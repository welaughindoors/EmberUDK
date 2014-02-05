class EmberCosmetic_ItemList extends Object;

struct EmberCosmetic_ItemList_Struct
{
	var array<SkeletalMesh> CosmeticItemList;
	var array<SkeletalMesh> CapeItemList;

	var array<name> SocketLocationList;
	var array<float> CosmeticItemScaleList;
};

var EmberCosmetic_ItemList_Struct CosmeticStruct;




//==================================================
// API Part. Modify This
//==================================================

function InitiateCosmetics()
{

	/*
		Usage:
		 	AddStaticToSocket(SkeletalMesh, Socket, Scale)
		 		Add's a cosmetic with the specified mesh to the socket. Scale is optional (by default 1);

		 	AddClothToSocket(SkeletalMesh, Socket, Scale)
				Add's a cape with the specified mesh to the socket. Scale is optional (by default 1);

	*/

	//Item 1
	AddStaticToSocket(SkeletalMesh'Cosmetic.Headband', 'Helmet');

	//Item 2 (cape example), 10x Scale
	AddClothToSocket(SkeletalMesh'Cosmetic.TestCloth', 'CapeAttach', 10);
}

//==================================================
// END API. Begin System Functions
//==================================================









//==========================================================
// Ignore This Function. Makes Adding Shit More Compact
//==========================================================
function AddStaticToSocket(SkeletalMesh sMesh, name sSock, float Scaler = 1)
{
	CosmeticStruct.CosmeticItemList.AddItem(sMesh);
	CosmeticStruct.SocketLocationList.AddItem(sSock);
	CosmeticStruct.CosmeticItemScaleList.AddItem(Scaler);
}

function AddClothToSocket(SkeletalMesh sMesh, name sSock, float Scaler = 1)
{
	CosmeticStruct.CapeItemList.AddItem(sMesh);
	CosmeticStruct.SocketLocationList.AddItem(sSock);
	CosmeticStruct.CosmeticItemScaleList.AddItem(Scaler);
}

function SetCapeAttributes(SkeletalMeshComponent sMesh)
{
	sMesh.SetEnableClothSimulation(true);
    sMesh.SetClothFrozen(false);
    sMesh.SetClothSleep(false);
    sMesh.InitRBPhys();
    sMesh.ForceUpdate(false);
    	sMesh.SetRBChannel(RBCC_Default);
		sMesh.SetRBCollidesWithChannel(RBCC_Default,TRUE);
		sMesh.SetRBCollidesWithChannel(RBCC_Pawn,TRUE);
		sMesh.SetRBCollidesWithChannel(RBCC_Vehicle,TRUE);
		sMesh.SetRBCollidesWithChannel(RBCC_Cloth,TRUE);
		sMesh.SetRBCollidesWithChannel(RBCC_Water,TRUE);
		sMesh.SetRBCollidesWithChannel(RBCC_Clothing,TRUE);
}