local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Wait for Character to load
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
if not HumanoidRootPart then
    warn("Failed to find HumanoidRootPart. GUI may not function correctly.")
    return
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CarnalityGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 10)
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not ScreenGui.Parent then
    warn("Failed to parent ScreenGui to PlayerGui. Aborting.")
    return
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 8)
MainFrameCorner.Parent = MainFrame

-- Title Bar (Golden Look)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Text = "Carnality GUI | V0.5 (Early Access)" -- Updated to Early Access
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

-- Toggle Button (Golden Look)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -70, 0, 5)
ToggleButton.Text = "X"
ToggleButton.BackgroundColor3 = Color3.fromRGB(218, 165, 32) -- Darker Gold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.ZIndex = 3
ToggleButton.Parent = TitleBar

local ToggleButtonCorner = Instance.new("UICorner")
ToggleButtonCorner.CornerRadius = UDim.new(0, 4)
ToggleButtonCorner.Parent = ToggleButton

-- Category Frame (Left Side)
local CategoryFrame = Instance.new("Frame")
CategoryFrame.Size = UDim2.new(0, 150, 1, -50)
CategoryFrame.Position = UDim2.new(0, 10, 0, 50)
CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CategoryFrame.BorderSizePixel = 0
CategoryFrame.ZIndex = 2
CategoryFrame.Parent = MainFrame

local CategoryFrameCorner = Instance.new("UICorner")
CategoryFrameCorner.CornerRadius = UDim.new(0, 4)
CategoryFrameCorner.Parent = CategoryFrame

-- Content Frame (Right Side)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 330, 1, -50)
ContentFrame.Position = UDim2.new(0, 160, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.Visible = false
ContentFrame.ZIndex = 2
ContentFrame.Parent = MainFrame

local ContentFrameCorner = Instance.new("UICorner")
ContentFrameCorner.CornerRadius = UDim.new(0, 4)
ContentFrameCorner.Parent = ContentFrame

-- Floating Toggle Button (Golden Look)
local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0, 10, 0, 10)
FloatingButton.Text = "⚜️"
FloatingButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextScaled = true
FloatingButton.Visible = false
FloatingButton.ZIndex = 1
FloatingButton.Parent = ScreenGui

local FloatingButtonCorner = Instance.new("UICorner")
FloatingButtonCorner.CornerRadius = UDim.new(1, 0)
FloatingButtonCorner.Parent = FloatingButton

-- Function to clear ContentFrame
local function clearContentFrame()
    local success, err = pcall(function()
        for _, child in pairs(ContentFrame:GetChildren()) do
            child:Destroy()
        end
    end)
    if not success then
        warn("Failed to clear ContentFrame: " .. tostring(err))
        ContentFrame.Visible = false
    end
end

-- Function to add a category button
local function addCategoryButton(text, posY, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 30)
    Button.Position = UDim2.new(0.05, 0, 0, posY)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.ZIndex = 3
    Button.Parent = CategoryFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = Button

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    local lastClick = 0
    Button.MouseButton1Click:Connect(function()
        local currentTime = tick()
        if currentTime - lastClick < 0.5 then return end
        lastClick = currentTime
        local success, err = pcall(function()
            clearContentFrame()
            callback()
        end)
        if not success then
            warn("Failed to load category '" .. text .. "': " .. tostring(err))
            ContentFrame.Visible = false
        end
    end)
end

-- Category: Credits
addCategoryButton("Credits", 10, function()
    ContentFrame.Visible = true

    local CreditsContent = Instance.new("Frame")
    CreditsContent.Size = UDim2.new(1, 0, 1, 0)
    CreditsContent.BackgroundTransparency = 1
    CreditsContent.ZIndex = 3
    CreditsContent.Parent = ContentFrame

    local CreditsText = Instance.new("TextLabel")
    CreditsText.Size = UDim2.new(0.9, 0, 0.8, 0)
    CreditsText.Position = UDim2.new(0.05, 0, 0.1, 0)
    CreditsText.Text = "scripter: C00lShIn3\nif you got this script from someone else other than our official discord server. please report the user."
    CreditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    CreditsText.BackgroundTransparency = 1
    CreditsText.TextScaled = true
    CreditsText.TextXAlignment = Enum.TextXAlignment.Left
    CreditsText.ZIndex = 4
    CreditsText.Parent = CreditsContent

    print("Credits category loaded.")
end)

