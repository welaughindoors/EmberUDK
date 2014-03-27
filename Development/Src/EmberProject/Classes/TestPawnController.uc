class TestPawnController extends GameAIController;

var Pawn thePlayer; //variable to hold the target pawn
var float startTheClock;
var float timeTillSync;
var bool noPlayerSeen;
// var array<name> attackList;


var struct AttackPacketStruct
{
  var name AnimName;
  var array<float> Mods;
} AttackPacket;

simulated event Tick(float DeltaTime)
{
  super.Tick(DeltaTime);
  if(thePlayer != None)
  timeTillSync+= DeltaTime;
  if(timeTillSync >= 0.7)
  {
    timeTillSync = 0;
  // if(EmberGameInfo(WorldInfo.Game).AttackPacket.isActive)
    // randomizeAttack();
  }
  startTheClock+= DeltaTime;
}
simulated private function DebugPrint(string sMessage)
{
    GetALocalPlayerController().ClientMessage(sMessage);
}

simulated event PostBeginPlay()
{
  super.PostBeginPlay();
}


// simulated function copyToAttackStruct(name animName, array<float> mods)
// {
//   TestPawn(pawn).doAttack () ;
//   // local int i;
//   // AttackPacket.AnimName = animName;
//   // for(i = 0; i < mods.length; i++)
//   //   AttackPacket.Mods[i] = mods[i];
// }

simulated function DoCounterAttack()
{
  // EmberGameInfo(WorldInfo.Game).AttackPacket.isActive = false;
  // if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumForwardString1)
  //   copyToAttackStruct(aFramework.mediumForwardString1, aFramework.mediumForwardString1Mods);
  // else if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumbackLeftString1)
  // copyToAttackStruct(aFramework.mediumRightString1, aFramework.mediumRightString1Mods);
  // else if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumbackRightString1)
  // copyToAttackStruct(aFramework.mediumForwardLeftString1, aFramework.mediumForwardLeftString1Mods);
  // else if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumForwardLeftString1)
  // copyToAttackStruct(aFramework.mediumForwardRightString1, aFramework.mediumForwardRightString1Mods);
  // else if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumForwardRightString1)
  // copyToAttackStruct(aFramework.mediumLeftString1, aFramework.mediumLeftString1Mods);
  // else if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumRightString1)
  // copyToAttackStruct(aFramework.mediumLeftString1, aFramework.mediumLeftString1Mods);
  // else if(EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName == aFramework.mediumLeftString1)
  // copyToAttackStruct(aFramework.mediumRightString1, aFramework.mediumRightString1Mods);
  // else
  // {
  //   EmberGameInfo(WorldInfo.Game).AttackPacket.isActive = false;

    randomizeAttack();
  // }
  
}

simulated function randomizeAttack()
{
  local int i;
  if(EmberGameInfo(WorldInfo.Game).AttackPacket.isActive)
    {
      DoCounterAttack();
      return;
    }
  i = Rand(7) + 16;
  TestPawn(pawn).doAttack (i) ;
}
simulated function TalkToPlayer(string message)
{
  thePlayer.Instigator.Controller.ConsoleCommand("say"@message);
}

 event SeePlayer(Pawn SeenPlayer) //bot sees player
{
          if (thePlayer ==none && TestPawn(pawn).followPlayer == 1) //if we didnt already see a player
          {
    thePlayer = SeenPlayer; //make the pawn the target
    TalkToPlayer("I see you. I'm coming to kill you.");
    EmberGameInfo(WorldInfo.Game).pawnsActiveOnPlayer++;
    
    TestPawn(pawn).talkCounterChooser = Rand(19);
    Focus = SeenPlayer;
    startTheClock = 0;
    GoToState('Follow'); // trigger the movement code
                // TestPawn(pawn).doAttack ('ember_attack_forward', 1.0, 0.65, 0) ;
                    // GetALocalPlayerController().ClientMessage("sMessage");
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

    if (thePlayer != None && TestPawn(pawn).followPlayer == 1)  // If we seen a player
    {
      if(VSize(pawn.location - thePlayer.location) > 200)
      MoveTo(thePlayer.Location); // Move directly to the players location
      GoToState('Looking'); //when we get NetherEngine
    }

}

state Looking
{
Begin:

  if (thePlayer != None && TestPawn(pawn).followPlayer == 1)  // If we seen a player
    {
      noPlayerSeen = false;
      Focus = thePlayer;
    if(VSize(pawn.location - thePlayer.location) > 200)
    MoveTo(thePlayer.Location); // Move directly to the players location
    GoToState('Follow');  // when we get there
    }
    else
      noPlayerSeen = true;

}
 
function prepareTheAttack()
{
  // local float timeToAttack;
      // timeToAttack = 0.3;
      Focus = thePlayer;
      // DebugPrint("prep");
      //VSize(pawn.location - thePlayer.location) <= TestPawn(pawn).attackPlayerRange &&
    if( TestPawn(pawn).GetTimeLeftOnAttack() == 0 && !noPlayerSeen && TestPawn(pawn).attackPlayer == 1 && startTheClock > 0.5)
    {
      startTheClock = 0;
      randomizeAttack();
//Rand(attackList.length)
      // TestPawn(pawn).doAttack (AttackPacket) ;
    }
}
//================================
// Console Vars
//================================

function float ModifiedDebugPrint(string sMessage, float variable)
{
  DebugPrint(sMessage @ string(variable));
  return variable;
}
defaultproperties
{
noPlayerSeen = true;
}
                