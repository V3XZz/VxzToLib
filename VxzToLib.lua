local VxzToLib = {Flags = {}, Tabs = {}, Config = {}}

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
        if prop == "Parent" then instance.Parent = value
        else instance[prop] = value end
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
    
    self.MinimizeButton = Create("TextButton", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "_",
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = Controls
    })
    
    self.CloseButton = Create("TextButton", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
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
    
    self.DisplayName = Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "Player",
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
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
    end)
    
    return self
end

function VxzToLib:MakeTab(options)
    local TabButton = Create("TextButton", {
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = self.TabContainer
    })
    
    local TabContent = Create("Frame", {
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
        AddSection = function(_, options)
            return VxzToLib.AddSection(TabContent, options)
        end,
        AddButton = function(_, options)
            return VxzToLib.AddButton(TabContent, options)
        end,
        AddToggle = function(_, options)
            return VxzToLib.AddToggle(TabContent, options)
        end,
        AddSlider = function(_, options)
            return VxzToLib.AddSlider(TabContent, options)
        end,
        AddLabel = function(_, text)
            return VxzToLib.AddLabel(TabContent, text)
        end,
        AddParagraph = function(_, title, content)
            return VxzToLib.AddParagraph(TabContent, title, content)
        end,
        AddTextbox = function(_, options)
            return VxzToLib.AddTextbox(TabContent, options)
        end,
        AddBind = function(_, options)
            return VxzToLib.AddBind(TabContent, options)
        end,
        AddDropdown = function(_, options)
            return VxzToLib.AddDropdown(TabContent, options)
        end,
        AddColorpicker = function(_, options)
            return VxzToLib.AddColorpicker(TabContent, options)
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

function VxzToLib.AddSection(parent, options)
    local SectionFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
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
        AddButton = function(_, buttonOptions)
            return VxzToLib.AddButton(SectionContent, buttonOptions)
        end,
        AddToggle = function(_, toggleOptions)
            return VxzToLib.AddToggle(SectionContent, toggleOptions)
        end,
        AddSlider = function(_, sliderOptions)
            return VxzToLib.AddSlider(SectionContent, sliderOptions)
        end,
        AddLabel = function(_, text)
            return VxzToLib.AddLabel(SectionContent, text)
        end,
        AddParagraph = function(_, title, content)
            return VxzToLib.AddParagraph(SectionContent, title, content)
        end,
        AddTextbox = function(_, textboxOptions)
            return VxzToLib.AddTextbox(SectionContent, textboxOptions)
        end,
        AddBind = function(_, bindOptions)
            return VxzToLib.AddBind(SectionContent, bindOptions)
        end,
        AddDropdown = function(_, dropdownOptions)
            return VxzToLib.AddDropdown(SectionContent, dropdownOptions)
        end,
        AddColorpicker = function(_, colorpickerOptions)
            return VxzToLib.AddColorpicker(SectionContent, colorpickerOptions)
        end
    }
    
    return sectionObj
end

function VxzToLib.AddButton(parent, options)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = parent
    })
    
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(60, 30, 90)}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 20, 60)}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        if options.Callback then options.Callback() end
    end)
    
    return Button
end

function VxzToLib.AddToggle(parent, options)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
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
            
            if options.Callback then options.Callback(value) end
        end
    }
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggleObj:Set(not toggleObj.Value)
    end)
    
    if options.Flag then VxzToLib.Flags[options.Flag] = toggleObj end
    
    return toggleObj
end

function VxzToLib.AddSlider(parent, options)
    local SliderFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SliderFrame
    })
    
    local ValueLabel = Create("TextLabel", {
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(options.Default),
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = SliderFrame
    })
    
    local SliderTrack = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Parent = SliderFrame
    })
    
    local SliderFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(180, 80, 255),
        BorderSizePixel = 0,
        Parent = SliderTrack
    })
    
    local SliderButton = Create("TextButton", {
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0, 0, 0.5, -7.5),
        BackgroundColor3 = Color3.fromRGB(220, 150, 255),
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 2,
        Parent = SliderTrack
    })
    
    local min = options.Min or 0
    local max = options.Max or 100
    local default = math.clamp(options.Default or 50, min, max)
    local increment = options.Increment or 1
    local valueName = options.ValueName or ""
    
    local function setValue(value)
        local clamped = math.clamp(value, min, max)
        local percentage = (clamped - min) / (max - min)
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -7.5, 0.5, -7.5)
        ValueLabel.Text = tostring(clamped) .. (valueName ~= "" and " " .. valueName or "")
        
        if options.Callback then options.Callback(clamped) end
    end
    
    local sliderObj = {
        Value = default,
        Set = function(self, value) self.Value = value setValue(value) end
    }
    
    setValue(default)
    
    local dragging = false
    SliderButton.MouseButton1Down:Connect(function() dragging = true end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local sliderPos = SliderTrack.AbsolutePosition
            local sliderSize = SliderTrack.AbsoluteSize.X
            local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize)
            local percentage = relativeX / sliderSize
            local value = min + (max - min) * percentage
            value = math.floor(value / increment + 0.5) * increment
            
            sliderObj.Value = value
            setValue(value)
        end
    end)
    
    if options.Flag then VxzToLib.Flags[options.Flag] = sliderObj end
    
    return sliderObj
