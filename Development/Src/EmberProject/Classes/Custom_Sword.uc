class Custom_Sword extends UTWeapon;

var array<Actor> HitArray;


var name StartSocket, EndSocket;
var int ComboTimer;
var int ComboMove;
var SoundCue Swipe1, Swipe2, Swipe3, Swipe4, Sheath;

var vector oldStart, oldStart2, oldStart3, oldEnd, oldEnd2, oldEnd3, oldMid;


    //debug properties
    var bool resetTracers;
/*
DebugPrint
    Easy way to print out debug messages
    If wanting to print variables, use: DebugPrint("var :" $var);
*/
simulated private function DebugPrint(string sMessage)
{
    GetALocalPlayerController().ClientMessage(sMessage);
}
//Starting our custom firing state

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // CylinderComponent.SetActorCollision(false, false); // disable cylinder collision
    // Mesh.SetActorCollision(true, true); // enable PhysicsAsset collision
    // Mesh.SetTraceBlocking(true, true); // block traces (i.e. anything touching mesh)
}

/*
WeaponFiring
    Main combo system and attack
*/
simulated state WeaponFiring{
    
    simulated event BeginState( Name PreviousStateName)
    {
        // DebugPrint("Combo Basic Move");
        //Check if there is any ammo for the current firemode.
        // if(!HasAmmo(CurrentFireMode))
        // {
        //     //Return if it's empty.
        //     WeaponEmpty();
        //     return;
        // }
        
        //The firemode for left click
        if(CurrentFireMode == 0)
        {
            //Set the state of the sword to be true, i.e. in the pawn's hand
            EmberPawn(Owner).SetSwordState(true);
            EmberPawn(Owner).Mesh.AttachComponentToSocket(Mesh,'WeaponPoint');
            
            //If the timer has got above 2, reset the combo.
            if(ComboTimer >= 5 && ComboMove >= 0)
            {
               if(ComboMove > 1 )
                   DebugPrint("Combo Reset");
                ComboMove = 0;
                ClearTimer('ComboTimerIncrease');
                ComboTimer = 0;
            }   
            
            //Run the first combo move
            if(Combotimer <= 5 && ComboMove == 0)
            {
                DebugPrint("Combo One");
                //Clear the timer
                ClearTimer('ComboTimerIncrease');
                ComboTimer = 0;
                //Change damage amount
                InstantHitDamage[0] = 10;
                // InstantHitDamage[0] = 10;
                //Play our relevant sound
                PlaySound(Swipe2);
                //Play the pawn's animation
                EmberPawn(Instigator).PlayAttack('Swipe1', 1);
                //Set the timer again
                SetTimer(0.25, true, 'ComboTimerIncrease');
                //Update how far along the combo we are.
                ComboMove = 1;
            }
            
            //Run the second combo move
            else if(Combotimer <= 5 && ComboMove == 1)
            {
                DebugPrint("Combo 2");
                //Same as above IF block
                ClearTimer('ComboTimerIncrease');
                ComboTimer = 0;
                InstantHitDamage[0] = 15;
                // InstantHitDamage[0] = 15;
                PlaySound(Swipe3);
                EmberPawn(Instigator).PlayAttack('Swipe2', 1);
                SetTimer(0.25, true, 'ComboTimerIncrease');
                ComboMove = 2;  
            }
            
            //Run the third combo move
            else if(Combotimer <= 5 && ComboMove == 2)
            {
                DebugPrint("Combo 3");
                //Same as above IF block
                ClearTimer('ComboTimerIncrease');
                ComboTimer = 0;
                InstantHitDamage[0] = 20;
                // InstantHitDamage[0] = 20;
                PlaySound(Swipe4);
                EmberPawn(Instigator).PlayAttack('Swipe3', 1);
                SetTimer(0.25, true, 'ComboTimerIncrease');
                ComboMove = 3; 
            }
            
            //Or if it was reset above, run the basic move.
            // else
            // {
            // //    DebugPrint("Combo Basic Move");
            //     //Same as above IF block
            //     ClearTimer('ComboTimerIncrease');
            //     ComboTimer = 0;
            //     InstantHitDamage[1] = 10;
            //     PlaySound(Swipe1);
            //     EmberPawn(Instigator).PlayAttack('Swipe0', 1);
            //     SetTimer(0.25, true, 'ComboTimerIncrease');
            //     ComboMove = 1;  
            // }
            
        }
        
        //Run any effects, such as muzzle flares and what not.
        //Although we defaulted them to nothing
        PlayFireEffects(CurrentFireMode);
        //Check for next fire interval
        SetTimer(GetFireInterval(CurrentFireMode), false, 'RefireCheckTimer');
        
    }
    
    simulated event EndState( Name NextStateName ){
        //Reset the array of hit pawns/actors
        // GetALocalPlayerController().ClientMessage("resetHitAray - EndState");
        HitArray.Length = 0;
        ClearTimer('RefireCheckTimer');
        NotifyWeaponFinishedFiring(CurrentFireMode);
        super.EndState(NextStateName);
        return;
    }
    simulated function RefireCheckTimer()
    {
        //Check if the pawn wants to put down the weapon.
        if(bWeaponPutDown)
        {
      //      PutDownWeapon();
            return;
        }
        if(ShouldRefire())
        {
            //Check if the controller wants to fire again.
            // GetALocalPlayerController().ClientMessage("resetHitAray - ShouldRefire");
            // HitArray.Length = 0;
            PlayFireEffects(CurrentFireMode);
            SetTimer(GetFireInterval(CurrentFireMode), false, 'RefireCheckTimer');
            return;
        }
        
        //Ends the firing sequence.
        HandleFinishedFiring();
    }
    
    
    function Tick(float DeltaTime)
    {
        local Vector Start, Start2, Start3, Mid, End3, End2, End;
        //Get the trace locations from your third person weapon mesh
        if(CurrentFireMode == 0)
        { 
        End = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).End;
        End2 = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).End2;
        End3 = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).End3;
        Start = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).Start; 
        Start2 = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).Start2; 
        Start3 = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).Start3; 
        Mid = Custom_Sword_Attach(EmberPawn(Owner).CurrentWeaponAttachment).Mid; 
            //Trace if in firemode 0, i.e. left click
            WeaponTrace(End, Start, Start2, Start3, End2, End3, Mid);
        }
        else
            resetTracers = true;
    }
    
    simulated event WeaponTrace(vector End, vector Start, vector Start2, vector Start3, vector End2, vector End3, vector Mid){
        local vector HitLocation, HitNormal;
        local Actor HitActor;
        if(!resetTracers)
        {
           
        DrawDebugLine(Start, oldStart, -1, 0, -1, true);
        DrawDebugLine(Start2, oldStart2, -1, 0, -1, true);
        DrawDebugLine(Start3, oldStart3, -1, 0, -1, true);
        DrawDebugLine(End, oldEnd, -1, 0, -1, true);
        DrawDebugLine(End2, oldEnd2, -1, 0, -1, true);
        DrawDebugLine(End3, oldEnd3, -1, 0, -1, true);
        DrawDebugLine(Mid, oldMid, -1, 0, -1, true);
        // DrawDebugLine(Start, End, -1, 0, -1, true);
        }
        else
         resetTracers = false;
        //Begin the trace from the recieved locations.
        HitActor = Trace(HitLocation, HitNormal, End, Start, true); 
        oldStart = start;
        oldStart2 = start2;
        oldStart3 = start3;
        oldEnd = end;
        oldEnd2 = end2;
        oldEnd3 = end3;
        oldMid = Mid;
        GetALocalPlayerController().ClientMessage("hitActor: " $HitActor);
        // GetALocalPlayerController().ClientMessage("HitLocation: " $HitLocation);
        // GetALocalPlayerController().ClientMessage("HitNormal: " $HitNormal);
        //Check if the trace collides with an actor.
        if(HitActor != none)
        {
            //Check to make sure the actor that is hit hasn't already been counted for during this attack.
            if(HitArray.Find(HitActor) == INDEX_NONE && HitActor.bCanBeDamaged)
            {
                GetALocalPlayerController().ClientMessage("iDamage: " $InstantHitDamage[CurrentFireMode]);
                GetALocalPlayerController().ClientMessage("iCount: " $CurrentFireMode);
                //Do the specified damage to the hit actor, using our custom damage type.
                HitActor.TakeDamage(InstantHitDamage[CurrentFireMode],
                Pawn(Owner).Controller, HitLocation, Velocity * 100.f, class'Custom_Sword_Damage');
                AmmoCount -= ShotCost[CurrentFireMode];
                //Add them to the hit array, so we don't hit them twice in one motion.
                HitArray.AddItem(HitActor);
            }
        }
    }
    
    //Finish the entire sequence.
    begin:
    FinishAnim(AnimNodeSequence(SkeletalMeshComponent(Mesh).FindAnimNode(WeaponFireAnim[CurrentFireMode])));
}

