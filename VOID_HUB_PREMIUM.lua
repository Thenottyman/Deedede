local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


-- VOID HUB PREMIUM COLOR SCHEME
local COLOR_BG = Color3.fromRGB(15, 15, 20)
local COLOR_YELLOW = Color3.fromRGB(138, 43, 226) -- Purple
local COLOR_YELLOW_DARK = Color3.fromRGB(98, 23, 186)
local COLOR_YELLOW_LIGHT = Color3.fromRGB(178, 83, 255)
local COLOR_WHITE = Color3.fromRGB(255, 255, 255)


local fps = 0
local ping = 0


local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local UseItemRemote = Net:RemoteEvent("UseItem")
local KeybindManager = {
    keybinds = {
        BatAimbot = Enum.KeyCode.Z,
        PaintballSpam = Enum.KeyCode.X,
        HighestESP = Enum.KeyCode.C,
        Helicopter = Enum.KeyCode.H,
        ESP = Enum.KeyCode.E,
        AutoSteal = Enum.KeyCode.V,
        Medusa = Enum.KeyCode.M,
        SpinBot = Enum.KeyCode.S,
        AntiRagdoll = Enum.KeyCode.R,
        Optimizer = Enum.KeyCode.O,
        XRay = Enum.KeyCode.K,
        AntiBeeDisc = Enum.KeyCode.B,
        PlayerFollower = Enum.KeyCode.L,
        StealingSpeed = Enum.KeyCode.T,
    }
}

getgenv().SetKeybind = function(featureName, keyCode)
    if KeybindManager.keybinds[featureName] then
        KeybindManager.keybinds[featureName] = keyCode
    end
end

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
clickSound.Volume = 0.4
clickSound.Parent = SoundService


local AnimalsData = require(ReplicatedStorage.Datas:WaitForChild("Animals"))
local AnimalsShared = require(ReplicatedStorage.Shared:WaitForChild("Animals"))
local NumberUtils = require(ReplicatedStorage.Utils:WaitForChild("NumberUtils"))
local highestEspGui = nil
local highestEspAnimals = {}
local highestEspCurrentBest = nil
local highestEspESP = nil
-- highestEspUpdateConnection moved to State table
local highestEspSynchronizerInternal = {
    _cache = {},
    _dataTable = nil
}

local DataStore = {
    Speed = 28.5,
    Gravity = 196.2,
    JumpPower = 50,
    HelicopterSpeed = 0,
    Keybinds = {}
}
local function toggleSwitch(switchData, active)
    if active then
        TweenService:Create(switchData.toggle, TweenInfo.new(0.3), {
            Position = UDim2.new(1, -23, 0, 2),
            BackgroundColor3 = COLOR_YELLOW
        }):Play()
        TweenService:Create(switchData.switchCont, TweenInfo.new(0.3), {
            BackgroundColor3 = COLOR_YELLOW_DARK
        }):Play()
    else
        TweenService:Create(switchData.toggle, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(switchData.switchCont, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end
end

local function saveSettings()
    if writefile and readfile then
        
        local keybindsCopy = {}
        for name, key in pairs(KeybindManager.keybinds) do
            keybindsCopy[name] = tostring(key):gsub("Enum.KeyCode.", "")
        end
        DataStore.Keybinds = keybindsCopy
        
        local success, err = pcall(function()
            writefile("VOID_HUB_SETTINGS.txt", game:GetService("HttpService"):JSONEncode(DataStore))
        end)
        if not success then
            warn("Failed to save settings:", err)
        end
    end
end

local function loadSettings()
    if readfile and isfile and isfile("VOID_HUB_SETTINGS.txt") then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("VOID_HUB_SETTINGS.txt"))
        end)
        if success and data then
            DataStore = data
            
           
            if DataStore.Keybinds then
                for name, keyString in pairs(DataStore.Keybinds) do
                    if type(keyString) == "string" then
                        local keyCode = Enum.KeyCode[keyString]
                        if keyCode then
                            KeybindManager.keybinds[name] = keyCode
                        end
                    end
                end
            end
        end
    end
end

-- Load settings on start
loadSettings()


local gui = Instance.new("ScreenGui")
gui.Name = "VOID_HUB_GUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui


local UserInputService = game:GetService("UserInputService")
do
    local isMobile_tmp = UserInputService:GetLastInputType() == Enum.UserInputType.Touch or game:GetService("RunService"):IsStudio() == false and game:GetService("GuiService"):IsTenFootInterface()
    local guiWidth_tmp = isMobile_tmp and 360 or 640
    local guiHeight_tmp = isMobile_tmp and 500 or 650
    getgenv()._GUI_WIDTH = guiWidth_tmp
    getgenv()._GUI_HEIGHT = guiHeight_tmp
    getgenv()._IS_MOBILE = isMobile_tmp
end
local isMobile = getgenv()._IS_MOBILE
local guiWidth = getgenv()._GUI_WIDTH
local guiHeight = getgenv()._GUI_HEIGHT

-- Container for all GUI elements (for dragging)
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, guiWidth, 0, guiHeight)
mainContainer.Position = UDim2.new(0.5, -guiWidth/2, 0.5, -guiHeight/2)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = gui


task.spawn(function()
    local lastTick = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTick = tick()
        if currentTick - lastTick >= 1 then
            fps = frameCount
            frameCount = 0
            lastTick = currentTick
        end
    end)
end)

-- Ping Counter
task.spawn(function()
    while true do
        ping = math.floor(player:GetNetworkPing() * 1000)
        task.wait(1)
    end
end)

-- Premium Notification Function
local function showNotification(message)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 320, 0, 65)
    notification.Position = UDim2.new(0.5, -160, 0, -75)
    notification.BackgroundColor3 = COLOR_BG
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = gui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notification
    
    local notifOutline = Instance.new("UIStroke")
    notifOutline.Color = COLOR_YELLOW
    notifOutline.Thickness = 2.5
    notifOutline.Transparency = 0.2
    notifOutline.Parent = notification
    
    -- Add glow gradient
    local glowGradient = Instance.new("UIGradient")
    glowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_YELLOW_DARK),
        ColorSequenceKeypoint.new(0.5, COLOR_YELLOW_LIGHT),
        ColorSequenceKeypoint.new(1, COLOR_YELLOW_DARK)
    })
    glowGradient.Rotation = 45
    glowGradient.Parent = notifOutline
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = 15
    notifText.TextColor3 = COLOR_YELLOW_LIGHT
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    -- Animate gradient
    task.spawn(function()
        for i = 0, 1, 0.05 do
            if glowGradient then
                glowGradient.Offset = Vector2.new(i, 0)
            end
            task.wait(0.03)
        end
    end)
    
    -- Animate in
    notification:TweenPosition(UDim2.new(0.5, -160, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
    
    -- Wait and animate out
    task.wait(3)
    notification:TweenPosition(UDim2.new(0.5, -160, 0, -75), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.5, true)
    task.wait(0.5)
    notification:Destroy()
end

-- Title Frame
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = COLOR_BG
titleFrame.BackgroundTransparency = 0.2
titleFrame.BorderSizePixel = 0
titleFrame.Active = true
titleFrame.Parent = mainContainer

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleFrame

local titleOutline = Instance.new("UIStroke")
titleOutline.Color = COLOR_YELLOW
titleOutline.Thickness = 3
titleOutline.Parent = titleFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLOR_YELLOW_DARK),
    ColorSequenceKeypoint.new(0.5, COLOR_YELLOW),
    ColorSequenceKeypoint.new(1, COLOR_YELLOW_DARK)
}
titleGradient.Rotation = 45
titleGradient.Parent = titleFrame

-- Premium animated gradient
task.spawn(function()
    while titleGradient and titleFrame do
        for i = 0, 360, 3 do
            if not titleGradient or not titleFrame then break end
            titleGradient.Rotation = i
            task.wait(0.03)
        end
    end
end)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "VOID HUB 💜 PREMIUM | FPS: 0 | PING: 0"
titleText.Font = Enum.Font.GothamBlack
titleText.TextSize = isMobile and 16 or 22
titleText.TextColor3 = COLOR_YELLOW_LIGHT
titleText.Parent = titleFrame

-- Update FPS and Ping in title
task.spawn(function()
    while true do
        titleText.Text = string.format("VOID HUB 💜 PREMIUM | FPS: %d | PING: %d", fps, ping)
        task.wait(0.5)
    end
end)

-- Drag Handler for Main Container
local dragging = false
local dragStart = nil
local startPos = nil

titleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
    end
end)

titleFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainContainer.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Movement Panel (Left)
local movementFrame = Instance.new("Frame")
local movementWidth = isMobile and guiWidth or 310
local movementHeight = isMobile and (guiHeight - 70) or 580
movementFrame.Size = UDim2.new(0, movementWidth, 0, movementHeight)
movementFrame.Position = isMobile and UDim2.new(0, 0, 0, 70) or UDim2.new(0, 0, 0, 70)
movementFrame.BackgroundColor3 = COLOR_BG
movementFrame.BackgroundTransparency = 0.2
movementFrame.BorderSizePixel = 0
movementFrame.Parent = mainContainer

local movementCorner = Instance.new("UICorner")
movementCorner.CornerRadius = UDim.new(0, 12)
movementCorner.Parent = movementFrame

local movementOutline = Instance.new("UIStroke")
movementOutline.Color = COLOR_YELLOW
movementOutline.Thickness = 3
movementOutline.Parent = movementFrame

local movementGradient = Instance.new("UIGradient")
movementGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLOR_YELLOW_DARK),
    ColorSequenceKeypoint.new(0.5, COLOR_YELLOW),
    ColorSequenceKeypoint.new(1, COLOR_YELLOW_DARK)
}
movementGradient.Rotation = 90
movementGradient.Parent = movementFrame

-- Premium gradient animation
task.spawn(function()
    while movementGradient and movementFrame do
        for i = 0, 360, 3 do
            if not movementGradient or not movementFrame then break end
            movementGradient.Rotation = i
            task.wait(0.04)
        end
    end
end)

local movementTitle = Instance.new("TextLabel")
movementTitle.Size = UDim2.new(1, 0, 0, 30)
movementTitle.Position = UDim2.new(0, 0, 0, 5)
movementTitle.BackgroundTransparency = 1
movementTitle.Text = "MOVEMENT"
movementTitle.Font = Enum.Font.GothamBold
movementTitle.TextSize = 18
movementTitle.TextColor3 = COLOR_YELLOW_LIGHT
movementTitle.Parent = movementFrame

-- Main Features Panel (Right)
local featuresFrame = Instance.new("Frame")
featuresFrame.Size = isMobile and UDim2.new(0, guiWidth, 0, movementHeight) or UDim2.new(0, 310, 0, 580)
featuresFrame.Position = isMobile and UDim2.new(0, 0, 0, 70 + movementHeight) or UDim2.new(0, 330, 0, 70)
featuresFrame.BackgroundColor3 = COLOR_BG
featuresFrame.BackgroundTransparency = 0.2
featuresFrame.BorderSizePixel = 0
featuresFrame.Parent = mainContainer

local featuresCorner = Instance.new("UICorner")
featuresCorner.CornerRadius = UDim.new(0, 12)
featuresCorner.Parent = featuresFrame

local featuresOutline = Instance.new("UIStroke")
featuresOutline.Color = COLOR_YELLOW
featuresOutline.Thickness = 3
featuresOutline.Parent = featuresFrame

local featuresGradient = Instance.new("UIGradient")
featuresGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLOR_YELLOW_DARK),
    ColorSequenceKeypoint.new(0.5, COLOR_YELLOW),
    ColorSequenceKeypoint.new(1, COLOR_YELLOW_DARK)
}
featuresGradient.Rotation = 90
featuresGradient.Parent = featuresFrame

-- Premium gradient animation
task.spawn(function()
    while featuresGradient and featuresFrame do
        for i = 0, 360, 3 do
            if not featuresGradient or not featuresFrame then break end
            featuresGradient.Rotation = i
            task.wait(0.04)
        end
    end
end)

local featuresTitle = Instance.new("TextLabel")
featuresTitle.Size = UDim2.new(1, 0, 0, 30)
featuresTitle.Position = UDim2.new(0, 0, 0, 5)
featuresTitle.BackgroundTransparency = 1
featuresTitle.Text = "MAIN FEATURES"
featuresTitle.Font = Enum.Font.GothamBold
featuresTitle.TextSize = 18
featuresTitle.TextColor3 = COLOR_YELLOW_LIGHT
featuresTitle.Parent = featuresFrame

-- Function to create a switch
local function createSwitch(parent, labelText, yPos, showOutline)
    if showOutline == nil then showOutline = true end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 35)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundColor3 = COLOR_BG
    container.BackgroundTransparency = 0.5
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    if showOutline then
        local outline = Instance.new("UIStroke")
        outline.Color = COLOR_YELLOW
        outline.Thickness = 2
        outline.Transparency = 0.3
        outline.Parent = container
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = COLOR_WHITE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local switchCont = Instance.new("Frame")
    switchCont.Size = UDim2.new(0, 50, 0, 25)
    switchCont.Position = UDim2.new(1, -60, 0.5, -12.5)
    switchCont.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    switchCont.BorderSizePixel = 0
    switchCont.Parent = container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0.5, 0)
    switchCorner.Parent = switchCont
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 21, 0, 21)
    toggle.Position = UDim2.new(0, 2, 0, 2)
    toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggle.BorderSizePixel = 0
    toggle.Parent = switchCont
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = switchCont
    
    return {container = container, button = button, toggle = toggle, switchCont = switchCont, label = label}
end

-- Function to create a slider
local function createSlider(parent, labelText, yPos, minVal, maxVal, defaultVal, showOutline, isGravity)
    if showOutline == nil then showOutline = true end
    
    -- Load saved value
    local savedValue = DataStore[labelText:gsub(" ", "")]
    if savedValue then
        defaultVal = savedValue
    end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 60)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundColor3 = COLOR_BG
    container.BackgroundTransparency = 0.5
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    if showOutline then
        local outline = Instance.new("UIStroke")
        outline.Color = COLOR_YELLOW
        outline.Thickness = 2
        outline.Transparency = 0.3
        outline.Parent = container
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText .. ": " .. defaultVal
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = COLOR_WHITE
    label.Parent = container
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -20, 0, 10)
    sliderTrack.Position = UDim2.new(0, 10, 0, 32)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = container
    
    local sliderTrackCorner = Instance.new("UICorner")
    sliderTrackCorner.CornerRadius = UDim.new(1, 0)
    sliderTrackCorner.Parent = sliderTrack
    
    -- For gravity: reverse the logic - higher slider = lower gravity
    local initialPercentage
    if isGravity then
        -- 196 = 100% (normal gravity), 0 = 0% (no gravity)
        initialPercentage = 1 - ((defaultVal - minVal) / (maxVal - minVal))
    else
        initialPercentage = (defaultVal - minVal) / (maxVal - minVal)
    end
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
    sliderFill.BackgroundColor3 = COLOR_YELLOW
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 20, 0, 20)
    sliderKnob.Position = UDim2.new(initialPercentage, -10, 0.5, -10)
    sliderKnob.BackgroundColor3 = COLOR_YELLOW_LIGHT
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderTrack
    
    local sliderKnobCorner = Instance.new("UICorner")
    sliderKnobCorner.CornerRadius = UDim.new(1, 0)
    sliderKnobCorner.Parent = sliderKnob
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 40, 1, 40)
    sliderButton.Position = UDim2.new(0, -20, 0, -20)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    return {
        container = container,
        button = sliderButton,
        label = label,
        fill = sliderFill,
        knob = sliderKnob,
        track = sliderTrack,
        min = minVal,
        max = maxVal,
        value = defaultVal,
        isGravity = isGravity or false
    }
end

-- Movement Panel Elements (Removed Desync and Animations as requested)
-- Booster Container
local boosterContainer = Instance.new("Frame")
boosterContainer.Size = UDim2.new(1, -20, 0, 380)
boosterContainer.Position = UDim2.new(0, 10, 0, 45)
boosterContainer.BackgroundColor3 = COLOR_BG
boosterContainer.BackgroundTransparency = 0.5
boosterContainer.BorderSizePixel = 0
boosterContainer.Parent = movementFrame

local boosterCorner = Instance.new("UICorner")
boosterCorner.CornerRadius = UDim.new(0, 8)
boosterCorner.Parent = boosterContainer

local boosterOutline = Instance.new("UIStroke")
boosterOutline.Color = COLOR_YELLOW
boosterOutline.Thickness = 2
boosterOutline.Transparency = 0.3
boosterOutline.Parent = boosterContainer

-- Booster Switch
local boosterSwitch = createSwitch(boosterContainer, "BOOSTER", 5, false)
boosterSwitch.container.Position = UDim2.new(0, 0, 0, 5)
boosterSwitch.container.Size = UDim2.new(1, 0, 0, 35)

-- Speed slider only (no gravity, no jump power)
do
    local sliders = {}
    sliders.speedSlider = createSlider(boosterContainer, "Speed", 45, 16, 100, DataStore.Speed, false)
    sliders.gravitySlider = createSlider(boosterContainer, "Gravity", 110, 0, 500, DataStore.Gravity, false, true)
    sliders.stealingSpeedSwitch = createSwitch(boosterContainer, "STEALING SPEED BOOST", 175, false)
    sliders.stealingSpeedSwitch.container.Position = UDim2.new(0, 0, 0, 175)
    sliders.stealingSpeedSwitch.container.Size = UDim2.new(1, 0, 0, 35)
    sliders.infiniteJumpSwitch = createSwitch(boosterContainer, "INFINITE JUMP", 220, false)
    sliders.infiniteJumpSwitch.container.Position = UDim2.new(0, 0, 0, 220)
    sliders.infiniteJumpSwitch.container.Size = UDim2.new(1, 0, 0, 35)
    sliders.jumpBoostSwitch = createSwitch(boosterContainer, "JUMP BOOST", 265, false)
    sliders.jumpBoostSwitch.container.Position = UDim2.new(0, 0, 0, 265)
    sliders.jumpBoostSwitch.container.Size = UDim2.new(1, 0, 0, 35)
    sliders.jumpBoostSlider = createSlider(boosterContainer, "Boost Power", 305, 0, 100, 50, false)
    getgenv()._SLIDERS = sliders
