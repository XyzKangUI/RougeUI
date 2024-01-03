local _, RougeUI = ...
local Indicator = {}

local function InCombat(unit)
    local _, _, class = UnitClass(unit)

    if UnitAffectingCombat(unit) then
        return true
    else
        if (IsActiveBattlefieldArena() and not (class == 1 or class == 2 or class == 4 or class == 11)) then
            for i = 1, 5, 1 do
                if UnitExists("arenapet" .. i .. "target") or UnitDetailedThreatSituation("player", "arenapet" .. i) or
                        UnitDetailedThreatSituation("party"..i, "arenapet" .. i) then
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
            if events[event] and frame:IsShown() then
                local unit = SecureButton_GetUnit(self)
                Indicator[self]:SetShown(InCombat(unit))
                if UnitClassification(unit) ~= "normal" then
                    ciFrame:SetPoint("LEFT", frame, "RIGHT", 0, -5)
                else
                    ciFrame:SetPoint("LEFT", frame, "RIGHT", -25, -5)
                end
            end
        end)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if RougeUI.db.CombatIndicator then
            CreateCombatIndicatorForUnit(TargetFrame)
            if FocusFrame then
                CreateCombatIndicatorForUnit(FocusFrame)
            end
        end
        self:UnregisterEvent("PLAYER_LOGIN")
        self:SetScript("OnEvent", nil)
    end
end)
