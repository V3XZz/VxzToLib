-- VxzToLib - Modern Hacker UI Library
local VxzToLib = {Flags = {}, Tabs = {}, Config = {}, Theme = {}}

-- Safe service initialization
local function GetService(serviceName)
    local service = game:GetService(serviceName)
    if not service then
        warn("[VxzToLib] Service not found:", serviceName)
        return nil
    end
    return service
end

local TweenService = GetService("TweenService")
local UserInputService = GetService("UserInputService")
local Players = GetService("Players")
local RunService = GetService("RunService")
local CoreGui = GetService("CoreGui")

-- Fallback for service errors
if not TweenService then
    warn("[VxzToLib] TweenService not available - creating fallback")
    TweenService = {
        Create = function() 
            return { Play = function() end }
        end
    }
end

-- Default theme settings
VxzToLib.Theme = {
    BackgroundColor = Color3.fromRGB(40, 40, 45),
    BorderColor = Color3.fromRGB(150, 80, 220),
    BorderThickness = 2,
    TextColor = Color3.fromRGB(220, 180, 255),
    AccentColor = Color3.fromRGB(180, 80, 255),
    ButtonColor = Color3.fromRGB(50, 50, 55),
    ButtonHoverColor = Color3.fromRGB(65, 65, 70),
    ButtonClickColor = Color3.fromRGB(100, 50, 180),
    TabColor = Color3.fromRGB(45, 45, 50),
    TabSelectedColor = Color3.fromRGB(80, 40, 120),
    ToggleOnColor = Color3.fromRGB(100, 50, 180),
    ToggleOffColor = Color3.fromRGB(65, 65, 70),
    TitleBarColor = Color3.fromRGB(45, 45, 50),
    SectionColor = Color3.fromRGB(100, 50, 150),
    NotificationColor = Color3.fromRGB(40, 40, 45),
    Font = Enum.Font.GothamMedium
}

local function Tween(instance, props, duration, style, direction)
    if not instance or not props then return end
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local success, tween = pcall(function()
        return TweenService:Create(instance, tweenInfo, props)
    end)
    
    if success and tween then
        tween:Play()
        return tween
    else
        warn("[VxzToLib] Tween failed:", tween)
        return nil
    end
end

local function Create(class, props)
    if not class then return nil end
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then 
            if value then
                instance.Parent = value
            end
        else
            if instance[prop] ~= nil then
                instance[prop] = value
            else
                warn("[VxzToLib] Property not found:", prop, "in", class)
            end
        end
    end
    return instance
end

function VxzToLib:SetTheme(theme)
    for key, value in pairs(theme) do
        if self.Theme[key] ~= nil then
            self.Theme[key] = value
        end
    end
end

