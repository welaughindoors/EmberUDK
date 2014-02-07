class EmberGameInfo extends UTGame; 

//=============================================
// Global Vars
//=============================================
var EmberPlayerController playerControllerWORLD;
var EmberPawn playerpawnWORLD;

var struct AttackPacketStruct
{
	var name AnimName;
	var array<float> Mods;
	var float tDur;
	var bool isActive;
} AttackPacket;

/*
AddDefaultInventory
  Reenable if we need to create inventories
*/
function AddDefaultInventory( pawn PlayerPawn )
{
	// local int i;
	//-may give the physics gun to non-bots
	// if(PlayerPawn.IsHumanControlled() )
	// {
		// PlayerPawn.CreateInventory(class'Custom_Sword',true);
	// }

	// for (i=0; i<DefaultInventory.Length; i++)
	// {
	// 	//-Ensure we don't give duplicate items
	// 	if (PlayerPawn.FindInventoryType( DefaultInventory[i] ) == None)
	// 	{
	// 		//-Only activate the first weapon
	// 		PlayerPawn.CreateInventory(DefaultInventory[i], (i > 0));
	// 	}
	// }
	// `Log("Adding inventory");
	PlayerPawn.AddDefaultInventory();

}

/*
RestartPlayer
  Not sure if needed
*/
function RestartPlayer(Controller aPlayer)
{
super.RestartPlayer(aPlayer);
playerControllerWORLD = EmberPlayerController(aPlayer);
playerControllerWORLD.resetMesh();
}

 static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Default.Class;
}

 defaultproperties

{
   DefaultPawnClass=class'EmberProject.EmberPawn'
   PlayerControllerClass=class'EmberProject.EmberPlayerController'
  PlayerReplicationInfoClass=class'EmberProject.EmberReplicationInfo'
   HUDType=class'EmberProject.EmberHUD'
   MapPrefixes[0]="UDN"
   // DefaultInventory(0)=none
	// bUseClassicHUD=true
    // bUseClassicHUD=true
}