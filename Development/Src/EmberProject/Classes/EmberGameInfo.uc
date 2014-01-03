class EmberGameInfo extends UTGame; 

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

// function DrawBar(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
// {

//     local int PosX,NbCases,i;

//     PosX = X; // Where we should draw the next rectangle
//     NbCases = 10 * Value / MaxValue;	 // Number of active rectangles to draw
//     i=0; // Number of rectangles already drawn

//     /* Displays active rectangles */
//     while(i < NbCases && i < 10)
//     {
//         Canvas.SetPos(PosX,Y);
//         Canvas.SetDrawColor(R,G,B,200);
//         Canvas.DrawRect(8,12);

//         PosX += 10;
//         i++;

//     }

//     /* Displays desactived rectangles */
//     while(i < 10)
//     {
//         Canvas.SetPos(PosX,Y);
//         Canvas.SetDrawColor(255,255,255,80);
//         Canvas.DrawRect(8,12);

//         PosX += 10;
//         i++;

//     }

//     /* Displays a title */
//     Canvas.SetPos(PosX + 5,Y);
//     Canvas.SetDrawColor(R,G,B,200);
//     Canvas.Font = class'Engine'.static.GetSmallFont();
//     Canvas.DrawText(Title);

// }
// function DrawHud()
// {
//         DrawBar("Health",playerpawnWORLD.Health, playerpawnWORLD.HealthMax,20,20,200,80,80);      
//         // DrawBar("Ammo",UTWeapon(PawnOwner.Weapon).AmmoCount, UTWeapon(PawnOwner.Weapon).MaxAmmoCount ,20,40,80,80,200);     
// // }
 static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Default.Class;
}

 defaultproperties

{
   DefaultPawnClass=class'EmberProject.EmberPawn'
   PlayerControllerClass=class'EmberProject.EmberPlayerController'
   HUDType=class'EmberProject.EmberHUD'
   MapPrefixes[0]="UDN"
   DefaultInventory(0)=0
	bUseClassicHUD=true
    // bUseClassicHUD=true
}