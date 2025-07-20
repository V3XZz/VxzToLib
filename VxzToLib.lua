-- VxzToLib - Modern Hacker UI Library
local VxzToLib = {Flags = {}, Tabs = {}, Config = {}}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function Tween(instance, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, props)
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

function VxzToLib:MakeWindow(options)
    if self.ScreenGui then self.ScreenGui:Destroy() end
    
    self.Config = {
        Name = options.Name or "VxzTo Library",
        HidePremium = options.HidePremium or false,
        SaveConfig = options.SaveConfig or false,
        ConfigFolder = options.ConfigFolder or "VxzToConfig",
        IntroEnabled = options.IntroEnabled or false,
        IntroText = options.IntroText or "Loading...",
        IntroIcon = options.IntroIcon or "rbxassetid://6031094678",
        Icon = options.Icon or "rbxassetid://6031094678",
        CloseCallback = options.CloseCallback or function() end
    }
    
    self.ScreenGui = Create("ScreenGui", {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui")
    })
    
    if self.Config.IntroEnabled then
        local IntroIcon = Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.4, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Image = self.Config.IntroIcon,
            ImageColor3 = Color3.fromRGB(180, 80, 255),
            Parent = self.ScreenGui
        })
        
        local IntroText = Create("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.6, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = self.Config.IntroText,
            TextColor3 = Color3.fromRGB(180, 80, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 24,
            Parent = self.ScreenGui
        })
        
        Tween(IntroIcon, {Size = UDim2.new(0, 80, 0, 80), Rotation = 360}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        wait(0.3)
        Tween(IntroText, {Size = UDim2.new(0, 300, 0, 40)}, 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        wait(1.5)
        
        Tween(IntroIcon, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.3, 0)}, 0.5)
        Tween(IntroText, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.7, 0)}, 0.5)
        wait(0.5)
        IntroIcon:Destroy()
        IntroText:Destroy()
    end
    
    self.Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 600, 0, 400),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = self.Window})
    
    local Border = Create("Frame", {
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.new(0, -2, 0, -2),
        BackgroundColor3 = Color3.fromRGB(120, 50, 200),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = Border})
    
    local Glass = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    local TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TitleBar})
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 0),
        Size = UDim2.new(0.7, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = self.Config.Name,
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    local Controls = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 24),
        BackgroundTransparency = 1,
        Parent = TitleBar
    })
    
    self.MinimizeButton = Create("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.25, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094678",
        ImageColor3 = Color3.fromRGB(180, 80, 255),
        Parent = Controls
    })
    
    self.CloseButton = Create("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.75, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094667",
        ImageColor3 = Color3.fromRGB(180, 80, 255),
        Parent = Controls
    })
    
    self.TabScroller = Create("ScrollingFrame", {
        Size = UDim2.new(0, 120, 1, -100),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(120, 50, 200),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Window
    })
    
    self.TabContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.TabScroller
    })
    
    local TabLayout = Create("UIListLayout", {
        Parent = self.TabContainer,
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    self.ContentContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -140, 1, -110),
        Position = UDim2.new(0, 130, 0, 90),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(120, 50, 200),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Window
    })
    
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = self.ContentContainer
    })
    
    local ContentLayout = Create("UIListLayout", {
        Parent = self.ContentContainer,
        Padding = UDim.new(0, 12)
    })
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabScroller.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    self.UserPanel = Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10),
        Size = UDim2.new(0, 200, 0, 30),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.3,
        Parent = self.Window
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.UserPanel})
    
    self.DisplayName = Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0.8, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = LocalPlayer.Name,
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.UserPanel
    })
    
    self.NotificationContainer = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 10),
        Size = UDim2.new(0, 300, 0, 0),
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self.Config.CloseCallback()
        Tween(self.Window, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    local minimized = false
    self.MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(self.Window, {Size = UDim2.new(0, 600, 0, 90)}, 0.3)
            self.ContentContainer.Visible = false
            self.TabScroller.Visible = false
        else
            Tween(self.Window, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
            self.ContentContainer.Visible = true
            self.TabScroller.Visible = true
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)
    
    return self
end

function VxzToLib:MakeTab(options)
    local TabButton = Create("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        Parent = self.TabContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabButton})
    
    local TabContent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local TabLayout = Create("UIListLayout", {
        Parent = TabContent,
        Padding = UDim.new(0, 12)
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
        end
        TabContent.Visible = true
        Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(80, 40, 120)}, 0.2)
    end)
    
    TabButton.MouseEnter:Connect(function()
        if not TabContent.Visible then
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}, 0.2)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not TabContent.Visible then
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
        end
    end)
    
    local tabObj = {
        Button = TabButton,
        Content = TabContent,
        AddSection = function(_, options)
            return VxzToLib.AddSection(TabContent, options)
        end
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        TabContent.Visible = true
        Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(80, 40, 120)}, 0.2)
    end
    
    return tabObj
