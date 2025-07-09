--[[
  Juju.lol-Inspired Sidebar UI Library (Logic Only)
  Features: Centered, draggable window, sidebar, categories/tabs, config save/load logic, animations, advanced features
  Author: (Your Name)
--]]

-----------------------------
-- 1. Theme & Config System --
-----------------------------
local Library = {}
Library.Decals = {
    earth = "rbxassetid://1179499278",
    gun = "rbxassetid://716771644",
    neverlose = "rbxassetid://8273837838",
    headshot = "rbxassetid://115730015",
    bullet = "rbxassetid://11702759796",
}
Library.Themes = {
    juju = {
        Name = "juju",
        Accent = Color3.fromRGB(80, 200, 255),
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(14, 14, 16),
        SidebarAccent = Color3.fromRGB(80, 200, 255),
        SidebarText = Color3.fromRGB(220, 230, 240),
        SidebarMuted = Color3.fromRGB(120, 140, 150),
        MainBackground = Color3.fromRGB(24, 24, 28),
        MainText = Color3.fromRGB(230, 230, 240),
        MainMuted = Color3.fromRGB(150, 150, 160),
        Separator = Color3.fromRGB(40, 50, 60),
        Font = Enum.Font.Gotham,
        CornerRadius = UDim.new(0, 8),
        TransitionTime = 0.15,
    },
    neverlose = {
        Name = "neverlose",
        Accent = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(20, 22, 28),
        Sidebar = Color3.fromRGB(16, 18, 22),
        SidebarAccent = Color3.fromRGB(0, 255, 255),
        SidebarText = Color3.fromRGB(220, 230, 240),
        SidebarMuted = Color3.fromRGB(120, 140, 150),
        MainBackground = Color3.fromRGB(28, 28, 34),
        MainText = Color3.fromRGB(230, 230, 240),
        MainMuted = Color3.fromRGB(150, 150, 160),
        Separator = Color3.fromRGB(40, 50, 60),
        Font = Enum.Font.Gotham,
        CornerRadius = UDim.new(0, 8),
        TransitionTime = 0.15,
    },
    linoria = {
        Name = "linoria",
        Accent = Color3.fromRGB(0, 170, 255),
        Background = Color3.fromRGB(22, 22, 28),
        Sidebar = Color3.fromRGB(18, 18, 22),
        SidebarAccent = Color3.fromRGB(0, 170, 255),
        SidebarText = Color3.fromRGB(230, 230, 240),
        SidebarMuted = Color3.fromRGB(120, 140, 150),
        MainBackground = Color3.fromRGB(30, 30, 38),
        MainText = Color3.fromRGB(230, 230, 240),
        MainMuted = Color3.fromRGB(150, 150, 160),
        Separator = Color3.fromRGB(40, 50, 60),
        Font = Enum.Font.Gotham,
        CornerRadius = UDim.new(0, 8),
        TransitionTime = 0.15,
    },
}
Library.Config = {
    Theme = "juju",
    Accent = nil, -- nil = use theme accent
    Name = "juju.lol",
    Logo = "earth",
    SelectedCategory = 1,
    SelectedTab = 1,
    Saved = {},
    WindowPos = UDim2.new(0.5, -400, 0.5, -250),
    WindowSize = UDim2.new(0, 800, 0, 500),
    Visible = true,
}
function Library:SetTheme(themeName)
    if Library.Themes[themeName] then
        Library.Config.Theme = themeName
        Library.Theme = Library.Themes[themeName]
        if Library._UpdateTheme then Library._UpdateTheme() end
    end
end
function Library:SetAccent(color)
    Library.Config.Accent = color
    if Library._UpdateTheme then Library._UpdateTheme() end
end
function Library:SetName(name)
    Library.Config.Name = name
    if Library._UpdateName then Library._UpdateName() end
end
function Library:SetLogo(logo)
    Library.Config.Logo = logo
    if Library._UpdateLogo then Library._UpdateLogo() end
end
function Library:SaveConfig(name)
    Library.Config.Saved[name or "default"] = self:ExportConfig()
end
function Library:LoadConfig(name)
    local data = Library.Config.Saved[name or "default"]
    if data then self:ImportConfig(data) end
end
function Library:ExportConfig()
    local data = {}
    for k,v in pairs(Library.Config) do
        if k ~= "Saved" then data[k] = v end
    end
    return data
