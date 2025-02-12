local addonName, RougeUI = ...
local EnemyOOC = {}
EnemyOOC.U = {}
local UnitPowerType, UnitPower, UnitAffectingCombat = _G.UnitPowerType, _G.UnitPower, _G.UnitAffectingCombat
local UnitCanAttack, UnitIsUnit, UnitGUID, UnitExists = _G.UnitCanAttack, _G.UnitIsUnit, _G.UnitGUID, _G.UnitExists
local inArena = false
local externalManaGainTimestamp = 0
local gain = 0
local dur = 2.02
local endTime = {}
local durations = { [1] = dur, [2] = dur * 2, [3] = dur * 3, [4] = dur * 4, [5] = dur * 5 }
local expirationTime = {}
local oocTime = {}
local outOfCombatTime = {}
local running = {}
local m_abs, ipairs, pairs = math.abs, ipairs, pairs
local UnitDetailedThreatSituation, UnitIsPlayer = _G.UnitDetailedThreatSituation, _G.UnitIsPlayer
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local COMBATLOG_FILTER_HOSTILE_PLAYERS = _G.COMBATLOG_FILTER_HOSTILE_PLAYERS;
local COMBATLOG_FILTER_ME = _G.COMBATLOG_FILTER_ME
local COMBATLOG_FILTER_FRIENDLY_UNITS = _G.COMBATLOG_FILTER_FRIENDLY_UNITS
local COMBATLOG_FILTER_HOSTILE_UNITS = _G.COMBATLOG_FILTER_HOSTILE_UNITS
local COMBATLOG_FILTER_UNKNOWN_UNITS = _G.COMBATLOG_FILTER_UNKNOWN_UNITS
local CombatLog_Object_IsA = _G.CombatLog_Object_IsA
local indicator

local updateUnit = {
    ["arena1"] = true,
    ["arena2"] = true,
    ["arena3"] = true,
    ["arena4"] = true,
    ["arena5"] = true
}

local powerTypes = { [0] = true, [3] = true, [1] = true, [6] = true, [2] = true }

local energyValues = {
    arena1 = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
    arena2 = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
    arena3 = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
    arena4 = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
    arena5 = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
}

