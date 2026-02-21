-- =============================================
-- Argon Hub X — Converted to Obsidian UI
-- Original: ArgonHubX by AgentX771
-- =============================================

-- ── Obsidian Library Init ──────────────────────
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options  = Library.Options
local Toggles  = Library.Toggles

Library.NotifySide = "Right"
Library.ShowCustomCursor = true

local function Notify(title, desc, duration)
    Library:Notify({
        Title   = "Argon Hub X: " .. title,
        Content = desc,
        Duration = duration or 5,
    })
end

-- ── Original Argon data loaders ───────────────
local ESPLines = loadstring(game:HttpGet("https://raw.githubusercontent.com/AgentX771/ArgonHubX/refs/heads/main/Privating/ESPLines.lua"))()
ESPLines.Enabled = true

-- ── Services ──────────────────────────────────
local Services = {
    CoreGui            = game:GetService("CoreGui"),
    HttpService        = game:GetService("HttpService"),
    Players            = game:GetService("Players"),
    MarketplaceService = game:GetService("MarketplaceService"),
    AnalyticsService   = game:GetService("RbxAnalyticsService"),
    Lighting           = game:GetService("Lighting"),
    RunService         = game:GetService("RunService"),
}

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local UserInputService   = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local Lighting           = game:GetService("Lighting")
local Debris             = game:GetService("Debris")
local TeleportService    = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService         = game:GetService("GuiService")
local Stats              = game:GetService("Stats")
local CoreGui            = game:GetService("CoreGui")

local Player    = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid  = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera    = workspace.CurrentCamera
local Mouse     = Player:GetMouse()

-- ── Runtime / RemoteStorage ───────────────────
local Runtime = workspace:FindFirstChild("Runtime")
local net     = ReplicatedStorage:WaitForChild("Packages")["_Index"]["sleitnick_net@0.1.0"].net

-- ── Feature State Variables ───────────────────
local AutoWalk            = false
local AutoWalkDistanceX   = 10
local AutoWalkDistanceZ   = 10
local PlayerSaftey        = false
local PlayerSaftey_Distance = 10
local RandomTeleports     = false
local TeleportDistanceX   = 10
local TeleportDistanceZ   = 10
local AutoDoubleJump      = false
local ClosestPlayer_var   = false
local AiPlay              = false
local AiPlayType          = "Normal"
local AiPlaySpeed         = 200
local RandAutoaParry      = {}
local RandRNG             = "false"
local BallVelocity        = false
local DirectionMode       = "Camera"
local EnableAntiCurve     = false
local EnableAutoCurve     = false
local Connections_Manager = {}
local Selected_Parry_Type = "Camera"
local Parried             = false
local Training_Parried    = false
local Last_Parry          = 0
local Parries             = 0
local ParryThreshold      = 2.5
local Speed_Divisor_Multiplier     = 1.1
local LobbyAP_Speed_Divisor_Multiplier = 1.1
local Infinity            = false
local Phantom             = false
local Curving             = 0
local Closest_Entity      = nil
local HighlightDetected   = false
local afkToggle           = false
local afkRunning          = false
local antiLagActive       = false
local auto_rewards_enabled = false
local reward_interval     = 60
local selected_reward_type = "All"
local inputJobId          = ""
local currentJobId        = game.JobId
local nowprediction       = true
local Detections          = true
local DeathSlashDetection = true
local TimeHoleDetection   = true
local AutoTelekinesis     = true
local ball_Trail_Enabled  = false
local MauaulSpam          = nil
local Grab_Parry          = nil
local Parry_Key           = nil
local InputTask           = nil
local Cooldown            = 0.02
local firstParryFired     = false
local firstParryType      = "F_Key"
local Previous_Positions  = {}
local CanSlash            = false
local BallSpeed           = 0
local originalMaterials   = {}
local originalDecalsTextures = {}
local hookSupport         = hookmetamethod and true
local problemDescription  = ""
local frequencySelection  = ""
local reportCount         = 0
local Tornado_Time        = tick()
local Last_Input          = UserInputService:GetLastInputType()
local isMobile            = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local PropertyChangeOrder = {}
local HashOne, HashTwo, HashThree
local ArgonHubX_Data      = nil
local hit_Sound           = nil
local hit_Sound_Enabled   = false
local hit_effect_Enabled  = false
local originalName        = "Argon Hub X"
local currentName         = originalName

-- ── Helper: GetMouse ──────────────────────────
function GetMouse()
    return UserInputService:GetMouseLocation()
end

-- ── Helper: GetClosestPlayer (global) ─────────
function GetClosestPlayer()
    local closestDistance = math.huge
    local closestTarget   = nil
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v ~= Player.Character then
            local d = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < closestDistance then
                closestDistance = d
                closestTarget   = v
            end
        end
    end
    return closestTarget
end

-- ── Helper: GetBall ───────────────────────────
function GetBall()
    for _, v in pairs(workspace.Balls:GetChildren()) do
        if v:IsA("Part") then return v end
    end
    return nil
end

function getBall()
    return GetBall()
end

function GetBallFromPlayerPos(Ball)
    return (Ball.Position - Player.Character.HumanoidRootPart.Position).Magnitude
end

local function getSpeed(part)
    if part:IsA("BasePart") then
        local speed = part.Velocity.Magnitude
        if speed > 1 then return part, speed end
    end
    return nil, nil
end

local function measureVerticalDistance(hrp, targetPart)
    return math.abs(hrp.Position.Y - targetPart.Position.Y)
end

-- ── Hotbar Key Listener ───────────────────────
local function GetHotKey()
    for _, v in pairs(Player.PlayerGui.Hotbar.Block.HotkeyFrame:GetChildren()) do
        if v:IsA("TextLabel") then return v.Text end
    end
    return ""
end

local KeyCodeBlock = ""
local text = Player.PlayerGui.Hotbar.Block.HotkeyFrame:FindFirstChild("F")
if text then
    KeyCodeBlock = text.Text
    text:GetPropertyChangedSignal("Text"):Connect(function()
        KeyCodeBlock = text.Text
    end)
end

-- ── Player Safety loop ────────────────────────
task.delay(10, function()
    task.spawn(function()
        while task.wait() do
            if PlayerSaftey then
                if not Player.Character or Player.Character.Parent.Name == "Dead" then return end
                pcall(function()
                    local closestPlayer = GetClosestPlayer()
                    if closestPlayer and (closestPlayer.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= PlayerSaftey_Distance then
                        Player.Character.HumanoidRootPart.CFrame = closestPlayer.HumanoidRootPart.CFrame * CFrame.new(-25, 0, -PlayerSaftey_Distance)
                    end
                end)
            end
        end
    end)
end)

-- ── Random Auto Parry (RNG) loop ──────────────
task.spawn(function()
    while task.wait() do
        if RandAutoaParry and RandAutoaParry[tostring(RandRNG)] then
            pcall(function()
                for _, v in pairs(workspace.Balls:GetChildren()) do
                    if v:IsA("Part") then
                        if not Player.Character or not Player.Character:FindFirstChild("Highlight") then return end
                        local part, speed = getSpeed(v)
                        if part and speed then
                            local minDistance = 2.5 * (speed * 0.1) + 2
                            if minDistance == 0 or minDistance <= 20 then
                                BallSpeed = 23
                            elseif minDistance > 20 and minDistance <= 88 then
                                BallSpeed = 2.5 * (speed * 0.1) + 5
                            elseif minDistance > 88 and minDistance <= 110 then
                                BallSpeed = 90
                            end
                            if (Player.Character.HumanoidRootPart.Position - part.Position).Magnitude <= BallSpeed then
                                CanSlash = true
                            else
                                CanSlash = false
                            end
                        end
                    end
                end
                if CanSlash then
                    if math.random(1, 5) == 5 then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    else
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)
                    end
                    CanSlash = false
                end
            end)
        end
    end
end)

-- ── Auto Walk / Auto Jump loop ────────────────
task.spawn(function()
    while task.wait() do
        if AutoWalk then
            pcall(function()
                local character = Player.Character
                if character and character.Parent and character.Parent.Name ~= "Dead" then
                    local targetPosition
                    for _, v in pairs(workspace.Balls:GetChildren()) do
                        if v:IsA("Part") then
                            local part, speed = getSpeed(v)
                            if part and speed and speed > 5 then
                                targetPosition = part.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ)
                                break
                            end
                        end
                    end
                    if not targetPosition then
                        for _, p in pairs(workspace.Alive:GetChildren()) do
                            if p ~= character and p:FindFirstChild("HumanoidRootPart") then
                                targetPosition = p.HumanoidRootPart.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ)
                                break
                            end
                        end
                    end
                    if targetPosition then
                        character:FindFirstChildOfClass("Humanoid"):MoveTo(targetPosition)
                    end
                end
            end)
        end

        if AutoDoubleJump then
            local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                    task.wait(0.1)
                else
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(0.3)
                end
            end
        end
    end
end)

-- ── Closest Player Camera Focus loop ──────────
task.spawn(function()
    while task.wait() do
        if ClosestPlayer_var then
            pcall(function()
                local character = Player.Character
                if character and character.Parent.Name ~= "Dead" then
                    local closestPlayer = GetClosestPlayer()
                    if closestPlayer and closestPlayer:FindFirstChild("Head") then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Head.Position)
                    end
                end
            end)
        end
    end
end)