end
function Library:ImportConfig(data)
    for k,v in pairs(data) do
        if k ~= "Saved" then Library.Config[k] = v end
    end
    if Library._UpdateTheme then Library._UpdateTheme() end
    if Library._UpdateName then Library._UpdateName() end
    if Library._UpdateLogo then Library._UpdateLogo() end
    if Library._UpdateWindow then Library._UpdateWindow() end
end

------------------------
-- 2. Utility Functions --
------------------------
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local function Tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or Library.Theme.TransitionTime, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end
local function AddCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Library.Theme.CornerRadius
    c.Parent = obj
    return c
end
local function AddStroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Library.Theme.Separator
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

------------------------
-- 3. Window & Sidebar --
------------------------
Library._SidebarGui = nil
Library._Window = nil
Library._Sidebar = nil
Library._MainContent = nil
Library._CategoryButtons = {}
Library._TabButtons = {}
Library._Categories = {} -- Start with no categories/tabs by default
function Library:BuildWindow()
    if Library._SidebarGui then Library._SidebarGui:Destroy() end
    local theme = Library.Themes[Library.Config.Theme]
    local accent = Library.Config.Accent or theme.Accent
    local gui = Instance.new("ScreenGui")
    gui.Name = "JujuSidebarUILibrary"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.Parent = game:GetService("CoreGui")
    Library._SidebarGui = gui
    -- Main Window
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Size = Library.Config.WindowSize
    window.Position = Library.Config.WindowPos
    window.BackgroundColor3 = theme.Background
    window.BorderSizePixel = 0
    window.Parent = gui
    window.Visible = Library.Config.Visible
    AddCorner(window, theme.CornerRadius)
    AddStroke(window, theme.Separator)
    Library._Window = window
    -- Drag logic
    local dragging, dragInput, dragStart, startPos
    window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y - window.AbsolutePosition.Y < 40 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    window.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Library.Config.WindowPos = window.Position
        end
    end)
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = window
    Library._Sidebar = sidebar
    -- Logo + Name
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Image = Library.Decals[Library.Config.Logo or "earth"]
    logo.Size = UDim2.new(0, 32, 0, 32)
    logo.Position = UDim2.new(0, 16, 0, 24)
    logo.BackgroundTransparency = 1
    logo.Parent = sidebar
    Library._Logo = logo
    local nameTop, nameBot = Library.Config.Name:match("([^.]+)%.([^.]+)")
    nameTop = nameTop or Library.Config.Name
    nameBot = nameBot or ""
    local name1 = Instance.new("TextLabel")
    name1.Text = nameTop
    name1.Font = theme.Font
    name1.TextColor3 = theme.SidebarText
    name1.TextSize = 20
    name1.TextXAlignment = Enum.TextXAlignment.Left
    name1.BackgroundTransparency = 1
    name1.Position = UDim2.new(0, 56, 0, 24)
    name1.Size = UDim2.new(1, -56, 0, 18)
    name1.Parent = sidebar
    Library._Name1 = name1
    local name2 = Instance.new("TextLabel")
    name2.Text = nameBot
    name2.Font = theme.Font
    name2.TextColor3 = accent
    name2.TextSize = 18
    name2.TextXAlignment = Enum.TextXAlignment.Left
    name2.BackgroundTransparency = 1
    name2.Position = UDim2.new(0, 56, 0, 42)
    name2.Size = UDim2.new(1, -56, 0, 16)
    name2.Parent = sidebar
    Library._Name2 = name2
    -- Category/Tab List
    local y = 80
    Library._CategoryButtons = {}
    Library._TabButtons = {}
    for i,cat in ipairs(Library._Categories) do
        local catLabel = Instance.new("TextLabel")
        catLabel.Text = cat.Name
        catLabel.Font = theme.Font
        catLabel.TextColor3 = accent
        catLabel.TextSize = 16
        catLabel.TextXAlignment = Enum.TextXAlignment.Left
        catLabel.BackgroundTransparency = 1
        catLabel.Position = UDim2.new(0, 16, 0, y)
        catLabel.Size = UDim2.new(1, -32, 0, 18)
        catLabel.Parent = sidebar
        Library._CategoryButtons[i] = catLabel
        y = y + 20
        local underline = Instance.new("Frame")
        underline.Size = UDim2.new(1, -32, 0, 1)
        underline.Position = UDim2.new(0, 16, 0, y)
        underline.BackgroundColor3 = theme.Separator
        underline.BorderSizePixel = 0
        underline.Parent = sidebar
        y = y + 8
        Library._TabButtons[i] = {}
        for j,tab in ipairs(cat.Tabs) do
            local tabBtn = Instance.new("TextButton")
            tabBtn.Text = (Library.Config.SelectedCategory == i and Library.Config.SelectedTab == j and "| " or "  ")..tab
            tabBtn.Font = theme.Font
            tabBtn.TextColor3 = (Library.Config.SelectedCategory == i and Library.Config.SelectedTab == j) and accent or theme.SidebarMuted
            tabBtn.TextSize = 15
            tabBtn.TextXAlignment = Enum.TextXAlignment.Left
            tabBtn.BackgroundTransparency = 1
            tabBtn.Position = UDim2.new(0, 24, 0, y)
            tabBtn.Size = UDim2.new(1, -40, 0, 18)
            tabBtn.Parent = sidebar
            tabBtn.MouseButton1Click:Connect(function()
                Library:SelectTab(i, j)
            end)
            Library._TabButtons[i][j] = tabBtn
            y = y + 18
        end
        y = y + 8
    end
    -- Main Content Area
    local main = Instance.new("Frame")
    main.Name = "MainContent"
    main.Size = UDim2.new(1, -170, 1, 0)
    main.Position = UDim2.new(0, 170, 0, 0)
    main.BackgroundColor3 = theme.MainBackground
    main.BorderSizePixel = 0
    main.Parent = window
    Library._MainContent = main
    AddCorner(main, theme.CornerRadius)
    -- Show selected tab content
    Library:ShowTabContent(Library.Config.SelectedCategory, Library.Config.SelectedTab)
    -- Theme update hooks
    Library._UpdateTheme = function()
        local theme = Library.Themes[Library.Config.Theme]
        local accent = Library.Config.Accent or theme.Accent
        window.BackgroundColor3 = theme.Background
        sidebar.BackgroundColor3 = theme.Sidebar
        name1.TextColor3 = theme.SidebarText
        name2.TextColor3 = accent
        for i,cat in ipairs(Library._Categories) do
            Library._CategoryButtons[i].TextColor3 = accent
            for j,tab in ipairs(cat.Tabs) do
                local btn = Library._TabButtons[i][j]
                btn.TextColor3 = (Library.Config.SelectedCategory == i and Library.Config.SelectedTab == j) and accent or theme.SidebarMuted
            end
        end
        main.BackgroundColor3 = theme.MainBackground
    end
    Library._UpdateName = function()
        local nameTop, nameBot = Library.Config.Name:match("([^.]+)%.([^.]+)")
        nameTop = nameTop or Library.Config.Name
        nameBot = nameBot or ""
        name1.Text = nameTop
        name2.Text = nameBot
    end
    Library._UpdateLogo = function()
        logo.Image = Library.Decals[Library.Config.Logo or "earth"]
    end
    Library._UpdateWindow = function()
        window.Position = Library.Config.WindowPos
        window.Size = Library.Config.WindowSize
        window.Visible = Library.Config.Visible
    end
