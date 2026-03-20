-- Components/Dropdown.lua
-- A dropdown list element with animated expand/collapse.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Dropdown = {}
Dropdown.__index = Dropdown

-- config = {
--   Text      : string     -- label shown above the dropdown
--   Options   : {string}   -- list of selectable option strings
--   Default   : string?    -- initially selected option
--   Callback  : function?  -- called with (selectedString) when changed
-- }
function Dropdown.new(parent, config)
    local self = setmetatable({}, Dropdown)

    config         = config or {}
    self._options  = config.Options  or {}
    self._callback = config.Callback
    self._open     = false
    self._selected = config.Default or (self._options[1] or "Select…")
    self._itemHeight = Theme.Layout.ElementHeight

    -- ── Closed-state row ─────────────────────────────────────────────────────
    local closedHeight = Theme.Layout.ElementHeight
    local container = Utility.Create("Frame", {
        Name            = "Dropdown",
        Size            = UDim2.new(1, 0, 0, closedHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, parent)

    -- Label
    local label = Utility.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, 0, 0, closedHeight),
        BackgroundTransparency = 1,
        Text            = config.Text or "Dropdown",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, container)

    Utility.AddPadding(label, 0, 0, 0, 8)

    -- Selected display row
    local selectedRow = Utility.Create("Frame", {
        Name            = "SelectedRow",
        Size            = UDim2.new(1, -8, 0, closedHeight - 4),
        Position        = UDim2.new(0, 4, 0, 2),
        BackgroundColor3 = Theme.Colors.ElementBackground,
    }, container)

    Utility.AddCorner(selectedRow, Theme.Layout.CornerRadius)
    Utility.AddStroke(selectedRow, Theme.Colors.Border, 1)

    local selectedLabel = Utility.Create("TextLabel", {
        Name            = "SelectedText",
        Size            = UDim2.new(1, -28, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text            = self._selected,
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, selectedRow)

    -- Arrow indicator
    local arrow = Utility.Create("TextLabel", {
        Name            = "Arrow",
        Size            = UDim2.new(0, 20, 1, 0),
        Position        = UDim2.new(1, -24, 0, 0),
        BackgroundTransparency = 1,
        Text            = "▾",
        TextColor3      = Theme.Colors.TextSecondary,
        Font            = Theme.Fonts.Bold,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Center,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, selectedRow)

    -- ── Options list (hidden initially) ──────────────────────────────────────
    local listTopOffset = closedHeight + 2
    local optionList = Utility.Create("Frame", {
        Name            = "OptionList",
        Size            = UDim2.new(1, -8, 0, #self._options * self._itemHeight),
        Position        = UDim2.new(0, 4, 0, listTopOffset),
        BackgroundColor3 = Theme.Colors.DropdownBackground,
        Visible         = false,
        ZIndex          = 5,
    }, container)

    Utility.AddCorner(optionList, Theme.Layout.CornerRadius)
    Utility.AddStroke(optionList, Theme.Colors.Border, 1)
    Utility.AddListLayout(optionList, Enum.FillDirection.Vertical, 0)

    -- Build option buttons
    for _, option in ipairs(self._options) do
        local optBtn = Utility.Create("TextButton", {
            Name            = option,
            Size            = UDim2.new(1, 0, 0, self._itemHeight),
            BackgroundColor3 = Theme.Colors.DropdownBackground,
            Text            = option,
            TextColor3      = Theme.Colors.TextPrimary,
            Font            = Theme.Fonts.Regular,
            TextSize        = Theme.TextSize.Body,
            TextXAlignment  = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex          = 6,
        }, optionList)

        Utility.AddPadding(optBtn, 0, 0, 0, 8)
        Utility.HoverEffect(optBtn, Theme.Colors.DropdownBackground, Theme.Colors.DropdownHover, Theme.Tween.Short)

        optBtn.MouseButton1Click:Connect(function()
            self:_select(option)
        end)
    end

    -- ── Toggle open/closed on click ───────────────────────────────────────────
    local clickBtn = Utility.Create("TextButton", {
        Name            = "ClickRegion",
        Size            = UDim2.new(1, 0, 0, closedHeight),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = selectedRow.ZIndex + 1,
    }, container)

    clickBtn.MouseButton1Click:Connect(function()
        self:_toggleOpen()
    end)

    self._container    = container
    self._selectedLabel = selectedLabel
    self._arrow        = arrow
    self._optionList   = optionList
    self._closedHeight = closedHeight
    self._listTopOffset = listTopOffset

    return self
end

function Dropdown:_toggleOpen()
    self._open = not self._open
    self._optionList.Visible = self._open
    local openHeight = self._closedHeight + 2
        + (#self._options * self._itemHeight)
    Utility.Tween(self._container, Theme.Tween.Short, {
        Size = UDim2.new(1, 0, 0, self._open and openHeight or self._closedHeight),
    })
    self._arrow.Text = self._open and "▴" or "▾"
end

function Dropdown:_select(option)
    self._selected = option
    self._selectedLabel.Text = option
    if self._open then
        self:_toggleOpen()
    end
    if type(self._callback) == "function" then
        self._callback(option)
    end
end

-- Returns the currently selected option string.
function Dropdown:GetValue()
    return self._selected
end

-- Programmatically selects an option (fires callback).
function Dropdown:SetValue(option)
    self:_select(option)
end

-- Replaces the option list and resets selection.
function Dropdown:SetOptions(options)
    self._options = options
    self._optionList:ClearAllChildren()
    Utility.AddListLayout(self._optionList, Enum.FillDirection.Vertical, 0)
    for _, option in ipairs(options) do
        local optBtn = Utility.Create("TextButton", {
            Name            = option,
            Size            = UDim2.new(1, 0, 0, self._itemHeight),
            BackgroundColor3 = Theme.Colors.DropdownBackground,
            Text            = option,
            TextColor3      = Theme.Colors.TextPrimary,
            Font            = Theme.Fonts.Regular,
            TextSize        = Theme.TextSize.Body,
            TextXAlignment  = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex          = 6,
        }, self._optionList)
        Utility.AddPadding(optBtn, 0, 0, 0, 8)
        Utility.HoverEffect(optBtn, Theme.Colors.DropdownBackground, Theme.Colors.DropdownHover, Theme.Tween.Short)
        optBtn.MouseButton1Click:Connect(function()
            self:_select(option)
        end)
    end
    self._optionList.Size = UDim2.new(1, -8, 0, #options * self._itemHeight)
end

-- Destroys the element.
function Dropdown:Destroy()
    self._container:Destroy()
end

return Dropdown
