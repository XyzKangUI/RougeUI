local _, RougeUI = ...
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

local MM = CreateFrame("Frame")
MM:RegisterEvent("ADDON_LOADED")
MM:SetScript("OnEvent", function(self, event, addon)
    local colVal = RougeUI.db.Colval

    if not (IsAddOnLoaded("SexyMap") or IsAddOnLoaded("Leatrix_Plus") and (LeaPlusDB["MinimapModder"] == "On")) and addon == "Blizzard_TimeManager" then
        TimeManagerClockButton:GetRegions():SetVertexColor(colVal, colVal, colVal)

        if not RougeUI.db.minimapChanges then
            if MinimapBorderTop then
                MinimapBorderTop:SetVertexColor(colVal, colVal, colVal)
            end
            return
        end

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
            MinimapNorthTag,
            MiniMapMailBorder,
            MinimapBorder,
            MiniMapWorldMapButton,
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

        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint("TOPLEFT", -6, 0)
        MiniMapMailIcon:SetTexture("Interface\\AddOns\\RougeUI\\textures\\mailicon")

        -- Square minimap
        local MinimapSize = 175
        Minimap:SetMaskTexture("Interface\\AddOns\\RougeUI\\textures\\rectangle")
        MinimapBorderTop:SetTexture(0)
        Minimap:SetSize(MinimapSize, MinimapSize)
        Minimap:SetHitRectInsets(0, 0, 24, 24)
        local p, r, rp, ofx, ofy = Minimap:GetPoint()
        Minimap:ClearAllPoints()
        Minimap:SetPoint(p, r, rp, ofx - 10, ofy)

        -- New border
        local bg = CreateFrame("Frame", nil, Minimap)
        bg:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, -21)
        bg:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, 21)
        bg:SetBackdrop({ edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND", edgeSize = 2 })
        bg:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.7)
        bg:SetBackdropColor(0.1, 0.1, 0.1)

        local topbg = CreateFrame("Frame", nil, MinimapCluster)
        topbg:SetParent(MinimapCluster)
        topbg:SetPoint("TOP", Minimap, "BOTTOM", 0, 21)
        topbg:SetSize(MinimapSize + 2, 15)
        topbg:SetBackdrop({ bgFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND", edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND", edgeSize = 2 })
        topbg:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.5)
        topbg:SetBackdropColor(0.1, 0.1, 0.1, 0.3)
        topbg:EnableMouse(false)

        -- Clock
        TimeManagerClockTicker:SetParent(MinimapZoneTextButton) -- MinimapBackdrop
        TimeManagerClockTicker:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        TimeManagerClockTicker:ClearAllPoints()
        TimeManagerClockTicker:SetPoint("LEFT", topbg, "LEFT", 2, 0)
        TimeManagerClockTicker:SetJustifyH("LEFT")
        TimeManagerClockButton:SetParent(MinimapZoneTextButton)
        TimeManagerClockButton:SetAlpha(0)
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetWidth(42)
        TimeManagerClockButton:SetPoint("LEFT", MinimapZoneText, "LEFT", -52, 0)

        -- ZoneText
        MinimapZoneText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        MinimapZoneTextButton:HookScript("OnClick", function()
            ToggleMinimap()
        end)
        MinimapZoneTextButton:ClearAllPoints()
        MinimapZoneTextButton:SetPoint("RIGHT", topbg, "RIGHT", 2, -1)
        MinimapZoneText:SetJustifyH("RIGHT")
        MinimapZoneText:SetWidth(120)
        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint("RIGHT", topbg, "RIGHT", 0, 0)

        -- PVP Button
        MiniMapBattlefieldBorder:Hide()
        MiniMapBattlefieldFrame:ClearAllPoints()
        MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, 20)

        -- Instance Difficulty
        local r, p, re, xoff, yoff = MiniMapInstanceDifficulty:GetPoint()
        MiniMapInstanceDifficulty:SetParent(Minimap)
        MiniMapInstanceDifficulty:ClearAllPoints()
        MiniMapInstanceDifficulty:SetPoint(r, p, re, 2.5, yoff)

        -- Reposition LFG Button
        if MiniMapLFGFrame then
            MiniMapLFGFrame:ClearAllPoints()
            MiniMapLFGFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -14, -6)
            MiniMapLFGFrameBorder:Hide()
        end

        -- GameTimeFrame
        GameTimeFrame:SetNormalTexture("Interface\\AddOns\\RougeUI\\textures\\cal")
        GameTimeFrame:SetPushedTexture("")
        GameTimeFrame:SetHighlightTexture("")
        GameTimeFrame:SetScale(0.8)
        local r, p, re, xoff, yoff = GameTimeFrame:GetPoint(1)
        GameTimeFrame:ClearAllPoints()
        GameTimeFrame:SetPoint(r, p, re, xoff, yoff - 30)
        GameTimeFrame:SetAlpha(0)
        GameTimeFrame:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
        GameTimeFrame:HookScript("OnLeave", function(self) self:SetAlpha(0) end)

        -- Move Buffs
        if ConsolidatedBuffs then
            local r, p, re, xoff, yoff = ConsolidatedBuffs:GetPoint()
            if r == "TOPRIGHT" and p == UIParent and re == "TOPRIGHT" and math.ceil(xoff) == -180 and math.ceil(yoff) == -13 then
                ConsolidatedBuffs:ClearAllPoints()
                ConsolidatedBuffs:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -205, -27) -- x = -187
            end
        end

        -- Disable cluster clicks
        MinimapCluster:EnableMouse(false)

        -- Tracking fix
        if (GetTrackingTexture() ~= nil) then
            if not MiniMapTrackingIcon:GetTexture() then
                MiniMapTrackingIcon:SetTexture(GetTrackingTexture())
                MiniMapTracking:Show()
            end
        end

        if MiniMapTracking and MiniMapTrackingBorder then
            MiniMapTrackingBorder:SetAtlas("Forge-ColorSwatchBorder", true)
            MiniMapTrackingBorder:SetSize(22, 22)
            MiniMapTrackingBorder:ClearAllPoints()
            MiniMapTrackingBorder:SetPoint("CENTER", MiniMapTracking, "CENTER")

            if MiniMapTrackingIcon then
                MiniMapTrackingIcon:SetSize(16, 16)
                MiniMapTrackingIcon:ClearAllPoints()
                MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTracking, "CENTER")
                MiniMapTrackingIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            end

            MiniMapTracking:ClearAllPoints()
            MiniMapTracking:SetPoint("TOPLEFT", MinimapBackdrop, "LEFT", -5, -26)
        end

        -- Re-anchor all buttons
        local buttonsPerRow = 6
        local spacing = 32
        local showingButtons = false

        local buttonAnchor = CreateFrame("Frame", "RougeMMAnchor", MinimapCluster)
        buttonAnchor:SetPoint("TOPLEFT", topbg, "BOTTOMLEFT", -2, 0)
        buttonAnchor:SetSize(1, 1)
        buttonAnchor:Hide()

        local function GetAllLibDBIconButtons()
            local results = {}
            for _, frame in pairs(_G) do
                if type(frame) == "table"
                        and type(frame.GetName) == "function"
                        and frame:GetName()
                        and frame:GetName():match("^LibDBIcon10_")
                        and frame.SetPoint then
                    table.insert(results, frame)
                end
            end
            return results
        end

        local function ShowMinimapButtons()
            local row, col = 0, 0
            local buttons = GetAllLibDBIconButtons()
            local prevButton

            for _, button in ipairs(buttons) do
                if button then
                    local name = button:GetName()
                    if name ~= prevButton then
                        prevButton = name
                        button:ClearAllPoints()
                        button:SetParent(buttonAnchor)
                        button:SetPoint("TOPLEFT", buttonAnchor, "TOPLEFT", col * spacing, -row * spacing)
                        button:Show()

                        col = col + 1
                        if col >= buttonsPerRow then
                            col = 0
                            row = row + 1
                        end
                    end
                end
            end

            if #buttons > 0 then
                buttonAnchor:Show()
            end
        end

        local function HideMinimapButtons()
            for _, button in ipairs(GetAllLibDBIconButtons()) do
                if button then
                    button:Hide()
                end
            end
            buttonAnchor:Hide()
        end

        C_Timer.After(0, function()
            ShowMinimapButtons()
            buttonAnchor:Hide()

            local buttons = GetAllLibDBIconButtons()
            for _, button in ipairs(buttons) do
                local name = button:GetName()

                if button == _G["LibDBIcon10_BugSack"] then
                    local btn = _G["BugSackLDB"]

                    hooksecurefunc(btn, "Update", function()
                        if not buttonAnchor:IsShown() then
                            if btn.icon == "Interface\\AddOns\\BugSack\\Media\\icon_red" then
                                button:ClearAllPoints()
                                button:SetParent(Minimap)
                                button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 10, -5)
                                button:SetFrameLevel(999)
                                button:Show()
                            elseif btn.icon == "Interface\\AddOns\\BugSack\\Media\\icon" then
                                ShowMinimapButtons()
                                buttonAnchor:Hide()
                            end
                        end
                    end)
                end

                local regions = { button:GetRegions() }
                local icon = regions[3]
                local borderIcon = regions[2]

                if borderIcon and borderIcon:IsObjectType("Texture") then
                    borderIcon:SetTexture("Interface\\AddOns\\RougeUI\\textures\\artifactforge")
                    borderIcon:SetTexCoord(0.216797, 0.324219, 0.826172, 0.879883)
                    borderIcon:ClearAllPoints()
                    borderIcon:SetPoint("CENTER", button, "CENTER")
                    borderIcon:SetSize(28, 28)
                    borderIcon:SetDrawLayer("OVERLAY", 1)
                    borderIcon:Show()
                    borderIcon:SetVertexColor(0.1, 0.1, 0.1, 1.0)
                end

                if icon and icon:IsObjectType("Texture") then
                    icon:ClearAllPoints()
                    icon:SetPoint("CENTER", button, "CENTER")
                    icon:SetSize(22, 22)
                    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                end
            end
        end)

        local toggleTrigger = CreateFrame("Frame", nil, topbg)
        toggleTrigger:SetSize(21, 21)
        toggleTrigger:SetPoint("BOTTOMRIGHT", topbg, "BOTTOMRIGHT", 2, 12)
        toggleTrigger:EnableMouse(true)

        local iconTexture = toggleTrigger:CreateTexture(nil, "OVERLAY")
        iconTexture:SetAllPoints()
        iconTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\transmogrify")
        iconTexture:SetSize(36, 30)
        iconTexture:SetTexCoord(0.507812, 0.578125, 0.300781, 0.359375)
        iconTexture:Show()

        C_Timer.After(45, function()
            toggleTrigger:SetAlpha(0)
        end)

        toggleTrigger:SetScript("OnMouseUp", function()
            showingButtons = not showingButtons
            if showingButtons then
                buttonAnchor:Show()
            else
                buttonAnchor:Hide()
            end
        end)

        toggleTrigger:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(toggleTrigger, "ANCHOR_TOPRIGHT")
            GameTooltip:SetText("Click to show or hide minimap buttons", 1, 1, 1)
            GameTooltip:Show()
            self:SetAlpha(1)
        end)

        toggleTrigger:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
            self:SetAlpha(0)
        end)

        -- Re-position bar when shown/hidden
        Minimap:HookScript("OnShow", function()
            topbg:ClearAllPoints()
            topbg:SetPoint("TOP", Minimap, "BOTTOM", 0, 21)

            toggleTrigger:ClearAllPoints()
            toggleTrigger:SetPoint("BOTTOMRIGHT", topbg, "BOTTOMRIGHT", 2, 12)
        end)

        Minimap:HookScript("OnHide", function()
            topbg:ClearAllPoints()
            topbg:SetPoint("TOP", MinimapCluster, "TOP", 0, -25)

            toggleTrigger:ClearAllPoints()
            toggleTrigger:SetPoint("TOPLEFT", topbg, "TOPLEFT", -20, 3)
            toggleTrigger:SetAlpha(1)
            C_Timer.After(5, function()
                toggleTrigger:SetAlpha(0)
            end)
        end)

        -- Ping snitch
        local pingTicker
        Minimap:RegisterEvent("MINIMAP_PING")
        Minimap:HookScript("OnEvent", function(self, event, unit)
            if event == "MINIMAP_PING" and unit ~= "player" then
                local name = UnitName(unit)
                if name then
                    MinimapZoneText:SetText(name)

                    local _, class = UnitClass(unit)
                    local c = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or RAID_CLASS_COLORS[class]
                    if c then
                        MinimapZoneText:SetTextColor(c.r, c.g, c.b)
                    end

                    if pingTicker then
                        pingTicker:Cancel()
                    end

                    pingTicker = C_Timer.NewTimer(2, function()
                        Minimap_Update()
                        pingTicker = nil
                    end)
                end
            end
        end)

        -- for other addons
        function GetMinimapShape()
            return "SQUARE"
        end
    elseif not (IsAddOnLoaded("SexyMap")) and addon == "Blizzard_GroupFinder_VanillaStyle" then
        if not RougeUI.db.minimapChanges then
            if LFGMinimapFrameBorder then
                LFGMinimapFrameBorder:SetVertexColor(colVal, colVal, colVal)
            end
        else
            local frame = LFGMinimapFrame
            if C_LFGList and not C_LFGList.HasActiveEntryInfo() then
                frame:SetAlpha(0)
            end

            local border = _G[frame:GetName() .. "Border"]
            if border then
                border:Hide()
            end

            -- Move to topleft corner
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -14, -6)

            -- Mouseover hide/show
            frame:HookScript("OnEnter", function(self)
                if self:GetAlpha() < 1 then
                    self:SetAlpha(1)
                end
            end)

            frame:HookScript("OnLeave", function(self)
                if C_LFGList and not C_LFGList.HasActiveEntryInfo() then
                    self:SetAlpha(0)
                end
            end)

            -- Hide by default, show when actively searching
            frame:HookScript("OnEvent", function(self, event)
                if event == "LFG_LIST_ACTIVE_ENTRY_UPDATE" then
                    if C_LFGList and C_LFGList.HasActiveEntryInfo() then
                        self:SetAlpha(1)
                    else
                        self:SetAlpha(0)
                    end
                end
            end)
        end
    end
end)