-- ── Random Teleports loop ─────────────────────
task.spawn(function()
    while task.wait(math.random(1, 2)) do
        if RandomTeleports then
            pcall(function()
                local character = Player.Character
                if character and character.Parent.Name ~= "Dead" then
                    for _, v in pairs(workspace.Balls:GetChildren()) do
                        if v:IsA("Part") then
                            local part, speed = getSpeed(v)
                            if part and speed then
                                character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(TeleportDistanceX, 0, TeleportDistanceZ)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ── Auto Rewards ──────────────────────────────
local function claim_rewards()
    pcall(function()
        if ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("RemoteEvent") then
            local event = ReplicatedStorage.Remote.RemoteEvent:FindFirstChild('ClaimLoginReward')
            if event then event:FireServer() end
        end
    end)
    task.defer(function()
        for day = 1, 30 do
            task.wait()
            pcall(function()
                if ReplicatedStorage.Remote:FindFirstChild("RemoteFunction") then
                    ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', day)
                end
            end)
            for _, wheel in ipairs({"SummerWheel", "CyborgWheel", "SynthWheel"}) do
                pcall(function()
                    local processRoll = net:FindFirstChild("RE/" .. wheel .. "/ProcessRoll")
                    if processRoll then processRoll:FireServer() end
                end)
            end
            pcall(function()
                if net:FindFirstChild("RE/ProcessTournamentRoll") then net["RE/ProcessTournamentRoll"]:FireServer() end
                if net:FindFirstChild("RE/RolledReturnCrate") then net["RE/RolledReturnCrate"]:FireServer() end
                if net:FindFirstChild("RE/ProcessLTMRoll") then net["RE/ProcessLTMRoll"]:FireServer() end
            end)
        end
    end)
    task.defer(function()
        for reward = 1, 6 do
            pcall(function() if net:FindFirstChild("RF/ClaimPlaytimeReward") then net["RF/ClaimPlaytimeReward"]:InvokeServer(reward) end end)
            pcall(function() if net:FindFirstChild("RE/ClaimSeasonPlaytimeReward") then net["RE/ClaimSeasonPlaytimeReward"]:FireServer(reward) end end)
            pcall(function() if ReplicatedStorage.Remote:FindFirstChild("RemoteFunction") then ReplicatedStorage.Remote.RemoteFunction:InvokeServer('SpinWheel') end end)
            pcall(function() if net:FindFirstChild("RE/SpinFinished") then net["RE/SpinFinished"]:FireServer() end end)
        end
    end)
    task.defer(function()
        for reward = 1, 5 do
            pcall(function() if net:FindFirstChild("RF/RedeemQuestsType") then net["RF/RedeemQuestsType"]:InvokeServer('SummerClashEvent', 'Daily', reward) end end)
        end
    end)
    task.defer(function()
        for reward = 1, 4 do
            pcall(function() if net:FindFirstChild("RE/SummerWheel/ClaimStreakReward") then net["RE/SummerWheel/ClaimStreakReward"]:FireServer(reward) end end)
        end
    end)
end

task.defer(function()
    while task.wait(reward_interval) do
        pcall(function()
            if auto_rewards_enabled then claim_rewards() end
        end)
    end
end)

-- ── Direction/Curve helpers ───────────────────
local function GetClosestPlayerLocal()
    local closest, distance = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (v.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if d < distance then closest = v; distance = d end
        end
    end
    return closest
end

local function GetDirection()
    if EnableAntiCurve then
        return (Camera.CFrame * CFrame.new(0, 0, -500)).Position
    elseif EnableAutoCurve then
        local t = GetClosestPlayerLocal()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            local d = (t.Character.HumanoidRootPart.Position - HumanoidRootPart.Position)
            return d.Unit + Vector3.new(0, math.sin(tick() * 5) * 0.2, 0)
        end
    elseif DirectionMode == "Camera" then
        return Camera.CFrame.LookVector
    elseif DirectionMode == "Mouse" then
        return (Mouse.Hit.Position - HumanoidRootPart.Position).Unit
    elseif DirectionMode == "Players" then
        local target = GetClosestPlayerLocal()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            return (target.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
        end
    elseif DirectionMode == "Normal" then return Vector3.new(0,0,-1)
    elseif DirectionMode == "Up" then return Vector3.new(0,1,0)
    elseif DirectionMode == "Down" then return Vector3.new(0,-1,0)
    elseif DirectionMode == "Left" then return -Camera.CFrame.RightVector
    elseif DirectionMode == "Right" then return Camera.CFrame.RightVector
    elseif DirectionMode == "Behind" then return -Camera.CFrame.LookVector
    elseif DirectionMode == "Random" then return Vector3.new(math.random(-10,10),math.random(-10,10),math.random(-10,10)).Unit
    elseif DirectionMode == "FrontLeft" then return (Camera.CFrame.LookVector - Camera.CFrame.RightVector).Unit
    elseif DirectionMode == "FrontRight" then return (Camera.CFrame.LookVector + Camera.CFrame.RightVector).Unit
    elseif DirectionMode == "BackLeft" then return (-Camera.CFrame.LookVector - Camera.CFrame.RightVector).Unit
    elseif DirectionMode == "BackRight" then return (-Camera.CFrame.LookVector + Camera.CFrame.RightVector).Unit
    elseif DirectionMode == "SkywardSpiral" then return (Camera.CFrame.LookVector + Vector3.new(0, math.sin(tick()*5), 0)).Unit
    elseif DirectionMode == "Zigzag" then return (Camera.CFrame.LookVector + Camera.CFrame.RightVector * math.sin(tick()*10)).Unit
    elseif DirectionMode == "Spin" then local a=math.rad(tick()*360%360); return Vector3.new(math.cos(a),0,math.sin(a)).Unit
    elseif DirectionMode == "Bounce" then return (Camera.CFrame.LookVector + Vector3.new(0,math.abs(math.sin(tick()*5))*2,0)).Unit
    elseif DirectionMode == "Wave" then return (Camera.CFrame.LookVector + Vector3.new(math.sin(tick()*5),0,0)).Unit
    elseif DirectionMode == "Orbit" then local a=tick()*2; return (Camera.CFrame.LookVector + Vector3.new(math.cos(a),0,math.sin(a))).Unit
    elseif DirectionMode == "Chaos" then return (Camera.CFrame.LookVector + Vector3.new(math.random(-100,100)/100,math.random(-100,100)/100,math.random(-100,100)/100)).Unit
    elseif DirectionMode == "TargetFeet" then
        local t = GetClosestPlayerLocal()
        if t and t.Character then
            local part = t.Character:FindFirstChild("LeftFoot") or t.Character:FindFirstChild("HumanoidRootPart")
            if part then return (part.Position - HumanoidRootPart.Position).Unit end
        end
    elseif DirectionMode == "TargetHead" then
        local t = GetClosestPlayerLocal()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            return (t.Character.Head.Position - HumanoidRootPart.Position).Unit
        end
    end
    return Camera.CFrame.LookVector
end

-- ── AI Play functions ──────────────────────────
local function get_ball() return GetBall() end
local function get_humanoid_root_part()
    local c = Player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function get_humanoid()
    local c = Player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function ai_play()
    if not AiPlay then return end
    local character = Player.Character
    if not character then return end

    local ball = get_ball()
    local hrp  = get_humanoid_root_part()
    local humanoid = get_humanoid()
    if not ball or not hrp or not humanoid then return end

    if AiPlayType == "Hacker" then
        humanoid.WalkSpeed = AiPlaySpeed
    else
        humanoid.WalkSpeed = 36
    end

    local ballPosition   = ball.Position
    local playerPosition = hrp.Position
    local distanceFromBall = (ballPosition - playerPosition).Magnitude

    local function is_path_clear(destination)
        local direction = (destination - playerPosition).Unit
        local ray = Ray.new(playerPosition, direction * 5)
        local part = workspace:FindPartOnRay(ray, character)
        return not part
    end

    if AiPlayType == "Normal" then
        if distanceFromBall < 60 then
            local dir = (playerPosition - ballPosition).Unit
            local tp  = playerPosition + dir * math.random(24, 36)
            if is_path_clear(tp) then humanoid:MoveTo(tp) end
        elseif math.random(1, 100) <= 6 then
            local offset = Vector3.new(math.random(-14,14), 0, math.random(-14,14))
            local tp = playerPosition + offset
            if is_path_clear(tp) then humanoid:MoveTo(tp) end
        end
    elseif AiPlayType == "Advanced" then
        if distanceFromBall < 80 then
            local chase  = (ballPosition - playerPosition).Unit
            local offset = Vector3.new(math.random(-6,6), 0, math.random(-6,6))
            local tp = playerPosition + chase * 30 + offset
            if is_path_clear(tp) then humanoid:MoveTo(tp) end
        elseif math.random(1, 100) <= 12 then
            local offset = Vector3.new(math.random(-24,24), 0, math.random(-24,24))
            local tp = playerPosition + offset
            if is_path_clear(tp) then humanoid:MoveTo(tp) end
        end
    elseif AiPlayType == "Hacker" then
        if distanceFromBall < 200 then
            local tp = ballPosition + Vector3.new(math.random(-3,3), 0, math.random(-3,3))
            if is_path_clear(tp) then humanoid:MoveTo(tp) end
        end
        for _, enemy in pairs(workspace:FindFirstChild("Alive"):GetChildren()) do
            if enemy:IsA("Model") and enemy ~= character and enemy:FindFirstChild("HumanoidRootPart") then
                local eHRP = enemy.HumanoidRootPart
                if (eHRP.Position - ballPosition).Magnitude <= 15 then
                    hrp.CFrame = CFrame.new(eHRP.Position + Vector3.new(math.random(-3,3), 0, math.random(-3,3)))
                    break
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(ai_play)

-- ── Block movement helper ─────────────────────
local function BlockMovement(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end

-- ── LPH stubs ────────────────────────────────
if not LPH_OBFUSCATED then
    function LPH_JIT(fn) return fn end
    function LPH_JIT_MAX(fn) return fn end
    function LPH_NO_VIRTUALIZE(fn) return fn end
end

-- ── Remote hash discovery ─────────────────────
LPH_NO_VIRTUALIZE(function()
    local ok, gc = pcall(getgc)
    if ok and type(gc) == "table" then
        for _, Value in next, gc do
            local infoOk, info = pcall(function()
                return typeof(Value) == "function" and islclosure(Value) and getrenv().debug.info(Value, "s")
            end)
            if infoOk and info and string.find(info, "SwordsController") then
                local lineOk, line = pcall(function() return getrenv().debug.info(Value, "l") end)
                if lineOk and line == 276 then
                    local s1, h1 = pcall(getconstant, Value, 62); if s1 then HashOne   = h1 end
                    local s2, h2 = pcall(getconstant, Value, 64); if s2 then HashTwo   = h2 end
                    local s3, h3 = pcall(getconstant, Value, 65); if s3 then HashThree = h3 end
                end
            end
        end
    end
end)()

LPH_NO_VIRTUALIZE(function()
    local ok, descendants = pcall(function() return game:GetDescendants() end)
    if ok and type(descendants) == "table" then
        for _, Object in next, descendants do
            local isRE  = pcall(function() return Object:IsA("RemoteEvent") end)
            local nameCheck = pcall(function() return string.find(Object.Name, "\n") end)
            if isRE and nameCheck and Object:IsA("RemoteEvent") and string.find(Object.Name, "\n") then
                pcall(function()
                    Object.Changed:Once(function()
                        table.insert(PropertyChangeOrder, Object)
                    end)
                end)
            end
        end
    end
end)()

repeat task.wait() until #PropertyChangeOrder == 3

local ShouldPlayerJump  = PropertyChangeOrder[1]
local MainRemote        = PropertyChangeOrder[2]
local GetOpponentPosition = PropertyChangeOrder[3]

-- ── Parry Key Discovery ───────────────────────
local success, connections = pcall(function()
    return getconnections(Player.PlayerGui.Hotbar.Block.Activated)
end)
if success and type(connections) == "table" then
    for _, Value in pairs(connections) do
        if Value and typeof(Value) == "table" and Value.Function and not iscclosure(Value.Function) then
            local sU, upvalues = pcall(getupvalues, Value.Function)
            if sU and type(upvalues) == "table" then
                for _, Value2 in pairs(upvalues) do
                    if type(Value2) == "function" then
                        local sK, result = pcall(function()
                            return getupvalue(getupvalue(Value2, 2), 17)
                        end)
                        if sK then Parry_Key = result end
                    end
                end
            end
        end
    end
end

local function Parry(...)
    ShouldPlayerJump:FireServer(HashOne, Parry_Key, ...)
    MainRemote:FireServer(HashTwo, Parry_Key, ...)
    GetOpponentPosition:FireServer(HashThree, Parry_Key, ...)
end

-- ── Navigation helper ─────────────────────────
local function updateNavigation(guiObject)
    GuiService.SelectedObject = guiObject
end

local function performFirstPress(parryType)
    if parryType == "F_Key" then
        pcall(function() VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1) end)
    elseif parryType == "Left_Click" then
        pcall(function() VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) end)
    elseif parryType == "Navigation" then
        local suc, button = pcall(function() return Player.PlayerGui.Hotbar.Block end)
        if suc and button then
            pcall(function()
                updateNavigation(button)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                updateNavigation(nil)
            end)
        end
    end
end

-- ── Animation storage ─────────────────────────
local Animation = { storage = {}, current = nil, track = nil }
for _, v in pairs(ReplicatedStorage.Misc.Emotes:GetChildren()) do
    if v:IsA("Animation") and v:GetAttribute("EmoteName") then
        Animation.storage[v:GetAttribute("EmoteName")] = v
    end
end
local Emotes_Data = {}
for k in pairs(Animation.storage) do table.insert(Emotes_Data, k) end
table.sort(Emotes_Data)

-- ── Auto Parry Object ─────────────────────────
local Auto_Parry = {}

function Auto_Parry.Parry_Animation()
    local Parry_Animation = ReplicatedStorage.Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword   = Player.Character:GetAttribute('CurrentlyEquippedSword')
    if not Current_Sword or not Parry_Animation then return end
    local Sword_Data = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)
    if not Sword_Data or not Sword_Data['AnimationType'] then return end
    for _, object in pairs(ReplicatedStorage.Shared.SwordAPI.Collection:GetChildren()) do
        if object.Name == Sword_Data['AnimationType'] then
            local anim_type = object:FindFirstChild('GrabParry') and 'GrabParry' or (object:FindFirstChild('Grab') and 'Grab')
            if anim_type then Parry_Animation = object[anim_type] end
        end
    end
    Grab_Parry = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
    Grab_Parry:Play()
end

function Auto_Parry.Play_Animation(v)
    local Animations = Animation.storage[v]
    if not Animations then return false end
    local Animator = Player.Character.Humanoid.Animator
    if Animation.track then Animation.track:Stop() end
    Animation.track = Animator:LoadAnimation(Animations)
    Animation.track:Play()
    Animation.current = v
end

function Auto_Parry.Get_Balls()
    local Balls = {}
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            table.insert(Balls, Instance)
        end
    end
    return Balls
end

function Auto_Parry.Get_Ball()
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            return Instance
        end
    end
end

function Auto_Parry.Lobby_Balls()
    for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
        if Instance:GetAttribute("realBall") then return Instance end
    end
end

function Auto_Parry.Closest_Player()
    local Max_Distance  = math.huge
    local Found_Entity  = nil
    for _, Entity in pairs(workspace.Alive:GetChildren()) do
        if tostring(Entity) ~= tostring(Player) then
            if Entity.PrimaryPart then
                local Distance = Player:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < Max_Distance then
                    Max_Distance  = Distance
                    Found_Entity  = Entity
                end
            end
        end
    end
    Closest_Entity = Found_Entity
    return Found_Entity
end

function Auto_Parry:Get_Entity_Properties()
    Auto_Parry.Closest_Player()
    if not Closest_Entity then return false end
    return {
        Velocity  = Closest_Entity.PrimaryPart.Velocity,
        Direction = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit,
        Distance  = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude,
    }
end

function Auto_Parry:Get_Ball_Properties()
    local Ball = Auto_Parry.Get_Ball()
    if not Ball then return false end
    local Zoomies = Ball:FindFirstChild('zoomies')
    if not Zoomies then return false end
    return {
        Ball     = Ball,
        Velocity = Zoomies.VectorVelocity,
        Speed    = Zoomies.VectorVelocity.Magnitude,
        Distance = Player:DistanceFromCharacter(Ball.Position),
    }
end

function Auto_Parry.Is_Curved()
    return (tick() - Curving) < 0.5
end

function Auto_Parry.Parry(parryType)
    Parry(Auto_Parry.Parry_Data(parryType))
end

function Auto_Parry.Parry_Data(Parry_Type)
    Auto_Parry.Closest_Player()
    local Events = {}
    local Vector2_Mouse_Location
    if Last_Input == Enum.UserInputType.MouseButton1 or Last_Input == Enum.UserInputType.Keyboard then
        local loc = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {loc.X, loc.Y}
    else
        Vector2_Mouse_Location = {Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2}
    end
    if isMobile then Vector2_Mouse_Location = {Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2} end
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v ~= Player.Character then
            local worldPos = v.PrimaryPart.Position
            local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
            if isOnScreen then Events[v] = Vector2.new(screenPos.X, screenPos.Y) end
            Events[tostring(v)] = screenPos
        end
    end
    if Parry_Type == 'Camera' then
        return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'Backwards' then
        local Backwards_Direction = Camera.CFrame.LookVector * -10000
        Backwards_Direction = Vector3.new(Backwards_Direction.X, 0, Backwards_Direction.Z)
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Backwards_Direction), Events, Vector2_Mouse_Location}
    end
    return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
