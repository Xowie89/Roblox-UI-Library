-- Theme.lua
-- Steam-inspired colour palette and typography constants used throughout the library.

local Theme = {}

-- ── Colours ──────────────────────────────────────────────────────────────────

Theme.Colors = {
    -- Backgrounds
    Background          = Color3.fromRGB(27,  40,  56),   -- main window bg
    SecondaryBackground = Color3.fromRGB(23,  26,  33),   -- sidebar / panel bg
    TertiaryBackground  = Color3.fromRGB(32,  48,  67),   -- section bg
    ElementBackground   = Color3.fromRGB(38,  56,  77),   -- individual element bg

    -- Borders
    Border              = Color3.fromRGB(55,  71,  90),
    BorderLight         = Color3.fromRGB(74,  99, 124),

    -- Accent (Steam blue)
    Accent              = Color3.fromRGB(102, 192, 244),
    AccentDark          = Color3.fromRGB(74,  158, 204),
    AccentHover         = Color3.fromRGB(120, 210, 255),

    -- Text
    TextPrimary         = Color3.fromRGB(197, 209, 218),
    TextSecondary       = Color3.fromRGB(143, 161, 179),
    TextDisabled        = Color3.fromRGB(100, 120, 140),
    TextAccent          = Color3.fromRGB(102, 192, 244),

    -- Interactive states
    ButtonDefault       = Color3.fromRGB(62,  88, 111),
    ButtonHover         = Color3.fromRGB(74, 108, 131),
    ButtonActive        = Color3.fromRGB(50,  72,  94),

    -- Toggle
    ToggleOn            = Color3.fromRGB(75,  158, 189),
    ToggleOff           = Color3.fromRGB(55,   71,  90),
    ToggleKnob          = Color3.fromRGB(220, 230, 240),

    -- Slider
    SliderFill          = Color3.fromRGB(102, 192, 244),
    SliderTrack         = Color3.fromRGB(45,  62,  80),

    -- Dropdown
    DropdownBackground  = Color3.fromRGB(30,  43,  60),
    DropdownHover       = Color3.fromRGB(42,  60,  80),

    -- Scrollbar
    Scrollbar           = Color3.fromRGB(55,  71,  90),
    ScrollbarHover      = Color3.fromRGB(102, 192, 244),

    -- Title bar
    TitleBar            = Color3.fromRGB(15,  23,  35),
    TitleBarBorder      = Color3.fromRGB(55,  71,  90),

    -- Tab bar
    TabInactive         = Color3.fromRGB(35,  50,  68),
    TabActive           = Color3.fromRGB(27,  40,  56),
    TabHover            = Color3.fromRGB(45,  64,  85),
}

-- ── Typography ────────────────────────────────────────────────────────────────

Theme.Fonts = {
    Default  = Enum.Font.GothamSemibold,
    Regular  = Enum.Font.Gotham,
    Bold     = Enum.Font.GothamBold,
    Mono     = Enum.Font.Code,
}

Theme.TextSize = {
    Title    = 16,
    Header   = 14,
    Body     = 13,
    Small    = 11,
}

-- ── Layout ────────────────────────────────────────────────────────────────────

Theme.Layout = {
    CornerRadius        = UDim.new(0, 4),
    CornerRadiusLarge   = UDim.new(0, 6),
    ElementPadding      = 6,
    SectionPadding      = 10,
    ElementHeight       = 30,
    TitleBarHeight      = 36,
    TabBarHeight        = 34,
    SectionHeaderHeight = 24,
}

-- ── Tweening ──────────────────────────────────────────────────────────────────

Theme.Tween = {
    Short  = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Long   = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

return Theme
