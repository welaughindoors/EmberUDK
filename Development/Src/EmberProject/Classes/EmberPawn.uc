class EmberPawn extends UTPawn;
//override to make player mesh visible by default

var SkeletalMeshComponent PlayerMeshComponent;
var AnimNodeSlot AnimSlot;
var bool SwordState;
var PlayerController customPlayerController;
var() SkeletalMeshComponent SwordMesh;

//=============================================
// Tether System
//=============================================
var actor 					curTargetWall;
var vector 					wallHitLoc;
var ParticleSystemComponent tetherBeam;
var ParticleSystemComponent tetherBeam2;
var float 					tetherMaxLength;
var float					tetherlength;
var float 					deltaTimeBoostMultiplier;
var vector 					prevTetherSourcePos;
var Vector 					tetherVelocity;
var bool 					tetherStatusForVel;
//these are optimization vars
//their values should never be relied on
//used to reduce variable memory allocation/deallocation
//this improves algorithm speed dramatically in my experience
var rotator r;
var vector vc;
var vector vc2;

//=============================================
// Sprint System
//=============================================
var bool 			iLikeToSprint;
var bool 			tickToggle;
var float 			originalSpeed;


//=============================================
// Jump/JetPack System
//=============================================
var bool 						jumpActive;
var bool 						verticalJumpActive;
var ParticleSystemComponent 	jumpEffects;
var rotator 					jumpRotation;
var vector 						jumpLocation;
var float 						gravityAccel;

var float 						SlowDescentTimer;

var vector 						movementVector;
var bool 						startSpaceMarineLanding;


//=============================================
// Foot/Kick System
//=============================================
var vector botFoot, oldBotFoot, botLeg, oldBotLeg;
var int  kickCounter;


//=============================================
// General Animations
//=============================================
var AnimNodeBlendList IdleAnimNodeBlendList;
var bool idleBool;

//=============================================
// Attack Animations
//=============================================
var AnimNodePlayCustomAnim forwardAttack1;

//=============================================
// Weapon
//=============================================
var Sword Sword;
var bool  tracerRecordBool;
/*
===============================================
End Variables
===============================================
*/


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
    GetALocalPlayerController().ClientMessage(sMessage);
}

// Not Needed, found out that there's an official code that does the same, even has same name >.<
// function bool isTimerActive(name tName)
// {
// 	return GetTimerCount(tName) != -1 ? true : false;
// }

//=============================================
// Null Functions
//=============================================

//Disables Landed Function, probably doesn't need disable
event Landed(vector HitNormal, Actor FloorActor);
simulated function TakeFallingDamage();
//Disables double directional dodge. Uncomment to renable.
function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross)
{
// 	local float VelocityZ;

// 	if ( Physics == PHYS_Falling )
// 	{
// 		TakeFallingDamage();
// 	}

// 	bDodging = true;
// 	bReadyToDoubleJump = (JumpBootCharge > 0);
// 	VelocityZ = Velocity.Z;
// 	Velocity = DodgeSpeed*Dir + (Velocity Dot Cross)*Cross ;

// 	if ( VelocityZ < -200 )
// 		Velocity.Z = VelocityZ + DodgeSpeedZ;
// 	else
// 		Velocity.Z = DodgeSpeedZ;

// //Edit here to control dodge distance
// 	Velocity.Z = 75;
// 	Velocity.X *= 4;
// 	Velocity.Y *= 4;

// 	CurrentDir = DoubleClickMove;
// 	SetPhysics(PHYS_Falling);
// 	SoundGroupClass.Static.PlayDodgeSound(self);
// 	return true;
}

//=============================================
// System Functions
//=============================================


/*
PostBeginPlay
	The initial startup for the class
*/
simulated event PostBeginPlay()
{

	super.PostBeginPlay();

    //Add pawn to world info to be accessed from anywhere
   	EmberGameInfo(WorldInfo.Game).playerPawnWORLD = Self;

   	//1 second attach skele mesh
    SetTimer(0.5, false, 'WeaponAttach'); 



}