end

function Auto_Parry.Spam_Service(data)
    local Ball_Properties   = data.Ball_Properties
    local Entity_Properties = data.Entity_Properties
    local Ping              = data.Ping
    local Spam_Accuracy     = 15
    local Maximum_Spam_Distance = 15
    if not Ball_Properties or not Entity_Properties then return Spam_Accuracy end
    local Speed     = Ball_Properties.Speed
    local Direction = Ball_Properties.Velocity.Unit
    local Target_Distance = Entity_Properties.Distance
    local EntityDir = Entity_Properties.Direction
    local Dot = EntityDir:Dot(Direction)
    if self and self.Ball_Properties and self.Ball_Properties.Distance > Maximum_Spam_Distance then return Spam_Accuracy end
    if Target_Distance > Maximum_Spam_Distance then return Spam_Accuracy end
    local Maximum_Speed = 5 - math.min(Speed / 5, 5)
    local Maximum_Dot   = math.clamp(Dot, -1, 0) * Maximum_Speed
    Spam_Accuracy = Maximum_Spam_Distance - Maximum_Dot
    return Spam_Accuracy
end

-- ── Highlight Detection ───────────────────────
RunService.Heartbeat:Connect(function()
    local c = Player.Character
    if not c then return end
    HighlightDetected = c:FindFirstChildWhichIsA("Highlight", true) ~= nil
end)

-- ── Infinity / Phantom events ─────────────────
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    Infinity = b and true or false
end)

game:GetService('ReplicatedStorage').Remotes.Phantom.OnClientEvent:Connect(function(a, b)
    Phantom = b.Name == tostring(Player)
end)

workspace:WaitForChild('Balls').ChildRemoved:Connect(function()
    Phantom = false
end)

-- ── Parry success events ──────────────────────
local ParryCD  = Player.PlayerGui.Hotbar.Block.UIGradient
local AbilityCD = Player.PlayerGui.Hotbar.Ability.UIGradient

local function isCooldownInEffect1(uig) return uig.Offset.Y < 0.4 end
local function isCooldownInEffect2(uig) return uig.Offset.Y == 0.5 end

local function cooldownProtection()
    if isCooldownInEffect1(ParryCD) then
        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
        return true
    end
    return false
end

local function AutoAbility()
    if isCooldownInEffect2(AbilityCD) then
        if Player.Character.Abilities["Raging Deflection"].Enabled
            or Player.Character.Abilities["Rapture"].Enabled
            or Player.Character.Abilities["Calming Deflection"].Enabled
            or Player.Character.Abilities["Aerodynamic Slash"].Enabled
            or Player.Character.Abilities["Fracture"].Enabled
            or Player.Character.Abilities["Death Slash"].Enabled
        then
            Parried = true
            ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
            task.wait(2.432)
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
            return true
        end
    end
    return false
end

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if hit_Sound_Enabled then hit_Sound:Play() end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root.Parent and root.Parent ~= Player.Character then
        if root.Parent.Parent ~= workspace.Alive then return end
    end
    Auto_Parry.Closest_Player()
    local Ball = Auto_Parry.Get_Ball()
    if not Ball then return end
    local Target_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    local Distance  = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball.AssemblyLinearVelocity.Unit)
    local Curve_Detected = Auto_Parry.Is_Curved()
    if Target_Distance < 15 and Distance < 15 and Dot > -0.25 then
        if Curve_Detected then Auto_Parry.Parry(Selected_Parry_Type) end
    end
    if not Grab_Parry then return end
    Grab_Parry:Stop()
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if Player.Character.Parent ~= workspace.Alive then return end
    if not Grab_Parry then return end
    Grab_Parry:Stop()
end)

