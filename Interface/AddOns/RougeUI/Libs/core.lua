--[================[
LibClassicDurations
Author: d87
Description: Tracks all aura applications in combat log and provides duration, expiration time.
And additionally enemy buffs info.

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
local buffCache = lib.buffCache
local auraID = {}
local timerSet

lib.nameplateUnitMap = lib.nameplateUnitMap or {}
local nameplateUnitMap = lib.nameplateUnitMap

lib.guidAccessTimes = lib.guidAccessTimes or {}
local guidAccessTimes = lib.guidAccessTimes

local f = lib.frame
local callbacks = lib.callbacks
local guids = lib.guids
local spells = lib.spells

local INFINITY, tonumber = math.huge, tonumber
local PURGE_THRESHOLD = 1200

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local UnitGUID, UnitAura = UnitGUID, UnitAura
local GetSpellInfo, GetSpellDescription = GetSpellInfo, GetSpellDescription
local GetTime, time = GetTime, time
local tinsert, unpack = table.insert, unpack
local bit_band = bit.band
local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local UnitCanAssist, UnitIsUnit = UnitCanAssist, UnitIsUnit

f:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)

lib.dataVersions = lib.dataVersions or {}
local SpellDataVersions = lib.dataVersions

function lib:SetDataVersion(dataType, version)
    SpellDataVersions[dataType] = version
end

function lib:GetDataVersion(dataType)
    return SpellDataVersions[dataType] or 0
end

lib.AddAura = function(id, opts)
    if not opts then
        return
    end

    if type(id) == "table" then
        for _, spellID in ipairs(id) do
            local spellName = GetSpellInfo(spellID)
            if spellName then
                spells[spellID] = opts
            end
        end
    else
        local spellName = GetSpellInfo(id)
        if spellName then
            spells[id] = opts
        end
    end
end

--------------------------
-- OLD GUIDs PURGE
--------------------------

local function purgeOldGUIDs()
    local now = time()
    local deleted = {}
    for guid, lastAccessTime in pairs(guidAccessTimes) do
        if lastAccessTime + PURGE_THRESHOLD < now then
            guids[guid] = nil
            nameplateUnitMap[guid] = nil
            buffCache[guid] = nil
            auraID[guid] = nil
            tinsert(deleted, guid)
        end
    end
    for _, guid in ipairs(deleted) do
        guidAccessTimes[guid] = nil
    end
end

if lib.purgeTicker then
    lib.purgeTicker:Cancel()
end
lib.purgeTicker = C_Timer.NewTicker(600, purgeOldGUIDs)

---------------------------
-- Buff Detection
---------------------------

local function FireToUnits(event, dstGUID)
    local guid = (dstGUID == UnitGUID("target")) and "target" or nameplateUnitMap[dstGUID]
    if guid then
        callbacks:Fire(event, guid)
    end
end

local function SetTimer(dstGUID, spellID, duration, expirationTime, doRemove)
    local guidTable = guids[dstGUID]
    if not guidTable then
        guids[dstGUID] = {}
        guidTable = guids[dstGUID]
    end

    if doRemove or spells[spellID] and spells[spellID].duration == "hide" then
        if guidTable[spellID] then
            guidTable[spellID] = nil
        end
        return
    end

    local applicationTable = guidTable[spellID]
    if not applicationTable then
        guidTable[spellID] = {}
        applicationTable = guidTable[spellID]
    end

    if not duration then
        -- try to get duration from spell description
        local spell, desc = Spell:CreateFromSpellID(spellID), GetSpellDescription(spellID)
        if desc == nil then
            spell:ContinueOnSpellLoad(function()
                desc = spell:GetSpellDescription()
            end)
        end
        if desc then
            local highestMin = 0
            local highestSec = 0
            -- some descriptions contain the word `sec` twice (e.g. HoT's), so find the highest number
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
            if highestMin and highestMin > 0 then
                duration = tonumber(highestMin) * 60
            elseif highestSec and highestSec > 0 then
                duration = tonumber(highestSec)
            else
                duration = nil
            end
        end
    end

    if not duration then
        return SetTimer(dstGUID, spellID, nil, nil, true)
    end

    local now = GetTime()
    -- We don't want some permanent buffs to linger forever
    if spells[spellID] and spells[spellID].duration == "fake" then
        duration = 0
        expirationTime = now + 15

        -- Force an update to remove the buff
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
    applicationTable[3] = expirationTime

    guidAccessTimes[dstGUID] = time()
end

---------------------------
-- Events
---------------------------
function f:COMBAT_LOG_EVENT_UNFILTERED(event)
    return self:CombatLogHandler()
end

function f:CombatLogHandler()
    local _, eventType, _, _, _, _, _, dstGUID, _, dstFlags, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo()
    local isDstFriendly = bit_band(dstFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0
    local isEnemyBuff = not isDstFriendly and auraType == "BUFF"
    local opts = spells[spellID]

    if isEnemyBuff and (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") then
        if eventType == "SPELL_AURA_APPLIED" and (nameplateUnitMap[dstGUID] or dstGUID == UnitGUID("target")) then
            return
        end
        -- CLEU fires before UNIT_AURA event, delay it.
        C_Timer.After(0.02, function()
            if auraID[dstGUID] and auraID[dstGUID].delay then
                auraID[dstGUID].delay = false
                return
            end
            SetTimer(dstGUID, spellID, opts and opts.duration)
            FireToUnits("UNIT_BUFF", dstGUID)
        end)
    end

    if eventType == "SPELL_AURA_REMOVED" and auraType == "BUFF" then
        -- Make sure to remove auras that UNIT_AURA cannot, including for friendly.
        SetTimer(dstGUID, spellID, nil, nil, true)
        FireToUnits("UNIT_BUFF", dstGUID)
    end

    if eventType == "UNIT_DIED" then
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

function f:NAME_PLATE_UNIT_ADDED(event, unit)
    if unit and UnitCanAssist("player", unit) then
        return
    end

    local unitGUID = UnitGUID(unit)
    if unitGUID then
        nameplateUnitMap[unitGUID] = unit
    end
end

function f:NAME_PLATE_UNIT_REMOVED(event, unit)
    if unit and UnitCanAssist("player", unit) then
        return
    end

    local unitGUID = UnitGUID(unit)
    if unitGUID then
        nameplateUnitMap[unitGUID] = nil
        auraID[unitGUID] = nil
    end
end

function f:UNIT_AURA(event, unit, info)
    local unitGUID = UnitGUID(unit)
    if not unitGUID or not info or info.isFullUpdate or UnitCanAssist("player", unit) or
            UnitIsUnit(unit, "player") or (unit ~= "target" and UnitIsUnit(unit, "target")) then
        return
    end

    if info.addedAuras then
        for _, v in pairs(info.addedAuras) do
            if v.isHelpful and v.auraInstanceID then
                if not auraID[unitGUID] then
                    auraID[unitGUID] = {}
                end

                if spells[v.spellId] and (v.dispelName ~= nil) then
                    spells[v.spellId].buffType = v.dispelName
                end

                SetTimer(unitGUID, v.spellId, v.duration, v.expirationTime)
                FireToUnits("UNIT_BUFF", unitGUID)
                auraID[unitGUID][v.auraInstanceID] = { v.spellId, v.duration }
            end
        end
    end

    if info.updatedAuraInstanceIDs then
        for _, v in pairs(info.updatedAuraInstanceIDs) do
            if auraID[unitGUID] and auraID[unitGUID][v] then
                -- prevent from running SPELL_AURA_REFRESH. Delay can be false
                if auraID[unitGUID].delay == nil then
                    auraID[unitGUID].delay = {}
                end
                auraID[unitGUID].delay = true

                local spellID, duration = auraID[unitGUID][v][1], auraID[unitGUID][2]
                SetTimer(unitGUID, spellID, duration)
                FireToUnits("UNIT_BUFF", unitGUID)
            end
        end
    end

    if info.removedAuraInstanceIDs then
        for _, v in pairs(info.removedAuraInstanceIDs) do
            if auraID[unitGUID] and auraID[unitGUID][v] then
                -- this could fire with CLEU, but its warranted
                SetTimer(unitGUID, auraID[unitGUID][v][1], nil, nil, true)
                auraID[unitGUID][v] = nil
            end
            FireToUnits("UNIT_BUFF", unitGUID)
        end
    end
end

---------------------------
-- ENEMY BUFFS
---------------------------

local function GetGUIDAuraTime(dstGUID, spellID)
    local applicationTable = guids[dstGUID] and guids[dstGUID][spellID]
    if not applicationTable then
        return
    end

    local duration, startTime, expiration = unpack(applicationTable)
    if not duration or not startTime or (type(duration) == "function") then
        return nil
    end

    -- INFINITY is set by the spellTable, 0 by UNIT_AURA/UnitAura on permanent buffs.
    if duration and (duration == INFINITY or (duration == 0 and expiration == 0)) then
        return 0, 0
    end

    local expirationTime = expiration or (startTime + duration)
    if GetTime() <= expirationTime then
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
            if guidTable[spellID] then
                guidTable[spellID] = nil
            end
        end
    end

    buffCache[dstGUID] = buffs
end

function lib.UnitAuraDirect(unit, index, filter)
    local unitGUID = UnitGUID(unit)
    if filter == "HELPFUL" and not UnitCanAssist("player", unit) and not UnitAura(unit, 1, filter) then
        if not unitGUID then
            return
        end

        RegenerateBuffList(unitGUID)
        local buffReturns = buffCache[unitGUID] and buffCache[unitGUID][index]
        if buffReturns then
            return unpack(buffReturns)
        end
    else
        -- cache the buffs we can see, e.g. for pre-duel or Detect Magic
        if filter == "HELPFUL" and unitGUID then
            local name, _, _, dispelType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)
            if name then
                SetTimer(unitGUID, spellID, duration, expirationTime)
                if spells[spellID] and spells[spellID].buffType then
                    if spells[spellID].buffType and dispelType and (spells[spellID].buffType ~= dispelType) then
                        spells[spellID].buffType = dispelType
                    end
                end
            end
        end
        return UnitAura(unit, index, filter)
    end
end

-- Why does the UnitAuraDirect need another function?
-- Keep it to not break addons
function lib:UnitAura(...)
    return self.UnitAuraDirect(...)
end

-- Idem
-- Keep it to not break addons
function lib.UnitAuraWithBuffs(...)
    return lib.UnitAuraDirect(...)
end

-- This used to return duration information for friendly buffs which UnitAura does by default now.
-- Keep it to not break addons
function lib.UnitAuraWrapper(...)
    return UnitAura(...)
end

-- What is this even used for? enemyBuffs already return the info when using UnitAuraDirect
-- Keep it to not break addons
function lib.GetAuraDurationByUnitDirect(unit, spellID)
    local dstGUID = UnitGUID(unit)
    return GetGUIDAuraTime(dstGUID, spellID)
end

-- Idem
-- Keep it to not break addons
function lib:GetAuraDurationByUnit(...)
    return self.GetAuraDurationByUnitDirect(...)
end

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

lib.activeFrames = lib.activeFrames or {}
local activeFrames = lib.activeFrames
function lib:RegisterFrame(frame)
    activeFrames[frame] = true
    if next(activeFrames) then
        f:RegisterEvent("UNIT_AURA")
        f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end
lib.Register = lib.RegisterFrame

function lib:UnregisterFrame(frame)
    activeFrames[frame] = nil
    if not next(activeFrames) then
        f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        f:UnregisterEvent("UNIT_AURA")
    end
end
lib.Unregister = lib.UnregisterFrame