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

    Asset("ANIM", "anim/status_vitality.zip"),
}

AddMinimapAtlas("images/map_icons/fefe.xml")


local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

--Adds the vitality meter
local function StatusPostConstruct(self)
    local VitalityBadge = require "widgets/vitalitybadge"
    local HungerBadge = require "widgets/hungerbadge"

    self.fefebrain = self:AddChild(VitalityBadge(self.owner))
    self.fefebrain:SetPosition(-80, -40, 0)
    self.onvitalitydelta = nil

    local oldShowStatusNumbers=self.ShowStatusNumbers
    self.ShowStatusNumbers=function(self)
        oldShowStatusNumbers(self)
        self.fefebrain.num:Show()
    end

    local oldHideStatusNumbers=self.HideStatusNumbers
    self.HideStatusNumbers=function(self)
        oldHideStatusNumbers(self)
        self.fefebrain.num:Hide()
    end

    local oldSetHungerPercent=self.SetHungerPercent
    self.SetHungerPercent=function(self,pct)
        oldSetHungerPercent(self,pct)
        self.fefebrain:SetPercent(pct, self.owner.replica.hunger:Max())

        if pct <= 0 then
            self.fefebrain:StartWarning()
        else
            self.fefebrain:StopWarning()
        end
    end

    local oldHungerDelta=self.HungerDelta
    function self:HungerDelta(data)
        oldHungerDelta(self,data)
        if not data.overtime then
            if data.newpercent > data.oldpercent then
                self.fefebrain:PulseGreen()
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/hunger_up")
            elseif data.newpercent < data.oldpercent then
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/hunger_down")
                self.fefebrain:PulseGreen()
            end
        end
    end

end


AddClassPostConstruct("widgets/statusdisplays", StatusPostConstruct)

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
