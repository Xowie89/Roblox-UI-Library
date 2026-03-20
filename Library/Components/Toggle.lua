-- Components/Toggle.lua
-- An on/off toggle element with an animated sliding knob.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Toggle = {}
Toggle.__index = Toggle

-- config = {
--   Text      : string     -- label shown beside the toggle
--   Default   : boolean?   -- initial state (default false)
--   Callback  : function?  -- called with (boolean) when state changes
-- }
function Toggle.new(parent, config)
    local self = setmetatable({}, Toggle)

    config       = config or {}
    self._value  = config.Default == true
    self._callback = config.Callback

    -- Container
    local container = Utility.Create("Frame", {
        Name            = "Toggle",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
    }, parent)

    -- Label
    local label = Utility.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, -52, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text            = config.Text or "Toggle",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, container)

    -- Track (the pill-shaped background)
    local trackWidth  = 38
    local trackHeight = 20
    local track = Utility.Create("Frame", {
        Name            = "Track",
        Size            = UDim2.new(0, trackWidth, 0, trackHeight),
        Position        = UDim2.new(1, -(trackWidth + 8), 0.5, -trackHeight / 2),
        BackgroundColor3 = self._value and Theme.Colors.ToggleOn or Theme.Colors.ToggleOff,
    }, container)

    Utility.AddCorner(track, UDim.new(0.5, 0))

    -- Knob
    local knobSize   = trackHeight - 4
    local knobOffX   = self._value and (trackWidth - knobSize - 2) or 2
    local knob = Utility.Create("Frame", {
        Name            = "Knob",
        Size            = UDim2.new(0, knobSize, 0, knobSize),
        Position        = UDim2.new(0, knobOffX, 0.5, -knobSize / 2),
        BackgroundColor3 = Theme.Colors.ToggleKnob,
    }, track)

    Utility.AddCorner(knob, UDim.new(0.5, 0))

    -- Invisible click region over the whole container
    local clickRegion = Utility.Create("TextButton", {
        Name            = "ClickRegion",
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = container.ZIndex + 1,
    }, container)

    clickRegion.MouseButton1Click:Connect(function()
        self:_toggle()
    end)

    self._container = container
    self._track     = track
    self._knob      = knob
    self._label     = label
    self._trackWidth  = trackWidth
    self._knobSize    = knobSize

    return self
end

function Toggle:_toggle()
    self._value = not self._value
    self:_updateVisuals()
    if type(self._callback) == "function" then
        self._callback(self._value)
    end
end

function Toggle:_updateVisuals()
    local knobOffset = self._value and (self._trackWidth - self._knobSize - 2) or 2
    Utility.Tween(self._track, Theme.Tween.Short, {
        BackgroundColor3 = self._value and Theme.Colors.ToggleOn or Theme.Colors.ToggleOff,
    })
    Utility.Tween(self._knob, Theme.Tween.Short, {
        Position = UDim2.new(0, knobOffset, 0.5, -self._knobSize / 2),
    })
end

-- Returns the current boolean value.
function Toggle:GetValue()
    return self._value
end

-- Programmatically sets the toggle state (fires callback).
function Toggle:SetValue(value)
    if value ~= self._value then
        self._value = value
        self:_updateVisuals()
        if type(self._callback) == "function" then
            self._callback(self._value)
        end
    end
end

-- Destroys the element.
function Toggle:Destroy()
    self._container:Destroy()
end

return Toggle