EnemyOOC.Quirks = {
    [6774] = true,	-- Slice and Dice (R2)
    [26669] = true, -- Evasion (R2)
    [31224] = true, -- Cloak of Shadows
    [11305] = true, -- Sprint (R3)
    [36554] = true, -- Shadowstep
    [14185] = true, -- Preparation
    [31230] = true, -- Cheat Death
    [13877] = true, -- Blade Flurry
    [13750] = true, -- Adrenaline Rush
    [14183] = true, -- Premeditation
    [14177] = true, -- Cold Blood
    [7744] = true, -- Will of the forsaken
    [20600] = true, -- Perception
    [20594] = true, -- Stoneform
    [20554] = true, -- Berserking
    [20572] = true, -- Blood Fury
    [31047] = true, -- Nightseye panther trinket
    [43716] = true, -- Berserker's call trinket
    [46784] = true, -- Shadowsong panther trinket
    [35166] = true, -- Bloodlust brooch trinket
    [51955] = true, -- Direbrew trinket
    [28093] = true, -- Lightning Speed
    [768] = true, -- Cat Form
    [783] = true, -- Travel Form
    [9634] = true, -- Dire Bear Form
    [5229] = true, -- Enrage
    [33357] = true, -- Dash
    [26999] = true, -- Frenzied Regen
    [9846] = true, -- Tiger's Fury
    [22812] = true, -- Barkskin
    [27045] = true, -- Aspect of the Wild
    [27044] = true, -- Aspect of the Hawk
    [34074] = true, -- Aspect of the Viper
    [13159] = true, -- Aspect of the Pack
    [13161] = true, -- Aspect of the Beast
    [5118] = true, -- Aspect of the Cheetah
    [13163] = true, -- Aspect of the Monkey
    [1002] = true, -- Eyes of the Beast
    [6197] = true, -- Eagle Eye
    [2641] = true, -- Dismiss Pet
    [883] = true, -- Call Pet
    [27046] = true, -- Mend Pet
    [34477] = true, -- Misdirection
    [5384] = true, -- Feign Death
    [13809] = true, -- Frost Trap
    [34600] = true, -- Snake Trap
    [27023] = true, -- Immolation trap
    [27025] = true, -- Explosive trap
    [14311] = true, -- Freezing trap
    [19880] = true, -- Track elementals
    [19885] = true, -- Track hidden
    [19884] = true, -- Track undead
    [19883] = true, -- Track humanoids
    [27125] = true, -- Mage Armor
    [66] = true, -- Invisibility
    [30482] = true, -- Molten Armor
    [27128] = true, -- Fire Ward
    [32796] = true, -- Frost Ward
    [27124] = true, -- Ice Armor
    [45438] = true, -- Ice Block
    [12043] = true, -- Presence of Mind
    [12042] = true, -- Arcane Power
    [11129] = true, -- Combustion
    [12472] = true, -- Icy Veins
    [31687] = true, -- Summon Water Ele
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
    [30302] = true, -- Nether protection
    [34939] = true, -- Backlash
    [12292] = true, -- Death Wish
    [30033] = true, -- Rampage
    [29838] = true, -- Second Wind
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
    [27260] = true, -- Demon armor
    [28189] = true, -- Fel Armor
    [28610] = true, -- Shadow Ward
    [2645] = true, -- Ghost Wolf
    [36936] = true, -- Totemic Recall
    [25485] = true, -- Rockbiter wep
    [25505] = true, -- WF wep
    [25500] = true, -- Frostbrand wep
    [25489] = true, -- Flametongue wep
    [31884] = true, -- Avenging Wrath
    [27153] = true, -- Fire resist aura
    [27149] = true, -- Devotion aura
    [32223] = true, -- Crusader aura
    [27152] = true, -- Frost resist aura
    [27150] = true, -- Retribution aura
    [27151] = true, -- Shadow resist aura
    [19746] = true, -- Concentration aura
    [14325] = true, -- Hunter's Mark
    [1130] = true, -- Hunter's Mark
    [14324] = true, -- Hunter's Mark
    [14323] = true, -- Hunter's Mark
    [31615] = true, -- Hunter's Mark
    [38067] = true, -- Guard's Mark
    [1543] = true, -- Flare
    [45334] = true, --  Feral charge effect
    [29858] = true, -- Soulshatter
    [10909] = true, -- Mind Vision
    [45468] = true, -- Mind Vision
    [453] = true, -- Mind Soothe
    [10953] = true, -- Mind Soothe
    [8192] = true, -- Mind Soothe
    [25596] = true, -- Mind Soothe
    [5138] = true, -- Drain Mana r1
    [6226] = true, -- Drain Mana r2
    [11703] = true, -- Drain Mana r3
    [11704] = true, -- Drain Mana r4
    [27221] = true, -- Drain Mana r5
    [30908] = true, -- Drain Mana r6
    [2855] = true -- Detect Magic
};

