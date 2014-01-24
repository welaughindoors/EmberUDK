/* Readme
/ -- 
/ -- Since this isn't a part of the pawn anymore, you can't use shit like
/ -- 'location', or 'velocity'
/ -- instead you'll need to reference them from pawn like so:
/ -- ePawn.location, ePawn.velocity
/ -- 
/ -- I wasn't able to create the beam via this class, so I had to make
/ -- a new function in the pawn to do so. therefore to update
/ -- the start and end points of the beam, use:
/ -- ePawn.updateBeamSource and ePawn.updateBeamEnd
/ -- 
/ -- DrawDebugLine can't be used here, so we'll reference it from ePawn
/ -- use ePawn.DrawDebugLine instead. same goes for trace
*/

class GloriousGrapple extends Object;

//=============================================
// Tether System
//=============================================
var actor 					curTargetWall;
var actor 					enemyPawn;
var bool 					enemyPawnToggle;
var vector 					wallHitLoc;
var ParticleSystemComponent tetherBeam2;
var float 					tetherMaxLength;
var float					tetherlength;
var float 					deltaTimeBoostMultiplier;
var vector 					prevTetherSourcePos;
var Vector 					tetherVelocity;
var bool 					tetherStatusForVel;
var Projectile				tetherProjectile;
var vector 					projectileHitVector;
var vector 					projectileHitLocation;

var float 					goingAwayVelModifier;
var float 					goingTowardsLowVelModifier;
var float 					goingTowardsHighVelModifier;
//these are optimization vars
//their values should never be relied on
//used to reduce variable memory allocation/deallocation
//this improves algorithm speed dramatically in my experience
var rotator r;
var vector vc;
var vector vc2;
var GameInfo EmberGameInfo;
var EmberPawn ePawn;
var EmberPlayerController ePC;



//These are the time related vars
var int 					ticCount;
var float 					timeFromStart;



//tether misc.
var rotator 				hitNormalRotator;


//=============================================
// Utility Functions
//=============================================
/*
DebugPrint
	Easy way to print out debug messages
	If wanting to print variables, use: DebugPrint("var :" $var);
*/
simulated private function DebugPrint(string sMessage)
{
    ePawn.DebugPrint(sMessage);
}

function masterTetherRace()
{



}

function runsPerTick(float deltaTime)
{
	timeFromStart+=deltaTime;
	ticCount++;
	//DebugPrint("hit -"@projectileHitLocation);
	//every tick this runs
	//Note: Tethercalcs also run per tick ONLY when tether's active though
	
}

function setInfo(Pawn p, PlayerController pc)
{
	ePawn = EmberPawn(p);
	ePC = EmberPlayerController(pc);
}

