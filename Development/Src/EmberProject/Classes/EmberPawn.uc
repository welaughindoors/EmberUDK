
//=============================================
// Important Tags
//=============================================
//temp_fix_for_animation
// -- Temporary fix until animation is corrected
//TODO:
// -- Shit TODO

class EmberPawn extends UTPawn;

//=============================================
// Combo / Attack System Vars
//=============================================

var name lightLeftString1;
var array<float>lightLeftString1Mods;
var name lightRightString1;
var array<float>lightRightString1Mods;
var name lightForwardString1;
var array<float>lightForwardString1Mods;
var name lightForwardLeftString1;
var array<float>lightForwardLeftString1Mods;
var name lightForwardRightString1;
var array<float>lightForwardRightString1Mods;

var name mediumLeftString1;
var array<float>mediumLeftString1Mods;
var name mediumRightString1;
var array<float>mediumRightString1Mods;
var name mediumForwardString1;
var array<float>mediumForwardString1Mods;
var name mediumForwardLeftString1;
var array<float>mediumForwardLeftString1Mods;
var name mediumForwardRightString1;
var array<float>mediumForwardRightString1Mods;

var name heavyLeftString1;
var array<float>heavyLeftString1Mods;
var name heavyRightString1;
var array<float>heavyRightString1Mods;
var name heavyForwardString1;
var array<float>heavyForwardString1Mods;
var name heavyForwardLeftString1;
var array<float>heavyForwardLeftString1Mods;
var name heavyForwardRightString1;
var array<float>heavyForwardRightString1Mods;

// var SkeletalMeshComponent PlayerMeshComponent;
var decoSword LightDecoSword;
var decoSword MediumDecoSword;
var decoSword HeavyDecoSword;
var AnimNodeSlot AnimSlot;
var bool SwordState;
var PlayerController customPlayerController;
// var() SkeletalMeshComponent SwordMesh;
var SkeletalMesh swordMesh;
var vector cameraOutLoc;
//=============================================
// Tether System
//=============================================
var actor 					curTargetWall;
var actor 					enemyPawn;
var bool 					enemyPawnToggle;
var vector 					wallHitLoc;
var ParticleSystemComponent tetherBeam;
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

var float 						JumpVelocityPinchTimer;

var vector 						movementVector;
var bool 						startSpaceMarineLanding;

var float 						JumpVelocityPinch_LandedTimer;


//=============================================
// Foot/Kick System
//=============================================
var vector botFoot, oldBotFoot, botLeg, oldBotLeg;
var int  kickCounter;


//=============================================
// General Animations
//=============================================
var AnimNodeBlendList 	IdleAnimNodeBlendList;
var AnimNodeBlendList 	RunAnimNodeBlendList;
var AnimNodeBlendList 	LeftStrafeAnimNodeBlendList;
var AnimNodeBlendList 	RightStrafeAnimNodeBlendList;
var AnimNodeBlendList 	WalkAnimNodeBlendList;
var AnimNodeBlendList 	wLeftStrafeAnimNodeBlendList;
var AnimNodeBlendList 	wRightStrafeAnimNodeBlendList;
var AnimNodeBlendList 	FullBodyBlendList;
var int  				currentStance;
var bool 				idleBool, runBool;
var float 				idleBlendTime, runBlendTime;

//=============================================
// Attack Animations
//=============================================
var AnimNodeBlendList AttackGateNode;
var AnimNodeBlendList AttackBlendNode;
var AnimNodePlayCustomAnim Attack1;
var AnimNodePlayCustomAnim Attack2;
var UDKSkelControl_Rotate SpineRotator;

// var float 				animationQueueAndDirection;
var array<byte> savedByteDirection;
//
//=============================================
// Weapon
//=============================================
var Sword Sword;
var bool  tracerRecordBool;
// var bool swordBlockIsActive; //temp_fix_for_animation
//=============================================
// Camera
//=============================================
// var float width;
// var float height;
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

goingTowardsHighVelModifier = 0.03;
goingTowardsLowVelModifier = 30;
goingAwayVelModifier = 55;

//Temp delete m

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
        LightDecoSword = Spawn(class'decoSword', self);
        MediumDecoSword = Spawn(class'decoSword', self);
        HeavyDecoSword = Spawn(class'decoSword', self);
        LightDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.gladius');
        MediumDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2');
        HeavyDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.flammard');
    //Sword.SetBase( actor NewBase, optional vector NewFloor, optional SkeletalMeshComponent SkelComp, optional name AttachName );
    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');
     // LightAttachComponent.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.gladius');
 // MediumAttachComponent.SetSkeletalMesh(SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2');
 // HeavyAttachComponent.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.flammard');
 
    Mesh.AttachComponentToSocket(LightDecoSword.Mesh, 'LightAttach');
    Mesh.AttachComponentToSocket(MediumDecoSword.Mesh, 'BalanceAttach');
    Mesh.AttachComponentToSocket(HeavyDecoSword.Mesh, 'HeavyAttach');
    LightDecoSword.Mesh.SetHidden(true);
    MediumDecoSword.Mesh.SetHidden(false);
    HeavyDecoSword.Mesh.SetHidden(false);
    	// Sword.Mesh.GetSocketWorldLocationAndRotation('StartControl', jumpLocation, jumpRotation);
    	// jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue', vect(0,0,0), vect(0,0,0), self); 
    	// WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue', Sword.Mesh, 'EndControl', true, , );
		// Sword.Mesh.AttachComponentToSocket(jumpEffects, 'StartControl');
		// jumpEffects.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue');
		// jumpEffects.ActivateSystem(true);
