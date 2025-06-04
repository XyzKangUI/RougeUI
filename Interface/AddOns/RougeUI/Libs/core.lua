--[================[
LibClassicDurations
Author: d87 (original), edited by Xyz
Description: Tracks all aura applications in combat log and provides duration, expiration time.
             Also provides enemy buffs info.
--]================]

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
    return
end

local MAJOR, MINOR = "LibClassicDurations", 72
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then
    return
end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
lib.frame = lib.frame or CreateFrame("Frame")
lib.guids = lib.guids or {}
lib.spells = lib.spells or {}
lib.buffCache = lib.buffCache or {}
lib.nameplateUnitMap = lib.nameplateUnitMap or {}
lib.guidAccessTimes = lib.guidAccessTimes or {}
lib.dataVersions = lib.dataVersions or {}
lib.activeFrames = lib.activeFrames or {}

local buffCache = lib.buffCache
local nameplateUnitMap = lib.nameplateUnitMap
local guidAccessTimes = lib.guidAccessTimes
local spells = lib.spells
local guids = lib.guids
local activeFrames = lib.activeFrames

-- For tracking UNIT_AURA info
local auraID = {}
local delay = {}
local timerSet  -- For handling "fake" durations

local f = lib.frame
local callbacks = lib.callbacks

local INFINITY = math.huge
local tonumber = tonumber
local pairs, ipairs = pairs, ipairs
local tinsert, unpack = table.insert, unpack
local bit_band = bit.band
local GetTime, time = GetTime, time
local UnitGUID, UnitAura = UnitGUID, UnitAura
local GetSpellInfo, GetSpellDescription = GetSpellInfo, GetSpellDescription
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local UnitCanAssist, UnitIsUnit = UnitCanAssist, UnitIsUnit
local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local feigningUnits = {}

local PURGE_THRESHOLD = 1200

f:SetScript("OnEvent", function(self, event, ...)
    if self[event] then
        return self[event](self, event, ...)
    end
end)

----------------------------------
-- Data Version Functions
----------------------------------
function lib:SetDataVersion(dataType, version)
    lib.dataVersions[dataType] = version
end

function lib:GetDataVersion(dataType)
    return lib.dataVersions[dataType] or 0
end

----------------------------------
-- Aura Registration
----------------------------------
function lib.AddAura(id, opts)
    if not opts then
        return
    end
    if type(id) == "table" then
        for _, spellID in ipairs(id) do
            if GetSpellInfo(spellID) then
                spells[spellID] = opts
            end
        end
    else
        if GetSpellInfo(id) then
            spells[id] = opts
        end
    end
end

----------------------------------
-- Purge Old GUIDs
----------------------------------
local function purgeOldGUIDs()
    local now = time()
    local toDelete = {}
    for guid, lastAccessTime in pairs(guidAccessTimes) do
        if lastAccessTime + PURGE_THRESHOLD < now then
            guids[guid] = nil
            nameplateUnitMap[guid] = nil
            buffCache[guid] = nil
            auraID[guid] = nil
            delay[guid] = nil
            tinsert(toDelete, guid)
        end
    end
    for _, guid in ipairs(toDelete) do
        guidAccessTimes[guid] = nil
    end
end

if lib.purgeTicker then
    lib.purgeTicker:Cancel()
end
lib.purgeTicker = C_Timer.NewTicker(600, purgeOldGUIDs)

----------------------------------
-- Buff Handling Functions
----------------------------------
local function FireToUnits(event, dstGUID)
    local guid = (dstGUID == UnitGUID("target")) and "target" or nameplateUnitMap[dstGUID]
    if guid then
        callbacks:Fire(event, guid)
    end
end

local function SetTimer(dstGUID, spellID, duration, expirationTime, doRemove)
    local guidTable = guids[dstGUID] or {}
    guids[dstGUID] = guidTable

    if doRemove or (spells[spellID] and spells[spellID].duration == "hide") then
        guidTable[spellID] = nil
        return
    end

    local applicationTable = guidTable[spellID] or {}
    guidTable[spellID] = applicationTable

    if not duration then
        local desc = GetSpellDescription(spellID)
        if not desc and Spell and Spell.CreateFromSpellID then
            local spell = Spell:CreateFromSpellID(spellID)
            spell:ContinueOnSpellLoad(function()
                desc = spell:GetSpellDescription()
            end)
        end
        if desc then
            local highestMin, highestSec = 0, 0
            for dur in desc:gmatch("(%d+)%s-[Mm]in") do
                local val = tonumber(dur)
                if val and val > highestMin then
                    highestMin = val
                end
            end
            for dur in desc:gmatch("(%d+)%s-[Ss]ec") do
                local val = tonumber(dur)
                if val and val > highestSec then
                    highestSec = val
                end
            end
            if highestMin > 0 then
                duration = highestMin * 60
            elseif highestSec > 0 then
                duration = highestSec
            end
        end
    end

    if not duration or type(duration) ~= "number" then
        return SetTimer(dstGUID, spellID, nil, nil, true)
    end

    local now = GetTime()
    if spells[spellID] and spells[spellID].duration == "fake" then
        duration = 0
        expirationTime = now + 15
        if not timerSet then
            C_Timer.After(15.5, function()
                FireToUnits("UNIT_BUFF", dstGUID)
                timerSet = false
            end)
            timerSet = true
        end
    end

    applicationTable[1] = duration
    applicationTable[2] = now
    applicationTable[3] = expirationTime or (now + duration)
    guidAccessTimes[dstGUID] = time()
