-- Components/Slider.lua
-- A numeric slider element with a draggable thumb and live value label.

local UserInputService = game:GetService("UserInputService")

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Slider = {}
Slider.__index = Slider

-- config = {
--   Text      : string     -- label shown above the slider
--   Min       : number     -- minimum value  (default 0)
--   Max       : number     -- maximum value  (default 100)
--   Default   : number?    -- initial value  (default Min)
--   Decimals  : number?    -- decimal places (default 0)
--   Suffix    : string?    -- appended to value display (e.g. "%")
--   Callback  : function?  -- called with (number) when value changes
-- }
function Slider.new(parent, config)
    local self = setmetatable({}, Slider)

    config          = config or {}
    self._min       = config.Min      or 0
    self._max       = config.Max      or 100
    self._decimals  = config.Decimals or 0
    self._suffix    = config.Suffix   or ""
    self._callback  = config.Callback
    self._dragging  = false

    local clampedDefault = Utility.Clamp(
        config.Default ~= nil and config.Default or self._min,
        self._min, self._max
    )
    self._value = clampedDefault

    -- ── Layout: total height = label row + slider row ─────────────────────────
    local totalHeight = Theme.Layout.ElementHeight * 2

    local container = Utility.Create("Frame", {
        Name            = "Slider",
        Size            = UDim2.new(1, 0, 0, totalHeight),
        BackgroundTransparency = 1,
    }, parent)

    -- Top row: text label + value display
    local labelRow = Utility.Create("Frame", {
        Name            = "LabelRow",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
    }, container)

    local label = Utility.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(0.7, 0, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text            = config.Text or "Slider",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, labelRow)

    local valueLabel = Utility.Create("TextLabel", {
        Name            = "Value",
        Size            = UDim2.new(0.3, -8, 1, 0),
        Position        = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text            = tostring(clampedDefault) .. self._suffix,
        TextColor3      = Theme.Colors.TextAccent,
        Font            = Theme.Fonts.Default,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Right,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, labelRow)

    -- Bottom row: track
    local sliderRow = Utility.Create("Frame", {
        Name            = "SliderRow",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        Position        = UDim2.new(0, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
    }, container)

    local trackHeight = 6
    local track = Utility.Create("Frame", {
        Name            = "Track",
        Size            = UDim2.new(1, -16, 0, trackHeight),
        Position        = UDim2.new(0, 8, 0.5, -trackHeight / 2),
        BackgroundColor3 = Theme.Colors.SliderTrack,
    }, sliderRow)

    Utility.AddCorner(track, UDim.new(0.5, 0))

    -- Filled portion
    local initialRatio = (clampedDefault - self._min) / math.max(1, self._max - self._min)
    local fill = Utility.Create("Frame", {
        Name            = "Fill",
        Size            = UDim2.new(initialRatio, 0, 1, 0),
        BackgroundColor3 = Theme.Colors.SliderFill,
    }, track)

    Utility.AddCorner(fill, UDim.new(0.5, 0))

    -- Thumb
    local thumbSize = 14
    local thumb = Utility.Create("Frame", {
        Name            = "Thumb",
        Size            = UDim2.new(0, thumbSize, 0, thumbSize),
        Position        = UDim2.new(initialRatio, -thumbSize / 2, 0.5, -thumbSize / 2),
        BackgroundColor3 = Theme.Colors.Accent,
        ZIndex          = track.ZIndex + 1,
    }, track)

    Utility.AddCorner(thumb, UDim.new(0.5, 0))

    -- Invisible drag region over the full track
    local dragRegion = Utility.Create("TextButton", {
        Name            = "DragRegion",
        Size            = UDim2.new(1, 0, 3, 0),
        Position        = UDim2.new(0, 0, -1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = track.ZIndex + 2,
    }, track)

    -- ── Drag logic ────────────────────────────────────────────────────────────

    local function updateFromX(absX)
        local trackAbs  = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        local ratio     = Utility.Clamp((absX - trackAbs.X) / trackSize.X, 0, 1)
        local rawValue  = self._min + ratio * (self._max - self._min)
        local newValue  = Utility.Round(rawValue, self._decimals)

        if newValue ~= self._value then
            self._value = newValue
            fill.Size   = UDim2.new(ratio, 0, 1, 0)
            thumb.Position = UDim2.new(ratio, -thumbSize / 2, 0.5, -thumbSize / 2)
            valueLabel.Text = tostring(newValue) .. self._suffix
            if type(self._callback) == "function" then
                self._callback(newValue)
            end
        end
    end

    dragRegion.MouseButton1Down:Connect(function(x, _y)
        self._dragging = true
        updateFromX(x)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self._dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._dragging = false
        end
    end)

    self._container  = container
    self._fill       = fill
    self._thumb      = thumb
    self._valueLabel = valueLabel
    self._thumbSize  = thumbSize

    return self
end

-- Returns the current numeric value.
function Slider:GetValue()
    return self._value
end

-- Programmatically sets the slider value (fires callback).
function Slider:SetValue(value)
    local clamped = Utility.Clamp(Utility.Round(value, self._decimals), self._min, self._max)
    self._value = clamped
    local ratio = (clamped - self._min) / math.max(1, self._max - self._min)
    self._fill.Size        = UDim2.new(ratio, 0, 1, 0)
    self._thumb.Position   = UDim2.new(ratio, -self._thumbSize / 2, 0.5, -self._thumbSize / 2)
    self._valueLabel.Text  = tostring(clamped) .. self._suffix
    if type(self._callback) == "function" then
        self._callback(clamped)
    end
end

-- Destroys the element.
function Slider:Destroy()
    self._container:Destroy()
end

return Slider
