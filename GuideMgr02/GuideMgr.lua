GuideMgr = class("GuideMgr")

GuideMgr._guideId = nil
GuideMgr._finished = {}

function GuideMgr.checkTrigger(point, group)
    -- No point, no trigger.
    if point == nil then
        return false
    end

    -- Do not trigger a new guide when guiding.
    if GuideMgr.isGuiding() then
        return false
    end

    -- Init the candidate infos.
    local candidateInfos
    if group == nil then
        candidateInfos = GuideMgr.getAllInfos()

    elseif type(group) == "number" or type(group) == "table" then
        candidateInfos = GuideMgr.getInfosByGroup(group)
    end

    if candidateInfos == nil then
        return false
    end

    -- Filter infos by finished.
    candidateInfos = GuideMgr.getUnfinishedInfos(candidateInfos)

    -- Filter infos by trigger point.
    candidateInfos = GuideMgr.getPointValidInfos(point, candidateInfos)

    -- Filter infos by trigger condition.
    candidateInfos = GuideMgr.getConditionValidInfos(candidateInfos)

    -- Check candidate infos empty.
    if #candidateInfos == 0 then
        return false
    end

    -- Sort by priority and group id.
    table.sort(candidateInfos, function(ele1, ele2)
        if ele1._priority == ele2._priority then
            return ele1._groupId < ele2._groupId
        else
            return ele1._priority > ele2._priority
        end
    end)

    -- Start guide first step.
    local info = candidateInfos[1]
    local triggerGroupId = info._groupId
    local guideId = triggerGroupId * 100 + 1
    GuideMgr.start(guideId)
    return true
end

function GuideMgr.isGuiding()
    return GuideMgr._guideId and GuideMgr._guideId > 0
end

function GuideMgr.getAllInfos()
    -- Get all infos in GuideTrigger.csv.
    -- Return the array.
end

function GuideMgr.getInfosByGroup()
    -- Get target infos in GuideTrigger.csv by _groupId.
    -- Return the array.
end

function GuideMgr.getUnfinishedInfos(infos)
    if infos == nil then
        return
    end

    local ret = {}
    for i = 1, #infos do
        local info = infos[i]
        if not GuideMgr.isFinished(info._groupId) then
            ret[#ret + 1] = info
        end
    end
    return ret
end

function GuideMgr.isFinished(groupId)
    return GuideMgr._finished[groupId] == true
end

function GuideMgr.getPointValidInfos(point, infos)
    local ret = {}
    for i = 1, #infos do
        local info = infos[i]
        if GuideMgr.isTriggerPointValid(info, point) then
            ret[#ret + 1] = info
        end
    end
    return ret
end

function GuideMgr.isTriggerPointValid(info, point)
    local param

    -- Parse param.
    if type(point) == "table" then
        param = point._param
        point = point._point
    end

    -- Different trigger point.
    if info._point ~= point then
        return false
    end

    -- Special handling.
    if point == GuideMgr.Point.enter_scene then
        -- Compare with the info in GuideTrigger.csv.
        local sceneName = info._pointParam.scene
        return Data.SceneId[sceneName] == param._sceneId

    else
        -- More point param check.
        -- ...
    end

    return true
end

function GuideMgr.getConditionValidInfos(infos)
    local ret = {}
    for i = 1, #infos do
        local isValid = true
        local info = infos[i]
        -- Array already parsed.
        local conds = info._conds
        -- Parse param array.
        local params = string.split(info._params, "|")

        for j = 1, #conds do
            if not GuideMgr.isConditionValid(conds[j], params[j]) then
                isValid = false
                break
            end
        end

        if isValid then
            ret[#ret + 1] = info
        end
    end
    return ret
end

function GuideMgr.isConditionValid(condition, param)
    if condition == GuideMgr.Cond.current_scene then
        -- Get current scene
        local scene = ...
        return Data.SceneId[param.scene] == scene._sceneId

    elseif condition == GuideMgr.Cond.hero_by_num_level then
        -- ...
    end

    return false
end

function GuideMgr.start(guideId)
    guideId = guideId or M._guideId

    if guideId == nil then
        return false
    end

    -- Check guide info validation.
    local info = GuideMgr.getInfo(guideId)
    if info == nil then
        -- Guide info not exists.
        GuideMgr.finish()
        return false
    end

    -- Set guide id.
    GuideMgr._guideId = guideId

    -- Set view
    GuideMgr.setView(info)
    return true
end

function GuideMgr.next()
    -- Check current step info validation.
    local info = GuideMgr.getInfo()
    if info == nil then
        GuideMgr.finish()
        return false
    end

    -- Check saving guide id.
    GuideMgr.checkSave(info)

    -- Next guide step id.
    local guideId = M._guideId + 1
    return GuideMgr.start(guideId)
end

function GuideMgr.checkSave(info)
    if info == nil then
        return false
    end

    local saveId = info._saveId
    if saveId > 0 then
        saveId = info._id + saveId
        -- Save the id to the server.
        GuideMgr.saveGuideId(saveId)
    end
end

function GuideMgr.getInfo(guideId)
    guideId = guideId or M._guideId
    if guideId == nil then
        return
    end

    -- Get info in GuideStep.csv by _id.
    -- ...

end

function GuideMgr.finish()
    -- Guide is not started.
    if not GuideMgr.isGuiding() then
        return false
    end

    --[[ Reset data ]]--
    -- Save guide group.
    local guideId = GuideMgr._guideId
    local groupId = math.floor(guideId / 100)
    GuideMgr.saveGuideGroup(groupId)

    -- Reset guide id.
    GuideMgr.saveGuideId(0)
    GuideMgr._guideId = 0

    --[[ Remove view ]]--
    GuideMgr.removeView()
    return true
end

function GuideMgr.saveGuideId(guideId)
    -- Save guide id to the server.
end

function GuideMgr.saveGuideGroup(groupId)
    -- Save guide group to the server.
end