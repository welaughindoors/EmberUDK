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

const lightLeftString1          = 8;
const lightRightString1         = 9;
const lightForwardString1       = 10;
const lightForwardLeftString1   = 11;
const lightForwardRightString1  = 12;
const lightBackString1          = 13;
const lightBackLeftString1      = 14;
const lightBackRightString1     = 15;

const mediumLeftString1         = 16;
const mediumRightString1        = 17;
const mediumForwardString1      = 18;
const mediumForwardLeftString1  = 19;
const mediumForwardRightString1 = 20;
const mediumBackString1         = 21;
const mediumBackRightString1    = 22;
const mediumBackLeftString1     = 23;

const heavyLeftString1          = 24;
const heavyRightString1         = 25;
const heavyForwardString1       = 26;
const heavyForwardLeftString1   = 27;
const heavyForwardRightString1  = 28;
const heavyBackString1          = 29;
const heavyBackLeftString1      = 30;
const heavyBackRightString1     = 31;

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
var float ServerAnimationTracerStart[32];
var float ServerAnimationTracerEnd[32];
var float ServerAnimationKnockback[32];
var float ServerAnimationChamberStart[32];
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

// function SetUpDirectionals()
// {
// 	lightLeftString1Mods.AddItem(dLeft);	
// 	lightRightString1Mods.AddItem(dRight);
// 	lightForwardString1Mods.AddItem(dTop);
//     lightForwardLeftString1Mods.AddItem(dTopLeft);
//     lightForwardRightString1Mods.AddItem(dTopRight);
//     lightBackLeftString1Mods.AddItem(dBottomLeft);
//     lightBackRightString1Mods.AddItem(dBottomRight);

//     mediumLeftString1Mods.AddItem(dLeft);	
// 	mediumRightString1Mods.AddItem(dRight);
// 	mediumForwardString1Mods.AddItem(dTop);
//     mediumForwardLeftString1Mods.AddItem(dTopLeft);
//     mediumForwardRightString1Mods.AddItem(dTopRight);
//     mediumBackLeftString1Mods.AddItem(dBottomLeft);
//     mediumBackRightString1Mods.AddItem(dBottomRight);

//     heavyLeftString1Mods.AddItem(dLeft);	
// 	heavyRightString1Mods.AddItem(dRight);
// 	heavyForwardString1Mods.AddItem(dTop);
//     heavyForwardLeftString1Mods.AddItem(dTopLeft);
//     heavyForwardRightString1Mods.AddItem(dTopRight);
//     heavyBackLeftString1Mods.AddItem(dBottomLeft);
//     heavyBackRightString1Mods.AddItem(dBottomRight);

//     TestLockAnim.AddItem('ember_heavy_forward');
// }

//==================================================================
//==================================================================

