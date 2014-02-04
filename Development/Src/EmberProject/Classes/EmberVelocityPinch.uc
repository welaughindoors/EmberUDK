class EmberVelocityPinch extends Object;

var float genericVelocityPinch;
var float accumulatedTime;
var float TargetStartTime;
var float TargetEndTime;
var bool bApplyVelocityPinch;
var Actor Owner;

//Set the owner of this velocity pinch class, so you can change owner's velocity
function SetOwner(Actor o)
{
	Owner = o;
}

simulated function ApplyVelocityPinch(float DeltaTime = -1, float TargetStartTimeSet = -1, float TargetEndTimeSet = -1)
{
	//If a time is entered, lets setup the variables
	if(TargetStartTimeSet != -1)
	{
		//Set the time that we'll end pinching
		TargetEndTime = TargetEndTimeSet;
		//Set the time that we'll start pinching
		TargetStartTime = TargetStartTimeSet;
		//Reset accumlatedTime
		accumulatedTime = 0;
		//This tells the owner class to run this function per tick
		bApplyVelocityPinch = true;

		EmberPawn(Owner).DebugPrint("start");
	}

	//This section of the code is run per tick in the owner's classes
	if(TargetStartTimeSet == -1 && TargetStartTime != 0)
	{
		//We'll increase the accumlated time by time per tick
		accumulatedTime += DeltaTime;

		//If we reach our start time...
		if(accumulatedTime >= TargetStartTime)
		{
		//And as long as the owner's velocity is greater than 50...
			if(VSize(Owner.velocity) > 50)
			//We'll modify it by genericVelocityPinch (Defined in DefaultProperites below)
				Owner.velocity *= genericVelocityPinch;
		}
		//Else if the accumlated time has gone over end time
		if(accumulatedTime >= TargetEndTime)
		{
			//Tell the tick functions in owner class to stop calling this function
				bApplyVelocityPinch = false;
				EmberPawn(Owner).DebugPrint("stop");
		}
	}
}

DefaultProperties
{
	genericVelocityPinch = 0.94560; //Modifier
}