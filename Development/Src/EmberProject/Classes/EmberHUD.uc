class EmberHUD extends UTHUD;


/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	    local float CrosshairSize; 
    super.DrawHUD(); 
    Canvas.SetDrawColor(0,255,0,255); 

    CrosshairSize = 0; 

    Canvas.SetPos(CenterX - CrosshairSize, CenterY); 
    Canvas.DrawRect(2*CrosshairSize + 1, 1); 

    Canvas.SetPos(CenterX, CenterY - CrosshairSize); 
    Canvas.DrawRect(1, 2*CrosshairSize + 1);
}
defaultproperties
{
}