local FontType = "Fonts\\FRIZQT__.ttf";

function CusFonts()
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

PetFrameHealthBar.useSimpleValue = true
PetFrameManaBar.useSimpleValue = true
PlayerFrameHealthBar.useSimpleValue = true
PlayerFrameManaBar.useSimpleValue = true
TargetFrameHealthBar.useSimpleValue = true
TargetFrameManaBar.useSimpleValue = true
FocusFrameHealthBar.useSimpleValue = true
FocusFrameManaBar.useSimpleValue = true
for i=1,4 do
   _G["PartyMemberFrame"..i.."HealthBar"].useSimpleValue = true
   _G["PartyMemberFrame"..i.."ManaBar"].useSimpleValue = true
end

local function New_TextStatusBar_UpdateTextString(statusFrame, textString, value, valueMin, valueMax)

	if (statusFrame.LeftText and statusFrame.RightText) then
		statusFrame.LeftText:SetText("");
		statusFrame.RightText:SetText("");
		statusFrame.LeftText:Hide();
		statusFrame.RightText:Hide();
	end

	local textDisplay = GetCVar("statusTextDisplay")

		if ((tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not (statusFrame.pauseUpdates)) then
			if (textDisplay == "NONE") then return end

			if textDisplay == "NUMERIC" and ( value and valueMax > 0) then
				statusFrame.isZero = nil;
				textString:Show();
				if ( value > 1e5 ) then
					textString:SetFormattedText("%s || %.0f%%",true_format(value),100*value/valueMax);
				else
					textString:SetText(true_format(value))
				end
			elseif ( textDisplay == "BOTH" ) and ( value and valueMax > 0) then
				local percent = math.ceil((value / valueMax) * 100) .. "%";
				local display = value
				if (statusFrame) then
					statusFrame.LeftText:SetText(percent)
					statusFrame.LeftText:Show();
					statusFrame.RightText:SetText(display)
					statusFrame.RightText:Show();
					textString:Hide();
				end
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

local function CTextStatusBar_UpdateTextString(textStatusBar)
	if not textStatusBar then textStatusBar = this end
	local textString = textStatusBar.TextString;
	if (textString) then
		if textStatusBar.useSimpleValue then
			local value = textStatusBar.finalValue or textStatusBar:GetValue();
			local valueMin, valueMax = textStatusBar:GetMinMaxValues();
			New_TextStatusBar_UpdateTextString(textStatusBar, textString, value, valueMin, valueMax);
		end
	end
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:RegisterEvent("ADDON_LOADED")
CF:SetScript("OnEvent", function(self, event)
	if RougeUI.smooth == false then return end
	if (event == "PLAYER_LOGIN" or event == "ADDON_LOADED") then
		hooksecurefunc("TextStatusBar_UpdateTextString", CTextStatusBar_UpdateTextString)
	end
end);
