local FontType = STANDARD_TEXT_FONT
local mfloor, tonumber, mceil = math.floor, tonumber, math.ceil
local GetCVar, UnitIsDeadOrGhost = GetCVar, UnitIsDeadOrGhost
local UnitExists = UnitExists
local UnitPower, UnitPowerMax, UnitHealth, UnitHealthMax = UnitPower, UnitPowerMax, UnitHealth, UnitHealthMax
local hooksecurefunc = hooksecurefunc

function RougeUIF:CusFonts()
    PlayerFrameHealthBar.TextString:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")
    PlayerFrameHealthBar.LeftText:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")
    PlayerFrameHealthBar.RightText:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")

    PlayerFrameManaBar.TextString:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
    PlayerFrameManaBar.LeftText:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
    PlayerFrameManaBar.RightText:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")

    PetFrameHealthBar.TextString:SetFont(FontType, RougeUI.HPFontSize - 2, "OUTLINE")
    PetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.HPFontSize - 2, "OUTLINE")
    PetFrameHealthBar.RightText:SetFont(FontType, RougeUI.HPFontSize - 2, "OUTLINE")

    PetFrameManaBar.TextString:SetFont(FontType, RougeUI.ManaFontSize - 2, "OUTLINE")
    PetFrameManaBar.LeftText:SetFont(FontType, RougeUI.ManaFontSize - 2, "OUTLINE")
    PetFrameManaBar.RightText:SetFont(FontType, RougeUI.ManaFontSize - 2, "OUTLINE")

    TargetFrameHealthBar.TextString:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")
    TargetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")
    TargetFrameHealthBar.RightText:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")

    TargetFrameManaBar.TextString:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
    TargetFrameManaBar.LeftText:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
    TargetFrameManaBar.RightText:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")

    FocusFrameHealthBar.TextString:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")
    FocusFrameHealthBar.LeftText:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")
    FocusFrameHealthBar.RightText:SetFont(FontType, RougeUI.HPFontSize, "OUTLINE")

    FocusFrameManaBar.TextString:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
    FocusFrameManaBar.LeftText:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
    FocusFrameManaBar.RightText:SetFont(FontType, RougeUI.ManaFontSize, "OUTLINE")
end

local function true_format(value)
    if (RougeUI.ShortNumeric == true) then
        if value > 1e7 then
            return (mfloor(value / 1e6)) .. 'm'
        elseif value > 1e6 then
            return (mfloor((value / 1e6) * 10) / 10) .. 'm'
        elseif value > 1e4 then
            return (mfloor(value / 1e3)) .. 'k'
        elseif value > 1e3 then
            return (mfloor((value / 1e3) * 10) / 10) .. 'k'
        else
            return value
        end
    elseif (RougeUI.ShortNumeric == false) then
        return value
    end
end

