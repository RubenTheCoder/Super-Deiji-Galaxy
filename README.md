# Roblox-project-1
Zou een platformer spel worden, maar is nu nummer #353.133 op de lijst van onvoltooide projecten


Game Client Script
Description
This script handles various client-side player actions after the 'FirstScript' has been executed.

Game Services
Services Used
GuiService: Manages GUI-related functionalities.
Players: Provides access to player-related information and functions.
ReplicatedFirst: Manages replication of assets to the client before the player joins the game.
ReplicatedStorage: Stores assets that need to be replicated between the server and client.
StarterGui: Manages the player's initial GUI.
SoundService: Manages in-game sounds.
TweenService: Manages tweening animations.
Settings
Device
DeviceBreakPoint: The pixel width at which the game toggles to using PC as the device.
Interface
FadeDuration: The duration of fade transitions in seconds.
TitleBackgroundScrollDuration: The duration of one scrolling round of the title screen background in seconds.
Instance Variables
Folders
remotes: Reference to the "Remotes" folder in ReplicatedStorage.
Camera
currentCamera: Reference to the workspace's current camera.
Connections
gameLoadedRemote: Reference to the "GameLoaded" remote event inside the "Remotes" folder.
Player
player: Reference to the local player.
playerGui: Reference to the player's GUI.
Sound
music: Reference to the "Music" sound object inside SoundService.
Preset Values
Device
device: Stores the current device type, initialized to "Mobile".
Interface
screenGui: Reference to the active screen GUI.
Coroutines
asyncList: Table containing active asynchronous functions.
asyncStats: Table containing status information for asynchronous functions.
Calculated Values
Device
getDeviceType(): Function that determines the device type used by the player.
Interface
setScreenGui(): Function to update the active screen GUI based on the device.
Functions
Coroutines
startAsync(functionObject, parameters): Starts an asynchronous function with optional parameters.
isAsyncRunning(asyncName): Returns the status of an asynchronous function.
stopAsync(functionObject): Stops a running asynchronous function.
Interface
startFade(transparency, duration): Darkens the screen for transition effects.
scrollTitleBackground(asyncName): Scrolls the title screen background.
flashText(flashTextLabel, transparency, duration): Creates a flashing effect on a text label.
Game
loadPlayer(): Continues loading the game from where 'FirstScript' left off.
Connections
gameLoadedRemote.Event:Connect(loadPlayer): Connects the loadPlayer() function to the "GameLoaded" remote event.
