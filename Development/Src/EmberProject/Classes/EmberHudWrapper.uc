/*
	This class is the 'interface' between the unrealscript code and the AS movie itself
*/
class EmberHudWrapper extends HUD;

Enum Tags
	{
		//Item 1
		Flash_Health,
		//Item 2
		Flash_Health2,
	};

var EmberHudBase FlashMovie;
var class<EmberHudBase> FlashMovieClass;
var array<EmberHudBase> FlashMovieContainer;
var array<SwfMovie> SwfContainer;
var array<GFxAlign> AlignmentContainer;
var array<Tags> TagContainer;
var array<string> MainClassContainer;

//===========================================================================================================
//===========================================================================================================

/*
Align_Center - SWF is centered horizontally and vertically on screen
Align_TopCenter - Top of SWF is at top of screen, and SWF is centered horizontally on screen
Align_BottomCenter - Bottom of SWF is at bottom of screen, and SWF is centered horizontally on screen
Align_CenterLeft - SWF is centered vertically and aligned to the left side of the screen
Align_CenterRight - SWF is centered vertically and aligned to the right side of the screen
Align_TopLeft - Top left corner of SWF is at top left corner of the screen
Align_TopRight - Top right corner of SWF is at top right corner of the screen
Align_BottomLeft - Bottom left corner of SWF is at bottom left corner of the screen
Align_BottomRight - Bottom right corner of SWF is at bottom right corner of the screen
*/

/*
AddFlashMovie
	Only function that you'll need for adding and setting up flash movies
*/
function AddFlashMovie()
{
	//==================================================
	// Item 1
	//==================================================

	//Enter your flash
	AddSwfMovie(SwfMovie'EmberResources.HpHud');
	//Enter your Alignment
	AddAlignment(Align_BottomLeft);
	//Enter main class
	AddMainClass("HpHud");
	//Enter your tag (only 1 tag for 1 flash file only!!!)
	//Tags can be declared near top
	AddTag(Flash_Health);


	//==================================================
	// Item 2
	//==================================================

	// AddSwfMovie(SwfMovie'EmberResources.HpHud');
	// AddAlignment(Align_BottomRight);
	// AddMainClass("HpHud");
	// AddTag(Flash_Health2);
}


//===========================================================================================================
//===========================================================================================================

function AddMainClass(string a)
{
	MainClassContainer.AddItem(a);
}
function AddSwfMovie(SwfMovie a)
{
	SwfContainer.AddItem(a);
}

function AddAlignment(GFxAlign a)
{
	AlignmentContainer.AddItem(a);
}
function AddTag(Tags a)
{
	TagContainer.AddItem(a);
}
function PostBeginPlay()
{
	local int i;
	super.PostBeginPlay();
	//Sets player owner in HudBase to PC
	//FlashMovie.PlayerOwner = EmberPlayerController(PlayerOwner);
	AddFlashMovie();

	for(i = 0; i < SwfContainer.length; i++)
	{
		// Creates wrapper to hud movie
		FlashMovie = new class'EmberHudBase'; 
		// Set the movie's info
		FlashMovie.MovieInfo = SwfContainer[i];
		// Sets the timer
		FlashMovie.SetTimingMode(TM_Real); 
		// Initializes
		FlashMovie.Init(); 
		// Sets the main class to access variables
		FlashMovie.SetHudMainClass(MainClassContainer[i]);
		// Play and show the movie on the screen
		FlashMovie.Start(); 
		// This prevents movie stretching you can test with the other GFxScaleModes if you preffer
		FlashMovie.SetViewScaleMode(SM_NoScale); 
		// Great function, contain the most used alignments and is resolution independent
		FlashMovie.SetAlignment(AlignmentContainer[i]); 
		// Store the flash for access later
		FlashMovieContainer.AddItem(FlashMovie);
	}
}

function SetVariable(Tags FlashTag, string variable, float value)
{
	local int FlashIndex;

	// Get Flash index from tag
	FlashIndex = GetIndexFromTag(FlashTag);

	// If tag is invalid, cancel function
	if(FlashIndex == -1)
		return;

	// If tag is valid, set new values
	FlashMovieContainer[FlashIndex].RootMC.SetFloat(variable, value);
}

function int GetIndexFromTag(Tags FlashTag)
{
	local int i;
	for(i = 0; i < TagContainer.length; i++)
	{
		if(TagContainer[i] == FlashTag)
			return i;
	}
	return -1;
}