function VxzToLib:MakeWindow(options)
    -- Cleanup previous instances
    if self.ScreenGui and self.ScreenGui.Parent then
        self.ScreenGui:Destroy()
    end
    
    -- Apply custom theme if provided
    if options and options.Theme then
        self:SetTheme(options.Theme)
    end
    
    self.Config = {
        Name = options and options.Name or "VxzTo Library",
        HidePremium = options and options.HidePremium or false,
        SaveConfig = options and options.SaveConfig or false,
        ConfigFolder = options and options.ConfigFolder or "VxzToConfig",
        IntroEnabled = options and options.IntroEnabled or false,
        IntroText = options and options.IntroText or "Loading...",
        IntroIcon = options and options.IntroIcon or "rbxassetid://6031094678",
        Icon = options and options.Icon or "rbxassetid://6031094678",
        CloseCallback = options and options.CloseCallback or function() end
    }
    
    self.ScreenGui = Create("ScreenGui", {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui or game:GetService("CoreGui")
    })
    
    if not self.ScreenGui then
        warn("[VxzToLib] Failed to create ScreenGui")
        return nil
    end
    
    -- Handle intro safely
    if self.Config.IntroEnabled then
        local IntroIcon = Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.4, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Image = self.Config.IntroIcon,
            ImageColor3 = self.Theme.AccentColor,
            Parent = self.ScreenGui
        })
        
        local IntroText = Create("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.6, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = self.Config.IntroText,
            TextColor3 = self.Theme.AccentColor,
            Font = Enum.Font.GothamBold,
            TextSize = 24,
            Parent = self.ScreenGui
        })
        
        if IntroIcon and IntroText then
            Tween(IntroIcon, {Size = UDim2.new(0, 80, 0, 80), Rotation = 360}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.wait(0.3)
            Tween(IntroText, {Size = UDim2.new(0, 300, 0, 40)}, 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            
            task.wait(1.5)
            
            Tween(IntroIcon, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.3, 0)}, 0.5)
            Tween(IntroText, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.7, 0)}, 0.5)
            task.wait(0.5)
            if IntroIcon then IntroIcon:Destroy() end
            if IntroText then IntroText:Destroy() end
        end
    end
    
    self.Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 600, 0, 400),
        BackgroundColor3 = self.Theme.BackgroundColor,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    
    if not self.Window then
        warn("[VxzToLib] Failed to create main window")
        return nil
    end
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = self.Window})
    
    -- Main window border
    local Border = Create("Frame", {
        Size = UDim2.new(1, self.Theme.BorderThickness*2, 1, self.Theme.BorderThickness*2),
        Position = UDim2.new(0, -self.Theme.BorderThickness, 0, -self.Theme.BorderThickness),
        BackgroundColor3 = self.Theme.BorderColor,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = self.Window
    })
    
    if Border then
        Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = Border})
    end
    
    -- Title bar with border
    local TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = self.Theme.TitleBarColor,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    if TitleBar then
        Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TitleBar})
        
        Create("TextLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 15, 0.5, 0),
            Size = UDim2.new(0.7, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = self.Config.Name,
            TextColor3 = self.Theme.TextColor,
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
        
        if Controls then
            self.MinimizeButton = Create("ImageButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.25, 0, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6031094678",
                ImageColor3 = self.Theme.AccentColor,
                Parent = Controls
            })
            
            self.CloseButton = Create("ImageButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.75, 0, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6031094667",
                ImageColor3 = self.Theme.AccentColor,
                Parent = Controls
            })
        end
    end
    
    self.TabScroller = Create("ScrollingFrame", {
        Size = UDim2.new(0, 120, 1, -100),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.BorderColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Window
    })
    
    self.TabContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.TabScroller
    })
    
    local TabLayout
    if self.TabContainer then
        TabLayout = Create("UIListLayout", {
            Parent = self.TabContainer,
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
    end
    
    self.ContentContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -140, 1, -110),
        Position = UDim2.new(0, 130, 0, 90),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.BorderColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Window
    })
    
    if self.ContentContainer then
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
        
        if ContentLayout then
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if self.ContentContainer then
                    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                end
            end)
        end
    end
    
    if TabLayout then
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if self.TabScroller then
                self.TabScroller.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end
        end)
    end
    
    self.UserPanel = Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10),
        Size = UDim2.new(0, 200, 0, 30),
        BackgroundColor3 = self.Theme.TitleBarColor,
        BackgroundTransparency = 0.3,
        Parent = self.Window
    })
    
    if self.UserPanel then
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.UserPanel})
        
        self.DisplayName = Create("TextLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(0.8, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = Players.LocalPlayer and Players.LocalPlayer.Name or "Player",
            TextColor3 = self.Theme.TextColor,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.UserPanel
        })
    end
    
    self.NotificationContainer = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 10),
        Size = UDim2.new(0, 300, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    
    if self.NotificationContainer then
        Create("UIListLayout", {
            Parent = self.NotificationContainer,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    end
    
    -- Draggable window functionality
    if TitleBar then
        local dragging = false
        local dragStart, startPos
        
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
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                self.Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    -- Close button functionality
    if self.CloseButton then
        self.CloseButton.MouseButton1Click:Connect(function()
            self.Config.CloseCallback()
            Tween(self.Window, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            if self.ScreenGui then
                self.ScreenGui:Destroy()
            end
        end)
    end
    
    -- Minimize functionality
    if self.MinimizeButton then
        local minimized = false
        self.MinimizeButton.MouseButton1Click:Connect(function()
            minimized = not minimized
            if minimized then
                Tween(self.Window, {Size = UDim2.new(0, 600, 0, 90)}, 0.3)
                if self.ContentContainer then self.ContentContainer.Visible = false end
                if self.TabScroller then self.TabScroller.Visible = false end
            else
                Tween(self.Window, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
                if self.ContentContainer then self.ContentContainer.Visible = true end
                if self.TabScroller then self.TabScroller.Visible = true end
            end
        end)
    end
    
    -- Toggle with LeftShift
    if UserInputService then
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftShift then
                if self.ScreenGui then
                    self.ScreenGui.Enabled = not self.ScreenGui.Enabled
                end
            end
        end)
    end
    
    return self
end

function VxzToLib:MakeTab(options)
    if not self.TabContainer then return nil end
    
    local TabButton = Create("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 40),
        BackgroundColor3 = self.Theme.TabColor,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = options and options.Name or "Tab",
        TextColor3 = self.Theme.TextColor,
        Font = self.Theme.Font,
        TextSize = 13,
        Parent = self.TabContainer
    })
    
    if not TabButton then return nil end
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabButton})
    
    local TabContent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentContainer
    })
    
    if not TabContent then return nil end
    
    local TabLayout = Create("UIListLayout", {
        Parent = TabContent,
        Padding = UDim.new(0, 12)
    })
    
    if TabLayout then
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
    end
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            if tab.Content then
                tab.Content.Visible = false
            end
            if tab.Button then
                Tween(tab.Button, {BackgroundColor3 = self.Theme.TabColor}, 0.2)
            end
        end
        if TabContent then
            TabContent.Visible = true
        end
        Tween(TabButton, {BackgroundColor3 = self.Theme.TabSelectedColor}, 0.2)
    end)
    
    TabButton.MouseEnter:Connect(function()
        if not TabContent.Visible then
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(
                self.Theme.TabColor.R * 1.2,
                self.Theme.TabColor.G * 1.2,
                self.Theme.TabColor.B * 1.2
            )}, 0.2)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not TabContent.Visible then
            Tween(TabButton, {BackgroundColor3 = self.Theme.TabColor}, 0.2)
        end
    end)
    
    local tabObj = {
        Button = TabButton,
        Content = TabContent,
        AddSection = function(_, sectionOptions)
            return VxzToLib.AddSection(TabContent, sectionOptions)
        end
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        if TabContent then
            TabContent.Visible = true
        end
        Tween(TabButton, {BackgroundColor3 = self.Theme.TabSelectedColor}, 0.2)
    end
    
    return tabObj
end

function VxzToLib.AddSection(parent, options)
    if not parent then return nil end
    
    local SectionFrame = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    if not SectionFrame then return nil end
    
    local SectionHeader = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    if SectionHeader then
        Create("TextLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0.8, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = options and options.Name or "Section",
            TextColor3 = VxzToLib.Theme.AccentColor,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SectionHeader
        })
        
        Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = VxzToLib.Theme.SectionColor,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = SectionHeader
        })
    end
    
    local SectionContent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    if SectionContent then
        local SectionLayout = Create("UIListLayout", {
            Parent = SectionContent,
            Padding = UDim.new(0, 10)
        })
        
        if SectionLayout then
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 35)
            end)
        end
    end
    
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
    if not parent then return nil end
    
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = VxzToLib.Theme.ButtonColor,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = options and options.Name or "Button",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = VxzToLib.Theme.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent
    })
    
    if not Button then return nil end
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Button})
    
    -- Add hand cursor effect
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonHoverColor}, 0.2)
        Button.Text = "> " .. (options and options.Name or "Button")
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonColor}, 0.2)
        Button.Text = options and options.Name or "Button"
    end)
    
    Button.MouseButton1Click:Connect(function()
        if options and options.Callback then 
            Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonClickColor}, 0.1)
            task.wait(0.1)
            Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonHoverColor}, 0.1)
            options.Callback() 
        end
    end)
    
    return Button
