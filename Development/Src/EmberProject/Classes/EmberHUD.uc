class EmberHUD extends UTHUD;

function DrawBar(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosX,NbCases,i;

    PosX = X; // Where we should draw the next rectangle
    NbCases = 10 * Value / MaxValue;	 // Number of active rectangles to draw
    i=0; // Number of rectangles already drawn

    /* Displays active rectangles */
    while(i < NbCases && i < 10)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(R,G,B,200);
        Canvas.DrawRect(8,12);

        PosX += 10;
        i++;

    }

    /* Displays desactived rectangles */
    while(i < 10)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(255,255,255,80);
        Canvas.DrawRect(8,12);

        PosX += 10;
        i++;

    }

    /* Displays a title */
    Canvas.SetPos(PosX + 5,Y);
    Canvas.SetDrawColor(R,G,B,200);
    Canvas.Font = class'Engine'.static.GetSmallFont();
    Canvas.DrawText(Title);

}

function DrawGameHud()
{

    // if ( !PlayerOwner.IsDead() && !UTPlayerOwner.IsInState('Spectating'))
    // {
        DrawBar("Health",80, 100,20,20,200,80,80); //        DrawBar("Ammo",UTWeapon(PawnOwner.Weapon).AmmoCount, UTWeapon(PawnOwner.Weapon).MaxAmmoCount ,20,40,80,80,200);     }

}
defaultproperties
{
}