//TODO:readd
		// setTrailEffects();
}
function setTrailEffects()
{ 
//Declare a new Emitter
local UTEmitter SwordEmitter;      
local vector Loc;
local rotator Roter;    
 
//Lets Get the Intial Location Rotation
Sword.Mesh.GetSocketWorldLocationAndRotation('EndControl', Loc, Roter);
 
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, Loc, Roter);
 
//Set it to the Socket
SwordEmitter.SetBase(self,, Sword.Mesh, 'EndControl');
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'VH_Manta.Effects.PS_Manta_Projectile', false); 
 
//Never End
SwordEmitter.LifeSpan = 0;
}
/* 
Tick
	Every ~0.088s, this function is called.
*/
Simulated Event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// DebugPrint(""@width);

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
	// bReadyToDoubleJump = true;
 
	// if(jumpActive)
		JumpVelocityPinch(DeltaTime);


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
  		RunAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('RunAnimNodeBlendList'));
  		LeftStrafeAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('LeftStrafeAnimNodeBlendList'));
  		RightStrafeAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('RightStrafeAnimNodeBlendList'));  		
		WalkAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('WalkAnimNodeBlendList'));  		
		wLeftStrafeAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('wLeftStrafeAnimNodeBlendList'));  		
		wRightStrafeAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('wRightStrafeAnimNodeBlendList'));  
		FullBodyBlendList = AnimNodeBlendList(Mesh.FindAnimNode('FullBodyBlendList'));  		
  		Attack1 = AnimNodePlayCustomAnim(Mesh.FindAnimNode('CustomAttack'));
  		SpineRotator = UDKSkelControl_Rotate( mesh.FindSkelControl('SpineRotator') );
  		SpineRotator.BoneRotationSpace=BCS_BoneSpace;
  		// AimNode = AnimNodeAimOffset(SkelComp.FindAnimNode('AimNode'));
  		// Attack2 = AnimNodePlayCustomAnim(Mesh.FindAnimNode('CustomAttack2'));

  		// AttackGateNode = AnimNodeBlendList(Mesh.FindAnimNode('AttackGateNode'));
		// AttackBlendNode = AnimNodeBlendList(Mesh.FindAnimNode('AttackBlendNode'));
    }

}
//=============================================
// Overrided Functions
//=============================================
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	DebugPrint("hit");
}

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
   DesiredCameraZOffset = (Health > 0) ? 1.25 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
   CameraZOffset = (fDeltaTime < 0.2) ? DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset : DesiredCameraZOffset;
   
   if ( Health <= 0 )
   {
      CurrentCamOffset = vect(0,0,0);
      CurrentCamOffset.X = GetCollisionRadius();
   }

   CamStart.Z += CameraZOffset;
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
   //Change multipliers here
   CamDirX *= CurrentCameraScale * 2.8;

   if ( (Health <= 0) || bFeigningDeath )
   {
      // adjust camera position to make sure it's not clipping into world
      // @todo fixmesteve.  Note that you can still get clipping if FindSpot fails (happens rarely)
      FindSpot(GetCollisionExtent(),CamStart);
   }
   if (CurrentCameraScale < CameraScale)
   {
      CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + 10 * FMax(CameraScale - CurrentCameraScale, 0.5)*fDeltaTime);
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
   out_CamLoc = CamStart - CamDirX*CurrentCamOffset.X*2.9 + CurrentCamOffset.Y*CamDirY*0.1 + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }
      cameraOutLoc = out_CamLoc;

   return true;
}   
// function getScreenWH(float nwidth, float nheight)
// {
// 	width = nwidth;
// 	height = nheight;
// }
/*
DoDoubleJump
	Jetpack main function
*/
// function DoDoubleJump( bool bUpdating )
// {
// 	// if ( !bIsCrouched && !bWantsToCrouch )
// 	// {
// 		if(jumpActive)
// 		{
// 			spaceMarineLanding();
// 			return;
// 		}
// 		if(!bUpdating)
// 		{
// 			// disableJetPack();
// 			disableJumpEffect(true);
// 			return;
// 		}
// 		if(verticalJumpActive)
// 			return;
// 		if ( !IsLocallyControlled() || AIController(Controller) != None )
// 		{
// 			MultiJumpRemaining -= 1;
// 		}
// 		Velocity.Z = JumpZ + (MultiJumpBoost);
// 		verticalJumpActive = true;
// 		UTInventoryManager(InvManager).OwnerEvent('MultiJump');
// 		SetPhysics(PHYS_Falling);
// 		BaseEyeHeight = DoubleJumpEyeHeight;
// 		if (!bUpdating)
// 		{
// 			SoundGroupClass.Static.PlayDoubleJumpSound(self);
// 		}

