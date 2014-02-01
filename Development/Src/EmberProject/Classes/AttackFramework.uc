class AttackFramework extends Object;


// struct DirectionAttackStruct
// {}
// const LLeft=3;
const dTop 			= 0;
const dBottom 		= 1;
const dLeft 		= 2;
const dRight 		= 3;
const dTopLeft 		= 4;
const dTopRight 	= 5;
const dBottomLeft 	= 6;
const dBottomRight 	= 7;

var float lightCameraShake;
var float mediumCameraShake;
var float heavyCameraShake;

var name lightLeftString1;
var array<float>lightLeftString1Mods;
var name lightRightString1;
var array<float>lightRightString1Mods;
var name lightForwardString1;
var array<float>lightForwardString1Mods;
var name lightForwardLeftString1;
var array<float>lightForwardLeftString1Mods;
var name lightForwardRightString1;
var array<float>lightForwardRightString1Mods;

var name lightBackString1;
var array<float>lightBackString1Mods;
var name lightBackLeftString1;
var array<float>lightBackLeftString1Mods;
var name lightBackRightString1;
var array<float>lightBackRightString1Mods;

var name mediumLeftString1;
var array<float>mediumLeftString1Mods;
var name mediumRightString1;
var array<float>mediumRightString1Mods;
var name mediumForwardString1; 
var array<float>mediumForwardString1Mods;
var name mediumForwardLeftString1;
var array<float>mediumForwardLeftString1Mods;
var name mediumForwardRightString1;
var array<float>mediumForwardRightString1Mods;

var name mediumBackString1;
var array<float>mediumBackString1Mods;
var name mediumBackLeftString1;
var array<float>mediumBackLeftString1Mods;
var name mediumBackRightString1;
var array<float>mediumBackRightString1Mods;

var name heavyLeftString1;
var array<float>heavyLeftString1Mods;
var name heavyRightString1;
var array<float>heavyRightString1Mods;
var name heavyForwardString1;
var array<float>heavyForwardString1Mods;
var name heavyForwardLeftString1;
var array<float>heavyForwardLeftString1Mods;
var name heavyForwardRightString1;
var array<float>heavyForwardRightString1Mods;

var name heavyBackString1;
var array<float>heavyBackString1Mods;
var name heavyBackLeftString1;
var array<float>heavyBackLeftString1Mods;
var name heavyBackRightString1;
var array<float>heavyBackRightString1Mods;


var float lightDamagePerTracer;
var float mediumDamagePerTracer;
var float heavyDamagePerTracer;

var SkeletalMesh lightSwordMesh;
var SkeletalMesh mediumSwordMesh;
var SkeletalMesh heavySwordMesh;

function InitFramework()
{
	SetUpDirectionals();
}

function SetUpDirectionals()
{
	lightLeftString1Mods.AddItem(dLeft);	
	lightRightString1Mods.AddItem(dRight);
	lightForwardString1Mods.AddItem(dTop);
    lightForwardLeftString1Mods.AddItem(dTopLeft);
    lightForwardRightString1Mods.AddItem(dTopRight);
    lightBackLeftString1Mods.AddItem(dBottomLeft);
    lightBackRightString1Mods.AddItem(dBottomRight);

    mediumLeftString1Mods.AddItem(dLeft);	
	mediumRightString1Mods.AddItem(dRight);
	mediumForwardString1Mods.AddItem(dTop);
    mediumForwardLeftString1Mods.AddItem(dTopLeft);
    mediumForwardRightString1Mods.AddItem(dTopRight);
    mediumBackLeftString1Mods.AddItem(dBottomLeft);
    mediumBackRightString1Mods.AddItem(dBottomRight);

    heavyLeftString1Mods.AddItem(dLeft);	
	heavyRightString1Mods.AddItem(dRight);
	heavyForwardString1Mods.AddItem(dTop);
    heavyForwardLeftString1Mods.AddItem(dTopLeft);
    heavyForwardRightString1Mods.AddItem(dTopRight);
    heavyBackLeftString1Mods.AddItem(dBottomLeft);
    heavyBackRightString1Mods.AddItem(dBottomRight);
}

