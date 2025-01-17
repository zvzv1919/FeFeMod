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

local function onattack(inst, attacker, target)
    --inst: this prefab(not its components.weapon)
    --attacker: the one holding this weapon
    --target: the one being attacked
    if target ~= nil and target:IsValid() then

        --impact sounds normally play through comabt component on the target
        --whip has additional impact sounds logic, which we'll just add here

        --combat:DoAreaAttack
        local weapon = inst.components.weapon
        local procfreeze = (weapon.freezerate ~= nil and math.random() < weapon.freezerate)

        if target.components.freezable ~= nil and procfreeze then
            if target.components.burnable ~= nil then
                if target.components.burnable:IsBurning() then
                    target.components.burnable:Extinguish()
                elseif target.components.burnable:IsSmoldering() then
                    target.components.burnable:SmotherSmolder()
                end
            end

            if attacker.components.talker ~= nil then
                attacker.components.talker:Say("冰死你")
            end
            target.components.freezable:AddColdness(TUNING.ICEPILLOW_COLDNESS)
            target.components.freezable:SpawnShatterFX()
            --            if target.components.freezable:IsFrozen() then
            --                target.components.freezable:Unfreeze()
            --            end
        end
    end
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
    inst:AddTag("icepillow")
    --    inst:AddTag("show_spoilage")
    inst:AddTag("frozen")
    inst:AddTag("icebox_valid")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.ICEPILLOW_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon.freezerate = TUNING.ICEPILLOW_FREEZERATE

    -------

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.ICEPILLOW_INSULATION)
    inst.components.insulator:SetSummer()

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/icepillow.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = MATERIALS.ICE
    inst.components.repairable.announcecanfix = false

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.ICEPILLOW_PERISHTIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/icepillow", fn, assets, prefabs)