-- Category: Code Executor
addCategoryButton("Code Executor", 50, function()
    ContentFrame.Visible = true

    local CodeContent = Instance.new("Frame")
    CodeContent.Size = UDim2.new(1, 0, 1, 0)
    CodeContent.BackgroundTransparency = 1
    CodeContent.ZIndex = 3
    CodeContent.Parent = ContentFrame

    local CodeTitle = Instance.new("TextLabel")
    CodeTitle.Size = UDim2.new(0.9, 0, 0, 30)
    CodeTitle.Position = UDim2.new(0.05, 0, 0, 10)
    CodeTitle.Text = "Code Executor"
    CodeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    CodeTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CodeTitle.TextScaled = true
    CodeTitle.ZIndex = 4
    CodeTitle.Parent = CodeContent

    local CodeTitleCorner = Instance.new("UICorner")
    CodeTitleCorner.CornerRadius = UDim.new(0, 4)
    CodeTitleCorner.Parent = CodeTitle

    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(0.9, 0, 0, 120)
    CodeBox.Position = UDim2.new(0.05, 0, 0, 50)
    CodeBox.Text = "Enter your code here..."
    CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    CodeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CodeBox.TextScaled = true
    CodeBox.TextWrapped = true
    CodeBox.ClearTextOnFocus = true
    CodeBox.MultiLine = true
    CodeBox.ZIndex = 4
    CodeBox.Parent = CodeContent

    local CodeBoxCorner = Instance.new("UICorner")
    CodeBoxCorner.CornerRadius = UDim.new(0, 4)
    CodeBoxCorner.Parent = CodeBox

    local ExecuteButton = Instance.new("TextButton")
    ExecuteButton.Size = UDim2.new(0.9, 0, 0, 30)
    ExecuteButton.Position = UDim2.new(0.05, 0, 0, 180)
    ExecuteButton.Text = "Execute"
    ExecuteButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecuteButton.TextScaled = true
    ExecuteButton.ZIndex = 4
    ExecuteButton.Parent = CodeContent

    local ExecuteButtonCorner = Instance.new("UICorner")
    ExecuteButtonCorner.CornerRadius = UDim.new(0, 4)
    ExecuteButtonCorner.Parent = ExecuteButton

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 220)
    StatusLabel.Text = "Status: Idle"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextScaled = true
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.ZIndex = 4
    StatusLabel.Parent = CodeContent

    local lastClick = 0
    ExecuteButton.MouseButton1Click:Connect(function()
        local currentTime = tick()
        if currentTime - lastClick < 0.5 then return end
        lastClick = currentTime
        local code = CodeBox.Text
        local success, result = pcall(function()
            local func, err = loadstring(code)
            if not func then
                error("Invalid code: " .. tostring(err))
            end
            func()
            StatusLabel.Text = "Status: Executed code!"
            print("Code executed successfully.")
        end)
        if not success then
            StatusLabel.Text = "Status: Error - " .. tostring(result)
            warn("Code execution failed: " .. tostring(result))
        end
    end)

    print("Code Executor category loaded.")
end)

