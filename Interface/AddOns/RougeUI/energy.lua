local _G = getfenv(0)
local UnitPowerType = _G.UnitPowerType
local pairs = _G.pairs
local UnitExists, UnitIsUnit, UnitIsPlayer = _G.UnitExists, _G.UnitIsUnit, _G.UnitIsPlayer
local UnitPower, UnitPowerMax, UnitIsEnemy = _G.UnitPower, _G.UnitPowerMax, _G.UnitIsEnemy
local inArena = false
local eventRegistered = { ["SPELL_PERIODIC_ENERGIZE"] = true, ["SPELL_ENERGIZE"] = true }
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local COMBATLOG_FILTER_HOSTILE_PLAYERS = _G.COMBATLOG_FILTER_HOSTILE_PLAYERS;
local CombatLog_Object_IsA = _G.CombatLog_Object_IsA
local externalManaGainTimestamp = 0
local gain = 0
local TargetFrameManaBar, FocusFrameManaBar = _G.TargetFrameManaBar, _G.FocusFrameManaBar

local frames = {
    ["target"] = TargetFrameManaBar,
    ["focus"] = FocusFrameManaBar,
}

local updateUnit = {
    ["target"] = TargetFrameManaBar,
    ["focus"] = FocusFrameManaBar,
    ["arena1"] = TargetFrameManaBar or FocusFrameManaBar,
    ["arena2"] = TargetFrameManaBar or FocusFrameManaBar,
    ["arena3"] = TargetFrameManaBar or FocusFrameManaBar,
    ["arena4"] = TargetFrameManaBar or FocusFrameManaBar,
    ["arena5"] = TargetFrameManaBar or FocusFrameManaBar
}

local powerTypes = { [0] = true, [3] = true }

local energyValues = {
    target = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
    focus = {
        last_tick = 0,
        last_value = 0,
        startTick = false,
        validTick = false,
    },
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

local function SetEnergyValue(self, value)
    local x = self:GetWidth()
    local position = ((x * value) / 2.02)

    if (position >= x * 0.2 and position <= x * 0.45) then
        self.energy.spark:SetVertexColor(0, 1, 0)
    else
        self.energy.spark:SetVertexColor(1, 1, 1)
    end

    if (position < x) then
        self.energy.spark:Show()
        self.energy.spark:SetPoint("CENTER", self, "LEFT", position, 0)
    end
end

local function OnUpdate(self, elapsed)
    for unit, frame in pairs(updateUnit) do
        if not powerTypes[PowerType(unit)] then
            return
        end

        if inArena then
            for i = 1, 5 do
                if UnitExists("arena" .. i) and UnitIsUnit(unit, "arena" .. i) then
                    energyValues[unit].last_tick = energyValues["arena" .. i].last_tick
                    break
                end
            end
        end

        energyValues[unit].last_tick = energyValues[unit].last_tick + elapsed

        if (energyValues[unit].last_tick >= 2.02) and energyValues[unit].startTick then
            if inArena then
                for i = 1, 5 do
                    if UnitExists("arena" .. i) and UnitIsUnit(unit, "arena" .. i) then
                        energyValues["arena" .. i].last_tick = 0
                        energyValues["arena" .. i].validTick = false
                        break
                    end
                end
            else
                energyValues[unit].last_tick = 0
                energyValues[unit].validTick = false
            end
        end
        SetEnergyValue(frame, energyValues[unit].last_tick)
    end
end

local function UpdateEnergy(unit)
    if not energyValues[unit] or not powerTypes[PowerType(unit)] then
        return
    end

    local energy = UnitPower(unit)
    local energyInc = energy - energyValues[unit].last_value

    if ((GetTime() - externalManaGainTimestamp) <= 0.02) and energyInc == gain then
        externalManaGainTimestamp = 0
        gain = 0
        return
    end

    if inArena then
        for i = 1, 5 do
            if UnitExists("arena" .. i) and UnitIsUnit(unit, "arena" .. i) and (unit == "target" or unit == "focus") then
                for key, value in pairs(energyValues["arena" .. i]) do
                    energyValues[unit][key] = value
                end
                return
            end
        end
    end

    if (energyValues[unit].last_value == 0) then
        energyValues[unit].last_value = energy
        return
    end

    if (energy > energyValues[unit].last_value) and not energyValues[unit].validTick then
        energyValues[unit].startTick = true
        energyValues[unit].last_tick = 0
        energyValues[unit].validTick = true
        if frames[unit] then
            SetEnergyValue(frames[unit], energyValues[unit].last_tick)
            if frames[unit].energy.spark:GetAlpha() < 1 then
                frames[unit].energy.spark:SetAlpha(1)
            end
        end
    end

    energyValues[unit].last_value = energy
end

local function AddEnergy(frame)
    if not frame.energy then
        frame.energy = CreateFrame("Statusbar", frame:GetName() .. "_energy", frame)
        frame.energy.spark = frame.energy:CreateTexture(nil, "OVERLAY")
        frame.energy.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        frame.energy.spark:SetSize(32, 32)
        frame.energy.spark:SetPoint("CENTER", frame, 0, 0)
        frame.energy.spark:SetBlendMode("ADD")
        frame.energy.spark:SetAlpha(0)
    end
end

local function RealTick()
    local _, eventType, _, _, _, _, _, _, _, destFlags, _, _, _, _, amount = CombatLogGetCurrentEventInfo()

    if not (eventRegistered[eventType]) then
        return
    end

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") and isDestEnemy then
        gain = amount
        externalManaGainTimestamp = GetTime()
        return
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("PLAYER_ENTERING_WORLD")

e:SetScript("OnEvent", function(self, event, ...)
    if not RougeUI.EnemyTicks then
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
        return
    end

    if event == "PLAYER_LOGIN" then
        for _, v in pairs(frames) do
            AddEnergy(v)
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "PLAYER_ENTERING_WORLD" then
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
            self:RegisterEvent("PLAYER_TARGET_CHANGED")
            self:RegisterEvent("PLAYER_FOCUS_CHANGED")
            self:RegisterEvent("UNIT_POWER_UPDATE")
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            if not self:GetScript("OnUpdate") then
                self:SetScript("OnUpdate", OnUpdate)
            end
        else
            self:UnregisterEvent("PLAYER_TARGET_CHANGED")
            self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
            self:UnregisterEvent("UNIT_POWER_UPDATE")
            self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            if self:GetScript("OnUpdate") then
                self:SetScript("OnUpdate", nil)
            end
        end
    elseif event == "UNIT_POWER_UPDATE" then
        local unit = ...
        if UnitIsEnemy("player", unit) and UnitIsPlayer(unit) then
            UpdateEnergy(unit)
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        RealTick()
    elseif event == "PLAYER_TARGET_CHANGED" then
        if not powerTypes[PowerType("target")] or not UnitIsPlayer("target") or not UnitIsEnemy("player", "target") then
            TargetFrameManaBar.energy.spark:SetAlpha(0)
        else
            if UnitPower("target") ~= UnitPowerMax("target") then
                TargetFrameManaBar.energy.spark:SetAlpha(1)
            end
        end
    elseif event == "PLAYER_FOCUS_CHANGED" then
        if not powerTypes[PowerType("focus")] or not UnitIsPlayer("focus") or not UnitIsEnemy("player", "focus") then
            FocusFrameManaBar.energy.spark:SetAlpha(0)
        else
            if UnitPower("focus") ~= UnitPowerMax("focus") then
                FocusFrameManaBar.energy.spark:SetAlpha(1)
            end
        end
    end
end)