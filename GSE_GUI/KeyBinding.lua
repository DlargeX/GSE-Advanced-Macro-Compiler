local GSE = GSE
local Statics = GSE.Static

local AceGUI = LibStub("AceGUI-3.0")
local L = GSE.L

local keybindingframe = AceGUI:Create("Frame")
keybindingframe:Hide()
keybindingframe.panels = {}

keybindingframe.frame:SetFrameStrata("MEDIUM")
if
    GSEOptions.frameLocations and GSEOptions.frameLocations.keybindingframe and
        GSEOptions.frameLocations.keybindingframe.left and
        GSEOptions.frameLocations.keybindingframe.top
 then
    keybindingframe:SetPoint(
        "TOPLEFT",
        UIParent,
        "BOTTOMLEFT",
        GSEOptions.frameLocations.keybindingframe.left,
        GSEOptions.frameLocations.keybindingframe.top
    )
end
GSE.GUIkeybindingframe = keybindingframe

if GSE.isEmpty(GSEOptions.keybindingHeight) then
    GSEOptions.keybindingHeight = 500
end
if GSE.isEmpty(GSEOptions.keybindingWidth) then
    GSEOptions.keybindingWidth = 700
end
keybindingframe.Height = GSEOptions.keybindingHeight
keybindingframe.Width = GSEOptions.keybindingWidth
if keybindingframe.Height < 500 then
    keybindingframe.Height = 500
    GSEOptions.keybindingHeight = keybindingframe.Height
end
if keybindingframe.Width < 700 then
    keybindingframe.Width = 700
    GSEOptions.keybindingWidth = keybindingframe.Width
end
keybindingframe.frame:SetClampRectInsets(-10, -10, -10, -10)
keybindingframe.frame:SetHeight(GSEOptions.keybindingHeight)
keybindingframe.frame:SetWidth(GSEOptions.keybindingWidth)

keybindingframe:SetTitle(L["Keybindings"])
keybindingframe:SetCallback(
    "OnClose",
    function(self)
        GSE.ClearTooltip(keybindingframe)
        keybindingframe:Hide()
    end
)

keybindingframe:SetLayout("Flow")
keybindingframe:SetAutoAdjustHeight(false)

local basecontainer = AceGUI:Create("SimpleGroup")
basecontainer:SetLayout("Flow")
basecontainer:SetAutoAdjustHeight(false)
basecontainer:SetHeight(keybindingframe.Height - 100)
basecontainer:SetFullWidth(true)
keybindingframe:AddChild(basecontainer)

local leftScrollContainer = AceGUI:Create("SimpleGroup")
leftScrollContainer:SetWidth(200)

leftScrollContainer:SetHeight(keybindingframe.Height - 90)
leftScrollContainer:SetLayout("Fill") -- important!

basecontainer:AddChild(leftScrollContainer)

local leftscroll = AceGUI:Create("ScrollFrame")
leftscroll:SetLayout("List") -- probably?
leftscroll:SetWidth(200)
leftscroll:SetHeight(keybindingframe.Height - 90)
leftScrollContainer:AddChild(leftscroll)

local spacer = AceGUI:Create("Label")
spacer:SetWidth(10)
basecontainer:AddChild(spacer)

local rightContainer = AceGUI:Create("SimpleGroup")
rightContainer:SetWidth(keybindingframe.Width - 290)