workspace.Balls.ChildAdded:Connect(function() Parried = false end)
workspace.Balls.ChildRemoved:Connect(function()
    Parries = 0
    Parried = false
    if Connections_Manager['Target Change'] then
        Connections_Manager['Target Change']:Disconnect()
        Connections_Manager['Target Change'] = nil
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
    local Primary_Part = Player.Character.PrimaryPart
    local Ball = Auto_Parry.Get_Ball()
    if not Ball then return end
    local Zoomies = Ball:FindFirstChild('zoomies')
    if not Zoomies then return end
    local Speed    = Zoomies.VectorVelocity.Magnitude
    local Distance = (Primary_Part.Position - Ball.Position).Magnitude
    local Velocity = Zoomies.VectorVelocity
    local Ball_Direction = Velocity.Unit
    local Direction = (Primary_Part.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)
    local Pings = Stats and Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"] and Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
    local Speed_Threshold = math.min(Speed / 100, 40)
    local Reach_Time = Distance / Speed - (Pings / 1000)
    local Enough_Speed = Speed > 100
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold
    if Enough_Speed and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end
    if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
        Curving = tick()
    end
end)

-- ── Balls ChildAdded (SOF / PhantomV2) ────────
local Balls    = workspace:WaitForChild('Balls')
local CurrentBall = nil
local RunTime  = workspace:FindFirstChild("Runtime")

Balls.ChildAdded:Connect(function(Value)
    Value.ChildAdded:Connect(function(Child)
        if getgenv().SlashOfFuryDetection and Child.Name == 'ComboCounter' then
            local Sof_Label = Child:FindFirstChildOfClass('TextLabel')
            if Sof_Label then
                repeat
                    local Slashes_Counter = tonumber(Sof_Label.Text)
                    if Slashes_Counter and Slashes_Counter < 32 then
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                    task.wait()
                until not Sof_Label.Parent or not Sof_Label
            end
        end
    end)
end)

RunTime.ChildAdded:Connect(function(Object)
    if getgenv().PhantomV2Detection then
        if Object.Name == "maxTransmission" or Object.Name == "transmissionpart" then
            local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
            if Weld then
                local Char = Player.Character or Player.CharacterAdded:Wait()
                if Char and Weld.Part1 == Char.HumanoidRootPart then
                    CurrentBall = GetBall()
                    Weld:Destroy()
                    if CurrentBall then
                        local FocusConnection
                        FocusConnection = RunService.RenderStepped:Connect(function()
                            local Highlighted = CurrentBall:GetAttribute("highlighted")
                            if Highlighted == true then
                                Player.Character.Humanoid.WalkSpeed = 36
                                local HRP = Char:FindFirstChild("HumanoidRootPart")
                                if HRP then
                                    local dir = (CurrentBall.Position - HRP.Position).Unit
                                    Player.Character.Humanoid:Move(dir, false)
                                end
                            elseif Highlighted == false then
                                FocusConnection:Disconnect()
                                Player.Character.Humanoid.WalkSpeed = 10
                                Player.Character.Humanoid:Move(Vector3.new(0,0,0), false)
                                task.delay(3, function() Player.Character.Humanoid.WalkSpeed = 36 end)
                                CurrentBall = nil
                            end
                        end)
                        task.delay(3, function()
                            if FocusConnection and FocusConnection.Connected then
                                FocusConnection:Disconnect()
                                Player.Character.Humanoid:Move(Vector3.new(0,0,0), false)
                                Player.Character.Humanoid.WalkSpeed = 36
                                CurrentBall = nil
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- ── Manual Spam GUI ───────────────────────────
function ManualSpam()
    if MauaulSpam then
        MauaulSpam:Destroy(); MauaulSpam = nil; return
    end
    MauaulSpam = Instance.new("ScreenGui")
    MauaulSpam.Name = "MauaulSpam"
    MauaulSpam.Parent = CoreGui
    MauaulSpam.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MauaulSpam.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Main.BorderSizePixel  = 0
    Main.Position = UDim2.new(0.414,0,0.404,0)
    Main.Size     = UDim2.new(0.227,0,0.191,0)
    Main.Parent   = MauaulSpam
    Instance.new("UICorner", Main)

    local dot = Instance.new("Frame", Main)
    dot.BackgroundColor3 = Color3.fromRGB(255,0,0)
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0.028,0,0.073,0)
    dot.Size     = UDim2.new(0.072,0,0.12,0)
    local dotC = Instance.new("UICorner", dot); dotC.CornerRadius = UDim.new(1,0)

    local title = Instance.new("TextButton", Main)
    title.BackgroundTransparency = 1
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.164,0,0.326,0)
    title.Size     = UDim2.new(0.668,0,0.347,0)
    title.Text     = "Argon Hub X"
    title.Font     = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextScaled = true
    local grad = Instance.new("UIGradient", title)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255,0,4)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,0,0)),
    }

    local hint = Instance.new("TextLabel", Main)
    hint.BackgroundTransparency = 1
    hint.BorderSizePixel = 0
    hint.Position = UDim2.new(0.548,0,0.826,0)
    hint.Size     = UDim2.new(0.452,0,0.173,0)
    hint.Text     = "PC: E to spam"
    hint.TextColor3 = Color3.fromRGB(57,57,57)
    hint.TextScaled = true

    -- colour transition
    local green_Color = {ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(0.75,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))}
    local red_Color   = {ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(0.75,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))}
    local current_Color = red_Color; local target_Color = green_Color
    local is_Green = false; local transition = false; local start_Time = 0; local transition_Time = 0.1
    RunService.Heartbeat:Connect(function()
        if transition then
            local alpha = math.clamp((tick()-start_Time)/transition_Time, 0, 1)
            local new_Color = {}
            for i = 1, #current_Color do
                new_Color[i] = ColorSequenceKeypoint.new(current_Color[i].Time, current_Color[i].Value:Lerp(target_Color[i].Value, alpha))
            end
            grad.Color = ColorSequence.new(new_Color)
            if alpha >= 1 then transition = false; current_Color, target_Color = target_Color, current_Color end
        end
    end)
    title.MouseButton1Click:Connect(function()
        if not transition then
            is_Green = not is_Green
            target_Color = is_Green and green_Color or red_Color
            transition   = true
            start_Time   = tick()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.E then
            Auto_Parry.Parry(Selected_Parry_Type)
        end
    end)
end

-- ── Sound System ──────────────────────────────
local soundIDs = {
    Disabled              = '',
    DC_15X                = 'rbxassetid://936447863',
    Neverlose             = 'rbxassetid://8679627751',
    Minecraft             = 'rbxassetid://8766809464',
    MinecraftHit2         = 'rbxassetid://8458185621',
    ["Teamfortress Bonk"] = 'rbxassetid://8255306220',
    ["Teamfortress Bell"] = 'rbxassetid://2868331684',
    ["Excalibur"]         = 'rbxassetid://153613030',
    ["Masamune"]          = 'rbxassetid://99803221089826',
    ["Muramasa"]          = 'rbxassetid://98608144972892',
    ["Soul Edge"]         = 'rbxassetid://130037857404629',
    ["Ragnarok"]          = 'rbxassetid://82442955130305',
    ["Dark Repulser"]     = 'rbxassetid://16008606789',
    ["Elucidator"]        = 'rbxassetid://78618347958652',
    ["Dragon Slayer"]     = 'rbxassetid://78833978912349',
}

local function initializate(dataFolder_name)
    ArgonHubX_Data = Instance.new('Folder', CoreGui)
    ArgonHubX_Data.Name = dataFolder_name
    hit_Sound = Instance.new('Sound', ArgonHubX_Data)
    hit_Sound.Volume = 5
end

local function setHitSound(soundId)
    hit_Sound.SoundId = soundId
end

RunService.RenderStepped:Connect(function()
    if not hit_Sound then return end
    local c = Player.Character
    if not c or not c:FindFirstChild("Head") then return end
    local dist = (Camera.CFrame.Position - c.Head.Position).Magnitude
    local vol = math.clamp(5 / (dist * 0.3), 0.1, 5)
    hit_Sound.Volume = vol
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if getgenv().hit_sound_Enabled then hit_Sound:Play() end
    if getgenv().hit_effect_Enabled then
        local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]
        hit_effect.Parent = getBall()
        hit_effect:Emit(3)
        task.delay(5, function() hit_effect:Destroy() end)
    end
end)

initializate('ArgonHubX_temp')

-- ── Auto Crates ───────────────────────────────
task.spawn(function()
    while true do wait(0.01)
        if getgenv().ASC then
            ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
        end
    end
end)
task.spawn(function()
    while true do wait(0.01)
        if getgenv().AEC then
            ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
        end
    end
end)

-- ── Anti AFK ─────────────────────────────────
local function startAntiAFK()
    if afkRunning then return end
    afkRunning = true
    task.spawn(function()
        while afkToggle do
            for i = 900, 1, -1 do
                if not afkToggle then break end
                task.wait(1)
            end
            if not afkToggle then break end
            for j = 1, 5 do
                local char = Player.Character or Player.CharacterAdded:Wait()
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                task.wait(0.5)
            end
        end
        afkRunning = false
    end)
end

-- ── Night Mode loop ───────────────────────────
task.defer(function()
    while task.wait(1) do
        if getgenv().night_mode_Enabled then
            TweenService:Create(Lighting, TweenInfo.new(3), {ClockTime = 3.9}):Play()
        else
            TweenService:Create(Lighting, TweenInfo.new(3), {ClockTime = 13.5}):Play()
        end
    end
end)

-- ── Remove Fog ────────────────────────────────
local function applySettings()
    if getgenv().remove_fog_Enabled then
        Lighting.FogEnd   = 1e10
        Lighting.FogStart = 1e10
        Lighting.FogColor = Color3.new(0,0,0)
    end
end
applySettings()
Player.CharacterAdded:Connect(function() task.wait(1); applySettings() end)

-- ── Ball Velocity Display ─────────────────────
local function create_ball_velocity_display(ball)
    if ball:FindFirstChild("BallVelocityDisplay") then
        return ball.BallVelocityDisplay.TextLabel
    end
    local bg = Instance.new("BillboardGui", ball)
    bg.Name = "BallVelocityDisplay"
    bg.Adornee = ball
    bg.Size = UDim2.new(0,200,0,50)
    bg.StudsOffset = Vector3.new(0,5,0)
    bg.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextScaled = true
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Arcade
    lbl.Text = ""
    return lbl
end

local function update_ball_velocity_display(ball, velocityText)
    if not BallVelocity then velocityText.Text = ""; return end
    if ball then
        velocityText.Text = string.format("Ball Velocity: %.2f", ball.Velocity.Magnitude)
        local hrp = get_humanoid_root_part()
        if hrp then
            local dist = (ball.Position - hrp.Position).Magnitude
            velocityText.TextColor3 = dist > 70 and Color3.fromRGB(0,255,0) or (dist > 30 and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0))
        end
    end
