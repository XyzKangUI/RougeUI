local _, RougeUI = ...
local comboPoints = 0;
local comboPointsCache = {};
local targetGUID
local COMBOFRAME_FADE_IN = 0;
local COMBOFRAME_HIGHLIGHT_FADE_IN = 0;
local COMBOFRAMELAST_NUM_POINTS = 0;

local function ComboUpdate()
    targetGUID = UnitGUID("target")
    if UnitIsPossessed("target") and UnitIsPlayer("target") then
        comboPoints = comboPointsCache[targetGUID] or 0;
    else
        comboPoints = GetComboPoints("player", "target");
        if UnitIsPlayer("target") and targetGUID ~= nil then
            comboPointsCache[targetGUID] = comboPoints
        end
    end

    local comboPoint, comboPointHighlight, comboPointShine;

    if ( comboPoints > 0 ) then
        if ( not ComboFrame:IsShown() ) then
            ComboFrame:Show();
            UIFrameFadeIn(ComboFrame, COMBOFRAME_FADE_IN);
        end

        for i=1, MAX_COMBO_POINTS do
            local fadeInfo = {};
            comboPoint = _G["ComboPoint" .. i];
            comboPoint:Show();
            comboPointHighlight = _G["ComboPoint"..i.."Highlight"];
            comboPointShine = _G["ComboPoint"..i.."Shine"];
            if ( i <= comboPoints ) then
                if ( i > COMBOFRAMELAST_NUM_POINTS ) then
                    -- Fade in the highlight and set a function that triggers when it is done fading
                    fadeInfo.mode = "IN";
                    fadeInfo.timeToFade = COMBOFRAME_HIGHLIGHT_FADE_IN;
                    fadeInfo.finishedFunc = ComboPointShineFadeIn;
                    fadeInfo.finishedArg1 = comboPointShine;
                    UIFrameFade(comboPointHighlight, fadeInfo);
                end
            else
                if ( ENABLE_COLORBLIND_MODE == "1" ) then
                    comboPoint:Hide();
                end
                comboPointHighlight:SetAlpha(0);
                comboPointShine:SetAlpha(0);
            end
        end
    else
        ComboPoint1Highlight:SetAlpha(0);
        ComboPoint1Shine:SetAlpha(0);
        ComboFrame:Hide();
    end
    COMBOFRAMELAST_NUM_POINTS = comboPoints;
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:RegisterEvent("PLAYER_ENTERING_WORLD")
CF:RegisterEvent("UNIT_COMBO_POINTS")

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
    elseif event == "UNIT_COMBO_POINTS" then
        ComboFrame_Update(ComboFrame)
    end
end)