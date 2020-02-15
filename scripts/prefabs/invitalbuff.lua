local function Yawn(target, grogginess, knockoutduration)
    target.yawntask = nil
    target.components.vitality:DoDelta(TUNING.VITALITY_YAWN)
    target:PushEvent("yawn", { grogginess = grogginess, knockoutduration = knockoutduration })
end

local function OnTick(inst, target)

    if target.components.vitality ~= nil and
            not target.components.health:IsDead() and
            not target:HasTag("playerghost") then
        local current_vitality = target.current_vitality:value()    --this field is required for any inst with the
        -- vitality
        -- component
        local vitalitymult = math.max(1, math.min(9,(current_vitality - 15) / 5))
        local knockoutduration = math.max(0,(20 - current_vitality) / 2)
    local grogginess = math.max(0, (50 - current_vitality) / 10 )

        if target.yawntask == nil then
            target.yawntask = target:DoTaskInTime(math.random() * TUNING.FEFE_YAWN_INTERVAL_RANDOM * vitalitymult,
                Yawn, grogginess, knockoutduration)
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(TUNING.FEFE_YAWN_INTERVAL_FIXED, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "invitalover" then
        inst.components.debuff:Extend ()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("invitalover")
    inst.components.timer:StartTimer("invitalover", 10000)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(TUNING.FEFE_YAWN_INTERVAL_FIXED, OnTick, nil, target)
end

local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    math.randomseed(os.time())

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("invitalover", 10000)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("invitalbuff", fn)