end

----------------------------------
-- Combat Log Processing
----------------------------------
function f:COMBAT_LOG_EVENT_UNFILTERED()
    self:CombatLogHandler()
end

function f:CombatLogHandler()
    local _, eventType, _, _, _, _, _, dstGUID, _, dstFlags, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo()
    local isDstFriendly = bit_band(dstFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0
    local isEnemyBuff = (not isDstFriendly) and (auraType == "BUFF")
    local opts = spells[spellID]

    if isEnemyBuff and (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") then
        if eventType == "SPELL_AURA_APPLIED" and (nameplateUnitMap[dstGUID] or dstGUID == UnitGUID("target")) then
            return
        end
        C_Timer.After(0.02, function()
            if delay[dstGUID] then
                delay[dstGUID] = false
                return
            end
            SetTimer(dstGUID, spellID, opts and opts.duration)
            FireToUnits("UNIT_BUFF", dstGUID)
        end)
    end

    if eventType == "SPELL_AURA_REMOVED" and auraType == "BUFF" then
        SetTimer(dstGUID, spellID, nil, nil, true)
        FireToUnits("UNIT_BUFF", dstGUID)
    end

    if eventType == "UNIT_DIED" and not feigningUnits[dstGUID] then
        guids[dstGUID] = nil
        auraID[dstGUID] = nil
        buffCache[dstGUID] = nil
        guidAccessTimes[dstGUID] = nil
        if not isDstFriendly then
            FireToUnits("UNIT_BUFF", dstGUID)
        end
        nameplateUnitMap[dstGUID] = nil
    end
end

----------------------------------
-- Nameplate Tracking
----------------------------------
function f:NAME_PLATE_UNIT_ADDED(_, unit)
    if unit and not UnitCanAssist("player", unit) then
        local unitGUID = UnitGUID(unit)
        if unitGUID then
            nameplateUnitMap[unitGUID] = unit
        end
    end
end

function f:NAME_PLATE_UNIT_REMOVED(_, unit)
    if unit and not UnitCanAssist("player", unit) then
        local unitGUID = UnitGUID(unit)
        if unitGUID then
            nameplateUnitMap[unitGUID] = nil
        end
    end
end

----------------------------------
-- UNIT_AURA Handling
----------------------------------
function f:UNIT_AURA(_, unit, info)
    local unitGUID = UnitGUID(unit)
    if not unitGUID or not info or info.isFullUpdate or UnitCanAssist("player", unit)
            or UnitIsUnit(unit, "player") or (unit ~= "target" and UnitIsUnit(unit, "target")) then
        return
    end

    if info.addedAuras then
        for _, aura in pairs(info.addedAuras) do
            if aura.isHelpful and aura.auraInstanceID then
                auraID[unitGUID] = auraID[unitGUID] or {}
                if spells[aura.spellId] and aura.dispelName then
                    spells[aura.spellId].buffType = aura.dispelName
                end
                SetTimer(unitGUID, aura.spellId, aura.duration, aura.expirationTime)
                FireToUnits("UNIT_BUFF", unitGUID)
                auraID[unitGUID][aura.auraInstanceID] = { aura.spellId, aura.duration }

                if feigningUnits[unitGUID] then
                    feigningUnits[unitGUID][aura.auraInstanceID] = true
                end
            end
        end
    end

    if info.updatedAuraInstanceIDs then
        for _, auraInstID in pairs(info.updatedAuraInstanceIDs) do
            if auraID[unitGUID] and auraID[unitGUID][auraInstID] then
                delay[unitGUID] = true
                local spellID = auraID[unitGUID][auraInstID][1]
                local smth = auraID[unitGUID][auraInstID][2]
                local duration = type(smth) == "number" and smth or 0
                SetTimer(unitGUID, spellID, duration)
                FireToUnits("UNIT_BUFF", unitGUID)
            end
        end
    end

    if info.removedAuraInstanceIDs then
        for _, auraInstID in pairs(info.removedAuraInstanceIDs) do
            if auraID[unitGUID] and auraID[unitGUID][auraInstID] then
                SetTimer(unitGUID, auraID[unitGUID][auraInstID][1], nil, nil, true)
                auraID[unitGUID][auraInstID] = nil
            end

            if feigningUnits[unitGUID] and feigningUnits[unitGUID][auraInstID] then
                feigningUnits[unitGUID][auraInstID] = nil

                if next(feigningUnits[unitGUID]) == nil then
                    feigningUnits[unitGUID] = nil
                end
            end

            FireToUnits("UNIT_BUFF", unitGUID)
        end
    end
end

function f:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
    if spellId == 5384 and unit then
        local guid = UnitGUID(unit)
        if not guid then return end
        feigningUnits[guid] = {}
    end
end

function f:PLAYER_TARGET_CHANGED()
    local _, class = UnitClass("target")
    if class == "HUNTER" then
        local hp = UnitHealth("target")
        if (hp and hp > 0) then
            local guid = UnitGUID("target")
            if not guid then return end
            local changed = false

            feigningUnits[guid] = nil

            if auraID[guid] then
                for auraInstID, auraData in pairs(auraID[guid]) do
                    local spellID = auraData[1]
                    if spellID == 5384 then
                        SetTimer(guid, spellID, nil, nil, true)
                        auraID[guid][auraInstID] = nil
                        changed = true
                    end
                end

                if changed then
                    FireToUnits("UNIT_BUFF", guid)
                end
            end
        end
    end
end
----------------------------------
-- Enemy Buffs Functions
----------------------------------
local function GetGUIDAuraTime(dstGUID, spellID)
    local applicationTable = guids[dstGUID] and guids[dstGUID][spellID]
    if not applicationTable then
        return
    end

    local duration, startTime, expiration = unpack(applicationTable)
    if not duration or not startTime or type(duration) == "function" then
        return
    end

    if duration == INFINITY or (duration == 0 and expiration == 0) then
        return 0, 0
    end

    local duration, expiration, startTime = tonumber(duration), tonumber(expiration), tonumber(startTime)
    local expirationTime = expiration or (startTime + duration)

    if expirationTime and (GetTime() <= expirationTime) then
        return duration, expirationTime
    end

end

local function makeBuffInfo(spellID, dstGUID)
    local name, _, icon = GetSpellInfo(spellID)
    local duration, expirationTime = GetGUIDAuraTime(dstGUID, spellID)
    if name and icon and duration and expirationTime then
        return { name, icon, 0, spells[spellID] and spells[spellID].buffType, duration, expirationTime, nil, nil, nil, spellID, false, false, false, false, 1 }
    end
end

local function RegenerateBuffList(dstGUID)
    local buffs = {}
    local now = GetTime()
    local guidTable = guids[dstGUID]
    if not guidTable then
        return
    end

    for spellID in pairs(guidTable) do
        local buffInfo = makeBuffInfo(spellID, dstGUID)
        if buffInfo and (buffInfo[6] > (now + 0.2) or (buffInfo[5] == 0 and buffInfo[6] == 0)) then
            tinsert(buffs, buffInfo)
        else
            guidTable[spellID] = nil
        end
    end
    buffCache[dstGUID] = buffs
end

----------------------------------
-- UnitAura and Related Functions
----------------------------------
function lib.UnitAuraDirect(unit, index, filter)
    local unitGUID = UnitGUID(unit)
    if filter == "HELPFUL" and not UnitCanAssist("player", unit) and not UnitAura(unit, 1, filter) then
        if unitGUID then
            RegenerateBuffList(unitGUID)
            local buffReturns = buffCache[unitGUID] and buffCache[unitGUID][index]
            if buffReturns then
                return unpack(buffReturns)
            end
        end
    else
        if filter == "HELPFUL" and unitGUID then
            local name, _, _, dispelType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)
            if name then
                SetTimer(unitGUID, spellID, duration, expirationTime)
                if spells[spellID] and dispelType and spells[spellID].buffType and spells[spellID].buffType ~= dispelType then
                    spells[spellID].buffType = dispelType
                end
            end
        end
        return UnitAura(unit, index, filter)
    end
end

-- Legacy wrappers (to avoid breaking addons)
function lib:UnitAura(...)
    return self.UnitAuraDirect(...)
end

function lib.UnitAuraWithBuffs(...)
    return lib.UnitAuraDirect(...)
end

function lib.UnitAuraWrapper(...)
    return UnitAura(...)
end

function lib.GetAuraDurationByUnitDirect(unit, spellID)
    local dstGUID = UnitGUID(unit)
    return GetGUIDAuraTime(dstGUID, spellID)
end

function lib:GetAuraDurationByUnit(...)
    return self.GetAuraDurationByUnitDirect(...)
end

----------------------------------
-- Callbacks and Frame Registration
----------------------------------
function callbacks.OnUsed()
    f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
end

function callbacks.OnUnused()
    f:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
    f:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
end

if next(callbacks.events) then
    callbacks.OnUsed()
end

function lib:RegisterFrame(frame)
    activeFrames[frame] = true
    if next(activeFrames) then
        f:RegisterEvent("UNIT_AURA")
        f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        f:RegisterEvent("PLAYER_TARGET_CHANGED")
    end
end
lib.Register = lib.RegisterFrame

function lib:UnregisterFrame(frame)
    activeFrames[frame] = nil
    if not next(activeFrames) then
        f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        f:UnregisterEvent("UNIT_AURA")
        f:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        f:UnregisterEvent("PLAYER_TARGET_CHANGED")
    end
end
lib.Unregister = lib.UnregisterFrame
