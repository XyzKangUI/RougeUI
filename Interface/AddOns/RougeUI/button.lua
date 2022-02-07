-- ls / modui border code

local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")

local r, g, b = .35, .35, .35
local sections = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"}
local buttons = {
	_G["MainMenuBarBackpackButton"],
	GameTooltip,
	ItemRefTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ShoppingTooltip1,
	ShoppingTooltip2,
	WorldMapTooltip,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	ChatMenu,
	VoiceMacroMenu,
	LanguageMenu,
	DropDownList1,	
	DropDownList2,
}

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

	local action = bu.action
	local name = bu:GetName()
	local ho = _G[name.."HotKey"]
	local nt = _G[name.."NormalTexture"]
	local fbg = _G[name.."FloatingBG"]

	addBorder(bu, 1)
	bu:SkinColor(r, g, b)

	if not bartender4 then
		ho:ClearAllPoints()
		ho:SetPoint("TOPRIGHT", bu, 1, -3)
	end

	if not nt then
		nt = bu:GetNormalTexture()
	end

	nt:Hide()
	if fbg then fbg:Hide() end

	bu.rabs_styled = true
end

local function init()
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

	for _, v in pairs(buttons) do
		addBorder(v)
		v:SkinColor(r, g, b)
	end

	for _, v in pairs(slots) do
		local bu = _G["Character"..v.."Slot"]
		local ic = _G["Character"..v.."SlotIconTexture"]
		addBorder(bu)
		bu:SkinColor(r, g, b)
		if bu:GetNormalTexture() then bu:GetNormalTexture():SetTexture("") end
		-- ic:SetTexCoord(.1, .9, .1, .9)
	end

	for i = 0, 3 do -- Bagicons
		local bu = _G["CharacterBag"..i.."Slot"]
        	addBorder(bu)
        	bu:SkinColor(r, g, b)
	end

	for i = 1,12 do  -- Bagslots
		for k = 1, MAX_CONTAINER_ITEMS do
			local bu = _G["ContainerFrame"..i.."Item"..k]
			-- local ic = _G["ContainerFrame"..i.."Item"..k.."IconTexture"]
            		addBorder(bu)
            		bu:SkinColor(r, g, b)
            		if bu:GetNormalTexture() then bu:GetNormalTexture():SetTexture("") end
            		-- ic:SetTexCoord(.1, .9, .1, .9)
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
		addBorder(bu)
		bu:SkinColor(r, g, b)
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
	tf:SkinColor(r, g, b)

end

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
        local bu = _G["TempEnchant"..i]
        local bo = _G["TempEnchant"..i.."Border"]
	local du = _G["TempEnchant"..i.."Duration"]
        bu:SetNormalTexture("")
        bo:SetTexture("")
        addBorder(bu, 1)
	SkinColor(bu, 1, 0, 1)
        du:SetJustifyH("CENTER")
        du:ClearAllPoints() 
	du:SetPoint("CENTER", bu, "BOTTOM", 0, -8)
end

local function applySkin(b)
	local name = b:GetName()
	local bo = _G[name.."Border"]
	local ic = _G[name.."Icon"]

	if name:match("Debuff") then
		addBorder(b, 0)
		ic:SetTexCoord(.1, .9, .1, .9)
		local re, gr, bl = bo:GetVertexColor()
		SkinColor(b, re*1.5, gr*1.5, bl*1.5)
		bo:SetAlpha(0)
		return
	end

        if bo then
		local r, g, b = bo:GetVertexColor()
		SkinColor(bo, r*1.5, g*1.5, b*1.5)
		bo:SetAlpha(0)
        end

	b:SetNormalTexture("")
	ic:SetTexCoord(.1, .9, .1, .9)
	addBorder(b, .25)
	SkinColor(b, .25, .25, .25)

	b.duration:ClearAllPoints()
	b.duration:SetPoint("CENTER", b, "BOTTOM", 0, -8)
	b.styled = true
end

hooksecurefunc("AuraButton_Update", function(self, index)
	local button = _G[self..index]
	if button and not button.styled then applySkin(button) end
end)

