local addonName, RougeUI = ...
local EnemyOOC = {}
EnemyOOC.U = {}
local UnitPowerType, UnitPower, UnitAffectingCombat = _G.UnitPowerType, _G.UnitPower, _G.UnitAffectingCombat
local UnitCanAttack, UnitGUID, UnitExists = _G.UnitCanAttack, _G.UnitGUID, _G.UnitExists
local UnitTokenFromGUID, UnitIsUnit = _G.UnitTokenFromGUID, _G.UnitIsUnit
local externalManaGainTimestamp = 0
local gain = 0
local endTime = {}
local durations = { 2.02, 4.04, 6.06, 8.08 }
local expirationTime = {}
local oocTime = {}
local outOfCombatTime = {}
local running = {}
local lastSeen = {}
local m_abs, ipairs, pairs = math.abs, ipairs, pairs
local max, strformat = math.max, string.format
local UnitDetailedThreatSituation, UnitIsPlayer = _G.UnitDetailedThreatSituation, _G.UnitIsPlayer
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local COMBATLOG_FILTER_HOSTILE_PLAYERS = _G.COMBATLOG_FILTER_HOSTILE_PLAYERS;
local COMBATLOG_FILTER_ME = _G.COMBATLOG_FILTER_ME
local COMBATLOG_FILTER_FRIENDLY_UNITS = _G.COMBATLOG_FILTER_FRIENDLY_UNITS
local COMBATLOG_FILTER_HOSTILE_UNITS = _G.COMBATLOG_FILTER_HOSTILE_UNITS
local COMBATLOG_FILTER_UNKNOWN_UNITS = _G.COMBATLOG_FILTER_UNKNOWN_UNITS
local CombatLog_Object_IsA = _G.CombatLog_Object_IsA
local indicator
local energyValues = {}
local powerTypes = { [0] = true, [3] = true, [1] = true, [6] = true, [2] = true }

local updateUnit = {}
for i = 1, 20 do
    updateUnit["nameplate" .. i] = true
end
updateUnit["target"] = true

EnemyOOC.Quirks = {
    [6774] = true, -- Slice and Dice (R2)
    [11305] = true, -- Sprint (R3)
    [14185] = true, -- Preparation
    [13877] = true, -- Blade Flurry
    [13750] = true, -- Adrenaline Rush
    [14183] = true, -- Premeditation
    [14177] = true, -- Cold Blood
    [7744] = true, -- Will of the forsaken
    [20600] = true, -- Perception
    [20594] = true, -- Stoneform
    [20554] = true, -- Berserking
    [20572] = true, -- Blood Fury
    [768] = true, -- Cat Form
    [783] = true, -- Travel Form
    [9634] = true, -- Dire Bear Form
    [5229] = true, -- Enrage
    [9846] = true, -- Tiger's Fury
    [22812] = true, -- Barkskin
    [34074] = true, -- Aspect of the Viper
    [13159] = true, -- Aspect of the Pack
    [13161] = true, -- Aspect of the Beast
    [5118] = true, -- Aspect of the Cheetah
    [13163] = true, -- Aspect of the Monkey
    [1002] = true, -- Eyes of the Beast
    [6197] = true, -- Eagle Eye
    [2641] = true, -- Dismiss Pet
    [883] = true, -- Call Pet
    [5384] = true, -- Feign Death
    [13809] = true, -- Frost Trap
    [14311] = true, -- Freezing trap
    [19880] = true, -- Track elementals
    [19885] = true, -- Track hidden
    [19884] = true, -- Track undead
    [19883] = true, -- Track humanoids
    [66] = true, -- Invisibility
    [12043] = true, -- Presence of Mind
    [12042] = true, -- Arcane Power
    [11129] = true, -- Combustion
    [12472] = true, -- Icy Veins
    [11958] = true, -- Cold Snap
    [20218] = true, -- Sanctity aura
    [14751] = true, -- Inner Focus
    [15473] = true, -- Shadowform
    [16188] = true, -- Nature's Swiftness
    [17116] = true, -- Nature's Swiftness
    [18788] = true, -- Demonic Sacrifice
    [19028] = true, -- Soul Link
    [18288] = true, -- Amplify curse
    [18095] = true, -- Nightfall
    [12292] = true, -- Death Wish
    [12975] = true, -- Last stand
    [13048] = true, -- Enrage
    [23920] = true, -- Spell reflect
    [2458] = true, -- Berseker stance
    [71] = true, -- Defensive stance
    [2457] = true, -- Battle stance
    [18499] = true, -- Berserker rage
    [2687] = true, -- Bloodrage
    [712] = true, -- Summon Succubus
    [691] = true, -- Summon Felhunter
    [697] = true, -- Summon Voidwalker
    [28610] = true, -- Shadow Ward
    [2645] = true, -- Ghost Wolf
    [19746] = true, -- Concentration aura
    [14325] = true, -- Hunter's Mark
    [1130] = true,
    [14323] = true,
    [14324] = true,
    [14325] = true,
    [1543] = true, -- Flare
    [14893] = true, -- Inspiration
    [15357] = true,
    [15359] = true,
    [27813] = true, -- Blessed Recovery
    [27817] = true,
    [27818] = true,
    [10909] = true, -- Mind Vision
    [2096] = true, -- Mind Vision
    [453] = true, -- Mind Soothe
    [12494] = true, -- Frostbite
    [12579] = true, -- Winter's chill
    [25711] = true, -- Forbearance
    [642] = true, -- Divine Shield
    [10278] = true, -- Hand of Protection
    [431690] = true, -- Void zone
    [401556] = true, -- Living Flame
    [10] = true, -- Blizzard
    [408699] = true, -- Waylay
    [14295] = true, -- Volley
    [409554] = true, -- Explosive shot
    [460700] = true, -- Rain of Fire
    [11682] = true, -- Hellfire
    [17402] = true -- Hurricane
};