end

local function getSlider(name)
    return getgenv()._SLIDERS[name]
end

local speedSlider = getSlider("speedSlider")
local gravitySlider = getSlider("gravitySlider")
local stealingSpeedSwitch = getSlider("stealingSpeedSwitch")


local keybindsFrame = Instance.new("Frame")
keybindsFrame.Size = UDim2.new(0, 310, 0, 580)
keybindsFrame.Position = UDim2.new(0, 660, 0, 70)
keybindsFrame.BackgroundColor3 = COLOR_BG
keybindsFrame.BackgroundTransparency = 0.2
keybindsFrame.BorderSizePixel = 0
keybindsFrame.Parent = mainContainer
keybindsFrame.Visible = false

local keybindsCorner = Instance.new("UICorner")
keybindsCorner.CornerRadius = UDim.new(0, 12)
keybindsCorner.Parent = keybindsFrame

local keybindsOutline = Instance.new("UIStroke")
keybindsOutline.Color = COLOR_YELLOW
keybindsOutline.Thickness = 3
keybindsOutline.Parent = keybindsFrame

local keybindsTitle = Instance.new("TextLabel")
keybindsTitle.Size = UDim2.new(1, 0, 0, 30)
keybindsTitle.Position = UDim2.new(0, 0, 0, 5)
keybindsTitle.BackgroundTransparency = 1
keybindsTitle.Text = "KEYBINDS"
keybindsTitle.Font = Enum.Font.GothamBold
keybindsTitle.TextSize = 18
keybindsTitle.TextColor3 = COLOR_YELLOW_LIGHT
keybindsTitle.Parent = keybindsFrame

local keybindsScroll = Instance.new("ScrollingFrame")
keybindsScroll.Size = UDim2.new(1, -10, 1, -45)
keybindsScroll.Position = UDim2.new(0, 5, 0, 40)
keybindsScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keybindsScroll.BackgroundTransparency = 0.3
keybindsScroll.BorderSizePixel = 0
keybindsScroll.CanvasSize = UDim2.new(0, 0, 0, 650)
keybindsScroll.ScrollBarThickness = 8
keybindsScroll.Parent = keybindsFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = keybindsScroll

local keybindsContainer = Instance.new("UIListLayout")
keybindsContainer.Padding = UDim.new(0, 8)
keybindsContainer.Parent = keybindsScroll

local rebindingFeature = nil
local rebindingButton = nil

local keybindFeatures = {
    {name = "Bat Aimbot", key = "BatAimbot"},
    {name = "Paintball Spam", key = "PaintballSpam"},
    {name = "Highest ESP", key = "HighestESP"},
    {name = "Helicopter", key = "Helicopter"},
    {name = "ESP", key = "ESP"},
    {name = "Auto Steal", key = "AutoSteal"},
    {name = "Stealing Speed Boost", key = "StealingSpeed"},
    {name = "Medusa", key = "Medusa"},
    {name = "SpinBot", key = "SpinBot"},
    {name = "Anti-Ragdoll", key = "AntiRagdoll"},
    {name = "Optimizer", key = "Optimizer"},
    {name = "X-Ray", key = "XRay"},
    {name = "Anti-Bee Disco", key = "AntiBeeDisc"},
    {name = "Player Follower", key = "PlayerFollower"}
}

do
    for _, feature in ipairs(keybindFeatures) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, -10, 0, 40)
        entry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        entry.BackgroundTransparency = 0.5
        entry.BorderSizePixel = 0
        entry.Parent = keybindsScroll
        
        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 6)
        entryCorner.Parent = entry
        
        local featureLabel = Instance.new("TextLabel")
        featureLabel.Size = UDim2.new(0.5, -5, 1, 0)
        featureLabel.Position = UDim2.new(0, 8, 0, 0)
        featureLabel.BackgroundTransparency = 1
        featureLabel.Text = feature.name
        featureLabel.Font = Enum.Font.Gotham
        featureLabel.TextSize = 12
        featureLabel.TextColor3 = COLOR_WHITE
        featureLabel.TextXAlignment = Enum.TextXAlignment.Left
        featureLabel.Parent = entry
        
        local keybindButton = Instance.new("TextButton")
        keybindButton.Size = UDim2.new(0.45, -5, 1, -8)
        keybindButton.Position = UDim2.new(0.5, 5, 0, 4)
        keybindButton.BackgroundColor3 = COLOR_YELLOW_DARK
        keybindButton.BackgroundTransparency = 0.4
        keybindButton.BorderSizePixel = 0
        keybindButton.Font = Enum.Font.GothamBold
        keybindButton.TextSize = 11
        keybindButton.TextColor3 = COLOR_YELLOW
        keybindButton.Parent = entry
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = keybindButton
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = COLOR_YELLOW
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.5
        btnStroke.Parent = keybindButton
        
        -- Update button text with current keybind
        local currentKey = KeybindManager.keybinds[feature.key]
        if currentKey then
            keybindButton.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
        else
            keybindButton.Text = "NONE"
        end
        
        -- Rebind on click
        keybindButton.MouseButton1Click:Connect(function()
            if rebindingFeature then
                rebindingFeature = nil
                if rebindingButton then
                    rebindingButton.BackgroundTransparency = 0.4
                    rebindingButton.Text = tostring(KeybindManager.keybinds[rebindingButton:GetAttribute("feature")] or ""):gsub("Enum.KeyCode.", "")
                end
            end
            
            rebindingFeature = feature.key
            rebindingButton = keybindButton
            keybindButton.BackgroundTransparency = 0.1
            keybindButton.Text = "PRESS KEY..."
            keybindButton:SetAttribute("feature", feature.key)
        end)
    end
end

-- Rebinding will be handled by the main keybind input handler below


-- Add tab button to toggle keybinds panel
local keybindsTabButton = Instance.new("TextButton")
keybindsTabButton.Size = UDim2.new(0, 90, 0, 35)
keybindsTabButton.Position = UDim2.new(1, -450, 0, 17.5)
keybindsTabButton.BackgroundColor3 = COLOR_YELLOW_DARK
keybindsTabButton.BackgroundTransparency = 0.3
keybindsTabButton.BorderSizePixel = 0
keybindsTabButton.Text = "KEYBINDS"
keybindsTabButton.Font = Enum.Font.GothamBold
keybindsTabButton.TextSize = 11
keybindsTabButton.TextColor3 = COLOR_YELLOW
keybindsTabButton.Parent = titleFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 6)
tabCorner.Parent = keybindsTabButton

local tabStroke = Instance.new("UIStroke")
tabStroke.Color = COLOR_YELLOW
tabStroke.Thickness = 1.5
tabStroke.Transparency = 0.5
tabStroke.Parent = keybindsTabButton

keybindsTabButton.MouseButton1Click:Connect(function()
    featuresFrame.Visible = not featuresFrame.Visible
    keybindsFrame.Visible = not keybindsFrame.Visible
    
    if featuresFrame.Visible then
        keybindsTabButton.Text = "KEYBINDS"
        keybindsTabButton.BackgroundTransparency = 0.3
    else
        keybindsTabButton.Text = "← FEATURES"
        keybindsTabButton.BackgroundTransparency = 0.1
    end
end)

-- Main Features Panel Elements - Store in a table to reduce locals
do
    local s = {}
    s.paintballSwitch = createSwitch(featuresFrame, "PAINTBALL SPAM", 45)
    s.autoBatSwitch = createSwitch(featuresFrame, "AUTO BAT", 90)
    s.antiRagdollSwitch = createSwitch(featuresFrame, "ANTI RAGDOLL", 135)
    s.espSwitch = createSwitch(featuresFrame, "PLAYER ESP", 180)
    s.optimizerSwitch = createSwitch(featuresFrame, "OPTIMIZER", 225)
    s.antiBeeDiscoSwitch = createSwitch(featuresFrame, "ANTI BEE/DISCO", 270)
    s.xrayBaseSwitch = createSwitch(featuresFrame, "XRAY BASE", 315)
    s.autoStealNearestSwitch = createSwitch(featuresFrame, "AUTO STEAL NEAREST", 360)
    s.medusaSwitch = createSwitch(featuresFrame, "MEDUSA IN RANGE", 405)
    s.spinBotSwitch = createSwitch(featuresFrame, "SPIN BOT", 450)
    s.batAimbotSwitch = createSwitch(featuresFrame, "BAT AIMBOT", 495)
    s.highestEspSwitch = createSwitch(featuresFrame, "HIGHEST ESP", 540)
    getgenv()._SWITCHES = s
end

local function getSwitch(name)
    return getgenv()._SWITCHES[name]
end

local paintballSwitch = getSwitch("paintballSwitch")
local autoBatSwitch = getSwitch("autoBatSwitch")
local antiRagdollSwitch = getSwitch("antiRagdollSwitch")
local espSwitch = getSwitch("espSwitch")
local optimizerSwitch = getSwitch("optimizerSwitch")
local antiBeeDiscoSwitch = getSwitch("antiBeeDiscoSwitch")
local xrayBaseSwitch = getSwitch("xrayBaseSwitch")
local autoStealNearestSwitch = getSwitch("autoStealNearestSwitch")
local medusaSwitch = getSwitch("medusaSwitch")
local spinBotSwitch = getSwitch("spinBotSwitch")
local batAimbotSwitch = getSwitch("batAimbotSwitch")
local highestEspSwitch = getSwitch("highestEspSwitch")

-- Variables consolidated into state table to reduce register usage
local State = {
    -- Toggles
    helicopterActive = false,
    espActive = false,
    optimizerActive = false,
    boosterActive = false,
    antiRagdollEnabled = false,
    antiBeeDiscoEnabled = false,
    xrayEnabled = false,
    autoStealNearestEnabled = false,
    medusaEnabled = false,
    spinBotEnabled = false,
    batAimbotEnabled = false,
    stealingSpeedEnabled = false,
    paintballSpamActive = false,
    playerFollowerActive = false,
    autoBatActive = false,
    highestEspActive = false,
    infiniteJumpActive = false,
    jumpBoostActive = false,
    
    -- Connections
    helicopterConnection = nil,
    autoBatConnection = nil,
    boosterConnection = nil,
    stealingSpeedConnection = nil,
    autoStealConnection = nil,
    medusaConnection = nil,
    paintballSpamConnection = nil,
    paintballEquipConnection = nil,
    playerFollowerConnection = nil,
    highestEspUpdateConnection = nil,
    jumpBoostConnection = nil,
    infiniteJumpConnection = nil,
    
    -- Velocities/Objects
    spinVelocity = nil,
    aimVelocity = nil,
    espFolder = nil,
    originalTransparency = {},
    playerFollowerTarget = nil,
    
    -- Ranges/Values
    medusaRange = 10,
    batRange = 8.5,
    playerFollowerDistance = 1.5,
    playerFollowerSpeed = 60,
    jumpBoostPower = 50,
    espConnections = {},
}

-- No shortcuts — use State directly to save 30+ registers
local lastFireTime = 0
local FIRE_RATE = 0

-- Paintball Discord Watermark
local watermarkFrame = Instance.new("Frame")
watermarkFrame.Size = UDim2.new(0, 350, 0, 40)
watermarkFrame.Position = UDim2.new(0.5, -175, 0, 10)
watermarkFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
watermarkFrame.BackgroundTransparency = 0.3
watermarkFrame.BorderSizePixel = 0
watermarkFrame.ZIndex = 10
watermarkFrame.Parent = gui

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 12)
watermarkCorner.Parent = watermarkFrame

local watermarkStroke = Instance.new("UIStroke")
watermarkStroke.Color = Color3.fromRGB(100, 150, 255)
watermarkStroke.Thickness = 2
watermarkStroke.Parent = watermarkFrame

local watermarkGradient = Instance.new("UIGradient")
watermarkGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
}
watermarkGradient.Parent = watermarkFrame

-- Animate rainbow for discord box
task.spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            watermarkGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0.8, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.5) % 1, 0.8, 1))
            }
            watermarkStroke.Color = Color3.fromHSV(hue, 0.6, 1)
            task.wait(0.03)
        end
    end
end)

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(1, -20, 1, 0)
watermark.Position = UDim2.new(0, 10, 0, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "discord.gg/sabscripts"
watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
watermark.TextTransparency = 0
watermark.TextScaled = true
watermark.Font = Enum.Font.Code
watermark.ZIndex = 11
watermark.Parent = watermarkFrame

-- Helper Functions
local function hrp()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHRP()
    local c = player.Character
    if not c then return end
    return c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- === UPDATED BAT AIMBOT SYSTEM (ANGULAR VELOCITY) ===
-- batAimbotConnection moved to State table
local batAimbotAngularVelocity = nil

local function getNearestPlayerWithinRange(range)
    local character = player.Character
    if not character then return nil end
    
    local myHRP = character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    
    local nearestPlayer = nil
    local nearestDistance = range or math.huge
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local distance = (myHRP.Position - otherHRP.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end
    
    return nearestPlayer, nearestDistance
end

local function applyBatAimbot()
    if not State.batAimbotEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Create or get BodyAngularVelocity
    if not batAimbotAngularVelocity or not batAimbotAngularVelocity.Parent then
        batAimbotAngularVelocity = Instance.new("BodyAngularVelocity")
        batAimbotAngularVelocity.Name = "BatAimbotAngularVelocity"
        batAimbotAngularVelocity.MaxTorque = Vector3.new(100000, 100000, 100000)
        batAimbotAngularVelocity.P = 10000
        batAimbotAngularVelocity.Parent = hrp
    end
    
    local myPos = hrp.Position
    
    -- Find closest player within range
    local closest = nil
    local closestDist = 99999
    
    for i = 1, #Players:GetPlayers() do
        local plr = Players:GetPlayers()[i]
        if plr ~= player and plr.Character then
            local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (myPos - targetHRP.Position).Magnitude
                if dist < closestDist and dist <= batRange then
                    closestDist = dist
                    closest = targetHRP
                end
            end
        end
    end
    
    if not closest then 
        batAimbotAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        return 
    end
    
    -- Calculate direction to target (horizontal only, Y stays same)
    local targetPos = closest.Position
    local directionToTarget = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos
    
    -- Get current forward direction
    local currentLook = hrp.CFrame.LookVector
    
    -- Calculate perpendicular axis (cross product)
    local axis = currentLook:Cross(directionToTarget.Unit)
    
    -- Calculate angle between current and target direction
    local angle = math.acos(math.clamp(currentLook:Dot(directionToTarget.Unit), -1, 1))
    
    -- Apply angular velocity - rotate towards target
    -- Magnitude controls rotation speed
    local rotationSpeed = math.min(angle * 20, 50) -- Cap rotation speed at 50
    batAimbotAngularVelocity.AngularVelocity = axis * rotationSpeed
end

-- Clean up function for bat aimbot
local function cleanupBatAimbot()
    if batAimbotAngularVelocity and batAimbotAngularVelocity.Parent then
        batAimbotAngularVelocity:Destroy()
        batAimbotAngularVelocity = nil
    end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = true
    end
end

-- === HIGHEST ESP SYSTEM ===
local function highestEspGetInternalTable()
    local Packages = ReplicatedStorage:FindFirstChild("Packages")
    if not Packages then return nil end
    
    local SynchronizerModule = Packages:FindFirstChild("Synchronizer")
    if not SynchronizerModule then return nil end
    
    local success, synchronizer = pcall(require, SynchronizerModule)
    if not success or not synchronizer then return nil end
    
    local GetMethod = synchronizer and synchronizer.Get
    if type(GetMethod) ~= "function" then return nil end
    
    for i = 1, 5 do
        local success, upvalue = pcall(getupvalue, GetMethod, i)
        if success and type(upvalue) == "table" then
            if upvalue.___private or upvalue.___channels or upvalue.___data then
                return upvalue
            end
            for k, v in pairs(upvalue) do
                if type(k) == "string" and k:match("^Plot_") or type(v) == "table" then
                    return upvalue
                end
            end
        end
    end
    
    local success, env = pcall(getfenv, GetMethod)
    if success and env and env.self then
        return env.self
    end
    
    return nil
end

task.spawn(function()
    local attempts = 0
    while attempts < 10 and not highestEspSynchronizerInternal._dataTable do
        highestEspSynchronizerInternal._dataTable = highestEspGetInternalTable()
        if not highestEspSynchronizerInternal._dataTable then
            task.wait(1)
            attempts = attempts + 1
        end
    end
end)

local function highestEspStealthGet(plotName)
    if not plotName or type(plotName) ~= "string" then return nil end
    if highestEspSynchronizerInternal._cache[plotName] == false then return nil end
    
    if highestEspSynchronizerInternal._dataTable then
        local keys = {
            plotName,
            "Plot_" .. plotName,
            "Plot" .. plotName,
            plotName .. "_Channel",
            "Channel_" .. plotName
        }
        
        for _, key in ipairs(keys) do
            if highestEspSynchronizerInternal._dataTable[key] then
                highestEspSynchronizerInternal._cache[plotName] = highestEspSynchronizerInternal._dataTable[key]
                return highestEspSynchronizerInternal._dataTable[key]
            end
        end
        
        for k, v in pairs(highestEspSynchronizerInternal._dataTable) do
            if type(k) == "string" and (k == plotName or k:find(plotName, 1, true)) then
                if type(v) == "table" then
                    highestEspSynchronizerInternal._cache[plotName] = v
                    return v
                end
            end
        end
    end
    
    highestEspSynchronizerInternal._cache[plotName] = false
    return nil
end

local function highestEspStealthGetFromChannel(channel, key)
    if not channel then return nil end
    
    local success, value = pcall(function()
        return channel:Get(key)
    end)
    
    if success then return value end
    
    success, value = pcall(function()
        if channel.Get and type(channel.Get) == "function" then
            return channel:Get(key)
        elseif channel.get and type(channel.get) == "function" then
            return channel:get(key)
        elseif rawget(channel, key) then
            return rawget(channel, key)
        end
    end)
    
    if success then return value end
    return nil
end

local function highestEspStealthGetProperty(channel, key)
    if not channel then return nil end
    
    local success, value = pcall(function()
        return channel[key]
    end)
    
    if success then return value end
    
    return highestEspStealthGetFromChannel(channel, key)
end

local function highestEspClearESP()
    if highestEspESP then
        pcall(function() highestEspESP.Highlight:Destroy() end)
        pcall(function() highestEspESP.Billboard:Destroy() end)
        highestEspESP = nil
    end
    highestEspCurrentBest = nil
end

local function highestEspGetWorldPart(animal)
    if not animal.plot or not animal.slot then return end
    local plot = Workspace.Plots:FindFirstChild(animal.plot)
    if not plot then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    local podium = podiums:FindFirstChild(animal.slot)
    if not podium then return end
    return podium:FindFirstChild("Base") or podium:FindFirstChild("Spawn") or podium
end

local function highestEspUpdateESPValue()
    if highestEspESP and highestEspESP.Billboard and highestEspESP.Billboard:FindFirstChild("Frame") then
        local frame = highestEspESP.Billboard.Frame
        local valueLabel = frame:FindFirstChild("TextLabel")
        if valueLabel and highestEspCurrentBest then
            valueLabel.Text = "$" .. NumberUtils:ToString(highestEspCurrentBest.gen) .. "/s"
        end
    end
end

local function highestEspCreateESP(animal)
    highestEspClearESP()
    local part = highestEspGetWorldPart(animal)
    if not part then return end
    highestEspESP = {}

    local success, h = pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.Adornee = part
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(255, 215, 0)
        highlight.FillTransparency = 0.75
        highlight.OutlineTransparency = 0.2
        highlight.Parent = highestEspGui
        return highlight
    end)
    
    if not success then return end
    highestEspESP.Highlight = h

    local success2, bb = pcall(function()
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = part
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = highestEspGui
        return billboard
    end)
    
    if not success2 then 
        pcall(function() highestEspESP.Highlight:Destroy() end)
        return 
    end
    highestEspESP.Billboard = bb

    pcall(function()
        local bg = Instance.new("Frame")
        bg.Name = "Frame"
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.35
        bg.BorderSizePixel = 0
        bg.Parent = bb

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = bg

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 215, 0)
        stroke.Thickness = 2
        stroke.Parent = bg

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -8, 0, 16)
        title.Position = UDim2.new(0, 4, 0, 2)
        title.BackgroundTransparency = 1
        title.Text = tostring(animal.name)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 10
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.Parent = bg

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(1, -8, 0, 18)
        value.Position = UDim2.new(0, 4, 0, 20)
        value.BackgroundTransparency = 1
        value.Text = "$" .. NumberUtils:ToString(animal.gen) .. "/s"
        value.Font = Enum.Font.GothamBold
        value.TextSize = 12
        value.TextColor3 = Color3.fromRGB(0, 255, 0)
        value.Parent = bg
    end)

    highestEspCurrentBest = animal
