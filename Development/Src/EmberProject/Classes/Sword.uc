class Sword extends Actor;
var SkeletalMeshComponent Mesh;
var AnimTree defaultAnimTree;
var AttackFramework_Parry aParry;
var vector lastRecordedSwordDirectionVector;

//=============================================
// Previous Socket Saved Positions
//=============================================
var vector oldStart, oldStart2, oldStart3, oldEnd, oldEnd2, oldEnd3, oldMid;
var vector oldBlock;

var array<vector> interpolatedPoints, oldInterpolatedPoints;
var vector savedEnd;
var array<bool> interpolatedPoints_DidWeHitActor;
//=============================================
// Utility Booleans for Tracers
//=============================================
var bool bTracers, bDidATracerHit, bFuckTheAttack;
var int   tracerAmount;
var float   tracerTempColourCounter;
var bool attackIsActive;
var array<SoundCue> SwordSounds;
var int tickCounterTillDirectionVector;
var array<byte> SwordGroupHits;


//=============================================
// Each tracer to trace only once per attack
// @TODO: Merge into one?
//=============================================
var array<Actor> HitArray, HitArray2, HitArray3, HitArray4, HitArray5, HitArray6, HitArray7;

var array<Actor> interpolatedPoints_HitArray, interpolatedPoints_TemporaryHitArray;

var array<traceHitInfo> interpolatedPoints_TemporaryHitInfo;
var AnimNodePlayCustomAnim  Attack2;
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
var FileWriter  writer;


//=============================================
// Block Vars
//=============================================
//var float blockDistance;
//var float blockCone;
var byte isBlock;

//=============================================
// Damage Vars
//=============================================
var float DamagePerTracer;
var bool  reduceDamage;
var float Knockback;
var int   currentStance;

//TestPawn can't use functional damage, so gotta hardcode it. What a pain
var bool bOwnerIsTestPawn;

var array<PhysicsAsset> PhysicsAssetCollection;
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
function swapToBlockPhysics(bool bBlock)
{  
  if(!bBlock)
  //normal physics
    Mesh.setPhysicsAsset(PhysicsAssetCollection[0]);
  else
  //block physics
    Mesh.setPhysicsAsset(PhysicsAssetCollection[1]);
}
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
      tracerTempColourCounter+= DeltaTime;
      inducedLag += DeltaTime;
        tickCounterTillDirectionVector++;
          // DebugPrint("line drawn");
      // TraceSwordVec();
  // WorldInfo.Game.Broadcast(self,": Health:");
      if(tracerEndDelay == 0)
      {
      if(tracerCounter >= tracerStartDelay && inducedLag >= 0.0)
      //To simulate lag, take the lag you want, divide by two and put it to the right of inducedLag
      //ex. want 40ms lag? then change above to inducedLag >= 0.02
      //number right of inducedLag is in seconds, so need to convert ms to seconds (0.02s = 20ms)
      {
        attackIsActive = true;
        inducedLag = 0;
        TraceAttack();
      }
    }
    //Else if there's no end tracer delay, don't check for it
    else
    {
       if(tracerCounter >= tracerStartDelay && tracerCounter <= tracerEndDelay && inducedLag >= 0.0)
      //To simulate lag, take the lag you want, divide by two and put it to the right of inducedLag
      //ex. want 40ms lag? then change above to inducedLag >= 0.02
      //number right of inducedLag is in seconds, so need to convert ms to seconds (0.02s = 20ms)
      {
        attackIsActive = true;
        inducedLag = 0;
        TraceAttack();
      }      
    }
   }
   // begin:
   // attackIsActive = false;
}


// simulated state AttackingNoTracers
// {
//     simulated event Tick(float DeltaTime)
//    {
//       super.Tick(DeltaTime);
//       tracerCounter+= DeltaTime;
//       tracerTempColourCounter+= DeltaTime;
//       inducedLag += DeltaTime;
//           // DebugPrint("line drawn");

