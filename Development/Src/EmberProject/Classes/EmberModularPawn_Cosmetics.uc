/* Readme
/ -- 
/ -- This class controls the skeletal meshes that will be applied to the Modular Pawn
/ -- 
/ -- do NOT CHANGE Skeletal Mesh for Head unless you know what you're doing
/ -- Head controls sockets, animations, and linkage. Changing it to something that isn't prepared will break pawn
/ -- 
/ -- All other modules are good to go for swapping
*/
class EmberModularPawn_Cosmetics extends Object;

var pawn Owner;
var SkeletalMeshComponent ParentModularItem;
var array<SkeletalMesh> HeadList;
var array<SkeletalMesh> TorsoList;
var array<SkeletalMesh> ArmsList;
var array<SkeletalMesh> HandsList;
var array<SkeletalMesh> LegsList;
var array<SkeletalMesh> FeetList;
// var array<SkeletalMesh> ComponentList;
var array<EmberModularItem> SkelMeshList;


//==================================================
// API Part. Modify This
//==================================================

//Sets up a list that will be used to add components. 
function SetupComponentList()
{
	//Adds Heads
	HeadList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_head_01'); //Index = 0
	HeadList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_head_02'); //Index = 1

	//Adds Torsos
	TorsoList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_torso_01'); //Index = 0
	TorsoList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_torso_02'); //Index = 1
	TorsoList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_torso_03'); //Index = 2

	//Adds Arms
	ArmsList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_arms_01'); //Index = 0

	//Adds Hands
	HandsList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_hands_01'); //Index = 0

	//Adds Legs
	LegsList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_legs_01'); //Index = 0

	//Adds Feets
	FeetList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_feet_01'); //Index = 0
	
}

//==================================================
// END API. Begin System Functions
//==================================================

//Change this ONLY if you know what you're doing
function setParentModularItem()
{
	
	//This is the 'head'. Everything relies on this. Fuck this up and pawn's fucked up
	
	//Set the parent mesh (set in Setup Components List above)
	ParentModularItem.SetSkeletalMesh(HeadList[0]);
	//Set the physics asset
	ParentModularItem.SetPhysicsAsset(PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics');
	//Set the AnimTree Template
	ParentModularItem.SetAnimTreeTemplate(AnimTree'ArtAnimation.Armature_Tree');
	//Set the AnimationSets
	ParentModularItem.AnimSets[0]=AnimSet'ArtAnimation.AnimSets.Armature';
	//Translate the mesh downwards to 'hit' the ground
	ParentModularItem.SetTranslation(vect(0,0,-49.8));
}

function SetChildModularInfo(SkeletalMesh ChildMesh)
{
		local EmberModularItem newModule;
		//Make a new preset module item
		newModule = new(self) class'EmberModularItem';
		//Change the mest to whats in the list
		newModule.SetSkeletalMesh(ChildMesh);
		//Set the parent animation component (the head)
		newModule.SetParentAnimComponent(ParentModularItem);
		// newModule.SetLightEnvironment(MyLightEnvironment);
		//Set the parent Shadow component (the head)
		newModule.SetShadowParent(ParentModularItem);
		//Adds mesh to a list to be accessed by EmberPawn to apply correct lighting to it
		SkelMeshList.AddItem(newModule);
		//Attach the component to the player character
		Owner.AttachComponent(newModule);
}
function SwapModularItem(int Category, int ModularItemIndex)
{
	//If it's the first category, it's head. Swap head
	if(Category == 1) ParentModularItem.SetSkeletalMesh(HeadList[ModularItemIndex]);

	else
	{
		//Set Category down by 2, to be 1:1 correlation with SkelMeshList
		//I.e. Torso would be Category 2, but it's the first item in SkelMeshList, which is the same as SkelMeshList[0]
		Category -= 2;
		switch (Category)
		{
			//Torso
			case 0:
				SkelMeshList[Category].SetSkeletalMesh(TorsoList[ModularItemIndex]);
				break;
		
			case 1:
				SkelMeshList[Category].SetSkeletalMesh(ArmsList[ModularItemIndex]);
				break;
		
			case 2:
				SkelMeshList[Category].SetSkeletalMesh(HandsList[ModularItemIndex]);
				break;
		
			case 3:
				SkelMeshList[Category].SetSkeletalMesh(LegsList[ModularItemIndex]);
				break;
		
			case 4:
				SkelMeshList[Category].SetSkeletalMesh(FeetList[ModularItemIndex]);
				break;
			default:
		}
	}

}

function setChildModularItems()
{
	// local EmberModularItem newModule;
	// local int i;

	//Might need this later

	//Going through each member in the list...
	// for(i = 0; i < ComponentList.length; i++)
	// {
	// 	//Make a new preset module item
	// 	newModule = new(self) class'EmberModularItem';
	// 	//Change the mest to whats in the list
	// 	newModule.SetSkeletalMesh(ComponentList[i]);
	// 	//Set the parent animation component (the head)
	// 	newModule.SetParentAnimComponent(ParentModularItem);
	// 	// newModule.SetLightEnvironment(MyLightEnvironment);
	// 	//Set the parent Shadow component (the head)
	// 	newModule.SetShadowParent(ParentModularItem);
	// 	//Adds mesh to a list to be accessed by EmberPawn to apply correct lighting to it
	// 	SkelMeshList.AddItem(newModule);
	// 	//Attach the component to the player character
	// 	Owner.AttachComponent(newModule);
	// }

	//Adds default torso to pawn
	SetChildModularInfo(TorsoList[0]);
	//Adds default arms to pawn
	SetChildModularInfo(ArmsList[0]);
	//Adds default hands to pawn
	SetChildModularInfo(HandsList[0]);
	//Adds default legs to pawn
	SetChildModularInfo(LegsList[0]);
	//Adds default feet to pawn
	SetChildModularInfo(FeetList[0]);
}

function Initialize(pawn pOwner, SkeletalMeshComponent pParent)
 {
 	//Get the player character and save it
 	Owner = pOwner;
 	//Get the parent module and save it. Can NOT be created dynamically, but can be modified dynamically
 	ParentModularItem = pParent;

	//We setup the list to use
	SetupComponentList();
 	//Setup the parent moduler item. This is the key.
 	setParentModularItem();
 	//Setup the additional modular components
 	setChildModularItems();
 }

