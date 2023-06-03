local isTrace = false
local level = 4
if isTrace then
    level = 6
end

local randomLog = utils.logger:new(level)

if frontLineManager then
    randomLog:info("Script was loaded via loader. Skipping..")
    return
end

local redFrontLinesGroups = {
    "RedFrontlineGround-1",
    "RedFrontlineGround-2",
    "RedFrontlineGround-3",
    "RedFrontlineGround-4",
    "RedFrontlineGround-5",
}

local groupFlags = {}
groupFlags["RedFrontlineGround-1"] = 11
groupFlags["RedFrontlineGround-2"] = 12
groupFlags["RedFrontlineGround-3"] = 13
groupFlags["RedFrontlineGround-4"] = 14
groupFlags["RedFrontlineGround-5"] = 15
groupFlags["BlueFrontlineGround-1"] = 21
groupFlags["BlueFrontlineGround-2"] = 22
groupFlags["BlueFrontlineGround-3"] = 23
groupFlags["BlueFrontlineGround-4"] = 24
groupFlags["BlueFrontlineGround-5"] = 25
groupFlags["RedArtileryGroup"] = 16
groupFlags["BlueArtileryGroup"] = 26

local redArtilleryGroups = {
    "RedArtileryGroup",
}

local blueFrontLinesGroups = {
    "BlueFrontlineGround-1",
    "BlueFrontlineGround-2",
    "BlueFrontlineGround-3",
    "BlueFrontlineGround-4",
    "BlueFrontlineGround-5",
}

local blueArtilleryGroups = {
    "BlueArtileryGroup",
}

local zonePools = {
    [1] = { "RedRetreat" },
    [2] = { "Zone1_A", "Zone1_B", "Zone1_C", "Zone1_D", "Zone1_E", "Zone1_F", "Zone1_G", "Zone1_H", "Zone1_I", "Zone1_J", "Zone1_K", "Zone1_L" },
    [3] = { "Zone2_A", "Zone2_B", "Zone2_C", "Zone2_D", "Zone2_E", "Zone2_F", "Zone2_G", "Zone2_H", "Zone2_I", "Zone2_J", "Zone2_K", "Zone2_L" },
    [4] = { "Zone3_A", "Zone3_B", "Zone3_C", "Zone3_D", "Zone3_E", "Zone3_F", "Zone3_G", "Zone3_H", "Zone3_I", "Zone3_J", "Zone3_K", "Zone3_L" },
    [5] = { "Zone4_A", "Zone4_B", "Zone4_C", "Zone4_D", "Zone4_E", "Zone4_F", "Zone4_G", "Zone4_H", "Zone4_I", "Zone4_J", "Zone4_K", "Zone4_L" },
    [6] = { "Zone5_A", "Zone5_B", "Zone5_C", "Zone5_D", "Zone5_E", "Zone5_F", "Zone5_G", "Zone5_H", "Zone5_I", "Zone5_J", "Zone5_K", "Zone5_L" },
    [7] = { "Zone6_A", "Zone6_B", "Zone6_C", "Zone6_D", "Zone6_E", "Zone6_F", "Zone6_G", "Zone6_H", "Zone6_I", "Zone6_J", "Zone6_K", "Zone6_L" },
    [8] = { "Zone7_A", "Zone7_B", "Zone7_C", "Zone7_D", "Zone7_E", "Zone7_F", "Zone7_G", "Zone7_H", "Zone7_I", "Zone7_J", "Zone7_K", "Zone7_L" },
    [9] = { "Zone8_A", "Zone8_B", "Zone8_C", "Zone8_D", "Zone8_E", "Zone8_F", "Zone8_G", "Zone8_H", "Zone8_I", "Zone8_J", "Zone8_K", "Zone8_L" },
    [10] = { "Zone9_A", "Zone9_B", "Zone9_C", "Zone9_D", "Zone9_E", "Zone9_F", "Zone9_G", "Zone9_H", "Zone9_I", "Zone9_J", "Zone9_K", "Zone9_L" },
    [11] = { "Zone10_A", "Zone10_B", "Zone10_C", "Zone10_D", "Zone10_E", "Zone10_F", "Zone10_G", "Zone10_H", "Zone10_I", "Zone10_J", "Zone10_K", "Zone10_L" },
    [12] = { "Zone11_A", "Zone11_B", "Zone11_C", "Zone11_D", "Zone11_E", "Zone11_F", "Zone11_G", "Zone11_H", "Zone11_I", "Zone11_J", "Zone11_K", "Zone11_L" },
    [13] = { "Zone12_A", "Zone12_B", "Zone12_C", "Zone12_D", "Zone12_E", "Zone12_F", "Zone12_G", "Zone12_H", "Zone12_I", "Zone12_J", "Zone12_K", "Zone12_L" },
    [14] = { "Zone13_A", "Zone13_B", "Zone13_C", "Zone13_D", "Zone13_E", "Zone13_F", "Zone13_G", "Zone13_H", "Zone13_I", "Zone13_J", "Zone13_K", "Zone13_L" },
    [15] = { "Zone14_A", "Zone14_B", "Zone14_C", "Zone14_D", "Zone14_E", "Zone14_F", "Zone14_G", "Zone14_H", "Zone14_I", "Zone14_J", "Zone14_K", "Zone14_L" },
    [16] = { "Zone15_A", "Zone15_B", "Zone15_C", "Zone15_D", "Zone15_E", "Zone15_F", "Zone15_G", "Zone15_H", "Zone15_I", "Zone15_J", "Zone15_K", "Zone15_L" },
    [17] = { "Zone16_A", "Zone16_B", "Zone16_C", "Zone16_D", "Zone16_E", "Zone16_F", "Zone16_G", "Zone16_H", "Zone16_I", "Zone16_J", "Zone16_K", "Zone16_L" },
    [18] = { "Zone17_A", "Zone17_B", "Zone17_C", "Zone17_D", "Zone17_E", "Zone17_F", "Zone17_G", "Zone17_H", "Zone17_I", "Zone17_J", "Zone17_K", "Zone17_L" },
    [19] = { "Zone18_A", "Zone18_B", "Zone18_C", "Zone18_D", "Zone18_E", "Zone18_F", "Zone18_G", "Zone18_H", "Zone18_I", "Zone18_J", "Zone18_K", "Zone18_L" },
    [20] = { "Zone19_A", "Zone19_B", "Zone19_C", "Zone19_D", "Zone19_E", "Zone19_F", "Zone19_G", "Zone19_H", "Zone19_I", "Zone19_J", "Zone19_K", "Zone19_L" },
    [21] = { "Zone20_A", "Zone20_B", "Zone20_C", "Zone20_D", "Zone20_E", "Zone20_F", "Zone20_G", "Zone20_H", "Zone20_I", "Zone20_J", "Zone20_K", "Zone20_L" }
}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function has_string_value (tab, val)
    for index, value in pairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function countTableSize(table)
    local n = 0
    for k, v in pairs(table) do
        n = n + 1
    end
    return n
