local function FixButttons()
    for i = 1, SPELLS_PER_PAGE do
        local button = _G["SpellButton"..i]
        if button and not button.isHooked then
            button:HookScript("OnClick", function(self, buttonPressed)
                local slot = SpellBook_GetSpellBookSlot(self);
                if ( slot > MAX_SPELLS ) then return end

                if ( IsModifiedClick("CHATLINK") ) then
                    if ( MacroFrameText and MacroFrameText:HasFocus() ) then
                        local spellName, subSpellName = GetSpellBookItemName(slot, SpellBookFrame.bookType);
                        if ( spellName and not IsPassiveSpell(slot, SpellBookFrame.bookType) ) then
                            if ( subSpellName and (strlen(subSpellName) > 0) ) then
                                ChatEdit_InsertLink(spellName.."("..subSpellName..")");
                            else
                                ChatEdit_InsertLink(spellName);
                            end
                        end
                        return;
                    else
                        local tradeSkillLink, tradeSkillSpellID = GetSpellTradeSkillLink(slot, SpellBookFrame.bookType);
                        if ( tradeSkillSpellID ) then
                            ChatEdit_InsertLink(tradeSkillLink);
                        else
                            ChatEdit_InsertLink(GetSpellLink(slot, SpellBookFrame.bookType));
                        end
                        return;
                    end
                end
                if ( IsModifiedClick("PICKUPACTION") ) then
                    PickupSpellBookItem(slot, SpellBookFrame.bookType);
                    return;
                end
            end)
            button.isHooked = true
        end
    end
end

if not SpellButton_OnModifiedClick then
    SpellBookFrame:HookScript("OnShow", FixButttons)
end

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