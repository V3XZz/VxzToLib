local VxzToLib = {Flags = {}, Tabs = {}, Config = {}, Theme = {}}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

VxzToLib.Theme = {
    BackgroundColor = Color3.fromRGB(45, 45, 50),
    BorderColor = Color3.fromRGB(150, 80, 220),
    BorderThickness = 2,
    TextColor = Color3.fromRGB(220, 220, 220),
    AccentColor = Color3.fromRGB(180, 80, 255),
    ButtonColor = Color3.fromRGB(55, 55, 60),
    ButtonHoverColor = Color3.fromRGB(65, 65, 70),
    ButtonClickColor = Color3.fromRGB(100, 50, 180),
    TabColor = Color3.fromRGB(50, 50, 55),
    TabSelectedColor = Color3.fromRGB(80, 40, 120),
    ToggleOnColor = Color3.fromRGB(100, 50, 180),
    ToggleOffColor = Color3.fromRGB(65, 65, 70),
    TitleBarColor = Color3.fromRGB(50, 50, 55),
    SectionColor = Color3.fromRGB(100, 50, 150),
    NotificationColor = Color3.fromRGB(45, 45, 50),
    Font = Enum.Font.GothamMedium
}

local function Tween(instance, props, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quint), props)
    tween:Play()
    return tween
end

local function Create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        instance[prop] = value
    end
    return instance
end

function VxzToLib:MakeWindow(options)
    if self.ScreenGui then self.ScreenGui:Destroy() end
    
    self.Config = {
        Name = options.Name or "VxzTo Library",
        CloseCallback = options.CloseCallback or function() end
    }
    
    self.ScreenGui = Create("ScreenGui", {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    self.Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 600, 0, 400),
        BackgroundColor3 = self.Theme.BackgroundColor,
        Parent = self.ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = self.Window})
    
    local Border = Create("Frame", {
        Size = UDim2.new(1, self.Theme.BorderThickness*2, 1, self.Theme.BorderThickness*2),
        Position = UDim2.new(0, -self.Theme.BorderThickness, 0, -self.Theme.BorderThickness),
        BackgroundColor3 = self.Theme.BorderColor,
        BackgroundTransparency = 0.1,
        ZIndex = 0,
        Parent = self.Window
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = Border})
    
    local TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = self.Theme.TitleBarColor,
        Parent = self.Window
    })
    
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
    
    self.MinimizeButton = Create("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.25, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094667",
        ImageColor3 = self.Theme.AccentColor,
        Parent = Controls
    })
    
    self.CloseButton = Create("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.75, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094670",
        ImageColor3 = self.Theme.AccentColor,
        Parent = Controls
    })
    
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
    
    local TabLayout = Create("UIListLayout", {
        Parent = self.TabContainer,
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabScroller.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    self.ContentContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -140, 1, -110),
        Position = UDim2.new(0, 130, 0, 90),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.BorderColor,
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
    
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif input.UserInputType == Enum.UserInputType.None then
            dragging = false
        end
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self.Config.CloseCallback()
        Tween(self.Window, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    local minimized = false
    self.MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(self.Window, {Size = UDim2.new(0, 600, 0, 36)}, 0.3)
            self.TabScroller.Visible = false
            self.ContentContainer.Visible = false
        else
            Tween(self.Window, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
            self.TabScroller.Visible = true
            self.ContentContainer.Visible = true
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
        BackgroundColor3 = self.Theme.TabColor,
        Text = options.Name or "Tab",
        TextColor3 = self.Theme.TextColor,
        Font = self.Theme.Font,
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
            Tween(tab.Button, {BackgroundColor3 = self.Theme.TabColor}, 0.2)
        end
        TabContent.Visible = true
        Tween(TabButton, {BackgroundColor3 = self.Theme.TabSelectedColor}, 0.2)
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
        TabContent.Visible = true
        Tween(TabButton, {BackgroundColor3 = self.Theme.TabSelectedColor}, 0.2)
    end
    
    return tabObj
end

function VxzToLib.AddSection(parent, options)
    local SectionFrame = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = options.Name or "Section",
        TextColor3 = VxzToLib.Theme.AccentColor,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionFrame
    })
    
    Create("Frame", {
        Position = UDim2.new(0, 0, 0, 26),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = VxzToLib.Theme.SectionColor,
        BackgroundTransparency = 0.3,
        Parent = SectionFrame
    })
    
    local SectionContent = Create("Frame", {
        Position = UDim2.new(0, 0, 0, 32),
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
        SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 38)
    end)
    
    return {
        Frame = SectionFrame,
        Content = SectionContent,
        AddButton = function(_, buttonOptions)
            return VxzToLib.AddButton(SectionContent, buttonOptions)
        end,
        AddToggle = function(_, toggleOptions)
            return VxzToLib.AddToggle(SectionContent, toggleOptions)
        end
    }
end

function VxzToLib.AddButton(parent, options)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, -5, 0, 36),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = VxzToLib.Theme.ButtonColor,
        Text = options.Name or "Button",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = VxzToLib.Theme.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Button})
    
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonHoverColor}, 0.2)
        Button.Text = "> " .. (options.Name or "Button")
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonColor}, 0.2)
        Button.Text = options.Name or "Button"
    end)
    
    Button.MouseButton1Click:Connect(function()
        if options.Callback then 
            Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonClickColor}, 0.1)
            task.wait(0.1)
            Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonHoverColor}, 0.1)
            options.Callback() 
        end
    end)
    
    return Button
