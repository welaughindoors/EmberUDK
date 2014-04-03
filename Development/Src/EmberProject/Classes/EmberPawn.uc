
//=============================================
// Important Tags
//=============================================
//temp_fix_for_animation
// -- Temporary fix until animation is corrected
//TODO:
// -- Shit TODO
//pending deletion
// -- deletion is pending. Function soon to be deleted


class EmberPawn extends UTPawn
placeable;

var SkeletalMeshComponent ParentModularComponent;
//=============================================
// Combo / Attack System Vars
//=============================================

var AttackFramework aFramework;
// var GloriousGrapple GG;
var EmberDodge Dodge;
var GrappleRopeBlock testBlock;
var EmberVelocityPinch VelocityPinch;
var EmberChamberFlags ChamberFlags;
var EmberCosmetic_ItemList Cosmetic_ItemList;
var EmberModularPawn_Cosmetics ModularPawn_Cosmetics;
var EmberHudWrapper eHud;

var ParticleSystemComponent PermaBeam;
var AnimNodeAimOffset AimOffsetNode;

var array<SkeletalMeshComponent> AllMeshs;

var byte SetUpCosmeticsStartupCheck;

var bool ParryEnabled;

var bool tempToggleForEffects;

//The point where one attack can merge into another
var bool bCancelPoint;

var float headcounter;
//When chambering, zooms camera closer to pawn
var bool bChamberZoom;
//When chambering, shakes camera
var bool bChamberZoomShake;

var array<bool> bGrappleStopLogicGate;
var int iGrappleStopCounter;
// var SkeletalMeshComponent PlayerMeshComponent;
var decoSword LightDecoSword;
var decoSword MediumDecoSword;
var decoSword HeavyDecoSword;
var decoSword Helmet;
var AnimNodeSlot AnimSlot;
var bool SwordState;
var EmberPlayerController ePC;
// var() SkeletalMeshComponent SwordMesh;
var SkeletalMesh swordMesh;
var vector cameraOutLoc;
var array<ParticleSystemComponent> tetherBeam;
var array<GrappleRopeBlock> ropeBlockArray;
var vector savedVelocity;
var array<SoundCue> huahs;
//=============================================
// Sprint System
//=============================================
var bool 			iLikeToSprint;
var bool 			tickToggle;
var float 			originalSpeed;

var float cameraCamZOffsetInterpolation;
var float cameraCamXOffsetMultiplierInterpolation;

var float cameraCamXOffsetInterpolation;

var float cameraCamYOffsetInterpolation;

var UTEmitter SwordEmitterL;  
var UTEmitter SwordEmitterR;  

//Switches tether beam types for previewing.
var int TetherBeamType;
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

//Modifier to jump's velocity (applied to velocity right before jump.z is)
var float JumpVelocityModifier;

var bool debugConeBool;

//For replication identifications
var int PawnID;

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
var AnimNodeBlendList 	JumpAttackSwitch;
var AnimNodeBlendList 	DashOverrideSwitch;

var bool 				idleBool, runBool;
var float 				idleBlendTime, runBlendTime;

//=============================================
// Skeleton Controls
//=============================================
var float IKRightHand_Strength;
var float IKUpperBodyIncrement;
var bool IKUpperBody_AnimateToggle;
var SkelControl_CCD_IK IKRightHand;
var SkelControl_CCD_IK IKLeftHand;
var SkelControl_CCD_IK IKUpperBody;
//Rotates head bone to target
var SkelControlLookAt Skel_LookAt;
//Lerp between skelcontrol and animations
var float Skel_LookAt_Lerp;
//=============================================
// Attack 
//=============================================
var AnimNodeBlendList 		AttackGateNode;
var AnimNodeBlendList 		AttackBlendNode;
var AnimNodePlayCustomAnim 	EmberDash;
var AnimNodeSlot			AttackSlot[2];
var AnimNodeBlend			AttackBlend;
var byte 					blendAttackCounter;
var bool 					bAttackQueueing;
var bool 					bRightChambering;
var float 					iChamberingCounter;

//Used for automated block, to prohibit spamming
var byte BlockChamberFlag;
//ID to the attack animation
var int AttackAnimationID;
//If player hit something, allow him to immediately do another attack
var bool AttackAnimationHitTarget;
//Radius to detect pawns around player for head tracking
var float Skel_HeadPawnDetectionRadius;

var struct ForcedAnimLoopPacketStruct
{
	var name AnimName;
	var float blendIn;
	var float blendOut;
	var float tDur;
} ForcedAnimLoopPacket;

var struct GrappleReplicationHolderStruct
{
	var array<int> PlayerID;
	var array<EmberPawn> gPawn;
	var array<vector> TetherProjectileHitLoc;
	var array<ParticleSystemComponent> TetherBeams;
	var array<bool> AttachedOnEnemy;
	var pawn clientTrackPawn;
} GrappleReplicationHolder;
//Current stance (fast/medium/heavy)
var int currentStance;

var float 				animationQueueAndDirection;
var array<byte> savedByteDirection;
var float enableInaAudio;

//
//=============================================
// Weapon
//=============================================
var array<Sword> Sword;
var bool  tracerRecordBool;

//Brings camera to shoulder level for grapple aiming
var bool bAttackGrapple;
//if tether projectile is active, do NOT shoot another
var bool bTetherProjectileActive;
//CVar used to show trace lines
var int bTraceLines;
// Toggles active state of sprint control
var bool bSprintControl;
// Runs per tick to add up to X seconds to increase level
var float fSprintControlCounter;
// Declares X Seconds
var float fSprintControlSecondsTrigger;
// Max ground speed bonus
var float fSprintControlMaxGroundSpeed;
// X% bonus to ground speed per level
var float fSprintControlPercentBonus;


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



//These are the time related vars
var int 					ticCount;
var float 					timeFromStart;



//tether misc.
var rotator 				hitNormalRotator;
var array<vector> 			startLocsArray;
var array<vector>			endLocsArray;
var int 					extraTether;


//=============================================
// Utility Functions
//=============================================
/*
DebugPrint
	Easy way to print out debug messages
	If wanting to print variables, use: DebugPrint("var :" $var);
*/
function DebugPrint(string sMessage)
{
    ePC.ClientMessage(sMessage);
}

//=============================================
// Null Functions
//=============================================

//Disables Landed Function, probably doesn't need disable
event Landed(vector HitNormal, Actor FloorActor);
simulated function TakeFallingDamage();
//Disables double directional dodge. Uncomment to renable.
function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross);

//=============================================
// System Functions
//=============================================

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int OldHealth;

	Velocity.Z += 25;

	// Attached Bio glob instigator always gets kill credit
	if (AttachedProj != None && !AttachedProj.bDeleteMe && AttachedProj.InstigatorController != None)
	{
		EventInstigator = AttachedProj.InstigatorController;
	}

	// reduce rocket jumping
	if (EventInstigator == Controller)
	{
		momentum *= 0.6;
	}

	// accumulate damage taken in a single tick
	if ( AccumulationTime != WorldInfo.TimeSeconds )
	{
		AccumulateDamage = 0;
		AccumulationTime = WorldInfo.TimeSeconds;
	}
    OldHealth = Health;
	AccumulateDamage += Damage;
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	AccumulateDamage = AccumulateDamage + OldHealth - Health - Damage;
	Flash_HealthUpdate();
}
/*
PostBeginPlay
	The initial startup for the class
*/
simulated event PostBeginPlay()
{
	super.PostBeginPlay();

    aFramework = new class'EmberProject.AttackFramework';
    Dodge = new class'EmberProject.EmberDodge';
    // GG = new class'EmberProject.GloriousGrapple';
    VelocityPinch = new class'EmberProject.EmberVelocityPinch';
    ChamberFlags = new class 'EmberProject.EmberChamberFlags';
    Cosmetic_ItemList = new class'EmberProject.EmberCosmetic_ItemList';
    Cosmetic_ItemList.InitiateCosmetics();
    Dodge.SetOwner(self);
    VelocityPinch.SetOwner(self);
    aFramework.InitFramework();

    SetTimer(0.1, false, 'SetUpCharacterMesh');
   	SetTimer(0.11, false, 'WeaponAttach'); 

}
/*
SetUpCharacterMesh
	Sets up player's mesh
*/
simulated function SetUpCharacterMesh()
{
    ModularPawn_Cosmetics = new class'EmberProject.EmberModularPawn_Cosmetics';
    ModularPawn_Cosmetics.Initialize(self, ParentModularComponent);
    SetPawnID();
}
/*
SetPawnID
	sets pawn ID for all clients
*/
simulated function SetPawnID()
{
	PawnID = EmberGameInfo(WorldInfo.game).counterForPawns;
	EmberGameInfo(WorldInfo.game).counterForPawns++;
}
/*
disableMoveInput
	WASD movement and such
*/
function disableMoveInput(bool yn)
{
	ePC.IgnoreMoveInput(yn);
}
/*
disableLookInput
	Mouse movement and such
*/
function disableLookInput(bool yn)
{
	ePC.IgnoreLookInput(yn);
}

/*
DoDodge
	takes WASD flags to have general idea of where player's heading
	Can't use velocity vector, because if player is moving left
	and then shift+right, it'll just either do 0 or go left.
*/
simulated function bool DoDodge(array<byte> inputA)
{
	return Dodge.DoDodge(inputA);
}
/*
DoJump
	Derived from UTPawn
	Modified to add additional movement 'oomf' when jumping
*/
function bool DoJump( bool bUpdating )
{
	// This extra jump allows a jumping or dodging pawn to jump again mid-air
	// (via thrusters). The pawn must be within +/- DoubleJumpThreshold velocity units of the
	// apex of the jump to do this special move.
	if ( !bUpdating && CanDoubleJump()&& (Abs(Velocity.Z) < DoubleJumpThreshold) && IsLocallyControlled() )
	{
		if ( PlayerController(Controller) != None )
			PlayerController(Controller).bDoubleJump = true;
		DoDoubleJump(bUpdating);
		MultiJumpRemaining -= 1;
		return true;
	}
	Velocity *= JumpVelocityModifier;
	if (bJumpCapable && !bIsCrouched && !bWantsToCrouch && (Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider))
	{
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )
			Velocity.Z = Default.JumpZ;
		else
			Velocity.Z = JumpZ;
		if (Base != None && !Base.bWorldGeometry && Base.Velocity.Z > 0.f)
		{
			if ( (WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ) && (GetGravityZ() == WorldInfo.WorldGravityZ) )
			{
				Velocity.Z += Base.Velocity.Z * sqrt(GetGravityZ()/WorldInfo.DefaultGravityZ);
			}
			else
			{
				Velocity.Z += Base.Velocity.Z;
			}
		}
		SetPhysics(PHYS_Falling);
		bReadyToDoubleJump = true;
		bDodging = false;
		if ( !bUpdating )
		    PlayJumpingSound();
		return true;
	}
	return false;
}
/*
SetUpCosmetics
	Static and Clothed assets are attached and setup here.
*/
simulated function SetUpCosmetics()
{
	local EmberCosmetic Cosmetic;
	local int i, x;
	if(SetUpCosmeticsStartupCheck == 1)
		return;
	SetUpCosmeticsStartupCheck = 1;
	DebugPrint("SetUpCosmetics");
	for(i = 0; i < Cosmetic_ItemList.CosmeticStruct.CosmeticItemList.length; i++)
	{
    Cosmetic = Spawn(class'EmberCosmetic', self);
    Cosmetic.Mesh.SetSkeletalMesh(Cosmetic_ItemList.CosmeticStruct.CosmeticItemList[i]);
    Cosmetic.Mesh.SetScale(Cosmetic_ItemList.CosmeticStruct.CosmeticItemScaleList[i]);
    AllMeshs.AddItem(Cosmetic.mesh);
    ParentModularComponent.AttachComponentToSocket(Cosmetic.Mesh, Cosmetic_ItemList.CosmeticStruct.SocketLocationList[i]);
	}
	for(x = 0; x < Cosmetic_ItemList.CosmeticStruct.CapeItemList.length; x++)
	{
    Cosmetic = Spawn(class'EmberCosmetic', self);
    Cosmetic.Mesh.SetSkeletalMesh(Cosmetic_ItemList.CosmeticStruct.CapeItemList[x]);
    Cosmetic.Mesh.SetScale(Cosmetic_ItemList.CosmeticStruct.CosmeticItemScaleList[i]);
    Cosmetic_ItemList.SetCapeAttributes(Cosmetic.Mesh);
    AllMeshs.AddItem(Cosmetic.mesh);
    ParentModularComponent.AttachComponentToSocket(Cosmetic.Mesh, Cosmetic_ItemList.CosmeticStruct.SocketLocationList[i]);
    i++;

	DebugPrint("SetUpCosmetics_Capes");
	}
	for(i = 0; i < ModularPawn_Cosmetics.SkelMeshList.length; i++)
		AllMeshs.AddItem(ModularPawn_Cosmetics.SkelMeshList[i]);

//Might not be necessary
	ModularPawn_Cosmetics.ParentModularItem.SetRBChannel(RBCC_Pawn);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Default,TRUE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Cloth,TRUE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Pawn,TRUE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Vehicle,TRUE);
   // Mesh.SetRBCollidesWithChannel(RBCC_Untitled3,FALSE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_BlockingVolume,TRUE);
	// ModularPawn_Cosmetics.ParentModularItem.SetPhysicsAsset(PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics');
	SetupLightEnvironment();
}
/*
SetupLightEnvironment
	All mesh pieces need to have light environment setup on it
	Hopefully this isn't resource intensive
	No light enviro on mesh = black
*/
function SetupLightEnvironment()
{
	local int i;
	for(i = 0; i < AllMeshs.length; i++)
		AllMeshs[i].setLightEnvironment(self.LightEnvironment);
}
/*
PullEnemy
	
*/
function PullEnemy(actor Other, vector MomentumTransfer, controller InstigatorController)
{
	Other.TakeDamage(0, InstigatorController, Other.Location, MomentumTransfer,  class'UTDmgType_LinkBeam',, self);
	ClientReceiveGrappleReplication(true, self.playerreplicationinfo.PlayerID, Other.Location, true, pawn(Other));
	if(role < ROLE_Authority)
		ServerPullEnemy(Other, MomentumTransfer, InstigatorController);
}