/*
WeaponAttach
	Attaches a skeleton mesh of the weapon in same place as weapon
	Used to detect collisions. atm WIP.
*/
function WeaponAttach()
{
           // DebugMessagePlayer("SocketName: " $ mesh.GetSocketByName( 'WeaponPoint' ) );
    // mesh.AttachComponentToSocket(SwordMesh, 'WeaponPoint');

        Sword = Spawn(class'Sword', self);
    //Sword.SetBase( actor NewBase, optional vector NewFloor, optional SkeletalMeshComponent SkelComp, optional name AttachName );
    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');
}

/*
Tick
	Every ~0.088s, this function is called.
*/
Simulated Event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);


	//for fps issues and keeping things properly up to date
	//specially for skeletal controllers

	deltaTimeBoostMultiplier = deltatime * 40;
	
	//the value of 40 was acquired through my own hard work and testing,
	//this deltaTimeBoostMultiplier system is my own idea :) - grapple

	//=== TETHER ====
	if (EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering) 
		{
			tetherVelocity = velocity;
			tetherCalcs();		//run calcs every tick tether is active
		}

	if(tetherStatusForVel)
		{
			if(Physics == PHYS_Falling)
				velocity = tetherVelocity;
			if(Physics == PHYS_Walking)
				tetherStatusForVel = false;
		}


	// TODO: Move all this to a function
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Prevents Sprint Boost In Air, Remove This Section If Boost Is Required
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	// if(iLikeToSprint)
	// {
	// // 	if(Physics == PHYS_Falling)
	// // 	{
	// // 		if(tickToggle)
	// // 		{
	// // 			// GroundSpeed /= 2.0;
	// // 			GroundSpeed = originalSpeed;
	// // 			tickToggle = !tickToggle;	
	// // 		}
	// // //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // // Holding shift while in air will lower negative z velocity = Shitty glide
	// // //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // 	// 	if(velocity.z <= 0)
	// // 	// 	{
	// // 	// 		// gravity = WorldInfo.GetGravityZ();
	// // 	// 		// gravity*= 0.2;
	// // 	// 	// velocity.z -= (velocity.z * 0.6);
	// // 	// 	velocity.z = -350;
	// // 	// 	// DebugPrint("going south" $velocity.z);
	// // 	// }
	// // 	}
	// // 	else
	// // 	{
	// // 		if(!tickToggle)
	// // 		{
	// // 			originalSpeed = GroundSpeed;
	// // 			GroundSpeed *= 2.0;
	// // 			tickToggle = !tickToggle;	
	// // 		}
	// // 	}

	// 	if(Physics == PHYS_Falling)
	// 	{
	// 		if(tickToggle)
	// 		{
	// 			GroundSpeed *= 0.3;
	// 			// GroundSpeed = originalSpeed;
	// 			tickToggle = !tickToggle;	
	// 		}
	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Holding shift while in air will lower negative z velocity = Shitty glide
	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// 	// 	if(velocity.z <= 0)
	// 	// 	{
	// 	// 		// gravity = WorldInfo.GetGravityZ();
	// 	// 		// gravity*= 0.2;
	// 	// 	// velocity.z -= (velocity.z * 0.6);
	// 	// 	velocity.z = -350;
	// 	// 	// DebugPrint("going south" $velocity.z);
	// 	// }
	// 	}
	// 	else
	// 	{
	// 		if(!tickToggle)
	// 		{
	// 			// originalSpeed = GroundSpeed;
	// 			GroundSpeed = originalSpeed;
	// 			tickToggle = !tickToggle;	
	// 		}
	// 	}
	// }

	// Probably not required
	bReadyToDoubleJump = true;

	if(jumpActive)
		SlowDescent(DeltaTime);

	if(startSpaceMarineLanding)
		spaceMarineLandingInAction(DeltaTime);

	// Probably can be removed
	// if(Physics == PHYS_Walking && jumpActive)
	// {
	// 	jumpActive = false;
	// 	jumpEffects.DeactivateSystem();
	// }

	animationControl();

}

