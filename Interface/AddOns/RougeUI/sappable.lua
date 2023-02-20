local plates = {}
local cacheUnit = {}
local unitID = { "target", "arena1", "arena2", "arena3" }
local ipairs, strsplit, mceil = ipairs, string.split, math.ceil
local UnitGUID, UnitIsPlayer, UnitClass = UnitGUID, UnitIsPlayer, UnitClass
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

local bustedSpells = {
    [GetSpellInfo(58381)] = true, -- Mind Flay
    [GetSpellInfo(63675)] = true, -- Improved Devouring Plague
}

local function GlyphCheck()
    for i = 1, 6 do
        local _, _, glyphID = GetGlyphSocketInfo(i);

        if (glyphID and glyphID == 63095) then
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

local function UpdateIndicator(amount, guid)
    if plates[guid] then
        local plate = plates[guid]
        if plate.indicator then
            if amount <= 0 then
                plate.indicator:SetText(amount)
                plate.indicator:Hide()
            elseif amount > 0 then
                plate.indicator:SetText(mceil(amount))
                if not plate.indicator:IsShown() then
                    plate.indicator:Show()
                end
            end
        end
    end
end

local function CLEU()
    local _, type, _, _, _, _, _, destGUID, _, destFlags, _, spellID, spellName, _, arg15, _, _, arg18, _, _, arg21 = CombatLogGetCurrentEventInfo()

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)

    if not (eventRegistered[type]) or not isDestEnemy then
        return
    end

    if not cacheUnit[destGUID] then
        cacheUnit[destGUID] = {
            maxAmount = nil,
            feared = false,
        }
    end

    if type == "SPELL_AURA_APPLIED" and PF[spellID] then
        local unit = unitToken(destGUID)

        if not UnitIsPlayer(unit) then
            return
        end

        local _, _, class = UnitClass(unit)
        local amount = classHealth[class] * 0.4

        if spellID == 51514 and glyphHex then
            amount = amount * 1.2
        end

        cacheUnit[destGUID] = {
            maxAmount = amount,
            feared = true,
        }
        CreateIcon(unit, destGUID)
        UpdateIndicator(amount, destGUID)
    elseif (type == "SPELL_DAMAGE" or type == "RANGE_DAMAGE") and cacheUnit[destGUID].feared then
        if bustedSpells[spellName] then
            return
        end

        local damage = arg15
        if arg21 then
            damage = arg15 / 2
        end

        cacheUnit[destGUID].maxAmount = cacheUnit[destGUID].maxAmount - damage

        local amount = cacheUnit[destGUID].maxAmount
        UpdateIndicator(amount, destGUID)
    elseif (type == "SPELL_PERIODIC_DAMAGE") and cacheUnit[destGUID].feared then
        local damage = arg15
        if arg21 then
            damage = arg15 / 2
        end

        cacheUnit[destGUID].maxAmount = cacheUnit[destGUID].maxAmount - damage

        local amount = cacheUnit[destGUID].maxAmount
        UpdateIndicator(amount, destGUID)
    elseif type == "SWING_DAMAGE" and cacheUnit[destGUID].feared then
        local damage = spellID
        if arg18 then
            damage = spellID / 2
        end

        cacheUnit[destGUID].maxAmount = cacheUnit[destGUID].maxAmount - damage

        local amount = cacheUnit[destGUID].maxAmount
        UpdateIndicator(amount, destGUID)
    elseif type == "SPELL_AURA_REMOVED" and PF[spellID] and cacheUnit[destGUID].feared then
        cacheUnit[destGUID] = {}

        UpdateIndicator(0, destGUID)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("GLYPH_UPDATED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        plates = {}
        cacheUnit = {}
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        CLEU()
    elseif event == "GLYPH_UPDATED" then
        if select(3, UnitClass("player")) == 7 then
            GlyphCheck()
        else
            self:UnregisterEvent("GLYPH_UPDATED")
        end
    elseif event == "PLAYER_LOGIN" then
        if not RougeUI.PSTrack then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            return
        end
        if select(3, UnitClass("player")) == 7 then
            GlyphCheck()
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)