rightContainer:SetLayout("List")
rightContainer:SetHeight(keybindingframe.Height - 90)
basecontainer:AddChild(rightContainer)
keybindingframe:DoLayout()
keybindingframe.frame:SetScript(
    "OnSizeChanged",
    function(self, width, height)
        keybindingframe.Height = height
        keybindingframe.Width = width
        if keybindingframe.Height > GetScreenHeight() then
            keybindingframe.Height = GetScreenHeight() - 10
            keybindingframe:SetHeight(keybindingframe.Height)
        end
        if keybindingframe.Height < 500 then
            keybindingframe.Height = 500
            keybindingframe:SetHeight(keybindingframe.Height)
        end
        if keybindingframe.Width < 700 then
            keybindingframe.Width = 700
            keybindingframe:SetWidth(keybindingframe.Width)
        end
        GSEOptions.keybindingHeight = keybindingframe.Height
        GSEOptions.keybindingWidth = keybindingframe.Width
        rightContainer:SetWidth(keybindingframe.Width - 290)
        rightContainer:SetHeight(keybindingframe.Height - 90)
        leftScrollContainer:SetHeight(keybindingframe.Height - 90)
        keybindingframe:DoLayout()
    end
)

local function showKeybind(bind, button, specialization)
    local initialbind = bind
    rightContainer:ReleaseChildren()
    local keybind = AceGUI:Create("Keybinding")
    keybind:SetLabel(L["Keybind"])
    if GSE.isEmpty(bind) then
        -- new keybindingframe
    else
        keybind:SetKey(bind)
    end

    keybind:SetCallback(
        "OnKeyChanged",
        function(self, _, key)
            bind = key
        end
    )

    keybind:SetLabel(L["Set Key to Bind"])
    local SequenceListbox = AceGUI:Create("Dropdown")

    SequenceListbox:SetWidth(200)
    SequenceListbox:SetLabel(L["Sequence"])
    local names = {}

    for k, _ in pairs(GSE3Storage[GSE.GetCurrentClassID()]) do
        names[k] = k
    end
    for k, _ in pairs(GSE3Storage[0]) do
        names[k] = k
    end

    SequenceListbox:SetList(names)
    SequenceListbox:SetValue(button)
    SequenceListbox:SetCallback(
        "OnValueChanged",
        function(obj, event, key)
            button = key
        end
    )

    local savebutton = AceGUI:Create("Button")
    savebutton:SetText(L["Save"])

    savebutton:SetCallback(
        "OnClick",
        function()
            if not GSE.isEmpty(SequenceListbox:GetValue()) and not GSE.isEmpty(keybind:GetKey()) then
                if GSE.isEmpty(specialization) then
                    specialization = tostring(GetSpecialization())
                end

                local char = UnitFullName("player")
                local realm = GetRealmName()
                if initialbind and bind ~= initialbind then
                    SetBinding(initialbind)
                    GSE_C["KeyBindings"][char .. "-" .. realm][specialization][bind] = nil
                end

                GSE_C["KeyBindings"][char .. "-" .. realm][specialization][bind] = button
                SetBindingClick(bind, button, _G[button])
                if bind ~= initialbind then
                    rightContainer:ReleaseChildren()
                end
                GSE.ShowKeyBindings()
            end
        end
    )

    local delbutton = AceGUI:Create("Button")
    delbutton:SetText(L["Delete"])

    delbutton:SetCallback(
        "OnClick",
        function()
            SetBinding(initialbind)
            GSE_C["KeyBindings"][char .. "-" .. realm][specialization][initialbind] = nil
            rightContainer:ReleaseChildren()
            GSE.ShowKeyBindings()
        end
    )

    local row = AceGUI:Create("SimpleGroup")
    row:SetFullWidth(true)
    row:SetLayout("Flow")

    row:AddChild(keybind)

    row:AddChild(SequenceListbox)

    local row2 = AceGUI:Create("SimpleGroup")
    row2:SetFullWidth(true)
    row2:SetLayout("Flow")

    row2:AddChild(savebutton)
    row2:AddChild(delbutton)
    rightContainer:AddChild(row)
    rightContainer:AddChild(row2)
    rightContainer:SetWidth(keybindingframe.Width - 290)
end