end

function VxzToLib.AddSection(parent, options)
    local SectionFrame = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local SectionHeader = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0.8, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionHeader
    })
    
    Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.fromRGB(100, 50, 150),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = SectionHeader
    })
    
    local SectionContent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local SectionLayout = Create("UIListLayout", {
        Parent = SectionContent,
        Padding = UDim.new(0, 10)
    })
    
    SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
        SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 35)
    end)
    
    local sectionObj = {
        Frame = SectionFrame,
        Content = SectionContent,
        AddButton = function(_, buttonOptions)
            return VxzToLib.AddButton(SectionContent, buttonOptions)
        end,
        AddToggle = function(_, toggleOptions)
            return VxzToLib.AddToggle(SectionContent, toggleOptions)
        end
    }
    
    return sectionObj
end

function VxzToLib.AddButton(parent, options)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(50, 50, 55),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(220, 180, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        Parent = parent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Button})
    
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(65, 65, 70)}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        if options.Callback then 
            Tween(Button, {BackgroundColor3 = Color3.fromRGB(100, 50, 180)}, 0.1)
            wait(0.1)
            Tween(Button, {BackgroundColor3 = Color3.fromRGB(65, 65, 70)}, 0.1)
            options.Callback() 
        end
    end)
    
    return Button
end

function VxzToLib.AddToggle(parent, options)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0.7, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(220, 180, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })
    
    local ToggleButton = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 26),
        BackgroundColor3 = options.Default and Color3.fromRGB(100, 50, 180) or Color3.fromRGB(50, 50, 55),
        BorderSizePixel = 0,
        Text = "",
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    
    local ToggleCircle = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(options.Default and 0.75 or 0.25, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(240, 200, 255),
        BorderSizePixel = 0,
        Parent = ToggleButton
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleCircle})
    
    ToggleButton.MouseEnter:Connect(function()
        Tween(ToggleButton, {BackgroundColor3 = options.Default and Color3.fromRGB(120, 70, 200) or Color3.fromRGB(65, 65, 70)}, 0.2)
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        Tween(ToggleButton, {BackgroundColor3 = options.Default and Color3.fromRGB(100, 50, 180) or Color3.fromRGB(50, 50, 55)}, 0.2)
    end)
    
    local toggleObj = {
        Value = options.Default or false,
        Set = function(self, value)
            self.Value = value
            Tween(ToggleButton, {
                BackgroundColor3 = value and Color3.fromRGB(100, 50, 180) or Color3.fromRGB(50, 50, 55)
            }, 0.2)
            
            Tween(ToggleCircle, {
                Position = UDim2.new(value and 0.75 or 0.25, 0, 0.5, 0)
            }, 0.2)
            
            if options.Callback then options.Callback(value) end
        end
    }
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggleObj:Set(not toggleObj.Value)
    end)
    
    if options.Flag then VxzToLib.Flags[options.Flag] = toggleObj end
    
    return toggleObj
end

function VxzToLib:MakeNotification(options)
    local Notification = Create("Frame", {
        Size = UDim2.new(0, 280, 0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 999,
        Parent = self.NotificationContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notification})
    
    Create("UIStroke", {
        Parent = Notification,
        Color = Color3.fromRGB(150, 80, 220),
        Thickness = 1,
        Transparency = 0.3
    })
    
    Create("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = options.Image or "rbxassetid://6031094678",
        ImageColor3 = Color3.fromRGB(180, 100, 255),
        Parent = Notification
    })
    
    local TitleLabel = Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 35, 0, 8),
        Size = UDim2.new(1, -45, 0, 20),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(220, 180, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local ContentLabel = Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Text = options.Content,
        TextColor3 = Color3.fromRGB(200, 170, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local textHeight = math.ceil(#options.Content / 45) * 14
    Notification.Size = UDim2.new(0, 280, 0, 40 + textHeight)
    ContentLabel.Size = UDim2.new(1, -20, 0, textHeight)
    
    Notification.Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)
    Notification.AnchorPoint = Vector2.new(0.5, 0)
    Tween(Notification, {Position = UDim2.new(0.5, 0, 0, 10)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    spawn(function()
        wait(options.Time or 3)
        Tween(Notification, {Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)}, 0.5)
        wait(0.5)
        Notification:Destroy()
    end)
    
    return Notification
end

function VxzToLib:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

return VxzToLib