/*
ServerPullEnemy
	
*/
reliable server function ServerPullEnemy(actor Other, vector MomentumTransfer, controller InstigatorController)
{
	PullEnemy(other, MomentumTransfer, InstigatorController);
}
/*
WeaponAttach
	Attaches a skeleton mesh of the weapon in same place as weapon
	Used to detect collisions. atm WIP.
	---
	Class that is runned after startup. Useful for creating misc classes for temp work
*/
simulated function WeaponAttach() 
{ 
    local Sword tSword;
		
        tSword = Spawn(class'Sword', self);
		tSword.Mesh.SetSkeletalMesh(aFramework.lightSwordMesh);
		tSword.setDamage(aFramework.lightDamagePerTracer);
		tSword.PhysicsAssetCollection.AddItem(PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_Physics');
		tSword.PhysicsAssetCollection.AddItem(PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_block_Physics');
        AllMeshs.AddItem(tSword.mesh);
		Sword.AddItem(tSword);

        tSword = Spawn(class'Sword', self);
		tSword.Mesh.SetSkeletalMesh(aFramework.mediumSwordMesh);
		tSword.setDamage(aFramework.mediumDamagePerTracer);		
		tSword.PhysicsAssetCollection.AddItem(PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_Physics');
		tSword.PhysicsAssetCollection.AddItem(PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_block_Physics');
		AllMeshs.AddItem(tSword.mesh);
        Sword.AddItem(tSword);

        tSword = Spawn(class'Sword', self);
		tSword.Mesh.SetSkeletalMesh(aFramework.heavySwordMesh);
		tSword.setDamage(aFramework.heavyDamagePerTracer);
		tSword.PhysicsAssetCollection.AddItem(PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_Physics');
		tSword.PhysicsAssetCollection.AddItem(PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_block_Physics');
		AllMeshs.AddItem(tSword.mesh);
        Sword.AddItem(tSword);

        huahs.AddItem(SoundCue'EmberSounds.huahcue1');

        //TODO: Get sheathes for this
        // LightDecoSword = Spawn(class'decoSword', self);
        MediumDecoSword = Spawn(class'decoSword', self);
        // HeavyDecoSword = Spawn(class'decoSword', self);

        // LightDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.gladius');
        MediumDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.ember_scabbard_katana');
        // HeavyDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.ember_weapon_heavy');
        AllMeshs.AddItem(MediumDecoSword.mesh);

    ParentModularComponent.AttachComponentToSocket(Sword[0].Mesh, 'WeaponPoint');
    ParentModularComponent.AttachComponentToSocket(Sword[0].CollisionComponent, 'WeaponPoint');
 
	MediumDecoSword.Mesh.AttachComponentToSocket(Sword[1].Mesh, 'KattanaSocket');
    MediumDecoSword.Mesh.AttachComponentToSocket(Sword[1].CollisionComponent, 'KattanaSocket');

    ParentModularComponent.AttachComponentToSocket(Sword[2].Mesh, 'HeavyAttach');
    ParentModularComponent.AttachComponentToSocket(Sword[2].CollisionComponent, 'HeavyAttach');

 	//TODO: Get rest of sheathes to add these back in
    // Mesh.AttachComponentToSocket(LightDecoSword.Mesh, 'LightAttach');
    ParentModularComponent.AttachComponentToSocket(MediumDecoSword.Mesh, 'BalanceAttach');
    // Mesh.AttachComponentToSocket(HeavyDecoSword.Mesh, 'HeavyAttach');

    LightDecoSword.Mesh.SetHidden(true);
    MediumDecoSword.Mesh.SetHidden(false);
    HeavyDecoSword.Mesh.SetHidden(false);

    currentStance = 1;

	SetUpCosmetics();
	overrideStanceChange();


		//TODO:readd	
		// setTrailEffects();
		SetupPlayerControllerReference();
		Flash_InitialUpdates();
}
/*
SetupPlayerControllerReference
	We used to derive from GameInfo, but its easier to just take instigator
	Reason being, for multiplayer
*/
simulated function SetupPlayerControllerReference(EmberPlayerController aPlayer = none)
{
	if(aPlayer == none)
		ePC = EmberPlayerController(Instigator.Controller);
		else
			ePC = aPlayer;
}
/*
setTrailEffects
	Sticks an emitter on current sword
*/
simulated function setTrailEffects(float duration)
{ 
//Declare a new Emitter    
local vector Loc;
local rotator Roter;    
 
//Lets Get the Intial Location Rotation
Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('MidControl', Loc, Roter);
 
//Spawn The Emitter In to The Pool
SwordEmitterL = Spawn(class'UTEmitter', self,, Loc, Roter);
 
//Set it to the Socket
SwordEmitterL.SetBase(self,, Sword[currentStance-1].Mesh, 'MidControl'); 
 
//Set the template
// SwordEmitter.SetTemplate(ParticleSystem'RainbowRibbonForSkelMeshes.RainbowSwordRibbon', false); 
// SwordEmitter.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue', false); 

SwordEmitterL.SetTemplate(ParticleSystem'RainbowRibbonForSkelMeshes.RainbowSwordRibbon', false); 
 
//Never End
SwordEmitterL.LifeSpan = duration;
SwordEmitterL.ParticleSystemComponent.bUpdateComponentInTick = true;
SwordEmitterL.ParticleSystemComponent.SetTickGroup(TG_EffectsUpdateWork);
Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('MidControl2', Loc, Roter);

//Spawn The Emitter In to The Pool
SwordEmitterR = Spawn(class'UTEmitter', self,, Loc, Roter);
 
//Set it to the Socket
SwordEmitterR.SetBase(self,, Sword[currentStance-1].Mesh, 'MidControl2'); 
 
//Set the template
// SwordEmitter.SetTemplate(ParticleSystem'RainbowRibbonForSkelMeshes.RainbowSwordRibbon', false); 
// SwordEmitter.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue', false); 

SwordEmitterR.SetTemplate(ParticleSystem'RainbowRibbonForSkelMeshes.RainbowSwordRibbon', false); 
 
//Never End
SwordEmitterR.LifeSpan = duration;
SwordEmitterR.ParticleSystemComponent.bUpdateComponentInTick = true;
SwordEmitterR.ParticleSystemComponent.SetTickGroup(TG_EffectsUpdateWork);
}
/*
setDodgeEffect
	Temp. WIP
	Adds an effect when dodging
*/
simulated function setDodgeEffect()
{
	local UTEmitter SwordEmitter;      
local vector Loc;
local rotator Roter;    
 
//Lets Get the Intial Location Rotation
ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('Dodge1', Loc, Roter);
 
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, Loc, rotator(vector(roter) << rot(0,-8192,0)));
 
//Set it to the Socket
SwordEmitter.SetBase(self,, Mesh, 'Dodge1'); 
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Exhaust', false); 
 
//Never End
SwordEmitter.LifeSpan = 3;
}

simulated function setDodgeStance(int index, float duration)
{	
	EmberDash.PlayCustomAnim('ember_medium_dash_forward',1.0, duration/3, 0, false);
	DashOverrideSwitch.SetActiveChild(index, 0);	
}
/* 
Tick
	Every ~0.088s, this function is called.
*/
Simulated Event Tick(float DeltaTime)
{
	local vector ssss;
	local rotator r;
	// local UTPlayerController PC;
	Super.Tick(DeltaTime);
	// runsPerTick(deltatime);
	LeftRightClicksAndChambersManagement(DeltaTime);
	//for fps issues and keeping things properly up to date
	//specially for skeletal controllers
// DebugPrint("lerp "@eHUD.GrappleAlpha);
	deltaTimeBoostMultiplier = deltatime * 40;
	
	if(PermaBeam != none)
	{

	Sword[currentStance-1].mesh.GetSocketWorldLocationAndRotation('EndControl', ssss, r);
		PermaBeam.SetVectorParameter('TetherEnd', ssss);
	Sword[currentStance-1].mesh.GetSocketWorldLocationAndRotation('StartControl', ssss, r);
		PermaBeam.SetVectorParameter('TetherSource', ssss);
	}
	//the value of 40 was acquired through my own hard work and testing,
	//this deltaTimeBoostMultiplier system is my own idea :) - grapple

	//=== TETHER ====
	if(ePC != none)
	if (ePC.isTethering) 
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
		if(Dodge.bDodging)
			Dodge.Count(DeltaTime);

if(VelocityPinch.bApplyVelocityPinch)
	VelocityPinch.ApplyVelocityPinch(DeltaTime);
if(bAttackQueueing)
{
	// DebugPrint("chamber active");
		AttackSlot[0].SetActorAnimEndNotification(true);
		//AttackSlot[1].SetActorAnimEndNotification(true);
}


if(debugConeBool)
debugCone(DeltaTime);

if(GrappleReplicationHolder.PlayerID.length != 0)
	ClientGrappleReplication();

 
	// if(jumpActive)
	// JumpVelocityPinch(DeltaTime);
	SprintControl(DeltaTime);
	Skel_HeadLookAt(DeltaTime);

	animationControl();
	ServerSetupLightEnvironment();
} 
/*
Skel_HeadLookAt(float fDeltaTime	

*/
function Skel_HeadLookAt(float fDeltaTime)
{
	local TestPawn P;
	local bool found;

	// headcounter+= fDeltaTime;

	// if(headcounter >= 0.1)
	// {
		// headcounter = 0;
		// foreach WorldInfo.AllPawns( class'TestPawn', P )
		// foreach VisibleCollidingActors(class'TestPawn', P, Skel_HeadPawnDetectionRadius, self.Location)
		foreach CollidingActors(class'TestPawn', P, Skel_HeadPawnDetectionRadius, self.Location)
		{
			// if(VSize(P.Location - self.Location) <= Skel_HeadPawnDetectionRadius)
			// {
				// DebugPrint("loc"@P.Location);
				Skel_LookAt.SetTargetLocation(P.Location);
				Skel_LookAt.InterpolateTargetLocation(fDeltaTime);
				Skel_LookAt_Lerp+= 2.5 *fDeltaTime;
				if(Skel_LookAt_Lerp > 1.0) Skel_LookAt_Lerp = 1.0;
				Skel_LookAt.ControlStrength = Skel_LookAt_Lerp;
				found = true;
			// }
		}
		if(!found)
		{
			Skel_LookAt_Lerp -= 2.5 * fDeltaTime;
			if(Skel_LookAt_Lerp < 0) Skel_LookAt_Lerp = 0;
			Skel_LookAt.ControlStrength = Skel_LookAt_Lerp;
		}
	// }
}
/*
SprintControl
	Increases Ground Speed by X% every X Seconds till Cap.
	If any other key is pressed, reset.
*/
function SprintControl(float fDeltaTime)
{
local float fSprintRealBonus;

//If player stopped moving
	if (VSize(Velocity) < 10)
	{

		//If ground speed was modified
		if(GroundSpeed != 280)
		{
			//Reset speed
			GroundSpeed = 280;
			//Reset counter
			fSprintControlCounter = 0;

			DebugPrint("Stopped Moving. GroundSpeed = "@GroundSpeed);
		}
	}
//Player is moving
	else
	{
		// If sprint control is initiated
		// This is determined in EmberPlayerController
		// If ONLY W is pressed, control is enabled. Otherwise disabled
		//----
		// Also use sprint control ONLY if GroundSpeed isn't at maxed
		if(bSprintControl && GroundSpeed < fSprintControlMaxGroundSpeed)
		{
			//Start counting
			fSprintControlCounter += fDeltaTime;
			// If we reached the step limit
			if(fSprintControlCounter >= fSprintControlSecondsTrigger)
				{
					//Convert XX% into number format

					//ex. 20% = 0.2
					fSprintRealBonus = fSprintControlPercentBonus / 100.0f;
					// 0.2 => 1.2
					fSprintRealBonus += 1.0;
					// Speed increased by 20%
					GroundSpeed *= fSprintRealBonus;
					//If it's higher than the limit imposed, set to limit
					if(GroundSpeed > fSprintControlMaxGroundSpeed)
						GroundSpeed = fSprintControlMaxGroundSpeed;

					DebugPrint("Ground Speed Increased to "@GroundSpeed);
					// Reset counter
					fSprintControlCounter = 0;
				}
		}
		// Sprint control is disabled
		else if (!bSprintControl && GroundSpeed != 280)
		{
			//Reset speed
			GroundSpeed = 280;
			//Reset counter
			fSprintControlCounter = 0;
			DebugPrint("SprintControl = False, GroundSpeed = "@GroundSpeed);
		}
	}
}
/*
Flash_InitialUpdates
	Used to run all flash functions that need updating on pawn initiliazation
*/
function Flash_InitialUpdates()
{
	
	Flash_GetWrapper();

	Flash_HealthUpdate();
}
function Flash_GetWrapper()
{
	eHud = EmberHudWrapper(ePC.myHUD);
}
/*
Flash_HealthUpdate
	Updates health of player
*/
function Flash_HealthUpdate()
{
	//If health is below 0, set display to 0
	if(Health < 0) 	eHud.SetVariable(eHud.Tags.Flash_Health, "currentHealth", 0);
	//Otherwise, set display to actual health
	else 			eHud.SetVariable(eHud.Tags.Flash_Health, "currentHealth", Health);
}
/*
enableAnimations
	Unfreezes pawn
*/
simulated function enableAnimations()
{
	CustomTimeDilation = 1.0f;
	Velocity = savedVelocity;
}
reliable server function ServerHitEffectReplicate(int PlayerID, int HitType)
{
	local EmberPawn Receiver;

	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who did the attack
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
			Receiver.ClientHitEffect(HitType);
	}
}
simulated function HitEffectReplicate(EmberPawn hitPawn, int HitType)
{
	//Simulated pawn shit doesn't get replicated
	if(role < ROLE_Authority)
		ServerHitEffectReplicate(hitPawn.PlayerReplicationInfo.PlayerID, HitType);
}
reliable client function ClientHitEffect(int HitType)
{
	local CameraAnim ShakeDatBooty;
	local float shakeAmount;

	switch(HitType)
	{
		//Red
		case 0:
			ShakeDatBooty=CameraAnim'EmberCameraFX.RedShake';
			break;

		//Green
		case 1:
			ShakeDatBooty=CameraAnim'EmberCameraFX.GreenShake';
			break;

		//Blue
		case 1:
			ShakeDatBooty=CameraAnim'EmberCameraFX.BlueShake';
			break;
	}

	  	switch(currentStance)
  	{
  		case 1: shakeAmount = aFramework.lightCameraShake;
  		break;
  		case 2: shakeAmount = aFramework.mediumCameraShake;
  		break;
  		case 3: shakeAmount = aFramework.heavyCameraShake;
  		break;
  	}
  	//Play anim
  	ePC.ClientPlayCameraAnim(ShakeDatBooty, shakeAmount);
  	//Save velocity for after time freeze
  	savedVelocity = Velocity * 0.5;
  	//Time freeze
  	CustomTimeDilation = 0.2f;
  	//Set timer for unfreeze
  	SetTimer(0.002, false, 'enableAnimations');
}
/*
PostInitAnimTree
	Allows custom animations.
*/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// local SkeletalMeshComponent flam;
	// flam = SkeletalMeshComponent'ArtAnimation.Meshes.ember_weapon_heavy';
    //Setting up a reference to our animtree to play custom stuff.
    super.PostInitAnimTree(SkelComp);
    if ( SkelComp == ParentModularComponent)
    {
  		IdleAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('IdleAnimNodeBlendList'));
  		RunAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('RunAnimNodeBlendList'));
  		LeftStrafeAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('LeftStrafeAnimNodeBlendList'));
  		RightStrafeAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('RightStrafeAnimNodeBlendList'));  		
		WalkAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('WalkAnimNodeBlendList'));  		
		wLeftStrafeAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('wLeftStrafeAnimNodeBlendList'));  		
		wRightStrafeAnimNodeBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('wRightStrafeAnimNodeBlendList'));  
		FullBodyBlendList = AnimNodeBlendList(ParentModularComponent.FindAnimNode('FullBodyBlendList'));  		
		JumpAttackSwitch = AnimNodeBlendList(ParentModularComponent.FindAnimNode('JumpAttackSwitch'));  
  		AttackBlend = AnimNodeBlend(ParentModularComponent.FindAnimNode('AttackBlend'));
  		AttackSlot[0] = AnimNodeSlot(ParentModularComponent.FindAnimNode('AttackSlot'));
  		AimNode = AnimNodeAimOffset(ParentModularComponent.FindAnimNode('AimNode'));
  		Skel_LookAt = SkelControlLookAt(ParentModularComponent.FindSkelControl('Skel_LookAt'));

		//Temporary
		DashOverrideSwitch  = AnimNodeBlendList(ParentModularComponent.FindAnimNode('DashOverrideSwitch'));  
  		EmberDash = AnimNodePlayCustomAnim(ParentModularComponent.FindAnimNode('EmberDash'));

  		JumpAttackSwitch.SetActiveChild(1, 0.3);
    }
}

