-- Makes the lib work
_Hawk = "ohhahtuhthttouttpwuttuaunbotwo"

--loadstring
local Hawk = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHanki/HawkHUB/main/LibSources/HawkLib.lua", true))()

-- Creating Window
local Window = Hawk:Window({
	ScriptName = "Hawk HUB",
	DestroyIfExists = true,
	Theme = "Dark"
})

-- Creating Close Button
Window:Close({
	visibility = true,
	Callback = function()
		Window:Destroy()
	end,
})

-- Creating Minimize Button
Window:Minimize({
	visibility = true,
	OpenButton = true,
	Callback = function() end,
})

-- Creating Tab
local tab1 = Window:Tab("Player & Environment Settings")

-- Creating Section
local newsec = tab1:Section("Player Modifiers")

------------------------------------------------------

-- Full Bright Toggle
local function toggleFullBright(value)
	if value then
		game.Lighting.Brightness = 2 -- Max Brightness
		game.Lighting.GlobalShadows = false
	else
		game.Lighting.Brightness = 1 -- Default Brightness
		game.Lighting.GlobalShadows = true
	end
end
newsec:Toggle("Full Bright", false, toggleFullBright)

------------------------------------------------------

-- WalkSpeed Slider
local function changeWalkSpeed(value)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end
local walkSpeedSlider = newsec:Slider("WalkSpeed", 16, 100, changeWalkSpeed)
walkSpeedSlider:SetValue(16) -- Default WalkSpeed

------------------------------------------------------

-- JumpPower Slider
local function changeJumpPower(value)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end
local jumpPowerSlider = newsec:Slider("JumpPower", 50, 200, changeJumpPower)
jumpPowerSlider:SetValue(50) -- Default JumpPower

------------------------------------------------------

-- Gravity Slider
local function changeGravity(value)
	game.Workspace.Gravity = value
end
local gravitySlider = newsec:Slider("Gravity", 50, 196.2, changeGravity)
gravitySlider:SetValue(196.2) -- Default Gravity

------------------------------------------------------

-- Field of View (FOV) Slider
local function changeFOV(value)
	game.Workspace.CurrentCamera.FieldOfView = value
end
local fovSlider = newsec:Slider("Field of View", 70, 120, changeFOV)
fovSlider:SetValue(70) -- Default FOV

------------------------------------------------------

-- Time of Day Slider
local function changeTimeOfDay(value)
	game.Lighting.TimeOfDay = tostring(value)
end
local timeOfDaySlider = newsec:Slider("Time of Day", 0, 24, changeTimeOfDay)
timeOfDaySlider:SetValue(14) -- Default to 2 PM

------------------------------------------------------

-- Fog Density Slider
local function changeFogDensity(value)
	game.Lighting.FogEnd = value
end
local fogDensitySlider = newsec:Slider("Fog Density", 100, 100000, changeFogDensity)
fogDensitySlider:SetValue(100000) -- Default Fog End

------------------------------------------------------

-- Adding Keybind for Reset
local function resetSettings()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
	game.Workspace.Gravity = 196.2
	game.Workspace.CurrentCamera.FieldOfView = 70
	game.Lighting.TimeOfDay = "14" -- Default to 2 PM
	game.Lighting.FogEnd = 100000
end
newsec:KeyBind("Reset to Default", "R", resetSettings)

------------------------------------------------------

-- Creating Notifications
local Notifications = Hawk:AddNotifications()

-- Example Notification usage
Notifications:Notification("Settings Loaded", "You can now adjust WalkSpeed, JumpPower, Gravity, and more!", "Notify", 5)
