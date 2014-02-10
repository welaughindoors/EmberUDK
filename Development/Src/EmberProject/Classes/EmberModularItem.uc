class EmberModularItem extends SkeletalMeshComponent;

var const array<ActorComponent> Components;

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=ModularSkeletalMeshComponent    
    bCacheAnimSequenceNodes=false
    AlwaysLoadOnClient=true
    AlwaysLoadOnServer=true
    CastShadow=true
    BlockRigidBody=true
    bUpdateSkelWhenNotRendered=false
    bIgnoreControllersWhenNotRendered=true
    bUpdateKinematicBonesFromAnimation=true
    bCastDynamicShadow=true
    RBChannel=RBCC_Pawn
    RBCollideWithChannels=(Default=true, Cloth=true, Pawn=true, Vehicle=true, Untitled3=true, BlockingVolume=true)
    LightEnvironment=MyLightEnvironment
    bOverrideAttachmentOwnerVisibility=true
    bAcceptsDynamicDecals=false
    bHasPhysicsAssetInstance=true
    TickGroup=TG_PreAsyncWork
    MinDistFactorForKinematicUpdate=0.2
    bChartDistanceFactor=true
    RBDominanceGroup=20
    bUseOnePassLightingOnTranslucency=true
    bPerBoneMotionBlur=true
  End Object
  Components.Add(ModularSkeletalMeshComponent)
}