class TestPawn extends UTPawn
      placeable;
//=============================================
// Mesh and Character Vars
//=============================================
var(NPC) SkeletalMeshComponent NPCMesh;
var() SkeletalMeshComponent SwordMesh;
var SkeletalMesh defaultMesh;
var MaterialInterface defaultMaterial0;
var AnimTree defaultAnimTree;
var array<AnimSet> defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;
var PhysicsAsset defaultPhysicsAsset;
var(NPC) class<AIController> NPCController;
//=================================
// Grappled Hooked
//=================================
var bool 		gHook;
var float 		gHookTimer;
var float 		dTime;
var vector 		gHookTarget;
var pawn 		playerPawn;
var vector 		grappleSocketLocation;

var pawn P;
//=============================================
// Weapon
//=============================================
var Sword Sword;
//=============================================
// Animation
//=============================================
var AnimNodePlayCustomAnim Attack1;
var bool 					defaultDelay;

//For when the player takes damage
// event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
// {
// 	local float tHealth;
// 	GetALocalPlayerController().ClientMessage("tPawn Damage -" $Damage);
// 	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
// 	tHealth = Health - Damage;
// 	Health = FMax(tHealth, 0);
// 	GetALocalPlayerController().ClientMessage("tPawn tHealth -" $tHealth);

// 	WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
// 	if(Health==0)
// 	{
// 		GotoState('Dying');
// 	}
// }
/*
Tick
  Per tick:
  check if hooked
  	if hooked, do hook function
  Get grappleSocketLocation for preperation of hook
*/

Simulated Event Tick(float DeltaTime)
{
	local rotator r;
	
	Super.Tick(DeltaTime);

   		if(gHook)
   		{
	   		dTime = DeltaTime;
   			gHookTimer += DeltaTime;
   			grappleHooked(gHookTarget, playerPawn);
   		}

	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', grappleSocketLocation, r);
}

/*
grappleHooked
	if hooked, pull pawn towards player
	@TODO: Everything. Don't like how shitty this is
*/
function grappleHooked(vector target, pawn player)
{
	local vector hitLoc, hitNormal, endLoc;
	local float floaty2;
	endLoc = player.location;
	gHook = true;
	if(gHook == true && gHookTimer == 0.00)
	{
		// gHookTimer += 0.01;
		gHookTarget = target;
		playerPawn = player;
		Self.trace(hitLoc, hitNormal, endLoc, location );
		floaty2 = VSize(location - endLoc);

		if(floaty2 <= 250) return;

		Velocity = target * 800;

		location.z > 50 ? Velocity.z : Velocity.z = 75;
		// location.z += 10;
		SetPhysics(Phys_Falling );
	}
	// else if(gHookTimer > 0.00 && gHookTimer < 0.5)
	if(gHook == true)
	{
		gHookTarget = target;
		location.z > 50 ? Velocity.z : Velocity.z = 75;

		Self.trace(hitLoc, hitNormal, endLoc, location );
		floaty2 = VSize(location - endLoc);

		//dTime ~ 0.0088
		Velocity = target * 800;// - (gHookTimer * 536.36));
		if(floaty2 <= 250)
		{
			Velocity.z = 0;
			Velocity.x = 0;
			Velocity.y = 0;
			gHookTimer = 0;
			gHook = false;
		}
		// Velocity.Z = 75;
		SetPhysics(Phys_Falling );
	}
}

