local _, RougeUI = ...
local FontType = STANDARD_TEXT_FONT
local mfloor, tonumber, mceil = math.floor, tonumber, math.ceil

local function round(value)
    return mfloor(value + 0.5)
end

function RougeUI.RougeUIF:CusFonts()
    if PlayerFrameHealthBar and PlayerFrameHealthBar.TextString then
        PlayerFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
    end

    if PlayerFrameManaBar and PlayerFrameManaBar.TextString then
        PlayerFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
    end

    if PetFrameHealthBar and PetFrameHealthBar.TextString then
        PetFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize - 2, "OUTLINE")
    end

    if PetFrameManaBar and PetFrameManaBar.TextString then
        PetFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize - 2, "OUTLINE")
    end

    if TargetFrameHealthBar and TargetFrameHealthBar.TextString then
        TargetFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")

        TargetFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
    end

    if FocusFrameHealthBar and FocusFrameHealthBar.TextString then
        FocusFrameHealthBar.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")

        FocusFrameManaBar.TextString:SetFont(FontType, RougeUI.db.ManaFontSize, "OUTLINE")
    end

    for i = 1, 5 do
        if _G["ArenaEnemyFrame"..i] then
            local hp = _G["ArenaEnemyFrame"..i.."HealthBar"]
            local mana = _G["ArenaEnemyFrame"..i.."ManaBar"]
            hp.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
            mana.TextString:SetFont(FontType, RougeUI.db.HPFontSize, "OUTLINE")
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
        return value
    end
end

local function New_TextStatusBar_UpdateTextStringWithValues(textStatusBar)
    local textString = textStatusBar.TextString;

    if textString then
        local value = textStatusBar.finalValue or textStatusBar:GetValue();
        local _, valueMax = textStatusBar:GetMinMaxValues();

        if textStatusBar.currValue and textStatusBar.currValue > 0 then
            if RougeUI.db.ShortNumeric then
                textString:SetText(true_format(value));
            else
                textString:SetText(value);
            end
        else
            textString:Hide()
        end
    end
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" and (RougeUI.db.smooth or RougeUI.db.ShortNumeric or RougeUI.db.Abbreviate) then
        hooksecurefunc("TextStatusBar_UpdateTextString", New_TextStatusBar_UpdateTextStringWithValues)
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end);