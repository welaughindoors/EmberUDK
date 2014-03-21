/*
	This is the actual AS movie
	Variables are done here
*/

class EmberHudBase extends GFxMoviePlayer;

var GFxObject RootMC;
var float myNumber;
var string MainClass;

//Initializes the movie
function Init( optional LocalPlayer LocPlay )
{
	Super.Init( LocPlay );
}
function SetHudMainClass(string a)
{
	MainClass = a;
}
//Starts the movie
function bool Start(optional bool StartPaused = false){
    Super.Start();

    // Initialize all objects in the movie
    Advance(0);
    
    //Setup variables for usage here
    RootMC = GetVariableObject(MainClass);

    return true;
}

DefaultProperties
{
	bDisplayWithHudOff=false
}