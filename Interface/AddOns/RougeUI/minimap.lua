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
		MinimapNorthTag
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

--------- Show MiniMapTracking on mouseover

local tracker = MiniMapTracking
tracker:SetAlpha(0)
local function FindParent(frame, target)
	if frame == target then
		return true
	elseif frame then
		return FindParent(frame:GetParent(), target)
	end
end

tracker:HookScript("OnEnter", function(self)
	self:SetAlpha(1)
end)

tracker:HookScript("OnLeave", function(self)
	if not FindParent(GetMouseFocus(), self) then
		self:SetAlpha(0)
	end
end)

tracker:HookScript("OnClick", function()
	tracker:SetAlpha(0)
end)
end
	MM:UnregisterEvent("PLAYER_LOGIN")
end);

hooksecurefunc(MiniMapWorldMapButton, "Show", MiniMapWorldMapButton.Hide)
