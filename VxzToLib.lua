local VxzToLib = {}
VxzToLib.__index = VxzToLib


local function Tween(instance, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = game:GetService("TweenService"):Create(instance, tweenInfo, props)
    tween:Play()
    return tween
end

local function Create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            instance[prop] = value
        end
    end
    return instance
end

local function LoadAssets()
    local assets = {
        Close = "rbxassetid://6031094678",
        Minimize = "rbxassetid://6031094678",
        ArrowDown = "rbxassetid://6031094678",
        ArrowUp = "rbxassetid://6031094678",
        ToggleOn = "rbxassetid://6031094678",
        ToggleOff = "rbxassetid://6031094678",
        SliderHandle = "rbxassetid://6031094678",
        DropdownIcon = "rbxassetid://6031094678",
        Notification = "rbxassetid://6031094678"
    }
    
    
    pcall(function()
        local response = game:HttpGet("https://raw.githubusercontent.com/V3XZz/Orion-Lib-Moded/main/assetvrion.json")
        local jsonAssets = game:GetService("HttpService"):JSONDecode(response)
        for k, v in pairs(jsonAssets) do
            assets[k] = v
        end
    end)
    
    return assets
end

local Assets = LoadAssets()


function VxzToLib.new()
    local self = setmetatable({}, VxzToLib)
    self.Flags = {}
    self.Configs = {}
    self.CurrentConfig = {}
    self.Elements = {}
    self.NotificationQueue = {}
    self.ActiveNotifications = 0
    return self
end

function VxzToLib:MakeWindow(options)
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Config = {
        Name = options.Name or "VxzTo Library",
        HidePremium = options.HidePremium or false,
        SaveConfig = options.SaveConfig or false,
        ConfigFolder = options.ConfigFolder or "VxzToConfig",
        IntroEnabled = options.IntroEnabled or false,
        IntroText = options.IntroText or "Loading VxzTo Library...",
        IntroIcon = options.IntroIcon or Assets.Notification,
        Icon = options.Icon or Assets.Notification,
        CloseCallback = options.CloseCallback or function() end
    }
    
    self.ScreenGui = Create("ScreenGui", {
        Name = "VxzToUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    
    if self.Config.IntroEnabled then
        local IntroFrame = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(10, 5, 15),
            Parent = self.ScreenGui
        })
        
        Create("ImageLabel", {
            Size = UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(0.5, -50, 0.4, -50),
            BackgroundTransparency = 1,
            Image = self.Config.IntroIcon,
            Parent = IntroFrame
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            Position = UDim2.new(0, 0, 0.6, 0),
            BackgroundTransparency = 1,
            Text = self.Config.IntroText,
            TextColor3 = Color3.fromRGB(180, 80, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 20,
            Parent = IntroFrame
        })
        
        wait(2)
        Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
        wait(0.5)
        IntroFrame:Destroy()
    end
    
    
    self.Window = Create("Frame", {
        Name = "Window",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(20, 10, 30),
        BorderColor3 = Color3.fromRGB(80, 0, 120),
        BorderSizePixel = 1,
        Parent = self.ScreenGui
    })
    
    
    Create("ImageLabel", {
        Size = UDim2.new(1, 12, 1, 12),
        Position = UDim2.new(0, -6, 0, -6),
        BackgroundTransparency = 1,
        Image = "rbxassetid://4996891970",
        ImageColor3 = Color3.fromRGB(120, 0, 200),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = self.Window
    })
    
    
    local TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 15, 45),
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    
    Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Config.Name,
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    
    local Controls = Create("Frame", {
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = TitleBar
    })
    
    
    self.MinimizeButton = Create("ImageButton", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = Assets.Minimize,
        ImageColor3 = Color3.fromRGB(180, 80, 255),
        Parent = Controls
    })
    
    
    self.CloseButton = Create("ImageButton", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = Assets.Close,
        ImageColor3 = Color3.fromRGB(180, 80, 255),
        Parent = Controls
    })
    
    
    self.TabContainer = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1,
        Parent = self.Window
    })
    
    
    Create("UIListLayout", {
        Parent = self.TabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5)
    })
    
    
    self.ContentContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Window
    })
    
    
    local ContentLayout = Create("UIListLayout", {
        Parent = self.ContentContainer,
        Padding = UDim.new(0, 5)
    })
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    
    self.UserPanel = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 1, -40),
        BackgroundColor3 = Color3.fromRGB(30, 15, 45),
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    
    self.Avatar = Create("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        BackgroundTransparency = 1,
        Parent = self.UserPanel
    })
    

    Create("Frame", {
        Size = UDim2.new(1, 2, 1, 2),
        Position = UDim2.new(0, -1, 0, -1),
        BackgroundColor3 = Color3.fromRGB(80, 0, 120),
        BorderSizePixel = 0,
        Parent = self.Avatar
    })
    
    
    self.DisplayName = Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "Loading...",
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.UserPanel
    })
    
    
    self.NotificationContainer = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.5, -150, 0, 10),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    
    
    Create("UIListLayout", {
        Parent = self.NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self.Config.CloseCallback()
        Tween(self.Window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    
    local minimized = false
    self.MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(self.Window, {Size = UDim2.new(0, 500, 0, 80)}, 0.3)
            self.ContentContainer.Visible = false
            self.TabContainer.Visible = false
        else
            Tween(self.Window, {Size = UDim2.new(0, 500, 0, 400)}, 0.3)
            self.ContentContainer.Visible = true
            self.TabContainer.Visible = true
        end
    end)
    
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)
    
    
    spawn(function()
        local player = game:GetService("Players").LocalPlayer
        self.DisplayName.Text = player.DisplayName or player.Name
        
        
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size48x48
        local content, isReady = player:GetUserThumbnailAsync(thumbType, thumbSize)
        self.Avatar.Image = content
    end)
    
    
    if self.Config.SaveConfig then
        self:LoadConfig()
    end
    
    return self
end


function VxzToLib:MakeTab(options)
    local TabButton = Create("TextButton", {
        Name = "Tab_"..options.Name,
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = self.TabContainer
    })
    
    local TabIcon = Create("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 5, 0.5, -10),
        BackgroundTransparency = 1,
        Image = options.Icon,
        Parent = TabButton
    })
    
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Text = "  "..options.Name
    
    local TabContent = Create("Frame", {
        Name = "TabContent_"..options.Name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local TabLayout = Create("UIListLayout", {
        Parent = TabContent,
        Padding = UDim.new(0, 5)
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    end)
    
    local tabObj = {
        Button = TabButton,
        Content = TabContent,
        AddSection = function(self, options)
            return self:AddSection(options)
        end,
        AddButton = function(self, options)
            return self:AddButton(options)
        end,
        AddToggle = function(self, options)
            return self:AddToggle(options)
        end,
        AddSlider = function(self, options)
            return self:AddSlider(options)
        end,
        AddLabel = function(self, options)
            return self:AddLabel(options)
        end,
        AddParagraph = function(self, options)
            return self:AddParagraph(options)
        end,
        AddTextbox = function(self, options)
            return self:AddTextbox(options)
        end,
        AddBind = function(self, options)
            return self:AddBind(options)
        end,
        AddDropdown = function(self, options)
            return self:AddDropdown(options)
        end,
        AddColorpicker = function(self, options)
            return self:AddColorpicker(options)
        end
    }
    
    self.Tabs = self.Tabs or {}
    table.insert(self.Tabs, tabObj)
    
    
    if #self.Tabs == 1 then
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    end
    
    return tabObj
end


function VxzToLib:AddSection(options)
    local SectionFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = self.Content
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(150, 50, 220),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionFrame
    })
    
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 22),
        BackgroundColor3 = Color3.fromRGB(80, 0, 120),
        BorderSizePixel = 0,
        Parent = SectionFrame
    })
    
    local SectionContent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local SectionLayout = Create("UIListLayout", {
        Parent = SectionContent,
        Padding = UDim.new(0, 5)
    })
    
    SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
        SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 25)
    end)
    
    local sectionObj = {
        Frame = SectionFrame,
        Content = SectionContent,
        AddButton = function(self, options)
            return self:AddButton(options)
        end,
        AddToggle = function(self, options)
            return self:AddToggle(options)
        end,
        AddSlider = function(self, options)
            return self:AddSlider(options)
        end,
        AddLabel = function(self, options)
            return self:AddLabel(options)
        end,
        AddParagraph = function(self, options)
            return self:AddParagraph(options)
        end,
        AddTextbox = function(self, options)
            return self:AddTextbox(options)
        end,
        AddBind = function(self, options)
            return self:AddBind(options)
        end,
        AddDropdown = function(self, options)
            return self:AddDropdown(options)
        end,
        AddColorpicker = function(self, options)
            return self:AddColorpicker(options)
        end
    }
    
    return sectionObj