end

function VxzToLib.AddToggle(parent, options)
    local ToggleFrame = Create("TextButton", {
        Size = UDim2.new(1, -5, 0, 36),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = VxzToLib.Theme.ButtonColor,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleFrame})
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0.7, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = options.Name or "Toggle",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = VxzToLib.Theme.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })
    
    local ToggleButton = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 26),
        BackgroundColor3 = options.Default and VxzToLib.Theme.ToggleOnColor or VxzToLib.Theme.ToggleOffColor,
        Text = "",
        AutoButtonColor = false,
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    
    local ToggleCircle = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(options.Default and 0.75 or 0.25, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(240, 200, 255),
        Parent = ToggleButton
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleCircle})
    
    local toggleObj = {
        Value = options.Default or false,
        Set = function(self, value)
            self.Value = value
            Tween(ToggleButton, {BackgroundColor3 = value and VxzToLib.Theme.ToggleOnColor or VxzToLib.Theme.ToggleOffColor}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(value and 0.75 or 0.25, 0, 0.5, 0)}, 0.2)
            if options.Callback then options.Callback(value) end
        end
    }
    
    ToggleButton.MouseButton1Click:Connect(function() toggleObj:Set(not toggleObj.Value) end)
    ToggleFrame.MouseButton1Click:Connect(function() toggleObj:Set(not toggleObj.Value) end)
    
    if options.Flag then VxzToLib.Flags[options.Flag] = toggleObj end
    
    return toggleObj
end

function VxzToLib:MakeNotification(options)
    local Notification = Create("Frame", {
        Size = UDim2.new(0, 280, 0, 0),
        BackgroundColor3 = VxzToLib.Theme.NotificationColor,
        LayoutOrder = 999,
        Parent = self.NotificationContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notification})
    Create("UIStroke", {Color = VxzToLib.Theme.BorderColor, Thickness = 2, Parent = Notification})
    
    Create("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = options.Image or "rbxassetid://6031094678",
        ImageColor3 = VxzToLib.Theme.AccentColor,
        Parent = Notification
    })
    
    Create("TextLabel", {
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
    ContentLabel.Size = UDim2.new(1, -20, 0, textHeight)
    
    Notification.Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)
    Tween(Notification, {Position = UDim2.new(0.5, 0, 0, 10)}, 0.5)
    
    spawn(function()
        task.wait(options.Time or 3)
        Tween(Notification, {Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)}, 0.5)
        task.wait(0.5)
        Notification:Destroy()
    end)
    
    return Notification
end

function VxzToLib:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

return VxzToLib