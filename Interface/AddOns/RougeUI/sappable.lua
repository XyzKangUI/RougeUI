local _, RougeUI = ...
local plates = {}
local cacheUnit = {}
local unitID = { "target", "arena1", "arena2", "arena3" }
local ipairs, mceil = ipairs, math.ceil
local UnitGUID, UnitClass = UnitGUID, UnitClass
local CombatLog_Object_IsA, COMBATLOG_FILTER_HOSTILE_PLAYERS = CombatLog_Object_IsA, COMBATLOG_FILTER_HOSTILE_PLAYERS
local glyphHex = nil

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
}

local PF = {
    [8122] = true,
    [8124] = true,
    [10888] = true,
    [10890] = true,
    [5782] = true,
    [6213] = true,
    [6215] = true,
    [5484] = true,
    [17928] = true,
    [5246] = true, -- Intimidating Shout
    [51514] = true, -- Hex
    [10326] = true -- Turn Evil
}

-- https://wowwiki-archive.fandom.com/wiki/Base_health
local classHealth = {
    [1] = 8121, -- Warrior
    [2] = 6934, -- Paladin
    [3] = 7324, -- Hunter
    [4] = 7604, -- Rogue
    [5] = 6960, -- Priest
    [6] = 8121, -- Death Knight
    [7] = 7604, -- Shaman
    [8] = 6963, -- Mage
    [9] = 7164, -- Warlock
    [11] = 7417, -- Druid
}

-- Do all damaging trinket procs count or only pendulum of telluric currents?
local bustedSpells = {
    [GetSpellInfo(58381)] = true, -- Mind Flay
    [GetSpellInfo(63675)] = true, -- Improved Devouring Plague
}

local function GlyphCheck()
    for i = 1, 6 do
        local _, _, glyphID = GetGlyphSocketInfo(i);

        if glyphID and (glyphID == 63291 or glyphID == 56244) then
            glyphHex = true
            return
        end
    end
    glyphHex = false
end

local function CreateIcon(unit, unitGUID)
    local plate = C_NamePlate.GetNamePlateForUnit(unit)

    if not plate or plate:IsForbidden() then
        return
    end

    if not plate.indicator then
        plate.indicator = plate:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        plate.indicator:SetFontObject("SystemFont_Outline_Small")
        plate.indicator:SetSize(50, 50)
        plate.indicator:SetScale(1.25)
        plate.indicator:SetPoint("CENTER", 0, -18)
        plate.indicator:Hide()
    end

    plate.indicator.unit = unit

    plates[unitGUID] = plate
end

local function UpdateIndicator(guid)
    local plate = plates[guid]

    if not plate then
        return
    end

    local amount = cacheUnit[guid] and cacheUnit[guid].maxAmount or 0
    if plate.indicator then
        if amount > 0 then
            plate.indicator:SetText(mceil(amount))
            if not plate.indicator:IsShown() then
                plate.indicator:Show()
            end
        else
            plate.indicator:Hide()
            plate.indicator:SetText("")
        end
    end
end

local function CLEU()
    local _, type, _, _, _, _, _, destGUID, _, destFlags, _, spellID, spellName, _, arg15, _, _, arg18, _, _, arg21 = CombatLogGetCurrentEventInfo()

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)

    if not (eventRegistered[type]) or not isDestEnemy then
        return
    end

    if type == "SPELL_AURA_APPLIED" then
        if PF[spellID] then
            local unit = unitToken(destGUID)

            if not unit then
                return
            end

            local _, _, class = UnitClass(unit)
            local amount = classHealth[class] * 0.40
            --local amount = UnitHealthMax(unit) * 0.15

            if spellID == 51514 and glyphHex then
                amount = amount * 1.2
            end

            cacheUnit[destGUID] = {
                maxAmount = amount,
                feared = true,
            }
            CreateIcon(unit, destGUID)
            UpdateIndicator(destGUID)
        end
    elseif type == "SPELL_AURA_REMOVED" then
        if PF[spellID] and (cacheUnit[destGUID] and cacheUnit[destGUID].feared) then
            cacheUnit[destGUID] = {}
            UpdateIndicator(destGUID)
        end
    else
        if (cacheUnit[destGUID] and cacheUnit[destGUID].feared) then
            if bustedSpells[spellName] and (type ~= "SPELL_PERIODIC_DAMAGE") then
                return
            end

            local damage, arg

            if type == "SWING_DAMAGE" then
                damage = spellID
                arg = arg18
            else
                damage = arg15
                arg = arg21
            end

            -- Crits count towards breaking CC, stealthfix?
            --   if arg then
            --       damage = damage / 2
            --    end

            cacheUnit[destGUID].maxAmount = cacheUnit[destGUID].maxAmount - damage
            UpdateIndicator(destGUID)
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        for _, plate in pairs(plates) do
            plate.indicator:Hide()
        end
        plates = {}
        cacheUnit = {}
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        CLEU()
    elseif event == "GLYPH_UPDATED" then
        local _, _, class = UnitClass("player")
        if (class == 7 or class == 9) then
            GlyphCheck()
        end
    elseif event == "PLAYER_LOGIN" then
        if not RougeUI.db.PSTrack then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            return
        end
        local _, _, class = UnitClass("player")
        if (class == 7 or class == 9) then
            frame:RegisterEvent("GLYPH_UPDATED")
            GlyphCheck()
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure())
        local guid = UnitGUID(unit)
        if (unit and namePlateFrameBase) and not namePlateFrameBase:IsForbidden() then
            UpdateIndicator(guid)
        end
    end
end)