// 	if(!jumpActive)
// 	{

// 	Mesh.GetSocketWorldLocationAndRotation('BackPack', jumpLocation, jumpRotation);
// 	// jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail', jumpLocation, jumpRotation, self); 
// 	// 	Mesh.AttachComponentToSocket(jumpEffects, 'BackPack');

// 	jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment (ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketTrail', Mesh, 'BackPack', true,  , jumpRotation);
// 	SetTimer(0.05, true, 'disableJumpEffect');
// 	// SetTimer(0.1, true, 'extendJump');
// 	}
// 	// }
// }
//=============================================
// Debug Functions
//=============================================

/*
RecordTracers - Debug Function
	Plays an animation showing tracers.
	Can change duration that tracers start and end
	@TODO: Tracers end record
	@TODO: Auto save to a script file perhaps?
*/
exec function RecordTracers(name animation, float duration, float t1, float t2)
{
	EmberGameInfo(WorldInfo.Game).playerControllerWORLD.RecordTracers(animation, duration, duration*t1, duration*t2);
}

/*
tethermod - Debug Function
	Used to modify grapple at runtime
	Usage:
		'tethermod 0 0 0'
			Outputs current tether values
		'tethermod X 0 0'
			Changes goingTowardsHighVelModifier modifier
		'tethermod 0 X 0'
			Changes goingTowardsLowVelModifier modifier
		'tethermod 0 0 X'
			Changes goingAwayVelModifier modifier
	Can change multiple modifiers at the same time
*/
exec function tethermod(float a, float b, float c)
{
	if(a == 0 && b == 0 && c == 0)
	{
		DebugPrint ("goingTowardsHigh -"@goingTowardsHighVelModifier);
		DebugPrint(", goingTowardsLow -"@goingTowardsLowVelModifier);
		DebugPrint(", goingAway -"@goingAwayVelModifier);
		return;
	}
	goingTowardsHighVelModifier = (a != 0) ? a : goingTowardsHighVelModifier;
	goingTowardsLowVelModifier = (b != 0) ? b : goingTowardsLowVelModifier;
	goingAwayVelModifier = (c != 0) ? c : goingAwayVelModifier;
}

	// b != 0 ? goingTowardsLowVelModifier = b : ;
	// c != 0 ? goingAwayVelModifier = c : ;
//=============================================
// Custom Functions
//=============================================
/*
doBlock
	goes to a block state
*/
function doBlock()
{
	Attack1.PlayCustomAnim('ember_jerkoff_block',1.0, 0.3, 0, true);
	Sword.GoToState('Blocking');

		// Sword.rotate(0,0,49152); //temp_fix_for_animation
		// swordBlockIsActive = true;//temp_fix_for_animation
}/*
cancelBlock
	Cancels loop anim
	Goes to idle anim
*/
function cancelBlock()
{
	Attack1.PlayCustomAnimByDuration('ember_jerkoff_block',0.1, 0.5, 0, false);
    Sword.SetInitialState();
    // swordBlockIsActive = false;//temp_fix_for_animation
	// Sword.rotate(0,0,16384); //temp_fix_for_animation

	// Attack1.PlayCustomAnim('ember_jerkoff_block',-1.0, 0.3, 0, false);
}
/*
GetTimeLeftOnAttack
	Returns time left on attack timer
*/
function float GetTimeLeftOnAttack()
{
	 return (GetTimerRate('AttackEnd') - GetTimerCount('AttackEnd'));
}
/*
doAttack
	Detects if player is moving left or right from playercontroler (PlayerInput)
	Determines which attack to use.
	Queues Attacks
*/
// function doAttack( float strafeDirection)
// {
// 	local float timerCounter;
// 	local float queueCounter;
// // 	local vector jumpLocation;
// // 	local rotator jumpRotation;

// // 	Mesh.GetSocketWorldLocationAndRotation('BackPack', jumpLocation, jumpRotation);

// // 	DebugPrint("l - "@Rotation - jumpRotation);
// // 	DebugPrint("l - "@jumpRotation - Rotation);
// // return;
// 	queueCounter = 0.25;

