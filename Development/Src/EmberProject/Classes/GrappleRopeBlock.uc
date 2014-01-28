class GrappleRopeBlock extends Actor;

var() StaticMeshComponent Mesh;

defaultproperties
{
        Begin Object Class=StaticMeshComponent Name=SpawnMesh
                BlockActors=true
                CollideActors=true
                BlockRigidBody=true
                StaticMesh=StaticMesh'GrappleAssets.TexPropCylinder'
                Scale3D=(X=.01,Y=.01,Z=.05)
        End Object
        Mesh=SpawnMesh
        CollisionComponent=SpawnMesh
        Components.Add(SpawnMesh)
}