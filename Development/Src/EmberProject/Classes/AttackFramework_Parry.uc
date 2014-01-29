class AttackFramework_Parry extends Object;

const dTop 			= 0;
const dBottom 		= 1;
const dLeft 		= 2;
const dRight 		= 3;
const dTopLeft 		= 4;
const dTopRight 	= 5;
const dBottomLeft 	= 6;
const dBottomRight 	= 7;

var actor owner;

function setOwner(actor own)
{
	owner = own;
}

simulated function DebugPrint(string sMessage)
{
    Owner.GetALocalPlayerController().ClientMessage(sMessage);
}

function bool CanAttackParry(int Direction_1, int Direction_2)
{
	//Quick check to see if both are same direction. Cause they're facing eachother, the attacks will collide.
	if((Direction_1 ^ Direction_2) == 0) return true;

	switch(Direction_1)
	{
		//If one of the swings it top (forward)
		case dTop:
			//And the other swing is bottom(backwards), say that they can parry
			if((Direction_2 ^ dBottom) == 0 )	return true;
			// if((Direction_2 ^ dTop) == 0 )	return true;
		break;

		case dBottom:
			// if((Direction_2 ^ dTop ) == 0 ) return true;
			if((Direction_2 ^ dBottom) == 0 )	return true;
		break;

		//If one of the swings is left
		case dLeft:
			//And the other swing is top right, right, or bottom right, say that they can parry.
			if((Direction_2 ^ dTopLeft ) == 0 ) return true;
			// if((Direction_2 ^ dLeft ) == 0 ) return true;
			if((Direction_2 ^ dBottomLeft ) == 0) return true;
		break;

		case dRight:
			// if((Direction_2 ^ dRight ) == 0 ) return true;
			if((Direction_2 ^ dTopRight ) == 0 ) return true;
			if((Direction_2 ^ dBottomRight ) == 0 ) return true;
		break;

		case dTopLeft:
			if((Direction_2 ^ dLeft ) == 0 ) return true;
			if((Direction_2 ^ dBottomLeft ) == 0) return true;
		break;

		case dTopRight:
			if((Direction_2 ^ dRight ) == 0 ) return true;
			if((Direction_2 ^ dBottomRight ) == 0) return true;
		break;

		case dBottomLeft:
			if((Direction_2 ^ dTopLeft ) == 0 ) return true;
			if((Direction_2 ^ dLeft ) == 0 ) return true;
		break;

		case dBottomRight:
			if((Direction_2 ^ dTopRight ) == 0 ) return true;
			if((Direction_2 ^ dRight ) == 0 ) return true;
		break;
	}
	return false;
}

DefaultProperties
{
	//defaults
}