// 	timerCounter = GetTimeLeftOnAttack();
// 	DebugPrint("attack Requested");
// 	if(timerCounter > queueCounter)
// 	{
// 	DebugPrint("attack Denied");
// 	return;
// 	}
// 	if(timerCounter < queueCounter && timerCounter > 0)
// 	{
// 	DebugPrint("attack Queued");
// 	animationQueueAndDirection = (strafeDirection == 0) ? 1337.0 : strafeDirection;
// 	// animationQueueAndDirection = strafeDirection;
// 	return;
// 	}
// 	if(strafeDirection > 0)
// 		rightAttack();
// 	else if(strafeDirection < 0)
// 		leftAttack();
// 	else
// 		forwardAttack();
// }
function doAttack( array<byte> byteDirection)
{
	local float timerCounter;
	local float queueCounter;
	local int totalKeyFlag;

	totalKeyFlag = 0;
	savedByteDirection[0] = byteDirection[0];
	savedByteDirection[1] = byteDirection[1];
	savedByteDirection[2] = byteDirection[2];
	savedByteDirection[3] = byteDirection[3];

	
	if((savedByteDirection[0] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[1] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[2] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[3] ^ 1) == 0 ) totalKeyFlag++;

	queueCounter = 0.25;

	timerCounter = GetTimeLeftOnAttack();
	DebugPrint("attack Requested");

	if(timerCounter > queueCounter)
		{
		DebugPrint("attack Denied");
		return;
		}

	if(timerCounter < queueCounter && timerCounter > 0)
		{
		DebugPrint("attack Queued");
		savedByteDirection[4] = 1;
		return;
		}

		switch(totalKeyFlag)
		{
			//no keys pressed
			case 0:
				forwardAttack();
			break;

			//one key pressed 
			case 1:
				if((savedByteDirection[0] ^ 1) == 0 ) forwardAttack(); //W
				if((savedByteDirection[1] ^ 1) == 0 ) leftAttack(); //A
				if((savedByteDirection[2] ^ 1) == 0 ) forwardAttack(); //S
				if((savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //D
			break;

			//two keys pressed 
			case 2:
				if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) forwardLeftAttack(); //W+A
				else if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) forwardRightAttack(); //W+D
				else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) forwardLeftAttack(); //S+A
				else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) forwardRightAttack(); //S+D

				// if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) leftAttack(); //W+A
				// else if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //W+D
				// else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) leftAttack(); //S+A
				// else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //S+D

				//for keys W + S and A + D
				else forwardAttack();

			break;

			//3-4 keys pressed
			case 3:
			case 4:
				forwardAttack();
			break;
		}

}
exec function setTracers(int tracers)
{
	Sword.setTracers(tracers);
}

// function rightAttackEnd()
// {
// 	DebugPrint("dun -");
// 	//forwardAttack1.StopCustomAnim(0);
//     Sword.SetInitialState();
//     Sword.resetTracers();
//     animationControl();
// }
function forwardLeftAttack()
{
		switch(currentStance)
	{
		case 1:
			Sword.setTracerDelay(lightForwardLeftString1Mods[1],lightForwardLeftString1Mods[2]);
			SetTimer(lightForwardLeftString1Mods[0], false, 'AttackEnd');			
			Attack1.PlayCustomAnimByDuration(lightForwardLeftString1,lightForwardLeftString1Mods[0], 0.5, 0, false);
		break;

		case 2:
			Sword.setTracerDelay(mediumForwardLeftString1Mods[1],mediumForwardLeftString1Mods[2]);
			SetTimer(mediumForwardLeftString1Mods[0], false, 'AttackEnd');	
			Attack1.PlayCustomAnimByDuration(mediumForwardLeftString1,mediumForwardLeftString1Mods[0], 0.5, 0, false);
		break;

		case 3:
			Sword.setTracerDelay(heavyForwardLeftString1Mods[1],heavyForwardLeftString1Mods[2]);
			SetTimer(heavyForwardLeftString1Mods[0], false, 'AttackEnd');	
			Attack1.PlayCustomAnimByDuration(heavyForwardLeftString1,heavyForwardLeftString1Mods[0], 0.5, 0, false);
		break;
	}

    Sword.GoToState('Attacking');
}
function forwardRightAttack()
{
		switch(currentStance)
	{
		case 1:
			Sword.setTracerDelay(lightForwardRightString1Mods[1],lightForwardRightString1Mods[2]);
			SetTimer(lightForwardRightString1Mods[0], false, 'AttackEnd');			
			Attack1.PlayCustomAnimByDuration(lightForwardRightString1,lightForwardRightString1Mods[0], 0.5, 0, false);
		break;

		case 2:
			Sword.setTracerDelay(mediumForwardRightString1Mods[1],mediumForwardRightString1Mods[2]);
			SetTimer(mediumForwardRightString1Mods[0], false, 'AttackEnd');	
			Attack1.PlayCustomAnimByDuration(mediumForwardRightString1,mediumForwardRightString1Mods[0], 0.5, 0, false);
		break;

		case 3:
			Sword.setTracerDelay(heavyForwardRightString1Mods[1],heavyForwardRightString1Mods[2]);
			SetTimer(heavyForwardRightString1Mods[0], false, 'AttackEnd');	
			Attack1.PlayCustomAnimByDuration(heavyForwardRightString1,heavyForwardRightString1Mods[0], 0.5, 0, false);
		break;
	}

    Sword.GoToState('Attacking');
}
/*
rightAttack
	Flushes existing debug lines
	Starts playing rightAttack attack animation
	Sets timer for end attack animation
	Sets tracer delay
	@TODO: Detect if timer is active, if so do not do another attack
*/
function rightAttack()
{
   	// AttackGateNode.SetActiveChild(1, 0);
   	// AttackBlendNode.SetActiveChild(0, 0);

    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');
	// FlushPersistentDebugLines();1.5,0.36

	//TODO: timer isn't 100% accurate, only 99%. Can cause a que attack to make sword 'active' but animation isn't playing

	switch(currentStance)
	{
		case 1:
			Sword.setTracerDelay(lightRightString1Mods[1],lightRightString1Mods[2]);
			SetTimer(lightRightString1Mods[0], false, 'AttackEnd');			
			Attack1.PlayCustomAnimByDuration(lightRightString1,lightRightString1Mods[0], 0.5, 0, false);
		break;

		case 2:
			Sword.setTracerDelay(mediumRightString1Mods[1],mediumRightString1Mods[2]);
			SetTimer(mediumRightString1Mods[0], false, 'AttackEnd');	
			Attack1.PlayCustomAnimByDuration(mediumRightString1,mediumRightString1Mods[0], 0.5, 0, false);
		break;

		case 3:
			Sword.setTracerDelay(heavyRightString1Mods[1],heavyRightString1Mods[2]);
			SetTimer(heavyRightString1Mods[0], false, 'AttackEnd');	
			Attack1.PlayCustomAnimByDuration(heavyRightString1,heavyRightString1Mods[0], 0.5, 0, false);
		break;
	}

    Sword.GoToState('Attacking');
}
/*
leftAttack
	Flushes existing debug lines
	Starts playing left attack animation
	Sets timer for end attack animation
	Sets tracer delay
	@TODO: Detect if timer is active, if so do not do another attack
*/
function leftAttack()
{
//ember_temp_left_attack
	// FlushPersistentDebugLines();
	DebugPrint("left -");

	// Attack1.PlayCustomAnimByDuration('ember_temp_left_attack',timeTakesToComplete, 0.5, 0, false);
	// SetTimer(timeTakesToComplete, false, 'AttackEnd');
	// SetTimer(timeTakesToComplete, false, 'AttackEnd');

	switch(currentStance)
	{
		case 1:

    		Mesh.AttachComponentToSocket(Sword.Mesh, 'DualWeaponPoint');
    		Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'DualWeaponPoint');

			Sword.setTracerDelay(lightLeftString1Mods[1], lightLeftString1Mods[2]);
			SetTimer(lightLeftString1Mods[0], false, 'AttackEnd');
			Attack1.PlayCustomAnimByDuration(lightLeftString1,lightLeftString1Mods[0], 0.5, 0, false);
		break;

		case 2:
			Sword.setTracerDelay(mediumLeftString1Mods[1], mediumLeftString1Mods[2]);
			SetTimer(mediumLeftString1Mods[0], false, 'AttackEnd');
			Attack1.PlayCustomAnimByDuration(mediumLeftString1,mediumLeftString1Mods[0], 0.5, 0, false);
		break;

		case 3:
			Sword.setTracerDelay(heavyLeftString1Mods[1], heavyLeftString1Mods[2]);
			SetTimer(heavyLeftString1Mods[0], false, 'AttackEnd');
			Attack1.PlayCustomAnimByDuration(heavyLeftString1,heavyLeftString1Mods[0], 0.5, 0, false);
		break;
	}	
    Sword.GoToState('Attacking');
}

