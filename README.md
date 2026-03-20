# Steam UI Library

A modular, Steam-themed Roblox UI library written in pure Lua (LuaU).  
Every UI element lives in its own module; a single primary module (`Library`) ties them all together.

---

## Project Structure

```
Library/
├── init.lua               ← primary module — require this
├── Theme.lua              ← Steam colour palette, fonts & layout constants
├── Utility.lua            ← shared helpers (Instance creation, tweening, dragging …)
└── Components/
    ├── Window.lua          ← draggable, closable window frame
    ├── Tab.lua             ← tab button + scrollable content page
    ├── Section.lua         ← labelled group container inside a tab
    ├── Button.lua          ← clickable button
    ├── Toggle.lua          ← animated on/off toggle
    ├── Slider.lua          ← draggable numeric slider
    ├── Dropdown.lua        ← animated dropdown list
    ├── TextBox.lua         ← text-input field
    ├── Keybind.lua         ← keybind picker
    └── Label.lua           ← static text label
```

---

## Quick Start

Place the `Library` folder inside your Roblox place (e.g. inside `ReplicatedStorage`),
then use a **LocalScript** to load it:

```lua
local Library = require(game.ReplicatedStorage.Library)

-- 1. Create a window
local Window = Library:CreateWindow({
    Title    = "My Script",
    Size     = UDim2.new(0, 520, 0, 400),
    Position = UDim2.new(0.5, -260, 0.5, -200),
})

-- 2. Add a tab
local MainTab = Window:AddTab("Main")

-- 3. Add a section inside the tab
local Section = MainTab:AddSection("Controls")

-- 4. Populate the section with elements
Section:AddLabel({ Text = "Welcome to the Steam UI Library!" })

Section:AddButton({
    Text     = "Click Me",
    Callback = function()
        print("Button clicked!")
    end,
})

Section:AddToggle({
    Text     = "Enable Feature",
    Default  = false,
    Callback = function(value)
        print("Toggle:", value)
    end,
})

Section:AddSlider({
    Text     = "Speed",
    Min      = 0,
    Max      = 100,
    Default  = 50,
    Suffix   = "%",
    Callback = function(value)
        print("Speed:", value)
    end,
})

Section:AddDropdown({
    Text     = "Select Mode",
    Options  = { "Option A", "Option B", "Option C" },
    Default  = "Option A",
    Callback = function(selected)
        print("Selected:", selected)
    end,
})

Section:AddTextBox({
    Text            = "Player Name",
    PlaceholderText = "Enter a name…",
    Callback        = function(text, pressedEnter)
        print("Input:", text, "| Enter pressed:", pressedEnter)
    end,
})

Section:AddKeybind({
    Text     = "Sprint Key",
    Default  = Enum.KeyCode.LeftShift,
    Callback = function(keyCode)
        print("Bound to:", keyCode.Name)
    end,
})
```

---

## API Reference

### `Library`

| Method | Returns | Description |
|--------|---------|-------------|
| `Library:CreateWindow(config)` | `Window` | Creates a new GUI window |

**`config` fields:**

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Title` | `string` | `"Steam UI Library"` | Window title text |
| `Size` | `UDim2` | `520 × 400` | Window dimensions |
| `Position` | `UDim2` | centred | Window position on screen |
| `Parent` | `Instance` | `PlayerGui` | ScreenGui parent |

---

### `Window`

| Method | Returns | Description |
|--------|---------|-------------|
| `Window:AddTab(label)` | `Tab` | Adds a named tab |
| `Window:Toggle()` | — | Toggles visibility |
| `Window:Show()` | — | Shows the window |
| `Window:Hide()` | — | Hides the window |
| `Window:Destroy()` | — | Destroys the ScreenGui |

---

### `Tab`

| Method | Returns | Description |
|--------|---------|-------------|
| `Tab:AddSection(title)` | `Section` | Adds a labelled section |
| `Tab:Destroy()` | — | Destroys the tab |

---

### `Section`

| Method | Config fields | Returns | Description |
|--------|--------------|---------|-------------|
| `Section:AddLabel(cfg)` | `Text` | `Label` | Static text label |
| `Section:AddButton(cfg)` | `Text`, `Callback` | `Button` | Clickable button |
| `Section:AddToggle(cfg)` | `Text`, `Default`, `Callback` | `Toggle` | On/off toggle |
| `Section:AddSlider(cfg)` | `Text`, `Min`, `Max`, `Default`, `Decimals`, `Suffix`, `Callback` | `Slider` | Numeric slider |
| `Section:AddDropdown(cfg)` | `Text`, `Options`, `Default`, `Callback` | `Dropdown` | Dropdown list |
| `Section:AddTextBox(cfg)` | `Text`, `PlaceholderText`, `Default`, `ClearOnFocus`, `Callback` | `TextBox` | Text input |
| `Section:AddKeybind(cfg)` | `Text`, `Default`, `Callback` | `Keybind` | Keybind picker |
| `Section:Destroy()` | — | — | Destroys the section |

---

### Element runtime methods

All elements expose `GetValue()`, `SetValue(v)`, and `Destroy()`.

---

## Theme

All colours, fonts and layout constants are defined in `Library/Theme.lua` and can be
customised before loading any components.  The palette mirrors the Steam client:

| Role | Colour |
|------|--------|
| Window background | `RGB(27, 40, 56)` |
| Panel background | `RGB(23, 26, 33)` |
| Accent (Steam blue) | `RGB(102, 192, 244)` |
| Primary text | `RGB(197, 209, 218)` |
| Secondary text | `RGB(143, 161, 179)` |

---

## License

MIT — free to use in any Roblox project.
