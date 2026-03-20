-- Components/Window.lua
-- A draggable, closable window frame that hosts the tab bar and tab pages.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)
local Tab     = require(script.Parent.Tab)

local Window = {}
Window.__index = Window

-- config = {
--   Title     : string     -- window title text
--   Size      : UDim2?     -- window size (default 520 × 400)
--   Position  : UDim2?     -- window position (default centred)
--   Parent    : Instance?  -- parent for the ScreenGui (default PlayerGui)
-- }
function Window.new(config)
    local self = setmetatable({}, Window)

    config = config or {}

    local Players = game:GetService("Players")
    local guiParent = config.Parent
        or (Players.LocalPlayer and Players.LocalPlayer:WaitForChild("PlayerGui"))
        or game:GetService("CoreGui")

    -- ── ScreenGui ─────────────────────────────────────────────────────────────
    local screenGui = Utility.Create("ScreenGui", {
        Name                  = "SteamUILibrary",
        ResetOnSpawn          = false,
        ZIndexBehavior        = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset        = true,
    }, guiParent)

    -- ── Main window frame ─────────────────────────────────────────────────────
    local size     = config.Size     or UDim2.new(0, 520, 0, 400)
    local position = config.Position or UDim2.new(0.5, -260, 0.5, -200)

    local frame = Utility.Create("Frame", {
        Name            = "Window",
        Size            = size,
        Position        = position,
        BackgroundColor3 = Theme.Colors.Background,
    }, screenGui)

    Utility.AddCorner(frame, Theme.Layout.CornerRadiusLarge)
    Utility.AddStroke(frame, Theme.Colors.TitleBarBorder, 1)

    -- Drop shadow (decorative)
    local shadow = Utility.Create("ImageLabel", {
        Name            = "Shadow",
        Size            = UDim2.new(1, 24, 1, 24),
        Position        = UDim2.new(0, -12, 0, -12),
        BackgroundTransparency = 1,
        Image           = "rbxassetid://5554236805",
        ImageColor3     = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType       = Enum.ScaleType.Slice,
        SliceCenter     = Rect.new(23, 23, 277, 277),
        ZIndex          = frame.ZIndex - 1,
    }, frame)

    -- ── Title bar ─────────────────────────────────────────────────────────────
    local titleBar = Utility.Create("Frame", {
        Name            = "TitleBar",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.TitleBarHeight),
        BackgroundColor3 = Theme.Colors.TitleBar,
    }, frame)

    -- Round only the top corners of the title bar
    Utility.AddCorner(titleBar, Theme.Layout.CornerRadiusLarge)
    Utility.Create("Frame", {
        Name            = "BottomCover",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.CornerRadiusLarge.Offset),
        Position        = UDim2.new(0, 0, 1, -Theme.Layout.CornerRadiusLarge.Offset),
        BackgroundColor3 = Theme.Colors.TitleBar,
        BorderSizePixel = 0,
    }, titleBar)

    -- Steam logo / icon area (solid accent circle)
    local iconSize = 20
    local icon = Utility.Create("Frame", {
        Name            = "Icon",
        Size            = UDim2.new(0, iconSize, 0, iconSize),
        Position        = UDim2.new(0, 10, 0.5, -iconSize / 2),
        BackgroundColor3 = Theme.Colors.Accent,
    }, titleBar)

    Utility.AddCorner(icon, UDim.new(0.5, 0))

    -- Title text
    local titleLabel = Utility.Create("TextLabel", {
        Name            = "Title",
        Size            = UDim2.new(1, -(iconSize + 60), 1, 0),
        Position        = UDim2.new(0, iconSize + 18, 0, 0),
        BackgroundTransparency = 1,
        Text            = config.Title or "Steam UI Library",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Bold,
        TextSize        = Theme.TextSize.Title,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, titleBar)

    -- Close button
    local closeBtn = Utility.Create("TextButton", {
        Name            = "CloseButton",
        Size            = UDim2.new(0, 28, 0, 28),
        Position        = UDim2.new(1, -34, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(196, 59, 43),
        Text            = "✕",
        TextColor3      = Color3.fromRGB(255, 255, 255),
        Font            = Theme.Fonts.Bold,
        TextSize        = 13,
        AutoButtonColor = false,
    }, titleBar)

    Utility.AddCorner(closeBtn, UDim.new(0.5, 0))
    Utility.HoverEffect(closeBtn, Color3.fromRGB(196, 59, 43), Color3.fromRGB(220, 80, 60), Theme.Tween.Short)

    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    -- Separator beneath title bar
    Utility.Create("Frame", {
        Name            = "Separator",
        Size            = UDim2.new(1, 0, 0, 1),
        Position        = UDim2.new(0, 0, 0, Theme.Layout.TitleBarHeight),
        BackgroundColor3 = Theme.Colors.TitleBarBorder,
        BorderSizePixel = 0,
    }, frame)

    -- ── Tab bar ───────────────────────────────────────────────────────────────
    local tabBarTop = Theme.Layout.TitleBarHeight + 1

    local tabBar = Utility.Create("Frame", {
        Name            = "TabBar",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.TabBarHeight),
        Position        = UDim2.new(0, 0, 0, tabBarTop),
        BackgroundColor3 = Theme.Colors.SecondaryBackground,
        ClipsDescendants = true,
    }, frame)

    Utility.AddListLayout(tabBar, Enum.FillDirection.Horizontal, 2,
        Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
    Utility.AddPadding(tabBar, 0, 6, 0, 6)

    -- Bottom separator under tab bar
    Utility.Create("Frame", {
        Name            = "Separator",
        Size            = UDim2.new(1, 0, 0, 1),
        Position        = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Colors.TitleBarBorder,
        BorderSizePixel = 0,
    }, tabBar)

    -- ── Page holder ───────────────────────────────────────────────────────────
    local pageTop = tabBarTop + Theme.Layout.TabBarHeight + 1

    local pageHolder = Utility.Create("Frame", {
        Name            = "PageHolder",
        Size            = UDim2.new(1, 0, 1, -pageTop),
        Position        = UDim2.new(0, 0, 0, pageTop),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, frame)

    -- ── Dragging ──────────────────────────────────────────────────────────────
    Utility.MakeDraggable(titleBar, frame)

    self._screenGui  = screenGui
    self._frame      = frame
    self._tabBar     = tabBar
    self._pageHolder = pageHolder
    self._tabs       = {}
    self._activeTab  = nil
    self._visible    = true

    return self
end

-- Adds a new tab and returns the Tab object.
function Window:AddTab(label)
    local isFirst = #self._tabs == 0
    local tab = Tab.new(self._tabBar, self._pageHolder, label, isFirst)

    table.insert(self._tabs, tab)
    if isFirst then
        self._activeTab = tab
    end

    tab:_registerClickCallback(function()
        self:_activateTab(tab)
    end)

    return tab
end

function Window:_activateTab(targetTab)
    for _, t in ipairs(self._tabs) do
        if t == targetTab then
            t:Activate()
        else
            t:Deactivate()
        end
    end
    self._activeTab = targetTab
end

-- Toggles the window visibility.
function Window:Toggle()
    self._visible = not self._visible
    self._frame.Visible = self._visible
end

-- Shows the window.
function Window:Show()
    self._visible = true
    self._frame.Visible = true
end

-- Hides the window.
function Window:Hide()
    self._visible = false
    self._frame.Visible = false
end

-- Destroys the entire GUI.
function Window:Destroy()
    self._screenGui:Destroy()
end

return Window
