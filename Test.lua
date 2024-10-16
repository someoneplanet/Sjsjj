local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cypherdh/VanisUILIB/main/.gitignore"))()
local Window = library:CreateWindow("Settings", "Your Game", "v1.0", "1234567890")
local Tab = Window:CreateTab("Player & Environment Settings")
local Page = Tab:CreateFrame("Adjustments")

-- Full Bright Toggle
local function toggleFullBright(enabled)
    if enabled then
        game.Lighting.Brightness = 2 -- Max Brightness
        game.Lighting.GlobalShadows = false
    else
        game.Lighting.Brightness = 1 -- Normal Brightness
        game.Lighting.GlobalShadows = true
    end
end
local FullBrightToggle = Page:CreateToggle("Full Bright", "Toggle full bright mode", toggleFullBright)

-- WalkSpeed Slider
local function changeWalkSpeed(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end
local WalkSpeedSlider = Page:CreateSlider("WalkSpeed", 16, 100, changeWalkSpeed)

-- JumpPower Slider
local function changeJumpPower(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end
local JumpPowerSlider = Page:CreateSlider("JumpPower", 50, 200, changeJumpPower)

-- Gravity Slider
local function changeGravity(value)
    game.Workspace.Gravity = value
end
local GravitySlider = Page:CreateSlider("Gravity", 50, 196.2, changeGravity)

-- Field of View (FOV) Slider
local function changeFOV(value)
    game.Workspace.CurrentCamera.FieldOfView = value
end
local FOVSlider = Page:CreateSlider("Field of View", 70, 120, changeFOV) -- Default 70

-- HipHeight Slider
local function changeHipHeight(value)
    game.Players.LocalPlayer.Character.Humanoid.HipHeight = value
end
local HipHeightSlider = Page:CreateSlider("Hip Height", 0, 50, changeHipHeight)

-- Time of Day Slider
local function changeTimeOfDay(value)
    game.Lighting.TimeOfDay = tostring(value)
end
local TimeOfDaySlider = Page:CreateSlider("Time of Day", 0, 24, changeTimeOfDay) -- 0 = midnight, 12 = noon

-- Fog Density Slider
local function changeFogDensity(value)
    game.Lighting.FogEnd = value
end
local FogDensitySlider = Page:CreateSlider("Fog Density", 100, 100000, changeFogDensity)

-- Notifications
local function showNotification(title, description)
    library:Notification(title, description, function() print("Notification acknowledged!") end)
end

-- Example Notification usage
showNotification("Settings Loaded", "You can now adjust WalkSpeed, JumpPower, Gravity, FOV, Hip Height, Time of Day, and more!")

-- Adding Keybind Example
local function resetSettings()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    game.Workspace.Gravity = 196.2
    game.Workspace.CurrentCamera.FieldOfView = 70
    game.Lighting.TimeOfDay = "14" -- Default to 2 PM
    game.Lighting.FogEnd = 100000
end
local ResetSettingsBind = Page:CreateBind("Reset to Default", "R", resetSettings)