end

function VxzToLib.AddToggle(parent, options)
    if not parent then return nil end
    
    local ToggleFrame = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = VxzToLib.Theme.ButtonColor,
        BackgroundTransparency = 0.5,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    if not ToggleFrame then return nil end
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleFrame})
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0.7, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = options and options.Name or "Toggle",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = VxzToLib.Theme.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })
    
    local ToggleButton = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 26),
        BackgroundColor3 = (options and options.Default) and VxzToLib.Theme.ToggleOnColor or VxzToLib.Theme.ToggleOffColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = ToggleFrame
    })
    
    if not ToggleButton then return nil end
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    
    local ToggleCircle = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((options and options.Default) and 0.75 or 0.25, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(240, 200, 255),
        BorderSizePixel = 0,
        Parent = ToggleButton
    })
    
    if ToggleCircle then
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleCircle})
    end
    
    -- Add hand cursor effect
    ToggleFrame.MouseEnter:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = VxzToLib.Theme.ButtonHoverColor}, 0.2)
        Tween(ToggleButton, {BackgroundColor3 = (options and options.Default) and 
            Color3.fromRGB(
                VxzToLib.Theme.ToggleOnColor.R * 1.2,
                VxzToLib.Theme.ToggleOnColor.G * 1.2,
                VxzToLib.Theme.ToggleOnColor.B * 1.2
            ) or 
            Color3.fromRGB(
                VxzToLib.Theme.ToggleOffColor.R * 1.2,
                VxzToLib.Theme.ToggleOffColor.G * 1.2,
                VxzToLib.Theme.ToggleOffColor.B * 1.2
            )
        }, 0.2)
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = VxzToLib.Theme.ButtonColor}, 0.2)
        Tween(ToggleButton, {BackgroundColor3 = (options and options.Default) and 
            VxzToLib.Theme.ToggleOnColor or VxzToLib.Theme.ToggleOffColor
        }, 0.2)
    end)
    
    local toggleObj = {
        Value = (options and options.Default) or false,
        Set = function(self, value)
            self.Value = value
            Tween(ToggleButton, {
                BackgroundColor3 = value and VxzToLib.Theme.ToggleOnColor or VxzToLib.Theme.ToggleOffColor
            }, 0.2)
            
            if ToggleCircle then
                Tween(ToggleCircle, {
                    Position = UDim2.new(value and 0.75 or 0.25, 0, 0.5, 0)
                }, 0.2)
            end
            
            if options and options.Callback then options.Callback(value) end
        end
    }
    
    -- Connect to the button events
    ToggleButton.MouseButton1Click:Connect(function()
        toggleObj:Set(not toggleObj.Value)
    end)
    
    ToggleFrame.MouseButton1Click:Connect(function()
        toggleObj:Set(not toggleObj.Value)
    end)
    
    if options and options.Flag then VxzToLib.Flags[options.Flag] = toggleObj end
    
    return toggleObj
