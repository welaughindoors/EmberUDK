class Sword extends Actor;
var SkeletalMeshComponent Mesh;

var vector oldStart, oldStart2, oldStart3, oldEnd, oldEnd2, oldEnd3, oldMid;
var bool bTracers;

var array<Actor> HitArray;
var float tracerCounter, tracerDelay;

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

function TraceAttack()
{
   local Actor HitActor;
   local Vector HitLocation, HitNormal, SwordTip, SwordHilt, Momentum;
   local Vector Start, Start2, Start3, Mid, End, End2, End3;
   local int DamageAmount;
        local traceHitInfo hitInfo, hitInfo2;
        local Actor HitActor2;

   Mesh.GetSocketWorldLocationAndRotation('EndControl', SwordTip, );
   Mesh.GetSocketWorldLocationAndRotation('StartControl', SwordHilt, );

    Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
    Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  
    Mesh.GetSocketWorldLocationAndRotation('EndControl 2', End2);  
    Mesh.GetSocketWorldLocationAndRotation('EndControl 3', End3);  
    Mesh.GetSocketWorldLocationAndRotation('StartControl 2', Start2);  
    Mesh.GetSocketWorldLocationAndRotation('StartControl 3', Start3);  
    Mesh.GetSocketWorldLocationAndRotation('MidControl', Mid);  

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
        DrawDebugLine(Start, oldStart, -1, 0, -1, true);
        DrawDebugLine(Start2, oldStart2, -1, 0, -1, true);
        DrawDebugLine(Start3, oldStart3, -1, 0, -1, true);
        DrawDebugLine(End, oldEnd, -1, 0, -1, true);
        DrawDebugLine(End2, oldEnd2, -1, 0, -1, true);
        DrawDebugLine(End3, oldEnd3, -1, 0, -1, true);
        DrawDebugLine(Mid, oldMid, -1, 0, -1, true);

        HitActor = Trace(HitLocation, HitNormal, End, Mid, true, , hitInfo); 
        HitActor2 = Trace(HitLocation, HitNormal, Start, Mid, true, , hitInfo2); 

        oldStart = start;
        oldStart2 = start2;
        oldStart3 = start3;
        oldEnd = end;
        oldEnd2 = end2;
        oldEnd3 = end3;
        oldMid = Mid;



        // GetALocalPlayerController().ClientMessage("hitActor: " $HitActor);
        // GetALocalPlayerController().ClientMessage("hitInfo: " $hitInfo.item );
        // GetALocalPlayerController().ClientMessage("hitActor: " $HitActor);
        // GetALocalPlayerController().ClientMessage("HitLocation: " $HitLocation);
        // GetALocalPlayerController().ClientMessage("HitNormal: " $HitNormal);

        // hitInfo.item == 0 ? DebugPrint("SwordHit") : ;
        // hitInfo2.item == 0 ? DebugPrint("SwordHit") : ;

        /*
        hitInfo.item == 0 ? TestPawn(HitActor).SwordGotHit(): ;
        hitInfo2.item == 0 ? TestPawn(HitActor2).SwordGotHit() : ;
        */
        if(hitInfo.Item == 0)
        {
        DebugPrint("SwordHit");
                TestPawn(HitActor).SwordGotHit();
        }
        else if (hitInfo2.Item == 0)
        {

        DebugPrint("SwordHit");
                TestPawn(HitActor2).SwordGotHit();
        }
        // if(Hitinfo.item == 0)
            // DebugPrint("Sword Hit");
        //Check if the trace collides with an actor.
        if(HitActor != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray.Find(HitActor) == INDEX_NONE && HitActor.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor.TakeDamage(15,
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray.AddItem(HitActor);
                // TestPawn(HitActor).SwordGotHit();
            }
        }
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

Rotation=(Pitch=0 ,Yaw=0, Roll=49152 )
    End Object
    Mesh = SwordMesh
    Components.Add(SwordMesh)

    Begin Object class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=+030.000000
        CollisionHeight=+015.000000
    End Object
    CollisionComponent = CollisionCylinder
    Components.Add(CollisionCylinder)
}