//   // WorldInfo.Game.Broadcast(self,": Health:");
//       if(tracerEndDelay == 0)
//       {
//       if(tracerCounter >= tracerStartDelay && inducedLag >= 0.0)
//       //To simulate lag, take the lag you want, divide by two and put it to the right of inducedLag
//       //ex. want 40ms lag? then change above to inducedLag >= 0.02
//       //number right of inducedLag is in seconds, so need to convert ms to seconds (0.02s = 20ms)
//       {
//         inducedLag = 0;
//         TraceAttackNoTracers();
//       }
//     }
//     //Else if there's no end tracer delay, so lets do a check that has tracer end delay
//     else
//     {
//        if(tracerCounter >= tracerStartDelay && tracerCounter <= tracerEndDelay && inducedLag >= 0.0)
//       //To simulate lag, take the lag you want, divide by two and put it to the right of inducedLag
//       //ex. want 40ms lag? then change above to inducedLag >= 0.02
//       //number right of inducedLag is in seconds, so need to convert ms to seconds (0.02s = 20ms)
//       {
//         inducedLag = 0;
//         TraceAttackNoTracers();
//       }      
//     }
//    }
// }

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
simulated function swordParried(actor hitActor)
{
  TestPawn(hitActor).SwordGotHit();
  TestPawn(owner).SwordGotHit();
  EmberPawn(hitActor).SwordGotHit();
  EmberPawn(owner).SwordGotHit();
  // EmberPawn(Owner).goToIdleMotherfucker();
  tracerCounter = tracerStartDelay + 1;
  bFuckTheAttack = true;
  if(!IsInState('Blocking')) SetInitialState();
}

function setTracers(int tracers)
{
  tracerAmount = tracers;
}
/* 
  setDamage
    Temp. Each tracer will do X damage for Y Stance
*/
function setDamage(float damage)
{
  DamagePerTracer = damage;
}
/* 
  setStance
    sets stance.
*/
function setStance(int s)
{
  currentStance = s;
}
function hitEffect(vector HitLocation, rotator roter){
// local ParticleSystemComponent ProjExplosion;
  
  //create explosion
  // ProjExplosion = 
  // WorldInfo.MyEmitterPool.SpawnEmitter(
  //   ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_Red', 
  //   HitLocation, 
  //   rotator(HitNormal), 
  //   None);
  // ProjExplosion.LifeSpan = 0.5;
  local UTEmitter SwordEmitter;      
// local vector Loc;  
  
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, HitLocation, roter);
 
//Set it to the Socket
// SwordEmitter.SetBase(self,, Sword.Mesh, 'EndControl');
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact', false); 
 
//Never End
SwordEmitter.LifeSpan = 0.3;
PlaySound(SwordSounds[1]);
}
function parryEffect(vector HitLocation, rotator roter = rot(0,0,0)){
// local ParticleSystemComponent ProjExplosion;
  
  //create explosion
  // ProjExplosion = 
  // WorldInfo.MyEmitterPool.SpawnEmitter(
  //   ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_Red', 
  //   HitLocation, 
  //   rotator(HitNormal), 
  //   None);
  // ProjExplosion.LifeSpan = 0.5;
  local UTEmitter SwordEmitter;      
// local vector Loc;  
  
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, HitLocation, roter);
 
//Set it to the Socket
// SwordEmitter.SetBase(self,, Sword.Mesh, 'EndControl');
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Death_Gib_Effect', false); 
 
//Never End
SwordEmitter.LifeSpan = 1;
PlaySound(SwordSounds[2]);
}

/*
TraceSwordVec
  While sword state is active, trace the 'general vector' of where the sword is going
*/

// simulated function TraceSwordVec()
// {
//   local vector End;
//      Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  

//      if(VSize(savedEnd) == 0)
//       savedEnd = End;

