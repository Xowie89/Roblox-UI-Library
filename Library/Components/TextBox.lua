-- Components/TextBox.lua
-- A text-input element with a Steam-styled border that highlights on focus.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local TextBox = {}
TextBox.__index = TextBox

-- config = {
--   Text            : string     -- label above the input
--   PlaceholderText : string?    -- greyed-out placeholder text
--   Default         : string?    -- pre-filled value
--   ClearOnFocus    : boolean?   -- clear text when input is focused (default false)
--   Callback        : function?  -- called with (string) when input is confirmed (Enter / focus lost)
-- }
function TextBox.new(parent, config)
    local self = setmetatable({}, TextBox)

    config         = config or {}
    self._callback = config.Callback

    local totalHeight = Theme.Layout.ElementHeight * 2

    local container = Utility.Create("Frame", {
        Name            = "TextBox",
        Size            = UDim2.new(1, 0, 0, totalHeight),
        BackgroundTransparency = 1,
    }, parent)

    -- Label
    local label = Utility.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
        Text            = config.Text or "Text Input",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, container)

    Utility.AddPadding(label, 0, 0, 0, 8)

    -- Input box background
    local inputBg = Utility.Create("Frame", {
        Name            = "InputBg",
        Size            = UDim2.new(1, -8, 0, Theme.Layout.ElementHeight - 4),
        Position        = UDim2.new(0, 4, 0, Theme.Layout.ElementHeight + 2),
        BackgroundColor3 = Theme.Colors.SecondaryBackground,
    }, container)

    Utility.AddCorner(inputBg, Theme.Layout.CornerRadius)
    local stroke = Utility.AddStroke(inputBg, Theme.Colors.Border, 1)

    -- Actual Roblox TextBox
    local textBox = Utility.Create("TextBox", {
        Name            = "Input",
        Size            = UDim2.new(1, -8, 1, 0),
        Position        = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Text            = config.Default or "",
        PlaceholderText = config.PlaceholderText or "Type here…",
        PlaceholderColor3 = Theme.Colors.TextDisabled,
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClearTextOnFocus = config.ClearOnFocus == true,
    }, inputBg)

    -- Highlight border on focus
    textBox.Focused:Connect(function()
        Utility.Tween(stroke, Theme.Tween.Short, { Color = Theme.Colors.Accent })
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        Utility.Tween(stroke, Theme.Tween.Short, { Color = Theme.Colors.Border })
        if type(self._callback) == "function" then
            self._callback(textBox.Text, enterPressed)
        end
    end)

    self._container = container
    self._textBox   = textBox
    self._label     = label

    return self
end

-- Returns the current text value.
function TextBox:GetValue()
    return self._textBox.Text
end

-- Programmatically sets the text value (does NOT fire callback).
function TextBox:SetValue(text)
    self._textBox.Text = tostring(text)
end

-- Destroys the element.
function TextBox:Destroy()
    self._container:Destroy()
end

return TextBox