end
function Library:SelectTab(catIdx, tabIdx)
    Library.Config.SelectedCategory = catIdx
    Library.Config.SelectedTab = tabIdx
    for i,cat in ipairs(Library._Categories) do
        for j,tab in ipairs(cat.Tabs) do
            local btn = Library._TabButtons[i][j]
            btn.Text = (catIdx == i and tabIdx == j and "| " or "  ")..tab
            btn.TextColor3 = (catIdx == i and tabIdx == j) and (Library.Config.Accent or Library.Themes[Library.Config.Theme].Accent) or Library.Themes[Library.Config.Theme].SidebarMuted
            -- Animate highlight
            Tween(btn, {TextColor3 = btn.TextColor3}, 0.2)
        end
    end
    Library:ShowTabContent(catIdx, tabIdx)
end
function Library:ShowTabContent(catIdx, tabIdx)
    local main = Library._MainContent
    if not main then return end
    main:ClearAllChildren()
    local theme = Library.Themes[Library.Config.Theme]
    local label = Instance.new("TextLabel")
    label.Text = "["..Library._Categories[catIdx].Name.."] "..Library._Categories[catIdx].Tabs[tabIdx]
    label.Font = theme.Font
    label.TextColor3 = theme.MainText
    label.TextSize = 22
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 24, 0, 32)
    label.Size = UDim2.new(1, -48, 0, 32)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = main
    -- Theme switcher demo
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Text = "theme:"
    themeLabel.Font = theme.Font
    themeLabel.TextColor3 = theme.MainMuted
    themeLabel.TextSize = 16
    themeLabel.BackgroundTransparency = 1
    themeLabel.Position = UDim2.new(0, 24, 0, 80)
    themeLabel.Size = UDim2.new(0, 60, 0, 24)
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = main
    local themeDropdown = Instance.new("TextButton")
    themeDropdown.Text = Library.Config.Theme
    themeDropdown.Font = theme.Font
    themeDropdown.TextColor3 = (Library.Config.Accent or theme.Accent)
    themeDropdown.TextSize = 16
    themeDropdown.BackgroundColor3 = theme.MainBackground
    themeDropdown.Position = UDim2.new(0, 90, 0, 80)
    themeDropdown.Size = UDim2.new(0, 100, 0, 24)
    themeDropdown.Parent = main
    AddCorner(themeDropdown, theme.CornerRadius)
    AddStroke(themeDropdown, theme.Separator)
    themeDropdown.MouseButton1Click:Connect(function()
        local keys = {}
        for k in pairs(Library.Themes) do table.insert(keys, k) end
        local idx = table.find(keys, Library.Config.Theme) or 1
        idx = idx % #keys + 1
        Library:SetTheme(keys[idx])
        themeDropdown.Text = keys[idx]
    end)
    local accentBtn = Instance.new("TextButton")
    accentBtn.Text = "accent"
    accentBtn.Font = theme.Font
    accentBtn.TextColor3 = (Library.Config.Accent or theme.Accent)
    accentBtn.TextSize = 16
    accentBtn.BackgroundColor3 = theme.MainBackground
    accentBtn.Position = UDim2.new(0, 200, 0, 80)
    accentBtn.Size = UDim2.new(0, 80, 0, 24)
    accentBtn.Parent = main
    AddCorner(accentBtn, theme.CornerRadius)
    AddStroke(accentBtn, theme.Separator)
    accentBtn.MouseButton1Click:Connect(function()
        local accents = {
            Color3.fromRGB(80, 200, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 170, 255),
            Color3.fromRGB(255, 80, 200),
        }
        local cur = Library.Config.Accent or theme.Accent
        local idx = 1
        for i,v in ipairs(accents) do if v == cur then idx = i end end
        idx = idx % #accents + 1
        Library:SetAccent(accents[idx])
        accentBtn.TextColor3 = accents[idx]
    end)
