--
-- Created by IntelliJ IDEA.
-- User: davejoey
-- Date: 2020-02-09
-- Time: 14:45
-- To change this template use File | Settings | File Templates.


local assets =
{
    Asset("ANIM", "anim/ivorypillow.zip"),
    Asset("ANIM", "anim/swap_ivorypillow.zip"),

    Asset("ATLAS", "images/inventoryimages/ivorypillow.xml"),
    Asset("IMAGE", "images/inventoryimages/ivorypillow.tex"),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_ivorypillow", "ivorypillow")
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
    if target ~= nil and target:IsValid() then

        --impact sounds normally play through comabt component on the target
        --whip has additional impact sounds logic, which we'll just add here

        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound("dontstarve/common/whip_large")
        end
        --combat:DoAreaAttack
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.IVORYPILLOW_AOE, { "_combat" }, nil)
        local weapon = inst.components.weapon

        for i, ent in ipairs(ents) do
            local procsleep = (weapon.sleepifyrate ~= nil and math.random() < weapon.sleepifyrate)
            local procfreeze = (weapon.freezerate ~= nil and math.random() < weapon.freezerate)


            if ent ~= attacker and
                attacker.components.combat:IsValidTarget(ent) then

                if ent ~= target then
                    ent.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(ent, inst,
                        TUNING.IVORYPILLOW_AOE_DMGMULT), inst, weapon.stimuli)
                end
                attacker:PushEvent("onareaattackother", {
                    target = ent,
                    weapon = inst,
                    stimuli = weapon.stimuli,
                    procsleep = procsleep,
                    sleepiness = TUNING.IVORYPILLOW_SLEEPINESS
                })
            end

            if ent.components.freezable ~= nil and procfreeze and ent ~= attacker and attacker.components.combat:IsValidTarget(ent) then
                if ent.components.burnable ~= nil then
                    if ent.components.burnable:IsBurning() then
                        ent.components.burnable:Extinguish()
                    elseif ent.components.burnable:IsSmoldering() then
                        ent.components.burnable:SmotherSmolder()
                    end
                end

                if attacker.components.talker ~= nil then
                    attacker.components.talker:Say("冰死你")
                end
                ent.components.freezable:AddColdness(TUNING.IVORYPILLOW_COLDNESS)
                ent.components.freezable:SpawnShatterFX()
                --            if target.components.freezable:IsFrozen() then
                --                target.components.freezable:Unfreeze()
                --            end
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

    inst.AnimState:SetBank("ivorypillow")
    inst.AnimState:SetBuild("ivorypillow")
    inst.AnimState:PlayAnimation("idle")

    --add tag ivorypillow
    inst:AddTag("pillow")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.IVORYPILLOW_DAMAGE)
    inst.components.weapon:SetRange(TUNING.IVORYPILLOW_HITRANGE)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon.sleepifyrate = TUNING.IVORYPILLOW_SLEEPIFYRATE
    inst.components.weapon.freezerate = TUNING.IVORYPILLOW_FREEZERATE

    -------

    --    inst:AddComponent("finiteuses")
    --    inst.components.finiteuses:SetMaxUses(200)
    --    inst.components.finiteuses:SetUses(200)
    --    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.IVORYPILLOW_INSULATION)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.IVORYPILLOW_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ivorypillow.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/ivorypillow", fn, assets, prefabs)

