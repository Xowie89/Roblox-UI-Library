-- Components/Keybind.lua
-- A keybind picker element.  Click to listen, press a key to bind.

local UserInputService = game:GetService("UserInputService")

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Keybind = {}
Keybind.__index = Keybind

-- config = {
--   Text      : string           -- label shown beside the keybind
--   Default   : Enum.KeyCode?    -- initial keybind (default: none)
--   Callback  : function?        -- called with (Enum.KeyCode) when key is bound
-- }
function Keybind.new(parent, config)
    local self = setmetatable({}, Keybind)

    config          = config or {}
    self._keyCode   = config.Default  -- may be nil
    self._callback  = config.Callback
    self._listening = false
    self._connection = nil

    local container = Utility.Create("Frame", {
        Name            = "Keybind",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.ElementHeight),
        BackgroundTransparency = 1,
    }, parent)

    -- Label
    local label = Utility.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, -90, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text            = config.Text or "Keybind",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, container)

    -- Keybind display button
    local btnWidth = 78
    local bindBtn = Utility.Create("TextButton", {
        Name            = "BindButton",
        Size            = UDim2.new(0, btnWidth, 0, 22),
        Position        = UDim2.new(1, -(btnWidth + 8), 0.5, -11),
        BackgroundColor3 = Theme.Colors.ElementBackground,
        Text            = self._keyCode and Utility.KeyCodeName(self._keyCode) or "None",
        TextColor3      = Theme.Colors.TextAccent,
        Font            = Theme.Fonts.Default,
        TextSize        = Theme.TextSize.Small,
        AutoButtonColor = false,
    }, container)

    Utility.AddCorner(bindBtn, Theme.Layout.CornerRadius)
    Utility.AddStroke(bindBtn, Theme.Colors.Border, 1)

    -- Click to start listening
    bindBtn.MouseButton1Click:Connect(function()
        if self._listening then return end
        self:_startListening(bindBtn)
    end)

    self._container = container
    self._bindBtn   = bindBtn

    return self
end

function Keybind:_startListening(btn)
    self._listening = true
    btn.Text       = "…"
    btn.TextColor3 = Theme.Colors.Accent

    self._connection = UserInputService.InputBegan:Connect(function(input, gameHandled)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        -- Allow Escape to cancel
        if input.KeyCode == Enum.KeyCode.Escape then
            self:_stopListening()
            btn.Text       = self._keyCode and Utility.KeyCodeName(self._keyCode) or "None"
            btn.TextColor3 = Theme.Colors.TextAccent
            return
        end

        self._keyCode = input.KeyCode
        self:_stopListening()

        btn.Text       = Utility.KeyCodeName(self._keyCode)
        btn.TextColor3 = Theme.Colors.TextAccent

        if type(self._callback) == "function" then
            self._callback(self._keyCode)
        end
    end)
end

function Keybind:_stopListening()
    self._listening = false
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
end

-- Returns the current Enum.KeyCode (may be nil if none set).
function Keybind:GetValue()
    return self._keyCode
end

-- Programmatically sets the keybind (fires callback).
function Keybind:SetValue(keyCode)
    self._keyCode        = keyCode
    self._bindBtn.Text   = keyCode and Utility.KeyCodeName(keyCode) or "None"
    if type(self._callback) == "function" then
        self._callback(keyCode)
    end
end

-- Destroys the element.
function Keybind:Destroy()
    self:_stopListening()
    self._container:Destroy()
end

return Keybind
