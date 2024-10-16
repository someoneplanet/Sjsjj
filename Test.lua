local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Themes
local themes = {
    Light = {
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(0, 0, 0),
        ButtonColor = Color3.fromRGB(200, 200, 200),
        BorderColor = Color3.fromRGB(150, 150, 150)
    },
    Dark = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        TextColor = Color3.fromRGB(255, 255, 255),
        ButtonColor = Color3.fromRGB(50, 50, 50),
        BorderColor = Color3.fromRGB(70, 70, 70)
    }
}

-- Default Theme
local currentTheme = themes.Dark

-- Set theme function
local function setTheme(theme)
    if themes[theme] then
        currentTheme = themes[theme]
    else
        warn("Theme does not exist!")
    end
end

-- Component creation
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.BackgroundColor3 = currentTheme.ButtonColor
    button.TextColor3 = currentTheme.TextColor
    button.Text = text
    button.Parent = screenGui

    button.MouseButton1Click:Connect(function()
        callback()
    end)

    return button
end

local function createFrame(size, position)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = currentTheme.BackgroundColor
    frame.BorderColor3 = currentTheme.BorderColor
    frame.Parent = screenGui

    return frame
end

local function createLabel(text, size, position)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = currentTheme.TextColor
    label.Text = text
    label.Parent = screenGui

    return label
end

-- Layouts
local function createVerticalList(container, padding)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or 5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
end

-- Animations
local function fadeIn(element, duration)
    element.BackgroundTransparency = 1
    element.Visible = true
    element:TweenBackgroundTransparency(0, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, duration or 0.5, true)
end

local function fadeOut(element, duration)
    element:TweenBackgroundTransparency(1, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, duration or 0.5, true)
end

local function slideIn(element, direction, duration)
    local startPosition = element.Position
    if direction == "Left" then
        element.Position = UDim2.new(-1, 0, element.Position.Y.Scale, element.Position.Y.Offset)
    elseif direction == "Right" then
        element.Position = UDim2.new(1, 0, element.Position.Y.Scale, element.Position.Y.Offset)
    end
    element:TweenPosition(startPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, duration or 0.5, true)
end

-- Event handling
local function onButtonClick(button, callback)
    button.MouseButton1Click:Connect(function()
        callback()
    end)
end

local function onHover(element, enterCallback, leaveCallback)
    element.MouseEnter:Connect(function()
        enterCallback()
    end)
    
    element.MouseLeave:Connect(function()
        leaveCallback()
    end)
end

-- UI Implementation Example
local mainFrame = createFrame(UDim2.new(0, 400, 0, 300), UDim2.new(0.5, -200, 0.5, -150))

local button = createButton("Click Me", function()
    print("Button clicked!")
end)
button.Parent = mainFrame

local label = createLabel("Welcome to SpectraUI!", UDim2.new(0, 300, 0, 50), UDim2.new(0, 50, 0, 20))
label.Parent = mainFrame

createVerticalList(mainFrame, 10)

-- Applying a theme and animations
setTheme("Light")
fadeIn(mainFrame, 1)
