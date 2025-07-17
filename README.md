# 💻 Roblox Executor UI Library (Linoria-Based)

A modern, modular UI Library built for Roblox executor scripts.  
Uses the Linoria framework for a clean, responsive, and powerful interface.

---

## 📦 Setup

```lua
local base = 'https://raw.githubusercontent.com/17kShotsss/UI-LIBRARY/main/'

local Library = loadstring(game:HttpGet(base .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(base .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(base .. 'addons/SaveManager.lua'))()

🪟 Creating the Window

local Window = Library:CreateWindow({
    Title = 'My Script UI',
    Center = true,
    AutoShow = true,
})

🧱 Tabs & Groupboxes

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Main Controls')

🔘 Toggle

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Enable Feature',
    Default = false,
    Tooltip = 'Toggles something on or off',
})

Toggles.MyToggle:OnChanged(function()
    print('Toggle:', Toggles.MyToggle.Value)
end)

📊 Slider

LeftGroupBox:AddSlider('MySlider', {
    Text = 'Adjust Value',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
})

Options.MySlider:OnChanged(function()
    print('Slider:', Options.MySlider.Value)
end)

📝 Textbox

LeftGroupBox:AddInput('MyInput', {
    Default = '',
    Placeholder = 'Type here...',
    Text = 'Textbox',
    Tooltip = 'Enter text',
})

Options.MyInput:OnChanged(function()
    print('Input:', Options.MyInput.Value)
end)

🔽 Dropdown

LeftGroupBox:AddDropdown('MyDropdown', {
    Values = { 'Option A', 'Option B', 'Option C' },
    Default = 1,
    Text = 'Choose one',
})

Options.MyDropdown:OnChanged(function()
    print('Selected:', Options.MyDropdown.Value)
end)

✅ Multi-Select Dropdown

LeftGroupBox:AddDropdown('MyMultiDropdown', {
    Values = { 'One', 'Two', 'Three' },
    Multi = true,
    Default = 1,
    Text = 'Multi Select',
})

Options.MyMultiDropdown:OnChanged(function()
    for k, v in next, Options.MyMultiDropdown.Value do
        print(k, v)
    end
end)

🎨 Color Picker

LeftGroupBox:AddLabel('Color'):AddColorPicker('MyColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'Select Color',
})

Options.MyColor:OnChanged(function()
    print('Color changed:', Options.MyColor.Value)
end)

⌨️ Keybind Picker

LeftGroupBox:AddLabel('Hotkey'):AddKeyPicker('MyKeybind', {
    Default = 'F',
    Mode = 'Toggle',
    Text = 'Activate Something',
})

Options.MyKeybind:OnClick(function()
    print('Keybind activated')
end)

🎛️ UI Settings Tab

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload UI', function()
    Library:Unload()
end)

MenuGroup:AddLabel('Menu Key'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Toggle UI',
})

Library.ToggleKeybind = Options.MenuKeybind

🎭 ThemeManager

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('MyScriptThemes')
ThemeManager:ApplyToTab(Tabs['UI Settings'])

💾 SaveManager

SaveManager:SetLibrary(Library)
SaveManager:SetFolder('MyScriptConfigs')
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Optional auto-load:
-- SaveManager:LoadAutoloadConfig()

🧼 Cleanup

Library:OnUnload(function()
    Library.Unloaded = true
end)

📁 Folder Structure

UI-LIBRARY/
│
├── Library.lua
└── addons/
    ├── ThemeManager.lua
    └── SaveManager.lua

✅ Notes

    This library is built on the Linoria UI framework.

    All UI elements are fully customizable.

    SaveManager and ThemeManager are optional but recommended for configs/themes.
