local VxzToLib = {Flags = {}, Tabs = {}, Config = {}, Theme = {}}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Theme with high-contrast colors
VxzToLib.Theme = {
    BackgroundColor = Color3.fromRGB(60, 60, 65),  -- Dark grey background
    BorderColor = Color3.fromRGB(180, 80, 255),    -- Vibrant purple border
    BorderThickness = 3,                           -- Thicker border for visibility
    TextColor = Color3.fromRGB(240, 240, 240),     -- Bright text for contrast
    AccentColor = Color3.fromRGB(200, 100, 255),   -- Brighter accent color
    ButtonColor = Color3.fromRGB(70, 70, 75),      -- Medium grey
    ButtonHoverColor = Color3.fromRGB(90, 90, 95), -- Light grey
    ButtonClickColor = Color3.fromRGB(130, 60, 230),-- Deep purple
    TabColor = Color3.fromRGB(65, 65, 70),         -- Tab grey
    TabSelectedColor = Color3.fromRGB(110, 60, 200),-- Selected tab purple
    ToggleOnColor = Color3.fromRGB(130, 60, 230),  -- Toggle on purple
    ToggleOffColor = Color3.fromRGB(90, 90, 95),   -- Toggle off grey
    TitleBarColor = Color3.fromRGB(65, 65, 70),    -- Title bar grey
    SectionColor = Color3.fromRGB(180, 80, 255),   -- Section accent purple
    NotificationColor = Color3.fromRGB(60, 60, 65),-- Notification grey
    Font = Enum.Font.GothamBold                    -- Bold font for readability
}

-- Helper functions
local function Tween(instance, props, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quint), props)
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

-- Create window
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
    
    -- Main window with thick purple border
    self.Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 600, 0, 400),
        BackgroundColor3 = self.Theme.BackgroundColor,
        Parent = self.ScreenGui
    })
    
    -- Rounded corners
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = self.Window})
    
    -- Vibrant purple border
    local Border = Create("Frame", {
        Size = UDim2.new(1, self.Theme.BorderThickness*2, 1, self.Theme.BorderThickness*2),
        Position = UDim2.new(0, -self.Theme.BorderThickness, 0, -self.Theme.BorderThickness),
        BackgroundColor3 = self.Theme.BorderColor,
        ZIndex = 0,
        Parent = self.Window
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Border})
    
    -- Add gradient for "shiny" effect
    local borderGradient = Create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 50, 230)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 230))
        }),
        Parent = Border
    })
    
    -- Title bar with purple accent
    local TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.TitleBarColor,
        Parent = self.Window
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TitleBar})
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 0),
        Size = UDim2.new(0.7, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = self.Config.Name,
        TextColor3 = self.Theme.TextColor,
        Font = self.Theme.Font,
        TextSize = 18,  -- Larger text for visibility
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Window controls
    local Controls = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 30),
        BackgroundTransparency = 1,
        Parent = TitleBar
    })
    
    self.MinimizeButton = Create("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.3, 0, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094667",  -- Dash icon
        ImageColor3 = self.Theme.AccentColor,
        Parent = Controls
    })
    
    self.CloseButton = Create("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.7, 0, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094670",  -- X icon
        ImageColor3 = self.Theme.AccentColor,
        Parent = Controls
    })
    
    -- Tab area
    self.TabScroller = Create("ScrollingFrame", {
        Size = UDim2.new(0, 130, 1, -100),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,  -- Thicker scrollbar
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
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabScroller.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    -- Content area
    self.ContentContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -160, 1, -120),
        Position = UDim2.new(0, 150, 0, 100),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,  -- Thicker scrollbar
        ScrollBarImageColor3 = self.Theme.BorderColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Window
    })
    
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = self.ContentContainer
    })
    
    local ContentLayout = Create("UIListLayout", {
        Parent = self.ContentContainer,
        Padding = UDim.new(0, 15)  -- More spacing
    })
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    -- Dragging functionality
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
        end
    end)
    
    -- Close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self.Config.CloseCallback()
        Tween(self.Window, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    -- Minimize button
    local minimized = false
    self.MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(self.Window, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
            self.TabScroller.Visible = false
            self.ContentContainer.Visible = false
        else
            Tween(self.Window, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
            self.TabScroller.Visible = true
            self.ContentContainer.Visible = true
        end
    end)
    
    -- Toggle UI with LeftShift
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)
    
    return self
end

-- Create tabs
function VxzToLib:MakeTab(options)
    local TabButton = Create("TextButton", {
        Size = UDim2.new(0.95, 0, 0, 45),  -- Larger tabs
        BackgroundColor3 = self.Theme.TabColor,
        Text = options.Name or "Tab",
        TextColor3 = self.Theme.TextColor,
        Font = self.Theme.Font,
        TextSize = 14,
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
        Padding = UDim.new(0, 15)  -- More spacing
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

-- Create sections
function VxzToLib.AddSection(parent, options)
    local SectionFrame = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    -- Section header with purple accent
    Create("TextLabel", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 28),  -- Taller header
        BackgroundTransparency = 1,
        Text = "  " .. (options.Name or "Section"),  -- Added space for visual separation
        TextColor3 = VxzToLib.Theme.AccentColor,
        Font = VxzToLib.Theme.Font,
        TextSize = 16,  -- Larger text
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionFrame
    })
    
    -- Purple separator
    Create("Frame", {
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 2),  -- Thicker separator
        BackgroundColor3 = VxzToLib.Theme.SectionColor,
        Parent = SectionFrame
    })
    
    local SectionContent = Create("Frame", {
        Position = UDim2.new(0, 0, 0, 38),  -- More space below separator
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local SectionLayout = Create("UIListLayout", {
        Parent = SectionContent,
        Padding = UDim.new(0, 12)  -- More spacing between controls
    })
    
    SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
        SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 42)
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

-- Create buttons
function VxzToLib.AddButton(parent, options)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, -10, 0, 40),  -- Wider with margin
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
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonHoverColor}, 0.2)
        Button.Text = "> " .. (options.Name or "Button")
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = VxzToLib.Theme.ButtonColor}, 0.2)
        Button.Text = options.Name or "Button"
    end)
    
    -- Click effects
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

