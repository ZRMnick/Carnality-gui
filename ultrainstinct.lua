-- Goku Ultra Instinct Script for Delta Executor (Mobile, 3-Stud Detection)
-- Features: Toggle, Proximity Dodge (3 studs), DBZ-Styled GUI, Slider, Visuals, Smooth Movement
-- Educational use only; use responsibly to avoid Roblox bans

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local DETECTION_RADIUS = 3 -- Studs; Goku senses danger super close
local MIN_TELEPORT_DISTANCE = 5 -- Min dodge distance (meters)
local MAX_TELEPORT_DISTANCE = 30 -- Max dodge distance (meters)
local TELEPORT_COOLDOWN = 0.3 -- Fast dodge cooldown (seconds)
local AURA_ID = "rbxassetid://510093254" -- Silver aura texture
local AFTERIMAGE_ID = "rbxassetid://243098098" -- Sparkle for afterimages

-- State
local isUltraInstinctActive = false
local lastTeleportTime = 0
local teleportDistance = 10 -- Default dodge distance (meters)

-- GUI Setup (DBZ Energy Meter Style)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "UltraInstinctGUI"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40) -- DBZ blue-black
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 100) -- Deep blue
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Ultra Instinct"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 255) -- Silver-blue glow
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.Arcade
TitleLabel.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 24
MinimizeButton.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
ToggleButton.Text = "UI: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 255)
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.Arcade
ToggleButton.Parent = ContentFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Instinct: Dormant"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.Arcade
StatusLabel.Parent = ContentFrame

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
SliderFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
SliderFrame.Parent = ContentFrame

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Dodge: 10m"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
SliderLabel.TextSize = 16
SliderLabel.Font = Enum.Font.Arcade
SliderLabel.Parent = SliderFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0.9, 0, 0, 10)
SliderBar.Position = UDim2.new(0.05, 0, 0, 30)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
SliderBar.Parent = SliderFrame

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 30, 0, 30)
SliderKnob.Position = UDim2.new(0, 0, 0, 25)
SliderKnob.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
SliderKnob.Parent = SliderFrame

local UICornerKnob = Instance.new("UICorner")
UICornerKnob.CornerRadius = UDim.new(0.5, 0)
UICornerKnob.Parent = SliderKnob

-- Visual Effects (Goku Ultra Instinct Style)
local function createAura(character)
    local aura = Instance.new("ParticleEmitter")
    aura.Texture = AURA_ID -- Silver aura
    aura.Lifetime = NumberRange.new(0.5, 1)
    aura.Rate = 100
    aura.Speed = NumberRange.new(2, 5)
    aura.Size = NumberSequence.new(1)
    aura.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
    aura.Parent = character.HumanoidRootPart
    aura.Enabled = isUltraInstinctActive
    return aura
end

local function createAfterImage(character)
    local afterImage = Instance.new("ParticleEmitter")
    afterImage.Texture = AFTERIMAGE_ID -- Sparkle for afterimage
    afterImage.Lifetime = NumberRange.new(0.2, 0.4)
    afterImage.Rate = 50
    afterImage.Speed = NumberRange.new(0, 0)
    afterImage.Size = NumberSequence.new(2)
    afterImage.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
    afterImage.Parent = character.HumanoidRootPart
    delay(0.5, function()
        afterImage:Destroy()
    end)
end

local function createShockwave(part)
    local shockwave = Instance.new("Part")
    shockwave.Size = Vector3.new(0.1, 0.1, 0.1)
    shockwave.Position = part.Position
    shockwave.Anchored = true
    shockwave.CanCollide = false
    shockwave.Transparency = 0.5
    shockwave.Color = Color3.fromRGB(200, 200, 255)
    shockwave.Parent = workspace
    local tween = TweenService:Create(shockwave, TweenInfo.new(0.5), {Size = Vector3.new(10, 0.1, 10), Transparency = 1})
    tween:Play()
    delay(0.5, function()
        shockwave:Destroy()
    end)
end

-- Teleport Function (Ultra Instinct Dodge)
local function dodge(targetPosition)
    if tick() - lastTeleportTime < TELEPORT_COOLDOWN then return end
    lastTeleportTime = tick()

    -- Random dodge direction (Goku’s instinctive movement)
    local angles = {0, 45, 90, 135, 180, 225, 270, 315}
    local randomAngle = angles[math.random(1, #angles)]
    local rad = math.rad(randomAngle)
    local teleportVector = Vector3.new(math.cos(rad), 0, math.sin(rad)) * (teleportDistance * 10) -- Meters to studs
    local newPosition = HumanoidRootPart.Position + teleportVector

    -- Avoid obstacles
    local ray = Ray.new(HumanoidRootPart.Position, teleportVector)
    local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {Character})
    if hit then
        newPosition = hitPosition - teleportVector.Unit * 5
    end

    -- Instant dodge with slight tween
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(newPosition)})
    tween:Play()

    -- Visuals
    createAfterImage(Character)
    createShockwave(HumanoidRootPart)

    -- Sound Effect
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1842934869" -- DBZ teleport sound
    sound.Volume = 0.5
    sound.Parent = HumanoidRootPart
    sound:Play()
    delay(2, function()
        sound:Destroy()
    end)

    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Instinct",
        Text = "Dodged " .. math.floor(teleportDistance) .. "m!",
        Duration = 1
    })
end

-- Proximity Check
local function checkProximity()
    if not isUltraInstinctActive then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if distance <= DETECTION_RADIUS * 10 then
                dodge(player.Character.HumanoidRootPart.Position#pragma
                break
            end
        end
    end
end

-- GUI Functionality
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    MinimizeButton.Text = isMinimized and "+" or "-"
    MainFrame.Size = isMinimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 200)
end)

ToggleButton.MouseButton1Click:Connect(function()
    isUltraInstinctActive = not isUltraInstinctActive
    ToggleButton.Text = "UI: " .. (isUltraInstinctActive and "ON" or "OFF")
    StatusLabel.Text = "Instinct: " .. (isUltraInstinctActive and "Awakened" or "Dormant")
    StatusLabel.TextColor3 = isUltraInstinctActive and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 255)
    local aura = Character.HumanoidRootPart:FindFirstChild("Aura")
    if aura then
        aura.Enabled = isUltraInstinctActive
    end
end)

-- Slider (Touch Support)
local isDragging = false
SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
    end
end)

SliderKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if isDragging then
        local touchX = input.Position.X
        local sliderX = SliderBar.AbsolutePosition.X
        local sliderWidth = SliderBar.AbsoluteSize.X
        local knobX = math.clamp(touchX - sliderX, 0, sliderWidth - SliderKnob.AbsoluteSize.X)
        SliderKnob.Position = UDim2.new(0, knobX, 0, 25)
        local sliderValue = knobX / (sliderWidth - SliderKnob.AbsoluteSize.X)
        teleportDistance = MIN_TELEPORT_DISTANCE + (MAX_TELEPORT_DISTANCE - MIN_TELEPORT_DISTANCE) * sliderValue
        SliderLabel.Text = "Dodge: " .. math.floor(teleportDistance) .. "m"
    end
end)

-- Character Reset and Aura
local aura = createAura(Character)
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    aura = createAura(Character)
end)

-- Main Loop
RunService.Heartbeat:Connect(checkProximity)

-- Initial Notification
StarterGui:SetCore("SendNotification", {
    Title = "Ultra Instinct Loaded",
    Text = "Tap the GUI to awaken Goku’s power!",
    Duration = 5
})
