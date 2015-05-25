Contents = {
	Solid		= 0x00000001,	-- Default setting. An eye is never valid in a solid
	Lava		= 0x00000002,
	Water		= 0x00000004,
	Fog			= 0x00000008,
	PlayerClip	= 0x00000010,
	MonsterClip	= 0x00000020,	-- Physically block bots
	BotClip		= 0x00000040,	-- A hint for bots - do not enter this brush by navigation (if possible)
	ShotClip	= 0x00000080,
	Body		= 0x00000100,	-- should never be on a brush, only in game
	Corpse		= 0x00000200,	-- should never be on a brush, only in game
	Trigger		= 0x00000400,
	NoDrop		= 0x00000800,	-- don't leave bodies or items (death fog, lava)
	Terrain		= 0x00001000,	-- volume contains terrain data
	Ladder		= 0x00002000,
	Abseil		= 0x00004000,	-- (SOF2) used like ladder to define where an NPC can abseil
	Opaque		= 0x00008000,	-- defaults to on, when off, solid can be seen through
	Outside		= 0x00010000,	-- volume is considered to be in the outside (i.e. not indoors)
	Inside		= 0x10000000,	-- volume is considered to be inside (i.e. indoors)
	Slime		= 0x00020000,	-- CHC needs this since we use same tools
	Lightsaber	= 0x00040000,	-- ""
	Teleporter	= 0x00080000,	-- ""
	Item		= 0x00100000,	-- ""
	NoShot		= 0x00200000,	-- shots pass through me
	Detail		= 0x08000000,	-- brushes not used for the bsp
	Translucent	= 0x80000000	-- don't consume surface fragments inside
}

CPD = {
	NEWDRAINEFX			= 0x00000001,
	DUELSEEOTHERS		= 0x00000002,	-- see other players when dueling
	ENDDUELROTATION		= 0x00000004,
	BLACKSABERSDISABLE	= 0x00000008,	-- disable black sabers
	AUTOREPLYDISABLE	= 0x00000010,
	NEWFORCEEFFECT		= 0x00000020,
	NEWDEATHMSG_DISABLE	= 0x00000040,
	NEWSIGHTEFFECT		= 0x00000080,
	NOALTDIMEFFECT		= 0x00000100,
	HOLSTEREDSABER		= 0x00000200,
	LEDGEGRAB			= 0x00000400,	-- disable ledge grab
	NEWDFAPRIM			= 0x00000800,
	NEWDFAALT			= 0x00001000,
	NOSPCARTWHEEL		= 0x00002000,
	ALLOWLIBCURL		= 0x00004000,
	NOKATA				= 0x00008000,	-- disable katas
	NOBUTTERFLY			= 0x00010000,	-- diable dual/staff butterfly
	NOSTAB				= 0x00020000,	-- disable roll/back stab
	NODFA				= 0x00040000	-- disable dfa
}

CSF = {
	GRAPPLE_SWING		= 0x0001,	-- can correctly predict movement when using the grapple hook
	SCOREBOARD_LARGE	= 0x0002,	-- can correctly parse scoreboard messages with information for 32 clients
	SCOREBOARD_KD		= 0x0004,	-- can correctly parse scoreboard messages with extra K/D information
	CHAT_FILTERS		= 0x0008,	-- can correctly parse chat messages with proper delimiters
	FIXED_WEAPON_ANIMS	= 0x0010	-- fixes the missing concussion rifle animations
}

CvarFlags = {
	None			= 0x0000,	-- no flags set
	Archive			= 0x0001,	-- set to cause it to be saved to vars.rc, used for system variables, not for player-specific configurations
	UserInfo		= 0x0002,	-- sent to server on connect or change
	ServerInfo		= 0x0004,	-- sent in response to front end requests
	SystemInfo		= 0x0008,	-- these cvars will be duplicated on all clients
	Init			= 0x0010,	-- don't allow change from console at all, but can be set from the command line
	Latch			= 0x0020,	-- will only change when C code next does a Cvar_Get(), so it can't be changed without proper initialization. modified will be set, even though the value hasn't changed yet
	ReadOnly		= 0x0040,	-- display only, cannot be set by user at all (can be set by code)
	UserCreated		= 0x0080,	-- created by a set command
	Temp			= 0x0100,	-- can be set even when cheats are disabled, but is not archived
	Cheat			= 0x0200,	-- can not be changed if cheats are disabled
	NoRestart		= 0x0400,	-- do not clear when a cvar_restart is issued
	Internal		= 0x0800,	-- cvar won't be displayed, ever (for passwords and such)
	Parental		= 0x1000	-- lets cvar system know that parental stuff needs to be updated
}

