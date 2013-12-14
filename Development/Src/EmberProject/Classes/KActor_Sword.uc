Class KActor_Sword Extends Actor
Placeable;


var SkeletalMeshComponent SwordMesh;

DefaultProperties
{
	bHardAttach=true

	Begin Object Class=SkeletalMeshComponent Name=SwordComponent
		SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
	End Object
	SwordMesh=SwordComponent
	Components.Add(ShieldComponent)
}
