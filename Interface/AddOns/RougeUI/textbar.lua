local addonName, RougeUI = ...
local FontType = STANDARD_TEXT_FONT
local mfloor, tonumber, mceil = math.floor, tonumber, math.ceil
local GetCVar, UnitIsDeadOrGhost, UnitExists = GetCVar, UnitIsDeadOrGhost, UnitExists
local UnitPower, UnitPowerMax, UnitHealth, UnitHealthMax = UnitPower, UnitPowerMax, UnitHealth, UnitHealthMax
local isClassic = false
local isTBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
local MiniHealth = false

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


local function New_TextStatusBar_UpdateTextStringWithValues(self, textString, value, valueMin, valueMax)
    if not self.TextString then return end

    if self.LeftText and self.RightText then
        self.LeftText:SetText("");
        self.RightText:SetText("");
        self.LeftText:Hide();
        self.RightText:Hide();
    end

    if ( ( tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not ( self.pauseUpdates ) ) then
        if self.finalValue then
            value = self.finalValue
        end

        if ( (self.cvar and GetCVar(self.cvar) == "1" and self.textLockable) or self.forceShow ) then
            textString:Show();
        elseif ( self.lockShow > 0 and (not self.forceHideText) ) then
            textString:Show();
        else
            textString:SetText("");
            textString:Hide();
            return;
        end

        if ( value == 0 and self.zeroText ) then
            textString:SetText(self.zeroText);
            textString:Show()
            return;
        end

        local showPercentage = self.showPercentage

        if MiniHealth then
            local realHealth = MiniHealthNumbersApi.v1:GetHealth(self.unit)
            if UnitIsPlayer(self.unit) and realHealth ~= nil and not self.powerType then
                value = realHealth
                showPercentage = false
            end
        end

        local valueDisplay = value;
        local valueMaxDisplay = valueMax

        if RougeUI.db.ShortNumeric or RougeUI.db.Abbreviate then
            valueDisplay = true_format(value)
            valueMaxDisplay = true_format(valueMax)
        end

        local shouldUsePrefix = self.prefix and (self.alwaysPrefix or not (self.cvar and GetCVar(self.cvar) == "1" and self.textLockable) );
        local displayMode = GetCVar("statusTextDisplay");

        if (isTBC or isClassic) and showPercentage and not UnitIsPlayer(self.unit) then
            showPercentage = false
        end

        if self.showNumeric then
            displayMode = STATUS_TEXT_DISPLAY_MODE.NUMERIC;
        elseif showPercentage then
            displayMode = STATUS_TEXT_DISPLAY_MODE.PERCENT;
        end

        if ( self.disablePercentages and displayMode == STATUS_TEXT_DISPLAY_MODE.PERCENT ) then
            displayMode = STATUS_TEXT_DISPLAY_MODE.NUMERIC;
        end

        if ( valueMax <= 0 or displayMode == STATUS_TEXT_DISPLAY_MODE.NUMERIC or displayMode == STATUS_TEXT_DISPLAY_MODE.NONE) then
            if ( shouldUsePrefix ) then
                textString:SetText(self.prefix.." "..valueDisplay.." / "..valueMaxDisplay);
            else
                if RougeUI.db.Abbreviate or RougeUI.db.ShortNumeric then
                    if (value > 1e7) then
                        textString:SetFormattedText("%s || %.0f%%", valueDisplay, 100 * value / valueMax);
                    else
                        textString:SetText(valueDisplay);
                    end
                else
                    textString:SetText(valueDisplay.." / "..valueMaxDisplay);
                end
            end
        elseif ( displayMode == STATUS_TEXT_DISPLAY_MODE.BOTH ) then
            if ( self.LeftText and self.RightText ) then
                if ( not self.disablePercentages and (not self.powerToken or self.powerToken == "MANA") ) then
                    self.LeftText:SetText(mceil((value / valueMax) * 100) .. "%");
                    self.LeftText:Show()
                end
                self.RightText:SetText(valueDisplay);
                self.RightText:Show();
                textString:Hide();
            else
                if RougeUI.db.Abbreviate or RougeUI.db.ShortNumeric then
                    valueDisplay = "(" .. mceil((value / valueMax) * 100) .. "%) " .. valueDisplay;
                else
                    valueDisplay = "(" .. mceil((value / valueMax) * 100) .. "%) " .. valueDisplay .. " / " .. valueMaxDisplay;
                end
                textString:SetText(valueDisplay);
            end
        elseif ( displayMode == STATUS_TEXT_DISPLAY_MODE.PERCENT ) then
            local percentVal = math.ceil((value / valueMax) * 100) .. "%";
            if ( shouldUsePrefix ) then
                textString:SetText(self.prefix .. " " .. percentVal);
            else
                textString:SetText(percentVal);
            end
        end
    else
        textString:Hide()
        textString:SetText("")
    end
end


local function PartyStatusBarText()
    for pFrame in PartyFrame.PartyMemberFramePool:EnumerateActive() do
        if pFrame then
            local name = pFrame.name
            local healthBar = pFrame.HealthBar
            local manaBar = pFrame.ManaBar

            local healthText = name:GetParent():CreateFontString(nil, "OVERLAY", "TextStatusBarText")
            healthText:SetPoint("CENTER", 20, 12)
            Mixin(TextStatusBarMixin, healthBar)
            healthBar:SetBarText(healthText)

            local manaText = name:GetParent():CreateFontString(nil, "OVERLAY", "TextStatusBarText")
            manaText:SetPoint("CENTER", 20, 2)
            Mixin(TextStatusBarMixin, manaBar)
            manaBar:SetBarText(manaText)

            healthBar.TextString:SetFont(FontType, 11, "OUTLINE")
            manaBar.TextString:SetFont(FontType, 11, "OUTLINE")

            if (RougeUI.db.smooth or RougeUI.db.ShortNumeric or RougeUI.db.Abbreviate) then
                hooksecurefunc(healthBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
                hooksecurefunc(manaBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
            end
        end
    end
end

local PW = CreateFrame("Frame")
PW:RegisterEvent("PLAYER_LOGIN")
PW:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_LOGIN" then
      -- if (RougeUI.db.smooth or RougeUI.db.ShortNumeric or RougeUI.db.Abbreviate) then
            hooksecurefunc(PlayerFrameHealthBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
            hooksecurefunc(PlayerFrameManaBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)

            hooksecurefunc(TargetFrameHealthBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
            hooksecurefunc(TargetFrameManaBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)

            if FocusFrame then
                hooksecurefunc(FocusFrameHealthBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
                hooksecurefunc(FocusFrameManaBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
            end

            hooksecurefunc(PetFrameHealthBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
            hooksecurefunc(PetFrameManaBar, "UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
     --   end

        if RougeUI.db.PartyText then
            PartyStatusBarText()
        end

        isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
        if isClassic and not C_AddOns.IsAddOnLoaded("ModernTargetFrame") then
            CreateStatusText()
            RougeUI.RougeUIF:CusFonts()
        end
        
        if C_AddOns.IsAddOnLoaded("MiniHealthNumbers") and MiniHealthNumbersApi.v1.GetHealth then
            MiniHealthNumbersApi.v1:PassiveMode(addonName)
            MiniHealth = true
        end
    end
end)