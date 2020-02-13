local assets =
{
    Asset("ANIM", "anim/healingpill.zip"),

    Asset("ATLAS", "images/inventoryimages/healingpill.xml"),
    Asset("IMAGE", "images/inventoryimages/healingpill.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("healingpill")
    inst.AnimState:SetBuild("healingpill")
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
    inst.components.edible.healthvalue = 100

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("healingpill", fn, assets)