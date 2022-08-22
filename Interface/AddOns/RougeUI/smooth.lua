local smoothing = {}
local floor = math.floor
local mabs = math.abs
local min, max = math.min, math.max
local UnitGUID = UnitGUID
local ONUPDATE_INTERVAL = 0.01
local TimeSinceLastUpdate = 0

local barstosmooth = {
	PlayerFrameHealthBar = "player",
	PlayerFrameManaBar = "player",
	PetFrameHealthBar = "pet",
	PetFrameManaBar = "pet",
	TargetFrameHealthBar = "target",
	TargetFrameManaBar = "target",
	FocusFrameHealthBar = "focus",
	FocusFrameManaBar = "focus",
	PartyMemberFrame1HealthBar = "party1",
	PartyMemberFrame1ManaBar = "party1",
	PartyMemberFrame2HealthBar = "party2",
	PartyMemberFrame2ManaBar = "party2",
	PartyMemberFrame3HealthBar = "party3",
	PartyMemberFrame3ManaBar = "party3",
	PartyMemberFrame4HealthBar = "party4",
	PartyMemberFrame4ManaBar = "party4"
}

local smoothframe = CreateFrame("Frame")
smoothframe:RegisterEvent("ADDON_LOADED")

local function isPlate(frame)
	local name = frame:GetName()
	if name and name:find("NamePlate") then
		return true
	end

	return false
end

local function AnimationTick()
	local limit = .33
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value - cur) /3, max(value - cur, limit))

		if new ~= new then
			new = value
		end

		bar:SetValue_(floor(new))
		if cur == value or mabs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end

local function SmoothSetValue(self, value)
	self.finalValue = value
	if self.unitType then
		local guid = UnitGUID(self.unitType)
		if (value == self:GetValue() or (not guid or guid ~= self.lastGuid)) then
			smoothing[self] = nil
			self:SetValue_(value)
		else
			smoothing[self] = value
		end
		self.lastGuid = guid
	else
		local _, max = self:GetMinMaxValues()
		if (value == self:GetValue() or (self._max and self._max ~= max)) then
			smoothing[self] = nil
			self:SetValue_(value)
		else
			smoothing[self] = value
		end
		self._max = max
	end
end

local function SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = SmoothSetValue
	end
end

local function onUpdate(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	if TimeSinceLastUpdate >= ONUPDATE_INTERVAL then
		TimeSinceLastUpdate = 0
		local frames = {WorldFrame:GetChildren()}
		for _, plate in ipairs(frames) do
			if not plate:IsForbidden() and isPlate(plate) and C_NamePlate.GetNamePlates() and plate:IsVisible() then
				local v = plate:GetChildren()
				if  v.healthBar then
					SmoothBar(v.healthBar)
				end
			end
		end

		for k,v in pairs (barstosmooth) do
			if _G[k] then
				SmoothBar(_G[k])
				_G[k]:SetScript("OnHide", function() _G[k].lastGuid = nil; _G[k].max_ = nil end)
				if v ~= "" then
					_G[k].unitType = v
				end
			end
		end
		AnimationTick()
	end
end

smoothframe:SetScript("OnEvent", function(self, event)
	if event == "ADDON_LOADED" and RougeUI.smooth == true then
		smoothframe:HookScript("OnUpdate", onUpdate)
	end
	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end);