local function buildKeybindHeader(specialization, bind, button)
    local font = CreateFont("seqPanelFont")
    font:SetFontObject(GameFontNormal)

    local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()
    local origjustificationH = font:GetJustifyH()
    local origjustificationV = font:GetJustifyV()
    font:SetJustifyH("LEFT")
    font:SetJustifyV("MIDDLE")
    local selpanel = AceGUI:Create("SelectablePanel")

    selpanel:SetKey(specialization .. bind)
    selpanel:SetFullWidth(true)
    selpanel:SetHeight(20)
    selpanel:SetAutoAdjustHeight(false)
    selpanel:SetLayout("List")
    local char = UnitFullName("player")
    local realm = GetRealmName()

    keybindingframe.panels[specialization .. bind] = selpanel

    local hlabel = AceGUI:Create("Label")

    hlabel:SetText(bind)
    hlabel:SetWidth(199)
    hlabel:SetFontObject(font)
    hlabel:SetFont(fontName, fontHeight + 2, fontFlags)

    selpanel:AddChild(hlabel)
    selpanel:SetCallback(
        "OnClick",
        function(widget, _, selected, callbutton)
            keybindingframe:clearpanels(widget, selected)
            if callbutton == "RightButton" then
                MenuUtil.CreateContextMenu(
                    selpanel,
                    function(ownerRegion, rootDescription)
                        rootDescription:CreateTitle(L["Manage Macros"])
                        rootDescription:CreateButton(
                            L["New"],
                            function()
                                showKeybind()
                            end
                        )
                        rootDescription:CreateButton(
                            L["Delete"],
                            function()
                                SetBinding(bind)
                                GSE_C["KeyBindings"][char .. "-" .. realm][specialization][bind] = nil
                                GSE.ShowKeyBindings()
                            end
                        )
                    end
                )
            else
                showKeybind(bind, button, specialization)
            end
        end
    )

    leftscroll:AddChild(selpanel)
    font:SetJustifyH(origjustificationH)
    font:SetJustifyV(origjustificationV)
end

local function buildKeybindMenu()
    leftscroll:ReleaseChildren()
    local char = UnitFullName("player")
    local realm = GetRealmName()
    local newButton = AceGUI:Create("Button")
    newButton:SetText(L["New"])
    newButton:SetCallback(
        "OnClick",
        function()
            showKeybind()
        end
    )
    leftscroll:AddChild(newButton)
    local specid = 0
    for k, v in pairs(GSE_C["KeyBindings"][char .. "-" .. realm]) do
        local currentspecid = tonumber(k)
        if specid ~= currentspecid then
            specid = currentspecid
            local _, speclabel = GetSpecializationInfo(currentspecid)
            local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()
            local sectionspacer1 = AceGUI:Create("Label")
            sectionspacer1:SetText(" ")
            sectionspacer1:SetFont(fontName, 4, fontFlags)
            leftscroll:AddChild(sectionspacer1)
            local sectionheader = AceGUI:Create("Label")
            sectionheader:SetText(speclabel)
            sectionheader:SetFont(fontName, fontHeight + 4, fontFlags)
            sectionheader:SetColor(GSE.GUIGetColour(GSEOptions.COMMENT))
            leftscroll:AddChild(sectionheader)
            local sectionspacer2 = AceGUI:Create("Label")
            sectionspacer2:SetText(" ")
            sectionspacer2:SetFont(fontName, 2, fontFlags)
            leftscroll:AddChild(sectionspacer2)
        end

        for i, j in pairs(v) do
            buildKeybindHeader(k, i, j)
        end
    end
end

function keybindingframe:clearpanels(widget, selected)
    for k, _ in pairs(keybindingframe.panels) do
        if k == widget:GetKey() then
            if selected then
                --keybindingframe.showMacro(widget.node)
                keybindingframe.panels[k]:SetClicked(true)
            else
                keybindingframe.panels[k]:SetClicked(false)
            end
        else
            keybindingframe.panels[k]:SetClicked(false)
        end
    end
end

function GSE.ShowKeyBindings()
    buildKeybindMenu()
    keybindingframe:Show()
end