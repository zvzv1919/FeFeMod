--
-- Created by IntelliJ IDEA.
-- User: davejoey
-- Date: 2020-02-09
-- Time: 14:45
-- To change this template use File | Settings | File Templates.


local assets =
{
    Asset("ANIM", "anim/pillow.zip"),
    Asset("ANIM", "anim/swap_pillow.zip"),

    Asset("ATLAS", "images/inventoryimages/pillow.xml"),
    Asset("IMAGE", "images/inventoryimages/pillow.tex"),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_pillow", "pillow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function onattack(inst, attacker, target)
    --inst: this prefab(not its components.weapon)
    --attacker: the one holding this weapon
    --target: the one being attacked
    local weapon = inst.components.weapon
    local procsleep = (weapon.sleepifyrate ~= nil and math.random()<weapon.sleepifyrate)
    if target ~= nil and target:IsValid() then
        attacker:PushEvent("onattackother", { target = target, weapon = inst, stimuli = weapon.stimuli, procsleep =
        procsleep })
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pillow")
    inst.AnimState:SetBuild("pillow")
    inst.AnimState:PlayAnimation("idle")

    --add tag pillow
    inst:AddTag("pillow")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.PILLOW_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon.sleepifyrate = TUNING.PILLOW_SLEEPIFYRATE

    -------
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.PILLOW_INSULATION)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.PILLOW_USES)
    inst.components.finiteuses:SetUses(TUNING.PILLOW_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pillow.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/pillow", fn, assets, prefabs)