EnemyOOC.Channeling = {
    [689] = true, -- Drain life r1
    [699] = true, -- Drain life r2
    [709] = true, -- Drain life r3
    [7651] = true, -- Drain life r4
    [11699] = true, -- Drain life r5
    [11700] = true, -- Drain life r6
    [27219] = true, -- Drain life r7
    [27220] = true, -- Drain life r8
    [1120] = true, -- Drain soul r1
    [8288] = true, -- Drain soul r2
    [8289] = true, -- Drain soul r3
    [11675] = true, -- Drain soul r4
    [27217] = true, -- Drain soul r5
    [15407] = true, -- Mind flay r1
    [17311] = true, -- Mind flay r2
    [17312] = true, -- Mind flay r3
    [17313] = true, -- Mind flay r4
    [17314] = true, -- Mind flay r5
    [18807] = true, -- Mind flay r6
    [25387] = true, -- Mind flay r7
    [26573] = true, -- Consecration r1
    [20116] = true, -- Consecration r2
    [20922] = true, -- Consecration r3
    [20923] = true, -- Consecration r4
    [20924] = true, -- Consecration r5
    [27173] = true, -- Consecration r6
    [2120] = true, -- Flamestrike r1
    [2121] = true, -- Flamestrike r2
    [8422] = true, -- Flamestrike r3
    [8423] = true, -- Flamestrike r4
    [10215] = true, -- Flamestrike r5
    [10216] = true, -- Flamestrike r6
    [27086] = true -- Flamestrike r7
};

EnemyOOC.Nova = {
    [15237] = true, -- r1
    [15430] = true, -- r2
    [15431] = true, -- r3
    [27799] = true, -- r4
    [27800] = true, -- r5
    [27801] = true, -- r6
    [25331] = true, -- r7
    [23455] = true,
    [25331] = true,
    [23458] = true,
    [23459] = true,
    [27803] = true,
    [27804] = true,
    [27805] = true,
    [25329] = true
};

EnemyOOC.Pets = {
    [33395] = true, -- Freeze
    [54053] = true, -- Shadow Bite
    [47992] = true, -- Lash of Pain
    [47995] = true, -- Intercept
    [47994] = true, -- Cleave
    [3606] = true, -- Searing Totem r1
    [6350] = true, -- Searing Totem r2
    [6351] = true, -- Searing Totem r3
    [6352] = true, -- Searing Totem r4
    [10435] = true, -- Searing Totem r5
    [10436] = true, -- Searing Totem r6
    [25530] = true, -- Searing Totem r7
    [8187] = true, -- Magma Totem r1
    [10579] = true, -- Magma Totem r2
    [10580] = true, -- Magma Totem r3
    [10581] = true, -- Magma Totem r4
    [25550] = true, -- Magma Totem r5
};

-- This list is for spells that we need to track because they either fire no cast_success (or have an unknown destguid)
EnemyOOC.Directdamage = {
    [42208] = true, -- Blizzard r1
    [42223] = true, -- Rain of fire r1
    [47666] = true, -- Penance r1
    [49821] = true, -- Mind Sear r1
    [32645] = true, -- Envenom r1
    [5940] = true, -- Shiv
    [57841] = true, -- Killing Spree
    [57842] = true, -- Killing Spree
    [51723] = true, -- Fan of Knives
    [50782] = true, -- Slam
    [42231] = true, -- Hurricane r1
    [5857] = true, -- Hellfire effect r1
    [52212] = true, -- Death and decay (bug)
    [53385] = true, -- Divine Storm
    [2812] = true, -- Holy Wrath r1
    [1449] = true, -- Arcane Explosion r1
    [48721] = true, -- Blood boil r1
    [50288] = true, -- Starfall r1
    [122] = true, -- Frost nova r1
    [120] = true, -- Cone of cold r1
    [31661] = true, -- Dragon's breath r1
    [47897] = true, -- Shadowflame r1
    [46968] = true, -- Shockwave
    [61391] = true, -- Typhoon r1
    [51490] = true, -- Thunderstorm
    [11113] = true, -- Blast Wave r1
    [44461] = true, -- Living Bomb r1 (the proc resets combat)
    [7268] = true, -- Arcane Missiles r1
    [50622] = true, -- Bladestorm (whirlwind)
    [1680] = true, -- Whirlwind
    [6343] = true, -- Thunder clap r1
    [8349] = true, -- Fire nova
    [77478] = true, -- Earthquake
    [82739] = true, -- Flame orb
    [84721] = true, -- Frostfire Orb
};

EnemyOOC.Refreshes = {
    [3600] = true, -- Eartbind totem

}

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

