PrefabFiles = {
	"fefe",
	"fefe_none",
    "pillow",
	"icepillow",
	"furrypillow",
	"ivorypillow",
    "catcoonden_placer",
    "healingpill",
    "headachepill",
    "feferegenbuff",
    "invitalbuff",
	"pillcase"
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

    Asset("ATLAS", "images/inventoryimages/pillow.xml"),
    Asset("IMAGE", "images/inventoryimages/pillow.tex"),
	
	Asset("ATLAS", "images/inventoryimages/icepillow.xml"),
    Asset("IMAGE", "images/inventoryimages/icepillow.tex"),
	
	Asset("ATLAS", "images/inventoryimages/furrypillow.xml"),
    Asset("IMAGE", "images/inventoryimages/furrypillow.tex"),
	
	Asset("ATLAS", "images/inventoryimages/ivorypillow.xml"),
    Asset("IMAGE", "images/inventoryimages/ivorypillow.tex"),

    Asset("ATLAS", "images/inventoryimages/healingpill.xml"),
    Asset("IMAGE", "images/inventoryimages/healingpill.tex"),

    Asset("ATLAS", "images/inventoryimages/headachepill.xml"),
    Asset("IMAGE", "images/inventoryimages/headachepill.tex"),

    Asset("ATLAS", "images/inventoryimages/catcoonden.xml"),
    Asset("IMAGE", "images/inventoryimages/catcoonden.tex"),

    Asset("ATLAS", "images/inventoryimages/pillcase.xml"),
    Asset("IMAGE", "images/inventoryimages/pillcase.tex"),

}

AddMinimapAtlas("images/map_icons/fefe.xml")


local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient
local TUNING = GLOBAL.TUNING
local CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

TUNING.FEFE_DAMAGE_MULTIPLIER = 1
TUNING.FEFE_MAX_VITALITY = 100
TUNING.FEFE_MAX_HEALTH = 20000
TUNING.FEFE_MAX_HUNGER = 299
TUNING.FEFE_MAX_SANITY = 20000
TUNING.FEFE_HUNGER_RATE = 1 * TUNING.WILSON_HUNGER_RATE

TUNING.VITALITY_SLEEP = 1
TUNING.VITALITY_DUSK = -0.03
TUNING.VITALITY_NIGHT = -0.2
TUNING.VITALITY_CAVE = -0.08
TUNING.VITALITY_YAWN = -1
TUNING.VITALITY_HUNGER = -0.1
TUNING.VITALITY_SAN = -0.1
TUNING.VITALITY_ATTACKED = 4
TUNING.VITALITY_ATTACK = 2
TUNING.VITALITY_EXTREMETEMP = 1
TUNING.VITALITY_HUNGER_THRESHOLD = 0.7
TUNING.VITALITY_SAN_THRESHOLD = 0.5


TUNING.PILLOW_SLEEPTIME = TUNING.PANFLUTE_SLEEPTIME
TUNING.PILLOW_SLEEPINESS = 3    --delaying sleeping of some creatures like spider; stronger creatures like bosses can
-- take several successive procs before going to sleep.
TUNING.PILLOW_DAMAGE = 20
TUNING.PILLOW_USES = 300
TUNING.PILLOW_SLEEPIFYRATE = .2
TUNING.PILLOW_INSULATION = TUNING.INSULATION_SMALL

TUNING.FURRYPILLOW_DAMAGE = 20
TUNING.FURRYPILLOW_HITRANGE = 2 * TUNING.WHIP_RANGE
TUNING.FURRYPILLOW_SLEEPIFYRATE = .15
TUNING.FURRYPILLOW_AOE = 4
TUNING.FURRYPILLOW_AOE_DMGMULT = .25
TUNING.FURRYPILLOW_PERISHTIME = TUNING.WALRUSHAT_PERISHTIME/2
TUNING.FURRYPILLOW_INSULATION = TUNING.INSULATION_MED

TUNING.ICEPILLOW_INSULATION = TUNING.INSULATION_LARGE
TUNING.ICEPILLOW_PERISHTIME = TUNING.PERISH_FAST
TUNING.ICEPILLOW_DAMAGE = 50
TUNING.ICEPILLOW_FREEZERATE = .25
TUNING.ICEPILLOW_COLDNESS = 1