-- Create toggles
function VxzToLib.AddToggle(parent, options)
    local ToggleFrame = Create("TextButton", {
        Size = UDim2.new(1, -10, 0, 40),  -- Wider with margin
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = VxzToLib.Theme.ButtonColor,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleFrame})
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 0),
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
        Size = UDim2.new(0, 55, 0, 28),  -- Larger toggle
        BackgroundColor3 = options.Default and VxzToLib.Theme.ToggleOnColor or VxzToLib.Theme.ToggleOffColor,
        Text = "",
        AutoButtonColor = false,
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    
    local ToggleCircle = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(options.Default and 0.75 or 0.25, 0, 0.5, 0),
        Size = UDim2.new(0, 22, 0, 22),  -- Larger circle
        BackgroundColor3 = Color3.fromRGB(250, 220, 255),  -- Brighter circle
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

-- Notification system
function VxzToLib:MakeNotification(options)
    local Notification = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 0),  -- Wider notifications
        BackgroundColor3 = VxzToLib.Theme.NotificationColor,
        Parent = self.ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Notification})
    
    -- Purple border for notifications
    Create("UIStroke", {
        Color = VxzToLib.Theme.BorderColor,
        Thickness = 3,  -- Thicker border
        Parent = Notification
    })
    
    Create("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 0),
        Size = UDim2.new(0, 25, 0, 25),  -- Larger icon
        BackgroundTransparency = 1,
        Image = options.Image or "rbxassetid://6031094678",
        ImageColor3 = VxzToLib.Theme.AccentColor,
        Parent = Notification
    })
    
    Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 45, 0, 10),
        Size = UDim2.new(1, -60, 0, 25),
        BackgroundTransparency = 1,
        Text = options.Name or "Notification",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = VxzToLib.Theme.Font,
        TextSize = 15,  -- Larger text
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local ContentLabel = Create("TextLabel", {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 15, 0, 40),
        Size = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = options.Content or "",
        TextColor3 = VxzToLib.Theme.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 13,  -- Larger text
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local textHeight = math.ceil(#(options.Content or "") / 40) * 16  -- More spacing
    Notification.Size = UDim2.new(0, 300, 0, 50 + textHeight)
    ContentLabel.Size = UDim2.new(1, -30, 0, textHeight)
    
    Notification.Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)
    Notification.AnchorPoint = Vector2.new(0.5, 0)
    Tween(Notification, {Position = UDim2.new(0.5, 0, 0, 15)}, 0.5)
    
    spawn(function()
        task.wait(options.Time or 4)  -- Longer display time
        Tween(Notification, {Position = UDim2.new(0.5, 0, 0, -Notification.AbsoluteSize.Y)}, 0.5)
        task.wait(0.5)
        Notification:Destroy()
    end)
    
    return Notification
end

-- Cleanup
function VxzToLib:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

return VxzToLib