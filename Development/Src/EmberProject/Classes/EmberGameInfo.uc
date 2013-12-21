class EmberGameInfo extends UTDeathMatch; 

//=============================================
// Global Vars
//=============================================
var EmberPlayerController playerControllerWORLD;
var EmberPawn playerpawnWORLD;


/*
AddDefaultInventory
  Reenable if we need to create inventories
*/
// function AddDefaultInventory( pawn PlayerPawn )
// {
// 	local int i;
// 	//-may give the physics gun to non-bots
// 	// if(PlayerPawn.IsHumanControlled() )
// 	// {
// 		PlayerPawn.CreateInventory(class'Custom_Sword',true);
// 	// }

// 	for (i=0; i<DefaultInventory.Length; i++)
// 	{
// 		//-Ensure we don't give duplicate items
// 		if (PlayerPawn.FindInventoryType( DefaultInventory[i] ) == None)
// 		{
// 			//-Only activate the first weapon
// 			PlayerPawn.CreateInventory(DefaultInventory[i], (i > 0));
// 		}
// 	}
// 	`Log("Adding inventory");
// 	PlayerPawn.AddDefaultInventory();

// }

/*
RestartPlayer
  Not sure if needed
*/
// function RestartPlayer(Controller aPlayer)
// {
// super.RestartPlayer(aPlayer);
// `Log("Player restarted");
// playerControllerWORLD = EmberPlayerController(aPlayer);
// playerControllerWORLD.resetMesh();
// }
// function DrawHud()
// {

// }
// function RecordTracers(vector l, name animation, float duration, float t1, float t2)
// {
// 	local Pawn p;
//    	p = Spawn(class'TestPawn', , , );
//    	p.SpawnDefaultController();
//     GetALocalPlayerController().ClientMessage("sMessage");
//    	// TestPawn(p).doAttackRecording(animation, duration, t1, t2);
// }


 defaultproperties

{
   DefaultPawnClass=class'EmberProject.EmberPawn'
   PlayerControllerClass=class'EmberProject.EmberPlayerController'
   MapPrefixes[0]="UDN"
}