local f = CreateFrame("Frame", nil, SpellBookFrame, "SecureHandlerShowHideTemplate")
f:SetAllPoints(SpellBookFrame)
f:SetFrameRef("SpellBookNextPageButton", SpellBookNextPageButton)
f:SetFrameRef("SpellBookPrevPageButton", SpellBookPrevPageButton)

f:Execute([[
  SpellBookNextPageButton = self:GetFrameRef("SpellBookNextPageButton")
  SpellBookPrevPageButton = self:GetFrameRef("SpellBookPrevPageButton")
]])

f:SetAttribute("_onshow", [[
  self:SetBindingClick(true, "MOUSEWHEELUP", SpellBookPrevPageButton)
  self:SetBindingClick(true, "MOUSEWHEELDOWN", SpellBookNextPageButton)
]])

f:SetAttribute("_onhide", [[
  self:ClearBinding("MOUSEWHEELUP")
  self:ClearBinding("MOUSEWHEELDOWN")
]])

if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
    EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", function()
        MountJournal:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\MountJournalPortrait")
        end)
        ToyBox:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\Trade_Archaeology_ChestofTinyGlassAnimals")
        end)
        HeirloomsJournal:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_misc_enggizmos_19")
        end)
        WardrobeCollectionFrame:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_chest_cloth_17")
        end)
    end)
end