local function IsInArena()
    local _, instanceType = IsInInstance()
    if instanceType == "arena" then
        return true
    else
        return false
    end
end

local function PowerType(unit)
    return UnitPowerType(unit)
end

function EnemyOOC:StartTimer(unit)
    local guid = UnitGUID(unit)

    self:ResetTimer(guid)

    if UnitIsUnit(unit, "target") then
        EnemyOOC.U["target"]:Show()
    end

    if UnitIsUnit(unit, "focus") then
        EnemyOOC.U["focus"]:Show()
    end
end

function EnemyOOC:StopTimer(unit)
    if UnitIsUnit(unit, "target") then
        EnemyOOC.U["target"]:Hide()
    end

    if UnitIsUnit(unit, "focus") then
        EnemyOOC.U["focus"]:Hide()
    end
end

function EnemyOOC:ResetTimer(guid)
    for unit in pairs(updateUnit) do
        if UnitGUID(unit) == guid then
            endTime[guid] = GetTime()
            break
        end
    end
end

function EnemyOOC:UNIT_FLAGS(unit)
    if not updateUnit[unit] then
        return
    end

    if UnitAffectingCombat(unit) then
        if not running[unit] then
            self:StartTimer(unit)
            running[unit] = true
        end
    else
        self:StopTimer(unit)
        running[unit] = false
        energyValues[unit].last_tick = GetTime()
        if UnitPower(unit) == 0 then
            energyValues[unit].startTick = true
        end
        -- if not powerTypes[PowerType(unit)] then
        -- self:Predict(unit, GetTime())
        -- energyValues[unit].startTick = true
        -- end
    end
end

function EnemyOOC:Predict(unit, now)
    for i = 1, #durations do
        if not expirationTime[i] then
            expirationTime[i] = {}
        end
        expirationTime[i][unit] = now + durations[i]
    end
end

function EnemyOOC.OnUpdate(self, elapsed)
    for unit in pairs(updateUnit) do
        if powerTypes[PowerType(unit)] and UnitExists(unit) then
            -- xx

            local now = GetTime()

            energyValues[unit].last_tick = energyValues[unit].last_tick + elapsed

            if (energyValues[unit].last_tick >= 2.02) and energyValues[unit].startTick then
                energyValues[unit].last_tick = 0
                energyValues[unit].validTick = false
                EnemyOOC:Predict(unit, now)
            end

            local guid = UnitGUID(unit)
            if endTime[guid] and (endTime[guid] <= now) then
                outOfCombatTime[unit] = endTime[guid] + 5
                oocTime[unit] = outOfCombatTime[unit] - now
                for i = 1, #durations do
                    if expirationTime[i] and expirationTime[i][unit] and expirationTime[i][unit] >= outOfCombatTime[unit] and
                            m_abs(outOfCombatTime[unit] - expirationTime[i][unit]) <= dur then
                        outOfCombatTime[unit] = expirationTime[i][unit]
                        oocTime[unit] = expirationTime[i][unit] - now
                        break
                    end
                end
            end

            if oocTime[unit] ~= nil and UnitAffectingCombat(unit) then
                if UnitIsUnit("target", unit) then
                    EnemyOOC:UpdateText("target")
                end
                if UnitIsUnit("focus", unit) then
                    EnemyOOC:UpdateText("focus")
                end
            end
        end
    end
end

