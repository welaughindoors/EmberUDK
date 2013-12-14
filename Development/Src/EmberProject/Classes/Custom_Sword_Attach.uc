class Custom_Sword_Attach extends UTWeaponAttachment;


var SkeletalMeshComponent weapMesh;
var name StartSocket, EndSocket;
var bool LastSwordState;
var bool NewSwordState;
var Vector Start, Start2, Start3, Mid, End3, End2, End;


simulated function PostBeginPlay()
{
    //Initialise our reference to our sword.
    weapMesh = Mesh;
    Super.PostBeginPlay();
}


simulated event SetPosition(UDKPawn Holder)
{
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
    local Vector FinalLocation;
 
    compo = Holder.Mesh;
 
    if (compo != none)
    {
        //Find out socket called weaponpoint.
        socket = compo.GetSocketByName('WeaponPoint');
        if (socket != none)
        {
            FinalLocation = compo.GetBoneLocation(socket.BoneName);
        }
    } 
    //Update the location of the sword. 
    SetLocation(FinalLocation);
}


simulated function Tick(float DeltaTime)
{
    //Get the locations of the two sockets on the sword, and save them for later referencing
    Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
    Mesh.GetSocketWorldLocationAndRotation('EndControl', End);  
    Mesh.GetSocketWorldLocationAndRotation('EndControl 2', End2);  
    Mesh.GetSocketWorldLocationAndRotation('EndControl 3', End3);  
    Mesh.GetSocketWorldLocationAndRotation('StartControl 2', Start2);  
    Mesh.GetSocketWorldLocationAndRotation('StartControl 3', Start3);  
    Mesh.GetSocketWorldLocationAndRotation('MidControl', Mid);  
    //Check if the sword needs to be changed.  
    ChangeSwordState();
}


function ChangeSwordState()
{
    //Get the sword state of our custom pawn.
    NewSwordState = EmberPawn(Owner).GetSwordState();
    if(NewSwordState != LastSwordState)
    {
        //If its not the same as last time it was checked, detach it.
        EmberPawn(Owner).Mesh.DetachComponent(weapMesh);
        //Then we check which point it has to go to, and attach it there.
        if(!NewSwordState)
        {
            EmberPawn(Owner).Mesh.AttachComponentToSocket(weapMesh, 'Sheathe');
        }   
        else
        {
            EmberPawn(Owner).Mesh.AttachComponentToSocket(weapMesh, 'WeaponPoint');
        }
        LastSwordState = NewSwordState;
    }
}


DefaultProperties
{
    //Socket names
    StartSocket = StartControl
    EndSocket = EndControl
    
    bCollideActors = true
    CollisionType = Collide_BlockAll
    bCollideWorld=True

    
    //Sword Mesh
    Begin Object Name=SkeletalMeshComponent0
    SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
    CullDistance=5000.000000
    Scale=1.2
     CastShadow=false
    bUseAsOccluder=false
    bAcceptsDecals=false
    bOverrideAttachmentOwnerVisibility=true
    bAcceptsDynamicDecals=FALSE
    bHasPhysicsAssetInstance=true
    PhysicsAsset=PhysicsAsset'GDC_Materials.Meshes.SK_ExportSword2_Physics'
    End Object
    weapMesh = SkeletalMeshComponent0
    
    //More default stuff...
    bMakeSplash=False
    MuzzleFlashSocket=none
    MuzzleFlashLightClass=none
    MuzzleFlashDuration=0


    //Our sword state default setting
    LastSwordState = true
    
    //Don't touch!
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'Custom_Sword'
}