// if(tickCounterTillDirectionVector > 5)
// {
// lastRecordedSwordDirectionVector = savedEnd - End;
//  DrawDebugLine(End,savedEnd, 128, 0, 128, true);
// tickCounterTillDirectionVector=0;
// }
// savedEnd = End;
// }
function OwnerIsTestPawn()
{
  bOwnerIsTestPawn=true;
}
/*
TraceAttack
  Trace the actual attack
  This is the main portion of the file
*/
simulated function TraceAttack()
{
   local Vector HitLocation, HitNormal, sVelocity;
   local Vector Start, End, Block, parryEffectLocation;
   local rotator bRotate;
   local traceHitInfo hitInfo;
   // local vector lastTracedVector;
   local Actor hitActor;
        // local float tVel;
        local float fDistance;
        local vector lVect;
        local int i;
          local float tCount;
          // local float lastVectorDot;
  bFuckTheAttack = false;

    Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
    Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  
    Mesh.GetSocketWorldLocationAndRotation('MidControl', parryEffectLocation);  
    Mesh.GetSocketWorldLocationAndRotation('BlockOne', Block, bRotate);  

//Prepare Arrays
    interpolatedPoints_TemporaryHitArray.length = 0;
    interpolatedPoints_TemporaryHitInfo.length = 0;
    interpolatedPoints.length = 0;
    interpolatedPoints.AddItem(Start);

//Get normal vector along sword + distance
    lVect = normal(End - Start);
    fDistance = VSize(End - Start);


//Prepare distance. Determines # of tracers
    fDistance /= tracerAmount-1;

// Get all the point locations
    for(i = 1; i < tracerAmount-1; i++)
      interpolatedPoints.AddItem(Start + (lVect * (fDistance * i)));
      interpolatedPoints.AddItem(End);

// If this is the the first trace in animation, clear out old interpolatedPoints and reset hitActors
if(!bTracers) 
{
  oldInterpolatedPoints.length = 0;
  bTracers = true;
  for (i = 0; i < interpolatedPoints.Length; i++) 
  {
    oldInterpolatedPoints.AddItem(interpolatedPoints[i]);
    // interpolatedPoints_DidWeHitActor.AddItem(false);
  }
}


  //TODO: BlockOne
        
        // DrawDebugLine(Start, Block, 0,0,0, true);

 reduceDamage = false;

if(oldBlock.z == 0 && oldBlock.y == 0 && oldBlock.x == 0)
  oldBlock = Block;
// DebugPrint("block start");
for(tCount = 0; tCount <= 1; tCount += 0.1)
{
        hitActor = Trace(HitLocation, HitNormal,  VLerp (Block, oldBlock, tCount),VLerp(Start, oldInterpolatedPoints[0], tCount), true, , hitInfo); 
        // DrawDebugLine( VLerp (Block, oldBlock, tCount),VLerp(Start, oldInterpolatedPoints[0], tCount), -1,125,-1, true);
        // DebugPrint("bHits -"@hitInfo.Material);
        // DebugPrint("bHits -"@hitInfo.PhysMaterial );
        // DebugPrint("bHits -"@hitInfo.Item); dfa
        // DebugPrint("bHits -"@hitInfo.LevelIndex );
        // DebugPrint("bHits -"@hitInfo.BoneName);
        
        if(hitInfo.BoneName == 'sword_blade')
        {
          if(EmberPawn(hitActor).isBlock() == 1)
          {
             swordParried(Owner);
            parryEffect(parryEffectLocation);      

    EmberPawn(Owner).ClientHitEffect(1);
    EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 1);
        SetInitialState();
        return;
          }

  if(EmberPawn(hitActor).ParryEnabled == true)
  {

    swordParried(hitActor);
    swordParried(Owner);
    parryEffect(parryEffectLocation);     

    // lastVectorDot = EmberPawn(Owner).GetSword().lastRecordedSwordDirectionVector dot EmberPawn(hitActor).GetSword().lastRecordedSwordDirectionVector;

  // DebugPrint("pTestOwner"@EmberPawn(Owner).GetSword().lastRecordedSwordDirectionVector);
  // DebugPrint("pTestTarget"@EmberPawn(hitActor).GetSword().lastRecordedSwordDirectionVector);
  //   DebugPrint("parryTest"@lastVectorDot);

    EmberPawn(Owner).ClientHitEffect(1);
    EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 1);
   sVelocity = Normal(Vector(Owner.Rotation));
   DrawDebugLine(Start, sVelocity*Knockback, 0, -1, 0, true);
    hitActor.TakeDamage(0, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');  
    SetInitialState();
    return;
  }

  if(TestPawn(hitActor).GetTimeLeftOnAttack() > 0)
  {
    // DebugPrint("p1"@aParry.CanAttackParry(EmberPawn(Owner).AttackPacket.Mods[5], TestPawn(hitActor).AttackPacket.Mods[5]));
    // DebugPrint("p2_own"@EmberPawn(Owner).AttackPacket.Mods[5]);
    // DebugPrint("p3_targ"@TestPawn(hitActor).AttackPacket.Mods[5]);
    //TODO: Upgrade to current system
            // if(aParry.CanAttackParry(EmberPawn(Owner).AttackPacket.Mods[7], TestPawn(hitActor).AttackPacket.Mods[7]))
            // {
            swordParried(hitActor);
      swordParried(Owner);
            parryEffect(parryEffectLocation);      

    EmberPawn(Owner).ClientHitEffect(1);
    EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 1);

    // //Bot Only. Remove in final
    // TestPawn(Owner).HitGreen();
    // TestPawn(hitActor).HitGreen();
   // sVelocity = Normal(End - Start);
   sVelocity = Normal(Vector(Owner.Rotation));
   DrawDebugLine(Start, sVelocity*Knockback, 0, -1, 0, true);
    hitActor.TakeDamage(0, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');     
    SetInitialState();
            return ;

          // }
  }
  else
  {
    reduceDamage = true;
  }
  }
        // DebugPrint("bHits -"@hitInfo.HitComponent );
        // DebugPrint("bHits -"@hitActor);
        // DebugPrint("----");
}
         // DrawDebugLine( Block , 10* normal(vector(bRotate)),-1,125,-1, true);
         // DrawDebugLine( Block , (Block + vect(-10,0,0))* normal(vector(bRotate)),-1,125,-1, true);
         // DrawDebugLine( Block , (Block + vect(0,10,0)) *normal(vector(bRotate)),-1,125,-1, true);
         // DrawDebugLine( Block , (Block + vect(0,-10,0))* normal(vector(bRotate)),-1,125,-1, true);

        // DrawDebugLine( VLerp (oldInterpolatedPoints, Start, tCount),Start, -1,125,-1, true);
      
        
           oldBlock = Block;
        // DrawDebugLine(Start, End, -1, 0, 0, true);
