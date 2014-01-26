# EmberUDK

Controls
===========
- WASD : Movement
- E    : Grapple
- 1    : Fast Stance
- 2    : Medium Stance
- 3    : Heavy Stance
- 4    : Sheathe
- Left Click : Attack
- Right Click : Block

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

#Inathero's doing this
- Change timer from anim preset duration to actual anim duration
- Add Velocity pinching on attacks
- Sword Trail implementation
- Shuffle 'dodge' booster thingy
- Perhaps material left where sword touches object? like JKA
- Velocity pinching on jumps
- Advanced parry system

#Biddybam's doing this
- Better Grapple

#Misc:
- Sheathe animation?
- Better Camera
- UI. Menu UI, Multiplayer UI, Server List, HUD
- HUD: HP, Crosshair, Stances (1,2,3), Strings?
- Everything.


ISSUES:
==========
- Grapple doesn't work correctly on low-end computers (Intel Core 2 Duo CPU E8400 @3.00GHz)

Notes:
==========
When we're dealing with rotations (degrees) in unrealscript: 
 * 360 = 65536
 * 180 = 32768
 * 90 = 16384
 * 45 = 8192
 * 1 = 182.044