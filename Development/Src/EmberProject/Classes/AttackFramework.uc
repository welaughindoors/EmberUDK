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


var name ServerAnimationNames[63];
var float ServerAnimationDuration[63];
var float ServerAnimationFadeIn[63];
var float ServerAnimationFadeOut[63];
var float ServerAnimationTracerStart[63];
var float ServerAnimationTracerEnd[63];
var float ServerAnimationKnockback[63];
var float ServerAnimationChamberStart[63];
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
ServerAnimationNames[13] = ember_temp_back_attack;
ServerAnimationNames[14] = ember_temp_back_left_attack;
ServerAnimationNames[15] = ember_temp_back_right_attack;

// ServerAnimationNames[16] = ember_medium_left;
ServerAnimationNames[16] = ember_medium_left;
ServerAnimationNames[17] = ember_medium_right;
ServerAnimationNames[18] = ember_medium_forward;
ServerAnimationNames[19] = ember_medium_diagonal_left;
ServerAnimationNames[20] = ember_medium_diagonal_right;
ServerAnimationNames[21] = ember_medium_forward;
ServerAnimationNames[22] = ember_medium_diagonal_left_reverse;
ServerAnimationNames[23] = ember_medium_diagonal_right_reverse;

ServerAnimationNames[24] = ember_medium_left;
ServerAnimationNames[25] = ember_medium_right;
ServerAnimationNames[26] = ember_medium_forward;
ServerAnimationNames[27] = ember_medium_diagonal_left;
ServerAnimationNames[28] = ember_medium_diagonal_right;
ServerAnimationNames[29] = ember_medium_forward; //medium back
ServerAnimationNames[30] = ember_medium_diagonal_left_reverse;
ServerAnimationNames[31] = ember_medium_diagonal_right_reverse;

//-------
// No Winds
ServerAnimationNames[32] = ember_temp_left_attack_no_wind;
ServerAnimationNames[33] = ember_temp_right_attack_no_wind;
ServerAnimationNames[34] = ember_attack_forward_no_wind;
ServerAnimationNames[35] = ember_temp_left_attack_no_wind;
ServerAnimationNames[36] = ember_temp_right_attack_no_wind;
ServerAnimationNames[37] = ember_temp_back_attack_no_wind;
ServerAnimationNames[38] = ember_temp_back_left_attack_no_wind;
ServerAnimationNames[39] = ember_temp_back_right_attack_no_wind;

// ServerAnimationNames[16] = ember_medium_left_no_wind;
ServerAnimationNames[40] = ember_medium_left_no_wind;
ServerAnimationNames[41] = ember_medium_right_no_wind;
ServerAnimationNames[42] = ember_medium_forward_no_wind;
ServerAnimationNames[43] = ember_medium_diagonal_left_no_wind;
ServerAnimationNames[44] = ember_medium_diagonal_right_no_wind;
ServerAnimationNames[45] = ember_medium_forward_no_wind;
ServerAnimationNames[46] = ember_medium_diagonal_left_reverse_no_wind;
ServerAnimationNames[47] = ember_medium_diagonal_right_reverse_no_wind;

// ServerAnimationNames[48] = ember_heavy_left_no_wind;
// ServerAnimationNames[49] = ember_heavy_right_no_wind;
// ServerAnimationNames[50] = ember_heavy_forward_no_wind;
// ServerAnimationNames[51] = ember_heavy_forward_left_no_wind;
// ServerAnimationNames[52] = ember_heavy_forward_right_no_wind;
// ServerAnimationNames[53] = ember_heavy_forward_no_wind; //heavy back
// ServerAnimationNames[54] = ember_heavy_back_left_no_wind;
// ServerAnimationNames[55] = ember_heavy_back_right_no_wind;