/*
MoveSwordOutOfCollision
	Experiment where player's hand would move if sword is colliding
	Looked bad, atm temporary disabled
	I believe it can be re-enabled ingame by scrolling up on mouse wheel once, then attempting
	to clip the sword through a wall
	pending deletion
*/
simulated function MoveSwordOutOfCollision(float DeltaTime)
{
	// if(IKRightHand_Strength == 0 && DeltaTime > 0)
	IKRightHand_Strength+=(2*DeltaTime);
	if(IKRightHand_Strength > 1) IKRightHand_Strength=1;
	if(IKRightHand_Strength < 0) IKRightHand_Strength=0;
	IKRightHand.SetSkelControlStrength(IKRightHand_Strength, abs(DeltaTime));
	IKLeftHand.SetSkelControlStrength(IKRightHand_Strength, abs(DeltaTime));
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
DrawGrappleCrosshairCalcs

*/
function DrawGrappleCrosshairCalcs()
{
	// DebugPrint("DrawGrappleCrosshairCalcs");
	eHud.enableGrappleCrosshair(bAttackGrapple);
	// eHud.SetVariable(eHud.Tags.Flash_Grapple, "GrapAlphaVar", 0);
}
/*
ToggleChamberZoomShake
	
*/
function ToggleChamberZoomShake()
{
	if(bChamberZoomShake)
	{
		bChamberZoomShake = false;
	  	ePC.ClientPlayCameraAnim(CameraAnim'EmberCameraFX.ChamberShake', 1.7, 0.9, , 0.5);
	}
}
/*
CalcCamera
	Required for modified Third Person
	so much shit here. God I fucking hate this so much, camera's a bitch
 */

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;

   CamStart = Location;
   CurrentCamOffset = CamOffset;



   //Change multipliers here
   DesiredCameraZOffset = (Health > 0) ? 1 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
   CameraZOffset = (fDeltaTime < 0.2) ? DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset : DesiredCameraZOffset;
   
   // if ( Health <= 0 )
   // {
   //    CurrentCamOffset = vect(0,0,0);
   //    CurrentCamOffset.X = GetCollisionRadius();
   // }
	
if(!bAttackGrapple && !bChamberZoom)
{
   	cameraCamZOffsetInterpolation = Lerp(cameraCamZOffsetInterpolation, 30, 3.5*fDeltaTime);
   	cameraCamXOffsetMultiplierInterpolation = Lerp(cameraCamXOffsetMultiplierInterpolation, 3, 3.5*fDeltaTime);
   	cameraCamXOffsetInterpolation = Lerp(cameraCamXOffsetInterpolation, 2.2, 3.5*fDeltaTime);
   	cameraCamYOffsetInterpolation = Lerp(cameraCamYOffsetInterpolation, 1, 3.5*fDeltaTime);
}
if(bAttackGrapple)
{
	cameraCamZOffsetInterpolation = Lerp(cameraCamZOffsetInterpolation, -13, 2*fDeltaTime);
   	cameraCamXOffsetMultiplierInterpolation = Lerp(cameraCamXOffsetMultiplierInterpolation, 3.1, 2*fDeltaTime);
   	cameraCamXOffsetInterpolation = Lerp(cameraCamXOffsetInterpolation, 0.8, 2.5*fDeltaTime);
   	cameraCamYOffsetInterpolation = Lerp(cameraCamYOffsetInterpolation, 2.5, 2.5*fDeltaTime);
}
if (bChamberZoom)
{
	// bChamberZoomShake = true;
	cameraCamZOffsetInterpolation = Lerp(cameraCamZOffsetInterpolation, -13, fDeltaTime/2);
   	cameraCamXOffsetMultiplierInterpolation = Lerp(cameraCamXOffsetMultiplierInterpolation, 3.1, fDeltaTime);
   	cameraCamXOffsetInterpolation = Lerp(cameraCamXOffsetInterpolation, 0.8, fDeltaTime/2);
   	cameraCamYOffsetInterpolation = Lerp(cameraCamYOffsetInterpolation, 1.5, fDeltaTime/2);

   	ToggleChamberZoomShake();
   	if(cameraCamXOffsetInterpolation < 1.0)
   	{
   		bChamberZoom = false;
   		bChamberZoomShake = false;
   		stopAttackQueue();
   	}
}
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
   //Change multipliers here
   // CamDirX *= CurrentCameraScale * 2.2;
CamDirX *= CurrentCameraScale * cameraCamXOffsetInterpolation;
CamDirY *= CurrentCameraScale * cameraCamYOffsetInterpolation;
   CamStart.Z += CameraZOffset + cameraCamZOffsetInterpolation;

   //Pretty neat affect, but need to work on it
   //CamStart.X += -50;

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
   out_CamLoc = CamStart - (CamDirX*CurrentCamOffset.X*cameraCamXOffsetMultiplierInterpolation) + CurrentCamOffset.Y*CamDirY*0.1 + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }
      cameraOutLoc = out_CamLoc;

   return true;
}   

//=============================================
// Debug Functions
//=============================================

