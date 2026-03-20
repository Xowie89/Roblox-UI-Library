-- Components/Label.lua
-- A static read-only text label element.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Label = {}
Label.__index = Label

-- config = {
--   Text        : string   -- label text
--   TextColor   : Color3?  -- optional override
-- }
function Label.new(parent, config)
    local self = setmetatable({}, Label)

    config = config or {}

    local container = Utility.Create("Frame", {
        Name            = "Label",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
    }, parent)

    local textLabel = Utility.Create("TextLabel", {
        Name            = "Text",
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = config.Text or "Label",
        TextColor3      = config.TextColor or Theme.Colors.TextSecondary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, container)

    Utility.AddPadding(container, 0, 4, 0, 8)

    self._container = container
    self._label     = textLabel

    return self
end

-- Updates the label text at runtime.
function Label:SetText(text)
    self._label.Text = tostring(text)
end

-- Destroys the element.
function Label:Destroy()
    self._container:Destroy()
end

return Label
