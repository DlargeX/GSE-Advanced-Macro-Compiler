local GSE = GSE
local L = GSE.L
local Statics = GSE.Static

StaticPopupDialogs["GS-DebugOutput"] = {
    text = "Dump of GS Debug messages",
    button1 = L["Update"],
    button2 = L["Close"],
    OnAccept = function(self, data)
        self.editBox:SetText(GSE.DebugOutput)
    end,
    OnShow = function(self, data)
        self.editBox:SetText(GSE.DebugOutput)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, -- Avoid some UI taint, see https://www.wowace.com/news/376-how-to-avoid-some-ui-taint
    hasEditBox = true
}

StaticPopupDialogs["GSE_UPDATE_AVAILABLE"] = {
    text = L[
        "GSE is out of date. You can download the newest version from https://www.curseforge.com/wow/addons/gse-gnome-sequencer-enhanced-advanced-macros."
    ],
    hasEditBox = 1,
    OnShow = function(self)
        self.editBox:SetAutoFocus(false)
        self.editBox:SetWidth(220)
        self.editBox:SetText("https://www.curseforge.com/wow/addons/gse-gnome-sequencer-enhanced-advanced-macros")
        self.editBox:HighlightText()
        ChatEdit_FocusActiveWindow()
    end,
    OnHide = function(self)
        self.editBox:SetWidth(self.editBox.width or 50)
    end,
    hideOnEscape = 1,
    button1 = OKAY,
    EditBoxOnEnterPressed = function(self)
        ChatEdit_FocusActiveWindow()
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        ChatEdit_FocusActiveWindow()
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
        if (self:GetText() ~= "https://www.curseforge.com/wow/addons/gse-gnome-sequencer-enhanced-advanced-macros") then
            self:SetText("https://www.curseforge.com/wow/addons/gse-gnome-sequencer-enhanced-advanced-macros")
        end
        self:HighlightText()
        self:ClearFocus()
        ChatEdit_FocusActiveWindow()
    end,
    OnEditFocusGained = function(self)
        self:HighlightText()
    end,
    showAlert = 1
}

StaticPopupDialogs["GSE_SEQUENCEHELP"] = {
    text = L["Copy this link and open it in a Browser."],
    hasEditBox = 1,
    url = "https://discord.gg/gseunited",
    OnShow = function(self)
        self.editBox:SetAutoFocus(false)
        self.editBox.width = self.editBox:GetWidth()
        self.editBox:SetWidth(220)
        self.editBox:SetText(StaticPopupDialogs["GSE_SEQUENCEHELP"].url)
        self.editBox:HighlightText()
        ChatEdit_FocusActiveWindow()
    end,
    OnHide = function(self)
        self.editBox:SetWidth(self.editBox.width or 50)
        self.editBox.width = nil
    end,
    hideOnEscape = 1,
    button1 = OKAY,
    EditBoxOnEnterPressed = function(self)
        ChatEdit_FocusActiveWindow()
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        ChatEdit_FocusActiveWindow()
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
        if (self:GetText() ~= StaticPopupDialogs["GSE_SEQUENCEHELP"].url) then
            self:SetText(StaticPopupDialogs["GSE_SEQUENCEHELP"].url)
        end
        self:HighlightText()
        self:ClearFocus()
        ChatEdit_FocusActiveWindow()
    end,
    OnEditFocusGained = function(self)
        self:HighlightText()
    end,
    showAlert = 1
}

StaticPopupDialogs["GSE-MacroImportSuccess"] = {
    text = L["Macro Import Successful."],
    button1 = L["Close"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3 -- Avoid some UI taint, see https://www.wowace.com/news/376-how-to-avoid-some-ui-taint
}

StaticPopupDialogs["GSE-GenericMessage"] = {
    text = L["Macro Import Successful."],
    button1 = L["Close"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3 -- Avoid some UI taint, see https://www.wowace.com/news/376-how-to-avoid-some-ui-taint
}

StaticPopupDialogs["GSE-MacroImportFailure"] = {
    text = L["Macro unable to be imported."],
    button1 = L["Close"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3 -- Avoid some UI taint, see https://www.wowace.com/news/376-how-to-avoid-some-ui-taint
}

StaticPopupDialogs["GSE-DeleteMacroDialog"] = {
    text = "",
    button1 = L["Delete"],
    button2 = L["Cancel"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = STATICPOPUPS_NUMDIALOGS,
    showAlert = true,
    exclusive = true
}

StaticPopupDialogs["GSE_ChatLink"] = {
    text = L["Copy this link and paste it into a chat window."],
    hasEditBox = 1,
    link = "",
    OnShow = function(self)
        self.editBox:SetAutoFocus(false)
        self.editBox.width = self.editBox:GetWidth()
        self.editBox:SetWidth(220)
        self.editBox:SetText(StaticPopupDialogs["GSE_ChatLink"].link)
        self.editBox:HighlightText()
        ChatEdit_FocusActiveWindow()
    end,
    OnHide = function(self)
        self.editBox:SetWidth(self.editBox.width or 50)
        self.editBox.width = nil
    end,
    hideOnEscape = 1,
    button1 = OKAY,
    EditBoxOnEnterPressed = function(self)
        ChatEdit_FocusActiveWindow()
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        ChatEdit_FocusActiveWindow()
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
        if (self:GetText() ~= StaticPopupDialogs["GSE_ChatLink"].link) then
            self:SetText(StaticPopupDialogs["GSE_ChatLink"].link)
        end
        self:HighlightText()
        self:ClearFocus()
        ChatEdit_FocusActiveWindow()
    end,
    OnEditFocusGained = function(self)
        self:HighlightText()
    end,
    showAlert = 1
}