DefaultProperties
{	
	//=============================================
// Combo / Attack System Vars
//=============================================
/* Note:
/- Placement in EmberPawn is temporary
/- Light/Medium/Heavy stances will be set in their 
/- Respective Sword.uc files when Ready.
*/

lightLeftString1			=	ember_temp_left_attack
lightRightString1			=	ember_temp_right_attack
lightForwardString1			=	ember_attack_forward
lightForwardLeftString1 	=	ember_temp_left_attack
lightForwardRightString1 	= 	ember_temp_right_attack
lightBackString1			=	
lightBackLeftString1 		=	
lightBackRightString1 		= 	

mediumLeftString1			=   ember_medium_left
mediumRightString1			=   ember_medium_right
mediumForwardString1 		=	ember_medium_forward
mediumForwardLeftString1 	=   ember_medium_diagonal_left
mediumForwardRightString1 	=   ember_medium_diagonal_right
mediumBackString1 			=	ember_medium_forward
mediumBackRightString1 		=   ember_medium_diagonal_left_reverse
mediumBackLeftString1 		=   ember_medium_diagonal_right_reverse

heavyLeftString1			=   ember_heavy_left
heavyRightString1			=	
heavyForwardString1			=   ember_heavy_forward
heavyForwardLeftString1 	=   ember_heavy_left
heavyForwardRightString1 	= 	
heavyBackString1			=
heavyBackLeftString1 		=   
heavyBackRightString1 		= 	


/* Mods:
/ -- Duration
/ -- Time till Tracer is Active (s)
/ -- Time till Tracer gets Deactivated (s),  if 0 = active for all attack
/ -- Blend in duration (s)
/ -- Blend out duration (s)
/ -- Knockback
/ -- Time Till Chamber (s)
/ ex: (1, 0.5, 0, 0.3, 0.5, 7500, 0.48): duration = 1s,  tracers start after 0.5s,  last till animation finishes, 
/ the first 0.3s of animation is blended with previous animation, the last 0.5s will blend with next animation
/ will do ~ 7500 knockback
/ 0.48s after attack starts, attack will pause if chambered
/ Condensed:
/ (Duration, Time Till Tracer Active, Time Till Tracer Ends, Blend In, Blend Out, Knockback, Time Till Chamber)
*/

lightLeftString1Mods 			=(1, 0.5, 0, 0.3, 0.5, 7500, 0.4)
lightRightString1Mods 			=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightForwardString1Mods 		=(1, 0.65, 0, 0.3, 0.5, 7500, 0.4)
lightForwardLeftString1Mods		=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightForwardRightString1Mods 	=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightBackString1Mods 			=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightBackLeftString1Mods		=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightBackRightString1Mods 		=(1, 0, 0, 0.3, 0.5, 7500, 0.4)

mediumLeftString1Mods 			=(1.3, 0.5, 0.7, 0.3, 0.5, 9500, 0.4) 
mediumRightString1Mods 			=(1.3, 0.5, 0.7, 0.3, 0.5, 9500, 0.4)
mediumForwardString1Mods 		=(1.3, 0.5, 0.7, 0.3, 0.5, 9500, 0.48)
mediumForwardLeftString1Mods 	=(1.3, 0.5, 0.7, 0.3, 0.5, 9500, 0.4)
mediumForwardRightString1Mods 	=(1.3, 0.5, 0.7, 0.3, 0.5, 9500, 0.4)
mediumBackString1Mods 			=(1.3, 0.5, 0.7, 0.3, 0.5, 9500, 0.48)
mediumBackLeftString1Mods 		=(1.3, 0.43, 0.65, 0.3, 0.5, 9500, 0.4)
mediumBackRightString1Mods	 	=(1.3, 0.43, 0.65, 0.3, 0.5, 9500, 0.4)

heavyLeftString1Mods 			=(2.0, 0.70, 1.05, 0.3, 0.5, 20000, 0.6)
heavyRightString1Mods 			=(1, 0, 0, 0.3, 0.5, 20000, 0.6)
heavyForwardString1Mods 		=(1.5, 1.0, 2.0, 0.2, 0.28, 20000, 0.8)
heavyForwardLeftString1Mods 	=(2.0, 0.70, 1.05, 0.3, 0.5, 20000, 0.6)
heavyForwardRightString1Mods 	=(1, 0, 0, 0.3, 0.5, 20000, 0.6)
heavyBackString1Mods 			=(1, 0, 0, 0.3, 0.5, 20000, 0.6)
heavyBackLeftString1Mods 		=(1, 0, 0, 0.3, 0.5, 20000, 0.6)
heavyBackRightString1Mods 		=(1, 0, 0, 0.3, 0.5, 20000, 0.6)


/* Damage:
/ -- Set damage per tracer
*/

lightDamagePerTracer = 2.5
mediumDamagePerTracer = 7.5
heavyDamagePerTracer = 13

/* Swords:
/ -- The Sword Meshes
*/

lightSwordMesh 	= SkeletalMesh'ArtAnimation.Meshes.gladius'
mediumSwordMesh = SkeletalMesh'ArtAnimation.Meshes.ember_weapon_katana'
heavySwordMesh 	= SkeletalMesh'ArtAnimation.Meshes.ember_weapon_heavy2'

/* Camera shakes
/ -- Currently:
/ -- Light : Camera shake in Light stance
/ -- Medium : Camera shake in Medium stance
/ -- Heavy : Camera shake in Heavy stance
/ -- Lower values = less shake + colour
/ -- Higher values = more shake + colour
*/

lightCameraShake = 0.1
mediumCameraShake = 0.21
heavyCameraShake = 0.47

}