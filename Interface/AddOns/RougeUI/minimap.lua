local _, RougeUI = ...
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local GetCVar = C_CVar and C_CVar.GetCVar or GetCVar
local MinimapBorderTop = MinimapBorderTop or MinimapCluster.BorderTop

local MM = CreateFrame("Frame")
MM:RegisterEvent("ADDON_LOADED")
MM:SetScript("OnEvent", function(self, event, addon)
    local colVal = RougeUI.db.Colval

    if not (IsAddOnLoaded("SexyMap") or IsAddOnLoaded("Leatrix_Plus") and (LeaPlusDB["MinimapModder"] == "On")) and addon == "Blizzard_TimeManager" then
        TimeManagerClockButton:GetRegions():SetVertexColor(colVal, colVal, colVal)

        if not RougeUI.db.minimapChanges or GetCVar("rotateMinimap") == "1" then
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
            --MinimapBorderTop,
            MinimapToggleButton,
            MinimapZoomIn,
            MinimapZoomOut,
            MinimapNorthTag,
            MiniMapMailBorder,
            MinimapBorder,
            GameTimeFrame, -- tbc
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

        if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            calendar:Hide()
        else
            calendar:ClearAllPoints()
            calendar:SetParent(Minimap)
            calendar:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 4, -30)
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
                if not focus then
                    return
                end

                if not FindParent(focus, self) then
                    self:SetAlpha(0)
                end
            end)

            if calendar:HasScript("OnClick") then
                calendar:HookScript("OnClick", function()
                    calendar:SetAlpha(0)
                end)
            end
        end

        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint("TOPRIGHT", 6.5, -15)
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

        -- Square minimap
        local MinimapSize = 175
        Minimap:SetMaskTexture("Interface\\AddOns\\RougeUI\\textures\\rectangle")
        MinimapBorderTop:SetTexture(0)
        Minimap:SetSize(MinimapSize, MinimapSize) -- limit
        Minimap:SetHitRectInsets(0, 0, 24, 24)
        local p, r, rp, ofx, ofy = Minimap:GetPoint()
        Minimap:ClearAllPoints()
        Minimap:SetPoint(p, r, rp, ofx - 10, ofy)

        -- New border
        local bg = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
        bg:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, -21)
        bg:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, 21)
        bg:SetBackdrop({ edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND", edgeSize = 2 })
        bg:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.7)
        bg:SetBackdropColor(0.1, 0.1, 0.1)

        local topbg = CreateFrame("Frame", nil, MinimapCluster, "BackdropTemplate")
        topbg:SetParent(Minimap)
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
        local mpIcon = MiniMapBattlefieldIcon
        if MiniMapBattlefieldBorder then
            MiniMapBattlefieldBorder:Hide()
        elseif MiniMapBattlefieldFrameBorder then -- MoP abomination
            MiniMapBattlefieldFrameBorder:Hide()
            mpIcon = MiniMapBattlefieldFrameIconTexture
            MiniMapBattlefieldFrameIcon:SetScript("OnUpdate", nil)
        end
        MiniMapBattlefieldFrame:ClearAllPoints()
        MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, 20)
        if C_Texture.GetAtlasInfo("charactercreate-icon-horde") and mpIcon then
            local atlasTex = (UnitFactionGroup("player") == "Horde" and "charactercreate-icon-horde") or "charactercreate-icon-alliance"
            if atlasTex then
                mpIcon:SetAtlas(atlasTex)
                hooksecurefunc(mpIcon, "SetTexture", function(self)
                    self:SetAtlas(atlasTex)
                    self:SetSize(40, 40)
                end)
            end
        end

        -- Reposition LFG Button
        if MiniMapLFGFrame then
            MiniMapLFGFrame:ClearAllPoints()
            MiniMapLFGFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -14, -6)
            MiniMapLFGFrameBorder:Hide()
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
        local LibDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)
        if not LibDBIcon or IsAddOnLoaded("HidingBar") or IsAddOnLoaded("MBB") or IsAddOnLoaded("MinimapButtonButton") then
            return
        end

        local buttonsPerRow = 6
        local spacing = 32
        local scale = 0.9
        local allButtons = {}
        local showingButtons = false

        local buttonAnchor = CreateFrame("Frame", "RougeMMAnchor", MinimapCluster)
        buttonAnchor:SetPoint("TOPLEFT", topbg, "BOTTOMLEFT", -2, 0)
        buttonAnchor:SetSize(1, 1)
        buttonAnchor:Hide()

        local function ShowMinimapButtons()
            local row, col = 0, 0
            for _, button in ipairs(allButtons) do
                if button and button:IsObjectType("Button") then
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", buttonAnchor, "TOPLEFT", col * spacing, -row * spacing)
                    button:SetParent(buttonAnchor)
                    button:SetScale(scale)
                    button:Show()

                    col = col + 1
                    if col >= buttonsPerRow then
                        col = 0
                        row = row + 1
                    end
                end
            end
            buttonAnchor:Show()
            showingButtons = true
        end

        local function HideMinimapButtons()
            for _, button in ipairs(allButtons) do
                if button and button:IsObjectType("Button") then
                    button:Hide()
                end
            end
            buttonAnchor:Hide()
            showingButtons = false
        end

        local drawLayerOrder = {
            BACKGROUND = 1,
            BORDER = 2,
            ARTWORK = 3,
            OVERLAY = 4,
            HIGHLIGHT = 5
        }

        local function FindIconAndBorder(button)
            local textures = {}
            for _, region in ipairs({ button:GetRegions() }) do
                if region:IsObjectType("Texture") then
                    local layer = region:GetDrawLayer()
                    table.insert(textures, {
                        texture = region,
                        layer = drawLayerOrder[layer or ""] or 99
                    })
                end
            end

            table.sort(textures, function(a, b)
                return a.layer < b.layer
            end)

            local icon, borderIcon
            if textures[1] then icon = textures[1].texture end
            if textures[2] and textures[2].layer > textures[1].layer then
                borderIcon = textures[2].texture
            end

            return icon, borderIcon
        end

        C_Timer.After(0, function()
            local redSack = nil

            -- LibDBIcon buttons
            for name, button in pairs(LibDBIcon.objects or {}) do
                if button and button:IsObjectType("Button") and button:GetName() and button:GetName():match("^LibDBIcon10_") then
                    table.insert(allButtons, button)
                    button:Hide()

                    local regions = { button:GetRegions() }
                    local icon = button.icon or regions[3]
                    local borderIcon = regions[2]

                    -- Bugsack hook
                    if name == "BugSack" and BugSack then
                        hooksecurefunc(BugSack, "UpdateDisplay", function()
                            if not buttonAnchor:IsShown() then
                                if not redSack then
                                    redSack = button:CreateTexture()
                                    redSack:SetTexture("Interface\\AddOns\\BugSack\\Media\\icon_red")
                                end

                                if icon:GetTexture() == redSack:GetTexture() then
                                    button:ClearAllPoints()
                                    button:SetParent(Minimap)
                                    button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 10, -5)
                                    button:SetFrameLevel(999)
                                    button:Show()
                                else
                                    ShowMinimapButtons()
                                    HideMinimapButtons()
                                end
                            end
                        end)
                    end

                    if borderIcon and borderIcon:IsObjectType("Texture") then
                        borderIcon:SetAtlas("Forge-ColorSwatchBorder")
                        borderIcon:ClearAllPoints()
                        borderIcon:SetPoint("CENTER", button, "CENTER")
                        borderIcon:SetSize(28, 28)
                        borderIcon:SetDrawLayer("OVERLAY", 1)
                        borderIcon:Show()
                        borderIcon:SetVertexColor(0.1, 0.1, 0.1, 1.0)

                        local bgTex = button:CreateTexture(nil, "BACKGROUND", nil, -8)
                        bgTex:SetColorTexture(0, 0, 0, 0.7)
                        bgTex:SetSize(22, 22)
                        bgTex:SetPoint("CENTER", button, "CENTER")
                    end

                    if icon and icon:IsObjectType("Texture") then
                        icon:ClearAllPoints()
                        icon:SetPoint("CENTER", button, "CENTER")
                        icon:SetSize(22, 22)
                        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                    end
                end
            end

            -- Collect other minimap buttons
            for _, child in ipairs({ Minimap:GetChildren() }) do
                if child:IsObjectType("Button")
                        and not child:IsProtected()
                        and child:HasScript("OnClick")
                        and child:GetWidth() <= 35
                        and child:GetHeight() <= 35
                        and (not child:GetName() or not child:GetName():match("^LibDBIcon10_"))
                        and child:IsShown()
                then
                    local name = child:GetName() or ""
                    if not name:find("GameTimeFrame") and not name:find("Zoom") and not name:find("MiniMapTrackingButton")
                    and not name:find("MiniMapBattlefieldFrame" ) and not name:find("LFGMinimapFrame")
                            and not name:find("MiniMapMailFrame") then
                        table.insert(allButtons, child)
                        child:Hide()

                        local icon, borderIcon = FindIconAndBorder(child)

                        -- Styling
                        borderIcon = borderIcon or child:CreateTexture(nil, "OVERLAY", nil, 1)

                        if borderIcon then
                            borderIcon:SetTexture("Interface\\AddOns\\RougeUI\\textures\\artifactforge")
                            borderIcon:SetTexCoord(0.216797, 0.324219, 0.826172, 0.879883)
                            borderIcon:ClearAllPoints()
                            borderIcon:SetPoint("CENTER", child, "CENTER")
                            borderIcon:SetSize(28, 28)
                            borderIcon:SetDrawLayer("OVERLAY", 1)
                            borderIcon:Show()
                            borderIcon:SetVertexColor(0.1, 0.1, 0.1, 1.0)
                        end

                        local bgTex = child:CreateTexture(nil, "BACKGROUND", nil, -8)
                        bgTex:SetColorTexture(0, 0, 0, 0.7)
                        bgTex:SetSize(22, 22)
                        bgTex:SetPoint("CENTER", child, "CENTER")

                        if icon then
                            icon:ClearAllPoints()
                            icon:SetPoint("CENTER", child, "CENTER")
                            icon:SetSize(22, 22)
                            icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                        end
                    end
                end
            end

            HideMinimapButtons()
        end)

        local toggleTrigger = CreateFrame("Frame", nil, topbg)
        toggleTrigger:SetSize(21, 21)
        toggleTrigger:SetPoint("BOTTOMRIGHT", topbg, "BOTTOMRIGHT", 2, 12)
        toggleTrigger:EnableMouse(true)

        local iconTexture = toggleTrigger:CreateTexture(nil, "OVERLAY")
        iconTexture:SetAllPoints()
        iconTexture:SetAtlas("transmog-icon-hidden")
        iconTexture:Show()

        C_Timer.After(45, function()
            toggleTrigger:SetAlpha(0)
        end)

        toggleTrigger:SetScript("OnMouseUp", function()
            showingButtons = not showingButtons
            if showingButtons then
                ShowMinimapButtons()
            else
                HideMinimapButtons()
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
                        if class == "SHAMAN" then
                            MinimapZoneText:SetTextColor(0.0, 0.44, 0.87)
                        else
                            MinimapZoneText:SetTextColor(c.r, c.g, c.b)
                        end
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
        function GetMinimapShape() return "SQUARE" end
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

            local border = _G[frame:GetName().."Border"]
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

