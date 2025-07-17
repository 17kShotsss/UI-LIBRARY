# Linoria-Based UI Library for Roblox Executors

A clean, modular UI library based on **Linoria UI** — designed for Roblox executor scripts.  
No credits are taken, all logic and styling are based on Linoria principles.

---

## 📦 Installation

```lua
local repo = 'https://raw.githubusercontent.com/17kShotsss/UI-LIBRARY/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

🪟 Create a Window

local Window = Library:CreateWindow({
    Title = 'Example | UI',
    Center = true,
    AutoShow = true,
})

🗂️ Tabs & Groupboxes

local Tabs = {
    Main = Window:AddTab('Main'),
    Settings = Window:AddTab('Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Combat')
local RightGroupBox = Tabs.Main:AddRightGroupbox('Visuals')

🎛️ Controls
✅ Toggles

LeftGroupBox:AddToggle('SilentAim', {
    Text = 'Enable Silent Aim',
    Default = false,
    Tooltip = 'Automatically targets enemies',
    Callback = function(v)
        print('Silent Aim:', v)
    end
})

🎚️ Sliders

LeftGroupBox:AddSlider('FOVRadius', {
    Text = 'FOV Radius',
    Default = 100,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Compact = false,
    Callback = function(v)
        print('FOV set to', v)
    end
})

🎯 Keybinds

RightGroupBox:AddLabel('Aimlock Key'):AddKeyPicker('AimKey', {
    Default = 'C',
    NoUI = false,
    Text = 'Keybind'
})

🌈 Color Pickers

RightGroupBox:AddToggle('UseCustomColor', {
    Text = 'Enable Color',
    Default = true,
    Callback = function(v) end
}):AddColorPicker('TargetColor', {
    Default = Color3.fromRGB(255, 75, 75),
    Title = 'Target Highlight Color'
})

🔽 Dropdowns

LeftGroupBox:AddDropdown('ResolverMode', {
    Values = { 'Off', 'Experimental', 'Full' },
    Default = 1,
    Multi = false,
    Text = 'Resolver Mode',
    Callback = function(mode)
        print('Resolver:', mode)
    end
})

⚙️ Theme & Config Saving

Make sure to create a Settings tab before calling these:

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

ThemeManager:SetFolder('ExampleHub')
SaveManager:SetFolder('ExampleHub/saves')

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

📁 File Structure

UI-LIBRARY/
├── Library.lua
└── addons/
    ├── ThemeManager.lua
    └── SaveManager.lua

📝 Notes

    The library is intended for use inside Roblox script executors.

    All UI logic is based on the Linoria UI framework.

    You can customize tab names, toggle defaults, and folders freely.
