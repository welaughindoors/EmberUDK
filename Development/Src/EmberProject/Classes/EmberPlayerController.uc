class EmberPlayerController extends UTPlayerController;



//=============================================
// Mesh and Character Variables
//=============================================
var SkeletalMesh defaultMesh;
var MaterialInterface defaultMaterial0;
var MaterialInterface defaultMaterial1;
var AnimTree defaultAnimTree;
var array<AnimSet> defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;
var PhysicsAsset defaultPhysicsAsset;

//=============================================
// Misc Variables
//=============================================

var bool isTethering;
var float      playerStrafeDirection;

//=============================================
// Camera Variables
//=============================================
var bool interpolateForCameraIsActive;
var int allowPawnRotationWhenStationary;
var int allowSpineRotation;
var float pawnRotationDotAngle;

//=============================================
// Overrided Functions
//=============================================
/*
PlayerWalking
	Used for dodge. Queued for removal
*/
    //ember_jerkoff_block
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;
   /*
    * The function called when the user presses the fire key (left mouse button by default)
    */
   exec function StartFire( optional byte FireModeNum )
   {

      //Moves Mouse a little bit to allow rapid clicks (unreal issue)
   local vector2D MPos;
   MPos = LocalPlayer(Player).ViewportClient.GetMousePosition();
   LocalPlayer(Player).ViewportClient.SetMouse(MPos.X, MPos.Y+2);

      //Does attack or block, depends on FireModeNum
   FireModeNum == 0 ? EmberPawn(pawn).doAttack(playerStrafeDirection) : EmberPawn(pawn).doBlock();

   }
simulated function StopFire(optional byte FireModeNum )
{
   if(FireModeNum == 1)
   EmberPawn(pawn).cancelBlock();
}
   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
		if ( (DoubleClickMove == DCLICK_Active) && (Pawn.Physics == PHYS_Falling) )
			DoubleClickDir = DCLICK_Active;
		else if ( (DoubleClickMove != DCLICK_None) && (DoubleClickMove < DCLICK_Active) )
		{
			if ( EmberPawn(Pawn).Dodge(DoubleClickMove) )
				DoubleClickDir = DCLICK_Active;
		}

   playerStrafeDirection = PlayerInput.aStrafe;
      if( Pawn == None )
      {
         return;
      }

      if (Role == ROLE_Authority)
      {
         // Update ViewPitch for remote clients
         Pawn.SetRemoteViewPitch( Rotation.Pitch );
      }

      Pawn.Acceleration = NewAccel;

      CheckJumpOrDuck();
		Super.ProcessMove(DeltaTime,NewAccel,DoubleClickMove,DeltaRot);
   }
}
/*
UpdateRotation
*/
function UpdateRotation( float DeltaTime )
{
   local Rotator   DeltaRot, newRotation, ViewRotation, spineRotate;
local Vector v1, v2;
local float dott;
   ViewRotation = Rotation;
   // if (Pawn!=none)
   // {
   //    Pawn.SetDesiredRotation(ViewRotation);
   // }

   // Calculate Delta to be applied on ViewRotation
   DeltaRot.Yaw   = PlayerInput.aTurn;
   DeltaRot.Pitch   = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);

   NewRotation = ViewRotation;
   NewRotation.Roll = Rotation.Roll;

if(VSize(pawn.Velocity) != 0)  
   // if ( Pawn != None )
      Pawn.FaceRotation(NewRotation, deltatime);
      else
      { 
         v1 = normal(vector(Rotation));
         v2 = normal(vector(pawn.Rotation));
         dott = v1 dot v2; 
         if(dott < pawnRotationDotAngle)
            interpolateForCameraIsActive = true;

         else if(dott >= 0.95)
            interpolateForCameraIsActive = false;

            if(interpolateForCameraIsActive && allowPawnRotationWhenStationary == 1)
            Pawn.FaceRotation(RInterpTo(Pawn.Rotation, NewRotation, DeltaTime, 60000, true),DeltaTime);
         }
         if(allowSpineRotation == 1)
         {
         spineRotate.Pitch = -newRotation.Pitch;
         EmberPawn(pawn).SpineRotator.BoneRotation = spineRotate;
      }
}   

/* 
PostBeginPlay
*/
Simulated Event PostBeginPlay() {
   super.postbeginplay();

   //set Self's worldinfo var
   EmberGameInfo(WorldInfo.Game).playerControllerWORLD = Self;

   SetTimer(0.25, false, 'resetMesh');
}
//=============================================
// Keybinded Functions
//=============================================

