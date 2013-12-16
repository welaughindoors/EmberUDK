class EmberPlayerController extends UTPlayerController;

var bool isTethering;

var SkeletalMesh defaultMesh;

var MaterialInterface defaultMaterial0;

var MaterialInterface defaultMaterial1;

var AnimTree defaultAnimTree;

var array<AnimSet> defaultAnimSet;

var AnimNodeSequence defaultAnimSeq;

var PhysicsAsset defaultPhysicsAsset;


/*
PlayerWalking
	Used for dodge. Queued for removal
*/
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
		if ( (DoubleClickMove == DCLICK_Active) && (Pawn.Physics == PHYS_Falling) )
			DoubleClickDir = DCLICK_Active;
		else if ( (DoubleClickMove != DCLICK_None) && (DoubleClickMove < DCLICK_Active) )
		{
			if ( EmberPawn(Pawn).Dodge(DoubleClickMove) )
				DoubleClickDir = DCLICK_Active;
		}

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
   local Rotator   DeltaRot, newRotation, ViewRotation;

   ViewRotation = Rotation;
   if (Pawn!=none)
   {
      Pawn.SetDesiredRotation(ViewRotation);
   }

   // Calculate Delta to be applied on ViewRotation
   DeltaRot.Yaw   = PlayerInput.aTurn;
   DeltaRot.Pitch   = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);

   NewRotation = ViewRotation;
   NewRotation.Roll = Rotation.Roll;

   if ( Pawn != None )
      Pawn.FaceRotation(NewRotation, deltatime);
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
exec function kButtonDown()
{
	EmberPawn(pawn).CreateTether();
}
exec function kbuttonUp ()
{
	EmberPawn(pawn).DetachTether();
}
exec function LeftShiftButtonDown()
{
	EmberPawn(pawn).startSprint();
}
exec function LeftShiftButtonUp ()
{
	EmberPawn(pawn).endSprint();
}
exec function increaseTether()
{
	EmberPawn(pawn).increaseTether();
}
exec function decreaseTether ()
{
	EmberPawn(pawn).decreaseTether();
}
exec function jumpIsRequested()
{
	EmberPawn(pawn).DoDoubleJump(true);
}

exec function jumpIsDenied()
{
	EmberPawn(pawn).DoDoubleJump(false);
	
}

exec function spawnDummy()
{
	local Pawn p;
	local vector l;
	l = Location;
	l.x += 20;
	p = Spawn(class'TestPawn');
	p.SpawnDefaultController();
	Spawn(class'Custom_Sword', , , l);
}

/*
leftMouseDown | leftMouseUp
	Queued for removal
*/
exec function leftMouseDown()
{
 	// Custom_Sword(UTWeapon).CurrentFireMode = 0;
}
exec function leftMouseUp()
{
	// Custom_Sword(UTWeapon).resetTracers = true;
}
exec function CntrlIsRequested()
{
	EmberPawn(pawn).kickCounter = 0;
	EmberPawn(pawn).DoKick();
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
// defaultMesh=SkeletalMesh'EmberBase.ember_player_mesh'
// defaultMesh=SkeletalMesh'mypackage.UT3_Male'
defaultMesh=SkeletalMesh'ArtAnimation.Meshes.ember_base'
// defaultAnimTree=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
 defaultAnimTree=AnimTree'ArtAnimation.Armature_Tree'
 
// defaultAnimSet(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
defaultAnimSet(0)=AnimSet'ArtAnimation.AnimSets.Armature'
defaultPhysicsAsset=PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics'
}