/*
RecordTracers - Debug Function
	Plays an animation showing tracers.
	Can change duration that tracers start and end
	@TODO: Tracers end record
	@TODO: Auto save to a script file perhaps?
	pending deletion. Might be used in future
*/
exec function RecordTracers(name animation, float duration, float t1, float t2)
{
	ePC.RecordTracers(animation, duration, duration*t1, duration*t2);
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
	pending deletion
*/
exec function tethermod(float a = 0, float b = 0, float c = 0, float D = 0)
{
	if(a == 0 && b == 0 && c == 0 && d == 0)
	{
		DebugPrint ("goingTowardsHigh -"@goingTowardsHighVelModifier);
		DebugPrint("goingTowardsLow -"@goingTowardsLowVelModifier);
		DebugPrint("goingAway -"@goingAwayVelModifier);
		DebugPrint("tetherlength -"@tetherlength);
		return;
	}
	goingTowardsHighVelModifier = (a != 0) ? a : goingTowardsHighVelModifier;
	goingTowardsLowVelModifier = (b != 0) ? b : goingTowardsLowVelModifier;
	goingAwayVelModifier = (c != 0) ? c : goingAwayVelModifier;
	tetherlength = (d != 0) ? d : tetherlength;
}

/*
doAttackQueue
	Is called everytime left click is pressed
	Essentially attacks. queues for smooth transitions
*/
simulated function doAttackQueue()
{
	local byte currentStringCounter;


	// EmberDash.PlayCustomAnim('ember_jerkoff_block',1.0, 0.3, 0, true);
	// Sword[currentStance-1].GoToState('Blocking');
// bAttackQueueing = true;
// eHud.SetVariable(eHud.Tags.Flash_Grapple, "GrapAlphaVar", 0);
	ePC.ClientStopCameraAnim(CameraAnim'EmberCameraFX.ChamberShake');
	// if(AttackSlot[0].GetCustomAnimNodeSeq().GetTimeLeft() > 0.5 && !AttackAnimationHitTarget)

// if((aFramework.ServerAnimationDuration[AttackAnimationID] - AttackSlot[0].GetCustomAnimNodeSeq().GetTimeLeft()) < aFramework.ServerAnimationTracerEnd[AttackAnimationID] && !AttackAnimationHitTarget)
		// return;
		if(!bCancelPoint && !AttackAnimationHitTarget)
		return;

	iChamberingCounter = 0;
	aFramework.CurrentAttackString++;
	if(aFramework.CurrentAttackString > aFramework.MaxAttacksThatCanBeStringed)
		return;

		DebugPrint("aFramework.CurrentAttackString_DAQ"@aFramework.CurrentAttackString );

	bCancelPoint = false;

	currentStringCounter = aFramework.CurrentAttackString;


	// ClearTimer('AttackEnd');
	// AttackEnd();
	// TracerEnd();
	aFramework.CurrentAttackString = currentStringCounter;

	//ChamberFlags are used for a sort of boolean switch state.
	//Looks bulky, but it utilizes byte shifts, so its actually rather fast
	ChamberFlags.resetLeftChamberFlags();
	ChamberFlags.setLeftChamberFlag(0);
	ChamberFlags.setLeftChamberFlag(2);
// if(GetTimeLeftOnAttack() == 0)
// {
	doAttack(ePC.verticalShift);
// }

}
/*
stopAttackQueue
	called when left click is released
*/
simulated function stopAttackQueue()
{
bAttackQueueing = false;
ChamberFlags.removeLeftChamberFlag(0);

if(ChamberFlags.CheckLeftFlag(1))
{
	if(role < ROLE_Authority)
	ServerChamber(false);
	ChamberGate(false);
}

	ePC.ClientStopCameraAnim(CameraAnim'EmberCameraFX.ChamberShake');
	// EmberDash.PlayCustomAnim('ember_jerkoff_block',-1.0, 0.3, 0, false);
}
/*
isBlock
	simple check to return current sword's status of blocking.
*/
simulated function byte isBlock()
{
	return Sword[currentStance-1].isBlock;
}
/*
doBlock
	ATM does this:
	Moment rightclick is held down, swaps sword's physic asset with the 'block' asset
	moves player to block stance
	freezes at block stance
	when right click is released, swaps sword's physics asset with normal sword asset
	goes back to idle
*/
simulated function doBlock()
{
	//Redoing this because I beleive replication ignores it, if not done at time
	aFramework.SetUpBlockPacket();
//can't copy structs in udk, how lame
ForcedAnimLoopPacket.AnimName=aFramework.ForcedAnimLoopPacket.AnimName;
ForcedAnimLoopPacket.blendIn=aFramework.ForcedAnimLoopPacket.blendIn;
ForcedAnimLoopPacket.blendOut=aFramework.ForcedAnimLoopPacket.blendOut;
ForcedAnimLoopPacket.tDur=aFramework.ForcedAnimLoopPacket.tDur;

//Insert block anim forcecevilbly. Fuck that word
//forcedAnimLoop(true);
//=====================================================================
//Placed it here, cause networking
AttackSlot[0].PlayCustomAnimByDuration(ForcedAnimLoopPacket.AnimName, ForcedAnimLoopPacket.tDur, ForcedAnimLoopPacket.blendIn, 0);
//Can't use GetTimeLeftOnAttack because we are not using a tracer timer
SetTimer(ForcedAnimLoopPacket.tDur, false, 'freezeAttackSlots');
//=====================================================================

//Setup a chamber flag
BlockChamberFlag = BlockChamberFlag | 0x01;

//Cancel timer if active
ClearTimer('AttackEnd');

//=====================================================================
//This segment is part of AttackEnd, without the animation reset
	ChamberFlags.removeLeftChamberFlag(2);
	// JumpAttackSwitch.SetActiveChild(1, 0.3);
    Sword[currentStance-1].SetInitialState();
    Sword[currentStance-1].resetTracers();
    bCancelPoint = true;
	disableMoveInput(false);
    // animationControl();
//End modded AttackEnd
//=====================================================================
Sword[currentStance-1].isBlock = 1;

if(role < ROLE_Authority)
	ServerDoBlock();
}
/*
stopBlock
	Unfreeze body, switch sword physics, block = false
*/
simulated function stopBlock()
{
	//IF chamber is active... i.e. letgo before block was done..
	if((BlockChamberFlag & 0x01) == 0x01)
	{
		//Reset the flag (so it'll stopBlock when block is done)
		BlockChamberFlag = 0;

		return;
	}
EmberReplicationInfo(playerreplicationinfo).Replicate_DoBlock(playerreplicationinfo.PlayerID);
freezeAttackSlots(true, ForcedAnimLoopPacket.blendOut);
swapToBlockPhysics(false);
Sword[currentStance-1].isBlock = 0;
if(role < ROLE_Authority)
	ServerDoBlock();
}

/*
swapToBlockPhysics
	Hardcoded currently. Needs fix
	Swaps between normal sword (does damage) and block (no damage, just block) assets
*/
simulated function swapToBlockPhysics(bool bBlock = true)
{
	Sword[currentStance-1].swapToBlockPhysics(bBlock);
}
/*
freezeAttackSlots
	Only used by doBlock currently. Should be adapted for chambers later
	Freeze's player's upper body animations
*/
simulated function freezeAttackSlots(bool freeze = true, float blendOut = 0.4)
{
		if(!freeze)
		{
			if(BlockChamberFlag == 0)
			{
				freezeAttackSlots();
				return;
			}
			BlockChamberFlag = 0;
			AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=false;
			//AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=false;
			swapToBlockPhysics();
		}
		else
		{
			AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=true;
			//AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=true;	
			AttackSlot[0].StopCustomAnim(blendOut);
			//AttackSlot[1].StopCustomAnim(blendOut);
		}
}
/*
doChamber
	Left click is held long enough by predetermined time
	Freeze animation, prepare for release
*/
simulated function doChamber()
{
	bRightChambering = true;
	iChamberingCounter = 0;
	ChamberFlags.resetRightChamberFlags();
	ChamberFlags.setRightChamberFlag(0);
	DebugPrint("DoCHamber");
	ClearTimer('AttackEnd');
	AttackEnd();
	// if(GetTimeLeftOnAttack() < 0.5)
	// {
	doAttack(ePC.verticalShift);
	// }
}
/*
ChamberGate
	Used by server as well
	Gate in determining weather to freeze or play animation, and notify pawn accordingly
*/
simulated function ChamberGate(bool Active, int ServerAttackAnimationID = -1)
{
		if(Active)
		{
			ChamberFlags.setLeftChamberFlag(1);
			ClearTimer('AttackEnd');
            Sword[currentStance-1].setTracerDelay(0,0);
			Sword[currentStance-1].SetInitialState();
			VelocityPinch.ApplyVelocityPinch(,0,0);
			AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=false;
			SwordEmitterL.LifeSpan = 0;
			SwordEmitterR.LifeSpan = 0;
			bChamberZoomShake=true;
			bChamberZoom = true;
			// //AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=false;
		}
		else
		{
			if(ServerAttackAnimationID != -1) AttackAnimationID = ServerAttackAnimationID;
			iChamberingCounter = 0;
			Sword[currentStance-1].GoToState('Attacking');
            Sword[currentStance-1].setTracerDelay(0,(aFramework.ServerAnimationTracerEnd[AttackAnimationID] - aFramework.ServerAnimationChamberStart[AttackAnimationID]));
			SetTimer((aFramework.ServerAnimationTracerEnd[AttackAnimationID] - aFramework.ServerAnimationChamberStart[AttackAnimationID]), false, 'AttackEnd');	
			VelocityPinch.ApplyVelocityPinch(,0,(aFramework.ServerAnimationTracerEnd[AttackAnimationID] - aFramework.ServerAnimationChamberStart[AttackAnimationID])  * 1.1);
			AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=true;
			
			SwordEmitterL.LifeSpan = (aFramework.ServerAnimationTracerEnd[AttackAnimationID] - aFramework.ServerAnimationChamberStart[AttackAnimationID])  * 1.1;
			SwordEmitterR.LifeSpan = (aFramework.ServerAnimationTracerEnd[AttackAnimationID] - aFramework.ServerAnimationChamberStart[AttackAnimationID])  * 1.1;
			bChamberZoom = false;
			// //AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=true;
		}
}

/*
LeftRightClicksAndChambersManagement
	Should be renamed to LeftClicksAndChambersManagement cause rightclick = block now
	All chamber and byte flag logic is done here primary
	Shit's confusing, i'll comment it out full next time
*/
simulated function LeftRightClicksAndChambersManagement(float DeltaTime)
{	
if(ChamberFlags.CheckLeftFlag(0))
{
	iChamberingCounter += DeltaTime;
	// if(iChamberingCounter >= aFramework.ServerAnimationChamberStart[AttackAnimationID] - playerreplicationinfo.ExactPing)
	if(iChamberingCounter >= aFramework.ServerAnimationChamberStart[AttackAnimationID])
		if(!ChamberFlags.CheckLeftFlag(1))
		{
		if(role < ROLE_Authority)
			ServerChamber(true);
			ChamberGate(true);
		}
}
}

/*
GetTimeLeftOnAttack
	Returns time left on attack timer
*/
simulated function float GetTimeLeftOnAttack()
{
	 return (GetTimerRate('AttackEnd') - GetTimerCount('AttackEnd'));
}
/*
ePlayAnim
	Formally ForcedAnimEnd, this just plays the animations and replicates it
*/
simulated function ePlayAnim(int ServerAttackAnimationID = -1)
{
AttackSlot[0].PlayCustomAnimByDuration(	aFramework.ServerAnimationNames		[AttackAnimationID],
        								aFramework.ServerAnimationDuration	[AttackAnimationID], 
        								aFramework.ServerAnimationFadeIn	[AttackAnimationID], 
        								aFramework.ServerAnimationFadeOut	[AttackAnimationID]);


// native function PlayAnim (bool bLoop, float InRate, float StartTime)
//Server's running the function
if(ServerAttackAnimationID != -1)
	EmberReplicationInfo(PlayerReplicationInfo).copyToServerAttackStruct(ServerAttackAnimationID, PlayerReplicationInfo.PlayerID);

//Client's running the function
if(Role < ROLE_Authority)
	ServerPlayAnim(AttackAnimationID);

}

simulated function ReplicateDamage_Calculated(int DamagePerTracer, Controller DamageInstigator, vector HitLocation, vector TotalKnockback, int PlayerID)
{
	local EmberPawn Receiver;
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who did the attack
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
		{
			Receiver.TakeDamage(DamagePerTracer, DamageInstigator, HitLocation, TotalKnockback,  class'UTDmgType_LinkBeam');
		}
	}
}
//This is for single player only. Might be removed later / merged with below:
simulated function int SinglePlayer_Damage(int Sword_CurrentStance, byte Sword_DamageGroup)
{
	local int TotalGroupDamage;

	switch(Sword_CurrentStance)
	{
		//light
		case 1:
			if(Sword_DamageGroup == 1) TotalGroupDamage = 3;
			if(Sword_DamageGroup == 2) TotalGroupDamage = 4;
			if(Sword_DamageGroup == 3) TotalGroupDamage = 5;
		break;

		//Medium
		case 2:
			if(Sword_DamageGroup == 1) TotalGroupDamage = 4;
			if(Sword_DamageGroup == 2) TotalGroupDamage = 5;
			if(Sword_DamageGroup == 3) TotalGroupDamage = 7;
		break;

		//Heavy
		case 3:
			if(Sword_DamageGroup == 1) TotalGroupDamage = 7;
			if(Sword_DamageGroup == 2) TotalGroupDamage = 9;
			if(Sword_DamageGroup == 3) TotalGroupDamage = 11;
		break;
	}

	return TotalGroupDamage;
}
/*
ReplicateDamage
	This is damage that only networking can access
*/
simulated function ReplicateDamage(int Sword_CurrentStance, byte Sword_DamageGroup, Controller DamageInstigator, vector HitLocation, vector TotalKnockback, int PlayerID)
{
	local int TotalGroupDamage;

switch(Sword_CurrentStance)
{
	//light
	case 1:
		if(Sword_DamageGroup == 1) TotalGroupDamage = 3;
		if(Sword_DamageGroup == 2) TotalGroupDamage = 4;
		if(Sword_DamageGroup == 3) TotalGroupDamage = 5;
	break;

	//Medium
	case 2:
		if(Sword_DamageGroup == 1) TotalGroupDamage = 4;
		if(Sword_DamageGroup == 2) TotalGroupDamage = 5;
		if(Sword_DamageGroup == 3) TotalGroupDamage = 7;
	break;

	//Heavy
	case 3:
		if(Sword_DamageGroup == 1) TotalGroupDamage = 7;
		if(Sword_DamageGroup == 2) TotalGroupDamage = 9;
		if(Sword_DamageGroup == 3) TotalGroupDamage = 11;
	break;
}

if(role < ROLE_Authority)
	ServerReplicateDamage( TotalGroupDamage,  DamageInstigator,  HitLocation,  TotalKnockback,  PlayerID);

}

