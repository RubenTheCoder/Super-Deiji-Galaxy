--[[
    Code description
    
    This script is used for all client-side player actions after the 'FirstScript'
]]





----------------------------------------------------------------
-- ████████████████████
-- 🛎 Game services 🛎
-- ████████████████████

-- Game services for our code

-- > Sorted alphabetically
-- > Services use PascalCase
-- > Services are get using GetService()
----------------------------------------------------------------

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")





----------------------------------------------------------------
-- ███████████████
-- ⚙️ Settings ⚙️
-- ███████████████

-- Values that can be tweaked to alter the game

-- > Sorted by category, then alphabetically 
-- > Settings use PascalCase
-- > Private settings have a underscore in front of them
----------------------------------------------------------------

-- █ 📱 Device 📱 █

-- When to toggle to PC as device used
local DeviceBreakPoint = 768 -- pixels



-- █ 👁️ Interface 👁️ █

-- Length of the fade transitions
local FadeDuration = 1 -- in seconds

-- How long one scrolling round of the titlescreen background takes
local TitleBackgroundScrollDuration = 60 -- in seconds





----------------------------------------------------------------
-- █████████████████████████
-- 💎 Instance variables 💎
-- █████████████████████████

-- Variables like paths and objects

-- > Sorted by order of requirement, category and then alphabetically
-- > Variables use camelCase
-- > Private variables have a underscore in front of them
----------------------------------------------------------------

-- █ 📁 Folders 📁 █
local remotes = ReplicatedStorage:WaitForChild("Remotes")



-- █ 📷 Camera 📷 █
local currentCamera = workspace.CurrentCamera



-- █ 📡 Connections 📡 █
local gameLoadedRemote = remotes:WaitForChild("GameLoaded")



-- █ ⛷ Player ⛷ █
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")



-- █ 🎼 Sound 🎼 █
local music = SoundService:WaitForChild("Music")





----------------------------------------------------------------
-- ███████████████████████
-- 📊 Normal variables 📊
-- ███████████████████████

-- Variables like tables and information

-- > Sorted by order of requirement, category and then alphabetically
-- > Variables use camelCase
-- > Private variables have a underscore in front of them
----------------------------------------------------------------





----------------------------------------------------------------
-- ███████████████████
-- 📄 Preset values 📄
-- ███████████████████

-- Used to hold preset values for later on

-- > Sorted on category and then alphabetically
-- > Variables use camelCase
-- > Private variables have a underscore in front of them
----------------------------------------------------------------

-- █ 📱 Device 📱 █
local device = "Mobile"



-- █ 👁️ Interface 👁️ █
local screenGui = playerGui:WaitForChild("Mobile")



-- █ ⛓ Coroutines ⛓ █
local asyncList = {}
local asyncStats = {}





----------------------------------------------------------------
-- ████████████████████████
-- 🧮 Calculated values 🧮
-- ████████████████████████

-- Values that require other values or functions to be determind

-- > Sorted by order of requirement, category and alphabetically
-- > Variables and functions use camelCase
-- > Private variables or functions have a underscore in front of them
----------------------------------------------------------------

-- █ 📱 Device 📱 █

-- Returns the device used by the player
local function getDeviceType()
    local largeScreen = currentCamera.ViewportSize.X > DeviceBreakPoint

    -- Only consoles use 'ten foot interfaces'
    if GuiService:IsTenFootInterface() then
        if largeScreen then
            return "Console"
        else
            return "SmallConsole"
        end
    end

    if largeScreen then
        return "PC"
    else
        return "Mobile"
    end
end

-- First time initialization
getDeviceType()

-- TODO TESTCODE
device = "Mobile"



-- █ 👁️ Interface 👁️ █

-- Updates what screenGui is being used and turns off the others
local function setScreenGui()
    local screenGuis = playerGui:GetChildren()
    
    -- List of screengui's allowed to close
    local whitelist = {
        "Mobile",
        "PC",
        "Console",
        "SmallConsole"
    }

    -- Turns off all other screenGui's
    for index, screenGui in pairs(screenGuis) do
        if screenGui:IsA("ScreenGui") and table.find(whitelist, screenGui.Name) then
            screenGui.Enabled = false
        end
    end

    -- Opens the right screenGui
    local screenGui = playerGui:WaitForChild(device)
    screenGui.Enabled = true
end

-- First time initialization
setScreenGui()





----------------------------------------------------------------
-- ████████████████
-- 🗜 Functions 🗜
-- ████████████████

-- Runnable blocks of code, not required at startup

-- > Sorted by order of requirement, category and alphabetically
-- > Functions use camelCase
-- > Private variables have a underscore in front of them
----------------------------------------------------------------

-- █ ⛓ Coroutines ⛓ █

