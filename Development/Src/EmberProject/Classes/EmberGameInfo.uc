class EmberGameInfo extends UTDeathMatch; 

var EmberPlayerController playerControllerWORLD;
var EmberPawn playerpawnWORLD;

 defaultproperties
{
   DefaultPawnClass=class'EmberProject.EmberPawn'
   PlayerControllerClass=class'EmberProject.EmberPlayerController'
   MapPrefixes[0]="UDN"
}