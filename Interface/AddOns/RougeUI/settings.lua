local Name, addon = ...
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
    Abbreviate = false,
    ShortNumeric = false,
    ManaFontSize = 14,
    HPFontSize = 14,
    SelfSize = 23,
    OtherBuffSize = 23,
    HighlightDispellable = false,
    TimerGap = false,
    ScoreBoard = true,
    HideTitles = true,
    FadePvPIcon = 0.45,
    CombatIndicator = false,
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
    GoldElite = false,
    Rare = false,
    RareElite = false,
    ModPlates = false,
    AuraRow = 122,
    BuffAlpha = false,
    ButtonAnim = false,
    PartyText = false,
    BuffSizer = true,
    Lorti = false,
    Roug = false,
    Modern = false,
    modtheme = false,
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
    wahksfk = false,
    -- EnemyTicker = false,
    OmniCC = false,
    defaultFont = true,
    AsuriFrame = false,
    HidePetText = false,
    minimapChanges = true,
    ManaBarColor = { r = 0.498, g = 0, b = 1.0, a = 1.0 },
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
    if not RougeUI then
        RougeUI = {}
    end
    for i, j in pairs(stock) do
        if type(j) == "table" then
            RougeUI[i] = RougeUI[i] or {}
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
    addon.RougeUIF:CusFonts()
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
    local frame = CreateFrame("CheckButton", title, panel, "ChatConfigCheckButtonTemplate")
    frame:HookScript("OnClick", function(self)
        local enabled = self:GetChecked()
        onClick(self, enabled and true or false)
    end)
    frame.Text = _G[frame:GetName() .. "Text"]
    frame.Text:SetText(title)
    frame.tooltip = desc
    return frame
end

local function CreateText(frame, x, y, text)
    local textstring = frame:CreateFontString(nil, "OVERLAY")
    textstring:SetPoint("TOPLEFT", x, y)
    textstring:SetFont("Fonts\\MORPHEUS.ttf", 14, "")
    textstring:SetText(text)
    textstring:SetVertexColor(0.99, 0.82, 0)
end

local function CreateSliderText(frame)
    frame.text = frame:CreateFontString(frame:GetName() .. "Text", "ARTWORK", "GameFontHighlight")
    frame.text:SetPoint("BOTTOM", frame, "TOP")
    frame.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    frame.textHigh = frame:CreateFontString(frame:GetName() .. "High", "ARTWORK", "GameFontHighlightSmall")
    frame.textHigh:SetText("HIGH")
    frame.textHigh:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 4, 3)
    frame.textHigh:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    frame.textLow = frame:CreateFontString(frame:GetName() .. "Low", "ARTWORK", "GameFontHighlightSmall")
    frame.textLow:SetText("LOW")
    frame.textLow:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -4, 3)
    frame.textLow:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    frame:SetSize(144, 17)
end

local panelOffsets = {}
local function AddElement(panel, element, elementType, headerText)
    local panelName = panel:GetName()
    if not panelOffsets[panelName] then
        panelOffsets[panelName] = -40
    end
    local yOffset = panelOffsets[panelName]
    local xOffset = (elementType == "slider" or elementType == "button" or elementType == "dropdown") and 20 or 10

    if headerText then
        CreateText(panel, 10, yOffset, headerText)
        yOffset = yOffset - 30
    end

    element:SetPoint("TOPLEFT", xOffset, yOffset)

    if elementType == "checkbox" then
        yOffset = yOffset - 35
    elseif elementType == "slider" then
        yOffset = yOffset - 60
    elseif elementType == "button" or elementType == "dropdown" then
        yOffset = yOffset - 40
    end

    panelOffsets[panelName] = yOffset
end

