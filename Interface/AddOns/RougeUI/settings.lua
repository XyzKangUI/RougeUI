local Name, addon = ...
local Title = select(2, GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$", "");
local floor = math.floor
local format = format
local CreateFrame, _G = CreateFrame, _G
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
addon.RougeUIF = {}
local WOW_PROJECT_ID, WOW_PROJECT_CLASSIC = WOW_PROJECT_ID, WOW_PROJECT_CLASSIC

local function RoundNumbers(val, valStep)
    return floor(val / valStep) * valStep
end

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
    HighlightDispellable = false,
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
    Slice = false,
    NoLevel = false,
    KeyEcho = false,
    ClassNames = false,
    RangeIndicator = false,
    EnergyTicker = false,
    wahksfk = false
}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function f:ADDON_LOADED(msg)
    if msg ~= Name then
        return
    end

    if not RougeUI then RougeUI = {} end

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

    addon.db = RougeUI

    addon.RougeUIF:CusFonts();

    if not f.options then
        f.options = f:CreateGUI()
    end

    f:UnregisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", nil)
end

function f:PLAYER_LOGOUT()
    RougeUI = addon.db
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
        Panel.name = Title
        local category
        if Settings then
            category = Settings.RegisterCanvasLayoutCategory(Panel, "RougeUI")
            Settings.RegisterAddOnCategory(category)
        else
            InterfaceOptions_AddCategory(Panel)
        end

        local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
        title:SetPoint("TOPLEFT", 12, -15);
        title:SetText(Title);

        local Filler = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        Filler:SetPoint("TOP", 0, -50)
        Filler:SetText("Welcome to RougeUI")

        Panel.childPanel1 = CreateFrame("Frame", "$parentConfigChild_UnitFrame", Panel)
        Panel.childPanel1.name = "UnitFrame"
        Panel.childPanel1.parent = Panel.name
        if Settings then
            local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel1, "UnitFrame")
            Settings.RegisterAddOnCategory(subcategory)
        else
            InterfaceOptions_AddCategory(Panel.childPanel1)
        end

        Panel.childPanel2 = CreateFrame("Frame", "$parentConfigChild_Tweaks", Panel)
        Panel.childPanel2.name = "Tweaks"
        Panel.childPanel2.parent = Panel.name
        if Settings then
            local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel2, "Tweaks")
            Settings.RegisterAddOnCategory(subcategory)
        else
            InterfaceOptions_AddCategory(Panel.childPanel2)
        end

        Panel.childPanel3 = CreateFrame("Frame", "$parentConfigChild_Hide", Panel)
        Panel.childPanel3.name = "Hide Elements"
        Panel.childPanel3.parent = Panel.name
        if Settings then
            local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel3, "Hide Elements")
            Settings.RegisterAddOnCategory(subcategory)
        else
            InterfaceOptions_AddCategory(Panel.childPanel3)
        end

        Panel.childPanel4 = CreateFrame("Frame", "$parentConfigChild_StatusBar", Panel)
        Panel.childPanel4.name = "StatusBar"
        Panel.childPanel4.parent = Panel.name
        if Settings then
            local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel4, "StatusBar")
            Settings.RegisterAddOnCategory(subcategory)
        else
            InterfaceOptions_AddCategory(Panel.childPanel4)
        end

        Panel.childPanel5 = CreateFrame("Frame", "$parentConfigChild_Theme", Panel)
        Panel.childPanel5.name = "Theme"
        Panel.childPanel5.parent = Panel.name
        if Settings then
            local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel5, "Theme")
            Settings.RegisterAddOnCategory(subcategory)
        else
            InterfaceOptions_AddCategory(Panel.childPanel5)
        end

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

        --childPanel1

        CreateText(Panel.childPanel1, 10, -40, "Class colored indicators")

        local ClassPortraitButton = CheckBtn("Enable Class Portraits", "Turn this on to display class portrait on target and focus frame", Panel.childPanel1, function(self, value)
            addon.db.Class_Portrait = value
        end)
        ClassPortraitButton:SetChecked(addon.db.Class_Portrait)
        ClassPortraitButton:SetPoint("TOPLEFT", 10, -70)

        local ClassHPButton = CheckBtn("Enable Class Colored HealthBar", "Enabling this will change the green healthBar color to the class color", Panel.childPanel4, function(self, value)
            addon.db.ClassHP = value
        end)
        ClassHPButton:SetChecked(addon.db.ClassHP)
        ClassHPButton:SetPoint("TOPLEFT", 10, -75)

        local GradientHPButton = CheckBtn("Enable Gradient HealthBar", "This changes the healthBar color from green > yellow > orange > red based on the current percentage", Panel.childPanel4, function(self, value)
            addon.db.GradientHP = value
        end)
        GradientHPButton:SetChecked(addon.db.GradientHP)
        GradientHPButton:SetPoint("TOPLEFT", 10, -110)

        local UnitHPButton = CheckBtn("Color HealthBar by Unit's Reaction", "This will change the healthBar color to red (hostile), green (friendly) or yellow (neutral)", Panel.childPanel4, function(self, value)
            addon.db.unithp = value
        end)
        UnitHPButton:SetChecked(addon.db.unithp)
        UnitHPButton:SetPoint("TOPLEFT", 10, -145)

        CreateText(Panel.childPanel1, 10, -210, "StatusText")

        local ShortNumericButton = CheckBtn("Display HP/Mana Text as '10k'", "Enabling this will shorten health/mana text values to one decimal", Panel.childPanel1, function(self, value)
            addon.db.ShortNumeric = value
        end)
        ShortNumericButton:SetChecked(addon.db.ShortNumeric)
        ShortNumericButton:SetPoint("TOPLEFT", 10, -245)

        local ShortNumericButton = CheckBtn("Display only CURRENT HP/Mana Text", "This will show the HP/Mana StatusText as CURRENT value instead of CURRENT / MAX", Panel.childPanel1, function(self, value)
            addon.db.Abbreviate = value
        end)
        ShortNumericButton:SetChecked(addon.db.Abbreviate)
        ShortNumericButton:SetPoint("TOPLEFT", 10, -280)

        local PartyTextButton = CheckBtn("Show HP/Mana Text on PartyFrames", "This will show the HP/Mana StatusText on party1-4", Panel.childPanel1, function(self, value)
            addon.db.PartyText = value
        end)
        PartyTextButton:SetChecked(addon.db.PartyText)
        PartyTextButton:SetPoint("TOPLEFT", 10, -315)

        CreateText(Panel.childPanel1, 350, -40, "Misc")

        local FadeIconButton = CheckBtn("Fade out PvP Icon", "Enabling this will set the PvP Icon's transparency at 35%", Panel.childPanel1, function(self, value)
            addon.db.FadeIcon = value
        end)
        FadeIconButton:SetChecked(addon.db.FadeIcon)
        FadeIconButton:SetPoint("TOPLEFT", 350, -70)

        local SmoothFrameButton = CheckBtn("Smooth Animated Health & Mana Bar", "Adds a smoother transition effect when gaining / losing mana or health", Panel.childPanel4, function(self, value)
            addon.db.smooth = value
        end)
        SmoothFrameButton:SetChecked(addon.db.smooth)
        SmoothFrameButton:SetPoint("TOPLEFT", 10, -180)

        local PimpFrameButton = CheckBtn("Purple Manabar", "Pimps your manabar to a purple color", Panel.childPanel4, function(self, value)
            addon.db.pimp = value
        end)
        PimpFrameButton:SetChecked(addon.db.pimp)
        PimpFrameButton:SetPoint("TOPLEFT", 10, -40)

        local ClassOutlines = CheckBtn("Class Colored Outlines", "When enabled it will add a class colored circle around target and focus frame portraits", Panel.childPanel1, function(self, value)
            addon.db.classoutline = value
        end)
        ClassOutlines:SetChecked(addon.db.classoutline)
        ClassOutlines:SetPoint("TOPLEFT", 10, -105)

        local ClassBG = CheckBtn("Class Colored Name Background", "Adds a class colored texture behind the UnitFrame name", Panel.childPanel1, function(self, value)
            if addon.db.ThickFrames then
                UIErrorsFrame:AddMessage("This cannot be enabled with big frames", 1, 0, 0)
            else
                addon.db.ClassBG = value
            end
        end)
        ClassBG:SetChecked(addon.db.ClassBG)
        ClassBG:SetPoint("TOPLEFT", 10, -140)

        local ClassCNames = CheckBtn("Class Colored Names", "Color names to their class color", Panel.childPanel1, function(self, value)
            addon.db.ClassNames = value
        end)
        ClassCNames:SetChecked(addon.db.ClassNames)
        ClassCNames:SetPoint("TOPLEFT", 10, -175)

        local ThickFrame = CheckBtn("Enable Big Frames", "Enable this for big (thick) UnitFrames", Panel.childPanel1, function(self, value)
            addon.db.ThickFrames = value
            addon.db.ClassBG = false
        end)
        ThickFrame:SetChecked(addon.db.ThickFrames)
        ThickFrame:SetPoint("TOPLEFT", 350, -105)

        local Transparent = CheckBtn("Transparent name background", nil, Panel.childPanel1, function(self, value)
            addon.db.transparent = value
            addon.db.ClassBG = false
        end)
        Transparent:SetChecked(addon.db.transparent)
        Transparent:SetPoint("TOPLEFT", 350, -140)

        local Nolvl = CheckBtn("Hide level text on frames", nil, Panel.childPanel1, function(self, value)
            addon.db.NoLevel = value
        end)
        Nolvl:SetChecked(addon.db.NoLevel)
        Nolvl:SetPoint("TOPLEFT", 350, -175)

        local ModPlates = CheckBtn("Change Nameplate Style", "This will slightly alter the original nameplate style", Panel.childPanel5, function(self, value)
            addon.db.ModPlates = value
        end)
        ModPlates:SetChecked(addon.db.ModPlates)
        ModPlates:SetPoint("TOPLEFT", 10, -75)

        CreateText(Panel.childPanel5, 350, -40, "Theme's")

        local LortiTheme = CheckBtn("Lorti Theme", "This will theme the UI to look like Lorti", Panel.childPanel5, function(self, value)
            addon.db.Lorti = value
        end)
        LortiTheme:SetChecked(addon.db.Lorti)
        LortiTheme:SetPoint("TOPLEFT", 350, -105)

        local RougTheme = CheckBtn("RougeUI Theme", nil, Panel.childPanel5, function(self, value)
            addon.db.Roug = value
        end)
        RougTheme:SetChecked(addon.db.Roug)
        RougTheme:SetPoint("TOPLEFT", 350, -70)

        local ModernTheme = CheckBtn("Minimalist Theme", nil, Panel.childPanel5, function(self, value)
            addon.db.Modern = value
            BuffColSlider:Show()
        end)
        ModernTheme:SetChecked(addon.db.Modern)
        ModernTheme:SetPoint("TOPLEFT", 350, -140)

        local name = "FontSizeSlider"
        local FontSizeSlider = CreateFrame("Slider", name, Panel.childPanel1, "OptionsSliderTemplate")
        FontSizeSlider:SetPoint("TOPLEFT", 20, -400)
        FontSizeSlider.textLow = _G[name .. "Low"]
        FontSizeSlider.textHigh = _G[name .. "High"]
        FontSizeSlider.text = _G[name .. "Text"]
        FontSizeSlider:SetMinMaxValues(8, 16)
        FontSizeSlider.minValue, FontSizeSlider.maxValue = FontSizeSlider:GetMinMaxValues()
        FontSizeSlider.textLow:SetText(FontSizeSlider.minValue)
        FontSizeSlider.textHigh:SetText(FontSizeSlider.maxValue)
        FontSizeSlider:SetValue(addon.db.HPFontSize)
        FontSizeSlider.text:SetText("HP Font Size " .. FontSizeSlider:GetValue(HealthFontSize))
        FontSizeSlider:SetValueStep(1)
        FontSizeSlider:SetObeyStepOnDrag(true);
        FontSizeSlider:SetScript("OnValueChanged", function(self)
            self.text:SetText("HP Font Size: " .. self:GetValue(addon.db.HPFontSize))
            addon.db.HPFontSize = self:GetValue()
            addon.RougeUIF:CusFonts()
        end)

        local name = "MFontSizeSlider"
        local MFontSizeSlider = CreateFrame("Slider", name, Panel.childPanel1, "OptionsSliderTemplate")
        MFontSizeSlider:SetPoint("TOPLEFT", 20, -460)
        MFontSizeSlider.textLow = _G[name .. "Low"]
        MFontSizeSlider.textHigh = _G[name .. "High"]
        MFontSizeSlider.text = _G[name .. "Text"]
        MFontSizeSlider:SetMinMaxValues(8, 16)
        MFontSizeSlider.minValue, MFontSizeSlider.maxValue = MFontSizeSlider:GetMinMaxValues()
        MFontSizeSlider.textLow:SetText(MFontSizeSlider.minValue)
        MFontSizeSlider.textHigh:SetText(MFontSizeSlider.maxValue)
        MFontSizeSlider:SetValue(addon.db.ManaFontSize)
        MFontSizeSlider.text:SetText("Mana Font Size " .. MFontSizeSlider:GetValue(ManaFontSize))
        MFontSizeSlider:SetValueStep(1)
        MFontSizeSlider:SetObeyStepOnDrag(true);
        MFontSizeSlider:SetScript("OnValueChanged", function(self)
            self.text:SetText("Mana Font Size: " .. self:GetValue(addon.db.ManaFontSize))
            addon.db.ManaFontSize = self:GetValue()
            addon.RougeUIF:CusFonts()
        end)

        local names = "TargetPlayerBuffSizeSlider"
        local TargetPlayerBuffSizeSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        TargetPlayerBuffSizeSlider:SetPoint("TOPLEFT", 20, -490)
        if addon.db.BuffSizer then
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
        TargetPlayerBuffSizeSlider:SetValue(addon.db.SelfSize)
        TargetPlayerBuffSizeSlider.text:SetText("Personal aura size: " .. format("%.f", TargetPlayerBuffSizeSlider:GetValue(SelfSize)));
        TargetPlayerBuffSizeSlider:SetValueStep(1)
        TargetPlayerBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetPlayerBuffSizeSlider:SetScript("OnValueChanged", function(_, value)
            if addon.db.SelfSize ~= value then
                addon.db.SelfSize = value;
                TargetPlayerBuffSizeSliderText:SetText("Personal (De)buff Size: " .. RoundNumbers(addon.db.SelfSize, 1))
                addon.RougeUIF:SetCustomBuffSize()
            end
        end)

        local names = "TargetBuffSizeSlider"
        local TargetBuffSizeSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        TargetBuffSizeSlider:SetPoint("TOPLEFT", 20, -440)
        if addon.db.BuffSizer then
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
        TargetBuffSizeSlider:SetValue(addon.db.OtherBuffSize)
        TargetBuffSizeSlider.text:SetText("Target Aura Size: " .. format("%.f", TargetBuffSizeSlider:GetValue(OtherBuffSize)));
        TargetBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetBuffSizeSlider:SetScript("OnValueChanged", function(_, value)
            if addon.db.OtherBuffSize ~= value then
                addon.db.OtherBuffSize = value;
                TargetBuffSizeSliderText:SetText("Target Buff Size: " .. RoundNumbers(addon.db.OtherBuffSize, 1))
                addon.RougeUIF:SetCustomBuffSize()
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
        ColorValueSlider:SetValue(addon.db.Colval)
        ColorValueSlider.text:SetText("UI Brightness: " .. format("%.2f", ColorValueSlider:GetValue(Colval)))
        ColorValueSlider:SetValueStep(0.05)
        ColorValueSlider:SetObeyStepOnDrag(true);
        ColorValueSlider:SetScript("OnValueChanged", function(_, value)
            ColorValueSlider.text:SetText("UI Brightness: " .. RoundNumbers(addon.db.Colval, 0.05))
            addon.db.Colval = value
            addon.RougeUIF:ChangeFrameColors()
        end)

        C_Timer.After(1, function()
            if not IsAddOnLoaded("SimpleAuraFilter") then
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
                BuffValueSlider:SetValue(addon.db.BuffsRow)
                BuffValueSlider.text:SetText("Buffs Per Row: " .. format("%.f", BuffValueSlider:GetValue(BuffsRow)))
                BuffValueSlider:SetValueStep(1)
                BuffValueSlider:SetObeyStepOnDrag(true);
                BuffValueSlider:SetScript("OnValueChanged", function(_, value)
                    BuffValueSlider.text:SetText("Buffs Per Row: " .. RoundNumbers(addon.db.BuffsRow, 1))
                    addon.db.BuffsRow = value
                end)
            end
        end)

        local name = "BuffColSlider"
        local BuffColSlider = CreateFrame("Slider", name, Panel.childPanel5, "OptionsSliderTemplate")
        BuffColSlider:SetMinMaxValues(0, 1)
        BuffColSlider:SetPoint("TOPLEFT", 25, -300)
        if addon.db.Modern then
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
        BuffColSlider:SetValue(addon.db.BuffVal)
        BuffColSlider.text:SetText("Theme's Border Brightness: " .. format("%.f", BuffColSlider:GetValue(BuffVal)))
        BuffColSlider:SetValueStep(0.05)
        BuffColSlider:SetObeyStepOnDrag(true);
        BuffColSlider:SetScript("OnValueChanged", function(_, value)
            BuffColSlider.text:SetText("Theme's Border Brightness: " .. RoundNumbers(addon.db.BuffVal, 0.05))
            addon.db.BuffVal = value
        end)

        local names = "AuraRowSlider"
        local AuraRowSlider = CreateFrame("Slider", names, Panel.childPanel2, "OptionsSliderTemplate")
        AuraRowSlider:SetPoint("TOPLEFT", 20, -540)
        if addon.db.BuffSizer then
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
        AuraRowSlider:SetValue(addon.db.AuraRow)
        AuraRowSlider.text:SetText("Aura Row Width Size: " .. format("%.f", AuraRowSlider:GetValue(AuraRow)));
        AuraRowSlider:SetObeyStepOnDrag(true);
        AuraRowSlider:SetScript("OnValueChanged", function(_, value)
            if addon.db.AuraRow ~= value then
                addon.db.AuraRow = value;
                AuraRowSliderText:SetText("Increase to fit more Aura's per row: " .. RoundNumbers(addon.db.AuraRow, 1))
                addon.RougeUIF:SetCustomBuffSize()
            end
        end)

        -- childPanel2

        CreateText(Panel.childPanel2, 10, -40, "PvP Tweaks")

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            local EnemyTicksButton = CheckBtn("Out of Combat Timer", "Track when your target/focus will leave combat (only tracks energy/mana users in arena)", Panel.childPanel2, function(self, value)
                addon.db.EnemyTicks = value
            end)
            EnemyTicksButton:SetChecked(addon.db.EnemyTicks)
            EnemyTicksButton:SetPoint("TOPLEFT", 10, -140)
        end

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            local PSTrackBtn = CheckBtn("CC Absorb Tracker", "Track the amount of damage fear/hex/turn evil can take before it breaks. This will display below the default Blizzard nameplate", Panel.childPanel2, function(self, value)
                addon.db.PSTrack = value
            end)
            PSTrackBtn:SetChecked(addon.db.PSTrack)
            PSTrackBtn:SetPoint("TOPLEFT", 10, -210)
        end

        local CombatIndicatorButton = CheckBtn("Combat Indicator", "Displays a Combat icon next to Target-/FocusFrame when they enter combat or send pet", Panel.childPanel2, function(self, value)
            addon.db.CombatIndicator = value
        end)
        CombatIndicatorButton:SetChecked(addon.db.CombatIndicator)
        CombatIndicatorButton:SetPoint("TOPLEFT", 10, -70)

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            local ArenaNumbersButton = CheckBtn("Show arena number on nameplate", "When in Arena show 'arena1-5' on enemy nameplates", Panel.childPanel2, function(self, value)
                addon.db.ArenaNumbers = value
            end)
            ArenaNumbersButton:SetChecked(addon.db.ArenaNumbers)
            ArenaNumbersButton:SetPoint("TOPLEFT", 10, -175)
        end

        local ScoreBoardButton = CheckBtn("Class colored PvP Scoreboard", "Color names on the PvP Scoreboard by class", Panel.childPanel2, function(self, value)
            addon.db.ScoreBoard = value
        end)
        ScoreBoardButton:SetChecked(addon.db.ScoreBoard)
        ScoreBoardButton:SetPoint("TOPLEFT", 10, -105)

        CreateText(Panel.childPanel2, 10, -255, "Buffs/Debuffs")

        CreateText(Panel.childPanel2, 350, -40, "Misc")

        local FastKeyPressButton = CheckBtn("Activate spells on key down", "Enabling this will trigger your spells on pressing keys down instead of on releasing them", Panel.childPanel2, function(self, value)
            addon.db.FastKeyPress = value
        end)
        FastKeyPressButton:SetChecked(addon.db.FastKeyPress)
        FastKeyPressButton:SetPoint("TOPLEFT", 350, -70)
        FastKeyPressButton:RegisterEvent("PLAYER_LOGIN")
        FastKeyPressButton:SetScript("OnEvent", function(self, event, ...)
            if (event == "PLAYER_LOGIN") then
                if addon.db.FastKeyPress and (GetCVarBool("ActionButtonUseKeyDown") ~= true) then
                    SetCVar("ActionButtonUseKeyDown", 1)
                end
                self:UnregisterEvent("PLAYER_LOGIN")
                self:SetScript("OnEvent", nil)
            end
        end)

        local SpellQueueWindow = CheckBtn("Auto-adjust SpellQueue Window", "Automatically changes SpellQueue value based on current latency", Panel.childPanel2, function(self, value)
            addon.db.SQFix = value
        end)
        SpellQueueWindow:SetChecked(addon.db.SQFix)
        SpellQueueWindow:SetPoint("TOPLEFT", 350, -105)

        local AutoReadyButton = CheckBtn("Auto accept raid ready check", "When enabled it will automatically accept any readychecks. Warning: Don't AFK or enable when queueing arena with a random", Panel.childPanel2, function(self, value)
            addon.db.AutoReady = value
        end)
        AutoReadyButton:SetChecked(addon.db.AutoReady)
        AutoReadyButton:SetPoint("TOPLEFT", 350, -140)

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            local Retab = CheckBtn("RETabBinder", "Changes TAB Bind to target nearest enemy players when in arena/battleground", Panel.childPanel2, function(self, value)
                addon.db.RETabBinder = value
            end)
            Retab:SetChecked(addon.db.RETabBinder)
            Retab:SetPoint("TOPLEFT", 350, -280)
        end

        local ButtonAnim = CheckBtn("Animated Keypress (SnowFallKeyPress)", "Works with Default/Dominos/Bartender4 actionbars", Panel.childPanel2, function(self, value)
            addon.db.ButtonAnim = value
        end)
        ButtonAnim:SetChecked(addon.db.ButtonAnim)
        ButtonAnim:SetPoint("TOPLEFT", 350, -210)

        local Echo = CheckBtn("WannabeAHK", "Doubles your keypresses - Works with Default/Dominos/Bartender4 actionbars", Panel.childPanel2, function(self, value)
            addon.db.KeyEcho = value
        end)
        Echo:SetChecked(addon.db.KeyEcho)
        Echo:SetPoint("TOPLEFT", 350, -245)

        local Echo = CheckBtn("Actionbar Range Indicator", "Color your actionbuttons when out of range or oom", Panel.childPanel2, function(self, value)
            addon.db.RangeIndicator = value
        end)
        Echo:SetChecked(addon.db.RangeIndicator)
        Echo:SetPoint("TOPLEFT", 350, -175)

        CreateText(Panel.childPanel2, 350, -330, "Rogue Specific")

        local ComboFixButton = CheckBtn("ComboFrame Fix", "This change will allow you to see combo points on mind controlled enemy players", Panel.childPanel2, function(self, value)
            addon.db.cfix = value
        end)
        ComboFixButton:SetChecked(addon.db.cfix)
        ComboFixButton:SetPoint("TOPLEFT", 350, -365)

        if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            local EnemyTicksButton = CheckBtn("Energy Ticker", "Track your Energy Ticks on the manabar", Panel.childPanel2, function(self, value)
                addon.db.EnergyTicker = value
            end)
            EnemyTicksButton:SetChecked(addon.db.EnergyTicker)
            EnemyTicksButton:SetPoint("TOPLEFT", 350, -400)
        else
            local SliceButton = CheckBtn("Slice & Dice Hax", "Use slice and dice on target/focus with your default keybind - requires default Blizzard actionbar/Dominos/Bartender4", Panel.childPanel2, function(self, value)
                addon.db.Slice = value
            end)
            SliceButton:SetChecked(addon.db.Slice)
            SliceButton:SetPoint("TOPLEFT", 350, -400)
        end


        local CastTimerButton = CheckBtn("Customized Castbar", "Styles the Target/FocusFrame castbar and adds a timer", Panel.childPanel5, function(self, value)
            addon.db.CastTimer = value
        end)
        CastTimerButton:SetChecked(addon.db.CastTimer)
        CastTimerButton:SetPoint("TOPLEFT", 10, -40)

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            local HighlightDispellable = CheckBtn("Highlight important Magic/Enrage buffs", "Instead of showing ALL dispellable buffs, this will only highlight non trash magic and enrage effects", Panel.childPanel2, function(self, value)
                addon.db.HighlightDispellable = value
                addon.db.BuffSizer = true
            end)
            HighlightDispellable:SetChecked(addon.db.HighlightDispellable)
            HighlightDispellable:SetPoint("TOPLEFT", 10, -285)
        end

        local TimerButton = CheckBtn("Remove space indentation from buffs", "When enabled (De)buffs will display the time as '1s' instead of '1 s'", Panel.childPanel2, function(self, value)
            addon.db.TimerGap = value
        end)
        TimerButton:SetChecked(addon.db.TimerGap)
        TimerButton:SetPoint("TOPLEFT", 10, -320)

        local BuffAlphaButton = CheckBtn("Disable BuffFrame fading animation", "Disable the pulsing effect on buffs and debuffs", Panel.childPanel2, function(self, value)
            addon.db.BuffAlpha = value
        end)
        BuffAlphaButton:SetChecked(addon.db.BuffAlpha)
        BuffAlphaButton:SetPoint("TOPLEFT", 10, -355)

        local BuffSizerButton = CheckBtn("Enable Buff Resizing", "Enables Target/Focus Frame Buff/Debuff scale sliders", Panel.childPanel2, function(self, value)
            addon.db.BuffSizer = value
            addon.RougeUIF:HookAuras()
            if addon.db.BuffSizer then
                AuraRowSlider:Show()
                TargetBuffSizeSlider:Show()
                TargetPlayerBuffSizeSlider:Show()
            else
                AuraRowSlider:Hide()
                TargetBuffSizeSlider:Hide()
                TargetPlayerBuffSizeSlider:Hide()
            end
        end)
        BuffSizerButton:SetChecked(addon.db.BuffSizer)
        BuffSizerButton:SetPoint("TOPLEFT", 10, -390)

        --childPanel3

        local HideGlowsButton = CheckBtn("Hide glowing effects on PlayerFrame", "Hides the yellow and red glowing when resting or being attacked on PlayerFrame", Panel.childPanel3, function(self, value)
            addon.db.HideGlows = value
        end)
        HideGlowsButton:SetChecked(addon.db.HideGlows)
        HideGlowsButton:SetPoint("TOPLEFT", 10, -40)

        local HideIndicatorButton = CheckBtn("Hide Combat Text on Portrait", "Hides the player and pet combat text on portraits", Panel.childPanel3, function(self, value)
            addon.db.HideIndicator = value
        end)
        HideIndicatorButton:SetChecked(addon.db.HideIndicator)
        HideIndicatorButton:SetPoint("TOPLEFT", 10, -75)

        local HideTitlesButton = CheckBtn("Hide Group/Raid text", "Hides the Group/Raid text showing on top of frames", Panel.childPanel3, function(self, value)
            addon.db.HideTitles = value
        end)
        HideTitlesButton:SetChecked(addon.db.HideTitles)
        HideTitlesButton:SetPoint("TOPLEFT", 10, -110)

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            local AggroHighlightButton = CheckBtn("Hide Aggro highlight on default raid frames", "Hides the red texture that appears on raid frames when someone has aggro", Panel.childPanel3, function(self, value)
                addon.db.HideAggro = value
            end)
            AggroHighlightButton:SetChecked(addon.db.HideAggro)
            AggroHighlightButton:SetPoint("TOPLEFT", 10, -320)
        end

        local HideStanceButton = CheckBtn("Hide StanceBar", "Hides the extra buttons like that show above the actionbars like Cat Form, Stealth and Shadowform", Panel.childPanel3, function(self, value)
            addon.db.Stance = value
        end)
        HideStanceButton:SetChecked(addon.db.Stance)
        HideStanceButton:SetPoint("TOPLEFT", 10, -180)

        local HideHotkeyButton = CheckBtn("Hide Hotkey text on default actionbar", "Hides the keybinding text displayed", Panel.childPanel3, function(self, value)
            addon.db.HideHotkey = value
        end)
        HideHotkeyButton:SetChecked(addon.db.HideHotkey)
        HideHotkeyButton:SetPoint("TOPLEFT", 10, -215)

        local HideMacroButton = CheckBtn("Hide macro text on default actionbar", "Hides the macro name displayed on icons", Panel.childPanel3, function(self, value)
            addon.db.HideMacro = value
        end)
        HideMacroButton:SetChecked(addon.db.HideMacro)
        HideMacroButton:SetPoint("TOPLEFT", 10, -250)

        local HideTotDebuffs = CheckBtn("Hide TargetOfTarget Debuffs", "Hides the 4 small ToT Debuffs", Panel.childPanel3, function(self, value)
            addon.db.ToTDebuffs = value
        end)
        HideTotDebuffs:SetChecked(addon.db.ToTDebuffs)
        HideTotDebuffs:SetPoint("TOPLEFT", 10, -285)

        local HideRoleButton = CheckBtn("Hide role icon on default raid frames", "Hides the role icon on blizzard raid frames", Panel.childPanel3, function(self, value)
            addon.db.roleIcon = value
        end)
        HideRoleButton:SetChecked(addon.db.roleIcon)
        HideRoleButton:SetPoint("TOPLEFT", 10, -145)

        CreateText(Panel.childPanel1, 350, -215, "Player Chain")

        local EliteChain = CheckBtn("Gold Elite PlayerFrame", "Show a `Gold Elite` artwork on PlayerFrame", Panel.childPanel1, function(self, value)
            addon.db.GoldElite = value
        end)
        EliteChain:SetChecked(addon.db.GoldElite)
        EliteChain:SetPoint("TOPLEFT", 350, -250)

        local RareChain = CheckBtn("Rare PlayerFrame", "Show a `Rare` artwork on PlayerFrame", Panel.childPanel1, function(self, value)
            addon.db.Rare = value
        end)
        RareChain:SetChecked(addon.db.Rare)
        RareChain:SetPoint("TOPLEFT", 350, -285)

        local RareElite = CheckBtn("Rare Elite PlayerFrame", "Show a `Rare Elite` artwork on PlayerFrame", Panel.childPanel1, function(self, value)
            addon.db.RareElite = value
        end)
        RareElite:SetChecked(addon.db.RareElite)
        RareElite:SetPoint("TOPLEFT", 350, -320)

    end
    return Panel
end