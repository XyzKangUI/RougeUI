local _, RougeUI = ...
local pairs, GetManaRegen, m_abs = _G.pairs, _G.GetManaRegen, math.abs
local UnitExists, UnitIsUnit, UnitIsEnemy = _G.UnitExists, _G.UnitIsUnit, _G.UnitIsEnemy
local UnitPower, UnitIsPlayer = _G.UnitPower, _G.UnitIsPlayer
local PlayerFrameManaBar, TargetFrameManaBar = _G.PlayerFrameManaBar, _G.TargetFrameManaBar
local eventRegistered = { ["SPELL_PERIODIC_ENERGIZE"] = true, ["SPELL_ENERGIZE"] = true, ["SPELL_CAST_SUCCESS"] = true }
local energyValues = {}
local possibleFSR

local ignoreTicks = {
    [10] = true,
    [4] = true,
    [6] = true,
    [8] = true,
    [25] = true,
    [33] = true,
    [25] = true,
    [30] = true,
    [15] = true,
    [20] = true,
}

local function AddEnergy(frame)
    if not frame.energy then
        frame.energy = CreateFrame("Statusbar", nil, frame)
        frame.energy.spark = frame.energy:CreateTexture(nil, "OVERLAY")
        frame.energy.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        frame.energy.spark:SetSize(24, 24)
        frame.energy.spark:SetPoint("CENTER", frame, 0, 0)
        frame.energy.spark:SetBlendMode("ADD")
        frame.energy.spark:SetAlpha(0)
    end
end

local function SetEnergyValue(self, value, tickRate)
    local x = self:GetWidth()
    local position
    if tickRate and tickRate > 2.02 then
        position = x - ((x * value) / tickRate)
    else
        position = ((x * value) / 2.02)
    end

    if (position < x) then
        self.energy.spark:Show()
        self.energy.spark:SetPoint("CENTER", self, "LEFT", position, 0)
    end
end

local function OnUpdate(self, elapsed)
    for unit in pairs(energyValues) do
        if UnitExists(unit) and (UnitIsEnemy("player", unit) or unit == "player") and UnitIsPlayer(unit) then

            energyValues[unit].last_tick = energyValues[unit].last_tick + elapsed

            if (energyValues[unit].last_tick >= energyValues[unit].tickRate) and energyValues[unit].startTick then
                energyValues[unit].last_tick = 0
                energyValues[unit].validTick = false
                if unit == "player" and energyValues["player"].tickRate ~= 2.02 then
                    energyValues["player"].tickRate = 2.02
                    possibleFSR = false
                end
                if UnitIsUnit(unit, "target") and not (unit == "player" or unit == "target") then
                    energyValues.target.last_tick = energyValues[unit].last_tick
                    energyValues.target.startTick = energyValues[unit].startTick
                end
            end

            if unit == "player" then
                SetEnergyValue(PlayerFrameManaBar, energyValues["player"].last_tick, energyValues["player"].tickRate)
            elseif (unit ~= "player") then
                if not UnitExists("playertarget") or UnitIsUnit(unit, "target") then
                    energyValues.target.last_tick = energyValues[unit].last_tick
                    energyValues.target.startTick = energyValues[unit].startTick
                end
                SetEnergyValue(TargetFrameManaBar, energyValues[unit].last_tick)
            end
        end
    end
end

