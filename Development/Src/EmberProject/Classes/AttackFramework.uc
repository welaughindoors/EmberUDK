class AttackFramework extends Object;


// struct DirectionAttackStruct
// {}
// const LLeft=3;

//Might be depreciated
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

var array<name>TestLockAnim;

var byte MaxAttacksThatCanBeStringed;
var byte CurrentAttackString;

//=================================================
// Used for replication
//=================================================

const REP_lightLeftString1          = 8;
const REP_lightRightString1         = 9;
const REP_lightForwardString1       = 10;
const REP_lightForwardLeftString1   = 11;
const REP_lightForwardRightString1  = 12;
const REP_lightBackString1          = 13;
const REP_lightBackLeftString1      = 14;
const REP_lightBackRightString1     = 15;

const REP_mediumLeftString1         = 16;
const REP_mediumRightString1        = 17;
const REP_mediumForwardString1      = 18;
const REP_mediumForwardLeftString1  = 19;
const REP_mediumForwardRightString1 = 20;
const REP_mediumBackString1         = 21;
const REP_mediumBackRightString1    = 22;
const REP_mediumBackLeftString1     = 23;

const REP_heavyLeftString1          = 24;
const REP_heavyRightString1         = 25;
const REP_heavyForwardString1       = 26;
const REP_heavyForwardLeftString1   = 27;
const REP_heavyForwardRightString1  = 28;
const REP_heavyBackString1          = 29;
const REP_heavyBackLeftString1      = 30;
const REP_heavyBackRightString1     = 31;


//=================================================
// We should simpify this later imo
//=================================================
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

var struct ForcedAnimLoopPacketStruct
{
    var name AnimName;
    var float blendIn;
    var float blendOut;
    var float tDur;
} ForcedAnimLoopPacket;


var name ServerAnimationNames[32];
var float ServerAnimationDuration[32];
var float ServerAnimationFadeIn[32];
var float ServerAnimationFadeOut[32];
//==================================================================
//==================================================================

function SetUpBlockPacket()
{
    //Animation Name for block
ForcedAnimLoopPacket.AnimName = 'ember_medium_block';
    //FadeOut to blend in (from whatever action into block)
ForcedAnimLoopPacket.blendIn = 0.2;
    //FadeOut to blend out (from block out to idle/attack)
ForcedAnimLoopPacket.blendOut = 0.2;
    //FadeOut of anim in s. lower = faster block
ForcedAnimLoopPacket.tDur = 0.3;
}

//==================================================================
//==================================================================

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

    TestLockAnim.AddItem('ember_heavy_forward');
}

//==================================================================
//==================================================================

function InitFramework()
{
    SetUpDirectionals();
    SetUpBlockPacket();
}

//==================================================================
//==================================================================

