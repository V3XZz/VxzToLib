# VxzToLib Documentation

This documentation is for the stable release of VxzToLib, a modern UI library with a hacker/exploit theme in purple.

## Table of Contents
1. [Booting the Library](#booting-the-library)
2. [Creating a Window](#creating-a-window)
3. [Creating a Tab](#creating-a-tab)
4. [Creating a Section](#creating-a-section)
5. [Notifying the User](#notifying-the-user)
6. [Creating a Button](#creating-a-button)
7. [Creating a Toggle](#creating-a-toggle)
8. [Creating a Color Picker](#creating-a-color-picker)
9. [Creating a Slider](#creating-a-slider)
10. [Creating a Label](#creating-a-label)
11. [Creating a Paragraph](#creating-a-paragraph)
12. [Creating a Textbox](#creating-a-textbox)
13. [Creating a Keybind](#creating-a-keybind)
14. [Creating a Dropdown](#creating-a-dropdown)
15. [Initializing the Library](#initializing-the-library)
16. [Using Flags](#using-flags)
17. [Config System](#config-system)
18. [Destroying the Interface](#destroying-the-interface)

---

## Booting the Library
```lua
local VxzToLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/V3XZz/VxzToLib/refs/heads/main/VxzToLib.lua'))()
```

## Creating a Window
```lua
local Window = VxzToLib:MakeWindow({
    Name = "Title of the library", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "VxzToConfig",
    IntroEnabled = true,
    IntroText = "Loading Hacker Toolkit...",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998",
    CloseCallback = function()
        print("Window closed")
    end
})
```

### Window Options
- **`Name`**: `<string>` - The name of the UI
- **`HidePremium`**: `<bool>` - Whether to show premium status in user details
- **`SaveConfig`**: `<bool>` - Toggles config saving
- **`ConfigFolder`**: `<string>` - Folder name for saved configs
- **`IntroEnabled`**: `<bool>` - Show intro animation
- **`IntroText`**: `<string>` - Text for intro animation
- **`IntroIcon`**: `<string>` - URL for intro image
- **`Icon`**: `<string>` - URL for window icon
- **`CloseCallback`**: `<function>` - Executes when window closes

---

## Creating a Tab
```lua
local Tab = Window:MakeTab({
    Name = "Tab 1",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
```

### Tab Options
- **`Name`**: `<string>` - Tab name
- **`Icon`**: `<string>` - Tab icon URL
- **`PremiumOnly`**: `<bool>` - Make tab premium-only

---

## Creating a Section
```lua
local Section = Tab:AddSection({
    Name = "Combat Features"
})
```

### Section Options
- **`Name`**: `<string>` - Section name

---

## Notifying the User
```lua
VxzToLib:MakeNotification({
    Name = "Alert!",
    Content = "Script loaded successfully!",
    Image = "rbxassetid://4483345998",
    Time = 5
})
```

### Notification Options
- **`Name`**: `<string>` - Notification title
- **`Content`**: `<string>` - Notification content
- **`Image`**: `<string>` - Icon URL
- **`Time`**: `<number>` - Duration in seconds

---

## Creating a Button
```lua
Tab:AddButton({
    Name = "Execute Hack",
    Callback = function()
        print("Hack executed!")
    end    
})
```

### Button Options
- **`Name`**: `<string>` - Button name
- **`Callback`**: `<function>` - Function to execute

---

## Creating a Toggle
```lua
local CoolToggle = Tab:AddToggle({
    Name = "God Mode",
    Default = false,
    Save = true,
    Flag = "GodMode",
    Callback = function(Value)
        print("God Mode:", Value)
    end    
})

-- Change toggle state
CoolToggle:Set(true)
```

### Toggle Options
- **`Name`**: `<string>` - Toggle name
- **`Default`**: `<bool>` - Default value
- **`Save`**: `<bool>` - Save to config
- **`Flag`**: `<string>` - Unique identifier
- **`Callback`**: `<function>` - Execute on change

---

## Creating a Color Picker
```lua
local ColorPicker = Tab:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Save = true,
    Flag = "ESPColor",
    Callback = function(Value)
        print("Color changed to:", Value)
    end	  
})

-- Change color
ColorPicker:Set(Color3.fromRGB(0, 255, 0))
```

### Color Picker Options
- **`Name`**: `<string>` - Color picker name
- **`Default`**: `<Color3>` - Default color
- **`Save`**: `<bool>` - Save to config
- **`Flag`**: `<string>` - Unique identifier
- **`Callback`**: `<function>` - Execute on change

---

## Creating a Slider
```lua
local CoolSlider = Tab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 50,
    Increment = 1,
    ValueName = "units",
    Save = true,
    Flag = "WalkSpeed",
    Callback = function(Value)
        print("Walk Speed:", Value)
    end    
})

-- Change slider value
CoolSlider:Set(100)
```

### Slider Options
- **`Name`**: `<string>` - Slider name
- **`Min`**: `<number>` - Minimum value
- **`Max`**: `<number>` - Maximum value
- **`Default`**: `<number>` - Default value
- **`Increment`**: `<number>` - Value change step
- **`ValueName`**: `<string>` - Value suffix
- **`Save`**: `<bool>` - Save to config
- **`Flag`**: `<string>` - Unique identifier
- **`Callback`**: `<function>` - Execute on change

---

## Creating a Label
```lua
local CoolLabel = Tab:AddLabel("Status: Active")

-- Change label text
CoolLabel:Set("Status: Inactive")
```

---

## Creating a Paragraph
```lua
local CoolParagraph = Tab:AddParagraph("Warning", "Using this may result in a ban!")

-- Change paragraph
CoolParagraph:Set("Important", "Always use with caution!")
```

---

## Creating a Textbox
```lua
Tab:AddTextbox({
    Name = "Username",
    Default = "Player1",
    TextDisappear = true,
    Callback = function(Value)
        print("Username set to:", Value)
    end	  
})
```

### Textbox Options
- **`Name`**: `<string>` - Textbox name
- **`Default`**: `<string>` - Default text
- **`TextDisappear`**: `<bool>` - Clear text after input
- **`Callback`**: `<function>` - Execute on text change

---

## Creating a Keybind
```lua
local CoolBind = Tab:AddBind({
    Name = "Toggle Menu",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Save = true,
    Flag = "MenuToggle",
    Callback = function()
        print("Menu toggled!")
    end    
})

-- Change keybind
CoolBind:Set(Enum.KeyCode.F1)
```

### Keybind Options
- **`Name`**: `<string>` - Keybind name
- **`Default`**: `<Enum.KeyCode>` - Default key
- **`Hold`**: `<bool>` - Require key hold
- **`Save`**: `<bool>` - Save to config
- **`Flag`**: `<string>` - Unique identifier
- **`Callback`**: `<function>` - Execute on press

---

## Creating a Dropdown
```lua
local CoolDropdown = Tab:AddDropdown({
    Name = "Weapon Select",
    Default = "AK-47",
    Options = {"AK-47", "Shotgun", "Sniper"},
    Save = true,
    Flag = "WeaponSelect",
    Callback = function(Value)
        print("Weapon selected:", Value)
    end    
})

-- Refresh options
CoolDropdown:Refresh({"Pistol", "Rocket Launcher"}, true)

-- Set value
CoolDropdown:Set("Sniper")
```

### Dropdown Options
- **`Name`**: `<string>` - Dropdown name
- **`Default`**: `<string>` - Default selection
- **`Options`**: `<table>` - Available options
- **`Save`**: `<bool>` - Save to config
- **`Flag`**: `<string>` - Unique identifier
- **`Callback`**: `<function>` - Execute on selection

---

## Initializing the Library
```lua
-- REQUIRED at the end of your script
VxzToLib:Init()
```

---

## Using Flags
Flags allow you to access element values anywhere in your code:

```lua
Tab:AddToggle({
    Name = "AutoFarm",
    Default = true,
    Save = true,
    Flag = "AutoFarm"
})

-- Access anywhere
print(VxzToLib.Flags["AutoFarm"].Value)
```

Flags work with:
- Toggles
- Sliders
- Dropdowns
- Binds
- Colorpickers

---

## Config System
To enable config saving:
1. Set `SaveConfig = true` in window options
2. Add `Save = true` and `Flag` to elements
3. Configs are saved per game in `ConfigFolder`

```lua
local Window = VxzToLib:MakeWindow({
    SaveConfig = true,
    ConfigFolder = "HackerConfig"
})

Tab:AddToggle({
    Name = "God Mode",
    Save = true,
    Flag = "GodMode"
})
```

---

## Destroying the Interface
```lua
VxzToLib:Destroy()
```

---

## Additional Features
1. **Modern Hacker Theme**: Purple/black color scheme with glow effects
2. **Draggable Window**: Move by dragging the title bar
3. **Minimize**: Hide content without closing
4. **Toggle with LeftShift**: Press LeftShift to show/hide UI
5. **User Info**: Shows display name and avatar in bottom right
6. **Animated Notifications**: Modern notifications above jump button
7. **Protection**: Auto-removes previous instances


## Example Script
```Lua
-- Load the library (replace with your actual URL)
local VxzToLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/V3XZz/VxzToLib/refs/heads/main/VxzToLib.lua'))()

-- Create the main window
local Window = VxzToLib:MakeWindow({
    Name = "Hacker Toolkit v2.0",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VxzToConfig",
    IntroEnabled = true,
    IntroText = "Initializing Exploit System...",
    IntroIcon = "rbxassetid://6031094678",
    Icon = "rbxassetid://6031094678",
    CloseCallback = function()
        print("Hacker Toolkit closed")
    end
})

-- Create tabs
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://6031094678",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6031094678"
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://6031094678"
})

-- Main Tab Content
local CombatSection = MainTab:AddSection({
    Name = "Combat Hacks"
})

CombatSection:AddButton({
    Name = "Kill All Players",
    Callback = function()
        -- Your kill all function here
        VxzToLib:MakeNotification({
            Name = "Combat",
            Content = "Eliminated all targets!",
            Image = "rbxassetid://6031094678",
            Time = 3
        })
    end
})

local GodToggle = CombatSection:AddToggle({
    Name = "God Mode",
    Default = false,
    Save = true,
    Flag = "GodMode",
    Callback = function(Value)
        -- Your god mode function here
        if Value then
            VxzToLib:MakeNotification({
                Name = "Combat",
                Content = "God Mode Activated",
                Image = "rbxassetid://6031094678",
                Time = 2
            })
        end
    end    
})

local AutoFarmSection = MainTab:AddSection({
    Name = "Automation"
})

AutoFarmSection:AddToggle({
    Name = "Auto Farm Coins",
    Default = false,
    Save = true,
    Flag = "AutoFarm",
    Callback = function(Value)
        -- Your auto farm function here
    end    
})

AutoFarmSection:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Color = Color3.fromRGB(180, 80, 255),
    Increment = 1,
    ValueName = "speed",
    Save = true,
    Flag = "FarmSpeed",
    Callback = function(Value)
        -- Set farm speed
    end    
})

-- Player Tab Content
local MovementSection = PlayerTab:AddSection({
    Name = "Movement"
})

MovementSection:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(180, 80, 255),
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

MovementSection:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(180, 80, 255),
    Increment = 10,
    ValueName = "power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

local FlyToggle = MovementSection:AddToggle({
    Name = "Fly Hack",
    Default = false,
    Save = true,
    Flag = "FlyHack",
    Callback = function(Value)
        -- Your fly hack function here
        if Value then
            VxzToLib:MakeNotification({
                Name = "Movement",
                Content = "Flight Systems Activated",
                Image = "rbxassetid://6031094678",
                Time = 2
            })
        end
    end    
})

local FlyBind = MovementSection:AddBind({
    Name = "Fly Toggle Key",
    Default = Enum.KeyCode.F,
    Hold = false,
    Save = true,
    Flag = "FlyToggleKey",
    Callback = function()
        FlyToggle:Set(not FlyToggle.Value)
    end    
})

-- Visual Tab Content
local ESP = VisualTab:AddSection({
    Name = "ESP"
})

local ESPToggle = ESP:AddToggle({
    Name = "Player ESP",
    Default = false,
    Save = true,
    Flag = "PlayerESP",
    Callback = function(Value)
        -- Your ESP function here
    end    
})

local ESPColor = ESP:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(180, 80, 255),
    Save = true,
    Flag = "ESPColor",
    Callback = function(Value)
        -- Update ESP color
    end	  
})

local ChamsSection = VisualTab:AddSection({
    Name = "Character"
})

local ChamsToggle = ChamsSection:AddToggle({
    Name = "X-Ray Chams",
    Default = false,
    Save = true,
    Flag = "XRayChams",
    Callback = function(Value)
        -- Your chams function here
    end    
})

-- Create a dropdown for character effects
local EffectsDropdown = ChamsSection:AddDropdown({
    Name = "Character Effects",
    Default = "None",
    Options = {"None", "Glow", "Wireframe", "Rainbow"},
    Save = true,
    Flag = "CharEffects",
    Callback = function(Value)
        -- Apply character effect
    end    
})

-- Add some informational elements
local InfoSection = MainTab:AddSection({
    Name = "Information"
})

InfoSection:AddParagraph("Welcome!", "Welcome to Hacker Toolkit v2.0")
InfoSection:AddLabel("Status: Active")
InfoSection:AddTextbox({
    Name = "Command Input",
    Default = "Type commands here",
    TextDisappear = true,
    Callback = function(Value)
        -- Handle command input
        VxzToLib:MakeNotification({
            Name = "Command",
            Content = "Executed: "..Value,
            Image = "rbxassetid://6031094678",
            Time = 3
        })
    end	  
})

-- Initialize the UI (REQUIRED)
VxzToLib:Init()

-- Show welcome notification
VxzToLib:MakeNotification({
    Name = "System Online",
    Content = "Hacker Toolkit initialized successfully!",
    Image = "rbxassetid://6031094678",
    Time = 5
})

-- Demonstration of flag usage
spawn(function()
    while wait(5) do
        if VxzToLib.Flags["GodMode"].Value then
            print("God Mode is active")
        end
        if VxzToLib.Flags["AutoFarm"].Value then
            print("Auto Farming at speed:", VxzToLib.Flags["FarmSpeed"].Value)
        end
    end
end)

-- Optional: Add a way to destroy the UI
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.End then
        VxzToLib:Destroy()
        VxzToLib:MakeNotification({
            Name = "System Offline",
            Content = "Hacker Toolkit terminated",
            Image = "rbxassetid://6031094678",
            Time = 3
        })
    end
end)
```
