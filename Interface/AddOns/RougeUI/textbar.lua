local FontType = "Fonts\\FRIZQT__.ttf";
local mfloor, tonumber, mceil = math.floor, tonumber, math.ceil
local GetCVar, UnitIsDeadOrGhost = GetCVar, UnitIsDeadOrGhost

function RougeUIF:CusFonts()
    PlayerFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    PlayerFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    PetFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")

    PetFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")

    TargetFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    TargetFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    FocusFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    FocusFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
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
                    statusFrame.RightText:SetText(valueDisplay);
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