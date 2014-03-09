/*
/ -- This class contains both the flags and the calculations
/ -- That will be used in chambering for both left and right mouse clicks
/ --
/ -- It will also be used in normal click attacks as well
*/

class EmberChamberFlags extends Object;

//Variables to contain the flags
var int LeftChamberFlags;
var int RightChamberFlags;

var array<int> FlagContainer;
//By setting it to 0, all flags are removed
function resetRightChamberFlags()
{
	RightChamberFlags = 0;
}

function resetLeftChamberFlags()
{
	LeftChamberFlags = 0;
}

//We set the 'flag' to Left Chamber
function setLeftChamberFlag(int Flag)
{
	//We don't have that flag recorded...
	// if(Flag => FlagContainer.length)
		// return;
	LeftChamberFlags = LeftChamberFlags | FlagContainer[Flag];
}
//Removes the flag from Left Chamber
function removeLeftChamberFlag(int Flag)
{
	//Variable used for counting each flag
	local int iCount;
	//Create a backup to test
	local int LeftBackupChamberFlags;
	//Give backup the same information as original
	LeftBackupChamberFlags = LeftChamberFlags;
	//Reset original to 0
	LeftChamberFlags = 0;
	//Starting from the lowest flag, increase by 1 each loop until we are equal to largest flag
	for(iCount = 0; iCount < FlagContainer.length; iCount++)
	{
		//if the flag we're on is not the flag we want to delete
		//And if it's a flag that's already enabled
		if(iCount != Flag && (LeftBackupChamberFlags & FlagContainer[iCount]) == FlagContainer[iCount])
			//Enable flag on original
			LeftChamberFlags = LeftChamberFlags | FlagContainer[iCount];
	}
}

function setRightChamberFlag(int Flag)
{
	//We don't have that flag recorded...
	// if(Flag => FlagContainer.length)
		// return;
	RightChamberFlags = RightChamberFlags | FlagContainer[Flag];
}
//Removes the flag from Right Chamber
function removeRightChamberFlag(int Flag)
{
	//Variable used for counting each flag
	local int iCount;
	//Create a backup to test
	local int RightBackupChamberFlags;
	//Give backup the same information as original
	RightBackupChamberFlags = RightChamberFlags;
	//Reset original to 0
	RightChamberFlags = 0;
	//Starting from the lowest flag, increase by 1 each loop until we are equal to largest flag
	for(iCount = 0; iCount < FlagContainer.length; iCount++)
	{
		//if the flag we're on is not the flag we want to delete
		//And if it's a flag that's already enabled
		if(iCount != Flag && (RightBackupChamberFlags & FlagContainer[iCount]) == FlagContainer[iCount])
			//Enable flag on original
			RightChamberFlags = RightChamberFlags | FlagContainer[iCount];
	}
}

//--------------------------------------
function bool CheckLeftFlag(int Flag)
{
	//We don't have that flag recorded...
	// if(Flag => FlagContainer.length)
		// return;
	//If flag was enabled, return true. Else it is not so return false
	if((LeftChamberFlags &  FlagContainer[Flag]) ==  FlagContainer[Flag]) //Wierd UDK stuff found from experience. In C++ this returns 1, but in UDK it returns Flag
		return true;
		return false;
}
function bool CheckRightFlag(int Flag)
{
	//We don't have that flag recorded...
	// if(Flag => FlagContainer.length)
		// return;
	//If flag was enabled, return true. Else it is not so return false
	if((RightChamberFlags &  FlagContainer[Flag]) ==  FlagContainer[Flag]) //Wierd UDK stuff found from experience. In C++ this returns 1, but in UDK it returns Flag
		return true;
		return false;
}

DefaultProperties
{
	// LargestLeftFlag = 0;
	// LargestRightFlag = 0;

	FlagContainer=(0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80);

}