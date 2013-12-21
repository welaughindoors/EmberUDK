class EmberProjectile extends UTProj_LinkPlasma;

//===================================================
// Projectile's Owner (from whence it was shot from)
//===================================================
var pawn myOwner;



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
	EmberPawn(myOwner).tetherLocationHit(HitNormal, location, none);
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
	if ( Other != Instigator )
	{
		if ( !Other.IsA('Projectile') || Other.bProjTarget )
		{
			// MomentumTransfer = (UTPawn(Other) != None) ? 0.0 : 1.0;
			// Other.TakeDamage(Damage, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
			Explode(HitLocation, HitNormal);
			EmberPawn(myOwner).tetherLocationHit(HitNormal, location, Other);
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
}