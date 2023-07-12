--[[
    Code description
    
    This script is used to display our custom loading screen and to disable coregui.
    It also disables controls
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

-- █ 👁️ Interface 👁️ █

-- How often the loadcircle steps in rotation
local LoadCircleDelay = 0.01 -- in seconds

-- How many degrees a loadcircle steps
local LoadCircleStep = 2 -- in degrees

-- How long the replacement of the roblox loading screen must be visible at least
local LoadscreenMinDuration = 5 -- in seconds

-- Length of fade transitions
local FadeDuration = 1 -- in seconds




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
local firstAssets = ReplicatedFirst:WaitForChild("Assets")
local remotes = ReplicatedStorage:WaitForChild("Remotes")



-- █ 📡 Connections 📡 █
local gameLoadedRemote = remotes:WaitForChild("GameLoaded")



-- █ ⛷ Player ⛷ █
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")



-- █ 👁️ Interface 👁️ █
local screenGui = firstAssets:WaitForChild("LoadGui"):Clone()





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

--[[ Starts a function async, with optional parameters to be parsed]]
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

--[[
    Spins the loadcircle of the roblox loadscreen until disabled by 'stopAsync()'.
    
    This is a async function.
]]
local function spinLoadCircle(asyncName, parameters)
    local loadCircle = parameters["loadCircle"]
    -- Rotates the circle while the coroutine is active
    while asyncStats[asyncName] == "Running" do
        task.wait(LoadCircleDelay)
        loadCircle.Rotation += LoadCircleStep
    end

    -- Stops it after the loop completed during a 'stopAsync()'
    asyncStats[asyncName] = "Stopped"
end



-- Replaces the default roblox loading screen with our custom one
local function replaceRobloxLoadscreen()
    local robloxLoadscreen = screenGui:WaitForChild("RobloxLoadscreen")
    robloxLoadscreen.Visible = true
    ReplicatedFirst:RemoveDefaultLoadingScreen()
end



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



-- █ 🕹 Game 🕹 █

-- This function runs others to show our own loading screen and then execute the ClientScript
local function loadGame()
    -- Disable controls and coregui
    GuiService.TouchControlsEnabled = false
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    -- Replace the loading screen
    screenGui.Parent = playerGui
    replaceRobloxLoadscreen()
    
    -- Get the load circle
    local loadScreen = screenGui:WaitForChild("RobloxLoadscreen")
    local loadFrame = loadScreen:WaitForChild("LoadFrame")
    local loadCircle = loadFrame:WaitForChild("LoadCircle")

    -- Start the loadcircle animation
    startAsync(spinLoadCircle, {loadCircle = loadCircle}) -- Function, LoadCircle

    -- Make the loading screen stay a minimum duration
    task.wait(LoadscreenMinDuration)

    -- Wait until the game loaded
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    -- Start the Transition to the loading screen
    startFade(0, FadeDuration) -- Transparency, Duration
    
    -- Wait for the transition to end
    task.wait(FadeDuration)

    -- Stop the loadcircle animation
    stopAsync(spinLoadCircle)
    
    -- Execute the 'ClientScript'
    gameLoadedRemote:Fire()
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

-- █ 🕹 Game 🕹 █
loadGame()
