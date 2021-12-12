local Name, ns = ...;
local Title = select(2,GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$","");

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
function f:ADDON_LOADED()
    if Class_Portrait == nil then Class_Portrait = false; end
    if ClassHP == nil then ClassHP = false; end
    if GradientHP == nil then GradientHP = false; end
    if FastKeyPress == nil then FastKeyPress = false; end
    if ShortNumeric == nil then ShortNumeric = false; end
    if FontSize == nil then FontSize = 11; end
    if SelfSize == nil then SelfSize = 27; end
    if OtherBuffSize == nil then OtherBuffSize = 23; end
    if HighlightDispellable == nil then HighlightDispellable = false; end

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
	ClassPortraitButton:SetChecked(Class_Portrait)
	ClassPortraitButton:SetScript("OnClick", function() Class_Portrait = not Class_Portrait end)

        local name = "ClassHP"
        local template = "UICheckButtonTemplate"
        local ClassHPButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        ClassHPButton:SetPoint("TOPLEFT", 10, -100)
        ClassHPButton.text = _G[name.."Text"]
	ClassHPButton.text:SetText("Enable Class Colored Health bars")
	ClassHPButton:SetChecked(ClassHP)
	ClassHPButton:SetScript("OnClick", function() ClassHP = not ClassHP end)

        local name = "GradientHP"
        local template = "UICheckButtonTemplate"
        local GradientHPButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        GradientHPButton:SetPoint("TOPLEFT", 10, -140)
        GradientHPButton.text = _G[name.."Text"]
	GradientHPButton.text:SetText("Enable Gradient Effect on Health bars")
	GradientHPButton:SetChecked(GradientHP)
	GradientHPButton:SetScript("OnClick", function() GradientHP = not GradientHP end)

        local name = "FastKeyPress"
        local template = "UICheckButtonTemplate"
        local FastKeyPressButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        FastKeyPressButton:SetPoint("TOPLEFT", 10, -180)
        FastKeyPressButton.text = _G[name.."Text"]
	FastKeyPressButton.text:SetText("Use spells when keys are pressed instead of released - Requires /reload")
	FastKeyPressButton:SetChecked(FastKeyPress)
	FastKeyPressButton:SetScript("OnClick", function() FastKeyPress = not FastKeyPress end)
	FastKeyPressButton:RegisterEvent("PLAYER_ENTERING_WORLD")
	FastKeyPressButton:SetScript("OnEvent", function(self, event, ...)
		if (event == "PLAYER_ENTERING_WORLD") and FastKeyPress == true then 
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
	ShortNumericButton:SetChecked(ShortNumeric)
	ShortNumericButton:SetScript("OnClick", function() ShortNumeric = not ShortNumeric end)

        local name = "HighlightDispellable"
        local template = "UICheckButtonTemplate"
        local HighlightDispellableButton = CreateFrame("CheckButton", name, Panel, "UICheckButtonTemplate")
        HighlightDispellableButton:SetPoint("TOPLEFT", 10, -260)
        HighlightDispellableButton.text = _G[name.."Text"]
	HighlightDispellableButton.text:SetText("Highlight dispellable magic buffs on enemy")
	HighlightDispellableButton:SetChecked(HighlightDispellable)
	HighlightDispellableButton:SetScript("OnClick", function() HighlightDispellable = not HighlightDispellable end)

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
        FontSizeSlider:SetValue(FontSize)
        FontSizeSlider.text:SetText("Healthbar Font Size: "..FontSizeSlider:GetValue(FontSize))
        FontSizeSlider:SetValueStep(1)
        FontSizeSlider:SetObeyStepOnDrag(true);
        FontSizeSlider:SetScript("OnValueChanged", function(self,event,arg1)
            FontSizeSlider.text:SetText("Healthbar Font Size: "..FontSizeSlider:GetValue(FontSize))
            FontSize = FontSizeSlider:GetValue()
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
	TargetPlayerBuffSizeSlider:SetValue(SelfSize)
	TargetPlayerBuffSizeSlider.text:SetText("Personal (De)buff Size: "..TargetPlayerBuffSizeSlider:GetValue(SelfSize));
        TargetPlayerBuffSizeSlider:SetValueStep(1)
        TargetPlayerBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetPlayerBuffSizeSlider:SetScript("OnValueChanged", function(self, value)
        if SelfSize ~= value then
            SelfSize = TargetPlayerBuffSizeSlider:GetValue();
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
	TargetBuffSizeSlider:SetValue(OtherBuffSize)
	TargetBuffSizeSlider.text:SetText("Target Buff Size: "..TargetBuffSizeSlider:GetValue(OtherBuffSize));
        TargetBuffSizeSlider:SetValueStep(1)
        TargetBuffSizeSlider:SetObeyStepOnDrag(true);
        TargetBuffSizeSlider:SetScript("OnValueChanged", function(self, value)
        if OtherBuffSize ~= value then
            OtherBuffSize = TargetBuffSizeSlider:GetValue();
            TargetBuffSizeSliderText:SetText("Target Buff Size: "..TargetBuffSizeSlider:GetValue(OtherBuffSize));
	    SetCustomBuffSize(value)
        end
    end)
    end
    return Panel
end