EnemyOOC.Channeling = {
    [1120] = true, -- Drain Soul
    [689] = true, -- Drain Life
    [5138] = true, -- Drain Mana
    [5740] = true, -- Rain of Fire
    [1949] = true, -- Hellfire
    [755] = true, -- Health Funnel
    [6789] = true, -- Death Coil
    [2096] = true, -- Mind Vision
    [15407] = true, -- Mind Flay
    [6064] = true, -- Heal
    [2061] = true, -- Flash Heal
    [2060] = true, -- Greater Heal
    [2050] = true, -- Lesser Heal
    [10917] = true, -- Power Word: Shield
    [596] = true, -- Prayer of Healing
    [2006] = true, -- Resurrection
    [1004] = true, -- Healing Touch
    [5185] = true, -- Healing Touch
    [8936] = true, -- Regrowth
    [740] = true, -- Tranquility
    [774] = true, -- Rejuvenation
    [2893] = true, -- Abolish Poison
    [8946] = true, -- Cure Poison
};

EnemyOOC.Nova = {
    [15237] = true, -- r1
    [15430] = true, -- r2
    [15431] = true, -- r3
    [27799] = true, -- r4
    [27800] = true, -- r5
    [27801] = true, -- r6
    [23455] = true,
    [23458] = true,
    [23459] = true,
    [27803] = true,
    [27804] = true,
    [27805] = true,
};

EnemyOOC.Pets = {
    [3606] = true, -- Searing Totem r1
    [6350] = true, -- Searing Totem r2
    [6351] = true, -- Searing Totem r3
    [6352] = true, -- Searing Totem r4
    [10435] = true, -- Searing Totem r5
    [10436] = true, -- Searing Totem r6
    [8187] = true, -- Magma Totem r6
    [10579] = true, -- Magma Totem r5
    [10580] = true, -- Magma Totem r4
    [10581] = true, -- Magma Totem r3
    [427746] = true, -- Intercept Stun
    [427744] = true, -- Cleave
};

EnemyOOC.Refreshes = {
    [3600] = true, -- Eartbind totem
};

