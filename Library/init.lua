-- Library/init.lua
-- Primary entry-point for the Steam UI Library.
--
-- Usage (inside a LocalScript):
--
--   local Library = require(path.to.Library)
--
--   local Window = Library:CreateWindow({
--       Title = "My Script",
--       Size  = UDim2.new(0, 520, 0, 400),
--   })
--
--   local Tab     = Window:AddTab("Main")
--   local Section = Tab:AddSection("Controls")
--
--   Section:AddButton({ Text = "Do Something", Callback = function() print("clicked") end })
--   Section:AddToggle({ Text = "Enable", Default = false, Callback = function(v) print(v) end })
--   Section:AddSlider({ Text = "Speed", Min = 0, Max = 100, Default = 50,
--       Callback = function(v) print(v) end })
--   Section:AddDropdown({ Text = "Mode", Options = {"A","B","C"}, Default = "A",
--       Callback = function(v) print(v) end })
--   Section:AddTextBox({ Text = "Name", PlaceholderText = "Enter name…",
--       Callback = function(v) print(v) end })
--   Section:AddKeybind({ Text = "Sprint", Default = Enum.KeyCode.LeftShift,
--       Callback = function(k) print(k) end })
--   Section:AddLabel({ Text = "v1.0 — Steam UI Library" })

local Library = {}
Library.__index = Library

-- Module version
Library.Version = "1.0.0"

-- Sub-module references (accessible for advanced use)
Library.Theme   = require(script.Theme)
Library.Utility = require(script.Utility)

-- Component constructors (accessible for advanced / standalone use)
Library.Components = {
    Window   = require(script.Components.Window),
    Tab      = require(script.Components.Tab),
    Section  = require(script.Components.Section),
    Button   = require(script.Components.Button),
    Toggle   = require(script.Components.Toggle),
    Slider   = require(script.Components.Slider),
    Dropdown = require(script.Components.Dropdown),
    TextBox  = require(script.Components.TextBox),
    Keybind  = require(script.Components.Keybind),
    Label    = require(script.Components.Label),
}

-- ── Primary factory ───────────────────────────────────────────────────────────

-- Creates and returns a new Window.
-- `config` is forwarded directly to Components.Window.new().
function Library:CreateWindow(config)
    return self.Components.Window.new(config)
end

return Library