end

-- Element creation functions
function VxzToLib:AddButton(options)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = self.Content
    })
    
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(60, 30, 90)}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 20, 60)}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        options.Callback()
    end)
    
    return Button
end

function VxzToLib:AddToggle(options)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = self.Content
    })
    
    Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })
    
    local ToggleButton = Create("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(0.7, 0, 0.5, -12.5),
        BackgroundColor3 = options.Default and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 15, 45),
        BorderSizePixel = 0,
        Text = "",
        Parent = ToggleFrame
    })
    
    local ToggleCircle = Create("Frame", {
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, options.Default and 29 or 2, 0.5, -10.5),
        BackgroundColor3 = Color3.fromRGB(200, 120, 255),
        BorderSizePixel = 0,
        Parent = ToggleButton
    })
    
    local toggleObj = {
        Value = options.Default or false,
        Set = function(self, value)
            self.Value = value
            Tween(ToggleButton, {
                BackgroundColor3 = value and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 15, 45)
            }, 0.2)
            
            Tween(ToggleCircle, {
                Position = UDim2.new(0, value and 29 or 2, 0.5, -10.5)
            }, 0.2)
            
            options.Callback(value)
        end
    }
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggleObj:Set(not toggleObj.Value)
    end)
    
    
    if options.Flag then
        self.Flags[options.Flag] = toggleObj
    end
    
    return toggleObj
