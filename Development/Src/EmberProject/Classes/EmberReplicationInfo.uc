class EmberReplicationInfo extends UTPlayerReplicationInfo;

var repnotify struct ServerFunctionReplicationStruct
{
	var byte FunctionID;
	var int PlayerID;
	var bool bToggle; 
	var bool bToggle2; 
	var bool bToggle3; 
	var int iVar;
	var int iVar2; 
	var int iVar3;
	var vector vVar;
	var vector vVar2;
	var vector vVar3;
	var bool DirtyBit;
}ServerFunctionReplication;

// Replication block
replication
{
	if(bNetDirty)
		ServerFunctionReplication;
}
/*
Replication_FunctionGate
	
*/
simulated function Replication_FunctionGate
(
	byte FunctionID, 
	int PlayerID, 
	optional bool bToggle, 
	optional bool bToggle2, 
	optional bool bToggle3, 
	optional int iVar, 
	optional int iVar2, 
	optional int iVar3,
	optional vector vVar,
	optional vector vVar2,
	optional vector vVar3
)
{
	local ServerFunctionReplicationStruct tStruct;

	tStruct.FunctionID = FunctionID;
	tStruct.PlayerID = PlayerID;
	tStruct.bToggle = bToggle;
	tStruct.bToggle2 = bToggle2; 
	tStruct.bToggle3 = bToggle3; 
	tStruct.iVar = iVar;
	tStruct.iVar2 = iVar2; 
	tStruct.iVar3 = iVar3;
	tStruct.vVar = vVar;
	tStruct.vVar2 = vVar2;
	tStruct.vVar3 = vVar3;
	// tStruct.DirtyBit = !ServerFunctionReplication.DirtyBit;

	ServerFunctionReplication = tStruct;
}

simulated event ReplicatedEvent(name VarName)
{
	local EmberPlayerController PC;
	// local pawn Sender;
	local pawn Receiver;
	
	if (VarName == 'ServerFunctionReplication')
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			Receiver = PC.pawn;
			EmberPawn(Receiver).ClientFunctionGate(
							ServerFunctionReplication.FunctionID,
							ServerFunctionReplication.PlayerID,
							ServerFunctionReplication.bToggle,
							ServerFunctionReplication.bToggle2,
							ServerFunctionReplication.bToggle3,
							ServerFunctionReplication.iVar,
							ServerFunctionReplication.iVar2,
							ServerFunctionReplication.iVar3,
							ServerFunctionReplication.vVar,
							ServerFunctionReplication.vVar2,
							ServerFunctionReplication.vVar3
							);
		}
	}
	super.ReplicatedEvent(VarName);
}

/*
ReplicationInfo classes have bAlwaysRelevant set to true. 
Server performance can be improved by setting 
a low NetUpdateFrequency. Whenever a replicated property 
changes, explicitly change NetUpdateTime to force replication.
Server performance can also be improved by 
setting 

bSkipActorPropertyReplication 

and 

bOnlyDirtyReplication to true.
*/
defaultproperties
{
	bOnlyDirtyReplication 	= true
	bAlwaysRelevant			= true
	LastKillTime=-5.0
	DefaultHudColor=(R=64,G=255,B=255,A=255)
	VoiceClass=class'UTGame.UTVoice_Robot'
	CharPortrait=Texture2D'CH_IronGuard_Headshot.HUD_Portrait_Liandri'
	NetUpdateFrequency 		= 400
	CharClassInfo=class'EmberProject.EmberFamilyInfo'
}

