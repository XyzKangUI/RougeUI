local addonName, RougeUI = ...
local plates = {}
local cacheUnit = {}
local unitID = { "target", "focus", "arena1", "arena2", "arena3" }
local ipairs, mceil = ipairs, math.ceil
local CombatLog_Object_IsA, COMBATLOG_FILTER_HOSTILE_PLAYERS = CombatLog_Object_IsA, COMBATLOG_FILTER_HOSTILE_PLAYERS

local function unitToken(guid)
    for _, unit in ipairs(unitID) do
        if UnitGUID(unit) == guid then
            return unit
        end
    end
end

local eventRegistered = {
    ["SWING_DAMAGE"] = true,
    ["RANGE_DAMAGE"] = true,
    ["SPELL_DAMAGE"] = true,
    ["SPELL_PERIODIC_DAMAGE"] = true,
    ["SPELL_AURA_APPLIED"] = true,
    ["SPELL_AURA_REMOVED"] = true,
    ["SPELL_MISSED"] = true,
    ["SWING_MISSED"] = true,
    ["RANGE_MISSED"] = true
}

local PF = {
    [8122] = 0.45, -- Psychic Scream
    [5782] = 0.4, -- Fear
    [5484] = 0.4, -- Howl of Terror
    [5246] = 0.4, -- Intimidating Shout (others)
    [20511] = 0.0001, -- Intimidating Shout (target)
    [51514] = 0.4, -- Hex
    [10326] = 0.4, -- Turn Evil
    [82691] = 0.13, -- Ring of Frost
    [122] = 9700, -- Frost Nova
    [339] = 9700, -- Entangling Roots
    [33395] = 9700, -- Freeze
    --[1513] = true, -- Scare Beast
}

-- Base Health lvl 85
local classHealth = {
    [1] = 43285, -- Warrior
    [2] = 43285, -- Paladin
    [3] = 39037, -- Hunter
    [4] = 40529, -- Rogue
    [5] = 43285, -- Priest
    [6] = 43285, -- Death Knight
    [7] = 37097, -- Shaman
    [8] = 37113, -- Mage
    [9] = 38184, -- Warlock
    [11] = 39533, -- Druid
}

local function CreateIcon(unit, unitGUID)
    local plate = C_NamePlate.GetNamePlateForUnit(unit)

    if not plate or plate:IsForbidden() then
        return
    end

    if not plate.ccAbsorbTrack then
        plate.ccAbsorbTrack = plate:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        plate.ccAbsorbTrack:SetFontObject("SystemFont_Outline_Small")
        plate.ccAbsorbTrack:SetSize(50, 50)
        plate.ccAbsorbTrack:SetScale(1.25)
        plate.ccAbsorbTrack:SetPoint("CENTER", 0, -18)
        plate.ccAbsorbTrack:Hide()
    end

    plate.ccAbsorbTrack.unit = unit

    plates[unitGUID] = plate
end

local function UpdateIndicator(guid)
    local plate = plates[guid]

    if not plate then
        return
    end

    local amount = cacheUnit[guid] and cacheUnit[guid].maxAmount or 0
    if plate.ccAbsorbTrack then
        if amount > 0 then
            plate.ccAbsorbTrack:SetText(mceil(amount))
            if not plate.ccAbsorbTrack:IsShown() then
                plate.ccAbsorbTrack:Show()
            end
        else
            plate.ccAbsorbTrack:Hide()
            plate.ccAbsorbTrack:SetText("")
        end
    end
end

local function CLEU()
    local _, type, _, _, _, _, _, destGUID, _, destFlags, _, spellID, spellName, arg14, arg15, _, arg17, arg18, _, _, arg21 = CombatLogGetCurrentEventInfo()

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)

    if not (eventRegistered[type]) or not isDestEnemy then
        return
    end

    local modifier = PF[spellID]

    if type == "SPELL_AURA_APPLIED" then
        if modifier then
            local unit = unitToken(destGUID)

            if not unit then
                return
            end

            local _, _, class = UnitClass(unit)
            local _, _, race = UnitRace(unit)
            local baseHealth = (race == 6) and classHealth[class] * 1.05 or classHealth[class]
            local amount = baseHealth * modifier
            if modifier > 1 then
                amount = modifier
            end
            --local amount = UnitHealthMax(unit) * 0.15

            cacheUnit[destGUID] = {
                maxAmount = amount,
                feared = true,
            }
            CreateIcon(unit, destGUID)
            UpdateIndicator(destGUID)
        end
    elseif type == "SPELL_AURA_REMOVED" then
        if modifier and (cacheUnit[destGUID] and cacheUnit[destGUID].feared) then
            cacheUnit[destGUID] = {}
            UpdateIndicator(destGUID)
        end
    else
        if (cacheUnit[destGUID] and cacheUnit[destGUID].feared) then
            if spellID == 63675 and (type ~= "SPELL_PERIODIC_DAMAGE") then
                return
            end

            local damage = arg15

            if type == "SWING_DAMAGE" then
                damage = spellID
            elseif type == "RANGE_MISSED" or type == "SPELL_MISSED" then
                if arg15 ~= "ABSORB" then
                    return
                end
                damage = arg17
            elseif type == "SWING_MISSED" then
                if spellID ~= "ABSORB" then
                    return
                end
                damage = arg14
            end

            cacheUnit[destGUID].maxAmount = cacheUnit[destGUID].maxAmount - damage
            UpdateIndicator(destGUID)
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        for _, plate in pairs(plates) do
            plate.ccAbsorbTrack:Hide()
        end
        plates = {}
        cacheUnit = {}
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        CLEU()
    elseif event == "ADDON_LOADED" and ... == addonName then
        if RougeUI.db.PSTrack then
            self:RegisterEvent("PLAYER_ENTERING_WORLD")
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        end
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure())
        local guid = UnitGUID(unit)
        if (unit and namePlateFrameBase) and not namePlateFrameBase:IsForbidden() then
            UpdateIndicator(guid)
        end
    end
end)