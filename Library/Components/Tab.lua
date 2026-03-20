-- Components/Tab.lua
-- Manages a single tab page: its button in the tab bar and its scrollable content frame.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)
local Section = require(script.Parent.Section)

local Tab = {}
Tab.__index = Tab

-- `tabBar`    : Frame — the horizontal strip of tab buttons
-- `pageHolder`: Frame — the parent that holds all tab content pages
-- `label`     : string — displayed tab name
-- `isFirst`   : boolean — whether this is the first tab (active by default)
function Tab.new(tabBar, pageHolder, label, isFirst)
    local self = setmetatable({}, Tab)

    self._active = isFirst == true

    -- ── Tab button ────────────────────────────────────────────────────────────
    local button = Utility.Create("TextButton", {
        Name            = "Tab_" .. label,
        Size            = UDim2.new(0, 0, 1, 0),  -- width driven by AutomaticSize
        AutomaticSize   = Enum.AutomaticSize.X,
        BackgroundColor3 = self._active and Theme.Colors.TabActive or Theme.Colors.TabInactive,
        Text            = "",
        AutoButtonColor = false,
    }, tabBar)

    Utility.AddCorner(button, Theme.Layout.CornerRadius)

    -- Bottom cover to hide the bottom rounded corners (tabs sit above the page)
    Utility.Create("Frame", {
        Name            = "BottomCover",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.CornerRadius.Offset),
        Position        = UDim2.new(0, 0, 1, -Theme.Layout.CornerRadius.Offset),
        BackgroundColor3 = self._active and Theme.Colors.TabActive or Theme.Colors.TabInactive,
        BorderSizePixel = 0,
    }, button)

    local buttonText = Utility.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = self._active and Theme.Colors.TextPrimary or Theme.Colors.TextSecondary,
        Font            = self._active and Theme.Fonts.Default or Theme.Fonts.Regular,
        TextSize        = Theme.TextSize.Body,
        TextXAlignment  = Enum.TextXAlignment.Center,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, button)

    Utility.AddPadding(button, 0, 14, 0, 14)

    -- Active indicator line at the bottom of the tab button
    local activeLine = Utility.Create("Frame", {
        Name            = "ActiveLine",
        Size            = UDim2.new(1, 0, 0, 2),
        Position        = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.Colors.Accent,
        Visible         = self._active,
    }, button)

    -- ── Content page ──────────────────────────────────────────────────────────
    local page = Utility.Create("ScrollingFrame", {
        Name            = "Page_" .. label,
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Colors.Scrollbar,
        Visible         = self._active,
        CanvasSize      = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, pageHolder)

    Utility.AddListLayout(page, Enum.FillDirection.Vertical, Theme.Layout.SectionPadding)
    Utility.AddPadding(page, Theme.Layout.SectionPadding, Theme.Layout.SectionPadding,
        Theme.Layout.SectionPadding, Theme.Layout.SectionPadding)

    self._button     = button
    self._buttonText = buttonText
    self._activeLine = activeLine
    self._page       = page

    return self
end

-- Called by the Window to wire up mutual deactivation between tabs.
function Tab:_registerClickCallback(callback)
    self._button.MouseButton1Click:Connect(callback)

    -- Hover effect only when inactive
    self._button.MouseEnter:Connect(function()
        if not self._active then
            Utility.Tween(self._button, Theme.Tween.Short, { BackgroundColor3 = Theme.Colors.TabHover })
        end
    end)
    self._button.MouseLeave:Connect(function()
        if not self._active then
            Utility.Tween(self._button, Theme.Tween.Short, { BackgroundColor3 = Theme.Colors.TabInactive })
        end
    end)
end

-- Activates this tab (shows its page, styles button as active).
function Tab:Activate()
    self._active = true
    self._page.Visible = true
    self._activeLine.Visible = true
    Utility.Tween(self._button, Theme.Tween.Short, { BackgroundColor3 = Theme.Colors.TabActive })
    self._buttonText.TextColor3 = Theme.Colors.TextPrimary
    self._buttonText.Font       = Theme.Fonts.Default
end

-- Deactivates this tab (hides its page, styles button as inactive).
function Tab:Deactivate()
    self._active = false
    self._page.Visible = false
    self._activeLine.Visible = false
    Utility.Tween(self._button, Theme.Tween.Short, { BackgroundColor3 = Theme.Colors.TabInactive })
    self._buttonText.TextColor3 = Theme.Colors.TextSecondary
    self._buttonText.Font       = Theme.Fonts.Regular
end

-- Adds a new Section inside this tab's scrolling page.
-- Returns the Section object.
function Tab:AddSection(title)
    return Section.new(self._page, title)
end

-- Destroys the tab (button + page).
function Tab:Destroy()
    self._button:Destroy()
    self._page:Destroy()
end

return Tab
