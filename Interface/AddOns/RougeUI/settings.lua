local Name, ns = ...;
local Title = select(2, GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$", "");
local floor = math.floor
local format = format
local CreateFrame, _G = CreateFrame, _G

local function RoundNumbers(val, valStep)
    return floor(val / valStep) * valStep
end

RougeUI = { Class_Portrait, ClassHP, GradientHP, FastKeyPress, ShortNumeric, ManaFontSize, HPFontSize, SelfSize, OtherBuffSize, HighlightDispellable, TimerGap, ScoreBoard, HideTitles,
            FadeIcon, CombatIndicator, CastTimer, smooth, pimp, retab, skinbuttons, Colval, ArenaNumbers, SQFix, classoutline, HideAggro, unithp, Stance, HideHotkey,
            ClassBG, AutoReady, EnemyTicks, ThickFrames, HideIndicator, Abbreviate, ModPlates, AuraRow, BuffAlpha, ButtonAnim, PChain, PartyText, BuffSizer }

RougeUIF = {}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)
function f:ADDON_LOADED()
    if RougeUI.Class_Portrait == nil then
        RougeUI.Class_Portrait = false;
    end
    if RougeUI.ClassHP == nil then
        RougeUI.ClassHP = false;
    end
    if RougeUI.GradientHP == nil then
        RougeUI.GradientHP = false;
    end
    if RougeUI.FastKeyPress == nil then
        RougeUI.FastKeyPress = false;
    end
    if RougeUI.ShortNumeric == nil then
        RougeUI.ShortNumeric = false;
    end
    if RougeUI.ManaFontSize == nil then
        RougeUI.ManaFontSize = 11;
    end
    if RougeUI.HPFontSize == nil then
        RougeUI.HPFontSize = 11;
    end
    if RougeUI.SelfSize == nil then
        RougeUI.SelfSize = 23;
    end
    if RougeUI.OtherBuffSize == nil then
        RougeUI.OtherBuffSize = 23;
    end
    if RougeUI.HighlightDispellable == nil then
        RougeUI.HighlightDispellable = false;
    end
    if RougeUI.TimerGap == nil then
        RougeUI.TimerGap = false;
    end
    if RougeUI.ScoreBoard == nil then
        RougeUI.ScoreBoard = false;
    end
    if RougeUI.HideTitles == nil then
        RougeUI.HideTitles = false;
    end
    if RougeUI.FadeIcon == nil then
        RougeUI.FadeIcon = false;
    end
    if RougeUI.HideGlows == nil then
        RougeUI.HideGlows = false;
    end
    if RougeUI.CombatIndicator == nil then
        RougeUI.CombatIndicator = false;
    end
    if RougeUI.CastTimer == nil then
        RougeUI.CastTimer = false;
    end
    if RougeUI.smooth == nil then
        RougeUI.smooth = false;
    end
    if RougeUI.pimp == nil then
        RougeUI.pimp = false;
    end
    if RougeUI.retab == nil then
        RougeUI.retab = false;
    end
    if RougeUI.classoutline == nil then
        RougeUI.classoutline = false;
    end
    if RougeUI.skinbuttons == nil then
        RougeUI.skinbuttons = false;
    end
    if RougeUI.Colval == nil then
        RougeUI.Colval = 1;
    end
    if RougeUI.ArenaNumbers == nil then
        RougeUI.ArenaNumbers = false;
    end
    if RougeUI.SQFix == nil then
        RougeUI.SQFix = false;
    end
    if RougeUI.HideAggro == nil then
        RougeUI.HideAggro = false;
    end
    if RougeUI.unithp == nil then
        RougeUI.unithp = false;
    end
    if RougeUI.Stance == nil then
        RougeUI.Stance = false;
    end
    if RougeUI.HideHotkey == nil then
        RougeUI.HideHotkey = false;
    end
    if RougeUI.HideMacro == nil then
        RougeUI.HideMacro = false;
    end
    if RougeUI.ClassBG == nil then
        RougeUI.ClassBG = false;
    end
    if RougeUI.AutoReady == nil then
        RougeUI.AutoReady = false;
    end
    if RougeUI.EnemyTicks == nil then
        RougeUI.EnemyTicks = false;
    end
    if RougeUI.ThickFrames == nil then
        RougeUI.ThickFrames = false;
    end
    if RougeUI.HideIndicator == nil then
        RougeUI.HideIndicator = false;
    end
    if RougeUI.Abbreviate == nil then
        RougeUI.Abbreviate = false;
    end
    if RougeUI.ModPlates == nil then
        RougeUI.ModPlates = true
    end
    if RougeUI.AuraRow == nil then
        RougeUI.AuraRow = 108
    end
    if RougeUI.BuffAlpha == nil then
        RougeUI.BuffAlpha = false
    end
    if RougeUI.ButtonAnim == nil then
        RougeUI.ButtonAnim = false
    end
    if RougeUI.PChain == nil then
        RougeUI.PChain = nil
    end
    if RougeUI.PartyText == nil then
        RougeUI.PartyText = false
    end
    if RougeUI.BuffSizer == nil then
        RougeUI.BuffSizer = true
    end

    RougeUIF:CusFonts();

    if not f.options then
        f.options = f:CreateGUI()
    end
