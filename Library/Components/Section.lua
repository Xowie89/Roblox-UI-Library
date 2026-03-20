-- Components/Section.lua
-- A labelled container that holds a group of UI elements within a tab.
-- Each element type is added via a dedicated method.

local Theme   = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

-- Lazy-require component modules to avoid circular dependencies.
local function requireComponent(name)
    return require(script.Parent[name])
end

local Section = {}
Section.__index = Section

function Section.new(scrollFrame, title)
    local self = setmetatable({}, Section)

    -- ── Outer wrapper ─────────────────────────────────────────────────────────
    local wrapper = Utility.Create("Frame", {
        Name            = "Section_" .. (title or "Section"),
        Size            = UDim2.new(1, 0, 0, 0),  -- height driven by AutomaticSize
        AutomaticSize   = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Colors.TertiaryBackground,
        LayoutOrder     = 0,
    }, scrollFrame)

    Utility.AddCorner(wrapper, Theme.Layout.CornerRadiusLarge)
    Utility.AddStroke(wrapper, Theme.Colors.Border, 1)

    -- ── Section header ────────────────────────────────────────────────────────
    local header = Utility.Create("Frame", {
        Name            = "Header",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.SectionHeaderHeight),
        BackgroundColor3 = Theme.Colors.SecondaryBackground,
        ZIndex          = wrapper.ZIndex + 1,
    }, wrapper)

    -- Round only the top corners of the header
    Utility.AddCorner(header, Theme.Layout.CornerRadiusLarge)

    -- Cover the bottom corners of the header with a same-colour frame
    Utility.Create("Frame", {
        Name            = "BottomCover",
        Size            = UDim2.new(1, 0, 0, Theme.Layout.CornerRadiusLarge.Offset),
        Position        = UDim2.new(0, 0, 1, -Theme.Layout.CornerRadiusLarge.Offset),
        BackgroundColor3 = Theme.Colors.SecondaryBackground,
        BorderSizePixel = 0,
    }, header)

    -- Left accent bar
    Utility.Create("Frame", {
        Name            = "Accent",
        Size            = UDim2.new(0, 3, 0.6, 0),
        Position        = UDim2.new(0, 8, 0.2, 0),
        BackgroundColor3 = Theme.Colors.Accent,
    }, header)

    -- Header title
    Utility.Create("TextLabel", {
        Name            = "Title",
        Size            = UDim2.new(1, -20, 1, 0),
        Position        = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text            = title or "Section",
        TextColor3      = Theme.Colors.TextPrimary,
        Font            = Theme.Fonts.Default,
        TextSize        = Theme.TextSize.Header,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextYAlignment  = Enum.TextYAlignment.Center,
    }, header)

    -- ── Content area ──────────────────────────────────────────────────────────
    local content = Utility.Create("Frame", {
        Name            = "Content",
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.new(0, 0, 0, Theme.Layout.SectionHeaderHeight),
        AutomaticSize   = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, wrapper)

    Utility.AddListLayout(content, Enum.FillDirection.Vertical, Theme.Layout.ElementPadding)
    Utility.AddPadding(content, Theme.Layout.SectionPadding, Theme.Layout.SectionPadding,
        Theme.Layout.SectionPadding, Theme.Layout.SectionPadding)

    self._wrapper = wrapper
    self._content = content

    return self
end

-- ── Public element factories ──────────────────────────────────────────────────

function Section:AddLabel(config)
    return requireComponent("Label").new(self._content, config)
end

function Section:AddButton(config)
    return requireComponent("Button").new(self._content, config)
end

function Section:AddToggle(config)
    return requireComponent("Toggle").new(self._content, config)
end

function Section:AddSlider(config)
    return requireComponent("Slider").new(self._content, config)
end

function Section:AddDropdown(config)
    return requireComponent("Dropdown").new(self._content, config)
end

function Section:AddTextBox(config)
    return requireComponent("TextBox").new(self._content, config)
end

function Section:AddKeybind(config)
    return requireComponent("Keybind").new(self._content, config)
end

-- Destroys the entire section.
function Section:Destroy()
    self._wrapper:Destroy()
end

return Section
