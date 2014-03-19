# EmberUDK

Controls
===========
- WASD : Movement
- E    : Grapple (works only in grapple view)
- 1    : Fast Stance
- 2    : Medium Stance
- 3    : Heavy Stance
- ~~4    : Sheathe~~
- 4    : Grapple View
- Ctrl (hold) : Walk
- Shift : Dash
- Left Click (tap): Attack
- Left Click (tap + tap): Feints into an attack (have to tap during windup)
- Left Click (Hold): Chamber's Attack

- ~~Right Click (tap): Feint windup~~
- ~~Right Click (hold): Chamber, release into attack (same as holding left click)~~
- Right Click (hold) : Block

Console Commands
===========

type command as shown here to see a description of what it does (for most items)

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
- setTracers # (default 15)

---

- ep_player_modular Category# Index#

Categories are: Head=1, Torso=2, Arms=3, Hands=4, Legs=5, Feets=6
Indexs are determined by how many items are in each category. See EmberModularPawn_Cosmetics under SetupComponentList for more details

Be careful when switching head. Switching head can break everything.

---


TODO:
==========

####Inathero's doing this
- Everything Networking. What a monster
- Change timer from anim preset duration to actual anim duration
- Sword Trail implementation
- Shuffle 'dodge' booster thingy
- Perhaps material left where sword touches object? like JKA
- Velocity pinching on jumps
- Advanced parry system
- Walking blending tweaking
- Modular Pawns Advanced
- IK Nodes control and creation
- More blocking

####Biddybam's doing this
- Better Grapple

####Admin's doing this
- Walking animation + blending

####Hydras's doing this
- Testing out cosmetics

####Jinx's doing this
- Working on ember_dowtown

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
- ~~Chamber Attacks and feints on right click (hold/tap)~~
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
- API's for modular items.
- TestPawn uses medium AttackFramework
- Made collision between pawn and cape
- ~~Chain limit enabled (chain X attacks. Last attack needs to go to idle before continuing)~~
- Attack Locks (pending usage)
- Remade pawn rendering code to use modular method rather than static
- Created blocking code to block attacks using a physics asset
- When getting hit/hitting, temp animation freeze to make the attack feel like it has weight
- Unable to cancel animation when 0.5s+ of it remains. However if you hit something, you can attack again regardless of time left
- 3 Damage groups per sword - Sword tip, middle, and hilt. Damage scales from each group differently
- Mini-freeze when hitting something. Gives an extra 'oomf' feeling.
- Over Shoulder zoom when switching to grapple hook
- Basic Pawn Modular Component management + Switching on the fly (for customization)
- Working Crosshair w/ Grapple. Now grapple will go EXACTLY where crosshair is looking
- Dynamic crosshair, is enabled only during Grapple View.
- Player's names appear on top of pawns. Not working completely, but 95% of code is done.


####AI by Inathero
- Will follow player on sight and attack on sight (can enable/disable this w/ console commands)
- Uses entire medium attack framework for attacks currently
- ~~Is able to read the player's moves and setup parries to counter player~~
- ~~Is able to undergo feints in heated combat to trick and damage player in accordance to player's attacks (very basic. am working~~
- ^-- Were disabled in favor for multiplayer (functions it relied on were single player exclusive)

####Networking by Inathero
- Modular Pawns (lighting not being replicated to clients)
- ALL attack animations (in a super bandwidth saving way)
- Stance changes
- Damage to/from EmberPawns (can't damage TestPawns)
- Blocking (needs fixing)
- Chambering (needs testing)
- New damage groups

####Admininistrator
- Essentially all the Animations
- Rig and Model
- Updated medium side's
- Updated medium left/right diagonals
- Updated medium forward
- Parts of modular pawns created
- block animation

####Hydra
- Headband cosmetic
- Capes
- and more capes!

####Coldhands
- light thrust
- a few medium attacks

####Biddybam
- Grapple 'sticks' around edges, like a rope
- Grapple 'unsticks' around edges when going back around

####Jinx
- Basic structuring of Ember_Downtown map

####Flow3r
- basic menu done in flash scaleform.

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

fuck network for now, we also redid pawn code so networking is basically nonexistant atm

How to Multiplayer:
==========

Because we're in the dev testing phase, got to do some stuff

Go to where you installed UDK, and open UnSetup.Game.xml in Binaries folder, example:

C:\UDK-2013-07\Binaries\UnSetup.Game.xml

Change Game Unique ID to 2cd47243-db5d-4b32-bd0a-34c2a8a9c5ae
Change Machine Unique ID to b88282d2-0d27-476e-8511-ab84180c688a

Save. You're done!

When you want to create the latest multiplayer ready version, copy all the files from github over to the main UDK install

and run Package Game.bat

it'll create a zip file. That's the multiplayer ready version =)

Notes:
==========
When we're dealing with rotations (degrees) in unrealscript: 
 * 360 = 65536
 * 180 = 32768
 * 90 = 16384
 * 45 = 8192
 * 1 = 182.044
