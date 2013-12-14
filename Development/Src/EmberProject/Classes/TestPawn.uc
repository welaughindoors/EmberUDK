class TestPawn extends UTPawn
      placeable;
var(NPC) SkeletalMeshComponent NPCMesh;
// var archetype KActor_Sword SwordArchetype;

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

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetPhysics(PHYS_Walking); // wake the physics up
	
	// set up collision detection based on mesh's PhysicsAsset
	CylinderComponent.SetActorCollision(false, false); // disable cylinder collision
	Mesh.SetActorCollision(true, true); // enable PhysicsAsset collision
	Mesh.SetTraceBlocking(true, true); // block traces (i.e. anything touching mesh)
	// SetTimer(0.5, true, 'BrainTimer');

// SpawnDefaultController();

CreateInventory(class'Custom_Sword',false ); 
// SetTimer(2.0, false, 'WeaponAttach');
}
//      function WeaponAttach()
// {
//            local Vector SocketLocation;
// 	local Rotator SocketRotation;
// 	local KACtor_Sword sword;
	
// 	super.PostBeginPlay();
// 	// AddInventoryItems();
// 	// `Log("Fomor Soldier has been spawned with Inventory"); //debug
	
	
// 	if (Mesh != None)
// 	{
// 		if (SwordArchetype != None && Mesh.GetSocketByName('WeaponPoint') != None)
// 		{
// 			Mesh.GetSocketWorldLocationAndRotation('WeaponPoint', SocketLocation, SocketRotation);
// 			// SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
// 			sword = Spawn(SwordArchetype.class,,, SocketLocation, SocketRotation, SwordArchetype);
			
// 			if (sword != None)
// 			{
// 				sword.SetBase(Self,, Mesh, 'WeaponPoint');
// 			}
// 		}
// 	}




//            // DebugMessagePlayer("SocketName: " $ mesh.GetSocketByName( 'WeaponPoint' ) );
//     // mesh.AttachComponentToSocket(SwordMesh, 'WeaponPoint');
// }

// function BrainTimer()
// {
//   local int OffsetX;
//   local int OffsetY;

//   //make a random offset, some distance away
//   OffsetX = Rand(500)-Rand(500);
//   OffsetY = Rand(500)-Rand(500);

//        //some distance left or right and some distance in front or behind
//     MyTarget.X = Pawn.Location.X + OffsetX;
//     MyTarget.Y = Pawn.Location.Y + OffsetY;
//        //so it doesnt fly up n down
//        MyTarget.Z = Pawn.Location.Z;

//       GoToState('MoveAbout');

// }

// state MoveAbout
// {
// Begin:

//     MoveTo(MyTarget);
// }
// simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
// {
// 	return;
// }
//override so that the corpse will stay.
// simulated State Dying
// {
// ignores OnAnimEnd, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld;

// 	exec simulated function FeignDeath();
// 	reliable server function ServerFeignDeath();
// 	event bool EncroachingOn(Actor Other)
// 	{
// 		// don't abort moves in ragdoll
// 		// return false;
// 		return true;
// 	}

// 	event Timer()
// 	{
// 		local PlayerController PC;
// 		local bool bBehindAllPlayers;
// 		local vector ViewLocation;
// 		local rotator ViewRotation;

// 		// let the dead bodies stay if the game is over
// 		if (WorldInfo.GRI != None && WorldInfo.GRI.bMatchIsOver)
// 		{
// 			LifeSpan = 0.0;
// 			return;
// 		}
// 		//commenting off Destroy so that the bodies will stay
// 		//if ( !PlayerCanSeeMe() )
// 		//{
// 		//	Destroy();
// 		//	return;
// 		//}
// 		// go away if not viewtarget
// 		//@todo FIXMESTEVE - use drop detail, get rid of backup visibility check
// 		bBehindAllPlayers = true;
// 		ForEach LocalPlayerControllers(class'PlayerController', PC)
// 		{
// 			if ( (PC.ViewTarget == self) || (PC.ViewTarget == Base) )
// 			{
// 				if ( LifeSpan < 3.5 )
// 					LifeSpan = 3.5;
// 				SetTimer(2.0, false);
// 				return;
// 			}

