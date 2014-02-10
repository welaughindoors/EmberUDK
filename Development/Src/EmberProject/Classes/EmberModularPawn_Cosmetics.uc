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
var EmberModularItem ParentModularItem;
var array<SkeletalMesh> ComponentList;


//==================================================
// API Part. Modify This
//==================================================

//Sets up a list that will be used to add components. 
function SetupComponentList()
{
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_torso_01');
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_hands_01');
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_feet_01');
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_arms_01');
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_legs_01');
}

//==================================================
// END API. Begin System Functions
//==================================================









function setChildModularItems()
{
	local EmberModularItem newModule;
	local int i;

	//We setup the list to use
	SetupComponentList();

	//Going through each member in the list...
	for(i = 0; i < ComponentList.length; i++)
	{
		//Make a new preset module item
		newModule = new(self) class'EmberModularItem';
		//Change the mest to whats in the list
		newModule.SetSkeletalMesh(ComponentList[i]);
		//Set the parent animation component (the head)
		newModule.SetParentAnimComponent(ParentModularItem);
		//Set the parent Shadow component (the head)
		newModule.SetShadowParent(ParentModularItem);
		//Attach the component to the player character
		Owner.AttachComponent(newModule);
	}
}

function Initialize(pawn pOwner)
 {
 	//Get the player character and save it
 	Owner = pOwner;
 	//Setup the parent moduler item. This is the key.
 	setParentModularItem();
 	//Setup the additional modular components
 	setChildModularItems();
 }

function setParentModularItem()
{
	//Make a new preset module item
	ParentModularItem = new(self) class'EmberModularItem';
	//Set the mesh
	ParentModularItem.SetSkeletalMesh(SkeletalMesh'ModularPawn.Meshes.ember_head_01');
	//Set the physics asset
	ParentModularItem.SetPhysicsAsset(PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics');
	//Set the AnimTree Template
	ParentModularItem.SetAnimTreeTemplate(AnimTree'ArtAnimation.Armature_Tree');
	//Set the AnimationSets
	ParentModularItem.AnimSets[0]=AnimSet'ArtAnimation.AnimSets.Armature';
	//Translate the mesh downwards to 'hit' the ground
	ParentModularItem.SetTranslation(vect(0,0,-49.8));
	//Attach the component to player character
	Owner.AttachComponent(ParentModularItem);
}