-- Category: Hacks
addCategoryButton("Hacks", 90, function()
    ContentFrame.Visible = true

    local HacksContent = Instance.new("Frame")
    HacksContent.Size = UDim2.new(1, 0, 1, 0)
    HacksContent.BackgroundTransparency = 1
    HacksContent.ZIndex = 3
    HacksContent.Parent = ContentFrame

    local HacksTitle = Instance.new("TextLabel")
    HacksTitle.Size = UDim2.new(0.9, 0, 0, 30)
    HacksTitle.Position = UDim2.new(0.05, 0, 0, 10)
    HacksTitle.Text = "Hacks"
    HacksTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HacksTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    HacksTitle.TextScaled = true
    HacksTitle.ZIndex = 4
    HacksTitle.Parent = HacksContent

    local HacksTitleCorner = Instance.new("UICorner")
    HacksTitleCorner.CornerRadius = UDim.new(0, 4)
    HacksTitleCorner.Parent = HacksTitle

    -- Scrolling Frame for Hacks
    local HacksScroll = Instance.new("ScrollingFrame")
    HacksScroll.Size = UDim2.new(0.9, 0, 0, 230)
    HacksScroll.Position = UDim2.new(0.05, 0, 0, 50)
    HacksScroll.BackgroundTransparency = 1
    HacksScroll.ScrollBarThickness = 4
    HacksScroll.CanvasSize = UDim2.new(0, 0, 0, 450)
    HacksScroll.ZIndex = 4
    HacksScroll.Parent = HacksContent

    -- Function to add a hack button (Golden Look)
    local function addHackButton(text, posY, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.95, 0, 0, 30)
        Button.Position = UDim2.new(0.025, 0, 0, posY)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextScaled = true
        Button.ZIndex = 5
        Button.Parent = HacksScroll

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button

        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 223, 51) -- Lighter Gold
        end)
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        end)

        local lastClick = 0
        Button.MouseButton1Click:Connect(function()
            local currentTime = tick()
            if currentTime - lastClick < 0.5 then return end
            lastClick = currentTime
            local success, err = pcall(callback)
            if not success then
                warn("Hack '" .. text .. "' failed: " .. tostring(err))
            end
        end)
    end

    -- Hack 1: Speed Hack with Slider (Golden Look)
    local speedHackPosY = 0
    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Size = UDim2.new(0.95, 0, 0, 60)
    SpeedFrame.Position = UDim2.new(0.025, 0, 0, speedHackPosY)
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SpeedFrame.ZIndex = 5
    SpeedFrame.Parent = HacksScroll

    local SpeedFrameCorner = Instance.new("UICorner")
    SpeedFrameCorner.CornerRadius = UDim.new(0, 4)
    SpeedFrameCorner.Parent = SpeedFrame

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0.5, 0, 0, 20)
    SpeedLabel.Position = UDim2.new(0.05, 0, 0, 5)
    SpeedLabel.Text = "Speed: 16"
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextScaled = true
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedLabel.ZIndex = 6
    SpeedLabel.Parent = SpeedFrame

    local SpeedSlider = Instance.new("TextButton")
    SpeedSlider.Size = UDim2.new(0.9, 0, 0, 20)
    SpeedSlider.Position = UDim2.new(0.05, 0, 0, 30)
    SpeedSlider.Text = ""
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SpeedSlider.ZIndex = 6
    SpeedSlider.Parent = SpeedFrame

    local SpeedSliderCorner = Instance.new("UICorner")
    SpeedSliderCorner.CornerRadius = UDim.new(0, 4)
    SpeedSliderCorner.Parent = SpeedSlider

    local SpeedSliderFill = Instance.new("Frame")
    SpeedSliderFill.Size = UDim2.new(0, 0, 1, 0)
    SpeedSliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    SpeedSliderFill.BorderSizePixel = 0
    SpeedSliderFill.ZIndex = 7
    SpeedSliderFill.Parent = SpeedSlider

    local SpeedSliderFillCorner = Instance.new("UICorner")
    SpeedSliderFillCorner.CornerRadius = UDim.new(0, 4)
    SpeedSliderFillCorner.Parent = SpeedSliderFill

    local isDragging = false
    SpeedSlider.MouseButton1Down:Connect(function()
        isDragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    SpeedSlider.MouseMoved:Connect(function(x, y)
        if isDragging then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = SpeedSlider.AbsolutePosition
            local frameSize = SpeedSlider.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
            local speedValue = math.floor(16 + (relativeX * (100 - 16)))
            SpeedSliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SpeedLabel.Text = "Speed: " .. speedValue
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedValue
                print("Speed set to " .. speedValue .. ", Alpha! 🏃‍♂️")
            else
                warn("Speed Hack failed: Humanoid not found.")
            end
        end
    end)

    -- Hack 2: Infinite Jump
    local infiniteJumpEnabled = false
    local infiniteJumpConnection
    addHackButton("Infinite Jump", 65, function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
            infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                local humanoid = Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            print("Infinite Jump enabled, Alpha! 🐰")
        else
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
            print("Infinite Jump disabled, Alpha! 🐾")
        end
    end)

    -- Hack 3: Noclip
    local noclipEnabled = false
    local noclipConnection
    addHackButton("Noclip", 100, function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            if noclipConnection then noclipConnection:Disconnect() end
            noclipConnection = RunService.Stepped:Connect(function()
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            print("Noclip enabled, Alpha! 🚪")
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            print("Noclip disabled, Alpha! 🚧")
        end
    end)

    -- Hack 4: Kill Player
    local killPlayerPosY = 135
    local KillFrame = Instance.new("Frame")
    KillFrame.Size = UDim2.new(0.95, 0, 0, 60)
    KillFrame.Position = UDim2.new(0.025, 0, 0, killPlayerPosY)
    KillFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    KillFrame.ZIndex = 5
    KillFrame.Parent = HacksScroll

    local KillFrameCorner = Instance.new("UICorner")
    KillFrameCorner.CornerRadius = UDim.new(0, 4)
    KillFrameCorner.Parent = KillFrame

    local KillDropdown = Instance.new("TextBox")
    KillDropdown.Size = UDim2.new(0.9, 0, 0, 20)
    KillDropdown.Position = UDim2.new(0.05, 0, 0, 5)
    KillDropdown.Text = "Enter Player Name"
    KillDropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    KillDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    KillDropdown.TextScaled = true
    KillDropdown.ClearTextOnFocus = true
    KillDropdown.ZIndex = 6
    KillDropdown.Parent = KillFrame

    local KillDropdownCorner = Instance.new("UICorner")
    KillDropdownCorner.CornerRadius = UDim.new(0, 4)
    KillDropdownCorner.Parent = KillDropdown

    local KillButton = Instance.new("TextButton")
    KillButton.Size = UDim2.new(0.9, 0, 0, 20)
    KillButton.Position = UDim2.new(0.05, 0, 0, 35)
    KillButton.Text = "Kill Player"
    KillButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    KillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KillButton.TextScaled = true
    KillButton.ZIndex = 6
    KillButton.Parent = KillFrame

    local KillButtonCorner = Instance.new("UICorner")
    KillButtonCorner.CornerRadius = UDim.new(0, 4)
    KillButtonCorner.Parent = KillButton

    KillButton.MouseButton1Click:Connect(function()
        local targetName = KillDropdown.Text
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            target.Character.Humanoid.Health = 0
            print("Killed " .. target.Name .. ", Alpha! 💀")
        else
            warn("Kill Player failed: Target not found or invalid.")
        end
    end)

    -- Hack 5: Teleport to Player
    local tpPlayerPosY = 200
    local TPFrame = Instance.new("Frame")
    TPFrame.Size = UDim2.new(0.95, 0, 0, 60)
    TPFrame.Position = UDim2.new(0.025, 0, 0, tpPlayerPosY)
    TPFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TPFrame.ZIndex = 5
    TPFrame.Parent = HacksScroll

    local TPFrameCorner = Instance.new("UICorner")
    TPFrameCorner.CornerRadius = UDim.new(0, 4)
    TPFrameCorner.Parent = TPFrame

    local TPDropdown = Instance.new("TextBox")
    TPDropdown.Size = UDim2.new(0.9, 0, 0, 20)
    TPDropdown.Position = UDim2.new(0.05, 0, 0, 5)
    TPDropdown.Text = "Enter Player Name"
    TPDropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TPDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPDropdown.TextScaled = true
    TPDropdown.ClearTextOnFocus = true
    TPDropdown.ZIndex = 6
    TPDropdown.Parent = TPFrame

    local TPDropdownCorner = Instance.new("UICorner")
    TPDropdownCorner.CornerRadius = UDim.new(0, 4)
    TPDropdownCorner.Parent = TPDropdown

    local TPButton = Instance.new("TextButton")
    TPButton.Size = UDim2.new(0.9, 0, 0, 20)
    TPButton.Position = UDim2.new(0.05, 0, 0, 35)
    TPButton.Text = "Teleport"
    TPButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPButton.TextScaled = true
    TPButton.ZIndex = 6
    TPButton.Parent = TPFrame

    local TPButtonCorner = Instance.new("UICorner")
    TPButtonCorner.CornerRadius = UDim.new(0, 4)
    TPButtonCorner.Parent = TPButton

    TPButton.MouseButton1Click:Connect(function()
        local targetName = TPDropdown.Text
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            print("Teleported to " .. target.Name .. ", Alpha! 🌌")
        else
            warn("Teleport to Player failed: Target not found or invalid.")
        end
    end)

    -- Hack 6: God Mode
    local godModeEnabled = false
    addHackButton("God Mode", 265, function()
        godModeEnabled = not godModeEnabled
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = godModeEnabled and 1000000 or 100
            humanoid.Health = godModeEnabled and 1000000 or 100
            print(godModeEnabled and "God Mode enabled, Alpha! 🛡️" or "God Mode disabled, Alpha! ⚔️")
        else
            warn("God Mode failed: Humanoid not found.")
        end
    end)

    -- Hack 7: Invisibility
    local invisible = false
    addHackButton("Invisibility", 300, function()
        invisible = not invisible
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = invisible and 1 or 0
            end
        end
        print(invisible and "You’re a ghost, Alpha! 👻" or "Visible again, Alpha! 😎")
    end)

    -- Hack 8: Steal Tool
    addHackButton("Steal Tool", 335, function()
        local players = Players:GetPlayers()
        local target = players[math.random(2, #players)]
        if target and target.Character and target.Backpack then
            for _, tool in pairs(target.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Clone().Parent = LocalPlayer.Backpack
                    print("Stole " .. tool.Name .. " from " .. target.Name .. ", Alpha! 🕵️")
                    break
                end
            end
        else
            warn("Steal Tool failed: No valid target or tools found.")
        end
    end)

    -- Hack 9: Fly
    local flying = false
    local flyConnection
    addHackButton("Fly", 370, function()
        flying = not flying
        local humanoid = Character:FindFirstChild("Humanoid")
        local rootPart = HumanoidRootPart
        if flying and humanoid and rootPart then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart
            if flyConnection then flyConnection:Disconnect() end
            flyConnection = RunService.RenderStepped:Connect(function()
                if not flying then return end
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new(
                    (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                ).Unit * 50
                bv.Velocity = cam.CFrame:VectorToWorldSpace(moveDir)
                rootPart.CFrame = CFrame.new(rootPart.Position) * cam.CFrame.Rotation
            end)
            print("Flying high, Alpha! ✈️")
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if rootPart and rootPart:FindFirstChild("BodyVelocity") then
                rootPart:FindFirstChild("BodyVelocity"):Destroy()
            end
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
            print("Landed, Alpha! 🌍")
        end
    end)

    -- Hack 10: Aimbot
    local aimbotEnabled = false
    local aimbotConnection
    addHackButton("Aimbot", 405, function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            if aimbotConnection then aimbotConnection:Disconnect() end
            aimbotConnection = RunService.RenderStepped:Connect(function()
                local closestPlayer = nil
                local closestDistance = math.huge
                local cam = workspace.CurrentCamera
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = player.Character.HumanoidRootPart.Position
                        local screenPos, onScreen = cam:WorldToViewportPoint(targetPos)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
                end
            end)
            print("Aimbot enabled, Alpha! 🎯")
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
                aimbotConnection = nil
            end
            print("Aimbot disabled, Alpha! 🔫")
        end
    end)

    -- Hack 11: Auto Respawn
    local autoRespawnEnabled = false
    local autoRespawnConnection
    addHackButton("Auto Respawn", 440, function()
        autoRespawnEnabled = not autoRespawnEnabled
        if autoRespawnEnabled then
            if autoRespawnConnection then autoRespawnConnection:Disconnect() end
            autoRespawnConnection = LocalPlayer.Character:FindFirstChild("Humanoid").Died:Connect(function()
                if autoRespawnEnabled then
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").Respawn:FireServer()
                    print("Auto Respawn triggered, Alpha! 🔄")
                end
            end)
            print("Auto Respawn enabled, Alpha! 🔄")
        else
            if autoRespawnConnection then
                autoRespawnConnection:Disconnect()
                autoRespawnConnection = nil
            end
            print("Auto Respawn disabled, Alpha! 🛑")
        end
    end)

    print("Hacks category loaded.")
end)

-- Category: Visuals
addCategoryButton("Visuals", 130, function()
    ContentFrame.Visible = true

    local VisualsContent = Instance.new("Frame")
    VisualsContent.Size = UDim2.new(1, 0, 1, 0)
    VisualsContent.BackgroundTransparency = 1
    VisualsContent.ZIndex = 3
    VisualsContent.Parent = ContentFrame

    local VisualsTitle = Instance.new("TextLabel")
    VisualsTitle.Size = UDim2.new(0.9, 0, 0, 30)
    VisualsTitle.Position = UDim2.new(0.05, 0, 0, 10)
    VisualsTitle.Text = "Visuals"
    VisualsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisualsTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VisualsTitle.TextScaled = true
    VisualsTitle.ZIndex = 4
    VisualsTitle.Parent = VisualsContent

    local VisualsTitleCorner = Instance.new("UICorner")
    VisualsTitleCorner.CornerRadius = UDim.new(0, 4)
    VisualsTitleCorner.Parent = VisualsTitle

    -- Scrolling Frame for Visuals
    local VisualsScroll = Instance.new("ScrollingFrame")
    VisualsScroll.Size = UDim2.new(0.9, 0, 0, 230)
    VisualsScroll.Position = UDim2.new(0.05, 0, 0, 50)
    VisualsScroll.BackgroundTransparency = 1
    VisualsScroll.ScrollBarThickness = 4
    VisualsScroll.CanvasSize = UDim2.new(0, 0, 0, 150)
    VisualsScroll.ZIndex = 4
    VisualsScroll.Parent = VisualsContent

    -- Function to add a visuals button (Golden Look)
    local function addVisualsButton(text, posY, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.95, 0, 0, 30)
        Button.Position = UDim2.new(0.025, 0, 0, posY)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextScaled = true
        Button.ZIndex = 5
        Button.Parent = VisualsScroll

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button

        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 223, 51) -- Lighter Gold
        end)
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        end)

        local lastClick = 0
        Button.MouseButton1Click:Connect(function()
            local currentTime = tick()
            if currentTime - lastClick < 0.5 then return end
            lastClick = currentTime
            local success, err = pcall(callback)
            if not success then
                warn("Visual '" .. text .. "' failed: " .. tostring(err))
            end
        end)
    end

    -- Visual 1: ESP
    local espEnabled = false
    local espConnections = {}
    addVisualsButton("ESP", 0, function()
        espEnabled = not espEnabled
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Gold (changed from red)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                    espConnections[player] = highlight
                end
            end
            print("ESP activated, Alpha! 👀")
        else
            for _, connection in pairs(espConnections) do
                if connection then
                    connection:Destroy()
                end
            end
            espConnections = {}
            print("ESP deactivated, Alpha! 🕶️")
        end
    end)

    -- Visual 2: Chams
    local chamsEnabled = false
    local chamsConnections = {}
    addVisualsButton("Chams", 35, function()
        chamsEnabled = not chamsEnabled
        if chamsEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local glow = Instance.new("SurfaceGui")
                            glow.Parent = part
                            glow.Adornee = part
                            glow.Face = Enum.NormalId.Front
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold (changed from green)
                            frame.BackgroundTransparency = 0.5
                            frame.Parent = glow
                            chamsConnections[player] = glow
                        end
                    end
                end
            end
            print("Chams enabled, Alpha! 🌟")
        else
            for _, connection in pairs(chamsConnections) do
                if connection then
                    connection:Destroy()
                end
            end
            chamsConnections = {}
            print("Chams disabled, Alpha! 🌑")
        end
    end)

    -- Visual 3: Fullbright
    local fullbrightEnabled = false
    local lighting = game:GetService("Lighting")
    local originalBrightness = lighting.Brightness
    local originalFogEnd = lighting.FogEnd
    addVisualsButton("Fullbright", 70, function()
        fullbrightEnabled = not fullbrightEnabled
        if fullbrightEnabled then
            lighting.Brightness = 1
            lighting.FogEnd = 100000
            for _, light in pairs(lighting:GetChildren()) do
                if light:IsA("Atmosphere") then
                    light.Density = 0
                end
            end
            print("Fullbright enabled, Alpha! ☀️")
        else
            lighting.Brightness = originalBrightness
            lighting.FogEnd = originalFogEnd
            print("Fullbright disabled, Alpha! 🌙")
        end
    end)

    print("Visuals category loaded.")
end)

-- Category: Exploits
addCategoryButton("Exploits", 170, function()
    ContentFrame.Visible = true

    local ExploitsContent = Instance.new("Frame")
    ExploitsContent.Size = UDim2.new(1, 0, 1, 0)
    ExploitsContent.BackgroundTransparency = 1
    ExploitsContent.ZIndex = 3
    ExploitsContent.Parent = ContentFrame

    local ExploitsTitle = Instance.new("TextLabel")
    ExploitsTitle.Size = UDim2.new(0.9, 0, 0, 30)
    ExploitsTitle.Position = UDim2.new(0.05, 0, 0, 10)
    ExploitsTitle.Text = "Exploits"
    ExploitsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExploitsTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ExploitsTitle.TextScaled = true
    ExploitsTitle.ZIndex = 4
    ExploitsTitle.Parent = ExploitsContent

    local ExploitsTitleCorner = Instance.new("UICorner")
    ExploitsTitleCorner.CornerRadius = UDim.new(0, 4)
    ExploitsTitleCorner.Parent = ExploitsTitle

    -- Scrolling Frame for Exploits
    local ExploitsScroll = Instance.new("ScrollingFrame")
    ExploitsScroll.Size = UDim2.new(0.9, 0, 0, 230)
    ExploitsScroll.Position = UDim2.new(0.05, 0, 0, 50)
    ExploitsScroll.BackgroundTransparency = 1
    ExploitsScroll.ScrollBarThickness = 4
    ExploitsScroll.CanvasSize = UDim2.new(0, 0, 0, 150)
    ExploitsScroll.ZIndex = 4
    ExploitsScroll.Parent = ExploitsContent

    -- Function to add an exploit button (Golden Look)
    local function addExploitButton(text, posY, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.95, 0, 0, 30)
        Button.Position = UDim2.new(0.025, 0, 0, posY)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextScaled = true
        Button.ZIndex = 5
        Button.Parent = ExploitsScroll

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button

        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 223, 51) -- Lighter Gold
        end)
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        end)

        local lastClick = 0
        Button.MouseButton1Click:Connect(function()
            local currentTime = tick()
            if currentTime - lastClick < 0.5 then return end
            lastClick = currentTime
            local success, err = pcall(callback)
            if not success then
                warn("Exploit '" .. text .. "' failed: " .. tostring(err))
            end
        end)
    end

    -- Exploit 1: Server Crasher
    addExploitButton("Server Crasher", 0, function()
        warn("Server Crasher activated. Use with caution!")
        for i = 1, 1000 do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").SomeEvent:FireServer(string.rep("crash", 10000))
            end)
        end
        print("Server Crasher executed, Alpha! 💥")
    end)

    -- Exploit 2: Chat Spammer
    local chatSpamEnabled = false
    local chatSpamConnection
    local ChatFrame = Instance.new("Frame")
    ChatFrame.Size = UDim2.new(0.95, 0, 0, 60)
    ChatFrame.Position = UDim2.new(0.025, 0, 0, 35)
    ChatFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ChatFrame.ZIndex = 5
    ChatFrame.Parent = ExploitsScroll

    local ChatFrameCorner = Instance.new("UICorner")
    ChatFrameCorner.CornerRadius = UDim.new(0, 4)
    ChatFrameCorner.Parent = ChatFrame

    local ChatInput = Instance.new("TextBox")
    ChatInput.Size = UDim2.new(0.9, 0, 0, 20)
    ChatInput.Position = UDim2.new(0.05, 0, 0, 5)
    ChatInput.Text = "Enter Message to Spam"
    ChatInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ChatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    ChatInput.TextScaled = true
    ChatInput.ClearTextOnFocus = true
    ChatInput.ZIndex = 6
    ChatInput.Parent = ChatFrame

    local ChatInputCorner = Instance.new("UICorner")
    ChatInputCorner.CornerRadius = UDim.new(0, 4)
    ChatInputCorner.Parent = ChatInput

    local ChatSpamButton = Instance.new("TextButton")
    ChatSpamButton.Size = UDim2.new(0.9, 0, 0, 20)
    ChatSpamButton.Position = UDim2.new(0.05, 0, 0, 35)
    ChatSpamButton.Text = "Chat Spammer"
    ChatSpamButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    ChatSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ChatSpamButton.TextScaled = true
    ChatSpamButton.ZIndex = 6
    ChatSpamButton.Parent = ChatFrame

    local ChatSpamButtonCorner = Instance.new("UICorner")
    ChatSpamButtonCorner.CornerRadius = UDim.new(0, 4)
    ChatSpamButtonCorner.Parent = ChatSpamButton

    ChatSpamButton.MouseButton1Click:Connect(function()
        chatSpamEnabled = not chatSpamEnabled
        if chatSpamEnabled then
            if chatSpamConnection then chatSpamConnection:Disconnect() end
            chatSpamConnection = RunService.Heartbeat:Connect(function()
                if chatSpamEnabled then
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ChatInput.Text, "All")
                end
            end)
            print("Chat Spammer enabled, Alpha! 📢")
        else
            if chatSpamConnection then
                chatSpamConnection:Disconnect()
                chatSpamConnection = nil
            end
            print("Chat Spammer disabled, Alpha! 🤫")
        end
    end)

    print("Exploits category loaded.")
