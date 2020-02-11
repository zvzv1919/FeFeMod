--
-- Created by IntelliJ IDEA.
-- User: davejoey
-- Date: 2020-02-09
-- Time: 14:45
-- To change this template use File | Settings | File Templates.


local assets =
{
    Asset("ANIM", "anim/furrypillow.zip"),
    Asset("ANIM", "anim/swap_furrypillow.zip"),

    Asset("ATLAS", "images/inventoryimages/furrypillow.xml"),
    Asset("IMAGE", "images/inventoryimages/furrypillow.tex"),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_furrypillow", "furrypillow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
    --inst: this prefab(not its components.weapon)
    --attacker: the one holding this weapon
    --target: the one being attacked
    if target ~= nil and target:IsValid() then

        --impact sounds normally play through comabt component on the target
        --whip has additional impact sounds logic, which we'll just add here

        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound("dontstarve/common/whip_large")
        end
        --combat:DoAreaAttack
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 4, { "_combat" }, nil)
        local weapon = inst.components.weapon
        for i, ent in ipairs(ents) do
            if ent ~= target and
                    ent ~= attacker and
                    attacker.components.combat:IsValidTarget(ent) then
                attacker:PushEvent("onareaattackother", { target = ent, weapon = inst, stimuli = weapon.stimuli })
                ent.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(ent, inst,
                    1), inst, weapon.stimuli)
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("furrypillow")
    inst.AnimState:SetBuild("furrypillow")
    inst.AnimState:PlayAnimation("idle")

    --add tag furrypillow
    inst:AddTag("pillow")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20)
    inst.components.weapon:SetRange(2 * TUNING.WHIP_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/furrypillow.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/furrypillow", fn, assets, prefabs)

