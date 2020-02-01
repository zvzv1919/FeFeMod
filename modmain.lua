PrefabFiles = {
	"fefe",
	"fefe_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/fefe.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/fefe.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/fefe.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/fefe.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/fefe_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/fefe_silho.xml" ),

    Asset( "IMAGE", "bigportraits/fefe.tex" ),
    Asset( "ATLAS", "bigportraits/fefe.xml" ),
	
	Asset( "IMAGE", "images/map_icons/fefe.tex" ),
	Asset( "ATLAS", "images/map_icons/fefe.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_fefe.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_fefe.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_fefe.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_fefe.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_fefe.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_fefe.xml" ),
	
	Asset( "IMAGE", "images/names_fefe.tex" ),
    Asset( "ATLAS", "images/names_fefe.xml" ),
	
	Asset( "IMAGE", "images/names_gold_fefe.tex" ),
    Asset( "ATLAS", "images/names_gold_fefe.xml" ),
}

AddMinimapAtlas("images/map_icons/fefe.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.fefe = "睡觉达人"
STRINGS.CHARACTER_NAMES.fefe = "fefe"
STRINGS.CHARACTER_DESCRIPTIONS.fefe = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.fefe = "\"让我再睡一会儿\""

-- Custom speech strings
STRINGS.CHARACTERS.FEFE = require "speech_fefe"

-- The character's name as appears in-game 
STRINGS.NAMES.FEFE = "fefe"
STRINGS.SKIN_NAMES.fefe_none = "fefe"

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("fefe", "FEMALE")