// tell the server to play them too
reliable server function ServerPlayAnim(int ServerAttackAnimationID)
{
	ePlayAnim(ServerAttackAnimationID);
}
/*
ServerReplicateDamage
	Server sends out damage to player
*/
reliable server function ServerReplicateDamage(int DamagePerTracer, Controller DamageInstigator, vector HitLocation, vector TotalKnockback, int PlayerID)
{
	`Log(PlayerID$" took Damage - "$DamagePerTracer);
	ReplicateDamage_Calculated( DamagePerTracer,  DamageInstigator,  HitLocation,  TotalKnockback,  PlayerID);
}
/*
ServerChamber
	Sends to players if a chamber was activated/deactivated
*/
reliable server function ServerChamber(bool Active)
{
	EmberReplicationInfo(PlayerReplicationInfo).Replicate_Chamber(Active, PlayerReplicationInfo.PlayerID);
	ChamberGate(active);
}

/*
ServerGrappleReplication
	Sends grapple information
*/
reliable server function ServerGrappleReplication(bool Active, int PlayerID, vector hitLocation)
{
	EmberReplicationInfo(PlayerReplicationInfo).Replicate_Grapple(Active, PlayerID, hitLocation);
}
/*
ClientTetherBeamProjectileReplication
	
*/
reliable client function ClientTetherBeamProjectileReplication(vector hitDirection, int PlayerID)
{
	local EmberPawn Receiver;
	local vector projectileSpawnVect;
	local rotator roter;
	local EmberProjectile P;
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who sent the packet
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
		{
			//Get Launch Location
			Receiver.ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('GrappleSocket', projectileSpawnVect, roter);
			//Spawns projectile at GrappleSocket
			P = Spawn(class'EmberProjectile',self,,projectileSpawnVect);
			//We fire projectile along vector
			p.Init(hitDirection);
			return;
		}		
    }
}
/*
ClientGrappleReplication
	Actual replication
	runs per tick
*/
function ClientGrappleReplication()
{
	local int i;
	local vector grappleSocket;
	local ParticleSystemComponent newBeam;

	//While we have more players than beams (i.e. a player just made a beam), create a blank beam:
	while(GrappleReplicationHolder.PlayerID.length > GrappleReplicationHolder.tetherBeams.length)
		{
			switch (TetherBeamType)
			{
				case 1:
			newBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.TetherStraightBeam', vect(0,0,0));
			break;
				case 2:
			newBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.tetherbeam2', vect(0,0,0));
			break;
				case 3:
			newBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.TetherSchizoBeam', vect(0,0,0));
			break;
				default:
				}	
			newBeam.SetHidden(false);
			newBeam.ActivateSystem(true);
			newBeam.bUpdateComponentInTick = true;
			newBeam.SetTickGroup(TG_EffectsUpdateWork);
			GrappleReplicationHolder.tetherBeams.AddItem(newBeam);
			//Set beam end. Since ~most~ Tethers's ends won't move. Set it initially and let be
			updateBeamEnd(GrappleReplicationHolder.TetherProjectileHitLoc[i], i);

		}

	//For every active player beam
	for(i = 0; i < GrappleReplicationHolder.PlayerID.length; i++)
	{
		//Get source location
		GrappleReplicationHolder.gPawn[i].ParentModularComponent.GetSocketWorldLocationAndRotation('GrappleSocket', grappleSocket, r);
		//Update source location
		updateBeamSource(grappleSocket, i);
		//Update End location
		if(GrappleReplicationHolder.AttachedOnEnemy[i] && GrappleReplicationHolder.clientTrackPawn != none)
		{
		TestPawn(GrappleReplicationHolder.clientTrackPawn).mesh.GetSocketWorldLocationAndRotation('GrappleSocket', grappleSocket, r);
			
		updateBeamEnd(grappleSocket, i);
		if(VSize(GrappleReplicationHolder.clientTrackPawn.Location - GrappleReplicationHolder.gPawn[i].Location) < 250)
			ClientReceiveGrappleReplication(false, GrappleReplicationHolder.PlayerID[i], vect(0,0,0));
		}
		// else
		// updateBeamEnd(GrappleReplicationHolder.TetherProjectileHitLoc[i], i);

	}
}
/*
ClientReceiveGrappleReplication
	Receives data to start grapple replication
*/
function ClientReceiveGrappleReplication(bool Active, int PlayerID, vector hitLocation, bool bOnEnemy = false, pawn tPawn = none)
{
	local EmberPawn Receiver;
	local playerreplicationinfo PRI;
	local int i;

	//If grapple replication is canceled (grapple ended)
	if(!Active)
	{
		//Check all player ID's
		for(i = 0; i <GrappleReplicationHolder.PlayerID.length; i++)
		{
			//If we find a match
			if(GrappleReplicationHolder.PlayerID[i] == PlayerID)
			{
				//Remove data
				GrappleReplicationHolder.PlayerID.Remove(i, 1);
				GrappleReplicationHolder.gPawn.Remove(i, 1);
				GrappleReplicationHolder.TetherProjectileHitLoc.Remove(i, 1);
				GrappleReplicationHolder.AttachedOnEnemy.Remove(i,1);
				deactivateTetherBeam(i);
				// DebugPrint("Done"@GrappleReplicationHolder.TetherBeams.length);
				return;
			}
		}
	}
	else
	{
		//Find all local pawns
		ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
		{
			//If one of the pawns has the same ID as the player who sent the packet
			if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
			{
				PRI = Receiver.playerreplicationinfo;
				GrappleReplicationHolder.PlayerID.AddItem(PlayerID);
				GrappleReplicationHolder.gPawn.AddItem(Receiver);
				GrappleReplicationHolder.TetherProjectileHitLoc.AddItem(hitLocation);
				GrappleReplicationHolder.AttachedOnEnemy.AddItem(bOnEnemy);
				if(tPawn!=none)
				GrappleReplicationHolder.clientTrackPawn=tPawn;
				return;
			}	
    	}
	}
}
/*
ClientChamberReplication
	Client replicates chamber gate
*/
reliable client function ClientChamberReplication(bool Active, int PlayerID)
{
	local EmberPawn Receiver;
	local playerreplicationinfo PRI;
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who sent the packet
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
		{
			PRI = Receiver.playerreplicationinfo;
			Receiver.ChamberGate(Active, EmberReplicationInfo(PRI).ServerAttackPacket.ServerAnimAttack);
		}
		
    }
}
/*
ClientAttackAnimReplication
	Client recieves animation and plays it
*/
reliable client function ClientAttackAnimReplication(int AnimAttack, int PlayerID)
{
	local EmberPawn Receiver;
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who did the attack
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
		{
			//Debug Print, Perhaps remove
			DebugPrint(PlayerReplicationInfo.PlayerName@"ClientAttackAnimReplication"@PlayerID);
			//Tell that pawn to do an attack. 
			FlushPersistentDebugLines();
			// Receiver.AttackEnd();
  			Receiver.Sword[Receiver.currentStance-1].setKnockback(aFramework.ServerAnimationKnockback[AnimAttack]);
  			if(!Receiver.ChamberFlags.CheckRightFlag(0))
			{
				Receiver.Sword[Receiver.currentStance-1].GoToState('Attacking');
            	Receiver.Sword[Receiver.currentStance-1].setTracerDelay(aFramework.ServerAnimationTracerStart[AnimAttack], aFramework.ServerAnimationTracerEnd[AnimAttack]);

            	//TODO: Animation Lock
				// if(aFramework.TestLockAnim[0] == AttackPacket.AnimName)
					// SetTimer(AttackPacket.Mods[0], false, 'AttackLock');

				Receiver.VelocityPinch.ApplyVelocityPinch(,aFramework.ServerAnimationTracerStart[AnimAttack], aFramework.ServerAnimationTracerEnd[AnimAttack] * 1.1);
			}

        	Receiver.AttackSlot[0].PlayCustomAnimByDuration(aFramework.ServerAnimationNames		[AnimAttack],
        													aFramework.ServerAnimationDuration	[AnimAttack], 
        													aFramework.ServerAnimationFadeIn	[AnimAttack], 
        													aFramework.ServerAnimationFadeOut	[AnimAttack]);
        	Receiver.setTrailEffects(aFramework.ServerAnimationDuration	[AnimAttack]);
    }
    }
}
/*
ClientBlockReplication
	Client replicates block status
*/
reliable client function ClientBlockReplication(int PlayerID)
{
	local EmberPawn Receiver;
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who did the attack
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
		{
			//Tell that pawn to switch stances
			if(Receiver.isBlock() == 0)
				Receiver.doBlock();
			else
				Receiver.stopBlock();
    	}
    }
}
/*
ServerDoBlock
	Client tells server that it's blocking
*/
reliable server function ServerDoBlock()
{
	EmberReplicationInfo(playerreplicationinfo).Replicate_DoBlock(playerreplicationinfo.PlayerID);
	doBlock();
}
/*
ClientStanceReplication
	Replicates Changestance to clients
*/
reliable client function ClientStanceReplication(int ServerStance, int PlayerID)
{
	local EmberPawn Receiver;
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{
		//If one of the pawns has the same ID as the player who did the attack
		if(Receiver.PlayerReplicationInfo.PlayerID == PlayerID)
		{
			//Tell that pawn to switch stances
			Receiver.ChangeStance(ServerStance);
    	}
    }
}
/*
ClientTakeDamage
	ClientTakes damage
*/
reliable client function ClientTakeDamage(int DamagePerTracer, Controller DamageInstigator, vector HitLocation, vector TotalKnockback,  class<DamageType> DamageType)
{
	DebugPrint("Takes Damage");

	self.TakeDamage(DamagePerTracer, DamageInstigator, HitLocation, TotalKnockback, DamageType);
	//We know its this pawn who's taking damage, we're not replicated other pawns, just dealing damage to ourselves (received from other pawns)
	// self.Health -= DamagePerTracer;
	// Velocity *= TotalKnockback;
	//Not sure what to use the rest for
}
/*
forcedAnimEnd
	Same as OnAnimEnd, but isn't called naturally by UDK. Called forecebiliy by code
*/
simulated function forcedAnimEnd()
{
local float moddedTime;
			AttackBlend.setBlendTarget(0, 0.2);    


	if(aFramework.CurrentAttackString > 1)
		AttackAnimationID += 24;


            
            // AttackSlot[0].PlayCustomAnimByDuration(AttackPacket.AnimName, AttackPacket.Mods[0], AttackPacket.Mods[3], AttackPacket.Mods[4]);

			if(!ChamberFlags.CheckRightFlag(0))
			{
				Sword[currentStance-1].GoToState('Attacking');
				if(AttackAnimationID <= 31)
				{
            		Sword[currentStance-1].setKnockback(aFramework.ServerAnimationKnockback[AttackAnimationID]);
            		Sword[currentStance-1].setTracerDelay(aFramework.ServerAnimationTracerStart[AttackAnimationID], aFramework.ServerAnimationTracerEnd[AttackAnimationID]);
					VelocityPinch.ApplyVelocityPinch(,aFramework.ServerAnimationTracerStart[AttackAnimationID], aFramework.ServerAnimationTracerEnd[AttackAnimationID] * 1.1);
					// SetTimer(aFramework.ServerAnimationDuration[AttackAnimationID], false, 'TracerEnd');
				setTrailEffects(aFramework.ServerAnimationDuration[AttackAnimationID]);
				}
            	else
            	{
            		moddedTime = aFramework.ServerAnimationTracerEnd[AttackAnimationID-24];// - aFramework.ServerAnimationTracerStart[AttackAnimationID-24];
            		Sword[currentStance-1].setTracerDelay(0,moddedTime * 0.9);
					setTrailEffects(moddedTime*0.9);
            	}
            	//TODO: Animation Lock
				// if(aFramework.TestLockAnim[0] == AttackPacket.AnimName)

			}
				

	ePlayAnim();
}

/*
forcedAnimLoop
	Only being used by lock atm
	Forces an animation into the animation cycle
		Can either loop animation for ever, or play once.
*/
simulated function forcedAnimLoop(bool freezeLastFrame = false)
{
			AttackBlend.setBlendTarget(0, 0.2);
            if(!freezeLastFrame)
            {
            AttackSlot[0].PlayCustomAnimByDuration(ForcedAnimLoopPacket.AnimName, ForcedAnimLoopPacket.tDur, ForcedAnimLoopPacket.blendIn, ForcedAnimLoopPacket.blendOut, true);
        	}
            else
            {
            	AttackSlot[0].PlayCustomAnimByDuration(ForcedAnimLoopPacket.AnimName, ForcedAnimLoopPacket.tDur, ForcedAnimLoopPacket.blendIn, 0);
            	//Can't use GetTimeLeftOnAttack because we are not using a tracer timer
				SetTimer(ForcedAnimLoopPacket.tDur, false, 'freezeAttackSlots');	            	
            }
}
/*
forcedAnimEndByParry
	Most likely need to merge w/ forcedAnimLoop
	Overrides animation cycle w/ a parry animation upon parry
*/
simulated function forcedAnimEndByParry()
{
	local int i;

	DebugPrint("ember Pawn forced anim end by parry");

    ClearTimer('attackStop');
    AttackBlend.setBlendTarget(1, 0); 
	SetTimer(0.5, false, 'attackStop');

	i = Rand(Sword[currentStance-1].aParry.ParryNames.length);

	AttackSlot[0].PlayCustomAnimByDuration(Sword[currentStance-1].aParry.ParryNames[i],Sword[currentStance-1].aParry.ParryMods[i], 0, 0, false);
	bCancelPoint = true;
}

//TODO: call ON SPAWN of new Pawn instead of ticks
/*
ServerSetupLightEnvironment
	Sets light environment for all replicated players on client's view
*/
function ServerSetupLightEnvironment()
{
	local EmberPawn Receiver;
	local int i;
	
	//Find all local pawns
	ForEach WorldInfo.AllPawns(class'EmberPawn', Receiver) 
	{		
		if(Receiver == self) continue;

		for(i = 0; i < Receiver.AllMeshs.length; i++)
		{
			if(Receiver.AllMeshs[i].LightEnvironment == none)
			Receiver.AllMeshs[i].setLightEnvironment(self.LightEnvironment);
		}
    }
}
/*
doAttack
	Mastermind of attacks
	gets left click + directional from WASD and determines what attack to use, and executs it
*/
simulated function doAttack( array<byte> byteDirection)
{

	local int totalKeyFlag;

	//TODO: Joke function, toss it out later
	if(enableInaAudio == 1)
	PlaySound(huahs[0]);

	totalKeyFlag = 0;
	savedByteDirection[0] = byteDirection[0];
	savedByteDirection[1] = byteDirection[1];
	savedByteDirection[2] = byteDirection[2];
	savedByteDirection[3] = byteDirection[3];

	
	if((savedByteDirection[0] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[1] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[2] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[3] ^ 1) == 0 ) totalKeyFlag++;

		

	FlushPersistentDebugLines();
	
//If you jump, it'll still do attack as if you were on ground
JumpAttackSwitch.SetActiveChild(0, 0.3);

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
				if((savedByteDirection[2] ^ 1) == 0 ) backAttack(); //S
				if((savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //D
			break;

			//two keys pressed 
			case 2:
				if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) forwardLeftAttack(); //W+A
				else if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) forwardRightAttack(); //W+D
				else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) backLeftAttack(); //S+A
				else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) backRightAttack(); //S+D

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
/*
setTracers
	Sets how many tracers to be drawn along sword
	Very fun to use ingame
*/
exec function setTracers(int tracers)
{
	Sword[currentStance-1].setTracers(tracers);
}

/*
EndPreAttack
	Force's animation end w/ new animation that was copied in copyToAttackStruct
*/
simulated function EndPreAttack()
{
	if(GetTimeLeftOnAttack() <= 0.5)
		forcedAnimEnd();

}
/*
forwardAttack
	Flushes existing debug lines
	Starts playing forward attack animation
	Sets timer for end attack animation
	Sets tracer delay
*/
simulated function forwardAttack()
{
	DebugPrint("fwd -");

	switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightForwardString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumForwardString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavyForwardString1;
		break;
	}

	EndPreAttack();
}
simulated function BackAttack()
{
	DebugPrint("fwd -");

	switch(currentStance) 
	{
		case 1:
		AttackAnimationID = aFramework.lightBackString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumBackString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavyBackString1;
		break;
	}
	EndPreAttack();
}
simulated function backLeftAttack()
{
		switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightbackLeftString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumbackLeftString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavybackLeftString1;
		break;
	}
	EndPreAttack();
}

simulated function backRightAttack()
{
		switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightBackRightString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumbackRightString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavybackRightString1;
		break;
	}
	EndPreAttack();
}
simulated function forwardLeftAttack()
{
		switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightForwardLeftString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumForwardLeftString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavyForwardLeftString1;
		break;
	}
	EndPreAttack();
}

simulated function forwardRightAttack()
{
		switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightForwardRightString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumForwardRightString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavyForwardRightString1;
		break;
	}
	EndPreAttack();
}
/*
rightAttack
	Flushes existing debug lines
	Starts playing rightAttack attack animation
	Sets timer for end attack animation
	Sets tracer delay
*/
simulated function rightAttack()
{
	switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightRightString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumRightString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavyRightString1;
		break;
	}
	EndPreAttack();
}
/*
leftAttack
	Starts playing left attack animation
	Sets timer for end attack animation
	Sets tracer delay
*/
simulated function leftAttack()
{
	switch(currentStance)
	{
		case 1:
		AttackAnimationID = aFramework.lightLeftString1;
		break;

		case 2:
		AttackAnimationID = aFramework.mediumLeftString1;
		break;

		case 3:
		AttackAnimationID = aFramework.heavyLeftString1;
		break;
	}	
	EndPreAttack();
}
/*
AttackLock
	Disabled WASD movement
*/
simulated function AttackLock()
{
	disableMoveInput(true);
	// disableLookInput(true);
}
/*
AttackEnd
	Resets sword, tracers, and idle stance at end of forward attack
*/
simulated function AttackEnd()
{
	if(!bCancelPoint)
		return;
	DebugPrint("AttackEnd");
	ChamberFlags.removeLeftChamberFlag(2);
	JumpAttackSwitch.SetActiveChild(1, 0.3);
	//forwardEmberDash.StopCustomAnim(0);
	// Sword.rotate(0,0,49152);
    Sword[currentStance-1].SetInitialState();
    Sword[currentStance-1].resetTracers();

	disableMoveInput(false);

    // animationControl();
    aFramework.CurrentAttackString = 0;
    DebugPrint("aFramework.CurrentAttackString "@ aFramework.CurrentAttackString );

    if(savedByteDirection[4] == 1)
    {
    	savedByteDirection[4] = 0;
    	doAttack(savedByteDirection);
    }
	AttackAnimationHitTarget = false;
	
}
simulated function TracerEnd()
{
DebugPrint("TracerEnd");
    Sword[currentStance-1].SetInitialState();
    Sword[currentStance-1].resetTracers();

	// disableMoveInput(false);

    // animationControl();	
}
/*
SwordGotHit
	Temporary animation for 'parries'
*/
simulated function SwordGotHit()
{
	forcedAnimEndByParry();
}
/*
animationControl
	When player is idle, pick only one of the random idle animations w/ 0.25 blend
*/
simulated function animationControl()
{
	if(Vsize(Velocity) == 0) 
	{ 
		//Idle
		if(idleBool == false)
		{
			idleBool = true;
			runBool = false;
		 	if(IdleAnimNodeBlendList.BlendTimeToGo <= 0.f)
			 	IdleAnimNodeBlendList.SetActiveChild(currentStance-1, idleBlendTime);

	  		FullBodyBlendList.SetActiveChild(1,idleBlendTime);//Use Full Body Blending
  		}
	}
	else
	{
		if( runBool == false)
		{ 
			idleBool = false;
			runBool = true;
		 	if(RunAnimNodeBlendList.BlendTimeToGo <= 0.f)
	  			{ 
  				//Pick a random idle animation
					RunAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
					RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
					LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
					WalkAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
					wRightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
					wLeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
  				}
  			FullBodyBlendList.SetActiveChild(0,idleBlendTime);//Split body blending at spine
  		}
	}
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
	local vector HitLocation, HitNormal;

	//Do a trace of where the crosshair is facing. Get the HitLocation to tell where the projectile to fire at
	//TODO: setup different distance than 10000
	// Trace(HitLocation, HitNormal,eHUD.OutStart, eHUD.OutStart + eHUD.OutRotation*10000, true); 
	Trace(HitLocation, HitNormal, eHUD.OutStart + eHUD.OutRotation*10000, eHUD.OutStart, true); 
// PlayerOwner.Trace(HitLocation, HitNormal, MouseOrigin + (MouseDir * 100000), MouseOrigin, true);
	
	//If we hit nothing, cancel function
 	if(VSize(HitLocation) == 0)
 	return;

 	bGrappleStopLogicGate.AddItem(false);
 	bGrappleStopLogicGate.AddItem(false);
 	bGrappleStopLogicGate.AddItem(false);

 	//If it would've hit something, but we aleady have an active projectile, cancel function
 	//TODO: Readd
	// if(bTetherProjectileActive)
	// 	return;
	// bTetherProjectileActive = true;

	//Get Launch Location
	ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('GrappleSocket', newLoc, rotat);
	//Spawns projectile at GrappleSocket
	P = Spawn(class'EmberProjectile',self,,newLoc);
	//We setup vector of where it's going to head
	newLoc = normal(HitLocation - newLoc) * 20;
	//We set the owner (custom function) to get OnHit 
	EmberProjectile(p).setProjectileOwner(self);
	//We fire projectile along vector
	p.Init(newLoc);

	if(role < ROLE_Authority)
		ServerTetherBeamProjectile(self.playerreplicationinfo.playerID, newLoc);
}
/*
ServerTetherBeamProjectile
	
*/
reliable server function ServerTetherBeamProjectile(int PlayerID, vector ProjectileDir)
{
	EmberReplicationInfo(playerreplicationinfo).Replicate_TetherBeamProjectile(ProjectileDir, PlayerID);
}
/*
tetherLocationHit
	returns hit and location of tetherBeamProjectile
*/
function tetherLocationHit(vector hitNormal, vector hitLocation, actor Other)
{
	// tetherLocationHit(hit, lol, Other);
	if(ePC.EPressedStatus == 0)
		return;
	projectileHitVector=hitNormal;
	projectileHitLocation=hitLocation;
	// enemyPawn = Other;
	// enemyPawnToggle = (enemyPawn != none) ? true : false;
	`Log("tetherLocationHit");
	detachTether();
	DebugPrint("projectileHitLocation"@projectileHitLocation);
	// GrappleReplicationHolder.TetherProjectileHitLoc.AddItem(projectileHitLocation);
	// ClientReceiveGrappleReplication
	ClientReceiveGrappleReplication(true, self.playerreplicationinfo.PlayerID, hitLocation);
	// createTether();
	ePC.isTethering = true;
	bTetherProjectileActive = false;
	if(role < ROLE_Authority)
		ServerTetherLocationHit(hitNormal, hitLocation, Other);
}

