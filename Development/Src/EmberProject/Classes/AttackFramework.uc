class AttackFramework extends Object;

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
mediumBackLeftString1 		=   ember_medium_diagonal_left_reverse
mediumBackRightString1 		=   ember_medium_diagonal_right_reverse

heavyLeftString1			=   ember_heavy_left
heavyRightString1			=	
heavyForwardString1			=
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
/ ex: (1, 0.5, 0, 0.3, 0.5): duration = 1s,  tracers start after 0.5s,  last till animation finishes, 
/ the first 0.3s of animation is blended with previous animation, the last 0.5s will blend with next animation
*/

lightLeftString1Mods 			=(1, 0.5, 0, 0.3, 0.5)
lightRightString1Mods 			=(1, 0, 0, 0.3, 0.5)
lightForwardString1Mods 		=(1, 0.65, 0, 0.3, 0.5)
lightForwardLeftString1Mods		=(1, 0, 0, 0.3, 0.5)
lightForwardRightString1Mods 	=(1, 0, 0, 0.3, 0.5)
lightBackString1Mods 			=(1, 0, 0, 0.3, 0.5)
lightBackLeftString1Mods		=(1, 0, 0, 0.3, 0.5)
lightBackRightString1Mods 		=(1, 0, 0, 0.3, 0.5)

mediumLeftString1Mods 			=(1.3, 0.5, 0.7, 0.3, 0.5) 
mediumRightString1Mods 			=(1.3, 0.5, 0.7, 0.3, 0.5)
mediumForwardString1Mods 		=(1.3, 0.5, 0.7, 0.3, 0.5)
mediumForwardLeftString1Mods 	=(1.3, 0.5, 0.7, 0.3, 0.5)
mediumForwardRightString1Mods 	=(1.3, 0.5, 0.7, 0.3, 0.5)
mediumBackString1Mods 			=(1.3, 0.5, 0.7, 0.3, 0.5)
mediumBackLeftString1Mods 		=(1.3, 0.5, 0.7, 0.3, 0.5)
mediumBackRightString1Mods	 	=(1.3, 0.5, 0.7, 0.3, 0.5)

heavyLeftString1Mods 			=(2.0, 0.70, 1.05, 0.3, 0.5)
heavyRightString1Mods 			=(1, 0, 0, 0.3, 0.5)
heavyForwardString1Mods 		=(1, 0, 0, 0.3, 0.5)
heavyForwardLeftString1Mods 	=(2.0, 0.70, 1.05, 0.3, 0.5)
heavyForwardRightString1Mods 	=(1, 0, 0, 0.3, 0.5)
heavyBackString1Mods 			=(1, 0, 0, 0.3, 0.5)
heavyBackLeftString1Mods 		=(1, 0, 0, 0.3, 0.5)
heavyBackRightString1Mods 		=(1, 0, 0, 0.3, 0.5)

/* Damage:
/ -- Set damage per tracer
*/

lightDamagePerTracer = 5
mediumDamagePerTracer = 10
heavyDamagePerTracer = 20

}