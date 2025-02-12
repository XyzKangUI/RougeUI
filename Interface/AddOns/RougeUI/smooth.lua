-- Smooth animations -- Ls

local addonName, RougeUI = ...
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
    return range > 0.0 and mabs((new - target) / range) <= 0.001
end

local function hasAbsorbValue(unit)
    if Precognito and (Precognito.db.animHealth or Precognito.db.absorbTrack) and unit then
        if Precognito.UnitGetTotalAbsorbs(unit) and Precognito.UnitGetTotalAbsorbs(unit) > 0 then
            return true
        elseif UnitGetIncomingHeals(unit) and UnitGetIncomingHeals(unit) > 0 then
            return true
        end
    end
    return false
end

local function AnimationTick(_, elapsed)
    for unitFrame, targetValue in next, smoothing do
        if hasAbsorbValue(unitFrame.unit) then
            smoothing[unitFrame] = nil
            unitFrame:SetValue_(unitFrame._value)
            if not next(smoothing) then
                smoothframe:SetScript("OnUpdate", nil)
            end
        else
            local newValue = lerp(unitFrame._value, targetValue, clamp(0.33 * elapsed * 60))
            unitFrame:SetValue_(floor(newValue))
            unitFrame._value = newValue

            if not unitFrame:IsVisible() or isCloseEnough(newValue, targetValue, unitFrame._max) then
                unitFrame:SetValue_(targetValue)
                unitFrame._value = targetValue
                smoothing[unitFrame] = nil

                if not next(smoothing) then
                    smoothframe:SetScript("OnUpdate", nil)
                end
            end
        end
    end
end

local function SetSmoothedValue(self, value)
    self.finalValue = value
    local guid = UnitGUID(self.unit)

    if hasAbsorbValue(self.unit) or not self:IsVisible() or isCloseEnough(self._value, value, self._max) or (self.unit and guid ~= self.guid) then
        self.guid = guid
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
    if self.updatingMinMax then
        return
    end

    self.updatingMinMax = true
    self:SetMinMaxValues_(min, max)

    if self._max and self._max ~= max then
        local ratio = (max ~= 0 and self._max and self._max ~= 0) and (max / self._max) or 1

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
    self.updatingMinMax = false
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

smoothframe:RegisterEvent("ADDON_LOADED")
smoothframe:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" and addon == addonName and RougeUI.db.smooth then
        for barName, unit in pairs(barstosmooth) do
            local statusbar = _G[barName]
            if statusbar then
                SmoothBar(statusbar)
                statusbar:HookScript("OnHide", function(self)
                    self.guid, self.max_ = nil, nil
                end)
                statusbar.unit = unit ~= "" and unit or nil
            end
        end

        self:UnregisterEvent("ADDON_LOADED")
        self:SetScript("OnUpdate", AnimationTick)
    end
end)
