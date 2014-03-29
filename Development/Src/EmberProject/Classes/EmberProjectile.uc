class EmberProjectile extends UTProj_LinkPlasma;

//===================================================
// Projectile's Owner (from whence it was shot from)
//===================================================
var pawn myOwner;
var float DistanceTravelled;


//===================================================
// Overrided Events
//===================================================

/*
HitWall
  If we hit something like a static mesh
  explode projectile
  get location and hit normal
  send it to owner
*/
simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	// Velocity = MirrorVectorByNormal(Velocity,HitNormal);
	// SetRotation(Rotator(Velocity));
	// Wall.TakeDamage(Damage,Instigat orController,HitNormal,MomentumTransfer * Normal(Velocity), MyDamageType,, self);

    // GetALocalPlayerController().ClientMessage("Projectile hits");	
    MomentumTransfer = 1.0;

	Super.HitWall(HitNormal, Wall, WallComp);
	Explode(location, HitNormal);
	if(myOwner != none)
	EmberPawn(myOwner).tetherLocationHit(HitNormal, location, none);
}

simulated function float GetDistance( vector vec1, vector vec2 )
{
	local float size;
	size = VSize(vec1 - vec2);
	return size;
}
/*
ProcessTouch
  If we hit something like an actor
  explode projectile
  get location and hit normal
  send it to owner
  @TODO: Use this instead of both this and hitwall?
*/
simulated function ProcessTouch (Actor Other, vector HitLocation, vector HitNormal)
{
	local vector PullLocation;
	if ( Other != Instigator )
	{
		if ( !Other.IsA('Projectile') || Other.bProjTarget )
		{
			// MomentumTransfer = (UTPawn(Other) != None) ? 0.0 : 1.0;
			// Other.TakeDamage(Damage, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
			Explode(HitLocation, HitNormal);
			if(myOwner != none)
			{
			// EmberPawn(myOwner).tetherLocationHit(HitNormal, location, Other);

			DistanceTravelled = GetDistance( Instigator.Location, Location );
			
			if ( DistanceTravelled <= 0 )
				DistanceTravelled = 1;
				
			MomentumTransfer = MomentumTransfer * ( DistanceTravelled / 2000 );
			
			PullLocation = Instigator.Location;
			if ( Other.Location.Z < Instigator.Location.Z )
			{
				MomentumTransfer = MomentumTransfer * 1.25;
			}
			
			if ( Other.Location.Z < Instigator.Location.Z )
			{
				PullLocation.Z += 150; 
				MomentumTransfer = MomentumTransfer * 1.25;
			}
			Damage = 0;
			EmberPawn(myOwner).PullEnemy(Other, MomentumTransfer * Normal( PullLocation - Other.Location ), InstigatorController);
			// EmberPawn(myOwner).DebugPrint("hitot -"@MomentumTransfer * Normal( PullLocation - Other.Location ));
			// EmberPawn(myOwner).DebugPrint("hitm -"@MomentumTransfer);
			// EmberPawn(myOwner).DebugPrint("hitnorm -"@Normal( PullLocation - Other.Location ));
			// EmberPawn(myOwner).DebugPrint("hitpullLoc -"@PullLocation);
			// EmberPawn(myOwner).DebugPrint("hitotherloc -"@Other.Location);
			// EmberPawn(myOwner).DebugPrint("DistanceTravelled -"@DistanceTravelled);
			// EmberPawn(myOwner).DebugPrint("DistanceTravelled / 2000  -"@DistanceTravelled / 2000 );
			
			// Other.TakeDamage(Damage, InstigatorController, Other.Location, MomentumTransfer * Normal( PullLocation - Other.Location ), MyDamageType,, self);
			//KRPawn(Other).SetPhysics(PHYS_Falling);
			
			// KRPawn(Instigator).SetupBeamActor( KRPawn(Other) );
			}
			Shutdown();
		}
	}
}

//===================================================
// Custom Functions
//===================================================

/*
setProjectileOwner
  set Owner so we can communicate with it
*/
function setProjectileOwner(pawn law)
{
	myOwner = law;
}

DefaultProperties
{
	
	Speed=5400 // 1400 default
	MaxSpeed=10000 // 5000 default
	DrawScale=4.2 // 1.2 default
	MaxEffectDistance=2000.0 // 7000 def
    MomentumTransfer=150000.0
}