--
-- Created by IntelliJ IDEA.
-- User: davejoey
-- Date: 2020-02-09
-- Time: 14:45
-- To change this template use File | Settings | File Templates.


local assets =
{
    Asset("ANIM", "anim/pillcase.zip"),

    Asset("ATLAS", "images/inventoryimages/pillcase.xml"),
    Asset("IMAGE", "images/inventoryimages/pillcase.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "pillcase", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner)

    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function miner_perish(inst)
    local equippable = inst.components.equippable
    if equippable ~= nil and equippable:IsEquipped() then
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner ~= nil then
            local data =
            {
                prefab = inst.prefab,
                equipslot = equippable.equipslot,
            }
            miner_turnoff(inst)
            owner:PushEvent("torchranout", data)
            return
        end
    end
    miner_turnoff(inst)
end

local function miner_takefuel(inst)
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        miner_turnon(inst)
    end
end

local function miner_custom_init(inst)
    inst.entity:AddSoundEmitter()
    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pillcase")
    inst.AnimState:SetBuild("pillcase")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("pillcase")
    inst:AddTag("hat")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.PILLCASE_ARMOR, TUNING.PILLCASE_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pillcase.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/pillcase", fn, assets, prefabs)