EFlags = {
	G2ANIMATING		= 0x00000001,	-- perform g2 bone anims based on torsoAnim and legsAnim, works for ET_GENERAL
	DEAD			= 0x00000002,	-- don't draw a foe marker over players with EF_DEAD
	RADAROBJECT		= 0x00000004,	-- display on team radar
	TELEPORT_BIT	= 0x00000008,	-- toggled every time the origin abruptly changes
	SHADER_ANIM		= 0x00000010,	-- animating shader (by s.frame)
	PLAYER_EVENT	= 0x00000020,
	RAG				= 0x00000040,	-- ragdoll him even if he's alive
	PERMANENT		= 0x00000080,	-- permanent entities
	NODRAW			= 0x00000100,	-- may have an event, but no model (unspawned items)
	FIRING			= 0x00000200,
	ALT_FIRING		= 0x00000400,
	JETPACK_ACTIVE	= 0x00000800,	-- jetpack is activated
	NOT_USED_1		= 0x00001000,
	TALK			= 0x00002000,	-- draw a talk balloon
	CONNECTION		= 0x00004000,	-- draw a connection trouble sprite
	ALT_DIM			= 0x00008000,	-- player is in the alternate dimension
	GRAPPLE_SWING	= 0x00010000,	-- swinging on grapple hook
	NOT_USED_2		= 0x00020000,
	NOT_USED_3		= 0x00040000,
	BODYPUSH		= 0x00080000,	-- fullbody push effect
	DOUBLE_AMMO		= 0x00100000,	-- hacky way to get around ammo max (siege)
	SEEKERDRONE		= 0x00200000,	-- show seeker drone floating around head
	MISSILE_STICK	= 0x00400000,	-- missiles that stick to the wall
	ITEMPLACEHOLDER	= 0x00800000,	-- item effect
	SOUNDTRACKER	= 0x01000000,	-- sound position needs to be updated in relation to another entity
	DROPPEDWEAPON	= 0x02000000,	-- it's a dropped weapon
	DISINTEGRATION	= 0x04000000,	-- being disintegrated by the disruptor
	INVULNERABLE	= 0x08000000,	-- just spawned in or whatever, so is protected
	CLIENTSMOOTH	= 0x10000000,	-- standard lerporigin smooth override on client
	JETPACK			= 0x20000000,	-- wearing a jetpack
	JETPACK_FLAMING	= 0x40000000,	-- jetpack fire effect
	NOT_USED_4		= 0x80000000
}

EFlags2 = {
	HELD_BY_MONSTER		= 0x0001,	-- being held by something, like a rancor or a wampa
	USE_ALT_ANIM		= 0x0002,	-- for certain special runs/stands for creatures like the rancor and wampa whose
									--	runs/stands are conditional
	ALERTED				= 0x0004,	-- for certain special anims. for rancor: means you've had an enemy, so use the
									--	more alert stand
	GENERIC_NPC_FLAG	= 0x0008,	-- so far, used for rancor
	FLYING				= 0x0010,	-- flying
	HYPERSPACE			= 0x0020,	-- used to both start the hyperspace effect on the predicted client and to let the
									--	vehicle know it can now jump into hyperspace (after turning to face the proper angle)
	BRACKET_ENTITY		= 0x0040,	-- draw as bracketed
	SHIP_DEATH			= 0x0080,	-- "died in ship" mode
	NOT_USED_1			= 0x0100,	-- grapple hook is out
	GRAPPLE_OUT			= 0x0200
}

Flags = {
	GODMODE					= 0x00000001,
	NOTARGET				= 0x00000002,
	TEAMSLAVE				= 0x00000004,	-- not the first on the team
	NO_KNOCKBACK			= 0x00000008,
	DROPPED_ITEM			= 0x00000010,
	NO_BOTS					= 0x00000020,	-- spawn point not for bot use
	NO_HUMANS				= 0x00000040,	-- spawn point just for bots
	FORCE_GESTURE			= 0x00000080,	-- force gesture on client
	INACTIVE				= 0x00000100,	-- inactive
	NAVGOAL					= 0x00000200,	-- for NPC nav stuff
	DONT_SHOOT				= 0x00000400,
	SHIELDED				= 0x00000800,
	UNDYING					= 0x00001000,	-- takes damage down to 1, but never dies
	BOUNCE					= 0x00002000,	-- for missiles
	BOUNCE_HALF				= 0x00004000,	-- for missiles
	BOUNCE_SHRAPNEL			= 0x00008000,	-- special shrapnel flag
	VEH_BOARDING			= 0x00010000,
	DMG_BY_SABER_ONLY		= 0x00020000,	-- only take damage from saber
	DMG_BY_HEAVY_WEAP_ONLY	= 0x00040000,	-- only take damage from explosives
	BBRUSH					= 0x00080000	-- breakable brush
}

Fonts = {
	NONE		= 0,
	SMALL		= 1,
	MEDIUM		= 2,
	LARGE		= 3,
	SMALL2		= 4,
	JAPPLARGE	= 5,
	JAPPSMALL	= 6,
	JAPPMONO	= 7
}

FSMode = {
	READ		= 0,
	WRITE		= 1,
	APPEND		= 2,
	APPEND_SYNC	= 3
}

Gametypes = {
	FFA				= 0,	-- deathmatch
	HOLOCRON		= 1,	-- holocron deathmatch
	JEDIMASTER		= 2,	-- jedi master
	DUEL			= 3,	-- 1v1
	POWERDUEL		= 4,	-- 2v1
	SINGLE_PLAYER	= 5,	-- cooperative
	-- team gametypes
	TEAM			= 6,	-- team deathmatch
	SIEGE			= 7,	-- siege/objectives
	CTF				= 8,	-- capture the flag
	CTY				= 9		-- capture the ysalimiri
}