ServerAnimationNames[48] = ember_medium_left_no_wind;
ServerAnimationNames[49] = ember_medium_right_no_wind;
ServerAnimationNames[50] = ember_medium_forward_no_wind;
ServerAnimationNames[51] = ember_medium_diagonal_left_no_wind;
ServerAnimationNames[52] = ember_medium_diagonal_right_no_wind;
ServerAnimationNames[53] = ember_medium_forward_no_wind; //medium back
ServerAnimationNames[54] = ember_medium_diagonal_left_reverse_no_wind;
ServerAnimationNames[55] = ember_medium_diagonal_right_reverse_no_wind;

// ServerAnimationFadeOut[32] = 
// ServerAnimationFadeOut[33] = 
// ServerAnimationFadeOut[34] = 
// ServerAnimationFadeOut[35] = 
// ServerAnimationFadeOut[36] = 
// ServerAnimationFadeOut[37] = 
// ServerAnimationFadeOut[38] = 
// ServerAnimationFadeOut[39] = 

// ServerAnimationFadeOut[40] = 
// ServerAnimationFadeOut[41] = 
// ServerAnimationFadeOut[42] = 
// ServerAnimationFadeOut[43] = 
// ServerAnimationFadeOut[44] = 
// ServerAnimationFadeOut[45] = 
// ServerAnimationFadeOut[46] = 
// ServerAnimationFadeOut[47] = 

// ServerAnimationFadeOut[48] = 
// ServerAnimationFadeOut[49] = 
// ServerAnimationFadeOut[50] = 
// ServerAnimationFadeOut[51] = 
// ServerAnimationFadeOut[52] = 
// ServerAnimationFadeOut[53] =  
// ServerAnimationFadeOut[54] = 
// ServerAnimationFadeOut[55] = 
//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationDuration[8]  = 1;
ServerAnimationDuration[9]  = 1;
ServerAnimationDuration[10] = 1.2;
ServerAnimationDuration[11] = 1;
ServerAnimationDuration[12] = 1;
ServerAnimationDuration[13] = 1.2;
ServerAnimationDuration[14] = 1;
ServerAnimationDuration[15] = 1;

ServerAnimationDuration[16] = 1.4;
ServerAnimationDuration[17] = 1.5;
ServerAnimationDuration[18] = 1.4;
ServerAnimationDuration[19] = 1.4;
ServerAnimationDuration[20] = 1.5;
ServerAnimationDuration[21] = 1.4;
ServerAnimationDuration[22] = 1.4;
ServerAnimationDuration[23] = 1.4;

ServerAnimationDuration[24] = 1.4;
ServerAnimationDuration[25] = 1.5;
ServerAnimationDuration[26] = 1.4;
ServerAnimationDuration[27] = 1.4;
ServerAnimationDuration[28] = 1.5;
ServerAnimationDuration[29] = 1.4;
ServerAnimationDuration[30] = 1.4;
ServerAnimationDuration[31] = 1.4;

//---
//No Wind
ServerAnimationDuration[32] = 1;
ServerAnimationDuration[33] = 1;
ServerAnimationDuration[34] = 1.2;
ServerAnimationDuration[35] = 1;
ServerAnimationDuration[36] = 1;
ServerAnimationDuration[37] = 1.2;
ServerAnimationDuration[38] = 1;
ServerAnimationDuration[39] = 1;

ServerAnimationDuration[40] = 1.4;
ServerAnimationDuration[41] = 1.4;
ServerAnimationDuration[42] = 1.4;
ServerAnimationDuration[43] = 1.4;
ServerAnimationDuration[44] = 1.4;
ServerAnimationDuration[45] = 1.4;
ServerAnimationDuration[46] = 1.4;
ServerAnimationDuration[47] = 1.4;

ServerAnimationDuration[48] = 1.4;
ServerAnimationDuration[49] = 1.4;
ServerAnimationDuration[50] = 1.4;
ServerAnimationDuration[51] = 1.4;
ServerAnimationDuration[52] = 1.4;
ServerAnimationDuration[53] = 1.4;
ServerAnimationDuration[54] = 1.4;
ServerAnimationDuration[55] = 1.4;
//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationFadeIn[8]  = 0.3;
ServerAnimationFadeIn[9]  = 0.3;
ServerAnimationFadeIn[10] = 0.3;
ServerAnimationFadeIn[11] = 0.3;
ServerAnimationFadeIn[12] = 0.3;
ServerAnimationFadeIn[13] = 0.3;
ServerAnimationFadeIn[14] = 0.3;
ServerAnimationFadeIn[15] = 0.3;

