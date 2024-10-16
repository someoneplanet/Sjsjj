local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.IgnoreGuiInset = true

-- Theme Colors
local theme = {
    WindowBackground = Color3.fromRGB(35, 35, 35),
    SectionBackground = Color3.fromRGB(25, 25, 25),
    ButtonBackground = Color3.fromRGB(45, 45, 45),
    BorderColor = Color3.fromRGB(60, 60, 60),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(0, 170, 255)
}

-- Create Window
local function createWindow(title, size, position)
    local window = Instance.new("Frame")
    window.Size = size or UDim2.new(0, 400, 0, 300)
    window.Position = position or UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = theme.WindowBackground
    window.BorderSizePixel = 1
    window.BorderColor3 = theme.BorderColor
    window.Parent = screenGui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "SpectraUI Window"
    titleLabel.TextColor3 = theme.TextColor
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 20
    titleLabel.Parent = window

    return window
end

-- Create Section
local function createSection(parent, sectionTitle)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 100)
    section.Position = UDim2.new(0, 5, 0, 35)
    section.BackgroundColor3 = theme.SectionBackground
    section.BorderSizePixel = 1
    section.BorderColor3 = theme.BorderColor
    section.Parent = parent
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 0, 30)
    sectionLabel.Position = UDim2.new(0, 5, 0, 5)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = sectionTitle or "Section"
    sectionLabel.TextColor3 = theme.TextColor
    sectionLabel.Font = Enum.Font.SourceSans
    sectionLabel.TextSize = 18
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = section
    
    return section
end

-- Create Button
local function createButton(parent, buttonText, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 35)
    button.BackgroundColor3 = theme.ButtonBackground
    button.BorderSizePixel = 1
    button.BorderColor3 = theme.BorderColor
    button.Text = buttonText or "Button"
    button.TextColor3 = theme.TextColor
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        callback()
    end)

    return button
end

-- Create Label
local function createLabel(parent, labelText)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 30)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Label"
    label.TextColor3 = theme.TextColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    return label
end

-- Create Toggle Button (switchable on/off button)
local function createToggleButton(parent, buttonText, defaultState, callback)
    local isActive = defaultState or false
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 35)
    button.BackgroundColor3 = theme.ButtonBackground
    button.BorderSizePixel = 1
    button.BorderColor3 = theme.BorderColor
    button.Text = buttonText or "Toggle Button"
    button.TextColor3 = isActive and theme.AccentColor or theme.TextColor
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        button.TextColor3 = isActive and theme.AccentColor or theme.TextColor
        callback(isActive)
    end)

    return button
end

-- Add Window Draggability
local function makeDraggable(frame, dragHandle)
    local isDragging = false
    local dragInput, mousePos, framePos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Example UI Setup
local mainWindow = createWindow("SpectraUI Example", UDim2.new(0, 400, 0, 300), UDim2.new(0.5, -200, 0.5, -150))
local section1 = createSection(mainWindow, "Section 1")

local button1 = createButton(section1, "Click Me", function()
    print("Button clicked!")
end)

local toggle1 = createToggleButton(section1, "Toggle Me", false, function(state)
    print("Toggle state: " .. tostring(state))
end)

local label1 = createLabel(section1, "This is a label.")

-- Make window draggable
makeDraggable(mainWindow, mainWindow)
