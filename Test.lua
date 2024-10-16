local SimpleUI = {}

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Default theme
local defaultTheme = {
    background = Color3.fromRGB(45, 45, 45),
    foreground = Color3.fromRGB(60, 60, 60),
    accent = Color3.fromRGB(0, 120, 215),
    text = Color3.fromRGB(255, 255, 255)
}

-- Current theme (starts with default)
local currentTheme = table.clone(defaultTheme)

-- Settings
local settings = {
    theme = "default",
    fontSize = 18
}

-- Utility function to create base GUI object
local function createGuiObject(class, properties)
    local object = Instance.new(class)
    for k, v in pairs(properties) do
        object[k] = v
    end
    return object
end

-- Function to save settings
local function saveSettings()
    local player = Players.LocalPlayer
    local settingsJSON = HttpService:JSONEncode(settings)
    pcall(function()
        player:SetAttribute("SimpleUISettings", settingsJSON)
    end)
end

-- Function to load settings
local function loadSettings()
    local player = Players.LocalPlayer
    local settingsJSON = player:GetAttribute("SimpleUISettings")
    if settingsJSON then
        pcall(function()
            settings = HttpService:JSONDecode(settingsJSON)
        end)
    end
    SimpleUI.applyTheme(settings.theme)
end

-- Apply theme to an object
local function applyThemeToObject(object)
    if object:IsA("Frame") or object:IsA("ScrollingFrame") then
        object.BackgroundColor3 = currentTheme.background
    elseif object:IsA("TextButton") then
        object.BackgroundColor3 = currentTheme.foreground
        object.TextColor3 = currentTheme.text
    elseif object:IsA("TextLabel") or object:IsA("TextBox") then
        object.TextColor3 = currentTheme.text
    end
    object.TextSize = settings.fontSize
end

-- Function to apply theme to all UI elements
function SimpleUI.applyTheme(themeName)
    if themeName == "dark" then
        currentTheme = {
            background = Color3.fromRGB(30, 30, 30),
            foreground = Color3.fromRGB(50, 50, 50),
            accent = Color3.fromRGB(0, 120, 215),
            text = Color3.fromRGB(255, 255, 255)
        }
    elseif themeName == "light" then
        currentTheme = {
            background = Color3.fromRGB(240, 240, 240),
            foreground = Color3.fromRGB(220, 220, 220),
            accent = Color3.fromRGB(0, 120, 215),
            text = Color3.fromRGB(0, 0, 0)
        }
    else
        currentTheme = table.clone(defaultTheme)
    end
    
    settings.theme = themeName
    saveSettings()
    
    -- Apply theme to all existing UI elements
    for _, player in ipairs(Players:GetPlayers()) do
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetDescendants()) do
                if gui:IsA("GuiObject") then
                    applyThemeToObject(gui)
                end
            end
        end
    end
end

-- Create a simple window
function SimpleUI.createWindow(name, size)
    local window = createGuiObject("ScreenGui", {
        Name = name,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
        IgnoreGuiInset = true
    })
    
    local frame = createGuiObject("Frame", {
        Name = "MainFrame",
        Size = size or UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = window
    })
    
    local title = createGuiObject("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Text = name,
        Parent = frame
    })
    
    applyThemeToObject(frame)
    applyThemeToObject(title)
    
    return window, frame
end

-- Create a button
function SimpleUI.createButton(parent, text, position, size, callback)
    local button = createGuiObject("TextButton", {
        Name = text .. "Button",
        Size = size or UDim2.new(0, 200, 0, 50),
        Position = position,
        Text = text,
        Parent = parent
    })
    
    applyThemeToObject(button)
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Create a text label
function SimpleUI.createLabel(parent, text, position, size)
    local label = createGuiObject("TextLabel", {
        Name = text .. "Label",
        Size = size or UDim2.new(0, 200, 0, 40),
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        Parent = parent
    })
    
    applyThemeToObject(label)
    return label
end

-- Create tabs
function SimpleUI.createTabs(parent, tabNames)
    local tabContainer = createGuiObject("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local contentContainer = createGuiObject("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -90),
        Position = UDim2.new(0, 0, 0, 90),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local tabs = {}
    local buttonWidth = 1 / #tabNames
    
    for i, tabName in ipairs(tabNames) do
        local tabButton = SimpleUI.createButton(
            tabContainer,
            tabName,
            UDim2.new(buttonWidth * (i-1), 0, 0, 0),
            UDim2.new(buttonWidth, 0, 1, 0),
            function() end
        )
        
        local tabContent = createGuiObject("Frame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = i == 1,
            Parent = contentContainer
        })
        
        tabs[tabName] = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(tabs) do
                content.Visible = false
            end
            tabContent.Visible = true
        end)
    end
    
    return tabs
end

-- Add touch scrolling to a frame
function SimpleUI.addScrolling(frame)
    local scrollingEnabled = false
    local dragStart
    local startPos

    local function updatePosition(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        frame.Position = newPosition
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            scrollingEnabled = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    scrollingEnabled = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and scrollingEnabled then
            updatePosition(input)
        end
    end)
end

-- Create settings UI
function SimpleUI.createSettingsUI(parent)
    local settingsFrame = createGuiObject("Frame", {
        Name = "SettingsFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.5,
        Parent = parent
    })
    
    local themeLabel = SimpleUI.createLabel(settingsFrame, "Theme:", UDim2.new(0, 10, 0, 10))
    
    local themes = {"default", "dark", "light"}
    for i, theme in ipairs(themes) do
        SimpleUI.createButton(settingsFrame, theme, UDim2.new(0, 10, 0, 50 * i), UDim2.new(0, 100, 0, 40), function()
            SimpleUI.applyTheme(theme)
        end)
    end
    
    local fontSizeLabel = SimpleUI.createLabel(settingsFrame, "Font Size:", UDim2.new(0, 10, 0, 200))
    
    local fontSizes = {14, 18, 22}
    for i, size in ipairs(fontSizes) do
        SimpleUI.createButton(settingsFrame, tostring(size), UDim2.new(0, 10 + 110 * (i-1), 0, 240), UDim2.new(0, 100, 0, 40), function()
            settings.fontSize = size
            saveSettings()
            SimpleUI.applyTheme(settings.theme)  -- This will apply the new font size
        end)
    end
end

-- Initialize the library
loadSettings()

return SimpleUI