end

randomLog:info("Initializing frontlines")

_DATABASE_CIRCLES = {}
_DATABASE_SPAWNS = {}
_ACTIVE_FRONT_LINES_GROUP_RED = {}
_ACTIVE_FRONT_LINES_GROUP_BLUE = {}

frontLineManager = {}
function frontLineManager.clearCircles(groupName)
    randomLog:trace("Clear circles to frontLine for group " .. groupName)

    if _DATABASE_CIRCLES[groupName] then
        randomLog:info("Removing marker id " .. _DATABASE_CIRCLES[groupName] .. " - group " .. groupName)
        trigger.action.removeMark(_DATABASE_CIRCLES[groupName])
        _DATABASE_CIRCLES[groupName] = nil
    end
end

function frontLineManager.clearAllFrontCircles()
    randomLog:trace("Clear circles for whole frontline")

    for k, v in pairs(_DATABASE_CIRCLES) do
        randomLog:info("Removing marker id " .. v .. " - group " .. k)
        trigger.action.removeMark(v)
    end

    _DATABASE_CIRCLES = {}
    _DATABASE_SPAWNS = {}
end

function frontLineManager.pushedFront(coalition)
    randomLog:trace("Pushed " .. coalition .. " front")
    frontLineManager.clearAllFrontCircles()

    for groupName, flagNumber in pairs(groupFlags) do
        local currentTimer = trigger.action.getUserFlag(flagNumber)
        trigger.action.setUserFlag(flagNumber, 3)
        randomLog:trace("Changing timer for group " .. groupName .. "(" .. flagNumber .. ") from " .. currentTimer .. " to " .. 3)
    end
end

function frontLineManager.getRadiusAndPointOfGroup(groupName)
    local radius = 0
    local group = Group.getByName(groupName)
    local avgGroupPos = nil
    if group then
        avgGroupPos = mist.getAvgPos(mist.makeUnitTable({'[g]' .. groupName}))
        local units = group:getUnits()
        if #units > 0 then
            for i = 1, #units do
                local unit = units[i]
                local unitPos = unit:getPosition().p
                local distance = mist.utils.get2DDist(unitPos, avgGroupPos)
                if distance > radius then
                    radius = distance
                end
            end
        end
    end

    return radius, avgGroupPos
end

function frontLineManager.createCircle(groupName, zoneName)
    frontLineManager.clearCircles(groupName)

    local function drawMarker()
        local markerId = mist.marker.getNextId()
        randomLog:info("Group " .. groupName .. " new marker id: " .. markerId .. ". Drawing..")
        _DATABASE_CIRCLES[groupName] = markerId
        local color = { 1, 0, 0, 1 }
        local fillColor = { 1, 0, 0, .2 }
        local isBlue = frontLineManager.isBlue(groupName)

        if isBlue then
            color = { 0, 0, 1, 1 }
            fillColor = { 0, 0, 1, .2 }
        end

        local radius, avgGroupPos = frontLineManager.getRadiusAndPointOfGroup(groupName)
        trigger.action.circleToAll(-1, markerId, avgGroupPos, radius + 300, color, fillColor, 1, true)
    end

    mist.scheduleFunction(drawMarker, { }, timer.getTime() + math.random(1, 3))
end

