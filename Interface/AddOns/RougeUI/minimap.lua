local _, RougeUI = ...
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded

local MM = CreateFrame("Frame")
MM:RegisterEvent("PLAYER_LOGIN")
MM:SetScript("OnEvent", function(self, event)
    if not (IsAddOnLoaded("SexyMap")) then
        TimeManagerClockButton:GetRegions():SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        -- Hide stuff
        if MiniMapWorldMapButton then
            hooksecurefunc(MiniMapWorldMapButton, "Show", MiniMapWorldMapButton.Hide)
        end
        if MinimapNorthTag then
            hooksecurefunc(MinimapNorthTag, "Show", MinimapNorthTag.Hide)
        end

        for _, v in pairs({
            MinimapBorderTop,
            MinimapToggleButton,
            MinimapZoomIn,
            MinimapZoomOut,
        }) do
            if v then
                v:Hide()
            end
        end

        -- Zoom in with mousewheel
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

        -- Show calendar on mouseover
        calendar:HookScript("OnEnter", function(self)
            self:SetAlpha(1)
        end)

        calendar:HookScript("OnLeave", function(self)
            local focus = GetMouseFoci and GetMouseFoci()[1] or GetMouseFocus()
            if not FindParent(focus, self) then
                self:SetAlpha(0)
            end
        end)

        if calendar:HasScript("OnClick") then
            calendar:HookScript("OnClick", function()
                calendar:SetAlpha(0)
            end)
        end

        if IsAddOnLoaded("Leatrix_Plus") and (LeaPlusDB["MinimapModder"] == "On" and (LeaPlusDB["CombineAddonButtons"] == "On") or LeaPlusDB["SquareMinimap"] == "On") then
            return
        end

        -- Center text properly
        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint("TOPLEFT", "MinimapZoneTextButton", "TOPLEFT", 8, 0)

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