/*
PostInitAnimTree
	Allows custom animations.
*/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    //Setting up a reference to our animtree to play custom stuff.
    super.PostInitAnimTree(SkelComp);
    if ( SkelComp == Mesh)
    {
        AnimSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
  		IdleAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('IdleAnimNodeBlendList'));
  		forwardAttack1 = AnimNodePlayCustomAnim(Mesh.FindAnimNode('AttackForward')); 
    }

}
//=============================================
// Overrided Functions
//=============================================


/*
BecomeViewTarget
	Required for modified Third Person
*/
simulated event BecomeViewTarget( PlayerController PC )
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
      UTPC = UTPlayerController(PC);
      if (UTPC != None)
      {
         //set player controller to behind view and make mesh visible
         UTPC.SetBehindView(true);
         SetMeshVisibility(UTPC.bBehindView);
      }
   }
}

/*
CalcCamera
	Required for modified Third Person
*/
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;

   CamStart = Location;
   CurrentCamOffset = CamOffset;

   //Change multipliers here
   DesiredCameraZOffset = (Health > 0) ? 1.5 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
   CameraZOffset = (fDeltaTime < 0.2) ? DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset : DesiredCameraZOffset;
   
   if ( Health <= 0 )
   {
      CurrentCamOffset = vect(0,0,0);
      CurrentCamOffset.X = GetCollisionRadius();
   }

   CamStart.Z += CameraZOffset;
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
   //Change multipliers here
   CamDirX *= CurrentCameraScale * 1.8;

   if ( (Health <= 0) || bFeigningDeath )
   {
      // adjust camera position to make sure it's not clipping into world
      // @todo fixmesteve.  Note that you can still get clipping if FindSpot fails (happens rarely)
      FindSpot(GetCollisionExtent(),CamStart);
   }
   if (CurrentCameraScale < CameraScale)
   {
      CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + 10 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
   }
   else if (CurrentCameraScale > CameraScale)
   {
      CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - 10 * FMax(CameraScale - CurrentCameraScale, 0.9)*fDeltaTime);
   }

   if (CamDirX.Z > GetCollisionHeight())
   {
      CamDirX *= square(cos(out_CamRot.Pitch * 0.0000958738)); // 0.0000958738 = 2*PI/65536
   }
   //Change multipliers here
   out_CamLoc = CamStart - CamDirX*CurrentCamOffset.X*1.9 + CurrentCamOffset.Y*CamDirY + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }

   return true;
}   