function frontLineManager.array_concat(...)
    local t = {}
    for n = 1, select("#", ...) do
        local arg = select(n, ...)
        if type(arg) == "table" then
            for _, v in ipairs(arg) do
                t[#t + 1] = v
            end
        else
            t[#t + 1] = arg
        end
    end
    return t
end

function frontLineManager.isArtillery(groupName)
    return has_value(redArtilleryGroups, groupName) or has_value(blueArtilleryGroups, groupName)
end

function frontLineManager.isBlue(groupName)
    return has_value(blueFrontLinesGroups, groupName) or has_value(blueArtilleryGroups, groupName)
end

function frontLineManager.isRed(groupName)
    return has_value(redFrontLinesGroups, groupName) or has_value(redArtilleryGroups, groupName)
end

function frontLineManager.spawnGroup(groupName)
    randomLog:info("Spawning group " .. groupName)

    local isBlue = frontLineManager.isBlue(groupName)
    local isRed = frontLineManager.isRed(groupName)
    local isArtillery = frontLineManager.isArtillery(groupName)

    local currentFrontLineState = trigger.misc.getUserFlag(1)

    if isBlue and not isArtillery then
        currentFrontLineState = currentFrontLineState + 1
    end

    if isRed and isArtillery then
        currentFrontLineState = currentFrontLineState - 1
    end

    if isBlue and isArtillery then
        currentFrontLineState = currentFrontLineState + 2
    end

    local zonePool = zonePools[currentFrontLineState]
    local randomZoneName = nil

    if isBlue and currentFrontLineState == 21 then
        randomZoneName = "BlueRetreat"
    end

    if isBlue and currentFrontLineState == 20 and isArtillery then
        randomZoneName = "BlueRetreat"
    end

    if isRed and currentFrontLineState == 1 then
        randomZoneName = "RedRetreat"
    end

    if isRed and currentFrontLineState == 2 and isArtillery then
        randomZoneName = "RedRetreat"
    end

    --randomZoneName = zonePool[math.random(1, #zonePool)]
    -- pokus o to aby se nespawnovali na stejné.. je potřeba ještě přidělat rušení těch _DATABASE_SPAWNS
    if randomZoneName == nil then
        local repeated = 1
        repeat
            randomZoneName = zonePool[math.random(1, #zonePool)]
            if repeated > 1 then
                randomLog:trace("Trying to get new zone for group " .. groupName .. ". Attempt " .. repeated .. ". Zone " .. randomZoneName)
            end
            repeated = repeated + 1
        until not has_string_value(_DATABASE_SPAWNS, randomZoneName)
    end

    mist.respawnGroup(groupName, true)

    local zone = trigger.misc.getZone(randomZoneName)
    local destinationPoint = zone.point

    -- Teleport a unit group to the specified destination point
    mist.teleportToPoint({
        groupName = groupName, -- Replace with the name of the unit group
        point = destinationPoint,
        action = "move",
        radius = 120,
        runways = false
    })

    _DATABASE_SPAWNS[groupName] = randomZoneName

    if isRed then
        _ACTIVE_FRONT_LINES_GROUP_RED[groupName] = true
    else
        _ACTIVE_FRONT_LINES_GROUP_BLUE[groupName] = true
    end

    randomLog:info("Spawned to zone " .. randomZoneName)

    frontLineManager.createCircle(groupName, randomZoneName)
end

local groupsToCheck = frontLineManager.array_concat(blueFrontLinesGroups, redFrontLinesGroups, redArtilleryGroups, blueArtilleryGroups)

local function onGroupChange(event)
    if event.id == world.event.S_EVENT_DEAD then
        for _, v in ipairs(groupsToCheck) do
            local group = Group.getByName(v)
            if group then
                if group:getSize() <= 0 then
                    if _DATABASE_CIRCLES[v] then
                        mist.scheduleFunction(frontLineManager.clearCircles, { v }, timer.getTime() + math.random(1, 3))
                    end

                    if _DATABASE_SPAWNS[v] then
                        _DATABASE_SPAWNS[v] = nil
                    end

                    if frontLineManager.isRed(v) then
                        _ACTIVE_FRONT_LINES_GROUP_RED[v] = nil
                    else
                        _ACTIVE_FRONT_LINES_GROUP_BLUE[v] = nil
                    end
                end
            else
                if _DATABASE_CIRCLES[v] then
                    randomLog:error("Group is not exists... " .. v .. ".. but has circle. Clearing circle")
                    frontLineManager.clearCircles(v)
                end

                if _DATABASE_SPAWNS[v] then
                    _DATABASE_SPAWNS[v] = nil
                end

                if _ACTIVE_FRONT_LINES_GROUP_RED[v] or _ACTIVE_FRONT_LINES_GROUP_BLUE[v] then
                    if frontLineManager.isRed(v) then
                        _ACTIVE_FRONT_LINES_GROUP_RED[v] = nil
                    else
                        _ACTIVE_FRONT_LINES_GROUP_BLUE[v] = nil
                    end
                end
            end
        end
    end
end

mist.addEventHandler(onGroupChange)

trigger.action.outText('Frontline manager loaded', 10)