end

function VxzToLib.AddLabel(parent, text)
    local Label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent
    })
    
    local labelObj = {
        Set = function(self, newText) Label.Text = newText end
    }
    
    return labelObj
end

function VxzToLib.AddParagraph(parent, title, content)
    local ParagraphFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local TitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ParagraphFrame
    })
    
    local ContentLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ParagraphFrame
    })
    
    local paragraphObj = {
        Set = function(self, newTitle, newContent)
            TitleLabel.Text = newTitle
            ContentLabel.Text = newContent
        end
    }
    
    return paragraphObj
end

function VxzToLib.AddTextbox(parent, options)
    local TextboxFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TextboxFrame
    })
    
    local Textbox = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = options.Default or "",
        TextColor3 = Color3.fromRGB(200, 150, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = TextboxFrame
    })
    
    Textbox.FocusLost:Connect(function()
        if options.TextDisappear then Textbox.Text = "" end
        if options.Callback then options.Callback(Textbox.Text) end
    end)
    
    return Textbox
end

function VxzToLib.AddBind(parent, options)
    local BindFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = BindFrame
    })
    
    local BindButton = Create("TextButton", {
        Size = UDim2.new(0.3, 0, 1, -10),
        Position = UDim2.new(0.7, 0, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = tostring(options.Default.Name),
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = BindFrame
    })
    
    local bindObj = {
        Value = options.Default,
        Set = function(self, value)
            self.Value = value
            BindButton.Text = tostring(value.Name)
        end
    }
    
    BindButton.MouseButton1Click:Connect(function()
        BindButton.Text = "..."
        local input = game:GetService("UserInputService").InputBegan:Wait()
        if input.UserInputType == Enum.UserInputType.Keyboard then
            bindObj:Set(input.KeyCode)
            if options.Callback then options.Callback(input.KeyCode) end
        end
    end)
    
    if options.Flag then VxzToLib.Flags[options.Flag] = bindObj end
    
    return bindObj
end

function VxzToLib.AddDropdown(parent, options)
    local DropdownFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name,
        TextColor3 = Color3.fromRGB(200, 120, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DropdownFrame
    })
    
    local DropdownButton = Create("TextButton", {
        Size = UDim2.new(0.3, 0, 1, -10),
        Position = UDim2.new(0.7, 0, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 20, 60),
        BorderSizePixel = 0,
        Text = options.Default or "Select",
        TextColor3 = Color3.fromRGB(180, 80, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = DropdownFrame
    })
    
    local DropdownList = Create("Frame", {
        Size = UDim2.new(0.3, 0, 0, 0),
        Position = UDim2.new(0.7, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(30, 15, 45),
        BorderSizePixel = 0,
        Visible = false,
        Parent = DropdownFrame
    })
    
    Create("UIListLayout", {
        Parent = DropdownList,
        Padding = UDim.new(0, 2)
    })
    
    local dropdownObj = {
        Value = options.Default,
        Options = options.Options or {},
        Refresh = function(self, newOptions, clear)
            if clear then
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
            end
            
            self.Options = newOptions or self.Options
            
            for _, option in ipairs(self.Options) do
                local OptionButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(40, 20, 60),
                    BorderSizePixel = 0,
                    Text = option,
                    TextColor3 = Color3.fromRGB(180, 80, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = DropdownList
                })
                
                OptionButton.MouseButton1Click:Connect(function()
                    dropdownObj.Value = option
                    DropdownButton.Text = option
                    DropdownList.Visible = false
                    if options.Callback then options.Callback(option) end
                end)
            end
        end,
        Set = function(self, value)
            self.Value = value
            DropdownButton.Text = value
            if options.Callback then options.Callback(value) end
        end
    }
    
    dropdownObj:Refresh(options.Options, false)
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
        DropdownList.Size = UDim2.new(0.3, 0, 0, #dropdownObj.Options * 27)
    end)
    
    if options.Flag then VxzToLib.Flags[options.Flag] = dropdownObj end
    
    return dropdownObj
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
        Image = options.Image or "rbxassetid://6031094678",
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
    
    local ContentLabel = Create("TextLabel", {
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
    
    local textHeight = math.ceil(#options.Content / 30) * 15
    Notification.Size = UDim2.new(1, 0, 0, 50 + textHeight)
    ContentLabel.Size = UDim2.new(1, -10, 0, textHeight)
    
    Notification.Position = UDim2.new(0.5, -150, 0, -Notification.AbsoluteSize.Y)
    Tween(Notification, {Position = UDim2.new(0.5, -150, 0, 10)}, 0.5)
    
    spawn(function()
        wait(options.Time or 5)
        Tween(Notification, {Position = UDim2.new(0.5, -150, 0, -Notification.AbsoluteSize.Y)}, 0.5)
        wait(0.5)
        Notification:Destroy()
    end)
    
    return Notification
end

function VxzToLib:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

return VxzToLib