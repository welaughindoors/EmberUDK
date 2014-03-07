class EmberReplicationInfo extends UTPlayerReplicationInfo;

// var repnotify struct ServerAttackPacketStruct
// {
// 	var name AnimName;
// 	var array<float> Mods;
// 	var int ServerTargetPawn;
// 	// var float tDur;
// } ServerAttackPacket ;

var repnotify struct ServerAttackPacketStruct
{
	var int ServerAnimAttack;
	var int ServerTargetPawn;
	var bool DirtyBit;
	// var float tDur;
} ServerAttackPacket ;

var repnotify struct ServerStancePacketStruct
{
	var int ServerStance;
	var int ServerTargetPawn;
} ServerStancePacket;

// Replication block
replication
{

	// if (bNetDirty && Role == Role_Authority)
		// AttackPacket;
	if(bNetDirty)
		ServerAttackPacket, ServerStancePacket;
}

/*
copyToServerAttackStruct
	When a player does an attack, copy the data needed
	Create a new temporary structure, load the data
	Swap the real packet with temp packet. The changed data will update immediately for all clients
*/
simulated function Replicate_ServerStance(int CurrentStance, int TargetPawn)
{
	local ServerStancePacketStruct tStruct;

	tStruct.ServerStance 		= CurrentStance;
	tStruct.ServerTargetPawn 	= TargetPawn;
	
	ServerStancePacket = tStruct;
}
/*
copyToServerAttackStruct
	When a player does an attack, copy the data needed
	Create a new temporary structure, load the data
	Swap the real packet with temp packet. The changed data will update immediately for all clients
*/
simulated function copyToServerAttackStruct(int AnimAttack, int TargetPawn)
{
	local ServerAttackPacketStruct tStruct;
	tStruct.ServerAnimAttack = AnimAttack;
	tStruct.ServerTargetPawn = TargetPawn;

	//If anim is repeated, no changes so won't be set. So we'll change a bool to make it send anyways
	tStruct.DirtyBit = !ServerAttackPacket.DirtyBit;
	
	ServerAttackPacket = tStruct;
}

simulated event ReplicatedEvent(name VarName)
{
	local EmberPlayerController PC;
	local pawn P;
	// local EmberPawn eppawn;

	if (varname == 'ServerAttackPacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			if(PC.pawn.PlayerReplicationInfo != self)
			{
				P = PC.pawn;
				EmberPawn(P).DebugPrint("REPLICATION_ServerAttackPacket"@ServerAttackPacket.ServerAnimAttack);
				EmberPawn(P).ClientAttackAnimReplication(ServerAttackPacket.ServerAnimAttack, ServerAttackPacket.ServerTargetPawn);
			}
		}
	}

	if (varname == 'ServerStancePacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			// if(PC.pawn.PlayerReplicationInfo != self)
			// {
				P = PC.pawn;
				EmberPawn(P).DebugPrint("REPLICATION_ServerStancePacket");
				EmberPawn(P).ClientStanceReplication(ServerStancePacket.ServerStance, ServerStancePacket.ServerTargetPawn);
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
	NetUpdateFrequency 		= 100
	CharClassInfo=class'EmberProject.EmberFamilyInfo'
}

