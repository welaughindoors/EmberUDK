class Sword extends Actor;
var SkeletalMeshComponent Mesh;


//=============================================
// Previous Socket Saved Positions
//=============================================
var vector oldStart, oldStart2, oldStart3, oldEnd, oldEnd2, oldEnd3, oldMid;

//=============================================
// Utility Booleans for Tracers
//=============================================
var bool bTracers, bDidATracerHit, bFuckTheAttack;

//=============================================
// Each tracer to trace only once per attack
// @TODO: Merge into one?
//=============================================
var array<Actor> HitArray, HitArray2, HitArray3, HitArray4, HitArray5, HitArray6, HitArray7;

//=============================================
// Tracer Delay Vars
//=============================================
var float tracerCounter, tracerStartDelay, tracerEndDelay;

//=============================================
// Debug Var
//=============================================
var float DamageAmount;

//=============================================
// Induce Lag
//=============================================
var float inducedLag;

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

//=============================================
// Simulated States
//=============================================

/*
Attacking
  Activating this state in EmberPawn when doing attack animation
  Essentially "wakes" up Sword class to become active
  @TODO: Perhaps simplify the two if statements
*/
simulated state Attacking
{
    simulated event Tick(float DeltaTime)
   {
      super.Tick(DeltaTime);
      tracerCounter+= DeltaTime;
      inducedLag += DeltaTime;
      if(tracerEndDelay == 0)
      {
      if(tracerCounter >= tracerStartDelay && inducedLag >= 0)
      //To simulate lag, take the lag you want, divide by two and put it to the right of inducedLag
      //ex. want 40ms lag? then change above to inducedLag >= 0.02
      //number right of inducedLag is in seconds, so need to convert ms to seconds (0.02s = 20ms)
      {
        inducedLag = 0;
        TraceAttack();
      }
    }
    //Else if there's no end tracer delay, don't check for it
    else
    {
       if(tracerCounter >= tracerStartDelay && tracerCounter <= tracerEndDelay && inducedLag >= 0)
      //To simulate lag, take the lag you want, divide by two and put it to the right of inducedLag
      //ex. want 40ms lag? then change above to inducedLag >= 0.02
      //number right of inducedLag is in seconds, so need to convert ms to seconds (0.02s = 20ms)
      {
        inducedLag = 0;
        TraceAttack();
      }      
    }
   }
}

//=============================================
// Custom States
//=============================================

/*
swordParried
  Activated when a tracer hits target's sword
  Gets actor, tells it its sword got hit
  Tells owner of this sword to stop attack animation
  Tells sword to reset state.
*/
function swordParried(actor hitActor)
{
  TestPawn(hitActor).SwordGotHit();
  EmberPawn(Owner).goToIdleMotherfucker();
  tracerCounter = tracerStartDelay + 1;
  bFuckTheAttack = true;
  SetInitialState();
}

