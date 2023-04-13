local Name = ...
local Title = select(2, GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$", "");
local floor = math.floor
local format = format
local CreateFrame, _G = CreateFrame, _G

local function RoundNumbers(val, valStep)
    return floor(val / valStep) * valStep
end

RougeUI = { Class_Portrait, ClassHP, GradientHP, FastKeyPress, ShortNumeric, ManaFontSize, HPFontSize, SelfSize, OtherBuffSize, HighlightDispellable, TimerGap, ScoreBoard, HideTitles,
            FadeIcon, CombatIndicator, CastTimer, smooth, pimp, retab, Colval, ArenaNumbers, SQFix, classoutline, HideAggro, unithp, Stance, HideHotkey,
            ClassBG, AutoReady, EnemyTicks, ThickFrames, HideIndicator, Abbreviate, ModPlates, AuraRow, BuffAlpha, ButtonAnim, PartyText, BuffSizer, GoldElite, RareElite, Rare,
            Lorti, Roug, Modern, BuffsRow, BuffVal, PSTrack, cfix, roleIcon, transparent, Slice }

RougeUIF = {}

local stock = {
    Class_Portrait = false,
    ClassHP = true,
    GradientHP = false,
    FastKeyPress = true,
    ShortNumeric = true,
    ManaFontSize = 11,
    HPFontSize = 11,
    SelfSize = 23,
    OtherBuffSize = 23,
    HighlightDispellable = true,
    TimerGap = false,
    ScoreBoard = true,
    HideTitles = true,
    FadeIcon = true,
    CombatIndicator = true,
    CastTimer = false,
    smooth = true,
    pimp = false,
    retab = false,
    Colval = 0.25,
    ArenaNumbers = false,
    SQFix = false,
    classoutline = false,
    HideAggro = true,
    unithp = false,
    Stance = false,
    HideHotkey = false,
    ClassBG = false,
    AutoReady = false,
    EnemyTicks = false,
    ThickFrames = false,
    HideIndicator = true,
    Abbreviate = false,
    ModPlates = true,
    AuraRow = 108,
    BuffAlpha = false,
    ButtonAnim = false,
    PartyText = false,
    BuffSizer = false,
    GoldElite = false,
    RareElite = false,
    Rare = false,
    Lorti = false,
    Roug = false,
    Modern = false,
    BuffsRow = 10,
    BuffVal = 1.0,
    PSTrack = false,
    cfix = false,
    roleIcon = false,
    transparent = true,
    Slice = false
}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function f:ADDON_LOADED()
    for i, j in pairs(stock) do
        if type(j) == "table" then
            for k, v in pairs(j) do
                if RougeUI[i][k] == nil then
                    RougeUI[i][k] = v
                end
            end
        else
            if RougeUI[i] == nil then
                RougeUI[i] = j
            end
        end
    end

    RougeUIF:CusFonts();

    if not f.options then
        f.options = f:CreateGUI()
    end

    f:UnregisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", nil)
end

local function CheckBtn(title, desc, panel, onClick)
    local frame = CreateFrame("CheckButton", title, panel, "InterfaceOptionsCheckButtonTemplate")
    frame:SetScript("OnClick", function(self)
        local enabled = self:GetChecked()
        onClick(self, enabled and true or false)
    end)
    frame.text = _G[frame:GetName() .. "Text"]
    frame.text:SetText(title)
    frame.tooltipText = desc
    return frame
end

local function CreateText(frame, x, y, text)
    local textstring = frame:CreateFontString("textstring")
    textstring:SetPoint("TOPLEFT", x, y)
    textstring:SetFont("Fonts\\MORPHEUS.ttf", 14, "")
    textstring:SetText(text)
    textstring:SetVertexColor(0.99, 0.82, 0)
end

function f:CreateGUI()
    local Panel = CreateFrame("Frame", "$parentRougeUI_Config", InterfaceOptionsPanelContainer)
    do
        Panel.name = Title;
        InterfaceOptions_AddCategory(Panel)

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

        Panel.childPanel4 = CreateFrame("Frame", "$parentConfigChild_StatusBar", Panel)
        Panel.childPanel4.name = "StatusBar"
        Panel.childPanel4.parent = Panel.name
        InterfaceOptions_AddCategory(Panel.childPanel4)

        Panel.childPanel5 = CreateFrame("Frame", "$parentConfigChild_Theme", Panel)
        Panel.childPanel5.name = "Theme"
        Panel.childPanel5.parent = Panel.name
        InterfaceOptions_AddCategory(Panel.childPanel5)

        for _, v in pairs({ Panel.childPanel1, Panel.childPanel2, Panel.childPanel3, Panel.childPanel4, Panel.childPanel5 }) do
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

        CreateText(Panel.childPanel1, 10, -40, "Class colored indicators")

        local ClassPortraitButton = CheckBtn("Enable Class Portraits", "Turn this on to display class portrait on target and focus frame", Panel.childPanel1, function(self, value)
            RougeUI.Class_Portrait = value
        end)
        ClassPortraitButton:SetChecked(RougeUI.Class_Portrait)
        ClassPortraitButton:SetPoint("TOPLEFT", 10, -70)

        local ClassHPButton = CheckBtn("Enable Class Colored HealthBar", "Enabling this will change the green healthBar color to the class color", Panel.childPanel4, function(self, value)
            RougeUI.ClassHP = value
        end)
        ClassHPButton:SetChecked(RougeUI.ClassHP)
        ClassHPButton:SetPoint("TOPLEFT", 10, -75)

        local GradientHPButton = CheckBtn("Enable Gradient HealthBar", "This changes the healthBar color from green > yellow > orange > red based on the current percentage", Panel.childPanel4, function(self, value)
            RougeUI.GradientHP = value
        end)
        GradientHPButton:SetChecked(RougeUI.GradientHP)
        GradientHPButton:SetPoint("TOPLEFT", 10, -110)

        local UnitHPButton = CheckBtn("Color HealthBar by Unit's Reaction", "This will change the healthBar color to red (hostile), green (friendly) or yellow (neutral)", Panel.childPanel4, function(self, value)
            RougeUI.unithp = value
        end)
        UnitHPButton:SetChecked(RougeUI.unithp)
        UnitHPButton:SetPoint("TOPLEFT", 10, -145)

        CreateText(Panel.childPanel1, 10, -180, "StatusText")

        local ShortNumericButton = CheckBtn("Display HP/Mana Text as '10k'", "Enabling this will shorten health/mana text values to one decimal", Panel.childPanel1, function(self, value)
            RougeUI.ShortNumeric = value
        end)
        ShortNumericButton:SetChecked(RougeUI.ShortNumeric)
        ShortNumericButton:SetPoint("TOPLEFT", 10, -215)

        local ShortNumericButton = CheckBtn("Display only CURRENT HP/Mana Text", "This will show the HP/Mana StatusText as CURRENT value instead of CURRENT / MAX", Panel.childPanel1, function(self, value)
            RougeUI.Abbreviate = value
        end)
        ShortNumericButton:SetChecked(RougeUI.Abbreviate)
        ShortNumericButton:SetPoint("TOPLEFT", 10, -250)

        local PartyTextButton = CheckBtn("Show HP/Mana Text on PartyFrames", "This will show the HP/Mana StatusText on party1-4", Panel.childPanel1, function(self, value)
            RougeUI.PartyText = value
        end)
        PartyTextButton:SetChecked(RougeUI.PartyText)
        PartyTextButton:SetPoint("TOPLEFT", 10, -285)

        CreateText(Panel.childPanel1, 350, -40, "Misc")

        local FadeIconButton = CheckBtn("Fade out PvP Icon", "Enabling this will set the PvP Icon's transparency at 35%", Panel.childPanel1, function(self, value)
            RougeUI.FadeIcon = value
        end)
        FadeIconButton:SetChecked(RougeUI.FadeIcon)
        FadeIconButton:SetPoint("TOPLEFT", 350, -70)

        local SmoothFrameButton = CheckBtn("Smooth Animated Health & Mana Bar", "Adds a smoother transition effect when gaining / losing mana or health", Panel.childPanel4, function(self, value)
            RougeUI.smooth = value
        end)
        SmoothFrameButton:SetChecked(RougeUI.smooth)
        SmoothFrameButton:SetPoint("TOPLEFT", 10, -180)

        local PimpFrameButton = CheckBtn("Purple Manabar", "Pimps your manabar to a purple color", Panel.childPanel4, function(self, value)
            RougeUI.pimp = value
        end)
        PimpFrameButton:SetChecked(RougeUI.pimp)
        PimpFrameButton:SetPoint("TOPLEFT", 10, -40)

        local ClassOutlines = CheckBtn("Class Colored Outlines", "When enabled it will add a class colored circle around target and focus frame portraits", Panel.childPanel1, function(self, value)
            RougeUI.classoutline = value
        end)
        ClassOutlines:SetChecked(RougeUI.classoutline)
        ClassOutlines:SetPoint("TOPLEFT", 10, -105)

        local ClassBG = CheckBtn("Class Colored Name Background", "Adds a class colored texture behind the UnitFrame name", Panel.childPanel1, function(self, value)
            if RougeUI.ThickFrames then
                UIErrorsFrame:AddMessage("This cannot be enabled with big frames", 1, 0, 0)
            else
                RougeUI.ClassBG = value
            end
        end)
        ClassBG:SetChecked(RougeUI.ClassBG)
        ClassBG:SetPoint("TOPLEFT", 10, -140)

        local ThickFrame = CheckBtn("Enable Big Frames", "Enable this for big (thick) UnitFrames", Panel.childPanel1, function(self, value)
            RougeUI.ThickFrames = value
            RougeUI.ClassBG = false
        end)
        ThickFrame:SetChecked(RougeUI.ThickFrames)
        ThickFrame:SetPoint("TOPLEFT", 350, -105)

        local Transparent = CheckBtn("Transparent name background", nil, Panel.childPanel1, function(self, value)
            RougeUI.transparent = value
            RougeUI.ClassBG = false
        end)
        Transparent:SetChecked(RougeUI.transparent)
        Transparent:SetPoint("TOPLEFT", 350, -140)

        local ModPlates = CheckBtn("Change Nameplate Style", "This will slightly alter the original nameplate style", Panel.childPanel5, function(self, value)
            RougeUI.ModPlates = value
        end)
        ModPlates:SetChecked(RougeUI.ModPlates)
        ModPlates:SetPoint("TOPLEFT", 10, -75)

        CreateText(Panel.childPanel5, 350, -40, "Theme's")

        local LortiTheme = CheckBtn("Lorti Theme", "This will theme the UI to look like Lorti", Panel.childPanel5, function(self, value)
            RougeUI.Lorti = value
        end)
        LortiTheme:SetChecked(RougeUI.Lorti)
        LortiTheme:SetPoint("TOPLEFT", 350, -105)

        local RougTheme = CheckBtn("RougeUI Theme", nil, Panel.childPanel5, function(self, value)
            RougeUI.Roug = value
        end)
        RougTheme:SetChecked(RougeUI.Roug)
        RougTheme:SetPoint("TOPLEFT", 350, -70)

        local ModernTheme = CheckBtn("Minimalist Theme", nil, Panel.childPanel5, function(self, value)
            RougeUI.Modern = value
            BuffColSlider:Show()
        end)
        ModernTheme:SetChecked(RougeUI.Modern)
        ModernTheme:SetPoint("TOPLEFT", 350, -140)

        local name = "FontSizeSlider"
        local FontSizeSlider = CreateFrame("Slider", name, Panel.childPanel1, "OptionsSliderTemplate")
        FontSizeSlider:SetPoint("TOPLEFT", 20, -355)
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
        MFontSizeSlider:SetPoint("TOPLEFT", 20, -415)
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
        TargetPlayerBuffSizeSlider:SetPoint("TOPLEFT", 20, -490)
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
        TargetBuffSizeSlider:SetPoint("TOPLEFT", 20, -440)
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
        local ColorValueSlider = CreateFrame("Slider", name, Panel.childPanel5, "OptionsSliderTemplate")
        ColorValueSlider:SetMinMaxValues(0, 1)
        ColorValueSlider:SetPoint("TOPLEFT", 25, -230)
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

        local name = "BuffValueSlider"
        local BuffValueSlider = CreateFrame("Slider", name, Panel.childPanel5, "OptionsSliderTemplate")
        BuffValueSlider:SetMinMaxValues(2, 10)
        BuffValueSlider:SetPoint("TOPLEFT", 25, -160)
        BuffValueSlider.text = _G[name .. "Text"]
        BuffValueSlider.textLow = _G[name .. "Low"]
        BuffValueSlider.textHigh = _G[name .. "High"]
        BuffValueSlider.minValue, BuffValueSlider.maxValue = BuffValueSlider:GetMinMaxValues()
        BuffValueSlider.textLow:SetText(floor(BuffValueSlider.minValue))
        BuffValueSlider.textHigh:SetText(floor(BuffValueSlider.maxValue))
        BuffValueSlider:SetValue(RougeUI.BuffsRow)
        BuffValueSlider.text:SetText("Buffs Per Row: " .. format("%.f", BuffValueSlider:GetValue(BuffsRow)))
        BuffValueSlider:SetValueStep(1)
        BuffValueSlider:SetObeyStepOnDrag(true);
        BuffValueSlider:SetScript("OnValueChanged", function(_, value)
            BuffValueSlider.text:SetText("Buffs Per Row: " .. RoundNumbers(RougeUI.BuffsRow, 1))
            RougeUI.BuffsRow = value
        end)

        local name = "BuffColSlider"
        local BuffColSlider = CreateFrame("Slider", name, Panel.childPanel5, "OptionsSliderTemplate")
        BuffColSlider:SetMinMaxValues(0, 1)
        BuffColSlider:SetPoint("TOPLEFT", 25, -300)
        if RougeUI.Modern then
            BuffColSlider:Show()
        else
            BuffColSlider:Hide()
        end
        BuffColSlider.text = _G[name .. "Text"]
        BuffColSlider.textLow = _G[name .. "Low"]
        BuffColSlider.textHigh = _G[name .. "High"]
        BuffColSlider.minValue, BuffColSlider.maxValue = BuffColSlider:GetMinMaxValues()
        BuffColSlider.textLow:SetText(floor(BuffColSlider.minValue))
        BuffColSlider.textHigh:SetText(floor(BuffColSlider.maxValue))
        BuffColSlider:SetValue(RougeUI.BuffVal)
        BuffColSlider.text:SetText("Theme's Border Brightness: " .. format("%.f", BuffColSlider:GetValue(BuffVal)))
        BuffColSlider:SetValueStep(0.05)
        BuffColSlider:SetObeyStepOnDrag(true);
        BuffColSlider:SetScript("OnValueChanged", function(_, value)
            BuffColSlider.text:SetText("Theme's Border Brightness: " .. RoundNumbers(RougeUI.BuffVal, 0.05))
            RougeUI.BuffVal = value
        end)

        local names = "AuraRowSlider"
        local AuraRowSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        AuraRowSlider:SetPoint("TOPLEFT", 20, -540)
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

        CreateText(Panel.childPanel2, 10, -40, "PvP Tweaks")

        local EnemyTicksButton = CheckBtn("Out of Combat Timer", "Track when your target/focus will leave combat (only tracks energy/mana users in arena)", Panel.childPanel2, function(self, value)
            RougeUI.EnemyTicks = value
        end)
        EnemyTicksButton:SetChecked(RougeUI.EnemyTicks)
        EnemyTicksButton:SetPoint("TOPLEFT", 10, -70)

        local PSTrackBtn = CheckBtn("CC Absorb Tracker", "Track the amount of damage fear/hex/turn evil can take before it breaks. This will display below the default Blizzard nameplate", Panel.childPanel2, function(self, value)
            RougeUI.PSTrack = value
        end)
        PSTrackBtn:SetChecked(RougeUI.PSTrack)
        PSTrackBtn:SetPoint("TOPLEFT", 10, -105)

        local CombatIndicatorButton = CheckBtn("Combat Indicator", "Displays a Combat icon next to Target-/FocusFrame when they enter combat or send pet", Panel.childPanel2, function(self, value)
            RougeUI.CombatIndicator = value
        end)
        CombatIndicatorButton:SetChecked(RougeUI.CombatIndicator)
        CombatIndicatorButton:SetPoint("TOPLEFT", 10, -140)

        local ArenaNumbersButton = CheckBtn("Show arena number on nameplate", "When in Arena show 'arena1-5' on enemy nameplates", Panel.childPanel2, function(self, value)
            RougeUI.ArenaNumbers = value
        end)
        ArenaNumbersButton:SetChecked(RougeUI.ArenaNumbers)
        ArenaNumbersButton:SetPoint("TOPLEFT", 10, -175)

        local ScoreBoardButton = CheckBtn("Class colored PvP Scoreboard", "Color names on the PvP Scoreboard by class", Panel.childPanel2, function(self, value)
            RougeUI.ScoreBoard = value
        end)
        ScoreBoardButton:SetChecked(RougeUI.ScoreBoard)
        ScoreBoardButton:SetPoint("TOPLEFT", 10, -210)

        CreateText(Panel.childPanel2, 10, -255, "Buffs/Debuffs")

        CreateText(Panel.childPanel2, 350, -40, "Misc")

        local FastKeyPressButton = CheckBtn("Activate spells on key down", "Enabling this will trigger your spells on pressing keys down instead of on releasing them", Panel.childPanel2, function(self, value)
            RougeUI.FastKeyPress = value
        end)
        FastKeyPressButton:SetChecked(RougeUI.FastKeyPress)
        FastKeyPressButton:SetPoint("TOPLEFT", 350, -70)
        FastKeyPressButton:RegisterEvent("PLAYER_LOGIN")
        FastKeyPressButton:SetScript("OnEvent", function(self, event, ...)
            if (event == "PLAYER_LOGIN") then
                if RougeUI.FastKeyPress and (GetCVarBool("ActionButtonUseKeyDown") ~= true) then
                    SetCVar("ActionButtonUseKeyDown", 1)
                end
                self:UnregisterEvent("PLAYER_LOGIN")
                self:SetScript("OnEvent", nil)
            end
        end)

        local SpellQueueWindow = CheckBtn("Auto-adjust SpellQueue Window", "Automatically changes SpellQueue value based on current latency", Panel.childPanel2, function(self, value)
            RougeUI.SQFix = value
        end)
        SpellQueueWindow:SetChecked(RougeUI.SQFix)
        SpellQueueWindow:SetPoint("TOPLEFT", 350, -105)

        local AutoReadyButton = CheckBtn("Auto accept raid/arena ready check", "When enabled it will automatically accept any readychecks. Warning: Don't AFK or enable when queueing arena with a random", Panel.childPanel2, function(self, value)
            RougeUI.AutoReady = value
        end)
        AutoReadyButton:SetChecked(RougeUI.AutoReady)
        AutoReadyButton:SetPoint("TOPLEFT", 350, -140)

        local Retab = CheckBtn("RETabBinder", "Changes TAB Bind to target nearest enemy players when in arena/battleground", Panel.childPanel2, function(self, value)
            RougeUI.RETabBinder = value
        end)
        Retab:SetChecked(RougeUI.RETabBinder)
        Retab:SetPoint("TOPLEFT", 350, -175)

        local ButtonAnim = CheckBtn("Animated Keypress (SnowFallKeyPress)", "Works with Default/Dominos/Bartender4 actionbars", Panel.childPanel2, function(self, value)
            RougeUI.ButtonAnim = value
        end)
        ButtonAnim:SetChecked(RougeUI.ButtonAnim)
        ButtonAnim:SetPoint("TOPLEFT", 350, -210)

        CreateText(Panel.childPanel2, 350, -260, "Rogue Specific")

        local ComboFixButton = CheckBtn("ComboFrame Fix", "This change will allow you to see combo points on mind controlled enemy players", Panel.childPanel2, function(self, value)
            RougeUI.cfix = value
        end)
        ComboFixButton:SetChecked(RougeUI.cfix)
        ComboFixButton:SetPoint("TOPLEFT", 350, -290)

        local SliceButton = CheckBtn("Slice & Dice Hax", "Use slice and dice on target/focus with your default keybind - requires default Blizzard actionbar/Dominos/Bartender4", Panel.childPanel2, function(self, value)
            RougeUI.Slice = value
        end)
        SliceButton:SetChecked(RougeUI.Slice)
        SliceButton:SetPoint("TOPLEFT", 350, -325)

        local CastTimerButton = CheckBtn("Customized Castbar", "Styles the Target/FocusFrame castbar and adds a timer", Panel.childPanel5, function(self, value)
            RougeUI.CastTimer = value
        end)
        CastTimerButton:SetChecked(RougeUI.CastTimer)
        CastTimerButton:SetPoint("TOPLEFT", 10, -40)

        local HighlightDispellable = CheckBtn("Highlight important Magic/Enrage buffs", "Instead of showing ALL dispellable buffs, this will only highlight non trash magic and enrage effects", Panel.childPanel2, function(self, value)
            RougeUI.HighlightDispellable = value
            RougeUI.BuffSizer = true
        end)
        HighlightDispellable:SetChecked(RougeUI.HighlightDispellable)
        HighlightDispellable:SetPoint("TOPLEFT", 10, -285)

        local TimerButton = CheckBtn("Remove space indentation from buffs", "When enabled (De)buffs will display the time as '1s' instead of '1 s'", Panel.childPanel2, function(self, value)
            RougeUI.TimerGap = value
        end)
        TimerButton:SetChecked(RougeUI.TimerGap)
        TimerButton:SetPoint("TOPLEFT", 10, -320)

        local BuffAlphaButton = CheckBtn("Disable BuffFrame fading animation", "Disable the pulsing effect on buffs and debuffs", Panel.childPanel2, function(self, value)
            RougeUI.BuffAlpha = value
        end)
        BuffAlphaButton:SetChecked(RougeUI.BuffAlpha)
        BuffAlphaButton:SetPoint("TOPLEFT", 10, -355)

        local BuffSizerButton = CheckBtn("Enable Buff Resizing", "Enables Target/Focus Frame Buff/Debuff scale sliders", Panel.childPanel2, function(self, value)
            RougeUI.BuffSizer = value
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
        BuffSizerButton:SetChecked(RougeUI.BuffSizer)
        BuffSizerButton:SetPoint("TOPLEFT", 10, -390)

        --childPanel3

        local HideGlowsButton = CheckBtn("Hide glowing effects on PlayerFrame", "Hides the yellow and red glowing when resting or being attacked on PlayerFrame", Panel.childPanel3, function(self, value)
            RougeUI.HideGlows = value
        end)
        HideGlowsButton:SetChecked(RougeUI.HideGlows)
        HideGlowsButton:SetPoint("TOPLEFT", 10, -40)

        local HideIndicatorButton = CheckBtn("Hide Combat Text on Portrait", "Hides the player and pet combat text on portraits", Panel.childPanel3, function(self, value)
            RougeUI.HideIndicator = value
        end)
        HideIndicatorButton:SetChecked(RougeUI.HideIndicator)
        HideIndicatorButton:SetPoint("TOPLEFT", 10, -75)

        local HideTitlesButton = CheckBtn("Hide Group/Raid text", "Hides the Group/Raid text showing on top of frames", Panel.childPanel3, function(self, value)
            RougeUI.HideTitles = value
        end)
        HideTitlesButton:SetChecked(RougeUI.HideTitles)
        HideTitlesButton:SetPoint("TOPLEFT", 10, -110)

        local AggroHighlightButton = CheckBtn("Hide Aggro highlight on default raid frames", "Hides the red texture that appears on raid frames when someone has aggro", Panel.childPanel3, function(self, value)
            RougeUI.HideAggro = value
        end)
        AggroHighlightButton:SetChecked(RougeUI.HideAggro)
        AggroHighlightButton:SetPoint("TOPLEFT", 10, -145)

        local HideStanceButton = CheckBtn("Hide StanceBar", "Hides the extra buttons like that show above the actionbars like Cat Form, Stealth and Shadowform", Panel.childPanel3, function(self, value)
            RougeUI.Stance = value
        end)
        HideStanceButton:SetChecked(RougeUI.Stance)
        HideStanceButton:SetPoint("TOPLEFT", 10, -180)

        local HideHotkeyButton = CheckBtn("Hide Hotkey text on default actionbar", "Hides the keybinding text displayed", Panel.childPanel3, function(self, value)
            RougeUI.HideHotkey = value
        end)
        HideHotkeyButton:SetChecked(RougeUI.HideHotkey)
        HideHotkeyButton:SetPoint("TOPLEFT", 10, -215)

        local HideMacroButton = CheckBtn("Hide macro text on default actionbar", "Hides the macro name displayed on icons", Panel.childPanel3, function(self, value)
            RougeUI.HideMacro = value
        end)
        HideMacroButton:SetChecked(RougeUI.HideMacro)
        HideMacroButton:SetPoint("TOPLEFT", 10, -250)

        local HideRoleButton = CheckBtn("Hide role icon on default raid frames", "Hides the role icon on blizzard raid frames", Panel.childPanel3, function(self, value)
            RougeUI.roleIcon = value
        end)
        HideRoleButton:SetChecked(RougeUI.roleIcon)
        HideRoleButton:SetPoint("TOPLEFT", 10, -285)

        CreateText(Panel.childPanel1, 350, -180, "Player Chain")

        local EliteChain = CheckBtn("Gold Elite PlayerFrame", "Show a `Gold Elite` artwork on PlayerFrame", Panel.childPanel1, function(self, value)
            RougeUI.GoldElite = value
            RougeUI.Rare = false
            RougeUI.RareElite = false
            if RougeUI.Colval < 0.54 then
                PlayerFrameTexture:SetVertexColor(1, 1, 1)
            end

            if RougeUI.ThickFrames and (RougeUI.Colval >= 0.54) then
                PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite2")
            elseif RougeUI.ThickFrames and (RougeUI.Colval < 0.54) then
                PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite")
            else
                if (RougeUI.Colval > 0.54) then
                    PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp")
                else
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite")
                end
            end
        end)
        EliteChain:SetChecked(RougeUI.GoldElite)
        EliteChain:SetPoint("TOPLEFT", 350, -215)

        local RareChain = CheckBtn("Rare PlayerFrame", "Show a `Rare` artwork on PlayerFrame", Panel.childPanel1, function(self, value)
            RougeUI.Rare = value
            RougeUI.RareElite = false
            RougeUI.GoldElite = false
            if (RougeUI.Colval < 0.54) then
                PlayerFrameTexture:SetVertexColor(1, 1, 1)
            end
            if RougeUI.ThickFrames and (RougeUI.Colval >= 0.54) then
                PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Rare2")
            elseif RougeUI.ThickFrames and (RougeUI.Colval < 0.54) then
                PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Rare")
            else
                if (RougeUI.Colval > 0.54) then
                    PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp")
                else
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare")
                end
            end
        end)
        RareChain:SetChecked(RougeUI.Rare)
        RareChain:SetPoint("TOPLEFT", 350, -250)

        local RareElite = CheckBtn("Rare Elite PlayerFrame", "Show a `Rare Elite` artwork on PlayerFrame", Panel.childPanel1, function(self, value)
            RougeUI.RareElite = value
            RougeUI.Rare = false
            RougeUI.GoldElite = false
            if (RougeUI.Colval < 0.54) then
                PlayerFrameTexture:SetVertexColor(1, 1, 1)
            end
            if RougeUI.ThickFrames and (RougeUI.Colval >= 0.54) then
                PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite2")
            elseif RougeUI.ThickFrames and (RougeUI.Colval < 0.54) then
                PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite")
            else
                if (RougeUI.Colval > 0.54) then
                    PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite.blp")
                else
                    PlayerFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare-Elite")
                end
            end
        end)
        RareElite:SetChecked(RougeUI.RareElite)
        RareElite:SetPoint("TOPLEFT", 350, -285)

    end
    return Panel
end


