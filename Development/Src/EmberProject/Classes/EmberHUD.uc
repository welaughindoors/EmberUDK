class EmberHUD extends UDKHUD;

var Color CrossHairColor;
var Texture2D CrosshairImage;
var UIRoot.TextureCoordinates IconCoordinates;
var UIRoot.TextureCoordinates CrossHairCoordinates;
var float CrosshairScaling;

var float CrossHairWidth;

var vector OutStart;
var vector OutRotation;

var bool bGrappleCrosshair;
var float GrappleAlpha;

function DrawPlayerNames()
{
	local EmberPlayerController Receiver;
	local vector TextLocation;
	 local Vector2D TextSize;
	// local vector TextCoord;
	//Find all local pawns
	ForEach WorldInfo.AllControllers(class'EmberPlayerController', Receiver) 
	{
		TextLocation = Receiver.pawn.Location;
		TextLocation.Z += 50;
		TextLocation = Canvas.Project(TextLocation);
		Canvas.TextSize(Receiver.PlayerReplicationInfo.PlayerName, TextSize.X, TextSize.Y);
   Canvas.SetPos(TextLocation.X - TextSize.X, TextLocation.Y);
   Canvas.DrawText(Receiver.PlayerReplicationInfo.PlayerName,,1 / RatioX,1 / RatioY);
   // Receiver = EmberPlayerController(PlayerOwner).pawn;
    }
}

function enableGrappleCrosshair(bool Active)
{
	bGrappleCrosshair = Active;
}

function DrawGrappleCrosshair()
{
		local vector2d CrosshairSize;
	local vector2d CenterCoords;
	local float x,y, ScreenX, ScreenY;
    super.PostRender();

    CrosshairSize.Y = CrosshairScaling * CrossHairCoordinates.VL * Canvas.ClipY/720;
  	CrosshairSize.X = CrosshairSize.Y * ( CrossHairCoordinates.UL / CrossHairCoordinates.VL );

	X = Canvas.ClipX * 0.5;
	Y = Canvas.ClipY * 0.5;
	ScreenX = X - (CrosshairSize.X * 0.5);
	ScreenY = Y - (CrosshairSize.Y * 0.5);
	CenterCoords.x = X;
	CenterCoords.y = Y;
	Canvas.DeProject(CenterCoords,OutStart, OutRotation);
	if ( CrosshairImage != none )
	{
		// crosshair drop shadow
		// Canvas.DrawColor = class'UTHUD'.default.BlackColor;
		// Canvas.SetPos( ScreenX+1, ScreenY+1);
		// Canvas.DrawTile(CrosshairImage,CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL,CrossHairCoordinates.VL);

		GrappleAlpha = (bGrappleCrosshair) ? Lerp(GrappleAlpha, 230, 0.023) : Lerp(GrappleAlpha, 0, 0.04);
		Canvas.SetDrawColor(255,255,255,GrappleAlpha);

		if(bGrappleCrosshair == true)
		{
			GrappleAlpha = Lerp(GrappleAlpha, 230, 0.023);
			Canvas.SetDrawColor(255,255,255,GrappleAlpha);
		}
		else
		{
			GrappleAlpha = Lerp(GrappleAlpha, 0, 0.04);
			Canvas.SetDrawColor(255,255,255,GrappleAlpha);
		}

		// Canvas.DrawColor.a = Lerp(Canvas.DrawColor.a, 125, fDeltaTime);
		// Canvas.DrawColor.a = CrossHairColor;
		Canvas.SetPos(ScreenX, ScreenY);
		Canvas.DrawTile(CrosshairImage,CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL,CrossHairCoordinates.VL);
	}
}

function PostRender()
{
    super.PostRender();

	// if(GrappleAlpha != 0)    
		DrawGrappleCrosshair();

	// DrawPlayerNames();

	   super.DrawHUD();

// UTPlayerController(PlayerOwner).PlayerReplicationInfo.PlayerName;

}




defaultproperties
{
	GrappleAlpha=0
    CrossHairColor=(R=255,G=0,B=0,A=127)
    CrossHairWidth=50
    CrosshairImage=Texture2D'UI_HUD.HUD.UTCrossHairs'
	// CrossHairCoordinates=(U=192,V=64,UL=64,VL=64)
	CrossHairCoordinates=(U=295,V=250,UL=70,VL=70)
	IconCoordinates=(U=600,V=341,UL=111,VL=58)
	CrosshairScaling=1.0
    //Texture2D'UI_HUD.HUD.UTCrossHairs'
}