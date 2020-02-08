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
function VitalityBadge:OnUpdate(dt)
    local anim = "neutral"
    if  self.owner ~= nil and
        self.owner:HasTag("sleeping") and
        self.owner.replica.hunger ~= nil and
        self.owner.replica.hunger:GetPercent() > 0 then

        anim = "arrow_loop_decrease" 
    end

    if self.owner.components.debuffable and self.owner.components.debuffable:HasDebuff("wintersfeastbuff") then
        anim = "arrow_loop_increase"
    end

    if self.arrowdir ~= anim then
        self.arrowdir = anim
        self.hungerarrow:GetAnimState():PlayAnimation(anim, true)
    end
end

return VitalityBadge
