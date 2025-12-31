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
                if UnitExists("arenapet" .. i .. "target") or UnitDetailedThreatSituation("player", "arenapet" .. i) or
                        UnitDetailedThreatSituation("party" .. i, "arenapet" .. i) then
                    if UnitIsUnit(unit, "arena" .. i) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local events = {
    ["UNIT_FLAGS"] = true,
    ["PLAYER_TARGET_CHANGED"] = true,
    ["PLAYER_FOCUS_CHANGED"] = true
}

local function CreateCombatIndicatorForUnit(frame)
    if not Indicator[frame] then
        local ciFrame = frame:CreateTexture(nil, "BORDER")
        ciFrame:SetPoint("LEFT", frame, "RIGHT", -25, -5)
        ciFrame:SetSize(60, 60)
        ciFrame:SetTexture("Interface\\AddOns\\RougeUI\\textures\\CombatSwords")
        ciFrame:Hide()
        Indicator[frame] = ciFrame

        frame:RegisterEvent("UNIT_FLAGS")
        frame:HookScript("OnEvent", function(self, event)
            if events[event] and self:IsShown() then
                local unit = self.unit
                if not unit then return end
                Indicator[self]:SetShown(UnitAffectingCombat(unit))
                if UnitClassification(unit) ~= "normal" and not asuriFrame then
                    ciFrame:SetPoint("LEFT", self, "RIGHT", -15, -5)
                else
                    ciFrame:SetPoint("LEFT", self, "RIGHT", -10, -5)
                end
            end
        end)
    end
end

local f = CreateFrame("Frame")
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