TUNING.IVORYPILLOW_DAMAGE = 45
TUNING.IVORYPILLOW_HITRANGE = TUNING.WHIP_RANGE
TUNING.IVORYPILLOW_SLEEPIFYRATE = .07
TUNING.IVORYPILLOW_AOE = 5
TUNING.IVORYPILLOW_AOE_DMGMULT = .25
TUNING.IVORYPILLOW_PERISHTIME = TUNING.WALRUSHAT_PERISHTIME
TUNING.IVORYPILLOW_INSULATION = TUNING.INSULATION_LARGE
TUNING.IVORYPILLOW_FREEZERATE = .04
TUNING.IVORYPILLOW_COLDNESS = 2
TUNING.IVORYPILLOW_SLEEPINESS = 5

TUNING.HEALINGPILL_TICK_RATE = 0.6
TUNING.HEALINGPILL_DURATION = 30
TUNING.HEALINGPILL_TICK_VALUE = 1
TUNING.HEALINGPILL_STACK_SIZE = 1

TUNING.FEFE_YAWN_INTERVAL_FIXED = 5
TUNING.FEFE_YAWN_INTERVAL_RANDOM = 10   --dropping the modified interval below 10 will make the game unplayable
TUNING.FEFE_YAWN_GROGGINESS = 2

TUNING.PILLCASE_ARMOR = 1200
TUNING.PILLCASE_ABSORPTION = .4

--Adds the vitality meter
local function StatusPostConstruct(self)
    local VitalityBadge = require "widgets/vitalitybadge"
--    local HungerBadge = require "widgets/hungerbadge"

    local function OnSetPlayerModeFefe(inst, self)
        self.modetaskfefe=nil
        if self.fefebrain ~= nil and self.onvitalitydelta == nil then
            self.onvitalitydelta = function(owner, data) self:VitalityDelta(data) end
            self.inst:ListenForEvent("vitalitydelta", self.onvitalitydelta, self.owner)
            self.fefebrain:GetVitality()
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
                self.fefebrain:GetVitality()
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
            if self.owner:HasTag("vitality") then
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
--        self:SetVitalityPercent(data.newpercent)
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
STRINGS.CHARACTER_DESCRIPTIONS.fefe = "*嗜睡如命\n*酷爱小猫\n*药不离身\n*气血稀薄，但好勇斗狠"
STRINGS.CHARACTER_QUOTES.fefe = "\"让我再睡一会儿\""

-- Custom speech strings
STRINGS.CHARACTERS.FEFE = require "speech_fefe"

-- The character's name as appears in-game 
STRINGS.NAMES.FEFE = "fefe"
STRINGS.SKIN_NAMES.fefe_none = "fefe"

--item names (Name when you hover over it)
STRINGS.NAMES.PILLOW = "枕头"
STRINGS.NAMES.ICEPILLOW = "夏日枕"
STRINGS.NAMES.FURRYPILLOW = "小猫枕"
STRINGS.NAMES.IVORYPILLOW = "龙枕"
STRINGS.NAMES.HEALINGPILL = "连花清瘟"
STRINGS.NAMES.HEADACHEPILL = "布洛芬"
STRINGS.NAMES.PILLCASE = "药罐子"

--item desc (what happens when you click on it)
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PILLOW = "我想我很清醒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEPILLOW = "我想我很清醒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FURRYPILLOW = "我想我很清醒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.IVORYPILLOW = "我想我很清醒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEALINGPILL = "这玩意有毒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEADACHEPILL = "这玩意有毒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PILLCASE = "这玩意有毒"

--item desc (what happens when ike clicks on it)
STRINGS.CHARACTERS.FEFE.DESCRIBE.PILLOW = "我不要离开它！"
STRINGS.CHARACTERS.FEFE.DESCRIBE.ICEPILLOW = "清凉地睡上一觉！"
STRINGS.CHARACTERS.FEFE.DESCRIBE.FURRYPILLOW = "适合在我的头下！"
STRINGS.CHARACTERS.FEFE.DESCRIBE.IVORYPILLOW = "朕的龙枕！"
STRINGS.CHARACTERS.FEFE.DESCRIBE.HEALINGPILL = "我的病体需要它"
STRINGS.CHARACTERS.FEFE.DESCRIBE.HEADACHEPILL = "吃了头就不痛了"
STRINGS.CHARACTERS.FEFE.DESCRIBE.PILLCASE = "一定要记得带药"

