# EmberUDK

Controls
===========
- WASD : Movement
- E    : Grapple
- 1    : Fast Stance
- 2    : Medium Stance
- 3    : Heavy Stance
- 4    : Sheathe
- Ctrl (hold) : Walk
- Shift : Dash
- Left Click (tap): Attack
- Left Click (tap + tap): Feints into an attack (have to tap during windup)
- Left Click (Hold): Chamber's Attack

- Right Click (tap): Feint windup
- Right Click (hold): Chamber, release into attack (same as holding left click)

Console Commands
===========

type command as shown here to see a description of what it does

- ep_sword_block_distance
- ep_sword_block_cone
- ep_player_anim_run_blend_time
- ep_player_anim_idle_blend_time
- ep_player_gravity_scaling
- ep_player_jump_boost
- ep_player_rotation_when_stationary
- ep_player_rotation_iterp_stationary_attack
- ep_player_rotation_iterp_movement
- ep_player_rotation_iterp_movement_attack
- dot_angle_examples
- ep_ai_follow_player
- ep_ai_attack_player
- ep_ai_attack_player_range
- tethermod 0 0 0

TODO:
==========

####Inathero's doing this
- NETWORKING WTF
- Change timer from anim preset duration to actual anim duration
- Sword Trail implementation
- Shuffle 'dodge' booster thingy
- Perhaps material left where sword touches object? like JKA
- Velocity pinching on jumps
- Advanced parry system
- Walking blending tweaking

####Biddybam's doing this
- Better Grapple

####Admin's doing this
- Walking animation + blending

####Hydras's doing this
- Testing out cosmetics

####Misc:
- Sheathe animation?
- Better Camera
- UI. Menu UI, Multiplayer UI, Server List, HUD
- HUD: HP, Crosshair, Stances (1,2,3), Strings?
- Everything.

Recently Completed:
==========

####Inathero
- ~~Better Queuing of attacks on left click (hold)~~
- Chamber Attacks and feints on right click (hold/tap)
- Basic Velocity Pinching on attacks
- Basic Jump Velocity Pinching on landing
- Basic Knockback (but per stance)
- Basic Dodge when pressing Shift
- Camera shakes on hit/damage/parry
- Colour Camera blue = hit, red = damage, green = parry
- Directional Parries
- Some basic temporary sound assets
- API's for Grapple
- API's for Static Cosmetic items
- API's for Cape/Cloth Cosmetic Items
- TestPawn uses medium AttackFramework
- Made collision between pawn and cape
- Chain limit enabled (chain X attacks. Last attack needs to go to idle before continuing)
- Attack Locks (on heavies)

####Biddybam
- Grapple 'sticks' around edges, like a rope
- Grapple 'unsticks' around edges when going back around

####Admin + Coldhands Anim Team
- Animations
- Updated medium side's
- Updated medium left/right diagonals
- Updated medium forward
- light thrust

####Hydra
- Headband cosmetic
- Capes
- and more capes!

Issues:
==========
- Grapple doesn't work correctly on low-end computers (Intel Core 2 Duo CPU E8400 @3.00GHz)

Networking Issues:
==========
- Grapple is completely dead
- Sword replication on Test Pawns is null
- Collision Z axis on test pawns is lower than default
- Test Pawns damage is one hit killing. Probably due to null sword replication
- Player does no damage

Notes:
==========
When we're dealing with rotations (degrees) in unrealscript: 
 * 360 = 65536
 * 180 = 32768
 * 90 = 16384
 * 45 = 8192
 * 1 = 182.044
