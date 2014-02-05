class EmberCosmetic extends Actor;
var SkeletalMeshComponent Mesh;

/*
DebugPrint
  Easy way to print out debug messages
  If wanting to print variables, use: DebugPrint("var :" $var);
*/
simulated private function DebugPrint(string sMessage)
{
    GetALocalPlayerController().ClientMessage(sMessage);
}
function rotate(int nPitch, int nYaw, int nRoll)
{
   local Rotator newRot;    // This will be our new Rotation
    newRot.Pitch = nPitch;   // Since 65536 = 0 = 360, half of that equals 180, right?
    newRot.Yaw = nYaw;    // Since 65536 = 0 = 360, half of that equals 180, right?
    newRot.Roll = nRoll;   
    Mesh.SetRotation(newRot);
}

defaultproperties
{
      bCollideActors=True
      bBlockActors=True

    Begin Object class=SkeletalMeshComponent Name=SwordMesh
        // SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
        // SkeletalMesh=SkeletalMesh'ArtAnimation.Meshes.gladius'
        // PhysicsAsset=PhysicsAsset'GDC_Materials.Meshes.SK_ExportSword2_Physics'
       AlwaysLoadOnClient=true
       AlwaysLoadOnServer=true
       CastShadow=true
       BlockRigidBody=true 
       bUpdateSkelWhenNotRendered=false
       bIgnoreControllersWhenNotRendered=true
       bUpdateKinematicBonesFromAnimation=true
       bCastDynamicShadow=true
       RBChannel=RBCC_Untitled3
       bOverrideAttachmentOwnerVisibility=true
       bAcceptsDynamicDecals=false
       bHasPhysicsAssetInstance=true
       TickGroup=TG_PreAsyncWork
       MinDistFactorForKinematicUpdate=0.2f
       bChartDistanceFactor=true
       RBDominanceGroup=20
       Scale=1
       bAllowAmbientOcclusion=false 
       bUseOnePassLightingOnTranslucency=true
       bPerBoneMotionBlur=true
       bOwnerNoSee=false
       BlockActors=true
       BlockZeroExtent=true 
       BlockNonZeroExtent=true
       CollideActors=true
        End Object
    Mesh = SwordMesh
    Components.Add(SwordMesh)

}