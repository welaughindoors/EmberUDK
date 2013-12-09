class EmberPawn extends UTPawn;
//override to make player mesh visible by default

var SkeletalMeshComponent PlayerMeshComponent;
var AnimNodeSlot AnimSlot;
var bool SwordState;
var PlayerController customPlayerController;

//=============================================
// Tether System
//=============================================
var actor 				curTargetWall;
var vector 				wallHitLoc;
var ParticleSystemComponent 				tetherBeam;
var float 				tetherMaxLength;
var float				tetherlength;
var float deltaTimeBoostMultiplier;
var vector 				prevTetherSourcePos;

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

simulated private function DebugPrint(string sMessage)
{
    GetALocalPlayerController().ClientMessage(sMessage);
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

   EmberGameInfo(WorldInfo.Game).playerPawnWORLD = Self;
}

function detachTether() {
	
	curTargetWall = none;
	
	//beam
	if(tetherBeam != none){
		tetherBeam.SetHidden(true);
		tetherBeam.DeactivateSystem();
		tetherBeam = none;
	}
	
	
	SetPhysics(PHYS_Walking);

        //state
	 EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering = false;

	//make sure to restore normal pawn animation playing
	//see last section of tutorial
	//TetheringAnimOnly = false;
}

function createTether() {
	local vector hitLoc;
	local vector tVar;
	local vector hitNormal;
	local actor wall;
	local vector startTraceLoc;
	//~~~ Trace ~~~
	
	vc = normal(Vector( EmberGameInfo(WorldInfo.Game).playerControllerWORLD.Rotation)) * 10;
	//vc = Owner.Rotation;
	
	//pawn location + 100 in direction of player camera
	startTraceLoc = Location + vc ;
	 
	//trace only to tether's max length
	wall = Self.trace(hitLoc, hitNormal, 
				startTraceLoc + tetherMaxLength * vc, 
				startTraceLoc
			);


	if(!Wall.isa('Actor')) return;
	
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
	tetherlength = vsize(hitLoc - Location);
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
		ParticleSystem'RamaTetherBeam.tetherBeam', 
		Location + vect(0, 0, 32) + vc * 48, 
		// Location,
		rotator(HitNormal));

	tetherBeam.SetHidden(false);
	tetherBeam.ActivateSystem(true);
	
	//Beam Source Point
	Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', tVar, r);
	tetherBeam.SetVectorParameter('TetherSource', tVar);
	
	//Beam End
	tetherBeam.SetVectorParameter('TetherEnd', hitLoc);	
}

function startSprint()
{
	iLikeToSprint = true;
	tickToggle = true;
	GroundSpeed *= 2.6;
}

function endSprint()
{
	iLikeToSprint = false;
	GroundSpeed /= 2.6;
}
//these calcs run every tick while tether is active
//so the code is optimized to reduce
//variable memory allocation and deallocation
//I use global vars vc and vc2 as variables to store different
//info I need for my tether algorithm

//the other vars are also global since they are assigned values
//in other tether functions
//and their values should NOT be recalculated every tick

//~~~~~~~~~~~~~~~~~~~~~~~~~~
//Rama's Tether System Calcs
//~~~~~~~~~~~~~~~~~~~~~~~~~~
function tetherCalcs() {
	local int idunnowhatimdoing;
	//~~~~~~~~~~~~~~~~~
	//Beam Source Point
	//~~~~~~~~~~~~~~~~~
	//get position of source point on skeletal mesh

	//set this to be any socket you want or create your own socket
	//using skeletal mesh editor in UDK

	//dual weapon point is left hand 
	Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', vc, r);
	
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
		if(vsize(velocity) < 1300){
			velocity -= vc2 * 70;
		}
		}
		
		//not moving in direction of pawn
		//apply as much velocity as needed to prevent falling
		//allows sudden direction changes
		else {
			velocity -= vc2 * 70;
		}
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

