class EmberVelocityPinch extends Object;

var float genericVelocityPinch;
var float genericTimeTillVelocityPinch;
var float accumulatedTime;
var float TargetStartTime;
var float TargetEndTime;
var bool bApplyVelocityPinch;
var Actor Owner;

function SetOwner(Actor o)
{
	Owner = o;
}

simulated function ApplyVelocityPinch(float DeltaTime = -1, float TargetStartTimeSet = -1, float TargetEndTimeSet = -1)//,bool EndVelPinch = false)
{
	// EmberPawn(Owner).DebugPrint("velPinch");
	// if(EndVelPinch)
		// bApplyVelocityPinch = false;

	if(TargetStartTimeSet != -1)
	{
		TargetEndTime = TargetEndTimeSet;// * genericTimeTillVelocityPinch;
		TargetStartTime = TargetStartTimeSet;
		accumulatedTime = 0;
		bApplyVelocityPinch = true;
	}

	if(TargetStartTimeSet == -1 && TargetStartTime != 0)
	{
		accumulatedTime += DeltaTime;

		if(accumulatedTime >= TargetStartTime)
			if(VSize(Owner.velocity) > 50)
				Owner.velocity *= genericVelocityPinch;

		if(accumulatedTime >= TargetEndTime)
		{
			bApplyVelocityPinch = false;
			// Owner.velocity = 2048;
		}
	}
}

DefaultProperties
{
	genericTimeTillVelocityPinch = 0.5; //last 20%
	genericVelocityPinch = 0.946; //Modifier
}