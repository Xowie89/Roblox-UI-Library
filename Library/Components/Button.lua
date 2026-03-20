-- Components/Button.lua
-- A clickable button element with Steam-styled hover and press animations.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Button = {}
Button.__index = Button

-- config = {
--   Text      : string     -- button label
--   Callback  : function?  -- called when the button is clicked
-- }
function Button.new(parent, config)
    local self = setmetatable({}, Button)

    config         = config or {}
    self._callback = config.Callback

    -- Outer container (transparent, reserves vertical space)
    local container = Utility.Create("Frame", {
        Name            = "Button",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
    }, parent)

    -- Visible button body
    local body = Utility.Create("TextButton", {
        Name            = "Body",
        Size            = UDim2.new(1, -8, 1, 0),
        Position        = UDim2.new(0, 4, 0, 0),
        BackgroundColor3 = Theme.Colors.ButtonDefault,
        Text            = config.Text or "Button",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Default,
        TextSize        = Theme.TextSize.Body,
        AutoButtonColor = false,
    }, container)

    Utility.AddCorner(body, Theme.Layout.CornerRadius)
    Utility.AddStroke(body, Theme.Colors.Border, 1)

    -- Hover / press colours
    Utility.HoverEffect(body, Theme.Colors.ButtonDefault, Theme.Colors.ButtonHover, Theme.Tween.Short)

    body.MouseButton1Down:Connect(function()
        Utility.Tween(body, Theme.Tween.Short, { BackgroundColor3 = Theme.Colors.ButtonActive })
    end)

    body.MouseButton1Up:Connect(function()
        Utility.Tween(body, Theme.Tween.Short, { BackgroundColor3 = Theme.Colors.ButtonHover })
    end)

    body.MouseButton1Click:Connect(function()
        if type(self._callback) == "function" then
            self._callback()
        end
    end)

    self._container = container
    self._body      = body

    return self
end

-- Updates the button label at runtime.
function Button:SetText(text)
    self._body.Text = tostring(text)
end

-- Replaces the callback at runtime.
function Button:SetCallback(fn)
    self._callback = fn
end

-- Destroys the element.
function Button:Destroy()
    self._container:Destroy()
end

return Button