/*
DoDoubleJump
	Jetpack main function
*/
function DoDoubleJump( bool bUpdating )
{
	// if ( !bIsCrouched && !bWantsToCrouch )
	// {
		if(jumpActive)
		{
			spaceMarineLanding();
			return;
		}
		if(!bUpdating)
		{
			// disableJetPack();
			disableJumpEffect(true);
			return;
		}
		if(verticalJumpActive)
			return;
		if ( !IsLocallyControlled() || AIController(Controller) != None )
		{
			MultiJumpRemaining -= 1;
		}
		Velocity.Z = JumpZ + (MultiJumpBoost);
		verticalJumpActive = true;
		UTInventoryManager(InvManager).OwnerEvent('MultiJump');
		SetPhysics(PHYS_Falling);
		BaseEyeHeight = DoubleJumpEyeHeight;
		if (!bUpdating)
		{
			SoundGroupClass.Static.PlayDoubleJumpSound(self);
		}

	if(!jumpActive)
	{
	Mesh.GetSocketWorldLocationAndRotation('BackPack', jumpLocation, jumpRotation);
	// jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail', jumpLocation, jumpRotation, self); 
	// 	Mesh.AttachComponentToSocket(jumpEffects, 'BackPack');

	jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment (ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketTrail', Mesh, 'BackPack', true,  , jumpRotation);
	SetTimer(0.05, true, 'disableJumpEffect');
	// SetTimer(0.1, true, 'extendJump');
	}
	// }
}

//=============================================
// Custom Functions
//=============================================
exec function RecordTracers(name animation, float duration, float t1, float t2)
{
forwardAttack1.PlayCustomAnimByDuration(animation,duration, 0.2, 0, false);
	Sword.setTracerDelay(t1);
    Sword.GoToState('Attacking');
SetTimer(duration, false, 'forwardAttackEnd');
}
function forwardAttack()
{
	DebugPrint("start -");
forwardAttack1.PlayCustomAnimByDuration('ember_attack_forward',1.0, 0.2, 0, false);
SetTimer(1.0, false, 'forwardAttackEnd');

	Sword.setTracerDelay(0.65);
    Sword.GoToState('Attacking');
// forwardAttack1.StopCustomAnim(0);
}

function forwardAttackEnd()
{
	DebugPrint("dun -");

    Sword.SetInitialState();
    Sword.resetTracers();
    animationControl();
	// forwardAttack1.SetActiveChild(0);
}

function animationControl()
{
	if(Vsize(Velocity) == 0) 
	{ 
		//Idle
		if(idleBool == false)
		{
		idleBool = true;
		 if (IdleAnimNodeBlendList.BlendTimeToGo <= 0.f)
  			{
    			IdleAnimNodeBlendList.SetActiveChild(Rand(IdleAnimNodeBlendList.Children.Length), 0.25f);
  			}
  		}
	}
	else
		idleBool = false;
}
/*
increaseTether
*/
function increaseTether() 
{
	if (tetherlength > tetherMaxLength) return;
	tetherlength += 70;
}
/*
decreaseTether
*/
function decreaseTether() 
{
	if (tetherlength <= 300) {
		tetherlength = 300;
		return;
	}
	tetherlength -= 70;
}
/*
detachTether
*/
function detachTether() 
{
	curTargetWall = none;
	
	//beam
	if(tetherBeam != none){
		tetherBeam.SetHidden(true);
		tetherBeam.DeactivateSystem();
		tetherBeam = none;
	}
		if(tetherBeam2 != none){
		tetherBeam2.SetHidden(true);
		tetherBeam2.DeactivateSystem();
		tetherBeam2 = none;
	}
	
	// SetPhysics(PHYS_Walking);
        //state
	 EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering = false;

	//make sure to restore normal pawn animation playing
	//see last section of tutorial
	//TetheringAnimOnly = false;
}

/*
createTether
	How it works:
		Starts trace a little infront of character, to target point
		If the target point is an actor, cancel function //TODO: player grappling
		else, clear old tethers and prepare for tethering
		Save wall actor and wall hit location
		Create tether length
		Create tether particle
		Set particle start and end points
*/
function createTether() 
{
	local vector hitLoc;
	local vector tVar;
	local vector hitNormal;
	local actor wall;
	local vector startTraceLoc;
	local vector endLoc;
	local float floaty;
	local int isPawn;
	//~~~ Trace ~~~

	vc = normal(Vector( EmberGameInfo(WorldInfo.Game).playerControllerWORLD.Rotation)) * 50;
	//vc = Owner.Rotation;
	
	Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', tVar, r);
	//pawn location + 100 in direction of player camera

	hitLoc = location;
	hitLoc.z += 10;
	startTraceLoc = tVar + vc ;
	// startTraceLoc = Location + vc ;
	 
	endLoc =startTraceLoc + tetherMaxLength * vc;
	// endLoc.z += 1500;

	//trace only to tether's max length
	wall = Self.trace(hitLoc, hitNormal, 
				endLoc, 
				startTraceLoc
			);
	// DrawDebugLine(endLoc, startTraceLoc, -1, 0, -1, true);


	// if(!Wall.isa('Actor')) return; //Change this later for grappling opponents
	// Wall.isa('Actor') ? DebugPrint("Actor : " $Wall) : ;
	// InStr(wall, "TestPawn") > 0? DebugPrint("gud") : ;
	isPawn = InStr(wall, "TestPawn");
	DebugPrint("p = " $isPawn);
	floaty = VSize(location - wall.location);
	DebugPrint("distance -"@floaty);
	if(isPawn >= 0)
	{
		endLoc = normal(location - wall.location);
		TestPawn(wall).grappleHooked(endLoc, self);
		// endLoc *= 500;
		// wall.velocity = endLoc;
	}
	//~~~~~~~~~~~~~~~
	// Tether Success
	//~~~~~~~~~~~~~~~
	//Clear any old tether
	detachTether();
	
	//state
	 EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering = true;
	
	curTargetWall = Wall;
	wallHitLoc = hitLoc;
	
	//get length of tether from starting
	//position of object and wall
	// tetherlength = vsize(hitLoc - Location) * 0.75;
	// if (tetherlength > 1000) 
		// tetherlength = 1000;

	tetherlength = vsize(hitLoc - Location) * 0.75;
	if (tetherlength > 500) 
		tetherlength = 500;
	//~~~
	
	//~~~ Beam UPK Asset Download ~~~ 
	//I provide you with the beam resource to use here:
	//requires Nov 2012 UDK
	//Rama Tether Beam Package [Download] For You
	tetherBeam = WorldInfo.MyEmitterPool.SpawnEmitter(

		//change name to match your imported version 
		//of my package download above
		//In UDK: select asset and right click “copy full path”
		//paste below
		ParticleSystem'RamaTetherBeam.tetherBeam2', //Visual System
		Location + vect(0, 0, 32) + vc * 48, 
		// Location,
		rotator(HitNormal));

	tetherBeam2 = WorldInfo.MyEmitterPool.SpawnEmitter(

		//change name to match your imported version 
		//of my package download above
		//In UDK: select asset and right click “copy full path”
		//paste below
		ParticleSystem'RamaTetherBeam.tetherBeam2', //Visual System
		Location + vect(0, 0, 32) + vc * 48, 
		// Location,
		rotator(HitNormal));

	tetherBeam.SetHidden(false);
	tetherBeam.ActivateSystem(true);
	
	//Beam Source Point
	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', tVar, r);
	tetherBeam.SetVectorParameter('TetherSource', tVar);
	
	//Beam End
	tetherBeam.SetVectorParameter('TetherEnd', hitLoc);	


	tetherBeam2.SetHidden(false);
	tetherBeam2.ActivateSystem(true);
	
	//Beam Source Point
	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket2', tVar, r);
	tetherBeam2.SetVectorParameter('TetherSource', tVar);
	
	//Beam End
	tetherBeam2.SetVectorParameter('TetherEnd', hitLoc);	
}

/*
startSprint
	Saves original ground speed, and modifies it
	Also modifies current velocity to do instant transition
*/
// function startSprint()
// {
// 	iLikeToSprint = true;
// 	tickToggle = true;
// 	originalSpeed = GroundSpeed;
// 	//Sprint Speed
// 	//GroundSpeed *= 2.0;
// 	GroundSpeed *= 0.3;

// 	//Does instant transition to max sprint speed
// 	if(Physics != PHYS_Falling)
// 		// velocity *= 2.0;
// 		velocity *= 0.3;
// }

// /*
// endSprint
// */
// function endSprint()
// {
// 	iLikeToSprint = false;
// 	// GroundSpeed /= 2.0;
// 	GroundSpeed = originalSpeed;
// }

//~~~~~~~~~~~~~~~~~~~~~~~~~~
//Rama's Tether System Calcs
//~~~~~~~~~~~~~~~~~~~~~~~~~~

//these calcs run every tick while tether is active
//so the code is optimized to reduce
//variable memory allocation and deallocation
//I use global vars vc and vc2 as variables to store different
//info I need for my tether algorithm

//the other vars are also global since they are assigned values
//in other tether functions
//and their values should NOT be recalculated every tick

function tetherCalcs() {
	local int idunnowhatimdoing;
	//~~~~~~~~~~~~~~~~~
	//Beam Source Point
	//~~~~~~~~~~~~~~~~~
	//get position of source point on skeletal mesh

	//set this to be any socket you want or create your own socket
	//using skeletal mesh editor in UDK

	//dual weapon point is left hand 
	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', vc, r);
	
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
	tetherBeam.SetVectorParameter('TetherSource', vc);
	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket2', vc2, r);
	tetherBeam2.SetVectorParameter('TetherSource', vc2);
	
	//save prev tick pos to see change in position
	prevTetherSourcePos = vc;
	
	
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
	vc = Location - curTargetWall.Location;
	
	//dist between pawn and tether location
	//see Vsize(vc) below (got rid of unnecessary var)
	
	idunnowhatimdoing = tetherlength * 0.2;
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
		
                SetPhysics(PHYS_Falling);
		
		//direction of tether = normal of distance between
		//pawn and tether attach point
		vc2 = normal(vc);
		
		//moving in same direction as tether?

		//absolute value of size difference between
		//normalized velocity and tether direction
		//if > 1 it means pawn is moving in same direction as tether
		if(abs(vsize(Normal(velocity) - vc2)) > 1){
		
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
		if(vsize(velocity) < 2500){
			velocity -= vc2 * 95;
		}
		}
		
		//not moving in direction of pawn
		//apply as much velocity as needed to prevent falling
		//allows sudden direction changes
		else {
			if(velocity.z > 1200) //Usually caused by gravity boost from jetpack
				velocity -= vc2 * (95 * (Velocity.z * 0.4));
			else
				velocity -= vc2 * 95;
		}
		if(tetherlength > 1000)
			velocity -= vc2 * (tetherlength * 0.15);
		// if(location.z <= 75){
		// 	ll = location;
		// 	ll.z = 76;
		// 	EmberGameInfo(WorldInfo.Game).playerControllerWORLD.SetLocation(ll);
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

/*
AddDefaultInventory
	Not sure if required as it might've been done somewhere else
*/
function AddDefaultInventory()
{
    //Add the sword as default
    InvManager.DiscardInventory();
    InvManager.CreateInventory(class'Custom_Sword'); //InvManager is the pawn's InventoryManager
}
/*
SetSwordState
	true = hand, false = nowhere
*/
exec function SetSwordState(bool inHand)
{
    //setting our sword state.
    SwordState = inHand; 
}
/*
GetSwordState
*/
function bool GetSwordState()
{
    //getting our sword state.
    return SwordState;   
}
/*
PlayAttack
	Play animation at speed
*/
exec function PlayAttack(name AnimationName, float AnimationSpeed)
{
    //The function we use to play our anims
    //Below goes, (anim name, anim speed, blend in time, blend out time, loop, override all anims)
    AnimSlot.PlayCustomAnim( AnimationName, AnimationSpeed, 0.00, 0.00, false, true);
}

/*
disableJetPack
*/
function disableJetPack()
{
		ClearTimer('extendJump');
		jumpActive = false;
}

/*
extendJump
	No longer used. Pending deletion.
*/
function extendJump()
{
	// DoDoubleJump(true);
}

/*
disableJumpEffect
	When approaching point of incidence on verticle velocity, disable jetpack thrust effect
*/
function disableJumpEffect(bool force = false)
{
	if(velocity.z < 50 )
	{
		jumpEffects.DeactivateSystem();
		ClearTimer('disableJumpEffect');
		SlowDescentTimer = 0;
		jumpActive = true;
		verticalJumpActive = false;
		// SlowDescent();
	}
}
/*
SlowDescent
	SpaceMarine like jetpack
		For about 0.5s (seems like 0.75 in game), a slowed descent after point of incidence on verticle velocity
			This allows for precision aiming for next grapple
		Afterwords, until a tetherbeam is created or ground is hit, player speeds up till hits ground
*/
function SlowDescent(float fDeltaTime)
{
	if(tetherBeam != none)
	{
		jumpActive = false;
		return;
	}
	SlowDescentTimer += fDeltaTime;
		
	 	gravityAccel = GetGravityZ();
        // Scale acceleration to velocity
      gravityAccel *= 2.0;
        // addedGravity as a percent of Pawn.GetGravityZ(), 1.0 adds 1 full G of acceleration, 2.0 adds 2 full G's of acceleration, etc, etc, 0.0 adds no acceleration
      if(SlowDescentTimer < 0.5)
      {
      gravityAccel *= 0.45;
      Velocity.Z -= gravityAccel * fDeltaTime;
  		}
  		else
  		{
      	gravityAccel *= 0.47;
      	Velocity.Z += gravityAccel * fDeltaTime;
  		}
  		if(physics == PHYS_Walking)
  			jumpActive = false;
}

/*
spaceMarineLanding
	Pressing space again during descent will launch player downwards to location.
	Probably need fix on spacebar, make it do something else or something
*/
function spaceMarineLanding()
{
   	local vector HitLocation, HitNormal, landingLocation, vPlayer, startTraceLoc;
	local actor wall;

	vPlayer = normal(Vector( EmberGameInfo(WorldInfo.Game).playerControllerWORLD.Rotation)) * 10;
	
	//pawn location + 100 in direction of player camera
	startTraceLoc = Location + vPlayer ;
	 
	//trace only to tether's max length. TODO: Set max limit for landing
	wall = Self.trace(HitLocation, hitNormal, 
				startTraceLoc + tetherMaxLength * vPlayer, 
				startTraceLoc
			);

	//Make landing location a little further from actual hit location, due to gravity pushing down.
	//TODO: Fix this cause it's still off
	landingLocation = location - (HitLocation * 1.2);
	//Get Unit Vector pointing towards landing site
	movementVector = normal(landingLocation);
	//Says we're ready to land
	startSpaceMarineLanding = true;
}

/*
spaceMarineLandingInAction
	Plays during tick
	Launches player towards landing location * 150 units
	Stops when hitting ground
		TODO: If aiming up, it'll launch player and never lands, launching you to the moon.
*/
function spaceMarineLandingInAction(float fDeltaTime)
{
	if(physics == PHYS_Walking)
	{
		startSpaceMarineLanding = false;
		return;
	}
	// vc = Location - curTargetWall.Location;
	
                SetPhysics(PHYS_Falling);
			velocity -= movementVector * 150;
		
}
/*
DoKick
	Does a tracer for ~ 2.5 seconds from left foot to left knee
*/
function DoKick()
{
	kickCounter++;
	if(kickCounter < 20)
		SetTimer(0.1, false, 'DoKick');

		mesh.GetSocketWorldLocationAndRotation('L_JB', botFoot); 
		mesh.GetSocketWorldLocationAndRotation('L_Knee', botLeg); 

			// if(oldBotLeg == vect(0,0,0))
	  //       	DrawDebugLine(botFoot, oldBotFoot, -1, 0, -1, true);
   //      	else
   //  	    	DrawDebugLine(botLeg, oldBotLeg, -1, 0, -1, true);

    	    	DrawDebugLine(botLeg, botFoot, -1, 0, -1, true);
}
defaultproperties
{

	bCanStrafe=false
	SwordState = false
	tetherStatusForVel = false
	tetherMaxLength = 4000
	MultiJumpBoost=1622.0
	CustomGravityScaling = 1.6

	// Begin Object Class=SkeletalMeshComponent Name=SwordMesh
 //        SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
 //         // bForceUpdateAttachmentsInTick=True
 //         Scale=2
 //    End Object
 //    Components.Add(SwordMesh)

    Begin Object Class=SkeletalMeshComponent Name=MyWeaponSkeletalMesh
    CastShadow=true
    bCastDynamicShadow=true
    bOwnerNoSee=false
    // LightEnvironment=MyLightEnvironment;
        SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
    Scale=0.5
Rotation=(Pitch=0 ,Yaw=0, Roll=49152 )
  End Object
  SwordMesh=MyWeaponSkeletalMesh
}