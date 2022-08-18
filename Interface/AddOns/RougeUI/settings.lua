local Name, ns = ...;
local Title = select(2,GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$","");
local floor = math.floor

local function RoundNumbers(val, valStep)
	return floor(val/valStep)*valStep
end

RougeUI = { Class_Portrait, ClassHP, GradientHP, FastKeyPress, ShortNumeric, FontSize, SelfSize, OtherBuffSize, HighlightDispellable, TimerGap, ScoreBoard, HideTitles,
		FadeIcon, EnergyTicker, CombatIndicator, CastTimer, smooth, pimp, retab, rfocus, skinbuttons, Colval, ArenaNumbers, SQFix }

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
    if RougeUI.pimp == nil then RougeUI.pimp = false; end
    if RougeUI.retab == nil then RougeUI.retab = false; end
    if RougeUI.rfocus == nil then RougeUI.rfocus = false; end
    if RougeUI.skinbuttons == nil then RougeUI.skinbuttons = false; end
    if RougeUI.Colval == nil then RougeUI.Colval = 1; end
    if RougeUI.ArenaNumbers == nil then RougeUI.ArenaNumbers = false; end
    if RougeUI.SQFix == nil then RougeUI.SQFix = false; end


    Custom_TargetBuffSize();
    CusFonts();

    if not f.options then
        f.options = f:CreateGUI()
    end
end

function f:CreateGUI()
	local Panel=CreateFrame("Frame", "$parentRougeUI_Config", InterfaceOptionsPanelContainer) do
		Panel.name=Title;
		InterfaceOptions_AddCategory(Panel);--	Panel Registration

		local title=Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
		title:SetPoint("TOPLEFT",12,-15);
		title:SetText(Title);

		local Filler = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Filler:SetPoint("TOP", 0, -50)
		Filler:SetText("Welcome to RougeUI.".." Don't forget to check for new updates on GitHub")

		Panel.childPanel1 = CreateFrame("Frame", "$parentConfigChild_UnitFrame", Panel)
		Panel.childPanel1.name = "UnitFrame"
		Panel.childPanel1.parent = Panel.name
		InterfaceOptions_AddCategory(Panel.childPanel1)

		Panel.childPanel2 = CreateFrame("Frame", "$parentConfigChild_Misc", Panel)
		Panel.childPanel2.name = "Misc"
		Panel.childPanel2.parent = Panel.name
		InterfaceOptions_AddCategory(Panel.childPanel2)

		local Reload = CreateFrame("Button", nil, Panel.childPanel1, "UIPanelButtonTemplate")
		Reload:SetPoint("BOTTOMRIGHT", -10, 10)
		Reload:SetWidth(100)
		Reload:SetHeight(25)
		Reload:SetText("Save & Reload")
		Reload:SetScript("OnClick", function(self, button, down)
			ReloadUI()
		end)

		local Reload = CreateFrame("Button", nil, Panel.childPanel2, "UIPanelButtonTemplate")
		Reload:SetPoint("BOTTOMRIGHT", -10, 10)
		Reload:SetWidth(100)
		Reload:SetHeight(25)
		Reload:SetText("Save & Reload")
		Reload:SetScript("OnClick", function(self, button, down)
			ReloadUI()
		end)

		local name = "ClassPortraitButton"
		local template = "UICheckButtonTemplate"
		local ClassPortraitButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		ClassPortraitButton:SetPoint("TOPLEFT", 10, -40)
		ClassPortraitButton.text = _G[name.."Text"]
		ClassPortraitButton.text:SetText("Enable class portraits")
		ClassPortraitButton:SetChecked(RougeUI.Class_Portrait)
		ClassPortraitButton:SetScript("OnClick", function() RougeUI.Class_Portrait = not RougeUI.Class_Portrait end)

		local name = "ClassHP"
		local template = "UICheckButtonTemplate"
		local ClassHPButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		ClassHPButton:SetPoint("TOPLEFT", 10, -80)
		ClassHPButton.text = _G[name.."Text"]
		ClassHPButton.text:SetText("Class Colored HP")
		ClassHPButton:SetChecked(RougeUI.ClassHP)
		ClassHPButton:SetScript("OnClick", function() RougeUI.ClassHP = not RougeUI.ClassHP end)

		local name = "ScoreBoard"
		local template = "UICheckButtonTemplate"
		local ScoreBoardButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		ScoreBoardButton:SetPoint("TOPLEFT", 10, -120)
		ScoreBoardButton.text = _G[name.."Text"]
		ScoreBoardButton.text:SetText("Class Colored PvP Scoreboard")
		ScoreBoardButton:SetChecked(RougeUI.ScoreBoard)
		ScoreBoardButton:SetScript("OnClick", function() RougeUI.ScoreBoard = not RougeUI.ScoreBoard end)

		local name = "HideTitles"
		local template = "UICheckButtonTemplate"
		local HideTitlesButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		HideTitlesButton:SetPoint("TOPLEFT", 10, -240)
		HideTitlesButton.text = _G[name.."Text"]
		HideTitlesButton.text:SetText("Hide Group/Raid titles, e.g. Group 1")
		HideTitlesButton:SetChecked(RougeUI.HideTitles)
		HideTitlesButton:SetScript("OnClick", function() RougeUI.HideTitles = not RougeUI.HideTitles end)

		local name = "FadeIcon"
		local template = "UICheckButtonTemplate"
		local FadeIconButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		FadeIconButton:SetPoint("TOPLEFT", 350, -40)
		FadeIconButton.text = _G[name.."Text"]
		FadeIconButton.text:SetText("Fade PvP Icon")
		FadeIconButton:SetChecked(RougeUI.FadeIcon)
		FadeIconButton:SetScript("OnClick", function() RougeUI.FadeIcon = not RougeUI.FadeIcon end)

		local name = "HideGlows"
		local template = "UICheckButtonTemplate"
		local HideGlowsButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		HideGlowsButton:SetPoint("TOPLEFT", 350, -80)
		HideGlowsButton.text = _G[name.."Text"]
		HideGlowsButton.text:SetText("Hide hit indicator + glows on Playerframe")
		HideGlowsButton:SetChecked(RougeUI.HideGlows)
		HideGlowsButton:SetScript("OnClick", function() RougeUI.HideGlows = not RougeUI.HideGlows end)

		local name = "EnergyTicker"
		local template = "UICheckButtonTemplate"
		local EnergyTickerButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		EnergyTickerButton:SetPoint("TOPLEFT", 350, -120)
		EnergyTickerButton.text = _G[name.."Text"]
		EnergyTickerButton.text:SetText("Enable Energy ticker for Rogue/Druid")
		EnergyTickerButton:SetChecked(RougeUI.EnergyTicker)
		EnergyTickerButton:SetScript("OnClick", function() RougeUI.EnergyTicker = not RougeUI.EnergyTicker end)

		local name = "CombatIndicator"
		local template = "UICheckButtonTemplate"
		local CombatIndicatorButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		CombatIndicatorButton:SetPoint("TOPLEFT", 10, -160)
		CombatIndicatorButton.text = _G[name.."Text"]
		CombatIndicatorButton.text:SetText("Enable Combat Indicator")
		CombatIndicatorButton:SetChecked(RougeUI.CombatIndicator)
		CombatIndicatorButton:SetScript("OnClick", function() RougeUI.CombatIndicator = not RougeUI.CombatIndicator end)

		local name = "CastTimer"
		local template = "UICheckButtonTemplate"
		local CastTimerButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		CastTimerButton:SetPoint("TOPLEFT", 10, -200)
		CastTimerButton.text = _G[name.."Text"]
		CastTimerButton.text:SetText("Enable modUI castbar style with timer")
		CastTimerButton:SetChecked(RougeUI.CastTimer)
		CastTimerButton:SetScript("OnClick", function() RougeUI.CastTimer = not RougeUI.CastTimer end)

		local name = "SmoothFrame"
		local template = "UICheckButtonTemplate"
		local SmoothFrameButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		SmoothFrameButton:SetPoint("TOPLEFT", 350, -160)
		SmoothFrameButton.text = _G[name.."Text"]
		SmoothFrameButton.text:SetText("Smooth animated health/mana bars")
		SmoothFrameButton:SetChecked(RougeUI.smooth)
		SmoothFrameButton:SetScript("OnClick", function() RougeUI.smooth = not RougeUI.smooth end)

		local name = "PimpFrame"
		local template = "UICheckButtonTemplate"
		local PimpFrameButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		PimpFrameButton:SetPoint("TOPLEFT", 350, -200)
		PimpFrameButton.text = _G[name.."Text"]
		PimpFrameButton.text:SetText("Enable Violet Colored Energy/Mana Bar")
		PimpFrameButton:SetChecked(RougeUI.pimp)
		PimpFrameButton:SetScript("OnClick", function() RougeUI.pimp = not RougeUI.pimp end)

		local name = "RetabBind"
		local template = "UICheckButtonTemplate"
		local RetabBind = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		RetabBind:SetPoint("TOPLEFT", 10, -280)
		RetabBind.text = _G[name.."Text"]
		RetabBind.text:SetText("RETabBinder")
		RetabBind:SetChecked(RougeUI.retab)
		RetabBind:SetScript("OnClick", function() RougeUI.retab = not RougeUI.retab end)

		local name = "Skinbuttons"
		local template = "UICheckButtonTemplate"
		local Skinbuttons = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		Skinbuttons:SetPoint("TOPLEFT", 10, -320)
		Skinbuttons.text = _G[name.."Text"]
		Skinbuttons.text:SetText("Apply border theme to actionbar, buffs etc")
		Skinbuttons:SetChecked(RougeUI.skinbuttons)
		Skinbuttons:SetScript("OnClick", function() RougeUI.skinbuttons = not RougeUI.skinbuttons end)

		local name = "ColorValueSlider"
		local template = "OptionsSliderTemplate"
		local ColorValueSlider = CreateFrame("Slider", name, Panel.childPanel2, template)
		ColorValueSlider:SetMinMaxValues(0, 1)
		ColorValueSlider:SetPoint("TOPLEFT",20, -390)
		ColorValueSlider.text = _G[name.."Text"]
		ColorValueSlider.textLow = _G[name.."Low"]
		ColorValueSlider.textHigh = _G[name.."High"]
		ColorValueSlider.minValue, ColorValueSlider.maxValue = ColorValueSlider:GetMinMaxValues()
		ColorValueSlider.textLow:SetText(floor(ColorValueSlider.minValue))
		ColorValueSlider.textHigh:SetText(floor(ColorValueSlider.maxValue))
		ColorValueSlider:SetValue(RougeUI.Colval)
		ColorValueSlider.text:SetText("Change brightness of UI: "..ColorValueSlider:GetValue(Colval))
		ColorValueSlider:SetValueStep(0.05)
		ColorValueSlider:SetObeyStepOnDrag(true);
		ColorValueSlider:SetScript("OnValueChanged", function(self,value)
			ColorValueSlider.text:SetText("Change brightness of UI: "..RoundNumbers(RougeUI.Colval, 0.05))
			RougeUI.Colval = ColorValueSlider:GetValue()
			ChangeFrameColors()
		end)

		local name = "ArenaNumbers"
		local template = "UICheckButtonTemplate"
		local ArenaNumbersButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		ArenaNumbersButton:SetPoint("TOPLEFT", 350, -40)
		ArenaNumbersButton.text = _G[name.."Text"]
		ArenaNumbersButton.text:SetText("Show arena number on nameplate")
		ArenaNumbersButton:SetChecked(RougeUI.ArenaNumbers)
		ArenaNumbersButton:SetScript("OnClick", function() RougeUI.ArenaNumbers = not RougeUI.ArenaNumbers end)

		local name = "SpellQueueWindow"
		local template = "UICheckButtonTemplate"
		local SQFixButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		SQFixButton:SetPoint("TOPLEFT", 350, -80)
		SQFixButton.text = _G[name.."Text"]
		SQFixButton.text:SetText("Auto-adjust SpellQueue Window")
		SQFixButton:SetChecked(RougeUI.SQFix)
		SQFixButton:SetScript("OnClick", function() RougeUI.SQFix = not RougeUI.SQFix end)

		local name = "RedFocus"
		local template = "UICheckButtonTemplate"
		local RedFocus = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		RedFocus:SetPoint("TOPLEFT", 350, -240)
		RedFocus.text = _G[name.."Text"]
		RedFocus.text:SetText("Add red line to focusframe")
		RedFocus:SetChecked(RougeUI.rfocus)
		RedFocus:SetScript("OnClick", function() RougeUI.rfocus = not RougeUI.rfocus end)

		local name = "GradientHP"
		local template = "UICheckButtonTemplate"
		local GradientHPButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		GradientHPButton:SetPoint("TOPLEFT", 10, -120)
		GradientHPButton.text = _G[name.."Text"]
		GradientHPButton.text:SetText("Gradient effect on HP")
		GradientHPButton:SetChecked(RougeUI.GradientHP)
		GradientHPButton:SetScript("OnClick", function() RougeUI.GradientHP = not RougeUI.GradientHP end)

		local name = "FastKeyPress"
		local template = "UICheckButtonTemplate"
		local FastKeyPressButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		FastKeyPressButton:SetPoint("TOPLEFT", 10, -40)
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
		local ShortNumericButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		ShortNumericButton:SetPoint("TOPLEFT", 10, -160)
		ShortNumericButton.text = _G[name.."Text"]
		ShortNumericButton.text:SetText("Shorten NUMERIC HP to one decimal")
		ShortNumericButton:SetChecked(RougeUI.ShortNumeric)
		ShortNumericButton:SetScript("OnClick", function() RougeUI.ShortNumeric = not RougeUI.ShortNumeric end)

		local name = "HighlightDispellable"
		local template = "UICheckButtonTemplate"
		local HighlightDispellableButton = CreateFrame("CheckButton", name, Panel.childPanel1, "UICheckButtonTemplate")
		HighlightDispellableButton:SetPoint("TOPLEFT", 10, -200)
		HighlightDispellableButton.text = _G[name.."Text"]
		HighlightDispellableButton.text:SetText("Highlight enemy Magic buffs")
		HighlightDispellableButton:SetChecked(RougeUI.HighlightDispellable)
		HighlightDispellableButton:SetScript("OnClick", function() RougeUI.HighlightDispellable = not RougeUI.HighlightDispellable end)

		local name = "TimerGap"
		local template = "UICheckButtonTemplate"
		local TimerGapButton = CreateFrame("CheckButton", name, Panel.childPanel2, "UICheckButtonTemplate")
		TimerGapButton:SetPoint("TOPLEFT", 10, -80)
		TimerGapButton.text = _G[name.."Text"]
		TimerGapButton.text:SetText("Remove space gap in (de)buff timer")
		TimerGapButton:SetChecked(RougeUI.TimerGap)
		TimerGapButton:SetScript("OnClick", function() RougeUI.TimerGap = not RougeUI.TimerGap end)

		local name = "FontSizeSlider"
		local template = "OptionsSliderTemplate"
		local FontSizeSlider = CreateFrame("Slider", name, Panel.childPanel1, template)
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
		local TargetPlayerBuffSizeSlider = CreateFrame("Slider", names, Panel.childPanel1, template)
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
				TargetPlayerBuffSizeSliderText:SetText("Personal (De)buff Size: "..RoundNumbers(RougeUI.SelfSize, 1))
				SetCustomBuffSize(value)
			end
		end)

		local names = "TargetBuffSizeSlider"
		local template = "OptionsSliderTemplate"
		local TargetBuffSizeSlider = CreateFrame("Slider", names, Panel.childPanel1, template)
		TargetBuffSizeSlider:SetPoint("TOPLEFT", 20, -480)
		TargetBuffSizeSlider:SetMinMaxValues(8, 32)
		TargetBuffSizeSlider:SetValueStep(1)
		TargetBuffSizeSlider.textLow = _G[names.."Low"]
		TargetBuffSizeSlider.textHigh = _G[names.."High"]
		TargetBuffSizeSlider.text = _G[names.."Text"]
		TargetBuffSizeSlider.minValue, TargetBuffSizeSlider.maxValue = TargetBuffSizeSlider:GetMinMaxValues()
		TargetBuffSizeSlider.textLow:SetText(floor(TargetBuffSizeSlider.minValue))
		TargetBuffSizeSlider.textHigh:SetText(floor(TargetBuffSizeSlider.maxValue))
		TargetBuffSizeSlider:SetValue(RougeUI.OtherBuffSize)
		TargetBuffSizeSlider.text:SetText("Target Buff Size: "..TargetBuffSizeSlider:GetValue(OtherBuffSize));
		TargetBuffSizeSlider:SetObeyStepOnDrag(true);
		TargetBuffSizeSlider:SetScript("OnValueChanged", function(self, value)
			if RougeUI.OtherBuffSize ~= value then
				RougeUI.OtherBuffSize = TargetBuffSizeSlider:GetValue();
				TargetBuffSizeSliderText:SetText("Target Buff Size: "..RoundNumbers(RougeUI.OtherBuffSize, 1))
				SetCustomBuffSize(value)
			end
		end)

	end
	return Panel
end
