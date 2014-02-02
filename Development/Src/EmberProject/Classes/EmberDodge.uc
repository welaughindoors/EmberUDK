class EmberDodge extends Object;

var vector DodgeVelocity;
var bool bDodgeCapable;
var bool bDodging;
var float DodgeSpeed;
var float DodgeDuration;
var float counter;

var EmberPawn player;

function setOwner(EmberPawn own)
{
	player = own;
}

function Count(float dTime)
{
	counter += dTime;
	if(counter >= DodgeDuration)
	{
		UnDodge();
		counter = 0;
	}
}
//ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Exhaust'
//Dodge1/2

function bool DoDodge(array<byte> direction)
{
	local vector X,Y,Z;
	local vector dVect;
	
	//finds global axes of pawn
	player.GetAxes(player.Rotation, X, Y, Z);

	if( bDodgeCapable && player.Physics == Phys_Walking )
	{
		//temporarily raise speeds
		player.AirSpeed = DodgeSpeed;
		player.GroundSpeed = DodgeSpeed;
		bDodging = true;
		player.Velocity.Z = -player.default.GroundSpeed;

	player.setDodgeStance(0, DodgeDuration);

  if((direction[1] ^ 1) == 0) dVect = -DodgeSpeed*Normal(Y);
  else if((direction[3] ^ 1) == 0) dVect = DodgeSpeed*Normal(Y);
  else if((direction[0] ^ 1) == 0) dVect = DodgeSpeed*Normal(X);
  else if((direction[2] ^ 1) == 0) dVect = -DodgeSpeed*Normal(X);

  if((direction[3] ^ 1) == 0)
  {
player.setDodgeEffect();
  }
  
		// switch ( DoubleClickMove )
		// {
		// 	//dodge left
		// 	case DClick_Left:
		// 		DodgeVelocity = -DodgeSpeed*Normal(Y);
		// 		break;
		// 	//dodge right
		// 	case DClick_Right:
		// 		DodgeVelocity = DodgeSpeed*Normal(Y);
		// 		break;
		// 	//dodge forward
		// 	case DCLICK_Forward:
		// 		DodgeVelocity = DodgeSpeed*Normal(X);
		// 		break;
		// 	//dodge back
		// 	case DCLICK_Back:
		// 		DodgeVelocity = -DodgeSpeed*Normal(X);
		// 		break;
		// 	//in case there is an error
		// 	default:
		// 		`log('DoDodge Error');
		// 		break;
		// }

		player.Velocity = dVect;

		player.SetPhysics(Phys_Flying); //gives the right physics
		bDodgeCapable = false; //prevent dodging mid dodge
		player.disableMoveInput(true);
		// player.disableLookInput(true);
		// player.SetTimer(DodgeDuration,false,'UnDodge'); //time until the dodge is done
		return true;
	}
	else
	{
		return false;
	}
	
}
function Dodging()
{
	local vector TraceStart3;
	local vector TraceEnd1, TraceEnd2, TraceEnd3;


	if( bDodging )
	{
		//trace location for detecting objects just below pawn
		TraceEnd1 = player.Location;
		TraceEnd1.Z = player.Location.Z - 50;

		//trace location for detecting objects below pawn that are close
		TraceEnd2 = player.Location;
		TraceEnd2.Z = player.Location.Z - 120;

		//trace locations for detecting ledges pawn will fall off
		TraceStart3 = player.Location + 10*normal(DodgeVelocity);
		TraceEnd3 = TraceStart3;
		TraceEnd3.Z = TraceStart3.Z - 121;

		if( player.FastTrace(TraceEnd1) && !player.FastTrace(TraceEnd2) ) //nothing is very close and something is sort of close
		{
			player.Velocity.Z = -player.default.GroundSpeed; //push pawn to the ground
		}


		if( player.FastTrace(TraceEnd3, TraceStart3) ) //pawn is about to fall off a ledge
		{
			UnDodge();
		}
		else
		{
			//maintain a constant velocity
			player.Velocity.X = DodgeVelocity.X;
			player.Velocity.Y = DodgeVelocity.Y;
		}
	}
}
function UnDodge()
{
	local vector IdealVelocity;

	player.SetPhysics(Phys_Falling); //use falling instead of walking in case we are mid-air after the dodge
	bDodgeCapable = true;
	bDodging = false;
		player.disableMoveInput(false);
		// player.disableLookInput(false);
	player.GroundSpeed = player.default.GroundSpeed;
	player.AirSpeed = player.default.AirSpeed;

	//reset the velocity of pawn
	IdealVelocity = normal(DodgeVelocity)*player.default.GroundSpeed;
	player.Velocity.X = IdealVelocity.X;
	player.Velocity.Y = IdealVelocity.Y;
	player.setDodgeStance(0, DodgeDuration);
}

DefaultProperties
{
	DodgeSpeed = 635
	DodgeDuration = 0.2
	bDodgeCapable = true
	bDodging = false
}
