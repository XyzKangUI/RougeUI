local Name, addon = ...
local floor, format, tinsert = math.floor, string.format, table.insert
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
addon.RougeUIF = addon.RougeUIF or {}

local function RoundNumbers(val, valStep)
    if not valStep or valStep == 0 then return val end
    return floor(val / valStep + 0.5) * valStep
end

local function AutoSetPoints(elements, startX, startY, ySpacing)
    local currentY = startY
    for i, element in ipairs(elements) do
        if element and type(element.SetPoint) == "function" then
            element:ClearAllPoints()
            element:SetPoint("TOPLEFT", startX, currentY)
            currentY = currentY - ySpacing
        end
    end
    return currentY
end

local stock = {
    Class_Portrait = false,
    ClassHP = true,
    GradientHP = false,
    ShortNumeric = true,
    ManaFontSize = 14,
    HPFontSize = 14,
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
    classoutline = false,
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
    AuraRow = 122,
    BuffAlpha = false,
    ButtonAnim = false,
    BuffSizer = true,
    GoldElite = false,
    RareElite = false,
    Rare = false,
    Lorti = false,
    Roug = false,
    Modern = false,
    BuffsRow = 8,
    BuffVal = 1.0,
    cfix = false,
    transparent = true,
    NoLevel = false,
    KeyEcho = false,
    ClassNames = false,
    RangeIndicator = false,
    EnergyTicker = false,
    wahksfk = false,
    EnemyTicker = false,
    modtheme = false,
    OmniCC = false,
    AsuriFrame = false,
    HideGlows = false,
    HideMacro = false,
    ToTDebuffs = false,
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
            if type(RougeUI[i]) ~= "table" then RougeUI[i] = {} end
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

    if addon.RougeUIF and addon.RougeUIF.CusFonts then
        addon.RougeUIF:CusFonts()
    end

    if not f.options then
        f.options = f:CreateGUI()
    end

    f:UnregisterEvent("ADDON_LOADED")
end

function f:PLAYER_LOGOUT()
    RougeUI = addon.db
end

local function CheckBtn(idName, title, desc, panel, onClick)
    local frame = CreateFrame("CheckButton", "$parent"..idName, panel, "InterfaceOptionsCheckButtonTemplate")
    frame:SetScript("OnClick", function(self)
        local enabled = self:GetChecked()
        onClick(self, enabled and true or false)
    end)
    _G[frame:GetName() .. "Text"]:SetText(title)
    frame.tooltipText = desc
    return frame
end

local function CreateText(idName, panel, text)
    local textstring = panel:CreateFontString("$parent"..idName, "ARTWORK", "GameFontNormal")
    textstring:SetFont("Fonts\\MORPHEUS.ttf", 14, "")
    textstring:SetText(text)
    textstring:SetJustifyH("LEFT")
    textstring:SetVertexColor(0.99, 0.82, 0)
    return textstring
end

local function CreateSlider(idName, panel, labelText, minVal, maxVal, stepVal, dbValue, onValueChangedCallback)
    local slider = CreateFrame("Slider", "$parent"..idName, panel, "OptionsSliderTemplate")
    local textWidget = _G[slider:GetName() .. "Text"]
    local highWidget = _G[slider:GetName() .. "High"]
    local lowWidget = _G[slider:GetName() .. "Low"]

    textWidget:SetText(labelText .. format(stepVal % 1 == 0 and "%.0f" or "%.2f", dbValue))
    lowWidget:SetText(minVal)
    highWidget:SetText(maxVal)

    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(stepVal)
    slider:SetValue(dbValue)

    slider:SetScript("OnValueChanged", function(self, value)
        local roundedValue = RoundNumbers(value, self:GetValueStep())
        if self:GetValue() ~= roundedValue then
            self:SetValue(roundedValue)
        end
        textWidget:SetText(labelText .. format(stepVal % 1 == 0 and "%.0f" or "%.2f", roundedValue))
        onValueChangedCallback(self, roundedValue)
    end)
    return slider
end


function f:CreateGUI()
    local Panel = CreateFrame("Frame", "$parentRougeUI_Config", InterfaceOptionsPanelContainer)
    Panel.name = "|cff009cffRougeUI|r"

    local category
    if Settings then
        category = Settings.RegisterCanvasLayoutCategory(Panel, Panel.name)
        Settings.RegisterAddOnCategory(category)
    else
        InterfaceOptions_AddCategory(Panel)
    end

    local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 12, -15)
    title:SetText(Panel.name)

    local Filler = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Filler:SetPoint("TOP", 0, -50)
    Filler:SetText("Welcome to RougeUI")

    local subPanels = {
        {id = "UnitFrame", name = "UnitFrame"},
        {id = "Tweaks", name = "Tweaks"},
        {id = "Hide", name = "Hide Elements"},
        {id = "StatusBar", name = "StatusBar"},
        {id = "Theme", name = "Theme"},
    }

    for i, panelInfo in ipairs(subPanels) do
        local childPanel = CreateFrame("Frame", "$parentConfigChild_"..panelInfo.id, Panel)
        childPanel.name = panelInfo.name
        childPanel.parent = Panel.name
        Panel["childPanel"..i] = childPanel

        if Settings then
            local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, childPanel, panelInfo.name)
            Settings.RegisterAddOnCategory(subcategory)
        else
            InterfaceOptions_AddCategory(childPanel)
        end

        local Reload = CreateFrame("Button", "$parentReloadButton"..i, childPanel, "UIPanelButtonTemplate")
        Reload:SetPoint("BOTTOMRIGHT", -10, 10)
        Reload:SetWidth(100)
        Reload:SetHeight(25)
        Reload:SetText("Save & Reload")
        Reload:SetScript("OnClick", function() ReloadUI() end)
    end

    local xPos = 15
    local xPos2 = 350
    local startY = -40
    local spacingY = 35

    do
        local panel = Panel.childPanel1
        local col1Elements, col2Elements = {}, {}

        tinsert(col1Elements, CreateText("UF_HeaderClassColor", panel, "Class Colored Indicators"))

        local ClassPortraitButton = CheckBtn("UF_ClassPortrait", "Enable Class Portraits", "Turn this on to display class portrait on target and focus frame", panel, function(self, value) addon.db.Class_Portrait = value end)
        ClassPortraitButton:SetChecked(addon.db.Class_Portrait)
        tinsert(col1Elements, ClassPortraitButton)

        local ClassOutlines = CheckBtn("UF_ClassOutlines", "Class Colored Outlines", "When enabled it will add a class colored circle around target and focus frame portraits", panel, function(self, value) addon.db.classoutline = value end)
        ClassOutlines:SetChecked(addon.db.classoutline)
        tinsert(col1Elements, ClassOutlines)

        local ClassBG_CB, Transparent_CB
        ClassBG_CB = CheckBtn("UF_ClassBG", "Class Colored Name Background", "Adds a class colored texture behind the UnitFrame name", panel, function(self, value)
            if addon.db.ThickFrames then
                UIErrorsFrame:AddMessage("This cannot be enabled with big frames", 1, 0, 0)
                self:SetChecked(false)
            else
                addon.db.ClassBG = value
                if Transparent_CB then Transparent_CB:SetChecked(false) end
                addon.db.transparent = false
                addon.db.AsuriFrame = false
                if addon.db.ClassBG and IsAddOnLoaded("Leatrix_Plus") and _G["LeaPlusDB"] and _G["LeaPlusDB"]["ClassColFrames"] == "On" then
                    UIErrorsFrame:AddMessage("Don't forget to disable Class colored frames in Leatrix Plus", 1, 0, 0)
                end
            end
        end)
        ClassBG_CB:SetChecked(addon.db.ClassBG)
        tinsert(col1Elements, ClassBG_CB)

        local ClassCNames = CheckBtn("UF_ClassNames", "Class Colored Names", "Color names to their class color", panel, function(self, value) addon.db.ClassNames = value end)
        ClassCNames:SetChecked(addon.db.ClassNames)
        tinsert(col1Elements, ClassCNames)

        tinsert(col1Elements, CreateText("UF_HeaderStatusText", panel, "StatusText"))

        local ShortNumericButton_CB, AbbButton_CB
        ShortNumericButton_CB = CheckBtn("UF_ShortNumeric", "Display HP/Mana Text as '10k'", "Enabling this will shorten health/mana text values to one decimal", panel, function(self, value)
            addon.db.ShortNumeric = value
            addon.db.Abbreviate = false
            if AbbButton_CB then AbbButton_CB:SetChecked(false) end
        end)
        ShortNumericButton_CB:SetChecked(addon.db.ShortNumeric)
        tinsert(col1Elements, ShortNumericButton_CB)

        AbbButton_CB = CheckBtn("UF_Abbreviate", "Display only CURRENT HP/Mana Text", "This will show the HP/Mana StatusText as CURRENT value instead of CURRENT / MAX", panel, function(self, value)
            addon.db.Abbreviate = value
            addon.db.ShortNumeric = false
            if ShortNumericButton_CB then ShortNumericButton_CB:SetChecked(false) end
        end)
        AbbButton_CB:SetChecked(addon.db.Abbreviate)
        tinsert(col1Elements, AbbButton_CB)

        AutoSetPoints(col1Elements, xPos, startY, spacingY)

        local hpFontSizeSlider = CreateSlider("UF_HPFontSizeSlider", panel, "HP Font Size: ", 8, 16, 1, addon.db.HPFontSize, function(self, value)
            addon.db.HPFontSize = value
            if addon.RougeUIF and addon.RougeUIF.CusFonts then addon.RougeUIF:CusFonts() end
        end)
        hpFontSizeSlider:SetPoint("TOPLEFT", 20, -410)

        local manaFontSizeSlider = CreateSlider("UF_ManaFontSizeSlider", panel, "Mana Font Size: ", 8, 16, 1, addon.db.ManaFontSize, function(self, value)
            addon.db.ManaFontSize = value
            if addon.RougeUIF and addon.RougeUIF.CusFonts then addon.RougeUIF:CusFonts() end
        end)
        manaFontSizeSlider:SetPoint("TOPLEFT", 20, -470)

        tinsert(col2Elements, CreateText("UF_HeaderMisc", panel, "Misc"))

        local FadeIconButton = CheckBtn("UF_FadeIcon", "Fade out PvP Icon", "Enabling this will set the PvP Icon's transparency at 35%", panel, function(self, value) addon.db.FadeIcon = value end)
        FadeIconButton:SetChecked(addon.db.FadeIcon)
        tinsert(col2Elements, FadeIconButton)

        local ThickFrame_CB = CheckBtn("UF_ThickFrames", "Enable Big Frames", "Enable this for big (thick) UnitFrames", panel, function(self, value)
            addon.db.ThickFrames = value
            if addon.db.ThickFrames then
                addon.db.ClassBG = false
                if ClassBG_CB then ClassBG_CB:SetChecked(false) end
                if IsAddOnLoaded("Leatrix_Plus") and _G["LeaPlusDB"] and _G["LeaPlusDB"]["ClassColFrames"] == "On" then
                    UIErrorsFrame:AddMessage("Don't forget to disable Class colored frames in Leatrix Plus", 1, 0, 0)
                end
            end
        end)
        ThickFrame_CB:SetChecked(addon.db.ThickFrames)
        tinsert(col2Elements, ThickFrame_CB)

        Transparent_CB = CheckBtn("UF_TransparentBG", "Transparent name background", nil, panel, function(self, value)
            addon.db.transparent = value
            if value then
                addon.db.ClassBG = false
                if ClassBG_CB then ClassBG_CB:SetChecked(false) end
            end
        end)
        Transparent_CB:SetChecked(addon.db.transparent)
        tinsert(col2Elements, Transparent_CB)

        local Nolvl = CheckBtn("UF_NoLevel", "Hide level text on frames", nil, panel, function(self, value) addon.db.NoLevel = value end)
        Nolvl:SetChecked(addon.db.NoLevel)
        tinsert(col2Elements, Nolvl)

        tinsert(col2Elements, CreateText("UF_HeaderPlayerChain", panel, "Player Chain Artwork"))

        local EliteChain_CB, RareChain_CB, RareElite_CB
        EliteChain_CB = CheckBtn("UF_GoldElite", "Gold Elite PlayerFrame", "Show a `Gold Elite` artwork on PlayerFrame", panel, function(self, value)
            addon.db.GoldElite = value; addon.db.Rare = false; addon.db.RareElite = false
            if RareChain_CB then RareChain_CB:SetChecked(false) end
            if RareElite_CB then RareElite_CB:SetChecked(false) end
        end)
        EliteChain_CB:SetChecked(addon.db.GoldElite)
        tinsert(col2Elements, EliteChain_CB)

        RareChain_CB = CheckBtn("UF_Rare", "Rare PlayerFrame", "Show a `Rare` artwork on PlayerFrame", panel, function(self, value)
            addon.db.Rare = value; addon.db.GoldElite = false; addon.db.RareElite = false
            if EliteChain_CB then EliteChain_CB:SetChecked(false) end
            if RareElite_CB then RareElite_CB:SetChecked(false) end
        end)
        RareChain_CB:SetChecked(addon.db.Rare)
        tinsert(col2Elements, RareChain_CB)

        RareElite_CB = CheckBtn("UF_RareElite", "Rare Elite PlayerFrame", "Show a `Rare Elite` artwork on PlayerFrame", panel, function(self, value)
            addon.db.RareElite = value; addon.db.Rare = false; addon.db.GoldElite = false
            if EliteChain_CB then EliteChain_CB:SetChecked(false) end
            if RareChain_CB then RareChain_CB:SetChecked(false) end
        end)
        RareElite_CB:SetChecked(addon.db.RareElite)
        tinsert(col2Elements, RareElite_CB)

        AutoSetPoints(col2Elements, xPos2, startY, spacingY)
    end

    do
        local panel = Panel.childPanel2
        local col1Elements, col2Elements = {}, {}

        tinsert(col1Elements, CreateText("TW_HeaderPvP", panel, "PvP Tweaks"))

        local CombatIndicatorButton = CheckBtn("TW_CombatIndicator", "Combat Indicator", "Displays a Combat icon next to Target-/FocusFrame", panel, function(self, value) addon.db.CombatIndicator = value end)
        CombatIndicatorButton:SetChecked(addon.db.CombatIndicator)
        tinsert(col1Elements, CombatIndicatorButton)

        local ScoreBoardButton = CheckBtn("TW_ScoreBoard", "Class colored PvP Scoreboard", "Color names on the PvP Scoreboard by class", panel, function(self, value) addon.db.ScoreBoard = value end)
        ScoreBoardButton:SetChecked(addon.db.ScoreBoard)
        tinsert(col1Elements, ScoreBoardButton)

        local EnemyTicksButton = CheckBtn("TW_EnemyTicks", "Out of Combat Timer", "Track when your target/focus will leave combat", panel, function(self, value) addon.db.EnemyTicks = value end)
        EnemyTicksButton:SetChecked(addon.db.EnemyTicks)
        tinsert(col1Elements, EnemyTicksButton)

        local ArenaNumbersButton = CheckBtn("TW_ArenaNumbers", "Show arena number on nameplate", "When in Arena show 'arena1-5' on enemy nameplates", panel, function(self, value) addon.db.ArenaNumbers = value end)
        ArenaNumbersButton:SetChecked(addon.db.ArenaNumbers)
        tinsert(col1Elements, ArenaNumbersButton)

        tinsert(col1Elements, CreateText("TW_HeaderAuras", panel, "Buffs/Debuffs"))

        local HighlightDispellable = CheckBtn("TW_HighlightDispellable", "Highlight important Magic/Enrage buffs", "Highlights non-trash magic and enrage effects", panel, function(self, value)
            addon.db.HighlightDispellable = value
        end)
        HighlightDispellable:SetChecked(addon.db.HighlightDispellable)
        tinsert(col1Elements, HighlightDispellable)

        local TimerButton = CheckBtn("TW_TimerGap", "Remove space indentation from buffs", "'1s' instead of '1 s'", panel, function(self, value) addon.db.TimerGap = value end)
        TimerButton:SetChecked(addon.db.TimerGap)
        tinsert(col1Elements, TimerButton)

        local BuffAlphaButton = CheckBtn("TW_BuffAlpha", "Disable BuffFrame fading animation", "Disable pulsing effect on buffs/debuffs", panel, function(self, value) addon.db.BuffAlpha = value end)
        BuffAlphaButton:SetChecked(addon.db.BuffAlpha)
        tinsert(col1Elements, BuffAlphaButton)

        local currentY_Col1_Auto = AutoSetPoints(col1Elements, xPos, startY, spacingY)

        local TargetBuffSizeSlider_S, TargetPlayerBuffSizeSlider_S, AuraRowSlider_S

        local BuffSizerButton = CheckBtn("TW_BuffSizer", "Enable Buff Resizing", "Enables Target/Focus Frame Buff/Debuff scale sliders", panel, function(self, value)
            addon.db.BuffSizer = value
            if addon.RougeUIF and addon.RougeUIF.HookAuras then addon.RougeUIF:HookAuras() end
            if value then
                if TargetBuffSizeSlider_S then TargetBuffSizeSlider_S:Show() end
                if TargetPlayerBuffSizeSlider_S then TargetPlayerBuffSizeSlider_S:Show() end
                if AuraRowSlider_S then AuraRowSlider_S:Show() end
            else
                if TargetBuffSizeSlider_S then TargetBuffSizeSlider_S:Hide() end
                if TargetPlayerBuffSizeSlider_S then TargetPlayerBuffSizeSlider_S:Hide() end
                if AuraRowSlider_S then AuraRowSlider_S:Hide() end
            end
        end)
        BuffSizerButton:SetChecked(addon.db.BuffSizer)
        BuffSizerButton:SetPoint("TOPLEFT", xPos, currentY_Col1_Auto)

        TargetBuffSizeSlider_S = CreateSlider("TW_TargetBuffSizeSlider", panel, "Target Aura Size: ", 15, 34, 1, addon.db.OtherBuffSize, function(self, value)
            addon.db.OtherBuffSize = value
            if addon.RougeUIF and addon.RougeUIF.SetCustomBuffSize then addon.RougeUIF:SetCustomBuffSize() end
        end)
        TargetBuffSizeSlider_S:SetPoint("TOPLEFT", 20, -440)

        TargetPlayerBuffSizeSlider_S = CreateSlider("TW_PlayerBuffSizeSlider", panel, "Personal Aura Size: ", 15, 34, 1, addon.db.SelfSize, function(self, value)
            addon.db.SelfSize = value
            if addon.RougeUIF and addon.RougeUIF.SetCustomBuffSize then addon.RougeUIF:SetCustomBuffSize() end
        end)
        TargetPlayerBuffSizeSlider_S:SetPoint("TOPLEFT", 20, -490)

        AuraRowSlider_S = CreateSlider("TW_AuraRowSlider", panel, "Aura Row Width: ", 108, 200, 14, addon.db.AuraRow, function(self, value)
            addon.db.AuraRow = value
            if addon.RougeUIF and addon.RougeUIF.SetCustomBuffSize then addon.RougeUIF:SetCustomBuffSize() end
        end)
        AuraRowSlider_S:SetPoint("TOPLEFT", 20, -540)

        if addon.db.BuffSizer then
            TargetBuffSizeSlider_S:Show(); TargetPlayerBuffSizeSlider_S:Show(); AuraRowSlider_S:Show()
        else
            TargetBuffSizeSlider_S:Hide(); TargetPlayerBuffSizeSlider_S:Hide(); AuraRowSlider_S:Hide()
        end

        tinsert(col2Elements, CreateText("TW_HeaderMisc", panel, "Misc"))

        local AutoReadyButton = CheckBtn("TW_AutoReady", "Auto accept raid ready check", "Automatically accepts readychecks. Warning: Don't AFK!", panel, function(self, value) addon.db.AutoReady = value end)
        AutoReadyButton:SetChecked(addon.db.AutoReady)
        tinsert(col2Elements, AutoReadyButton)

        local RangeIndicator = CheckBtn("TW_RangeIndicator", "Actionbar Range Indicator", "Color actionbuttons when out of range or oom", panel, function(self, value) addon.db.RangeIndicator = value end)
        RangeIndicator:SetChecked(addon.db.RangeIndicator)
        tinsert(col2Elements, RangeIndicator)

        local ButtonAnim = CheckBtn("TW_ButtonAnim", "Animated Keypress (SnowFallKeyPress)", "Works with Default/Dominos/Bartender4", panel, function(self, value) addon.db.ButtonAnim = value end)
        ButtonAnim:SetChecked(addon.db.ButtonAnim)
        tinsert(col2Elements, ButtonAnim)

        local KeyEcho = CheckBtn("TW_KeyEcho", "WannabeAHK", "Doubles keypresses - Works with Default/Dominos/Bartender4", panel, function(self, value) addon.db.KeyEcho = value end)
        KeyEcho:SetChecked(addon.db.KeyEcho)
        tinsert(col2Elements, KeyEcho)

        local Retab = CheckBtn("TW_Retab", "RETabBinder", "Changes TAB to target enemy players in arena/BG", panel, function(self, value) addon.db.retab = value end)
        Retab:SetChecked(addon.db.retab)
        tinsert(col2Elements, Retab)

        tinsert(col2Elements, CreateText("TW_HeaderRogue", panel, "Rogue Specific"))

        local ComboFixButton = CheckBtn("TW_ComboFix", "ComboFrame Fix", "See combo points on mind controlled enemy players", panel, function(self, value) addon.db.cfix = value end)
        ComboFixButton:SetChecked(addon.db.cfix)
        tinsert(col2Elements, ComboFixButton)

        AutoSetPoints(col2Elements, xPos2, startY, spacingY)
    end

    do
        local panel = Panel.childPanel3
        local col1Elements = {}

        local HideGlowsButton = CheckBtn("HE_HideGlows", "Hide glowing effects on PlayerFrame", "Hides yellow/red glowing on PlayerFrame", panel, function(self, value) addon.db.HideGlows = value end)
        HideGlowsButton:SetChecked(addon.db.HideGlows or false)
        tinsert(col1Elements, HideGlowsButton)

        local HideIndicatorButton = CheckBtn("HE_HideCombatText", "Hide Combat Text on Portrait", "Hides player/pet combat text on portraits", panel, function(self, value) addon.db.HideIndicator = value end)
        HideIndicatorButton:SetChecked(addon.db.HideIndicator)
        tinsert(col1Elements, HideIndicatorButton)

        local HideTitlesButton = CheckBtn("HE_HideGroupText", "Hide Group/Raid text", "Hides Group/Raid text on top of frames", panel, function(self, value) addon.db.HideTitles = value end)
        HideTitlesButton:SetChecked(addon.db.HideTitles)
        tinsert(col1Elements, HideTitlesButton)

        local HideStanceButton = CheckBtn("HE_HideStance", "Hide StanceBar", "Hides extra buttons like Cat Form, Stealth", panel, function(self, value) addon.db.Stance = value end)
        HideStanceButton:SetChecked(addon.db.Stance)
        tinsert(col1Elements, HideStanceButton)

        local HideHotkeyButton = CheckBtn("HE_HideHotkey", "Hide Hotkey text on default actionbar", "Hides keybinding text", panel, function(self, value) addon.db.HideHotkey = value end)
        HideHotkeyButton:SetChecked(addon.db.HideHotkey)
        tinsert(col1Elements, HideHotkeyButton)

        local HideMacroButton = CheckBtn("HE_HideMacro", "Hide macro text on default actionbar", "Hides macro name on icons", panel, function(self, value) addon.db.HideMacro = value end)
        HideMacroButton:SetChecked(addon.db.HideMacro or false)
        tinsert(col1Elements, HideMacroButton)

        local HideTotDebuffs = CheckBtn("HE_HideToTDebuffs", "Hide TargetOfTarget Debuffs", "Hides the 4 small ToT Debuffs", panel, function(self, value) addon.db.ToTDebuffs = value end)
        HideTotDebuffs:SetChecked(addon.db.ToTDebuffs or false)
        tinsert(col1Elements, HideTotDebuffs)

        AutoSetPoints(col1Elements, xPos, startY, spacingY)
    end

    do
        local panel = Panel.childPanel4
        local col1Elements = {}

        local PimpFrameButton = CheckBtn("SB_PimpMana", "Purple Manabar", "Pimps your manabar to a purple color", panel, function(self, value) addon.db.pimp = value end)
        PimpFrameButton:SetChecked(addon.db.pimp)
        tinsert(col1Elements, PimpFrameButton)

        local ClassHPButton_CB, GradientHPButton_CB, UnitHPButton_CB
        ClassHPButton_CB = CheckBtn("SB_ClassHP", "Enable Class Colored HealthBar", "Changes healthBar to class color", panel, function(self, value)
            addon.db.ClassHP = value
            if value then
                addon.db.GradientHP = false; if GradientHPButton_CB then GradientHPButton_CB:SetChecked(false) end
                addon.db.unithp = false; if UnitHPButton_CB then UnitHPButton_CB:SetChecked(false) end
            end
        end)
        ClassHPButton_CB:SetChecked(addon.db.ClassHP)
        tinsert(col1Elements, ClassHPButton_CB)

        GradientHPButton_CB = CheckBtn("SB_GradientHP", "Enable Gradient HealthBar", "Green > yellow > orange > red based on %", panel, function(self, value)
            addon.db.GradientHP = value
            if value then
                addon.db.ClassHP = false; if ClassHPButton_CB then ClassHPButton_CB:SetChecked(false) end
                addon.db.unithp = false; if UnitHPButton_CB then UnitHPButton_CB:SetChecked(false) end
            end
        end)
        GradientHPButton_CB:SetChecked(addon.db.GradientHP)
        tinsert(col1Elements, GradientHPButton_CB)

        UnitHPButton_CB = CheckBtn("SB_UnitReactionHP", "Color HealthBar by Unit's Reaction", "Red (hostile), green (friendly), yellow (neutral)", panel, function(self, value)
            addon.db.unithp = value
            if value then
                addon.db.ClassHP = false; if ClassHPButton_CB then ClassHPButton_CB:SetChecked(false) end
                addon.db.GradientHP = false; if GradientHPButton_CB then GradientHPButton_CB:SetChecked(false) end
            end
        end)
        UnitHPButton_CB:SetChecked(addon.db.unithp)
        tinsert(col1Elements, UnitHPButton_CB)

        local SmoothFrameButton = CheckBtn("SB_SmoothHPMP", "Smooth Animated Health & Mana Bar", "Smoother transition on gain/loss", panel, function(self, value) addon.db.smooth = value end)
        SmoothFrameButton:SetChecked(addon.db.smooth)
        tinsert(col1Elements, SmoothFrameButton)

        AutoSetPoints(col1Elements, xPos, startY, spacingY)
    end

    do
        local panel = Panel.childPanel5
        local col1Elements, col2Elements = {}, {}
        local BuffColSlider_S

        local CastTimerButton = CheckBtn("TH_CastTimer", "Customized Castbar", "Styles Target/Focus castbar and adds timer", panel, function(self, value) addon.db.CastTimer = value end)
        CastTimerButton:SetChecked(addon.db.CastTimer)
        tinsert(col1Elements, CastTimerButton)

        local ModPlates = CheckBtn("TH_ModPlates", "Change Nameplate Style", "Slightly alter original nameplate style", panel, function(self, value) addon.db.ModPlates = value end)
        ModPlates:SetChecked(addon.db.ModPlates)
        tinsert(col1Elements, ModPlates)

        local OmniTimers = CheckBtn("TH_OmniCC", "OmniCC Buff Timers", "Use OmniCC instead of Blizzard buff timers", panel, function(self, value)
            if not IsAddOnLoaded("OmniCC") then
                UIErrorsFrame:AddMessage("To enable this option you have to enable OmniCC first", 1, 0, 0)
                self:SetChecked(false)
                addon.db.OmniCC = false
                return
            end
            addon.db.OmniCC = value
        end)
        OmniTimers:SetChecked(addon.db.OmniCC)
        tinsert(col1Elements, OmniTimers)

        AutoSetPoints(col1Elements, xPos, startY, spacingY)

        local buffValueSlider = CreateSlider("TH_buffValueSlider", panel, "Buffs per row: ", 1, 10, 1, addon.db.BuffsRow, function(self, value)
            addon.db.BuffsRow = value
        end)
        buffValueSlider:SetPoint("TOPLEFT", 25, -160)

        local ColorValueSlider = CreateSlider("TH_ColorValueSlider", panel, "UI Brightness: ", 0, 1, 0.05, addon.db.Colval, function(self, value)
            addon.db.Colval = value
            if addon.RougeUIF and addon.RougeUIF.ChangeFrameColors then addon.RougeUIF:ChangeFrameColors() end
        end)
        ColorValueSlider:SetPoint("TOPLEFT", 25, -230)

        BuffColSlider_S = CreateSlider("TH_BuffColSlider", panel, "Theme Border Brightness: ", 0, 1, 0.05, addon.db.BuffVal, function(self, value)
            addon.db.BuffVal = value
        end)
        BuffColSlider_S:SetPoint("TOPLEFT", 25, -300)
        if not (addon.db.Modern or addon.db.modtheme) then BuffColSlider_S:Hide() else BuffColSlider_S:Show() end

        tinsert(col2Elements, CreateText("TH_HeaderThemes", panel, "Themes"))

        local LortiTheme_CB, RougTheme_CB, ModernTheme_CB, Modtheme_CB
        RougTheme_CB = CheckBtn("TH_RougTheme", "RougeUI Theme", nil, panel, function(self, value)
            addon.db.Roug = value; addon.db.Lorti = false; addon.db.Modern = false; addon.db.modtheme = false
            if LortiTheme_CB then LortiTheme_CB:SetChecked(false) end
            if ModernTheme_CB then ModernTheme_CB:SetChecked(false) end
            if Modtheme_CB then Modtheme_CB:SetChecked(false) end
            if BuffColSlider_S then BuffColSlider_S:Hide() end
        end)
        RougTheme_CB:SetChecked(addon.db.Roug)
        tinsert(col2Elements, RougTheme_CB)

        LortiTheme_CB = CheckBtn("TH_LortiTheme", "Lorti Theme", "Themes UI to look like Lorti", panel, function(self, value)
            addon.db.Lorti = value; addon.db.Roug = false; addon.db.Modern = false; addon.db.modtheme = false
            if RougTheme_CB then RougTheme_CB:SetChecked(false) end
            if ModernTheme_CB then ModernTheme_CB:SetChecked(false) end
            if Modtheme_CB then Modtheme_CB:SetChecked(false) end
            if BuffColSlider_S then BuffColSlider_S:Hide() end
        end)
        LortiTheme_CB:SetChecked(addon.db.Lorti)
        tinsert(col2Elements, LortiTheme_CB)

        ModernTheme_CB = CheckBtn("TH_ModernTheme", "Minimalist Theme", nil, panel, function(self, value)
            addon.db.Modern = value; addon.db.Lorti = false; addon.db.Roug = false; addon.db.modtheme = false
            if LortiTheme_CB then LortiTheme_CB:SetChecked(false) end
            if RougTheme_CB then RougTheme_CB:SetChecked(false) end
            if Modtheme_CB then Modtheme_CB:SetChecked(false) end
            if BuffColSlider_S then BuffColSlider_S:Show() end
        end)
        ModernTheme_CB:SetChecked(addon.db.Modern)
        tinsert(col2Elements, ModernTheme_CB)

        Modtheme_CB = CheckBtn("TH_ModTheme", "ModUI Theme", nil, panel, function(self, value)
            addon.db.modtheme = value; addon.db.Lorti = false; addon.db.Roug = false; addon.db.Modern = false
            if LortiTheme_CB then LortiTheme_CB:SetChecked(false) end
            if RougTheme_CB then RougTheme_CB:SetChecked(false) end
            if ModernTheme_CB then ModernTheme_CB:SetChecked(false) end
            if BuffColSlider_S then BuffColSlider_S:Show() end
        end)
        Modtheme_CB:SetChecked(addon.db.modtheme)
        tinsert(col2Elements, Modtheme_CB)

        local AsuriFrame_CB = CheckBtn("TH_AsuriFrame", "Asuri UI Frames", nil, panel, function(self, value)
            addon.db.AsuriFrame = value
            if value then
                addon.db.ThickFrames = false;
                addon.db.ClassBG = false;
                addon.db.transparent = false;
                addon.db.NoLevel = false;
                addon.db.ModPlates = false;
            end
        end)
        AsuriFrame_CB:SetChecked(addon.db.AsuriFrame)
        tinsert(col2Elements, AsuriFrame_CB)

        AutoSetPoints(col2Elements, xPos2, startY, spacingY)
    end

    return Panel
end