/*
TraceAttack
  Gets current tracers (current tick) and previous tracers (last tick)
  does traces on them
  if sword is hit -> swordParried()
  else if actor is hit -> do damage
  damage scales w/ velocity and tracer that was used
  @TODO: Make this cleaner and smarter and more compact
*/
function TraceAttack()
{

   local Actor HitActor;
   local Vector HitLocation, HitNormal, SwordTip, SwordHilt;
   local Vector Start, Start2, Start3, Mid, End, End2, End3, bottomBlockControl, bottomBlockControl2, tipBlockControl, tipBlockControl2, tipBlockControl3;
   
        local traceHitInfo hitInfo, hitInfo2, hitInfo3, hitInfo4, hitInfo5, hitInfo6, hitInfo7, hitInfo8, hitInfo9, hitInfo10, hitInfo11;
        local Actor HitActor2, HitActor3, HitActor4, HitActor5, HitActor6, HitActor7, HitActor8, HitActor9, HitActor10, HitActor11;
        local float tVel;

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
    Mesh.GetSocketWorldLocationAndRotation('tipBlockControl2', tipBlockControl2); 
    Mesh.GetSocketWorldLocationAndRotation('tipBlockControl3', tipBlockControl3); 
    Mesh.GetSocketWorldLocationAndRotation('bottomBlockControl2', bottomBlockControl2); 

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
        // DrawDebugLine(Start, End, -1, 0, 0, true);

        DrawDebugLine(Start, oldStart, -1, 0, -1, true);
        DrawDebugLine(Start2, oldStart2, -1, 0, -1, true);
        DrawDebugLine(Start3, oldStart3, -1, 0, -1, true);
        DrawDebugLine(End, oldEnd, -1, 0, -1, true);
        DrawDebugLine(End2, oldEnd2, -1, 0, -1, true);
        DrawDebugLine(End3, oldEnd3, -1, 0, -1, true);
        DrawDebugLine(Mid, oldMid, -1, 0, -1, true);

        DrawDebugLine(bottomBlockControl, tipBlockControl, 127, -1, 212, true);
        DrawDebugLine(tipBlockControl, tipBlockControl2, 127, -1, 212, true);
        DrawDebugLine(tipBlockControl3, tipBlockControl2, 127, -1, 212, true);
        DrawDebugLine(tipBlockControl3, tipBlockControl, 127, -1, 212, true);

        tVel = VSize(End - oldEnd);

        HitActor = Trace(HitLocation, HitNormal, End, oldEnd, true, , hitInfo); 
        HitActor2 = Trace(HitLocation, HitNormal, End2, oldEnd2, true, , hitInfo2); 
        HitActor3 = Trace(HitLocation, HitNormal, End3, oldEnd3, true, , hitInfo3); 
        HitActor4 = Trace(HitLocation, HitNormal, Mid, oldMid, true, , hitInfo4) ;
        HitActor5 = Trace(HitLocation, HitNormal, Start3, oldStart3, true, , hitInfo5); 
        HitActor6 = Trace(HitLocation, HitNormal, Start2, oldStart2, true, , hitInfo6); 
        HitActor7 = Trace(HitLocation, HitNormal, Start, oldStart, true, , hitInfo7); 
        HitActor8 = Trace(HitLocation, HitNormal, bottomBlockControl, tipBlockControl, true,, hitInfo8); 
        HitActor9 = Trace(HitLocation, HitNormal, tipBlockControl, tipBlockControl2, true, , hitInfo9); 
        HitActor10 = Trace(HitLocation, HitNormal, tipBlockControl2, tipBlockControl3, true, , hitInfo10); 
        HitActor11 = Trace(HitLocation, HitNormal, bottomBlockControl, tipBlockControl3, true, , hitInfo11); 

        oldStart = start;
        oldStart2 = start2;
        oldStart3 = start3;
        oldEnd = end;
        oldEnd2 = end2;
        oldEnd3 = end3;
        oldMid = Mid;

        //@TODO: Even though one of the circles hits sword, other cirlces could hit body asame time, what do.

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
        hitInfo9.Item == 0 ? swordParried(HitActor9):;
        hitInfo10.Item == 0 ? swordParried(HitActor10):;
        hitInfo11.Item == 0 ? swordParried(HitActor11):;
        
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
                HitActor.TakeDamage(1 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray.AddItem(HitActor);
                bDidATracerHit = true;
                DamageAmount+=1 + (tVel * 0.165);
                // TestPawn(HitActor).SwordGotHit();
            }
        }
                if(HitActor2 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray2.Find(HitActor2) == INDEX_NONE && HitActor2.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor2.TakeDamage(2 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray2.AddItem(HitActor2);
                bDidATracerHit = true;
                DamageAmount+=2 + (tVel * 0.165);
                // TestPawn(HitActor2).SwordGotHit();
            }
        }
                if(HitActor3 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray3.Find(HitActor3) == INDEX_NONE && HitActor3.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor3.TakeDamage(3 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray3.AddItem(HitActor3);
                bDidATracerHit = true;
                DamageAmount+=3 + (tVel * 0.165);
                // TestPawn(HitActor3).SwordGotHit();
            }
        }
                if(HitActor4 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray4.Find(HitActor4) == INDEX_NONE && HitActor4.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor4.TakeDamage(4 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray4.AddItem(HitActor4);
                bDidATracerHit = true;
                DamageAmount+=4 + (tVel * 0.165);
                // TestPawn(HitActor4).SwordGotHit();
            }
        }
                if(HitActor5 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray5.Find(HitActor5) == INDEX_NONE && HitActor5.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor5.TakeDamage(5 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray5.AddItem(HitActor5);
                bDidATracerHit = true;
                DamageAmount+=5 + (tVel * 0.165);
                // TestPawn(HitActor5).SwordGotHit();
            }
        }
                if(HitActor6 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray6.Find(HitActor6) == INDEX_NONE && HitActor6.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor6.TakeDamage(6 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray6.AddItem(HitActor6);
                bDidATracerHit = true;
                DamageAmount+=6 + (tVel * 0.165);
                // TestPawn(HitActor765).SwordGotHit();
            }
        }
                if(HitActor7 != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray7.Find(HitActor7) == INDEX_NONE && HitActor7.bCanBeDamaged)
            {
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor7.TakeDamage(7 + (tVel * 0.165),
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                // AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray7.AddItem(HitActor7);
                bDidATracerHit = true;
                DamageAmount+=7 + (tVel * 0.165);
                // TestPawn(HitActor7).SwordGotHit();
            }
        }
   // if(HitActor8 != none && bDidATracerHit != true)
   //      {
   //          //Check to make sure the actor that is hit hasn't already been counted for during this attack.
   //          if(HitArray.Find(HitActor8) == INDEX_NONE && HitActor8.bCanBeDamaged)
   //          {
   //              //Do the specified damage to the hit actor, using our custom damage type.
   //              HitActor8.TakeDamage(2,
   //              Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
   //              // AmmoCount -= ShotCost[CurrentFireMode];
   //              //Add them to the hit array, so we don't hit them twice in one motion.
   //              HitArray.AddItem(HitActor8);
   //              DamageAmount+=2;
   //              // TestPawn(HitActor8).SwordGotHit();
   //          }
   //      }
        if(bDidATracerHit)
        DebugPrint("tDamage -"@DamageAmount);
                bDidATracerHit = false;
}

/*
resetTracers
  Cleans hit actor arrays and resets tracer bool
*/
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

/*
settracerStartDelay
  Sets delay from when tracer starts and where tracer ends.
*/
function setTracerDelay(float sDelay, float eDelay = 0)
{
  tracerStartDelay = sDelay;
  tracerEndDelay = eDelay;
  tracerCounter = 0;
}
defaultproperties
{
        bCollideActors=True
      bBlockActors=True
      bNotifyRigidBodyCollision = true
ScriptRigidBodyCollisionThreshold=0.001
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
        // CollisionRadius=+0160.000000
        // CollisionHeight=+0165.000000
    End Object
    CollisionComponent = CollisionCylinder
    Components.Add(CollisionCylinder)
    // CollisionType=COLLIDE_BlockAll

}