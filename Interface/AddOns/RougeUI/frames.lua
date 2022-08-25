local function FrameColour()
		for i,v in pairs({
			PlayerFrameTexture,
			PlayerFrameAlternateManaBarBorder,
			PlayerFrameAlternateManaBarLeftBorder,
			PlayerFrameAlternateManaBarRightBorder,
			PlayerFrameAlternatePowerBarBorder,
			PlayerFrameAlternatePowerBarLeftBorder,
			PlayerFrameAlternatePowerBarRightBorder,
			TargetFrameTextureFrameTexture,
			TargetFrameToTTextureFrameTexture,
			FocusFrameToTTextureFrameTexture,
			FocusFrameTextureFrameTexture,
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
			FocusFrameSpellBar.Border,
			}) do
				v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
		end

CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

for i, v in pairs({
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
	AddonList.BotLeftCorner,
	AddonList.BotRightCorner,
	AddonList.BottomBorder,
	AddonList.LeftBorder,
	AddonList.RightBorder,
	AddonList.TopBorder,
	AddonList.TopLeftCorner,
	AddonList.TopRightCorner,
	AddonListBtnCornerLeft,
	AddonListBtnCornerRight,
	AddonListBg,
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
   v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
end

for i,v in pairs({
	BankPortraitTexture,
	BankFrameTitleText,
	MerchantFramePortrait,
	WhoFrameTotals
}) do
   v:SetVertexColor(1, 1, 1)
end

	-- BankFrame
	local a, b, c, d, _, e = BankFrame:GetRegions()
	for _, v in pairs({a, b, c, d, e}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- MerchantFrame
	local a, b, c, d, e, f, g, h = MerchantFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = MerchantFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
	for _, v in pairs({a, b, c ,d, e, f, g, h, j, k}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- Paperdoll

	local a, b, c, d = PetPaperDollFrameCompanionFrame:GetRegions()
	for _, v in pairs({a, c}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local _, b, c, d, e, f = PetPaperDollFrame:GetRegions()
	for _, v in pairs({b, c, d, e}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- TokenFrame

	local a, b, c, d = TokenFrame:GetRegions()
	for _, v in pairs({a, b, c, d}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- Skill

	local a, b, c, d = SkillFrame:GetRegions()
	for _, v in pairs({a, b, c ,d}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	--Reputation Frame

	local a, b, c, d = ReputationFrame:GetRegions()
	for _, v in pairs({a, b, c, d}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider}) do
     		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- PvPFrame

	local _, _, c, d, e, f, g, h = PVPFrame:GetRegions()
	for _, v in pairs({c, d, e, f, g, h }) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- Character Tabs

	local a, b, c, d, e, f, g, h = CharacterFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = CharacterFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = CharacterFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = CharacterFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end


	local a, b, c, d, e, f, g, h = CharacterFrameTab5:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- Social Frame
	local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r, FriendsFrameInset:GetRegions()}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	FriendsFrameInsetInsetBottomBorder:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	WhoFrameEditBoxInset:GetRegions():SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	WhoFrameDropDownLeft:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	WhoFrameDropDownMiddle:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	WhoFrameDropDownRight:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

	local a, b, c, d, e, f, g, h, i = WhoFrameEditBoxInset:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = FriendsFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = FriendsFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = FriendsFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = FriendsFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- GuildFrame

	local a, b, c, d, e, f = GuildFrame:GetRegions()
	for _, v in pairs({e, f}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	-- MailFrame

	local a, b, c, d, e, f, g, h = MailFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	local a, b, c, d, e, f, g, h = MailFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	ChatFrame1EditBoxLeft:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	ChatFrame1EditBoxMid:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	ChatFrame1EditBoxRight:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

	GameTooltip:SetBackdropBorderColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	GameTooltip.SetBackdropBorderColor = function() end
end

local Framecolor = CreateFrame("Frame")

Framecolor:RegisterEvent("ADDON_LOADED")
Framecolor:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "RougeUI" then
		FrameColour()
		self:UnregisterEvent("ADDON_LOADED")
		self:SetScript("OnEvent", nil)
	end
end)


function ChangeFrameColors()
	FrameColour()
end
	
