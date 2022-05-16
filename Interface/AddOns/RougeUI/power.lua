local events = {
        "PLAYER_LOGIN",
        "PLAYER_REGEN_DISABLED",
        "PLAYER_REGEN_ENABLED",
        "UPDATE_SHAPESHIFT_FORM",
        "COMBAT_LOG_EVENT_UNFILTERED",
        "UNIT_POWER_UPDATE"
}

local last_tick = GetTime()
local last_value = 0
local externalManaGainTimestamp = 0

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

  if time >= last_tick + 2.02 then
    last_tick = time
  end

  SetEnergyValue(self:GetParent(), v)
end

local function UpdateEnergy()
  local energy = UnitPower("player", 3)
  local maxenergy = UnitPowerMax("player", 3)
  local time = GetTime()
  local v = time - last_tick

  if time - externalManaGainTimestamp < 0.02 then
    externalManaGainTimestamp = 0
    return
  end

  if (((energy == last_value + 20 or energy == last_value + 21 or energy == last_value + 40 or energy == last_value + 41) and energy ~= maxenergy)) then
        last_tick = time
  end

  last_value = energy
end

local function AddEnergy()
  PlayerFrameManaBar.energy = CreateFrame("Statusbar", "PlayerFrameManaBar_energy", PlayerFrameManaBar)
  PlayerFrameManaBar.energy.spark = PlayerFrameManaBar.energy:CreateTexture(nil, "OVERLAY")
  PlayerFrameManaBar.energy.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
  PlayerFrameManaBar.energy.spark:SetSize(32, 32)
  PlayerFrameManaBar.energy.spark:SetPoint("CENTER", PlayerFrameManaBar, 0, 0)
  PlayerFrameManaBar.energy.spark:SetBlendMode("ADD")
  PlayerFrameManaBar.energy.spark:SetAlpha(.4)

  PlayerFrameManaBar.energy:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	if not PlayerFrameManaBar.energy:GetScript("OnUpdate") then
		PlayerFrameManaBar.energy:SetScript("OnUpdate", OnUpdate)
	end
end

local eventRegistered = { SPELL_PERIODIC_ENERGIZE = true, SPELL_ENERGIZE = true }
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local COMBATLOG_FILTER_ME = COMBATLOG_FILTER_ME;
local function RealTick()
  local _, eventType, _, _, _, _, _, _, _, destFlags = CombatLogGetCurrentEventInfo()
  if not (eventRegistered[eventType]) then return end

  local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)

  if (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") then
    if isDestPlayer then
      externalManaGainTimestamp = GetTime()
    end
    return
  end
end

local OnEvent = function(self, event, ...)
  local _, class = UnitClass("player")
  if not ((RougeUI.EnergyTicker == true) and class == "ROGUE" or class == "DRUID") then
    self:UnregisterAllEvents()
    self:SetScript("OnEvent", nil)
    return
  end

  if event == "PLAYER_LOGIN" then
    AddEnergy()
    self:UnregisterEvent("PLAYER_LOGIN")
    if (class ~= "DRUID") then
      self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
    end
  elseif event == "PLAYER_REGEN_DISABLED" then
    PlayerFrameManaBar.energy.spark:SetAlpha(1)
  elseif event == "PLAYER_REGEN_ENABLED" then
    PlayerFrameManaBar.energy.spark:SetAlpha(.4)
  elseif event == "UPDATE_SHAPESHIFT_FORM" and class == "DRUID" then
    if (UnitPowerType("player") ~= 3) then
      PlayerFrameManaBar.energy.spark:SetAlpha(0)
		else
      PlayerFrameManaBar.energy.spark:SetAlpha(1)
    end
  elseif event == "UNIT_POWER_UPDATE" then
    UpdateEnergy()
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    RealTick()
  end
end

local  e = CreateFrame("Frame")
for _, v in pairs(events) do e:RegisterEvent(v) end
e:SetScript("OnEvent", OnEvent)


    --
