local _, RougeUI = ...
local UnitPowerType = _G.UnitPowerType
local pairs = _G.pairs
local UnitExists, UnitIsUnit, UnitIsEnemy = _G.UnitExists, _G.UnitIsUnit, _G.UnitIsEnemy
local UnitPower, UnitIsPlayer = _G.UnitPower, _G.UnitIsPlayer
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local COMBATLOG_FILTER_HOSTILE_PLAYERS, COMBATLOG_FILTER_ME = _G.COMBATLOG_FILTER_HOSTILE_PLAYERS, _G.COMBATLOG_FILTER_ME
local CombatLog_Object_IsA = _G.CombatLog_Object_IsA
local PlayerFrameManaBar, TargetFrameManaBar = _G.PlayerFrameManaBar, _G.TargetFrameManaBar
local externalManaGainTimestamp = 0
local gain = 0

local eventRegistered = { ["SPELL_PERIODIC_ENERGIZE"] = true, ["SPELL_ENERGIZE"] = true, ["SPELL_CAST_SUCCESS"] = true }
local powerTypes = { [0] = true, [3] = true }
local energyValues = {}

local function PowerType(unit)
    return UnitPowerType(unit)
end

local function SetEnergyValue(self, value)
    local x = self:GetWidth()
    local position = ((x * value) / 2.02)

    if (position < x) then
        self.energy.spark:Show()
        self.energy.spark:SetPoint("CENTER", self, "LEFT", position, 0)
    end
end

local function OnUpdate(self, elapsed)
    for unit in pairs(energyValues) do
        if powerTypes[PowerType(unit)] and UnitExists(unit) and (UnitIsEnemy("player", unit) or unit == "player") and UnitIsPlayer(unit) then

            energyValues[unit].last_tick = energyValues[unit].last_tick + elapsed

            if (energyValues[unit].last_tick >= 2.02) and energyValues[unit].startTick then
                energyValues[unit].last_tick = 0
                energyValues[unit].validTick = false
                if UnitIsUnit(unit, "target") and not (unit == "player" or unit == "target") then
                    energyValues.target.last_tick = energyValues[unit].last_tick
                    energyValues.target.startTick = energyValues[unit].startTick
                end
            end

            if unit == "player" then
                SetEnergyValue(PlayerFrameManaBar, energyValues[unit].last_tick)
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
    if not energyValues[unit] or not powerTypes[PowerType(unit)] then
        return
    end

    local now = GetTime()
    local energy = UnitPower(unit)
    local energyInc = energy - energyValues[unit].last_value

    if ((now - externalManaGainTimestamp) <= 0.02) and energyInc == gain then
        externalManaGainTimestamp = 0
        gain = 0
        return
    end

    if (energyValues[unit].last_value == 0) then
        energyValues[unit].last_value = energy
        return
    elseif energyInc == 0 then
        return
    end

    local increment = (energy > energyValues[unit].last_value)
    if powerType == "ENERGY" then
        increment = (energy == energyValues[unit].last_value + 20 or
                energy == energyValues[unit].last_value + 21 or
                energy == energyValues[unit].last_value + 40 or energy == energyValues[unit].last_value + 41)
    end

    if increment and not energyValues[unit].validTick then
        energyValues[unit].startTick = true
        energyValues[unit].last_tick = now
        energyValues[unit].validTick = true
        if unit == "player" and (PlayerFrameManaBar.energy.spark:GetAlpha() < 1) then
            PlayerFrameManaBar.energy.spark:SetAlpha(1)
        elseif UnitIsUnit("target", unit) and (unit ~= "player") and (TargetFrameManaBar.energy.spark:GetAlpha() < 1) then
            TargetFrameManaBar.energy.spark:SetAlpha(1)
        end
    end

    energyValues[unit].last_value = energy
end

local function AddEnergy(frame)
    if not frame.energy then
        frame.energy = CreateFrame("Statusbar", nil, frame)
        frame.energy.spark = frame.energy:CreateTexture(nil, "OVERLAY")
        frame.energy.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        frame.energy.spark:SetSize(28, 28)
        frame.energy.spark:SetPoint("CENTER", frame, 0, 0)
        frame.energy.spark:SetBlendMode("ADD")
        frame.energy.spark:SetAlpha(0)
    end
end

local function RealTick()
    local _, eventType, _, _, _, sourceFlags, _, _, _, destFlags, _, spellID, _, _, amount = CombatLogGetCurrentEventInfo()

    if not (eventRegistered[eventType]) then
        return
    end

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
    local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)
    local isSourcePlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)
    local now = GetTime()

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") and (isDestEnemy or (isDestPlayer and isSourcePlayer)) then
        gain = amount
        externalManaGainTimestamp = now
        return
    end

    if eventType == "SPELL_CAST_SUCCESS" and isSourcePlayer and spellID == 13750 then
        energyValues["player"].last_tick = now
        return
    end
end


local e = CreateFrame("Frame")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("UNIT_POWER_UPDATE")
e:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not RougeUI.db.EnergyTicker and not RougeUI.db.EnemyTicker then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            return
        end

        if RougeUI.db.EnergyTicker and powerTypes[PowerType("player")] then
            AddEnergy(PlayerFrameManaBar)
            energyValues["player"] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
            }

            local _, class = UnitClass("player")
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
            }

            for i = 1, 10 do
                energyValues["nameplate" .. i] = {
                    last_tick = 0,
                    last_value = 0,
                    startTick = false,
                    validTick = false,
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
        if not powerTypes[PowerType("target")] or not UnitIsPlayer("target")
                or not UnitIsEnemy("player", "target") or not energyValues.target.startTick then
            TargetFrameManaBar.energy.spark:SetAlpha(0)
            C_Timer.After(0.1, function()
                if energyValues.target.startTick and powerTypes[PowerType("target")]
                        and UnitIsPlayer("target") and UnitIsEnemy("player", "target") then
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
    end
end)