// DebugPrint("block end, hit start");
// for each point, do a trace and get hit info
//i = 0, starts from hilt
//interpolated points lenth = tip of blade
  for (i = 0; i < interpolatedPoints.Length; ++i) 
  {
    //if the trace for this particular tracer hasn't hit anything
    // if(interpolatedPoints_DidWeHitActor[i] == false)
    // {
      // if(tracerTempColourCounter < 0.33 && tracerTempColourCounter > 0 )
      if(EmberPawn(Owner).bTraceLines == 1)
      {
      if(i < 5)
        DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], -1, 0, -1, true);
      

      // else if(tracerTempColourCounter > 0.33 && tracerTempColourCounter < 0.66 )
      else if (i >= 5 && i < 10)
      DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], 0, 0, -1, true);
    

     // else if(tracerTempColourCounter < 1 && tracerTempColourCounter > 0.66)
     else if (i >= 10 && i < 15)
        DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], 34, 139, 34, true);
        }

        interpolatedPoints_TemporaryHitArray.AddItem(Trace(HitLocation, HitNormal, interpolatedPoints[i], oldInterpolatedPoints[i], true, , hitInfo)); 
        interpolatedPoints_TemporaryHitInfo.AddItem(hitInfo);
    // }
  }

// DebugPrint("hit end, hit analysis");
  //get the size difference from the current tip and last recorded tip
  // tVel = VSize(interpolatedPoints[interpolatedPoints.length - 1] - oldInterpolatedPoints[interpolatedPoints.length - 1]);

                bDidATracerHit = false;
