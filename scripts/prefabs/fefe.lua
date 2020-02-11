local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- Custom starting inventory
local start_inv = {
    "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes",
    "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes",
    "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes",
    "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes",
    "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes",
    "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes", "mashedpotatoes",
    "mashedpotatoes", "mashedpotatoes",
    "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "green_cap", "torch", "torch", "flint",
    "flint",
    "twigs",
    "twigs", "panflute", "spear", "spidereggsack", "spidereggsack", "spidereggsack", "spidereggsack",
    "spidereggsack", "spidereggsack", "pillow"
}

local POWER_QUOTE = {
    "fefe之力！",
    "让你再睡会儿",
    "让你再睡会儿",
    "???"
}

-- When the character is revived from human
local function onbecamehuman(inst)
    -- Set speed when not a ghost (optional)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "fefe_speed_mod", 1)
end

local function onbecameghost(inst)
    -- Remove speed modifier when becoming a ghost
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "fefe_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function GetVitality(inst)
    if inst.components.vitality ~= nil then
        return inst.components.vitality:GetPercent()
        --    elseif inst.player_classified ~= nil then
        --        return inst.player_classified.currentwereness:value() * .01
    elseif inst.player_classified ~= nil then

        return 0.3
    else
        return 0.1
        --        return inst.components.vitality:GetPercent()
    end
end

local function GetMaxVitality(inst)
    if inst.components.vitality ~= nil then
        return inst.components.vitality:Max()
    end
    --    return inst.components.vitality:Max()
end

local function GetVitalityPenalty(inst)
    if inst.components.vitality ~= nil then
        return inst.components.vitality:GetPenaltyPercent()
    end
    --    return inst.components.vitality:GetPenaltyPercent()
end

local function IsValidVictim(victim)
    return victim ~= nil
            and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
            victim:HasTag("veggie") or
            victim:HasTag("structure") or
            victim:HasTag("wall") or
            victim:HasTag("balloon") or
            victim:HasTag("groundspike") or
            victim:HasTag("smashable") or
            victim:HasTag("companion"))
            and victim.components.health ~= nil
            and victim.components.combat ~= nil
end

local function OnPutToSleep(victim)
    victim.components.health.fefetask = nil
    local mount = victim.components.rider ~= nil and victim.components.rider:GetMount() or nil

    if mount ~= nil then
        mount:PushEvent("ridersleep", { sleepiness = 10, sleeptime = TUNING.PANFLUTE_SLEEPTIME })
    end
    if victim.components.sleeper ~= nil then
        victim.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
    elseif victim.components.grogginess ~= nil then
        victim.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
    else
        victim:PushEvent("knockedout")
    end
end

local function SayQuote(inst)
    inst.components.talker.fefetask = nil
    inst.components.talker:Say(POWER_QUOTE[math.ceil(3 * math.random())])
end

local function Sleepify(inst, data)
    local sleepChance = 1

    if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("pillow") then

        local victim = data.target

        if math.random() < sleepChance then

            if inst.components.talker.fefetask == nil then
                inst.components.talker.fefetask = inst:DoTaskInTime(0.01, SayQuote, inst)
            end

            if not inst.components.health:IsDead() and IsValidVictim(victim) then
                if victim.components.health.fefetask == nil and
                        (TheNet:GetPVPEnabled() or not victim:HasTag("player")) and
                        not (victim.components.freezable ~= nil and victim.components.freezable:IsFrozen()) and
                        not (victim.components.pinnable ~= nil and victim.components.pinnable:IsStuck()) and
                        not (victim.components.fossilizable ~= nil and victim.components.fossilizable:IsFossilized()) then
                    victim.components.health.fefetask = victim:DoTaskInTime(0.01, OnPutToSleep, victim)
                end
                inst.components.health:DoDelta(15)
                inst.components.sanity:DoDelta(10)
                inst.components.vitality:DoDelta(20)
            end
        end
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
    -- Minimap icon
    inst.MiniMapEntity:SetIcon("fefe.tex")
    inst:AddTag("vitality")
    inst:AddTag("fefe")
    --    inst:AddComponent("vitality")

    inst.max_vitality = net_shortint(inst.GUID, "max_vitality", "vitalitydirty")
    inst.current_vitality = net_shortint(inst.GUID, "current_vitality", "vitalitydirty")
    inst.ratescale_vitality = net_shortint(inst.GUID, "ratescale_vitality", "ratescalevitalitydirty")
    --    inst.GetVitality=GetVitality
    --    inst.GetMaxVitality=GetMaxVitality
    --    inst.GetVitalityPenalty=GetVitalityPenalty
end



-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
    -- choose which sounds this character will play
    inst.soundsname = "willow"
    --	inst:AddTag("vitality")

    -- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"

    -- Stats

    inst:AddComponent("vitality")

    --    inst.Light:SetRadius(2.5)
    --    inst.Light:SetFalloff(0.3)
    --    inst.Light:SetIntensity(.7)
    --    inst.Light:SetColour(235 / 255, 121 / 255, 12 / 255)
    --    inst.Light:Enable(true)
    inst.components.vitality:SetMax(520)
    inst.components.hunger:SetMax(150)
    inst.components.health:SetMaxHealth(20000)
    inst.components.sanity:SetMax(135)
    --    inst:AddComponent("vitality")

    inst:ListenForEvent("oneat", function(inst, data)
        if data.food and data.food.components.edible then
            local sanity = data.food.components.edible:GetSanity(inst)
            inst.components.vitality:DoDelta(sanity)
        end
    end)

    inst:ListenForEvent("onareaattackother", Sleepify)
    inst:ListenForEvent("onattackother", Sleepify)


    --    if inst.components.vitality ~= nil then
    --        inst.components.health:SetMaxHealth(997)
    --    else
    --        inst.components.health:SetMaxHealth(50)
    --    end

    -- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1

    -- Hunger rate (optional)
    inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("fefe", prefabs, assets, common_postinit, master_postinit, start_inv)