end

local function highestEspIsMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then
        return false
    end
    
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then
        return false
    end
    
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then
        return false
    end
    
    local channel = highestEspStealthGet(plot.Name)
    if channel then
        local owner = highestEspStealthGetProperty(channel, "Owner")
        if owner then
            if typeof(owner) == "Instance" and owner:IsA("Player") then
                return owner.UserId == player.UserId
            elseif typeof(owner) == "table" and owner.UserId then
                return owner.UserId == player.UserId
            elseif typeof(owner) == "Instance" then
                return owner == player
            end
        end
    end
    
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") then
            return yourBase.Enabled == true
        end
    end
    
    return false
end

local function highestEspRefreshPlotData(plot)
    local plotName = plot.Name
    local channel = highestEspStealthGet(plotName)
    if not channel then 
        for uid, animal in pairs(highestEspAnimals) do
            if animal.plot == plotName then
                highestEspAnimals[uid] = nil
            end
        end
        return {} 
    end
    
    local list = highestEspStealthGetFromChannel(channel, "AnimalList")
    if not list then 
        for uid, animal in pairs(highestEspAnimals) do
            if animal.plot == plotName then
                highestEspAnimals[uid] = nil
            end
        end
        return {} 
    end
    
    local currentAnimals = {}
    local plotAnimals = {}
    
    local isMyPlot = false
    local tempAnimal = {plot = plotName}
    isMyPlot = highestEspIsMyBaseAnimal(tempAnimal)
    
    if isMyPlot then
        for uid, animal in pairs(highestEspAnimals) do
            if animal.plot == plotName then
                highestEspAnimals[uid] = nil
            end
        end
        return {}
    end
    
    for slot, data in pairs(list) do
        if type(data) ~= "table" then continue end
        
        local uid = plotName .. "_" .. slot
        currentAnimals[uid] = true
        
        local existingAnimal = highestEspAnimals[uid]
        if existingAnimal then
            local success3, newGen = pcall(function()
                return AnimalsShared:GetGeneration(data.Index, data.Mutation, data.Traits, nil)
            end)
            
            if success3 and newGen then
                existingAnimal.gen = newGen
                plotAnimals[uid] = existingAnimal
            end
        else
            local success2, info = pcall(function()
                return AnimalsData[data.Index]
            end)
            
            if not success2 or not info then continue end
            
            local success3, gen = pcall(function()
                return AnimalsShared:GetGeneration(data.Index, data.Mutation, data.Traits, nil)
            end)
            
            if not success3 or not gen then continue end
            
            plotAnimals[uid] = {
                uid = uid,
                name = info.DisplayName or data.Index,
                gen = gen,
                plot = plotName,
                slot = tostring(slot),
                isNotMyPlot = true
            }
        end
    end
    
    for uid, animal in pairs(highestEspAnimals) do
        if animal.plot == plotName and not currentAnimals[uid] then
            highestEspAnimals[uid] = nil
        end
    end
    
    return plotAnimals
end

local function highestEspRefreshAllData()
    if not highestEspSynchronizerInternal._dataTable then return end
    
    local plots = Workspace:WaitForChild("Plots")
    if not plots then 
        highestEspClearESP()
        return 
    end
    
    for _, plot in ipairs(plots:GetChildren()) do
        local plotAnimals = highestEspRefreshPlotData(plot)
        for uid, animal in pairs(plotAnimals) do
            highestEspAnimals[uid] = animal
        end
    end
end

local function highestEspFindBestAnimal()
    local best = nil
    local bestVal = 0
    
    for _, animal in pairs(highestEspAnimals) do
        if animal.gen > bestVal then
            bestVal = animal.gen
            best = animal
        end
    end
    
    return best
end

local function highestEspRecompute()
    local best = highestEspFindBestAnimal()
    
    if best and (not highestEspCurrentBest or best.uid ~= highestEspCurrentBest.uid) then
        highestEspCreateESP(best)
    elseif best and highestEspCurrentBest and best.uid == highestEspCurrentBest.uid and best.gen ~= highestEspCurrentBest.gen then
        highestEspCurrentBest.gen = best.gen
        highestEspUpdateESPValue()
    elseif not best and highestEspCurrentBest then
        highestEspClearESP()
    elseif best and not highestEspCurrentBest then
        highestEspCreateESP(best)
    end
end

local function highestEspStart()
    if State.highestEspActive then return end
    
    -- Create GUI for Highest ESP
    highestEspGui = Instance.new("ScreenGui")
    highestEspGui.Name = "StealthHighestESP"
    highestEspGui.ResetOnSpawn = false
    highestEspGui.DisplayOrder = 999999
    highestEspGui.Parent = playerGui
    
    task.spawn(function()
        task.wait(2)
        
        local success = pcall(function()
            local plots = Workspace:WaitForChild("Plots")
            
            if plots then
                if State.highestEspUpdateConnection then
                    State.highestEspUpdateConnection:Disconnect()
                end
                
                State.highestEspUpdateConnection = RunService.Heartbeat:Connect(function()
                    highestEspRefreshAllData()
                    highestEspRecompute()
                end)
                
                plots.ChildAdded:Connect(function(plot)
                    task.wait(0.5)
                end)
                
                plots.ChildRemoved:Connect(function(plot)
                    local plotName = plot.Name
                    for uid, animal in pairs(highestEspAnimals) do
                        if animal.plot == plotName then
                            highestEspAnimals[uid] = nil
                        end
                    end
                    highestEspRecompute()
                end)
            end
        end)
    end)
    
    highestEspGui.Destroying:Connect(function()
        if State.highestEspUpdateConnection then
            State.highestEspUpdateConnection:Disconnect()
        end
        highestEspClearESP()
    end)
end

local function highestEspStop()
    if State.highestEspUpdateConnection then
        State.highestEspUpdateConnection:Disconnect()
        State.highestEspUpdateConnection = nil
    end
    
    if highestEspGui then
        highestEspGui:Destroy()
        highestEspGui = nil
    end
    
    highestEspClearESP()
    highestEspAnimals = {}
    highestEspCurrentBest = nil
end

