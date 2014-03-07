class EmberReplicationInfo extends UTPlayerReplicationInfo;

var repnotify struct ServerAttackPacketStruct
{
	var name AnimName;
	var array<float> Mods;
	var int targetPawn;
	// var float tDur;
} ServerAttackPacket ;

// Replication block
replication
{

	// if (bNetDirty && Role == Role_Authority)
		// AttackPacket;
	if(bNetDirty)
		ServerAttackPacket;
}
simulated function copyToServerAttackStruct(name AnimName, float tDur, float fIn, float fOut, int targetPawn)
{
	local ServerAttackPacketStruct tStruct;
	tStruct.AnimName = AnimName;
	tStruct.Mods.AddItem(tDur);
	tStruct.Mods.AddItem(fIn);
	tStruct.Mods.AddItem(fOut);
	tStruct.targetPawn = targetPawn;
ServerAttackPacket = tStruct;
}
simulated event ReplicatedEvent(name VarName)
{
	local EmberPlayerController PC;
	local pawn P;
	// local EmberPawn eppawn;

	if (varname == 'ServerAttackPacket') {
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			// find my pawn and tell it
			// if ( P.PlayerReplicationInfo == self )
			// {
				P = PC.pawn;
				EmberPawn(P).DebugPrint("REPLICATION_ServerAttackPacket"@ServerAttackPacket.Mods[0]);
				EmberPawn(P).ClientAttackAnimReplication(ServerAttackPacket.AnimName, ServerAttackPacket.Mods, ServerAttackPacket.targetPawn);
				// break;
			// }
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

