local MM = CreateFrame("Frame")
MM:RegisterEvent("PLAYER_LOGIN")
MM:SetScript("OnEvent",function(self, event)
if not (IsAddOnLoaded("SexyMap")) then
	for _, v in pairs ({
		MinimapBorderTop,
		MinimapToggleButton,
		MinimapZoomIn,
		GameTimeFrame,
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

MiniMapMailFrame:ClearAllPoints() 
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', 0, -10)

MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint('TOP', Minimap, -2, 17)

GameTimeFrame:UnregisterAllEvents()
GameTimeFrame.Show = kill

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