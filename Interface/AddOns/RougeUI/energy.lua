local last_tick = GetTime()
local last_value = 0
local externalManaGainTimestamp = 0
local e = CreateFrame("Frame")
local fakeTick, startTick, validateTick
local UnitIsPlayer = UnitIsPlayer

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
e:RegisterEvent("PLAYER_TARGET_CHANGED")
e:RegisterUnitEvent("UNIT_POWER_UPDATE", "target")
e:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "target")
e:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "target")


local function PowerType()
    return UnitPowerType("target")
end

local function SetEnergyValue(self, value)
    local x = self:GetWidth()
    local position = ((x * value) / 2.02)

    if (position < x) then
        self.energy.spark:Show()
        self.energy.spark:SetPoint("CENTER", self, "LEFT", position, 0)
    end
end

local function OnUpdate(self)
    local time = GetTime()
    local v = time - last_tick

    if (v > 2.01 and v < 2.04) then -- ticks occur every 2.02s if not for deviations due to latency
        last_tick = time
        validateTick = false
    end

    SetEnergyValue(self:GetParent(), v)
end

local function UpdateEnergy(unit)
    local energy = UnitPower(unit)
    local maxenergy = UnitPowerMax(unit)
    local time = GetTime()
    local energyInc = energy - last_value

    if time - externalManaGainTimestamp < 0.02 then
        externalManaGainTimestamp = 0
        return
    end

    last_value = energy

    if energy == maxenergy and energyInc ~= 20 or energyInc <= 0 then
        return
    end

    if (energyInc > 0 and energyInc < 999) and not fakeTick then
        startTick = true
    end

    if startTick and not validateTick then
        last_tick = time
        validateTick = true
        if TargetFrameManaBar.energy.spark:GetAlpha() < 1 then
            TargetFrameManaBar.energy.spark:SetAlpha(1)
        end
    end

    fakeTick = false
end

local function AddEnergy()
    TargetFrameManaBar.energy = CreateFrame("Statusbar", "TargetFrameManaBar_energy", TargetFrameManaBar)
    TargetFrameManaBar.energy.spark = TargetFrameManaBar.energy:CreateTexture(nil, "OVERLAY")
    TargetFrameManaBar.energy.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    TargetFrameManaBar.energy.spark:SetSize(32, 32)
    TargetFrameManaBar.energy.spark:SetPoint("CENTER", TargetFrameManaBar, 0, 0)
    TargetFrameManaBar.energy.spark:SetBlendMode("ADD")
    TargetFrameManaBar.energy.spark:SetAlpha(.4)

    if not TargetFrameManaBar.energy:GetScript("OnUpdate") then
        TargetFrameManaBar.energy:SetScript("OnUpdate", OnUpdate)
    end
end

local eventRegistered = { SPELL_PERIODIC_ENERGIZE = true, SPELL_ENERGIZE = true }
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local COMBATLOG_FILTER_HOSTILE_PLAYERS = COMBATLOG_FILTER_HOSTILE_PLAYERS;
local CombatLog_Object_IsA = CombatLog_Object_IsA
local function RealTick()
    local _, eventType, _, _, _, _, _, _, _, destFlags = CombatLogGetCurrentEventInfo()
    if not (eventRegistered[eventType]) then
        return
    end

    local isDestEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") then
        if isDestEnemy then
            externalManaGainTimestamp = GetTime()
            fakeTick = true
        end
        return
    end
end

local function OnEvent(self, event, ...)
    if not RougeUI.EnemyTicks then
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
        return
    end

    if event == "PLAYER_LOGIN" then
        AddEnergy()
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "UNIT_POWER_UPDATE" then
        local unit = ...
        UpdateEnergy(unit)
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        RealTick()
    elseif event == "PLAYER_TARGET_CHANGED" then
        if not (PowerType() == 0 or PowerType() == 3) or not UnitIsPlayer("target") then
            TargetFrameManaBar.energy:SetScript("OnUpdate", nil)
            TargetFrameManaBar.energy.spark:SetAlpha(0)
            return
        else
            if not TargetFrameManaBar.energy:GetScript("OnUpdate") then
                TargetFrameManaBar.energy:SetScript("OnUpdate", OnUpdate)
            end
            TargetFrameManaBar.energy.spark:SetAlpha(1)
        end
        last_tick = GetTime()
        validateTick = false
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        fakeTick = true
        if PowerType() == 0 then
            TargetFrameManaBar.energy.spark:SetAlpha(0)
	  end
    elseif event == "UNIT_SPELLCAST_FAILED" then
        fakeTick = true
    end
end
e:SetScript("OnEvent", OnEvent)