local function New_TextStatusBar_UpdateTextStringWithValues(statusFrame, textString, value, valueMin, valueMax)
    local value = statusFrame.finalValue or statusFrame:GetValue();
    local unit = statusFrame.unit

    if (statusFrame.LeftText and statusFrame.RightText) then
        statusFrame.LeftText:SetText("");
        statusFrame.RightText:SetText("");
        statusFrame.LeftText:Hide();
        statusFrame.RightText:Hide();
    end

    if ((tonumber(valueMax) ~= valueMax or valueMax > 0) and not (statusFrame.pauseUpdates)) then
        statusFrame:Show();

        if ((statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) or statusFrame.forceShow) then
            textString:Show();
        elseif (statusFrame.lockShow > 0 and (not statusFrame.forceHideText)) then
            textString:Show();
        else
            textString:SetText("");
            textString:Hide();
            return ;
        end

        local valueDisplay = value;
        local valueMaxDisplay = valueMax;

        local textDisplay = GetCVar("statusTextDisplay");
        if (value and valueMax > 0 and ((textDisplay ~= "NUMERIC" and textDisplay ~= "NONE") or statusFrame.showPercentage) and not statusFrame.showNumeric) then
            if (value == 0 and statusFrame.zeroText) then
                textString:SetText(statusFrame.zeroText);
                statusFrame.isZero = 1;
                textString:Show();
            elseif (textDisplay == "BOTH" and not statusFrame.showPercentage) then
                if (statusFrame.LeftText and statusFrame.RightText) then
                    if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                        statusFrame.LeftText:SetText(mceil((value / valueMax) * 100) .. "%");
                        statusFrame.LeftText:Show();
                    end
                    if RougeUI.ShortNumeric then
                        statusFrame.RightText:SetText(true_format(valueDisplay));
                    else
                        statusFrame.RightText:SetText(valueDisplay);
                    end
                    statusFrame.RightText:Show();
                    textString:Hide();
                else
                    valueDisplay = "(" .. mceil((value / valueMax) * 100) .. "%) " .. valueDisplay .. " / " .. valueMaxDisplay;
                end
                textString:SetText(valueDisplay);
            else
                valueDisplay = mceil((value / valueMax) * 100) .. "%";
                if (statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                    textString:SetText(statusFrame.prefix .. " " .. valueDisplay);
                else
                    textString:SetText(valueDisplay);
                end
            end
        elseif (value == 0 and statusFrame.zeroText) then
            textString:SetText(statusFrame.zeroText);
            statusFrame.isZero = 1;
            textString:Show();
            return ;
        else
            statusFrame.isZero = nil;
            if (statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                textString:SetText(statusFrame.prefix .. " " .. valueDisplay .. " / " .. valueMaxDisplay);
            else
                if RougeUI.Abbreviate or RougeUI.ShortNumeric then
                    if (value > 1e5) then
                        textString:SetFormattedText("%s || %.0f%%", true_format(value), 100 * value / valueMax);
                    else
                        textString:SetText(true_format(value))
                    end
                else
                    textString:SetText(valueDisplay .. " / " .. valueMaxDisplay);
                end
            end
        end
    elseif unit and UnitIsDeadOrGhost(unit) then
        textString:SetText("")
    else
        textString:Hide();
        textString:SetText("");
        if (not statusFrame.alwaysShow) then
            statusFrame:Hide();
        else
            statusFrame:SetValue(0);
        end
    end
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" and (RougeUI.smooth or RougeUI.ShortNumeric or RougeUI.Abbreviate) then
        hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end);

local function PartyStatusBarText()
    if not PartyText then
        for i = 1, 4, 1 do
            local PartyText = CreateFrame("Frame", nil, _G["PartyMemberFrame" .. i])
            PartyText:SetFrameStrata("HIGH")
            PartyText:Show()

            PartyText.HealthText = PartyText:CreateFontString("PartyMemberFrame" .. i .. "HealthBarText", "OVERLAY", "TextStatusBarText");
            PartyText.HealthText:SetFont(FontType, 10, "OUTLINE")
            PartyText.HealthText:SetAllPoints(_G["PartyMemberFrame" .. i .. "HealthBar"])

            PartyText.ManaText = PartyText:CreateFontString("PartyMemberFrame" .. i .. "ManaBarText", "OVERLAY", "TextStatusBarText");
            PartyText.ManaText:SetFont(FontType, 10, "OUTLINE")
            PartyText.ManaText:SetAllPoints(_G["PartyMemberFrame" .. i .. "ManaBar"])
        end
    end
end

local function UpdatePartyMana(unit)
    local id = string.gsub(unit, "party([1-4])", "%1");
    local manatext
    local currMana, maxMana = UnitPower(unit), UnitPowerMax(unit)
    if RougeUI.ShortNumeric then
        manatext = true_format(currMana)
    elseif RougeUI.Abbreviate then
        manatext = currMana
    else
        manatext = currMana .. "/" .. maxMana
    end

    if id then
        _G["PartyMemberFrame" .. id .. "ManaBarText"]:SetText(manatext);
    end
end

local function UpdatePartyHealth(unit)
    local id = string.gsub(unit, "party([1-4])", "%1");
    local hptext
    local currHP, maxHP = UnitHealth(unit), UnitHealthMax(unit)
    if RougeUI.ShortNumeric then
        hptext = true_format(currHP)
    elseif RougeUI.Abbreviate then
        hptext = currHP
    else
        hptext = currHP .. "/" .. maxHP
    end

    if id then
        _G["PartyMemberFrame" .. id .. "HealthBarText"]:SetText(hptext)
    end
end

local PW = CreateFrame("Frame")
PW:RegisterEvent("PLAYER_LOGIN")
PW:RegisterEvent("UNIT_HEALTH_FREQUENT")
PW:RegisterEvent("UNIT_POWER_FREQUENT")
PW:SetScript("OnEvent", function(self, event, unit)
    if not RougeUI.PartyText then
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
        return
    end

    if event == "PLAYER_LOGIN" then
        hooksecurefunc("PartyMemberFrame_UpdateMember", function(self)
            local i = self:GetID()
            if UnitExists("party" .. i) then
                UpdatePartyMana("party" .. i)
                UpdatePartyHealth("party" .. i)
            end
        end)
        PartyStatusBarText()
        self:UnregisterEvent("PLAYER_LOGIN")
    end

    if not (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
        return
    end

    if event == "UNIT_HEALTH_FREQUENT" then
        if UnitExists(unit) then
            UpdatePartyHealth(unit);
        end
    elseif event == "UNIT_POWER_FREQUENT" then
        if UnitExists(unit) then
            UpdatePartyMana(unit)
        end
    end
end)