DefaultProperties
{	
// AttackSlot[0].PlayCustomAnimByFadeOut(AnimName, Mods[0], Mods[1], Mods[2]);
//                                                 aFramework.ServerAnimationNames     [AnimAttack],
//                                                 aFramework.ServerAnimationFadeOut  [AnimAttack], 
//                                                 aFramework.ServerAnimationFadeIn    [AnimAttack], 
//                                                 aFramework.ServerAnimationFadeOut   [AnimAttack]);
//==========================================================
//Networking, Highly likely to convert normal client to this
//Copying Nether's way of doing this
//==========================================================
ServerAnimationNames[8] = ember_temp_left_attack;
ServerAnimationNames[9] = ember_temp_right_attack;
ServerAnimationNames[10] = ember_attack_forward;
ServerAnimationNames[11] = ember_temp_left_attack;
ServerAnimationNames[12] = ember_temp_right_attack;

ServerAnimationNames[16] = ember_medium_left;
ServerAnimationNames[17] = ember_medium_right;
ServerAnimationNames[18] = ember_medium_forward;
ServerAnimationNames[19] = ember_medium_diagonal_left;
ServerAnimationNames[20] = ember_medium_diagonal_right;
ServerAnimationNames[21] = ember_medium_forward;
ServerAnimationNames[22] = ember_medium_diagonal_left_reverse;
ServerAnimationNames[23] = ember_medium_diagonal_right_reverse;

ServerAnimationNames[24] = ember_heavy_left;
ServerAnimationNames[26] = ember_heavy_forward;
ServerAnimationNames[27] = ember_heavy_left;
ServerAnimationNames[29] = ember_heavy_forward;

ServerAnimationDuration[8]  = 1;
ServerAnimationDuration[9]  = 1;
ServerAnimationDuration[10] = 1;
ServerAnimationDuration[11] = 1;
ServerAnimationDuration[12] = 1;

ServerAnimationDuration[16] = 1.4;
ServerAnimationDuration[17] = 1.4;
ServerAnimationDuration[18] = 1.4;
ServerAnimationDuration[19] = 1.4;
ServerAnimationDuration[20] = 1.4;
ServerAnimationDuration[21] = 1.4;
ServerAnimationDuration[22] = 1.4;
ServerAnimationDuration[23] = 1.4;

ServerAnimationDuration[24] = 1.7;
ServerAnimationDuration[26] = 1.4;
ServerAnimationDuration[27] = 1.7;
ServerAnimationDuration[29] = 1.4;

ServerAnimationFadeIn[8]  = 0.3;
ServerAnimationFadeIn[9]  = 0.3;
ServerAnimationFadeIn[10] = 0.3;
ServerAnimationFadeIn[11] = 0.3;
ServerAnimationFadeIn[12] = 0.3;

ServerAnimationFadeIn[16] = 0.3;
ServerAnimationFadeIn[17] = 0.3;
ServerAnimationFadeIn[18] = 0.3;
ServerAnimationFadeIn[19] = 0.3;
ServerAnimationFadeIn[20] = 0.3;
ServerAnimationFadeIn[21] = 0.3;
ServerAnimationFadeIn[22] = 0.3;
ServerAnimationFadeIn[23] = 0.3;

ServerAnimationFadeIn[24] = 0.3;
ServerAnimationFadeIn[26] = 0.2;
ServerAnimationFadeIn[27] = 0.3;
ServerAnimationFadeIn[29] = 0.2;

ServerAnimationFadeOut[8]  = 0.5;
ServerAnimationFadeOut[9]  = 0.5;
ServerAnimationFadeOut[10] = 0.5;
ServerAnimationFadeOut[11] = 0.5;
ServerAnimationFadeOut[12] = 0.5;

ServerAnimationFadeOut[16] = 0.5;
ServerAnimationFadeOut[17] = 0.5;
ServerAnimationFadeOut[18] = 0.5;
ServerAnimationFadeOut[19] = 0.5;
ServerAnimationFadeOut[20] = 0.5;
ServerAnimationFadeOut[21] = 0.5;
ServerAnimationFadeOut[22] = 0.5;
ServerAnimationFadeOut[23] = 0.5;

ServerAnimationFadeOut[24] = 0.5;
ServerAnimationFadeOut[26] = 0.1;
ServerAnimationFadeOut[27] = 0.5;
ServerAnimationFadeOut[29] = 0.1;

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
heavyBackString1			=	ember_heavy_forward
heavyBackLeftString1 		=   
heavyBackRightString1 		= 	


/* Mods:
/ -- FadeOut
/ -- Time till Tracer is Active (s)
/ -- Time till Tracer gets Deactivated (s),  if 0 = active for all attack
/ -- Blend in FadeOut (s)
/ -- Blend out FadeOut (s)
/ -- Knockback
/ -- Time Till Chamber (s)
/ ex: (1, 0.5, 0, 0.3, 0.5, 7500, 0.48): FadeOut = 1s,  tracers start after 0.5s,  last till animation finishes, 
/ the first 0.3s of animation is blended with previous animation, the last 0.5s will blend with next animation
/ will do ~ 7500 knockback
/ 0.48s after attack starts, attack will pause if chambered
/ Condensed:
/ (FadeOut, Time Till Tracer Active, Time Till Tracer Ends, Blend In, Blend Out, Knockback, Time Till Chamber)
*/

lightLeftString1Mods 			=(1, 0.5, 0, 0.3, 0.5, 7500, 0.4)
lightRightString1Mods 			=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightForwardString1Mods 		=(1, 0.65, 0, 0.3, 0.5, 7500, 0.4)
lightForwardLeftString1Mods		=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightForwardRightString1Mods 	=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightBackString1Mods 			=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightBackLeftString1Mods		=(1, 0, 0, 0.3, 0.5, 7500, 0.4)
lightBackRightString1Mods 		=(1, 0, 0, 0.3, 0.5, 7500, 0.4)

mediumLeftString1Mods 			=(1.4, 0.5, 0.7, 0.3, 0.5, 9500, 0.4) 
mediumRightString1Mods 			=(1.4, 0.5, 0.7, 0.3, 0.5, 9500, 0.4)
mediumForwardString1Mods 		=(1.4, 0.5, 0.7, 0.3, 0.5, 9500, 0.48)
mediumForwardLeftString1Mods 	=(1.4, 0.45, 0.7, 0.3, 0.5, 9500, 0.4)
mediumForwardRightString1Mods 	=(1.4, 0.45, 0.7, 0.3, 0.5, 9500, 0.4)
mediumBackString1Mods 			=(1.4, 0.5, 0.7, 0.3, 0.5, 9500, 0.48)
mediumBackLeftString1Mods 		=(1.4, 0.43, 0.65, 0.3, 0.5, 9500, 0.4)
mediumBackRightString1Mods	 	=(1.4, 0.43, 0.65, 0.3, 0.5, 9500, 0.4)

heavyLeftString1Mods 			=(1.7, 0.65, 0.85, 0.3, 0.5, 20000, 0.6)
heavyRightString1Mods 			=(1, 0, 0, 0.3, 0.5, 20000, 0.6)
heavyForwardString1Mods 		=(1.4, 0.8, 1.4, 0.2, 0.1, 20000, 0.8)
heavyForwardLeftString1Mods 	=(1.7, 0.65, 0.85, 0.3, 0.5, 20000, 0.6)
heavyForwardRightString1Mods 	=(1, 0, 0, 0.3, 0.5, 20000, 0.6)
heavyBackString1Mods 			=(1.4, 0.70, 1.05, 0.3, 0.5, 20000, 0.6)
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

/* Strings till idle
/ -- Currently:
/ -- the number below signifies how many attacks can be 'stringed' before last one needs to force idle
/ -- example, if the number is 3. then you can string 1, 2, 3 attacks but third attack will return to idle before you can do any other attacks
*/

MaxAttacksThatCanBeStringed = 300

//BLOCK
// Is not here, it's up in the functions because its a packet structure

}