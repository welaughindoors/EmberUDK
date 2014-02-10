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
var array<SkeletalMesh> ComponentList;
var array<EmberModularItem> SkelMeshList;


//==================================================
// API Part. Modify This
//==================================================

//Sets up a list that will be used to add components. 
function SetupComponentList()
{
	//Adds Torso
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_torso_01');
	//Adds Hands
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_hands_01');
	//Adds Feet
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_feet_01');
	//Adds Arms
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_arms_01');
	//Adds Legs
	ComponentList.AddItem(SkeletalMesh'ModularPawn.Meshes.ember_legs_01');
}

//Change this ONLY if you know what you're doing
function setParentModularItem()
{
	
	//This is the 'head'. Everything relies on this. Fuck this up and pawn's fucked up
	
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
		//Adds mesh to a list to be accessed by EmberPawn to apply correct lighting to it
		SkelMeshList.AddItem(newModule);
		//Attach the component to the player character
		Owner.AttachComponent(newModule);
	}
}

function Initialize(pawn pOwner, SkeletalMeshComponent pParent)
 {
 	//Get the player character and save it
 	Owner = pOwner;
 	//Get the parent module and save it. Can NOT be created dynamically, but can be modified dynamically
 	ParentModularItem = pParent;
 	//Setup the parent moduler item. This is the key.
 	setParentModularItem();
 	//Setup the additional modular components
 	setChildModularItems();
 }

