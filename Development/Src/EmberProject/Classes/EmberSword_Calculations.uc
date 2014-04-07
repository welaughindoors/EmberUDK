class EmberSword_Calculations extends Actor;

// var AttackFramework_Parry aParry;

//=============================================
// Previous Socket Saved Positions
//=============================================
var array<vector> interpolatedPoints, oldInterpolatedPoints;
var array<bool> interpolatedPoints_DidWeHitActor;
//=============================================
// Utility Booleans for Tracers
//=============================================
var bool bTracers, bDidATracerHit, bFuckTheAttack;
var int   tracerAmount;
var array<SoundCue> SwordSounds;
var int tickCounterTillDirectionVector;
var array<byte> SwordGroupHits;

var int SwordID;
//=============================================
// Each tracer to trace only once per attack
// @TODO: Merge into one?
//=============================================
var array<Actor> interpolatedPoints_HitArray, interpolatedPoints_TemporaryHitArray;

var array<traceHitInfo> interpolatedPoints_TemporaryHitInfo;
var AnimNodePlayCustomAnim  Attack2;
//=============================================
// Tracer Delay Vars
//=============================================
var float tracerCounter;

//=============================================
// Damage Vars
//=============================================
var bool  reduceDamage;
var float Knockback;
var int   currentStance;

//TestPawn can't use functional damage, so gotta hardcode it. What a pain
var bool bOwnerIsTestPawn;

// var array<PhysicsAsset> PhysicsAssetCollection;

var array<EmberSword_Model> SwordData;
var float fTracerStart;
var float fTracerEnd;
//sword index
var int sIndex;
var bool bAttackIsGo;
var bool bCustomTracerPoints;
var vector vStartPoint;
var vector vEndPoint;
var bool bContinueTracerEnd;
var int SavedAttackAnimationID;
/*
DebugPrint
  Easy way to print out debug messages
  If wanting to print variables, use: DebugPrint("var :" $var);
*/
function DebugPrint(string sMessage)
{
    EmberPawn(Owner).DebugPrint(sMessage);
}

function Initialize(pawn ePawn)
{
	// Owner = ePawn;
}

/*
AddSwordModel
	
*/
function AddSwordModel(EmberSword_Model sModel)
{
	SwordData.AddItem(sModel);
}
/*
CustomTracerPoints
	
*/
function CustomTracerPoints(vector StartPoint, vector EndPoint)
{
	vStartPoint = StartPoint;
	vEndPoint = EndPoint;
	bCustomTracerPoints = true;
}
/*
PrepareAttack
	
*/
function PrepareAttack(float tracerStart, float tracerEnd, int mIndex)
{
	//No end was specified. 
	// if(tracerEnd == 0) return;

	fTracerStart = tracerStart;
	fTracerEnd = tracerEnd;
	sIndex = mIndex;
	tracerCounter = 0;
	resetTracers();
	bAttackIsGo = true;
}
/*
EndAttack
	
*/
function EndAttack()
{
	SavedAttackAnimationID--;
	bAttackIsGo = false;
	bCustomTracerPoints = false;
	bContinueTracerEnd = false;
	tracerCounter = 0;
}
/*
ContinuePastTracerEnd
	
*/	
function ContinuePastTracerEnd()
{
	bContinueTracerEnd = true;
}
function swapToBlockPhysics(bool bBlock, int mIndex)
{  
  if(!bBlock)
  //normal physics
    SwordData[mIndex].SwitchPhysicsAsset(0);
  else
  //block physics
    SwordData[mIndex].SwitchPhysicsAsset(1);
}


simulated event Tick(float DeltaTime)
   {
      super.Tick(DeltaTime);
      if(bAttackIsGo)
      	{
      		tracerCounter += DeltaTime;
        	if(tracerCounter >= fTracerStart) TraceAttack();
        	if(tracerCounter >= fTracerEnd && !bContinueTracerEnd) EndAttack();
    	}
    }
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

  if(!IsInState('Blocking')) EndAttack();
}

function setTracers(int tracers)
{
  tracerAmount = tracers;
}

function hitEffect(vector HitLocation, rotator roter = rot(0,0,0))
{
  local UTEmitter SwordEmitter;    
  
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, HitLocation, roter);
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact', false); 
 
SwordEmitter.LifeSpan = 0.3;
PlaySound(SwordSounds[1]);
}

function parryEffect(vector HitLocation, rotator roter = rot(0,0,0))
{
  local UTEmitter SwordEmitter;  
  
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, HitLocation, roter);
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Death_Gib_Effect', false); 
 