end

local lastBall
RunService.RenderStepped:Connect(function()
    if not BallVelocity then
        if lastBall and lastBall:FindFirstChild("BallVelocityDisplay") then lastBall.BallVelocityDisplay:Destroy() end
        lastBall = nil; return
    end
    local ball = get_ball()
    if ball ~= lastBall then
        if lastBall and lastBall:FindFirstChild("BallVelocityDisplay") then lastBall.BallVelocityDisplay:Destroy() end
        if ball then
            local velocityText = create_ball_velocity_display(ball)
            lastBall = ball
            RunService.RenderStepped:Connect(function()
                if ball and velocityText then update_ball_velocity_display(ball, velocityText) end
            end)
        end
    end
end)

-- ── View Ball (camera follow) ─────────────────
local function resetCamera() Camera.CameraType = Enum.CameraType.Custom end
local function startViewBallLoop()
    if _G.viewConnection then _G.viewConnection:Disconnect(); _G.viewConnection = nil end
    _G.viewConnection = RunService.RenderStepped:Connect(function()
        local ball = getBall()
        if _G.AgentX77 and ball then
            Camera.CameraType = Enum.CameraType.Scriptable
            local targetPosition = ball.Position + Vector3.new(0,5,15)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position:Lerp(targetPosition, 0.05), ball.Position)
        else
            resetCamera()
        end
    end)
end

-- ── Rotate Towards Ball ───────────────────────
local function getCharacter() return Player.Character or Player.CharacterAdded:Wait() end
local function rotateCharacter()
    while getgenv().RotateTowardsBall do
        task.wait()
        local char = getCharacter()
        local ball = getBall()
        if ball and char and char:FindFirstChild("HumanoidRootPart") and char.PrimaryPart then
            local direction = (ball.Position - char.HumanoidRootPart.Position).Unit
            local targetCFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + direction)
            char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame:Lerp(targetCFrame, 0.2))
        end
    end
end
Player.CharacterAdded:Connect(function()
    task.wait(1)
    if getgenv().RotateTowardsBall then task.spawn(rotateCharacter) end
end)

-- ── Follow Ball ───────────────────────────────
task.spawn(function()
    local Ball = workspace:WaitForChild("Balls")
    local DeadFolder = workspace:FindFirstChild("Dead")
    local currentTween = nil
    getgenv().FollowSpeed    = 1
    getgenv().FollowDistance = 1000
    while true do
        wait(0.001)
        if getgenv().FB then
            if DeadFolder and DeadFolder:FindFirstChild(Player.Name) then
                if currentTween then currentTween:Pause(); currentTween = nil end
            else
                local ball = Ball:FindFirstChildOfClass("Part")
                local char = Player.Character
                if ball and char and char.PrimaryPart then
                    local distance = (char.PrimaryPart.Position - ball.Position).Magnitude
                    if distance <= tonumber(getgenv().FollowDistance) then
                        if currentTween then currentTween:Pause() end
                        local tweenInfo = TweenInfo.new(tonumber(getgenv().FollowSpeed), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                        currentTween = TweenService:Create(char.PrimaryPart, tweenInfo, {CFrame = ball.CFrame})
                        currentTween:Play()
                    end
                end
            end
        else
            if currentTween then currentTween:Pause(); currentTween = nil end
        end
    end
end)

-- ── Exploit name helper ───────────────────────
local function getExploitName()
    return (identifyexecutor and identifyexecutor())
        or (syn and syn.get_executor and syn.get_executor())
        or (secure_load and "SecureLoad")
        or (KRNL_LOADED and "KRNL")
        or (islclosure and "Unknown Executor")
        or "Unknown"
end

-- ── Sphere Visualizer stub ────────────────────
local function removeSphere()
    local s = workspace:FindFirstChild("_ArgonVisualizerSphere")
    if s then s:Destroy() end
end

-- ── Ball Trail ────────────────────────────────
workspace.Balls.ChildAdded:Connect(function(ball)
    if ball:IsA("BasePart") and ball_Trail_Enabled then
        local trail = Instance.new("Trail")
        local a0 = Instance.new("Attachment", ball); a0.Position = Vector3.new(0, 0.5, 0)
        local a1 = Instance.new("Attachment", ball); a1.Position = Vector3.new(0,-0.5, 0)
        trail.Attachment0 = a0; trail.Attachment1 = a1
        trail.Lifetime    = 0.5
        trail.MinLength   = 0
        trail.Parent      = ball
    end
end)

-- ───────────────────────────────────────────────
-- ██████████  OBSIDIAN WINDOW  ████████████████
-- ───────────────────────────────────────────────

local Window = Library:CreateWindow({
    Title    = 'Argon Hub X',
    Center   = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    Footer = 'by AgentX771 | Obsidian UI',
})

Library:SetWatermark("Argon Hub X | Free & Open")

local Tabs = {
    Home     = Window:AddTab("Home",     "home"),
    Main     = Window:AddTab("Main",     "user"),
    Combat   = Window:AddTab("Combat",   "swords"),
    Shop     = Window:AddTab("Shop",     "shopping-cart"),
    Settings = Window:AddTab("Settings", "settings"),
    UISettings = Window:AddTab("UI Settings", "sliders"),
}

-- ─────────────────────────────────────────
-- HOME TAB
-- ─────────────────────────────────────────
local HomeLeft  = Tabs.Home:AddLeftGroupbox("Discord")
local HomeRight = Tabs.Home:AddRightGroupbox("Argon Security")

HomeLeft:AddButton("Join Discord", function()
    local req = (syn and syn.request) or (http and http.request) or http_request
    local opened = false
    local JoinDiscord = "https://discord.gg/kG5nqaVYtM"
    if req then
        local success, response = pcall(function()
            return req({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {['Content-Type']='application/json',['Origin']='https://discord.com'},
                Body = HttpService:JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = HttpService:GenerateGUID(false),
                    args = {code = 'kG5nqaVYtM'}
                })
            })
        end)
        if success and response and response.StatusCode == 200 then opened = true end
    end
    if not opened then
        if setclipboard then
            setclipboard(JoinDiscord)
            Notify("Clipboard", "Discord link copied to clipboard.")
        else
            Notify("Unsupported", "Paste this link in your browser: " .. JoinDiscord)
        end
    else
        Notify("Discord", "Discord is running on your device.")
    end
end)

HomeRight:AddToggle("ProtectionArgon", {
    Text    = "Protection - Argon",
    Default = true,
}):OnChanged(function(value)
    if value then
        if hookmetamethod and getnamecallmethod and getrawmetatable and setreadonly then
            local old
            old = hookmetamethod(game, "__namecall", function(self, ...)
                if string.lower(tostring(getnamecallmethod())) == "kick" then
                    Notify("Protection", "Blocked kick attempt.")
                    return wait(9e9)
                end
                return old(self, ...)
            end)
        end
        Notify("Protection", "Protections have been activated.")
    else
        Notify("Protection", "WARNING: Protection has been disabled.")
    end
end)

-- ─────────────────────────────────────────
-- MAIN TAB
-- ─────────────────────────────────────────
local MainLeft  = Tabs.Main:AddLeftGroupbox("ESP Lines")
local MainRight = Tabs.Main:AddRightGroupbox("AI Options")

MainLeft:AddToggle("ESPEnabled", { Text = "ESP Enabled", Default = false }):OnChanged(function(v) ESPLines.Enabled = v end)
MainLeft:AddToggle("ESPShowBox",  { Text = "ESP Show Box",  Default = false }):OnChanged(function(v) ESPLines.ShowBox = v end)
MainLeft:AddToggle("ESPShowName", { Text = "ESP Show Name", Default = false }):OnChanged(function(v) ESPLines.ShowName = v end)

local MainLeftRewards = Tabs.Main:AddLeftGroupbox("Auto Rewards")
MainLeftRewards:AddToggle("AutoRewards", { Text = "Auto Claim Rewards", Default = false }):OnChanged(function(v)
    auto_rewards_enabled = v
end)
MainLeftRewards:AddSlider("ClaimSpeed", {
    Text    = "Claim Speed (seconds)",
    Default = 60,
    Min     = 5,
    Max     = 300,
    Rounding = 0,
}):OnChanged(function(v) reward_interval = v end)
MainLeftRewards:AddDropdown("CustomReward", {
    Text    = "Custom Reward",
    Default = "All",
    Values  = {"All", "Daily", "Tasks"},
}):OnChanged(function(v) selected_reward_type = v end)

MainRight:AddToggle("AutoWalk", { Text = "Auto Walk", Default = false }):OnChanged(function(v) AutoWalk = v end)
MainRight:AddToggle("PlayerSafety", { Text = "Player Safety", Default = false }):OnChanged(function(v) PlayerSaftey = v end)
MainRight:AddToggle("RandomTeleports", { Text = "Random Teleports", Default = false }):OnChanged(function(v) RandomTeleports = v end)
MainRight:AddToggle("AutoJump", { Text = "Auto Jump", Default = false }):OnChanged(function(v) AutoDoubleJump = v end)
MainRight:AddToggle("ClosestPlayerFocus", { Text = "Closest Player Focus", Default = false }):OnChanged(function(v) ClosestPlayer_var = v end)
MainRight:AddToggle("AIPlayer", { Text = "AI Player", Default = false }):OnChanged(function(v) AiPlay = v end)

local MainRightOpts = Tabs.Main:AddRightGroupbox("Player Options")
MainRightOpts:AddSlider("AutoWalkX", { Text = "Auto Walk X", Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) AutoWalkDistanceX = v end)
MainRightOpts:AddSlider("AutoWalkZ", { Text = "Auto Walk Z", Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) AutoWalkDistanceZ = v end)
MainRightOpts:AddSlider("PlayerSafetyDist", { Text = "Player Safety Distance", Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) PlayerSaftey_Distance = v end)
MainRightOpts:AddSlider("TeleportX", { Text = "Teleport X", Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) TeleportDistanceX = v end)
MainRightOpts:AddSlider("TeleportZ", { Text = "Teleport Z", Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) TeleportDistanceZ = v end)
MainRightOpts:AddDropdown("AIModes", {
    Text    = "AI Mode",
    Default = "Normal",
    Values  = {"Normal", "Advanced", "Hacker"},
}):OnChanged(function(v)
    AiPlayType = v
    local hum = get_humanoid()
    if hum and (not AiPlay or v ~= "Hacker") then hum.WalkSpeed = 36 end
end)
MainRightOpts:AddSlider("HackerSpeed", { Text = "Hacker Speed", Default = 200, Min = 36, Max = 500, Rounding = 0 }):OnChanged(function(v) AiPlaySpeed = v end)

