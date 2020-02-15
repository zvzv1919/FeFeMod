local easing = require("easing")
local SourceModifierList = require("util/sourcemodifierlist")

local function onmaxvitality(self, max)
    self.inst.max_vitality:set(max)
end

local function oncurrentvitality(self, current)
    self.inst.current_vitality:set(current)
end

--
local function onratescale(self, ratescale)
    self.inst.ratescale_vitality:set(ratescale)
end


--local function onmode(self, mode)
--    self.inst.vitality:SetVitalityMode(mode)
--end

--local function onvital(self, vital)
--    self.inst.vitality:SetIsVital(not self.inducedinvitality and vital)
--end
--
--local function oninducedinvitality(self, inducedinvitality)
--    self.inst.vitality:SetIsVital(not inducedinvitality and self.vital)
--    self.inst.vitality:SetCurrent(inducedinvitality and 0 or self.currentvitality)
--end
--
--local function onpenalty(self, penalty)
--    self.inst.vitality:SetPenalty(penalty)
--end
--
--local function onghostdrainmult(self, ghostdrainmult)
--    self.inst.vitality:SetGhostDrainMult(ghostdrainmult)
--end

--local function OnChangeArea(inst, area)
--    local area_vitality_mode = area ~= nil and area.tags and table.contains(area.tags, "lunacyarea") and
--            VITALITY_MODE_LUNACY
--            or VITALITY_MODE_INVITALITY
--    inst.components.vitality:SetVitalityMode(area_vitality_mode)
--end

local Vitality = Class(function(self, inst)
    self.inst = inst
    self.maxvitality = 199
    self.currentvitality = self.maxvitality

    --    self.mode = VITALITY_MODE_INVITALITY

    self.rate = 0
    self.ratescale = RATE_SCALE.NEUTRAL
    self.rate_modifier = 1
    --    self.vital = true

    self.fxtime = 0
    self.dapperness = 0
    self.externalmodifiers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.inducedinvitality = nil
    self.inducedinvitality_sources = nil
    self.night_drain_mult = 1
    --    self.neg_aura_mult = 1
    --    self.neg_aura_absorb = 0
    --    self.dapperness_mult = 1

    self.penalty = 0

    self.vitality_penalties = {}

    self.ghost_drain_mult = 0

    self.custom_rate_fn = nil

    --    self._oldisvital = self:IsVital()
    self._oldpercent = self:GetPercent()

    self.inst:StartUpdatingComponent(self)
    --    self:RecalcGhostDrain()

    --    self.inst:ListenForEvent("changearea", OnChangeArea)
end,
    nil,
    {
        maxvitality = onmaxvitality,
        currentvitality = oncurrentvitality,
        ratescale = onratescale
    })
--end,
--    nil,
--    {
--        max = onmax,
--        current = oncurrent,
--        ratescale = onratescale,
--        mode = onmode,
--        vital = onvital,
--        inducedinvitality = oninducedinvitality,
--        penalty = onpenalty,
--        ghost_drain_mult = onghostdrainmult,
--    })

--function Vitality:IsVital()
--    return (self.mode == VITALITY_MODE_INVITALITY and (not self.inducedinvitality and self.vital))
--            or (self.mode == VITALITY_MODE_LUNACY and (self.inducedinvitality or self.vital))
--end
--
--function Vitality:IsInvital()
--    return self.mode == VITALITY_MODE_INVITALITY and (self.inducedinvitality or not self.vital)
--end
--
--function Vitality:IsEnlightened()
--    return self.mode == VITALITY_MODE_LUNACY and (not self.inducedinvitality and not self.vital)
--end
--
--function Vitality:IsCrazy()
--    -- deprecated
--    return self:IsInvital()
--end

--function Vitality:SetVitalityMode(mode)
--    if self.mode ~= mode then
--        self.mode = mode
--        self.inst:PushEvent("vitalitymodechanged", {mode = self.mode})
--        self:DoDelta(0)
--    end
--end

--function Vitality:IsInvitalityMode()
--    return self.mode == VITALITY_MODE_INVITALITY
--end
--
--function Vitality:IsLunacyMode()
--    return self.mode == VITALITY_MODE_LUNACY
--end
--
--function Vitality:GetVitalityMode()
--    return self.mode
--end


function Vitality:AddVitalityPenalty(key, mod)
    self.vitality_penalties[key] = mod
    self:RecalculatePenalty()
end

function Vitality:RemoveVitalityPenalty(key)
    self.vitality_penalties[key] = nil
    self:RecalculatePenalty()
end

function Vitality:RecalculatePenalty()
    local penalty = 0

    for k, v in pairs(self.vitality_penalties) do
        penalty = penalty + v
    end

    penalty = math.max(penalty, -self.maxvitality)

    self.penalty = penalty

    self:DoDelta(0)
end

function Vitality:OnSave()
    return
    {
        current = self.currentvitality,
        max = self.maxvitality
        --        vital = self.vital,
        --        mode = self.mode,
    }