/*
forwardAttack
	Flushes existing debug lines
	Starts playing forward attack animation
	Sets timer for end attack animation
	Sets tracer delay
	@TODO: Detect if timer is active, if so do not do another attack
*/
function forwardAttack()
{
	FlushPersistentDebugLines();
	DebugPrint("fwd -");

	switch(currentStance)
	{
		case 1:
			Sword.setTracerDelay(0.65); 
			Sword.setTracerDelay(lightForwardString1Mods[1], lightForwardString1Mods[2]);
			SetTimer(lightForwardString1Mods[0], false, 'AttackEnd');
			Attack1.PlayCustomAnimByDuration(lightForwardString1,lightForwardString1Mods[0], 0.5, 0, false);
			// Sword.setTracerDelay(0.30, timeTakesToComplete - 0.2);
		break;

		case 2:
			//timeTakesToComplete = 1.5;
			Sword.setTracerDelay(0.4, 0.7);
			Sword.setTracerDelay(mediumForwardString1Mods[1], mediumForwardString1Mods[2]);
			SetTimer(mediumForwardString1Mods[0], false, 'AttackEnd');
			Attack1.PlayCustomAnimByDuration(mediumForwardString1,mediumForwardString1Mods[0], 0.5, 0, false);
		break;

		case 3:
			Sword.setTracerDelay(heavyForwardString1Mods[1], heavyForwardString1Mods[2]);
			SetTimer(heavyForwardString1Mods[0], false, 'AttackEnd');
			Attack1.PlayCustomAnimByDuration(heavyForwardString1,heavyForwardString1Mods[0], 0.5, 0, false);
		break;
	}
    Sword.GoToState('Attacking');
}
/*
AttackEnd
	Resets sword, tracers, and idle stance at end of forward attack
	@TODO: Make perhaps only one attack end animation funcion
*/
function AttackEnd()
{
	DebugPrint("dun -");
	//forwardAttack1.StopCustomAnim(0);
	// Sword.rotate(0,0,49152);
    Sword.SetInitialState();
    Sword.resetTracers();

    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');

    animationControl();

    if(savedByteDirection[4] == 1)
    {
    	savedByteDirection[4] = 0;
    	doAttack(savedByteDirection);
    }

	// forwardAttack1.SetActiveChild(0);
}
/*
goToIdleMotherfucker
	Temporary animation for 'parries'
*/
function goToIdleMotherfucker()
{
Attack1.PlayCustomAnimByDuration('ember_idle_2',1.0, 0.2, 0, false);
}
/*
animationControl
	When player is idle, pick only one of the random idle animations w/ 0.25 blend
*/
function animationControl()
{
	if(Vsize(Velocity) == 0) 
	{ 
		//Idle
		if(idleBool == false)
		{
		idleBool = true;
		runBool = false;
		 if (IdleAnimNodeBlendList.BlendTimeToGo <= 0.f)
  			{
  				//Pick a random idle animation
    			// IdleAnimNodeBlendList.SetActiveChild(Rand(IdleAnimNodeBlendList.Children.Length), 0.25f);
				IdleAnimNodeBlendList.SetActiveChild(currentStance-1, idleBlendTime);
    			//Set sword orientation temp_fix_for_animation
				// Sword.rotate(0,0,16384);
    			// Sword.Rotation() Rotation=(Pitch=000 ,Yaw=0, Roll=16384 )
  			}
  			FullBodyBlendList.SetActiveChild(1,idleBlendTime);//Use Full Body Blending
  		}
	}
	else
	{
		if( runBool == false)
		{ 
		idleBool = false;
		runBool = true;
		 if (RunAnimNodeBlendList.BlendTimeToGo <= 0.f)
  			{ 
  				//Pick a random idle animation
    			// IdleAnimNodeBlendList.SetActiveChild(Rand(IdleAnimNodeBlendList.Children.Length), 0.25f);
				RunAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				WalkAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				wRightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				wLeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
    			//Set sword orientation temp_fix_for_animation
				// Sword.rotate(0,0,16384);
    			// Sword.Rotation() Rotation=(Pitch=000 ,Yaw=0, Roll=16384 )
  			}
  			FullBodyBlendList.SetActiveChild(0,idleBlendTime);//Split body blending at spine
  		}
    	//Set sword orientation, temp_fix_for_animation
		// Sword.rotate(0,0,49152);

	}

	// if(swordBlockIsActive)//temp_fix_for_animation
		// Sword.rotate(0,0,49152);
}
/*
tetherBeamProjectile
	Launches a projectile specified by EmberProjectile.uc
	Upon hitting a target, executes tetherLocationHit
*/  
function tetherBeamProjectile()
{
	local projectile P;
	local vector newLoc;
	local rotator rotat;
	// newLoc = Location;
	//@TODO: if EmberProjectile already exists when launch, delete previous instance and initiate new
	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', newLoc, rotat);
	P = Spawn(class'EmberProjectile',self,,newLoc);
	newLoc = normal(Vector( EmberGameInfo(WorldInfo.Game).playerControllerWORLD.Rotation)) * 50;
	EmberProjectile(p).setProjectileOwner(self);
	p.Init(newLoc);
}
/*
tetherLocationHit
	returns hit and location of tetherBeamProjectile
*/
function tetherLocationHit(vector hit, vector lol, actor Other)
{
	projectileHitVector=hit;
	projectileHitLocation=lol;
	enemyPawn = Other;
	enemyPawnToggle = (enemyPawn != none) ? true : false;
	createTether();
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

	enemyPawn = enemyPawnToggle ? enemyPawn : none;

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
	// local float floaty;
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
	// DebugPrint("p = " $isPawn);
	// floaty = VSize(location - wall.location);
	// DebugPrint("distance -"@floaty);
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
	

	enemyPawnToggle = enemyPawnToggle ? false : false;
	//state
	 EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering = true;
	
	curTargetWall = Wall;
	//wallHitLoc = hitLoc;
	wallhitloc = projectileHitVector;
	
	//get length of tether from starting
	//position of object and wall
	// tetherlength = vsize(hitLoc - Location) * 0.75;
	// if (tetherlength > 1000) 
		// tetherlength = 1000;

	tetherlength = vsize(hitLoc - Location) * 0.75;
	// if (tetherlength > 500) 
		// tetherlength = 500;
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
	//tetherBeam.SetVectorParameter('TetherEnd', hitLoc);	
	if(enemyPawn != none)
	tetherBeam.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
	else
	tetherBeam.SetVectorParameter('TetherEnd', projectileHitLocation);	
	


	tetherBeam2.SetHidden(false);
	tetherBeam2.ActivateSystem(true);
	
	//Beam Source Point
	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket2', tVar, r);
	// tetherBeam2.SetVectorParameter('TetherSource', tVar);
	tetherBeam2.SetVectorParameter('TetherSource', tVar);
	
	
	//Beam End
	if(enemyPawn != none)
	tetherBeam2.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
	else
	tetherBeam2.SetVectorParameter('TetherEnd', projectileHitLocation);	
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
	tetherBeam2.SetVectorParameter('TetherSource', vc);
	
	//save prev tick pos to see change in position
	prevTetherSourcePos = vc;
	

	if(enemyPawn != none)
	{
		DebugPrint("tcalc - "@TestPawn(enemyPawn).grappleSocketLocation);
	tetherBeam.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
		tetherBeam2.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
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
	vc = Location - projectileHitLocation;
	
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
		// if(vsize(velocity) < 2500){
			// velocity -= vc2 * 300;
		// }
		if(Vsize(vc) > 1500)
		{
			velocity -= vc2 * (Vsize(vc) * goingTowardsHighVelModifier);
		}
		else
		{
			velocity -= vc2 * goingTowardsLowVelModifier;	
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
				velocity -= vc2 * goingAwayVelModifier;
			}
		// }
		// if(tetherlength > 1000)
			// velocity -= vc2 * (tetherlength * 0.15);
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
	Queued for Deletion
*/
function AddDefaultInventory()
{
    //Add the sword as default
    // InvManager.DiscardInventory();
    // InvManager.CreateInventory(class'Custom_Sword'); //InvManager is the pawn's InventoryManager
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


function JumpVelocityPinch(float fDeltaTime)
{

//TODO: Velocity keeps capping at 320, need to find a logarithmic approach

 if(physics == PHYS_Falling) //we are in the air
 	jumpActive = true;

  		if(physics == PHYS_Walking && jumpActive) //When we land after being in the air
  		{
  			JumpVelocityPinch_LandedTimer=fDeltaTime; //set the timer to something else
  			jumpActive = false; //disable toggle so we don't activate this again
  			AccelRate *= 0.3;
  			Velocity *= 0.60;
  		}

  		if(JumpVelocityPinch_LandedTimer != 0) //if the timer isn't 0
  		{
  			JumpVelocityPinch_LandedTimer += fDeltaTime; //increase timer by tick ammount
  			// if( JumpVelocityPinch_LandedTimer <= 0.5 ) //while it's less than half a second
  				// if(VSize(Velocity) > 320) //and if velocity is greater than 320 (440 is max speed when walking)
  				// AccelRate *= 1.05; //multiply itself by 0.8
  		}

  		if(JumpVelocityPinch_LandedTimer > 0.5) //if timer has gone past 0.5 seconds
  		{
  			JumpVelocityPinch_LandedTimer = 0; //set it to 0.
  			AccelRate=2048.0;
  		}
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

//===============================
// Stances Functions
//===============================
function LightStance()
{
	if(GetTimeLeftOnAttack() > 0)
		return;

	currentStance = 1;
	swordMesh=SkeletalMesh'ArtAnimation.Meshes.gladius';
	Mesh.DetachComponent(Sword.mesh);
    Mesh.DetachComponent(Sword.CollisionComponent);
	Sword.Mesh.SetSkeletalMesh(swordMesh);
	    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');
    LightDecoSword.Mesh.SetHidden(true);
    HeavyDecoSword.Mesh.SetHidden(false);
    MediumDecoSword.Mesh.SetHidden(false);
	overrideStanceChange();
}
function BalanceStance()
{
	if(GetTimeLeftOnAttack() > 0)
		return;

	currentStance = 2;
	swordMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2';
	Mesh.DetachComponent(Sword.mesh);
    Mesh.DetachComponent(Sword.CollisionComponent);
	Sword.Mesh.SetSkeletalMesh(swordMesh);
	    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');
    LightDecoSword.Mesh.SetHidden(false);
    HeavyDecoSword.Mesh.SetHidden(false);
    MediumDecoSword.Mesh.SetHidden(true);
	overrideStanceChange();
}
function HeavyStance()
{
	if(GetTimeLeftOnAttack() > 0)
		return;

 	currentStance = 3;
	swordMesh=SkeletalMesh'ArtAnimation.Meshes.flammard';  
	Mesh.DetachComponent(Sword.mesh);  
    Mesh.DetachComponent(Sword.CollisionComponent);
	Sword.Mesh.SetSkeletalMesh(swordMesh);
	    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint'); 
    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint'); 
    LightDecoSword.Mesh.SetHidden(false);
    HeavyDecoSword.Mesh.SetHidden(true);
    MediumDecoSword.Mesh.SetHidden(false);
overrideStanceChange();
}
function SheatheWeapon()
{
	Mesh.DetachComponent(Sword.mesh);
    Mesh.DetachComponent(Sword.CollisionComponent);
} 
function overrideStanceChange()
{
	IdleAnimNodeBlendList.SetActiveChild(currentStance-1, idleBlendTime);
	RunAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	WalkAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	wRightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	wLeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
}
//===============================
// Console Vars
//===============================

exec function ep_sword_block_distance(float distance = -3949212)
{
	if(distance == -3949212)
		DebugPrint("Distance till sword block 'parries' opponent. Current Value -"@Sword.blockDistance);
	else
  		Sword.blockDistance = distance;
}
exec function ep_sword_block_cone(float coneDotProductAngle = -3949212)
{
	if(coneDotProductAngle == -3949212)
		DebugPrint("DotProductAngle for active block. 0.5 is ~45 degrees. 0 is 90 degrees. Current Value -"@Sword.blockCone);
	else
  		Sword.blockCone = coneDotProductAngle;
}
exec function ep_player_anim_run_blend_time(float runBlendTimeMod = -3949212)
{
	if(runBlendTimeMod == -3949212)
		DebugPrint("Blend time (in seconds) between run animations. Current Value -"@runBlendTime);
	else
  		runBlendTime = runBlendTimeMod;
} 
exec function ep_player_anim_idle_blend_time(float idleBlendTimeMod = -3949212)
{
	if(idleBlendTimeMod == -3949212) 
		DebugPrint("Blend time (in seconds) between idle animations. Current Value -"@idleBlendTime);
	else
  		idleBlendTime = idleBlendTimeMod; 
}
exec function ep_player_gravity_scaling(float GravityScale = -3949212)
{
	if(GravityScale == -3949212) 
		DebugPrint("Lower values = lower gravity, higher = higher gravity. Current Value -"@CustomGravityScaling);
	else
  		CustomGravityScaling = GravityScale;
}
exec function ep_player_jump_boost(float JumpBoost = -3949212)
{ 
	JumpZ = (JumpBoost == -3949212) ? ModifiedDebugPrint("The boost player gets when jumping. Current Value -", JumpZ) : JumpBoost;
}
exec function ep_player_decoSword_light(int Var1 = -3949212, int Var2 = -3949212, int Var3 = -3949212)
{ 
	local int v1, v2, v3;
	if(Var1 == -3949212 && Var2 == -3949212 && Var3 == -3949212)
	{
		DebugPrint("Rotates Light DecoSword. Uses the weird bit angle system. 360 degrees = 65536");
		DebugPrint("pitch:"@LightDecoSword.Rotation.pitch);
		DebugPrint("yaw:"@LightDecoSword.Rotation.Yaw);
		DebugPrint("roll:"@LightDecoSword.Rotation.Roll);
	}
	else
	{
		v1 = (Var1 == -3949212) ? LightDecoSword.Rotation.pitch : Var1;
		v2 = (Var2 == -3949212) ? LightDecoSword.Rotation.Yaw : Var2;
		v3 = (Var3 == -3949212) ? LightDecoSword.Rotation.Roll : Var3;
		LightDecoSword.rotate(v1, v2, v3);
	}
	// -180,45,-180
}
function float ModifiedDebugPrint(string sMessage, float variable)
{
	DebugPrint(sMessage @ string(variable));
	return variable;
}
defaultproperties
{
	savedByteDirection=(0,0,0,0,0); 

//=============================================
// Combo / Attack System Vars
//=============================================
/* Note:
/- Placement in EmberPawn is temporary
/- Light/Medium/Heavy stances will be set in their 
/- Respective Sword.uc files when Ready.
*/


lightLeftString1			=	ember_temp_left_attack
lightRightString1			=	ember_temp_right_attack
lightForwardString1			=	ember_attack_forward
lightForwardLeftString1 	=	ember_temp_left_attack
lightForwardRightString1 	= 	ember_temp_right_attack

mediumLeftString1			=
mediumRightString1			=
mediumForwardString1 		=	ember_medium_forward
mediumForwardLeftString1 	= 
mediumForwardRightString1 	= 

heavyLeftString1			=
heavyRightString1			=	ember_heavy_right
heavyForwardString1			=
heavyForwardLeftString1 	= 
heavyForwardRightString1 	= 	ember_heavy_right


//Mods:
// -- Duration
// -- Time till Tracer is Active (s)
// -- Time till Tracer gets Deactivated (s), if 0 = active for all attack
// ex: (1.0, 0.5, 0): duration = 1s, tracers start after 0.5s, last till animation finishes
lightLeftString1Mods 			=(1,0.5,0)
lightRightString1Mods 			=(1,0,0)
lightForwardString1Mods 		=(1,0.65,0)
lightForwardLeftString1Mods		=(1,0,0)
lightForwardRightString1Mods 	=(1,0,0)

mediumLeftString1Mods 			=(1,0,0) 
mediumRightString1Mods 			=(1,0,0)
mediumForwardString1Mods 		=(1.0,0.4,0.7)
mediumForwardLeftString1Mods 	=(1,0,0)
mediumForwardRightString1Mods 	=(1,0,0)

heavyLeftString1Mods 			=(1,0,0)
heavyRightString1Mods 			=(1.5,0.55,0.95)
heavyForwardString1Mods 		=(1,0,0)
heavyForwardLeftString1Mods 	=(1,0,0)
heavyForwardRightString1Mods 	=(1.5,0.55,0.95)

//=============================================
// End Combo / Attack System Vars
//=============================================

	notSpawned=true
	idleBlendTime=0.15f
	runBlendTime=0.15f
	bCanStrafe=false
	SwordState = false
	tetherStatusForVel = false
	tetherMaxLength = 4000
	MultiJumpBoost=1622.0
	CustomGravityScaling = 1.8//1.6
	JumpZ=500//JumpZ=750 //default-322.0
        bCollideActors=True
      bBlockActors=True
      currentStance = 1;

	Begin Object Name=CollisionCylinder
		CollisionRadius=0025.00000
		CollisionHeight=0047.5.00000
	End Object
   	Components.Add(CollisionCylinder)

	CollisionComponent=CollisionCylinder
}