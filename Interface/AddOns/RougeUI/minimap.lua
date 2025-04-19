local _, RougeUI = ...
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

local MM = CreateFrame("Frame")
MM:RegisterEvent("PLAYER_LOGIN")
MM:SetScript("OnEvent", function(self, event)
    if not (IsAddOnLoaded("SexyMap")) and event == "PLAYER_LOGIN" then
        TimeManagerClockButton:GetRegions():SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        -- Hide stuff
        if MiniMapWorldMapButton then
            hooksecurefunc(MiniMapWorldMapButton, "Show", MiniMapWorldMapButton.Hide)
        end

        if MinimapNorthTag then
            hooksecurefunc(MinimapNorthTag, "Show", MinimapNorthTag.Hide)
        end

        C_Timer.After(0, function()
            if LFGMinimapFrameBorder then
                LFGMinimapFrameBorder:Hide()
            end

            if LFGMinimapFrame then
                LFGMinimapFrame:SetAlpha(0)
                LFGMinimapFrame:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
                LFGMinimapFrame:HookScript("OnLeave", function(self) self:SetAlpha(0) end)
            end
        end)

        for _, v in pairs({
            --MinimapBorderTop,
            MinimapToggleButton,
            MinimapZoomIn,
            MinimapZoomOut,
            MinimapNorthTag,
        }) do
            if v then
                v:Hide()
                v:SetAlpha(0)
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
            local focus = GetMouseFoci()[1]
            if not focus then return end

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

        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint("TOPLEFT", -23, 7)
        MiniMapMailBorder:Hide()
        MiniMapMailIcon:SetTexture("Interface\\AddOns\\RougeUI\\textures\\mailicon")

        if MiniMapTracking and MiniMapTrackingButton then
            MiniMapTracking:ClearAllPoints()
            MiniMapTracking:SetPoint("CENTER", UIParent, "CENTER", 100000, 100000)
            MiniMapTrackingButton:SetParent(Minimap)
            MiniMapTrackingButton:SetMenuAnchor(AnchorUtil.CreateAnchor("TOPRIGHT", Minimap, "CENTER"))

            local menuOpen = false
            Minimap:SetScript("OnMouseUp", function(self, btn)
                if btn == "RightButton" then
                    if menuOpen then
                        MiniMapTrackingButton:CloseMenu()
                    else
                        MiniMapTrackingButton:OpenMenu()
                    end
                else
                    Minimap_OnClick(self)
                end
            end)

            hooksecurefunc(MiniMapTrackingButton, "OpenMenu", function()
                menuOpen = true
            end)

            hooksecurefunc(MiniMapTrackingButton, "CloseMenu", function()
                menuOpen = false
            end)

            Minimap:SetPropagateKeyboardInput(true)
            Minimap:HookScript("OnKeyDown", function(self, key)
                if key == "ESCAPE" then
                    menuOpen = false
                end
            end)
        end


        MinimapZoneText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        MinimapBorder:SetTexture("Interface\\AddOns\\RougeUI\\textures\\minimapBorder")
        MinimapBorderTop:SetTexture("Interface\\AddOns\\RougeUI\\textures\\minimapBorder")
        MinimapBorderTop:SetTexCoord(0.25, 1, 0, 0.125)
        MinimapBorderTop:ClearAllPoints()
        MinimapBorderTop:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", 0, 7)
        MinimapZoneTextButton:HookScript("OnClick", function()
            ToggleMinimap()
        end)
        MinimapZoneTextButton:ClearAllPoints()
        MinimapZoneTextButton:SetPoint("CENTER", MinimapCluster, "CENTER", -10, 83)
        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint("LEFT", MinimapBorderTop, "LEFT", 20, -1)
        MinimapZoneText:SetJustifyH("LEFT")
        MinimapZoneText:SetWidth(137)
        TimeManagerClockTicker:SetParent(MinimapZoneTextButton) -- MinimapBackdrop
        TimeManagerClockTicker:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        TimeManagerClockTicker:ClearAllPoints()
        TimeManagerClockTicker:SetPoint("RIGHT", MinimapBorderTop, "RIGHT", -8, -1)
        TimeManagerClockTicker:SetJustifyH("RIGHT")
        TimeManagerClockButton:SetParent(MinimapZoneTextButton)
        TimeManagerClockButton:SetAlpha(0)
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint("RIGHT", MinimapZoneText, "RIGHT", 38, -1)
    end
end)

