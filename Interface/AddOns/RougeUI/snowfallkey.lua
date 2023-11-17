local _, RougeUI = ...
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local bt4 = IsAddOnLoaded("Bartender4")
local dm = IsAddOnLoaded("Dominos")
local CreateFrame, hooksecurefunc = CreateFrame, hooksecurefunc
local GetActionButtonForID = GetActionButtonForID
local wahk = false

local function CreateAnim(self)
    if (not self:IsVisible() or (self:GetParent():GetAlpha() < .35) or (self:GetAlpha() < 1)) then
        return
    end

    local frame
    if not frame then
        frame = CreateFrame("Frame")
        frame:SetFrameStrata("TOOLTIP")

        local texture = frame:CreateTexture()
        texture:SetTexture("Interface\\Cooldown\\star4")
        texture:SetAlpha(0)
        texture:SetAllPoints(frame)
        texture:SetBlendMode("ADD")
        texture:SetDrawLayer("OVERLAY", 7)

        local animation = texture:CreateAnimationGroup()

        local alpha = animation:CreateAnimation("Alpha")
        alpha:SetFromAlpha(0)
        alpha:SetToAlpha(1)
        alpha:SetDuration(0)
        alpha:SetOrder(1)

        local scale1 = animation:CreateAnimation("Scale")
        scale1:SetScale(1.5, 1.5)
        scale1:SetDuration(0)
        scale1:SetOrder(1)

        local scale2 = animation:CreateAnimation("Scale")
        scale2:SetScale(0, 0)
        scale2:SetDuration(.3)
        scale2:SetOrder(2)

        local rotation = animation:CreateAnimation("Rotation")
        rotation:SetDegrees(90)
        rotation:SetDuration(.3)
        rotation:SetOrder(2)

        self.sfk = animation
        self.snowfall = frame
    end
end

function RougeUI.Animate(self)
    if not self.sfk and not self.snowfall then
        CreateAnim(self)
    end

    local func = true
    if wahk then
        func = self:GetButtonState() == "PUSHED"
    end

    if func then
        self.snowfall:SetAllPoints(self)
        self.sfk:Stop()
        self.sfk:Play()
    end
end

local function AnimateClick(button)
    if button and not button.hooked then
        button.AnimateThis = RougeUI.Animate
        button:HookScript("OnClick", button.AnimateThis)
        button.hooked = true
    end
end

local function HookedDefaultBars()
    hooksecurefunc("ActionButtonDown", function(id)
        local button = GetActionButtonForID(id)
        if button then
            RougeUI.Animate(button)
        end
    end)
    hooksecurefunc("MultiActionButtonDown", function(name, id)
        local button = _G[name .. "Button" .. id]
        if button then
            RougeUI.Animate(button)
        end
    end)
    hooksecurefunc("PetActionButtonDown", function(id)
        local button = _G["PetActionButton" .. id]
        if button then
            RougeUI.Animate(button)
        end
    end)

    for i = 1, 12 do
        AnimateClick(_G["ActionButton" .. i])
        AnimateClick(_G["MultiBarBottomLeftButton" .. i])
        AnimateClick(_G["MultiBarBottomRightButton" .. i])
        AnimateClick(_G["MultiBarRightButton" .. i])
        AnimateClick(_G["MultiBarLeftButton" .. i])
    end

    for i = 1, 10 do
        AnimateClick(_G["PetActionButton" .. i])
    end

    for i = 1, 6 do
        AnimateClick(_G["OverrideActionBarButton" .. i])
    end
end

local function AnimateBartender()
    for i = 1, 120 do
        AnimateClick(_G["BT4Button" .. i])
        AnimateClick(_G["BT4PetButton" .. i])
    end
    --    for i = 1, 6 do
    --        AnimateClick(_G["OverrideActionBarButton" .. i])
    --    end
end

local function AnimateDominos()
    for i = 1, 120 do
        AnimateClick(_G["DominosActionButton" .. i])
    end
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
    
    if RougeUI.db.ButtonAnim and not (bt4 and dm) then
        if RougeUI.db.KeyEcho then
            wahk = true
            return
        end
        if bt4 then
            AnimateBartender()
        elseif dm then
            HookedDefaultBars()
            AnimateDominos()
        else
            HookedDefaultBars()
        end
    end
end)