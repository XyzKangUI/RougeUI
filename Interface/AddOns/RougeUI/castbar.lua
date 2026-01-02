local _, RougeUI = ...
local strformat, max = string.format, math.max
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

local function PurpleKoolaid(statusbar)
    if (not statusbar or statusbar.disconnected) then
        return
    end

    local min, max = statusbar:GetMinMaxValues()
    if (max <= min) then
        return
    end

    local value = statusbar:GetValue()
    if ((value < min) or (value > max)) then
        return
    end

    value = (value - min) / (max - min)

    local startR, startG, startB = 0.7, 0.3, 1.0
    local endR, endG, endB = 0.49803921568, 0, 1.0

    local progress = value * value

    local r = startR + (endR - startR) * progress
    local g = startG + (endG - startG) * progress
    local b = startB + (endB - startB) * progress

    statusbar:SetStatusBarColor(r, g, b)
end

local function setFont(textString, size)
    local fontType
    if LOCALE_koKR then
        fontType = "Fonts\\2002.TTF"
    elseif LOCALE_zhTW then
        fontType = "Fonts\\arheiuhk_bd.TTF"
    elseif LOCALE_zhCN then
        fontType = "Fonts\\ARKai_C.ttf"
    elseif LOCALE_ruRU then
        fontType = "Fonts\\FRIZQT___CYR.TTF"
    else
        fontType = "Fonts\\FRIZQT__.TTF"
    end

    textString:SetFont(fontType, size, "OUTLINE")
end

local backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "",
    tile = true,
    tileSize = 14,
    edgeSize = 14,
    insets = { left = -4, right = -4, top = -4, bottom = -4 },
}

local function playerCastbar(cf)
    cf.Border:SetTexture(nil)
    Mixin(PlayerCastingBarFrame, BackdropTemplateMixin)
    cf:SetBackdrop(backdrop)
    cf:SetBackdropColor(0.1, 0.1, 0.1, 1)
    cf.Flash:SetTexture(nil)
    cf:SetSize(195, 18)
    cf.Icon = cf:CreateTexture(nil, "OVERLAY")
    cf.Icon:SetSize(22, 22)
    cf.Icon:SetPoint("RIGHT", cf, "LEFT", -5.3, 0)
    cf.Spark:SetAlpha(0.7)
    cf.Spark:SetHeight(50)
    cf.Text:ClearAllPoints()
    cf.Text:SetPoint("CENTER", cf, "CENTER", 0, 0)
    setFont(cf.Text, 11)

    local skinEnabled = RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern or RougeUI.db.modtheme
    if not skinEnabled then
        if not cf.IconBackdrop then
            cf.IconBackdrop = CreateFrame("Frame", nil, cf, "BackdropTemplate")
            cf.IconBackdrop:SetSize(18, 18)
            cf.IconBackdrop:SetPoint("CENTER", cf.Icon, "CENTER", 0, 0)
            cf.IconBackdrop:SetBackdrop(backdrop)
            cf.IconBackdrop:SetBackdropColor(0.1, 0.1, 0.1, 1)
            cf.Icon:SetParent(cf.IconBackdrop)
        end
    end
end

local function modstyle()
    for _, t in pairs { TargetFrameSpellBar, FocusFrameSpellBar } do
        if t then
            t.timer = t:CreateFontString(nil, "OVERLAY")
            setFont(t.timer, 9)
            t.timer:SetShadowColor(0, 0, 0)
            t.timer:SetShadowOffset(0, 0)
            t.timer:SetPoint("RIGHT", t, -2.5, 0)
            t.update = .1

            setFont(t.Text, 10)
            t.Text:SetShadowOffset(0, 0)
            t.Text:SetJustifyH("LEFT")
            t.Text:ClearAllPoints()
            t.Text:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 2, -5)
            t.Spark:SetAlpha(0.7)
            t.Spark:SetSize(15, 15)
            t.BorderShield:SetAlpha(0.7)
        end
    end

    local cf = PlayerCastingBarFrame
    playerCastbar(cf)

    local cfop = false
    hooksecurefunc(cf.Border, "SetTexture", function(self)
        if cfop then return end
        cfop = true
        C_Timer.After(0, function()
            playerCastbar(cf)
            cfop = false
        end)
    end)

    cf.timer = cf:CreateFontString(nil, "OVERLAY")
    cf.timer:SetShadowColor(0, 0, 0)
    cf.timer:SetShadowOffset(1, -1)
    cf.timer:SetPoint("RIGHT", cf, -2.5, -0.5)
    cf.timer:SetScale(1.15)
    cf.update = .1
    setFont(cf.timer, 9)
end

local function TimerHook(self, elapsed)
    if not self.timer then
        return
    end

    self.update = (self.update or 0) - elapsed

    if self.update <= 0 then
        local remainingTime = 0

        if self.casting then
            remainingTime = max(self.maxValue - self.value, 0)
        elseif self.channeling then
            remainingTime = max(self.value, 0)
        end

        self.timer:SetText(strformat("%.1f", remainingTime))
        self.update = 0.1
    end
end

local function CreateAnimation(frame)
    if not frame then
        return
    end

    local ag = frame:CreateAnimationGroup()
    frame.InterruptShakeAnim = ag
    ag:SetLooping("NONE")
    ag:SetToFinalAlpha(false)

    local function AddTranslation(order, offsetX, offsetY, duration, startDelay)
        local anim = ag:CreateAnimation("Translation")
        anim:SetOrder(order)
        anim:SetDuration(duration)
        anim:SetOffset(offsetX, offsetY)
        anim:SetSmoothing("NONE")
        if startDelay then
            anim:SetStartDelay(startDelay)
        end
        return anim
    end

    AddTranslation(1, 0, 0, 0.1)
    AddTranslation(2, -1, 1, 0.0, 0.05)
    AddTranslation(3, 1, -2, 0.0, 0.05)
    AddTranslation(4, 1, 2, 0.0, 0.05)
    AddTranslation(5, -1, -1, 0.0, 0.05)

    return ag
end

local FR = CreateFrame("Frame")
FR:RegisterEvent("PLAYER_LOGIN")
FR:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if RougeUI.db.CastTimer then
            modstyle()

            for _, v in pairs { TargetFrameSpellBar, FocusFrameSpellBar } do
                if v then
                    v:HookScript("OnUpdate", function(self, elapsed)
                        TimerHook(self, elapsed)
                        if self.BorderShield and self.BorderShield:IsShown() then
                            self:SetStatusBarColor(0.94, 0.94, 0.94)
                        else
                            RougeUI.RougeUIF:GradientColour(self)
                        end
                        if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                            self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                        end
                    end)
                end
            end

            PlayerCastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
                TimerHook(self, elapsed)
                PurpleKoolaid(self)
                if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                    self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                end
            end)

            CreateAnimation(PlayerCastingBarFrame)

            PlayerCastingBarFrame:HookScript("OnEvent", function(self, event)
                if (self == PlayerCastingBarFrame) and (event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED") then
                    if self.InterruptShakeAnim and not self.InterruptShakeAnim:IsPlaying() then
                        self.InterruptShakeAnim:Play()
                    end
                end
            end)
        end
    end
end)
