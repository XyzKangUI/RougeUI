---------------------------------------------------------------------
-- Smooth animations -- Ls

local _, RougeUI = ...
local smoothing = {}
local floor, next = math.floor, next
local mabs = math.abs
local UnitGUID = UnitGUID
local smoothframe = CreateFrame("Frame")

local barstosmooth = {
    PlayerFrameHealthBar = "player",
    PlayerFrameManaBar = "player",
    TargetFrameHealthBar = "target",
    TargetFrameManaBar = "target",
    FocusFrameHealthBar = "focus",
    FocusFrameManaBar = "focus",
}

local function clamp(v, max)
    local min = 0
    max = max or 1

    if v >= max then
        return max
    elseif v <= min then
        return min
    end

    return v
end

local function lerp(startValue, endValue, amount)
    return startValue + (endValue - startValue) * amount
end

local function isCloseEnough(new, target, range)
    if range > 0.0 then
        return mabs((new - target) / range) <= 0.001
    end

    return true
end

local function AnimationTick(_, elapsed)
    for unitFrame, info in next, smoothing do
        local newValue = lerp(unitFrame._value, info, clamp(.33 * elapsed * 60))
        unitFrame:SetValue_(floor(newValue))
        unitFrame._value = newValue

        if not unitFrame:IsVisible() or isCloseEnough(newValue, info, unitFrame._max) then
            if smoothing[unitFrame] then
                unitFrame:SetValue_(smoothing[unitFrame])
                unitFrame._value = smoothing[unitFrame]

                smoothing[unitFrame] = nil
            end

            if not next(smoothing) then
                smoothframe:SetScript("OnUpdate", nil)
            end
        end
    end
end

local function SetSmoothedValue(self, value)
    self.finalValue = value
    local guid = UnitGUID(self.unit)

    if not self:IsVisible() or isCloseEnough(self._value, value, self._max) or (self.unit and guid ~= self.guid) then
        if guid ~= self.guid then
            self.guid = guid
        end
        smoothing[self] = nil
        self:SetValue_(floor(value))
        self._value = self:GetValue()
        return
    end

    smoothing[self] = clamp(value, self._max)

    if not smoothframe:GetScript("OnUpdate") then
        smoothframe:SetScript("OnUpdate", AnimationTick)
    end
end

local function SmoothSetValue(self, min, max)
    self:SetMinMaxValues_(min, max)

    if self._max and self._max ~= max then
        local ratio = 1
        if max ~= 0 and self._max and self._max ~= 0 then
            ratio = max / (self._max or max)
        end

        local target = smoothing[self]
        if target then
            smoothing[self] = target * ratio
        end

        local cur = self._value
        if cur then
            self:SetValue_(cur * ratio)
            self._value = cur * ratio
        end
    end

    self._max = max
end

local function SmoothBar(bar)
    local _
    _, bar._max = bar:GetMinMaxValues()
    bar._value = bar:GetValue()

    if not bar.SetValue_ then
        bar.SetValue_ = bar.SetValue
        bar.SetValue = SetSmoothedValue
    end
    if not bar.SetMinMaxValues_ then
        bar.SetMinMaxValues_ = bar.SetMinMaxValues
        bar.SetMinMaxValues = SmoothSetValue
    end
end

local function init()
    for k, v in pairs(barstosmooth) do
        local statusbar = _G[k]
        if statusbar then
            SmoothBar(statusbar)
            statusbar:HookScript("OnHide", function(self)
                self.guid, self.max_ = nil, nil
            end)
            if v ~= "" then
                statusbar.unit = v
            end
        end
    end
end

smoothframe:RegisterEvent("ADDON_LOADED")
smoothframe:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" and RougeUI.db.smooth then
        init()
        smoothframe:SetScript("OnUpdate", AnimationTick)
    end
    self:UnregisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", nil)
end)