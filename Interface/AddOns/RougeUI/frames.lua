local addonName, RougeUI = ...
local pairs = _G.pairs
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded

local function FrameColour()
    for _, v in pairs({
        PlayerFrameTexture,
        PlayerFrameAlternateManaBarBorder,
        PlayerFrameAlternateManaBarLeftBorder,
        PlayerFrameAlternateManaBarRightBorder,
        PlayerFrameAlternatePowerBarBorder,
        PlayerFrameAlternatePowerBarLeftBorder,
        PlayerFrameAlternatePowerBarRightBorder,
        TargetFrameTextureFrameTexture,
        TargetFrameToTTextureFrameTexture,
        PetFrameTexture,
        PartyMemberFrame1Texture,
        PartyMemberFrame2Texture,
        PartyMemberFrame3Texture,
        PartyMemberFrame4Texture,
        PartyMemberFrame1PetFrameTexture,
        PartyMemberFrame2PetFrameTexture,
        PartyMemberFrame3PetFrameTexture,
        PartyMemberFrame4PetFrameTexture,
        SlidingActionBarTexture0,
        SlidingActionBarTexture1,
        MainMenuBarTexture0,
        MainMenuBarTexture1,
        MainMenuBarTexture2,
        MainMenuBarTexture3,
        MainMenuMaxLevelBar0,
        MainMenuMaxLevelBar1,
        MainMenuMaxLevelBar2,
        MainMenuMaxLevelBar3,
        MainMenuXPBarTexture0,
        MainMenuXPBarTexture1,
        MainMenuXPBarTexture2,
        MainMenuXPBarTexture3,
        MainMenuXPBarTexture4,
        ReputationWatchBar.StatusBar.WatchBarTexture0,
        ReputationWatchBar.StatusBar.WatchBarTexture1,
        ReputationWatchBar.StatusBar.WatchBarTexture2,
        ReputationWatchBar.StatusBar.WatchBarTexture3,
        ReputationWatchBar.StatusBar.XPBarTexture0,
        ReputationWatchBar.StatusBar.XPBarTexture1,
        ReputationWatchBar.StatusBar.XPBarTexture2,
        ReputationWatchBar.StatusBar.XPBarTexture3,
        MinimapBorder,
        MirrorTimer1Border,
        MirrorTimer2Border,
        MirrorTimer3Border,
        MiniMapTrackingBorder,
        MiniMapLFGFrameBorder,
        MiniMapBattlefieldBorder,
        MiniMapMailBorder,
        MiniMapBorderTop,
        CastingBarFrame.Border,
        TargetFrameSpellBar.Border,
        Rune1BorderTexture,
        Rune2BorderTexture,
        Rune3BorderTexture,
        Rune4BorderTexture,
        Rune5BorderTexture,
        Rune6BorderTexture,
    }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        for _, v in pairs({
            FocusFrameToTTextureFrameTexture,
            FocusFrameTextureFrameTexture,
            FocusFrameSpellBar.Border,
        }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    CHAT_FONT_HEIGHTS = { 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 }

    for _, v in pairs({
        MainMenuBarLeftEndCap,
        MainMenuBarRightEndCap,
        StanceBarLeft,
        StanceBarMiddle,
        StanceBarRight,
        GameMenuFrameHeader,
        GameMenuFrame.BottomEdge,
        GameMenuFrame.BottomLeftCorner,
        GameMenuFrame.BottomRightCorner,
        GameMenuFrame.LeftEdge,
        GameMenuFrame.RightEdge,
        GameMenuFrame.TopEdge,
        GameMenuFrame.TopLeftCorner,
        GameMenuFrame.TopRightCorner,
        InterfaceOptionsFrameHeader,
        InterfaceOptionsFrame.BottomEdge,
        InterfaceOptionsFrame.BottomLeftCorner,
        InterfaceOptionsFrame.BottomRightCorner,
        InterfaceOptionsFrame.LeftEdge,
        InterfaceOptionsFrame.RightEdge,
        InterfaceOptionsFrame.TopEdge,
        InterfaceOptionsFrame.TopLeftCorner,
        InterfaceOptionsFrame.TopRightCorner,
        VideoOptionsFrameHeader,
        VideoOptionsFrame.BottomEdge,
        VideoOptionsFrame.BottomLeftCorner,
        VideoOptionsFrame.BottomRightCorner,
        VideoOptionsFrame.LeftEdge,
        VideoOptionsFrame.RightEdge,
        VideoOptionsFrame.TopEdge,
        VideoOptionsFrame.TopLeftCorner,
        VideoOptionsFrame.TopRightCorner,
        AddonListBotLeftCorner,
        AddonListBotRightCorner,
        AddonListBottomBorder,
        AddonListLeftBorder,
        AddonListRightBorder,
        AddonListTopBorder,
        AddonListTopLeftCorner,
        AddonListTopRightCorner,
        AddonListBtnCornerLeft,
        AddonListBtnCornerRight,
        AddonListButtonBottomBorder,
        AddonListInsetInsetTopBorder,
        AddonListInsetInsetTopRightCorner,
        AddonListInsetInsetRightBorder,
        AddonListInsetInsetBotRightCorner,
        AddonListInsetInsetBottomBorder,
        AddonListInsetInsetBotLeftCorner,
        AddonListInsetInsetLeftBorder,
        AddonListEnableAllButton_RightSeparator,
        AddonListDisableAllButton_RightSeparator,
        AddonListOkayButton_LeftSeparator,
        AddonListCancelButton_LeftSeparator,
        AddonCharacterDropDownLeft,
        AddonCharacterDropDownMiddle,
        AddonCharacterDropDownRight,
        AddonListBg,
        AddonListTitleBg,
        ExhaustionTickNormal,
        AddonListEnableAllButton_RightSeparator,
        AddonListDisableAllButton_RightSeparator,
        AddonListCancelButton_LeftSeparator,
        AddonListOkayButton_LeftSeparator,
        StaticPopup1.BottomEdge,
        StaticPopup1.BottomLeftCorner,
        StaticPopup1.BottomRightCorner,
        StaticPopup1.LeftEdge,
        StaticPopup1.RightEdge,
        StaticPopup1.TopEdge,
        StaticPopup1.TopLeftCorner,
        StaticPopup1.TopRightCorner,
        StaticPopup2.BottomEdge,
        StaticPopup2.BottomLeftCorner,
        StaticPopup2.BottomRightCorner,
        StaticPopup2.LeftEdge,
        StaticPopup2.RightEdge,
        StaticPopup2.TopEdge,
        StaticPopup2.TopLeftCorner,
        StaticPopup2.TopRightCorner,
        StaticPopup3.BottomEdge,
        StaticPopup3.BottomLeftCorner,
        StaticPopup3.BottomRightCorner,
        StaticPopup3.LeftEdge,
        StaticPopup3.RightEdge,
        StaticPopup3.TopEdge,
        StaticPopup3.TopLeftCorner,
        StaticPopup3.TopRightCorner,
        StaticPopup4.BottomEdge,
        StaticPopup4.BottomLeftCorner,
        StaticPopup4.BottomRightCorner,
        StaticPopup4.LeftEdge,
        StaticPopup4.RightEdge,
        StaticPopup4.TopEdge,
        StaticPopup4.TopLeftCorner,
        StaticPopup4.TopRightCorner,
        DropDownList1MenuBackdrop.BottomEdge,
        DropDownList1MenuBackdrop.BottomLeftCorner,
        DropDownList1MenuBackdrop.BottomRightCorner,
        DropDownList1MenuBackdrop.LeftEdge,
        DropDownList1MenuBackdrop.RightEdge,
        DropDownList1MenuBackdrop.TopEdge,
        DropDownList1MenuBackdrop.TopLeftCorner,
        DropDownList1MenuBackdrop.TopRightCorner,
        DropDownList2MenuBackdrop.BottomEdge,
        DropDownList2MenuBackdrop.BottomLeftCorner,
        DropDownList2MenuBackdrop.BottomRightCorner,
        DropDownList2MenuBackdrop.LeftEdge,
        DropDownList2MenuBackdrop.RightEdge,
        DropDownList2MenuBackdrop.TopEdge,
        DropDownList2MenuBackdrop.TopLeftCorner,
        DropDownList2MenuBackdrop.TopRightCorner,
        ContainerFrame1BackgroundTop,
        ContainerFrame1BackgroundMiddle1,
        ContainerFrame1BackgroundBottom,
        ContainerFrame2BackgroundTop,
        ContainerFrame2BackgroundMiddle1,
        ContainerFrame2BackgroundBottom,
        ContainerFrame3BackgroundTop,
        ContainerFrame3BackgroundMiddle1,
        ContainerFrame3BackgroundBottom,
        ContainerFrame4BackgroundTop,
        ContainerFrame4BackgroundMiddle1,
        ContainerFrame4BackgroundBottom,
        ContainerFrame5BackgroundTop,
        ContainerFrame5BackgroundMiddle1,
        ContainerFrame5BackgroundBottom,
        ContainerFrame6BackgroundTop,
        ContainerFrame6BackgroundMiddle1,
        ContainerFrame6BackgroundBottom,
        ContainerFrame7BackgroundTop,
        ContainerFrame7BackgroundMiddle1,
        ContainerFrame7BackgroundBottom,
        ContainerFrame8BackgroundTop,
        ContainerFrame8BackgroundMiddle1,
        ContainerFrame8BackgroundBottom,
        ContainerFrame9BackgroundTop,
        ContainerFrame9BackgroundMiddle1,
        ContainerFrame9BackgroundBottom,
        ContainerFrame10BackgroundTop,
        ContainerFrame10BackgroundMiddle1,
        ContainerFrame10BackgroundBottom,
        ContainerFrame11BackgroundTop,
        ContainerFrame11BackgroundMiddle1,
        ContainerFrame11BackgroundBottom,
        ContainerFrame12BackgroundTop,
        ContainerFrame12BackgroundMiddle1,
        ContainerFrame12BackgroundBottom,
        MerchantFrameInsetInsetBottomBorder,
        TradeFrameBg,
        TradeFrameBottomBorder,
        TradeFrameButtonBottomBorder,
        TradeFrameLeftBorder,
        TradeFrameRightBorder,
        TradeFrameTitleBg,
        TradeFrameTopBorder,
        TradeFrameTopRightCorner,
        TradeRecipientLeftBorder,
        TradeFrameBtnCornerLeft,
        TradeFrameBtnCornerRight,
        TradeRecipientBG,
        TradeFramePortraitFrame,
        TradeRecipientPortraitFrame,
        TradeRecipientBotLeftCorner,
        PVPReadyDialog.BottomEdge,
        PVPReadyDialog.BottomLeftCorner,
        PVPReadyDialog.BottomRightCorner,
        PVPReadyDialog.LeftEdge,
        PVPReadyDialog.RightEdge,
        PVPReadyDialog.TopEdge,
        PVPReadyDialog.TopLeftCorner,
        PVPReadyDialog.TopRightCorner,
        MailFrameBg,
        MailFrameBotLeftCorner,
        MailFrameBotRightCorner,
        MailFrameBottomBorder,
        MailFrameBtnCornerLeft,
        MailFrameBtnCornerRight,
        MailFrameButtonBottomBorder,
        MailFrameLeftBorder,
        MailFramePortraitFrame,
        MailFrameRightBorder,
        MailFrameTitleBg,
        MailFrameTopBorder,
        MailFrameTopLeftCorner,
        MailFrameTopRightCorner,
        MailFrameInsetInsetBottomBorder,
        MailFrameInsetInsetBotLeftCorner,
        MailFrameInsetInsetBotRightCorner,
        LootFrameBg,
        LootFrameRightBorder,
        LootFrameLeftBorder,
        LootFrameTopBorder,
        LootFrameBottomBorder,
        LootFrameTopRightCorner,
        LootFrameTopLeftCorner,
        LootFrameBotRightCorner,
        LootFrameBotLeftCorner,
        LootFrameInsetInsetTopRightCorner,
        LootFrameInsetInsetTopLeftCorner,
        LootFrameInsetInsetBotRightCorner,
        LootFrameInsetInsetBotLeftCorner,
        LootFrameInsetInsetRightBorder,
        LootFrameInsetInsetLeftBorder,
        LootFrameInsetInsetTopBorder,
        LootFrameInsetInsetBottomBorder,
        LootFramePortraitFrame,
        MerchantFrameTitleBg,
        MerchantFrameTopBorder,
        MerchantFrameBtnCornerRight,
        MerchantFrameBtnCornerLeft,
        MerchantFrameBottomRightBorder,
        MerchantFrameBottomLeftBorder,
        MerchantFrameButtonBottomBorder,
        MerchantFrameBg
    }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- Main MainMenu
    local gmbutton = {
        GameMenuButtonHelp = { GameMenuButtonHelp.Left, GameMenuButtonHelp.Middle, GameMenuButtonHelp.Right },
        GameMenuButtonStore = { GameMenuButtonStore.Left, GameMenuButtonStore.Middle, GameMenuButtonStore.Right },
        GameMenuButtonOptions = { GameMenuButtonOptions.Left, GameMenuButtonOptions.Middle, GameMenuButtonOptions.Right },
        GameMenuButtonMacros = { GameMenuButtonMacros.Left, GameMenuButtonMacros.Middle, GameMenuButtonMacros.Right },
        GameMenuButtonAddons = { GameMenuButtonAddons.Left, GameMenuButtonAddons.Middle, GameMenuButtonAddons.Right },
        GameMenuButtonLogout = { GameMenuButtonLogout.Left, GameMenuButtonLogout.Middle, GameMenuButtonLogout.Right },
        GameMenuButtonQuit = { GameMenuButtonQuit.Left, GameMenuButtonQuit.Middle, GameMenuButtonQuit.Right },
        GameMenuButtonContinue = { GameMenuButtonContinue.Left, GameMenuButtonContinue.Middle, GameMenuButtonContinue.Right },
        GameMenuButtonRatings = { GameMenuButtonRatings.Left, GameMenuButtonRatings.Middle, GameMenuButtonRatings.Right },
        GameMenuButtonUIOptions = { GameMenuButtonUIOptions.Left, GameMenuButtonUIOptions.Middle, GameMenuButtonUIOptions.Right },
        GameMenuButtonKeybindings = { GameMenuButtonKeybindings.Left, GameMenuButtonKeybindings.Middle, GameMenuButtonKeybindings.Right }

    }

    for _, v in pairs(gmbutton) do
        for _, j in pairs(v) do
            j:SetDesaturation(1 - RougeUI.db.Colval)
            j:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            if RougeUI.db.Colval < 0.8 then
                j:SetDesaturated(true)
            end
        end
    end

    -- SettingsPanel
    if SettingsPanel then
        for _, v in pairs({
            SettingsPanel.bg,
            SettingsPanel.Bg.TopSection,
            SettingsPanel.Bg.BottomEdge,
            SettingsPanel.Bg.BottomRight,
            SettingsPanel.Bg.BottomLeft,
            SettingsPanel.NineSlice.TopEdge,
            SettingsPanel.NineSlice.BottomEdge,
            SettingsPanel.NineSlice.LeftEdge,
            SettingsPanel.NineSlice.RightEdge,
            SettingsPanel.NineSlice.TopLeftCorner,
            SettingsPanel.NineSlice.TopRightCorner,
            SettingsPanel.NineSlice.BottomLeftCorner,
            SettingsPanel.NineSlice.BottomRightCorner,
            SettingsPanel.SearchBox.Left,
            SettingsPanel.SearchBox.Middle,
            SettingsPanel.SearchBox.Right,
        }) do
            v:SetDesaturation(1 - RougeUI.db.Colval)
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            if RougeUI.db.Colval < 0.8 then
                v:SetDesaturated(true)
            end
        end
    end

    if SettingsPanelTitleBg then
        SettingsPanelTitleBg:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end

    -- TotemFrame
    if TotemFrame then
        for i = 1, 4 do
            local _, totem = _G["TotemFrameTotem" .. i]:GetChildren()
            if totem then
                totem:GetRegions():SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- BankFrame
    if BankFrame then
        local a, b, c, d, e = BankFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- MerchantFrame
    if MerchantFrameTab1 then
        local a, b, c, d, e, f = MerchantFrameTab1:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if MerchantFrameTab2 then
        local a, b, c, d, e, f = MerchantFrameTab2:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if MerchantFrame then
        local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f, g, h, j, k }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- Paperdoll

    if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        if CharacterFrame then
            for _, v in ipairs({ CharacterFrame:GetRegions() }) do
                if v:IsObjectType("Texture") then
                    v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end

        if CharacterFrameInsetInsetBottomBorder then
            CharacterFrameInsetInsetBottomBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetLeftBorder then
            CharacterFrameInsetInsetLeftBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetRightBorder then
            CharacterFrameInsetInsetRightBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetBotLeftCorner then
            CharacterFrameInsetInsetBotLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetBotRightCorner then
            CharacterFrameInsetInsetBotRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetTopBorder then
            CharacterFrameInsetInsetTopBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetTopLeftCorner then
            CharacterFrameInsetInsetTopLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInsetInsetTopRightCorner then
            CharacterFrameInsetInsetTopRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInset.NineSlice.BottomEdge then
            CharacterFrameInset.NineSlice.BottomEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInset.NineSlice.LeftEdge then
            CharacterFrameInset.NineSlice.LeftEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if CharacterFrameInset.NineSlice.BottomLeftCorner then
            CharacterFrameInset.NineSlice.BottomLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end

        CharacterFramePortrait:SetVertexColor(1, 1, 1)
    end

    if PaperDollFrame then
        local a, b, c, d, _, e = PaperDollFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
            a:SetVertexColor(1, 1, 1)
        end
    end

    if PetPaperDollFrameCompanionFrame then
        local a, _, c = PetPaperDollFrameCompanionFrame:GetRegions()
        for _, v in pairs({ a, c }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if PetPaperDollFrame then
        local _, b, c, d, e = PetPaperDollFrame:GetRegions()
        for _, v in pairs({ b, c, d, e }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- TokenFrame

    if TokenFrame then
        local a, b, c, d = TokenFrame:GetRegions()
        for _, v in pairs({ a, b, c, d }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        for i = 1, 20 do
            local vertex = _G["TokenFrameContainerButton" .. i .. "Stripe"]
            if vertex then
                vertex:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- Skill

    if SkillFrame then
        local a, b, c, d = SkillFrame:GetRegions()
        for _, v in pairs({ a, b, c, d }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    --Reputation Frame

    if ReputationFrame then
        local a, b, c, d = ReputationFrame:GetRegions()
        for _, v in pairs({ a, b, c, d }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        ReputationFrameStandingLabel:SetVertexColor(1, 1, 1)
        ReputationFrameFactionLabel:SetVertexColor(1, 1, 1)
    end

    if ReputationDetailCorner and ReputationDetailDivider then
        for _, v in pairs({ ReputationDetailCorner, ReputationDetailDivider }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- PvPFrame

    if PVPFrame then

        local a, b, c, d, e, f, g, h = PVPFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f, g, h }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if HonorFrame then
        local a, b, c, d = HonorFrame:GetRegions()
        for _, v in pairs({ a, b, c, d }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- Character Tabs

    if CharacterFrameTab1 then
        local a, b, c, d, e, f = CharacterFrameTab1:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if CharacterFrameTab2 then
        local a, b, c, d, e, f = CharacterFrameTab2:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if CharacterFrameTab3 then
        local a, b, c, d, e, f = CharacterFrameTab3:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if CharacterFrameTab4 then
        local a, b, c, d, e, f = CharacterFrameTab4:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if CharacterFrameTab5 then
        local a, b, c, d, e, f = CharacterFrameTab5:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- Social Frame
    if FriendsFrame and FriendsFrameInset and WhoFrameListInset then
        local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
        for _, v in pairs({
            a, b, c, d, e, f, g, i, j, k, l, n, o, p, q, r,
            FriendsFrameInset:GetRegions(),
            WhoFrameListInset:GetRegions()
        }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if FriendsFrameInsetInsetBottomBorder then
        FriendsFrameInsetInsetBottomBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    if WhoFrameEditBoxInset then
        WhoFrameEditBoxInset:GetRegions():SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    if WhoFrameDropDownLeft then
        WhoFrameDropDownLeft:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    if WhoFrameDropDownMiddle then
        WhoFrameDropDownMiddle:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    if WhoFrameDropDownRight then
        WhoFrameDropDownRight:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end

    if WhoFrameEditBoxInset then
        local a, b, c, d, e, f, g, h, i = WhoFrameEditBoxInset:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f, g, h, i }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if FriendsFrameTab1 then
        local a, b, c, d, e, f = FriendsFrameTab1:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if FriendsFrameTab2 then
        local a, b, c, d, e, f = FriendsFrameTab2:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if FriendsFrameTab3 then
        local a, b, c, d, e, f = FriendsFrameTab3:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if FriendsFrameTab4 then
        local a, b, c, d, e, f = FriendsFrameTab4:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- GuildFrame

    if GuildFrame then
        local _, _, _, _, e, f = GuildFrame:GetRegions()
        for _, v in pairs({ e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- MailFrame

    if MailFrameTab1 then
        local a, b, c, d, e, f = MailFrameTab1:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if MailFrameTab2 then
        local a, b, c, d, e, f = MailFrameTab2:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    for i = 1, MAX_SKILLLINE_TABS do
        local vertex = _G["SpellBookSkillLineTab" .. i]:GetRegions()
        if vertex then
            vertex:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- Should remain untouched
    for _, v in pairs({
        BankPortraitTexture,
        BankFrameTitleText,
        WhoFrameTotals,
        MerchantFramePortrait
    }) do
        if v then
            v:SetVertexColor(1, 1, 1)
        end
    end

    if ChatFrame1EditBoxLeft then
        ChatFrame1EditBoxLeft:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    if ChatFrame1EditBoxMid then
        ChatFrame1EditBoxMid:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    if ChatFrame1EditBoxRight then
        ChatFrame1EditBoxRight:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end

    if GameTooltip then
        GameTooltip:SetBackdropBorderColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end

    if GetBuildInfo() >= "3.4.3" then
        if PVEFrame then
            for _, region in pairs({ PVEFrame:GetRegions() }) do
                if region and region:IsObjectType("Texture") then
                    region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
            for _, region in pairs({ PVEFrame.shadows:GetRegions() }) do
                if region and region:IsObjectType("Texture") then
                    region:SetVertexColor(0, 0, 0)
                end
            end
            for _, region in pairs({ LFDParentFrame:GetRegions() }) do
                if region and region:IsObjectType("Texture") then
                    region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
            for _, region in pairs({ LFDParentFrameInset:GetRegions() }) do
                if region and region:IsObjectType("Texture") then
                    region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
            for _, region in pairs({ LFGListFrame.CategorySelection.Inset:GetRegions() }) do
                if region and region:IsObjectType("Texture") then
                    region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
            if RaidFinderQueueFrame then
                for _, region in pairs({ RaidFinderQueueFrame:GetRegions() }) do
                    if region and region:IsObjectType("Texture") then
                        region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                    end
                end
                for _, region in pairs({ RaidFinderFrameRoleInset:GetRegions() }) do
                    if region and region:IsObjectType("Texture") then
                        region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                    end
                end
                for _, region in pairs({ RaidFinderFrameRoleInset.NineSlice:GetRegions() }) do
                    if region and region:IsObjectType("Texture") then
                        region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                    end
                end
            end
            LFDQueueFrameFindGroupButton_LeftSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            LFDQueueFrameFindGroupButton_RightSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            if PVEFrameLeftInsetInsetLeftBorder then
                PVEFrameLeftInsetInsetLeftBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if PVEFrameLeftInsetInsetBottomBorder then
                PVEFrameLeftInsetInsetBottomBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if PVEFrameLeftInsetInsetBotLeftCorner then
                PVEFrameLeftInsetInsetBotLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if PVEFrameLeftInset.NineSlice.BottomEdge then
                PVEFrameLeftInset.NineSlice.BottomEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if PVEFrameLeftInset.NineSlice.BottomLeftCorner then
                PVEFrameLeftInset.NineSlice.BottomLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if PVEFrameLeftInset.NineSlice.LeftEdge then
                PVEFrameLeftInset.NineSlice.LeftEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if RaidFinderFrameFindRaidButton_LeftSeparator then
                RaidFinderFrameFindRaidButton_LeftSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if RaidFinderFrameFindRaidButton_RightSeparator then
                RaidFinderFrameFindRaidButton_RightSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            LFGListFrame.CategorySelection.FindGroupButton.LeftSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            LFGListFrame.CategorySelection.StartGroupButton.RightSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            PVEFramePortrait:SetVertexColor(1, 1, 1)
        end
    end

    if CompactRaidFrameContainerBorderFrame then
        for _, region in pairs({ CompactRaidFrameContainerBorderFrame:GetRegions() }) do
            if region and region:IsObjectType("Texture") then
                region:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    for _, v in pairs({ ComboPoint1, ComboPoint2, ComboPoint3, ComboPoint4, ComboPoint5 }) do
        if v then
            v:GetRegions():SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end
    if FComboPoint1 then
        for _, v in pairs({ FComboPoint1, FComboPoint2, FComboPoint3, FComboPoint4, FComboPoint5 }) do
            if v then
                v:GetRegions():SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if CharacterHeadSlotFrame then
        for _, v in pairs({ "Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Shirt", "Tabard", "Hands", "Waist",
                            "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand", "Ranged" }) do
            local slotFrame = _G["Character" .. v .. "SlotFrame"]
            if slotFrame then
                slotFrame:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        local crs = { CharacterRangedSlot:GetRegions() }
        if crs[14] then
            crs[14]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        local cmh = { CharacterMainHandSlot:GetRegions() }
        if cmh[14] then
            cmh[14]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end

        if PaperDollInnerBorderRight then
            PaperDollInnerBorderRight:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if PaperDollInnerBorderLeft then
            PaperDollInnerBorderLeft:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if PaperDollInnerBorderTop then
            PaperDollInnerBorderTop:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if PaperDollInnerBorderBottom then
            PaperDollInnerBorderBottom:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if PaperDollInnerBorderBottom2 then
            PaperDollInnerBorderBottom2:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end
end

local function NewVariables()
    -- Rep bar
    for i = 1, 15 do
        local FrameBG = _G["ReputationBar" .. i .. "Background"]
        if FrameBG then
            FrameBG:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- SpellBookFrame
    local build = GetBuildInfo()
    if SpellBookFrame then
        local _, a, b, c, d, e, f, _, _, i, j, k, l, m, n, o, p = SpellBookFrame:GetRegions()
        local vars = {}
        if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
            vars = { a, c, d, e, f, i, j, k, l, m, n, o, p }
            if SpellBookFrameInsetInsetBottomBorder then
                SpellBookFrameInsetInsetBottomBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInsetInsetRightBorder then
                SpellBookFrameInsetInsetRightBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInsetInsetLeftBorder then
                SpellBookFrameInsetInsetLeftBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInsetInsetBotRightCorner then
                SpellBookFrameInsetInsetBotRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInsetInsetBotLeftCorner then
                SpellBookFrameInsetInsetBotLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInset.NineSlice.BottomEdge then
                SpellBookFrameInset.NineSlice.BottomEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInset.NineSlice.BottomLeftCorner then
                SpellBookFrameInset.NineSlice.BottomLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInset.NineSlice.RightEdge then
                SpellBookFrameInset.NineSlice.RightEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameInset.NineSlice.LeftEdge then
                SpellBookFrameInset.NineSlice.LeftEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameBotRightCorner then
                SpellBookFrameBotRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if SpellBookFrameRightBorner then
                SpellBookFrameRightBorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        else
            vars = { a, b, c, d }
        end
        for _, v in pairs(vars) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if not SpellBookFrame.Material and WOW_PROJECT_ID ~= WOW_PROJECT_CATACLYSM_CLASSIC then
        SpellBookFrame.Material = SpellBookFrame:CreateTexture(nil, "OVERLAY", nil, 7)
        SpellBookFrame.Material:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\QuestBG.tga")
        SpellBookFrame.Material:SetWidth(547)
        SpellBookFrame.Material:SetHeight(541)
        SpellBookFrame.Material:SetPoint("TOPLEFT", SpellBookFrame, 22, -74)
        SpellBookFrame.Material:SetVertexColor(.9, .9, .9)
    end

    -- QuestLogFrame

    local _, b, c, d, e, f = QuestLogFrame:GetRegions()
    for _, v in pairs({ b, c, e }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        b:SetVertexColor(1, 1, 1)
        d:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        f:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end

    if (IsAddOnLoaded("WideQuestLog")) then
        QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
        QuestLogFrame.Material:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\QuestBG.tga")
        QuestLogFrame.Material:SetWidth(524)
        QuestLogFrame.Material:SetHeight(553)
        QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, -10, 0)
        QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
    else
        QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
        QuestLogFrame.Material:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\QuestBG.tga")
        QuestLogFrame.Material:SetWidth(514)
        QuestLogFrame.Material:SetHeight(400)
        QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, 0, 0)
        QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
    end

    for _, v in pairs({
        GossipFrame.GreetingPanel,
        QuestFrameRewardPanel,
        QuestFrameDetailPanel,
        QuestFrameProgressPanel,
        QuestFrameGreetingPanel,
    }) do
        for _, j in pairs({ v:GetRegions() }) do
            if j then
                j:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        if not v.Material then
            v.Material = v:CreateTexture(nil, "OVERLAY", nil, 7)
            v.Material:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\QuestBG.tga")
            v.Material:SetWidth(514)
            v.Material:SetHeight(522)
            v.Material:SetPoint("TOPLEFT", v, 22, -74)
            v.Material:SetVertexColor(.9, .9, .9)
        end

        if v == GossipFrame.GreetingPanel or v == QuestFrameGreetingPanel then
            v.Corner = v:CreateTexture(nil, "OVERLAY", nil, 7)
            v.Corner:SetTexture("Interface\\QuestFrame\\UI-Quest-BotLeftPatch")
            v.Corner:SetSize(132, 64)
            v.Corner:SetPoint("BOTTOMLEFT", v, 21, 68)
            v.Corner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- Wardrobe
    local _, a, b, c, d, e = DressUpFrame:GetRegions()
    for _, v in pairs({ a, b, c, d, e }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    if DressUpFrameTitleText then
        DressUpFrameTitleText:SetVertexColor(1, 1, 1)
    end

    -- Readycheck
    local _, a = ReadyCheckListenerFrame:GetRegions()
    if a then
        a:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end

    -- Scoreboard
    local a, b, c, d, e, f, _, h, _, _, _, l = WorldStateScoreFrame:GetRegions()
    local wscf = { a, b, c, d, e, f, l }
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        wscf = { a, b, c, d, e, f, h }
    end
    for _, v in pairs(wscf) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- Taxiframe
    local _, a, b, c, d = TaxiFrame:GetRegions()
    for _, v in pairs({ a, b, c, d }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- TabardFrame
    local _, a, b, c, d = TabardFrame:GetRegions()
    for _, v in pairs({ a, b, c, d, e }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- PetStable
    for _, v in pairs({ PetStableFrame:GetRegions() }) do
        if v:GetObjectType() == "Texture" and v ~= PetStableFramePortrait then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    if PetLevelText then
        PetLevelText:SetVertexColor(1, 1, 1)
    end

    if ContainerFrame1PortraitButton then
        local mask = ContainerFrame1PortraitButton:CreateMaskTexture()
        mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
        mask:SetAllPoints(ContainerFrame1Portrait)

        local overlay = ContainerFrame1PortraitButton:CreateTexture(nil, "OVERLAY")
        overlay:SetTexture(133633)
        overlay:SetAllPoints(ContainerFrame1Portrait)
        overlay:AddMaskTexture(mask)
        overlay:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    end

    for i = 0, 3 do
        local snt = _G["CharacterBag" .. i .. "SlotNormalTexture"]
        if snt then
            snt:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    if CommunitiesFrame then
        for _, v in pairs({ CommunitiesFrame:GetRegions() }) do
            if v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        CommunitiesFrame.PortraitOverlay.Portrait:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end
end

local function BlizzFrames(addon)
    -- GlyphFrame
    if addon == "Blizzard_GlyphUI" then
        local a, _, c, d, e, f, g, h, i = GlyphFrame:GetRegions()
        for _, v in pairs({ a, c, d, e, f, g, h, i }) do
            if v then
                if RougeUI.db.Colval <= 0.5 then
                    v:SetVertexColor(.5, .5, .5)
                else
                    v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end
    end

    -- CalendarFrame
    if addon == "Blizzard_Calendar" then
        local vectors = { CalendarFrame:GetRegions() }
        for i = 1, 13 do
            if vectors[i] then
                vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if addon == "Blizzard_BindingUI" then
        -- KeyBindingFrame
        local vectors = { KeyBindingFrame:GetRegions() }
        for i = 1, 1 do
            if vectors[i] then
                vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        for i = 1, 10 do
            local vectors = { KeyBindingFrame.header:GetRegions() }
            if vectors[i] then
                vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        for _, v in pairs({
            KeyBindingFrame.BottomEdge,
            KeyBindingFrame.TopEdge,
            KeyBindingFrame.LeftEdge,
            KeyBindingFrame.RightEdge,
            KeyBindingFrame.BottomLeftCorner,
            KeyBindingFrame.TopLeftCorner,
            KeyBindingFrame.BottomRightCorner,
            KeyBindingFrame.TopRightCorner,
            KeyBindingFrameBottomBorder,
            KeyBindingFrameTopBorder,
            KeyBindingFrameRightBorder,
            KeyBindingFrameLeftBorder,
            KeyBindingFrameBottomLeftCorner,
            KeyBindingFrameBottomRightCorner,
            KeyBindingFrameTopLeftCorner,
            KeyBindingFrameTopRightCorner,
        }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if addon == "Blizzard_TimeManager" then
        for _, v in pairs({ StopwatchFrame:GetRegions() }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        local a, b, c = StopwatchTabFrame:GetRegions()
        for _, v in pairs({ a, b, c }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r = TimeManagerFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    --RECOLOR Achievement

    if addon == "Blizzard_AchievementUI" then
        local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o = AchievementFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f, g, h, i, j, k, l, m, n, o }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- Barber
    if addon == "Blizzard_BarbershopUI" then
        local a, b, c = BarberShopFrame:GetRegions()
        for _, v in pairs({ a, b, c }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- Talentframe

    if addon == "Blizzard_TalentUI" then
        local _, a, b, c, d, _, _, _, _, _, e, f, g = PlayerTalentFrame:GetRegions()

        for _, v in pairs({ a, b, c, d, e, f, g }) do
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end

    -- Tradeskill
    if addon == "Blizzard_TradeSkillUI" then
        local _, b, c, d, e, f, g, h, i, j = TradeSkillFrame:GetRegions()
        local tsui = { b, c, d, e, f, h, i }
        if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            tsui = { b, c, d, e, g, h, i, j }
        end
        for _, v in pairs(tsui) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- ClassTrainerFrame
    if addon == "Blizzard_TrainerUI" then
        local _, a, b, c, d, _, e, f, g, h = ClassTrainerFrame:GetRegions()

        for _, v in pairs({ a, b, c, d, e, f, g, h }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    -- InspectFrame/InspectTalentFrame/InspectPVPFrame

    if addon == "Blizzard_InspectUI" then
        for _, v in pairs({
            InspectTalentFramePointsBarBorderLeft,
            InspectTalentFramePointsBarBorderMiddle,
            InspectTalentFramePointsBarBorderRight,
            InspectTalentFramePointsBarBackground,
            InspectFrameTab1LeftDisabled,
            InspectFrameTab1MiddleDisabled,
            InspectFrameTab1RightDisabled,
            InspectFrameTab2LeftDisabled,
            InspectFrameTab2MiddleDisabled,
            InspectFrameTab2RightDisabled,
            InspectFrameTab3LeftDisabled,
            InspectFrameTab3MiddleDisabled,
            InspectFrameTab3RightDisabled,
            InspectTalentFrameTab1Left,
            InspectTalentFrameTab1Right,
            InspectTalentFrameTab1Middle,
            InspectTalentFrameTab1LeftDisabled,
            InspectTalentFrameTab1MiddleDisabled,
            InspectTalentFrameTab1RightDisabled,
            InspectTalentFrameTab2Left,
            InspectTalentFrameTab2Right,
            InspectTalentFrameTab2Middle,
            InspectTalentFrameTab2LeftDisabled,
            InspectTalentFrameTab2MiddleDisabled,
            InspectTalentFrameTab2RightDisabled,
            InspectTalentFrameTab3Left,
            InspectTalentFrameTab3Right,
            InspectTalentFrameTab3Middle,
            InspectTalentFrameTab3LeftDisabled,
            InspectTalentFrameTab3MiddleDisabled,
            InspectTalentFrameTab3RightDisabled,
        }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        if InspectPaperDollFrame then
            local vectors = { InspectPaperDollFrame:GetRegions() }
            for i = 1, 4 do
                if vectors[i] then
                    vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end

        if InspectPVPFrame then
            local vectors = { InspectPVPFrame:GetRegions() }
            for i = 1, 5 do
                if vectors[i] then
                    vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end

        if InspectHonorFrame then
            local a, b, c, d = InspectHonorFrame:GetRegions()
            for _, v in pairs({ a, b, c, d }) do
                if v then
                    v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end

        if InspectTalentFrame then
            local vectors = { InspectTalentFrame:GetRegions() }
            for i = 1, 5 do
                if vectors[i] then
                    vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end

        if InspectTalentFrameScrollFrame then
            local vectors = { InspectTalentFrameScrollFrame:GetRegions() }
            for i = 1, 2 do
                if vectors[i] then
                    vectors[i]:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
            end
        end
    end

    -- Macro's
    if addon == "Blizzard_MacroUI" then
        local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r = MacroFrame:GetRegions()
        for _, v in pairs({ a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        for _, v in pairs({
            MacroFrameTab1Left,
            MacroFrameTab1Right,
            MacroFrameTab1Middle,
            MacroFrameTab1LeftDisabled,
            MacroFrameTab1MiddleDisabled,
            MacroFrameTab1RightDisabled,
            MacroFrameTab2Left,
            MacroFrameTab2Right,
            MacroFrameTab2Middle,
            MacroFrameTab2LeftDisabled,
            MacroFrameTab2MiddleDisabled,
            MacroFrameTab2RightDisabled,
        }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if addon == "Blizzard_ArenaUI" then
        for _, v in pairs({
            ArenaEnemyFrame1Texture,
            ArenaEnemyFrame2Texture,
            ArenaEnemyFrame3Texture,
            ArenaEnemyFrame4Texture,
            ArenaEnemyFrame5Texture,
            ArenaEnemyFrame1SpecBorder,
            ArenaEnemyFrame2SpecBorder,
            ArenaEnemyFrame3SpecBorder,
            ArenaEnemyFrame4SpecBorder,
            ArenaEnemyFrame5SpecBorder,
            ArenaEnemyFrame1PetFrameTexture,
            ArenaEnemyFrame2PetFrameTexture,
            ArenaEnemyFrame3PetFrameTexture,
            ArenaEnemyFrame4PetFrameTexture,
            ArenaEnemyFrame5PetFrameTexture,
            ArenaPrepFrame1Texture,
            ArenaPrepFrame2Texture,
            ArenaPrepFrame3Texture,
            ArenaPrepFrame4Texture,
            ArenaPrepFrame5Texture,
            ArenaPrepFrame1SpecBorder,
            ArenaPrepFrame2SpecBorder,
            ArenaPrepFrame3SpecBorder,
            ArenaPrepFrame4SpecBorder, }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        RougeUI.RougeUIF:CusFonts()
    end

    if addon == "Blizzard_Collections" then
        for _, v in pairs({ CollectionsJournal:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ MountJournal:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ MountJournal.RightInset:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ MountJournal.LeftInset:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ PetJournal:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ PetJournalRightInset:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ PetJournalLeftInset:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        CollectionsJournalTitleText:SetVertexColor(1, 1, 1)
        CollectionsJournalPortrait:SetVertexColor(1, 1, 1)
        if MountJournalInsetBottomBorder then
            MountJournalInsetBottomBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if MountJournalInsetBotRightCorner then
            MountJournalInsetBotRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if MountJournal then
            if MountJournal.RightInset.NineSlice.BottomEdge then
                MountJournal.RightInset.NineSlice.BottomEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if MountJournal.RightInset.NineSlice.RightEdge then
                MountJournal.RightInset.NineSlice.RightEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if MountJournal.RightInset.NineSlice.TopEdge then
                MountJournal.RightInset.NineSlice.TopEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if MountJournal.RightInset.NineSlice.BottomLeftCorner then
                MountJournal.RightInset.NineSlice.BottomLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if MountJournal.LeftInset.NineSlice.BottomEdge then
                MountJournal.LeftInset.NineSlice.BottomEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
            if MountJournalMountButton_RightSeparator then
                MountJournalMountButton_RightSeparator:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if addon == "Blizzard_Communities" then
        for _, v in pairs({ CommunitiesFrame:GetRegions() }) do
            if v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end

        CommunitiesFrame.PortraitOverlay.Portrait:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end

    if addon == "Blizzard_EncounterJournal" then
        for _, v in pairs({ EncounterJournal:GetRegions() }) do
            if v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        for _, v in pairs({ EncounterJournalInset.NineSlice:GetRegions() }) do
            if v and v:IsObjectType("Texture") then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
        if EncounterJournalNavBarInsetBottomBorder then
            EncounterJournalNavBarInsetBottomBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if EncounterJournalNavBarInsetLeftBorder then
            EncounterJournalNavBarInsetLeftBorder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        if EncounterJournalNavBarInsetBotLeftCorner then
            EncounterJournalNavBarInsetBotLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
        EncounterJournalPortrait:SetVertexColor(1, 1, 1)
    end

    if addon == "Blizzard_EngravingUI" then
        if EngravingFrame then
            EngravingFrame.Border.NineSlice.TopEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.Center:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.BottomEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.LeftEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.RightEdge:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.TopLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.TopRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.BottomRightCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            EngravingFrame.Border.NineSlice.BottomLeftCorner:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end
end

local Framecolor = CreateFrame("Frame")
Framecolor:RegisterEvent("ADDON_LOADED")
Framecolor:SetScript("OnEvent", function(self, event, addon)
    if addon == addonName then
        if RougeUI.db.Colval < 1 then
            FrameColour()
            NewVariables()
        end

        if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
            -- Blizz lack of quality control
            MainMenuExpBar:SetSize(1034, 13);
            MainMenuXPBarTexture0:SetSize(262, 10);
            MainMenuXPBarTexture1:SetSize(262, 10);
            MainMenuXPBarTexture2:SetSize(262, 10);
            MainMenuXPBarTexture3:SetSize(262, 10);
            MainMenuXPBarTexture0:SetPoint("BOTTOM", -391, 3);
            MainMenuXPBarTexture1:SetPoint("BOTTOM", -130, 3);
            MainMenuXPBarTexture2:SetPoint("BOTTOM", 130, 3);
            MainMenuXPBarTexture3:SetPoint("BOTTOM", 391, 3);
            MainMenuMaxLevelBar0:SetPoint("CENTER", -391, 4)
            MainMenuMaxLevelBar0:SetSize(261, 7)
            MainMenuMaxLevelBar1:SetSize(261, 7)
            MainMenuMaxLevelBar2:SetSize(261, 7)
            MainMenuMaxLevelBar3:SetSize(261, 7)
            MainMenuBarTextureExtender:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            MainMenuBarTexture3:SetSize(281, 43)
            MainMenuBarTexture3:SetPoint("BOTTOM", 379, 0);
            CharacterMicroButton:SetPoint("BOTTOMLEFT", 549, 2)
            CharacterMainHandSlot:SetPoint("BOTTOMLEFT", 109, 16)
        end
    else
        BlizzFrames(addon)
    end

    C_Timer.After(0, function()
        for i = 0, 3 do
            local snt = _G["CharacterBag" .. i .. "SlotNormalTexture"]
            if snt then
                snt:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end)
end)

function RougeUI.RougeUIF:ChangeFrameColors()
    FrameColour()
    NewVariables()
    BlizzFrames()
end

