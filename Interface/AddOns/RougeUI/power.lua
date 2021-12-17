local events = {
        "PLAYER_LOGIN",
        "PLAYER_REGEN_DISABLED",
        "PLAYER_REGEN_ENABLED"
}

local last_tick  = GetTime()
local last_value = 0

local function SetEnergyValue(self, value)
        local x         = self:GetWidth()
        local type      = UnitPowerType("player")
	local position = ((x * value) / 2.02)

	if (position < x) then
		self.energy.spark:Show()
		self.energy.spark:SetPoint('CENTER', self, 'LEFT', position, 0)
	end
end

local function UpdateEnergy(self, unit)
        local energy = UnitPower("player", 3)
        local time  = GetTime()
    	local v = time - last_tick
	local maxenergy = UnitPowerMax("player", 3)

	if (((energy == last_value + 20 or energy == last_value + 21 or energy == last_value + 40 or energy == last_value + 41) and energy ~= maxenergy) or (time >= last_tick + 2.02)) then
    		last_tick = time
	end

    	SetEnergyValue(self:GetParent(), v)

    	last_value = energy
end

local function AddEnergy()
        PlayerFrameManaBar.energy = CreateFrame('Statusbar', 'PlayerFrameManaBar_energy', PlayerFrameManaBar)
        PlayerFrameManaBar.energy.spark = PlayerFrameManaBar.energy:CreateTexture(nil, 'OVERLAY')
        PlayerFrameManaBar.energy.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        PlayerFrameManaBar.energy.spark:SetSize(32, 32)
        PlayerFrameManaBar.energy.spark:SetPoint('CENTER', PlayerFrameManaBar, 0, 0)
        PlayerFrameManaBar.energy.spark:SetBlendMode'ADD'
        PlayerFrameManaBar.energy.spark:SetAlpha(.4)

        PlayerFrameManaBar.energy:RegisterEvent("UNIT_POWER_UPDATE")
	if not PlayerFrameManaBar.energy:GetScript("OnUpdate") then
		PlayerFrameManaBar.energy:SetScript("OnUpdate", UpdateEnergy)
	end
end

local function OnEvent(self, event)
	local _, class = UnitClass("player")
	if not ((RougeUI.EnergyTicker == true) and class == "ROGUE" or class == "DRUID") then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetScript("OnEvent", nil)
		return
	end

	if (event == "PLAYER_LOGIN") then
		AddEnergy()
        elseif event == ("PLAYER_REGEN_DISABLED") then
             	PlayerFrameManaBar.energy.spark:SetAlpha(1)
        elseif event == ("PLAYER_REGEN_ENABLED") then
             	PlayerFrameManaBar.energy.spark:SetAlpha(0.3)
        end

	self:UnregisterEvent("PLAYER_LOGIN")
end

local  e = CreateFrame("Frame")
for _, v in pairs(events) do e:RegisterEvent(v) end
e:SetScript("OnEvent", OnEvent)


    --