local function UpdateEnergy(unit, powerType)
    if not energyValues[unit] or not (powerType == "ENERGY" or powerType == "RAGE" or powerType == "MANA") then
        return
    end

    local energy = UnitPower(unit)
    local energyInc = energy - energyValues[unit].last_value
    local now = GetTime()
    local guid = UnitGUID(unit)
    local externalTick = energyValues[guid] and energyValues[guid].externalTick or 0
    local gain = energyValues[guid] and energyValues[guid].externalGain or 0

    -- Energized Ticks (sometimes doesn't work as expected)
    if ((now - externalTick) <= 0.1) and energyInc == gain then
        energyValues[unit].last_value = energy
        return
    end

    if (energyValues[unit].last_value == 0) then
        energyValues[unit].last_value = energy
        return
    elseif energyInc == 0 then
        return
    end

    local increment
    if powerType == "ENERGY" then
        increment = (energy == energyValues[unit].last_value + 20 or
                energy == energyValues[unit].last_value + 21 or
                energy == energyValues[unit].last_value + 40 or energy == energyValues[unit].last_value + 41)
    elseif powerType == "RAGE" and not UnitAffectingCombat(unit) then
        increment = (energyInc == -2 or energyInc == -1 or energyInc == -3)
    elseif powerType == "MANA" then
        if ignoreTicks[energyInc] then
            increment = false
        end

        if unit == "player" then
            local base, casting = GetManaRegen()
            local tick = base * 2
            if AuraUtil.FindAuraByName(GetSpellInfo(1137), "player") or (energyInc > 2) and (energy > energyValues[unit].last_value) and (m_abs(energyInc - tick) < 1) then
                increment = true
                possibleFSR = false
            else
                increment = false
                if (energy < energyValues[unit].last_value) and not possibleFSR and (casting < 0.05) then
                    possibleFSR = true
                end
            end
        else
            -- Ignore these ticks (hope it ain't disruptive)
            local percentageGain = math.floor((energyInc / UnitPowerMax(unit)) * 100)
            if percentageGain == 5 or percentageGain == 10 or percentageGain == 6 then
                increment = false
            else
                increment = (energy > energyValues[unit].last_value)
            end
        end
    end

    if increment and not energyValues[unit].validTick then
        possibleFSR = false
        energyValues[unit].startTick = true
        energyValues[unit].validTick = true
        energyValues[unit].last_tick = 0
        energyValues[unit].tickRate = 2.02
        if unit == "player" and (PlayerFrameManaBar.energy.spark:GetAlpha() < 1) then
            PlayerFrameManaBar.energy.spark:SetAlpha(1)
        elseif UnitIsUnit("target", unit) and (unit ~= "player") and (TargetFrameManaBar.energy.spark:GetAlpha() < 1) then
            TargetFrameManaBar.energy.spark:SetAlpha(1)
        end
    end

    energyValues[unit].last_value = energy
end

local function RealTick()
    local _, eventType, _, _, _, sourceFlags, _, destGUID, _, destFlags, _, spellID, _, _, amount = CombatLogGetCurrentEventInfo()

    if not (eventRegistered[eventType]) then
        return
    end

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
    local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)
    local isSourcePlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") and (isDestEnemy or (isDestPlayer and isSourcePlayer)) then
        if energyValues[destGUID] == nil then
            energyValues[destGUID] = {}
        end

        energyValues[destGUID].externalTick = GetTime()
        energyValues[destGUID].externalGain = amount
        return
    end

    if eventType == "SPELL_CAST_SUCCESS" and isSourcePlayer and spellID == 13750 then
        energyValues["player"].last_tick = 0
        return
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("UNIT_POWER_UPDATE")
e:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
e:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not RougeUI.db.EnergyTicker and not RougeUI.db.EnemyTicker then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            return
        end

        if UnitPowerType("player") ~= 0 then
            self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        end

        if RougeUI.db.EnergyTicker then
            AddEnergy(PlayerFrameManaBar)
            energyValues["player"] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
                tickRate = 2.02,
            }

            local _, class = UnitClass("player")
            if UnitPowerType("player") ~= 0 and class ~= "DRUID" then
                self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            end

            if class == "DRUID" then
                self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
            end
        end
        if RougeUI.db.EnemyTicker then
            AddEnergy(TargetFrameManaBar)
            energyValues["target"] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
                tickRate = 2.02,
            }

            for i = 1, 10 do
                energyValues["nameplate" .. i] = {
                    last_tick = 0,
                    last_value = 0,
                    startTick = false,
                    validTick = false,
                    tickRate = 2.02,
                }
            end

            self:RegisterEvent("PLAYER_TARGET_CHANGED")
            self:RegisterEvent("PLAYER_ENTERING_WORLD")
        end
        self:SetScript("OnUpdate", OnUpdate)
    elseif event == "PLAYER_ENTERING_WORLD" then
        for unit in pairs(energyValues) do
            energyValues[unit] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
                tickRate = 2.02,
            }
        end
    elseif event == "UNIT_POWER_UPDATE" then
        local unit = ...
        if energyValues[unit] and ((UnitIsEnemy("player", unit) and UnitIsPlayer(unit)) or unit == "player") then
            UpdateEnergy(...)
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        RealTick()
    elseif event == "PLAYER_TARGET_CHANGED" then
        if not UnitIsPlayer("target")
                or not UnitIsEnemy("player", "target") or not energyValues.target.startTick then
            TargetFrameManaBar.energy.spark:SetAlpha(0)
            C_Timer.After(0.1, function()
                if energyValues.target.startTick and UnitIsPlayer("target")
                        and UnitIsEnemy("player", "target") then
                    TargetFrameManaBar.energy.spark:SetAlpha(1)
                end
            end)
        else
            TargetFrameManaBar.energy.spark:SetAlpha(1)
        end
    elseif event == "UPDATE_SHAPESHIFT_FORM" then
        if (UnitPowerType("player") == 1) then
            PlayerFrameManaBar.energy.spark:SetAlpha(0)
        else
            PlayerFrameManaBar.energy.spark:SetAlpha(1)
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local _, _, spellId = ...

        if not possibleFSR then
            return
        end

        if IsPlayerSpell(spellId) or IsSpellKnownOrOverridesKnown(spellId) then
            local now = GetTime()
            local channeling, _, _, startTime, endTime = UnitChannelInfo("player")
            local channelTime = channeling and ((endTime - startTime) / 1000) or 0
            local rate = (6.06 - (now - (now - energyValues["player"].last_tick)) % 2.02)
            energyValues["player"].tickRate = rate >= 5 and rate or rate + 2.02
            -- TODO: More research on how channeling vs rate interacts
            if channeling and channelTime > rate then
                energyValues["player"].tickRate = energyValues["player"].tickRate + 2.02
            end
            energyValues["player"].last_tick = 0
            energyValues["player"].startTick = true
            energyValues["player"].validTick = false
        end
    end
end)