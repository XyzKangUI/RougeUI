-- ls / modui border code

local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")
if (IsAddOnLoaded("Masque") and (dominos or bartender4)) then return end

local sections = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"}

local slots = {
	[0] = "Ammo", "Head", "Neck", "Shoulder",
	"Shirt", "Chest", "Waist", "Legs", "Feet",
	"Wrist", "Hands", "Finger0", "Finger1",
	"Trinket0", "Trinket1",
	"Back", "MainHand", "SecondaryHand", "Ranged", "Tabard",
}


local function SkinColor(self, r, g, b, a)
	local  t = self.borderTextures
	if not t then return end
	for  _, tex in pairs(t) do
		tex:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
	end
end

local function GetBorderColor(self)
	return self.borderTextures and self.borderTextures.TOPLEFT:GetVertexColor()
end

local function addBorder(object, offset)
	if type(object) ~= "table" or not object.CreateTexture or object.borderTextures then return end

	local t = {}
	offset = offset or 0

	for i = 1, #sections do
		local x = object:CreateTexture(nil, "OVERLAY", nil, 1)
		x:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\border-"..sections[i])
		t[sections[i]] = x
	end

	t.TOPLEFT:SetWidth(8)
	t.TOPLEFT:SetHeight(8)
	t.TOPLEFT:SetPoint("BOTTOMRIGHT", object, "TOPLEFT", 4 + offset, -4 - offset)

	t.TOPRIGHT:SetWidth(8)
	t.TOPRIGHT:SetHeight(8)
	t.TOPRIGHT:SetPoint("BOTTOMLEFT", object, "TOPRIGHT", -4 - offset, -4 - offset)

	t.BOTTOMLEFT:SetWidth(8)
	t.BOTTOMLEFT:SetHeight(8)
	t.BOTTOMLEFT:SetPoint("TOPRIGHT", object, "BOTTOMLEFT", 4 + offset, 4 + offset)

	t.BOTTOMRIGHT:SetWidth(8)
	t.BOTTOMRIGHT:SetHeight(8)
	t.BOTTOMRIGHT:SetPoint("TOPLEFT", object, "BOTTOMRIGHT", -4 - offset, 4 + offset)

	t.TOP:SetHeight(8)
	t.TOP:SetPoint("TOPLEFT", t.TOPLEFT, "TOPRIGHT", 0, 0)
	t.TOP:SetPoint("TOPRIGHT", t.TOPRIGHT, "TOPLEFT", 0, 0)

	t.BOTTOM:SetHeight(8)
	t.BOTTOM:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "BOTTOMRIGHT", 0, 0)
	t.BOTTOM:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "BOTTOMLEFT", 0, 0)

	t.LEFT:SetWidth(8)
	t.LEFT:SetPoint("TOPLEFT", t.TOPLEFT, "BOTTOMLEFT", 0, 0)
	t.LEFT:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "TOPLEFT", 0, 0)

	t.RIGHT:SetWidth(8)
	t.RIGHT:SetPoint("TOPRIGHT", t.TOPRIGHT, "BOTTOMRIGHT", 0, 0)
	t.RIGHT:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "TOPRIGHT", 0, 0)

	object.borderTextures = t
	object.SkinColor = SkinColor
	object.GetBorderColor = GetBorderColor
end

local function styleActionButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end

	local name = bu:GetName()
	local ho = _G[name.."HotKey"]
	local fbg = _G[name.."FloatingBG"]
	local ic = _G[name.."Icon"]
	local nt = _G[name.."NormalTexture"]

	addBorder(bu, .1)
	SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

	ic:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	nt:SetAlpha(0)

	if not bartender4 then
		ho:ClearAllPoints()
		ho:SetPoint("TOPRIGHT", bu, 1, -2)
	end

	if fbg then fbg:Hide() end

	bu.rabs_styled = true
end

