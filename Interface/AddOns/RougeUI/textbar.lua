local FontType = "Fonts\\FRIZQT__.ttf";

function RougeUIF:CusFonts()
    PlayerFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    PlayerFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    PlayerFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    PetFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")

    PetFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")
    PetFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize - 2, "OUTLINE")

    TargetFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    TargetFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    TargetFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    FocusFrameHealthBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameHealthBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameHealthBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")

    FocusFrameManaBar.TextString:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameManaBar.LeftText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
    FocusFrameManaBar.RightText:SetFont(FontType, RougeUI.FontSize, "OUTLINE")
end

local function true_format(value)
	if (RougeUI.ShortNumeric == true) then
		if value > 1e7 then return (math.floor(value /1e6))..'m'
		elseif value > 1e6 then return (math.floor((value /1e6)*10)/10)..'m'
 		elseif value > 1e4 then return (math.floor(value/1e3))..'k'
		elseif value > 1e3 then return (math.floor((value /1e3)*10)/10)..'k'
		else return value end
	elseif (RougeUI.ShortNumeric == false) then
		return value
	end
end

local function New_TextStatusBar_UpdateTextStringWithValues(statusFrame, textString, value, valueMin, valueMax)
	local value = statusFrame.finalValue or statusFrame:GetValue();

	if( statusFrame.LeftText and statusFrame.RightText ) then
		statusFrame.LeftText:SetText("");
		statusFrame.RightText:SetText("");
		statusFrame.LeftText:Hide();
		statusFrame.RightText:Hide();
	end

	local textDisplay = GetCVar("statusTextDisplay")

		if ((tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not (statusFrame.pauseUpdates)) then
			if textDisplay == "NUMERIC" and ( value and valueMax > 0) then
				statusFrame.isZero = nil;
				textString:Show();
				if ( value > 1e5 ) then
					textString:SetFormattedText("%s || %.0f%%",true_format(value),100*value/valueMax);
				else
					textString:SetText(true_format(value))
				end
			elseif ( textDisplay == "BOTH" ) and ( value and valueMax > 0) then
				if ( statusFrame.LeftText and statusFrame.RightText ) then
					if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
						statusFrame.LeftText:SetText(math.ceil((value / valueMax) * 100) .. "%");
						statusFrame.LeftText:Show();
					end
					statusFrame.RightText:SetText(value)
					statusFrame.RightText:Show();
				end
					textString:Hide();
			elseif textDisplay == "PERCENT" and ( value and valueMax > 0) then
				local percent = math.ceil((value / valueMax) * 100) .. "%";
				textString:SetText(percent)
				textString:Show();
			end
		else
			textString:Hide();
			textString:SetText("");
			if ( not statusFrame.alwaysShow ) then
				statusFrame:Hide();
			else
				statusFrame:SetValue(0);
			end
		end

	if (textDisplay == "BOTH") or (textDisplay == "NUMERIC") or (textDisplay == "PERCENT") then
		if (UnitIsDeadOrGhost("target")) then
			for i, v in pairs({TargetFrameHealthBar, TargetFrameManaBar}) do
				v.TextString:SetText("");
				v.LeftText:SetText("");
				v.RightText:SetText("");
			end
		end
	end
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" and (RougeUI.smooth or RougeUI.ShortNumeric) then
		hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
	end
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent", nil)
end);