function EnemyOOC:UNIT_POWER_UPDATE(unit, type)
    if not energyValues[unit] or not powerTypes[PowerType(unit)] then
        return
    end

    local energy = UnitPower(unit)
    local energyInc = energy - energyValues[unit].last_value
    local now = GetTime()

    if ((now - externalManaGainTimestamp) <= 0.02) and energyInc == gain then
        externalManaGainTimestamp = 0
        gain = 0
        return
    end

    if ((energyValues[unit].last_value == 0) and (type == "ENERGY" or type == "MANA" or type == "FOCUS")) then
        energyValues[unit].last_value = energy
        return
    elseif (type == "RAGE" or type == "RUNIC_POWER") and not (energyInc == -2 or energyInc == -1 or energyInc == -3) then
        energyValues[unit].last_value = energy
        return
    elseif energyInc == 0 then
        return
    end

    if ((energy > energyValues[unit].last_value) or (type == "RAGE" or type == "RUNIC_POWER")) and not energyValues[unit].validTick then
        --print(type, energy > energyValues[unit].last_value, unit, energyInc)
        energyValues[unit].startTick = true
        energyValues[unit].last_tick = now
        energyValues[unit].validTick = true
        EnemyOOC:Predict(unit, now)
    end

    energyValues[unit].last_value = energy
end

local Unitids = { "arena1", "arena2", "arena3", "arena4", "arena5", "arenapet1", "arenapet2", "arenapet3", "arenapet4", "arenapet5" }
local function isInCombat(guid)
    for _, unit in ipairs(Unitids) do
        if UnitGUID(unit) == guid and UnitAffectingCombat(unit) then
            return true
        end
    end
    return false
end

local function PetOwner(guid)
    local owner
    for i = 1, 5 do
        if UnitExists("arena" .. i) and UnitExists("arenapet" .. i) then
            if guid == UnitGUID("arenapet" .. i) then
                owner = UnitGUID("arena" .. i)
                break
            end
        end
    end
    return owner
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

local skip = {}
function EnemyOOC:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, _, sourceGUID, _, sourceFlags, _, destGUID, _, destFlags, _, spellID, _, _, amount = CombatLogGetCurrentEventInfo()

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
    local GuardianPet = bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0 and isEnemyPet

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
    if eventType == "SWING_MISSED" and (isDestEnemy or isDestHostile) and (spellID ~= "ABSORB") then
        return
    end

    if isEnemyPet then
        if GuardianPet or (not self.Pets[spellID] and eventType ~= "SWING_DAMAGE" and eventType ~= "SPELL_HEAL") then
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
        if not (isSourcePlayer or isSourceFriend) and not isDestEnemy or ((spellID ~= nil) and self.Refreshes[spellID]) then
            return
        end
    end

    -- Helfire doesn't put combat nor keeps combat
    if (isSourceEnemy and (spellID == 5857 or spellID == 11681 or spellID == 27214 or spellID == 11684)) then
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
    if isEnemyPet then
        self:ResetTimer(PetOwner(sourceGUID))
    end
end

function EnemyOOC:UNIT_SPELLCAST_SUCCEEDED(unit, a, b, spellID)
    if not updateUnit[unit] then
        return
    end

    -- stealth/vanish fallback
    if spellID == 26889 or spellID == 1784 or spellID == 58984 or spellID == 5215 then
        if running[unit] then
            running[unit] = false
        end
    end

    if spellID == 2764 or spellID == 3018 then
        local guid = UnitGUID(unit)
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
    inArena = IsInArena()

    if inArena then
        for unit, values in pairs(energyValues) do
            energyValues[unit] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
            }
        end
        EnemyOOC.event:RegisterEvent("PLAYER_TARGET_CHANGED")
        EnemyOOC.event:RegisterEvent("PLAYER_FOCUS_CHANGED")
        EnemyOOC.event:RegisterEvent("UNIT_POWER_UPDATE")
        EnemyOOC.event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        EnemyOOC.event:RegisterEvent("UNIT_FLAGS")
        EnemyOOC.event:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        EnemyOOC.event:RegisterEvent("UNIT_SPELLCAST_FAILED")
        EnemyOOC.event:SetScript("OnUpdate", EnemyOOC.OnUpdate)
    else
        EnemyOOC.event:UnregisterEvent("PLAYER_TARGET_CHANGED")
        EnemyOOC.event:UnregisterEvent("PLAYER_FOCUS_CHANGED")
        EnemyOOC.event:UnregisterEvent("UNIT_POWER_UPDATE")
        EnemyOOC.event:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        EnemyOOC.event:UnregisterEvent("UNIT_FLAGS")
        EnemyOOC.event:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        EnemyOOC.event:UnregisterEvent("UNIT_SPELLCAST_FAILED")
        EnemyOOC.event:SetScript("OnUpdate", nil)
        expirationTime = {}
        oocTime = {}
        endTime = {}
        outOfCombatTime = {}
        running = {}
        skip = {}
        EnemyOOC.U["target"]:Hide()
        EnemyOOC.U["focus"]:Hide()
    end
