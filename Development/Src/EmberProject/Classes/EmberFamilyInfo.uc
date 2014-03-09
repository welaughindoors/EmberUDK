/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */

class EmberFamilyInfo extends UTFamilyInfo_Liandri
	abstract;

defaultproperties
{
	FamilyID="LIAM"

	CharacterMesh=SkeletalMesh'ArtAnimation.Meshes.ember_player' 

	PhysAsset=PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics'
	AnimSets(0)=AnimSet'ArtAnimation.AnimSets.Armature'
// LightEnvironment=MyLightEnvironment
	// ArmMeshPackageName="CH_Corrupt_Arms"
	// ArmMesh=CH_Corrupt_Arms.Mesh.SK_CH_Corrupt_Arms_MaleA_1P
	// ArmSkinPackageName="CH_Corrupt_Arms"
	// RedArmMaterial=CH_Corrupt_Arms.Materials.MI_CH_Corrupt_FirstPersonArms_VRed
	// BlueArmMaterial=CH_Corrupt_Arms.Materials.MI_CH_Corrupt_FirstPersonArms_VBlue

	// CharacterTeamHeadMaterials[0]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MBody01_VRed'
	// CharacterTeamBodyMaterials[0]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MHead01_VRed'
	// CharacterTeamHeadMaterials[1]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MBody01_VBlue'
	// CharacterTeamBodyMaterials[1]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MHead01_VBlue'
	// BaseMICParent=MaterialInstanceConstant'CH_All.Materials.MI_CH_ALL_Corrupt_Base'
	// BioDeathMICParent=MaterialInstanceConstant'CH_All.Materials.MI_CH_ALL_Corrupt_BioDeath'
}