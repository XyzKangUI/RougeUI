---------------------------------------------------------------------
-- Smooth animations

local smoothing = {}
local pairs = pairs
local floor = math.floor
local mabs = math.abs
local UnitGUID = UnitGUID

local barstosmooth = {
    PlayerFrameHealthBar = "player",
    PlayerFrameManaBar = "player",
    TargetFrameHealthBar = "target",
    TargetFrameManaBar = "target",
    FocusFrameHealthBar = "focus",
    FocusFrameManaBar = "focus",
}

local function clamp(value, min, max)
    min = 0
    max = max or 1

    if value > max then
        return max;
    elseif value < min then
        return min;
    end
    return value;
end

local function lerp(startValue, endValue, amount)
    return (1 - amount) * startValue + amount * endValue
end

local function IsCloseEnough(bar, newValue, targetValue)
    local _, max = bar:GetMinMaxValues();
    local range = max
    if range > 0.0 then
        return mabs((newValue - targetValue) / range) < .001
    end

    return true;
end

local function AnimationTick()
    for bar, value in pairs(smoothing) do
        local cur = bar:GetValue()
        local effectiveTargetValue = clamp(value, bar:GetMinMaxValues());
        local newValue = lerp(cur, effectiveTargetValue, .25);

        if IsCloseEnough(bar, newValue, effectiveTargetValue) then
            smoothing[bar] = nil
            bar:SetValue_(effectiveTargetValue)
        else
            bar:SetValue_(floor(newValue))
        end
    end
end

local function SetSmoothedValue(self, value)
    self.finalValue = value

    if self.unit then
        local guid = UnitGUID(self.unit)
        if guid ~= self.guid then
            smoothing[self] = nil
            self:SetValue_(value)
        end
        self.guid = guid
    end
    smoothing[self] = value;
end

local function SmoothSetValue(self, _, max)
    self:SetMinMaxValues_(0, max)

    local targetValue = smoothing[self];
    if targetValue then
        local ratio = 1;

        if max ~= 0 and self._max and self._max ~= 0 then
            ratio = max / (self._max or max);
        end

        smoothing[self] = targetValue * ratio;
    end
    self._max = max
end

local function SmoothBar(bar)
    if not bar.SetValue_ then
        bar.SetValue_ = bar.SetValue
        bar.SetValue = SetSmoothedValue
    end
    if not bar.SetMinMaxValues_ then
        bar.SetMinMaxValues_ = bar.SetMinMaxValues
        bar.SetMinMaxValues = SmoothSetValue
    end
end

local function onUpdate()
    for _, plate in pairs(C_NamePlate.GetNamePlates(true)) do
        if not plate:IsForbidden() and plate:IsVisible() and plate.UnitFrame:IsShown() then
            SmoothBar(plate.UnitFrame.healthBar)
        end
    end
    AnimationTick()
end

local function init()
    for k, v in pairs(barstosmooth) do
        if _G[k] then
            SmoothBar(_G[k])
            _G[k]:HookScript("OnHide", function()
                _G[k].guid = nil;
                _G[k].max_ = nil
            end)
            if v ~= "" then
                _G[k].unit = v
            end
        end
    end
end

local smoothframe = CreateFrame("Frame")
smoothframe:RegisterEvent("ADDON_LOADED")
smoothframe:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" and RougeUI.smooth then
        smoothframe:SetScript("OnUpdate", AnimationTick)
        init()
    end
    self:UnregisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", nil)
end)