class TestWeapon extends UTWeapon;

simulated function Projectile ProjectileFire()
{
    local vector        RealStartLoc;
    local Projectile    SpawnedProjectile;

    // tell remote clients that we fired, to trigger effects
    IncrementFlashCount();

    if( Role == ROLE_Authority )
    {
        // this is the location where the projectile is spawned.
        RealStartLoc = GetPhysicalFireStartLoc();

        // Spawn projectile
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);

        if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
        {
            SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
        }

        // Return it up the line
        return SpawnedProjectile;
    }

    return None;
}