function f:CreateGUI()
    local Panel = CreateFrame("Frame", "$parentRougeUI_Config")
    local Title = "|cff009cffRougeUI|r"
    Panel.name = Title
    local category = Settings.RegisterCanvasLayoutCategory(Panel, Title)
    Settings.RegisterAddOnCategory(category)
    Panel.categoryID = category:GetID()

    local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 12, -15)
    title:SetText(Title)

    local Filler = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Filler:SetPoint("TOP", 0, -50)
    Filler:SetText("Welcome to RougeUI")

    -- Child Panels
    Panel.childPanel1 = CreateFrame("Frame", "$parentConfigChild_UnitFrame", Panel)
    Panel.childPanel1.name = "UnitFrame"
    Panel.childPanel1.parent = Panel.name
    Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel1, "UnitFrame")

    Panel.childPanel2 = CreateFrame("Frame", "$parentConfigChild_Tweaks", Panel)
    Panel.childPanel2.name = "Tweaks"
    Panel.childPanel2.parent = Panel.name
    Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel2, "Tweaks")

    Panel.childPanel3 = CreateFrame("Frame", "$parentConfigChild_Hide", Panel)
    Panel.childPanel3.name = "Hide Elements"
    Panel.childPanel3.parent = Panel.name
    Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel3, "Hide Elements")

    Panel.childPanel4 = CreateFrame("Frame", "$parentConfigChild_StatusBar", Panel)
    Panel.childPanel4.name = "StatusBar"
    Panel.childPanel4.parent = Panel.name
    Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel4, "StatusBar")

    Panel.childPanel7 = CreateFrame("Frame", "$parentConfigChild_Auras", Panel)
    Panel.childPanel7.name = "Auras"
    Panel.childPanel7.parent = Panel.name
    Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel7, "Auras")

    Panel.childPanel5 = CreateFrame("Frame", "$parentConfigChild_Misc", Panel)
    Panel.childPanel5.name = "Misc"
    Panel.childPanel5.parent = Panel.name
    Settings.RegisterCanvasLayoutSubcategory(category, Panel.childPanel5, "Misc")

    for _, v in pairs({ Panel.childPanel1, Panel.childPanel2, Panel.childPanel3, Panel.childPanel4, Panel.childPanel5, Panel.childPanel7 }) do
        local Reload = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
        Reload:SetPoint("BOTTOMRIGHT", -10, 10)
        Reload:SetWidth(100)
        Reload:SetHeight(25)
        Reload:SetText("Save & Reload")
        Reload:SetScript("OnClick", function()
            ReloadUI()
        end)
    end

    local sliderTemplate = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and "UISliderTemplate" or "OptionsSliderTemplate"

    -- childPanel1: UnitFrame
    local ClassPortraitButton = CheckBtn("Class Portraits", "Turn this on to display class portrait frames", Panel.childPanel1, function(self, value)
        addon.db.Class_Portrait = value
    end)
    ClassPortraitButton:SetChecked(addon.db.Class_Portrait)
    AddElement(Panel.childPanel1, ClassPortraitButton, "checkbox", "Class colored indicators")

    local ClassOutlines = CheckBtn("Class Colored Outlines", "When enabled it will add a class colored circle around target and focus frame portraits", Panel.childPanel1, function(self, value)
        addon.db.classoutline = value
    end)
    ClassOutlines:SetChecked(addon.db.classoutline)
    AddElement(Panel.childPanel1, ClassOutlines, "checkbox")

    local ClassCNames = CheckBtn("Class Colored Names", "Color names to their class color", Panel.childPanel1, function(self, value)
        addon.db.ClassNames = value
    end)
    ClassCNames:SetChecked(addon.db.ClassNames)
    AddElement(Panel.childPanel1, ClassCNames, "checkbox")

    local NameBackgroundDropdown = CreateFrame("DropdownButton", "RougeUINameBackgroundDropdown", Panel.childPanel1, "WowStyle1DropdownTemplate")
    NameBackgroundDropdown:SetWidth(150)
    NameBackgroundDropdown:SetDefaultText("Select Name Background")
    local function NameBackgroundGenerator(dropdown, rootDescription)
        local function IsSelected(value)
            if value == "None" then
                return not addon.db.ClassBG and not addon.db.transparent
            elseif value == "ClassBG" then
                return addon.db.ClassBG
            elseif value == "transparent" then
                return addon.db.transparent
            end
            return false
        end
        local function SetSelected(value)
            if value == "ClassBG" then
                if addon.db.ThickFrames then
                    UIErrorsFrame:AddMessage("This cannot be enabled with big frames", 1, 0, 0)
                    return -- Prevent selection
                end
                addon.db.ClassBG = true
                addon.db.transparent = false
                if IsAddOnLoaded("Leatrix_Plus") and LeaPlusDB["ClassColFrames"] == "On" then
                    UIErrorsFrame:AddMessage("Don't forget to disable Class colored frames in Leatrix Plus", 1, 0, 0)
                    print("Don't forget to disable Class colored frames in Leatrix Plus")
                end
            elseif value == "transparent" then
                addon.db.transparent = true
                addon.db.ClassBG = false
            else -- None
                addon.db.ClassBG = false
                addon.db.transparent = false
            end
            dropdown:GenerateMenu() -- Update selection text
        end
        MenuUtil.CreateRadioMenu(dropdown,
                IsSelected, SetSelected,
                {"Default", "None"},
                {"Class Colored", "ClassBG"},
                {"Transparent", "transparent"}
        )
    end
    NameBackgroundDropdown:SetupMenu(NameBackgroundGenerator)
    AddElement(Panel.childPanel1, NameBackgroundDropdown, "dropdown", "Name Background")

    local FrameStyleDropdown = CreateFrame("DropdownButton", "RougeUIFrameStyleDropdown", Panel.childPanel1, "WowStyle1DropdownTemplate")
    FrameStyleDropdown:SetWidth(150)
    FrameStyleDropdown:SetDefaultText("Select Frame Style")
    local function FrameStyleGenerator(dropdown, rootDescription)
        local function IsSelected(value)
            if value == "Default" then
                return not addon.db.ThickFrames and not addon.db.AsuriFrame
            elseif value == "ThickFrames" then
                return addon.db.ThickFrames
            elseif value == "AsuriFrame" then
                return addon.db.AsuriFrame
            end
            return false
        end
        local function SetSelected(value)
            if value == "ThickFrames" then
                addon.db.ThickFrames = true
                addon.db.AsuriFrame = false
                addon.db.ClassBG = false
                if IsAddOnLoaded("Leatrix_Plus") and LeaPlusDB["ClassColFrames"] == "On" then
                    UIErrorsFrame:AddMessage("Don't forget to disable Class colored frames in Leatrix Plus", 1, 0, 0)
                    print("Don't forget to disable Class colored frames in Leatrix Plus")
                end
            elseif value == "AsuriFrame" then
                addon.db.AsuriFrame = true
                addon.db.ThickFrames = false
                addon.db.ClassBG = false
                addon.db.transparent = false
                addon.db.NoLevel = false
            else -- None
                addon.db.ThickFrames = false
                addon.db.AsuriFrame = false
            end
            dropdown:GenerateMenu()
        end
        MenuUtil.CreateRadioMenu(dropdown,
                IsSelected, SetSelected,
                {"None", "None"},
                {"Big Frames", "ThickFrames"},
                {"Asuri's UI Frames", "AsuriFrame"}
        )
    end
    FrameStyleDropdown:SetupMenu(FrameStyleGenerator)
    AddElement(Panel.childPanel1, FrameStyleDropdown, "dropdown", "Frame Style")

    local PartyTextButton = CheckBtn("Show HP/Mana Text on PartyFrames", "This will show the HP/Mana StatusText on party1-4", Panel.childPanel1, function(self, value)
        addon.db.PartyText = value
    end)
    PartyTextButton:SetChecked(addon.db.PartyText)
    AddElement(Panel.childPanel1, PartyTextButton, "checkbox", "Statustext")

    local defaultFontButton = CheckBtn("Retail text font", "This changes the WoW font to a retail look", Panel.childPanel1, function(self, value)
        addon.db.defaultFont = value
    end)
    defaultFontButton:SetChecked(addon.db.defaultFont)
    AddElement(Panel.childPanel1, defaultFontButton, "checkbox")

    local StatusTextDropdown = CreateFrame("DropdownButton", "RougeUIStatusTextDropdown", Panel.childPanel1, "WowStyle1DropdownTemplate")
    StatusTextDropdown:SetWidth(150)
    StatusTextDropdown:SetDefaultText("Select Status Text")
    local function StatusTextGenerator(dropdown, rootDescription)
        local function IsSelected(value)
            if value == "Full" then
                return not addon.db.Abbreviate and not addon.db.ShortNumeric
            elseif value == "Abbreviate" then
                return addon.db.Abbreviate
            elseif value == "ShortNumeric" then
                return addon.db.ShortNumeric
            end
            return false
        end
        local function SetSelected(value)
            addon.db.Abbreviate = (value == "Abbreviate")
            addon.db.ShortNumeric = (value == "ShortNumeric")
            dropdown:GenerateMenu()
        end
        MenuUtil.CreateRadioMenu(dropdown,
                IsSelected, SetSelected,
                {"Default", "Full"},
                {"Shorten HP/Mana", "ShortNumeric"},
                {"Current HP/Mana Only", "Abbreviate"}
        )
    end
    StatusTextDropdown:SetupMenu(StatusTextGenerator)
    AddElement(Panel.childPanel1, StatusTextDropdown, "dropdown")


    local PlayerFrameStyleDropdown = CreateFrame("DropdownButton", "RougeUIPlayerFrameStyleDropdown", Panel.childPanel1, "WowStyle1DropdownTemplate")
    PlayerFrameStyleDropdown:SetWidth(150)
    PlayerFrameStyleDropdown:SetDefaultText("Select Frame Style")
    local function PlayerFrameStyleGenerator(dropdown, rootDescription)
        local function IsSelected(value)
            if value == "None" then
                return not addon.db.GoldElite and not addon.db.Rare and not addon.db.RareElite
            elseif value == "GoldElite" then
                return addon.db.GoldElite
            elseif value == "Rare" then
                return addon.db.Rare
            elseif value == "RareElite" then
                return addon.db.RareElite
            end
            return false
        end
        local function SetSelected(value)
            addon.db.GoldElite = (value == "GoldElite")
            addon.db.Rare = (value == "Rare")
            addon.db.RareElite = (value == "RareElite")
            dropdown:GenerateMenu()
        end
        MenuUtil.CreateRadioMenu(dropdown,
                IsSelected, SetSelected,
                {"None", "None"},
                {"Gold Elite", "GoldElite"},
                {"Rare", "Rare"},
                {"Rare Elite", "RareElite"}
        )
    end
    PlayerFrameStyleDropdown:SetupMenu(PlayerFrameStyleGenerator)
    AddElement(Panel.childPanel1, PlayerFrameStyleDropdown, "dropdown", "Player Elite Frame")

    local FontSizeSlider = CreateFrame("Slider", "FontSizeSlider", Panel.childPanel1, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(FontSizeSlider)
    else
        FontSizeSlider.text = _G["FontSizeSliderText"]
        FontSizeSlider.textHigh = _G["FontSizeSliderHigh"]
        FontSizeSlider.textLow = _G["FontSizeSliderLow"]
    end
    FontSizeSlider:SetMinMaxValues(8, 16)
    FontSizeSlider.minValue, FontSizeSlider.maxValue = FontSizeSlider:GetMinMaxValues()
    FontSizeSlider.textLow:SetText(FontSizeSlider.minValue)
    FontSizeSlider.textHigh:SetText(FontSizeSlider.maxValue)
    FontSizeSlider:SetValue(addon.db.HPFontSize)
    FontSizeSlider.text:SetText("HealthText Size " .. FontSizeSlider:GetValue())
    FontSizeSlider:SetValueStep(1)
    FontSizeSlider:SetObeyStepOnDrag(true)
    FontSizeSlider:SetScript("OnValueChanged", function(self)
        self.text:SetText("HealthText Size: " .. self:GetValue())
        addon.db.HPFontSize = self:GetValue()
        addon.RougeUIF:CusFonts()
    end)
    FontSizeSlider:SetPoint("TOPLEFT", 400, -90)

    local MFontSizeSlider = CreateFrame("Slider", "MFontSizeSlider", Panel.childPanel1, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(MFontSizeSlider)
    else
        MFontSizeSlider.text = _G["MFontSizeSliderText"]
        MFontSizeSlider.textHigh = _G["MFontSizeSliderHigh"]
        MFontSizeSlider.textLow = _G["MFontSizeSliderLow"]
    end
    MFontSizeSlider:SetMinMaxValues(8, 16)
    MFontSizeSlider.minValue, MFontSizeSlider.maxValue = MFontSizeSlider:GetMinMaxValues()
    MFontSizeSlider.textLow:SetText(MFontSizeSlider.minValue)
    MFontSizeSlider.textHigh:SetText(MFontSizeSlider.maxValue)
    MFontSizeSlider:SetValue(addon.db.ManaFontSize)
    MFontSizeSlider.text:SetText("ManaText Size " .. MFontSizeSlider:GetValue())
    MFontSizeSlider:SetValueStep(1)
    MFontSizeSlider:SetObeyStepOnDrag(true)
    MFontSizeSlider:SetScript("OnValueChanged", function(self)
        self.text:SetText("ManaText Size: " .. self:GetValue())
        addon.db.ManaFontSize = self:GetValue()
        addon.RougeUIF:CusFonts()
    end)
    MFontSizeSlider:SetPoint("TOPLEFT", 400, -90 - 60)

    local FadePVPICON = CreateFrame("Slider", "FadePVPICON", Panel.childPanel1, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(FadePVPICON)
    else
        FadePVPICON.text = _G["FadePVPICONText"]
        FadePVPICON.textLow = _G["FadePVPICONLow"]
        FadePVPICON.textHigh = _G["FadePVPICONHigh"]
    end
    FadePVPICON:SetMinMaxValues(0, 1)
    FadePVPICON.minValue, FadePVPICON.maxValue = FadePVPICON:GetMinMaxValues()
    FadePVPICON.textLow:SetText(floor(FadePVPICON.minValue))
    FadePVPICON.textHigh:SetText(floor(FadePVPICON.maxValue))
    FadePVPICON:SetValue(addon.db.FadePvPIcon)
    FadePVPICON.text:SetText("PvP Icon transparency: " .. format("%.2f", FadePVPICON:GetValue()))
    FadePVPICON:SetValueStep(0.05)
    FadePVPICON:SetObeyStepOnDrag(true)
    FadePVPICON:SetScript("OnValueChanged", function(_, value)
        FadePVPICON.text:SetText("PvP Icon transparency: " .. RoundNumbers(value, 0.05))
        addon.db.FadePvPIcon = value
        addon.PvPIcon()
    end)
    FadePVPICON:SetPoint("TOPLEFT", 400, -90 - 120)

    local ColorValueSlider = CreateFrame("Slider", "ColorValueSlider", Panel.childPanel1, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(ColorValueSlider)
    else
        ColorValueSlider.text = _G["ColorValueSliderText"]
        ColorValueSlider.textHigh = _G["ColorValueSliderHigh"]
        ColorValueSlider.textLow = _G["ColorValueSliderLow"]
    end
    ColorValueSlider:SetMinMaxValues(0, 1)
    ColorValueSlider.minValue, ColorValueSlider.maxValue = ColorValueSlider:GetMinMaxValues()
    ColorValueSlider.textLow:SetText(floor(ColorValueSlider.minValue))
    ColorValueSlider.textHigh:SetText(floor(ColorValueSlider.maxValue))
    ColorValueSlider:SetValue(addon.db.Colval)
    ColorValueSlider.text:SetText("UI Frame Darkness: " .. format("%.2f", ColorValueSlider:GetValue()))
    ColorValueSlider:SetValueStep(0.05)
    ColorValueSlider:SetObeyStepOnDrag(true)
    ColorValueSlider:SetScript("OnValueChanged", function(_, value)
        ColorValueSlider.text:SetText("UI Frame Darkness: " .. RoundNumbers(value, 0.05))
        addon.db.Colval = value
        addon.RougeUIF:ChangeFrameColors()
    end)
    ColorValueSlider:SetPoint("TOPLEFT", 400, -90 - 180)

    local BuffColSlider = CreateFrame("Slider", "BuffColSlider", Panel.childPanel1, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(BuffColSlider)
    else
        BuffColSlider.text = _G["BuffColSliderText"]
        BuffColSlider.textHigh = _G["BuffColSliderHigh"]
        BuffColSlider.textLow = _G["BuffColSliderLow"]
    end
    BuffColSlider:SetMinMaxValues(0, 1)
    if addon.db.Modern or addon.db.modtheme then
        BuffColSlider:Show()
    else
        BuffColSlider:Hide()
    end
    BuffColSlider.minValue, BuffColSlider.maxValue = BuffColSlider:GetMinMaxValues()
    BuffColSlider.textLow:SetText(floor(BuffColSlider.minValue))
    BuffColSlider.textHigh:SetText(floor(BuffColSlider.maxValue))
    BuffColSlider:SetValue(addon.db.BuffVal)
    BuffColSlider.text:SetText("Theme's Border Brightness: " .. format("%.2f", BuffColSlider:GetValue()))
    BuffColSlider:SetValueStep(0.05)
    BuffColSlider:SetObeyStepOnDrag(true)
    BuffColSlider:SetScript("OnValueChanged", function(_, value)
        BuffColSlider.text:SetText("Theme's Border Brightness: " .. RoundNumbers(value, 0.05))
        addon.db.BuffVal = value
    end)
    BuffColSlider:SetPoint("TOPLEFT", 400, -90 - 240)

    -- childPanel2: Tweaks
    local EnemyTicksButton = CheckBtn("Enemy Out of Combat Countdown", "Shows how long until the enemy leaves combat.", Panel.childPanel2, function(self, value)
        addon.db.EnemyTicks = value
    end)
    EnemyTicksButton:SetChecked(addon.db.EnemyTicks)
    AddElement(Panel.childPanel2, EnemyTicksButton, "checkbox", "PvP Tweaks")

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        local PSTrackBtn = CheckBtn("Crowd control absorb threshold", "Track the amount of damage fear/hex/turn evil can take before it breaks. This will display below the default Blizzard nameplate", Panel.childPanel2, function(self, value)
            addon.db.PSTrack = value
        end)
        PSTrackBtn:SetChecked(addon.db.PSTrack)
        AddElement(Panel.childPanel2, PSTrackBtn, "checkbox")
    end

    local CombatIndicatorButton = CheckBtn("Combat Indicator", "Displays a Combat icon next to Target-/FocusFrame when they enter combat or send pet", Panel.childPanel2, function(self, value)
        addon.db.CombatIndicator = value
    end)
    CombatIndicatorButton:SetChecked(addon.db.CombatIndicator)
    AddElement(Panel.childPanel2, CombatIndicatorButton, "checkbox")

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        local ArenaNumbersButton = CheckBtn("Show arena number on nameplate", "When in Arena show 'arena1-5' on enemy nameplates", Panel.childPanel2, function(self, value)
            addon.db.ArenaNumbers = value
        end)
        ArenaNumbersButton:SetChecked(addon.db.ArenaNumbers)
        AddElement(Panel.childPanel2, ArenaNumbersButton, "checkbox")
    end

    local ScoreBoardButton = CheckBtn("Class colored PvP Scoreboard", "Color names on the PvP Scoreboard by class", Panel.childPanel2, function(self, value)
        addon.db.ScoreBoard = value
    end)
    ScoreBoardButton:SetChecked(addon.db.ScoreBoard)
    AddElement(Panel.childPanel2, ScoreBoardButton, "checkbox")

    local FastKeyPressButton = CheckBtn("Activate spells on key down", "Enabling this will trigger your spells on pressing keys down instead of on releasing them", Panel.childPanel2, function(self, value)
        addon.db.FastKeyPress = value
    end)
    FastKeyPressButton:SetChecked(addon.db.FastKeyPress)
    FastKeyPressButton:RegisterEvent("PLAYER_LOGIN")
    FastKeyPressButton:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" then
            if addon.db.FastKeyPress and not GetCVarBool("ActionButtonUseKeyDown") then
                SetCVar("ActionButtonUseKeyDown", 1)
            end
            self:UnregisterEvent("PLAYER_LOGIN")
            self:SetScript("OnEvent", nil)
        end
    end)
    AddElement(Panel.childPanel2, FastKeyPressButton, "checkbox", "Misc")

    local SpellQueueWindow = CheckBtn("Auto-adjust SpellQueue Window", "Automatically changes SpellQueue value based on current latency", Panel.childPanel2, function(self, value)
        addon.db.SQFix = value
    end)
    SpellQueueWindow:SetChecked(addon.db.SQFix)
    AddElement(Panel.childPanel2, SpellQueueWindow, "checkbox")

    local AutoReadyButton = CheckBtn("Auto accept raid ready check", "When enabled it will automatically accept any readychecks. Warning: Don't AFK or enable when queueing arena with a random", Panel.childPanel2, function(self, value)
        addon.db.AutoReady = value
    end)
    AutoReadyButton:SetChecked(addon.db.AutoReady)
    AddElement(Panel.childPanel2, AutoReadyButton, "checkbox")

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        local Retab = CheckBtn("RETabBinder", "Changes TAB Bind to target nearest enemy players when in arena/battleground", Panel.childPanel2, function(self, value)
            addon.db.retab = value
        end)
        Retab:SetChecked(addon.db.retab)
        AddElement(Panel.childPanel2, Retab, "checkbox")
    end

    local ButtonAnim = CheckBtn("Animated Keypress (SnowFallKeyPress)", "Works with Default/Dominos/Bartender4 actionbars", Panel.childPanel2, function(self, value)
        addon.db.ButtonAnim = value
    end)
    ButtonAnim:SetChecked(addon.db.ButtonAnim)
    AddElement(Panel.childPanel2, ButtonAnim, "checkbox")

    local Echo = CheckBtn("Wannabe AutoHotKey", "Doubles your keypresses - Works with Default/Dominos/Bartender4 actionbars", Panel.childPanel2, function(self, value)
        addon.db.KeyEcho = value
    end)
    Echo:SetChecked(addon.db.KeyEcho)
    AddElement(Panel.childPanel2, Echo, "checkbox")

    local RangeIndicator = CheckBtn("Actionbar Range Indicator", "Color your actionbuttons when out of range or oom", Panel.childPanel2, function(self, value)
        addon.db.RangeIndicator = value
    end)
    RangeIndicator:SetChecked(addon.db.RangeIndicator)
    AddElement(Panel.childPanel2, RangeIndicator, "checkbox")

    local ComboFixButton = CheckBtn("ComboFrame Fix", "This change will instantly display combopoints and display them on mind controlled enemy players", Panel.childPanel2, function(self, value)
        addon.db.cfix = value
    end)
    ComboFixButton:SetChecked(addon.db.cfix)
    AddElement(Panel.childPanel2, ComboFixButton, "checkbox", "Rogue Specific")

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        local SliceButton = CheckBtn("Slice & Dice Hax", "Use slice and dice on target/focus with your default keybind - requires default Blizzard actionbar/Dominos/Bartender4", Panel.childPanel2, function(self, value)
            addon.db.Slice = value
        end)
        SliceButton:SetChecked(addon.db.Slice)
        AddElement(Panel.childPanel2, SliceButton, "checkbox")
    end

    -- childPanel3: Hide Elements
    local HideGlowsButton = CheckBtn("Hide glow on player frame", "Hides the yellow and red glowing when resting or being attacked on PlayerFrame", Panel.childPanel3, function(self, value)
        addon.db.HideGlows = value
    end)
    HideGlowsButton:SetChecked(addon.db.HideGlows)
    AddElement(Panel.childPanel3, HideGlowsButton, "checkbox")

    local HideIndicatorButton = CheckBtn("Hide CombatText spam on portrait", "Hides the player and pet combat text on portraits", Panel.childPanel3, function(self, value)
        addon.db.HideIndicator = value
    end)
    HideIndicatorButton:SetChecked(addon.db.HideIndicator)
    AddElement(Panel.childPanel3, HideIndicatorButton, "checkbox")

    local HideTitlesButton = CheckBtn("Hide Group/Raid text", "Hides the Group/Raid text showing on top of raid frames", Panel.childPanel3, function(self, value)
        addon.db.HideTitles = value
    end)
    HideTitlesButton:SetChecked(addon.db.HideTitles)
    AddElement(Panel.childPanel3, HideTitlesButton, "checkbox")

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        local AggroHighlightButton = CheckBtn("Hide Aggro highlight on default raid frames", "Hides the red texture that appears on raid frames when someone has aggro", Panel.childPanel3, function(self, value)
            addon.db.HideAggro = value
        end)
        AggroHighlightButton:SetChecked(addon.db.HideAggro)
        AddElement(Panel.childPanel3, AggroHighlightButton, "checkbox")
    end

    local HidePetText = CheckBtn("Hide Pet Health/Mana", "Hides Pet text", Panel.childPanel3, function(self, value)
        addon.db.HidePetText = value
        if PetFrameHealthBarText then
            PetFrameHealthBarText:SetAlpha(0)
        end
        if PetFrameManaBarText then
            PetFrameManaBarText:SetAlpha(0)
        end
    end)
    HidePetText:SetChecked(addon.db.HidePetText)
    AddElement(Panel.childPanel3, HidePetText, "checkbox")

    local HideStanceButton = CheckBtn("Hide StanceBar", "Hides the extra buttons like that show above the actionbars like Cat Form, Stealth and Shadowform", Panel.childPanel3, function(self, value)
        addon.db.Stance = value
    end)
    HideStanceButton:SetChecked(addon.db.Stance)
    AddElement(Panel.childPanel3, HideStanceButton, "checkbox")

    local HideHotkeyButton = CheckBtn("Hide Hotkey text on default actionbar", "Hides the keybinding text displayed", Panel.childPanel3, function(self, value)
        addon.db.HideHotkey = value
    end)
    HideHotkeyButton:SetChecked(addon.db.HideHotkey)
    AddElement(Panel.childPanel3, HideHotkeyButton, "checkbox")

    local HideMacroButton = CheckBtn("Hide macro text on default actionbar", "Hides the macro name displayed on icons", Panel.childPanel3, function(self, value)
        addon.db.HideMacro = value
    end)
    HideMacroButton:SetChecked(addon.db.HideMacro)
    AddElement(Panel.childPanel3, HideMacroButton, "checkbox")

    local HideTotDebuffs = CheckBtn("Hide TargetOfTarget Debuffs", "Hides the 4 small ToT Debuffs", Panel.childPanel3, function(self, value)
        addon.db.ToTDebuffs = value
    end)
    HideTotDebuffs:SetChecked(addon.db.ToTDebuffs)
    AddElement(Panel.childPanel3, HideTotDebuffs, "checkbox")

    local HideRoleButton = CheckBtn("Hide role icon on default raid frames", "Hides the role icon on blizzard raid frames", Panel.childPanel3, function(self, value)
        addon.db.roleIcon = value
    end)
    HideRoleButton:SetChecked(addon.db.roleIcon)
    AddElement(Panel.childPanel3, HideRoleButton, "checkbox")

    local Nolvl = CheckBtn("Hide level text on frames", "Hide the level text on Player/Target/Focus frames and nameplates", Panel.childPanel3, function(self, value)
        addon.db.NoLevel = value
    end)
    Nolvl:SetChecked(addon.db.NoLevel)
    AddElement(Panel.childPanel3, Nolvl, "checkbox")

    -- childPanel4: StatusBar
    local ClassHPButton = CheckBtn("Enable Class Colored HealthBar", "Enabling this will change the green healthBar color to the class color", Panel.childPanel4, function(self, value)
        addon.db.ClassHP = value
    end)
    ClassHPButton:SetChecked(addon.db.ClassHP)
    AddElement(Panel.childPanel4, ClassHPButton, "checkbox")

    local UnitHPButton = CheckBtn("Color HealthBar based on Unit Status", "This will change the healthBar color to red (hostile), green (friendly) or yellow (neutral)", Panel.childPanel4, function(self, value)
        addon.db.unithp = value
    end)
    UnitHPButton:SetChecked(addon.db.unithp)

    local GradientHPButton = CheckBtn("Enable Smooth Color Gradient on Healthbar", "This changes the healthBar color from green > yellow > orange > red based on the current percentage", Panel.childPanel4, function(self, value)
        addon.db.GradientHP = value
        addon.db.ClassHP = false
        addon.db.unithp = false
        ClassHPButton:SetChecked(addon.db.ClassHP)
        UnitHPButton:SetChecked(addon.db.unithp)
    end)
    GradientHPButton:SetChecked(addon.db.GradientHP)
    AddElement(Panel.childPanel4, GradientHPButton, "checkbox")
    AddElement(Panel.childPanel4, UnitHPButton, "checkbox")

    local SmoothFrameButton = CheckBtn("Smooth Animated Health & Mana Bar", "Adds a smoother transition effect when gaining / losing mana or health", Panel.childPanel4, function(self, value)
        addon.db.smooth = value
    end)
    SmoothFrameButton:SetChecked(addon.db.smooth)
    AddElement(Panel.childPanel4, SmoothFrameButton, "checkbox")

    local EnergyTickerButton = CheckBtn("Personal energy ticker", "Track your own power ticks on the manabar", Panel.childPanel4, function(self, value)
        addon.db.EnergyTicker = value
    end)
    EnergyTickerButton:SetChecked(addon.db.EnergyTicker)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        AddElement(Panel.childPanel4, EnergyTickerButton, "checkbox")
    end

    local ColorPickerButton = CreateFrame("Button", nil, Panel.childPanel4, "UIPanelButtonTemplate")
    ColorPickerButton:SetSize(140, 25)
    ColorPickerButton:SetText("Set Manabar Color")
    if addon.db.pimp then
        ColorPickerButton:Show()
    else
        ColorPickerButton:Hide()
    end
    ColorPickerButton:SetScript("OnClick", function()
        local db = addon.db
        local currentColor = db.ManaBarColor or { r = 0.25, g = 0.5, b = 1, a = 1.0 }
        local previous = { r = currentColor.r, g = currentColor.g, b = currentColor.b, a = currentColor.a }
        local function OnColorChanged()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            local a = ColorPickerFrame:GetColorAlpha()
            db.ManaBarColor = { r = r, g = g, b = b, a = a }
            local c = db.ManaBarColor
            if c then
                PlayerFrameManaBar:SetStatusBarColor(c.r, c.g, c.b, c.a)
            end
        end
        local function OnCancel()
            db.ManaBarColor = { r = previous.r, g = previous.g, b = previous.b, a = previous.a }
            local c = db.ManaBarColor
            if c then
                PlayerFrameManaBar:SetStatusBarColor(c.r, c.g, c.b, c.a)
            end
        end
        local options = {
            swatchFunc = OnColorChanged,
            opacityFunc = OnColorChanged,
            cancelFunc = OnCancel,
            hasOpacity = true,
            opacity = currentColor.a,
            r = currentColor.r,
            g = currentColor.g,
            b = currentColor.b,
        }
        ColorPickerFrame:SetupColorPickerAndShow(options)
    end)

    local PimpFrameButton = CheckBtn("Recolor manabar", "Enables a color pick wheel to change the manabar color", Panel.childPanel4, function(self, value)
        addon.db.pimp = value
        ColorPickerButton:SetShown(value)
        if value then
            print("Reload to apply the manabar color change fully.")
        end
    end)
    PimpFrameButton:SetChecked(addon.db.pimp)
    AddElement(Panel.childPanel4, PimpFrameButton, "checkbox")
    AddElement(Panel.childPanel4, ColorPickerButton, "button")

    -- childPanel5: Misc
    local ModPlates = CheckBtn("Custom Nameplates", "This will slightly alter the original nameplate style", Panel.childPanel5, function(self, value)
        addon.db.ModPlates = value
    end)
    ModPlates:SetChecked(addon.db.ModPlates)
    AddElement(Panel.childPanel5, ModPlates, "checkbox")

    local CastTimerButton = CheckBtn("Custom Castbar", "Styles the Player, Target and FocusFrame castbar and adds a timer", Panel.childPanel5, function(self, value)
        addon.db.CastTimer = value
    end)
    CastTimerButton:SetChecked(addon.db.CastTimer)
    AddElement(Panel.childPanel5, CastTimerButton, "checkbox")

    local CustomMM = CheckBtn("Custom Minimap", "Changes the appearance of the original minimap", Panel.childPanel5, function(self, value)
        addon.db.minimapChanges = value
    end)
    CustomMM:SetChecked(addon.db.minimapChanges)
    AddElement(Panel.childPanel5, CustomMM, "checkbox")

    local ThemeDropdown = CreateFrame("DropdownButton", "RougeUIThemeDropdown", Panel.childPanel1, "WowStyle1DropdownTemplate")
    ThemeDropdown:SetWidth(150)
    ThemeDropdown:SetDefaultText("Select Theme")
    local function ThemeGenerator(dropdown, rootDescription)
        local function IsSelected(value)
            if value == "None" then
                return not addon.db.Roug and not addon.db.modtheme and not addon.db.Minimalist and not addon.db.Lorti
            elseif value == "Roug" then
                return addon.db.Roug
            elseif value == "modtheme" then
                return addon.db.modtheme
            elseif value == "Minimalist" then
                return addon.db.Minimalist
            elseif value == "Lorti" then
                return addon.db.Lorti
            end
            return false
        end
        local function SetSelected(value)
            addon.db.Roug = (value == "Roug")
            addon.db.modtheme = (value == "modtheme")
            addon.db.Minimalist = (value == "Minimalist")
            if value == "modtheme" or value == "Minimalist" then
                BuffColSlider:Show()
            else
                BuffColSlider:Hide()
            end
            addon.db.Lorti = (value == "Lorti")
            dropdown:GenerateMenu()
        end
        MenuUtil.CreateRadioMenu(dropdown,
                IsSelected, SetSelected,
                {"None", "None"},
                {"RougeUI", "Roug"},
                {"ModUI", "modtheme"},
                {"Minimalist", "Minimalist"},
                {"Lorti", "Lorti"}
        )
    end
    ThemeDropdown:SetupMenu(ThemeGenerator)
    AddElement(Panel.childPanel1, ThemeDropdown, "dropdown", "Skin")

    -- childPanel7: Auras
    C_Timer.After(1, function()
        if not IsAddOnLoaded("SimpleAuraFilter") then
            local BuffValueSlider = CreateFrame("Slider", "BuffValueSlider", Panel.childPanel7, sliderTemplate)
            if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
                CreateSliderText(BuffValueSlider)
            else
                BuffValueSlider.text = _G["BuffValueSliderText"]
                BuffValueSlider.textLow = _G["BuffValueSliderLow"]
                BuffValueSlider.textHigh = _G["BuffValueSliderHigh"]
            end
            BuffValueSlider:SetMinMaxValues(2, 10)
            BuffValueSlider.minValue, BuffValueSlider.maxValue = BuffValueSlider:GetMinMaxValues()
            BuffValueSlider.textLow:SetText(floor(BuffValueSlider.minValue))
            BuffValueSlider.textHigh:SetText(floor(BuffValueSlider.maxValue))
            BuffValueSlider:SetValue(addon.db.BuffsRow)
            BuffValueSlider.text:SetText("Buffs per row (BuffFrame): " .. format("%.f", BuffValueSlider:GetValue()))
            BuffValueSlider:SetValueStep(1)
            BuffValueSlider:SetObeyStepOnDrag(true)
            BuffValueSlider:SetScript("OnValueChanged", function(_, value)
                BuffValueSlider.text:SetText("Buffs per row (BuffFrame): " .. RoundNumbers(value, 1))
                addon.db.BuffsRow = value
            end)
            AddElement(Panel.childPanel7, BuffValueSlider, "slider")
        end
    end)

    local OmniTimers = CheckBtn("OmniCC Buff Timers", "Disable Blizzard's buff timers and use OmniCC instead", Panel.childPanel7, function(self, value)
        if not IsAddOnLoaded("OmniCC") then
            UIErrorsFrame:AddMessage("To enable this option you have to enable OmniCC first", 1, 0, 0)
            self:SetChecked(false)
            addon.db.OmniCC = false
            return
        end
        addon.db.OmniCC = value
    end)
    OmniTimers:SetChecked(addon.db.OmniCC)
    AddElement(Panel.childPanel7, OmniTimers, "checkbox", "Aura Settings")

    local HighlightDispellable = CheckBtn(WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and "Highlight Dispellable Buffs" or "Highlight important Magic/Enrage buffs", WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and "Highlights enemy magic buffs" or "Instead of showing ALL dispellable buffs, this will only highlight non trash magic and enrage effects", Panel.childPanel7, function(self, value)
        addon.db.HighlightDispellable = value
        addon.db.BuffSizer = true
    end)
    HighlightDispellable:SetChecked(addon.db.HighlightDispellable)
    AddElement(Panel.childPanel7, HighlightDispellable, "checkbox")

    local TimerButton = CheckBtn("Remove space indentation (BuffFrame)", "When enabled (De)buffs will display the time as '1s' instead of '1 s'", Panel.childPanel7, function(self, value)
        addon.db.TimerGap = value
    end)
    TimerButton:SetChecked(addon.db.TimerGap)
    AddElement(Panel.childPanel7, TimerButton, "checkbox")

    local BuffAlphaButton = CheckBtn("Disable fading animation on BuffFrame", "Disable the pulsing effect on buffs and debuffs", Panel.childPanel7, function(self, value)
        addon.db.BuffAlpha = value
    end)
    BuffAlphaButton:SetChecked(addon.db.BuffAlpha)
    AddElement(Panel.childPanel7, BuffAlphaButton, "checkbox")

    local BuffSizerButton = CheckBtn("Enable Buff Resizing (Target-/FocusFrame)", "Enables Target/Focus Frame Buff/Debuff scale sliders", Panel.childPanel7, function(self, value)
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
    AddElement(Panel.childPanel7, BuffSizerButton, "checkbox")

    local TargetPlayerBuffSizeSlider = CreateFrame("Slider", "TargetPlayerBuffSizeSlider", Panel.childPanel7, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(TargetPlayerBuffSizeSlider)
    else
        TargetPlayerBuffSizeSlider.textLow = _G["TargetPlayerBuffSizeSliderLow"]
        TargetPlayerBuffSizeSlider.textHigh = _G["TargetPlayerBuffSizeSliderHigh"]
        TargetPlayerBuffSizeSlider.text = _G["TargetPlayerBuffSizeSliderText"]
    end
    if addon.db.BuffSizer then
        TargetPlayerBuffSizeSlider:Show()
    else
        TargetPlayerBuffSizeSlider:Hide()
    end
    TargetPlayerBuffSizeSlider:SetMinMaxValues(15, 34)
    TargetPlayerBuffSizeSlider.minValue, TargetPlayerBuffSizeSlider.maxValue = TargetPlayerBuffSizeSlider:GetMinMaxValues()
    TargetPlayerBuffSizeSlider.textLow:SetText(TargetPlayerBuffSizeSlider.minValue)
    TargetPlayerBuffSizeSlider.textHigh:SetText(TargetPlayerBuffSizeSlider.maxValue)
    TargetPlayerBuffSizeSlider:SetValue(addon.db.SelfSize)
    TargetPlayerBuffSizeSlider.text:SetText("Auras cast by me: " .. format("%.f", TargetPlayerBuffSizeSlider:GetValue()))
    TargetPlayerBuffSizeSlider:SetValueStep(1)
    TargetPlayerBuffSizeSlider:SetObeyStepOnDrag(true)
    TargetPlayerBuffSizeSlider:SetScript("OnValueChanged", function(_, value)
        if addon.db.SelfSize ~= value then
            addon.db.SelfSize = value
            TargetPlayerBuffSizeSlider.text:SetText("Auras cast by me: " .. RoundNumbers(value, 1))
            addon.RougeUIF:SetCustomBuffSize()
        end
    end)
    AddElement(Panel.childPanel7, TargetPlayerBuffSizeSlider, "slider")

    local TargetBuffSizeSlider = CreateFrame("Slider", "TargetBuffSizeSlider", Panel.childPanel7, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(TargetBuffSizeSlider)
    else
        TargetBuffSizeSlider.textLow = _G["TargetBuffSizeSliderLow"]
        TargetBuffSizeSlider.textHigh = _G["TargetBuffSizeSliderHigh"]
        TargetBuffSizeSlider.text = _G["TargetBuffSizeSliderText"]
    end
    if addon.db.BuffSizer then
        TargetBuffSizeSlider:Show()
    else
        TargetBuffSizeSlider:Hide()
    end
    TargetBuffSizeSlider:SetMinMaxValues(15, 34)
    TargetBuffSizeSlider:SetValueStep(1)
    TargetBuffSizeSlider.minValue, TargetBuffSizeSlider.maxValue = TargetBuffSizeSlider:GetMinMaxValues()
    TargetBuffSizeSlider.textLow:SetText(floor(TargetBuffSizeSlider.minValue))
    TargetBuffSizeSlider.textHigh:SetText(floor(TargetBuffSizeSlider.maxValue))
    TargetBuffSizeSlider:SetValue(addon.db.OtherBuffSize)
    TargetBuffSizeSlider.text:SetText("Auras cast by others: " .. format("%.f", TargetBuffSizeSlider:GetValue()))
    TargetBuffSizeSlider:SetObeyStepOnDrag(true)
    TargetBuffSizeSlider:SetScript("OnValueChanged", function(_, value)
        if addon.db.OtherBuffSize ~= value then
            addon.db.OtherBuffSize = value
            TargetBuffSizeSlider.text:SetText("Auras cast by others: " .. RoundNumbers(value, 1))
            addon.RougeUIF:SetCustomBuffSize()
        end
    end)
    AddElement(Panel.childPanel7, TargetBuffSizeSlider, "slider")

    local AuraRowSlider = CreateFrame("Slider", "AuraRowSlider", Panel.childPanel7, sliderTemplate)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        CreateSliderText(AuraRowSlider)
    else
        AuraRowSlider.textLow = _G["AuraRowSliderLow"]
        AuraRowSlider.textHigh = _G["AuraRowSliderHigh"]
        AuraRowSlider.text = _G["AuraRowSliderText"]
    end
    if addon.db.BuffSizer then
        AuraRowSlider:Show()
    else
        AuraRowSlider:Hide()
    end
    AuraRowSlider:SetMinMaxValues(108, 200)
    AuraRowSlider:SetValueStep(1)
    AuraRowSlider.minValue, AuraRowSlider.maxValue = AuraRowSlider:GetMinMaxValues()
    AuraRowSlider.textLow:SetText(floor(AuraRowSlider.minValue))
    AuraRowSlider.textHigh:SetText(floor(AuraRowSlider.maxValue))
    AuraRowSlider:SetValue(addon.db.AuraRow)
    AuraRowSlider.text:SetText("Auras per row (width size): " .. format("%.f", AuraRowSlider:GetValue()))
    AuraRowSlider:SetObeyStepOnDrag(true)
    AuraRowSlider:SetScript("OnValueChanged", function(_, value)
        if addon.db.AuraRow ~= value then
            addon.db.AuraRow = value
            AuraRowSlider.text:SetText("Auras per row (width size): " .. RoundNumbers(value, 1))
            addon.RougeUIF:SetCustomBuffSize()
        end
    end)
    AddElement(Panel.childPanel7, AuraRowSlider, "slider")

    SLASH_RUI1 = "/rui"
    function SlashCmdList.RUI()
        Settings.OpenToCategory(Panel.categoryID)
    end

    return Panel
end