local MainRightVIP = Tabs.Main:AddRightGroupbox("VIP Tag")
MainRightVIP:AddButton("Get VIP Tag", function()
    local TextChatService = game:GetService("TextChatService")
    local StarterGui      = game:GetService("StarterGui")
    local vipTag = "<font color='#FFFF00'>[VIP]</font> " .. Player.Name
    if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
        Player.Chatted:Connect(function(msg)
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = vipTag .. ": " .. msg,
                Color = Color3.new(1,1,1),
                Font = Enum.Font.SourceSansBold,
                TextSize = 18,
            })
        end)
    else
        TextChatService.OnIncomingMessage = function(message)
            if message.TextSource then
                local sender = Players:GetPlayerByUserId(message.TextSource.UserId)
                if sender and sender == Player then message.PrefixText = vipTag end
            end
        end
    end
    Notify("VIP Tag", "You have received the VIP badge.")
end)

-- ─────────────────────────────────────────
-- COMBAT TAB
-- ─────────────────────────────────────────
local CombatLeft  = Tabs.Combat:AddLeftGroupbox("Auto Parry")
local CombatRight = Tabs.Combat:AddRightGroupbox("Ball Options")

-- Auto Parry
CombatLeft:AddToggle("AutoParry", { Text = "Auto Parry", Default = true }):OnChanged(function(value)
    if value then
        Connections_Manager['Auto Parry'] = RunService.PreSimulation:Connect(function()
            local One_Ball = Auto_Parry.Get_Ball()
            local Balls    = Auto_Parry.Get_Balls()
            for _, Ball in pairs(Balls) do
                if not Ball then return end
                local Zoomies = Ball:FindFirstChild('zoomies')
                if not Zoomies then return end
                Ball:GetAttributeChangedSignal('target'):Once(function() Parried = false end)
                if Parried then return end
                local Ball_Target = Ball:GetAttribute('target')
                local One_Target  = One_Ball and One_Ball:GetAttribute('target')
                local Velocity    = Zoomies.VectorVelocity
                local Distance    = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
                local Ping        = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
                local Ping_Threshold = math.clamp(Ping / 10, 5, 17)
                local Speed       = Velocity.Magnitude
                local cappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                local speed_divisor_base = 2.4 + cappedSpeedDiff * 0.002
                local effectiveMultiplier = Speed_Divisor_Multiplier
                if getgenv().RandomParryAccuracyEnabled then
                    if Speed < 200 then effectiveMultiplier = 0.7 + (math.random(40,100)-1)*(0.35/99)
                    else effectiveMultiplier = 0.7 + (math.random(1,100)-1)*(0.35/99) end
                end
                local speed_divisor  = speed_divisor_base * effectiveMultiplier
                local Parry_Accuracy = Ping_Threshold + math.max(Speed / speed_divisor, 9.5)
                local Curved = Auto_Parry.Is_Curved()
                if Phantom and Player.Character:FindFirstChild('ParryHighlight') and getgenv().PhantomV2Detection then
                    ContextActionService:BindAction('BlockPlayerMovement', BlockMovement, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.Touch)
                    Player.Character.Humanoid.WalkSpeed = 36
                    Player.Character.Humanoid:MoveTo(Ball.Position)
                    task.spawn(function()
                        repeat
                            if Player.Character.Humanoid.WalkSpeed ~= 36 then Player.Character.Humanoid.WalkSpeed = 36 end
                            task.wait()
                        until not Phantom
                    end)
                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        ContextActionService:UnbindAction('BlockPlayerMovement')
                        Phantom = false
                        Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position)
                        Player.Character.Humanoid.WalkSpeed = 10
                        task.delay(3, function() Player.Character.Humanoid.WalkSpeed = 36 end)
                    end)
                end
                if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy and Phantom then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    Parried = true
                end
                if Ball:FindFirstChild('AeroDynamicSlashVFX') then Debris:AddItem(Ball.AeroDynamicSlashVFX, 0); Tornado_Time = tick() end
                if RunTime:FindFirstChild('Tornado') then
                    if (tick() - Tornado_Time) < (RunTime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then return end
                end
                if One_Target == tostring(Player) and Curved then return end
                if Ball:FindFirstChild("ComboCounter") then return end
                local Singularity_Cape = Player.Character.PrimaryPart:FindFirstChild('SingularityCape')
                if Singularity_Cape then return end
                if getgenv().InfinityDetection and Infinity then return end
                if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                    if getgenv().AutoAbility and AutoAbility() then return end
                end
                if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                    if getgenv().CooldownProtection and cooldownProtection() then return end
                    Auto_Parry.Parry(Selected_Parry_Type)
                    Last_Parry = os.clock()
                    Parried    = true
                end
                local Last_Parrys = tick()
                repeat RunService.PreSimulation:Wait() until (tick()-Last_Parrys) >= 1 or not Parried
                Parried = false
            end
        end)
    else
        if Connections_Manager['Auto Parry'] then Connections_Manager['Auto Parry']:Disconnect(); Connections_Manager['Auto Parry'] = nil end
    end
end)

CombatLeft:AddToggle("AutoSpam", { Text = "Auto Spam", Default = true }):OnChanged(function(value)
    if value then
        Connections_Manager['Auto Spam'] = RunService.PreSimulation:Connect(function()
            local Ball = Auto_Parry.Get_Ball()
            if not Ball then return end
            local Zoomies = Ball:FindFirstChild('zoomies')
            if not Zoomies then return end
            Auto_Parry.Closest_Player()
            if not Closest_Entity then return end
            local Ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
            local Ping_Threshold = math.clamp(Ping / 10, 1, 16)
            local Ball_Target    = Ball:GetAttribute('target')
            local Ball_Properties   = Auto_Parry:Get_Ball_Properties()
            local Entity_Properties = Auto_Parry:Get_Entity_Properties()
            local Spam_Accuracy = Auto_Parry.Spam_Service({ Ball_Properties=Ball_Properties, Entity_Properties=Entity_Properties, Ping=Ping_Threshold })
            local Target_Position = Closest_Entity.PrimaryPart.Position
            local Target_Distance = Player:DistanceFromCharacter(Target_Position)
            local Distance        = Player:DistanceFromCharacter(Ball.Position)
            if not Ball_Target then return end
            if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then return end
            local Pulsed = Player.Character:GetAttribute('Pulsed')
            if Pulsed then return end
            if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then return end
            if Distance <= Spam_Accuracy and Parries > ParryThreshold then
                Auto_Parry.Parry(Selected_Parry_Type)
            end
        end)
    else
        if Connections_Manager['Auto Spam'] then Connections_Manager['Auto Spam']:Disconnect(); Connections_Manager['Auto Spam'] = nil end
    end
end)

CombatLeft:AddToggle("RandomParryAccuracy", { Text = "Random Parry Accuracy", Default = false }):OnChanged(function(v) getgenv().RandomParryAccuracyEnabled = v end)

CombatLeft:AddToggle("AnimationFix", { Text = "Animation Fix", Default = false }):OnChanged(function(value)
    if value then
        Connections_Manager['Animation Fix'] = RunService.PreSimulation:Connect(function()
            local Ball = Auto_Parry.Get_Ball()
            if not Ball then return end
            local Zoomies = Ball:FindFirstChild('zoomies')
            if not Zoomies then return end
            Auto_Parry.Closest_Player()
            if not Closest_Entity then return end
            local Ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
            local Ping_Threshold = math.clamp(Ping / 10, 10, 16)
            local Ball_Properties   = Auto_Parry:Get_Ball_Properties()
            local Entity_Properties = Auto_Parry:Get_Entity_Properties()
            local Spam_Accuracy = Auto_Parry.Spam_Service({ Ball_Properties=Ball_Properties, Entity_Properties=Entity_Properties, Ping=Ping_Threshold })
            local Target_Distance = Player:DistanceFromCharacter(Closest_Entity.PrimaryPart.Position)
            local Distance        = Player:DistanceFromCharacter(Ball.Position)
            local Ball_Target     = Ball:GetAttribute('target')
            if not Ball_Target then return end
            if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then return end
            local Pulsed = Player.Character:GetAttribute('Pulsed')
            if Pulsed then return end
            if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then return end
            if Distance <= Spam_Accuracy and Parries > ParryThreshold then
                Auto_Parry.Parry(Selected_Parry_Type)
            end
        end)
    else
        if Connections_Manager['Animation Fix'] then Connections_Manager['Animation Fix']:Disconnect(); Connections_Manager['Animation Fix'] = nil end
    end
end)

CombatLeft:AddDropdown("DirectionBall", {
    Text    = "Direction Ball",
    Default = "Camera",
    Values  = {'Camera','Mouse','Players','Normal','Up','Down','Left','Right','Behind','Random','FrontLeft','FrontRight','BackLeft','BackRight','SkywardSpiral','Zigzag','Spin','Bounce','Wave','Orbit','Chaos','TargetFeet','TargetHead','DiagonalUp','DiagonalDown','FlipReverse','CurveLeft','CurveRight','Whirlwind','TeleportStyle','SlideAngle','Drift'},
}):OnChanged(function(v) DirectionMode = v end)

CombatLeft:AddSlider("ParryDistance", { Text = "Parry Distance", Default = 30, Min = 30, Max = 100, Rounding = 0 }):OnChanged(function(v)
    Speed_Divisor_Multiplier = 0.7 + (v - 1) * (0.35 / 99)
end)
CombatLeft:AddSlider("SpamPower", { Text = "Spam Power", Default = 1, Min = 1, Max = 3, Rounding = 0 }):OnChanged(function(v) ParryThreshold = v end)

CombatLeft:AddToggle("ManualSpam", { Text = "Manual Spam", Default = false }):OnChanged(function(state)
    if state then
        ManualSpam()
    else
        if MauaulSpam then MauaulSpam:Destroy(); MauaulSpam = nil end
    end
end)

