class Sword extends Actor;
var SkeletalMeshComponent Mesh;

var vector oldStart, oldStart2, oldStart3, oldEnd, oldEnd2, oldEnd3, oldMid;
var bool bTracers, bDidATracerHit, bFuckTheAttack;

var array<Actor> HitArray, HitArray2, HitArray3, HitArray4, HitArray5, HitArray6, HitArray7;
var float tracerCounter, tracerDelay;

var int DamageAmount;

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

function swordParried(actor hitActor)
{
  TestPawn(hitActor).SwordGotHit();
  EmberPawn(Owner).goToIdleMotherfucker();
  tracerCounter = tracerDelay + 1;
  bFuckTheAttack = true;
}

function TraceAttack()
{
   local Actor HitActor;
   local Vector HitLocation, HitNormal, SwordTip, SwordHilt, Momentum;
   local Vector Start, Start2, Start3, Mid, End, End2, End3, bottomBlockControl, tipBlockControl;
   
        local traceHitInfo hitInfo, hitInfo2, hitInfo3, hitInfo4, hitInfo5, hitInfo6, hitInfo7, hitInfo8;
        local Actor HitActor2, HitActor3, HitActor4, HitActor5, HitActor6, HitActor7, HitActor8;

bFuckTheAttack = false;
   Mesh.GetSocketWorldLocationAndRotation('EndControl', SwordTip, );
   Mesh.GetSocketWorldLocationAndRotation('StartControl', SwordHilt, );

    Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
    Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  
    Mesh.GetSocketWorldLocationAndRotation('EndControl 2', End2);  
    Mesh.GetSocketWorldLocationAndRotation('EndControl 3', End3);  
    Mesh.GetSocketWorldLocationAndRotation('StartControl 2', Start2);  
    Mesh.GetSocketWorldLocationAndRotation('StartControl 3', Start3);  
    Mesh.GetSocketWorldLocationAndRotation('MidControl', Mid);  
    Mesh.GetSocketWorldLocationAndRotation('bottomBlockControl', bottomBlockControl);  
    Mesh.GetSocketWorldLocationAndRotation('tipBlockControl', tipBlockControl);  

if(!bTracers)
{
  bTracers = true;
          oldStart = start;
        oldStart2 = start2;
        oldStart3 = start3;
        oldEnd = end;
        oldEnd2 = end2;
        oldEnd3 = end3;
        oldMid = Mid;
}
        bDidATracerHit = false;
        DrawDebugLine(Start, oldStart, -1, 0, -1, true);
        DrawDebugLine(Start, End, -1, 0, -1, true);
        DrawDebugLine(Start2, oldStart2, -1, 0, -1, true);
        DrawDebugLine(Start3, oldStart3, -1, 0, -1, true);
        DrawDebugLine(End, oldEnd, -1, 0, -1, true);
        DrawDebugLine(End2, oldEnd2, -1, 0, -1, true);
        DrawDebugLine(End3, oldEnd3, -1, 0, -1, true);
        DrawDebugLine(Mid, oldMid, -1, 0, -1, true);
        DrawDebugLine(bottomBlockControl, tipBlockControl, -1, 0, -1, true);

        HitActor = Trace(HitLocation, HitNormal, End, oldEnd, true, , hitInfo); 
        HitActor2 = Trace(HitLocation, HitNormal, End2, oldEnd2, true, , hitInfo2); 
        HitActor3 = Trace(HitLocation, HitNormal, End3, oldEnd3, true, , hitInfo3); 
        HitActor4 = Trace(HitLocation, HitNormal, Mid, oldMid, true, , hitInfo4) ;
        HitActor5 = Trace(HitLocation, HitNormal, Start3, oldStart3, true, , hitInfo5); 
        HitActor6 = Trace(HitLocation, HitNormal, Start2, oldStart2, true, , hitInfo6); 
        HitActor7 = Trace(HitLocation, HitNormal, Start, oldStart, true, , hitInfo7); 
        HitActor8 = Trace(HitLocation, HitNormal, bottomBlockControl, tipBlockControl, true, , hitInfo8); 

        oldStart = start;
        oldStart2 = start2;
        oldStart3 = start3;
        oldEnd = end;
        oldEnd2 = end2;
        oldEnd3 = end3;
        oldMid = Mid;

        //@TODO: Even though one of the circles hits sword, other cirlces could hit body asame time, what do.

        // GetALocalPlayerController().ClientMessage("HitActor765: " $HitActor765);
        // GetALocalPlayerController().ClientMessage("hitInfo: " $hitInfo.item );
        // GetALocalPlayerController().ClientMessage("HitActor765: " $HitActor765);
        // GetALocalPlayerController().ClientMessage("HitLocation: " $HitLocation);
        // GetALocalPlayerController().ClientMessage("HitNormal: " $HitNormal);

        // hitInfo.item == 0 ? DebugPrint("SwordHit") : ;
        // hitInfo2.item == 0 ? DebugPrint("SwordHit") : ;

        /*
        hitInfo.item == 0 ? TestPawn(HitActor765).SwordGotHit(): ;
        hitInfo2.item == 0 ? TestPawn(HitActor2).SwordGotHit() : ;
        */
        // if(hitInfo.Item == 0 || hitInfo2.Item == 0 || hitInfo3.Item == 0 || hitInfo4.Item == 0 || hitInfo5.Item == 0 || hitInfo6.Item == 0 || hitInfo7.Item == 0 |)
        // {
        // DebugPrint("SwordHit");
        hitInfo.Item == 0 ? swordParried(HitActor):;
        hitInfo2.Item == 0 ? swordParried(HitActor2):;
        hitInfo3.Item == 0 ? swordParried(HitActor3):;
        hitInfo4.Item == 0 ? swordParried(HitActor4):;
        hitInfo5.Item == 0 ? swordParried(HitActor5):;
        hitInfo6.Item == 0 ? swordParried(HitActor6):;
        hitInfo7.Item == 0 ? swordParried(HitActor7):;
        hitInfo8.Item == 0 ? swordParried(HitActor8):;
        
                DamageAmount = 0;
                // return;
        // }
        // else if (hitInfo2.Item == 0)
        // {

        // DebugPrint("SwordHit");
        //         TestPawn(HitActor2).SwordGotHit();
        // }
        // if(Hitinfo.item == 0)
            // DebugPrint("Sword Hit");
        //Check if the trace collides with an actor.
        if(bFuckTheAttack)
        return;
        if(HitActor != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray.Find(HitActor) == INDEX_NONE && HitActor.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor.TakeDamage(1,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray.AddItem(HitActor);
                bDidATracerHit = true;
                DamageAmount+=1;
                // TestPawn(HitActor).SwordGotHit();
            }
        }
                if(HitActor2 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray2.Find(HitActor2) == INDEX_NONE && HitActor2.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor2.TakeDamage(2,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray2.AddItem(HitActor2);
                bDidATracerHit = true;
                DamageAmount+=2;
                // TestPawn(HitActor2).SwordGotHit();
            }
        }
                if(HitActor3 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray3.Find(HitActor3) == INDEX_NONE && HitActor3.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor3.TakeDamage(3,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray3.AddItem(HitActor3);
                bDidATracerHit = true;
                DamageAmount+=3;
                // TestPawn(HitActor3).SwordGotHit();
            }
        }
                if(HitActor4 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray4.Find(HitActor4) == INDEX_NONE && HitActor4.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor4.TakeDamage(4,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray4.AddItem(HitActor4);
                bDidATracerHit = true;
                DamageAmount+=4;
                // TestPawn(HitActor4).SwordGotHit();
            }
        }
                if(HitActor5 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray5.Find(HitActor5) == INDEX_NONE && HitActor5.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor5.TakeDamage(5,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray5.AddItem(HitActor5);
                bDidATracerHit = true;
                DamageAmount+=5;
                // TestPawn(HitActor5).SwordGotHit();
            }
        }
                if(HitActor6 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray6.Find(HitActor6) == INDEX_NONE && HitActor6.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor6.TakeDamage(6,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray6.AddItem(HitActor6);
                bDidATracerHit = true;
                DamageAmount+=6;
                // TestPawn(HitActor765).SwordGotHit();
            }
        }
                if(HitActor7 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray7.Find(HitActor7) == INDEX_NONE && HitActor7.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor7.TakeDamage(7,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray7.AddItem(HitActor7);
                bDidATracerHit = true;
                DamageAmount+=7;
                // TestPawn(HitActor7).SwordGotHit();
            }
        }
                        if(HitActor8 != none && bDidATracerHit != true)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray.Find(HitActor8) == INDEX_NONE && HitActor8.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor8.TakeDamage(2,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray.AddItem(HitActor8);
                DamageAmount+=2;
                // TestPawn(HitActor8).SwordGotHit();
            }
        }
        if(bDidATracerHit)
        DebugPrint("tDamage -"@DamageAmount);
                bDidATracerHit = false;
}
simulated state Attacking
{
    simulated event Tick(float DeltaTime)
   {
      super.Tick(DeltaTime);
      tracerCounter+= DeltaTime;
      if(tracerCounter >= tracerDelay)
        TraceAttack();
   }
}
function resetTracers()
{
  bTracers = false;
  HitArray.length = 0;
  HitArray2.length = 0;
  HitArray3.length = 0;
  HitArray4.length = 0;
  HitArray5.length = 0;
  HitArray6.length = 0;
  HitArray7.length = 0;
}
function setTracerDelay(float sDelay)
{
  tracerDelay = sDelay;
  tracerCounter = 0;
}
defaultproperties
{
    Begin Object class=SkeletalMeshComponent Name=SwordMesh
        SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
        PhysicsAsset=PhysicsAsset'GDC_Materials.Meshes.SK_ExportSword2_Physics'
        bCacheAnimSequenceNodes=false
       AlwaysLoadOnClient=true
       AlwaysLoadOnServer=true
       CastShadow=true
       BlockRigidBody=true
       bUpdateSkelWhenNotRendered=false
       bIgnoreControllersWhenNotRendered=true
       bUpdateKinematicBonesFromAnimation=true
       bCastDynamicShadow=true
       RBChannel=RBCC_Untitled3
       RBCollideWithChannels=(Untitled3=true)
       //LightEnvironment=MyLightEnvironment
       bOverrideAttachmentOwnerVisibility=true
       bAcceptsDynamicDecals=false
       bHasPhysicsAssetInstance=true
       TickGroup=TG_PreAsyncWork
       MinDistFactorForKinematicUpdate=0.2f
       bChartDistanceFactor=true
       RBDominanceGroup=20
       Scale=0.5
       bAllowAmbientOcclusion=false
       bUseOnePassLightingOnTranslucency=true
       bPerBoneMotionBlur=true
       bOwnerNoSee=false
       BlockActors=true
       BlockZeroExtent=true
       BlockNonZeroExtent=true
       CollideActors=true

Rotation=(Pitch=14000 ,Yaw=0, Roll=49152 )
    End Object
    Mesh = SwordMesh
    Components.Add(SwordMesh)

    Begin Object class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=+060.000000
        CollisionHeight=+065.000000
    End Object
    CollisionComponent = CollisionCylinder
    Components.Add(CollisionCylinder)
}