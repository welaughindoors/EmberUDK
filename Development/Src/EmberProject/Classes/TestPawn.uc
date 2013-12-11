class TestPawn extends UTPawn
      placeable;
var(NPC) SkeletalMeshComponent NPCMesh;

//For when the player takes damage
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	Health = FMax(Health - Damage, 0);
	WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
	if(Health==0)
	{
		GotoState('Dying');
	}
}
//override so that the corpse will stay.
simulated State Dying
{
ignores OnAnimEnd, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld;

	exec simulated function FeignDeath();
	reliable server function ServerFeignDeath();
	event bool EncroachingOn(Actor Other)
	{
		// don't abort moves in ragdoll
		return false;
	}

	event Timer()
	{
		local PlayerController PC;
		local bool bBehindAllPlayers;
		local vector ViewLocation;
		local rotator ViewRotation;

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
		bBehindAllPlayers = true;
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
				bBehindAllPlayers = false;
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

///////////
//RAG DOLL
///////////
//For when the player dies
function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if(Super.Died(Killer, DamageType, HitLocation))
	{
		Super.PlayDying(damageType, HitLocation);
		LifeSpan=0;
		// Ensure we are always updating kinematic so that it won't go through the ground
		Mesh.MinDistFactorForKinematicUpdate = 0.0;

		Mesh.SetRBCollidesWithChannel(RBCC_Default,TRUE);
		Mesh.ForceSkelUpdate();
		Mesh.SetTickGroup(TG_PostAsyncWork);
		CollisionComponent = Mesh;

		// Turn collision on for skelmeshcomp and off for cylinder
		CylinderComponent.SetActorCollision(false, false);
		Mesh.SetActorCollision(true, true);
		Mesh.SetTraceBlocking(true, true);
		SetPhysics(PHYS_RigidBody);
		Mesh.PhysicsWeight = 1.0;

		// If we had stopped updating kinematic bodies on this character due to distance from camera, force an update of bones now.
		if( Mesh.bNotUpdatingKinematicDueToDistance )
		{
			Mesh.UpdateRBBonesFromSpaceBases(TRUE, TRUE);
		}

		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);
		Mesh.bUpdateKinematicBonesFromAnimation=FALSE;
		Mesh.SetRBLinearVelocity(Velocity, false);
		Mesh.SetTranslation(vect(0,0,1) * BaseTranslationOffset);
		Mesh.WakeRigidBody();
		return true;
	}
	return false;
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
	
	Begin Object Name=CollisionCylinder
		// CollisionRadius=+00102.00000
		// CollisionHeight=+00102.800000
		CollisionRadius=+0070.00000
		CollisionHeight=+0090.00000
	End Object
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

	bRunPhysicsWithNoController=true

}