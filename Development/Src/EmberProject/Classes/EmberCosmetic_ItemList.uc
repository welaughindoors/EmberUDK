class EmberCosmetic_ItemList extends Object;

var array<SkeletalMesh> CosmeticItemList;
var array<name> SocketLocationList;

function InitiateCosmetics()
{
	//Item 1
	CosmeticItemList.AddItem(SkeletalMesh'Cosmetic.Headband');
	SocketLocationList.AddItem('Helmet');
}