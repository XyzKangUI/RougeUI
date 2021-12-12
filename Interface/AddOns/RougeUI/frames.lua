local Framecolor = CreateFrame("Frame")
Framecolor:RegisterEvent("ADDON_LOADED")
Framecolor:SetScript("OnEvent", function(self, event, addon)
	if (addon == "RougeUI") then
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
			MerchantFrameTopBorder,
			MerchantFrameBtnCornerRight,
			MerchantFrameBtnCornerLeft,
			MerchantFrameBottomRightBorder,
			MerchantFrameBottomLeftBorder,
			MerchantFrameButtonBottomBorder,
			MerchantFrameBg,
			MinimapBorder,
			CastingBarFrame.Border,
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
				v:SetVertexColor(0.05, 0.05, 0.05)
		end

CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

local a, b, c, d, _, e = BankFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

}) do
   v:SetVertexColor(0.35, 0.35, 0.35)

end

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
	ContainerFrame11BackgroundBottom
}) do
   v:SetVertexColor(0.4, 0.4, 0.4)
end

for i,v in pairs({
      LootFrameInsetBg,
      LootFrameTitleBg,
      MerchantFrameTitleBg

}) do
   v:SetVertexColor(0.35, 0.35, 0.35)
end

for i,v in pairs ({
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
	StanceBarLeft,
	StanceBarMiddle,
	StanceBarRight
}) do
   v:SetVertexColor(.35, .35, .35)
end

local a, b, c, d, _, e = PaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

})do
   v:SetVertexColor(0.35, 0.35, 0.35)

end

local a, b, c, d = SkillFrame:GetRegions()
for _, v in pairs({a, b, c ,d

}) do
     v:SetVertexColor(0.35, 0.35, 0.35)
end
for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider

}) do
     v:SetVertexColor(0.35, 0.35, 0.35)
end
--Reputation Frame
local a, b, c, d = ReputationFrame:GetRegions()
for _, v in pairs({a, b, c, d

}) do
     v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e = PVPFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

}) do
   v:SetVertexColor(.7, .7, .7)
end

local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
for _, v in pairs({a, b, c ,d, e, f, g, h, j, k

}) do
   v:SetVertexColor(0.35, 0.35, 0.35)
end

for i,v in pairs({
      MerchantFramePortrait

}) do
   v:SetVertexColor(1, 1, 1)
end

local a, b, c, d, _, e = PetPaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

})do
   v:SetVertexColor(0.35, 0.35, 0.35)

end

--Character Tabs

local a, b, c, d, e, f, g, h = CharacterFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end


local a, b, c, d, e, f, g, h = CharacterFrameTab5:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e = PVPFrame:GetRegions()
for _, v in pairs({a, b, c, d, e 

}) do
   v:SetVertexColor(0.35, 0.35, 0.35)
end

-- Social Frame
local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
for _, v in pairs({
	a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r,
	FriendsFrameInset:GetRegions(),
	WhoFrameListInset:GetRegions()
}) do
	v:SetVertexColor(0.35, 0.35, 0.35)
end

for i,v in pairs({
	BankPortraitTexture,
	BankFrameTitleText,
	MerchantFramePortrait,
	WhoFrameTotals
}) do
   v:SetVertexColor(1, 1, 1)
end

FriendsFrameInsetInsetBottomBorder:SetVertexColor(0.35, 0.35, 0.35)
WhoFrameEditBoxInset:GetRegions():SetVertexColor(0.35, 0.35, 0.35)
WhoFrameDropDownLeft:SetVertexColor(0.5, 0.5, 0.5)
WhoFrameDropDownMiddle:SetVertexColor(0.5, 0.5, 0.5)
WhoFrameDropDownRight:SetVertexColor(0.5, 0.5, 0.5)

local a, b, c, d, e, f, g, h, i = WhoFrameEditBoxInset:GetRegions()
for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
	v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end


for i, v in pairs({
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
	MailFrameInsetInsetBotRightCorner
}) do
   v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = MailFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

local a, b, c, d, e, f, g, h = MailFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35, 0.35, 0.35)
end

	GameTooltip:SetBackdropBorderColor(.05, .05, .05)
	GameTooltip.SetBackdropBorderColor = function() end

	self:UnregisterEvent("ADDON_LOADED")
	Framecolor:SetScript("OnEvent", nil)
	end
end)