// 			PC.GetPlayerViewPoint( ViewLocation, ViewRotation );
// 			if ( ((Location - ViewLocation) dot vector(ViewRotation) > 0) )
// 			{
// 				bBehindAllPlayers = false;
// 				break;
// 			}
// 		}
// 		//if ( bBehindAllPlayers )
// 		//{
// 		//	Destroy();
// 		//	return;
// 		//}
// 		SetTimer(2.0, false);
// 	}
// }

///////////
//RAG DOLL
///////////
//For when the player dies
// function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
// {
// 	if(Super.Died(Killer, DamageType, HitLocation))
// 	{
// 		Super.PlayDying(damageType, HitLocation);
// 		LifeSpan=0;
// 		// Ensure we are always updating kinematic so that it won't go through the ground
// 		Mesh.MinDistFactorForKinematicUpdate = 0.0;

// 		Mesh.SetRBCollidesWithChannel(RBCC_Default,TRUE);
// 		Mesh.ForceSkelUpdate();
// 		Mesh.SetTickGroup(TG_PostAsyncWork);
// 		CollisionComponent = Mesh;

// 		// Turn collision on for skelmeshcomp and off for cylinder
// 		CylinderComponent.SetActorCollision(false, false);
// 		Mesh.SetActorCollision(true, true);
// 		Mesh.SetTraceBlocking(true, true);
// 		SetPhysics(PHYS_RigidBody);
// 		Mesh.PhysicsWeight = 1.0;

// 		// If we had stopped updating kinematic bodies on this character due to distance from camera, force an update of bones now.
// 		if( Mesh.bNotUpdatingKinematicDueToDistance )
// 		{
// 			Mesh.UpdateRBBonesFromSpaceBases(TRUE, TRUE);
// 		}

// 		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);
// 		Mesh.bUpdateKinematicBonesFromAnimation=FALSE;
// 		Mesh.SetRBLinearVelocity(Velocity, false);
// 		// Mesh.SetTranslation(vect(0,0,1) * BaseTranslationOffset);
// 		Mesh.WakeRigidBody();
// 		return true;
// 	}
// 	return false;
// }
Simulated Event Tick(float DeltaTime)
{

	 //GetALocalPlayerController().ClientMessage("tick : " $DeltaTime);
   	 Super.Tick(DeltaTime);
   	 // Velocity = vect(0,0,0);
   	 }
DefaultProperties
{
	NPCMesh=NPCMesh0
	bCollideActors=true
	bPushesRigidBodies=true
	bStatic=False
	bMovable=True
	bAvoidLedges=true
	bStopAtLedges=true
	LedgeCheckThreshold=0.5f
	
	// Begin Object Name=CollisionCylinder
	// // 	// CollisionRadius=+00102.00000
	// // 	// CollisionHeight=+00102.800000
	// 	CollisionRadius=+0070.00000
	// 	CollisionHeight=+0090.00000
	// End Object
   	//Setup default NPC mesh
    Begin Object Class=SkeletalmeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
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


// Begin Object Class=KActor_Sword Name=MyWeaponSkeletalMesh
//     CastShadow=true
//     bCastDynamicShadow=true
//     bOwnerNoSee=false
//     // LightEnvironment=MyLightEnvironment;
//         SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
//         BlockNonZeroExtent=true
// BlockZeroExtent=true
// BlockActors=true
// CollideActors=true
//             BlockZeroExtent=True
//             bHasPhysicsAssetInstance = true
//             bCollideComplex=true
//     // Scale=1.2
//   End Object
//   SwordMesh=MyWeaponSkeletalMesh

	// bRunPhysicsWithNoController=true
	ControllerClass=class'UTGame.UTBot'

}