function tetherLocationHit(vector hit, vector lol, actor Other)
{
	projectileHitVector=hit;
	projectileHitLocation=lol;
	enemyPawn = Other;
	enemyPawnToggle = (enemyPawn != none) ? true : false;
	createTether();
}
function createTether() 
{
	local vector hitLoc;
	local vector headSocket;
	local vector grappleSocket;
	local vector hitNormal;
	local actor wall;
	local vector startTraceLoc;
	local vector endLoc;
	// local float floaty;
	local int isPawn;
	//~~~ Trace ~~~

	vc = normal(Vector(ePC.Rotation)) * 50;
	//vc = Owner.Rotation;
	
	ePawn.Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', headSocket, r);
	//pawn location + 100 in direction of player camera

	hitLoc = ePawn.location;
	hitLoc.z += 10;
	startTraceLoc = headSocket + vc ;
	// startTraceLoc = Location + vc ;
	 
	endLoc =startTraceLoc + tetherMaxLength * vc;
	// endLoc.z += 1500;

	//trace only to tether's max length
	wall = ePawn.trace(hitLoc, hitNormal, 
				endLoc, 
				startTraceLoc
			);
	// DrawDebugLine(endLoc, startTraceLoc, -1, 0, -1, true);


	// if(!Wall.isa('Actor')) return; //Change this later for grappling opponents
	// Wall.isa('Actor') ? DebugPrint("Actor : " $Wall) : ;
	// InStr(wall, "TestPawn") > 0? DebugPrint("gud") : ;
	isPawn = InStr(wall, "TestPawn");
	// DebugPrint("p = " $isPawn);
	// floaty = VSize(location - wall.location);
	// DebugPrint("distance -"@floaty);
	if(isPawn >= 0)
	{
		endLoc = normal(ePawn.location - wall.location);
		TestPawn(wall).grappleHooked(endLoc, ePawn);
		// endLoc *= 500;
		// wall.velocity = endLoc;
	}
	//~~~~~~~~~~~~~~~
	// Tether Success
	//~~~~~~~~~~~~~~~
	//Clear any old tether
	detachTether();
	

	enemyPawnToggle = enemyPawnToggle ? false : false;
	//state
	 ePC.isTethering = true;
	
	curTargetWall = Wall;
	//wallHitLoc = hitLoc;
	wallhitloc = projectileHitVector;
	
	//get length of tether from starting
	//position of object and wall
	// tetherlength = vsize(hitLoc - Location) * 0.75;
	// if (tetherlength > 1000) 
		// tetherlength = 1000;

	// tetherlength = vsize(hitLoc - ePawn.Location) * 0.75;
	// if (tetherlength > 500) 
		// tetherlength = 500;
	//~~~
	
	//~~~ Beam UPK Asset Download ~~~ 
	//I provide you with the beam resource to use here:
	//requires Nov 2012 UDK
	//Rama Tether Beam Package [Download] For You

	hitNormalRotator = rotator(HitNormal);
	ePawn.createTetherBeam(ePawn.Location + vect(0, 0, 32) + vc * 48, hitNormalRotator);


	//Beam Source Point
	ePawn.Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', grappleSocket, r);
	ePawn.updateBeamSource(grappleSocket);
	
	
	//Beam End
	//tetherBeam.SetVectorParameter('TetherEnd', hitLoc);	
	if(enemyPawn != none)
		ePawn.updateBeamEnd(TestPawn(enemyPawn).grappleSocketLocation);
	else
		ePawn.updateBeamEnd(projectileHitLocation);
	
}