end

function VxzToLib:MakeNotification(options)
    if not self.NotificationContainer then return nil end
    if not options then return nil end
    
    local Notification = Create("Frame", {
        Size = UDim2.new(0, 280, 0, 0),
        BackgroundColor3 = VxzToLib.Theme.NotificationColor,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = 999,
        Parent = self.NotificationContainer
    })
    
    if not Notification then return nil end
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notification})
    
    Create("UIStroke", {
        Parent = Notification,
        Color = VxzToLib.Theme.BorderColor,
        Thickness = VxzToLib.Theme.BorderThickness,
        Transparency = 0.3
    })
    
    Create("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = options.Image or "rbxassetid://6031094678",
        ImageColor3 = VxzToLib.Theme.AccentColor,
        Parent = Notification
    })
    
    local TitleLabel = Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 35, 0, 8),
        Size = UDim2.new(1, -45, 0, 20),
        BackgroundTransparency = 1,
        Text = options.Name or "Notification",
        TextColor3 = VxzToLib.Theme.TextColor,
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
        Text = options.Content or "",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local textHeight = math.ceil(#(options.Content or "") / 45) * 14
    Notification.Size = UDim2.new(0, 280, 0, 40 + textHeight)
    if ContentLabel then
        ContentLabel.Size = UDim2.new(1, -20, 0, textHeight)
    end
    
    Notification.Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)
    Notification.AnchorPoint = Vector2.new(0.5, 0)
    Tween(Notification, {Position = UDim2.new(0.5, 0, 0, 10)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    spawn(function()
        task.wait(options.Time or 3)
        Tween(Notification, {Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)}, 0.5)
        task.wait(0.5)
        Notification:Destroy()
    end)
    
    return Notification
end

function VxzToLib:Destroy()
    if self.ScreenGui and self.ScreenGui.Parent then
        self.ScreenGui:Destroy()
    end
    self.ScreenGui = nil
end

return VxzToLib