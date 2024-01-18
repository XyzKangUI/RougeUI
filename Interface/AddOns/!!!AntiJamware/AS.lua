local interval = 60
local last = 0
local modified = false

local originalFunction = {
    RunScript = RunScript,
    SlashCmdList = SlashCmdList,
    SendMailMailButton = SendMailMailButton,
    SendMailMoneyGold = SendMailMoneyGold,
    ChatFrame1 = ChatFrame1,
    DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME,
    RemoveExtraSpaces = RemoveExtraSpaces,
    Click = Click,
}

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
    last = last + elapsed

    if last >= interval then
        last = 0
        if originalFunction.RunScript ~= RunScript then
            print("|cff00ff98AntiJamware:|r", "Warning, you have an addon installed modified by Jammin that is spying on you. It might be OmniBar, TCT or some other addon. I recommend you to delete the malicious RunScript code.")
            modified = true
        end

        if originalFunction.SlashCmdList ~= SlashCmdList then
            print("SlashCmdList function has been modified, this may harm your game!")
            modified = true
        end

        if originalFunction.SendMailMailButton ~= SendMailMailButton then
            print("SendMailMailButton function has been modified, this may harm your game!")
            modified = true
        end

        if originalFunction.SendMailMoneyGold ~= SendMailMoneyGold then
            print("SendMailMoneyGold function has been modified, this may harm your game!")
            modified = true
        end

        if originalFunction.ChatFrame1 ~= ChatFrame1 then
            print("ChatFrame1 function has been modified, this may harm your game!")
            modified = true
        end

        if originalFunction.DEFAULT_CHAT_FRAME ~= DEFAULT_CHAT_FRAME then
            print("DEFAULT_CHAT_FRAME function has been modified, this may harm your game!")
            modified = true
        end

        if originalFunction.RemoveExtraSpaces ~= RemoveExtraSpaces then
            print("RemoveExtraSpaces function  has been modified, this may harm your game!")
            modified = true
        end

        if originalFunction.Click ~= Click then
            print("Click function has been modified, this may harm your game!")
            modified = true
        end

        if modified then
            self:SetScript("OnUpdate", nil)
        end
    end
end)