local function createUndetectableESP()
    if State.espFolder then
        State.espFolder:Destroy()
    end
    
    for _, conn in pairs(State.espConnections) do
        conn:Disconnect()
    end
    State.espConnections = {}
    
    State.espFolder = Instance.new("Folder")
    State.espFolder.Name = "LIMITED_ESP"
    State.espFolder.Parent = workspace
    
    local function addESP(character)
        if character == player.Character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Create yellow glow effect
        local highlight = Instance.new("Highlight")
        highlight.Name = "LIMITED_ESP_GLOW"
        highlight.Adornee = character
        highlight.Enabled = true
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = COLOR_YELLOW
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = COLOR_YELLOW_DARK
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        -- Create billboard GUI for name and distance
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "LIMITED_ESP_INFO"
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 8, 0)
        billboard.MaxDistance = 1000
        billboard.Parent = hrp
        
        -- Background frame
        local bg = Instance.new("Frame")
        bg.Name = "Background"
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = COLOR_BG
        bg.BackgroundTransparency = 0.3
        bg.BorderSizePixel = 0
        bg.Parent = billboard
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = bg
        
        -- Yellow border
        local border = Instance.new("UIStroke")
        border.Color = COLOR_YELLOW
        border.Thickness = 2
        border.Parent = bg
        
        -- Player name label
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "PlayerName"
        nameLabel.Size = UDim2.new(1, -10, 0, 25)
        nameLabel.Position = UDim2.new(0, 5, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = character.Name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextColor3 = COLOR_YELLOW_LIGHT
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextStrokeColor3 = COLOR_BG
        nameLabel.Parent = bg
        
        -- Distance label
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "Distance"
        distanceLabel.Size = UDim2.new(1, -10, 0, 20)
        distanceLabel.Position = UDim2.new(0, 5, 0, 30)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.TextSize = 12
        distanceLabel.TextColor3 = COLOR_WHITE
        distanceLabel.TextStrokeTransparency = 0.5
        distanceLabel.TextStrokeColor3 = COLOR_BG
        distanceLabel.Parent = bg
        
        -- Update distance in real-time
        local updateConn = RunService.RenderStepped:Connect(function()
            if not character or not character.Parent or not hrp then
                highlight:Destroy()
                billboard:Destroy()
                return
            end
            
            local myHRP = getHRP()
            if myHRP then
                local distance = math.floor((myHRP.Position - hrp.Position).Magnitude)
                distanceLabel.Text = distance .. " studs"
            end
        end)
        
        table.insert(State.espConnections, updateConn)
        
        -- Clean up when character is removed
        character.AncestryChanged:Connect(function()
            if not character.Parent then
                highlight:Destroy()
                billboard:Destroy()
            end
        end)
    end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            addESP(otherPlayer.Character)
        end
        local charConn = otherPlayer.CharacterAdded:Connect(addESP)
        table.insert(State.espConnections, charConn)
    end
    
    local playerConn = Players.PlayerAdded:Connect(function(otherPlayer)
        local charConn = otherPlayer.CharacterAdded:Connect(addESP)
        table.insert(State.espConnections, charConn)
    end)
    table.insert(State.espConnections, playerConn)
end

local function removeESP()
    if State.espFolder then
        State.espFolder:Destroy()
        State.espFolder = nil
    end
    
    for _, conn in pairs(State.espConnections) do
        conn:Disconnect()
    end
    State.espConnections = {}
    
    -- Remove all ESP elements from players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            -- Remove highlights
            for _, child in ipairs(otherPlayer.Character:GetChildren()) do
                if child:IsA("Highlight") and child.Name == "LIMITED_ESP_GLOW" then
                    child:Destroy()
                end
            end
            
            -- Remove billboards
            local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local billboard = hrp:FindFirstChild("LIMITED_ESP_INFO")
                if billboard then
                    billboard:Destroy()
                end
            end
        end
    end
end

-- === PAINTBALL SPAM FUNCTIONS ===
local function forceEquipPaintballGun()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if not character or not backpack then return end
    
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Paintball Gun" then
            tool.Parent = backpack
        end
    end
    
    local gun = backpack:FindFirstChild("Paintball Gun")
    if gun then gun.Parent = character end
end

local function getPerfectTorsoPosition()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = character.HumanoidRootPart.Position
    local nearestTarget = nil
    local nearestDist = math.huge
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist and dist < 400 then
                nearestDist = dist
                nearestTarget = p.Character
            end
        end
    end
    
    if not nearestTarget then return nil end
    
    local torso = nearestTarget:FindFirstChild("UpperTorso") or nearestTarget:FindFirstChild("Torso") or nearestTarget:FindFirstChild("HumanoidRootPart")
    if torso then
        return torso.Position + (torso.Velocity * 0.1)
    end
    return nil
end

do
    local function startPaintballSpam()
        if State.paintballSpamActive then return end
        State.paintballSpamActive = true
        
        State.paintballEquipConnection = RunService.Heartbeat:Connect(function()
            if State.paintballSpamActive then forceEquipPaintballGun() end
        end)
        
        State.paintballSpamConnection = RunService.Heartbeat:Connect(function()
            if not State.paintballSpamActive then return end
            local now = tick()
            if now - lastFireTime >= FIRE_RATE then
                local pos = getPerfectTorsoPosition()
                if pos then
                    -- Fire 5 times per frame for maximum speed
                    for i = 1, 5 do
                        UseItemRemote:FireServer(pos)
                    end
                    lastFireTime = now
                end
            end
        end)
        
        showNotification("Paintball Spam Enabled", COLOR_YELLOW)
    end

    local function stopPaintballSpam()
        State.paintballSpamActive = false
        if State.paintballSpamConnection then State.paintballSpamConnection:Disconnect() end
        if State.paintballEquipConnection then State.paintballEquipConnection:Disconnect() end
        
        showNotification("Paintball Spam Disabled", COLOR_YELLOW)
    end
    
    getgenv().startPaintballSpam = startPaintballSpam
    getgenv().stopPaintballSpam = stopPaintballSpam
end

local startPaintballSpam = getgenv().startPaintballSpam
local stopPaintballSpam = getgenv().stopPaintballSpam

-- === MEDUSA SYSTEM ===
local function findMedusa()
    for _, v in ipairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("medusa") then
            return v
        end
    end
    return nil
end

local function getClosestPlayer()
    local best, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (getHRP().Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                best = plr
            end
        end
    end
    return best
end

local OPTIMIZER = {}
local optimizerThreads = {}
local optimizerConnections = {}
local originalSettings = {}

local function addThread(func)
    local t = task.spawn(func)
    table.insert(optimizerThreads, t)
    return t
end

local function addConnection(conn)
    table.insert(optimizerConnections, conn)
    return conn
end

-- Store original settings for restoration
local function storeOriginalSettings()
    pcall(function()
        originalSettings = {
            -- Workspace
            streamingEnabled = Workspace.StreamingEnabled,
            streamingMinRadius = Workspace.StreamingMinRadius,
            streamingTargetRadius = Workspace.StreamingTargetRadius,
            
            -- Rendering
            qualityLevel = settings().Rendering.QualityLevel,
            meshPartDetailLevel = settings().Rendering.MeshPartDetailLevel,
            
            -- Lighting
            globalShadows = Lighting.GlobalShadows,
            brightness = Lighting.Brightness,
            fogEnd = Lighting.FogEnd,
            technology = Lighting.Technology,
            environmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
            environmentSpecularScale = Lighting.EnvironmentSpecularScale,
            
            -- Terrain
            decoration = Workspace.Terrain.Decoration,
            waterWaveSize = Workspace.Terrain.WaterWaveSize,
            waterWaveSpeed = Workspace.Terrain.WaterWaveSpeed,
            waterReflectance = Workspace.Terrain.WaterReflectance,
            waterTransparency = Workspace.Terrain.WaterTransparency,
        }
    end)
end

local PERFORMANCE_FFLAGS = {
    -- Rendering optimizations (ULTRA LOW)
    ["DFIntTaskSchedulerTargetFps"] = 999,
    ["FFlagDebugGraphicsPreferVulkan"] = true,
    ["FFlagDebugGraphicsDisableDirect3D11"] = true,
    ["FFlagDebugGraphicsPreferD3D11FL10"] = false,
    ["DFFlagDebugRenderForceTechnologyVoxel"] = true,
    ["FFlagDisablePostFx"] = true,
    ["FIntRenderShadowIntensity"] = 0,
    ["FIntRenderLocalLightUpdatesMax"] = 0,
    ["FIntRenderLocalLightUpdatesMin"] = 0,
    ["DFIntTextureCompositorActiveJobs"] = 1,
    ["DFIntDebugFRMQualityLevelOverride"] = 1,
    
    -- Physics optimizations
    ["FFlagFixPlayerCollisionWhenSwimming"] = false,
    ["DFIntMaxInterpolationSubsteps"] = 0,
    ["DFIntS2PhysicsSenderRate"] = 15,
    
    -- Network optimizations
    ["DFIntConnectionMTUSize"] = 1492,
    ["DFIntHttpCurlConnectionCacheSize"] = 134217728,
    
    -- Memory optimizations (AGGRESSIVE)
    ["DFIntCSGLevelOfDetailSwitchingDistance"] = 0,
    ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = 0,
    ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = 0,
    ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = 0,
    
    -- Disable unnecessary features
    ["FFlagEnableInGameMenuChromeABTest3"] = false,
    ["FFlagEnableInGameMenuModernization"] = false,
    ["FFlagEnableReportAbuseMenuRoactABTest2"] = false,
    ["FFlagDisableNewIGMinDUA"] = true,
    ["FFlagEnableAccessoryValidation"] = false,
    ["FFlagEnableV3MenuABTest3"] = false,
    
    -- UI optimizations (MINIMAL)
    ["FIntRobloxGuiBlurIntensity"] = 0,
    ["DFIntTimestepArbiterThresholdCFLThou"] = 10,
    
    -- Texture/graphics optimizations (POTATO)
    ["DFIntTextureQualityOverride"] = 1,
    ["DFIntPerformanceControlTextureQualityBestUtility"] = 1,
    ["DFIntTexturePoolSizeMB"] = 64,
    
    -- Animation optimizations
    ["DFIntMaxFrameBufferSize"] = 1,
    
    -- Particle optimizations
    ["FFlagDebugDisableParticleRendering"] = false,
    ["DFIntParticleMaxCount"] = 100,
    
    -- Water optimizations
    ["FFlagEnableWaterReflections"] = false,
    ["DFIntWaterReflectionQuality"] = 0,
}

local function applyFFlags()
    local success = 0
    local failed = 0
    
    for flag, value in pairs(PERFORMANCE_FFLAGS) do
        local ok = pcall(function()
            setfflag(flag, tostring(value))
        end)
        
        if ok then
            success = success + 1
        else
            failed = failed + 1
        end
    end
end

local function nukeVisualEffects()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            pcall(function()
                -- Destroy ALL particles
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                    obj.Rate = 0
                    obj:Destroy()
                    
                -- Destroy trails
                elseif obj:IsA("Trail") then
                    obj.Enabled = false
                    obj:Destroy()
                    
                -- Destroy beams
                elseif obj:IsA("Beam") then
                    obj.Enabled = false
                    obj:Destroy()
                    
                -- Destroy all lights
                elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    obj.Enabled = false
                    obj.Brightness = 0
                    obj:Destroy()
                    
                -- Destroy fire, smoke, sparkles
                elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                    obj:Destroy()
                    
                -- Destroy explosions
                elseif obj:IsA("Explosion") then
                    obj:Destroy()
                    
                -- Simplify meshes
                elseif obj:IsA("SpecialMesh") then
                    obj.TextureId = ""
                    
                -- Remove textures/decals (except faces)
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                        obj.Transparency = 1
                    end
                    
                -- Disable shadows on all parts
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.Plastic
                    
                    -- Remove reflectance
                    if obj.Material == Enum.Material.Glass then
                        obj.Reflectance = 0
                    end
                end
            end)
        end
    end)
end

function OPTIMIZER.Enable()
    if getgenv().OPTIMIZER_ACTIVE then 
        warn("[Optimizer] Already running!")
        return 
    end
    
    getgenv().OPTIMIZER_ACTIVE = true
    storeOriginalSettings()
    
    -- Apply FFlags first
    pcall(applyFFlags)
    
    -- 1. ULTRA POTATO Streaming
    pcall(function()
        Workspace.StreamingEnabled = true
        Workspace.StreamingMinRadius = 64
        Workspace.StreamingTargetRadius = 256
        Workspace.StreamingIntegrityMode = Enum.StreamingIntegrityMode.MinimumRadiusPause
    end)
    
    -- 2. ULTRA POTATO Rendering
    pcall(function()
        local renderSettings = settings().Rendering
        renderSettings.QualityLevel = Enum.QualityLevel.Level01
        renderSettings.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        renderSettings.EditQualityLevel = Enum.QualityLevel.Level01
        
        -- Disable ALL lighting effects
        Lighting.GlobalShadows = false
        Lighting.Brightness = 3
        Lighting.FogEnd = 9e9
        Lighting.Technology = Enum.Technology.Legacy
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        
        -- Disable ALL post-processing effects
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                pcall(function() 
                    effect.Enabled = false 
                    effect:Destroy()
                end)
            end
        end
        
        -- Remove atmosphere
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmo then atmo:Destroy() end
        
        -- Remove bloom
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then bloom:Destroy() end
        
        -- Remove blur
        local blur = Lighting:FindFirstChildOfClass("BlurEffect")
        if blur then blur:Destroy() end
        
        -- Remove color correction
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then cc:Destroy() end
        
        -- Remove sun rays
        local sunrays = Lighting:FindFirstChildOfClass("SunRaysEffect")
        if sunrays then sunrays:Destroy() end
        
        -- Remove depth of field
        local dof = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        if dof then dof:Destroy() end
    end)
    
    -- 3. ULTRA POTATO Physics
    pcall(function()
        local physics = settings().Physics
        physics.AllowSleep = true
        physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
        physics.ThrottleAdjustTime = 0
    end)
    
    -- 4. POTATO Terrain
    pcall(function()
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterReflectance = 0
        Workspace.Terrain.WaterTransparency = 1
        Workspace.Terrain.Decoration = false
    end)
    
    -- 5. NUKE all visual effects (one-time aggressive pass)
    addThread(function()
        task.wait(1)
        nukeVisualEffects()
    end)
    
    -- 6. Monitor for NEW visual effects and destroy them
    addConnection(Workspace.DescendantAdded:Connect(function(obj)
        if not getgenv().OPTIMIZER_ACTIVE then return end
        
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
               obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or
               obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.Plastic
            end
        end)
    end))
    
    -- 7. Character optimizer (event-based, ULTRA POTATO)
    local function optimizeCharacter(char)
        if not char then return end
        
        task.spawn(function()
            task.wait(0.5)
            
            pcall(function()
                for _, part in ipairs(char:GetDescendants()) do
                    pcall(function()
                        if part:IsA("BasePart") then
                            part.CastShadow = false
                            part.Material = Enum.Material.Plastic
                            part.Reflectance = 0
                            
                        elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") then
                            part:Destroy()
                            
                        elseif part:IsA("PointLight") or part:IsA("SpotLight") or part:IsA("SurfaceLight") then
                            part:Destroy()
                            
                        elseif part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") then
                            part:Destroy()
                        end
                    end)
                end
            end)
        end)
    end
    
    -- Optimize current characters
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            optimizeCharacter(plr.Character)
        end
        
        addConnection(plr.CharacterAdded:Connect(function(char)
            if getgenv().OPTIMIZER_ACTIVE then
                optimizeCharacter(char)
            end
        end))
    end
    
    addConnection(Players.PlayerAdded:Connect(function(plr)
        addConnection(plr.CharacterAdded:Connect(function(char)
            if getgenv().OPTIMIZER_ACTIVE then
                optimizeCharacter(char)
            end
        end))
    end))
    
    -- 8. Memory cleanup (less aggressive - every 15 seconds)
    addThread(function()
        while getgenv().OPTIMIZER_ACTIVE do
            task.wait(15)
            
            pcall(function()
                collectgarbage("collect")
            end)
        end
    end)
    
    -- 9. FPS Unlocker
    pcall(function()
        setfpscap(999)
    end)
    
    -- 10. Disable camera shake/effects
    pcall(function()
        local cam = Workspace.CurrentCamera
        cam.FieldOfView = 70
    end)
    
    showNotification("ULTRA POTATO Optimizer Enabled", COLOR_YELLOW)
end