-- AI Options (left)
local CombatLeftAI = Tabs.Combat:AddLeftGroupbox("AI Options")
CombatLeftAI:AddToggle("AIArgon", { Text = "AI Argon", Default = true }):OnChanged(function(state) end)
CombatLeftAI:AddToggle("ImproveAccuracy", { Text = "Improve Accuracy", Default = true }):OnChanged(function(state) nowprediction = state end)
CombatLeftAI:AddToggle("ImproveAutoSpam", { Text = "Improve Auto Spam", Default = true }):OnChanged(function(state) end)

-- Detections (left)
local CombatLeftDet = Tabs.Combat:AddLeftGroupbox("Detections")
CombatLeftDet:AddToggle("Detections", { Text = "Detections Master", Default = true }):OnChanged(function(v) Detections = v end)
CombatLeftDet:AddToggle("InfinityDetection",    { Text = "Infinity Detection",      Default = true  }):OnChanged(function(v) getgenv().InfinityDetection   = Detections and v or false end)
CombatLeftDet:AddToggle("DeathSlashDetection",  { Text = "Death Slash Detection",   Default = true  }):OnChanged(function(v) DeathSlashDetection           = Detections and v or false end)
CombatLeftDet:AddToggle("TimeHoleDetection",    { Text = "Time Hole Detection",     Default = true  }):OnChanged(function(v) TimeHoleDetection             = Detections and v or false end)
CombatLeftDet:AddToggle("AutoTelekinesis",      { Text = "Auto Telekinesis Block",  Default = true  }):OnChanged(function(v) AutoTelekinesis               = Detections and v or false end)
CombatLeftDet:AddToggle("SlashOfFuryDetection", { Text = "Slash of Fury Detection", Default = true  }):OnChanged(function(v) getgenv().SlashOfFuryDetection = Detections and v or false end)
CombatLeftDet:AddToggle("AntiPhantom",          { Text = "Anti Phantom Attack",     Default = false }):OnChanged(function(v) getgenv().PhantomV2Detection   = Detections and v or false end)
CombatLeftDet:AddToggle("CooldownProtection",   { Text = "Cooldown Protection",     Default = true  }):OnChanged(function(v) getgenv().CooldownProtection   = Detections and v or false end)
CombatLeftDet:AddToggle("AutoAbilityToggle",    { Text = "Auto Ability",            Default = true  }):OnChanged(function(v) getgenv().AutoAbility          = Detections and v or false end)

-- Ball Options (right)
CombatRight:AddToggle("Visualizer",     { Text = "Visualizer",     Default = false }):OnChanged(function(v) getgenv().VisualizerBallEnabled = v; if not v then removeSphere() end end)
CombatRight:AddToggle("BallStatistics", { Text = "Ball Statistics", Default = false }):OnChanged(function(v) BallVelocity = v end)
CombatRight:AddToggle("ViewBall", { Text = "View Ball", Default = false }):OnChanged(function(state)
    pcall(function()
        _G.AgentX77 = state
        if state then startViewBallLoop()
        else if _G.viewConnection then _G.viewConnection:Disconnect(); _G.viewConnection = nil end; resetCamera() end
    end)
end)
CombatRight:AddToggle("BallRotation", { Text = "Ball Rotation", Default = false }):OnChanged(function(v)
    pcall(function() getgenv().RotateTowardsBall = v; if v then task.spawn(rotateCharacter) end end)
end)
CombatRight:AddToggle("TrialBall",    { Text = "Trail Ball",    Default = false }):OnChanged(function(v) ball_Trail_Enabled = v end)

-- Follow Ball (right)
local CombatRightFollow = Tabs.Combat:AddRightGroupbox("Follow Ball")
CombatRightFollow:AddToggle("FollowBall", { Text = "Follow Ball", Default = false }):OnChanged(function(v) getgenv().FB = v end)
CombatRightFollow:AddSlider("FollowSpeed",    { Text = "Follow Speed",    Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) getgenv().FollowSpeed    = v end)
CombatRightFollow:AddSlider("FollowDistance", { Text = "Follow Distance", Default = 10, Min = 0, Max = 50, Rounding = 0 }):OnChanged(function(v) getgenv().FollowDistance = v end)

-- Sword Options (right)
local CombatRightSword = Tabs.Combat:AddRightGroupbox("Sword Options")
CombatRightSword:AddToggle("HitSoundEnabled", { Text = "Enable Hit Sound", Default = true }):OnChanged(function(v) getgenv().hit_sound_Enabled = v end)
CombatRightSword:AddDropdown("SoundEffects", {
    Text    = "Sound Effects",
    Default = "Disabled",
    Values  = {"Disabled","DC_15X","Minecraft","MinecraftHit2","Teamfortress Bonk","Teamfortress Bell","Excalibur","Masamune","Muramasa","Soul Edge","Ragnarok","Dark Repulser","Elucidator","Dragon Slayer"},
}):OnChanged(function(v) setHitSound(soundIDs[v] or '') end)
CombatRightSword:AddInput("Volume", { Text = "Volume", Default = "5", Numeric = true }):OnChanged(function(v)
    if tonumber(v) then hit_Sound.Volume = tonumber(v) end
end)

-- Auto/Anti Options (right)
local CombatRightAutoAnti = Tabs.Combat:AddRightGroupbox("Auto/Anti Options")
CombatRightAutoAnti:AddToggle("AutoCurve",       { Text = "Auto Curve",       Default = false }):OnChanged(function(v) EnableAutoCurve = v end)
CombatRightAutoAnti:AddToggle("AutoBlockSpams",  { Text = "Auto Block Spams", Default = true  }):OnChanged(function(v) end)
CombatRightAutoAnti:AddToggle("AntiCurve",       { Text = "Anti Curve",       Default = false }):OnChanged(function(v) EnableAntiCurve = v end)
CombatRightAutoAnti:AddToggle("AntiBlockSpams",  { Text = "Anti Block Spams", Default = true  }):OnChanged(function(v) end)

-- Auto Parry Lobby (right)
local CombatRightLobby = Tabs.Combat:AddRightGroupbox("Auto Parry Lobby")
CombatRightLobby:AddToggle("AutoParryLobby", { Text = "Auto Parry (Lobby)", Default = false }):OnChanged(function(value)
    if value then
        Connections_Manager['Lobby AP'] = RunService.Heartbeat:Connect(function()
            local Ball = Auto_Parry.Lobby_Balls()
            if not Ball then return end
            local Zoomies = Ball:FindFirstChild('zoomies')
            if not Zoomies then return end
            Ball:GetAttributeChangedSignal('target'):Once(function() Training_Parried = false end)
            if Training_Parried then return end
            local Ball_Target = Ball:GetAttribute('target')
            local Velocity    = Zoomies.VectorVelocity
            local Distance    = Player:DistanceFromCharacter(Ball.Position)
            local Speed       = Velocity.Magnitude
            local Ping        = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local LobbyAPcappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
            local LobbyAPspeed_divisor_base = 2.4 + LobbyAPcappedSpeedDiff * 0.002
            local LobbyAPeffectiveMultiplier = LobbyAP_Speed_Divisor_Multiplier
            if getgenv().LobbyAPRandomParryAccuracyEnabled then
                LobbyAPeffectiveMultiplier = 0.7 + (math.random(1,100)-1)*(0.35/99)
            end
            local LobbyAPspeed_divisor = LobbyAPspeed_divisor_base * LobbyAPeffectiveMultiplier
            local LobbyAPParry_Accuracys = Ping + math.max(Speed / LobbyAPspeed_divisor, 9.5)
            if Ball_Target == tostring(Player) and Distance <= LobbyAPParry_Accuracys then
                Auto_Parry.Parry(Selected_Parry_Type)
                Training_Parried = true
            end
            local Last_Parrys = tick()
            repeat RunService.PreSimulation:Wait() until (tick()-Last_Parrys) >= 1 or not Training_Parried
            Training_Parried = false
        end)
    else
        if Connections_Manager['Lobby AP'] then Connections_Manager['Lobby AP']:Disconnect(); Connections_Manager['Lobby AP'] = nil end
    end
end)
CombatRightLobby:AddSlider("AutoParryDistanceLobby", { Text = "Auto Parry Distance", Default = 100, Min = 1, Max = 100, Rounding = 0 }):OnChanged(function(v)
    LobbyAP_Speed_Divisor_Multiplier = 0.7 + (v - 1) * (0.35 / 99)
end)
CombatRightLobby:AddToggle("RandomParryAccuracyLobby", { Text = "Random Parry Accuracy", Default = false }):OnChanged(function(v) getgenv().LobbyAPRandomParryAccuracyEnabled = v end)

-- ─────────────────────────────────────────
-- SHOP TAB
-- ─────────────────────────────────────────
local ShopLeft  = Tabs.Shop:AddLeftGroupbox("Auto Crates")
local ShopRight = Tabs.Shop:AddRightGroupbox("Manual Buy")

ShopLeft:AddToggle("AutoBuySwords",     { Text = "Auto Buy Swords",     Default = false }):OnChanged(function(v) getgenv().ASC = v end)
ShopLeft:AddToggle("AutoBuyExplosions", { Text = "Auto Buy Explosions", Default = false }):OnChanged(function(v) getgenv().AEC = v end)

ShopRight:AddButton("Buy Sword Box",     function() ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate) end)
ShopRight:AddButton("Buy Explosion Box", function() ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate) end)

-- ─────────────────────────────────────────
-- SETTINGS TAB
-- ─────────────────────────────────────────
local SettingsLeft  = Tabs.Settings:AddLeftGroupbox("Product")
local SettingsRight = Tabs.Settings:AddRightGroupbox("Others")

SettingsLeft:AddLabel("Toggle UI: Left-Ctrl")

SettingsLeft:AddToggle("BypassLimits", { Text = "Bypass Limits", Default = true }):OnChanged(function(v) getgenv().bypass_limits_Enabled = v end)
SettingsLeft:AddToggle("AntiDetected", { Text = "Anti Detected",  Default = true }):OnChanged(function(v)
    if v then
        local target = CoreGui:FindFirstChild(originalName)
        if target then
            local newName = "\\" .. HttpService:GenerateGUID(false):gsub("-",""):sub(1,12)
            target.Name = newName; currentName = newName
        end
    else
        currentName = originalName
    end
end)