local function init()
	for _,v in pairs(slots) do
		local bu =  _G["Character"..v.."Slot"]
		addBorder(bu, 1)
		SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
		bu:SetNormalTexture("")
	end

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		styleActionButton(_G["ActionButton"..i])
		styleActionButton(_G["MultiBarRightButton"..i])
		styleActionButton(_G["MultiBarLeftButton"..i])
		styleActionButton(_G["MultiBarBottomLeftButton"..i])
		styleActionButton(_G["MultiBarBottomRightButton"..i])
	end

	for i = 1, 6 do
		styleActionButton(_G["OverrideActionBarButton"..i])
	end

	if dominos then
		for i = 1, 60 do
			styleActionButton(_G["DominosActionButton"..i])
		end
	end

	if bartender4 then
		for i = 1, 120 do
			styleActionButton(_G["BT4Button"..i])
		end
	end

	addBorder(MainMenuBarBackpackButton, 1)
	SkinColor(MainMenuBarBackpackButton, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

	for _, v in pairs(slots) do
		local bu = _G["Character"..v.."Slot"]
		addBorder(bu, 0)
		SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	for i = 0, 3 do -- Bagicons
		local bu = _G["CharacterBag"..i.."Slot"]
		addBorder(bu, 1)
		SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	for i = 1,12 do  -- Bagslots
		for k = 1, MAX_CONTAINER_ITEMS do
			local bu = _G["ContainerFrame"..i.."Item"..k]
			addBorder(bu, 1)
			SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
			if bu:GetNormalTexture() then bu:GetNormalTexture():SetTexture("") end
			bu.bg = bu:CreateTexture(nil, "BACKGROUND")
			bu.bg:SetAllPoints()
			bu.bg:SetTexture[[Interface\Buttons\UI-Slot-Background]]
			bu.bg:SetTexCoord(.075, .6, .075, .6)
			bu.bg:SetAlpha(.4)
		end
	end

	for i = 1, 28 do
		local bu = _G["BankFrameItem"..i]
		local ic = _G["BankFrameItem"..i.."IconTexture"]
		addBorder(bu, 0)
		SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
		if bu:GetNormalTexture() then bu:GetNormalTexture():SetTexture("") end
		-- ic:SetTexCoord(.1, .9, .1, .9)
		bu.bg = bu:CreateTexture(nil, "BACKGROUND")
		bu.bg:SetAllPoints()
		bu.bg:SetTexture[[Interface\Buttons\UI-Slot-Background]]
		bu.bg:SetTexCoord(.075, .6, .075, .6)
		bu.bg:SetAlpha(.4)
	end

	local tf = CreateFrame("Frame", nil, _G[TargetFrameSpellBar:GetName()])
	tf:SetAllPoints(_G[TargetFrameSpellBar:GetName().."Icon"])
	addBorder(tf, 0)
	SkinColor(tf, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

	for i = 1, NUM_TEMP_ENCHANT_FRAMES  do
		local bu = _G["TempEnchant"..i]
		local bo = _G["TempEnchant"..i.."Border"]
		local du = _G["TempEnchant"..i.."Duration"]
		bu:SetNormalTexture("")
		bo:SetTexture("")
		addBorder(bu, .5)
		SkinColor(bu, 1, 0, 1)
		du:SetJustifyH("CENTER")
		du:ClearAllPoints()
		du:SetPoint("CENTER", bu, "BOTTOM", 0, -7.5)
	end
end

local function applySkin(b)
	local name = b:GetName()
	local ic = _G[name.."Icon"]

	if name:match("Debuff") then
		ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		return
	end

	b:SetNormalTexture("")
	ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	addBorder(b, .1)
	SkinColor(b, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)

	b.duration:ClearAllPoints()
	b.duration:SetPoint("CENTER", b, "BOTTOM", 0, -7.5)
	b.styled = true

	b.count:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
	b.count:ClearAllPoints()
	b.count:SetPoint("TOPRIGHT", 0, -1)
end

local function UpdatePaperDoll()
	for i, v in pairs(slots) do
		local bu = _G["Character"..v.."Slot"]
		local q = GetInventoryItemQuality("player", i)
		if q and q > 1 then
			local re, gr, bl = GetItemQualityColor(q)
			SkinColor(bu, re*1.4, gr*1.4, bl*1.4)
		else
			SkinColor(bu, RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
		end
	end
end

local e = CreateFrame("Frame")
e:SetParent(CharacterFrame)
e:RegisterEvent("UNIT_INVENTORY_CHANGED")
e:SetScript("OnShow", function(self, event)
	if RougeUI.skinbuttons == false then
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		self:SetScript("OnShow", nil)
		return
	end
	if event == "UNIT_INVENTORY_CHANGED" then
		UpdatePaperDoll()
	end
end)
e:SetScript("OnEvent", function(self, event)
	if RougeUI.skinbuttons == false then
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		self:SetScript("OnEvent", nil)
		return
	end
	if event == "UNIT_INVENTORY_CHANGED" then
		UpdatePaperDoll()
	end
end)

local e3 = CreateFrame("Frame")
e3:RegisterEvent("PLAYER_LOGIN")
e3:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		if RougeUI.skinbuttons == true then
			init()
			UpdatePaperDoll()
			hooksecurefunc("AuraButton_Update", function(self, index)
				local button = _G[self..index]
				if button and not button.styled then applySkin(button) end
			end)
		end
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetScript("OnEvent", nil)
	end
end)

--
