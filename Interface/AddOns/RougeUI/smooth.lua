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
   PartyMemberFrame4ManaBar = "party4",
 }

local smoothframe = CreateFrame("Frame")
smoothframe:RegisterEvent("ADDON_LOADED")
smoothing = {}

local min, max = math.min, math.max

local function AnimationTick()
		local limit = 30/GetFramerate()
		for bar, value in pairs(smoothing) do
			local cur = bar:GetValue()
			local new = cur + min((value - cur) /3, max(value - cur, limit))

			if new ~= new then 
				new = value 
			end

			if cur == value or math.abs(new - value) < 2 then
				bar:SetValue_(value)
				smoothing[bar] = nil
			else
				bar:SetValue_(math.floor(new))
			end
		end
end

local function SmoothSetValue(self, value)
	self.finalValue = value
	if self.unitType then
      		local guid = UnitGUID(self.unitType)
      		if value == self:GetValue() or not guid or guid ~= self.lastGuid then
         		smoothing[self] = nil
         		self:SetValue_(value)
      		else
         		smoothing[self] = value
		end
		self.lastGuid = guid
	else
		local _, max = self:GetMinMaxValues()
		if value == self:GetValue() or self._max and self._max ~= max then
			smoothing[self] = nil
			self:SetValue_(value)
		else
			smoothing[self] = value
		end
		self._max = max
	end
end

for bar, value in pairs(smoothing) do
	if bar.SetValue_ then bar.SetValue = SmoothSetValue end
end

local function SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue  = SmoothSetValue
	end

	if not smoothframe:GetScript("OnUpdate") then
		smoothframe:SetScript("OnUpdate", AnimationTick)
	end
end

smoothframe:SetScript("OnEvent", function(self, event)
	if (RougeUI.smooth == false) then
		smoothframe:UnregisterEvent("ADDON_LOADED")
		smoothframe:SetScript("OnEvent", nil)
		return 
	end

	if (event == "ADDON_LOADED") then
		for k,v in pairs (barstosmooth) do
			if _G[k] then
				SmoothBar(_G[k])
				_G[k]:SetScript("OnHide", function() _G[k].lastGuid = nil; _G[k].max_ = nil end)
				if v ~= "" then
					_G[k].unitType = v
				end
			end
		end
	end
	smoothframe:UnregisterEvent("ADDON_LOADED")
	smoothframe:SetScript("OnEvent", nil)
end);