end

function EnemyOOC:UpdateText(unit)
    if not EnemyOOC.U[unit] then
        return
    end

    if not powerTypes[PowerType(unit)] then
        -- xx
        EnemyOOC.U[unit].text:SetAlpha(0)
        if indicator then
            EnemyOOC.U[unit].texture:SetAlpha(0)
        end
    end

    for i = 1, 5, 1 do
        if UnitIsUnit(unit, "arena" .. i) and (oocTime["arena" .. i] ~= nil) then
            EnemyOOC.U[unit].text:SetText(string.format("%.1f", oocTime["arena" .. i] >= 0 and oocTime["arena" .. i] or 0))
            if (oocTime["arena" .. i] > 0 and oocTime["arena" .. i] < 4) and not (UnitDetailedThreatSituation("player", "arenapet" .. i) or
                    UnitDetailedThreatSituation("party" .. i, "arenapet" .. i)) and energyValues["arena" .. i].startTick then
                EnemyOOC.U[unit].text:SetAlpha(1)
                if indicator then
                    EnemyOOC.U[unit].texture:SetAlpha(1)
                end
            else
                EnemyOOC.U[unit].text:SetAlpha(0)
                if indicator then
                    EnemyOOC.U[unit].texture:SetAlpha(0)
                end
            end
        end
    end
end

EnemyOOC.event = CreateFrame("Frame")
EnemyOOC.event:RegisterEvent("ADDON_LOADED")
EnemyOOC.event:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        if RougeUI.db.EnemyTicks then
            CreateIcon("target", TargetFrame)
            CreateIcon("focus", FocusFrame)
            indicator = RougeUI.db.CombatIndicator
            self:RegisterEvent("PLAYER_ENTERING_WORLD")
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        if powerTypes[PowerType("target")] and UnitAffectingCombat("target") and UnitCanAttack("player", "target") and UnitIsPlayer("target") then
            -- xx
            EnemyOOC:UpdateText("target")
            EnemyOOC.U["target"].text:SetAlpha(1)
            if indicator then
                EnemyOOC.U["target"].texture:SetAlpha(1)
            end
            if not EnemyOOC.U["target"]:IsShown() then
                EnemyOOC.U["target"]:Show()
            end
        else
            EnemyOOC.U["target"].text:SetAlpha(0)
            if indicator then
                EnemyOOC.U["target"].texture:SetAlpha(0)
            end
        end
    elseif event == "PLAYER_FOCUS_CHANGED" then
        if powerTypes[PowerType("focus")] and UnitAffectingCombat("focus") and UnitCanAttack("player", "focus") and UnitIsPlayer("focus") then
            -- xx
            EnemyOOC:UpdateText("focus")
            EnemyOOC.U["focus"].text:SetAlpha(1)
            if indicator then
                EnemyOOC.U["focus"].texture:SetAlpha(1)
            end
            if not EnemyOOC.U["focus"]:IsShown() then
                EnemyOOC.U["focus"]:Show()
            end
        else
            EnemyOOC.U["focus"].text:SetAlpha(0)
            if indicator then
                EnemyOOC.U["focus"].texture:SetAlpha(0)
            end
        end
    else
        if EnemyOOC[event] then
            EnemyOOC[event](EnemyOOC, ...)
        end
    end
end)

