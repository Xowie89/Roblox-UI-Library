-- Utility.lua
-- Shared helper functions used by every component in the library.

local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")

local Utility = {}

-- ── Instance creation ─────────────────────────────────────────────────────────

-- Creates a new Roblox Instance, applies a property table, and optionally
-- parents it to `parent`.  Returns the new instance.
function Utility.Create(className, properties, parent)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

-- Applies UICorner to `instance` using the given UDim radius.
function Utility.AddCorner(instance, radius)
    return Utility.Create("UICorner", { CornerRadius = radius }, instance)
end

-- Applies UIStroke to `instance`.
function Utility.AddStroke(instance, color, thickness, transparency)
    return Utility.Create("UIStroke", {
        Color       = color       or Color3.fromRGB(55, 71, 90),
        Thickness   = thickness   or 1,
        Transparency = transparency or 0,
    }, instance)
end

-- Applies UIPadding to `instance` with uniform or per-side padding values.
function Utility.AddPadding(instance, top, right, bottom, left)
    top    = top    or 0
    right  = right  or top
    bottom = bottom or top
    left   = left   or right
    return Utility.Create("UIPadding", {
        PaddingTop    = UDim.new(0, top),
        PaddingRight  = UDim.new(0, right),
        PaddingBottom = UDim.new(0, bottom),
        PaddingLeft   = UDim.new(0, left),
    }, instance)
end

-- Applies UIListLayout to `instance`.
function Utility.AddListLayout(instance, direction, padding, halign, valign)
    return Utility.Create("UIListLayout", {
        FillDirection       = direction or Enum.FillDirection.Vertical,
        Padding             = UDim.new(0, padding or 0),
        HorizontalAlignment = halign    or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = valign    or Enum.VerticalAlignment.Top,
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }, instance)
end

-- ── Tweening ──────────────────────────────────────────────────────────────────

-- Plays a tween on `instance`, animating `properties` using `tweenInfo`.
-- Returns the Tween object.
function Utility.Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ── Dragging ──────────────────────────────────────────────────────────────────

-- Makes `frame` draggable by dragging `handle`.
-- Both parameters must be GuiObjects.
function Utility.MakeDraggable(handle, frame)
    local dragging     = false
    local dragStart    = Vector2.zero
    local frameStart   = Vector2.zero

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging   = true
            dragStart  = Vector2.new(input.Position.X, input.Position.Y)
            frameStart = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            frame.Position = UDim2.new(
                0, frameStart.X + delta.X,
                0, frameStart.Y + delta.Y
            )
        end
    end)
end

-- ── Miscellaneous ─────────────────────────────────────────────────────────────

-- Clamps `value` between `min` and `max`.
function Utility.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Rounds `value` to `decimals` decimal places.
function Utility.Round(value, decimals)
    local factor = 10 ^ (decimals or 0)
    return math.floor(value * factor + 0.5) / factor
end

-- Returns a string representation of a KeyCode (e.g. Enum.KeyCode.E → "E").
function Utility.KeyCodeName(keyCode)
    local name = keyCode.Name
    -- Strip the leading "Key" prefix that some codes have (e.g. "KeypadEnter")
    return name
end

-- Connects a hover-highlight effect to `element`.
-- `normalColor` and `hoverColor` should be Color3 values.
-- `property` defaults to "BackgroundColor3".
function Utility.HoverEffect(element, normalColor, hoverColor, tweenInfo, property)
    property = property or "BackgroundColor3"
    element.MouseEnter:Connect(function()
        Utility.Tween(element, tweenInfo, { [property] = hoverColor })
    end)
    element.MouseLeave:Connect(function()
        Utility.Tween(element, tweenInfo, { [property] = normalColor })
    end)
end

return Utility
