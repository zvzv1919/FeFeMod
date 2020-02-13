local assets =
{
    Asset("ANIM", "anim/spider_gland_salve.zip"),

    Asset("ATLAS", "images/inventoryimages/healingpill.xml"),
    Asset("IMAGE", "images/inventoryimages/healingpill.tex"),
}

local prefabs = {"feferegenbuff"}

local oneatenfn = function(inst, eater)
    eater.components.health:DoDelta(15, nil, "healingpill")
    if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost") then
        eater.components.debuffable:AddDebuff("feferegenbuff", "feferegenbuff")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank("spider_gland_salve")
    inst.AnimState:SetBuild("spider_gland_salve")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/healingpill.xml"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = -5
    inst.components.edible.sanityvalue = -30
    inst.components.edible.oneaten = oneatenfn

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("healingpill", fn, assets, prefabs)