-- This list is for spells that we need to track because they either fire no cast_success (or have an unknown destguid)
EnemyOOC.Directdamage = {
    [116] = true, -- Frostbolt
    [133] = true, -- Fireball
    [11366] = true, -- Pyroblast
    [2136] = true, -- Fire Blast
    [120] = true, -- Cone of Cold
    [122] = true, -- Frost Nova
    [1449] = true, -- Arcane Explosion
    [686] = true, -- Shadow Bolt
    [348] = true, -- Immolate
    [172] = true, -- Corruption
    [603] = true, -- Doom
    [980] = true, -- Curse of Agony
    [5782] = true, -- Fear
    [6353] = true, -- Soul Fire
    [17962] = true, -- Conflagrate
    [8129] = true, -- Mana Burn
    [585] = true, -- Smite
    [8092] = true, -- Mind Blast
    [589] = true, -- Shadow Word: Pain
    [2944] = true, -- Devouring Plague
    [5019] = true, -- Shoot
    [75] = true, -- Auto Shot
    [2643] = true, -- Multi-Shot
    [2973] = true, -- Raptor Strike
    [19434] = true, -- Aimed Shot
    [20271] = true, -- Judgement
    [24275] = true, -- Hammer of Wrath
    [20925] = true, -- Holy Shield
    [2812] = true, -- Holy Wrath
    [26573] = true, -- Consecration
    [20467] = true, -- Judgement of Righteousness
    [20911] = true, -- Blessing of Sanctuary
    [20473] = true, -- Holy Shock
    [19750] = true, -- Flash of Light
    [635] = true, -- Holy Light
    [1044] = true, -- Blessing of Freedom
    [10308] = true, -- Hammer of Justice
    [24275] = true, -- Hammer of Wrath
    [22568] = true, -- Ferocious Bite
    [2912] = true, -- Starfire
    [1822] = true, -- Rake
    [22842] = true, -- Frenzied Regeneration
    [5176] = true, -- Wrath
    [402284] = true, -- Penance
    [440488] = true, -- Shockwave
    [408428] = true, -- Fire Nova
    [409239] = true, -- Fan of Knives
    [399963] = true, -- Envenom
    [439753] = true, -- Starfall
    [439756] = true, -- Starfall
};

local function CreateIcon(unit, frame)
    if not EnemyOOC.U[unit] then
        EnemyOOC.U[unit] = CreateFrame("Frame", nil, frame)
        EnemyOOC.U[unit]:SetPoint("CENTER", frame, "RIGHT", -6, -10)
        EnemyOOC.U[unit]:SetSize(100, 100)
        EnemyOOC.U[unit]:SetScale(1.4)
        EnemyOOC.U[unit].text = EnemyOOC.U[unit]:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        EnemyOOC.U[unit].text:SetFontObject("SystemFont_Outline_Small")
        EnemyOOC.U[unit].text:SetAllPoints()
        EnemyOOC.U[unit].texture = EnemyOOC.U[unit]:CreateTexture(nil, "BACKGROUND")
        EnemyOOC.U[unit].texture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\CombatSwords2.blp")
        EnemyOOC.U[unit].texture:SetSize(45, 45)
        EnemyOOC.U[unit].texture:SetPoint("LEFT", frame, "RIGHT", -18, -3)
        EnemyOOC.U[unit]:Hide()
    end
end

local function PowerType(unit)
    return UnitPowerType(unit)
end

function EnemyOOC:StartTimer(guid)
    if not guid then
        return
    end

    self:ResetTimer(guid)

    if UnitGUID("target") == guid then
        EnemyOOC.U["target"]:Show()
    end
end

function EnemyOOC:StopTimer(guid)
    if not guid then
        return
    end

    if UnitGUID("target") == guid then
        EnemyOOC.U["target"]:Hide()
    end
end

function EnemyOOC:ResetTimer(guid)
    if not guid then
        return
    end
    endTime[guid] = GetTime()
end

function EnemyOOC:PlateUnit(unit)
    if not updateUnit[unit] then
        return
    end
    local guid = UnitGUID(unit)
    if not guid then
        return
    end

    if UnitAffectingCombat(unit) then
        if not running[guid] then
            self:StartTimer(guid)
            running[guid] = true
        end
    elseif not UnitAffectingCombat(unit) then
        self:StopTimer(guid)
        running[guid] = false
    end
end

function EnemyOOC:Predict(guid, now)
    for i = 1, #durations do
        if not expirationTime[i] then
            expirationTime[i] = {}
        end
        expirationTime[i][guid] = now + durations[i]
    end
end

