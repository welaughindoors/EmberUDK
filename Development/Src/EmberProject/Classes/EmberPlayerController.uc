class EmberPlayerController extends UTPlayerController;

var bool isTethering;

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

Simulated Event PostBeginPlay() {

   //very important line
   super.postbeginplay();

   //set Self's worldinfo var
   EmberGameInfo(WorldInfo.Game).playerControllerWORLD = Self;

   //SetTimer(0.1, false, 'SetWorldVars');
}
exec function kButtonDown()
{
	EmberPawn(pawn).CreateTether();
}
exec function kbuttonUp ()
{
	EmberPawn(pawn).DetachTether();
	// EmberPawn(pawn).tetherStatusForVel = true;
}
exec function LeftShiftButtonDown()
{
	//    local Pawn p;
	// 	p = Spawn(class'TestPawn');
	// p.SpawnDefaultController();
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

exec function spawnDummy()
{

		   local Pawn p;
		p = Spawn(class'TestPawn');
	p.SpawnDefaultController();
}
Simulated Event Tick(float DeltaTime)
{
   	 Super.Tick(DeltaTime);
	//if(PlayerInput.PressedKeys[0].Find('Q') >= 0) {
  		// Do something
  		ClientMessage("hi : " $PlayerInput.PressedKeys[0]);	//	}

}

defaultproperties
{
}
	