Gametypes = setmetatable( {}, {
	__index = {
		FFA						= 0,
		HOLOCRON				= 1,
		JEDIMASTER				= 2,
		DUEL					= 3,
		POWERDUEL				= 4,
		SINGLE_PLAYER			= 5,
		TEAM					= 6,
		SIEGE					= 7,
		CTF						= 8,
		CTY						= 9 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

Fonts = setmetatable( {}, {
	__index = {
		NONE					= 0,
		SMALL					= 1,
		MEDIUM					= 2,
		LARGE					= 3,
		SMALL2					= 4,
		JAPPLARGE				= 5,
		JAPPSMALL				= 6,
		JAPPMONO				= 7 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

TextStyle = setmetatable( {}, {
	__index = {
		NORMAL					= 0,
		BLINK					= 1,
		PULSE					= 2,
		SHADOWED				= 3,
		OUTLINED				= 4,
		OUTLINESHADOWED			= 5,
		SHADOWEDMORE			= 6 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

SoundChannel = setmetatable( {}, {
	__index = {
		AUTO					= 0,	-- Auto-picks an empty channel to play sound on
		LOCAL					= 1,	-- menu sounds, etc
		WEAPON					= 2,
		VOICE					= 3,	-- Voice sounds cause mouth animation
		VOICE_ATTEN				= 4,	-- Causes mouth animation but still use normal sound falloff
		ITEM					= 5,
		BODY					= 6,
		AMBIENT					= 7,	-- added for ambient sounds
		LOCAL_SOUND				= 8,	-- chat messages, etc
		ANNOUNCER				= 9,	-- announcer voices, etc
		LESS_ATTEN				= 10,	-- attenuates similar to chan_voice, but uses empty channel auto-pick behaviour
		MENU1					= 11,	-- menu stuff, etc
		VOICE_GLOBAL			= 12,	-- Causes mouth animation and is broadcast, like announcer
		MUSIC					= 13 },	-- music played as a looping sound
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

Weapons = setmetatable( {}, {
	__index = {
		NONE					= 0,
		STUN_BATON				= 1,
		MELEE					= 2,
		SABER					= 3,
		BRYAR_PISTOL			= 4,
		BLASTER					= 5,
		DISRUPTOR				= 6,
		BOWCASTER				= 7,
		REPEATER				= 8,
		DEMP2					= 9,
		FLECHETTE				= 10,
		ROCKET_LAUNCHER			= 11,
		THERMAL					= 12,
		TRIP_MINE				= 13,
		DET_PACK				= 14,
		CONCUSSION				= 15,
		BRYAR_OLD				= 16,
		EMPLACED_GUN			= 17,
		TURRET					= 18,
		NUM_WEAPONS				= 19 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

SaberStyle = setmetatable( {}, {
	__index = {
		NONE					= 0,
		FAST					= 1,
		MEDIUM					= 2,
		STRONG					= 3,
		DESANN					= 4,
		TAVION					= 5,
		DUAL					= 6,
		STAFF					= 7 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

EFlags = setmetatable( {}, {
	__index = {
		G2ANIMATING				= 0x00000001,
		DEAD					= 0x00000002,
		RADAROBJECT				= 0x00000004,
		TELEPORT_BIT			= 0x00000008,
		SHADER_ANIM				= 0x00000010,
		PLAYER_EVENT			= 0x00000020,
		RAG						= 0x00000040,
		PERMANENT				= 0x00000080,
		NODRAW					= 0x00000100,
		FIRING					= 0x00000200,
		ALT_FIRING				= 0x00000400,
		JETPACK_ACTIVE			= 0x00000800,
		NOT_USED_1				= 0x00001000,
		TALK					= 0x00002000,
		CONNECTION				= 0x00004000,
		ALT_DIM					= 0x00008000,
		GRAPPLE_SWING			= 0x00010000,
		NOT_USED_2				= 0x00020000,
		NOT_USED_3				= 0x00040000,
		BODYPUSH				= 0x00080000,
		DOUBLE_AMMO				= 0x00100000,
		SEEKERDRONE				= 0x00200000,
		MISSILE_STICK			= 0x00400000,
		ITEMPLACEHOLDER			= 0x00800000,
		SOUNDTRACKER			= 0x01000000,
		DROPPEDWEAPON			= 0x02000000,
		DISINTEGRATION			= 0x04000000,
		INVULNERABLE			= 0x08000000,
		CLIENTSMOOTH			= 0x10000000,
		JETPACK					= 0x20000000,
		JETPACK_FLAMING			= 0x40000000,
		NOT_USED_4				= 0x80000000 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

EFlags2 = setmetatable( {}, {
	__index = {
		HELD_BY_MONSTER			= 0x001,
		USE_ALT_ANIM			= 0x002,
		ALERTED					= 0x004,
		GENERIC_NPC_FLAG		= 0x008,
		FLYING					= 0x010,
		HYPERSPACE				= 0x020,
		BRACKET_ENTITY			= 0x040,
		SHIP_DEATH				= 0x080,
		NOT_USED_1				= 0x100,
		GRAPPLE_OUT				= 0x200 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

Gender = setmetatable( {}, {
	__index = {
		MALE					= 0,
		FEMALE					= 1,
		NEUTER					= 2 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

CSF = setmetatable( {}, {
	__index = {
		GRAPPLE_SWING			= 0x01,
		SCOREBOARD_LARGE		= 0x02,
		SCOREBOARD_KD			= 0x04,
		CHAT_FILTERS			= 0x08,
		FIXED_WEAPON_ANIMS		= 0x10 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

SSF = setmetatable( {}, {
	__index = {
		GRAPPLE_SWING			= 0x01,
		SCOREBOARD_LARGE		= 0x02,
		SCOREBOARD_KD			= 0x04,
		CHAT_FILTERS			= 0x08,
		FIXED_WEAP_ANIMS		= 0x10,
		MERC_FLAMETHROWER		= 0x20 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

CvarFlags = setmetatable( {}, {
	__index = {
		NONE					= 0x0000,	-- no flags set
		ARCHIVE					= 0x0001,	-- set to cause it to be saved to vars.rc, used for system variables, not for player-specific configurations
		USERINFO				= 0x0002,	-- sent to server on connect or change
		SERVERINFO				= 0x0004,	-- sent in response to front end requests
		SYSTEMINFO				= 0x0008,	-- these cvars will be duplicated on all clients
		INIT					= 0x0010,	-- don't allow change from console at all, but can be set from the command line
		LATCH					= 0x0020,	-- will only change when C code next does a Cvar_Get(), so it can't be changed without proper initialization. modified will be set, even though the value hasn't changed yet
		ROM						= 0x0040,	-- display only, cannot be set by user at all (can be set by code)
		USER_CREATED			= 0x0080,	-- created by a set command
		TEMP					= 0x0100,	-- can be set even when cheats are disabled, but is not archived
		CHEAT					= 0x0200,	-- can not be changed if cheats are disabled
		NORESTART				= 0x0400,	-- do not clear when a cvar_restart is issued
		INTERNAL				= 0x0800,	-- cvar won't be displayed, ever (for passwords and such)
		PARENTAL				= 0x1000 },	-- lets cvar system know that parental stuff needs to be updated
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

FSMode = setmetatable( {}, {
	__index = {
		READ					= 0,
		WRITE					= 1,
		APPEND					= 2,
		APPEND_SYNC				= 3 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

Contents = setmetatable( {}, {
	__index = {
		CONTENTS_SOLID			= 0x00000001,	-- Default setting. An eye is never valid in a solid
		CONTENTS_LAVA			= 0x00000002,
		CONTENTS_WATER			= 0x00000004,
		CONTENTS_FOG			= 0x00000008,
		CONTENTS_PLAYERCLIP		= 0x00000010,
		CONTENTS_MONSTERCLIP	= 0x00000020,	-- Physically block bots
		CONTENTS_BOTCLIP		= 0x00000040,	-- A hint for bots - do not enter this brush by navigation (if possible)
		CONTENTS_SHOTCLIP		= 0x00000080,
		CONTENTS_BODY			= 0x00000100,	-- should never be on a brush, only in game
		CONTENTS_CORPSE			= 0x00000200,	-- should never be on a brush, only in game
		CONTENTS_TRIGGER		= 0x00000400,
		CONTENTS_NODROP			= 0x00000800,	-- don't leave bodies or items (death fog, lava)
		CONTENTS_TERRAIN		= 0x00001000,	-- volume contains terrain data
		CONTENTS_LADDER			= 0x00002000,
		CONTENTS_ABSEIL			= 0x00004000,	-- (SOF2) used like ladder to define where an NPC can abseil
		CONTENTS_OPAQUE			= 0x00008000,	-- defaults to on, when off, solid can be seen through
		CONTENTS_OUTSIDE		= 0x00010000,	-- volume is considered to be in the outside (i.e. not indoors)
		CONTENTS_INSIDE			= 0x10000000,	-- volume is considered to be inside (i.e. indoors)
		CONTENTS_SLIME			= 0x00020000,	-- CHC needs this since we use same tools
		CONTENTS_LIGHTSABER		= 0x00040000,	-- ""
		CONTENTS_TELEPORTER		= 0x00080000,	-- ""
		CONTENTS_ITEM			= 0x00100000,	-- ""
		CONTENTS_NOSHOT			= 0x00200000,	-- shots pass through me
		CONTENTS_DETAIL			= 0x08000000,	-- brushes not used for the bsp
		CONTENTS_TRANSLUCENT	= 0x80000000 },	-- don't consume surface fragments inside
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )
