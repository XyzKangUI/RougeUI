local Name, ns = ...;
local Title = select(2,GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$","");

RougeUI = { Class_Portrait, ClassHP, GradientHP, FastKeyPress, ShortNumeric, FontSize, SelfSize, OtherBuffSize, HighlightDispellable, TimerGap, ScoreBoard, HideTitles,
		FadeIcon, EnergyTicker, CombatIndicator, CastTimer, smooth, pimp, retab }

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
function f:ADDON_LOADED()
    if RougeUI.Class_Portrait == nil then RougeUI.Class_Portrait = false; end
    if RougeUI.ClassHP == nil then RougeUI.ClassHP = false; end
    if RougeUI.GradientHP == nil then RougeUI.GradientHP = false; end
    if RougeUI.FastKeyPress == nil then RougeUI.FastKeyPress = false; end
    if RougeUI.ShortNumeric == nil then RougeUI.ShortNumeric = false; end
    if RougeUI.FontSize == nil then RougeUI.FontSize = 11; end
    if RougeUI.SelfSize == nil then RougeUI.SelfSize = 27; end
    if RougeUI.OtherBuffSize == nil then RougeUI.OtherBuffSize = 23; end
    if RougeUI.HighlightDispellable == nil then RougeUI.HighlightDispellable = false; end
    if RougeUI.TimerGap == nil then RougeUI.TimerGap = false; end
    if RougeUI.ScoreBoard == nil then RougeUI.ScoreBoard = false; end
    if RougeUI.HideTitles == nil then RougeUI.HideTitles = false; end
    if RougeUI.FadeIcon == nil then RougeUI.FadeIcon = false; end
    if RougeUI.HideGlows == nil then RougeUI.HideGlows = false; end
    if RougeUI.EnergyTicker == nil then RougeUI.EnergyTicker = false; end
    if RougeUI.CombatIndicator == nil then RougeUI.CombatIndicator = false; end
    if RougeUI.CastTimer == nil then RougeUI.CastTimer = false; end
    if RougeUI.smooth == nil then RougeUI.smooth = false; end

    Custom_TargetBuffSize();
    CusFonts();

    if not f.optionsPanel then
        f.optionsPanel = f:CreateGUI()
    end
end

function f:CreateGUI()
    local Panel=CreateFrame("Frame"); do
        Panel.name=Title;
        InterfaceOptions_AddCategory(Panel);--	Panel Registration

        local title=Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
        title:SetPoint("TOPLEFT",12,-15);
        title:SetText(Title);

	local Reload = CreateFrame("Button", nil, Panel, "UIPanelButtonTemplate")
	Reload:SetPoint("BOTTOMRIGHT", -10, 10)
	Reload:SetWidth(100)
	Reload:SetHeight(25)
	Reload:SetText("Save & Reload")
	Reload:SetScript("OnClick", function(self, button, down)
		ReloadUI()
	end)

        local name = "ClassPortraitButton"
        local template = "UICheckButtonTemplate"
        local ClassPortraitButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ClassPortraitButton:SetPoint("TOPLEFT", 10, -60)
        ClassPortraitButton.text = _G[name.."Text"]
	ClassPortraitButton.text:SetText("Enable class portraits")
	ClassPortraitButton:SetChecked(RougeUI.Class_Portrait)
	ClassPortraitButton:SetScript("OnClick", function() RougeUI.Class_Portrait = not RougeUI.Class_Portrait end)

        local name = "ClassHP"
        local template = "UICheckButtonTemplate"
        local ClassHPButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ClassHPButton:SetPoint("TOPLEFT", 10, -100)
        ClassHPButton.text = _G[name.."Text"]
	ClassHPButton.text:SetText("Class Colored HP")
	ClassHPButton:SetChecked(RougeUI.ClassHP)
	ClassHPButton:SetScript("OnClick", function() RougeUI.ClassHP = not RougeUI.ClassHP end)

        local name = "ScoreBoard"
        local template = "UICheckButtonTemplate"
        local ScoreBoardButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ScoreBoardButton:SetPoint("TOPLEFT", 350, -60)
        ScoreBoardButton.text = _G[name.."Text"]
	ScoreBoardButton.text:SetText("Class Colored PvP Scoreboard")
	ScoreBoardButton:SetChecked(RougeUI.ScoreBoard)
	ScoreBoardButton:SetScript("OnClick", function() RougeUI.ScoreBoard = not RougeUI.ScoreBoard end)

        local name = "HideTitles"
        local template = "UICheckButtonTemplate"
        local HideTitlesButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        HideTitlesButton:SetPoint("TOPLEFT", 350, -100)
        HideTitlesButton.text = _G[name.."Text"]
	HideTitlesButton.text:SetText("Hide Group/Raid titles, e.g. Group 1")
	HideTitlesButton:SetChecked(RougeUI.HideTitles)
	HideTitlesButton:SetScript("OnClick", function() RougeUI.HideTitles = not RougeUI.HideTitles end)

        local name = "FadeIcon"
        local template = "UICheckButtonTemplate"
        local FadeIconButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        FadeIconButton:SetPoint("TOPLEFT", 350, -140)
        FadeIconButton.text = _G[name.."Text"]
	FadeIconButton.text:SetText("Fade PvP Icon")
	FadeIconButton:SetChecked(RougeUI.FadeIcon)
	FadeIconButton:SetScript("OnClick", function() RougeUI.FadeIcon = not RougeUI.FadeIcon end)

        local name = "HideGlows"
        local template = "UICheckButtonTemplate"
        local HideGlowsButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        HideGlowsButton:SetPoint("TOPLEFT", 350, -180)
        HideGlowsButton.text = _G[name.."Text"]
	HideGlowsButton.text:SetText("Hide hit indicator + glows on Playerframe")
	HideGlowsButton:SetChecked(RougeUI.HideGlows)
	HideGlowsButton:SetScript("OnClick", function() RougeUI.HideGlows = not RougeUI.HideGlows end)

        local name = "EnergyTicker"
        local template = "UICheckButtonTemplate"
        local EnergyTickerButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        EnergyTickerButton:SetPoint("TOPLEFT", 350, -220)
        EnergyTickerButton.text = _G[name.."Text"]
	EnergyTickerButton.text:SetText("Enable Energy ticker for Rogue/Druid")
	EnergyTickerButton:SetChecked(RougeUI.EnergyTicker)
	EnergyTickerButton:SetScript("OnClick", function() RougeUI.EnergyTicker = not RougeUI.EnergyTicker end)

        local name = "CombatIndicator"
        local template = "UICheckButtonTemplate"
        local CombatIndicatorButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        CombatIndicatorButton:SetPoint("TOPLEFT", 350, -260)
        CombatIndicatorButton.text = _G[name.."Text"]
	CombatIndicatorButton.text:SetText("Enable Combat Indicator")
	CombatIndicatorButton:SetChecked(RougeUI.CombatIndicator)
	CombatIndicatorButton:SetScript("OnClick", function() RougeUI.CombatIndicator = not RougeUI.CombatIndicator end)

        local name = "CastTimer"
        local template = "UICheckButtonTemplate"
        local CastTimerButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        CastTimerButton:SetPoint("TOPLEFT", 350, -300)
        CastTimerButton.text = _G[name.."Text"]
	CastTimerButton.text:SetText("Enable timer on target/focus castbar")
	CastTimerButton:SetChecked(RougeUI.CastTimer)
	CastTimerButton:SetScript("OnClick", function() RougeUI.CastTimer = not RougeUI.CastTimer end)

        local name = "SmoothFrame"
        local template = "UICheckButtonTemplate"
        local SmoothFrameButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        SmoothFrameButton:SetPoint("TOPLEFT", 350, -340)
        SmoothFrameButton.text = _G[name.."Text"]
	SmoothFrameButton.text:SetText("Smooth animated health/mana bars")
	SmoothFrameButton:SetChecked(RougeUI.smooth)
	SmoothFrameButton:SetScript("OnClick", function() RougeUI.smooth = not RougeUI.smooth end)

        local name = "PimpFrame"
        local template = "UICheckButtonTemplate"
        local PimpFrameButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        PimpFrameButton:SetPoint("TOPLEFT", 350, -380)
        PimpFrameButton.text = _G[name.."Text"]
	PimpFrameButton.text:SetText("Enable Violet Colored Energy/Mana Bar")
	PimpFrameButton:SetChecked(RougeUI.pimp)
	PimpFrameButton:SetScript("OnClick", function() RougeUI.pimp = not RougeUI.pimp end)

        local name = "RetabBind"
        local template = "UICheckButtonTemplate"
        local RetabBind = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        RetabBind:SetPoint("TOPLEFT", 350, -420)
        RetabBind.text = _G[name.."Text"]
	RetabBind.text:SetText("RETabBinder")
	RetabBind:SetChecked(RougeUI.retab)
	RetabBind:SetScript("OnClick", function() RougeUI.retab = not RougeUI.retab end)

        local name = "GradientHP"
        local template = "UICheckButtonTemplate"
        local GradientHPButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        GradientHPButton:SetPoint("TOPLEFT", 10, -140)
        GradientHPButton.text = _G[name.."Text"]
	GradientHPButton.text:SetText("Gradient effect on HP")
	GradientHPButton:SetChecked(RougeUI.GradientHP)
	GradientHPButton:SetScript("OnClick", function() RougeUI.GradientHP = not RougeUI.GradientHP end)

        local name = "FastKeyPress"
        local template = "UICheckButtonTemplate"
        local FastKeyPressButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        FastKeyPressButton:SetPoint("TOPLEFT", 10, -180)
        FastKeyPressButton.text = _G[name.."Text"]
	FastKeyPressButton.text:SetText("Cast spells on key down (SnowFallKey)")
	FastKeyPressButton:SetChecked(RougeUI.FastKeyPress)
	FastKeyPressButton:SetScript("OnClick", function() RougeUI.FastKeyPress = not RougeUI.FastKeyPress end)
	FastKeyPressButton:RegisterEvent("PLAYER_ENTERING_WORLD")
	FastKeyPressButton:SetScript("OnEvent", function(self, event, ...)
		if (event == "PLAYER_ENTERING_WORLD") and RougeUI.FastKeyPress == true then 
			SetCVar('ActionButtonUseKeyDown', 1) 
		else
			SetCVar('ActionButtonUseKeyDown', 0)
		end
	end)

        local name = "ShortNumeric"
        local template = "UICheckButtonTemplate"
        local ShortNumericButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ShortNumericButton:SetPoint("TOPLEFT", 10, -220)
        ShortNumericButton.text = _G[name.."Text"]
	ShortNumericButton.text:SetText("Shorten NUMERIC HP to one decimal")
	ShortNumericButton:SetChecked(RougeUI.ShortNumeric)
	ShortNumericButton:SetScript("OnClick", function() RougeUI.ShortNumeric = not RougeUI.ShortNumeric end)

        local name = "HighlightDispellable"
        local template = "UICheckButtonTemplate"
        local HighlightDispellableButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        HighlightDispellableButton:SetPoint("TOPLEFT", 10, -260)
        HighlightDispellableButton.text = _G[name.."Text"]
	HighlightDispellableButton.text:SetText("Highlight enemy Magic buffs")
	HighlightDispellableButton:SetChecked(RougeUI.HighlightDispellable)
	HighlightDispellableButton:SetScript("OnClick", function() RougeUI.HighlightDispellable = not RougeUI.HighlightDispellable end)

        local name = "TimerGap"
        local template = "UICheckButtonTemplate"
        local TimerGapButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        TimerGapButton:SetPoint("TOPLEFT", 10, -300)
        TimerGapButton.text = _G[name.."Text"]
	TimerGapButton.text:SetText("Remove space gap in (de)buff timer")
	TimerGapButton:SetChecked(RougeUI.TimerGap)
	TimerGapButton:SetScript("OnClick", function() RougeUI.TimerGap = not RougeUI.TimerGap end)

        local name = "FontSizeSlider"
        local template = "OptionsSliderTemplate"
        local FontSizeSlider = CreateFrame("Slider", name, Panel, template)
        FontSizeSlider:SetPoint("TOPLEFT",20, -360)
        FontSizeSlider.textLow = _G[name.."Low"]
        FontSizeSlider.textHigh = _G[name.."High"]
        FontSizeSlider.text = _G[name.."Text"]
        FontSizeSlider:SetMinMaxValues(8, 16)
        FontSizeSlider.minValue, FontSizeSlider.maxValue = FontSizeSlider:GetMinMaxValues()
        FontSizeSlider.textLow:SetText(FontSizeSlider.minValue)
        FontSizeSlider.textHigh:SetText(FontSizeSlider.maxValue)
        FontSizeSlider:SetValue(RougeUI.FontSize)
        FontSizeSlider.text:SetText("Healthbar Font Size: "..FontSizeSlider:GetValue(FontSize))
        FontSizeSlider:SetValueStep(1)
        FontSizeSlider:SetObeyStepOnDrag(true);
        FontSizeSlider:SetScript("OnValueChanged", function(self,event,arg1)
            FontSizeSlider.text:SetText("Healthbar Font Size: "..FontSizeSlider:GetValue(RougeUI.FontSize))
            RougeUI.FontSize = FontSizeSlider:GetValue()
            CusFonts()
        end)

       local names = "TargetPlayerBuffSizeSlider"
        local template = "OptionsSliderTemplate"
        local TargetPlayerBuffSizeSlider = CreateFrame("Slider", names, Panel, template)
        TargetPlayerBuffSizeSlider:SetPoint("TOPLEFT", 20, -420)
        TargetPlayerBuffSizeSlider.textLow = _G[names.."Low"]
        TargetPlayerBuffSizeSlider.textHigh = _G[names.."High"]
        TargetPlayerBuffSizeSlider.text = _G[names.."Text"]
        TargetPlayerBuffSizeSlider:SetMinMaxValues(8, 32)
        TargetPlayerBuffSizeSlider.minValue, TargetPlayerBuffSizeSlider.maxValue = TargetPlayerBuffSizeSlider:GetMinMaxValues()
        TargetPlayerBuffSizeSlider.textLow:SetText(TargetPlayerBuffSizeSlider.minValue)
        TargetPlayerBuffSizeSlider.textHigh:SetText(TargetPlayerBuffSizeSlider.maxValue)
	TargetPlayerBuffSizeSlider:SetValue(RougeUI.SelfSize)
	TargetPlayerBuffSizeSlider.text:SetText("Personal (De)buff Size: "..TargetPlayerBuffSizeSlider:GetValue(SelfSize));
        TargetPlayerBuffSizeSlider:SetValueStep(1)
        TargetPlayerBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetPlayerBuffSizeSlider:SetScript("OnValueChanged", function(self, value)
        if RougeUI.SelfSize ~= value then
            RougeUI.SelfSize = TargetPlayerBuffSizeSlider:GetValue();
            TargetPlayerBuffSizeSliderText:SetText("Personal (De)buff Size: "..TargetPlayerBuffSizeSlider:GetValue(SelfSize));
	    SetCustomBuffSize(value)
        end
   end)

        local names = "TargetBuffSizeSlider"
        local template = "OptionsSliderTemplate"
        local TargetBuffSizeSlider = CreateFrame("Slider", names, Panel, template)
        TargetBuffSizeSlider:SetPoint("TOPLEFT", 20, -480)
        TargetBuffSizeSlider.textLow = _G[names.."Low"]
        TargetBuffSizeSlider.textHigh = _G[names.."High"]
        TargetBuffSizeSlider.text = _G[names.."Text"]
        TargetBuffSizeSlider:SetMinMaxValues(8, 32)
        TargetBuffSizeSlider.minValue, TargetBuffSizeSlider.maxValue = TargetBuffSizeSlider:GetMinMaxValues()
        TargetBuffSizeSlider.textLow:SetText(TargetBuffSizeSlider.minValue)
        TargetBuffSizeSlider.textHigh:SetText(TargetBuffSizeSlider.maxValue)
	TargetBuffSizeSlider:SetValue(RougeUI.OtherBuffSize)
	TargetBuffSizeSlider.text:SetText("Target Buff Size: "..TargetBuffSizeSlider:GetValue(OtherBuffSize));
        TargetBuffSizeSlider:SetValueStep(1)
        TargetBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetBuffSizeSlider:SetScript("OnValueChanged", function(self, value)
        if RougeUI.OtherBuffSize ~= value then
            RougeUI.OtherBuffSize = TargetBuffSizeSlider:GetValue();
            TargetBuffSizeSliderText:SetText("Target Buff Size: "..TargetBuffSizeSlider:GetValue(OtherBuffSize));
	    SetCustomBuffSize(value)
        end
    end)

    end
    return Panel
end