function tetherCalcs() {
	local array<vector> startLocsArray;
	local array<vector> endLocsArray;
	local int idunnowhatimdoing;
	local actor wall;
	local vector hitLoc;
	local vector hitNormal;  //ignore this shit
	local vector endLoc;
	local vector startTraceLoc;
	local vector defaultCheck;

	//~~~~~~~~~~~~~~~~~
	//Beam Source Point
	//~~~~~~~~~~~~~~~~~
	//get position of source point on skeletal mesh

	//set this to be any socket you want or create your own socket
	//using skeletal mesh editor in UDK

	//dual weapon point is left hand 
	ePawn.Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', vc, r);
	ePawn.DrawDebugLine(vc, projectileHitLocation, -1, 0, -1, true);
    wall = ePawn.trace(hitLoc, hitNormal, vc, projectileHitLocation);
    DebugPrint("hitlog - "@hitLoc==defaultCheck);

	
    	    	// DrawDebugLine(vc, curTargetWall.Location, -1, 0, -1, true);
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//adjust for Skeletal Mesh Socket Rendered/Actual Location tick delay

	//there is a tick delay between the actual socket position
	//and the rendered socket position
	//I encountered this issue when working skeletal controllers
	//my solution is to just manually adjust the actual socket position
	//to match the screen rendered position
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//if falling, lower tether source faster
	if (vc.z - prevTetherSourcePos.z < 0) {
		vc.z -= 8 * deltaTimeBoostMultiplier;
	}
	
	//raising up, raise tether beam faster
	else {
		vc.z += 8 * deltaTimeBoostMultiplier;
	}
	
	//deltaTimeBoostMultipler neutralizes effects of 
	//fluctuating frame rate / time dilation

	//update beam based on on skeletal mesh socket
	if(hitLoc==defaultCheck)
	{
		ePawn.updateBeamSource(vc);
	}
	else
	{
		//work in progress
	}
	ePawn.Mesh.GetSocketWorldLocationAndRotation('GrappleSocket2', vc2, r);
	
	//save prev tick pos to see change in position
	prevTetherSourcePos = vc;
	

	if(enemyPawn != none)
	{
		//DebugPrint("tcalc - "@TestPawn(enemyPawn).grappleSocketLocation);
		ePawn.updateBeamEnd(TestPawn(enemyPawn).grappleSocketLocation);
	}
	
	//~~~~~~~~~~~~~~~~~~~
	//Actual Tether Constraint

	//I dont use a RB_Constraint
	//I control the allowed position
	//of the pawn through code
	//and use velocity adjustments every tick
	//to make it look fluid

	//setting PHYS_Falling + velocity adjustments every tick 
	//is what makes this work
	//and look really good with in-game physics
	//~~~~~~~~~~~~~~~~~~~
	
	//vector between player and tether loc
	//curTargetWall was given its value in createTether()
	vc = ePawn.Location - projectileHitLocation;
	
	//dist between pawn and tether location
	//see Vsize(vc) below (got rid of unnecessary var)
	
	idunnowhatimdoing = tetherlength * 0.4;
        //is the pawn moving beyond allowed current tether length?
        //if so apply corrective force to push pawn back within range

	if (Vsize(vc) > tetherlength - idunnowhatimdoing) {
		
                //determine whether to remove all standard pawn
	        //animations and just use the Victory animation
	        //I use this to make animations look smooth while my Tether System
                //is applying changes to pawn velocity (otherwise strange anims play)

                //this also results in pawn looking like it is actively initiating the
                //change in velocity through some Willful Action
               // TetheringAnimOnly = true;
		
                ePawn.SetPhysics(PHYS_Falling);
		
		//direction of tether = normal of distance between
		//pawn and tether attach point
		vc2 = normal(vc);
		
		//moving in same direction as tether?

		//absolute value of size difference between
		//normalized velocity and tether direction
		//if > 1 it means pawn is moving in same direction as tether
		if(abs(vsize(Normal(ePawn.velocity) - vc2)) > 1){
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//limit max velocity applied to pawn in direction of tether
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		//50 controls how much the pawn moves around while attached to tether
		//could turn into a variable and control for greater refinement of
		//this game mechanic

		//1200 is the max velocity the tether system is allowed to force the
		//pawn to move at, adjust to your preferences
		//could also be made into a variable
		// DebugPrint("v - " $velocity.z);
		// if(vsize(velocity) < 2500){
			// velocity -= vc2 * 300;
		// }
		if(Vsize(vc) > 1500)
		{
			ePawn.velocity -= vc2 * (Vsize(vc) * goingTowardsHighVelModifier);
		}
		else
		{
			ePawn.velocity -= vc2 * goingTowardsLowVelModifier;	
		}

		// DebugPrint("length"@Vsize(vc));
		}
		
		//not moving in direction of pawn
		//apply as much velocity as needed to prevent falling
		//allows sudden direction changes
		// else {
			// if(velocity.z > 1200) //Usually caused by gravity boost from jetpack
				// velocity -= vc2 * (95 * (Velocity.z * 0.4)) ;
			else
			{
				// DebugPrint("going away");
				ePawn.velocity -= vc2 * goingAwayVelModifier;
			}
		// }
		// if(tetherlength > 1000)
			// velocity -= vc2 * (tetherlength * 0.15);
		// if(location.z <= 75){
		// 	ll = location;
		// 	ll.z = 76;
		// 	ePC.SetLocation(ll);
		// 	// setLocation
		// 	// Velocity.z *= -2;
		// }
	}
	else {
		//allow all regular ut pawn animations
                //since player velocity is not being actively changed 
                //by Rama Tether System
                //TetheringAnimOnly = false;




	}
	/*
	//if the target point of tether is attached to moving object

	if (tetheredToMovingWall) {
		//beam end point
		tetherBeam.SetVectorParameter('TetherEnd', 					
		curTargetWall.Location);
	}
	*/
}

function detachTether() 
{
	curTargetWall = none;

	enemyPawn = enemyPawnToggle ? enemyPawn : none;

	//beam
	
	
	// SetPhysics(PHYS_Walking);
        //state
	 ePC.isTethering = false;
	 ePawn.deactivateTetherBeam();

	//make sure to restore normal pawn animation playing
	//see last section of tutorial
	//TetheringAnimOnly = false;
}

DefaultProperties
{
	
goingTowardsHighVelModifier = 0.03;
goingTowardsLowVelModifier = 30;
goingAwayVelModifier = 55;
}