function OPTIMIZER.Disable()
    if not getgenv().OPTIMIZER_ACTIVE then return end
    
    getgenv().OPTIMIZER_ACTIVE = false
    
    -- Cancel all threads
    for _, thread in ipairs(optimizerThreads) do
        pcall(function()
            task.cancel(thread)
        end)
    end
    optimizerThreads = {}
    
    -- Disconnect all connections
    for _, conn in ipairs(optimizerConnections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    optimizerConnections = {}
    
    -- Restore original settings
    pcall(function()
        Workspace.StreamingEnabled = originalSettings.streamingEnabled or true
        Workspace.StreamingMinRadius = originalSettings.streamingMinRadius or 64
        Workspace.StreamingTargetRadius = originalSettings.streamingTargetRadius or 1024
        
        settings().Rendering.QualityLevel = originalSettings.qualityLevel or Enum.QualityLevel.Automatic
        settings().Rendering.MeshPartDetailLevel = originalSettings.meshPartDetailLevel or Enum.MeshPartDetailLevel.DistanceBased
        
        Lighting.GlobalShadows = originalSettings.globalShadows ~= false
        Lighting.Brightness = originalSettings.brightness or 1
        Lighting.FogEnd = originalSettings.fogEnd or 100000
        Lighting.Technology = originalSettings.technology or Enum.Technology.ShadowMap
        Lighting.EnvironmentDiffuseScale = originalSettings.environmentDiffuseScale or 1
        Lighting.EnvironmentSpecularScale = originalSettings.environmentSpecularScale or 1
        
        Workspace.Terrain.WaterWaveSize = originalSettings.waterWaveSize or 0.15
        Workspace.Terrain.WaterWaveSpeed = originalSettings.waterWaveSpeed or 10
        Workspace.Terrain.WaterReflectance = originalSettings.waterReflectance or 1
        Workspace.Terrain.WaterTransparency = originalSettings.waterTransparency or 0.3
        Workspace.Terrain.Decoration = originalSettings.decoration ~= false
    end)
    
    showNotification("Optimizer Disabled", COLOR_YELLOW)
end

do
    local function enableAntiBeeDisco()
        if not State.antiBeeDiscoEnabled then return end
        
        -- Remove disco effects from lighting
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("ColorCorrectionEffect") or child:IsA("BlurEffect") or 
               child.Name == "DiscoEffect" or child.Name == "BeeBlur" then
                child:Destroy()
            end
        end
        
        -- Block bee buzzing sound
        local PlayerScripts = player:WaitForChild("PlayerScripts")
        local beeScript = PlayerScripts:FindFirstChild("Bee", true)
        if beeScript then
            local buzzing = beeScript:FindFirstChild("Buzzing")
            if buzzing and buzzing:IsA("Sound") then
                buzzing:Stop()
                buzzing.Volume = 0
            end
        end
    end

    local function disableAntiBeeDisco()
        -- Nothing to restore
    end
    
    getgenv().enableAntiBeeDisco = enableAntiBeeDisco
    getgenv().disableAntiBeeDisco = disableAntiBeeDisco
end

local enableAntiBeeDisco = getgenv().enableAntiBeeDisco
local disableAntiBeeDisco = getgenv().disableAntiBeeDisco

-- === XRAY BASE SYSTEM ===
do
    local function enableXray()
        if not State.xrayEnabled then return end
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Anchored and obj.CanCollide then
                local name = obj.Name:lower()
                local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                
                if name:find("base") or parentName:find("base") or name:find("wall") then
                    State.originalTransparency[obj] = obj.LocalTransparencyModifier
                    obj.LocalTransparencyModifier = 0.85
                end
            end
        end
    end

    local function disableXray()
        for part, value in pairs(State.originalTransparency) do
            if part then
                part.LocalTransparencyModifier = value
            end
        end
        State.originalTransparency = {}
    end
    
    getgenv().enableXray = enableXray
    getgenv().disableXray = disableXray
end

local enableXray = getgenv().enableXray
local disableXray = getgenv().disableXray

do
    local function startPlayerFollower()
        if State.playerFollowerConnection then
            State.playerFollowerConnection:Disconnect()
        end
        
        State.playerFollowerConnection = RunService.Heartbeat:Connect(function()
            if not State.playerFollowerActive then return end
            
            -- Find closest player
            local closestPlayer = nil
            local closestDistance = math.huge
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherCharacter = otherPlayer.Character
                    if otherCharacter then
                        local otherHRP = otherCharacter:FindFirstChild("HumanoidRootPart")
                        if otherHRP then
                            local distance = (getHRP().Position - otherHRP.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestPlayer = otherPlayer
                            end
                        end
                    end
                end
            end
            
            State.playerFollowerTarget = closestPlayer
            if not closestPlayer or not closestPlayer.Character then return end
            
            local targetCharacter = closestPlayer.Character
            local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            
            if not targetHRP or not targetHumanoid then return end
            
            local ourHRP = getHRP()
            if not ourHRP then return end
            
            -- Get target's velocity and position
            local targetVelocity = targetHRP.AssemblyLinearVelocity
            local targetPosition = targetHRP.Position
            
            -- Get target's look direction to position ourselves behind them
            local targetLookDirection = targetHRP.CFrame.LookVector
            local offsetPosition = targetPosition - (targetLookDirection * playerFollowerDistance)
            
            -- Move to stay close to target
            local moveDirection = (offsetPosition - ourHRP.Position)
            local currentVelocity = ourHRP.AssemblyLinearVelocity
            
            -- Blend between target velocity and position-correction velocity
            if moveDirection.Magnitude > 0.5 then
                ourHRP.AssemblyLinearVelocity = currentVelocity:Lerp(
                    moveDirection.Unit * playerFollowerSpeed,
                    0.2
                )
            else
                -- Very close, just copy their velocity
                ourHRP.AssemblyLinearVelocity = currentVelocity:Lerp(targetVelocity, 0.1)
            end
            
            -- Jump detection and replication
            local targetIsJumping = targetHumanoid.State == Enum.HumanoidStateType.Jumping or
                                   targetVelocity.Y > 0.1
            
            if targetIsJumping and not State.playerFollowerTarget._lastJumpState then
                local ourHumanoid = character:FindFirstChild("Humanoid")
                if ourHumanoid then
                    ourHumanoid:Jump()
                end
            end
            
            State.playerFollowerTarget._lastJumpState = targetIsJumping
        end)
    end

    local function stopPlayerFollower()
        if State.playerFollowerConnection then
            State.playerFollowerConnection:Disconnect()
            State.playerFollowerConnection = nil
        end
        State.playerFollowerTarget = nil
    end
    
    getgenv().startPlayerFollower = startPlayerFollower
    getgenv().stopPlayerFollower = stopPlayerFollower
end

local startPlayerFollower = getgenv().startPlayerFollower
local stopPlayerFollower = getgenv().stopPlayerFollower

local ANTI_RAGDOLL = {}
local antiRagdollMode = nil
local ragdollConnections = {}
local cachedCharData = {}

-- Cache character data for performance
local function cacheCharacterData()
    local char = player.Character
    if not char then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not root then return false end
    
    cachedCharData = {
        character = char,
        humanoid = hum,
        root = root,
        originalWalkSpeed = hum.WalkSpeed,
        originalJumpPower = hum.JumpPower,
        isFrozen = false
    }
    
    return true
end

-- Clean disconnect helper
local function disconnectAll()
    for _, conn in ipairs(ragdollConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end
    ragdollConnections = {}
end

-- Check if currently ragdolled (using multiple detection methods)
local function isRagdolled()
    if not cachedCharData.humanoid then return false end
    
    local hum = cachedCharData.humanoid
    local state = hum:GetState()
    
    -- State check
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true
    }
    
    if ragdollStates[state] then
        return true
    end
    
    -- Timer attribute check
    local endTime = player:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then
            return true
        end
    end
    
    return false
end

-- Remove all ragdoll constraints (v1 method)
local function removeRagdollConstraints()
    if not cachedCharData.character then return end
    
    local removed = false
    
    for _, descendant in ipairs(cachedCharData.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or 
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            pcall(function()
                descendant:Destroy()
                removed = true
            end)
        end
    end
    
    return removed
end

-- Force exit ragdoll state
local function forceExitRagdoll()
    if not cachedCharData.humanoid or not cachedCharData.root then return end
    
    local hum = cachedCharData.humanoid
    local root = cachedCharData.root
    
    -- Clear ragdoll timer
    pcall(function()
        local now = workspace:GetServerTimeNow()
        player:SetAttribute("RagdollEndTime", now)
    end)
    
    -- Force standing state
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    -- Reset physics
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

-- Freeze player in place (v2 method)
local function freezePlayer()
    if not cachedCharData.humanoid or not cachedCharData.root then return end
    if cachedCharData.isFrozen then return end
    
    local hum = cachedCharData.humanoid
    local root = cachedCharData.root
    
    -- Save current stats
    cachedCharData.originalWalkSpeed = hum.WalkSpeed
    cachedCharData.originalJumpPower = hum.JumpPower
    
    -- Freeze
    hum.WalkSpeed = 0
    hum.JumpPower = 0
    root.Anchored = true
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    cachedCharData.isFrozen = true
end

-- Unfreeze player (v2 method)
local function unfreezePlayer()
    if not cachedCharData.humanoid or not cachedCharData.root then return end
    if not cachedCharData.isFrozen then return end
    
    local hum = cachedCharData.humanoid
    local root = cachedCharData.root
    
    -- Restore stats
    hum.WalkSpeed = cachedCharData.originalWalkSpeed or 16
    hum.JumpPower = cachedCharData.originalJumpPower or 50
    
    -- Unfreeze
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    cachedCharData.isFrozen = false
end

-- Main heartbeat loop for v1 (Moveable)
local function v1HeartbeatLoop()
    while antiRagdollMode == "v1" and cachedCharData.humanoid do
        task.wait()
        
        if isRagdolled() then
            -- Remove constraints and force exit
            removeRagdollConstraints()
            forceExitRagdoll()
        end
    end
end

-- Main heartbeat loop for v2 (Freeze)
local function v2HeartbeatLoop()
    while antiRagdollMode == "v2" and cachedCharData.humanoid do
        task.wait()
        
        if isRagdolled() then
            freezePlayer()
        else
            unfreezePlayer()
        end
    end
end

-- Setup camera binding for v1
local function setupCameraBinding()
    if not cachedCharData.humanoid then return end
    
    local conn = RunService.RenderStepped:Connect(function()
        if antiRagdollMode ~= "v1" then return end
        
        local cam = workspace.CurrentCamera
        if cam and cachedCharData.humanoid and cam.CameraSubject ~= cachedCharData.humanoid then
            cam.CameraSubject = cachedCharData.humanoid
        end
    end)
    
    table.insert(ragdollConnections, conn)
end

-- Handle character respawn
local function onCharacterAdded(char)
    task.wait(0.5) -- Wait for character to load
    
    if not antiRagdollMode then return end
    
    if cacheCharacterData() then
        if antiRagdollMode == "v1" then
            setupCameraBinding()
            task.spawn(v1HeartbeatLoop)
        elseif antiRagdollMode == "v2" then
            task.spawn(v2HeartbeatLoop)
        end
    end
end

function ANTI_RAGDOLL.Enable(mode)
    if mode ~= "v1" and mode ~= "v2" then 
        warn("[Anti-Ragdoll] Invalid mode:", mode)
        return 
    end
    
    if antiRagdollMode == mode then return end
    
    -- Disable first
    ANTI_RAGDOLL.Disable()
    
    -- Cache character data
    if not cacheCharacterData() then
        warn("[Anti-Ragdoll] Failed to cache character data")
        return
    end
    
    antiRagdollMode = mode
    
    -- Setup character respawn listener
    local charConn = player.CharacterAdded:Connect(onCharacterAdded)
    table.insert(ragdollConnections, charConn)
    
    -- Start appropriate mode
    if mode == "v1" then
        setupCameraBinding()
        task.spawn(v1HeartbeatLoop)
        showNotification("Anti-Ragdoll v2 (Moveable) Enabled", COLOR_YELLOW)
    else
        task.spawn(v2HeartbeatLoop)
        showNotification("Anti-Ragdoll v1 (Freeze) Enabled", COLOR_YELLOW)
    end
end

function ANTI_RAGDOLL.Disable()
    if not antiRagdollMode then return end
    
    local mode = antiRagdollMode
    antiRagdollMode = nil
    
    -- Unfreeze if frozen
    if cachedCharData.isFrozen then
        unfreezePlayer()
    end
    
    -- Disconnect all
    disconnectAll()
    
    -- Clear cache
    cachedCharData = {}
    
    showNotification("✗ Anti-Ragdoll Disabled", COLOR_YELLOW)
end

-- Update the anti-ragdoll switch handler
antiRagdollSwitch.button.MouseButton1Click:Connect(function()
    local isEnabled = not State.antiRagdollEnabled
    State.antiRagdollEnabled = isEnabled
    toggleSwitch(antiRagdollSwitch, isEnabled)
    
    if isEnabled then
        -- Use v1 mode (Moveable) - same as BKS
        ANTI_RAGDOLL.Enable("v1")
    else
        ANTI_RAGDOLL.Disable()
    end
end)

-- === AUTO BAT SYSTEM ===
do
    local function enableAutoBat()
        if State.autoBatConnection then State.autoBatConnection:Disconnect() end
        State.autoBatConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local backpack = player:FindFirstChild("Backpack")
            
            if humanoid and backpack then
                local bat = backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")
                
                if bat then
                    if bat.Parent == backpack then
                        humanoid:EquipTool(bat)
                    end
                    
                    if bat:FindFirstChild("Activated") or bat:FindFirstChild("Handle") then
                        bat:Activate()
                    end
                end
            end
        end)
    end

    local function disableAutoBat()
        if State.autoBatConnection then
            State.autoBatConnection:Disconnect()
            State.autoBatConnection = nil
        end
    end
    
    getgenv().enableAutoBat = enableAutoBat
    getgenv().disableAutoBat = disableAutoBat
end

local enableAutoBat = getgenv().enableAutoBat
local disableAutoBat = getgenv().disableAutoBat

-- boost
local boosterVelocity = nil

do
    local function enableBooster()
        if State.boosterConnection then
            State.boosterConnection:Disconnect()
        end
        
        State.boosterConnection = RunService.Heartbeat:Connect(function()
            if not State.boosterActive then return end
            
            local char = player.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not humanoid then return end
            
            -- Apply speed by modifying HRP velocity only
            local speed = speedSlider.value
            local direction = humanoid.MoveDirection
            
            if direction.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(
                    direction.X * speed,
                    hrp.AssemblyLinearVelocity.Y,
                    direction.Z * speed
                )
            end
            
            -- Apply gravity boost
            local gravityValue = gravitySlider.value
            Workspace.Gravity = gravityValue
        end)
    end

    local function disableBooster()
        if State.boosterConnection then
            State.boosterConnection:Disconnect()
            State.boosterConnection = nil
        end
    end
    
    getgenv().enableBooster = enableBooster
    getgenv().disableBooster = disableBooster
end

local enableBooster = getgenv().enableBooster
local disableBooster = getgenv().disableBooster

do
    local function enableStealingSpeedBoost()
        if State.stealingSpeedConnection then
            State.stealingSpeedConnection:Disconnect()
        end
        
        State.stealingSpeedConnection = RunService.RenderStepped:Connect(function()
            if not State.stealingSpeedEnabled then return end
            
            local char = player.Character
            if not char then return end
            
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not hrp then return end
            
            -- Check if player is currently using a steal tool
            local isStealingNow = false
            local backpack = player:FindFirstChild("Backpack")
            
            -- Simple check: if any tool in backpack has "steal" or "grab" in name and is equipped
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Parent == char then
                        local toolName = tool.Name:lower()
                        if toolName:find("steal") or toolName:find("grab") or toolName:find("hand") then
                            isStealingNow = true
                            break
                        end
                    end
                end
            end
            
            -- Apply speed boost if stealing detected
            if isStealingNow then
                local direction = humanoid.MoveDirection
                if direction.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        direction.X * 28.5,
                        hrp.AssemblyLinearVelocity.Y,
                        direction.Z * 28.5
                    )
                end
            end
        end)
    end
    
    local function disableStealingSpeedBoost()
        if State.stealingSpeedConnection then
            State.stealingSpeedConnection:Disconnect()
            State.stealingSpeedConnection = nil
        end
    end
    
    getgenv().enableStealingSpeedBoost = enableStealingSpeedBoost
    getgenv().disableStealingSpeedBoost = disableStealingSpeedBoost
end

local enableStealingSpeedBoost = getgenv().enableStealingSpeedBoost
local disableStealingSpeedBoost = getgenv().disableStealingSpeedBoost

-- === HELICOPTER SYSTEM ===
do
    local function enableHelicopter()
        if helicopterConnection then
            helicopterConnection:Disconnect()
        end
        
        State.helicopterConnection = RunService.Heartbeat:Connect(function()
            if not State.helicopterActive then return end
            
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end)
    end

    local function disableHelicopter()
        if State.helicopterConnection then
            State.helicopterConnection:Disconnect()
            State.helicopterConnection = nil
        end
    end
    
    getgenv().enableHelicopter = enableHelicopter
    getgenv().disableHelicopter = disableHelicopter
end

local enableHelicopter = getgenv().enableHelicopter
local disableHelicopter = getgenv().disableHelicopter

do
    local function updateSpinBotSystem()
        if State.spinBotEnabled then
            local humanoid = getHumanoid()
            if humanoid and humanoid.RootPart then
                humanoid.AutoRotate = false
                
                if not State.spinVelocity or not State.spinVelocity.Parent then
                    State.spinVelocity = Instance.new("BodyAngularVelocity")
                    State.spinVelocity.Name = "SpinBotVelocity"
                    State.spinVelocity.AngularVelocity = Vector3.new(0, 100, 0)
                    State.spinVelocity.MaxTorque = Vector3.new(0, 5000, 0)
                    State.spinVelocity.P = 1000
                    State.spinVelocity.Parent = humanoid.RootPart
                end
            end
        else
            if State.spinVelocity and State.spinVelocity.Parent then
                State.spinVelocity:Destroy()
                State.spinVelocity = nil
            end
            
            local humanoid = getHumanoid()
            if humanoid then
                humanoid.AutoRotate = true
            end
        end
    end
    
    getgenv().updateSpinBotSystem = updateSpinBotSystem
end

-- === MEDUSA IN RANGE SYSTEM ===
do
    local function startMedusaInRange()
        if medusaConnection then medusaConnection:Disconnect() end
        
        State.medusaConnection = RunService.RenderStepped:Connect(function()
            if not State.medusaEnabled then return end
            
            local char = player.Character
            if not char then return end
            
            local root = getHRP()
            local humanoid = getHumanoid()
            if not root or not humanoid then return end
            
            local medusa = findMedusa() or (char:FindFirstChild("Medusa") and char:FindFirstChild("Medusa"):IsA("Tool") and char.Medusa)
            
            if medusa then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local target = p.Character.HumanoidRootPart
                        local dist = (target.Position - root.Position).Magnitude
                        
                        if dist <= medusaRange then
                            -- Move towards target
                            humanoid:Move((target.Position - root.Position).Unit)
                            
                            -- Equip medusa if not equipped
                            if medusa.Parent ~= char then
                                char.Humanoid:EquipTool(medusa)
                            end
                            
                            -- Activate medusa
                            medusa:Activate()
                        end
                    end
                end
            end
        end)
    end

    local function stopMedusaInRange()
        if State.medusaConnection then
            State.medusaConnection:Disconnect()
            State.medusaConnection = nil
        end
    end
    
    getgenv().startMedusaInRange = startMedusaInRange
    getgenv().stopMedusaInRange = stopMedusaInRange
end

local startMedusaInRange = getgenv().startMedusaInRange
local stopMedusaInRange = getgenv().stopMedusaInRange

do
    -- === AUTO STEAL NEAREST SYSTEM (factory to isolate locals) ===
    local function makeAutoStealNearest()
        local ReplicatedStorage_local = game:GetService("ReplicatedStorage")
        local Packages_local = ReplicatedStorage_local and ReplicatedStorage_local:FindFirstChild("Packages")
        local NetModule_local = nil
        if Packages_local then
            pcall(function() NetModule_local = require(Packages_local.Net) end)
        end

        local autoStealConn_local = nil

        local function start_internal()
            if autoStealConn_local then autoStealConn_local:Disconnect() end

            autoStealConn_local = RunService.RenderStepped:Connect(function()
                if not State.autoStealNearestEnabled then return end

                local char = player.Character
                if not char then return end

                local root = getHRP()
                local humanoid = getHumanoid()
                if not root or not humanoid then return end

                local nearest, nearestDist = getNearestPlayerWithinRange(50)
                if nearest and nearest.Character then
                    local targetPos = nearest.Character:FindFirstChild("HumanoidRootPart")
                    if targetPos then
                        local direction = (targetPos.Position - root.Position).Unit
                        humanoid:Move(direction)

                        local backpack = player:FindFirstChild("Backpack")
                        if backpack then
                            for _, tool in ipairs(backpack:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name:lower():find("steal") then
                                    if tool.Parent == backpack then
                                        humanoid:EquipTool(tool)
                                    end
                                    tool:Activate()
                                    break
                                end
                            end
                        end

                        local Net = NetModule_local
                        if Net then
                            pcall(function()
                                local stealRemote = Net:RemoteEvent("Steal") or Net:RemoteEvent("GrabItem")
                                if stealRemote then
                                    stealRemote:FireServer(nearest, targetPos.Position)
                                end
                            end)
                        end
                    end
                end
            end)
        end

        local function stop_internal()
            if autoStealConn_local then
                autoStealConn_local:Disconnect()
                autoStealConn_local = nil
            end
        end

        getgenv().startAutoStealNearest = start_internal
        getgenv().stopAutoStealNearest = stop_internal
    end

    makeAutoStealNearest()
end

-- Keep backward compatibility
startAutoStealNearest = getgenv().startAutoStealNearest
stopAutoStealNearest = getgenv().stopAutoStealNearest

local function setupSlider(slider, callback)
    local dragging = false
    
    slider.button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local relativePos = mouse.X - slider.track.AbsolutePosition.X
            local percentage = math.clamp(relativePos / slider.track.AbsoluteSize.X, 0, 1)
            
            -- Handle gravity slider (reverse logic)
            if slider.isGravity then
                percentage = 1 - percentage -- Reverse the percentage
                slider.value = math.floor(slider.min + (percentage * (slider.max - slider.min)))
            elseif slider.max == 100 then
                slider.value = math.floor(percentage * slider.max)
            else
                slider.value = math.floor(slider.min + (percentage * (slider.max - slider.min)))
            end
            
            slider.label.Text = slider.label.Text:match("^[^:]+") .. ": " .. slider.value
            
            -- Update visual position (for gravity, we need to reverse visual too)
            local visualPercentage = slider.isGravity and (1 - percentage) or percentage
            slider.fill.Size = UDim2.new(visualPercentage, 0, 1, 0)
            slider.knob.Position = UDim2.new(visualPercentage, -10, 0.5, -10)
            
            -- Save to DataStore
            local key = slider.label.Text:match("^[^:]+"):gsub(" ", "")
            DataStore[key] = slider.value
            saveSettings()
            
            if callback then
                callback(slider.value)
            end
        end
    end)
end

setupSlider(speedSlider, function(value)
    if State.boosterActive then
        enableBooster()
    end
end)

setupSlider(gravitySlider, function(value)
    if State.boosterActive then
        enableBooster()
    end
end)

setupSlider(getSlider("jumpBoostSlider"), function(value)
    State.jumpBoostPower = value
end)



-- Paintball Spam Switch
paintballSwitch.button.MouseButton1Click:Connect(function()
    State.paintballSpamActive = not State.paintballSpamActive
    toggleSwitch(paintballSwitch, State.paintballSpamActive)
    
    if State.paintballSpamActive then
        startPaintballSpam()
    else
        stopPaintballSpam()
    end
end)

-- Booster Switch
boosterSwitch.button.MouseButton1Click:Connect(function()
    State.boosterActive = not State.boosterActive
    toggleSwitch(boosterSwitch, State.boosterActive)
    
    if State.boosterActive then
        enableBooster()
        showNotification("Booster Enabled", COLOR_YELLOW)
    else
        disableBooster()
        showNotification("Booster Disabled", COLOR_YELLOW)
    end
end)

-- Auto Bat Switch
autoBatSwitch.button.MouseButton1Click:Connect(function()
    State.autoBatActive = not State.autoBatActive
    toggleSwitch(autoBatSwitch, State.autoBatActive)
    
    if State.autoBatActive then
        enableAutoBat()
        showNotification("Auto Bat Enabled", COLOR_YELLOW)
    else
        disableAutoBat()
        showNotification("Auto Bat Disabled", COLOR_YELLOW)
    end
end)

-- Player ESP Switch
espSwitch.button.MouseButton1Click:Connect(function()
    State.espActive = not State.espActive
    toggleSwitch(espSwitch, State.espActive)
    
    if State.espActive then
        createUndetectableESP()
        showNotification("ESP Enabled", COLOR_YELLOW)
    else
        removeESP()
        showNotification("ESP Disabled", COLOR_YELLOW)
    end
end)

-- Optimizer Switch
optimizerSwitch.button.MouseButton1Click:Connect(function()
    State.optimizerActive = not State.optimizerActive
    toggleSwitch(optimizerSwitch, State.optimizerActive)
    
    if State.optimizerActive then
        OPTIMIZER.Enable()
    else
        OPTIMIZER.Disable()
    end
end)

-- Anti Bee/Disco Switch
antiBeeDiscoSwitch.button.MouseButton1Click:Connect(function()
    State.antiBeeDiscoEnabled = not State.antiBeeDiscoEnabled
    toggleSwitch(antiBeeDiscoSwitch, State.antiBeeDiscoEnabled)
    
    if State.antiBeeDiscoEnabled then
        enableAntiBeeDisco()
        showNotification("Anti Bee/Disco Enabled", COLOR_YELLOW)
    else
        disableAntiBeeDisco()
        showNotification("Anti Bee/Disco Disabled", COLOR_YELLOW)
    end
end)

-- Xray Base Switch
xrayBaseSwitch.button.MouseButton1Click:Connect(function()
    State.xrayEnabled = not State.xrayEnabled
    toggleSwitch(xrayBaseSwitch, State.xrayEnabled)
    
    if State.xrayEnabled then
        enableXray()
        showNotification("Xray Base Enabled", COLOR_YELLOW)
    else
        disableXray()
        showNotification("Xray Base Disabled", COLOR_YELLOW)
    end
end)

-- Auto Steal Nearest Switch
autoStealNearestSwitch.button.MouseButton1Click:Connect(function()
    State.autoStealNearestEnabled = not State.autoStealNearestEnabled
    toggleSwitch(autoStealNearestSwitch, State.autoStealNearestEnabled)
    
    if State.autoStealNearestEnabled then
        startAutoStealNearest()
        showNotification("Auto Steal Nearest Enabled", COLOR_YELLOW)
    else
        stopAutoStealNearest()
        showNotification("Auto Steal Nearest Disabled", COLOR_YELLOW)
    end
end)

-- Stealing Speed Boost Switch
stealingSpeedSwitch.button.MouseButton1Click:Connect(function()
    State.stealingSpeedEnabled = not State.stealingSpeedEnabled
    toggleSwitch(stealingSpeedSwitch, State.stealingSpeedEnabled)
    
    if State.stealingSpeedEnabled then
        enableStealingSpeedBoost()
        showNotification("Stealing Speed Boost Enabled (28.5)", COLOR_YELLOW)
    else
        disableStealingSpeedBoost()
        showNotification("Stealing Speed Boost Disabled", COLOR_YELLOW)
    end
end)

-- Infinite Jump Switch
local infiniteJumpSwitch = getSlider("infiniteJumpSwitch")
infiniteJumpSwitch.button.MouseButton1Click:Connect(function()
    State.infiniteJumpActive = not State.infiniteJumpActive
    toggleSwitch(infiniteJumpSwitch, State.infiniteJumpActive)
    
    if State.infiniteJumpActive then
        showNotification("Infinite Jump Enabled", COLOR_YELLOW)
    else
        if State.infiniteJumpConnection then
            State.infiniteJumpConnection:Disconnect()
            State.infiniteJumpConnection = nil
        end
        showNotification("Infinite Jump Disabled", COLOR_YELLOW)
    end
end)

-- Jump Boost Switch
local jumpBoostSwitch = getSlider("jumpBoostSwitch")
jumpBoostSwitch.button.MouseButton1Click:Connect(function()
    State.jumpBoostActive = not State.jumpBoostActive
    toggleSwitch(jumpBoostSwitch, State.jumpBoostActive)
    
    if State.jumpBoostActive then
        showNotification("Jump Boost Enabled", COLOR_YELLOW)
    else
        if State.jumpBoostConnection then
            State.jumpBoostConnection:Disconnect()
            State.jumpBoostConnection = nil
        end
        showNotification("Jump Boost Disabled", COLOR_YELLOW)
    end
end)

-- Medusa in Range Switch
medusaSwitch.button.MouseButton1Click:Connect(function()
    State.medusaEnabled = not State.medusaEnabled
    toggleSwitch(medusaSwitch, State.medusaEnabled)
    
    if State.medusaEnabled then
        startMedusaInRange()
        showNotification("Medusa in Range Enabled", COLOR_YELLOW)
    else
        stopMedusaInRange()
        showNotification("Medusa in Range Disabled", COLOR_YELLOW)
    end
end)

-- Spin Bot Switch
spinBotSwitch.button.MouseButton1Click:Connect(function()
    State.spinBotEnabled = not State.spinBotEnabled
    toggleSwitch(spinBotSwitch, State.spinBotEnabled)
    
    updateSpinBotSystem()
    showNotification(State.spinBotEnabled and "Spin Bot Enabled" or "Spin Bot Disabled", COLOR_YELLOW)
end)

-- Bat Aimbot Switch - UPDATED
batAimbotSwitch.button.MouseButton1Click:Connect(function()
    State.batAimbotEnabled = not State.batAimbotEnabled
    toggleSwitch(batAimbotSwitch, State.batAimbotEnabled)
    
    if State.batAimbotEnabled then
        showNotification("Bat Aimbot Enabled - Character rotation only", COLOR_YELLOW)
    else
        cleanupBatAimbot()
        showNotification("Bat Aimbot Disabled", COLOR_YELLOW)
    end
end)

-- Highest ESP Switch
highestEspSwitch.button.MouseButton1Click:Connect(function()
    State.highestEspActive = not State.highestEspActive
    toggleSwitch(highestEspSwitch, State.highestEspActive)
    
    if State.highestEspActive then
        highestEspStart()
        showNotification("Highest ESP Enabled", COLOR_YELLOW)
    else
        highestEspStop()
        showNotification("Highest ESP Disabled", COLOR_YELLOW)
    end
end)

local isMobile = UserInputService.TouchEnabled

if isMobile then
    local mobilePanel = Instance.new("Frame")
    mobilePanel.Size = UDim2.new(0, 250, 0, 350)
    mobilePanel.Position = UDim2.new(1, -260, 1, -360)
    mobilePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mobilePanel.BackgroundTransparency = 0.2
    mobilePanel.BorderSizePixel = 0
    mobilePanel.Parent = mainContainer
    
    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0, 10)
    mobileCorner.Parent = mobilePanel
    
    local mobileTitle = Instance.new("TextLabel")
    mobileTitle.Size = UDim2.new(1, 0, 0, 30)
    mobileTitle.BackgroundTransparency = 1
    mobileTitle.Text = "MOBILE CONTROLS"
    mobileTitle.Font = Enum.Font.GothamBold
    mobileTitle.TextSize = 14
    mobileTitle.TextColor3 = COLOR_YELLOW
    mobileTitle.Parent = mobilePanel
    
    local mobileScroll = Instance.new("ScrollingFrame")
    mobileScroll.Size = UDim2.new(1, -10, 1, -40)
    mobileScroll.Position = UDim2.new(0, 5, 0, 35)
    mobileScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mobileScroll.BackgroundTransparency = 0.5
    mobileScroll.BorderSizePixel = 0
    mobileScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
    mobileScroll.ScrollBarThickness = 6
    mobileScroll.Parent = mobilePanel
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 6)
    scrollCorner.Parent = mobileScroll
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 6)
    scrollLayout.Parent = mobileScroll
    
    -- Mobile button data: {label, toggle_var, switch_obj, enable_func, disable_func}
    local mobileButtons = {
        {label = "Bat Aimbot (Z)", var = "batAimbotEnabled", switch = batAimbotSwitch},
        {label = "Paintball (X)", var = "paintballSpamActive", func_on = startPaintballSpam, func_off = stopPaintballSpam},
        {label = "Highest ESP (C)", var = "highestEspActive", switch = highestEspSwitch, func_on = highestEspStart, func_off = highestEspStop},
        {label = "Helicopter (H)", var = "helicopterActive", func_on = function() enableHelicopter() end, func_off = function() disableHelicopter() end},
        {label = "ESP (E)", var = "espActive", func_on = createUndetectableESP, func_off = removeESP},
        {label = "Auto Steal (V)", var = "autoStealActive"},
        {label = "Stealing Speed (T)", var = "stealingSpeedEnabled", switch = stealingSpeedSwitch, func_on = enableStealingSpeedBoost, func_off = disableStealingSpeedBoost},
        {label = "Medusa (M)", var = "medusaEnabled"},
        {label = "SpinBot (S)", var = "spinBotEnabled"},
        {label = "Anti-Ragdoll (R)", var = "antiRagdollEnabled"},
        {label = "Optimizer (O)", var = "optimizerActive", func_on = function() OPTIMIZER.Enable() end, func_off = function() OPTIMIZER.Disable() end},
        {label = "X-Ray (K)", var = "xrayEnabled", func_on = enableXray, func_off = disableXray},
        {label = "Player Follower (L)", var = "playerFollowerActive", func_on = startPlayerFollower, func_off = stopPlayerFollower},
    }
    
    for _, btn_data in ipairs(mobileButtons) do
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(1, -10, 0, 40)
        btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btnFrame.BorderSizePixel = 0
        btnFrame.Parent = mobileScroll
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btnFrame
        
        local btnLabel = Instance.new("TextLabel")
        btnLabel.Size = UDim2.new(0.6, -5, 1, 0)
        btnLabel.Position = UDim2.new(0, 5, 0, 0)
        btnLabel.BackgroundTransparency = 1
        btnLabel.Text = btn_data.label
        btnLabel.Font = Enum.Font.Gotham
        btnLabel.TextSize = 12
        btnLabel.TextColor3 = COLOR_WHITE
        btnLabel.TextXAlignment = Enum.TextXAlignment.Left
        btnLabel.Parent = btnFrame
        
        local btnToggle = Instance.new("TextButton")
        btnToggle.Size = UDim2.new(0.35, -5, 1, -8)
        btnToggle.Position = UDim2.new(0.6, 5, 0, 4)
        btnToggle.BackgroundColor3 = COLOR_YELLOW_DARK
        btnToggle.BackgroundTransparency = 0.4
        btnToggle.BorderSizePixel = 0
        btnToggle.Text = "OFF"
        btnToggle.Font = Enum.Font.GothamBold
        btnToggle.TextSize = 11
        btnToggle.TextColor3 = COLOR_RED
        btnToggle.Parent = btnFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 4)
        toggleCorner.Parent = btnToggle
        
        -- Get the variable
        local var_name = btn_data.var
        
        -- Click handler
        btnToggle.MouseButton1Click:Connect(function()
            -- Toggle the variable
            if var_name == "batAimbotEnabled" then
                State.batAimbotEnabled = not State.batAimbotEnabled
                if btn_data.switch then toggleSwitch(btn_data.switch, State.batAimbotEnabled) end
                if State.batAimbotEnabled then
                    batAimbotConnection = RunService.Heartbeat:Connect(applyBatAimbot)
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    if batAimbotConnection then batAimbotConnection:Disconnect() end
                    cleanupBatAimbot()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "paintballSpamActive" then
                State.paintballSpamActive = not State.paintballSpamActive
                if State.paintballSpamActive then
                    startPaintballSpam()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    stopPaintballSpam()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "highestEspActive" then
                State.highestEspActive = not State.highestEspActive
                if btn_data.switch then toggleSwitch(btn_data.switch, State.highestEspActive) end
                if State.highestEspActive then
                    highestEspStart()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    highestEspStop()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "helicopterActive" then
                State.helicopterActive = not State.helicopterActive
                if State.helicopterActive then
                    enableHelicopter()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    disableHelicopter()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "espActive" then
                State.espActive = not State.espActive
                if State.espActive then
                    createUndetectableESP()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    removeESP()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "optimizerActive" then
                State.optimizerActive = not State.optimizerActive
                if State.optimizerActive then
                    OPTIMIZER.Enable()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    OPTIMIZER.Disable()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "xrayEnabled" then
                State.xrayEnabled = not State.xrayEnabled
                if State.xrayEnabled then
                    enableXray()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    disableXray()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            elseif var_name == "playerFollowerActive" then
                State.playerFollowerActive = not State.playerFollowerActive
                if State.playerFollowerActive then
                    startPlayerFollower()
                    btnToggle.Text = "ON"
                    btnToggle.TextColor3 = COLOR_GREEN
                else
                    stopPlayerFollower()
                    btnToggle.Text = "OFF"
                    btnToggle.TextColor3 = COLOR_RED
                end
            else
                -- Generic toggle for others
                _G[var_name] = not _G[var_name]
                btnToggle.Text = _G[var_name] and "ON" or "OFF"
                btnToggle.TextColor3 = _G[var_name] and COLOR_GREEN or COLOR_RED
            end
        end)
    end
