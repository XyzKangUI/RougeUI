local addonName, RougeUI = ...
local GetManaRegen = _G.GetManaRegen
local UnitPower = _G.UnitPower
local PlayerFrameManaBar = _G.PlayerFrameManaBar
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
    local data = energyValues["player"]

    if data then
        data.last_tick = data.last_tick + elapsed

        if (data.last_tick >= data.tickRate) and data.startTick then
            data.last_tick = 0
            data.validTick = false
            if data.tickRate ~= 2.02 then
                data.tickRate = 2.02
                possibleFSR = false
            end
        end

        SetEnergyValue(PlayerFrameManaBar, data.last_tick, data.tickRate)
    end
end

local function UpdateEnergy(unit, powerType)
    if unit ~= "player" then return end
    
    if not energyValues[unit] or not (powerType == "ENERGY" or powerType == "RAGE" or powerType == "MANA") then
        return
    end

    local energy = UnitPower(unit)
    local energyInc = energy - energyValues[unit].last_value
    local now = GetTime()
    local guid = UnitGUID(unit)
    local externalTick = energyValues[guid] and energyValues[guid].externalTick or 0
    local gain = energyValues[guid] and energyValues[guid].externalGain or 0

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
        increment = (energy > energyValues[unit].last_value)

        local percentageGain = math.floor((energyInc / UnitPowerMax(unit)) * 100)
        if percentageGain == 10 or percentageGain == 6 or ignoreTicks[energyInc] or AuraUtil.FindAuraByName(GetSpellInfo(30823), "player") then
            increment = false
        end

        if unit == "player" then
            local _, casting = GetManaRegen()
            if AuraUtil.FindAuraByName(GetSpellInfo(1137), "player") then
                energyValues[unit].tickRate = 2.02
                possibleFSR = false
            elseif energyInc < 1 and not increment and casting < 0.05 then
                possibleFSR = true
            end
        end
    end

    energyValues[unit].last_value = energy

    if increment and not energyValues[unit].validTick and energyValues[unit].tickRate == 2.02 then
        possibleFSR = false
        energyValues[unit].startTick = true
        energyValues[unit].validTick = true
        energyValues[unit].last_tick = 0
        energyValues[unit].tickRate = 2.02
        
        if PlayerFrameManaBar.energy.spark:GetAlpha() < 1 then
            PlayerFrameManaBar.energy.spark:SetAlpha(1)
        end
    end
end

local function RealTick()
    local _, eventType, _, _, _, sourceFlags, _, destGUID, _, destFlags, _, spellID, _, _, amount = CombatLogGetCurrentEventInfo()

    if not (eventRegistered[eventType]) then
        return
    end

    local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)
    local isSourcePlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)

    if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") and isDestPlayer then
        local playerGUID = UnitGUID("player")
        if destGUID == playerGUID then
             if energyValues[playerGUID] == nil then
                energyValues[playerGUID] = {}
            end
            energyValues[playerGUID].externalTick = GetTime()
            energyValues[playerGUID].externalGain = amount
        end
        return
    end

    if eventType == "SPELL_CAST_SUCCESS" and isSourcePlayer and spellID == 13750 then
        if energyValues["player"] then
            energyValues["player"].last_tick = 0
        end
        return
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("ADDON_LOADED")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        if RougeUI.db.EnergyTicker then
            local _, class = UnitClass("player")
            if UnitPowerType("player") ~= 0 and class ~= "DRUID" then
                if self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") then
                    self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
                end
            else
                self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
            end

            AddEnergy(PlayerFrameManaBar)
            energyValues["player"] = {
                last_tick = 0,
                last_value = 0,
                startTick = false,
                validTick = false,
                tickRate = 2.02,
            }

            self:RegisterEvent("UNIT_POWER_UPDATE")
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            self:RegisterEvent("PLAYER_ENTERING_WORLD")
            self:SetScript("OnUpdate", OnUpdate)
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if energyValues["player"] then
            energyValues["player"].last_tick = 0
            energyValues["player"].last_value = 0
            energyValues["player"].startTick = false
            energyValues["player"].validTick = false
            energyValues["player"].tickRate = 2.02
        end
    elseif event == "UNIT_POWER_UPDATE" then
        local unit = ...
        if unit == "player" then
            UpdateEnergy(unit, ...)
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        RealTick()
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local _, _, spellId = ...

        if not possibleFSR or not energyValues["player"] then
            return
        end

        if IsPlayerSpell(spellId) or IsSpellKnownOrOverridesKnown(spellId) then
            local now = GetTime()
            local channeling, _, _, startTime, endTime = UnitChannelInfo("player")
            local channelTime = channeling and ((endTime - startTime) / 1000) or 0
            local rate = (6.06 - (now - (now - energyValues["player"].last_tick)) % 2.02)
            energyValues["player"].tickRate = rate >= 5 and rate or rate + 2.02
            
            if channeling and channelTime > rate then
                energyValues["player"].tickRate = energyValues["player"].tickRate + 2.02
            end
            energyValues["player"].last_tick = 0
            energyValues["player"].startTick = true
            energyValues["player"].validTick = false
        end
    end
end)