//Make the old interpolated points to = current ones, preparing for next trace
oldInterpolatedPoints.length = 0;
  for (i = 0; i < interpolatedPoints.Length; ++i) 
    oldInterpolatedPoints.AddItem(interpolatedPoints[i]);

  // for (i = interpolatedPoints.Length - 1; i >= 0; i --) 
   for (i = 0; i < interpolatedPoints.Length; i++) 
  {
    //if the trace for this particular tracer hasn't hit anything
    // if(interpolatedPoints_DidWeHitActor[i] == false)
    // {
      //If we hit the sword of the opponent, execute sword parried function
        if(interpolatedPoints_TemporaryHitInfo[i].item == 0)
        {
            swordParried(interpolatedPoints_TemporaryHitArray[i]);
            parryEffect(parryEffectLocation);      

    EmberPawn(Owner).ClientHitEffect(1);
    EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 1);
    // EmberPawn(hitActor).HitGreen();
            SetInitialState();
            return;
        }

      //Else we check if we hit actor 
      if(interpolatedPoints_TemporaryHitArray[i] != none)
      {
          //We hit something, no longer track this trace
          //@TODO: Make it so we can hit multiple actors
          //@TODO: Fix this damage thing to work right
          // interpolatedPoints_DidWeHitActor[i] = true;
          // x = (i > 5) ? 5 : i;
          // x = interpolatedPoints.Length - i;
          // DebugPrint("hit - "$x);
          // DebugPrint("i - "$i);
          //Take damage


          // interpolatedPoints_TemporaryHitArray[i].TakeDamage(x + (tVel * 0.165),
          //       // Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
          //         Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'UTDmgType_LinkBeam');
          //       //Add them to the hit array, so we don't hit them twice in one motion.
          //       // HitArray.AddItem(HitActor);
          //       bDidATracerHit = true;
          //       DamageAmount+=x + (tVel * 0.165);

// switch(currentStance)
// {
  // case 1:
  // DebugPrint("hit "@DamagePerTracer);
  // 
   // sVelocity = normal(interpolatedPoints_TemporaryHitArray[i].Location - owner.Location);
    // local vector v1, v2, swordLoc;
  // local rotator swordRot;
  // Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('EndControl', swordLoc, swordRot);
  // v1 = normal(vector(swordRot)) << rot(0,-8192,0);
   // sVelocity = Normal(End - Start);
   // sVelocity = Normal(Vector(Owner.Rotation));
   sVelocity = Normal(interpolatedPoints_TemporaryHitArray[i].Location - Owner.Location);
   DrawDebugLine(interpolatedPoints_TemporaryHitArray[i].Location, sVelocity*Knockback, -1, 0, 0, true);

  hitEffect(interpolatedPoints[i], rot(0,0,0));

  
  // EmberPawn(interpolatedPoints_TemporaryHitArray[i]).BodyHitMovement(EmberPawn(Owner).AttackPacket.Mods[7]);
  //TODO: Keep reduced damage?
  // if( reduceDamage )
  // {
  //   //Client only, Actually has 0 use in network
  //   interpolatedPoints_TemporaryHitArray[i].TakeDamage(DamagePerTracer/2, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
  //   //Server only. has 0 use in local
  //   EmberPawn(Owner).ReplicateDamage(DamagePerTracer/2, Pawn(Owner).Controller,HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);
  // }
  // else
  // {

    //Server only. has 0 use in local
    //If it's the first group and group hasn't be activated
    //Hilt group
    if(i<5 && SwordGroupHits[0] == 0)
    {
    SwordGroupHits[0] = 1;
    // EmberPawn(Owner).ReplicateDamage(DamagePerTracer,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);
    EmberPawn(Owner).ReplicateDamage(currentStance, 3,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);

    //Client only, Actually has 0 use in network
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(40, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
    }

    //Middle Group
    if(i>= 5 && i < 10 && SwordGroupHits[1] == 0)
    {
    SwordGroupHits[1] = 1;
    EmberPawn(Owner).ReplicateDamage(currentStance, 2,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);

    //Client only, Actually has 0 use in network
    if(bOwnerIsTestPawn)
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(30, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
    else
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(EmberPawn(Owner).SinglePlayer_Damage(currentStance, 2), Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
    }

    //Tip Group
    if(i>=10 && i < 15 && SwordGroupHits[2] == 0)
    {
    SwordGroupHits[2] = 1;
    EmberPawn(Owner).ReplicateDamage(currentStance, 1,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);

    //Client only, Actually has 0 use in network
    if(bOwnerIsTestPawn)
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(20, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
    else
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(EmberPawn(Owner).SinglePlayer_Damage(currentStance, 1), Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
    }
  // }
    DamageAmount+=DamagePerTracer;


    EmberPawn(Owner).ClientHitEffect(2);
    // EmberPawn(interpolatedPoints_TemporaryHitArray[i]).HitRed();
    EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 0);
    //Bot Only. Remove in final
    TestPawn(Owner).HitBlue();
    TestPawn(interpolatedPoints_TemporaryHitArray[i]).HitRed();


//   break;
//   case 2:
//     interpolatedPoints_TemporaryHitArray[i].TakeDamage(mediumDamagePerTracer, Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'UTDmgType_LinkBeam');
//     DamageAmount+=mediumDamagePerTracer;
//   break;
//   case 3:
//     interpolatedPoints_TemporaryHitArray[i].TakeDamage(heavyDamagePerTracer, Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'UTDmgType_LinkBeam');
//     DamageAmount+=heavyDamagePerTracer;
//   break;

// }

          
                //Add them to the hit array, so we don't hit them twice in one motion.
                // HitArray.AddItem(HitActor);
                bDidATracerHit = true;
                
      }
    // }
  }
        if(bDidATracerHit)
        {
        // DebugPrint("tDamage -"@DamageAmount);
        // TestPawn(owner).damageDone(DamageAmount);
      }
                bDidATracerHit = false;
}
function setKnockback(float knob)
{
  Knockback = knob;
}
/*
  TraceBlock
    Traces a block accross the sword 
*/

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  // DebugPrint("from sword");
}

function getAnim()
{  
// Mesh.SetAnimTreeTemplate(defaultAnimTree );
  // DebugPrint(""@Attack2);
  Attack2 = AnimNodePlayCustomAnim(Mesh.FindAnimNode('CustomAnim2'));
  // DebugPrint(""@Attack2);
  // Attack2.PlayCustomAnim('ember_flammard_tracer',15, 0.3, 0, true);
    //flammard_tree
}

simulated event PostBeginPlay()
{
tracerAmount = 15;
tracerTempColourCounter = 0;
aParry = new class'EmberProject.AttackFramework_Parry';
aParry.initialize();

SwordSounds.AddItem(SoundCue'EmberSounds.SwordSwings');
SwordSounds.AddItem(SoundCue'EmberSounds.SwordHitFlesh');
SwordSounds.AddItem(SoundCue'EmberSounds.SwordHitSword');
SwordSounds.AddItem(SoundCue'A_Gameplay.Gameplay.A_Gameplay_ArmorHitCue');
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
// writer.CloseFile();
interpolatedPoints_DidWeHitActor.length = 0;
interpolatedPoints_HitArray.length = 0;
DamageAmount = 0;
tracerTempColourCounter = 0;
oldBlock = vect(0,0,0);
savedEnd = vect(0,0,0);

//Reset array back to 0
SwordGroupHits.length = 0;
SwordGroupHits.AddItem(0);
SwordGroupHits.AddItem(0);
SwordGroupHits.AddItem(0);
}

/*
settracerStartDelay
  Sets delay from when tracer starts and where tracer ends.
*/
function setTracerDelay(float sDelay, float eDelay = 0)
{
  attackIsActive = false; 
  tracerStartDelay = sDelay;
  tracerEndDelay = eDelay;
  tracerCounter = 0;
  tracerTempColourCounter = 0;
  // DebugPrint("act dlea");
// writer = spawn(class'FileWriter');
// writer.OpenFile("Example.txt", FWFT_Log,, true, true);
}
function rotate(int nPitch, int nYaw, int nRoll)
{
   local Rotator newRot;    // This will be our new Rotation
    newRot.Pitch = nPitch;   // Since 65536 = 0 = 360, half of that equals 180, right?
    newRot.Yaw = nYaw;    // Since 65536 = 0 = 360, half of that equals 180, right?
    newRot.Roll = nRoll;   
  Mesh.SetRotation(newRot);
}

// function findActors()
// {
// local vector End;
// local TestPawn swordy;
// Mesh.GetSocketWorldLocationAndRotation('EndControl', End);
// // DebugPrint("run")  ;
// ForEach VisibleActors(class'TestPawn', Swordy, 50.f, End)
//   {
//     // Prefer NPC that Pawn is facing
   
//   DebugPrint("col"@Swordy);
//   }
// }
defaultproperties
{
      // bCollideActors=True
      // bBlockActors=True
      reduceDamage = false
      // blockDistance=55.0
      // blockCone=0.5;
      isBlock = 0;
      attackIsActive = false
      // defaultAnimTree=AnimTree'ArtAnimation.flammard_tree'
// ember_flammard_tracer
    Begin Object class=SkeletalMeshComponent Name=SwordMesh
        // SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
        SkeletalMesh=SkeletalMesh'ArtAnimation.Meshes.ember_weapon_katana'
        AnimTreeTemplate=AnimTree'ArtAnimation.flammard_tree'
        PhysicsAsset = PhysicsAsset'ArtAnimation.Meshes.ember_weapon_katana_Physics'
        // AnimSets(0)=AnimSet'ArtAnimation.Meshes.flammard_Anims'
        bCacheAnimSequenceNodes=false
       AlwaysLoadOnClient=true
       AlwaysLoadOnServer=true
       CastShadow=true
       // BlockRigidBody=true 
       bUpdateSkelWhenNotRendered=false
       bIgnoreControllersWhenNotRendered=true
       bUpdateKinematicBonesFromAnimation=true
       bCastDynamicShadow=true
       // RBChannel=RBCC_Untitled3
       // RBCollideWithChannels=(Untitled3=true)
       //LightEnvironment=MyLightEnvironment
       bOverrideAttachmentOwnerVisibility=true
       bAcceptsDynamicDecals=false
       bHasPhysicsAssetInstance=true
       TickGroup=TG_PreAsyncWork
       MinDistFactorForKinematicUpdate=0.2f
       bChartDistanceFactor=true
       RBDominanceGroup=20
       Scale=1
       bAllowAmbientOcclusion=false 
       bUseOnePassLightingOnTranslucency=true
       bPerBoneMotionBlur=true
       bOwnerNoSee=false
       // BlockActors=true
       BlockZeroExtent=true 
       BlockNonZeroExtent=true
       CollideActors=true


// Rotation=(Pitch=000 ,Yaw=0, Roll=49152 )
// Since 65536 = 0 = 360, half of that equals 180, right?
Rotation=(Pitch=000 ,Yaw=0, Roll=16384 )

    End Object
    Mesh = SwordMesh
    // Components.Add(SwordMesh)

    // CollisionType=COLLIDE_BlockAll
       CollisionType =COLLIDE_TouchAll 
    // Begin Object class=CylinderComponent Name=CollisionCylinder
    //     CollisionRadius=+0160.000000
    //     CollisionHeight=+0165.000000
    // End Object
    // CollisionType=COLLIDE_BlockAll
    // CollisionComponent = CollisionCylinder
    // Components.Add(CollisionCylinder)

}