class EmberGameInfo extends UTGame; 

//=============================================
// Global Vars
//=============================================
var int pawnsActiveOnPlayer;

var struct AttackPacketStruct
{
	var name AnimName;
	var array<float> Mods;
	var float tDur;
	var bool isActive;
} AttackPacket;
var int counterForPawns;
/*
AddDefaultInventory
  Reenable if we need to create inventories
*/
function AddDefaultInventory( pawn PlayerPawn )
{
	PlayerPawn.AddDefaultInventory();

}
// function PostBeginPlay()
// {
//   Super.PostBeginPlay();

//   // Set the timer which broad casts a random message to all players
//   SetTimer(1.f, true, 'RandomBroadcast');
// }

event InitGame( string Options, out string ErrorMessage )
{
    local string InOpt;
    super.InitGame(Options, ErrorMessage);
	// `log("INITGAME");
 //    InOpt = ParseOption(Options, "MyTeam");
 //    if(InOpt != "")
 //        MyTeam = int(InOpt);
	// `log("MyTeamINIT" @MyTeam);
}
// function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
// {
// 	local PlayerStart P, BestStart;
// 	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
// 		{
// 			PlayerStartPointsUsed.AddItem(P);
// 		}
// 		if(MyTeam == 1)
// 			BestStart = PlayerStartPointsUsed[0];
		
// 		else
// 			BestStart = PlayerStartPointsUsed[1];

// 		return BestStart;
// }
/*
RestartPlayer
  Not sure if needed
*/
 simulated function RestartPlayer(Controller aPlayer)
{
super.RestartPlayer(aPlayer);
if(aPlayer.bIsPlayer)
Broadcast(self, "player spawn"@aPlayer);
if(aPlayer.pawn ==none)
{
	Broadcast(self, "no pawn");
return;
}

// EmberPlayerController(aPlayer).SaveMeshValues();
}


// function RandomBroadcast()
// {
//   local EmberPlayerController PlayerController;
//   local EmberPawn pawn;
//   local string BroadcastMessage;

//   if (WorldInfo != None)
//   {
//     // Constuct a random text message
//     for (i = 0; i < 32; ++i)
//     {
//       BroadcastMessage $= Chr(Rand(255));
//     }

//     ForEach WorldInfo.AllControllers(class'EmberPlayerController', PlayerController)
//     {
//       pawn = EmberPawn(PlayerController.pawn);
//       pawn.ClientAttackAnimReplication(BroadcastMessage);
//     }
//   }
// }


 static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Default.Class;
}

 defaultproperties

{
// bRestartLevel =false;
	pawnsActiveOnPlayer = 0
	counterForPawns = 0;
	// bNoCollisionFail=true
   DefaultPawnClass=class'EmberProject.EmberPawn'
   PlayerControllerClass=class'EmberProject.EmberPlayerController'
  PlayerReplicationInfoClass=class'EmberProject.EmberReplicationInfo'
   HUDType=class'EmberProject.EmberHUD'
   MapPrefixes[0]="UDN"
   bDelayedStart = false
   // DefaultInventory(0)=none
	// bUseClassicHUD=true
    // bUseClassicHUD=true
}