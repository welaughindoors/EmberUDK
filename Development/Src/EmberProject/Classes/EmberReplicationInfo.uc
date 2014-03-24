class EmberReplicationInfo extends UTPlayerReplicationInfo;

var repnotify struct ServerAttackPacketStruct
{
	var int ServerAnimAttack;
	var int ServerTargetPawn;
	var bool DirtyBit;
} ServerAttackPacket ;

var repnotify struct ServerStancePacketStruct
{
	var int ServerStance;
	var int ServerTargetPawn;
} ServerStancePacket;

var repnotify struct ServerBlockPacketStruct
{
	var bool DirtyBit;
	var int ServerTargetPawn;
} ServerBlockPacket;

var repnotify struct ServerChamberPacketStruct
{
	var int ServerTargetPawn;
	var bool ChamberActive;
} ServerChamberPacket;

var repnotify struct ServerGrapplePacketStruct
{
	var int ServerTargetPawn;
	var bool GrappleActive;
	var vector hitLocation;
} ServerGrapplePacket;

var repnotify struct ServerTBProjectilePacketStruct
{
	var int ServerTargetPawn;
	var vector hitDirection;
	var bool DirtyBit;
}  ServerTBProjectilePacket;

// Replication block
replication
{
	if(bNetDirty)
		ServerAttackPacket, ServerStancePacket, ServerBlockPacket,
		ServerChamberPacket, ServerGrapplePacket, ServerTBProjectilePacket;
}

/*
Replicate_TetherBeamProjectile
	Player shot projectile in this direction
	uses dirty bit incase player doesn't move and shoots a second
*/
simulated function Replicate_TetherBeamProjectile(vector ProjectileDir, int PlayerID)
{
		local ServerTBProjectilePacketStruct tStruct;

	tStruct.ServerTargetPawn = PlayerID;	
	tStruct.hitDirection = ProjectileDir;
	tStruct.DirtyBit = !ServerTBProjectilePacket.DirtyBit;

	ServerTBProjectilePacket = tStruct;
}
/*
Replicate_Grapple
	Tells if grapple is active or not. If it's active, show the visual grapple
	(Grapple mechanics are done 100% by server)
*/
simulated function Replicate_Grapple(bool Active, int cPlayerID, vector hitLocation)
{
	local ServerGrapplePacketStruct tStruct;

	tStruct.ServerTargetPawn = cPlayerID;	
	tStruct.GrappleActive = Active;
	tStruct.hitLocation = hitLocation;

	ServerGrapplePacket = tStruct;
}

/*
Replicate_Chamber
	When player does block, get block status to replicate 'block'
*/
simulated function Replicate_Chamber(bool Active, int cPlayerID)
{
	local ServerChamberPacketStruct tStruct;

	tStruct.ServerTargetPawn = cPlayerID;
	// tStruct.DirtyBit = !ServerChamberPacket.DirtyBit;
	tStruct.ChamberActive = Active;

	ServerChamberPacket = tStruct;
}
/*
Replicate_Damage
	Gets information from sword.uc and transmits
	We use playerID here because that particular player will take the damage
*/
simulated function Replicate_DoBlock(int cPlayerID)
{
	local ServerBlockPacketStruct tStruct;

	tStruct.ServerTargetPawn = cPlayerID;
	tStruct.DirtyBit = !ServerBlockPacket.DirtyBit;

	ServerBlockPacket = tStruct;
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
	// local pawn Sender;
	local pawn Receiver;
	// local EmberPawn eppawn;

	if (varname == 'ServerAttackPacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			if(PC.pawn.PlayerReplicationInfo != self)
			{
				Receiver = PC.pawn;
				// EmberPawn(Receiver).DebugPrint("REPLICATION_ServerAttackPacket"@ServerAttackPacket.ServerAnimAttack);
				EmberPawn(Receiver).ClientAttackAnimReplication(ServerAttackPacket.ServerAnimAttack, ServerAttackPacket.ServerTargetPawn);
			}
		}
	}

	if (varname == 'ServerStancePacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			if(PC.pawn.PlayerReplicationInfo != self)
			{
				Receiver = PC.pawn;
				// EmberPawn(Receiver).DebugPrint("REPLICATION_ServerStancePacket");
				EmberPawn(Receiver).ClientStanceReplication(ServerStancePacket.ServerStance, ServerStancePacket.ServerTargetPawn);
			}
		}
	}

	if (varname == 'ServerBlockPacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			if(PC.pawn.PlayerReplicationInfo != self)
			{
				Receiver = PC.pawn;
				// EmberPawn(Receiver).DebugPrint("REPLICATION_ServerBlockPacket");
				EmberPawn(Receiver).ClientBlockReplication(ServerBlockPacket.ServerTargetPawn);
			}
		}
	}

	if (varname == 'ServerChamberPacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			if(PC.pawn.PlayerReplicationInfo != self)
			{
				Receiver = PC.pawn;
				// EmberPawn(Receiver).DebugPrint("REPLICATION_ServerChamberPacket");
				EmberPawn(Receiver).ClientChamberReplication(ServerChamberPacket.ChamberActive, ServerChamberPacket.ServerTargetPawn);
			}
		}
	}
	
	if (varname == 'ServerGrapplePacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			//We replicate all pawns, even sender.	
			Receiver = PC.pawn;
			// EmberPawn(Receiver).DebugPrint("REPLICATION_ServerGrapplePacket");
			EmberPawn(Receiver).ClientReceiveGrappleReplication(ServerGrapplePacket.GrappleActive, ServerGrapplePacket.ServerTargetPawn, ServerGrapplePacket.hitLocation);
		}
	}
	
	if (varname == 'ServerTBProjectilePacket') 
	{
		ForEach WorldInfo.AllControllers(class'EmberPlayerController', PC)
		{
			if(PC.pawn.PlayerReplicationInfo != self)
			{
				Receiver = PC.pawn;
				EmberPawn(Receiver).ClientTetherBeamProjectileReplication(ServerTBProjectilePacket.hitDirection, ServerTBProjectilePacket.ServerTargetPawn);
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
	NetUpdateFrequency 		= 400
	CharClassInfo=class'EmberProject.EmberFamilyInfo'
}

