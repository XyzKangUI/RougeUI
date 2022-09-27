---------------------------------------------------------------------
-- Smooth animations

local floor = math.floor
local activeObjects = {}
local handledObjects = {}
local TARGET_FPS = 60
local AMOUNT = .33
local abs = math.abs
local UnitGUID = UnitGUID
local smoothframe = CreateFrame("Frame")

local barstosmooth = {
    PlayerFrameHealthBar = "player",
    PlayerFrameManaBar = "player",
    TargetFrameHealthBar = "target",
    TargetFrameManaBar = "target",
    FocusFrameHealthBar = "focus",
    FocusFrameManaBar = "focus"
}

local function isPlate(frame)
    local name = frame:GetName()
    if name and name:find("NamePlate") then
        return true
    end

    return false
end

local function clamp(v, min, max)
    min = 0
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

local function lerp(v1, v2, perc)
    return v1 + (v2 - v1) * perc
end

local function remove(self)
    if activeObjects[self] then
        self:SetValue_(activeObjects[self].currentHealth)
        self._value = activeObjects[self].currentHealth

        activeObjects[self] = nil
    end

    if not next(activeObjects) then
        smoothframe:SetScript("OnUpdate", nil)
    end
end

local function AnimationTick(_, elapsed)
    for unitFrame, info in next, activeObjects do
        local new = lerp(unitFrame._value, info.currentHealth, clamp(AMOUNT * elapsed * TARGET_FPS))
        unitFrame:SetValue_(floor(new))
        unitFrame._value = new

        if info.changedGUID or isCloseEnough(new, info.currentHealth, unitFrame._max - unitFrame._min) then
            remove(unitFrame)
        end
    end
end

local function add(self, value)
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

    if not smoothframe:GetScript("OnUpdate") and RougeUI.smooth then
        smoothframe:SetScript("OnUpdate", smoothframe.OnUpdate)
    end
end

--- INIT

local function bar_SetValue(self, value)
    self.finalValue = value

    if not self:IsVisible() or isCloseEnough(self._value, value, self._max - self._min) or value == 0 then
        self:SetValue_(value)
        self._value = value
        return
    end

    add(self, value)
end

local function bar_SetMinMaxValues(self, min, max)
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

local function SmoothBar(self)
    if handledObjects[self] then
        return
    end

    self._min, self._max = self:GetMinMaxValues()
    self._value = self:GetValue()

    self.SetValue_ = self.SetValue
    self.SetValue = bar_SetValue
    self.SetMinMaxValues_ = self.SetMinMaxValues
    self.SetMinMaxValues = bar_SetMinMaxValues

    handledObjects[self] = true
end

function smoothframe.OnUpdate(_, elapsed)
    local frames = { WorldFrame:GetChildren() }
    for _, plate in ipairs(frames) do
        if not plate:IsForbidden() and isPlate(plate) and C_NamePlate.GetNamePlates() and plate:IsVisible() then
            local v = plate:GetChildren()
            if v.healthBar then
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
            _G[k]:SetScript("OnHide", function()
                _G[k].guid = nil;
                _G[k].min = nil;
                _G[k].max_ = nil
            end)
            if v ~= "" then
                _G[k].unit = v
            end
        end
    end
end

smoothframe:RegisterEvent("ADDON_LOADED")
smoothframe:SetScript("OnEvent", function(self)
    if RougeUI.smooth then
        init()
    end

    self:UnregisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", nil)
end)