/*
TakeDamage
	disable DmgType_Crushed, @renable in final?
*/
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local Vector shotDir, ApplyImpulse,BloodMomentum;
		local class<UTDamageType> UTDamage;
		local UTEmit_HitEffect HitEffect;
	
	if(damageType == class'DmgType_Crushed')
		return;

		if ( class'UTGame'.Static.UseLowGore(WorldInfo) )
		{
			if ( !bGibbed )
			{
				UTDamage = class<UTDamageType>(DamageType);
				if (UTDamage != None && ShouldGib(UTDamage))
				{
					bTearOffGibs = true;
					bGibbed = true;
				}
			}
			return;
		}

		// When playing death anim, we keep track of how long since we took that kind of damage.
		if(DeathAnimDamageType != None)
		{
			if(DamageType == DeathAnimDamageType)
			{
				TimeLastTookDeathAnimDamage = WorldInfo.TimeSeconds;
			}
		}

		if (!bGibbed && (InstigatedBy != None || EffectIsRelevant(Location, true, 0)))
		{
			UTDamage = class<UTDamageType>(DamageType);

			// accumulate damage taken in a single tick
			if ( AccumulationTime != WorldInfo.TimeSeconds )
			{
				AccumulateDamage = 0;
				AccumulationTime = WorldInfo.TimeSeconds;
			}
			AccumulateDamage += Damage;

			Health -= Damage;
			if ( UTDamage != None )
			{
				if ( ShouldGib(UTDamage) )
				{
					if ( bHideOnListenServer || (WorldInfo.NetMode == NM_DedicatedServer) )
					{
						bTearOffGibs = true;
						bGibbed = true;
						return;
					}
					SpawnGibs(UTDamage, HitLocation);
				}
				else if ( !bHideOnListenServer && (WorldInfo.NetMode != NM_DedicatedServer) )
				{
					CheckHitInfo( HitInfo, Mesh, Normal(Momentum), HitLocation );
					UTDamage.Static.SpawnHitEffect(self, Damage, Momentum, HitInfo.BoneName, HitLocation);

					if ( UTDamage.default.bCausesBlood && !class'UTGame'.Static.UseLowGore(WorldInfo)
						&& ((PlayerController(Controller) == None) || (WorldInfo.NetMode != NM_Standalone)) )
					{
						BloodMomentum = Momentum;
						if ( BloodMomentum.Z > 0 )
							BloodMomentum.Z *= 0.5;
						HitEffect = Spawn(GetFamilyInfo().default.BloodEmitterClass,self,, HitLocation, rotator(BloodMomentum));
						HitEffect.AttachTo(Self,HitInfo.BoneName);
					}

					if ( (UTDamage.default.DamageOverlayTime > 0) && (UTDamage.default.DamageBodyMatColor != class'UTDamageType'.default.DamageBodyMatColor) )
					{
						SetBodyMatColor(UTDamage.default.DamageBodyMatColor, UTDamage.default.DamageOverlayTime);
					}

					if( (Physics != PHYS_RigidBody) || (Momentum == vect(0,0,0)) || (HitInfo.BoneName == '') )
						return;

					shotDir = Normal(Momentum);
					ApplyImpulse = (DamageType.Default.KDamageImpulse * shotDir);

					if( UTDamage.Default.bThrowRagdoll && (Velocity.Z > -10) )
					{
						ApplyImpulse += Vect(0,0,1)*DamageType.default.KDeathUpKick;
					}
					// AddImpulse() will only wake up the body for the bone we hit, so force the others to wake up
					Mesh.WakeRigidBody();
					Mesh.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName, true);
				}
			}
		}

	WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
	Health = FMax(Health, 0);	
	if(Health==0)
	{
		GotoState('Dying');
	}
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
    	Attack1 = AnimNodePlayCustomAnim(Mesh.FindAnimNode('CustomAttack'));
    }

}

/*
PostBeginPlay
*/
simulated function PostBeginPlay()
{
	 //  if(NPCController != none)
  // {
  //   // set the existing ControllerClass to our new NPCController class
  //   ControllerClass = NPCController;
  // }  
	super.PostBeginPlay();

	SetPhysics(PHYS_Walking); // wake the physics up
	
	// set up @collision @detection based on mesh's PhysicsAsset
	// CylinderComponent.SetActorCollision(false, false); // disable cylinder collision
	// Mesh.SetActorCollision(true, true); // enable PhysicsAsset collision
	// Mesh.SetTraceBlocking(true, true); // block traces (i.e. anything touching mesh)
	// SetTimer(0.5, true, 'BrainTimer');
	SetTimer(0.1, false, 'WeaponAttach');

}

/*
WeaponAttach
	Attachs Sword.uc to pawn
*/
function WeaponAttach()
{
	 Sword = Spawn(class'Sword', self);
	 Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
}


/*
Dying
	Queued Deletion
*/
//override so that the corpse will stay.
//^ not made by @Inathero
simulated State Dying
{
ignores OnAnimEnd, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld;
	exec simulated function FeignDeath();
	reliable server function ServerFeignDeath();
	event bool EncroachingOn(Actor Other)
	{
		// don't abort moves in ragdoll
		// return false;
		return true;
	}

	event Timer()
	{
		local PlayerController PC;
		// local bool bBehindAllPlayers;
		local vector ViewLocation;
		local rotator ViewRotation;
		Destroy();

		// let the dead bodies stay if the game is over
		if (WorldInfo.GRI != None && WorldInfo.GRI.bMatchIsOver)
		{
			LifeSpan = 0.0;
			return;
		}
		//commenting off Destroy so that the bodies will stay
		//if ( !PlayerCanSeeMe() )
		//{
		//	Destroy();
		//	return;
		//}
		// go away if not viewtarget
		//@todo FIXMESTEVE - use drop detail, get rid of backup visibility check
		//bBehindAllPlayers = true;
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			if ( (PC.ViewTarget == self) || (PC.ViewTarget == Base) )
			{
				if ( LifeSpan < 3.5 )
					LifeSpan = 3.5;
				SetTimer(2.0, false);
				return;
			}

			PC.GetPlayerViewPoint( ViewLocation, ViewRotation );
			if ( ((Location - ViewLocation) dot vector(ViewRotation) > 0) )
			{
				// bBehindAllPlayers = false;
				break;
			}
		}
		//if ( bBehindAllPlayers )
		//{
		//	Destroy();
		//	return;
		//}
		SetTimer(2.0, false);
	}
}
/*
SwordGotHit
	Pending parry animation
	@TODO: Allow this function to be available only
	when pawn is doing an attack. Otherwise swords act
	as perma block mode.
*/
function SwordGotHit()
{
    GetALocalPlayerController().ClientMessage("Faggot hit my sword!");
    Sword.SetInitialState();
    Sword.attackIsActive = false;
    Attack1.PlayCustomAnimByDuration('ember_jerkoff_block',0.1, 0, 0, false);
}

