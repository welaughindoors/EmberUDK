class EmberCosmetic_ItemList extends Object;

var array<SkeletalMesh> CosmeticItemList;
var array<name> SocketLocationList;

function InitiateCosmetics()
{
	//Item 1
	AddCosmeticToSocket(SkeletalMesh'Cosmetic.Headband', 'Helmet');
}

//==========================================================
// Ignore This Function. Makes Adding Shit More Compact
//==========================================================
function AddCosmeticToSocket(SkeletalMesh sMesh, name sSock)
{
	CosmeticItemList.AddItem(sMesh);
	SocketLocationList.AddItem(sSock);
}