ServerAnimationFadeIn[16] = 0.3;
ServerAnimationFadeIn[17] = 0.3;
ServerAnimationFadeIn[18] = 0.3;
ServerAnimationFadeIn[19] = 0.3;
ServerAnimationFadeIn[20] = 0.3;
ServerAnimationFadeIn[21] = 0.3;
ServerAnimationFadeIn[22] = 0.3;
ServerAnimationFadeIn[23] = 0.3;

ServerAnimationFadeIn[24] = 0.3;
ServerAnimationFadeIn[25] = 0.3;
ServerAnimationFadeIn[26] = 0.2;
ServerAnimationFadeIn[27] = 0.3;
ServerAnimationFadeIn[28] = 0.3;
ServerAnimationFadeIn[29] = 0.2;
ServerAnimationFadeIn[30] = 0.3;
ServerAnimationFadeIn[31] = 0.3;

//---
//No Wind

ServerAnimationFadeIn[32] = 0.3;
ServerAnimationFadeIn[33] = 0.3;
ServerAnimationFadeIn[34] = 0.3;
ServerAnimationFadeIn[35] = 0.3;
ServerAnimationFadeIn[36] = 0.3;
ServerAnimationFadeIn[37] = 0.3;
ServerAnimationFadeIn[38] = 0.3;
ServerAnimationFadeIn[39] = 0.3;

ServerAnimationFadeIn[40] = 0.3;
ServerAnimationFadeIn[41] = 0.3;
ServerAnimationFadeIn[42] = 0.3;
ServerAnimationFadeIn[43] = 0.3;
ServerAnimationFadeIn[44] = 0.3;
ServerAnimationFadeIn[45] = 0.3;
ServerAnimationFadeIn[46] = 0.3;
ServerAnimationFadeIn[47] = 0.3;

ServerAnimationFadeIn[48] = 0.3;
ServerAnimationFadeIn[49] = 0.3;
ServerAnimationFadeIn[50] = 0.3;
ServerAnimationFadeIn[51] = 0.3;
ServerAnimationFadeIn[52] = 0.3;
ServerAnimationFadeIn[53] = 0.3;
ServerAnimationFadeIn[54] = 0.3;
ServerAnimationFadeIn[55] = 0.3;

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationFadeOut[8]  = 0.5;
ServerAnimationFadeOut[9]  = 0.5;
ServerAnimationFadeOut[10] = 0.5;
ServerAnimationFadeOut[11] = 0.5;
ServerAnimationFadeOut[12] = 0.5;
ServerAnimationFadeOut[13] = 0.5;
ServerAnimationFadeOut[14] = 0.5;
ServerAnimationFadeOut[15] = 0.5;

ServerAnimationFadeOut[16] = 0.5;
ServerAnimationFadeOut[17] = 0.5;
ServerAnimationFadeOut[18] = 0.5;
ServerAnimationFadeOut[19] = 0.5;
ServerAnimationFadeOut[20] = 0.5;
ServerAnimationFadeOut[21] = 0.5;
ServerAnimationFadeOut[22] = 0.5;
ServerAnimationFadeOut[23] = 0.5;

ServerAnimationFadeOut[24] = 0.5;
ServerAnimationFadeOut[25] = 0.5;
ServerAnimationFadeOut[26] = 0.5;
ServerAnimationFadeOut[27] = 0.5;
ServerAnimationFadeOut[28] = 0.5;
ServerAnimationFadeOut[29] = 0.5;
ServerAnimationFadeOut[30] = 0.5;
ServerAnimationFadeOut[31] = 0.5;

//--- 
//No Wind

