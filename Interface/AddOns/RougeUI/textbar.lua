local _, RougeUI = ...
local FontType = STANDARD_TEXT_FONT
local mfloor, tonumber, mceil = math.floor, tonumber, math.ceil
local GetCVar, UnitIsDeadOrGhost, UnitExists = GetCVar, UnitIsDeadOrGhost, UnitExists
local UnitPower, UnitPowerMax, UnitHealth, UnitHealthMax = UnitPower, UnitPowerMax, UnitHealth, UnitHealthMax
local isClassic = false

local function round(value)
    return mfloor(value + 0.5)
end

local function CreateText(name, parentName, point, x, y)
    local fontString = TargetFrameTextureFrame:CreateFontString(parentName .. name, nil, "TextStatusBarText")
    fontString:SetPoint(point, TargetFrameTextureFrame, point, x, y)

    return fontString
end

local function CreateStatusText()
    if not TargetFrameHealthBar.TextString then
        TargetFrameHealthBar.TextString = CreateText("Text", "TargetFrameHealthBar", "CENTER", -50, 3)
    end
    if not TargetFrameHealthBar.LeftText then
        TargetFrameHealthBar.LeftText = CreateText("TextLeft", "TargetFrameHealthBar", "LEFT", 8, 3)
    end
    if not TargetFrameHealthBar.RightText then
        TargetFrameHealthBar.RightText = CreateText("TextRight", "TargetFrameHealthBar", "RIGHT", -110, 3)
    end
    if not TargetFrameManaBar.TextString then
        TargetFrameManaBar.TextString = CreateText("Text", "TargetFrameManaBar", "CENTER", -50, -8)
    end
    if not TargetFrameManaBar.LeftText then
        TargetFrameManaBar.LeftText = CreateText("TextLeft", "TargetFrameManaBar", "LEFT", 8, -8)
    end
    if not TargetFrameManaBar.RightText then
        TargetFrameManaBar.RightText = CreateText("TextRight", "TargetFrameManaBar", "RIGHT", -110, -8)
    end
end

function RougeUI.RougeUIF:CusFonts()
    if not RougeUI.db.defaultFont then
        FontType = PlayerFrameHealthBarText:GetFont()
    end

    if PlayerFrameHealthBar and PlayerFrameHealthBar.TextString then
        PlayerFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
        PlayerFrameHealthBar.LeftText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
        PlayerFrameHealthBar.RightText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
    end

    if PlayerFrameManaBar and PlayerFrameManaBar.TextString then
        PlayerFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        PlayerFrameManaBar.LeftText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        PlayerFrameManaBar.RightText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
    end

    if PetFrameHealthBar and PetFrameHealthBar.TextString then
        PetFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize - 2, "OUTLINE")
        if PetFrameHealthBar.LeftText then
            PetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.db.HPFontSize - 2, "OUTLINE")
        end
        if PetFrameHealthBar.RightText then
            PetFrameHealthBar.RightText:SetFont(FontType, RougeUI.db.HPFontSize - 2, "OUTLINE")
        end
    end

    if PetFrameManaBar and PetFrameManaBar.TextString then
        PetFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize - 2, "OUTLINE")
        if PetFrameManaBar.LeftText then
            PetFrameManaBar.LeftText:SetFont(FontType, RougeUI.db.ManaFontSize - 2, "OUTLINE")
        end
        if PetFrameManaBar.RightText then
            PetFrameManaBar.RightText:SetFont(FontType, RougeUI.db.ManaFontSize - 2, "OUTLINE")
        end
    end

    if TargetFrameHealthBar and TargetFrameHealthBar.TextString then
        TargetFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
        TargetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
        TargetFrameHealthBar.RightText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")

        TargetFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        TargetFrameManaBar.LeftText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        TargetFrameManaBar.RightText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
    end

    if FocusFrameHealthBar and FocusFrameHealthBar.TextString then
        FocusFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
        FocusFrameHealthBar.LeftText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
        FocusFrameHealthBar.RightText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")

        FocusFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        FocusFrameManaBar.LeftText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        FocusFrameManaBar.RightText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
    end

    for i = 1, 5 do
        if _G["ArenaEnemyFrame" .. i] then
            local hp = _G["ArenaEnemyFrame" .. i .. "HealthBar"]
            local mana = _G["ArenaEnemyFrame" .. i .. "ManaBar"]
            hp.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
            hp.LeftText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
            hp.RightText:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
            mana.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
            mana.LeftText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
            mana.RightText:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
        end
    end
