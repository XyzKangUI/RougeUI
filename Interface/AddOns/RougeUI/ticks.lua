local addonName, RougeUI = ...
local GetManaRegen = _G.GetManaRegen
local UnitPower = _G.UnitPower
local UnitIsPlayer = _G.UnitIsPlayer
local UnitPowerType = _G.UnitPowerType
local PlayerFrameManaBar = _G.PlayerFrameManaBar
local drinkName = GetSpellInfo(1137)

local eventRegistered = {
    ["SPELL_PERIODIC_ENERGIZE"] = true,
    ["SPELL_ENERGIZE"] = true,
    ["SPELL_CAST_SUCCESS"] = true,
}

local energyValues = {}
local possibleFSR

local ignoreTicks = {
    [4] = true, [6] = true, [8] = true, [10] = true,
    [15] = true, [20] = true, [25] = true, [30] = true, [33] = true,
}

local function AddEnergy(frame)
    if frame.energy then return end

    frame.energy = CreateFrame("Statusbar", nil, frame)
    frame.energy.spark = frame.energy:CreateTexture(nil, "OVERLAY")
    frame.energy.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    frame.energy.spark:SetSize(24, 24)
    frame.energy.spark:SetPoint("CENTER", frame, 0, 0)
    frame.energy.spark:SetBlendMode("ADD")
    frame.energy.spark:SetAlpha(0)
end

local function SetEnergyValue(frame, value, tickRate)
    local x = frame:GetWidth()
    local position

    if tickRate and tickRate > 2.02 then
        position = x - ((x * value) / tickRate)
    else
        position = ((x * value) / 2.02)
    end

    if position < x then
        frame.energy.spark:Show()
        frame.energy.spark:SetPoint("CENTER", frame, "LEFT", position, 0)
    end
end

local function OnUpdate(_, elapsed)
    local ev = energyValues.player
    if not ev then return end

    ev.last_tick = ev.last_tick + elapsed

    if ev.last_tick >= ev.tickRate and ev.startTick then
        ev.last_tick = 0
        ev.validTick = false
        if ev.tickRate ~= 2.02 then
            ev.tickRate = 2.02
            possibleFSR = false
        end
    end

    SetEnergyValue(PlayerFrameManaBar, ev.last_tick, ev.tickRate)
end

local function UpdateEnergy(unit, powerType)
    if unit ~= "player" then return end
    if not (powerType == "ENERGY" or powerType == "RAGE" or powerType == "MANA") then return end

    local ev = energyValues.player
    local energy = UnitPower("player")
    local energyInc = energy - ev.last_value

    if ev.last_value == 0 then
        ev.last_value = energy
        return
    end

    if energyInc == 0 then return end

    local increment

    if powerType == "ENERGY" then
        local residual = energyInc - (ev.externalGain or 0)
        increment = residual > 0
        ev.externalGain = 0
        
    elseif powerType == "RAGE" and not UnitAffectingCombat("player") then
        increment = (energyInc == -1 or energyInc == -2 or energyInc == -3)

    elseif powerType == "MANA" then
        local residual = energyInc - (ev.externalGain or 0)
        increment = residual > 0
        ev.externalGain = 0

        local percentageGain = math.floor((residual / UnitPowerMax("player")) * 100)
        if percentageGain == 10 or percentageGain == 6 or ignoreTicks[residual] then
            increment = false
        end

        local _, casting = GetManaRegen()
        if C_UnitAuras.GetAuraDataBySpellName("player", drinkName, "HELPFUL") then
            ev.tickRate = 2.02
            possibleFSR = false
        elseif energyInc < 1 and not increment and casting < 0.05 then
            possibleFSR = true
        end
    end

    ev.last_value = energy

    if increment and not ev.validTick and ev.tickRate == 2.02 then
        possibleFSR = false
        ev.startTick = true
        ev.validTick = true
        ev.last_tick = 0
        ev.tickRate = 2.02
        if PlayerFrameManaBar.energy.spark:GetAlpha() < 1 then
            PlayerFrameManaBar.energy.spark:SetAlpha(1)
        end
    end
end

local function RealTick()
    local _, eventType, _, _, _, sourceFlags, _, _, _, destFlags, _, spellID, _, _, amount =
        CombatLogGetCurrentEventInfo()

    if not eventRegistered[eventType] then return end

    local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)
    local isSourcePlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE")
        and isDestPlayer and isSourcePlayer then
        energyValues.player.externalGain = (energyValues.player.externalGain or 0) + amount
        return
    end

    if eventType == "SPELL_CAST_SUCCESS" and isSourcePlayer and spellID == 13750 then
        energyValues.player.last_tick = 0
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("ADDON_LOADED")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        if not RougeUI.db.EnergyTicker then return end

        local _, class = UnitClass("player")
        if UnitPowerType("player") == 0 or class == "DRUID" then
            self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
        end

        AddEnergy(PlayerFrameManaBar)

        energyValues.player = {
            last_tick = 0,
            last_value = 0,
            startTick = false,
            validTick = false,
            tickRate = 2.02,
        }

        self:RegisterEvent("UNIT_POWER_UPDATE")
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        self:SetScript("OnUpdate", OnUpdate)

    elseif event == "UNIT_POWER_UPDATE" then
        UpdateEnergy(...)

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        RealTick()

    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local _, _, spellId = ...
        if spellId == 6603 or not possibleFSR then return end

        if IsPlayerSpell(spellId) or IsSpellKnownOrOverridesKnown(spellId) then
            local now = GetTime()
            local channeling, _, _, startTime, endTime = UnitChannelInfo("player")
            local channelTime = channeling and ((endTime - startTime) / 1000) or 0
            local rate = (6.06 - (now - energyValues.player.last_tick) % 2.02)

            energyValues.player.tickRate = rate >= 5 and rate or rate + 2.02
            if channeling and channelTime > rate then
                energyValues.player.tickRate = energyValues.player.tickRate + 2.02
            end

            energyValues.player.last_tick = 0
            energyValues.player.startTick = true
            energyValues.player.validTick = false
        end
    end
end)