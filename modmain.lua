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
--    local HungerBadge = require "widgets/hungerbadge"

    local function OnSetPlayerModeFefe(inst, self)
        self.modetaskfefe=nil
        if self.fefebrain ~= nil and self.onvitalitydelta == nil then
            self.onvitalitydelta = function(owner, data) self:VitalityDelta(data) end
            self.inst:ListenForEvent("vitalitydelta", self.onvitalitydelta, self.owner)
            self:SetVitalityPercent(1)
        end
    end

    local function OnSetGhostModeFefe(inst, self)
        self.modetaskfefe=nil
        if self.onvitalitydelta ~= nil then
            self.inst:RemoveEventCallback("vitalitydelta", self.onvitalitydelta, self.owner)
            self.onvitalitydelta = nil
        end
    end

    function self:AddVitality()
        if self.fefebrain == nil then
            self.fefebrain = self:AddChild(VitalityBadge(self.owner))
            self.fefebrain:SetPosition(-80, -40, 0)
--            TODO:vitalitydelta(data), GetVitality(),SetVitalityPercent() change "sanitydelta" to "vitalitydelta"
            if self.isghostmode then
                self.fefebrain:Hide()
            elseif self.modetask == nil and self.onvitalitydelta == nil then
                    self.onvitalitydelta = function(owner, data) self:VitalityDelta(data) end
                self.inst:ListenForEvent("vitalitydelta", self.onvitalitydelta, self.owner)
                self:SetVitalityPercent(self.owner:GetVitality())
            end
        end
    end

    function self:RemoveVitality()
        if self.fefebrain ~= nil then
            if self.onvitalitydelta ~= nil then
                self.inst:RemoveEventCallback("vitalitydelta", self.onvitalitydelta, self.owner)
                self.onvitalitydelta = nil
            end

            self.fefebrain:Kill()
            self.fefebrain = nil
        end
    end

    local oldSetGhostMode=self.SetGhostMode
    self.SetGhostMode=function(self, ghostmode)
        oldSetGhostMode(self, ghostmode)
        if ghostmode then
            if self.owner:HasTag("vitality") then
                self.fefebrain:Hide()
                self.fefebrain:StopWarning()
            end
        else
            if self.owner:HasTag("vitality") ~= nil then
                self.fefebrain:Show()
            end
        end

        if self.modetaskfefe ~= nil then
            self.modetaskfefe:Cancel()
        end
        self.modetaskfefe = self.inst:DoTaskInTime(0, ghostmode and OnSetGhostModeFefe or OnSetPlayerModeFefe, self)
    end

    local oldShowStatusNumbers=self.ShowStatusNumbers
    self.ShowStatusNumbers=function(self)
        oldShowStatusNumbers(self)
        self.fefebrain.num:Show()
        if self.fefebrain ~= nil then
            self.fefebrain.num:Show()
        end
    end

    local oldHideStatusNumbers=self.HideStatusNumbers
    self.HideStatusNumbers=function(self)
        oldHideStatusNumbers(self)
        self.fefebrain.num:Hide()
        if self.fefebrain ~= nil then
            self.fefebrain.num:Hide()
        end
    end

--TODO:Remove the redundant if statement
--    local oldSetSanityPercent=self.SetSanityPercent
    self.SetVitalityPercent=function(self,pct)
--        oldSetSanityPercent(self, pct)
        self.fefebrain:SetPercent(pct, self.owner:GetMaxVitality(), self.owner:GetVitalityPenalty())

            if self.owner.replica.sanity:IsInsane() or self.owner.replica.sanity:IsEnlightened() then
                self.fefebrain:StartWarning()
            else
                self.fefebrain:StopWarning()
            end
    end

--    local oldSanityDelta=self.SanityDelta
--    function self:SanityDelta(data)
--        oldSanityDelta(self,data)
--       self:VitalityDelta(data)
--        if self.owner:HasTag("vitality") then
--            if not data.overtime then
--                if data.newpercent > data.oldpercent then
--                    self.fefebrain:PulseGreen()
--                    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_up")
--                elseif data.newpercent < data.oldpercent then
--                    self.fefebrain:PulseRed()
--                    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_down")
--                end
--            end
--        end
--    end

    function self:VitalityDelta(data)
        self:SetVitalityPercent(data.newpercent)
--        oldSanityDelta(self,data)
        if not data.overtime then
            if data.newpercent > data.oldpercent then
                self.fefebrain:PulseGreen()
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_up")
            elseif data.newpercent < data.oldpercent then
                self.fefebrain:PulseRed()
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_down")
            end
        end
    end

    self.fefebrain=nil
    self.onvitalitydelta=nil
    self.modetaskfefe=nil --for initialization when entering the game scene

--    self:AddVitality()
    if self.owner:HasTag("vitality") then
        self:AddVitality()
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