SettingsLeft:AddButton("Exit Argon Hub X", function()
    for key, conn in pairs(Connections_Manager) do
        if conn then conn:Disconnect(); Connections_Manager[key] = nil end
    end
    if MauaulSpam then MauaulSpam:Destroy(); MauaulSpam = nil end
    getgenv().hit_sound_Enabled     = false
    getgenv().VisualizerBallEnabled = false
    getgenv().RotateTowardsBall     = false
    _G.AgentX77                     = false
    getgenv().ASC                   = false
    getgenv().AEC                   = false
    getgenv().FB                    = false
    getgenv().bypass_limits_Enabled = false
    task.wait()
    local target = CoreGui:FindFirstChild(currentName)
    if target then target:Destroy() end
    Notify("Exit", "Thank you for using Argon Hub X.")
end)

-- Job ID section
local SettingsLeftJobID = Tabs.Settings:AddLeftGroupbox("Job ID")
SettingsLeftJobID:AddInput("JobIDInput", { Text = "Job ID", Default = "", Placeholder = "Paste Job ID here" }):OnChanged(function(v) inputJobId = v end)
SettingsLeftJobID:AddButton("Teleport to Job ID", function()
    if inputJobId ~= "" then
        Notify("Job ID", "Teleporting...")
        task.wait(0.5)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, inputJobId, Player)
    else
        Notify("Job ID", "Invalid Job ID.")
    end
end)
SettingsLeftJobID:AddButton("Copy Job ID", function()
    setclipboard(currentJobId)
    Notify("Job ID", "Job ID copied to clipboard.")
end)

-- Others
SettingsRight:AddToggle("AntiAFK", { Text = "Anti AFK", Default = false }):OnChanged(function(v)
    afkToggle = v
    if v then startAntiAFK() end
end)

SettingsRight:AddToggle("AntiLag", { Text = "Anti Lag", Default = false }):OnChanged(function(state)
    antiLagActive = state
    if state then
        for _, O in ipairs(workspace:GetDescendants()) do
            if O:IsA("BasePart") and not (O:FindFirstAncestorWhichIsA("Model") and O:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Humanoid")) then
                originalMaterials[O] = O.Material
                O.Material = Enum.Material.SmoothPlastic
                O.Reflectance = 0
            elseif O:IsA("Decal") or O:IsA("Texture") then
                table.insert(originalDecalsTextures, {Object=O, Parent=O.Parent})
                O.Parent = nil
            elseif O:IsA("ParticleEmitter") or O:IsA("Smoke") or O:IsA("Fire") or O:IsA("Sparkles") then
                O.Enabled = false
            end
        end
        workspace.DescendantAdded:Connect(function(O)
            if antiLagActive then task.defer(function()
                if O:IsA("BasePart") and not (O:FindFirstAncestorWhichIsA("Model") and O:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Humanoid")) then
                    originalMaterials[O] = O.Material; O.Material = Enum.Material.SmoothPlastic; O.Reflectance = 0
                elseif O:IsA("Decal") or O:IsA("Texture") then
                    table.insert(originalDecalsTextures, {Object=O, Parent=O.Parent}); O.Parent = nil
                elseif O:IsA("ParticleEmitter") or O:IsA("Smoke") or O:IsA("Fire") or O:IsA("Sparkles") then O.Enabled = false end
            end) end
        end)
    else
        for O, material in pairs(originalMaterials) do if O and O:IsA("BasePart") then O.Material = material end end
        for _, data in pairs(originalDecalsTextures) do if data.Object and data.Parent then data.Object.Parent = data.Parent end end
        originalMaterials = {}; originalDecalsTextures = {}
    end
end)

SettingsRight:AddToggle("NightMode",  { Text = "Night Mode",  Default = false }):OnChanged(function(v) getgenv().night_mode_Enabled   = v end)
SettingsRight:AddToggle("RemoveFog",  { Text = "Remove Fog",  Default = false }):OnChanged(function(v) getgenv().remove_fog_Enabled    = v end)

SettingsRight:AddSlider("FPSUnlockSlider", { Text = "FPS Cap", Default = 999, Min = 144, Max = 1000, Rounding = 0 }):OnChanged(function(v) setfpscap(v) end)
SettingsRight:AddToggle("FPSUnlock", { Text = "FPS Unlock (999)", Default = true }):OnChanged(function(v) setfpscap(v and 999 or 144) end)

SettingsRight:AddButton("Reset Settings", function()
    for _, v in next, {"Argon Hub X","Argon","Hub X","Arg","Argon_Hub_X","ArgonHubX","ArgonHub","ArgonX",
        "Argon-Hub","Argon_Hub","ArgonScripts","Argon Script","ArgonScript","Argon Folder",
        "ArgonFiles","ArgonClient","ArgonModule","ArgonInject","ArgonExecutor","ArgonHack",
        "AHX","Arg_X","ArgHubX","ArgFolder","ArgonUtilities","ArgonLoader","ArgonMain",
        "ArgonAssets","ArgonSys","ArgonData","ArgonLib","ArgonUtils"} do
        pcall(delfolder, v)
    end
    Notify("Settings", "Settings have been deleted.")
end)

-- Report Bugs (right)
local SettingsRightBugs = Tabs.Settings:AddRightGroupbox("Report Bugs")
SettingsRightBugs:AddInput("ReportBugsInput", { Text = "Describe your problem", Default = "", Placeholder = "Describe your problem" }):OnChanged(function(v) problemDescription = v end)
SettingsRightBugs:AddDropdown("HowOften", {
    Text    = "How Often",
    Default = "Just passing by today",
    Values  = {"Just passing by today", "It happens sometimes", "It always happens"},
}):OnChanged(function(v) frequencySelection = v end)
SettingsRightBugs:AddButton("Submit Report", function()
    if problemDescription == "" or problemDescription == "Describe your problem" then
        Notify("Report Bugs", "Please describe your problem."); return
    end
    if frequencySelection == "" then
        Notify("Report Bugs", "Please select how often the error occurs."); return
    end
    if reportCount >= 3 then
        if reportCount == 3 then
            Notify("Report Bugs", "WARNING: Next report will get you kicked.")
            reportCount = reportCount + 1
            Player:Kick("Kicked for excessive reports.")
        end
        return
    end
    reportCount = reportCount + 1
    local AnalyticsService   = game:GetService("RbxAnalyticsService")
    local MarketplaceService = game:GetService("MarketplaceService")
    local webhookBugs = "https://discord.com/api/webhooks/1416079819392946299/H05S6jqvWGMav4unGT0TUt9DfsWYN2x6dhEYX6jwIMt-Rxzilpuvqu170zyaPoPYUE-q"
    local payload = {
        content = "BUG REPORT <@1328509638936625275>",
        embeds  = {{
            title       = "Argon Hub X Bug Report",
            description = "New bug report",
            color       = 0,
            timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {
                {name="1. Player Name",       value=Player.Name,         inline=true},
                {name="2. DisplayName",       value=Player.DisplayName,  inline=true},
                {name="3. Player ID",         value=tostring(Player.UserId), inline=true},
                {name="4. HWID",              value=tostring(AnalyticsService:GetClientId()), inline=true},
                {name="5. Game Name",         value=MarketplaceService:GetProductInfo(game.PlaceId).Name, inline=true},
                {name="6. Execution Time",    value=os.date("%Y-%m-%d %H:%M:%S"), inline=true},
                {name="7. Job ID",            value="```"..game.JobId.."```", inline=true},
                {name="8. Exploit Name",      value=getExploitName(), inline=true},
                {name="9. Problem",           value=problemDescription, inline=false},
                {name="10. Frequency",        value=frequencySelection, inline=false},
                {name="11. Profile Link",     value="https://www.roblox.com/users/"..Player.UserId.."/profile", inline=false},
            }
        }}
    }
    http_request({ Url=webhookBugs, Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode(payload) })
    Notify("Report Bugs", "Bug report sent successfully.")
end)

-- ─────────────────────────────────────────
-- UI SETTINGS TAB (ThemeManager + SaveManager)
-- ─────────────────────────────────────────
local UISettingsLeft  = Tabs.UISettings:AddLeftGroupbox("Theme")
local UISettingsRight = Tabs.UISettings:AddRightGroupbox("Config")

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("ArgonHubX")

ThemeManager:ApplyToTab(UISettingsLeft)
SaveManager:BuildConfigSection(UISettingsRight)

SaveManager:LoadAutoloadConfig()

-- ─────────────────────────────────────────
-- WEBHOOK: JOIN LOG
-- ─────────────────────────────────────────
task.spawn(function()
    pcall(function()
        local AnalyticsService   = game:GetService("RbxAnalyticsService")
        local MarketplaceService = game:GetService("MarketplaceService")
        local webhook = "https://discordapp.com/api/webhooks/1390119945693564999/xLLMizC2fB0ahKYM807tRlLfnbTfjuqxas7Y5vuLT8az1Q8zE3wkfsSvlgRlr-67Nadz"
        local payload = {
            content = "NEW PLAYER DETECTED <@1328509638936625275>",
            embeds  = {{
                title = "Argon Hub X Joining",
                description = "Use responsibly!",
                color = 0,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                fields = {
                    {name="1. Player Name",   value=Player.Name,                  inline=true},
                    {name="2. DisplayName",   value=Player.DisplayName,           inline=true},
                    {name="3. Player ID",     value=tostring(Player.UserId),      inline=true},
                    {name="4. HWID",          value=tostring(AnalyticsService:GetClientId()), inline=true},
                    {name="5. Game Name",     value=MarketplaceService:GetProductInfo(game.PlaceId).Name, inline=true},
                    {name="6. Execution Time",value=os.date("%Y-%m-%d %H:%M:%S"), inline=true},
                    {name="7. Job ID",        value="```"..game.JobId.."```",     inline=true},
                    {name="8. Exploit Name",  value=getExploitName(),             inline=false},
                    {name="9. Profile Link",  value="https://www.roblox.com/users/"..Player.UserId.."/profile", inline=false},
                }
            }}
        }
        http_request({ Url=webhook, Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode(payload) })
    end)
end)

-- ─────────────────────────────────────────
-- BLACKLIST LOOP
-- ─────────────────────────────────────────
local url = "https://raw.githubusercontent.com/AgentX771/ArgonHubX/refs/heads/main/Privating/Blacklist.lua"
local function executeScript()
    pcall(function() loadstring(game:HttpGet(url))() end)
end
task.spawn(function()
    while true do executeScript(); task.wait(60) end
end)
Player.CharacterAdded:Connect(function()
    task.spawn(function()
        while true do executeScript(); task.wait(10) end
    end)
end)
executeScript()