Gender = {
	MALE	= 0,
	FEMALE	= 1,
	NEUTER	= 2
}

KeyCatcher = {
	CONSOLE	= 0x01,
	UI		= 0x02,
	MESSAGE	= 0x04,
	CGAME	= 0x08
}

MOD = {
	UNKNOWN					= 0,
	STUN_BATON				= 1,
	MELEE					= 2,
	SABER					= 3,
	BRYAR_PISTOL 			= 4,
	BRYAR_PISTOL_ALT 		= 5,
	BLASTER 				= 6,
	TURBLAST 				= 7,
	DISRUPTOR 				= 8,
	DISRUPTOR_SPLASH 		= 9,
	DISRUPTOR_SNIPER 		= 10,
	BOWCASTER 				= 11,
	REPEATER 				= 12,
	REPEATER_ALT 			= 13,
	REPEATER_ALT_SPLASH		= 14,
	DEMP2 					= 15,
	DEMP2_ALT				= 16,
	FLECHETTE 				= 17,
	FLECHETTE_ALT_SPLASH	= 18,
	ROCKET 					= 19,
	ROCKET_SPLASH 			= 20,
	ROCKET_HOMING 			= 21,
	ROCKET_HOMING_SPLASH	= 22,
	THERMAL 				= 23,
	THERMAL_SPLASH 			= 24,
	TRIP_MINE_SPLASH 		= 25,
	TIMED_MINE_SPLASH 		= 26,
	DET_PACK_SPLASH 		= 27,
	VEHICLE 				= 28,
	CONC 					= 29,
	CONC_ALT 				= 30,
	FORCE_DARK 				= 31,
	SENTRY 					= 32,
	WATER 					= 33,
	SLIME 					= 34,
	LAVA 					= 35,
	CRUSH 					= 36,
	TELEFRAG 				= 37,
	FALLING 				= 38,
	SUICIDE 				= 39,
	TARGET_LASER 			= 40,
	TRIGGER_HURT 			= 41,
	TEAM_CHANGE 			= 42
}

SaberStyle = {
	NONE	= 0,
	FAST	= 1,
	MEDIUM	= 2,
	STRONG	= 3,
	DESANN	= 4,
	TAVION	= 5,
	DUAL	= 6,
	STAFF	= 7
}

SoundChannel = {
	AUTO			= 0,	-- auto-picks an empty channel to play sound on
	LOCAL			= 1,	-- menu sounds, etc
	WEAPON			= 2,
	VOICE			= 3,	-- voice sounds cause mouth animation
	VOICE_ATTEN		= 4,	-- causes mouth animation but still use normal sound falloff
	ITEM			= 5,
	BODY			= 6,
	AMBIENT			= 7,	-- added for ambient sounds
	LOCAL_SOUND		= 8,	-- chat messages, etc
	ANNOUNCER		= 9,	-- announcer voices, etc
	LESS_ATTEN		= 10,	-- attenuates similar to chan_voice, but uses empty channel auto-pick behaviour
	MENU1			= 11,	-- menu stuff, etc
	VOICE_GLOBAL	= 12,	-- causes mouth animation and is broadcast, like announcer
	MUSIC			= 13	-- music played as a looping sound
}

SSF = {
	GRAPPLE_SWING		= 0x0001,	-- can swing on grapple hook
	SCOREBOARD_LARGE	= 0x0002,	-- can send scoreboard information for 32 clients
	SCOREBOARD_KD		= 0x0004,	-- will show K/D on scoreboard
	CHAT_FILTERS		= 0x0008,	-- will send correct delimiters for tabbed chatbox
	FIXED_WEAP_ANIMS	= 0x0010,	-- fixed bryar/concussion firing animations
	MERC_FLAMETHROWER	= 0x0020,
	SPECTINFO			= 0x0040
}

Team = {
	FREE		= 0,
	RED			= 1,
	BLUE		= 2,
	SPECTATOR	= 3
}

TextStyle = {
	NORMAL			= 0,
	BLINK			= 1,
	PULSE			= 2,
	SHADOWED		= 3,
	OUTLINED		= 4,
	OUTLINESHADOWED	= 5,
	SHADOWEDMORE	= 6
}

Weapons = {
	NONE			= 0,
	STUN_BATON		= 1,
	MELEE			= 2,
	SABER			= 3,
	BRYAR_PISTOL	= 4,
	BLASTER			= 5,
	DISRUPTOR		= 6,
	BOWCASTER		= 7,
	REPEATER		= 8,
	DEMP2			= 9,
	FLECHETTE		= 10,
	ROCKET_LAUNCHER	= 11,
	THERMAL			= 12,
	TRIP_MINE		= 13,
	DET_PACK		= 14,
	CONCUSSION		= 15,
	BRYAR_OLD		= 16,
	EMPLACED_GUN	= 17,
	TURRET			= 18,
	NUM_WEAPONS		= 19
}
