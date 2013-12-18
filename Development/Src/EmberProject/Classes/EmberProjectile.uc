class EmberProjectile extends UTProj_LinkPlasma;

var pawn myOwner;

simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	// Velocity = MirrorVectorByNormal(Velocity,HitNormal);
	// SetRotation(Rotator(Velocity));
	// Wall.TakeDamage(Damage,InstigatorController,HitNormal,MomentumTransfer * Normal(Velocity), MyDamageType,, self);

    // GetALocalPlayerController().ClientMessage("Projectile hits");	
    MomentumTransfer = 1.0;

	Super.HitWall(HitNormal, Wall, WallComp);
	Explode(location, HitNormal);
	EmberPawn(myOwner).tetherLocationHit(HitNormal, location);
}
function setProjectileOwner(pawn law)
{
	myOwner = law;
}
// simulated function ProcessTouch (Actor Other, vector HitLocation, vector HitNormal)
// {
// 	if ( Other != Instigator )
// 	{
// 		if ( !Other.IsA('Projectile') || Other.bProjTarget )
// 		{
// 			MomentumTransfer = (UTPawn(Other) != None) ? 0.0 : 1.0;
// 			Other.TakeDamage(Damage, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
// 			Explode(HitLocation, HitNormal);
// 		}
// 	}
// }
DefaultProperties
{
	
	Speed=5400 // 1400 default
	MaxSpeed=10000 // 5000 default
	DrawScale=4.2 // 1.2 default
}