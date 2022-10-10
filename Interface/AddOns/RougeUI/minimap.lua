local IsAddOnLoaded, hooksecurefunc = IsAddOnLoaded, hooksecurefunc
local GetMouseFocus, ToggleDropDownMenu = GetMouseFocus, ToggleDropDownMenu
local Minimap_OnClick = Minimap_OnClick

local MM = CreateFrame("Frame")
MM:RegisterEvent("PLAYER_LOGIN")
MM:SetScript("OnEvent",function(self, event)
if not (IsAddOnLoaded("SexyMap")) then
	for _, v in pairs ({
		MinimapBorderTop,
		MinimapToggleButton,
		MinimapZoomIn,
		MinimapZoomOut,
		MinimapNorthTag,
		MiniMapTracking
	}) do
		v:Hide()
	end
select(1, TimeManagerClockButton:GetRegions()):SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
	if delta > 0 and Minimap:GetZoom() < 5 then
		Minimap:SetZoom(Minimap:GetZoom() + 1)
	elseif delta < 0 and Minimap:GetZoom() > 0 then
		Minimap:SetZoom(Minimap:GetZoom() - 1)
	end
end)

-- GameTimeFrame
local calendar = GameTimeFrame
calendar:SetAlpha(0)
local function FindParent(frame, target)
	if frame == target then
		return true
	elseif frame then
		return FindParent(frame:GetParent(), target)
	end
end

calendar:HookScript("OnEnter", function(self)
	self:SetAlpha(1)
end)

calendar:HookScript("OnLeave", function(self)
	if not FindParent(GetMouseFocus(), self) then
		self:SetAlpha(0)
	end
end)

calendar:HookScript("OnClick", function()
	calendar:SetAlpha(0)
end)

MiniMapMailFrame:ClearAllPoints() 
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', 0, -10)

MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint("TOPLEFT","MinimapZoneTextButton","TOPLEFT", 8, 0)

-- TrackingFrame

Minimap:SetScript("OnMouseUp", function(self, btn) 
   if btn == "RightButton" then 
      ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "MiniMapTracking", 0, -5)
   else 
      Minimap_OnClick(self) 
   end 
end)

MM:UnregisterEvent("PLAYER_LOGIN")
end
end)

hooksecurefunc(MiniMapWorldMapButton, "Show", MiniMapWorldMapButton.Hide)