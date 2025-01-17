local assets =
{
    Asset("ANIM", "anim/spider_gland_salve.zip"),

    Asset("ATLAS", "images/inventoryimages/headachepill.xml"),
    Asset("IMAGE", "images/inventoryimages/headachepill.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spider_gland_salve")
    inst.AnimState:SetBuild("spider_gland_salve")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("headachepill")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 30
    inst.components.fuel.fueltype = FUELTYPE.MEDICINE

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/headachepill.xml"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 100

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("headachepill", fn, assets)