local function TargetButton_Update(self)
	if self:IsForbidden() then return end
	for i = 1, MAX_TARGET_BUFFS do
		local bu = _G["TargetFrameBuff"..i]
		if bu then
			if not bu.skin then
				addBorder(bu, 0)
				_G["TargetFrameBuff"..i.."Icon"]:SetTexCoord(.1, .9, .1, .9)
				bu.skin = true
			end
			bu:SkinColor(r, g, b)
		else
			break
		end
	end

	for i = 1, MAX_TARGET_BUFFS do
		local bu = _G["FocusFrameBuff"..i]
		if bu then
			if not bu.skin then
				addBorder(bu, 0)
				_G["FocusFrameBuff"..i.."Icon"]:SetTexCoord(.1, .9, .1, .9)
				bu.skin = true
			end
			bu:SkinColor(r, g, b)
		else
			break
		end
	end

	for i = 1, MAX_TARGET_DEBUFFS do
		local bu = _G["TargetFrameDebuff"..i]
		if bu then
			if not bu.skin then
				addBorder(bu, 0)
				_G["TargetFrameDebuff"..i.."Icon"]:SetTexCoord(.1, .9, .1, .9)
				bu.skin = true
			end
			local re, gr, bl = _G["TargetFrameDebuff"..i.."Border"]:GetVertexColor()
			bu:SkinColor(re, gr, bl)
		else
			break
		end
	end

	for i = 1, MAX_TARGET_DEBUFFS do
		local bu = _G["FocusFrameDebuff"..i]
		if bu then
			if not bu.skin then
				addBorder(bu, 0)
				_G["FocusFrameDebuff"..i.."Icon"]:SetTexCoord(.1, .9, .1, .9)
				bu.skin = true
			end
			local re, gr, bl = _G["FocusFrameDebuff"..i.."Border"]:GetVertexColor()
			bu:SkinColor(re, gr, bl)
		else
			break
		end
	end
end
hooksecurefunc("TargetFrame_UpdateAuras", TargetButton_Update);

local function UpdatePaperDoll()
	for i, v in pairs(slots) do
		local bu = _G["Character"..v.."Slot"]
		local q = GetInventoryItemQuality("player", i)
		if q and q > 1 then
			local re, gr, bl = GetItemQualityColor(q)
			bu:SkinColor(re*1.4, gr*1.4, bl*1.4)
		else
			bu:SkinColor(r, g, b)
		end
	end
end

local function UpdateBag()
	for i = 1, 12 do
		local n = "ContainerFrame"..i
		local f = _G[n]
		local id = f:GetID()
		for i = 1, MAX_CONTAINER_ITEMS do
			local bu   = _G[n.."Item"..i]
			local link = GetContainerItemLink(id, bu:GetID())

			bu:SkinColor(r, g, b)

			if  bu and bu:IsShown() and link then
				local _, _, istring  = string.find(link, "|H(.+)|h")
				local n, _, q, _, _, type = GetItemInfo(istring)
				if n and strfind(n, "Mark of Honor") then
					bu:SkinColor(.98, .95, 0)
				elseif  type == "Quest" then
					bu:SkinColor(1, .33, 0)
				elseif q and q > 1 then
					local re, gr, bl = GetItemQualityColor(q)
					bu:SkinColor(re*1.4, gr*1.4, bl*1.4)
				end
			end
		end
	end
end

hooksecurefunc("ContainerFrame_OnShow", UpdateBag)

local e = CreateFrame("Frame")
e:SetParent(CharacterFrame)
e:SetScript("OnShow", UpdatePaperDoll)
e:SetScript("OnEvent", UpdatePaperDoll)
e:RegisterEvent("UNIT_INVENTORY_CHANGED")

local e2 = CreateFrame("Frame")
e2:SetParent(ContainerFrame1)
e2:SetScript("OnEvent", UpdateBag)
e2:RegisterEvent("BAG_UPDATE")

local e3 = CreateFrame("Frame")
e3:RegisterEvent("ADDON_LOADED")
e3:SetScript("OnEvent", function(self, event, addon)
	init()
end)

    --
