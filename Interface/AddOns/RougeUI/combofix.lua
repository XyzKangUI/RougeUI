local _, RougeUI = ...
local comboPoints = 0;
local comboPointsCache = {};
local targetGUID
local UnitGUID, UnitIsPlayer, GetComboPoints = UnitGUID, UnitIsPlayer, GetComboPoints
local COMBOFRAME_FADE_IN = 0;
local COMBOFRAME_HIGHLIGHT_FADE_IN = 0;
local COMBOFRAMELAST_NUM_POINTS = 0;
local UnitIsPossessed = UnitIsPossessed

local function ComboUpdate(self)
    if (not self.maxComboPoints) then
        -- This can happen if we are showing combo points on the player frame (which doesn't use ComboFrame) and we exit a vehicle.
        return ;
    end

    if self:IsEventRegistered("UNIT_POWER_FREQUENT") then
        self:UnregisterEvent("UNIT_POWER_FREQUENT")
    end

    targetGUID = UnitGUID("target")
    if UnitIsPossessed("target") and UnitIsPlayer("target") then
        comboPoints = comboPointsCache[targetGUID] or 0;
    else
        comboPoints = GetComboPoints(self.unit, "target");
        if UnitIsPlayer("target") and targetGUID ~= nil then
            comboPointsCache[targetGUID] = comboPoints
        end
    end

    local comboPoint, comboPointHighlight, comboPointShine;

    if (comboPoints > 0) then
        if (not self:IsShown()) then
            self:Show();
            UIFrameFadeIn(self, COMBOFRAME_FADE_IN);
        end

        local comboIndex = 1;
        for i = 1, self.maxComboPoints do
            local fadeInfo = {};
            comboPoint = self.ComboPoints[comboIndex];
            comboPointHighlight = comboPoint.Highlight;
            comboPointShine = comboPoint.Shine;
            if (i <= comboPoints) then
                if (i > COMBOFRAMELAST_NUM_POINTS) then
                    -- Fade in the highlight and set a function that triggers when it is done fading
                    fadeInfo.mode = "IN";
                    fadeInfo.timeToFade = COMBOFRAME_HIGHLIGHT_FADE_IN;
                    fadeInfo.finishedFunc = ComboPointShineFadeIn;
                    fadeInfo.finishedArg1 = comboPointShine;
                    UIFrameFade(comboPointHighlight, fadeInfo);
                end
            else
                if GetCVarBool("colorblindMode") then
                    comboPoint:Hide();
                end
                comboPointHighlight:SetAlpha(0);
                comboPointShine:SetAlpha(0);
            end
            comboPoint:Show();
            comboIndex = comboIndex + 1;
        end
    else
        self.ComboPoints[1].Highlight:SetAlpha(0);
        self.ComboPoints[1].Shine:SetAlpha(0);
        self:Hide();
    end
    COMBOFRAMELAST_NUM_POINTS = comboPoints;
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:RegisterEvent("PLAYER_ENTERING_WORLD")
CF:RegisterEvent("UNIT_POWER_UPDATE")

CF:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not RougeUI.db.cfix then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            return
        end
        hooksecurefunc("ComboFrame_Update", ComboUpdate)
    elseif event == "PLAYER_ENTERING_WORLD" then
        comboPointsCache = {}
    elseif event == "UNIT_POWER_UPDATE" then
        ComboFrame_Update(ComboFrame)
    end
end)