end



function VxzToLib:MakeNotification(options)
    local Notification = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 15, 35),
        BorderColor3 = Color3.fromRGB(80, 0, 120),
        BorderSizePixel = 1,
        LayoutOrder = 999,
        Parent = self.NotificationContainer
    })
    
    Create("ImageLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Image = options.Image or Assets.Notification,
        Parent = Notification
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 25),
        Position = UDim2.new(0, 45, 0, 5),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        Text = options.Content,
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local contentSize = 0
    for i = 1, #options.Content, 60 do
        contentSize = contentSize + 1
    end
    
    Notification.Size = UDim2.new(1, 0, 0, 50 + (contentSize * 12))
    Notification["TextLabel"].Size = UDim2.new(1, -10, 0, contentSize * 12)
    
    
    spawn(function()
        wait(options.Time or 5)
        Tween(Notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        wait(0.3)
        Notification:Destroy()
    end)
    
    return Notification
end


function VxzToLib:SaveConfig()
    if not self.Config.SaveConfig then return end
    
    local config = {}
    
    
    for flag, element in pairs(self.Flags) do
        if element.Value ~= nil then
            config[flag] = element.Value
        end
    end
    
    
    local success, err = pcall(function()
        if not isfolder(self.Config.ConfigFolder) then
            makefolder(self.Config.ConfigFolder)
        end
        
        local filePath = self.Config.ConfigFolder .. "/" .. game.PlaceId .. ".json"
        writefile(filePath, game:GetService("HttpService"):JSONEncode(config))
    end)
    
    if not success then
        self:MakeNotification({
            Name = "Config Error",
            Content = "Failed to save config: " .. err,
            Time = 5
        })
    end
end

function VxzToLib:LoadConfig()
    if not self.Config.SaveConfig then return end
    
    local success, config = pcall(function()
        local filePath = self.Config.ConfigFolder .. "/" .. game.PlaceId .. ".json"
        if isfile(filePath) then
            return game:GetService("HttpService"):JSONDecode(readfile(filePath))
        end
    end)
    
    if success and config then
        for flag, value in pairs(config) do
            if self.Flags[flag] and self.Flags[flag].Set then
                self.Flags[flag]:Set(value)
            end
        end
    end
end

function VxzToLib:Init()

    self.ScreenGui.Parent = game:GetService("CoreGui")
    return self
end

function VxzToLib:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    self = nil
end

return VxzToLib