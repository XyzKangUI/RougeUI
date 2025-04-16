local addonName, RougeUI = ...
local Indicator = {}
local asuriFrame = false

local function InCombat(unit)
    local _, _, class = UnitClass(unit)

    if UnitAffectingCombat(unit) then
        return true
    else
        if (IsActiveBattlefieldArena() and not (class == 1 or class == 2 or class == 4 or class == 11)) then
            for i = 1, 5, 1 do
                if UnitExists("arenapet" .. i .. "target") then
                    if UnitIsUnit(unit, "arena" .. i) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function CreateCombatIndicatorForUnit(frame)
    if not Indicator[frame] then
        local ciFrame = frame:CreateTexture(nil, "BORDER")
        ciFrame:SetPoint("LEFT", frame, "RIGHT", -25, -5)
        ciFrame:SetSize(60, 60)
        ciFrame:SetTexture("Interface\\AddOns\\RougeUI\\textures\\CombatSwords")
        ciFrame:Hide()
        Indicator[frame] = ciFrame

        frame:HookScript("OnEvent", function(self, event)
            if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" then
                if frame:IsShown() then
                    local unit = frame.unit
                    Indicator[self]:SetShown(InCombat(unit))
                    if UnitClassification(unit) ~= "normal" and not asuriFrame then
                        ciFrame:SetPoint("LEFT", frame, "RIGHT", 0, -5)
                    else
                        if asuriFrame and frame == FocusFrame then
                            ciFrame:SetPoint("LEFT", frame, "LEFT", -100, -14)
                            return
                        end
                        ciFrame:SetPoint("LEFT", frame, "RIGHT", -25, -5)
                    end
                end
            end
        end)
    end
end

local function checkCombat()
    for frame, indicator in pairs(Indicator) do
        if frame:IsShown() and frame.unit then
            indicator:SetShown(InCombat(frame.unit))
        else
            if indicator:IsShown() then
                indicator:Hide()
            end
        end
    end
end

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", checkCombat)
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and RougeUI.db.CombatIndicator and (... == addonName) then
        asuriFrame = RougeUI.db.AsuriFrame
        CreateCombatIndicatorForUnit(TargetFrame)
        if FocusFrame then
            CreateCombatIndicatorForUnit(FocusFrame)
        end
    end
end)
