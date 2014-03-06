class EmberReplicationInfo extends UTPlayerReplicationInfo;

var RepNotify int YourUniqueID;
var repnotify struct AttackPacketStruct
{
	var RepNotify array<float> Mods;
	var float tDur;
} AttackPacket;

	var RepNotify name AnimName;
// var RepNotify name AnimName;
// Replication block
replication
{

	if (bNetDirty && Role == Role_Authority)
		AttackPacket;
	if(bNetDirty)
		AnimName;
}

simulated event ReplicatedEvent(name VarName)
{
	local PlayerController PC;
	local pawn ePawn;
	WorldInfo.Game.Broadcast(self, "Packet Received~"@varname);
	if (varname == 'AttackPacket') {
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			if ( PC.PlayerReplicationInfo == self )
			{
				ePawn = PC.pawn;
				WorldInfo.Game.Broadcast(self, "pawn"@ePawn);
				// EmberPawn(ePawn).forcedAnimEndReplication(AttackPacket.AnimName, AttackPacket.Mods);
			}
		}
	}

	if (varname == 'AnimName') {
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			if ( PC.PlayerReplicationInfo == self )
			{
				ePawn = PC.pawn;
				EmberPawn(ePawn).DEbugPrint("replication called");
				WorldInfo.Game.Broadcast(self, "pawn"@ePawn);
				// EmberPawn(ePawn).forcedAnimEndReplication(AttackPacket.AnimName, AttackPacket.Mods);
			}
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
NetUpdateFrequency 		= 3
	CharClassInfo=class'EmberProject.EmberFamilyInfo'
}