function InitFramework()
{
    // SetUpDirectionals();
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
ServerAnimationNames[17] = ember_medium_right_v3;
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

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationDuration[8]  = 1;
ServerAnimationDuration[9]  = 1;
ServerAnimationDuration[10] = 1.2;
ServerAnimationDuration[11] = 1;
ServerAnimationDuration[12] = 1;

ServerAnimationDuration[16] = 1.4;
ServerAnimationDuration[17] = 1.5;
ServerAnimationDuration[18] = 1.4;
ServerAnimationDuration[19] = 1.4;
ServerAnimationDuration[20] = 1.5;
ServerAnimationDuration[21] = 1.4;
ServerAnimationDuration[22] = 1.4;
ServerAnimationDuration[23] = 1.4;

ServerAnimationDuration[24] = 1.7;
ServerAnimationDuration[26] = 1.4;
ServerAnimationDuration[27] = 1.7;
ServerAnimationDuration[29] = 1.4;

//==================================================================================
//==================================================================================
//==================================================================================

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

//==================================================================================
//==================================================================================
//==================================================================================

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

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationTracerStart[8]  = 0.5;
ServerAnimationTracerStart[9]  = 0;
ServerAnimationTracerStart[10] = 0.65;
ServerAnimationTracerStart[11] = 0;
ServerAnimationTracerStart[12] = 0;

ServerAnimationTracerStart[16] = 0.5;
ServerAnimationTracerStart[17] = 0.6;
ServerAnimationTracerStart[18] = 0.5;
ServerAnimationTracerStart[19] = 0.45;
ServerAnimationTracerStart[20] = 0.45;
ServerAnimationTracerStart[21] = 0.5;
ServerAnimationTracerStart[22] = 0.43;
ServerAnimationTracerStart[23] = 0.43;

ServerAnimationTracerStart[24] = 0.65;
ServerAnimationTracerStart[26] = 0.8;
ServerAnimationTracerStart[27] = 0.65;
ServerAnimationTracerStart[29] = 0.70;

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationTracerEnd[8]  = 0.7;
ServerAnimationTracerEnd[9]  = 0.7;
ServerAnimationTracerEnd[10] = 0.7;
ServerAnimationTracerEnd[11] = 0.7;
ServerAnimationTracerEnd[12] = 0.7;

ServerAnimationTracerEnd[16] = 1.5;
ServerAnimationTracerEnd[17] = 1.5;
ServerAnimationTracerEnd[18] = 1.5;
ServerAnimationTracerEnd[19] = 0.7;
ServerAnimationTracerEnd[20] = 0.7;
ServerAnimationTracerEnd[21] = 0.7;
ServerAnimationTracerEnd[22] = 0.65;
ServerAnimationTracerEnd[23] = 0.65;

ServerAnimationTracerEnd[24] = 0.85;
ServerAnimationTracerEnd[26] = 1.4;
ServerAnimationTracerEnd[27] = 0.85;
ServerAnimationTracerEnd[29] = 1.05;

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationKnockback[8]  = 7500;
ServerAnimationKnockback[9]  = 7500;
ServerAnimationKnockback[10] = 7500;
ServerAnimationKnockback[11] = 7500;
ServerAnimationKnockback[12] = 7500;

ServerAnimationKnockback[16] = 9500;
ServerAnimationKnockback[17] = 9500;
ServerAnimationKnockback[18] = 9500;
ServerAnimationKnockback[19] = 9500;
ServerAnimationKnockback[20] = 9500;
ServerAnimationKnockback[21] = 9500;
ServerAnimationKnockback[22] = 9500;
ServerAnimationKnockback[23] = 9500;

ServerAnimationKnockback[24] = 20000;
ServerAnimationKnockback[26] = 20000;
ServerAnimationKnockback[27] = 20000;
ServerAnimationKnockback[29] = 20000;

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationChamberStart[8]  = 0.4;
ServerAnimationChamberStart[9]  = 0.4;
ServerAnimationChamberStart[10] = 0.4;
ServerAnimationChamberStart[11] = 0.4;
ServerAnimationChamberStart[12] = 0.4;

ServerAnimationChamberStart[16] = 0.4;
ServerAnimationChamberStart[17] = 0.4;
ServerAnimationChamberStart[18] = 0.48;
ServerAnimationChamberStart[19] = 0.4;
ServerAnimationChamberStart[20] = 0.4;
ServerAnimationChamberStart[21] = 0.48;
ServerAnimationChamberStart[22] = 0.4;
ServerAnimationChamberStart[23] = 0.4;

ServerAnimationChamberStart[24] = 0.6;
ServerAnimationChamberStart[26] = 0.8;
ServerAnimationChamberStart[27] = 0.6;
ServerAnimationChamberStart[29] = 0.6;

/* Damage:
/ -- Set damage per tracer
*/

lightDamagePerTracer = 2
mediumDamagePerTracer = 3
heavyDamagePerTracer = 5

/* Swords:
/ -- The Sword Meshes
*/

lightSwordMesh 	= SkeletalMesh'ArtAnimation.Meshes.gladius'
mediumSwordMesh = SkeletalMesh'ArtAnimation.Meshes.ember_weapon_katana'
// heavySwordMesh 	= SkeletalMesh'ArtAnimation.Meshes.ember_weapon_heavy2'

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