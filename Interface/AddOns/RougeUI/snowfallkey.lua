local _, RougeUI = ...
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local CreateFrame = CreateFrame
local wahk = false

local function CreateAnim(self)
    local frame = CreateFrame("Frame", nil, self)
    frame:SetFrameStrata("TOOLTIP")
    frame:SetAllPoints(self)

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
    scale2:SetDuration(0.3)
    scale2:SetOrder(2)

    local rotation = animation:CreateAnimation("Rotation")
    rotation:SetDegrees(90)
    rotation:SetDuration(0.3)
    rotation:SetOrder(2)

    self.sfk = animation
    self.snowfall = frame
end

function RougeUI.Animate(self)
    if (not self:IsVisible() or (self:GetParent():GetAlpha() < .35) or (self:GetAlpha() < 1)) then
        return
    end

    if not self.snowfall then
        CreateAnim(self)
    end

    local func = true
    if wahk and not RougeUI.db.wahksfk then
        func = (self:GetButtonState() == "PUSHED")
    end

    if func and self.snowfall then
        self.sfk:Stop()
        self.sfk:Play()
    end
end

local function onKeyDown(self, state)
    if state == "PUSHED" then
        RougeUI.Animate(self)
    end
end

local function hookButton(buttonName)
    local button = _G[buttonName]
    if not button then
        return
    end

    if not button.sfkhooked then
        button:HookScript("OnMouseDown", RougeUI.Animate)
        hooksecurefunc(button, "SetButtonState", onKeyDown)
        button.sfkhooked = true
    end
end

local function hookBartender()
    for i = 1, 180 do
        hookButton("BT4Button" .. i)
        hookButton("BT4PetButton" .. i)
    end
end

local function hookDominos()
    for i = 1, 168 do
        hookButton("DominosActionButton" .. i)
    end

    for i = 1, 12 do
        hookButton("MultiBarRightActionButton" .. i)
        hookButton("MultiBarLeftActionButton" .. i)
        hookButton("MultiBarBottomLeftActionButton" .. i)
        hookButton("MultiBarBottomRightActionButton" .. i)
        hookButton("MultiBar5ActionButton" .. i)
        hookButton("MultiBar6ActionButton" .. i)
        hookButton("MultiBar7ActionButton" .. i)
    end
end

local function hookBlizzard()
    for i = 1, 12 do
        hookButton("ActionButton" .. i)
        hookButton("MultiBarBottomLeftButton" .. i)
        hookButton("MultiBarBottomRightButton" .. i)
        hookButton("MultiBarRightButton" .. i)
        hookButton("MultiBarLeftButton" .. i)
        hookButton("MultiBar5Button" .. i)
        hookButton("MultiBar6Button" .. i)
        hookButton("MultiBar7Button" .. i)
    end

    for i = 1, 10 do
        hookButton("PetActionButton" .. i)
    end
    for i = 1, 6 do
        hookButton("OverrideActionBarButton" .. i)
    end
end

local function hookButtons()
    C_Timer.After(0, function()
        if not RougeUI.db.ButtonAnim then
            return
        end

        if RougeUI.db.KeyEcho then
            wahk = true
            return
        end

        local bt4, dm = false, false

        if IsAddOnLoaded("Bartender4") then
            bt4 = true
        elseif IsAddOnLoaded("Dominos") then
            dm = true
        end

        if bt4 then
            hookBartender()
        elseif dm then
            hookDominos()
        else
            hookBlizzard()
        end
    end)
end

local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", hookButtons)