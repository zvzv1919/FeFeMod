--
-- Created by IntelliJ IDEA.
-- User: davejoey
-- Date: 2020-02-09
-- Time: 14:45
-- To change this template use File | Settings | File Templates.


local assets =
{

    Asset("ANIM", "anim/icepillow.zip"),
    Asset("ANIM", "anim/swap_icepillow.zip"),

    Asset("ATLAS", "images/inventoryimages/icepillow.xml"),
    Asset("IMAGE", "images/inventoryimages/icepillow.tex"),



}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_icepillow", "icepillow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icepillow")
    inst.AnimState:SetBuild("icepillow")
    inst.AnimState:PlayAnimation("idle")

    --add tag icepillow
    inst:AddTag("pillow")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/icepillow.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/icepillow", fn, assets,prefabs)

