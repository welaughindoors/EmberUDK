class TestPawnController extends GameAIController;

var Pawn thePlayer; //variable to hold the target pawn
var float startTheClock;

simulated event PostBeginPlay()
{
  super.PostBeginPlay();

}

 event SeePlayer(Pawn SeenPlayer) //bot sees player
{
          if (thePlayer ==none) //if we didnt already see a player
          {
    thePlayer = SeenPlayer; //make the pawn the target
    startTheClock = 0;
    GoToState('Follow'); // trigger the movement code
                // TestPawn(pawn).doAttack ('ember_attack_forward', 1.0, 0.65, 0) ;
                    GetALocalPlayerController().ClientMessage("sMessage");
          }
}

state Follow
{
      Simulated Event Tick(float DeltaTime)
    {
      Super.Tick(DeltaTime);
      startTheClock += DeltaTime;
      prepareTheAttack();
    }
Begin:

    if (thePlayer != None)  // If we seen a player
    {
      if(VSize(pawn.location - thePlayer.location) > 200)
      MoveTo(thePlayer.Location); // Move directly to the players location
      GoToState('Looking'); //when we get there
    }

}

state Looking
{
Begin:

  if (thePlayer != None)  // If we seen a player
    {
      if(VSize(pawn.location - thePlayer.location) > 200)
    MoveTo(thePlayer.Location); // Move directly to the players location
    GoToState('Follow');  // when we get there
    }

}

function prepareTheAttack()
{
  local float distanceToAttack, timeToAttack;
      distanceToAttack = 150;
      timeToAttack = 1.00;
    if(VSize(pawn.location - thePlayer.location) <= distanceToAttack && startTheClock >= timeToAttack)
    {
      startTheClock = 0;
      TestPawn(pawn).doAttack ('ember_attack_forward', 1.0, 0.65, 0) ;
    }
}


defaultproperties
{

}
                