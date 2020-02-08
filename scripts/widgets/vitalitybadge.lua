local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local VitalityBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, owner, {221/255, 182/255, 3/255, 1}, "status_vitality")
    owner:ListenForEvent("vitalitydirty",function(owner, data)self:GetVitality() end)

    self.hungerarrow = self.underNumber:AddChild(UIAnim())
    self.hungerarrow:GetAnimState():SetBank("sanity_arrow")
    self.hungerarrow:GetAnimState():SetBuild("sanity_arrow")
    self.hungerarrow:GetAnimState():PlayAnimation("neutral")
    self.hungerarrow:SetClickable(false)

    self:StartUpdating()
end)

function VitalityBadge:GetVitality()
    local max_vitality = self.owner.max_vitality:value()
    local current_vitality = self.owner.current_vitality:value()
    local percent_vitality = current_vitality/max_vitality
    self:SetPercent(percent_vitality, max_vitality)
end

--TODO:change the following function(check sanitybadge)

local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}

function VitalityBadge:OnUpdate(dt)
    local current_vitality = self.owner.current_vitality:value()
    local max_vitality = self.owner.max_vitality:value()
    local anim = "neutral"

    if current_vitality ~= nil then
        local ratescale = self.owner.ratescale_vitality:value()
        if ratescale == RATE_SCALE.INCREASE_LOW or
                ratescale == RATE_SCALE.INCREASE_MED or
                ratescale == RATE_SCALE.INCREASE_HIGH then
            if current_vitality < max_vitality then
                anim = RATE_SCALE_ANIM[ratescale]
            end
        elseif ratescale == RATE_SCALE.DECREASE_LOW or
                ratescale == RATE_SCALE.DECREASE_MED or
                ratescale == RATE_SCALE.DECREASE_HIGH then
            if current_vitality > 0 then
                anim = RATE_SCALE_ANIM[ratescale]
            end
        end
    end

    if self.arrowdir ~= anim then
        self.arrowdir = anim
        self.hungerarrow:GetAnimState():PlayAnimation(anim, true)
    end
end

return VitalityBadge