function ComboTimerIncrease()
{
    //Increase the combo timer.
    ComboTimer+=1;  
    //Check the sword state of the custom pawn.
    if(EmberPawn(Owner).GetSwordState())
    {
        if(ComboTimer == 5)  
        {
            //If the combo timer is above 4 ticks, play the sheath sound and animation
            // PlaySound(Sheath);
            // EmberPawn(Instigator).PlayAttack('sheath', 1.8);

        // GetALocalPlayerController().ClientMessage("sMessage: " $resetTracers);
        resetTracers = true;
                // DebugPrint("Combo Max");
        }
        if(ComboTimer >= 5)
        {

          //      DebugPrint("Combo Reset");
            //Once the anim is done, swap the sword to the sheath socket.
 //           EmberPawn(Owner).SetSwordState(false);  
            ComboTimer = 0;
            ComboMove = 0;
        }
    }
}       


DefaultProperties
{

    //This is all of the default stuff that would be set up for first person.
    // PlayerViewOffset=(X=0.000000,Y=0.00000,Z=0.000000)
    FiringStatesArray(1) = WeaponFiring
    
    //Sets up how much ammo to use per shot.
    ShotCost(1)=0
    bMeleeWeapon = true
    
    //Lets us create our own firing method.
    WeaponFireTypes(1)=EWFT_Custom
    
    //The two sockets we want to track and trace during attacking
    StartSocket = StartControl
    EndSocket = EndControl
    //     Begin Object Name=CollisionCylinder
    // // //   // CollisionRadius=+00102.00000
    // // //   // CollisionHeight=+00102.800000
    //  CollisionRadius=+0070.00000
    //  CollisionHeight=+0090.00000
    // End Object
    
    //More Default stuff
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    bCauseActorAnimEnd=true
    End Object
    
    //And even moreee
    Begin Object Name=FirstPersonMesh
    SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
    FOV=60
    Animations=MeshSequenceA
    AnimSets(1)=AnimSet'YourCustomPackage.AnimSets.AS_Sword'
    bForceUpdateAttachmentsInTick=True
    Scale=1
    End Object
    
    //Don't need this... defaulting it to nothing!
    Begin Object Name=PickupMesh
    SkeletalMesh=none
    Scale=1
    End Object
    
    //No more pesky noises
    WeaponEquipSnd=none
    WeaponPutDownSnd=none
    WeaponFireSnd(0)=none
    WeaponFireSnd(1)=none
    PickupSound=none
    
    //Defaulting as usual
    PivotTranslation=(Y=0.0)
    MuzzleFlashPSCTemplate=none
    MuzzleFlashLightClass=none
    
    //Set these to an arbitrary number above zero, so it doesn't get ejected from inventory
    MaxAmmoCount=100
    AmmoCount=100
    
    InventoryGroup=2
    
    //Good setup for combo intervals
    FireInterval(1)=0.25
    FireInterval(0)=0.1
    
    //Don't touch this bit!
    ArmsAnimSet=none
    Mesh=FirstPersonMesh
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    AttachmentClass=Class'Custom_Sword_Attach'
    
    //Defaulting the combo timer
    ComboTimer = 0
    
    //Cool sounds! Change these to the 'full link' from your content browser
    Swipe1 = SoundCue'YourCustomPackage.Cue.Swipe1'
    Swipe2 = SoundCue'YourCustomPackage.Cue.Swipe2'
    Swipe3 = SoundCue'YourCustomPackage.Cue.Swipe3'
    Swipe4 = SoundCue'YourCustomPackage.Cue.Swipe4'
    Sheath = SoundCue'YourCustomPackage.Cue.sheath'

    
}