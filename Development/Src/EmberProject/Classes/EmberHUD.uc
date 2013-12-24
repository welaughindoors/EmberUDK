class EmberHUD extends UTHUD;


/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	local float x,y,w,h,xl,yl;
	local vector ViewPoint;
	local rotator ViewRotation;

	// post render actors before creating safe region
	if (UTGRI != None && !UTGRI.bMatchIsOver && bShowHud && PawnOwner != none  )
	{
		Canvas.Font = GetFontSizeIndex(0);
		PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
		DrawActorOverlays(Viewpoint, ViewRotation);
	}

	// Create the safe region
	w = FullWidth * SafeRegionPct;
	X = Canvas.OrgX + (Canvas.ClipX - w) * 0.5;

	// We have some extra logic for figuring out how things should be displayed
	// in split screen.

	h = FullHeight * SafeRegionPct;

	if ( bIsSplitScreen )
	{
		if ( bIsFirstPlayer )
		{
			Y = Canvas.ClipY - H;
		}
		else
		{
			Y = 0.0f;
		}
	}
	else
	{
		Y = Canvas.OrgY + (Canvas.ClipY - h) * 0.5;
	}

	Canvas.OrgX = X;
	Canvas.OrgY = Y;
	Canvas.ClipX = w;
	Canvas.ClipY = h;
	Canvas.Reset(true);
	// EmberGameInfo(WorldInfo.Game).playerpawnWORLD.getScreenWH(Canvas.ClipX, Canvas.ClipY);

   // Canvas.SetDrawColor(255, 255, 255); // White
			// Canvas.SetPos(0.5*(Canvas.ClipX - XL), 0.44*Canvas.ClipY);
   // Canvas.DrawRect(504, 504);  

	// Set up delta time
	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
	LastHUDRenderTime = WorldInfo.TimeSeconds;

	// If we are not over, draw the hud
	if (UTGRI != None && !UTGRI.bMatchIsOver)
	{
		PlayerOwner.DrawHud( Self );
		DrawGameHud();
	}
	else	// Match is over
	{
		DrawPostGameHud();

		// still draw pause message
		if ( WorldInfo.Pauser != None )
		{
			Canvas.Font = GetFontSizeIndex(2);
			Canvas.Strlen(class'UTGameViewportClient'.default.LevelActionMessages[1],xl,yl);
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.SetPos(0.5*(Canvas.ClipX - XL), 0.44*Canvas.ClipY);
			Canvas.DrawText(class'UTGameViewportClient'.default.LevelActionMessages[1]);
		}
	}

	LastHUDUpdateTime = WorldInfo.TimeSeconds;
}
simulated function DrawWeaponCrosshair()
{
	local vector2d CrosshairSize;
	local float x,y,PickupScale, ScreenX, ScreenY;

	local float TargetDist;


	X = Canvas.ClipX * 0.5;
	Y = Canvas.ClipY * 0.5;
   
	// TargetDist = 0;//GetTargetDistance();

	// // Apply pickup scaling

	// if ( LastPickupTime > WorldInfo.TimeSeconds - 0.3 )
	// {
	// 	if ( LastPickupTime > WorldInfo.TimeSeconds - 0.15 )
	// 	{
	// 		PickupScale = (1 + 5 * (WorldInfo.TimeSeconds - LastPickupTime));
	// 	}
	// 	else
	// 	{
	// 		PickupScale = (1 + 5 * (LastPickupTime + 0.3 - WorldInfo.TimeSeconds));
	// 	}
	// }
	// else
	// {
	// 	PickupScale = 1.0;
	// }

 // 	CrosshairSize.Y = 10;//ConfiguredCrosshairScaling * 10 * CrossHairCoordinates.VL * PickupScale * Canvas.ClipY/720;
 //  	CrosshairSize.X = 10;//CrosshairSize.Y * ( CrossHairCoordinates.UL / CrossHairCoordinates.VL );

	// ScreenX = X - (CrosshairSize.X * 0.5);
	// ScreenY = Y - (CrosshairSize.Y * 0.5);
	// // if ( CrosshairImage != none )
	// // {
	// 	// crosshair drop shadow
	// 	Canvas.DrawColor = BlackColor;
	// 	Canvas.SetPos( ScreenX+1, ScreenY+1, TargetDist );
	// 	Canvas.DrawTile(CrosshairImage,CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL,CrossHairCoordinates.VL);

	// 	CrosshairColor = bGreenCrosshair ? Default.LightGreenColor : Default.CrosshairColor;
	// 	Canvas.DrawColor = (WorldInfo.TimeSeconds - LastHitEnemyTime < 0.3) ? RedColor : CrosshairColor;
	// 	Canvas.SetPos(ScreenX, ScreenY, TargetDist);
	// 	Canvas.DrawTile(CrosshairImage,CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL,CrossHairCoordinates.VL);
	// }
}
defaultproperties
{
}