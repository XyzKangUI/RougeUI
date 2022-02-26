local events = {
        "PLAYER_LOGIN",
        "PLAYER_REGEN_DISABLED",
        "PLAYER_REGEN_ENABLED",
	"UPDATE_SHAPESHIFT_FORM"
}

local last_tick = 0
local last_value = 0
local ONUPDATE_INTERVAL = 0.02
local last_update = 0

local function SetEnergyValue(self, value)
        local x         = self:GetWidth()
	local position = ((x * value) / 2.02)

	if (position < x) then
		self.energy.spark:Show()
		self.energy.spark:SetPoint('CENTER', self, 'LEFT', position, 0)
	end
end

local function UpdateEnergy(self, elapsed)
	local energy = UnitPower("player", 3)
	local maxenergy = UnitPowerMax("player", 3)
	last_update = last_update + elapsed
	last_tick = last_tick + elapsed

	if last_update < ONUPDATE_INTERVAL then
		return
	end

	if (((energy == last_value + 20 or energy == last_value + 21 or energy == last_value + 40 or energy == last_value + 41) and energy ~= maxenergy) or (last_tick >= 2.02)) then
    		last_tick = 0
	end

    	SetEnergyValue(self:GetParent(), last_tick)

    	last_value = energy
	last_update = 0
end

local function AddEnergy()
        PlayerFrameManaBar.energy = CreateFrame("Statusbar", nil, PlayerFrameManaBar)
        PlayerFrameManaBar.energy.spark = PlayerFrameManaBar.energy:CreateTexture(nil, "OVERLAY")
        PlayerFrameManaBar.energy.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        PlayerFrameManaBar.energy.spark:SetSize(32, 32)
        PlayerFrameManaBar.energy.spark:SetPoint("CENTER", PlayerFrameManaBar, 0, 0)
        PlayerFrameManaBar.energy.spark:SetBlendMode("ADD")
        PlayerFrameManaBar.energy.spark:SetAlpha(.4)

        PlayerFrameManaBar.energy:RegisterEvent("UNIT_POWER_UPDATE")
	if not PlayerFrameManaBar.energy:GetScript("OnUpdate") then
		PlayerFrameManaBar.energy:SetScript("OnUpdate", UpdateEnergy)
	end
end

local function OnEvent(self, event)
	local _, class = UnitClass("player")
	if (RougeUI.EnergyTicker == false and (class ~= "ROGUE" or class ~= "DRUID")) then
		self:UnregisterAllEvents()
		self:SetScript("OnEvent", nil)
		return
	end

	if (event == "PLAYER_LOGIN") then
		AddEnergy()
		if class == "DRUID" and UnitPowerType("player") ~= 3 then
			PlayerFrameManaBar.energy.spark:SetAlpha(0)
		end
        elseif (event == "PLAYER_REGEN_DISABLED") then
             	PlayerFrameManaBar.energy.spark:SetAlpha(1)
        elseif (event == "PLAYER_REGEN_ENABLED") then
             	PlayerFrameManaBar.energy.spark:SetAlpha(1)
	elseif (event == "UPDATE_SHAPESHIFT_FORM" and class == "DRUID") then
		if (UnitPowerType("player") ~= 3) then
			PlayerFrameManaBar.energy.spark:SetAlpha(0)
		else
			PlayerFrameManaBar.energy.spark:SetAlpha(1)
		end
        end

	if (class ~= "DRUID") then
		self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
	end
	self:UnregisterEvent("PLAYER_LOGIN")
end

local  e = CreateFrame("Frame")
for _, v in pairs(events) do e:RegisterEvent(v) end
e:SetScript("OnEvent", OnEvent)


    --