end)

-- Category: Fun
addCategoryButton("Fun", 210, function()
    ContentFrame.Visible = true

    local FunContent = Instance.new("Frame")
    FunContent.Size = UDim2.new(1, 0, 1, 0)
    FunContent.BackgroundTransparency = 1
    FunContent.ZIndex = 3
    FunContent.Parent = ContentFrame

    local FunTitle = Instance.new("TextLabel")
    FunTitle.Size = UDim2.new(0.9, 0, 0, 30)
    FunTitle.Position = UDim2.new(0.05, 0, 0, 10)
    FunTitle.Text = "Fun"
    FunTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    FunTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    FunTitle.TextScaled = true
    FunTitle.ZIndex = 4
    FunTitle.Parent = FunContent

    local FunTitleCorner = Instance.new("UICorner")
    FunTitleCorner.CornerRadius = UDim.new(0, 4)
    FunTitleCorner.Parent = FunTitle

    -- Scrolling Frame for Fun
    local FunScroll = Instance.new("ScrollingFrame")
    FunScroll.Size = UDim2.new(0.9, 0, 0, 230)
    FunScroll.Position = UDim2.new(0.05, 0, 0, 50)
    FunScroll.BackgroundTransparency = 1
    FunScroll.ScrollBarThickness = 4
    FunScroll.CanvasSize = UDim2.new(0, 0, 0, 150)
    FunScroll.ZIndex = 4
    FunScroll.Parent = FunContent

    -- Function to add a fun button (Golden Look)
    local function addFunButton(text, posY, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.95, 0, 0, 30)
        Button.Position = UDim2.new(0.025, 0, 0, posY)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextScaled = true
        Button.ZIndex = 5
        Button.Parent = FunScroll

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button

        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 223, 51) -- Lighter Gold
        end)
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
        end)

        local lastClick = 0
        Button.MouseButton1Click:Connect(function()
            local currentTime = tick()
            if currentTime - lastClick < 0.5 then return end
            lastClick = currentTime
            local success, err = pcall(callback)
            if not success then
                warn("Fun '" .. text .. "' failed: " .. tostring(err))
            end
        end)
    end

    -- Fun 1: Spin
    local spinning = false
    local spinConnection
    addFunButton("Spin", 0, function()
        spinning = not spinning
        if spinning then
            if spinConnection then spinConnection:Disconnect() end
            spinConnection = RunService.RenderStepped:Connect(function(delta)
                if spinning and HumanoidRootPart then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360 * delta * 2), 0)
                end
            end)
            print("Spinning enabled, Alpha! 🌀")
        else
            if spinConnection then
                spinConnection:Disconnect()
                spinConnection = nil
            end
            print("Spinning disabled, Alpha! 🛑")
        end
    end)

    -- Fun 2: Ragdoll
    addFunButton("Ragdoll", 35, function()
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            print("Ragdoll activated, Alpha! 🤸‍♂️")
        else
            warn("Ragdoll failed: Humanoid not found.")
        end
    end)

    -- Fun 3: Particle Effects
    local particlesEnabled = false
    local particleEmitter
    addFunButton("Particle Effects", 70, function()
        particlesEnabled = not particlesEnabled
        if particlesEnabled then
            if particleEmitter then particleEmitter:Destroy() end
            particleEmitter = Instance.new("ParticleEmitter")
            particleEmitter.Texture = "rbxassetid://243098098" -- Sparkles texture
            particleEmitter.Size = NumberSequence.new(1)
            particleEmitter.Rate = 50
            particleEmitter.Lifetime = NumberRange.new(1, 3)
            particleEmitter.Speed = NumberRange.new(5)
            particleEmitter.Parent = HumanoidRootPart
            print("Particle Effects enabled, Alpha! ✨")
        else
            if particleEmitter then
                particleEmitter:Destroy()
                particleEmitter = nil
            end
            print("Particle Effects disabled, Alpha! 🌫️")
        end
    end)

    print("Fun category loaded.")
