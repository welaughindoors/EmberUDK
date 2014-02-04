class Sword extends Actor;
var SkeletalMeshComponent Mesh;
var AnimTree defaultAnimTree;
var AttackFramework_Parry aParry;

//=============================================
// Previous Socket Saved Positions
//=============================================
var vector oldStart, oldStart2, oldStart3, oldEnd, oldEnd2, oldEnd3, oldMid;
var vector oldBlock;

var array<vector> interpolatedPoints, oldInterpolatedPoints;
var array<bool> interpolatedPoints_DidWeHitActor;
//=============================================
// Utility Booleans for Tracers
//=============================================
var bool bTracers, bDidATracerHit, bFuckTheAttack;
var int   tracerAmount;
var float   tracerTempColourCounter;
var bool attackIsActive;
var array<SoundCue> SwordSounds;

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
var float blockDistance;
var float blockCone;

//=============================================
// Damage Vars
//=============================================
var float DamagePerTracer;
var bool  reduceDamage;
var float Knockback;
// var int   currentStance;

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
      tracerTempColourCounter+= DeltaTime;
      inducedLag += DeltaTime;
          // DebugPrint("line drawn");

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
/*
  Blocking
    Active tracers along sword
*/
simulated state Blocking
{
    simulated event Tick(float DeltaTime)
   {
      super.Tick(DeltaTime);
      TraceBlock();
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
// /* 
//   setStance
//     sets stance.
// */
// function setStance(int s)
// {
//   currentStance = s;
// }
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
SwordEmitter.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_HIT', false); 
 
//Never End
SwordEmitter.LifeSpan = 0.25;
PlaySound(SwordSounds[2]);
}

simulated function TraceAttack()
{
   local Vector HitLocation, HitNormal, sVelocity;
   local Vector Start, End, Block, parryEffectLocation;
   local rotator bRotate;
   local traceHitInfo hitInfo;
   local Actor hitActor;
        // local float tVel;
        local float fDistance;
        local vector lVect;
        local int i;
          local float tCount;
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
  for (i = 0; i < interpolatedPoints.Length; ++i) 
  {
    oldInterpolatedPoints.AddItem(interpolatedPoints[i]);
    interpolatedPoints_DidWeHitActor.AddItem(false);
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
        // DebugPrint("bHits -"@hitInfo.Item);
        // DebugPrint("bHits -"@hitInfo.LevelIndex );
        if(hitInfo.BoneName == 'sword_blade')
        {
        // if(TestPawn(hitActor).doin)

  if(EmberPawn(hitActor).ParryEnabled == true)
  {

    swordParried(hitActor);
    swordParried(Owner);
    parryEffect(parryEffectLocation);     

    EmberPawn(Owner).HitGreen();
    EmberPawn(hitActor).HitGreen();
   sVelocity = Normal(Vector(Owner.Rotation));
   DrawDebugLine(Start, sVelocity*Knockback, 0, -1, 0, true);
    hitActor.TakeDamage(0, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');  
    return;
  }

  if(TestPawn(hitActor).GetTimeLeftOnAttack() > 0)
  {
    // DebugPrint("p1"@aParry.CanAttackParry(EmberPawn(Owner).AttackPacket.Mods[5], TestPawn(hitActor).AttackPacket.Mods[5]));
    // DebugPrint("p2_own"@EmberPawn(Owner).AttackPacket.Mods[5]);
    // DebugPrint("p3_targ"@TestPawn(hitActor).AttackPacket.Mods[5]);
            if(aParry.CanAttackParry(EmberPawn(Owner).AttackPacket.Mods[7], TestPawn(hitActor).AttackPacket.Mods[7]))
            {
            swordParried(hitActor);
    swordParried(Owner);
            parryEffect(parryEffectLocation);      

    EmberPawn(Owner).HitGreen();
    EmberPawn(hitActor).HitGreen();
   // sVelocity = Normal(End - Start);
   sVelocity = Normal(Vector(Owner.Rotation));
   DrawDebugLine(Start, sVelocity*Knockback, 0, -1, 0, true);
    hitActor.TakeDamage(0, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');     
            return ;
          }
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
  for (i = 0; i < interpolatedPoints.Length; ++i) 
  {
    //if the trace for this particular tracer hasn't hit anything
    // if(interpolatedPoints_DidWeHitActor[i] == false)
    // {
      if(tracerTempColourCounter < 0.33 && tracerTempColourCounter > 0 )
      {
        DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], -1, 0, -1, true);
      }

      else if(tracerTempColourCounter > 0.33 && tracerTempColourCounter < 0.66 )
      {
        DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], 0, 0, -1, true);
      }

     else if(tracerTempColourCounter < 1 && tracerTempColourCounter > 0.66)
     {
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

//@Not anymore: We start checking the array backwards. This way we start from tip of sword and head down to the base
// We check array forwards, don't ask why.
  for (i = interpolatedPoints.Length - 1; i >= 0; i --) 
   // for (i = 0; i < interpolatedPoints.Length; ++i) 
  {
    //if the trace for this particular tracer hasn't hit anything
    if(interpolatedPoints_DidWeHitActor[i] == false)
    {
      //If we hit the sword of the opponent, execute sword parried function
        if(interpolatedPoints_TemporaryHitInfo[i].item == 0)
            swordParried(interpolatedPoints_TemporaryHitArray[i]);

      //Else we check if we hit actor 
      if(interpolatedPoints_TemporaryHitArray[i] != none)
      {
          //We hit something, no longer track this trace
          //@TODO: Make it so we can hit multiple actors
          //@TODO: Fix this damage thing to work right
          interpolatedPoints_DidWeHitActor[i] = true;
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
  if( reduceDamage )
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(DamagePerTracer/2, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
  else
    interpolatedPoints_TemporaryHitArray[i].TakeDamage(DamagePerTracer, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
    DamageAmount+=DamagePerTracer;
    EmberPawn(Owner).HitBlue();
    EmberPawn(interpolatedPoints_TemporaryHitArray[i]).HitRed();
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
    }
  }
        if(bDidATracerHit)
        {
        DebugPrint("tDamage -"@DamageAmount);
        TestPawn(owner).damageDone(DamageAmount);
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
function TraceBlock()
{
   local Vector End;
   local Sword Swordy;
        local vector pawnToOwner, normalOwnerRotation;
        local float dotProductForOwnerAndEnemyPawn;
        local bool skipToNextIf;
//Check all pawns in the world
foreach Worldinfo.AllActors( class'Sword', Swordy ) 
{
  skipToNextIf = true;
  //Skip owner of sword
  if(Swordy != Owner)
  {
    //Get vector between pawn and
    Swordy.Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  
    pawnToOwner = End - Owner.location;
    //If distance is <= blockdistance
    if(VSize(pawnToOwner) <= blockDistance) 
    {
      // OwnerRotation = owner.Rotation;
      pawnToOwner = normal(pawnToOwner);
      normalOwnerRotation = normal(Vector(Owner.Rotation));
      dotProductForOwnerAndEnemyPawn = pawnToOwner dot normalOwnerRotation;
      // DebugPrint("act"@ Swordy.attackIsActive);
      //Pawn is in a state of attacking 
      //
        if( Swordy.attackIsActive && dotProductForOwnerAndEnemyPawn >= blockCone)
        {
          skipToNextIf = false;
          //reset state
           DebugPrint("block activated");
           TestPawn(Swordy.Owner).SwordGotHit();
           Swordy.SetInitialState();
        }
        //======================
        //This segment uses the sword's owner (pawn) as the locator
        //Might remove
        //=======================
      pawnToOwner = Swordy.Owner.Location - Owner.Location;
      pawnToOwner = normal(pawnToOwner);
      normalOwnerRotation = normal(Vector(Owner.Rotation));
      dotProductForOwnerAndEnemyPawn = pawnToOwner dot normalOwnerRotation;
       if( Swordy.attackIsActive && dotProductForOwnerAndEnemyPawn >= blockCone && skipToNextIf)
        {
          //reset state
           DebugPrint("block activated");
           TestPawn(Swordy.Owner).SwordGotHit();
           Swordy.SetInitialState();
        }

        //=======================
        //\end//=======================
    }
  }
}
return;
// i++;

//   bFuckTheAttack = false;

//     Mesh.GetSocketWorldLocationAndRotation('BlockOne', Start);
//     Mesh.GetSocketWorldLocationAndRotation('StartControl', End);  

// //Prepare Arrays
//     interpolatedPoints_TemporaryHitArray.length = 0;
//     interpolatedPoints_TemporaryHitInfo.length = 0;
//     interpolatedPoints.length = 0;
//     interpolatedPoints.AddItem(Start);

// //Get normal vector along sword + distance
//     lVect = normal(End - Start);
//     fDistance = VSize(End - Start);

// //Prepare distance. Determines # of tracers
//     fDistance /= tracerAmount-1;

// // Get all the point locations
//     for(i = 1; i < tracerAmount-1; i++)
//       interpolatedPoints.AddItem(Start + (lVect * (fDistance * i)));
//       interpolatedPoints.AddItem(End);

// // If this is the the first trace in animation, clear out old interpolatedPoints and reset hitActors
// if(!bTracers) 
// {
//   oldInterpolatedPoints.length = 0;
//   bTracers = true;
//   for (i = 0; i < interpolatedPoints.Length; ++i) 
//   {
//     oldInterpolatedPoints.AddItem(interpolatedPoints[i]);
//     interpolatedPoints_DidWeHitActor.AddItem(false);
//   }
// }
//         // DrawDebugLine(Start, End, -1, 0, 0, true);

// // for each point, do a trace and get hit info
//   // for (i = 0; i < interpolatedPoints.Length; ++i) 
//   // {
//   //   //if the trace for this particular tracer hasn't hit anything
//   //   // if(interpolatedPoints_DidWeHitActor[i] == false)
//   //   // {
//   //     if(tracerTempColourCounter < 0.33 && tracerTempColourCounter > 0 )
//   //     {
//   //       DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], -1, 0, -1, true);
//   //     }

//   //     else if(tracerTempColourCounter > 0.33 && tracerTempColourCounter < 0.66 )
//   //     {
//   //       DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], 0, 0, -1, true);
//   //     }

//   //    else if(tracerTempColourCounter < 1 && tracerTempColourCounter > 0.66)
//   //    {
//         DrawDebugLine(interpolatedPoints[0], oldInterpolatedPoints[interpolatedPoints.Length-1], -1, 0, -1, true);
//       // }
//         interpolatedPoints_TemporaryHitArray.AddItem(Trace(HitLocation, HitNormal, interpolatedPoints[0], oldInterpolatedPoints[interpolatedPoints.Length-1], true, , hitInfo)); 
//         interpolatedPoints_TemporaryHitInfo.AddItem(hitInfo);
//     // }
//   // }
//   //get the size difference from the current tip and last recorded tip
//   // tVel = VSize(interpolatedPoints[interpolatedPoints.length - 1] - oldInterpolatedPoints[interpolatedPoints.length - 1]);

//                 bDidATracerHit = false;
// //Make the old interpolated points to = current ones, preparing for next trace
// oldInterpolatedPoints.length = 0;
//   for (i = 0; i < interpolatedPoints.Length; ++i) 
//     oldInterpolatedPoints.AddItem(interpolatedPoints[i]);

//             if(interpolatedPoints_TemporaryHitInfo[0].item == 0)
//             {
//               DebugPrint("Sword Hit");
//             swordParried(interpolatedPoints_TemporaryHitArray[0]);
//           }

//@Not anymore: We start checking the array backwards. This way we start from tip of sword and head down to the base
// We check array forwards, don't ask why.
  // for (i = interpolatedPoints.Length - 1; i >= 0; i --) 
   // for (i = 0; i < interpolatedPoints.Length; ++i) 
  // {
    //if the trace for this particular tracer hasn't hit anything
  //   if(interpolatedPoints_DidWeHitActor[i] == false)
  //   {
  //     //If we hit the sword of the opponent, execute sword parried function
  //       if(interpolatedPoints_TemporaryHitInfo[i].item == 0)
  //           swordParried(interpolatedPoints_TemporaryHitArray[i]);

  //     //Else we check if we hit actor 
  //     if(interpolatedPoints_TemporaryHitArray[i] != none)
  //     {
  //         //We hit something, no longer track this trace
  //         //@TODO: Make it so we can hit multiple actors
  //         //@TODO: Fix this damage thing to work right
  //         interpolatedPoints_DidWeHitActor[i] = true;
  //         // x = (i > 5) ? 5 : i;
  //         x = interpolatedPoints.Length - i;
  //         // DebugPrint("hit - "$x);
  //         // DebugPrint("i - "$i);
  //         //Take damage
  //         interpolatedPoints_TemporaryHitArray[i].TakeDamage(x + (tVel * 0.165),
  //               Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
  //               //Add them to the hit array, so we don't hit them twice in one motion.
  //               // HitArray.AddItem(HitActor);
  //               bDidATracerHit = true;
  //               DamageAmount+=x + (tVel * 0.165);
  //     }
  //   }
  // }
        // if(bDidATracerHit)
        // DebugPrint("tDamage -"@DamageAmount);
        //         bDidATracerHit = false;
}

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
      bCollideActors=True
      bBlockActors=True
      reduceDamage = false
      blockDistance=55.0
      blockCone=0.5;
      attackIsActive = false
      // defaultAnimTree=AnimTree'ArtAnimation.flammard_tree'
    // CollisionType=COLLIDE_BlockAll
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
    // CollisionType=COLLIDE_BlockAll
       Scale=1
       bAllowAmbientOcclusion=false 
       bUseOnePassLightingOnTranslucency=true
       bPerBoneMotionBlur=true
       bOwnerNoSee=false
       BlockActors=true
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
    // Begin Object class=CylinderComponent Name=CollisionCylinder
    //     CollisionRadius=+0160.000000
    //     CollisionHeight=+0165.000000
    // End Object
    // CollisionType=COLLIDE_BlockAll
    // CollisionComponent = CollisionCylinder
    // Components.Add(CollisionCylinder)

}