/*
ServerTetherLocationHit
	Tetherhit replicated on server
	same as above function, but without (create tether) visual (saves bandwidth)
*/
reliable server function ServerTetherLocationHit(vector hitNormal, vector hitLocation, actor Other)
{

	// tetherLocationHit(hit, lol, Other);
	projectileHitVector=hitNormal;
	projectileHitLocation=hitLocation;
	// enemyPawn = Other;
	// enemyPawnToggle = (enemyPawn != none) ? true : false;
	`Log("tetherLocationHit");
	ePC.isTethering = true;
	bTetherProjectileActive = false;
	ServerGrappleReplication(true, self.playerreplicationinfo.PlayerID, hitLocation);
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
	local ParticleSystemComponent newBeam;


	//~~~ Trace ~~~

	vc = normal(Vector(ePC.Rotation)) * 50;
	//vc = Owner.Rotation;
	
	extraTether=0;
	

	enemyPawnToggle = enemyPawnToggle ? false : false;
	//state
	 ePC.isTethering = true;
	

	
	newBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.tetherBeam2', vect(0,0,0));
	newBeam.SetHidden(false);
	newBeam.ActivateSystem(true);
	tetherBeam.AddItem(newBeam);

	//Beam Source Point
	ParentModularComponent.GetSocketWorldLocationAndRotation('GrappleSocket', grappleSocket, r);
	updateBeamSource(grappleSocket, 0);
	updateBeamEnd(GrappleReplicationHolder.TetherProjectileHitLoc[0], 0);
}
simulated function debugCone(float deltatime)
{  
 // local Vector HitLocation, HitNormal;
 //   local Vector Start, End, Block;
 //   local rotator bRotate;
 //   local traceHitInfo hitInfo;
 //   local Actor hitActor;
 //        // local float tVel;
 //        local float fDistance;
 //        local vector lVect;
 //        local int i;
 //          local float tCount;
	// local vector v1, v2, swordLoc;
	// local rotator swordRot;
	// Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('EndControl', swordLoc, swordRot);
	// v1 = normal(vector(swordRot)) << rot(0,-8192,0);
	// v2 = normal(vector(swordRot)) << rot(0,8192,0);
	// DrawDebugLine(swordLoc, (v1 * 50)+swordLoc, 0, 0, -1, true);
	// DrawDebugLine(swordLoc, (v2 * 50)+swordLoc, -1, 0, -1, true);



	// Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('EndControl', End);
	// Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
	//     hitActor = Trace(HitLocation, HitNormal,Start, End, true, , hitInfo); 
        	// DebugPrint("hitc~"@hitInfo.HitComponent);
        	// DebugPrint("hitphy~"@hitInfo.PhysMaterial);
        	// DebugPrint("hiti~"@hitInfo.Item );
        	// DebugPrint("hitbone~"@hitInfo.BoneName  );
        	         // DebugPrint("bHitsMat -"@hitInfo.Material);
        // DebugPrint("bHitsPhyMat -"@hitInfo.PhysMaterial );
        // DebugPrint("bHitsItem -"@hitInfo.Item);
        // DebugPrint("bHitsLIndex -"@hitInfo.LevelIndex );
        // DebugPrint("bHitsBone -"@hitInfo.BoneName);
        // if(StaticMeshComponent(HitInfo.HitComponent) != none)
        	// DebugPrint("Static Mesh Hit");
        // if(hitInfo.HitComponent != none)
        // {
        // 	MoveSwordOutOfCollision(DeltaTime);
        // }
        // else
        // 	MoveSwordOutOfCollision(-DeltaTime);

// SetupLightEnvironment

}
/*
GetSword
*/
function sword GetSword()
{
	return Sword[currentStance-1];
}
/*
increaseTether
*/
function increaseTether() 
{
	// if (tetherlength > tetherMaxLength) return;
	// tetherlength += 70;
}
/*
decreaseTether
*/
function decreaseTether() 
{
	// if (tetherlength <= 300) {
	// 	tetherlength = 300;
	// 	return;
	// }
	// tetherlength -= 70;
}
/*
detachTether
*/
function detachTether() 
{
	local int i;

	for(i = 0; i < GrappleReplicationHolder.PlayerID.length; i++)
		{
			if( GrappleReplicationHolder.PlayerID[i] ==  self.playerreplicationinfo.PlayerID)
			{
				if(GrappleReplicationHolder.AttachedOnEnemy[i])
					return;
			}
		}

	ePC.isTethering = false;
	 bTetherProjectileActive = false;

 	bGrappleStopLogicGate.length = 0;
 	Velocity.Z += 100;
 	iGrappleStopCounter=0;
 	if(role < ROLE_Authority)
 	{
 		ClientReceiveGrappleReplication(false, self.playerreplicationinfo.PlayerID, vect(0,0,0));
 		ServerDetachTether();
 	}
 	else
 	{
 		ClientReceiveGrappleReplication(false, self.playerreplicationinfo.PlayerID, vect(0,0,0));
 		ServerGrappleReplication(false, self.playerreplicationinfo.PlayerID, vect(0,0,0));
 	}

}
/*
ServerDetachTether
	
*/
reliable server function ServerDetachTether()
{
	detachTether();
}
/*
createTetherBeam
	Makes a new beam at vector location
*/
simulated function createTetherBeam(vector v1, rotator r1)
{
	local ParticleSystemComponent newBeam;
	newBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.tetherBeam2', v1,r1);
	newBeam.SetHidden(false);
	newBeam.ActivateSystem(true);
	tetherBeam.AddItem(newBeam);
}
/*
updateBeamEnd
*/
simulated function updateBeamEnd(vector projectileHitLocation2, int index)
{
	GrappleReplicationHolder.TetherBeams[index].SetVectorParameter('TetherEnd', projectileHitLocation2);
}
/*
updateBeamSource
*/
simulated function updateBeamSource(vector tVar, int index)
{
	GrappleReplicationHolder.TetherBeams[index].SetVectorParameter('TetherSource', tVar);
}
/*
getBeamEnd
*/
simulated function vector getBeamEnd(int index)
{
	local vector projectileHitLocation2;
	tetherBeam[index].GetVectorParameter('TetherEnd', projectileHitLocation2);
	return projectileHitLocation2;
}
/*
getBeamSource
*/
simulated function vector getBeamSource(int index)
{
	local vector tVar;
	tetherBeam[index].GetVectorParameter('TetherSource', tVar);
	return tVar;
}
/*
getTetherBeams
	returns array of all active tether beams
*/
simulated function array<ParticleSystemComponent> getTetherBeams()
{
	return tetherBeam;
}
/*
deactivateAllTetherBeams
	deletes all tetherbeams
*/
simulated function deactivateAllTetherBeams()
{
	local int i;

	for(i=0; i < GrappleReplicationHolder.TetherBeams.length; i++)
	{
		if(GrappleReplicationHolder.TetherBeams[i] != none)
			{
				GrappleReplicationHolder.TetherBeams[i].SetHidden(true);
				GrappleReplicationHolder.TetherBeams[i].DeactivateSystem();
				GrappleReplicationHolder.TetherBeams[i] = none;
			}
	}
GrappleReplicationHolder.TetherBeams.length = 0;
}
/*
deactivateTetherBeam
	deletes a tetherbeam at specified location
*/
simulated function deactivateTetherBeam(int index)
{
	if(index >= GrappleReplicationHolder.TetherBeams.length)
	return;

		if(GrappleReplicationHolder.TetherBeams[index] != none)
			{
				GrappleReplicationHolder.TetherBeams[index].SetHidden(true);
				GrappleReplicationHolder.TetherBeams[index].DeactivateSystem();
				GrappleReplicationHolder.TetherBeams[index] = none;
			}
			GrappleReplicationHolder.tetherBeams.remove(index,1);
}
/*
createRopeBlock
	Not used. Preped for Biddybam and never used
*/
simulated function GrappleRopeBlock createRopeBlock()
{
  	ropeBlockArray.AddItem(Spawn(class'GrappleRopeBlock', self));	
  	return ropeBlockArray[ropeBlockArray.length-1];
}

/*
getRopeBlocks
	Not used. Preped for Biddybam and never used
*/
simulated function array<GrappleRopeBlock> getRopeBlocks()
{
	return RopeBlockArray;
}
/*
deleteBlock
	Not used. Preped for Biddybam and never used
*/
simulated function deleteBlock(GrappleRopeBlock block)
{
	local GrappleRopeBlock g;
	g = RopeBlockArray[RopeBlockArray.Find(block)];
	RopeBlockArray.RemoveItem(block);
	g.Destroy();
	return;
}
/*
tetherCalcs
	calculations for tether
	runs per tick
*/
reliable server function tetherCalcs() {
	// tetherCalcs();
	local int idunnowhatimdoing;
	// local actor wall;
	local actor testWall;
	local vector hitLoc;
	// local vector hitNormal;  //ignore this shit
	local vector testHitLoc;
	local vector testHitNormal;
	// local vector endLoc;
	// local vector startTraceLoc;
	local vector defaultCheck;

	tetherlength = 200;
	extraTether = 0;

// DebugPrint("v1"@ VSize(Velocity));
	//~~~~~~~~~~~~~~~~~
	//Beam Source Point
	//~~~~~~~~~~~~~~~~~
	//get position of source point on skeletal mesh

	//set this to be any socket you want or create your own socket
	//using skeletal mesh editor in UDK

	//dual weapon point is left hand 
	// self.ParentModularComponent.GetSocketWorldLocationAndRotation('GrappleSocket', vc, r);
	//DrawDebugLine(vc, projectileHitLocation, -1, 0, -1, true);
    // wall = trace(hitLoc, hitNormal, projectileHitLocation, vc);
    // if(extraTether>=1){
    // 	testWall = trace(testHitLoc, testHitNormal, getBeamEnd(extraTether-1), vc);
    // 	if(testWall==none){
    // 		//updateBeamEnd(getBeamEnd(extraTether-1), extraTether); this is not the way
    // 		updateBeamSource(vc, extraTether-1);
    // 		projectileHitLocation=getBeamEnd(extraTether-1);
    // 		deactivateTetherBeam(extraTether);
    // 		extraTether--;

    //    	}
    // }
    // projectileHitLocation=getBeamEnd(extraTether);

    //DebugPrint("hitlog - "@hitLoc==defaultCheck);

	
    	    	// DrawDebugLine(vc, curTargetWall.Location, -1, 0, -1, true);
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//adjust for Skeletal Mesh Socket Rendered/Actual Location tick delay

	//there is a tick delay between the actual socket position
	//and the rendered socket position
	//I encountered this issue when working skeletal controllers
	//my solution is to just manually adjust the actual socket position
	//to match the screen rendered position
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// if falling, lower tether source faster
	// if (vc.z - prevTetherSourcePos.z < 0) {
	// 	vc.z -= 8 * deltaTimeBoostMultiplier;
	// }
	
	// //raising up, raise tether beam faster
	// else {
	// 	vc.z += 8 * deltaTimeBoostMultiplier;
	// }
	
	// //deltaTimeBoostMultipler neutralizes effects of 
	// //fluctuating frame rate / time dilation

	// //update beam based on on skeletal mesh socket
	// if(hitLoc==defaultCheck)
	// {
	// 	updateBeamSource(vc, extraTether);
	// }
	// else
	// {
	// 	updateBeamSource(hitLoc, extraTether);
	// 	createTetherBeam(Location + vect(0, 0, 32) + vc * 48, hitNormalRotator);
	// 	extraTether++;
		
	// 	updateBeamSource(vc, extraTether);
	// 	updateBeamEnd(hitLoc, extraTether);
	// 	projectileHitLocation=hitLoc;
	// 	//work in progress
	// }
	// ParentModularComponent.GetSocketWorldLocationAndRotation('GrappleSocket2', vc2, r);
	
	// //save prev tick pos to see change in position
	// prevTetherSourcePos = vc;
	

	// if(enemyPawn != none)
	// {
	// 	//DebugPrint("tcalc - "@TestPawn(enemyPawn).grappleSocketLocation);
	// 	updateBeamEnd(TestPawn(enemyPawn).grappleSocketLocation, 0);
	// 	//seriously fuck this
	// 	//will deal with this fucking shit later, too complicated for my pleb mind, John
	// }
	
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
		//limit max velocity applied to pawn in direction of tether
		if(vsize(velocity) < 3000 * deltaTimeBoostMultiplier)
		{
			// `Log("1");
			iGrappleStopCounter+=1;
			// if(bGrappleStopLogicGate[1] && iGrappleStopCounter > 5)
				// detachTether();

			bGrappleStopLogicGate[0] = true;

			velocity -= vc2 * (Vsize(vc) * goingTowardsHighVelModifier) * 2;
		}
		}

		//General sequence is 2111111111111111111111111111222222222222111111

		else {
			// `Log("2");
			iGrappleStopCounter++;
			// if(bGrappleStopLogicGate[2]) bGrappleStopLogicGate[1] = true;
			// else bGrappleStopLogicGate[2] = true;
			// if(iGrappleStopCounter > 5)  bGrappleStopLogicGate[1] = true;

			velocity -= vc2 * goingTowardsLowVelModifier * 5;
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

// `Log("3");
				// DebugPrint("going away");
				velocity -= vc2 * (Vsize(vc) * goingTowardsHighVelModifier) * 3;


	}
	// DebugPrint("v2"@ VSize(Velocity));
	// if(iGrappleStopCounter > 5 && VSize(Velocity) <= 10)
	// 	detachTether();
}