end

function Vitality:OnLoad(data)
    --    if data.vital ~= nil then
    --        self.vital = data.vital
    --    end

    --    self.mode = data.mode or 0

    if data.current ~= nil then
        self.currentvitality = data.current
        self:DoDelta(0)
    end
    if data.max ~= nil then
        self.maxvitality = data.max
        self:DoDelta(0)
    end
end

function Vitality:GetPenaltyPercent()
    return self.penalty
end

function Vitality:GetPercent()
    return self.currentvitality / self.maxvitality
end

function Vitality:GetPercentWithPenalty()
    return self.currentvitality / (self.maxvitality - (self.maxvitality * self.penalty))
end

function Vitality:SetPercent(per, overtime)
    local target = per * self.maxvitality
    local delta = target - self.currentvitality
    self:DoDelta(delta, overtime)
end

function Vitality:GetDebugString()
    return string.format("%2.2f / %2.2f at %2.4f. Penalty %2.2f", self.currentvitality, self.maxvitality, self.rate,
        self.penalty)
end

function Vitality:SetMax(amount)
    self.maxvitality = amount
    self.currentvitality = amount
    self:DoDelta(0)
end

function Vitality:GetMaxWithPenalty()
    return self.maxvitality - (self.maxvitality * self.penalty)
end

function Vitality:GetRateScale()
    return self.ratescale
end

function Vitality:Max()
    return self.maxvitality
end

--function Vitality:SetInducedInvitality(src, val)
--    if val then
--        if self.inducedinvitality_sources == nil then
--            self.inducedinvitality_sources = { [src] = true }
--        else
--            self.inducedinvitality_sources[src] = true
--        end
--    elseif self.inducedinvitality_sources ~= nil then
--        self.inducedinvitality_sources[src] = nil
--        if next(self.inducedinvitality_sources) == nil then
--            self.inducedinvitality_sources = nil
--            val = nil
--        else
--            val = true
--        end
--    end
--    if self.inducedinvitality ~= val then
--        self.inducedinvitality = val
--        self:DoDelta(0)
--        self.inst:PushEvent("inducedinvitality", val)
--    end
--end

function Vitality:DoDelta(delta, overtime)
    if self.redirect ~= nil then
        self.redirect(self.inst, delta, overtime)
        return
    end

    if self.ignore then
        return
    end

    self.currentvitality = math.min(math.max(self.currentvitality + delta, 0), self.maxvitality - self.maxvitality * self.penalty)

    -- must calculate it due to inducedinvitality ...
    --    local percent_ignoresinduced = self.currentvitality / self.maxvitality
    --    if self.mode == VITALITY_MODE_INVITALITY then
    --        if self.vital and percent_ignoresinduced <= TUNING.VITALITY_BECOME_INVITAL_THRESH then --30
    --            self.vital = false
    --        elseif not self.vital and percent_ignoresinduced >= TUNING.VITALITY_BECOME_VITAL_THRESH then --35
    --            self.vital = true
    --        end
    --    else
    --        if self.vital and percent_ignoresinduced >= TUNING.VITALITY_BECOME_ENLIGHTENED_THRESH then
    --            self.vital = false
    --        elseif not self.vital and percent_ignoresinduced <= TUNING.VITALITY_LOSE_ENLIGHTENMENT_THRESH then
    --            self.vital = true
    --        end
    --    end

    self.inst:PushEvent("vitalitydelta", {
        oldpercent = self._oldpercent,
        newpercent = self:GetPercent(),
        overtime =
        overtime,
        vitalitymode = self.mode
    })
    self._oldpercent = self:GetPercent()

    --    if self:IsVital() ~= self._oldisvital then
    --        self._oldisvital = self:IsVital()
    --        if self._oldisvital then
    --            if self.onVital ~= nil then
    --                self.onVital(self.inst)
    --            end
    --            self.inst:PushEvent("govital")
    --            ProfileStatsSet("went_vital", true)
    --        else
    --            if self.mode == VITALITY_MODE_INVITALITY then
    --                if self.onInvital ~= nil then
    --                    self.onInvital(self.inst)
    --                end
    --                self.inst:PushEvent("goinvital")
    --                ProfileStatsSet("went_invital", true)
    --            else --self.mode == VITALITY_MODE_LUNACY
    --                if self.onEnlightened ~= nil then
    --                    self.onEnlightened(self.inst)
    --                end
    --                self.inst:PushEvent("goenlightened")
    --                ProfileStatsSet("went_enlightened", true)
    --            end
    --        end
    --    end
end

function Vitality:OnUpdate(dt)
    if not ((self.inst.components.health.invincible and self.inst.sleepingbag == nil) or --updates in sleepingbag
            self.inst.is_teleporting or
            (self.ignore and self.redirect == nil)) then
        self:Recalc(dt)
    else
        --Always want to update badge
        --        self:RecalcGhostDrain()

        --Disable arrows
        self.rate = 0
        self.ratescale = RATE_SCALE.NEUTRAL
    end