end

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    
    -- Clean up bat aimbot angular velocity on character respawn
    if batAimbotAngularVelocity and batAimbotAngularVelocity.Parent then
        batAimbotAngularVelocity:Destroy()
        batAimbotAngularVelocity = nil
    end
    
    -- Apply saved slider values on character spawn
    if State.boosterActive then
        enableBooster()
    end
    
    if State.autoBatActive then
        enableAutoBat()
    end
    
    if State.espActive then
        createUndetectableESP()
    end
    
    if State.optimizerActive then
        OPTIMIZER.Enable()
    end
    
    if State.antiBeeDiscoEnabled then
        enableAntiBeeDisco()
    end
    
    if State.xrayEnabled then
        enableXray()
    end
    
    -- Anti-ragdoll initialization
    if State.antiRagdollEnabled then
        -- Cache character data
        cachedCharData.hrp = char:FindFirstChild("HumanoidRootPart")
        cachedCharData.humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if cachedCharData.hrp and cachedCharData.humanoid then
            setupAntiRagdoll()
        end
    end
    
    if State.autoStealNearestEnabled then
        startAutoStealNearest()
    end
    
    if State.medusaEnabled then
        startMedusaInRange()
    end
    
    if State.spinBotEnabled then
        updateSpinBotSystem()
    end
    
    if State.batAimbotEnabled then
        -- Bat aimbot will be applied in the main loop
    end
    
    if State.paintballSpamActive then
        forceEquipPaintballGun()
    end
    
    if State.highestEspActive then
        highestEspStart()
    end
end)

RunService.Heartbeat:Connect(function()
    -- Update bat aimbot
    if State.batAimbotEnabled then
        applyBatAimbot()
    end
    
    -- Update spin bot
    if State.spinBotEnabled then
        updateSpinBotSystem()
    end
    
    -- Update anti bee/disco
    if State.antiBeeDiscoEnabled then
        enableAntiBeeDisco()
    end
    
    -- Update xray
    if State.xrayEnabled then
        enableXray()
    end
    
    -- Infinite Jump
    if State.infiniteJumpActive and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Landed)
        end
    end
    
    -- Jump Boost
    if State.jumpBoostActive and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum:GetState() == Enum.HumanoidStateType.Jumping then
            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, State.jumpBoostPower / 10, 0)
        end
    end
    
    -- Anti-ragdoll initialization
    -- Anti-ragdoll initialization
    if State.antiRagdollEnabled then
        -- Use the BKS anti-ragdoll system
        ANTI_RAGDOLL.Enable("v1")
    end
    
    -- Update Highest ESP if active
    if State.highestEspActive and State.highestEspUpdateConnection then
        highestEspRefreshAllData()
        highestEspRecompute()
    end
end)

-- Clean up bat aimbot when disabled
batAimbotSwitch.button.MouseButton1Click:Connect(function()
    if not State.batAimbotEnabled then
        cleanupBatAimbot()
    end
end)

-- Apply settings on script start
task.wait(1) -- Wait for character to load
if State.boosterActive then
    enableBooster()
end

task.defer(function()
    local rootFrame = gui:FindFirstChildWhichIsA("Frame")
    if not rootFrame then return end

    -- Remove existing scale to avoid stacking
    local oldScale = rootFrame:FindFirstChildOfClass("UIScale")
    if oldScale then
        oldScale:Destroy()
    end

    -- Apply scale (0.82 = 18% smaller)
    local scale = Instance.new("UIScale")
    scale.Scale = 0.82
    scale.Parent = rootFrame
end)