--Recipetab for fefe
CUSTOM_RECIPETABS["FEFE"] = { str = "FEFE", sort = 999, icon_atlas = "images/avatars/avatar_fefe.xml",
    icon = "avatar_fefe.tex", owner_tag =
"fefe" }

--Recipe for fefe's items
AddRecipe("pillow", {Ingredient("pigskin", 1),Ingredient("silk", 3)}, CUSTOM_RECIPETABS.FEFE, TECH.NONE, nil, nil, nil, nil,
    "fefe", "images/inventoryimages/pillow.xml")
AddRecipe("icepillow", {Ingredient("pillow", 1, "images/inventoryimages/pillow.xml"),Ingredient("icehat", 1), Ingredient
("gears", 1)}, CUSTOM_RECIPETABS
.FEFE, TECH
.SCIENCE_TWO,
    nil,
    nil, nil,
    nil,
    "fefe", "images/inventoryimages/icepillow.xml")
AddRecipe("furrypillow", {Ingredient("pillow", 1, "images/inventoryimages/pillow.xml"),Ingredient("beefalohat", 1), Ingredient("whip",1)}, CUSTOM_RECIPETABS
.FEFE,
    TECH
.SCIENCE_TWO,
    nil,
    nil, nil,
    nil,
    "fefe", "images/inventoryimages/furrypillow.xml")
AddRecipe("ivorypillow", {Ingredient("furrypillow", 1, "images/inventoryimages/furrypillow.xml"),Ingredient
("icepillow", 1, "images/inventoryimages/icepillow.xml"),Ingredient("minotaurhorn", 1)},
    CUSTOM_RECIPETABS
.FEFE, TECH.MAGIC_THREE, nil,
    nil,
    nil,
    nil, "fefe", "images/inventoryimages/ivorypillow.xml")
AddRecipe("catcoonden", {Ingredient("coontail", 3),Ingredient
("boards", 3),Ingredient("pumpkin", 3)},
    CUSTOM_RECIPETABS
    .FEFE, TECH.NONE, "catcoonden_placer",
    1.5,
    nil,
    nil, "fefe", "images/inventoryimages/catcoonden.xml", "catcoonden.tex") --the image path must not be absolute
AddRecipe("healingpill", {Ingredient("petals", 3), Ingredient("poop", 2), Ingredient("healingsalve", 1)},
    CUSTOM_RECIPETABS.FEFE, TECH
.NONE, nil,
    nil,
    nil,
    4,
    "fefe","images/inventoryimages/healingpill.xml")
AddRecipe("headachepill", {Ingredient("cutgrass", 1)}, CUSTOM_RECIPETABS.FEFE, TECH.NONE, nil, nil,
    nil,
    4,
    "fefe","images/inventoryimages/headachepill.xml")
AddRecipe("pillcase", {Ingredient("moonglass", 15), Ingredient("rope", 1), Ingredient("board", 1)},
    CUSTOM_RECIPETABS.FEFE, TECH
    .NONE, nil,
    nil,
    nil,
    4,
    "fefe","images/inventoryimages/healingpill.xml")
--Recipe desc
STRINGS.RECIPE_DESC.PILLOW = "我之慰藉"
STRINGS.RECIPE_DESC.ICEPILLOW = "我之所好"
STRINGS.RECIPE_DESC.FURRYPILLOW = "我之挚爱"
STRINGS.RECIPE_DESC.IVORYPILLOW = "我之天命"
STRINGS.RECIPE_DESC.HEALINGPILL = "专治感冒"
STRINGS.RECIPE_DESC.HEADACHEPILL = "止疼名药"
STRINGS.RECIPE_DESC.PILLCASE = "装满药片"

--Setting new random seed
--math.randomseed(os.time())
-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("fefe", "FEMALE")