end

--function Vitality:RecalcGhostDrain()
--    if GetGhostVitalityDrain(TheNet:GetServerGameMode()) then
--        local num_ghosts = TheWorld.shard.components.shard_players:GetNumGhosts()
--        local num_alive = TheWorld.shard.components.shard_players:GetNumAlive()
--        local group_resist = num_alive > num_ghosts and 1 - num_ghosts / num_alive or 0
--
--        self.ghost_drain_mult = math.min(num_ghosts, TUNING.MAX_VITALITY_GHOST_PLAYER_DRAIN_MULT) * (1 - group_resist *
--                group_resist)
--    else
--        self.ghost_drain_mult = 0
--    end
--end

local DAILY_VITALITY_DRAINS =
{
    DAY = 1,
    DUSK = -2,
    NIGHT = 3,
    CAVE = -4,
}

function Vitality:Recalc(dt)
    --    local total_dapperness = self.dapperness
    --    for k, v in pairs(self.inst.components.inventory.equipslots) do
    --        if v.components.equippable ~= nil then
    --            total_dapperness = total_dapperness + v.components.equippable:GetDapperness(self.inst)
    --        end
    --    end
    --
    --    total_dapperness = total_dapperness * self.dapperness_mult
    --
    --    local dapper_delta = total_dapperness * TUNING.VITALITY_DAPPERNESS

    local daily_vitality_drain = DAILY_VITALITY_DRAINS
    local daily_delta
    local sleep_delta

    if TheWorld:HasTag("cave") then
        daily_delta = daily_vitality_drain.CAVE
    else
        daily_delta = daily_vitality_drain.DAY
        if TheWorld.state.isnight then
            daily_delta = daily_vitality_drain.NIGHT
        end
        if TheWorld.state.isdusk then
            daily_delta = daily_vitality_drain.DUSK
        end
    end
    if self.inst.sg:HasStateTag("sleeping") or self.inst.sleepingbag ~= nil then
        sleep_delta = 10
    else
        sleep_delta = 0
    end
    --    local aura_delta = 0
    --    local x, y, z = self.inst.Transform:GetWorldPosition()
    --    local ents = TheSim:FindEntities(x, y, z, TUNING.VITALITY_AURA_SEACH_RANGE, { "vitalityaura" }, { "FX", "NOCLICK",
    --        "DECOR","INLIMBO" })
    --    for i, v in ipairs(ents) do
    --        if v.components.vitalityaura ~= nil and v ~= self.inst then
    --            local aura_val = v.components.vitalityaura:GetAura(self.inst)
    --            aura_delta = aura_delta + (aura_val < 0 and (self.neg_aura_absorb > 0 and self.neg_aura_absorb * -aura_val or aura_val) * self.neg_aura_mult or aura_val)
    --        end
    --    end

    --    local mount = self.inst.components.rider:IsRiding() and self.inst.components.rider:GetMount() or nil
    --    if mount ~= nil and mount.components.vitalityaura ~= nil then
    --        local aura_val = mount.components.vitalityaura:GetAura(self.inst)
    --        aura_delta = aura_delta + (aura_val < 0 and (self.neg_aura_absorb > 0 and self.neg_aura_absorb * -aura_val or aura_val) * self.neg_aura_mult or aura_val)
    --    end

    --    self:RecalcGhostDrain()
    --    local ghost_delta = TUNING.VITALITY_GHOST_PLAYER_DRAIN * self.ghost_drain_mult

    --    self.rate = dapper_delta + moisture_delta + daily_delta + aura_delta + ghost_delta + self.externalmodifiers:Get()
    self.rate = daily_delta + sleep_delta

    if self.custom_rate_fn ~= nil then
        --NOTE: dt param was added for wormwood's custom rate function
        --      dt shouldn't have been applied to the return value yet
        self.rate = self.rate + self.custom_rate_fn(self.inst, dt)
    end

    self.rate = self.rate * self.rate_modifier
    self.ratescale =
    (self.rate > .2 and RATE_SCALE.INCREASE_HIGH) or
            (self.rate > .1 and RATE_SCALE.INCREASE_MED) or
            (self.rate > .01 and RATE_SCALE.INCREASE_LOW) or
            (self.rate < -.3 and RATE_SCALE.DECREASE_HIGH) or
            (self.rate < -.1 and RATE_SCALE.DECREASE_MED) or
            (self.rate < -.02 and RATE_SCALE.DECREASE_LOW) or
            RATE_SCALE.NEUTRAL

    --print (string.format("dapper: %2.2f light: %2.2f TOTAL: %2.2f", dapper_delta, daily_delta, self.rate*dt))
    self:DoDelta(self.rate * dt, true)
end

Vitality.LongUpdate = Vitality.OnUpdate

return Vitality
