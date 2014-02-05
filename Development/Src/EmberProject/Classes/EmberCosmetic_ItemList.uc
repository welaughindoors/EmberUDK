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
		 	AddCosmeticToSocket(SkeletalMesh, Socket, Scale)
		 		Add's a cosmetic with the specified mesh to the socket. Scale is optional (by default 1);

		 	AddCapeToSocket(SkeletalMesh, Socket, Scale)
				Add's a cape with the specified mesh to the socket. Scale is optional (by default 1);

	*/

	//Item 1
	AddCosmeticToSocket(SkeletalMesh'Cosmetic.Headband', 'Helmet');

	//Item 2 (cape example), 10x Scale
	AddCapeToSocket(SkeletalMesh'Cosmetic.TestCloth', 'CapeAttach', 10);
}

//==================================================
// END API. Begin System Functions
//==================================================









//==========================================================
// Ignore This Function. Makes Adding Shit More Compact
//==========================================================
function AddCosmeticToSocket(SkeletalMesh sMesh, name sSock, float Scaler = 1)
{
	CosmeticStruct.CosmeticItemList.AddItem(sMesh);
	CosmeticStruct.SocketLocationList.AddItem(sSock);
	CosmeticStruct.CosmeticItemScaleList.AddItem(Scaler);
}

function AddCapeToSocket(SkeletalMesh sMesh, name sSock, float Scaler = 1)
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
}