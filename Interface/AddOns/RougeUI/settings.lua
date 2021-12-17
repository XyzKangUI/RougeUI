local Name, ns = ...;
local Title = select(2,GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$","");

RougeUI = { Class_Portrait, ClassHP, GradientHP, FastKeyPress, ShortNumeric, FontSize, SelfSize, OtherBuffSize, HighlightDispellable, TimerGap }

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

        local name = "ClassPortraitButton"
        local template = "UICheckButtonTemplate"
        local ClassPortraitButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ClassPortraitButton:SetPoint("TOPLEFT", 10, -60)
        ClassPortraitButton.text = _G[name.."Text"]
	ClassPortraitButton.text:SetText("Show Class Portrait on Target")
	ClassPortraitButton:SetChecked(RougeUI.Class_Portrait)
	ClassPortraitButton:SetScript("OnClick", function() RougeUI.Class_Portrait = not RougeUI.Class_Portrait end)

        local name = "ClassHP"
        local template = "UICheckButtonTemplate"
        local ClassHPButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ClassHPButton:SetPoint("TOPLEFT", 10, -100)
        ClassHPButton.text = _G[name.."Text"]
	ClassHPButton.text:SetText("Enable Class Colored Health bars")
	ClassHPButton:SetChecked(RougeUI.ClassHP)
	ClassHPButton:SetScript("OnClick", function() RougeUI.ClassHP = not RougeUI.ClassHP end)

        local name = "GradientHP"
        local template = "UICheckButtonTemplate"
        local GradientHPButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        GradientHPButton:SetPoint("TOPLEFT", 10, -140)
        GradientHPButton.text = _G[name.."Text"]
	GradientHPButton.text:SetText("Enable Gradient Effect on Health bars")
	GradientHPButton:SetChecked(RougeUI.GradientHP)
	GradientHPButton:SetScript("OnClick", function() RougeUI.GradientHP = not RougeUI.GradientHP end)

        local name = "FastKeyPress"
        local template = "UICheckButtonTemplate"
        local FastKeyPressButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        FastKeyPressButton:SetPoint("TOPLEFT", 10, -180)
        FastKeyPressButton.text = _G[name.."Text"]
	FastKeyPressButton.text:SetText("Use spells when keys are pressed instead of released - Requires /reload")
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
	ShortNumericButton.text:SetText("Shorten the NUMERIC display values to one decimal - Requires /reload")
	ShortNumericButton:SetChecked(RougeUI.ShortNumeric)
	ShortNumericButton:SetScript("OnClick", function() RougeUI.ShortNumeric = not RougeUI.ShortNumeric end)

        local name = "HighlightDispellable"
        local template = "UICheckButtonTemplate"
        local HighlightDispellableButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        HighlightDispellableButton:SetPoint("TOPLEFT", 10, -260)
        HighlightDispellableButton.text = _G[name.."Text"]
	HighlightDispellableButton.text:SetText("Highlight dispellable magic buffs on enemy")
	HighlightDispellableButton:SetChecked(RougeUI.HighlightDispellable)
	HighlightDispellableButton:SetScript("OnClick", function() RougeUI.HighlightDispellable = not RougeUI.HighlightDispellable end)

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