SwordEmitter.LifeSpan = 1;
PlaySound(SwordSounds[2]);
}

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
   	local Vector Start, End, Block;
   	local traceHitInfo hitInfo;
   	local Actor hitActor;
   	local float fDistance;
   	local vector lVect;
   	local int i;

	if(bCustomTracerPoints)
	{
  		End = vEndPoint;
  		Start = vStartPoint;
	}
	else
	{
		SwordData[sIndex].Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
	    SwordData[sIndex].Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  
	}
	//Get normal vector along sword + distance
	    lVect = normal(End - Start);
	    fDistance = VSize(End - Start);

	//Prepare Arrays
	    interpolatedPoints_TemporaryHitArray.length = 0;
	    interpolatedPoints_TemporaryHitInfo.length = 0;
	    interpolatedPoints.length = 0;
	    interpolatedPoints.AddItem(Start);
	    
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

	 reduceDamage = false;
	// for each point, do a trace and get hit info
	//i = 0, starts from hilt
	//interpolated points lenth = tip of blade
	  for (i = 0; i < interpolatedPoints.Length; ++i) 
	  {
	    //if the trace for this particular tracer hasn't hit anything
	    // if(interpolatedPoints_DidWeHitActor[i] == false)
	    // {
	    if(EmberPawn(Owner).bTraceLines == 1)
	    {
	      	if(i < 5)
		        DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], -1, 0, -1, true);

	      	else if (i >= 5 && i < 10)	
	      		DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], 0, 0, -1, true);

	    	 else if (i >= 10 && i < 15)
		        DrawDebugLine(interpolatedPoints[i], oldInterpolatedPoints[i], 34, 139, 34, true);
	    }

	        hitActor = Trace(HitLocation, HitNormal, interpolatedPoints[i], oldInterpolatedPoints[i], true, , hitInfo);
	        interpolatedPoints_TemporaryHitArray.AddItem(hitActor); 
	        interpolatedPoints_TemporaryHitInfo.AddItem(hitInfo);

	    if(StaticMeshComponent(HitInfo.HitComponent) == none)
	    {
		    if(hitInfo.BoneName == 'sword_blade' || hitInfo.BoneName == 'sword_grip')
	        {
	        	if(EmberPawn(hitActor).isBlock == 1)
	          	{
		            swordParried(Owner);
	            	parryEffect(HitLocation);      

	    			EmberPawn(Owner).ClientHitEffect(1);
	    			EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 1);
	        		SetInitialState();
		        		return;
	          	}

	  			if(EmberPawn(hitActor).ParryEnabled == true)
	  			{
				    swordParried(hitActor);
	    			swordParried(Owner);
	    			parryEffect(HitLocation);     

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

	    		//TODO: Upgrade to current system
	            // if(aParry.CanAttackParry(EmberPawn(Owner).AttackPacket.Mods[7], TestPawn(hitActor).AttackPacket.Mods[7]))
	            // {
	            	swordParried(hitActor);
	      			swordParried(Owner);
	            	parryEffect(HitLocation);      

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
	  			}
	  		else
	  		{
	    		reduceDamage = true;
	  		}
		}
	}
}

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
            parryEffect(interpolatedPoints[i]);

    		EmberPawn(Owner).ClientHitEffect(1);
	    	EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 1);
    		// EmberPawn(hitActor).HitGreen();
            SetInitialState();
            return;
        }

      //Else we check if we hit actor 
      	if(interpolatedPoints_TemporaryHitArray[i] != none)
      	{
	      	sVelocity = Normal(interpolatedPoints_TemporaryHitArray[i].Location - Owner.Location);
	   		DrawDebugLine(interpolatedPoints_TemporaryHitArray[i].Location, sVelocity*Knockback, -1, 0, 0, true);

			if(StaticMeshComponent(interpolatedPoints_TemporaryHitInfo[i].HitComponent) == none)
	  			hitEffect(interpolatedPoints[i]);
	  
	 	   //Server only. has 0 use in local
		    //If it's the first group and group hasn't be activated
		    //Hilt group
		    if(i<5 && SwordGroupHits[0] == 0)
		    {
		    	SwordGroupHits[0] = 1;
		    	// EmberPawn(Owner).ReplicateDamage(DamagePerTracer,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);
		    	EmberPawn(Owner).ReplicateDamage(sIndex+1, 3,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);

		    	//Client only, Actually has 0 use in network
		    	interpolatedPoints_TemporaryHitArray[i].TakeDamage(40, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
		    }

		    //Middle Group
		    if(i>= 5 && i < 10 && SwordGroupHits[1] == 0)
		    {
		    	SwordGroupHits[1] = 1;
		    	EmberPawn(Owner).ReplicateDamage(sIndex+1, 2,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);

		    	//Client only, Actually has 0 use in network
		    	if(bOwnerIsTestPawn)
		    		interpolatedPoints_TemporaryHitArray[i].TakeDamage(30, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
		    	else
		    		interpolatedPoints_TemporaryHitArray[i].TakeDamage(EmberPawn(Owner).SinglePlayer_Damage(currentStance, 2), Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
		    }

		    //Tip Group
		    if(i >= 10 && i < 15 && SwordGroupHits[2] == 0)
		    {
		    	SwordGroupHits[2] = 1;
		    	EmberPawn(Owner).ReplicateDamage(sIndex+1, 1,Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, EmberPawn(interpolatedPoints_TemporaryHitArray[i]).PlayerReplicationInfo.PlayerID);

		    	//Client only, Actually has 0 use in network
		    	if(bOwnerIsTestPawn)
		    		interpolatedPoints_TemporaryHitArray[i].TakeDamage(20, Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
		    	else
		    		interpolatedPoints_TemporaryHitArray[i].TakeDamage(EmberPawn(Owner).SinglePlayer_Damage(currentStance, 1), Pawn(Owner).Controller, HitLocation, sVelocity * Knockback, class'UTDmgType_LinkBeam');
		    }

    		EmberPawn(Owner).ClientHitEffect(2);
    		// EmberPawn(interpolatedPoints_TemporaryHitArray[i]).HitRed();
    		EmberPawn(Owner).HitEffectReplicate(EmberPawn(hitActor), 0);
    		//Bot Only. Remove in final
    		TestPawn(Owner).HitBlue();
    		TestPawn(interpolatedPoints_TemporaryHitArray[i]).HitRed();
        }
  	}
}

function setKnockback(float knob)
{
  Knockback = knob;
}
/*
PostBeginPlay
	Initial Setup
*/
simulated event PostBeginPlay()
{
tracerAmount = 15;
// aParry = new class'EmberProject.AttackFramework_Parry';
// aParry.initialize();
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
interpolatedPoints_DidWeHitActor.length = 0;
interpolatedPoints_HitArray.length = 0;

//Reset array back to 0
SwordGroupHits.length = 0;
SwordGroupHits.AddItem(0);
SwordGroupHits.AddItem(0);
SwordGroupHits.AddItem(0);
}