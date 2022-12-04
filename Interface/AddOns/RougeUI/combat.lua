local UnitAffectingCombat, IsActiveBattlefieldArena = UnitAffectingCombat, IsActiveBattlefieldArena
local UnitIsUnit, UnitExists, UnitClass = UnitIsUnit, UnitExists, UnitClass
local SecureButton_GetUnit = SecureButton_GetUnit
local Indicator = {}

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

local events = {
    ["UNIT_FLAGS"] = true,
    ["PLAYER_TARGET_CHANGED"] = true,
    ["PLAYER_FOCUS_CHANGED"] = true
}

local function CreateCombatIndicatorForUnit(frame)
    if not Indicator[frame] then
        local ciFrame = frame:CreateTexture(nil, "BORDER")
        ciFrame:SetPoint("LEFT", frame, "RIGHT", -25, 10)
        ciFrame:SetSize(30, 30)
        ciFrame:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
        ciFrame:Hide()
        Indicator[frame] = ciFrame

        frame:RegisterEvent("UNIT_FLAGS")
        frame:HookScript("OnEvent", function(self, event)
            if events[event] and frame:IsShown() then
                local unit = SecureButton_GetUnit(self) -- SecureButton_GetModifiedUnit?
                Indicator[self]:SetShown(InCombat(unit))
            end
        end)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self)
    if RougeUI.CombatIndicator then
        CreateCombatIndicatorForUnit(TargetFrame)
        CreateCombatIndicatorForUnit(FocusFrame)
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)