ServerAnimationFadeOut[32] = 0.5;
ServerAnimationFadeOut[33] = 0.5;
ServerAnimationFadeOut[34] = 0.5;
ServerAnimationFadeOut[35] = 0.5;
ServerAnimationFadeOut[36] = 0.5;
ServerAnimationFadeOut[37] = 0.5;
ServerAnimationFadeOut[38] = 0.5;
ServerAnimationFadeOut[39] = 0.5;

ServerAnimationFadeOut[40] = 0.5;
ServerAnimationFadeOut[41] = 0.5;
ServerAnimationFadeOut[42] = 0.5;
ServerAnimationFadeOut[43] = 0.5;
ServerAnimationFadeOut[44] = 0.5;
ServerAnimationFadeOut[45] = 0.5;
ServerAnimationFadeOut[46] = 0.5;
ServerAnimationFadeOut[47] = 0.5;

ServerAnimationFadeOut[48] = 0.5;
ServerAnimationFadeOut[49] = 0.5;
ServerAnimationFadeOut[50] = 0.5;
ServerAnimationFadeOut[51] = 0.5;
ServerAnimationFadeOut[52] = 0.5;
ServerAnimationFadeOut[53] = 0.5;
ServerAnimationFadeOut[54] = 0.5;
ServerAnimationFadeOut[55] = 0.5;

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

ServerAnimationTracerStart[24] = 0.5;
ServerAnimationTracerStart[25] = 0.6;
ServerAnimationTracerStart[26] = 0.5;
ServerAnimationTracerStart[27] = 0.45;
ServerAnimationTracerStart[28] = 0.45;
ServerAnimationTracerStart[29] = 0.5;
ServerAnimationTracerStart[30] = 0.43;
ServerAnimationTracerStart[31] = 0.43;

//---
// No Windups = 0 start;

//==================================================================================
//==================================================================================
//==================================================================================

ServerAnimationTracerEnd[8]  = 1;
ServerAnimationTracerEnd[9]  = 1;
ServerAnimationTracerEnd[10] = 1.2;
ServerAnimationTracerEnd[11] = 1;
ServerAnimationTracerEnd[12] = 1;

ServerAnimationTracerEnd[16] = 0.75;
ServerAnimationTracerEnd[17] = 0.75;
ServerAnimationTracerEnd[18] = 0.78;
ServerAnimationTracerEnd[19] = 0.77;
ServerAnimationTracerEnd[20] = 0.77;
ServerAnimationTracerEnd[21] = 0.77;
ServerAnimationTracerEnd[22] = 0.77;
ServerAnimationTracerEnd[23] = 0.77;

ServerAnimationTracerEnd[24] = 0.75;
ServerAnimationTracerEnd[25] = 0.75;
ServerAnimationTracerEnd[26] = 0.78;
ServerAnimationTracerEnd[27] = 0.77;
ServerAnimationTracerEnd[28] = 0.77;
ServerAnimationTracerEnd[29] = 0.77;
ServerAnimationTracerEnd[30] = 0.77;
ServerAnimationTracerEnd[31] = 0.77;

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

ServerAnimationKnockback[24] = 9500;
ServerAnimationKnockback[25] = 9500;
ServerAnimationKnockback[26] = 9500;
ServerAnimationKnockback[27] = 9500;
ServerAnimationKnockback[28] = 9500;
ServerAnimationKnockback[29] = 9500;
ServerAnimationKnockback[30] = 9500;
ServerAnimationKnockback[31] = 9500;

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

ServerAnimationChamberStart[24] = 0.4;
ServerAnimationChamberStart[25] = 0.4;
ServerAnimationChamberStart[26] = 0.48;
ServerAnimationChamberStart[27] = 0.4;
ServerAnimationChamberStart[28] = 0.4;
ServerAnimationChamberStart[29] = 0.48;
ServerAnimationChamberStart[30] = 0.4;
ServerAnimationChamberStart[31] = 0.4;

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
heavySwordMesh = SkeletalMesh'ArtAnimation.hilt'

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