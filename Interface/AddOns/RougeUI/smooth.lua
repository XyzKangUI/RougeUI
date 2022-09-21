---------------------------------------------------------------------
-- Smooth animations

local floor = math.floor
local activeObjects = {}
local handledObjects = {}
local TARGET_FPS = 60
local AMOUNT = .33	
local abs = math.abs
local UnitGUID = UnitGUID

local barstosmooth = {
   PlayerFrameHealthBar = "player",
   PlayerFrameManaBar = "player",
   TargetFrameHealthBar = "target",
   TargetFrameManaBar = "target",
   PetFrameHealthBar = "pet",
   PetFrameManaBar = "pet",
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

local function isPlate(frame)
	local name = frame:GetName()
	if name and name:find("NamePlate") then
		return true
	end

	return false
end

local function clamp(v, min, max)
	min = min or 0
	max = max or 1

	if v > max then
		return max
	elseif v < min then
		return min
	end

	return v
end

local function isCloseEnough(new, target, range)
	if range > 0 then
		return abs((new - target) / range) <= 0.001
	end

	return true
end

local smoothframe = CreateFrame("Frame")
local function AnimationTick(_, elapsed)
	for unitFrame, info in next, activeObjects do
		local new = Lerp(unitFrame._value, info.currentHealth, clamp(AMOUNT * elapsed * TARGET_FPS))
		if info.changedGUID or isCloseEnough(new, info.currentHealth, unitFrame._max - unitFrame._min) then
			new = info.currentHealth
			activeObjects[unitFrame] = nil
		end
		unitFrame:SetValue_(floor(new))
		unitFrame._value = new
	end
end

local function bar_SetSmoothedValue(self, value)
	self.finalValue = value

	value = tonumber(value)
	self._value = self:GetValue()
	if not activeObjects[self] then
		activeObjects[self] = {}
	end
	if self.unit then
		local guid = UnitGUID(self.unit)
		if guid ~= self.guid then
			activeObjects[self].changedGUID = true
		end
		self.guid = guid
	end

	activeObjects[self].currentHealth = clamp(value, self._min, self._max)
end

local function bar_SetSmoothedMinMaxValues(self, min, max)
	min, max = tonumber(min), tonumber(max)

	self:SetMinMaxValues_(min, max)

	if self._max and self._max ~= max then
		local ratio = 1
		if max ~= 0 and self._max and self._max ~= 0 then
			ratio = max / (self._max or max)
		end

		local currentHealth = activeObjects[self] and activeObjects[self].currentHealth
		if currentHealth then
			activeObjects[self].currentHealth = currentHealth * ratio
		end

		local cur = self._value
		if cur then
			self:SetValue_(cur * ratio)
			self._value = cur * ratio
		end
	end

	self._min = min
	self._max = max
end


local function SmoothBar(bar)
	bar._min, bar._max = bar:GetMinMaxValues()
	bar._value = bar:GetValue()

	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = bar_SetSmoothedValue
	end
	if not bar.SetMinMaxValues_ then
		bar.SetMinMaxValues_ = bar.SetMinMaxValues
		bar.SetMinMaxValues = bar_SetSmoothedMinMaxValues
	end

	handledObjects[bar] = true
end

local function onUpdate(self, elapsed)
	local frames = {WorldFrame:GetChildren()}
	for _, plate in ipairs(frames) do
		if not plate:IsForbidden() and isPlate(plate) and C_NamePlate.GetNamePlates() and plate:IsVisible() then
			local v = plate:GetChildren()
			if  v.healthBar then
				SmoothBar(v.healthBar)
			end
		end
	end
	AnimationTick(_, elapsed)
end

local function init()
	for k, v in pairs(barstosmooth) do
    		if _G[k] then
        		SmoothBar(_G[k])
        		_G[k]:HookScript("OnHide", function()
            		_G[k].lastGuid = nil;
            		_G[k].min_ = nil
            		_G[k].max_ = nil
       	 	end)
			if v ~= "" then
				_G[k].unit = v
			end
   	 	end
	end
end

smoothframe:RegisterEvent("ADDON_LOADED")
smoothframe:SetScript("OnEvent", function(self, event)
	if event == "ADDON_LOADED" and RougeUI.smooth == true then
		smoothframe:SetScript("OnUpdate", onUpdate)
		init()
	end
	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end)