function EnemyOOC.OnUpdate(self, elapsed)
    local seenGUIDs = {}
    local unitByGUID = {}
    local now = GetTime()

    for unit in pairs(updateUnit) do
        if UnitExists(unit) and powerTypes[PowerType(unit)] then
            local guid = UnitGUID(unit)
            if guid and not seenGUIDs[guid] then
                seenGUIDs[guid] = true
                unitByGUID[guid] = unit
                lastSeen[guid] = now
            end
        end
    end

    for guid, unit in pairs(unitByGUID) do
        if not energyValues[guid] then
            energyValues[guid] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
            }
        end

        energyValues[guid].last_tick = energyValues[guid].last_tick + elapsed

        if energyValues[guid].last_tick >= 2.02 and energyValues[guid].startTick then
            energyValues[guid].last_tick = 0
            energyValues[guid].validTick = false
            EnemyOOC:Predict(guid, now)
        end

        if endTime[guid] and endTime[guid] <= now then
            outOfCombatTime[guid] = endTime[guid] + 5
            oocTime[guid] = outOfCombatTime[guid] - now

            for i = 1, #durations do
                if expirationTime[i] and expirationTime[i][guid]
                        and expirationTime[i][guid] >= outOfCombatTime[guid]
                        and m_abs(outOfCombatTime[guid] - expirationTime[i][guid]) <= durations[1] then
                    outOfCombatTime[guid] = expirationTime[i][guid]
                    oocTime[guid] = expirationTime[i][guid] - now
                    break
                end
            end
        end
    end

    EnemyOOC:UpdateText("target", UnitGUID("target"))
end

function EnemyOOC:UNIT_POWER_UPDATE(unit)
    local guid = UnitGUID(unit)
    if not guid or not powerTypes[PowerType(unit)] then
        return
    end

    if not energyValues[guid] then
        energyValues[guid] = {
            last_tick = 0,
            last_value = 0,
            startTick = false,
            validTick = false,
        }
    end

    local energy = UnitPower(unit)
    local energyInc = energy - energyValues[guid].last_value
    local now = GetTime()

    if ((now - externalManaGainTimestamp) <= 0.02) and energyInc == gain then
        externalManaGainTimestamp = 0
        gain = 0
        return
    end

    if ((energyValues[guid].last_value == 0) and (type == "ENERGY" or type == "MANA")) then
        energyValues[guid].last_value = energy
        return
    elseif (type == "RAGE") and not (energyInc == -2 or energyInc == -1 or energyInc == -3) then
        energyValues[guid].last_value = energy
        return
    elseif energyInc == 0 then
        return
    end

    if ((energy > energyValues[guid].last_value) or (type == "RAGE")) and not energyValues[guid].validTick then
        energyValues[guid].startTick = true
        energyValues[guid].last_tick = now
        energyValues[guid].validTick = true
        EnemyOOC:Predict(guid, now)
    end

    energyValues[guid].last_value = energy
end

local function isInCombat(guid)
    local unit = UnitTokenFromGUID(guid)
    if not unit then
        return false
    end

    if guid then
        if UnitAffectingCombat(unit) then
            return true
        end
    end

    return false
end

local eventRegistered = {
    ["SWING_DAMAGE"] = true,
    ["RANGE_DAMAGE"] = true,
    ["SPELL_DAMAGE"] = true,
    ["SWING_MISSED"] = true,
    ["SPELL_MISSED"] = true,
    ["RANGE_MISSED"] = true,
    ["SPELL_PERIODIC_DAMAGE"] = true,
    ["SPELL_PERIODIC_LEECH"] = true,
    ["SPELL_HEAL"] = true,
    ["SPELL_CAST_SUCCESS"] = true,
    ["SPELL_AURA_APPLIED"] = true,
    ["SPELL_AURA_REFRESH"] = true,
    ["SPELL_PERIODIC_ENERGIZE"] = true,
    ["SPELL_ENERGIZE"] = true,
    ["SPELL_DISPEL"] = true,
    ["SPELL_DISPEL_FAILED"] = true,
    ["DAMAGE_SPLIT"] = true,
}