end

local function true_format(value)
    if (RougeUI.db.ShortNumeric == true) then
        if value > 1e7 then
            return (round(value / 1e6)) .. 'm'
        elseif value > 1e6 then
            return (round((value / 1e6) * 10) / 10) .. 'm'
        elseif value > 1e4 then
            return (round(value / 1e3)) .. 'k'
        elseif value > 1e3 then
            return (round((value / 1e3) * 10) / 10) .. 'k'
        else
            return value
        end
    elseif (RougeUI.db.ShortNumeric == false) then
        return AbbreviateLargeNumbers(value)
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
        local showPercentage = statusFrame.showPercentage

        if isClassic then
            if not UnitIsPlayer(statusFrame.unit) and statusFrame.showPercentage then
                showPercentage = false
            end
        end
        if (value and valueMax > 0 and ((textDisplay ~= "NUMERIC" and textDisplay ~= "NONE") or showPercentage) and not statusFrame.showNumeric) then
            if (value == 0 and statusFrame.zeroText) then
                textString:SetText(statusFrame.zeroText);
                statusFrame.isZero = 1;
                textString:Show();
            elseif (textDisplay == "BOTH" and not showPercentage) then
                if (statusFrame.LeftText and statusFrame.RightText) then
                    if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                        statusFrame.LeftText:SetText(mceil((value / valueMax) * 100) .. "%");
                        statusFrame.LeftText:Show();
                    end
                    if RougeUI.db.ShortNumeric then
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
                if RougeUI.db.Abbreviate or RougeUI.db.ShortNumeric then
                    if (value > 1e7) then
                        textString:SetFormattedText("%s || %.0f%%", true_format(value), 100 * value / valueMax);
                    else
                        textString:SetText(true_format(value))
                    end
                else
                    textString:SetText(valueDisplay .. " / " .. valueMaxDisplay);
                end
            end
        end
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

local function PartyStatusBarText()
    for i = 1, 4, 1 do
        local partyFrame = _G["PartyMemberFrame" .. i]
        if partyFrame then
            local name = _G["PartyMemberFrame" .. i .. "Name"]
            local healthBar = _G["PartyMemberFrame" .. i .. "HealthBar"]
            local manaBar = _G["PartyMemberFrame" .. i .. "ManaBar"]

            local healthText = name:GetParent():CreateFontString("PartyMemberFrame" .. i .. "HealthBarText", "OVERLAY", "TextStatusBarText")
            healthText:SetPoint("CENTER", 20, 12)
            SetTextStatusBarText(healthBar, healthText)

            local manaText = name:GetParent():CreateFontString("PartyMemberFrame" .. i .. "ManaBarText", "OVERLAY", "TextStatusBarText")
            manaText:SetPoint("CENTER", 20, 2)
            SetTextStatusBarText(manaBar, manaText)

            healthBar.TextString:SetFont(FontType, 11, "OUTLINE")
            manaBar.TextString:SetFont(FontType, 11, "OUTLINE")
        end
    end
end

local PW = CreateFrame("Frame")
PW:RegisterEvent("PLAYER_LOGIN")
PW:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_LOGIN" then
        if (RougeUI.db.smooth or RougeUI.db.ShortNumeric or RougeUI.db.Abbreviate) then
            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
        end

        if RougeUI.db.PartyText then
            PartyStatusBarText()
        end

        isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
        if isClassic and not IsAddOnLoaded("ModernTargetFrame") then
            CreateStatusText()
            RougeUI.RougeUIF:CusFonts()
        end
    end
end)