local function handleKeybindPress(featureName)
    if featureName == "BatAimbot" then
        State.batAimbotEnabled = not State.batAimbotEnabled
        if batAimbotSwitch then
            toggleSwitch(batAimbotSwitch, State.batAimbotEnabled)
        end
        if State.batAimbotEnabled then
            batAimbotConnection = RunService.Heartbeat:Connect(applyBatAimbot)
        else
            if batAimbotConnection then batAimbotConnection:Disconnect() end
            cleanupBatAimbot()
        end
        showNotification("Bat Aimbot " .. (State.batAimbotEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "PaintballSpam" then
        State.paintballSpamActive = not State.paintballSpamActive
        if State.paintballSpamActive then
            startPaintballSpam()
        else
            stopPaintballSpam()
        end
        
    elseif featureName == "HighestESP" then
        State.highestEspActive = not State.highestEspActive
        if highestEspSwitch then
            toggleSwitch(highestEspSwitch, State.highestEspActive)
        end
        if State.highestEspActive then
            highestEspStart()
        else
            highestEspStop()
        end
        showNotification("Highest ESP " .. (State.highestEspActive and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "Helicopter" then
        State.helicopterActive = not State.helicopterActive
        if State.helicopterActive then
            enableHelicopter()
        else
            disableHelicopter()
        end
        showNotification("Helicopter " .. (State.helicopterActive and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "ESP" then
        State.espActive = not State.espActive
        if State.espActive then
            createUndetectableESP()
        else
            removeESP()
        end
        showNotification("ESP " .. (State.espActive and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "Medusa" then
        State.medusaEnabled = not State.medusaEnabled
        if State.medusaEnabled then
            State.medusaConnection = RunService.Heartbeat:Connect(function()
                if State.medusaEnabled then
                    local medusa = findMedusa()
                    local target = getClosestPlayer()
                    if medusa and target and (getHRP().Position - target.Character.HumanoidRootPart.Position).Magnitude < State.medusaRange then
                        medusa.Parent = player.Character
                    end
                end
            end)
        else
            if State.medusaConnection then State.medusaConnection:Disconnect() end
        end
        showNotification("Medusa " .. (State.medusaEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "SpinBot" then
        State.spinBotEnabled = not State.spinBotEnabled
        updateSpinBotSystem()
        showNotification("SpinBot " .. (State.spinBotEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "AntiRagdoll" then
        State.antiRagdollEnabled = not State.antiRagdollEnabled
        showNotification("Anti-Ragdoll " .. (State.antiRagdollEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "Optimizer" then
        State.optimizerActive = not State.optimizerActive
        if State.optimizerActive then
            OPTIMIZER.Enable()
        else
            OPTIMIZER.Disable()
        end
        showNotification("Optimizer " .. (State.optimizerActive and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "XRay" then
        State.xrayEnabled = not State.xrayEnabled
        if State.xrayEnabled then
            enableXray()
        else
            disableXray()
        end
        showNotification("X-Ray " .. (State.xrayEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "AntiBeeDisc" then
        antiBeeDiscEnabled = not antiBeeDiscEnabled
        showNotification("Anti-Bee Disc " .. (antiBeeDiscEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "AutoSteal" then
        State.autoStealActive = not State.autoStealActive
        if State.autoStealActive then
            if autoStealCheckbox then
                autoStealCheckbox.MouseButton1Click:Fire()
            end
        else
            if autoStealLoop then autoStealLoop:Disconnect() end
        end
        showNotification("Auto Steal " .. (State.autoStealActive and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "StealingSpeed" then
        State.stealingSpeedEnabled = not State.stealingSpeedEnabled
        if stealingSpeedSwitch then
            toggleSwitch(stealingSpeedSwitch, State.stealingSpeedEnabled)
        end
        if State.stealingSpeedEnabled then
            enableStealingSpeedBoost()
        else
            disableStealingSpeedBoost()
        end
        showNotification("Stealing Speed Boost " .. (State.stealingSpeedEnabled and "ENABLED" or "DISABLED"), COLOR_YELLOW)
        
    elseif featureName == "PlayerFollower" then
        State.playerFollowerActive = not State.playerFollowerActive
        if State.playerFollowerActive then
            startPlayerFollower()
        else
            stopPlayerFollower()
        end
        showNotification("Player Follower " .. (playerFollowerActive and "ENABLED" or "DISABLED"), COLOR_YELLOW)
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        -- Wait for all features to be initialized
        if batAimbotSwitch and paintballSpamActive ~= nil then
            break
        end
    end
    
    -- Setup keybind listener
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        -- Handle keybind rebinding first
        if rebindingFeature and input.UserInputType == Enum.UserInputType.Keyboard then
            local newKey = input.KeyCode
            KeybindManager.keybinds[rebindingFeature] = newKey
            saveSettings()
            
            if rebindingButton then
                rebindingButton.BackgroundTransparency = 0.4
                rebindingButton.Text = tostring(newKey):gsub("Enum.KeyCode.", "")
            end
            
            rebindingFeature = nil
            rebindingButton = nil
            return
        end
        
        if gameProcessed then return end
        
        local keyCode = input.KeyCode
        
        -- Check which feature matches this keybind
        for featureName, bindKey in pairs(KeybindManager.keybinds) do
            if keyCode == bindKey then
                handleKeybindPress(featureName)
                break
            end
        end
    end)
end)

-- Copy discord link to clipboard
task.spawn(function()
    setclipboard("discord.gg/sabscripts")
end)

showNotification("discord.gg/sabscripts", COLOR_YELLOW)

task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- Global notification system
    getgenv().Notify = getgenv().Notify or Instance.new("BindableEvent")

    local function getInternalTable()
        local Packages = ReplicatedStorage:FindFirstChild("Packages")
        if not Packages then return nil end
        
        local SynchronizerModule = Packages:FindFirstChild("Synchronizer")
        if not SynchronizerModule then return nil end
        
        local success, synchronizer = pcall(require, SynchronizerModule)
        if not success or not synchronizer then return nil end
        
        local GetMethod = synchronizer and synchronizer.Get
        if type(GetMethod) ~= "function" then
            return nil
        end
        
        for i = 1, 5 do
            local success, upvalue = pcall(getupvalue, GetMethod, i)
            if success and type(upvalue) == "table" then
                if upvalue.___private or upvalue.___channels or upvalue.___data then
                    return upvalue
                end
                
                for k, v in pairs(upvalue) do
                    if type(k) == "string" and k:match("^Plot_") or type(v) == "table" then
                        return upvalue
                    end
                end
            end
        end
        
        local success, env = pcall(getfenv, GetMethod)
        if success and env and env.self then
            return env.self
        end
        
        return nil
    end

    local SynchronizerInternal = {
        _cache = {},
        _dataTable = nil
    }

    task.spawn(function()
        local attempts = 0
        while attempts < 10 and not SynchronizerInternal._dataTable do
            SynchronizerInternal._dataTable = getInternalTable()
            if not SynchronizerInternal._dataTable then
                task.wait(1)
                attempts = attempts + 1
            end
        end
    end)

    local function stealthGet(plotName)
        if not plotName or type(plotName) ~= "string" then
            return nil
        end
        
        if SynchronizerInternal._cache[plotName] == false then
            return nil
        end
        
        if SynchronizerInternal._dataTable then
            local keys = {
                plotName,
                "Plot_" .. plotName,
                "Plot" .. plotName,
                plotName .. "_Channel",
                "Channel_" .. plotName
            }
            
            for _, key in ipairs(keys) do
                if SynchronizerInternal._dataTable[key] then
                    SynchronizerInternal._cache[plotName] = SynchronizerInternal._dataTable[key]
                    return SynchronizerInternal._dataTable[key]
                end
            end
            
            for k, v in pairs(SynchronizerInternal._dataTable) do
                if type(k) == "string" and (k == plotName or k:find(plotName, 1, true)) then
                    if type(v) == "table" then
                        SynchronizerInternal._cache[plotName] = v
                        return v
                    end
                end
            end
        end
        
        SynchronizerInternal._cache[plotName] = false
        return nil
    end

    local function stealthGetProperty(channel, property)
        if not channel or type(channel) ~= "table" then
            return nil
        end
        
        if channel[property] then
            return channel[property]
        end
        
        if type(channel.Get) == "function" then
            local success, result = pcall(channel.Get, channel, property)
            if success then
                return result
            end
        end
        
        local altNames = {
            Owner = {"owner", "Owner", "plotOwner", "PlotOwner"},
            AnimalList = {"animalList", "AnimalList", "animals", "Animals", "pets"}
        }
        
        if altNames[property] then
            for _, alt in ipairs(altNames[property]) do
                if channel[alt] then
                    return channel[alt]
                end
            end
        end
        
        return nil
    end

    local autoStealEnabled = true
    local selectedTargetIndex = 1
    local currentStealProgress = 0
    local isCurrentlyStealing = false

    local Packages = ReplicatedStorage:WaitForChild("Packages")
    local Datas = ReplicatedStorage:WaitForChild("Datas")
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local Utils = ReplicatedStorage:WaitForChild("Utils")

    local AnimalsData, AnimalsShared, NumberUtils
    task.spawn(function()
        for i = 1, 10 do
            local success1, data = pcall(require, Datas:WaitForChild("Animals"))
            local success2, shared = pcall(require, Shared:WaitForChild("Animals"))
            local success3, utils = pcall(require, Utils:WaitForChild("NumberUtils"))
            
            if success1 and data then
                AnimalsData = data
            end
            if success2 and shared then
                AnimalsShared = shared
            end
            if success3 and utils then
                NumberUtils = utils
            end
            
            if AnimalsData and AnimalsShared and NumberUtils then
                break
            end
            task.wait(0.5)
        end
    end)

    local allAnimalsCache = {}
    local InternalStealCache = {}
    local PromptMemoryCache = {}

    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot then
            return false
        end
        
        local plots = workspace:FindFirstChild("Plots")
        if not plots then
            return false
        end
        
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then
            return false
        end
        
        local channel = stealthGet(plot.Name)
        if channel then
            local owner = stealthGetProperty(channel, "Owner")
            if owner then
                if typeof(owner) == "Instance" and owner:IsA("Player") then
                    return owner.UserId == LocalPlayer.UserId
                elseif typeof(owner) == "table" and owner.UserId then
                    return owner.UserId == LocalPlayer.UserId
                elseif typeof(owner) == "Instance" then
                    return owner == LocalPlayer
                end
            end
        end
        
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yourBase = sign:FindFirstChild("YourBase")
            if yourBase and yourBase:IsA("BillboardGui") then
                return yourBase.Enabled == true
            end
        end
        
        return false
    end

    local function get_top_3_pets()
        local topPets = {}
        
        for _, animalData in ipairs(allAnimalsCache) do
            if not isMyBaseAnimal(animalData) then
                table.insert(topPets, {
                    petName = animalData.name or "Unknown",
                    mpsText = animalData.genText or "$0/s",
                    mpsValue = animalData.genValue or 0,
                    owner = animalData.owner or "Unknown",
                    plot = animalData.plot or "Unknown",
                    slot = animalData.slot or "1",
                    uid = animalData.uid or "",
                    mutation = animalData.mutation or "None",
                    animalData = animalData
                })
            end
            
            if #topPets >= 3 then
                break
            end
        end
        
        return topPets
    end

    local function findProximityPromptForAnimal(animalData)
        if not animalData then return nil end
        
        local cachedPrompt = PromptMemoryCache[animalData.uid]
        if cachedPrompt and cachedPrompt.Parent then
            return cachedPrompt
        end
        
        local plot = workspace.Plots:FindFirstChild(animalData.plot)
        if not plot then return nil end
        
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        
        local podium = podiums:FindFirstChild(animalData.slot)
        if not podium then return nil end
        
        local base = podium:FindFirstChild("Base")
        if not base then return nil end
        
        local spawn = base:FindFirstChild("Spawn")
        if not spawn then return nil end
        
        local attach = spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        
        for _, p in ipairs(attach:GetChildren()) do
            if p:IsA("ProximityPrompt") then
                PromptMemoryCache[animalData.uid] = p
                return p
            end
        end
        
        return nil
    end

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        
        local data = {
            holdCallbacks = {},
            triggerCallbacks = {},
            ready = true,
        }
        
        local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if ok1 and type(conns1) == "table" then
            for _, conn in ipairs(conns1) do
                if type(conn.Function) == "function" then
                    table.insert(data.holdCallbacks, conn.Function)
                end
            end
        end
        
        local ok2, conns2 = pcall(getconnections, prompt.Triggered)
        if ok2 and type(conns2) == "table" then
            for _, conn in ipairs(conns2) do
                if type(conn.Function) == "function" then
                    table.insert(data.triggerCallbacks, conn.Function)
                end
            end
        end
        
        if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
            InternalStealCache[prompt] = data
        end
    end

    local function runCallbackList(list)
        for _, fn in ipairs(list) do
            task.spawn(fn)
        end
    end

    local function executeInternalStealAsync(prompt)
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        
        data.ready = false
        
        isCurrentlyStealing = true
        local startTime = tick()
        local stealDuration = 1.57
        
        task.spawn(function()
            if #data.holdCallbacks > 0 then
                runCallbackList(data.holdCallbacks)
            end
            
            while tick() - startTime < stealDuration do
                local progress = (tick() - startTime) / stealDuration
                currentStealProgress = math.clamp(progress * 100, 0, 100)
                task.wait(0.01)
            end

            local maxWait = 1
            local waited = 0

            local function getPromptPosition()
                if not prompt or not prompt.Parent then return nil end
                local parent = prompt.Parent
                if parent:IsA("Attachment") and parent.WorldPosition then
                    return parent.WorldPosition
                elseif parent:IsA("BasePart") and parent.Position then
                    return parent.Position
                elseif parent.WorldPosition then
                    return parent.WorldPosition
                end
                return nil
            end

            local hrp = nil
            if LocalPlayer and LocalPlayer.Character then
                hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end

            while waited < maxWait do
                task.wait(0.05)
                waited = waited + 0.05

                if not hrp or not hrp.Parent then
                    if LocalPlayer and LocalPlayer.Character then
                        hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    end
                end

                local promptPos = getPromptPosition()
                if hrp and promptPos then
                    if (hrp.Position - promptPos).Magnitude <= 3 then
                        break
                    end
                end
                if not prompt or not prompt.Parent then
                    break
                end
            end
            task.wait(0.1)
            getgenv().Notify:Fire("OK")
            if #data.triggerCallbacks > 0 then
                runCallbackList(data.triggerCallbacks)
            end
            
            data.ready = true
            isCurrentlyStealing = false
            currentStealProgress = 0
        end)
        
        return true
    end

    local function attemptSteal(prompt)
        if not prompt or not prompt.Parent then
            return false
        end
        
        buildStealCallbacks(prompt)
        if not InternalStealCache[prompt] then
            return false
        end
        
        return executeInternalStealAsync(prompt)
    end

    local function prebuildStealCallbacks()
        for uid, prompt in pairs(PromptMemoryCache) do
            if prompt and prompt.Parent then
                buildStealCallbacks(prompt)
            end
        end
    end

    task.spawn(function()
        while task.wait(2) do
            if autoStealEnabled then
                prebuildStealCallbacks()
            end
        end
    end)

    local plotChannels = {}
    local lastAnimalData = {}
    local scannerConnections = {}

    local function getAnimalHash(animalList)
        if not animalList then return "" end
        local hash = ""
        for slot, data in pairs(animalList) do
            if type(data) == "table" then
                hash = hash .. tostring(slot) .. tostring(data.Index) .. tostring(data.Mutation)
            end
        end
        return hash
    end

    local function scanSinglePlot(plot)
        pcall(function()        
            local plotUID = plot.Name
            local channel = stealthGet(plotUID)
            if not channel then return end
            
            local animalList = stealthGetProperty(channel, "AnimalList")
            local currentHash = getAnimalHash(animalList)
            if lastAnimalData[plotUID] == currentHash then
                return
            end
            lastAnimalData[plotUID] = currentHash
            
            for i = #allAnimalsCache, 1, -1 do
                if allAnimalsCache[i].plot == plot.Name then
                    table.remove(allAnimalsCache, i)
                end
            end
            
            local owner = stealthGetProperty(channel, "Owner")
            if not owner or not Players:FindFirstChild(owner.Name) then
                for i = #allAnimalsCache, 1, -1 do
                    if allAnimalsCache[i].plot == plot.Name then
                        table.remove(allAnimalsCache, i)
                    end
                end
                return
            end
            
            local ownerName = owner and owner.Name or "Unknown"
            if not animalList then return end
            
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local animalInfo = AnimalsData[animalName]
                    if not animalInfo then continue end
                    
                    local mutation = animalData.Mutation or "None"
                    local traits = (animalData.Traits and #animalData.Traits > 0) and table.concat(animalData.Traits, ", ") or "None"
                    
                    local genValue = AnimalsShared:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil)
                    local genText = "$" .. NumberUtils:ToString(genValue) .. "/s"
                    
                    table.insert(allAnimalsCache, {
                        name = animalInfo.DisplayName or animalName,
                        genText = genText,
                        genValue = genValue,
                        mutation = mutation,
                        traits = traits,
                        owner = ownerName,
                        plot = plot.Name,
                        slot = tostring(slot),
                        uid = plot.Name .. "_" .. tostring(slot),
                    })
                end
            end
            
            table.sort(allAnimalsCache, function(a, b)
                return a.genValue > b.genValue
            end)
        end)
    end

    local function setupPlotListener(plot)
        if plotChannels[plot.Name] then return end
        
        local channel
        local retries = 0
        local maxRetries = 3
        
        while not channel and retries < maxRetries do
            channel = stealthGet(plot.Name)
            if channel then
                break
            else
                retries = retries + 1
                if retries < maxRetries then
                    task.wait(0.3)
                end
            end
        end
        
        if not channel then return end
        plotChannels[plot.Name] = true
        
        scanSinglePlot(plot)
        
        local c1 = plot.DescendantAdded:Connect(function()
            task.wait(0.05)
            scanSinglePlot(plot)
        end)
        table.insert(scannerConnections, c1)
        
        local c2 = plot.DescendantRemoving:Connect(function()
            task.wait(0.05)
            scanSinglePlot(plot)
        end)
        table.insert(scannerConnections, c2)
        
        local c3 = task.spawn(function()
            while plot.Parent and plotChannels[plot.Name] do
                task.wait(3)
                scanSinglePlot(plot)
            end
        end)
        table.insert(scannerConnections, c3)
    end

    local function initializePlotScanner()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then
            for i = 1, 30 do
                plots = workspace:FindFirstChild("Plots")
                if plots then break end
                task.wait(0.5)
            end
            if not plots then
                return
            end
        end
        
        for _, plot in ipairs(plots:GetChildren()) do
            task.spawn(setupPlotListener, plot)
        end
        
        local newPlotConnection = plots.ChildAdded:Connect(function(plot)
            task.wait(0.2)
            task.spawn(setupPlotListener, plot)
        end)
        table.insert(scannerConnections, newPlotConnection)
        
        local removedPlotConnection = plots.ChildRemoved:Connect(function(plot)
            plotChannels[plot.Name] = nil
            lastAnimalData[plot.Name] = nil
            
            for i = #allAnimalsCache, 1, -1 do
                if allAnimalsCache[i].plot == plot.Name then
                    table.remove(allAnimalsCache, i)
                end
            end
        end)
        table.insert(scannerConnections, removedPlotConnection)
    end

    local screenGui, frame, statusLabel, targetLabel, petButtons, toggleButton, stealStatusLabel
    local progressScreenGui, progressBarContainer, progressBarFill, progressBarText

    local function createProgressBarGUI()
        if progressScreenGui and progressScreenGui.Parent then
            progressScreenGui:Destroy()
        end
        
        progressScreenGui = Instance.new("ScreenGui")
        progressScreenGui.Name = "AutoStealProgressUI"
        progressScreenGui.ResetOnSpawn = false
        progressScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        progressScreenGui.DisplayOrder = 101
        progressScreenGui.IgnoreGuiInset = true
        
        progressBarContainer = Instance.new("Frame")
        progressBarContainer.Size = UDim2.new(0, 200, 0, 20)
        progressBarContainer.Position = UDim2.new(0.5, -100, 0.9, 0)
        progressBarContainer.AnchorPoint = Vector2.new(0.5, 0)
        progressBarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        progressBarContainer.BackgroundTransparency = 0.3
        progressBarContainer.BorderSizePixel = 0
        progressBarContainer.Visible = true
        progressBarContainer.Parent = progressScreenGui
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = progressBarContainer
        
        local containerStroke = Instance.new("UIStroke")
        containerStroke.Color = Color3.fromRGB(100, 100, 100)
        containerStroke.Thickness = 1
        containerStroke.Transparency = 0.5
        containerStroke.Parent = progressBarContainer
        
        progressBarFill = Instance.new("Frame")
        progressBarFill.Size = UDim2.new(0, 0, 1, 0)
        progressBarFill.Position = UDim2.new(0, 2, 0, 0)
        progressBarFill.AnchorPoint = Vector2.new(0, 0)
        progressBarFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        progressBarFill.BorderSizePixel = 0
        progressBarFill.Parent = progressBarContainer
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 6)
        fillCorner.Parent = progressBarFill
        
        progressBarText = Instance.new("TextLabel")
        progressBarText.Size = UDim2.new(1, 0, 1, 0)
        progressBarText.Position = UDim2.new(0, 0, 0, 0)
        progressBarText.BackgroundTransparency = 1
        progressBarText.Text = "Steal Progress: 0%"
        progressBarText.Font = Enum.Font.GothamBold
        progressBarText.TextSize = 12
        progressBarText.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressBarText.TextStrokeTransparency = 0.5
        progressBarText.ZIndex = 2
        progressBarText.Parent = progressBarContainer
        
        if UserInputService.TouchEnabled then
            local progressToggleButton = Instance.new("TextButton")
            progressToggleButton.Size = UDim2.new(0, 20, 0, 20)
            progressToggleButton.Position = UDim2.new(1, 2, 0, 0)
            progressToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            progressToggleButton.BackgroundTransparency = 0.3
            progressToggleButton.BorderSizePixel = 0
            progressToggleButton.Text = "▼"
            progressToggleButton.Font = Enum.Font.GothamBold
            progressToggleButton.TextSize = 10
            progressToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            progressToggleButton.Parent = progressBarContainer
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = progressToggleButton
            
            progressToggleButton.MouseButton1Click:Connect(function()
                progressBarContainer.Visible = not progressBarContainer.Visible
                progressToggleButton.Text = progressBarContainer.Visible and "▼" or "▲"
            end)
        end
        
        progressScreenGui.Parent = PlayerGui
    end

    local function createMobileGUI()
        if not PlayerGui then
            for i = 1, 30 do
                PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if PlayerGui then break end
                task.wait(0.5)
            end
            if not PlayerGui then
                return false
            end
        end
        
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
        
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AutoStealUI_Mobile"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.DisplayOrder = 100
        screenGui.IgnoreGuiInset = true
        
        local isMobile = UserInputService.TouchEnabled
        local frameWidth = isMobile and 250 or 230
        local frameHeight = isMobile and 190 or 170
        
        frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
        frame.Position = UDim2.new(0.5, -frameWidth/2, 0.05, 0)
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        frame.ZIndex = 100
        frame.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(180, 0, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.5
        stroke.Parent = frame

        if not isMobile then
            local dragging = false
            local dragInput, mousePos, framePos

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    mousePos = input.Position
                    framePos = frame.Position
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)

            frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - mousePos
                    frame.Position = UDim2.new(
                        framePos.X.Scale,
                        framePos.X.Offset + delta.X,
                        framePos.Y.Scale,
                        framePos.Y.Offset + delta.Y
                    )
                end
            end)
        end

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -10, 0, 20)
        titleLabel.Position = UDim2.new(0, 5, 0, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "Titanz Auto Steal"
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = isMobile and 12 or 14
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 101
        titleLabel.Parent = frame

        local titleGradient = Instance.new("UIGradient")
        titleGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
        titleGradient.Parent = titleLabel

        statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(0, 60, 0, 18)
        statusLabel.Position = UDim2.new(1, -65, 0, 4)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "ON"
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = isMobile and 10 or 12
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusLabel.TextXAlignment = Enum.TextXAlignment.Right
        statusLabel.ZIndex = 101
        statusLabel.Parent = frame

        targetLabel = Instance.new("TextLabel")
        targetLabel.Size = UDim2.new(1, -10, 0, 18)
        targetLabel.Position = UDim2.new(0, 5, 0, 28)
        targetLabel.BackgroundTransparency = 1
        targetLabel.Text = "Current: Searching..."
        targetLabel.Font = Enum.Font.GothamBold
        targetLabel.TextSize = isMobile and 9 or 11
        targetLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.TextTruncate = Enum.TextTruncate.AtEnd
        targetLabel.ZIndex = 101
        targetLabel.Parent = frame

        stealStatusLabel = Instance.new("TextLabel")
        stealStatusLabel.Size = UDim2.new(1, -10, 0, 16)
        stealStatusLabel.Position = UDim2.new(0, 5, 0, 50)
        stealStatusLabel.BackgroundTransparency = 1
        stealStatusLabel.Text = "Steal: Ready (See progress bar below)"
        stealStatusLabel.Font = Enum.Font.GothamBold
        stealStatusLabel.TextSize = isMobile and 8 or 10
        stealStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        stealStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        stealStatusLabel.ZIndex = 101
        stealStatusLabel.Parent = frame

        local top3Label = Instance.new("TextLabel")
        top3Label.Size = UDim2.new(1, -10, 0, 16)
        top3Label.Position = UDim2.new(0, 5, 0, 70)
        top3Label.BackgroundTransparency = 1
        top3Label.Text = "Select:"
        top3Label.Font = Enum.Font.GothamBold
        top3Label.TextSize = isMobile and 8 or 10
        top3Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        top3Label.TextXAlignment = Enum.TextXAlignment.Left
        top3Label.ZIndex = 101
        top3Label.Parent = frame
        
        petButtons = {}
        
        local buttonHeight = isMobile and 24 or 22
        local buttonSpacing = isMobile and 28 or 26
        local startY = 90

        for i = 1, 3 do
            local petButton = Instance.new("TextButton")
            petButton.Size = UDim2.new(0, frameWidth - 20, 0, buttonHeight)
            petButton.Position = UDim2.new(0, 10, 0, startY + (i - 1) * buttonSpacing)
            petButton.BackgroundColor3 = Color3.fromRGB(15, 0, 15)
            petButton.BackgroundTransparency = 0.15
            petButton.BorderSizePixel = 0
            petButton.Text = string.format("#%d: ...", i)
            petButton.Font = Enum.Font.Gotham
            petButton.TextSize = isMobile and 8 or 10
            petButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            petButton.AutoButtonColor = false
            petButton.TextXAlignment = Enum.TextXAlignment.Left
            petButton.ZIndex = 101
            petButton.Parent = frame
            
            local petCorner = Instance.new("UICorner")
            petCorner.CornerRadius = UDim.new(0, 4)
            petCorner.Parent = petButton
            
            local petStroke = Instance.new("UIStroke")
            petStroke.Color = Color3.fromRGB(100, 100, 100)
            petStroke.Thickness = 1
            petStroke.Transparency = 0.7
            petStroke.Parent = petButton
            
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 3)
            padding.Parent = petButton
            
            petButtons[i] = {
                button = petButton,
                stroke = petStroke,
                index = i
            }
            
            if not isMobile then
                petButton.MouseEnter:Connect(function()
                    if selectedTargetIndex ~= i then
                        petButton.BackgroundTransparency = 0.05
                        petStroke.Transparency = 0.5
                    end
                end)
                
                petButton.MouseLeave:Connect(function()
                    if selectedTargetIndex ~= i then
                        petButton.BackgroundTransparency = 0.15
                        petStroke.Transparency = 0.7
                    end
                end)
            end
            
            petButton.MouseButton1Click:Connect(function()
                selectedTargetIndex = i
                
                for j, btn in ipairs(petButtons) do
                    if j == selectedTargetIndex then
                        btn.button.TextColor3 = Color3.fromRGB(100, 255, 100)
                        btn.stroke.Color = Color3.fromRGB(100, 255, 100)
                        btn.stroke.Transparency = 0.3
                    else
                        btn.button.TextColor3 = Color3.fromRGB(200, 200, 200)
                        btn.stroke.Color = Color3.fromRGB(100, 100, 100)
                        btn.stroke.Transparency = 0.7
                    end
                end
                
                local topPets = get_top_3_pets()
                if topPets[selectedTargetIndex] then
                    local currentPet = topPets[selectedTargetIndex]
                    targetLabel.Text = string.format("Current: %s", currentPet.petName)
                else
                    targetLabel.Text = "Current: None"
                end
            end)
        end

        toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, frameWidth - 20, 0, 28)
        toggleButton.Position = UDim2.new(0, 10, 0, startY + 3 * buttonSpacing)
        toggleButton.BackgroundColor3 = Color3.fromRGB(15, 0, 15)
        toggleButton.BackgroundTransparency = 0.15
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = "Disable"
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = isMobile and 10 or 12
        toggleButton.TextColor3 = Color3.fromRGB(230, 175, 255)
        toggleButton.AutoButtonColor = false
        toggleButton.ZIndex = 101
        toggleButton.Parent = frame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = toggleButton

        local buttonGradient = Instance.new("UIGradient")
        buttonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 255))
        }
        buttonGradient.Parent = toggleButton

        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(180, 0, 255)
        buttonStroke.Thickness = 1
        buttonStroke.Transparency = 0.5
        buttonStroke.Parent = toggleButton
        
        for i, btn in ipairs(petButtons) do
            if i == selectedTargetIndex then
                btn.button.TextColor3 = Color3.fromRGB(100, 255, 100)
                btn.stroke.Color = Color3.fromRGB(100, 255, 100)
                btn.stroke.Transparency = 0.3
            else
                btn.button.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.stroke.Color = Color3.fromRGB(100, 100, 100)
                btn.stroke.Transparency = 0.7
            end
        end
        
        if isMobile then
            local closeButton = Instance.new("TextButton")
            closeButton.Size = UDim2.new(0, 25, 0, 25)
            closeButton.Position = UDim2.new(1, -30, 0, 2)
            closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            closeButton.BackgroundTransparency = 0.3
            closeButton.BorderSizePixel = 0
            closeButton.Text = "X"
            closeButton.Font = Enum.Font.GothamBold
            closeButton.TextSize = 12
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.ZIndex = 101
            closeButton.Parent = frame
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 4)
            closeCorner.Parent = closeButton
            
            closeButton.MouseButton1Click:Connect(function()
                frame.Visible = not frame.Visible
                closeButton.Text = frame.Visible and "X" or "O"
            end)
        end
        
        screenGui.Parent = PlayerGui
        
        return true
    end

    local lastProgressUpdate = tick()
    local lastProgressValue = 0

    local function updateProgressBar()
        if not progressBarFill or not progressBarText then
            return
        end
        
        local now = tick()
        
        if now - lastProgressUpdate > 0.01 then
            local targetWidth = math.clamp(currentStealProgress, 0, 100)
            local smoothedWidth = lastProgressValue + (targetWidth - lastProgressValue) * 0.3
            local fillWidth = math.max(0, smoothedWidth)
            progressBarFill.Size = UDim2.new(fillWidth / 100, -4, 1, -4)
            progressBarText.Text = string.format("", fillWidth)
            
            if fillWidth < 30 then
                progressBarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                progressBarText.TextColor3 = Color3.fromRGB(255, 150, 150)
            elseif fillWidth < 70 then
                progressBarFill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                progressBarText.TextColor3 = Color3.fromRGB(255, 255, 150)
            else
                progressBarFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                progressBarText.TextColor3 = Color3.fromRGB(150, 255, 150)
            end
            
            if isCurrentlyStealing then
                progressBarContainer.Visible = true
                progressBarText.TextStrokeTransparency = 0.3
            else
                progressBarText.TextStrokeTransparency = 0.5
                if fillWidth <= 0 then
                    progressBarText.Text = ""
                    progressBarFill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    progressBarFill.Size = UDim2.new(0, 0, 1, -4)
                end
            end
            
            lastProgressValue = smoothedWidth
            lastProgressUpdate = now
        end
    end

    local function updateUI(enabled, topPets)
        if not statusLabel or not targetLabel or not toggleButton then
            return
        end
        
        autoStealEnabled = enabled
        
        if enabled then
            statusLabel.Text = "ON"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            if frame and frame:FindFirstChild("UIStroke") then
                frame.UIStroke.Color = Color3.fromRGB(100, 255, 100)
                frame.UIStroke.Transparency = 0.3
            end
            
            toggleButton.Text = "Disable"
            
            if topPets and type(topPets) == "table" and petButtons then
                for i = 1, 3 do
                    if petButtons[i] and petButtons[i].button then
                        if topPets[i] then
                            local pet = topPets[i]
                            petButtons[i].button.Text = string.format("#%d: %s", i, pet.petName or "?")
                        else
                            petButtons[i].button.Text = string.format("#%d: No", i)
                        end
                    end
                end
                
                if topPets[selectedTargetIndex] then
                    local currentPet = topPets[selectedTargetIndex]
                    targetLabel.Text = string.format("Current: %s", currentPet.petName or "?")
                else
                    targetLabel.Text = "Current: None"
                end
            else
                targetLabel.Text = "Current: Searching..."
                if petButtons then
                    for i = 1, 3 do
                        if petButtons[i] and petButtons[i].button then
                            petButtons[i].button.Text = string.format("#%d: ...", i)
                        end
                    end
                end
            end
            
            if petButtons then
                for i, btn in ipairs(petButtons) do
                    if i == selectedTargetIndex and btn.button and btn.stroke then
                        btn.button.TextColor3 = Color3.fromRGB(100, 255, 100)
                        btn.stroke.Color = Color3.fromRGB(100, 255, 100)
                        btn.stroke.Transparency = 0.3
                    elseif btn.button and btn.stroke then
                        btn.button.TextColor3 = Color3.fromRGB(200, 200, 200)
                        btn.stroke.Color = Color3.fromRGB(100, 100, 100)
                        btn.stroke.Transparency = 0.7
                    end
                end
            end
        else
            statusLabel.Text = "OFF"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            if frame and frame:FindFirstChild("UIStroke") then
                frame.UIStroke.Color = Color3.fromRGB(180, 0, 255)
                frame.UIStroke.Transparency = 0.5
            end
            
            toggleButton.Text = "Enable"
            targetLabel.Text = "Current: Off"
            
            if petButtons then
                for i = 1, 3 do
                    if petButtons[i] and petButtons[i].button then
                        petButtons[i].button.Text = string.format("#%d: Off", i)
                        petButtons[i].button.TextColor3 = Color3.fromRGB(150, 150, 150)
                    end
                end
            end
        end
        
        if autoStealEnabled and stealStatusLabel then
            stealStatusLabel.Text = "Steal: Active (See progress bar)"
            stealStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            stealStatusLabel.Text = "Steal: Disabled"
            stealStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    local stealConnection = nil

    local function autoStealLoop()
        if stealConnection then
            stealConnection:Disconnect()
        end
        
        stealConnection = RunService.Heartbeat:Connect(function()
            if not autoStealEnabled then
                return
            end
            
            local topPets = get_top_3_pets()
            
            local targetAnimal = nil
            if topPets[selectedTargetIndex] then
                targetAnimal = topPets[selectedTargetIndex].animalData
            end
            
            if not targetAnimal or isMyBaseAnimal(targetAnimal) then
                return
            end
            
            local prompt = PromptMemoryCache[targetAnimal.uid]
            if not prompt or not prompt.Parent then
                prompt = findProximityPromptForAnimal(targetAnimal)
            end
            
            if prompt then
                attemptSteal(prompt)
            end
        end)
    end

    local function progressBarUpdateLoop()
        while task.wait(0.01) do
            updateProgressBar()
        end
    end

    -- Main initialization thread
    task.spawn(function()
        while not AnimalsData or not AnimalsShared or not NumberUtils do
            task.wait(0.5)
        end
        
        task.wait(2)
        
        createProgressBarGUI()
        
        local guiCreated = createMobileGUI()
        if not guiCreated then
            return
        end
        
        task.spawn(progressBarUpdateLoop)
        
        if toggleButton then
            local isMobile = UserInputService.TouchEnabled
            
            if not isMobile then
                toggleButton.MouseEnter:Connect(function()
                    toggleButton.BackgroundTransparency = 0.05
                    if toggleButton:FindFirstChild("UIStroke") then
                        toggleButton.UIStroke.Transparency = 0.3
                    end
                end)

                toggleButton.MouseLeave:Connect(function()
                    toggleButton.BackgroundTransparency = 0.15
                    if toggleButton:FindFirstChild("UIStroke") then
                        toggleButton.UIStroke.Transparency = 0.5
                    end
                end)
            end

            toggleButton.MouseButton1Click:Connect(function()
                autoStealEnabled = not autoStealEnabled
                
                if autoStealEnabled then
                    local topPets = get_top_3_pets()
                    updateUI(true, topPets)
                    autoStealLoop()
                    
                    if progressBarText then
                        progressBarText.Text = ""
                        progressBarFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                    end
                else
                    updateUI(false)
                    isCurrentlyStealing = false
                    currentStealProgress = 0
                    
                    if progressBarText then
                        progressBarText.Text = ""
                        progressBarFill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                        progressBarFill.Size = UDim2.new(0, 0, 1, -4)
                    end
                end
            end)
        end
        
        initializePlotScanner()
        
        task.wait(1)
        autoStealLoop()
        
        local topPets = get_top_3_pets()
        updateUI(true, topPets)
        
        while task.wait(0.1) do
            if autoStealEnabled then
                local topPets = get_top_3_pets()
                updateUI(true, topPets)
            end
        end
    end)
end)