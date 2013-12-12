Class EmberFamilyInfo extends UTFamilyInfo 
   abstract;

defaultproperties
{
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
		BlockRigidBody=true;
		CollideActors=true;
	CharacterMesh=SkeletalMesh'MyPackage.UT3_Male'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
		AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
}