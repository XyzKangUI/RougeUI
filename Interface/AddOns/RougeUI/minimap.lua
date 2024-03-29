local _, RougeUI = ...
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded

local MM = CreateFrame("Frame")
MM:RegisterEvent("PLAYER_LOGIN")
MM:SetScript("OnEvent", function(self)
    if not (IsAddOnLoaded("SexyMap")) then
        for _, v in pairs({
            MinimapBorderTop,
            MinimapToggleButton,
            MinimapZoomIn,
            MinimapZoomOut,
        }) do
            v:Hide()
        end
        select(1, TimeManagerClockButton:GetRegions()):SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)

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

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            calendar:HookScript("OnClick", function()
                calendar:SetAlpha(0)
            end)
        end

        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint("TOPLEFT", "MinimapZoneTextButton", "TOPLEFT", 8, 0)

        self:UnregisterEvent("PLAYER_LOGIN")

        if IsAddOnLoaded("Leatrix_Plus") and (LeaPlusDB["MinimapModder"] == "On" and (LeaPlusDB["CombineAddonButtons"] == "On") or LeaPlusDB["SquareMinimap"] == "On") then
            return
        end

        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint('BOTTOMRIGHT', 0, -10)

        if MiniMapTracking then
            MiniMapTracking:Hide()
            Minimap:SetScript("OnMouseUp", function(self, btn)
                if btn == "RightButton" then
                    ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "MiniMapTracking", 0, -5)
                else
                    Minimap_OnClick(self)
                end
            end)
        end
    end
end)

hooksecurefunc(MiniMapWorldMapButton, "Show", MiniMapWorldMapButton.Hide)
hooksecurefunc(MinimapNorthTag, "Show", MinimapNorthTag.Hide)