/*
doAttack
	Used for attack tests
*/
function doAttack (name animation, float duration, float t1, float t2) 
{
	 Sword = Spawn(class'Sword', self);
	 Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
	Attack1.PlayCustomAnimByDuration(animation,duration, 0.2, 0, false);
	Sword.setTracerDelay(t1,t2);
    // Sword.GoToState('AttackingNoTracers');
    Sword.GoToState('Attacking');
	SetTimer(duration, false, 'attackStop');
}

/*
attackStop
	reset Sword status
*/
function attackStop()
{
	// Sword.rotate(0,0,49152);
    Sword.SetInitialState();
    Sword.resetTracers();
}
/*
doAttackRecording
	Used for tracer recording
*/

function doAttackRecording (name animation, float duration, float t1, float t2) 
{
	 Sword = Spawn(class'Sword', self);
	 Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
	Attack1.PlayCustomAnimByDuration(animation,duration, 0.5, 0, false);
	Sword.setTracerDelay(t1,t2);
    Sword.GoToState('Attacking');
	SetTimer(duration, false, 'AttackRecordingFinished');
}
/*
AttackRecordingFinished
	Delete this pawn instance
*/
function AttackRecordingFinished()
{
		Sword.Destroy();
		Destroy();
}
/*
SetCharacterClassFromInfo
	Used to set info for pawn
*/
simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
// Mesh.SetSkeletalMesh(defaultMesh);
// Mesh.SetMaterial(0,defaultMaterial0);
// Mesh.SetPhysicsAsset(defaultPhysicsAsset);
// Mesh.AnimSets=defaultAnimSet;
}

//Zombie shit
// simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
// {
//  `Log("Bump");

//      Super.Bump( Other, OtherComp, HitNormal );

// 	if ( (Other == None) || Other.bStatic )
// 		return;

//   P = Pawn(Other); //the pawn we might have bumped into

// 	if ( P != None)  //if we hit a pawn
// 	{
//             if (P.Health >1) //as long as pawns health is more than 1
// 	   {
//              P.Health --; // eat brains! mmmmm
//            }
//         }
// }
/*
goToIdleMotherfucker
	Temporary animation for 'parries'
*/
function goToIdleMotherfucker()
{
Sword.SetInitialState();
Attack1.PlayCustomAnimByDuration('ember_idle_2',0.1, 0.2, 0, false);
}

DefaultProperties
{
defaultMesh=SkeletalMesh'ArtAnimation.Meshes.ember_base'
defaultAnimTree=AnimTree'ArtAnimation.Armature_Tree'
defaultAnimSet(0)=AnimSet'ArtAnimation.AnimSets.Armature'
defaultPhysicsAsset=PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics'
	bCollideActors=true
	bPushesRigidBodies=true
	bStatic=False
	bMovable=True
	bAvoidLedges=true
	bStopAtLedges=true
	LedgeCheckThreshold=0.5f
	Health = 250
	
	Begin Object Name=CollisionCylinder
	// // 	// CollisionRadius=+00102.00000
	// // 	// CollisionHeight=+00102.800000
		CollisionRadius=0025.00000
		CollisionHeight=0047.5.00000
	End Object
   Components.Add(CollisionCylinder)

   	//Setup default NPC mesh
    Begin Object Class=SkeletalmeshComponent Name=NPCMesh0
// SkeletalMesh=SkeletalMesh'ArtAnimation.Meshes.ember_base'

SkeletalMesh=SkeletalMesh'ArtAnimation.Meshes.ember_player'
AnimtreeTemplate=AnimTree'ArtAnimation.Armature_Tree'
AnimSets(0)=AnimSet'ArtAnimation.AnimSets.Armature'
PhysicsAsset=PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics'
		LightEnvironment=MyLightEnvironment
		BlockRigidBody=TRUE
		MinDistFactorForKinematicUpdate=0.0
		bChartDistanceFactor=true
		bHasPhysicsAssetInstance=true
		bEnableFullAnimWeightBodies=true
		CastShadow=true
		Scale=1.0
		BlockZeroExtent=true
		PhysicsWeight=1.0
    End Object
   Mesh=NPCMesh0
   Components.Add(NPCMesh0)


// Begin Object Class=SkeletalmeshComponent Name=MyWeaponSkeletalMesh
//     CastShadow=true
//     bCastDynamicShadow=true
//     bOwnerNoSee=false
//     // LightEnvironment=MyLightEnvironment;
//         SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
//         BlockNonZeroExtent=true
//         BlockZeroExtent=true
//         BlockActors =true
//         CollideActors=true
//     // Scale=1.2
//   End Object
//   SwordMesh=MyWeaponSkeletalMesh

// 	Components.Add(MyWeaponSkeletalMesh)
	CollisionComponent=CollisionCylinder
	RagdollLifespan=180.0
	// bRunPhysicsWithNoController=true
	ControllerClass=class'TestPawnController'
}