end)

-- Toggle GUI Visibility
local guiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    FloatingButton.Visible = not guiVisible
    print(guiVisible and "GUI shown." or "GUI hidden.")
end)

FloatingButton.MouseButton1Click:Connect(function()
    guiVisible = true
    MainFrame.Visible = true
    FloatingButton.Visible = false
    print("GUI shown.")
end)

-- ESP and Chams Player Handling
Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Gold (changed from red)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = char
            espConnections[player] = highlight
        end)
    end
    if chamsEnabled and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    local glow = Instance.new("SurfaceGui")
                    glow.Parent = part
                    glow.Adornee = part
                    glow.Face = Enum.NormalId.Front
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold (changed from green)
                    frame.BackgroundTransparency = 0.5
                    frame.Parent = glow
                    chamsConnections[player] = glow
                end
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espConnections[player] then
        espConnections[player]:Destroy()
        espConnections[player] = nil
    end
    if chamsConnections[player] then
        chamsConnections[player]:Destroy()
        chamsConnections[player] = nil
    end
end)

-- Character Respawn Handling
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart", 10)
    if not HumanoidRootPart then
        warn("Failed to find HumanoidRootPart on respawn.")
        return
    end

    if invisible then
        for _, part in pairs(newChar:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end

    if noclipEnabled then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end

    if godModeEnabled then
        local humanoid = newChar:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 1000000
            humanoid.Health = 1000000
        end
    end

    if flying then
        local humanoid = newChar:FindFirstChild("Humanoid")
        local rootPart = HumanoidRootPart
        if humanoid and rootPart then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart
            if flyConnection then flyConnection:Disconnect() end
            flyConnection = RunService.RenderStepped:Connect(function()
                if not flying then return end
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new(
                    (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                ).Unit * 50
                bv.Velocity = cam.CFrame:VectorToWorldSpace(moveDir)
                rootPart.CFrame = CFrame.new(rootPart.Position) * cam.CFrame.Rotation
            end)
        end
    end

    if infiniteJumpEnabled then
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    if spinning then
        if spinConnection then spinConnection:Disconnect() end
        spinConnection = RunService.RenderStepped:Connect(function(delta)
            if spinning and HumanoidRootPart then
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360 * delta * 2), 0)
            end
        end)
    end

    if particlesEnabled then
        if particleEmitter then particleEmitter:Destroy() end
        particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxassetid://243098098"
        particleEmitter.Size = NumberSequence.new(1)
        particleEmitter.Rate = 50
        particleEmitter.Lifetime = NumberRange.new(1, 3)
        particleEmitter.Speed = NumberRange.new(5)
        particleEmitter.Parent = HumanoidRootPart
    end

    if aimbotEnabled then
        if aimbotConnection then aimbotConnection:Disconnect() end
        aimbotConnection = RunService.RenderStepped:Connect(function()
            local closestPlayer = nil
            local closestDistance = math.huge
            local cam = workspace.CurrentCamera
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = player.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPos)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
            if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
            end
        end)
    end

    if autoRespawnEnabled then
        if autoRespawnConnection then autoRespawnConnection:Disconnect() end
        autoRespawnConnection = newChar:FindFirstChild("Humanoid").Died:Connect(function()
            if autoRespawnEnabled then
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").Respawn:FireServer()
                print("Auto Respawn triggered, Alpha! 🔄")
            end
        end)
    end

    local humanoid = newChar:FindFirstChild("Humanoid")
    if humanoid then
        local speedValue = tonumber(SpeedLabel.Text:match("%d+")) or 16
        humanoid.WalkSpeed = speedValue
    end

    print("Character respawned and state updated.")
end)

-- Automatically open Credits category on load
local success, err = pcall(function()
    for _, child in pairs(CategoryFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Text == "Credits" then
            child.MouseButton1Click:Invoke()
            break
        end
    end
end)
if not success then
    warn("Failed to open Credits category on load: " .. tostring(err))
end

print("Carnality GUI V0.5 (Early Access) loaded, Alpha! Golden look for Delta Executor—let's dominate! ✨🌟")