Simulated Event Tick(float DeltaTime)
{
   	 Super.Tick(DeltaTime);
	
	//for fps issues and keeping things properly up to date
	//specially for skeletal controllers

	deltaTimeBoostMultiplier = deltatime * 40;
	
	//the value of 40 was acquired through my own hard work and testing,
	//this deltaTimeBoostMultiplier system is my own idea :)

	//=== TETHER ====
	//pc is ref to controller class
	if (EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering) {
		tetherCalcs();		//run calcs every tick tether is active
	}



	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//Prevents Sprint Boost In Air, Remove This Section If Boost Is Required
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	if(iLikeToSprint)
	{
		if(Physics == PHYS_Falling)
		{
			if(tickToggle)
			{
				GroundSpeed /= 2.6;
				tickToggle = !tickToggle;	
			}
		}
		else
		{
			if(!tickToggle)
			{
				GroundSpeed *= 2.6;
				tickToggle = !tickToggle;	
			}
		}
	}


	
}

function AddDefaultInventory()
{
    //Add the sword as default
    InvManager.DiscardInventory();
    InvManager.CreateInventory(class'Custom_Sword'); //InvManager is the pawn's InventoryManager
}


exec function SetSwordState(bool inHand)
{
    //setting our sword state.
    SwordState = inHand; 
}


function bool GetSwordState()
{
    //getting our sword state.
    return SwordState;   
}



simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    //Setting up a reference to our animtree to play custom stuff.
    super.PostInitAnimTree(SkelComp);
    if ( SkelComp == Mesh)
    {
        AnimSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
    }
}

// Simulated Event PostBeginPlay() {
// 	super.postbeginplay(); 
           
//            //set Self's worldinfo var
// 	//CustomGameInfo(WorldInfo.Game).hudWORLD = Self;
	
// 	//retrieve worldinfo var
// 	customPlayerController = EmberGameInfo(WorldInfo.Game).GetALocalPlayerController;
// }

exec function PlayAttack(name AnimationName, float AnimationSpeed)
{
    //The function we use to play our anims
    //Below goes, (anim name, anim speed, blend in time, blend out time, loop, override all anims)
    AnimSlot.PlayCustomAnim( AnimationName, AnimationSpeed, 0.00, 0.00, false, true);
}


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

//SK_ExportSword2

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;

   CamStart = Location;
   CurrentCamOffset = CamOffset;

   DesiredCameraZOffset = (Health > 0) ? 1.3 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
   CameraZOffset = (fDeltaTime < 0.2) ? DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset : DesiredCameraZOffset;
   
   if ( Health <= 0 )
   {
      CurrentCamOffset = vect(0,0,0);
      CurrentCamOffset.X = GetCollisionRadius();
   }

   CamStart.Z += CameraZOffset;
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
   CamDirX *= CurrentCameraScale;

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

   out_CamLoc = CamStart - CamDirX*CurrentCamOffset.X*1.9 + CurrentCamOffset.Y*CamDirY + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }

   return true;
}   

function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross)
{
	local float VelocityZ;

	if ( Physics == PHYS_Falling )
	{
		TakeFallingDamage();
	}

	bDodging = true;
	bReadyToDoubleJump = (JumpBootCharge > 0);
	VelocityZ = Velocity.Z;
	Velocity = DodgeSpeed*Dir + (Velocity Dot Cross)*Cross ;

	if ( VelocityZ < -200 )
		Velocity.Z = VelocityZ + DodgeSpeedZ;
	else
		Velocity.Z = DodgeSpeedZ;

//Edit here to control dodge distance
	Velocity.Z = 75;
	Velocity.X *= 4;
	Velocity.Y *= 4;

	CurrentDir = DoubleClickMove;
	SetPhysics(PHYS_Falling);
	SoundGroupClass.Static.PlayDodgeSound(self);
	return true;
}

defaultproperties
{
	SwordState = false
	tetherMaxLength = 4000
	MultiJumpBoost=922.0
}