/*
SetSwordState
	true = hand, false = nowhere
	pending deletion
*/
exec function SetSwordState(bool inHand)
{
    //setting our sword state.
    SwordState = inHand; 
}
/*
GetSwordState
pending deletion
*/
simulated function bool GetSwordState()
{
    //getting our sword state.
    return SwordState;   
}
/*
PlayAttack
	Play animation at speed
*/
// exec function PlayAttack(name AnimationName, float AnimationSpeed)
// {
//     //The function we use to play our anims
//     //Below goes, (anim name, anim speed, blend in time, blend out time, loop, override all anims)
//     AnimSlot.PlayCustomAnim( AnimationName, AnimationSpeed, 0.00, 0.00, false, true);
// }

/*
JumpVelocityPinch
	pinch's players velocity upon landing
*/
simulated function JumpVelocityPinch(float fDeltaTime)
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
CancelPoint
	
*/
function CancelPoint()
{
	DebugPrint("CancelPoint");
	bCancelPoint = true;
}
//===============================
// Stances Functions
//===============================
simulated function ChangeStance(int newStance, int oldStance = -1)
{
	local vector ssss;
	local rotator r;
	DebugPrint(""@aFramework.CurrentAttackString);
	if(aFramework.CurrentAttackString > 0) return;

	if(oldStance == -1) oldStance = currentStance;

	switch(oldStance)
{
	case 1:
	ParentModularComponent.AttachComponentToSocket(Sword[oldStance-1].Mesh, 'LightAttach');
	break;

	case 2:
	MediumDecoSword.Mesh.AttachComponentToSocket(Sword[oldStance-1].Mesh, 'KattanaSocket');

	break;

	case 3:
	ParentModularComponent.AttachComponentToSocket(Sword[oldStance-1].Mesh, 'HeavyAttach');
	break;
}

ParentModularComponent.AttachComponentToSocket(Sword[newStance-1].Mesh, 'WeaponPoint');
// setTrailEffects();

currentStance = newStance;

EmberReplicationInfo(playerreplicationinfo).Replicate_ServerStance(currentStance, playerreplicationinfo.PlayerID);
			Sword[currentStance-1].mesh.GetSocketWorldLocationAndRotation('StartControl', ssss, r);
switch (TetherBeamType)
			{
				case 1:
			PermaBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.TetherStraightBeam', ssss);
			break;
				case 2:
			PermaBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.tetherbeam2', vect(0,0,0));
			break;
				case 3:
			PermaBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.TetherSchizoBeam', ssss);
			break;
				default:
				}	
			
			PermaBeam.SetHidden(false);
			PermaBeam.ActivateSystem(true);
			PermaBeam.bUpdateComponentInTick = true;
			PermaBeam.SetTickGroup(TG_EffectsUpdateWork);
			//Set beam end. Since ~most~ Tethers's ends won't move. Set it initially and let be
			



overrideStanceChange();

if(Role < ROLE_Authority)
	ServerChangeStance(currentStance, oldStance);

}
reliable server function ServerChangeStance(int ClientCurrentStance, int oldStance)
{
	ChangeStance(ClientCurrentStance);
}
// simulated function ActivateGrappleHook()
// {
// 	bAttackGrapple=true;
// }
/*
SheatheWeapon
	removes weapon
	really old function, needs wip
*/
simulated function SheatheWeapon()
{
	ModularPawn_Cosmetics.ParentModularItem.DetachComponent(Sword[currentStance-1].mesh);
    ModularPawn_Cosmetics.ParentModularItem.DetachComponent(Sword[currentStance-1].CollisionComponent);
} 
/*
overrideStanceChange
	forces animation change
*/
simulated function overrideStanceChange()
{
	IdleAnimNodeBlendList.SetActiveChild(currentStance-1, idleBlendTime);
	RunAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	WalkAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	wRightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	wLeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	Sword[currentStance-1].setStance(currentStance);
}
//===============================
// Console Vars
//===============================