-- Starts a function async, with optional parameters to be parsed
function startAsync(functionObject, parameters)
    -- Creates a string of the function's id
    local asyncName = tostring(functionObject)

    -- Creates a coroutine function
    local asyncFunction = coroutine.create(functionObject)

    -- Puts the function and its status inside tables
    asyncList[asyncName] = asyncFunction
    asyncStats[asyncName] = "Running"

    -- Start the coroutine
    coroutine.resume(asyncFunction, asyncName, parameters)
end



-- Returns the coroutine status
local function isAsyncRunning(asyncName)
    if asyncList[asyncName] then
        return coroutine.status(asyncList[asyncName])
    end
end



-- Stops a coroutine using the function parsed previously at 'startAsync()'
local function stopAsync(functionObject)
    -- Creates a string of the function's id
    local asyncName = tostring(functionObject)

    -- Gets the function from the list using its roblox function id
    local asyncFunction = asyncList[asyncName]

    if asyncFunction then
        -- Makes the loops stop
        asyncStats[asyncName] = "Stopping"

        -- Waits for function to ended properly
        while asyncStats[asyncName] == "Stopping" and isAsyncRunning(asyncName) do
            task.wait()
        end

        -- Ends the coroutine after the running has finished
        coroutine.close(asyncFunction)
        asyncStats[asyncName] = nil
        asyncList[asyncName] = nil
    end
end



-- █ 👁️ Interface 👁️ █

-- Darkens the screen for transition effects
local function startFade(transparency, duration)
    -- Create the tween info
    local fadeScreen = screenGui:WaitForChild("FadeScreen")
    local fadeTweenInfo = TweenInfo.new(
        1,
        Enum.EasingStyle.Circular,
        Enum.EasingDirection.In
    )
    
    -- Create the tween
    local fadeTween = TweenService:Create(
        fadeScreen,
        fadeTweenInfo,
        {BackgroundTransparency = transparency})
    
    -- Run the tween
    fadeTween:Play()
end



-- Scrolls the background of the titleframe
local function scrollTitleBackground(asyncName)
    local titleScreen = screenGui:WaitForChild("TitleScreen")
    local scroller = titleScreen:WaitForChild("Scroller")
        
    -- Scrolls the background while the coroutine is still active
    while asyncStats[asyncName] == "Running" do
        -- Reset the scroller
        scroller.Position = UDim2.new(0,0,0,0)
        
        -- Create tween info
        local scrollTweenInfo = TweenInfo.new(
            TitleBackgroundScrollDuration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.In
        )
        
        -- Create the scrolling tween
        local tween = TweenService:Create(
            scroller,
            scrollTweenInfo,
            {Position = UDim2.new(-4,0,0,0)}
        )
        
        -- Run the tween
        tween:Play()
        
        -- Wait for the tween to end
        task.wait(TitleBackgroundScrollDuration)
    end

    -- Stops it after the loop completed during a 'stopAsync()'
    asyncStats[asyncName] = "Stopped"
end



-- Flashes a flash textlabel
local function flashText(flashTextLabel, transparency, duration)
    local titleFlashTweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.In
    )
    
    -- Create a tween
    local titleFlashTween = TweenService:Create(
        flashTextLabel,
        titleFlashTweenInfo,
        {TextTransparency = transparency}
    )
    
    -- Run the tween
    titleFlashTween:Play()
end



-- █ 🕹 Game 🕹 █

-- This will continue to load the game where the 'FirstScript' left of
local function loadPlayer()
    -- Get the fadescreen and set its transparency
    local fadeScreen = screenGui:WaitForChild("FadeScreen")
    fadeScreen.BackgroundTransparency = 0
    
    -- Close the loadgui
    local loadGui = playerGui:WaitForChild("LoadGui")
    loadGui.Enabled = false
    
    -- Open the titlescreen
    local titleScreen = screenGui:WaitForChild("TitleScreen")
    titleScreen.Visible = true
    
    -- Start playing the intro music
    local introMusic = music:WaitForChild("Intro")
    introMusic:Play()
    
    -- Start rotating the background
    startAsync(scrollTitleBackground)
    
    -- Fade out the fadescreen
    startFade(1, FadeDuration)
    
    -- Wait for the fade transition to end
    task.wait(FadeDuration)
    
    -- Wait a short delay before flashing in the title
    task.wait(1)
    
    -- Flash in the title
    local title = titleScreen:WaitForChild("Title")
    local titleFlash = titleScreen:WaitForChild("TitleFlash")
    flashText(titleFlash, 0, 0.5)
    
    -- Wait for the tween to end
    task.wait(0.5)
    
    -- Show the real title
    title.Visible = true
    
    -- End the flash
    flashText(titleFlash, 1, 1)
    
    -- Wait for the tween to end
    task.wait(1)
end





----------------------------------------------------------------
-- ██████████████████
-- 🔗 Connections 🔗
-- ██████████████████

-- Binds events to functions

-- > Sorted by category and alphabetically
-- > Connections use camelCase
-- > Private connections have a underscore in front of them
----------------------------------------------------------------

-- █ 📡 Connections 📡 █
gameLoadedRemote.Event:Connect(loadPlayer)