/*
eButtonDown
*/
exec function eButtonDown()
{
   EmberPawn(pawn).tetherBeamProjectile();
}
/*
ebuttonUp
*/
exec function ebuttonUp ()
{
   EmberPawn(pawn).DetachTether();
}
/*
increaseTether
   MouseScrollUp
*/
exec function increaseTether()
{
   EmberPawn(pawn).increaseTether();
}
/*
decreaseTether
   MouseScrollDown
*/
exec function decreaseTether ()
{
   EmberPawn(pawn).decreaseTether();
}
//=============================================
// @Temporarily disabled. 
// @Renable in DefaultInput.ini
//=============================================
/*
jumpIsRequested
   Space pressed Down
*/
exec function jumpIsRequested()
{
   EmberPawn(pawn).DoDoubleJump(true);
}
/*
jumpIsDenied
   Space let Go
*/
exec function jumpIsDenied()
{
   EmberPawn(pawn).DoDoubleJump(false);
   
}
/*
leftMouseDown
   When click, does attack based on strafe direction
   Moves mouse slightly to allow multiple attacks (otherwise multiclick is disabled)
*/
exec function leftMouseDown()
{
   // local vector2D MPos;
   // MPos = LocalPlayer(Player).ViewportClient.GetMousePosition();
   // LocalPlayer(Player).ViewportClient.SetMouse(MPos.X, MPos.Y+2);
   // EmberPawn(pawn).doAttack(playerStrafeDirection);
   // EmberPawn(pawn).SpawnStuff();
   // Custom_Sword(UTWeapon).CurrentFireMode = 0;
}
/*
leftMouseUp
   Queued for deletion
*/
exec function leftMouseUp()
{
   // Custom_Sword(UTWeapon).resetTracers = true;
}
/*
CntrlIsRequested
   Queued for deletion
*/
exec function CntrlIsRequested()
{
   EmberPawn(pawn).kickCounter = 0;
   EmberPawn(pawn).DoKick();
}
/*
LightStance
   Switch to Light Stance 
*/
exec function LightStance()
{
EmberPawn(pawn).LightStance();
}
/*
BalanceStance
   Switch to Light Stance
*/
exec function BalanceStance()
{
EmberPawn(pawn).BalanceStance();
}
/*
HeavyStance
   Switch to Light Stance
*/
exec function HeavyStance()
{
EmberPawn(pawn).HeavyStance();
}
//=============================================
// Custom Functions
//=============================================
/*
spawnDummy
  Creates a dummy at player's spawn point
*/
exec function spawnDummy()
{
   local Pawn p;
   p = Spawn(class'TestPawn');
   p.SpawnDefaultController();
   // Spawn(class'Custom_Sword', , , l);
}

function RecordTracers(name animation, float duration, float t1, float t2)
{ 
   local Pawn p;
      p = Spawn(class'TestPawn', , , );
      // p.SpawnDefaultController();
    GetALocalPlayerController().ClientMessage("sMessage");
      TestPawn(p).doAttackRecording(animation, duration, t1, t2);
}
//=============================================
// Console Functions
//=============================================
exec function ep_player_spine_rotation(float Toggle = -3949212)
{
   allowSpineRotation = (Toggle == -3949212) ? ModifiedDebugPrint("Allows spine rotation for looking up and down. 1 = true, 0 = false. Current Value - ", allowSpineRotation) : Toggle;
}
exec function ep_player_rotation_when_stationary(float Toggle = -3949212)
{
   allowPawnRotationWhenStationary = (Toggle == -3949212) ? ModifiedDebugPrint("Allows player rotation when stationary. 1 = true, 0 = false. Current Value - ", allowPawnRotationWhenStationary) : Toggle;
}
exec function ep_player_rotation_when_stationary_angle(float dot_angle = -3949212)
{
   pawnRotationDotAngle = (dot_angle == -3949212) ? ModifiedDebugPrint("Dot angle detection to rotate player to camera. examples can be found under command dot_angle_examples. Current Value - ", pawnRotationDotAngle) : dot_angle;
}
exec function dot_angle_examples(float dot_angle = -3949212)
{
   GetALocalPlayerController().ClientMessage("Example angles: 1 = 0 degrees, 0.5 = 45 degrees, 0 = 90 degrees, -0.5 = 135 degrees, -1 = 180 degrees.");
}
function float ModifiedDebugPrint(string sMessage, float variable)
{
   GetALocalPlayerController().ClientMessage(sMessage @ string(variable));
   return variable; 
}
function bool ModifiedDebugPrintBool(string sMessage, bool variable)
{
   GetALocalPlayerController().ClientMessage(sMessage @ string(variable));
   return variable;
}
/*
resetMesh
	Sets custom mesh
*/
public function resetMesh()
{
self.Pawn.Mesh.SetSkeletalMesh(defaultMesh);
self.Pawn.Mesh.SetMaterial(0,defaultMaterial0);
self.Pawn.Mesh.SetMaterial(1,defaultMaterial1);
self.Pawn.Mesh.SetPhysicsAsset(defaultPhysicsAsset );
self.Pawn.Mesh.AnimSets=defaultAnimSet;
self.Pawn.Mesh.SetAnimTreeTemplate(defaultAnimTree );
}

defaultproperties
{
   pawnRotationDotAngle = 0.16f
    interpolateForCameraIsActive = false
    allowPawnRotationWhenStationary = 1.0f
    allowSpineRotation = 1.0f
// defaultMesh=SkeletalMesh'EmberBase.ember_player_mesh'
// defaultMesh=SkeletalMesh'mypackage.UT3_Male'
defaultMesh=SkeletalMesh'ArtAnimation.Meshes.ember_player'
// defaultAnimTree=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
 defaultAnimTree=AnimTree'ArtAnimation.Armature_Tree'
 
// defaultAnimSet(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
defaultAnimSet(0)=AnimSet'ArtAnimation.AnimSets.Armature'
defaultPhysicsAsset=PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics'
}