class TestPawnController extends GameAIController;

var Pawn thePlayer; //variable to hold the target pawn

simulated event PostBeginPlay()
{
  super.PostBeginPlay();

}

 event SeePlayer(Pawn SeenPlayer) //bot sees player
{
          if (thePlayer ==none) //if we didnt already see a player
          {
    thePlayer = SeenPlayer; //make the pawn the target
    GoToState('Follow'); // trigger the movement code
                // TestPawn(pawn).doAttack ('ember_attack_forward', 1.0, 0.65, 0) ;
                    GetALocalPlayerController().ClientMessage("sMessage");
          }
}

state Follow
{

Begin:

    if (thePlayer != None)  // If we seen a player
    {

                TestPawn(pawn).doAttack ('ember_attack_forward', 1.0, 0.65, 0) ;
    MoveTo(thePlayer.Location); // Move directly to the players location
                GoToState('Looking'); //when we get there
    }

}

state Looking
{
Begin:
  if (thePlayer != None)  // If we seen a player
    {

    MoveTo(thePlayer.Location); // Move directly to the players location
                GoToState('Follow');  // when we get there
    }

}

defaultproperties
{

}