// exec function ep_sword_stance_damages(float l = 0 ,float m = 0, float h = 0)
// {
// 	if(l == 0 && m == 0 && h == 0)
// 	{
// 		DebugPrint("light -"@)
// 	}
// 	if(distance == -3949212)
// 		DebugPrint("Distance till sword block 'parries' opponent. Current Value -"@Sword[currentStance-1].blockDistance);
// 	else
//   		Sword[currentStance-1].blockDistance = distance;
// }
// exec function ep_sword_block_distance(float distance = -3949212)
// {
// 	if(distance == -3949212)
// 		DebugPrint("Distance till sword block 'parries' opponent. Current Value -"@Sword[currentStance-1].blockDistance);
// 	else
//   		Sword[currentStance-1].blockDistance = distance;
// }
// exec function ep_sword_block_cone(float coneDotProductAngle = -3949212)
// {
// 	if(coneDotProductAngle == -3949212)
// 		DebugPrint("DotProductAngle for active block. 0.5 is ~45 degrees. 0 is 90 degrees. Current Value -"@Sword[currentStance-1].blockCone);
// 	else
//   		Sword[currentStance-1].blockCone = coneDotProductAngle;
// }

exec function ep_player_audio_Inathero(float enableAudio_One_or_Zero = -3949212)
{ 
	enableInaAudio = (enableAudio_One_or_Zero == -3949212) ? ModifiedDebugPrint("Inathero's op audio. 1 = on, 0 = off. Current - ", enableInaAudio) : enableAudio_One_or_Zero;
}
exec function ep_debug_tracelines(float tVar = -3949212)
{
	if(tVar == -3949212)
		DebugPrint("Enables Debug Trace Lines. 1 = true; 0 = false. Current Value -"@bTraceLines);
	else
	{
  		if(tVar == 0) bTraceLines = tVar;
  		if(tVar == 1) bTraceLines = tVar;
	}
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
exec function ep_sprintcontrol_seconds_trigger(float tVar = -3949212)
{ 
	fSprintControlSecondsTrigger = (tVar == -3949212) ? ModifiedDebugPrint("Seconds till percent bonus is applied. Current Value -", fSprintControlSecondsTrigger) : tVar;
}
exec function ep_sprintcontrol_max_speed(float tVar = -3949212)
{ 
	fSprintControlMaxGroundSpeed = (tVar == -3949212) ? ModifiedDebugPrint("Max speed possible. Current Value -", fSprintControlMaxGroundSpeed) : tVar;
}
exec function ep_sprintcontrol_percent_bonus(float tVar = -3949212)
{ 
	fSprintControlPercentBonus = (tVar == -3949212) ? ModifiedDebugPrint("percent bonus that is applied. 10% = 10, 25% = 25, 100% = 100, Current Value -", fSprintControlPercentBonus) : tVar;
}
exec function ep_skel_head_trackradius(float tVar = -3949212)
{ 
	Skel_HeadPawnDetectionRadius = (tVar == -3949212) ? ModifiedDebugPrint("Radius to track enemy pawns. Current Value -", Skel_HeadPawnDetectionRadius) : tVar;
}
exec function ep_player_jump_Z(float tVar = -3949212)
{ 
	JumpZ = (tVar == -3949212) ? ModifiedDebugPrint("The vertical lift done to player. AKA how 'High' you go. Current Value -", JumpZ) : tVar;
}
exec function ep_player_jump_boost(float tVar = -3949212)
{ 
	JumpVelocityModifier = (tVar == -3949212) ? ModifiedDebugPrint("Modifier applied to jump velocity. AKA how 'far' you go. Current Value -", JumpVelocityModifier) : tVar;
}
exec function ep_server_animation_duration(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationDuration[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationDuration[Index];
			aFramework.ServerAnimationDuration[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_server_animation_fade_in(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationFadeIn[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationFadeIn[Index];
			aFramework.ServerAnimationFadeIn[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_server_animation_fade_out(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationFadeOut[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationFadeOut[Index];
			aFramework.ServerAnimationFadeOut[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_server_animation_tracer_start(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationTracerStart[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationTracerStart[Index];
			aFramework.ServerAnimationTracerStart[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_server_animation_tracer_end(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationTracerEnd[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationTracerEnd[Index];
			aFramework.ServerAnimationTracerEnd[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_server_animation_knockback(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationKnockback[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationKnockback[Index];
			aFramework.ServerAnimationKnockback[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_server_animation_chamber_start(float Index = -3949212, float NewValue = -239817)
{ 
	local float tVar;
	if(Index == -3949212)
		DebugPrint("Usage: ServerAnimationChamberStart[Index] = NewValue");
		else
		{
			tVar = aFramework.ServerAnimationChamberStart[Index];
			aFramework.ServerAnimationChamberStart[Index] = NewValue;
			DebugPrint("Value changed: "@tVar@" => "@NewValue);
		}
}
exec function ep_player_tether_beam_type(float Index = -3949212)
{ 
	if(Index == -3949212)
		DebugPrint("1 = Straight Beam; 2 = Rama Beam; 3 = Schizo Beam");
		else
		{
			switch (Index)
			{
				case 1:
				case 2:
				case 3:
					TetherBeamType = Index;
			break;
				default:
					
			}
		}
}

// exec function ep_chamber(float t)
// {
// 	AttackPacket.tDur = t;
// }

// exec function ep_player_decoSword_light(int Var1 = -3949212, int Var2 = -3949212, int Var3 = -3949212)
// { 
// 	local int v1, v2, v3;
// 	if(Var1 == -3949212 && Var2 == -3949212 && Var3 == -3949212)
// 	{
// 		DebugPrint("Rotates Light DecoSword. Uses the weird bit angle system. 360 degrees = 65536");
// 		DebugPrint("pitch:"@LightDecoSword.Rotation.pitch);
// 		DebugPrint("yaw:"@LightDecoSword.Rotation.Yaw);
// 		DebugPrint("roll:"@LightDecoSword.Rotation.Roll);
// 	}
// 	else
// 	{
// 		v1 = (Var1 == -3949212) ? LightDecoSword.Rotation.pitch : Var1;
// 		v2 = (Var2 == -3949212) ? LightDecoSword.Rotation.Yaw : Var2;
// 		v3 = (Var3 == -3949212) ? LightDecoSword.Rotation.Roll : Var3;
// 		LightDecoSword.rotate(v1, v2, v3);
// 	}
// 	// -180,45,-180
// }
function float ModifiedDebugPrint(string sMessage, float variable)
{
	DebugPrint(sMessage @ string(variable));
	return variable;
}
function attachReset()
{
	local SkeletalMeshComponent ToBeAttachedItem;
	ToBeAttachedItem = new class'SkeletalMeshComponent';
	ToBeAttachedItem.SetSkeletalMesh(SkeletalMesh'ModularPawn.Meshes.ember_head_01');
	ToBeAttachedItem.SetParentAnimComponent(Mesh);
	AttachComponent(ToBeAttachedItem);
}
defaultproperties
{
	//TODO: find correct values
	// NetUpdateFrequency = 200
	// NetPriority=3
	// Role = ROLE_Authority
	// RemoteRole = ROLE_AutonomousProxy 
	TetherBeamType = 1;
	AttackAnimationHitTarget = true;
	bTraceLines = 1;
	JumpVelocityModifier = 1.5;
Skel_HeadPawnDetectionRadius = 200.0f; //radius for detection

fSprintControlSecondsTrigger = 0.325f; // Step up every 0.325s
fSprintControlMaxGroundSpeed = 500; // Max ground speed = 400
fSprintControlPercentBonus = 2.5; // 2.5% bonus

goingTowardsHighVelModifier = 0.03;
goingTowardsLowVelModifier = 30;
goingAwayVelModifier = 55;

	bAttackGrapple=false;
	blendAttackCounter=0;
	savedByteDirection=(0,0,0,0,0); 
	debugConeBool=false;
	enableInaAudio = 0;
    GroundSpeed=280.0;
    bAlwaysRelevant=true
//SkeletalMesh'ArtAnimation.Meshes.ember_player'
//=============================================
// End Combo / Attack System Vars
//=============================================

	idleBlendTime=0.15f
	runBlendTime=0.15f
	bCanStrafe=false
	SwordState = false
	MultiJumpBoost=1622.0
	CustomGravityScaling = 1.8//1.6
	JumpZ=750//JumpZ=750 //default-322.0
    bCollideActors=True
    bBlockActors=True
    currentStance = 1;

 // Remove normal defined skeletal mesh
  Components.Remove(WPawnSkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=ModularSkeletalMeshComponent    
	SkeletalMesh=SkeletalMesh'ModularPawn.Meshes.ember_head_01'
	PhysicsAsset=PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics'
	AnimtreeTemplate=AnimTree'ArtAnimation.Armature_Tree'
	AnimSets(0)=AnimSet'ArtAnimation.AnimSets.Armature'
	Translation=(Z=-49.8)
    bCacheAnimSequenceNodes=false
    AlwaysLoadOnClient=true
    AlwaysLoadOnServer=true
    CastShadow=true
    BlockRigidBody=true
    bUpdateSkelWhenNotRendered=false
    bIgnoreControllersWhenNotRendered=true
    bUpdateKinematicBonesFromAnimation=true
    bCastDynamicShadow=true
    RBChannel=RBCC_Pawn
    RBCollideWithChannels=(Default=true, Cloth=true, Pawn=true, Vehicle=true, Untitled3=true, BlockingVolume=true)
    LightEnvironment=MyLightEnvironment
    bOverrideAttachmentOwnerVisibility=true
    bAcceptsDynamicDecals=false
    bHasPhysicsAssetInstance=true
    TickGroup=TG_PreAsyncWork
    MinDistFactorForKinematicUpdate=0.2
    bChartDistanceFactor=true
    RBDominanceGroup=20
    bUseOnePassLightingOnTranslucency=true
    bPerBoneMotionBlur=true
  End Object
  ParentModularComponent = ModularSkeletalMeshComponent;
  Components.Add(ModularSkeletalMeshComponent)

	Begin Object Name=CollisionCylinder
		CollisionRadius=0025.00000
		CollisionHeight=0047.5.00000
	End Object
   	Components.Add(CollisionCylinder)

	CollisionComponent=CollisionCylinder
}