end

function f:CreateGUI()
    local Panel = CreateFrame("Frame", "$parentRougeUI_Config", InterfaceOptionsPanelContainer)
    do
        Panel.name = Title;
        InterfaceOptions_AddCategory(Panel);--	Panel Registration

        local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
        title:SetPoint("TOPLEFT", 12, -15);
        title:SetText(Title);

        local Filler = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        Filler:SetPoint("TOP", 0, -50)
        Filler:SetText("Welcome to RougeUI.")

        Panel.childPanel1 = CreateFrame("Frame", "$parentConfigChild_UnitFrame", Panel)
        Panel.childPanel1.name = "UnitFrame"
        Panel.childPanel1.parent = Panel.name
        InterfaceOptions_AddCategory(Panel.childPanel1)

        Panel.childPanel2 = CreateFrame("Frame", "$parentConfigChild_Tweaks", Panel)
        Panel.childPanel2.name = "Tweaks"
        Panel.childPanel2.parent = Panel.name
        InterfaceOptions_AddCategory(Panel.childPanel2)

        Panel.childPanel3 = CreateFrame("Frame", "$parentConfigChild_Hide", Panel)
        Panel.childPanel3.name = "Hide Elements"
        Panel.childPanel3.parent = Panel.name
        InterfaceOptions_AddCategory(Panel.childPanel3)

        for _, v in pairs({ Panel.childPanel1, Panel.childPanel2, Panel.childPanel3 }) do
            local Reload = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
            Reload:SetPoint("BOTTOMRIGHT", -10, 10)
            Reload:SetWidth(100)
            Reload:SetHeight(25)
            Reload:SetText("Save & Reload")
            Reload:SetScript("OnClick", function()
                ReloadUI()
            end)
        end

        function SlashCmdList.RougeUI()
            InterfaceOptionsFrame_OpenToCategory(Panel)
            InterfaceOptionsFrame_OpenToCategory(Panel)
        end
        SLASH_RougeUI1 = "/rui"

        print("|cffFFF468RougeUI|cffffffff loaded. Open options with: |cffFFF468/rui")

        --childPanel1

        local name = "ClassPortraitButton"
        local ClassPortraitButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ClassPortraitButton:SetPoint("TOPLEFT", 10, -40)
        ClassPortraitButton.text = _G[name .. "Text"]
        ClassPortraitButton.text:SetText("Show class portraits")
        ClassPortraitButton.text:SetVertexColor(1,1,1)
        ClassPortraitButton:SetChecked(RougeUI.Class_Portrait)
        ClassPortraitButton:SetScript("OnClick", function()
            RougeUI.Class_Portrait = not RougeUI.Class_Portrait
        end)

        local name = "ClassHP"
        local ClassHPButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ClassHPButton:SetPoint("TOPLEFT", 10, -75)
        ClassHPButton.text = _G[name .. "Text"]
        ClassHPButton.text:SetVertexColor(1,1,1)
        ClassHPButton.text:SetText("Class colored Healthbars")
        ClassHPButton:SetChecked(RougeUI.ClassHP)
        ClassHPButton:SetScript("OnClick", function()
            RougeUI.ClassHP = not RougeUI.ClassHP
        end)

        local name = "GradientHP"
        local GradientHPButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        GradientHPButton:SetPoint("TOPLEFT", 10, -110)
        GradientHPButton.text = _G[name .. "Text"]
        GradientHPButton.text:SetVertexColor(1,1,1)
        GradientHPButton.text:SetText("Gradient Healthbars")
        GradientHPButton:SetChecked(RougeUI.GradientHP)
        GradientHPButton:SetScript("OnClick", function()
            RougeUI.GradientHP = not RougeUI.GradientHP
        end)

        local name = "UnitHP"
        local UnitHPButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        UnitHPButton:SetPoint("TOPLEFT", 10, -145)
        UnitHPButton.text = _G[name .. "Text"]
        UnitHPButton.text:SetVertexColor(1,1,1)
        UnitHPButton.text:SetText("Color Healthbars by status (enemy/friendly/neutral)")
        UnitHPButton:SetChecked(RougeUI.unithp)
        UnitHPButton:SetScript("OnClick", function()
            RougeUI.unithp = not RougeUI.unithp
        end)

        local name = "ShortNumeric"
        local ShortNumericButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ShortNumericButton:SetPoint("TOPLEFT", 10, -180)
        ShortNumericButton.text = _G[name .. "Text"]
        ShortNumericButton.text:SetVertexColor(1,1,1)
        ShortNumericButton.text:SetText("Shorten 'NUMERIC' statusText to one decimal")
        ShortNumericButton:SetChecked(RougeUI.ShortNumeric)
        ShortNumericButton:SetScript("OnClick", function()
            RougeUI.ShortNumeric = not RougeUI.ShortNumeric
        end)

        local name = "Abbreviate"
        local AbbreviateButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        AbbreviateButton:SetPoint("TOPLEFT", 10, -215)
        AbbreviateButton.text = _G[name .. "Text"]
        AbbreviateButton.text:SetVertexColor(1,1,1)
        AbbreviateButton.text:SetText("Abbreviate statusText values")
        AbbreviateButton:SetChecked(RougeUI.Abbreviate)
        AbbreviateButton:SetScript("OnClick", function()
            RougeUI.Abbreviate = not RougeUI.Abbreviate
        end)

        local name = "PartyTextButton"
        local PartyTextButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        PartyTextButton:SetPoint("TOPLEFT", 10, -250)
        PartyTextButton.text = _G[name .. "Text"]
        PartyTextButton.text:SetVertexColor(1,1,1)
        PartyTextButton.text:SetText("Enable statusText on Party frames")
        PartyTextButton:SetChecked(RougeUI.PartyText)
        PartyTextButton:SetScript("OnClick", function()
            RougeUI.PartyText = not RougeUI.PartyText
        end)

        local name = "FadeIcon"
        local FadeIconButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        FadeIconButton:SetPoint("TOPLEFT", 350, -40)
        FadeIconButton.text = _G[name .. "Text"]
        FadeIconButton.text:SetVertexColor(1,1,1)
        FadeIconButton.text:SetText("Fade PvP Icon")
        FadeIconButton:SetChecked(RougeUI.FadeIcon)
        FadeIconButton:SetScript("OnClick", function()
            RougeUI.FadeIcon = not RougeUI.FadeIcon
        end)

        local name = "SmoothFrame"
        local SmoothFrameButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        SmoothFrameButton:SetPoint("TOPLEFT", 350, -75)
        SmoothFrameButton.text = _G[name .. "Text"]
        SmoothFrameButton.text:SetVertexColor(1,1,1)
        SmoothFrameButton.text:SetText("Smooth animated health & mana bar")
        SmoothFrameButton:SetChecked(RougeUI.smooth)
        SmoothFrameButton:SetScript("OnClick", function()
            RougeUI.smooth = not RougeUI.smooth
        end)

        local name = "PimpFrame"
        local PimpFrameButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        PimpFrameButton:SetPoint("TOPLEFT", 350, -110)
        PimpFrameButton.text = _G[name .. "Text"]
        PimpFrameButton.text:SetVertexColor(1,1,1)
        PimpFrameButton.text:SetText("Enable Violet colored manabar")
        PimpFrameButton:SetChecked(RougeUI.pimp)
        PimpFrameButton:SetScript("OnClick", function()
            RougeUI.pimp = not RougeUI.pimp
        end)

        local name = "ClassOutlines"
        local ClassOutlines = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ClassOutlines:SetPoint("TOPLEFT", 350, -145)
        ClassOutlines.text = _G[name .. "Text"]
        ClassOutlines.text:SetVertexColor(1,1,1)
        ClassOutlines.text:SetText("Add class colored outline to frames")
        ClassOutlines:SetChecked(RougeUI.classoutline)
        ClassOutlines:SetScript("OnClick", function()
            RougeUI.classoutline = not RougeUI.classoutline
        end)

        local name = "Skinbuttons"
        local Skinbuttons = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        Skinbuttons:SetPoint("TOPLEFT", 350, -180)
        Skinbuttons.text = _G[name .. "Text"]
        Skinbuttons.text:SetVertexColor(1,1,1)
        Skinbuttons.text:SetText("Apply modUI border theme")
        Skinbuttons:SetChecked(RougeUI.skinbuttons)
        Skinbuttons:SetScript("OnClick", function()
            RougeUI.skinbuttons = not RougeUI.skinbuttons
        end)

        local name = "ClassBG"
        local ClassBG = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ClassBG:SetPoint("TOPLEFT", 350, -215)
        ClassBG.text = _G[name .. "Text"]
        ClassBG.text:SetVertexColor(1,1,1)
        ClassBG.text:SetText("Class colored name background")
        ClassBG:SetChecked(RougeUI.ClassBG)
        ClassBG:SetScript("OnClick", function(self)
            if RougeUI.ThickFrames then
                UIErrorsFrame:AddMessage("This cannot be enabled with big frames", 1, 0, 0)
                self:SetChecked(nil)
            else
                RougeUI.ClassBG = self:GetChecked()
            end
        end)

        local name = "ThickFrame"
        local ThickFrame = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ThickFrame:SetPoint("TOPLEFT", 350, -250)
        ThickFrame.text = _G[name .. "Text"]
        ThickFrame.text:SetVertexColor(1,1,1)
        ThickFrame.text:SetText("Enable Big Frames")
        ThickFrame:SetChecked(RougeUI.ThickFrames)
        ThickFrame:SetScript("OnClick", function()
            RougeUI.ThickFrames = not RougeUI.ThickFrames
            RougeUI.ClassBG = false
        end)

        local name = "ModPlates"
        local ModPlates = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
        ModPlates:SetPoint("TOPLEFT", 350, -285)
        ModPlates.text = _G[name .. "Text"]
        ModPlates.text:SetVertexColor(1,1,1)
        ModPlates.text:SetText("ModUI Nameplate Style")
        ModPlates:SetChecked(RougeUI.ModPlates)
        ModPlates:SetScript("OnClick", function()
            RougeUI.ModPlates = not RougeUI.ModPlates
        end)

        local name = "FontSizeSlider"
        local FontSizeSlider = CreateFrame("Slider", name, Panel.childPanel1, "OptionsSliderTemplate")
        FontSizeSlider:SetPoint("TOPLEFT", 20, -460)
        FontSizeSlider.textLow = _G[name .. "Low"]
        FontSizeSlider.textHigh = _G[name .. "High"]
        FontSizeSlider.text = _G[name .. "Text"]
        FontSizeSlider:SetMinMaxValues(8, 16)
        FontSizeSlider.minValue, FontSizeSlider.maxValue = FontSizeSlider:GetMinMaxValues()
        FontSizeSlider.textLow:SetText(FontSizeSlider.minValue)
        FontSizeSlider.textHigh:SetText(FontSizeSlider.maxValue)
        FontSizeSlider:SetValue(RougeUI.HPFontSize)
        FontSizeSlider.text:SetText("HP Font Size " .. FontSizeSlider:GetValue(HealthFontSize))
        FontSizeSlider:SetValueStep(1)
        FontSizeSlider:SetObeyStepOnDrag(true);
        FontSizeSlider:SetScript("OnValueChanged", function(self)
            self.text:SetText("HP Font Size: " .. self:GetValue(RougeUI.HPFontSize))
            RougeUI.HPFontSize = self:GetValue()
            RougeUIF:CusFonts()
        end)

        local name = "MFontSizeSlider"
        local MFontSizeSlider = CreateFrame("Slider", name, Panel.childPanel1, "OptionsSliderTemplate")
        MFontSizeSlider:SetPoint("TOPLEFT", 20, -520)
        MFontSizeSlider.textLow = _G[name .. "Low"]
        MFontSizeSlider.textHigh = _G[name .. "High"]
        MFontSizeSlider.text = _G[name .. "Text"]
        MFontSizeSlider:SetMinMaxValues(8, 16)
        MFontSizeSlider.minValue, MFontSizeSlider.maxValue = MFontSizeSlider:GetMinMaxValues()
        MFontSizeSlider.textLow:SetText(MFontSizeSlider.minValue)
        MFontSizeSlider.textHigh:SetText(MFontSizeSlider.maxValue)
        MFontSizeSlider:SetValue(RougeUI.ManaFontSize)
        MFontSizeSlider.text:SetText("Mana Font Size " .. MFontSizeSlider:GetValue(ManaFontSize))
        MFontSizeSlider:SetValueStep(1)
        MFontSizeSlider:SetObeyStepOnDrag(true);
        MFontSizeSlider:SetScript("OnValueChanged", function(self)
            self.text:SetText("Mana Font Size: " .. self:GetValue(RougeUI.ManaFontSize))
            RougeUI.ManaFontSize = self:GetValue()
            RougeUIF:CusFonts()
        end)

        local names = "TargetPlayerBuffSizeSlider"
        local TargetPlayerBuffSizeSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        TargetPlayerBuffSizeSlider:SetPoint("TOPLEFT", 20, -340)
        if RougeUI.BuffSizer then
            TargetPlayerBuffSizeSlider:Show()
        else
            TargetPlayerBuffSizeSlider:Hide()
        end
        TargetPlayerBuffSizeSlider.textLow = _G[names .. "Low"]
        TargetPlayerBuffSizeSlider.textHigh = _G[names .. "High"]
        TargetPlayerBuffSizeSlider.text = _G[names .. "Text"]
        TargetPlayerBuffSizeSlider:SetMinMaxValues(15, 34)
        TargetPlayerBuffSizeSlider.minValue, TargetPlayerBuffSizeSlider.maxValue = TargetPlayerBuffSizeSlider:GetMinMaxValues()
        TargetPlayerBuffSizeSlider.textLow:SetText(TargetPlayerBuffSizeSlider.minValue)
        TargetPlayerBuffSizeSlider.textHigh:SetText(TargetPlayerBuffSizeSlider.maxValue)
        TargetPlayerBuffSizeSlider:SetValue(RougeUI.SelfSize)
        TargetPlayerBuffSizeSlider.text:SetText("Personal aura size: " .. format("%.f", TargetPlayerBuffSizeSlider:GetValue(SelfSize)));
        TargetPlayerBuffSizeSlider:SetValueStep(1)
        TargetPlayerBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetPlayerBuffSizeSlider:SetScript("OnValueChanged", function(_, value)
            if RougeUI.SelfSize ~= value then
                RougeUI.SelfSize = value;
                TargetPlayerBuffSizeSliderText:SetText("Personal (De)buff Size: " .. RoundNumbers(RougeUI.SelfSize, 1))
                RougeUIF:SetCustomBuffSize()
            end
        end)

        local names = "TargetBuffSizeSlider"
        local TargetBuffSizeSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        TargetBuffSizeSlider:SetPoint("TOPLEFT", 20, -400)
        if RougeUI.BuffSizer then
            TargetBuffSizeSlider:Show()
        else
            TargetBuffSizeSlider:Hide()
        end
        TargetBuffSizeSlider:SetMinMaxValues(15, 34)
        TargetBuffSizeSlider:SetValueStep(1)
        TargetBuffSizeSlider.textLow = _G[names .. "Low"]
        TargetBuffSizeSlider.textHigh = _G[names .. "High"]
        TargetBuffSizeSlider.text = _G[names .. "Text"]
        TargetBuffSizeSlider.minValue, TargetBuffSizeSlider.maxValue = TargetBuffSizeSlider:GetMinMaxValues()
        TargetBuffSizeSlider.textLow:SetText(floor(TargetBuffSizeSlider.minValue))
        TargetBuffSizeSlider.textHigh:SetText(floor(TargetBuffSizeSlider.maxValue))
        TargetBuffSizeSlider:SetValue(RougeUI.OtherBuffSize)
        TargetBuffSizeSlider.text:SetText("Target Aura Size: " .. format("%.f", TargetBuffSizeSlider:GetValue(OtherBuffSize)));
        TargetBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetBuffSizeSlider:SetScript("OnValueChanged", function(_, value)
            if RougeUI.OtherBuffSize ~= value then
                RougeUI.OtherBuffSize = value;
                TargetBuffSizeSliderText:SetText("Target Buff Size: " .. RoundNumbers(RougeUI.OtherBuffSize, 1))
                RougeUIF:SetCustomBuffSize()
            end
        end)

        local name = "ColorValueSlider"
        local ColorValueSlider = CreateFrame("Slider", name, Panel.childPanel1, "OptionsSliderTemplate")
        ColorValueSlider:SetMinMaxValues(0, 1)
        ColorValueSlider:SetPoint("TOPLEFT", 20, -400)
        ColorValueSlider.text = _G[name .. "Text"]
        ColorValueSlider.textLow = _G[name .. "Low"]
        ColorValueSlider.textHigh = _G[name .. "High"]
        ColorValueSlider.minValue, ColorValueSlider.maxValue = ColorValueSlider:GetMinMaxValues()
        ColorValueSlider.textLow:SetText(floor(ColorValueSlider.minValue))
        ColorValueSlider.textHigh:SetText(floor(ColorValueSlider.maxValue))
        ColorValueSlider:SetValue(RougeUI.Colval)
        ColorValueSlider.text:SetText("UI Brightness: " .. format("%.2f", ColorValueSlider:GetValue(Colval)))
        ColorValueSlider:SetValueStep(0.05)
        ColorValueSlider:SetObeyStepOnDrag(true);
        ColorValueSlider:SetScript("OnValueChanged", function(_, value)
            ColorValueSlider.text:SetText("UI Brightness: " .. RoundNumbers(RougeUI.Colval, 0.05))
            RougeUI.Colval = value
            RougeUIF:ChangeFrameColors()
        end)

        local names = "AuraRowSlider"
        local AuraRowSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        AuraRowSlider:SetPoint("TOPLEFT", 20, -460)
        if RougeUI.BuffSizer then
            AuraRowSlider:Show()
        else
            AuraRowSlider:Hide()
        end
        AuraRowSlider:SetMinMaxValues(108, 200)
        AuraRowSlider:SetValueStep(14)
        AuraRowSlider.textLow = _G[names .. "Low"]
        AuraRowSlider.textHigh = _G[names .. "High"]
        AuraRowSlider.text = _G[names .. "Text"]
        AuraRowSlider.minValue, AuraRowSlider.maxValue = AuraRowSlider:GetMinMaxValues()
        AuraRowSlider.textLow:SetText(floor(AuraRowSlider.minValue))
        AuraRowSlider.textHigh:SetText(floor(AuraRowSlider.maxValue))
        AuraRowSlider:SetValue(RougeUI.AuraRow)
        AuraRowSlider.text:SetText("Aura Row Width Size: " .. format("%.f", AuraRowSlider:GetValue(AuraRow)));
        AuraRowSlider:SetObeyStepOnDrag(true);
        AuraRowSlider:SetScript("OnValueChanged", function(_, value)
            if RougeUI.AuraRow ~= value then
                RougeUI.AuraRow = value;
                AuraRowSliderText:SetText("Increase to fit more Aura's per row: " .. RoundNumbers(RougeUI.AuraRow, 1))
                RougeUIF:SetCustomBuffSize()
            end
        end)

        -- childPanel2
        local name = "FastKeyPress"
        local FastKeyPressButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        FastKeyPressButton:SetPoint("TOPLEFT", 10, -215)
        FastKeyPressButton.text = _G[name .. "Text"]
        FastKeyPressButton.text:SetVertexColor(1,1,1)
        FastKeyPressButton.text:SetText("Cast spells on keypress down")
        FastKeyPressButton:SetChecked(RougeUI.FastKeyPress)
        FastKeyPressButton:SetScript("OnClick", function()
            RougeUI.FastKeyPress = not RougeUI.FastKeyPress
        end)
        FastKeyPressButton:RegisterEvent("PLAYER_LOGIN")
        FastKeyPressButton:SetScript("OnEvent", function(self, event, ...)
            if (event == "PLAYER_LOGIN") and RougeUI.FastKeyPress == true then
                SetCVar("ActionButtonUseKeyDown", 1)
                self:UnregisterEvent("PLAYER_LOGIN")
                self:SetScript("OnEvent", nil)
            end
        end)

        local name = "TimerGap"
        local TimerGapButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        TimerGapButton:SetPoint("TOPLEFT", 10, -75)
        TimerGapButton.text = _G[name .. "Text"]
        TimerGapButton.text:SetVertexColor(1,1,1)
        TimerGapButton.text:SetText("Remove space gap in (de)buff timer")
        TimerGapButton:SetChecked(RougeUI.TimerGap)
        TimerGapButton:SetScript("OnClick", function()
            RougeUI.TimerGap = not RougeUI.TimerGap
        end)

        local name = "ScoreBoard"
        local ScoreBoardButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        ScoreBoardButton:SetPoint("TOPLEFT", 10, -110)
        ScoreBoardButton.text = _G[name .. "Text"]
        ScoreBoardButton.text:SetVertexColor(1,1,1)
        ScoreBoardButton.text:SetText("Class colored PvP Scoreboard")
        ScoreBoardButton:SetChecked(RougeUI.ScoreBoard)
        ScoreBoardButton:SetScript("OnClick", function()
            RougeUI.ScoreBoard = not RougeUI.ScoreBoard
        end)

        local name = "CombatIndicator"
        local CombatIndicatorButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        CombatIndicatorButton:SetPoint("TOPLEFT", 10, -145)
        CombatIndicatorButton.text = _G[name .. "Text"]
        CombatIndicatorButton.text:SetVertexColor(1,1,1)
        CombatIndicatorButton.text:SetText("Enable Combat Indicator")
        CombatIndicatorButton:SetChecked(RougeUI.CombatIndicator)
        CombatIndicatorButton:SetScript("OnClick", function()
            RougeUI.CombatIndicator = not RougeUI.CombatIndicator
        end)

        local name = "CastTimer"
        local CastTimerButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        CastTimerButton:SetPoint("TOPLEFT", 10, -180)
        CastTimerButton.text = _G[name .. "Text"]
        CastTimerButton.text:SetVertexColor(1,1,1)
        CastTimerButton.text:SetText("Enable modUI castbar style with a timer")
        CastTimerButton:SetChecked(RougeUI.CastTimer)
        CastTimerButton:SetScript("OnClick", function()
            RougeUI.CastTimer = not RougeUI.CastTimer
        end)

        local name = "RetabBind"
        local RetabBind = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        RetabBind:SetPoint("TOPLEFT", 10, -40)
        RetabBind.text = _G[name .. "Text"]
        RetabBind.text:SetVertexColor(1,1,1)
        RetabBind.text:SetText("RETabBinder")
        RetabBind:SetChecked(RougeUI.retab)
        RetabBind:SetScript("OnClick", function()
            RougeUI.retab = not RougeUI.retab
        end)

        local name = "ButtonAnim"
        local ButtonAnim = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        ButtonAnim:SetPoint("TOPLEFT", 10, -250)
        ButtonAnim.text = _G[name .. "Text"]
        ButtonAnim.text:SetVertexColor(1,1,1)
        ButtonAnim.text:SetText("Animate Keypress (SnowfallKeyPress)")
        ButtonAnim:SetChecked(RougeUI.ButtonAnim)
        ButtonAnim:SetScript("OnClick", function()
            RougeUI.ButtonAnim = not RougeUI.ButtonAnim
        end)

        local name = "BuffSizer"
        local BuffSizerButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        BuffSizerButton:SetPoint("TOPLEFT", 10, -285)
        BuffSizerButton.text = _G[name .. "Text"]
        BuffSizerButton.text:SetVertexColor(1,1,1)
        BuffSizerButton.text:SetText("Enable for aura resizing")
        BuffSizerButton:SetChecked(RougeUI.BuffSizer)
        BuffSizerButton:SetScript("OnClick", function()
            RougeUI.BuffSizer = not RougeUI.BuffSizer
            RougeUIF:HookAuras()
            if RougeUI.BuffSizer then
                AuraRowSlider:Show()
                TargetBuffSizeSlider:Show()
                TargetPlayerBuffSizeSlider:Show()
            else
                AuraRowSlider:Hide()
                TargetBuffSizeSlider:Hide()
                TargetPlayerBuffSizeSlider:Hide()
            end
        end)

        local name = "ArenaNumbers"
        local ArenaNumbersButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        ArenaNumbersButton:SetPoint("TOPLEFT", 350, -40)
        ArenaNumbersButton.text = _G[name .. "Text"]
        ArenaNumbersButton.text:SetVertexColor(1,1,1)
        ArenaNumbersButton.text:SetText("Show arena number on nameplate")
        ArenaNumbersButton:SetChecked(RougeUI.ArenaNumbers)
        ArenaNumbersButton:SetScript("OnClick", function()
            RougeUI.ArenaNumbers = not RougeUI.ArenaNumbers
        end)

        local name = "SpellQueueWindow"
        local SQFixButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        SQFixButton:SetPoint("TOPLEFT", 350, -75)
        SQFixButton.text = _G[name .. "Text"]
        SQFixButton.text:SetVertexColor(1,1,1)
        SQFixButton.text:SetText("Auto-adjust SpellQueue Window")
        SQFixButton:SetChecked(RougeUI.SQFix)
        SQFixButton:SetScript("OnClick", function()
            RougeUI.SQFix = not RougeUI.SQFix
        end)

        local name = "AutoReady"
        local AutoReadyButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        AutoReadyButton:SetPoint("TOPLEFT", 350, -110)
        AutoReadyButton.text = _G[name .. "Text"]
        AutoReadyButton.text:SetVertexColor(1,1,1)
        AutoReadyButton.text:SetText("Auto accept raid/arena ready checks")
        AutoReadyButton:SetChecked(RougeUI.AutoReady)
        AutoReadyButton:SetScript("OnClick", function()
            RougeUI.AutoReady = not RougeUI.AutoReady
        end)

        local name = "EnemyTicks"
        local EnemyTicksButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        EnemyTicksButton:SetPoint("TOPLEFT", 350, -145)
        EnemyTicksButton.text = _G[name .. "Text"]
        EnemyTicksButton.text:SetVertexColor(1,1,1)
        EnemyTicksButton.text:SetText("Enable target mana/energy tick tracker")
        EnemyTicksButton:SetChecked(RougeUI.EnemyTicks)
        EnemyTicksButton:SetScript("OnClick", function()
            RougeUI.EnemyTicks = not RougeUI.EnemyTicks
        end)

        local name = "HighlightDispellable"
        local HighlightDispellableButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        HighlightDispellableButton:SetPoint("TOPLEFT", 350, -180)
        HighlightDispellableButton.text = _G[name .. "Text"]
        HighlightDispellableButton.text:SetVertexColor(1,1,1)
        HighlightDispellableButton.text:SetText("Highlight enemy's important Magic/Enrage buffs")
        HighlightDispellableButton:SetChecked(RougeUI.HighlightDispellable)
        HighlightDispellableButton:SetScript("OnClick", function()
            RougeUI.BuffSizer = true
            RougeUI.HighlightDispellable = not RougeUI.HighlightDispellable
        end)

        local name = "BuffAlpha"
        local BuffAlphaButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
        BuffAlphaButton:SetPoint("TOPLEFT", 350, -215)
        BuffAlphaButton.text = _G[name .. "Text"]
        BuffAlphaButton.text:SetVertexColor(1,1,1)
        BuffAlphaButton.text:SetText("Disable BuffFrame fading animation")
        BuffAlphaButton:SetChecked(RougeUI.BuffAlpha)
        BuffAlphaButton:SetScript("OnClick", function()
            RougeUI.BuffAlpha = not RougeUI.BuffAlpha
        end)

        --childPanel3

        local name = "HideGlows"
        local HideGlowsButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        HideGlowsButton:SetPoint("TOPLEFT", 10, -40)
        HideGlowsButton.text = _G[name .. "Text"]
        HideGlowsButton.text:SetVertexColor(1,1,1)
        HideGlowsButton.text:SetText("Hide all glows on Playerframe")
        HideGlowsButton:SetChecked(RougeUI.HideGlows)
        HideGlowsButton:SetScript("OnClick", function()
            RougeUI.HideGlows = not RougeUI.HideGlows
        end)

        local name = "HideIndicator"
        local HideIndicatorButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        HideIndicatorButton:SetPoint("TOPLEFT", 10, -75)
        HideIndicatorButton.text = _G[name .. "Text"]
        HideIndicatorButton.text:SetVertexColor(1,1,1)
        HideIndicatorButton.text:SetText("Hide combat text on portrait")
        HideIndicatorButton:SetChecked(RougeUI.HideIndicator)
        HideIndicatorButton:SetScript("OnClick", function()
            RougeUI.HideIndicator = not RougeUI.HideIndicator
        end)

        local name = "HideTitles"
        local HideTitlesButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        HideTitlesButton:SetPoint("TOPLEFT", 10, -110)
        HideTitlesButton.text = _G[name .. "Text"]
        HideTitlesButton.text:SetVertexColor(1,1,1)
        HideTitlesButton.text:SetText("Hide Group/Raid title")
        HideTitlesButton:SetChecked(RougeUI.HideTitles)
        HideTitlesButton:SetScript("OnClick", function()
            RougeUI.HideTitles = not RougeUI.HideTitles
        end)

        local name = "AggroHighlight"
        local AggroHighlightButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        AggroHighlightButton:SetPoint("TOPLEFT", 10, -145)
        AggroHighlightButton.text = _G[name .. "Text"]
        AggroHighlightButton.text:SetVertexColor(1,1,1)
        AggroHighlightButton.text:SetText("Hide Aggro highlight on default Raid Frames")
        AggroHighlightButton:SetChecked(RougeUI.HideAggro)
        AggroHighlightButton:SetScript("OnClick", function()
            RougeUI.HideAggro = not RougeUI.HideAggro
        end)

        local name = "HideStance"
        local HideStanceButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        HideStanceButton:SetPoint("TOPLEFT", 10, -180)
        HideStanceButton.text = _G[name .. "Text"]
        HideStanceButton.text:SetVertexColor(1,1,1)
        HideStanceButton.text:SetText("Hide Stance bar")
        HideStanceButton:SetChecked(RougeUI.Stance)
        HideStanceButton:SetScript("OnClick", function()
            RougeUI.Stance = not RougeUI.Stance
        end)

        local name = "HideHotkey"
        local HideHotkeyButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        HideHotkeyButton:SetPoint("TOPLEFT", 10, -215)
        HideHotkeyButton.text = _G[name .. "Text"]
        HideHotkeyButton.text:SetVertexColor(1,1,1)
        HideHotkeyButton.text:SetText("Hide hotkey labels on default actionbar")
        HideHotkeyButton:SetChecked(RougeUI.HideHotkey)
        HideHotkeyButton:SetScript("OnClick", function()
            RougeUI.HideHotkey = not RougeUI.HideHotkey
        end)

        local name = "HideMacro"
        local HideMacroButton = CreateFrame("CheckButton", name, Panel.childPanel3, "UICheckButtonTemplate")
        HideMacroButton:SetPoint("TOPLEFT", 10, -250)
        HideMacroButton.text = _G[name .. "Text"]
        HideMacroButton.text:SetVertexColor(1,1,1)
        HideMacroButton.text:SetText("Hide macro text on default actionbar")
        HideMacroButton:SetChecked(RougeUI.HideMacro)
        HideMacroButton:SetScript("OnClick", function()
            RougeUI.HideMacro = not RougeUI.HideMacro
        end)

        local textstring = Panel.childPanel1:CreateFontString("textstring")
        textstring:SetPoint("TOPLEFT", 15, -310)
        textstring:SetFont("Fonts\\MORPHEUS.ttf", 11, "")
        textstring:SetText("Set Player EliteFrame:")

        local DropDownMenuChain = CreateFrame("Frame", "DropDownMenuChain", Panel.childPanel1, "UIDropDownMenuTemplate")
        DropDownMenuChain:ClearAllPoints()
        DropDownMenuChain:SetPoint("LEFT", 0, -60)
        DropDownMenuChain:Show()
        local function OnClick(self)
            UIDropDownMenu_SetSelectedID(DropDownMenuChain, self:GetID())
            if RougeUI.Colval < .54 then
                PlayerFrameTexture:SetVertexColor(1, 1, 1)
            end
            if (UIDropDownMenu_GetSelectedID(DropDownMenuChain) == 1) then
                RougeUI.PChain = 1
                if RougeUI.ThickFrames and not (RougeUI.Colval < .54) then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite2")
                elseif RougeUI.ThickFrames and (RougeUI.Colval < .54) then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite")
                else
                    if RougeUI.Colval > .54 then
                        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp")
                    else
                        PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite")
                    end
                end
            elseif (UIDropDownMenu_GetSelectedID(DropDownMenuChain) == 2) then
                RougeUI.PChain = 2
                if RougeUI.ThickFrames and not (RougeUI.Colval < .54) then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Rare2")
                elseif RougeUI.ThickFrames and (RougeUI.Colval < .54) then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Rare")
                else
                    if RougeUI.Colval > .54 then
                        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp")
                    else
                        PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare")
                    end
                end
            elseif (UIDropDownMenu_GetSelectedID(DropDownMenuChain) == 3) then
                RougeUI.PChain = 3
                if RougeUI.ThickFrames and not (RougeUI.Colval < .54) then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite2")
                elseif RougeUI.ThickFrames and (RougeUI.Colval < .54) then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite")
                else
                    if RougeUI.Colval > .54 then
                        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite.blp")
                    else
                        PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare-Elite")
                    end
                end
            elseif (UIDropDownMenu_GetSelectedID(DropDownMenuChain) == 4) then
                RougeUI.PChain = nil
                PlayerFrameTexture:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
                if RougeUI.ThickFrames then
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-TargetingFrame")
                else
                    PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
                end
            end
        end
        local chains = { "Elite", "Rare", "Rare-Elite", "None" }
        local function initialize(self, level)
            local info = UIDropDownMenu_CreateInfo()
            for _, v in pairs(chains) do
                info = UIDropDownMenu_CreateInfo()
                info.text = v
                info.value = v
                info.func = OnClick
                UIDropDownMenu_AddButton(info, level)
            end
        end

        UIDropDownMenu_Initialize(DropDownMenuChain, initialize)
        UIDropDownMenu_SetWidth(DropDownMenuChain, 100);
        UIDropDownMenu_SetButtonWidth(DropDownMenuChain, 124)
        UIDropDownMenu_SetSelectedID(DropDownMenuChain, RougeUI.PChain)
        UIDropDownMenu_JustifyText(DropDownMenuChain, "LEFT")

    end
    return Panel
end