function EnemyOOC:COMBAT_LOG_EVENT_UNFILTERED()
    local _, eventType, _, sourceGUID, _, sourceFlags, _, destGUID, _, destFlags, _, spellID, _, _, amount = CombatLogGetCurrentEventInfo()

    if not (eventRegistered[eventType]) then
        return
    end

    local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)
    local isSourcePlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)
    local isSourceFriend = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS)
    local isDestFriend = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_FRIENDLY_UNITS)
    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
    local isSourceEnemy = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
    local isEnemyPet = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_UNITS)
    local isDestHostile = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_UNITS)
    local isUnknown = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_UNKNOWN_UNITS)

    if (not isDestEnemy and not isSourceEnemy and not isEnemyPet) then
        return
    end

    -- if DestGUID is unknown
    if isSourceEnemy and isUnknown then
        return
    end

    -- Only the CAST_SUCCESS affects combat, unless the spell doesn't fire it (e.g. shiv)
    if eventType == "SPELL_DAMAGE" and isSourceEnemy and not (self.Directdamage[spellID] or self.Nova[spellID]) then
        return
    end

    -- When you dodge/parry/resist etc an attack you drop combat
    if eventType == "SWING_MISSED" and (isDestEnemy or isDestHostile) then
        return
    end

    -- Pet attacks keep the summoner in combat, while some pet cd's do not (mind blowing logic).
    if isEnemyPet then
        if (not self.Pets[spellID] and eventType ~= "SWING_DAMAGE" and eventType ~= "SPELL_HEAL") then
            return
        end
    end

    -- Don't reset timer on throw.
    if ((eventType == "RANGE_DAMAGE" or eventType == "SPELL_CAST_SUCCESS") and isSourceEnemy and (spellID == 2764 or spellID == 3018)) then
        return
    end

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") then
        if isDestEnemy then
            gain = amount
            externalManaGainTimestamp = GetTime()
        end
        return
    end

    --return if enemy heals or dispels out of combat friendly target. Holy Nova/Beacon of Light doesn't keep combat when it heals a friendly (intended?)
    if (eventType == "SPELL_HEAL" or
            eventType == "SPELL_AURA_APPLIED" or
            eventType == "SPELL_CAST_SUCCESS" or
            eventType == "SPELL_AURA_REFRESH") then

        if isSourceEnemy and (isDestEnemy or isDestHostile) then
            if (sourceGUID == destGUID) or self.Nova[spellID] or (spellID == 53653) or not isInCombat(destGUID) then
                return
            end

            if destGUID ~= sourceGUID then
                if isInCombat(destGUID) then
                    self:ResetTimer(sourceGUID)
                    return
                end
            end
        end
    end

    --return if enemy only gets dispelled or buffed by his pet / self
    if ((eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_REFRESH") and ((sourceGUID == destGUID) or isEnemyPet and isDestEnemy)) then
        return
    end

    -- return if periodic damage is not a channeling spell
    if eventType == "SPELL_PERIODIC_DAMAGE" then
        if (spellID ~= nil and not self.Channeling[spellID]) or isSourceEnemy then
            return
        end
    end

    -- E.g. shout spams trigger refresh eventtype
    if eventType == "SPELL_AURA_REFRESH" then
        if (spellID ~= nil and self.Refreshes[spellID]) then
            return
        end
    end

    -- Feral charge (bear) affects only source's combat state.
    if (isDestEnemy or isDestHostile) and spellID == 16979 then
        return
    end

    -- Traps don't affect hunter's combat
    if isSourceEnemy and (spellID == 14301 or spellID == 14315 or spellID == 14309 or spellID == 13810) then
        return
    end

    if (eventType == "SPELL_DISPEL_FAILED" or eventType == "SPELL_DISPEL") and not ((isSourcePlayer and isDestEnemy) or (isSourceEnemy and (isDestPlayer or isDestFriend))) then
        return
    end

    --return if the event is listed in our quirk table
    if ((spellID ~= nil) and (self.Quirks[spellID])) then
        return ;
    end

    --reset
    if isSourceEnemy then
        self:ResetTimer(sourceGUID)
    end
    if isDestEnemy then
        self:ResetTimer(destGUID)
    end
end

function EnemyOOC:UNIT_SPELLCAST_SUCCEEDED(unit, a, b, spellID)
    if not updateUnit[unit] then
        return
    end

    local guid = UnitGUID(unit)
    if not guid then
        return
    end

    -- stealth/vanish fallback
    if spellID == 26889 or spellID == 1784 or spellID == 58984 or spellID == 5215 then
        if running[guid] then
            running[guid] = false
        end
    end

    if spellID == 2764 or spellID == 3018 then
        self:ResetTimer(guid)
    end
end

local failSpellIDs = { [5171] = true, [6774] = true, [48674] = true, [48673] = true, [26679] = true }
function EnemyOOC:UNIT_SPELLCAST_FAILED(unit, a, b, spellID)
    if not updateUnit[unit] then
        return
    end

    -- UNIT_POWER_UPDATE event can be forcefully triggered by this event. We don't want that
    if failSpellIDs[spellID] then
        energyValues[unit].validTick = true
    end
end

function EnemyOOC:PLAYER_ENTERING_WORLD()
    expirationTime = {}
    oocTime = {}
    endTime = {}
    outOfCombatTime = {}
    running = {}
    EnemyOOC.U["target"]:Hide()

    for guid, values in pairs(energyValues) do
        energyValues[guid] = {
            last_tick = 0,
            last_value = 0,
            startTick = false,
            validTick = false,
        }
    end
end

function EnemyOOC:UpdateText(unit, guid)
    if not EnemyOOC.U[unit] then
        return
    end

    if not guid or not powerTypes[PowerType(unit)] or not UnitAffectingCombat(unit) or (UnitGUID(unit) ~= guid) then
        EnemyOOC.U[unit].text:SetAlpha(0)
        if indicator then
            EnemyOOC.U[unit].texture:SetAlpha(0)
        end
        EnemyOOC.U[unit]:Hide()
        return
    end

    local timeLeft = oocTime[guid]

    if timeLeft ~= nil then
        timeLeft = max(0, timeLeft)
        EnemyOOC.U[unit].text:SetText(strformat("%.1f", timeLeft))

        local shouldShow = (timeLeft > 0 and timeLeft < 4) and energyValues[guid] and energyValues[guid].startTick

        if shouldShow then
            EnemyOOC.U[unit].text:SetAlpha(1)
            if indicator then
                EnemyOOC.U[unit].texture:SetAlpha(1)
            end
            EnemyOOC.U[unit]:Show()
        else
            EnemyOOC.U[unit].text:SetAlpha(0)
            if indicator then
                EnemyOOC.U[unit].texture:SetAlpha(0)
            end
            EnemyOOC.U[unit]:Hide()
        end
    else
        EnemyOOC.U[unit].text:SetAlpha(0)
        if indicator then
            EnemyOOC.U[unit].texture:SetAlpha(0)
        end
        EnemyOOC.U[unit]:Hide()
    end
end

EnemyOOC.event = CreateFrame("Frame")
EnemyOOC.event:RegisterEvent("ADDON_LOADED")
EnemyOOC.event:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        if RougeUI.db.EnemyTicks then
            CreateIcon("target", TargetFrame)
            indicator = RougeUI.db.CombatIndicator
            self:RegisterEvent("PLAYER_ENTERING_WORLD")

            EnemyOOC.event:RegisterEvent("PLAYER_TARGET_CHANGED")
            EnemyOOC.event:RegisterEvent("UNIT_POWER_UPDATE")
            EnemyOOC.event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            EnemyOOC.event:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            EnemyOOC.event:RegisterEvent("UNIT_SPELLCAST_FAILED")
            EnemyOOC.event:SetScript("OnUpdate", EnemyOOC.OnUpdate)

            CreateIcon("target", TargetFrame)
            indicator = RougeUI.db.CombatIndicator

            C_Timer.NewTicker(600, function()
                local now = GetTime()
                for guid, timestamp in pairs(lastSeen) do
                    if now - timestamp >= 600 then
                        energyValues[guid] = nil
                        endTime[guid] = nil
                        expirationTime[guid] = nil
                        outOfCombatTime[guid] = nil
                        oocTime[guid] = nil
                        running[guid] = nil
                        lastSeen[guid] = nil
                    end
                end
            end)
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        local unit = "target"
        local guid = UnitGUID(unit)
        if guid and energyValues[guid] then
            EnemyOOC:UpdateText(unit, guid)
        else
            if EnemyOOC.U[unit] then
                EnemyOOC.U[unit].text:SetAlpha(0)
                if indicator then
                    EnemyOOC.U[unit].texture:SetAlpha(0)
                end
                EnemyOOC.U[unit]:Hide()
            end
        end
    else
        if EnemyOOC[event] then
            EnemyOOC[event](EnemyOOC, ...)
        end
    end
end)
