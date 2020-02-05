local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local VitalityBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, owner, { 0 / 255, 0 / 255, 0 / 255, 1 }, "status_vitality")

    self.hungerarrow = self.underNumber:AddChild(UIAnim())
    self.hungerarrow:GetAnimState():SetBank("sanity_arrow")
    self.hungerarrow:GetAnimState():SetBuild("sanity_arrow")
    self.hungerarrow:GetAnimState():PlayAnimation("neutral")
    self.hungerarrow:SetClickable(false)

    self:StartUpdating()
end)

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