end
function Library:Show()
    if Library._Window then
        Tween(Library._Window, {BackgroundTransparency = 0}, 0.2)
        Library._Window.Visible = true
        Library.Config.Visible = true
    end
end
function Library:Hide()
    if Library._Window then
        Tween(Library._Window, {BackgroundTransparency = 1}, 0.2)
        wait(0.2)
        Library._Window.Visible = false
        Library.Config.Visible = false
    end
end
function Library:Toggle()
    if Library._Window then
        if Library._Window.Visible then Library:Hide() else Library:Show() end
    end
end

--[[ example: Full UI Demo ]]--
------------------------
--[[
local lib = require(path.to.thisfile)

-- Build the window
lib:BuildWindow()

-- Set custom name and logo
lib:SetName("example.lol")
lib:SetLogo("gun")

-- Set theme and accent
lib:SetTheme("neverlose")
lib:SetAccent(Color3.fromRGB(255, 80, 200))

-- Add categories/tabs (optional, for demo)
lib._Categories = {
    {
        Name = "main",
        Tabs = {"ragebot", "legitbot"},
    },
    {
        Name = "visuals",
        Tabs = {"players", "general", "skins"},
    },
    {
        Name = "misc.",
        Tabs = {"players", "configs", "addons", "shop", "main"},
    },
    {
        Name = "settings",
        Tabs = {"ui", "themes", "about"},
    },
}

-- Rebuild window to apply new categories
lib:BuildWindow()

-- Save/load config
lib:SaveConfig("mycfg")
lib:LoadConfig("mycfg")

-- Show/hide/toggle window
lib:Show()   -- show window
wait(2)
lib:Hide()   -- hide window
wait(1)
lib:Show()   -- show again
wait(1)
lib:Toggle() -- toggle window
wait(1)
lib:Toggle() -- toggle again

-- Switch to a specific tab (e.g., visuals > general)
lib:SelectTab(2, 2)

-- You can now interact with the UI, switch themes, drag the window, and use all features!
--]]

return Library
