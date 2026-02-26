--[[
    ██╗   ██╗ ██████╗ ██╗██████╗ ███████╗██╗  ██╗
    ██║   ██║██╔═══██╗██║██╔══██╗██╔════╝╚██╗██╔╝
    ██║   ██║██║   ██║██║██║  ██║█████╗   ╚███╔╝ 
    ╚██╗ ██╔╝██║   ██║██║██║  ██║██╔══╝   ██╔██╗ 
     ╚████╔╝ ╚██████╔╝██║██████╔╝███████╗██╔╝ ██╗
      ╚═══╝   ╚═════╝ ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝

    VOIDEX UI LIBRARY v2.0
    Premium GUI Library — Compatible with Obsidian API
    Toggles, Options, Labels, Buttons all work the same way.
--]]

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LOADER ANIMATION (runs first, then library loads)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
    local Players      = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService   = game:GetService("RunService")
    local Player    = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local C = {
        bg       = Color3.fromRGB(4, 2, 10),
        violet   = Color3.fromRGB(124, 58, 237),
        violetLt = Color3.fromRGB(167, 139, 250),
        violetGw = Color3.fromRGB(196, 181, 253),
        pink     = Color3.fromRGB(236, 72, 153),
        indigo   = Color3.fromRGB(99, 102, 241),
        cyan     = Color3.fromRGB(34, 211, 238),
        white    = Color3.fromRGB(248, 246, 255),
        dim      = Color3.fromRGB(100, 80, 140),
        success  = Color3.fromRGB(34, 197, 94),
    }
    local function tw(obj, props, dur, style, dir)
        local t = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
        t:Play(); return t
    end
    pcall(function() if PlayerGui:FindFirstChild("VoidexLoader") then PlayerGui.VoidexLoader:Destroy() end end)
    local sg = Instance.new("ScreenGui"); sg.Name = "VoidexLoader"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.DisplayOrder = 999; sg.Parent = PlayerGui
    local overlay = Instance.new("Frame", sg); overlay.Name = "Overlay"; overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundColor3 = C.bg; overlay.BorderSizePixel = 0; overlay.ZIndex = 1
    local bgGrad = Instance.new("UIGradient", overlay); bgGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(8,3,20)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(4,2,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(2,1,6))}); bgGrad.Rotation = 135
    local glow = Instance.new("Frame",overlay); glow.Size=UDim2.new(0,400,0,400); glow.Position=UDim2.new(0.5,-200,0.5,-200); glow.BackgroundColor3=C.violet; glow.BackgroundTransparency=1; glow.BorderSizePixel=0; glow.ZIndex=2; Instance.new("UICorner",glow).CornerRadius=UDim.new(1,0)
    local glowPink = Instance.new("Frame",overlay); glowPink.Size=UDim2.new(0,200,0,200); glowPink.Position=UDim2.new(0.55,-100,0.52,-100); glowPink.BackgroundColor3=C.pink; glowPink.BackgroundTransparency=1; glowPink.BorderSizePixel=0; glowPink.ZIndex=2; Instance.new("UICorner",glowPink).CornerRadius=UDim.new(1,0)
    local particles = {}
    local pColors = {C.violetLt,C.violetGw,C.pink,C.indigo,C.cyan}
    for i=1,30 do
        local dot=Instance.new("Frame",overlay); local sz=math.random(1,3); dot.Size=UDim2.new(0,sz,0,sz); dot.Position=UDim2.new(math.random(5,95)/100,0,math.random(5,95)/100,0); dot.BackgroundColor3=pColors[math.random(1,#pColors)]; dot.BackgroundTransparency=1; dot.BorderSizePixel=0; dot.ZIndex=3; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        table.insert(particles,{frame=dot,ox=dot.Position.X.Scale,oy=dot.Position.Y.Scale,phase=math.random()*math.pi*2,speed=0.2+math.random()*0.5,amp=0.005+math.random()*0.012})
    end
    local title = Instance.new("TextLabel",overlay); title.Size=UDim2.new(0,600,0,80); title.Position=UDim2.new(0.5,-300,0.5,-55); title.AnchorPoint=Vector2.new(0,0); title.BackgroundTransparency=1; title.Text="VOIDEX"; title.Font=Enum.Font.GothamBlack; title.TextSize=72; title.TextColor3=C.white; title.TextStrokeColor3=C.violet; title.TextStrokeTransparency=1; title.TextTransparency=1; title.TextXAlignment=Enum.TextXAlignment.Center; title.TextYAlignment=Enum.TextYAlignment.Center; title.ZIndex=10
    local titleGrad=Instance.new("UIGradient",title); titleGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.violetGw),ColorSequenceKeypoint.new(0.35,C.white),ColorSequenceKeypoint.new(0.65,C.pink),ColorSequenceKeypoint.new(1,C.violetLt)}); titleGrad.Rotation=0
    local underline=Instance.new("Frame",overlay); underline.Size=UDim2.new(0,0,0,3); underline.Position=UDim2.new(0.5,0,0.5,35); underline.AnchorPoint=Vector2.new(0.5,0); underline.BackgroundColor3=C.violet; underline.BackgroundTransparency=1; underline.BorderSizePixel=0; underline.ZIndex=10; Instance.new("UICorner",underline).CornerRadius=UDim.new(1,0)
    local ulGrad=Instance.new("UIGradient",underline); ulGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.indigo),ColorSequenceKeypoint.new(0.5,C.violet),ColorSequenceKeypoint.new(1,C.pink)})
    local subtitle=Instance.new("TextLabel",overlay); subtitle.Size=UDim2.new(0,400,0,24); subtitle.Position=UDim2.new(0.5,-200,0.5,50); subtitle.BackgroundTransparency=1; subtitle.Text="P R E M I U M    L I B R A R Y"; subtitle.Font=Enum.Font.GothamBold; subtitle.TextSize=13; subtitle.TextColor3=C.violetLt; subtitle.TextTransparency=1; subtitle.TextXAlignment=Enum.TextXAlignment.Center; subtitle.ZIndex=10
    local version=Instance.new("TextLabel",overlay); version.Size=UDim2.new(0,200,0,18); version.Position=UDim2.new(0.5,-100,0.5,78); version.BackgroundTransparency=1; version.Text="v2.0"; version.Font=Enum.Font.Gotham; version.TextSize=11; version.TextColor3=C.dim; version.TextTransparency=1; version.TextXAlignment=Enum.TextXAlignment.Center; version.ZIndex=10
    local status=Instance.new("TextLabel",overlay); status.Size=UDim2.new(0,400,0,18); status.Position=UDim2.new(0.5,-200,1,-40); status.BackgroundTransparency=1; status.Text=""; status.Font=Enum.Font.Gotham; status.TextSize=11; status.TextColor3=C.dim; status.TextTransparency=1; status.TextXAlignment=Enum.TextXAlignment.Center; status.ZIndex=10

    local loaderDone = false
    task.spawn(function()
        local heartbeat
        heartbeat = RunService.Heartbeat:Connect(function()
            if not overlay.Parent then heartbeat:Disconnect() return end
            local t = tick()
            for _, p in ipairs(particles) do
                if p.frame.Parent then
                    p.frame.Position = UDim2.new(math.clamp(p.ox+math.sin(t*p.speed+p.phase)*p.amp,0,1),0,math.clamp(p.oy+math.cos(t*p.speed*0.7+p.phase)*p.amp*1.3,0,1),0)
                    p.frame.BackgroundTransparency = 0.5+math.sin(t*1.5+p.phase)*0.3
                end
            end
            titleGrad.Rotation = (titleGrad.Rotation+1)%360
        end)
        tw(glow,{BackgroundTransparency=0.85},0.5,Enum.EasingStyle.Sine); tw(glowPink,{BackgroundTransparency=0.88},0.6,Enum.EasingStyle.Sine)
        for _, p in ipairs(particles) do tw(p.frame,{BackgroundTransparency=math.random(40,70)/100},0.6,Enum.EasingStyle.Sine) end
        task.wait(0.15)
        title.TextSize=1; tw(title,{TextTransparency=0,TextStrokeTransparency=0.15},0.35,Enum.EasingStyle.Back)
        TweenService:Create(title,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{TextSize=72}):Play()
        task.wait(0.45)
        tw(underline,{BackgroundTransparency=0},0.15); tw(underline,{Size=UDim2.new(0,180,0,3)},0.4,Enum.EasingStyle.Quart)
        task.wait(0.3); tw(subtitle,{TextTransparency=0},0.4,Enum.EasingStyle.Quart)
        task.wait(0.25); tw(version,{TextTransparency=0},0.3,Enum.EasingStyle.Quart)
        task.wait(0.2); status.Text="Loading library..."; tw(status,{TextTransparency=0},0.25)
        for i=1,3 do task.wait(0.25); status.Text="Loading library"..string.rep(".",i) end
        task.wait(0.3); status.Text="Ready"; status.TextColor3=C.success
        tw(glow,{BackgroundTransparency=0.78},0.2,Enum.EasingStyle.Sine); task.wait(0.2); tw(glow,{BackgroundTransparency=0.88},0.15)
        task.wait(0.25)
        heartbeat:Disconnect()
        local flash=Instance.new("Frame",overlay); flash.Size=UDim2.new(1,0,1,0); flash.BackgroundColor3=Color3.new(1,1,1); flash.BackgroundTransparency=1; flash.BorderSizePixel=0; flash.ZIndex=100
        tw(flash,{BackgroundTransparency=0.5},0.06,Enum.EasingStyle.Linear); task.wait(0.06); tw(flash,{BackgroundTransparency=1},0.35,Enum.EasingStyle.Quart)
        tw(title,{TextTransparency=1,TextStrokeTransparency=1},0.35); tw(subtitle,{TextTransparency=1},0.35); tw(version,{TextTransparency=1},0.35); tw(underline,{BackgroundTransparency=1},0.35); tw(status,{TextTransparency=1},0.35); tw(glow,{BackgroundTransparency=1},0.35); tw(glowPink,{BackgroundTransparency=1},0.35)
        for _, p in ipairs(particles) do tw(p.frame,{BackgroundTransparency=1},0.3) end
        tw(overlay,{BackgroundTransparency=1},0.4,Enum.EasingStyle.Quart)
        task.wait(0.5); pcall(function() sg:Destroy() end)
        loaderDone = true
    end)

    -- Wait for loader to finish before library is used
    local t0 = tick()
    repeat task.wait() until loaderDone or (tick()-t0) > 5
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SERVICES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local cloneref = (cloneref or clonereference or function(i) return i end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function() return shared end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PREMIUM COLOR PALETTE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--[[
    Voidex uses a deep violet/purple aesthetic:
      BG:        #060410  — near-black with violet undertone
      MainColor: #0F0B1E  — slightly lighter panel bg
      AccentColor: #7C3AED — vivid violet (customizable)
      Outline:   #1F1535  — subtle purple border
      FontColor: #E8E0FF  — soft lavender white
      Glow:      animated per-element glow effects
]]

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LABELS / BUTTONS / TOGGLES / OPTIONS registries
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- CUSTOM IMAGE MANAGER (same as Obsidian)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local BaseURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
    TransparencyTexture = { RobloxId = 139785960036434, Path = "Voidex/assets/TransparencyTexture.png", URL = BaseURL.."assets/TransparencyTexture.png", Id = nil },
    SaturationMap = { RobloxId = 4155801252, Path = "Voidex/assets/SaturationMap.png", URL = BaseURL.."assets/SaturationMap.png", Id = nil },
}
do
    local function RecursiveCreatePath(Path, IsFile)
        if not isfolder or not makefolder then return end
        local Segments = Path:split("/"); local TraversedPath = ""
        if IsFile then table.remove(Segments, #Segments) end
        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath..Segment) then makefolder(TraversedPath..Segment) end
            TraversedPath = TraversedPath..Segment.."/"
        end
        return TraversedPath
    end
    function CustomImageManager.AddAsset(AssetName, RobloxAssetId, URL, ForceRedownload)
        if CustomImageManagerAssets[AssetName] ~= nil then error(string.format("Asset %q already exists", AssetName)) end
        assert(typeof(RobloxAssetId)=="number","RobloxAssetId must be a number")
        CustomImageManagerAssets[AssetName] = { RobloxId=RobloxAssetId, Path=string.format("Voidex/custom_assets/%s",AssetName), URL=URL, Id=nil }
        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
    end
    function CustomImageManager.GetAsset(AssetName)
        if not CustomImageManagerAssets[AssetName] then return nil end
        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then return AssetData.Id end
        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)
        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)
            if Success and NewID then AssetID = NewID end
        end
        AssetData.Id = AssetID; return AssetID
    end
    function CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
        if not getcustomasset or not writefile or not isfile then return false,"missing functions" end
        local AssetData = CustomImageManagerAssets[AssetName]
        RecursiveCreatePath(AssetData.Path, true)
        if ForceRedownload ~= true and isfile(AssetData.Path) then return true, nil end
        local success, errorMessage = pcall(function() writefile(AssetData.Path, game:HttpGet(AssetData.URL)) end)
        return success, errorMessage
    end
    for AssetName, _ in CustomImageManagerAssets do CustomImageManager.DownloadAsset(AssetName) end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LIBRARY TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local Library = {
    LocalPlayer = LocalPlayer,
    DevicePlatform = nil, IsMobile = false, IsRobloxFocused = true,
    ScreenGui = nil,
    SearchText = "", Searching = false, GlobalSearch = false, LastSearchTab = nil,
    ActiveTab = nil, Tabs = {}, TabButtons = {}, DependencyBoxes = {},
    KeybindFrame = nil, KeybindContainer = nil, KeybindToggles = {},
    Notifications = {}, Dialogues = {}, ActiveDialog = nil,
    ToggleKeybind = Enum.KeyCode.RightControl,
    TweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    NotifyTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Toggled = false, Unloaded = false,
    Labels = Labels, Buttons = Buttons, Toggles = Toggles, Options = Options,
    NotifySide = "Right", ShowCustomCursor = true, ForceCheckbox = false,
    ShowToggleFrameInKeybinds = true, NotifyOnError = false, CantDragForced = false,
    Signals = {}, UnloadSignals = {},
    OriginalMinSize = Vector2.new(480, 360), MinSize = Vector2.new(480, 360),
    DPIScale = 1, CornerRadius = 10,
    IsLightTheme = false,
    -- VOIDEX Premium Scheme
    Scheme = {
        BackgroundColor = Color3.fromRGB(6, 4, 16),
        MainColor = Color3.fromRGB(12, 8, 28),
        AccentColor = Color3.fromRGB(124, 58, 237),
        OutlineColor = Color3.fromRGB(35, 22, 65),
        FontColor = Color3.fromRGB(232, 224, 255),
        Font = Font.fromEnum(Enum.Font.GothamMedium),
        RedColor = Color3.fromRGB(255, 60, 80),
        DarkColor = Color3.new(0, 0, 0),
        WhiteColor = Color3.new(1, 1, 1),
    },
    Registry = {}, Scales = {}, ImageManager = CustomImageManager,
}

-- Voidex Extra Theme Colors
local VX = {
    Accent     = Color3.fromRGB(124, 58, 237),
    AccentDim  = Color3.fromRGB(80, 35, 170),
    AccentGlow = Color3.fromRGB(167, 139, 250),
    Pink       = Color3.fromRGB(236, 72, 153),
    Cyan       = Color3.fromRGB(34, 211, 238),
    Surface    = Color3.fromRGB(12, 8, 28),
    SurfaceUp  = Color3.fromRGB(18, 12, 40),
    SurfaceTop = Color3.fromRGB(24, 16, 52),
    Border     = Color3.fromRGB(35, 22, 65),
    BorderHi   = Color3.fromRGB(80, 50, 160),
    Text       = Color3.fromRGB(232, 224, 255),
    TextDim    = Color3.fromRGB(140, 120, 200),
    TextFaint  = Color3.fromRGB(70, 55, 110),
}

if RunService:IsStudio() then
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then Library.IsMobile=true; Library.OriginalMinSize=Vector2.new(480,240)
    else Library.IsMobile=false; Library.OriginalMinSize=Vector2.new(480,360) end
else
    pcall(function() Library.DevicePlatform = UserInputService:GetPlatform() end)
    Library.IsMobile = (Library.DevicePlatform==Enum.Platform.Android or Library.DevicePlatform==Enum.Platform.IOS)
    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480,240) or Vector2.new(480,360)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- TEMPLATES (same structure as Obsidian)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local Templates = {
    Frame = { BorderSizePixel = 0 },
    ImageLabel = { BackgroundTransparency = 1, BorderSizePixel = 0 },
    ImageButton = { AutoButtonColor = false, BorderSizePixel = 0 },
    ScrollingFrame = { BorderSizePixel = 0 },
    TextLabel = { BorderSizePixel = 0, FontFace = "Font", RichText = true, TextColor3 = "FontColor" },
    TextButton = { AutoButtonColor = false, BorderSizePixel = 0, FontFace = "Font", RichText = true, TextColor3 = "FontColor" },
    TextBox = {
        BorderSizePixel = 0, FontFace = "Font",
        PlaceholderColor3 = function() local H,S,V=Library.Scheme.FontColor:ToHSV(); return Color3.fromHSV(H,S,V/2) end,
        Text = "", TextColor3 = "FontColor",
    },
    UIListLayout = { SortOrder = Enum.SortOrder.LayoutOrder },
    UIStroke = { ApplyStrokeMode = Enum.ApplyStrokeMode.Border },
    -- Library templates
    Window = {
        Title = "No Title", Footer = "Voidex v2.0",
        Position = UDim2.fromOffset(6,6), Size = UDim2.fromOffset(720,600),
        IconSize = UDim2.fromOffset(30,30), AutoShow = true, Center = true, Resizable = true,
        SearchbarSize = UDim2.fromScale(1,1), GlobalSearch = false, CornerRadius = 10,
        NotifySide = "Right", ShowCustomCursor = false, Font = Enum.Font.GothamMedium,
        ToggleKeybind = Enum.KeyCode.RightControl, MobileButtonsSide = "Left",
        UnlockMouseWhileOpen = true, EnableSidebarResize = false, EnableCompacting = true,
        DisableCompactingSnap = false, SidebarCompacted = false, MinContainerWidth = 256,
        MinSidebarWidth = 128, SidebarCompactWidth = 48, SidebarCollapseThreshold = 0.5,
        CompactWidthActivation = 128,
    },
    Dialog = { Title="Dialog", Description="Description", AutoDismiss=true, OutsideClickDismiss=true, FooterButtons={} },
    Toggle = { Text="Toggle", Default=false, Callback=function()end, Changed=function()end, Risky=false, Disabled=false, Visible=true },
    Input = { Text="Input", Default="", Finished=false, Numeric=false, ClearTextOnFocus=true, Placeholder="", AllowEmpty=true, EmptyReset="---", Callback=function()end, Changed=function()end, Disabled=false, Visible=true },
    Slider = { Text="Slider", Default=0, Min=0, Max=100, Rounding=0, Prefix="", Suffix="", Callback=function()end, Changed=function()end, Disabled=false, Visible=true },
    Dropdown = { Values={}, DisabledValues={}, Multi=false, MaxVisibleDropdownItems=8, Callback=function()end, Changed=function()end, Disabled=false, Visible=true },
    Viewport = { Object=nil, Camera=nil, Clone=true, AutoFocus=true, Interactive=false, Height=200, Visible=true },
    Image = { Image="", Transparency=0, BackgroundTransparency=0, Color=Color3.new(1,1,1), RectOffset=Vector2.zero, RectSize=Vector2.zero, ScaleType=Enum.ScaleType.Fit, Height=200, Visible=true },
    Video = { Video="", Looped=false, Playing=false, Volume=1, Height=200, Visible=true },
    UIPassthrough = { Instance=nil, Height=24, Visible=true },
    KeyPicker = { Text="KeyPicker", Default="None", DefaultModifiers={}, Mode="Toggle", Modes={"Always","Toggle","Hold"}, SyncToggleState=false, Callback=function()end, ChangedCallback=function()end, Changed=function()end, Clicked=function()end },
    ColorPicker = { Default=Color3.new(1,1,1), Callback=function()end, Changed=function()end },
}

local Places = { Bottom={0,1}, Right={1,0} }
local Sizes  = { Left={0.5,1}, Right={0.5,1} }

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SCHEME HELPERS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local SchemeReplaceAlias = { RedColor="Red", WhiteColor="White", DarkColor="Dark" }
local SchemeAlias        = { Red="RedColor", White="WhiteColor", Dark="DarkColor" }

local function GetSchemeValue(Index)
    if not Index then return nil end
    local rA = SchemeReplaceAlias[Index]; if rA and Library.Scheme[rA]~=nil then Library.Scheme[Index]=Library.Scheme[rA]; Library.Scheme[rA]=nil; return Library.Scheme[Index] end
    local aA = SchemeAlias[Index]; if aA and Library.Scheme[aA]~=nil then warn(string.format("Scheme Value %q is deprecated, please use %q instead.",Index,aA)); return Library.Scheme[aA] end
    return Library.Scheme[Index]
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- BASIC HELPERS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function WaitForEvent(Event, Timeout, Condition)
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition)=="function" and Condition(...) then Bindable:Fire(true)
        else Bindable:Fire(false) end
    end)
    task.delay(Timeout, function() Connection:Disconnect(); Bindable:Fire(false) end)
    local Result = Bindable.Event:Wait(); Bindable:Destroy(); return Result
end
local function IsMouseInput(Input, IncludeM2)
    return Input.UserInputType==Enum.UserInputType.MouseButton1 or (IncludeM2==true and Input.UserInputType==Enum.UserInputType.MouseButton2) or Input.UserInputType==Enum.UserInputType.Touch
end
local function IsClickInput(Input, IncludeM2)
    return IsMouseInput(Input,IncludeM2) and Input.UserInputState==Enum.UserInputState.Begin and Library.IsRobloxFocused
end
local function IsHoverInput(Input)
    return (Input.UserInputType==Enum.UserInputType.MouseMovement or Input.UserInputType==Enum.UserInputType.Touch) and Input.UserInputState==Enum.UserInputState.Change
end
local function IsDragInput(Input, IncludeM2)
    return IsMouseInput(Input,IncludeM2) and (Input.UserInputState==Enum.UserInputState.Begin or Input.UserInputState==Enum.UserInputState.Change) and Library.IsRobloxFocused
end
local function GetTableSize(Table) local s=0; for _ in Table do s+=1 end; return s end
local function StopTween(Tween) if not (Tween and Tween.PlaybackState==Enum.PlaybackState.Playing) then return end; Tween:Cancel() end
local function Trim(Text) return Text:match("^%s*(.-)%s*$") end
local function Round(Value, Rounding) assert(Rounding>=0,"Invalid rounding number."); if Rounding==0 then return math.floor(Value) end; return tonumber(string.format("%."..Rounding.."f",Value)) end
local function GetPlayers(ExcludeLocalPlayer)
    local PlayerList=Players:GetPlayers()
    if ExcludeLocalPlayer then local Idx=table.find(PlayerList,LocalPlayer); if Idx then table.remove(PlayerList,Idx) end end
    table.sort(PlayerList,function(a,b) return a.Name:lower()<b.Name:lower() end); return PlayerList
end
local function GetTeams()
    local TeamList=Teams:GetTeams(); table.sort(TeamList,function(a,b) return a.Name:lower()<b.Name:lower() end); return TeamList
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- VOIDEX GLOW HELPERS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function AddGlowStroke(frame, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Library.Scheme.AccentColor
    s.Thickness = thickness or 1
    s.Transparency = 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = frame
    return s
end

local function PulseGlow(stroke, color)
    color = color or Library.Scheme.AccentColor
    TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency=0, Color=color}):Play()
    task.delay(0.4, function()
        TweenService:Create(stroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency=0.7}):Play()
    end)
end

-- Shimmering gradient animation for toggle switches
local function AnimateAccentGradient(frame, active)
    local existing = frame:FindFirstChildOfClass("UIGradient")
    if existing then existing:Destroy() end
    if not active then return end
    local grad = Instance.new("UIGradient", frame)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(167,139,250)),
        ColorSequenceKeypoint.new(0.5, Library.Scheme.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236,72,153)),
    })
    grad.Rotation = 90
    -- Animate shimmer
    local conn
    local t0 = tick()
    conn = RunService.Heartbeat:Connect(function()
        if not frame.Parent then conn:Disconnect(); return end
        local t = tick()-t0
        grad.Offset = Vector2.new(math.sin(t*2)*0.3, 0)
    end)
    task.delay(2, function() pcall(conn.Disconnect, conn) end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SEARCH FUNCTIONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function Library:UpdateDependencyBoxes()
    for _, Depbox in Library.DependencyBoxes do Depbox:Update(true) end
    if Library.Searching then Library:UpdateSearch(Library.SearchText) end
end

local function CheckDepbox(Box, Search)
    local VisibleElements=0
    for _, ElementInfo in Box.Elements do
        if ElementInfo.Type=="Divider" then ElementInfo.Holder.Visible=false; continue
        elseif ElementInfo.SubButton then
            local Visible=false
            if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then Visible=true else ElementInfo.Base.Visible=false end
            if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then Visible=true else ElementInfo.SubButton.Base.Visible=false end
            ElementInfo.Holder.Visible=Visible; if Visible then VisibleElements+=1 end; continue
        end
        if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then ElementInfo.Holder.Visible=true; VisibleElements+=1
        else ElementInfo.Holder.Visible=false end
    end
    for _, Depbox in Box.DependencyBoxes do
        if not Depbox.Visible then continue end
        VisibleElements += CheckDepbox(Depbox, Search)
    end
    Box.Holder.Visible = VisibleElements>0; return VisibleElements
end

local function RestoreDepbox(Box)
    for _, ElementInfo in Box.Elements do
        ElementInfo.Holder.Visible = typeof(ElementInfo.Visible)=="boolean" and ElementInfo.Visible or true
        if ElementInfo.SubButton then ElementInfo.Base.Visible=ElementInfo.Visible; ElementInfo.SubButton.Base.Visible=ElementInfo.SubButton.Visible end
    end
    Box:Resize(); Box.Holder.Visible=true
    for _, Depbox in Box.DependencyBoxes do if not Depbox.Visible then continue end; RestoreDepbox(Depbox) end
end

local function ApplySearchToTab(Tab, Search)
    if not Tab then return end
    local HasVisible=false
    for _, Groupbox in Tab.Groupboxes do
        local VisibleElements=0
        for _, ElementInfo in Groupbox.Elements do
            if ElementInfo.Type=="Divider" then ElementInfo.Holder.Visible=false; continue
            elseif ElementInfo.SubButton then
                local Visible=false
                if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then Visible=true else ElementInfo.Base.Visible=false end
                if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then Visible=true else ElementInfo.SubButton.Base.Visible=false end
                ElementInfo.Holder.Visible=Visible; if Visible then VisibleElements+=1 end; continue
            end
            if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then ElementInfo.Holder.Visible=true; VisibleElements+=1
            else ElementInfo.Holder.Visible=false end
        end
        for _, Depbox in Groupbox.DependencyBoxes do
            if not Depbox.Visible then continue end
            VisibleElements += CheckDepbox(Depbox, Search)
        end
        if VisibleElements>0 then Groupbox:Resize(); HasVisible=true end
        Groupbox.BoxHolder.Visible = VisibleElements>0
    end
    for _, Tabbox in Tab.Tabboxes do
        local VisibleTabs=0; local VisibleElements={}
        for _, SubTab in Tabbox.Tabs do
            VisibleElements[SubTab]=0
            for _, ElementInfo in SubTab.Elements do
                if ElementInfo.Type=="Divider" then ElementInfo.Holder.Visible=false; continue
                elseif ElementInfo.SubButton then
                    local Visible=false
                    if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then Visible=true else ElementInfo.Base.Visible=false end
                    if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then Visible=true else ElementInfo.SubButton.Base.Visible=false end
                    ElementInfo.Holder.Visible=Visible; if Visible then VisibleElements[SubTab]+=1 end; continue
                end
                if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then ElementInfo.Holder.Visible=true; VisibleElements[SubTab]+=1
                else ElementInfo.Holder.Visible=false end
            end
            for _, Depbox in SubTab.DependencyBoxes do
                if not Depbox.Visible then continue end
                VisibleElements[SubTab] += CheckDepbox(Depbox, Search)
            end
        end
        for SubTab, Visible in VisibleElements do
            SubTab.ButtonHolder.Visible=Visible>0
            if Visible>0 then VisibleTabs+=1; HasVisible=true
                if Tabbox.ActiveTab==SubTab then SubTab:Resize()
                elseif Tabbox.ActiveTab and VisibleElements[Tabbox.ActiveTab]==0 then SubTab:Show() end
            end
        end
        Tabbox.BoxHolder.Visible = VisibleTabs>0
    end
    return HasVisible
end

local function ResetTab(Tab)
    if not Tab then return end
    for _, Groupbox in Tab.Groupboxes do
        for _, ElementInfo in Groupbox.Elements do
            ElementInfo.Holder.Visible = typeof(ElementInfo.Visible)=="boolean" and ElementInfo.Visible or true
            if ElementInfo.SubButton then ElementInfo.Base.Visible=ElementInfo.Visible; ElementInfo.SubButton.Base.Visible=ElementInfo.SubButton.Visible end
        end
        for _, Depbox in Groupbox.DependencyBoxes do if not Depbox.Visible then continue end; RestoreDepbox(Depbox) end
        Groupbox:Resize(); Groupbox.BoxHolder.Visible=true
    end
    for _, Tabbox in Tab.Tabboxes do
        for _, SubTab in Tabbox.Tabs do
            for _, ElementInfo in SubTab.Elements do
                ElementInfo.Holder.Visible=typeof(ElementInfo.Visible)=="boolean" and ElementInfo.Visible or true
                if ElementInfo.SubButton then ElementInfo.Base.Visible=ElementInfo.Visible; ElementInfo.SubButton.Base.Visible=ElementInfo.SubButton.Visible end
            end
            for _, Depbox in SubTab.DependencyBoxes do if not Depbox.Visible then continue end; RestoreDepbox(Depbox) end
            SubTab.ButtonHolder.Visible=true
        end
        if Tabbox.ActiveTab then Tabbox.ActiveTab:Resize() end
        Tabbox.BoxHolder.Visible=true
    end
end

function Library:UpdateSearch(SearchText)
    Library.SearchText = SearchText
    local TabsToReset={}
    if Library.GlobalSearch then
        for _, Tab in Library.Tabs do if typeof(Tab)=="table" and not Tab.IsKeyTab then table.insert(TabsToReset,Tab) end end
    elseif Library.LastSearchTab and typeof(Library.LastSearchTab)=="table" then
        table.insert(TabsToReset, Library.LastSearchTab)
    end
    for _, Tab in ipairs(TabsToReset) do ResetTab(Tab) end
    local Search = SearchText:lower()
    if Trim(Search)==""  then Library.Searching=false; Library.LastSearchTab=nil; return end
    if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then Library.Searching=false; Library.LastSearchTab=nil; return end
    Library.Searching=true
    local TabsToSearch={}
    if Library.GlobalSearch then TabsToSearch=TabsToReset; if #TabsToSearch==0 then for _,Tab in Library.Tabs do if typeof(Tab)=="table" and not Tab.IsKeyTab then table.insert(TabsToSearch,Tab) end end end
    elseif Library.ActiveTab then table.insert(TabsToSearch,Library.ActiveTab) end
    local FirstVisibleTab=nil; local ActiveHasVisible=false
    for _, Tab in ipairs(TabsToSearch) do
        local HasVisible=ApplySearchToTab(Tab,Search)
        if HasVisible then if not FirstVisibleTab then FirstVisibleTab=Tab end; if Tab==Library.ActiveTab then ActiveHasVisible=true end end
    end
    if Library.GlobalSearch then
        if ActiveHasVisible and Library.ActiveTab then Library.ActiveTab:RefreshSides()
        elseif FirstVisibleTab then
            local SearchMarker=SearchText
            task.defer(function() if Library.SearchText~=SearchMarker then return end; if Library.ActiveTab~=FirstVisibleTab then FirstVisibleTab:Show() end end)
        end
        Library.LastSearchTab=nil
    else Library.LastSearchTab=Library.ActiveTab end
end

function Library:AddToRegistry(Instance, Properties) Library.Registry[Instance]=Properties end
function Library:RemoveFromRegistry(Instance) Library.Registry[Instance]=nil end
function Library:UpdateColorsUsingRegistry()
    for Instance, Properties in Library.Registry do
        for Property, Index in Properties do
            local SchemeValue=GetSchemeValue(Index)
            if SchemeValue or typeof(Index)=="function" then Instance[Property]=SchemeValue or Index() end
        end
    end
end
function Library:SetDPIScale(DPIScale)
    Library.DPIScale=DPIScale/100; Library.MinSize=Library.OriginalMinSize*Library.DPIScale
    for _, UIScale in Library.Scales do UIScale.Scale=Library.DPIScale end
    for _, Option in Options do if Option.Type=="Dropdown" then Option:RecalculateListSize() end end
    for _, Notification in Library.Notifications do Notification:Resize() end
end
function Library:GiveSignal(Connection)
    local ConnectionType=typeof(Connection)
    if Connection and (ConnectionType=="RBXScriptConnection" or ConnectionType=="RBXScriptSignal") then table.insert(Library.Signals,Connection) end
    return Connection
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ICON MODULE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function IsValidCustomIcon(Icon) return typeof(Icon)=="string" and (Icon:match("rbxasset") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type=")) end
local FetchIcons, Icons = pcall(function()
    return (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"))())()
end)
function Library:GetIcon(IconName) if not FetchIcons then return end; local Success, Icon=pcall(Icons.GetAsset,IconName); if not Success then return end; return Icon end
function Library:GetCustomIcon(IconName)
    if not IsValidCustomIcon(IconName) then return Library:GetIcon(IconName)
    else return { Url=IconName, ImageRectOffset=Vector2.zero, ImageRectSize=Vector2.zero, Custom=true } end
end
function Library:Validate(Table, Template)
    if typeof(Table)~="table" then return Template end
    for k, v in Template do if typeof(k)=="number" then continue end; if typeof(v)=="table" then Table[k]=Library:Validate(Table[k],v); elseif Table[k]==nil then Table[k]=v end end
    return Table
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- CREATOR (New instance function)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function FillInstance(Table, Instance)
    local ThemeProperties = Library.Registry[Instance] or {}
    for key, value in Table do
        if ThemeProperties[key] then ThemeProperties[key]=nil
        elseif key~="Text" then
            local SchemeValue=GetSchemeValue(value)
            if SchemeValue or typeof(value)=="function" then ThemeProperties[key]=value; value=SchemeValue or value() end
        end
        Instance[key]=value
    end
    if GetTableSize(ThemeProperties)>0 then Library.Registry[Instance]=ThemeProperties end
end

local function New(ClassName, Properties)
    local Inst = Instance.new(ClassName)
    if Templates[ClassName] then FillInstance(Templates[ClassName], Inst) end
    FillInstance(Properties, Inst)
    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function() Inst.ZIndex = Properties.Parent.ZIndex end)
    end
    return Inst
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SCREEN GUI + CURSOR + NOTIFICATIONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function SafeParentUI(Instance, Parent)
    local success=pcall(function()
        if not Parent then Parent=CoreGui end
        local DestinationParent = typeof(Parent)=="function" and Parent() or Parent
        Instance.Parent=DestinationParent
    end)
    if not (success and Instance.Parent) then Instance.Parent=Library.LocalPlayer:WaitForChild("PlayerGui",math.huge) end
end
local function ParentUI(UI, SkipHiddenUI)
    if SkipHiddenUI then SafeParentUI(UI,CoreGui); return end
    pcall(protectgui,UI); SafeParentUI(UI,gethui)
end

local ScreenGui = New("ScreenGui", { Name="Voidex", DisplayOrder=999, ResetOnSpawn=false })
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui
ScreenGui.DescendantRemoving:Connect(function(Instance) Library:RemoveFromRegistry(Instance) end)

-- Ambient scanline overlay for premium feel
local ScanlineOverlay = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1,1),
    ZIndex = 1000,
    Parent = ScreenGui,
})
-- Subtle vignette / animated glow for the overall UI
local ModalElement = New("TextButton", {
    BackgroundTransparency=1, Modal=false, Size=UDim2.fromScale(0,0),
    AnchorPoint=Vector2.zero, Text="", ZIndex=-999, Parent=ScreenGui,
})

-- Premium custom cursor (cross-hair style with glow ring)
local Cursor, CursorRing, CursorCustomImage
do
    Cursor = New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.fromRGB(220,200,255),
        Size=UDim2.fromOffset(8,1), Visible=false, ZIndex=11000, Parent=ScreenGui,
    })
    New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3="DarkColor",
        Position=UDim2.fromScale(0.5,0.5), Size=UDim2.new(1,2,1,2), ZIndex=10999, Parent=Cursor,
    })
    local CursorV = New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.fromRGB(220,200,255),
        Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(1,8), ZIndex=11000, Parent=Cursor,
    })
    New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3="DarkColor",
        Position=UDim2.fromScale(0.5,0.5), Size=UDim2.new(1,2,1,2), ZIndex=10999, Parent=CursorV,
    })
    -- Glow ring around cursor
    CursorRing = New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1,
        Size=UDim2.fromOffset(18,18), ZIndex=10998, Parent=Cursor,
    })
    Instance.new("UICorner",CursorRing).CornerRadius=UDim.new(1,0)
    local s=Instance.new("UIStroke",CursorRing); s.Color=Library.Scheme.AccentColor; s.Thickness=1; s.Transparency=0.4
    CursorCustomImage = New("ImageLabel", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1,
        Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(20,20),
        ZIndex=11000, Visible=false, Parent=Cursor,
    })
end

-- Notification Area
local NotificationArea, NotificationList
do
    NotificationArea = New("Frame", {
        AnchorPoint=Vector2.new(1,0), BackgroundTransparency=1,
        Position=UDim2.new(1,-8,0,8), Size=UDim2.new(0,300,1,-8), Parent=ScreenGui,
    })
    table.insert(Library.Scales, New("UIScale", { Parent=NotificationArea }))
    NotificationList = New("UIListLayout", {
        HorizontalAlignment=Enum.HorizontalAlignment.Right, Padding=UDim.new(0,6), Parent=NotificationArea,
    })
end

-- Tooltip
local TooltipLabel = New("TextLabel", {
    AutomaticSize=Enum.AutomaticSize.Y, BackgroundColor3=VX.SurfaceTop,
    Size=UDim2.fromOffset(180,0), TextSize=13, TextWrapped=true,
    Visible=false, ZIndex=20, TextXAlignment=Enum.TextXAlignment.Left,
    Parent=ScreenGui,
})
New("UICorner", { CornerRadius=UDim.new(0,6), Parent=TooltipLabel })
New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.6, Parent=TooltipLabel })
New("UIPadding", { PaddingBottom=UDim.new(0,4), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), PaddingTop=UDim.new(0,4), Parent=TooltipLabel })
table.insert(Library.Scales, New("UIScale", { Parent=TooltipLabel }))
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if Library.Unloaded then return end
    local X,_ = Library:GetTextBounds(TooltipLabel.Text, TooltipLabel.FontFace, TooltipLabel.TextSize, (workspace.CurrentCamera.ViewportSize.X-TooltipLabel.AbsolutePosition.X-8)/Library.DPIScale)
    TooltipLabel.Size = UDim2.fromOffset(X+12)
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LIB FUNCTIONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function Library:ResetCursorIcon() CursorCustomImage.Visible=false; CursorCustomImage.Size=UDim2.fromOffset(20,20) end
function Library:ChangeCursorIcon(ImageId)
    if not ImageId or ImageId=="" then Library:ResetCursorIcon(); return end
    local Icon=Library:GetCustomIcon(ImageId); assert(Icon,"Image must be valid")
    CursorCustomImage.Visible=true; CursorCustomImage.Image=Icon.Url; CursorCustomImage.ImageRectOffset=Icon.ImageRectOffset; CursorCustomImage.ImageRectSize=Icon.ImageRectSize
end
function Library:ChangeCursorIconSize(Size) assert(typeof(Size)=="UDim2","UDim2 expected."); CursorCustomImage.Size=Size end
function Library:GetBetterColor(Color, Add) Add=Add*(Library.IsLightTheme and -4 or 2); return Color3.fromRGB(math.clamp(Color.R*255+Add,0,255),math.clamp(Color.G*255+Add,0,255),math.clamp(Color.B*255+Add,0,255)) end
function Library:GetLighterColor(Color) local H,S,V=Color:ToHSV(); return Color3.fromHSV(H,math.max(0,S-0.1),math.min(1,V+0.1)) end
function Library:GetDarkerColor(Color) local H,S,V=Color:ToHSV(); return Color3.fromHSV(H,S,V/2) end
function Library:GetKeyString(KeyCode) if KeyCode.EnumType==Enum.KeyCode and KeyCode.Value>33 and KeyCode.Value<127 then return string.char(KeyCode.Value) end; return KeyCode.Name end
function Library:GetTextBounds(Text, Font, Size, Width)
    local Params=Instance.new("GetTextBoundsParams"); Params.Text=Text; Params.RichText=true; Params.Font=Font; Params.Size=Size; Params.Width=Width or workspace.CurrentCamera.ViewportSize.X-32
    local Bounds=TextService:GetTextBoundsAsync(Params); return Bounds.X, Bounds.Y
end
function Library:MouseIsOverFrame(Frame, Mouse)
    local AbsPos,AbsSize=Frame.AbsolutePosition,Frame.AbsoluteSize
    return Mouse.X>=AbsPos.X and Mouse.X<=AbsPos.X+AbsSize.X and Mouse.Y>=AbsPos.Y and Mouse.Y<=AbsPos.Y+AbsSize.Y
end
function Library:SafeCallback(Func, ...)
    if not (Func and typeof(Func)=="function") then return end
    local Result=table.pack(xpcall(Func,function(Error) task.defer(error,debug.traceback(Error,2)); if Library.NotifyOnError then Library:Notify(Error) end; return Error end,...))
    if not Result[1] then return nil end; return table.unpack(Result,2,Result.n)
end
function Library:SetFont(FontFace) if typeof(FontFace)=="EnumItem" then FontFace=Font.fromEnum(FontFace) end; Library.Scheme.Font=FontFace; Library:UpdateColorsUsingRegistry() end
function Library:SetScheme(Scheme) for k,v in Scheme do Library.Scheme[k]=v end; Library:UpdateColorsUsingRegistry() end
function Library:OnUnload(Callback) table.insert(Library.UnloadSignals,Callback) end
function Library:Unload()
    for Index=#Library.Signals,1,-1 do local Connection=table.remove(Library.Signals,Index); if Connection and Connection.Connected then Connection:Disconnect() end end
    for _, Callback in Library.UnloadSignals do Library:SafeCallback(Callback) end
    for _, Tooltip in Tooltips do Library:SafeCallback(Tooltip.Destroy,Tooltip) end
    Library.Unloaded=true; ScreenGui:Destroy(); getgenv().Library=nil
end

-- Draggable + Resizable
function Library:MakeDraggable(UI, DragFrame, IgnoreToggled, IsMainWindow)
    local StartPos; local FramePos; local Dragging=false; local Changed
    DragFrame.InputBegan:Connect(function(Input)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then return end
        StartPos=Input.Position; FramePos=UI.Position; Dragging=true
        Changed=Input.Changed:Connect(function() if Input.UserInputState~=Enum.UserInputState.End then return end; Dragging=false; if Changed and Changed.Connected then Changed:Disconnect(); Changed=nil end end)
    end)
    Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input)
        if (not IgnoreToggled and not Library.Toggled) or (IsMainWindow and Library.CantDragForced) or not (ScreenGui and ScreenGui.Parent) then Dragging=false; if Changed and Changed.Connected then Changed:Disconnect(); Changed=nil end; return end
        if Dragging and IsHoverInput(Input) then local Delta=Input.Position-StartPos; UI.Position=UDim2.new(FramePos.X.Scale,FramePos.X.Offset+Delta.X,FramePos.Y.Scale,FramePos.Y.Offset+Delta.Y) end
    end))
end

function Library:MakeResizable(UI, DragFrame, Callback)
    local StartPos; local FrameSize; local Dragging=false; local Changed
    DragFrame.InputBegan:Connect(function(Input)
        if not IsClickInput(Input) then return end
        StartPos=Input.Position; FrameSize=UI.Size; Dragging=true
        Changed=Input.Changed:Connect(function() if Input.UserInputState~=Enum.UserInputState.End then return end; Dragging=false; if Changed and Changed.Connected then Changed:Disconnect(); Changed=nil end end)
    end)
    Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then Dragging=false; if Changed and Changed.Connected then Changed:Disconnect(); Changed=nil end; return end
        if Dragging and IsHoverInput(Input) then
            local Delta=Input.Position-StartPos
            UI.Size=UDim2.new(FrameSize.X.Scale,math.clamp(FrameSize.X.Offset+Delta.X,Library.MinSize.X,math.huge),FrameSize.Y.Scale,math.clamp(FrameSize.Y.Offset+Delta.Y,Library.MinSize.Y,math.huge))
            if Callback then Library:SafeCallback(Callback) end
        end
    end))
end

function Library:MakeCover(Holder, Place)
    local Pos=Places[Place] or {0,0}; local Size=Sizes[Place] or {1,0.5}
    return New("Frame", { AnchorPoint=Vector2.new(Pos[1],Pos[2]), BackgroundColor3=Holder.BackgroundColor3, Position=UDim2.fromScale(Pos[1],Pos[2]), Size=UDim2.fromScale(Size[1],Size[2]), Parent=Holder })
end

function Library:AddOutline(Frame)
    -- Voidex: glowing purple outline instead of plain outline
    local OutlineStroke = New("UIStroke", {
        Color = Library.Scheme.OutlineColor,
        Thickness = 1,
        Parent = Frame,
    })
    local ShadowStroke = New("UIStroke", {
        Color = "DarkColor",
        Thickness = 1.5,
        Parent = Frame,
    })
    return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame, Size) return New("Frame", { BackgroundTransparency=1, Size=Size or UDim2.fromScale(0,0), Parent=Frame }) end

-- Draggable label / button / menu
function Library:AddDraggableLabel(Text)
    local Table={}
    local Label=New("TextLabel", {
        AutomaticSize=Enum.AutomaticSize.XY, BackgroundColor3=VX.SurfaceTop,
        Size=UDim2.fromOffset(0,0), Position=UDim2.fromOffset(8,8),
        Text=Text, TextSize=14, ZIndex=10, Parent=ScreenGui,
        TextColor3=VX.Text,
    })
    New("UICorner", { CornerRadius=UDim.new(0,8), Parent=Label })
    New("UIPadding", { PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12), PaddingTop=UDim.new(0,6), Parent=Label })
    New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.5, Parent=Label })
    table.insert(Library.Scales, New("UIScale", { Parent=Label }))
    Library:MakeDraggable(Label,Label,true)
    Table.Label=Label
    function Table:SetText(Text) Label.Text=Text end
    function Table:SetVisible(Visible) Label.Visible=Visible end
    return Table
end

function Library:AddDraggableButton(Text, Func, ExcludeScaling)
    local Table={}
    local Button=New("TextButton", {
        BackgroundColor3=VX.SurfaceTop,
        Position=UDim2.fromOffset(8,8), TextSize=15, ZIndex=10,
        TextColor3=VX.AccentGlow, Parent=ScreenGui,
    })
    New("UICorner", { CornerRadius=UDim.new(0,8), Parent=Button })
    New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.4, Parent=Button })
    if not ExcludeScaling then table.insert(Library.Scales, New("UIScale", { Parent=Button })) end
    Button.MouseButton1Click:Connect(function() Library:SafeCallback(Func,Table) end)
    Library:MakeDraggable(Button,Button,true)
    Table.Button=Button
    function Table:SetText(Text) local X,Y=Library:GetTextBounds(Text,Library.Scheme.Font,15); Button.Text=Text; Button.Size=UDim2.fromOffset(X*2,Y*2) end
    Table:SetText(Text)
    return Table
end

function Library:AddDraggableMenu(Name)
    local Holder=New("Frame", {
        AutomaticSize=Enum.AutomaticSize.XY, BackgroundColor3=VX.Surface,
        Position=UDim2.fromOffset(8,8), Size=UDim2.fromOffset(0,0), ZIndex=10, Parent=ScreenGui,
    })
    New("UICorner", { CornerRadius=UDim.new(0,10), Parent=Holder })
    table.insert(Library.Scales, New("UIScale", { Parent=Holder }))
    New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.5, Parent=Holder })
    -- Header line
    local Line=New("Frame", { BackgroundColor3=Library.Scheme.OutlineColor, Position=UDim2.fromOffset(0,32), Size=UDim2.new(1,0,0,1), Parent=Holder })
    local LabelH=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,32), Text=Name, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=VX.AccentGlow, Parent=Holder })
    New("UIPadding", { PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12), Parent=LabelH })
    local Container=New("Frame", { BackgroundTransparency=1, Position=UDim2.fromOffset(0,33), Size=UDim2.new(1,0,1,-33), Parent=Holder })
    New("UIListLayout", { Padding=UDim.new(0,6), Parent=Container })
    New("UIPadding", { PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), PaddingTop=UDim.new(0,6), Parent=Container })
    Library:MakeDraggable(Holder,LabelH,true)
    return Holder, Container
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- TOOLTIP
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local CurrentHoverInstance
function Library:AddTooltip(InfoStr, DisabledInfoStr, HoverInstance)
    local TooltipTable = { Disabled=false, Hovering=false, Signals={} }
    local function GiveSignal(Connection) if Connection and (typeof(Connection)=="RBXScriptConnection" or typeof(Connection)=="RBXScriptSignal") then table.insert(TooltipTable.Signals,Connection) end; return Connection end
    local function DoHover()
        if CurrentHoverInstance==HoverInstance or Library.ActiveDialog or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu,Mouse)) or (TooltipTable.Disabled and typeof(DisabledInfoStr)~="string") or (not TooltipTable.Disabled and typeof(InfoStr)~="string") then return end
        CurrentHoverInstance=HoverInstance
        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
        TooltipLabel.Visible=true
        while Library.Toggled and not Library.ActiveDialog and Library:MouseIsOverFrame(HoverInstance,Mouse) and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu,Mouse)) do
            TooltipLabel.Position = UDim2.fromOffset(Mouse.X+(Library.ShowCustomCursor and 8 or 14), Mouse.Y+(Library.ShowCustomCursor and 8 or 12))
            RunService.RenderStepped:Wait()
        end
        TooltipLabel.Visible=false; CurrentHoverInstance=nil
    end
    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
    GiveSignal(HoverInstance.MouseLeave:Connect(function() if CurrentHoverInstance~=HoverInstance then return end; TooltipLabel.Visible=false; CurrentHoverInstance=nil end))
    function TooltipTable:Destroy()
        for Index=#TooltipTable.Signals,1,-1 do local Connection=table.remove(TooltipTable.Signals,Index); if Connection and Connection.Connected then Connection:Disconnect() end end
        if CurrentHoverInstance==HoverInstance then if TooltipLabel then TooltipLabel.Visible=false end; CurrentHoverInstance=nil end
    end
    table.insert(Tooltips, TooltipLabel); return TooltipTable
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- CONTEXT MENU
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local CurrentMenu
function Library:AddContextMenu(Holder, Size, Offset, List, ActiveCallback)
    local Menu
    if List then
        Menu = New("ScrollingFrame", {
            AutomaticCanvasSize=List==2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            AutomaticSize=List==1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3=VX.SurfaceUp,
            BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png",
            CanvasSize=UDim2.fromOffset(0,0), ScrollBarImageColor3=Library.Scheme.AccentColor,
            ScrollBarThickness=List==2 and 2 or 0, Size=typeof(Size)=="function" and Size() or Size,
            TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png",
            Visible=false, ZIndex=10, Parent=ScreenGui,
        })
    else
        Menu = New("Frame", {
            BackgroundColor3=VX.SurfaceUp, Size=typeof(Size)=="function" and Size() or Size,
            Visible=false, ZIndex=10, Parent=ScreenGui,
        })
    end
    New("UICorner", { CornerRadius=UDim.new(0,8), Parent=Menu })
    New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.5, Parent=Menu })
    table.insert(Library.Scales, New("UIScale", { Parent=Menu }))
    local Table = { Active=false, Holder=Holder, Menu=Menu, List=nil, Signal=nil, Size=Size }
    if List then Table.List=New("UIListLayout", { Parent=Menu }) end
    function Table:Open()
        if CurrentMenu==Table then return elseif CurrentMenu then CurrentMenu:Close() end
        CurrentMenu=Table; Table.Active=true
        local offsetVal = typeof(Offset)=="function" and Offset() or Offset
        Menu.Position=UDim2.fromOffset(math.floor(Holder.AbsolutePosition.X+offsetVal[1]),math.floor(Holder.AbsolutePosition.Y+offsetVal[2]))
        Menu.Size=typeof(Table.Size)=="function" and Table.Size() or Table.Size
        if typeof(ActiveCallback)=="function" then Library:SafeCallback(ActiveCallback,true) end
        Menu.Visible=true
        Table.Signal=Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            local offsetVal2=typeof(Offset)=="function" and Offset() or Offset
            Menu.Position=UDim2.fromOffset(math.floor(Holder.AbsolutePosition.X+offsetVal2[1]),math.floor(Holder.AbsolutePosition.Y+offsetVal2[2]))
        end)
    end
    function Table:Close()
        if CurrentMenu~=Table then return end; Menu.Visible=false
        if Table.Signal then Table.Signal:Disconnect(); Table.Signal=nil end
        Table.Active=false; CurrentMenu=nil
        if typeof(ActiveCallback)=="function" then Library:SafeCallback(ActiveCallback,false) end
    end
    function Table:Toggle() if Table.Active then Table:Close() else Table:Open() end end
    function Table:SetSize(Size) Table.Size=Size; Menu.Size=typeof(Size)=="function" and Size() or Size end
    return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
    if Library.Unloaded then return end
    if IsClickInput(Input,true) then
        local Location=Input.Position
        if CurrentMenu and not (Library:MouseIsOverFrame(CurrentMenu.Menu,Location) or Library:MouseIsOverFrame(CurrentMenu.Holder,Location)) then CurrentMenu:Close() end
    end
end))

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- NOTIFICATIONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function Library:SetNotifySide(Side)
    Library.NotifySide=Side
    if Side:lower()=="left" then
        NotificationArea.AnchorPoint=Vector2.new(0,0); NotificationArea.Position=UDim2.fromOffset(8,8); NotificationList.HorizontalAlignment=Enum.HorizontalAlignment.Left
    else
        NotificationArea.AnchorPoint=Vector2.new(1,0); NotificationArea.Position=UDim2.new(1,-8,0,8); NotificationList.HorizontalAlignment=Enum.HorizontalAlignment.Right
    end
end

function Library:Notify(...)
    local Data={}; local Info=select(1,...)
    if typeof(Info)=="table" then
        Data.Title=tostring(Info.Title); Data.Description=tostring(Info.Description); Data.Time=Info.Time or 5; Data.SoundId=Info.SoundId; Data.Steps=Info.Steps; Data.Persist=Info.Persist; Data.Icon=Info.Icon; Data.BigIcon=Info.BigIcon; Data.IconColor=Info.IconColor
    else Data.Description=tostring(Info); Data.Time=select(2,...) or 5; Data.SoundId=select(3,...) end
    Data.Destroyed=false
    local DeletedInstance=false; local DeleteConnection=nil
    if typeof(Data.Time)=="Instance" then DeleteConnection=Data.Time.Destroying:Connect(function() DeletedInstance=true; DeleteConnection:Disconnect(); DeleteConnection=nil end) end

    local FakeBackground=New("Frame", { AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, Size=UDim2.fromScale(1,0), Visible=false, Parent=NotificationArea })
    -- Premium notification card
    local Holder=New("Frame", {
        AutomaticSize=Enum.AutomaticSize.Y, BackgroundColor3=VX.SurfaceUp,
        Position=Library.NotifySide:lower()=="left" and UDim2.new(-1,-8,0,-2) or UDim2.new(1,8,0,-2),
        Size=UDim2.fromScale(1,1), ZIndex=5, Parent=FakeBackground,
    })
    New("UICorner", { CornerRadius=UDim.new(0,10), Parent=Holder })
    New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.3, Parent=Holder })
    New("UIListLayout", { Padding=UDim.new(0,4), Parent=Holder })
    New("UIPadding", { PaddingBottom=UDim.new(0,10), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingTop=UDim.new(0,10), Parent=Holder })
    -- Accent left bar
    local AccentBar=New("Frame", { BackgroundColor3=Library.Scheme.AccentColor, Position=UDim2.fromOffset(0,0), Size=UDim2.new(0,3,1,0), ZIndex=6, Parent=Holder })
    New("UICorner", { CornerRadius=UDim.new(0,3), Parent=AccentBar })
    local grad=Instance.new("UIGradient",AccentBar); grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(1,VX.Pink)}); grad.Rotation=90

    local ContentContainer=New("Frame", { BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.XY, Size=UDim2.fromScale(1,0), Parent=Holder })
    local Title,Desc,TitleX,DescX=nil,nil,0,0

    local TextContainer=New("Frame", { BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.XY, Size=UDim2.fromScale(0,0), Parent=ContentContainer })
    New("UIListLayout", { Padding=UDim.new(0,3), Parent=TextContainer })
    if Data.Title then
        Title=New("TextLabel", { AutomaticSize=Enum.AutomaticSize.None, BackgroundTransparency=1, Size=UDim2.fromScale(0,0), Text=Data.Title, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, TextColor3=VX.AccentGlow, Parent=TextContainer })
    end
    if Data.Description then
        Desc=New("TextLabel", { AutomaticSize=Enum.AutomaticSize.None, BackgroundTransparency=1, Size=UDim2.fromScale(0,0), Text=Data.Description, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, TextColor3=VX.TextDim, Parent=TextContainer })
    end

    function Data:Resize()
        if Title then local X,Y=Library:GetTextBounds(Title.Text,Title.FontFace,Title.TextSize,(NotificationArea.AbsoluteSize.X/Library.DPIScale)-24); Title.Size=UDim2.fromOffset(X,Y); TitleX=X end
        if Desc then local X,Y=Library:GetTextBounds(Desc.Text,Desc.FontFace,Desc.TextSize,(NotificationArea.AbsoluteSize.X/Library.DPIScale)-24); Desc.Size=UDim2.fromOffset(X,Y); DescX=X end
        FakeBackground.Size=UDim2.fromOffset(math.max(TitleX,DescX)+24,0)
    end
    function Data:ChangeTitle(Text) if Title then Data.Title=tostring(Text); Title.Text=Data.Title; Data:Resize() end end
    function Data:ChangeDescription(Text) if Desc then Data.Description=tostring(Text); Desc.Text=Data.Description; Data:Resize() end end
    function Data:Destroy()
        Data.Destroyed=true
        TweenService:Create(Holder,Library.NotifyTweenInfo,{Position=Library.NotifySide:lower()=="left" and UDim2.new(-1,-8,0,-2) or UDim2.new(1,8,0,-2)}):Play()
        task.delay(Library.NotifyTweenInfo.Time,function() Library.Notifications[FakeBackground]=nil; FakeBackground:Destroy() end)
    end

    -- Timer bar
    local TimerHolder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,4), Parent=Holder })
    local TimerBar=New("Frame", { BackgroundColor3=VX.Border, Size=UDim2.new(1,0,1,0), Parent=TimerHolder })
    New("UICorner", { CornerRadius=UDim.new(1,0), Parent=TimerBar })
    local TimerFill=New("Frame", { BackgroundColor3=Library.Scheme.AccentColor, Size=UDim2.fromScale(1,1), Parent=TimerBar })
    New("UICorner", { CornerRadius=UDim.new(1,0), Parent=TimerFill })
    local tGrad=Instance.new("UIGradient",TimerFill); tGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(1,VX.Pink)})
    if typeof(Data.Time)=="Instance" then TimerFill.Size=UDim2.fromScale(0,1) end
    if Data.SoundId then local SoundId=Data.SoundId; if typeof(SoundId)=="number" then SoundId=string.format("rbxassetid://%d",SoundId) end; New("Sound",{SoundId=SoundId,Volume=3,PlayOnRemove=true,Parent=SoundService}):Destroy() end

    Data:Resize()
    Library.Notifications[FakeBackground]=Data; FakeBackground.Visible=true
    TweenService:Create(Holder,Library.NotifyTweenInfo,{Position=UDim2.fromOffset(0,0)}):Play()
    task.delay(Library.NotifyTweenInfo.Time,function()
        if Data.Persist then return
        elseif typeof(Data.Time)=="Instance" then repeat task.wait() until DeletedInstance or Data.Destroyed
        else TweenService:Create(TimerFill,TweenInfo.new(Data.Time,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Size=UDim2.fromScale(0,1)}):Play(); task.wait(Data.Time) end
        if not Data.Destroyed then Data:Destroy() end
    end)
    return Data
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ICONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local CheckIcon  = Library:GetIcon("check")
local ArrowIcon  = Library:GetIcon("chevron-up")
local ResizeIcon = Library:GetIcon("move-diagonal-2")
local KeyIcon    = Library:GetIcon("key")
local MoveIcon   = Library:GetIcon("move")

function Library:SetIconModule(module)
    FetchIcons=true; Icons=module
    CheckIcon=Library:GetIcon("check"); ArrowIcon=Library:GetIcon("chevron-up")
    ResizeIcon=Library:GetIcon("move-diagonal-2"); KeyIcon=Library:GetIcon("key"); MoveIcon=Library:GetIcon("move")
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- BASE ADDONS (KeyPicker, ColorPicker)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local BaseAddons = {}
do
    local Funcs = {}

    -- ── KeyPicker ──────────────────────────────────
    function Funcs:AddKeyPicker(Idx, Info)
        Info = Library:Validate(Info, Templates.KeyPicker)
        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel
        local KeyPicker = {
            Text=Info.Text, Value=Info.Default, Modifiers=Info.DefaultModifiers, DisplayValue=Info.Default,
            Toggled=false, Mode=Info.Mode, SyncToggleState=Info.SyncToggleState,
            Callback=Info.Callback, ChangedCallback=Info.ChangedCallback, Changed=Info.Changed, Clicked=Info.Clicked,
            Type="KeyPicker",
        }
        if KeyPicker.Mode=="Press" then
            assert(ParentObj.Type=="Label","KeyPicker with mode 'Press' can only be applied on Labels.")
            KeyPicker.SyncToggleState=false; Info.Modes={"Press"}; Info.Mode="Press"
        end
        if KeyPicker.SyncToggleState then Info.Modes={"Toggle","Hold"}; if not table.find(Info.Modes,Info.Mode) then Info.Mode="Toggle" end end

        local Picking=false
        local SpecialKeys={["MB1"]=Enum.UserInputType.MouseButton1,["MB2"]=Enum.UserInputType.MouseButton2,["MB3"]=Enum.UserInputType.MouseButton3}
        local SpecialKeysInput={[Enum.UserInputType.MouseButton1]="MB1",[Enum.UserInputType.MouseButton2]="MB2",[Enum.UserInputType.MouseButton3]="MB3"}
        local Modifiers={["LAlt"]=Enum.KeyCode.LeftAlt,["RAlt"]=Enum.KeyCode.RightAlt,["LCtrl"]=Enum.KeyCode.LeftControl,["RCtrl"]=Enum.KeyCode.RightControl,["LShift"]=Enum.KeyCode.LeftShift,["RShift"]=Enum.KeyCode.RightShift,["Tab"]=Enum.KeyCode.Tab,["CapsLock"]=Enum.KeyCode.CapsLock}
        local ModifiersInput={[Enum.KeyCode.LeftAlt]="LAlt",[Enum.KeyCode.RightAlt]="RAlt",[Enum.KeyCode.LeftControl]="LCtrl",[Enum.KeyCode.RightControl]="RCtrl",[Enum.KeyCode.LeftShift]="LShift",[Enum.KeyCode.RightShift]="RShift",[Enum.KeyCode.Tab]="Tab",[Enum.KeyCode.CapsLock]="CapsLock"}
        local IsModifierInput=function(Input) return Input.UserInputType==Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode]~=nil end
        local GetActiveModifiers=function() local A={} for Name,Input in Modifiers do if not table.find(A,Name) and UserInputService:IsKeyDown(Input) then table.insert(A,Name) end end; return A end
        local AreModifiersHeld=function(Required) if not (typeof(Required)=="table" and GetTableSize(Required)>0) then return true end; local Active=GetActiveModifiers(); local Holding=true; for _,Name in Required do if not table.find(Active,Name) then Holding=false; break end end; return Holding end
        local IsInputDown=function(Input) if not Input then return false end; if SpecialKeysInput[Input.UserInputType]~=nil then return UserInputService:IsMouseButtonPressed(Input.UserInputType) and not UserInputService:GetFocusedTextBox(); elseif Input.UserInputType==Enum.UserInputType.Keyboard then return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox(); else return false end end
        local ConvertToInputModifiers=function(CurrentModifiers) local IM={} for _,name in CurrentModifiers do table.insert(IM,Modifiers[name]) end; return IM end

        -- Premium key picker button
        local Picker=New("TextButton", {
            BackgroundColor3=VX.SurfaceTop, Size=UDim2.fromOffset(22,18), Text=KeyPicker.Value,
            TextSize=12, TextColor3=VX.AccentGlow, Parent=ToggleLabel,
        })
        New("UICorner", { CornerRadius=UDim.new(0,5), Parent=Picker })
        New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.5, Parent=Picker })

        local KeybindsToggle={Normal=KeyPicker.Mode~="Toggle"}
        do
            local Holder=New("TextButton", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,16), Text="", Visible=not Info.NoUI, Parent=Library.KeybindContainer })
            local Label=New("TextLabel", { AutomaticSize=Enum.AutomaticSize.X, BackgroundTransparency=1, Size=UDim2.fromScale(0,1), Text="", TextSize=13, TextTransparency=0.5, TextColor3=VX.Text, Parent=Holder })
            local Checkbox=New("Frame", { AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=VX.SurfaceTop, Position=UDim2.fromScale(0,0.5), Size=UDim2.fromOffset(14,14), SizeConstraint=Enum.SizeConstraint.RelativeYY, Parent=Holder })
            New("UICorner", { CornerRadius=UDim.new(0,4), Parent=Checkbox })
            New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.5, Parent=Checkbox })
            local CheckImage=New("ImageLabel", { Image=CheckIcon and CheckIcon.Url or "", ImageColor3=VX.AccentGlow, ImageRectOffset=CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero, ImageRectSize=CheckIcon and CheckIcon.ImageRectSize or Vector2.zero, ImageTransparency=1, Position=UDim2.fromOffset(2,2), Size=UDim2.new(1,-4,1,-4), Parent=Checkbox })
            function KeybindsToggle:Display(State) Label.TextTransparency=State and 0 or 0.5; CheckImage.ImageTransparency=State and 0 or 1 end
            function KeybindsToggle:SetText(Text) Label.Text=Text end
            function KeybindsToggle:SetVisibility(Visibility) Holder.Visible=Visibility end
            function KeybindsToggle:SetNormal(Normal) KeybindsToggle.Normal=Normal; Holder.Active=not Normal; Label.Position=Normal and UDim2.fromOffset(0,0) or UDim2.fromOffset(22,0); Checkbox.Visible=not Normal end
            KeyPicker.DoClick=function(...) end
            Holder.MouseButton1Click:Connect(function() if KeybindsToggle.Normal then return end; KeyPicker.Toggled=not KeyPicker.Toggled; KeyPicker:DoClick() end)
            KeybindsToggle.Holder=Holder; KeybindsToggle.Label=Label; KeybindsToggle.Checkbox=Checkbox; KeybindsToggle.Loaded=true
            table.insert(Library.KeybindToggles,KeybindsToggle)
        end

        local MenuTable=Library:AddContextMenu(Picker,UDim2.fromOffset(62,0),function() return {Picker.AbsoluteSize.X+1.5,0.5} end,1)
        KeyPicker.Menu=MenuTable
        local ModeButtons={}
        for _, Mode in Info.Modes do
            local ModeButton={}
            local Button=New("TextButton", { BackgroundColor3=VX.SurfaceTop, BackgroundTransparency=1, Size=UDim2.new(1,0,0,22), Text=Mode, TextSize=13, TextTransparency=0.5, TextColor3=VX.Text, Parent=MenuTable.Menu })
            function ModeButton:Select() for _,B in ModeButtons do B:Deselect() end; KeyPicker.Mode=Mode; Button.BackgroundTransparency=0; Button.TextTransparency=0; Button.TextColor3=VX.AccentGlow; MenuTable:Close() end
            function ModeButton:Deselect() KeyPicker.Mode=nil; Button.BackgroundTransparency=1; Button.TextTransparency=0.5; Button.TextColor3=VX.Text end
            Button.MouseButton1Click:Connect(function() ModeButton:Select() end)
            if KeyPicker.Mode==Mode then ModeButton:Select() end
            ModeButtons[Mode]=ModeButton
        end

        function KeyPicker:Display(PickerText) if Library.Unloaded then return end; local X,Y=Library:GetTextBounds(PickerText or KeyPicker.DisplayValue,Picker.FontFace,Picker.TextSize,ToggleLabel.AbsoluteSize.X); Picker.Text=PickerText or KeyPicker.DisplayValue; Picker.Size=UDim2.fromOffset(X+9,Y+4) end
        function KeyPicker:Update()
            KeyPicker:Display()
            if Info.NoUI then return end
            if KeyPicker.Mode=="Toggle" and ParentObj.Type=="Toggle" and ParentObj.Disabled then KeybindsToggle:SetVisibility(false); return end
            local State=KeyPicker:GetState(); local ShowToggle=Library.ShowToggleFrameInKeybinds and KeyPicker.Mode=="Toggle"
            if KeyPicker.SyncToggleState and ParentObj.Value~=State then ParentObj:SetValue(State) end
            if KeybindsToggle.Loaded then
                if ShowToggle then KeybindsToggle:SetNormal(false) else KeybindsToggle:SetNormal(true) end
                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue,KeyPicker.Text,KeyPicker.Mode)); KeybindsToggle:SetVisibility(true); KeybindsToggle:Display(State)
            end
        end
        function KeyPicker:GetState()
            if KeyPicker.Mode=="Always" then return true
            elseif KeyPicker.Mode=="Hold" then
                local Key=KeyPicker.Value; if Key=="None" then return false end
                if not AreModifiersHeld(KeyPicker.Modifiers) then return false end
                if SpecialKeys[Key]~=nil then return UserInputService:IsMouseButtonPressed(SpecialKeys[Key]) and not UserInputService:GetFocusedTextBox()
                else return UserInputService:IsKeyDown(Enum.KeyCode[Key]) and not UserInputService:GetFocusedTextBox() end
            else return KeyPicker.Toggled end
        end
        function KeyPicker:OnChanged(Func) KeyPicker.Changed=Func end
        function KeyPicker:OnClick(Func) KeyPicker.Clicked=Func end
        function KeyPicker:DoClick()
            if KeyPicker.Mode=="Press" then if KeyPicker.Toggled and Info.WaitForCallback==true then return end; KeyPicker.Toggled=true end
            Library:SafeCallback(KeyPicker.Callback,KeyPicker.Toggled); Library:SafeCallback(KeyPicker.Clicked,KeyPicker.Toggled)
            if KeyPicker.Mode=="Press" then KeyPicker.Toggled=false end
            KeyPicker:Update()
        end
        function KeyPicker:SetValue(Value, Modifiers2)
            KeyPicker.Value=Value; KeyPicker.Modifiers=Modifiers2 or {}
            local ModifierStr="" if #KeyPicker.Modifiers>0 then ModifierStr=table.concat(KeyPicker.Modifiers,"+")+"+" end
            KeyPicker.DisplayValue=ModifierStr..Value; KeyPicker:Update()
        end
        Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
            if Library.Unloaded then return end
            if Picking then
                if Input.UserInputType==Enum.UserInputType.Keyboard and Input.KeyCode==Enum.KeyCode.Escape then
                    Picking=false; KeyPicker:Display("..."); return
                end
                if IsModifierInput(Input) then return end
                local Key = SpecialKeysInput[Input.UserInputType] or (Input.UserInputType==Enum.UserInputType.Keyboard and Library:GetKeyString(Input.KeyCode)) or nil
                if not Key then return end
                Picking=false
                local ActiveModifiers=GetActiveModifiers(); local ModifierStr="" if #ActiveModifiers>0 then ModifierStr=table.concat(ActiveModifiers,"+")+"+" end
                KeyPicker.Value=Key; KeyPicker.Modifiers=ActiveModifiers; KeyPicker.DisplayValue=ModifierStr..Key
                Library:SafeCallback(KeyPicker.ChangedCallback,KeyPicker.Value); Library:SafeCallback(KeyPicker.Changed,KeyPicker.Value)
                KeyPicker:Update(); return
            end
            if UserInputService:GetFocusedTextBox() then return end
            if KeyPicker.Value=="None" then return end
            if not AreModifiersHeld(KeyPicker.Modifiers) then return end
            local Key=SpecialKeysInput[Input.UserInputType] or (Input.UserInputType==Enum.UserInputType.Keyboard and Library:GetKeyString(Input.KeyCode)) or nil
            if Key~=KeyPicker.Value then return end
            if KeyPicker.Mode=="Toggle" then KeyPicker.Toggled=not KeyPicker.Toggled
            elseif KeyPicker.Mode=="Press" then KeyPicker.Toggled=true end
            KeyPicker:DoClick()
        end))
        Library:GiveSignal(UserInputService.InputEnded:Connect(function(Input)
            if Library.Unloaded or not Library.Toggled then return end
            if KeyPicker.Value=="None" then return end
            local Key=SpecialKeysInput[Input.UserInputType] or (Input.UserInputType==Enum.UserInputType.Keyboard and Library:GetKeyString(Input.KeyCode)) or nil
            if Key~=KeyPicker.Value then return end
            if KeyPicker.Mode=="Hold" then KeyPicker.Toggled=false; KeyPicker:DoClick() end
        end))
        Picker.MouseButton1Click:Connect(function()
            if Picking then Picking=false; KeyPicker:Display(); return end
            Picking=true; KeyPicker:Display("...")
            MenuTable:Toggle()
        end)
        KeyPicker:SetValue(KeyPicker.Value, KeyPicker.Modifiers)
        if ParentObj.Addons then table.insert(ParentObj.Addons, KeyPicker) end
        Options[Idx]=KeyPicker; return self
    end

    -- ── ColorPicker ────────────────────────────────
    function Funcs:AddColorPicker(Idx, Info)
        Info=Library:Validate(Info,Templates.ColorPicker)
        local ParentObj=self; local ToggleLabel=ParentObj.TextLabel
        local ColorPicker={
            Value=Info.Default, Transparency=Info.Transparency and 0 or nil,
            Hue=0, Sat=0, Vib=1,
            Callback=Info.Callback, Changed=Info.Changed, Type="ColorPicker",
        }
        ColorPicker:SetHSVFromRGB and nil or nil -- defined below
        local function SetHSV(C) ColorPicker.Hue,ColorPicker.Sat,ColorPicker.Vib=C:ToHSV() end
        SetHSV(ColorPicker.Value)

        local Holder=New("ImageButton", {
            BackgroundColor3=ColorPicker.Value,
            Size=UDim2.fromOffset(16,16), Parent=ToggleLabel,
        })
        New("UICorner", { CornerRadius=UDim.new(0,4), Parent=Holder })
        New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.5, Parent=Holder })
        local HolderTransparency=New("ImageLabel", { Image=CustomImageManager.GetAsset("TransparencyTexture"), ScaleType=Enum.ScaleType.Tile, TileSize=UDim2.fromOffset(8,8), Size=UDim2.fromScale(1,1), ImageTransparency=1, Parent=Holder })
        New("UICorner", { CornerRadius=UDim.new(0,4), Parent=HolderTransparency })

        local HueSequenceTable={ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(1/6,Color3.fromHSV(1/6,1,1)),ColorSequenceKeypoint.new(2/6,Color3.fromHSV(2/6,1,1)),ColorSequenceKeypoint.new(3/6,Color3.fromHSV(3/6,1,1)),ColorSequenceKeypoint.new(4/6,Color3.fromHSV(4/6,1,1)),ColorSequenceKeypoint.new(5/6,Color3.fromHSV(5/6,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(0,1,1))}

        local ColorMenu=Library:AddContextMenu(Holder,function()
            return UDim2.fromOffset(Info.Transparency and 252 or 234, 240)
        end,function() return {Holder.AbsoluteSize.X+4,0.5} end)
        ColorPicker.ColorMenu=ColorMenu
        New("UIListLayout", { Padding=UDim.new(0,4), Parent=ColorMenu.Menu })
        New("UIPadding", { PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,6), Parent=ColorMenu.Menu })

        local ColorHolder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,200), Parent=ColorMenu.Menu })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), Parent=ColorHolder })
        local SatVipMap=New("ImageButton", { BackgroundColor3=ColorPicker.Value, Image=CustomImageManager.GetAsset("SaturationMap"), Size=UDim2.fromOffset(200,200), Parent=ColorHolder })
        New("UICorner", { CornerRadius=UDim.new(0,6), Parent=SatVipMap })
        local SatVibCursor=New("Frame", { AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), Size=UDim2.fromOffset(6,6), Parent=SatVipMap })
        New("UICorner", { CornerRadius=UDim.new(1,0), Parent=SatVibCursor })
        New("UIStroke", { Color=Color3.new(0,0,0), Parent=SatVibCursor })
        local HueSelector=New("TextButton", { Size=UDim2.fromOffset(16,200), Text="", Parent=ColorHolder })
        New("UICorner", { CornerRadius=UDim.new(0,6), Parent=HueSelector })
        New("UIGradient", { Color=ColorSequence.new(HueSequenceTable), Rotation=90, Parent=HueSelector })
        local HueCursor=New("Frame", { AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), BorderColor3=Color3.new(0,0,0), BorderSizePixel=1, Position=UDim2.fromScale(0.5,ColorPicker.Hue), Size=UDim2.new(1,2,0,1), Parent=HueSelector })

        local TransparencySelector,TransparencyColor,TransparencyCursor
        if Info.Transparency then
            TransparencySelector=New("ImageButton", { Image=CustomImageManager.GetAsset("TransparencyTexture"), ScaleType=Enum.ScaleType.Tile, Size=UDim2.fromOffset(16,200), TileSize=UDim2.fromOffset(8,8), Parent=ColorHolder })
            New("UICorner", { CornerRadius=UDim.new(0,6), Parent=TransparencySelector })
            TransparencyColor=New("Frame", { BackgroundColor3=ColorPicker.Value, Size=UDim2.fromScale(1,1), Parent=TransparencySelector })
            New("UICorner", { CornerRadius=UDim.new(0,6), Parent=TransparencyColor })
            New("UIGradient", { Rotation=90, Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}), Parent=TransparencyColor })
            TransparencyCursor=New("Frame", { AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), BorderColor3=Color3.new(0,0,0), BorderSizePixel=1, Position=UDim2.fromScale(0.5,ColorPicker.Transparency), Size=UDim2.new(1,2,0,1), Parent=TransparencySelector })
        end

        local InfoHolder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,24), Parent=ColorMenu.Menu })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalFlex=Enum.UIFlexAlignment.Fill, Padding=UDim.new(0,8), Parent=InfoHolder })
        local HueBox=New("TextBox", { BackgroundColor3=VX.SurfaceTop, Size=UDim2.fromScale(1,1), Text="#??????", TextSize=13, TextColor3=VX.Text, Parent=InfoHolder })
        New("UICorner", { CornerRadius=UDim.new(0,5), Parent=HueBox })
        New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.6, Parent=HueBox })
        local RgbBox=New("TextBox", { BackgroundColor3=VX.SurfaceTop, Size=UDim2.fromScale(1,1), Text="?, ?, ?", TextSize=13, TextColor3=VX.Text, Parent=InfoHolder })
        New("UICorner", { CornerRadius=UDim.new(0,5), Parent=RgbBox })
        New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=1, Transparency=0.6, Parent=RgbBox })

        local ContextMenu=Library:AddContextMenu(Holder,UDim2.fromOffset(93,0),function() return {Holder.AbsoluteSize.X+1.5,0.5} end,1)
        ColorPicker.ContextMenu=ContextMenu
        do
            local function CreateCtxButton(Text, Func)
                local B=New("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),Text=Text,TextSize=13,TextColor3=VX.TextDim,Parent=ContextMenu.Menu})
                B.MouseButton1Click:Connect(function() Library:SafeCallback(Func); ContextMenu:Close() end)
                B.MouseEnter:Connect(function() TweenService:Create(B,Library.TweenInfo,{TextColor3=VX.AccentGlow}):Play() end)
                B.MouseLeave:Connect(function() TweenService:Create(B,Library.TweenInfo,{TextColor3=VX.TextDim}):Play() end)
            end
            CreateCtxButton("Copy color",function() Library.CopiedColor={ColorPicker.Value,ColorPicker.Transparency} end)
            ColorPicker.SetValueRGB=function(...)end
            CreateCtxButton("Paste color",function() ColorPicker:SetValueRGB(Library.CopiedColor[1],Library.CopiedColor[2]) end)
            if setclipboard then
                CreateCtxButton("Copy Hex",function() setclipboard(tostring(ColorPicker.Value:ToHex())) end)
                CreateCtxButton("Copy RGB",function() setclipboard(table.concat({math.floor(ColorPicker.Value.R*255),math.floor(ColorPicker.Value.G*255),math.floor(ColorPicker.Value.B*255)},", ")) end)
            end
        end

        function ColorPicker:SetHSVFromRGB(Color) ColorPicker.Hue,ColorPicker.Sat,ColorPicker.Vib=Color:ToHSV() end
        function ColorPicker:Display()
            if Library.Unloaded then return end
            ColorPicker.Value=Color3.fromHSV(ColorPicker.Hue,ColorPicker.Sat,ColorPicker.Vib)
            Holder.BackgroundColor3=ColorPicker.Value; HolderTransparency.ImageTransparency=(1-ColorPicker.Transparency)
            SatVipMap.BackgroundColor3=Color3.fromHSV(ColorPicker.Hue,1,1)
            if TransparencyColor then TransparencyColor.BackgroundColor3=ColorPicker.Value end
            SatVibCursor.Position=UDim2.fromScale(ColorPicker.Sat,1-ColorPicker.Vib); HueCursor.Position=UDim2.fromScale(0.5,ColorPicker.Hue)
            if TransparencyCursor then TransparencyCursor.Position=UDim2.fromScale(0.5,ColorPicker.Transparency) end
            HueBox.Text="#"..ColorPicker.Value:ToHex(); RgbBox.Text=table.concat({math.floor(ColorPicker.Value.R*255),math.floor(ColorPicker.Value.G*255),math.floor(ColorPicker.Value.B*255)},", ")
        end
        function ColorPicker:Update() ColorPicker:Display(); Library:SafeCallback(ColorPicker.Callback,ColorPicker.Value); Library:SafeCallback(ColorPicker.Changed,ColorPicker.Value) end
        function ColorPicker:OnChanged(Func) ColorPicker.Changed=Func end
        function ColorPicker:SetValue(HSV, Transparency2) if typeof(HSV)=="Color3" then ColorPicker:SetValueRGB(HSV,Transparency2); return end; local Color=Color3.fromHSV(HSV[1],HSV[2],HSV[3]); ColorPicker.Transparency=Info.Transparency and Transparency2 or 0; ColorPicker:SetHSVFromRGB(Color); ColorPicker:Update() end
        function ColorPicker:SetValueRGB(Color, Transparency2) ColorPicker.Transparency=Info.Transparency and Transparency2 or 0; ColorPicker:SetHSVFromRGB(Color); ColorPicker:Update() end

        Holder.MouseButton1Click:Connect(ColorMenu.Toggle)
        SatVipMap.InputBegan:Connect(function(Input)
            while IsDragInput(Input) do
                local Min=SatVipMap.AbsolutePosition; local Max=Min+SatVipMap.AbsoluteSize
                local OldSat=ColorPicker.Sat; local OldVib=ColorPicker.Vib
                ColorPicker.Sat=math.clamp((Mouse.X-Min.X)/(Max.X-Min.X),0,1)
                ColorPicker.Vib=1-math.clamp((Mouse.Y-Min.Y)/(Max.Y-Min.Y),0,1)
                if ColorPicker.Sat~=OldSat or ColorPicker.Vib~=OldVib then ColorPicker:Update() end
                RunService.RenderStepped:Wait()
            end
        end)
        HueSelector.InputBegan:Connect(function(Input)
            while IsDragInput(Input) do
                local Min=HueSelector.AbsolutePosition.Y; local Max=Min+HueSelector.AbsoluteSize.Y
                local OldHue=ColorPicker.Hue; ColorPicker.Hue=(math.clamp(Mouse.Y,Min,Max)-Min)/(Max-Min)
                if ColorPicker.Hue~=OldHue then ColorPicker:Update() end; RunService.RenderStepped:Wait()
            end
        end)
        if TransparencySelector then
            TransparencySelector.InputBegan:Connect(function(Input)
                while IsDragInput(Input) do
                    local Min=TransparencySelector.AbsolutePosition.Y; local Max=Min+TransparencySelector.AbsoluteSize.Y
                    local OldTrans=ColorPicker.Transparency; ColorPicker.Transparency=(math.clamp(Mouse.Y,Min,Max)-Min)/(Max-Min)
                    if ColorPicker.Transparency~=OldTrans then ColorPicker:Update() end; RunService.RenderStepped:Wait()
                end
            end)
        end
        HueBox.FocusLost:Connect(function(Enter) if not Enter then return end; local Success,Color=pcall(Color3.fromHex,HueBox.Text); if Success and typeof(Color)=="Color3" then ColorPicker:SetHSVFromRGB(Color) end; ColorPicker:Update() end)
        RgbBox.FocusLost:Connect(function(Enter) if not Enter then return end; local R,G,B=RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)"); if R and G and B then ColorPicker:SetHSVFromRGB(Color3.fromRGB(R,G,B)) end; ColorPicker:Update() end)

        ColorPicker:Display()
        if ParentObj.Addons then table.insert(ParentObj.Addons,ColorPicker) end
        ColorPicker.Default=ColorPicker.Value; Options[Idx]=ColorPicker; return self
    end

    BaseAddons.__index=Funcs
    BaseAddons.__namecall=function(_,Key,...) return Funcs[Key](...) end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- BASE GROUPBOX
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local BaseGroupbox = {}
do
    local Funcs = {}

    -- ── AddDivider ─────────────────────────────────
    function Funcs:AddDivider(...)
        local Params=select(1,...); local Text,MarginTop,MarginBottom=nil,0,0
        if typeof(Params)=="table" then Text=Params.Text; MarginTop=Params.MarginTop or Params.Margin or 0; MarginBottom=Params.MarginBottom or Params.Margin or 0
        elseif typeof(Params)=="string" then Text=Params end
        local Groupbox=self; local Container=Groupbox.Container
        local Holder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,8+MarginTop+MarginBottom), Parent=Container })
        local InnerHolder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Parent=Holder })
        New("UIPadding", { PaddingTop=UDim.new(0,MarginTop), PaddingBottom=UDim.new(0,MarginBottom), Parent=Holder })
        if Text then
            local TextLabel=New("TextLabel", { AutomaticSize=Enum.AutomaticSize.X, BackgroundTransparency=1, Size=UDim2.fromScale(1,0), Text=Text, TextSize=13, TextTransparency=0.4, TextXAlignment=Enum.TextXAlignment.Center, TextColor3=VX.TextDim, Parent=InnerHolder })
            local X,_=Library:GetTextBounds(Text,TextLabel.FontFace,TextLabel.TextSize,TextLabel.AbsoluteSize.X); local SizeX=X//2+10
            New("Frame", { AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=VX.Border, Position=UDim2.fromScale(0,0.5), Size=UDim2.new(0.5,-SizeX,0,1), Parent=InnerHolder })
            New("Frame", { AnchorPoint=Vector2.new(1,0.5), BackgroundColor3=VX.Border, Position=UDim2.fromScale(1,0.5), Size=UDim2.new(0.5,-SizeX,0,1), Parent=InnerHolder })
        else
            local Divider=New("Frame", { AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=VX.Border, Position=UDim2.fromScale(0,0.5), Size=UDim2.new(1,0,0,1), Parent=InnerHolder })
            local dGrad=Instance.new("UIGradient",Divider); dGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Library.Scheme.AccentColor),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}); dGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,1)})
        end
        Groupbox:Resize()
        table.insert(Groupbox.Elements, { Holder=Holder, Type="Divider" })
    end

    -- ── AddLabel ───────────────────────────────────
    function Funcs:AddLabel(...)
        local Data={}; local Addons={}
        local First=select(1,...); local Second=select(2,...)
        if typeof(First)=="table" or typeof(Second)=="table" then
            local Params=typeof(First)=="table" and First or Second
            Data.Text=Params.Text or ""; Data.DoesWrap=Params.DoesWrap or false; Data.Size=Params.Size or 14; Data.Visible=Params.Visible or true; Data.Idx=typeof(Second)=="table" and First or nil
        else Data.Text=First or ""; Data.DoesWrap=Second or false; Data.Size=14; Data.Visible=true; Data.Idx=select(3,...) or nil end
        local Groupbox=self; local Container=Groupbox.Container
        local Label={ Text=Data.Text, DoesWrap=Data.DoesWrap, Addons=Addons, Visible=Data.Visible, Type="Label" }
        local TextLabel=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,18), Text=Label.Text, TextSize=Data.Size, TextWrapped=Label.DoesWrap, TextXAlignment=Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left, TextColor3=VX.TextDim, Parent=Container })
        function Label:SetVisible(Visible) Label.Visible=Visible; TextLabel.Visible=Label.Visible; Groupbox:Resize() end
        function Label:SetText(Text) Label.Text=Text; TextLabel.Text=Text; if Label.DoesWrap then local _,Y=Library:GetTextBounds(Label.Text,TextLabel.FontFace,TextLabel.TextSize,TextLabel.AbsoluteSize.X); TextLabel.Size=UDim2.new(1,0,0,Y+4) end; Groupbox:Resize() end
        if Label.DoesWrap then
            local _,Y=Library:GetTextBounds(Label.Text,TextLabel.FontFace,TextLabel.TextSize,TextLabel.AbsoluteSize.X); TextLabel.Size=UDim2.new(1,0,0,Y+4)
            local Last=TextLabel.AbsoluteSize
            TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() if TextLabel.AbsoluteSize==Last then return end; local _,Y=Library:GetTextBounds(Label.Text,TextLabel.FontFace,TextLabel.TextSize,TextLabel.AbsoluteSize.X); TextLabel.Size=UDim2.new(1,0,0,Y+4); Last=TextLabel.AbsoluteSize; Groupbox:Resize() end)
        else
            New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Right, Padding=UDim.new(0,6), Parent=TextLabel })
        end
        Groupbox:Resize()
        Label.TextLabel=TextLabel; Label.Container=Container
        if not Data.DoesWrap then setmetatable(Label,BaseAddons) end
        Label.Holder=TextLabel; table.insert(Groupbox.Elements,Label)
        if Data.Idx then Labels[Data.Idx]=Label else table.insert(Labels,Label) end
        return Label
    end

    -- ── AddButton ──────────────────────────────────
    function Funcs:AddButton(...)
        local function GetInfo(...)
            local Info={}; local First=select(1,...); local Second=select(2,...)
            if typeof(First)=="table" or typeof(Second)=="table" then
                local Params=typeof(First)=="table" and First or Second
                Info.Text=Params.Text or ""; Info.Func=Params.Func or Params.Callback or function()end; Info.DoubleClick=Params.DoubleClick; Info.Tooltip=Params.Tooltip; Info.DisabledTooltip=Params.DisabledTooltip; Info.Risky=Params.Risky or false; Info.Disabled=Params.Disabled or false; Info.Visible=Params.Visible or true; Info.Idx=typeof(Second)=="table" and First or nil
            else Info.Text=First or ""; Info.Func=Second or function()end; Info.DoubleClick=false; Info.Tooltip=nil; Info.DisabledTooltip=nil; Info.Risky=false; Info.Disabled=false; Info.Visible=true; Info.Idx=select(3,...) or nil end
            return Info
        end
        local Info=GetInfo(...)
        local Groupbox=self; local Container=Groupbox.Container
        local Button={ Text=Info.Text, Func=Info.Func, DoubleClick=Info.DoubleClick, Tooltip=Info.Tooltip, DisabledTooltip=Info.DisabledTooltip, TooltipTable=nil, Risky=Info.Risky, Disabled=Info.Disabled, Visible=Info.Visible, Tween=nil, Type="Button" }
        local Holder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,24), Parent=Container })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalFlex=Enum.UIFlexAlignment.Fill, Padding=UDim.new(0,8), Parent=Holder })

        local function CreateButton(Button)
            local Base=New("TextButton", {
                Active=not Button.Disabled, BackgroundColor3=Button.Disabled and VX.Surface or VX.SurfaceTop,
                Size=UDim2.fromScale(1,1), Text=Button.Text, TextSize=14,
                TextTransparency=Button.Disabled and 0.7 or 0.3, Visible=Button.Visible,
                TextColor3=Button.Risky and Library.Scheme.RedColor or VX.Text, Parent=Holder,
            })
            New("UICorner", { CornerRadius=UDim.new(0,7), Parent=Base })
            local Stroke=New("UIStroke", { Color=Button.Disabled and VX.Border or Library.Scheme.AccentColor, Thickness=1, Transparency=Button.Disabled and 0.8 or 0.5, Parent=Base })
            return Base, Stroke
        end

        local function InitEvents(Button)
            Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then return end
                Button.Tween=TweenService:Create(Button.Base,Library.TweenInfo,{TextTransparency=0,BackgroundColor3=VX.SurfaceTop})
                Button.Tween:Play()
                TweenService:Create(Button.Stroke,Library.TweenInfo,{Transparency=0}):Play()
            end)
            Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then return end
                Button.Tween=TweenService:Create(Button.Base,Library.TweenInfo,{TextTransparency=0.3,BackgroundColor3=VX.SurfaceTop})
                Button.Tween:Play()
                TweenService:Create(Button.Stroke,Library.TweenInfo,{Transparency=0.5}):Play()
            end)
            Button.Base.MouseButton1Click:Connect(function()
                if Button.Disabled or Button.Locked then return end
                -- Click flash effect
                TweenService:Create(Button.Base,TweenInfo.new(0.05),{BackgroundColor3=Library.Scheme.AccentColor}):Play()
                task.delay(0.05,function() TweenService:Create(Button.Base,TweenInfo.new(0.15),{BackgroundColor3=VX.SurfaceTop}):Play() end)
                if Button.DoubleClick then
                    Button.Locked=true; Button.Base.Text="Are you sure?"; Button.Base.TextColor3=Library.Scheme.AccentColor
                    local Clicked=WaitForEvent(Button.Base.MouseButton1Click,0.5)
                    Button.Base.Text=Button.Text; Button.Base.TextColor3=Button.Risky and Library.Scheme.RedColor or VX.Text
                    if Clicked then Library:SafeCallback(Button.Func) end
                    RunService.RenderStepped:Wait(); Button.Locked=false; return
                end
                Library:SafeCallback(Button.Func)
            end)
        end

        Button.Base, Button.Stroke = CreateButton(Button)
        InitEvents(Button)

        function Button:AddButton(...)
            local Info2=GetInfo(...)
            local SubButton={ Text=Info2.Text, Func=Info2.Func, DoubleClick=Info2.DoubleClick, Tooltip=Info2.Tooltip, DisabledTooltip=Info2.DisabledTooltip, TooltipTable=nil, Risky=Info2.Risky, Disabled=Info2.Disabled, Visible=Info2.Visible, Tween=nil, Type="SubButton" }
            Button.SubButton=SubButton; SubButton.Base,SubButton.Stroke=CreateButton(SubButton); InitEvents(SubButton)
            function SubButton:UpdateColors() StopTween(SubButton.Tween); SubButton.Base.BackgroundColor3=SubButton.Disabled and VX.Surface or VX.SurfaceTop; SubButton.Base.TextTransparency=SubButton.Disabled and 0.8 or 0.3; SubButton.Stroke.Transparency=SubButton.Disabled and 0.8 or 0.5 end
            function SubButton:SetDisabled(Disabled) SubButton.Disabled=Disabled; if SubButton.TooltipTable then SubButton.TooltipTable.Disabled=SubButton.Disabled end; SubButton.Base.Active=not SubButton.Disabled; SubButton:UpdateColors() end
            function SubButton:SetVisible(Visible) SubButton.Visible=Visible; SubButton.Base.Visible=SubButton.Visible; Groupbox:Resize() end
            function SubButton:SetText(Text) SubButton.Text=Text; SubButton.Base.Text=Text end
            if typeof(SubButton.Tooltip)=="string" or typeof(SubButton.DisabledTooltip)=="string" then SubButton.TooltipTable=Library:AddTooltip(SubButton.Tooltip,SubButton.DisabledTooltip,SubButton.Base); SubButton.TooltipTable.Disabled=SubButton.Disabled end
            if SubButton.Risky then SubButton.Base.TextColor3=Library.Scheme.RedColor end
            SubButton:UpdateColors()
            if Info2.Idx then Buttons[Info2.Idx]=SubButton else table.insert(Buttons,SubButton) end
            return SubButton
        end

        function Button:UpdateColors() StopTween(Button.Tween); Button.Base.BackgroundColor3=Button.Disabled and VX.Surface or VX.SurfaceTop; Button.Base.TextTransparency=Button.Disabled and 0.8 or 0.3; Button.Stroke.Transparency=Button.Disabled and 0.8 or 0.5 end
        function Button:SetDisabled(Disabled) Button.Disabled=Disabled; if Button.TooltipTable then Button.TooltipTable.Disabled=Button.Disabled end; Button.Base.Active=not Button.Disabled; Button:UpdateColors() end
        function Button:SetVisible(Visible) Button.Visible=Visible; Holder.Visible=Button.Visible; Groupbox:Resize() end
        function Button:SetText(Text) Button.Text=Text; Button.Base.Text=Text end
        if typeof(Button.Tooltip)=="string" or typeof(Button.DisabledTooltip)=="string" then Button.TooltipTable=Library:AddTooltip(Button.Tooltip,Button.DisabledTooltip,Button.Base); Button.TooltipTable.Disabled=Button.Disabled end
        Button:UpdateColors(); Groupbox:Resize(); Button.Holder=Holder; table.insert(Groupbox.Elements,Button)
        if Info.Idx then Buttons[Info.Idx]=Button else table.insert(Buttons,Button) end
        return Button
    end

    -- ── AddCheckbox ────────────────────────────────
    function Funcs:AddCheckbox(Idx, Info)
        Info=Library:Validate(Info,Templates.Toggle)
        local Groupbox=self; local Container=Groupbox.Container
        local Toggle={ Text=Info.Text, Value=Info.Default, Tooltip=Info.Tooltip, DisabledTooltip=Info.DisabledTooltip, TooltipTable=nil, Callback=Info.Callback, Changed=Info.Changed, Risky=Info.Risky, Disabled=Info.Disabled, Visible=Info.Visible, Addons={}, Type="Toggle" }
        local Button=New("TextButton", { Active=not Toggle.Disabled, BackgroundTransparency=1, Size=UDim2.new(1,0,0,20), Text="", Visible=Toggle.Visible, Parent=Container })
        local Label=New("TextLabel", { BackgroundTransparency=1, Position=UDim2.fromOffset(28,0), Size=UDim2.new(1,-28,1,0), Text=Toggle.Text, TextSize=14, TextTransparency=Toggle.Disabled and 0.8 or (Toggle.Value and 0 or 0.4), TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Toggle.Risky and Library.Scheme.RedColor or VX.Text, Parent=Button })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Right, Padding=UDim.new(0,6), Parent=Label })
        local Checkbox=New("Frame", { BackgroundColor3=VX.SurfaceTop, Size=UDim2.fromScale(1,1), SizeConstraint=Enum.SizeConstraint.RelativeYY, Parent=Button })
        New("UICorner", { CornerRadius=UDim.new(0,5), Parent=Checkbox })
        local CheckboxStroke=New("UIStroke", { Color=Toggle.Value and Library.Scheme.AccentColor or VX.Border, Thickness=1, Transparency=Toggle.Disabled and 0.8 or 0, Parent=Checkbox })
        local CheckImage=New("ImageLabel", { Image=CheckIcon and CheckIcon.Url or "", ImageColor3=VX.AccentGlow, ImageRectOffset=CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero, ImageRectSize=CheckIcon and CheckIcon.ImageRectSize or Vector2.zero, ImageTransparency=Toggle.Value and 0 or 1, Position=UDim2.fromOffset(2,2), Size=UDim2.new(1,-4,1,-4), Parent=Checkbox })
        function Toggle:UpdateColors() Toggle:Display() end
        function Toggle:Display()
            if Library.Unloaded then return end
            CheckboxStroke.Transparency=Toggle.Disabled and 0.8 or 0
            if Toggle.Disabled then Label.TextTransparency=0.8; CheckImage.ImageTransparency=Toggle.Value and 0.8 or 1; Checkbox.BackgroundColor3=VX.Surface; return end
            TweenService:Create(Label,Library.TweenInfo,{TextTransparency=Toggle.Value and 0 or 0.4}):Play()
            TweenService:Create(CheckImage,Library.TweenInfo,{ImageTransparency=Toggle.Value and 0 or 1}):Play()
            TweenService:Create(CheckboxStroke,Library.TweenInfo,{Color=Toggle.Value and Library.Scheme.AccentColor or VX.Border}):Play()
            Checkbox.BackgroundColor3=VX.SurfaceTop
        end
        function Toggle:OnChanged(Func) Toggle.Changed=Func end
        function Toggle:SetValue(Value) if Toggle.Disabled then return end; Toggle.Value=Value; Toggle:Display(); for _,Addon in Toggle.Addons do if Addon.Type=="KeyPicker" and Addon.SyncToggleState then Addon.Toggled=Toggle.Value; Addon:Update() end end; Library:UpdateDependencyBoxes(); Library:SafeCallback(Toggle.Callback,Toggle.Value); Library:SafeCallback(Toggle.Changed,Toggle.Value) end
        function Toggle:SetDisabled(Disabled) Toggle.Disabled=Disabled; if Toggle.TooltipTable then Toggle.TooltipTable.Disabled=Toggle.Disabled end; for _,Addon in Toggle.Addons do if Addon.Type=="KeyPicker" and Addon.SyncToggleState then Addon:Update() end end; Button.Active=not Toggle.Disabled; Toggle:Display() end
        function Toggle:SetVisible(Visible) Toggle.Visible=Visible; Button.Visible=Toggle.Visible; Groupbox:Resize() end
        function Toggle:SetText(Text) Toggle.Text=Text; Label.Text=Text end
        Button.MouseButton1Click:Connect(function() if Toggle.Disabled then return end; Toggle:SetValue(not Toggle.Value) end)
        if typeof(Toggle.Tooltip)=="string" or typeof(Toggle.DisabledTooltip)=="string" then Toggle.TooltipTable=Library:AddTooltip(Toggle.Tooltip,Toggle.DisabledTooltip,Button); Toggle.TooltipTable.Disabled=Toggle.Disabled end
        Toggle:Display(); Groupbox:Resize(); Toggle.TextLabel=Label; Toggle.Container=Container; setmetatable(Toggle,BaseAddons); Toggle.Holder=Button; table.insert(Groupbox.Elements,Toggle); Toggle.Default=Toggle.Value; Toggles[Idx]=Toggle
        return Toggle
    end

    -- ── AddToggle ──────────────────────────────────
    function Funcs:AddToggle(Idx, Info)
        if Library.ForceCheckbox then return Funcs.AddCheckbox(self,Idx,Info) end
        Info=Library:Validate(Info,Templates.Toggle)
        local Groupbox=self; local Container=Groupbox.Container
        local Toggle={ Text=Info.Text, Value=Info.Default, Tooltip=Info.Tooltip, DisabledTooltip=Info.DisabledTooltip, TooltipTable=nil, Callback=Info.Callback, Changed=Info.Changed, Risky=Info.Risky, Disabled=Info.Disabled, Visible=Info.Visible, Addons={}, Type="Toggle" }
        local Button=New("TextButton", { Active=not Toggle.Disabled, BackgroundTransparency=1, Size=UDim2.new(1,0,0,22), Text="", Visible=Toggle.Visible, Parent=Container })
        local Label=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(1,-46,1,0), Text=Toggle.Text, TextSize=14, TextTransparency=Toggle.Disabled and 0.8 or (Toggle.Value and 0 or 0.4), TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Toggle.Risky and Library.Scheme.RedColor or VX.Text, Parent=Button })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Right, Padding=UDim.new(0,6), Parent=Label })

        -- VOIDEX Premium pill switch
        local Switch=New("Frame", { AnchorPoint=Vector2.new(1,0.5), BackgroundColor3=Toggle.Value and Library.Scheme.AccentColor or VX.SurfaceTop, Position=UDim2.new(1,0,0.5,0), Size=UDim2.fromOffset(36,20), Parent=Button })
        New("UICorner", { CornerRadius=UDim.new(1,0), Parent=Switch })
        New("UIPadding", { PaddingBottom=UDim.new(0,3), PaddingLeft=UDim.new(0,3), PaddingRight=UDim.new(0,3), PaddingTop=UDim.new(0,3), Parent=Switch })
        local SwitchStroke=New("UIStroke", { Color=Toggle.Value and Library.Scheme.AccentColor or VX.Border, Thickness=1, Transparency=Toggle.Disabled and 0.75 or 0, Parent=Switch })
        -- Glowing knob
        local Ball=New("Frame", {
            BackgroundColor3=Toggle.Disabled and VX.TextFaint or (Toggle.Value and Color3.new(1,1,1) or VX.TextDim),
            AnchorPoint=Vector2.new(Toggle.Value and 1 or 0, 0),
            Position=UDim2.fromScale(Toggle.Value and 1 or 0, 0),
            Size=UDim2.fromScale(1,1), SizeConstraint=Enum.SizeConstraint.RelativeYY, Parent=Switch,
        })
        New("UICorner", { CornerRadius=UDim.new(1,0), Parent=Ball })
        -- Glow inside ball when active
        local BallGlow=New("UIStroke", { Color=Color3.new(1,1,1), Thickness=1.5, Transparency=Toggle.Value and 0.3 or 1, Parent=Ball })

        function Toggle:UpdateColors() Toggle:Display() end
        function Toggle:Display()
            if Library.Unloaded then return end
            local Offset=Toggle.Value and 1 or 0
            Switch.BackgroundTransparency=Toggle.Disabled and 0.75 or 0
            SwitchStroke.Transparency=Toggle.Disabled and 0.75 or 0
            if Toggle.Disabled then
                Label.TextTransparency=0.8
                Ball.AnchorPoint=Vector2.new(Offset,0); Ball.Position=UDim2.fromScale(Offset,0)
                Ball.BackgroundColor3=VX.TextFaint
                TweenService:Create(Switch,Library.TweenInfo,{BackgroundColor3=VX.Surface}):Play()
                TweenService:Create(SwitchStroke,Library.TweenInfo,{Color=VX.Border}):Play()
                return
            end
            TweenService:Create(Label,Library.TweenInfo,{TextTransparency=Toggle.Value and 0 or 0.4}):Play()
            TweenService:Create(Ball,Library.TweenInfo,{AnchorPoint=Vector2.new(Offset,0),Position=UDim2.fromScale(Offset,0)}):Play()
            TweenService:Create(Ball,Library.TweenInfo,{BackgroundColor3=Toggle.Value and Color3.new(1,1,1) or VX.TextDim}):Play()
            TweenService:Create(BallGlow,Library.TweenInfo,{Transparency=Toggle.Value and 0.3 or 1}):Play()
            if Toggle.Value then
                TweenService:Create(Switch,Library.TweenInfo,{BackgroundColor3=Library.Scheme.AccentColor}):Play()
                TweenService:Create(SwitchStroke,Library.TweenInfo,{Color=Library.Scheme.AccentColor}):Play()
                -- Shimmer effect on switch
                AnimateAccentGradient(Switch, true)
            else
                -- Remove gradient
                local g=Switch:FindFirstChildOfClass("UIGradient"); if g then g:Destroy() end
                TweenService:Create(Switch,Library.TweenInfo,{BackgroundColor3=VX.SurfaceTop}):Play()
                TweenService:Create(SwitchStroke,Library.TweenInfo,{Color=VX.Border}):Play()
            end
        end
        function Toggle:OnChanged(Func) Toggle.Changed=Func end
        function Toggle:SetValue(Value)
            if Toggle.Disabled then return end; Toggle.Value=Value; Toggle:Display()
            for _,Addon in Toggle.Addons do if Addon.Type=="KeyPicker" and Addon.SyncToggleState then Addon.Toggled=Toggle.Value; Addon:Update() end end
            Library:UpdateDependencyBoxes(); Library:SafeCallback(Toggle.Callback,Toggle.Value); Library:SafeCallback(Toggle.Changed,Toggle.Value)
        end
        function Toggle:SetDisabled(Disabled) Toggle.Disabled=Disabled; if Toggle.TooltipTable then Toggle.TooltipTable.Disabled=Toggle.Disabled end; for _,Addon in Toggle.Addons do if Addon.Type=="KeyPicker" and Addon.SyncToggleState then Addon:Update() end end; Button.Active=not Toggle.Disabled; Toggle:Display() end
        function Toggle:SetVisible(Visible) Toggle.Visible=Visible; Button.Visible=Toggle.Visible; Groupbox:Resize() end
        function Toggle:SetText(Text) Toggle.Text=Text; Label.Text=Text end

        Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then return end
            -- Click ripple on the switch
            local ripple=Instance.new("Frame"); ripple.BackgroundColor3=Color3.new(1,1,1); ripple.BackgroundTransparency=0.7; ripple.AnchorPoint=Vector2.new(0.5,0.5); ripple.Position=UDim2.fromScale(0.5,0.5); ripple.Size=UDim2.fromOffset(0,0); ripple.ZIndex=Switch.ZIndex+1; ripple.Parent=Switch
            Instance.new("UICorner",ripple).CornerRadius=UDim.new(1,0)
            TweenService:Create(ripple,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(36,36),BackgroundTransparency=1}):Play()
            task.delay(0.3,function() pcall(ripple.Destroy,ripple) end)
            Toggle:SetValue(not Toggle.Value)
        end)

        if typeof(Toggle.Tooltip)=="string" or typeof(Toggle.DisabledTooltip)=="string" then Toggle.TooltipTable=Library:AddTooltip(Toggle.Tooltip,Toggle.DisabledTooltip,Button); Toggle.TooltipTable.Disabled=Toggle.Disabled end
        Toggle:Display(); Groupbox:Resize(); Toggle.TextLabel=Label; Toggle.Container=Container; setmetatable(Toggle,BaseAddons); Toggle.Holder=Button; table.insert(Groupbox.Elements,Toggle); Toggle.Default=Toggle.Value; Toggles[Idx]=Toggle
        return Toggle
    end

    -- ── AddInput ───────────────────────────────────
    function Funcs:AddInput(Idx, Info)
        Info=Library:Validate(Info,Templates.Input)
        local Groupbox=self; local Container=Groupbox.Container
        local InputObj={ Text=Info.Text, Value=Info.Default, Finished=Info.Finished, Numeric=Info.Numeric, ClearTextOnFocus=Info.ClearTextOnFocus, Placeholder=Info.Placeholder, AllowEmpty=Info.AllowEmpty, EmptyReset=Info.EmptyReset, Callback=Info.Callback, Changed=Info.Changed, Disabled=Info.Disabled, Visible=Info.Visible, Tooltip=Info.Tooltip, DisabledTooltip=Info.DisabledTooltip, TooltipTable=nil, Type="Input" }
        local Holder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,42), Visible=InputObj.Visible, Parent=Container })
        local InputLabel=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,18), Text=InputObj.Text, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=VX.TextDim, Parent=Holder })
        local Box=New("TextBox", {
            Active=not InputObj.Disabled, BackgroundColor3=VX.SurfaceTop,
            PlaceholderText=InputObj.Placeholder, Position=UDim2.fromOffset(0,20), Size=UDim2.new(1,0,0,22),
            Text=InputObj.Value, TextSize=14, ClearTextOnFocus=InputObj.ClearTextOnFocus,
            TextColor3=VX.Text, PlaceholderColor3=VX.TextFaint, Parent=Holder,
        })
        New("UICorner", { CornerRadius=UDim.new(0,7), Parent=Box })
        local BoxStroke=New("UIStroke", { Color=VX.Border, Thickness=1, Transparency=InputObj.Disabled and 0.8 or 0, Parent=Box })
        New("UIPadding", { PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Parent=Box })
        Box.Focused:Connect(function() TweenService:Create(BoxStroke,Library.TweenInfo,{Color=Library.Scheme.AccentColor,Transparency=0}):Play() end)
        Box.FocusLost:Connect(function() TweenService:Create(BoxStroke,Library.TweenInfo,{Color=VX.Border,Transparency=0}):Play() end)
        function InputObj:UpdateColors() if Library.Unloaded then return end; InputLabel.TextTransparency=InputObj.Disabled and 0.8 or 0; Box.TextTransparency=InputObj.Disabled and 0.8 or 0; BoxStroke.Transparency=InputObj.Disabled and 0.8 or 0 end
        function InputObj:SetDisabled(Disabled) InputObj.Disabled=Disabled; if InputObj.TooltipTable then InputObj.TooltipTable.Disabled=InputObj.Disabled end; Box.Active=not InputObj.Disabled; InputObj:UpdateColors() end
        function InputObj:SetVisible(Visible) InputObj.Visible=Visible; Holder.Visible=InputObj.Visible; Groupbox:Resize() end
        function InputObj:SetValue(Value) InputObj.Value=Value; Box.Text=Value end
        function InputObj:SetText(Text) InputObj.Text=Text; InputLabel.Text=Text end
        Box:GetPropertyChangedSignal("Text"):Connect(function()
            if InputObj.Disabled then return end
            local Text=Box.Text
            if InputObj.Numeric then local Num=tonumber(Text); if not Num then Box.Text=InputObj.Value; return end end
            InputObj.Value=Text
            if not InputObj.Finished then Library:SafeCallback(InputObj.Callback,Text); Library:SafeCallback(InputObj.Changed,Text) end
        end)
        Box.FocusLost:Connect(function(Enter)
            if not Enter then if InputObj.AllowEmpty then return end end
            local Value=Trim(Box.Text)
            if Value=="" and not InputObj.AllowEmpty then Value=InputObj.EmptyReset end
            InputObj.Value=Value; Box.Text=Value
            Library:SafeCallback(InputObj.Callback,Value); Library:SafeCallback(InputObj.Changed,Value)
        end)
        if typeof(InputObj.Tooltip)=="string" or typeof(InputObj.DisabledTooltip)=="string" then InputObj.TooltipTable=Library:AddTooltip(InputObj.Tooltip,InputObj.DisabledTooltip,Box); InputObj.TooltipTable.Disabled=InputObj.Disabled end
        InputObj:UpdateColors(); Groupbox:Resize(); InputObj.Holder=Holder; table.insert(Groupbox.Elements,InputObj); InputObj.Default=InputObj.Value; Options[Idx]=InputObj
        return InputObj
    end

    -- ── AddSlider ──────────────────────────────────
    function Funcs:AddSlider(Idx, Info)
        Info=Library:Validate(Info,Templates.Slider)
        local Groupbox=self; local Container=Groupbox.Container
        local Slider={ Text=Info.Text, Value=tonumber(Info.Default) or 0, Min=Info.Min, Max=Info.Max, Rounding=Info.Rounding, Prefix=Info.Prefix, Suffix=Info.Suffix, Callback=Info.Callback, Changed=Info.Changed, Disabled=Info.Disabled, Visible=Info.Visible, Tooltip=Info.Tooltip, DisabledTooltip=Info.DisabledTooltip, TooltipTable=nil, Type="Slider" }
        local Holder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,Info.Compact and 18 or 36), Visible=Slider.Visible, Parent=Container })
        local SliderLabel
        if not Info.Compact then
            SliderLabel=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,16), Text=Slider.Text, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=VX.TextDim, Parent=Holder })
        end
        local Bar=New("TextButton", {
            Active=not Slider.Disabled, AnchorPoint=Vector2.new(0,1),
            BackgroundColor3=VX.SurfaceTop, Position=UDim2.fromScale(0,1), Size=UDim2.new(1,0,0,16),
            Text="", Parent=Holder,
        })
        New("UICorner", { CornerRadius=UDim.new(1,0), Parent=Bar })
        New("UIStroke", { Color=VX.Border, Thickness=1, Parent=Bar })
        local DisplayLabel=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Text="", TextSize=13, ZIndex=2, TextColor3=VX.Text, Parent=Bar })
        local Fill=New("Frame", { BackgroundColor3=Library.Scheme.AccentColor, Size=UDim2.fromScale(0.5,1), Parent=Bar })
        New("UICorner", { CornerRadius=UDim.new(1,0), Parent=Fill })
        -- Gradient fill
        local fillGrad=Instance.new("UIGradient",Fill); fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(1,Library.Scheme.AccentColor)})
        -- Knob
        local Knob=New("Frame", { AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(10,10), ZIndex=3, Parent=Bar })
        New("UICorner", { CornerRadius=UDim.new(1,0), Parent=Knob })
        local KnobGlow=New("UIStroke", { Color=Library.Scheme.AccentColor, Thickness=2, Transparency=0.5, Parent=Knob })
        function Slider:UpdateColors()
            if Library.Unloaded then return end
            if SliderLabel then SliderLabel.TextTransparency=Slider.Disabled and 0.8 or 0 end
            DisplayLabel.TextTransparency=Slider.Disabled and 0.8 or 0
            Fill.BackgroundColor3=Slider.Disabled and VX.Border or Library.Scheme.AccentColor
            Knob.Visible=not Slider.Disabled
        end
        function Slider:Display()
            if Library.Unloaded then return end
            local CustomDisplayText=nil; if Info.FormatDisplayValue then CustomDisplayText=Info.FormatDisplayValue(Slider,Slider.Value) end
            if CustomDisplayText then DisplayLabel.Text=tostring(CustomDisplayText)
            elseif Info.Compact then DisplayLabel.Text=string.format("%s: %s%s%s",Slider.Text,Slider.Prefix,Slider.Value,Slider.Suffix)
            elseif Info.HideMax then DisplayLabel.Text=string.format("%s%s%s",Slider.Prefix,Slider.Value,Slider.Suffix)
            else DisplayLabel.Text=string.format("%s%s%s/%s%s%s",Slider.Prefix,Slider.Value,Slider.Suffix,Slider.Prefix,Slider.Max,Slider.Suffix) end
            local X=(Slider.Value-Slider.Min)/(Slider.Max-Slider.Min)
            TweenService:Create(Fill,Library.TweenInfo,{Size=UDim2.fromScale(X,1)}):Play()
            TweenService:Create(Knob,Library.TweenInfo,{Position=UDim2.fromScale(X,0.5)}):Play()
        end
        function Slider:OnChanged(Func) Slider.Changed=Func end
        function Slider:SetMax(Value) assert(Value>Slider.Min,"Max value cannot be less than current min."); Slider:SetValue(math.clamp(Slider.Value,Slider.Min,Value)); Slider.Max=Value; Slider:Display() end
        function Slider:SetMin(Value) assert(Value<Slider.Max,"Min value cannot be greater than current max."); Slider:SetValue(math.clamp(Slider.Value,Value,Slider.Max)); Slider.Min=Value; Slider:Display() end
        function Slider:SetValue(Str)
            if Slider.Disabled then return end; local Num=tonumber(Str); if not Num or Num==Slider.Value then return end
            Num=math.clamp(Num,Slider.Min,Slider.Max); Slider.Value=Num; Slider:Display()
            Library:SafeCallback(Slider.Callback,Slider.Value); Library:SafeCallback(Slider.Changed,Slider.Value)
        end
        function Slider:SetDisabled(Disabled) Slider.Disabled=Disabled; if Slider.TooltipTable then Slider.TooltipTable.Disabled=Slider.Disabled end; Bar.Active=not Slider.Disabled; Slider:UpdateColors() end
        function Slider:SetVisible(Visible) Slider.Visible=Visible; Holder.Visible=Slider.Visible; Groupbox:Resize() end
        function Slider:SetText(Text) Slider.Text=Text; if SliderLabel then SliderLabel.Text=Text; return end; Slider:Display() end
        function Slider:SetPrefix(Prefix) Slider.Prefix=Prefix; Slider:Display() end
        function Slider:SetSuffix(Suffix) Slider.Suffix=Suffix; Slider:Display() end
        Bar.InputBegan:Connect(function(Input)
            if not IsClickInput(Input) or Slider.Disabled then return end
            TweenService:Create(KnobGlow,Library.TweenInfo,{Transparency=0}):Play()
            for _,Side in Library.ActiveTab.Sides do Side.ScrollingEnabled=false end
            while IsDragInput(Input) do
                local Location=Mouse.X; local Scale=math.clamp((Location-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
                local OldValue=Slider.Value; Slider.Value=Round(Slider.Min+((Slider.Max-Slider.Min)*Scale),Slider.Rounding)
                Slider:Display(); if Slider.Value~=OldValue then Library:SafeCallback(Slider.Callback,Slider.Value); Library:SafeCallback(Slider.Changed,Slider.Value) end
                RunService.RenderStepped:Wait()
            end
            TweenService:Create(KnobGlow,Library.TweenInfo,{Transparency=0.5}):Play()
            for _,Side in Library.ActiveTab.Sides do Side.ScrollingEnabled=true end
        end)
        if typeof(Slider.Tooltip)=="string" or typeof(Slider.DisabledTooltip)=="string" then Slider.TooltipTable=Library:AddTooltip(Slider.Tooltip,Slider.DisabledTooltip,Bar); Slider.TooltipTable.Disabled=Slider.Disabled end
        Slider:UpdateColors(); Slider:Display(); Groupbox:Resize(); Slider.Holder=Holder; table.insert(Groupbox.Elements,Slider); Slider.Default=Slider.Value; Options[Idx]=Slider
        return Slider
    end

    -- ── AddDropdown ────────────────────────────────
    function Funcs:AddDropdown(Idx, Info)
        Info=Library:Validate(Info,Templates.Dropdown)
        local Groupbox=self; local Container=Groupbox.Container
        if Info.SpecialType=="Player" then Info.Values=GetPlayers(Info.ExcludeLocalPlayer); Info.AllowNull=true
        elseif Info.SpecialType=="Team" then Info.Values=GetTeams(); Info.AllowNull=true end
        local Dropdown={ Text=Info.Text or Idx, Values=Info.Values, DisabledValues=Info.DisabledValues or {}, Value=Info.Multi and {} or nil, Multi=Info.Multi, MaxVisibleDropdownItems=Info.MaxVisibleDropdownItems, AllowNull=Info.AllowNull, Callback=Info.Callback, Changed=Info.Changed, Disabled=Info.Disabled, Visible=Info.Visible, Tooltip=Info.Tooltip, DisabledTooltip=Info.DisabledTooltip, TooltipTable=nil, Type="Dropdown", SpecialType=Info.SpecialType, ExcludeLocalPlayer=Info.ExcludeLocalPlayer }
        local Holder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,42), Visible=Dropdown.Visible, Parent=Container })
        local DropLabel=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,18), Text=Dropdown.Text, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=VX.TextDim, Parent=Holder })
        local DropButton=New("TextButton", {
            AnchorPoint=Vector2.new(0,1), BackgroundColor3=VX.SurfaceTop,
            Position=UDim2.fromScale(0,1), Size=UDim2.new(1,0,0,22),
            Text="", Parent=Holder,
        })
        New("UICorner", { CornerRadius=UDim.new(0,7), Parent=DropButton })
        local DropStroke=New("UIStroke", { Color=VX.Border, Thickness=1, Parent=DropButton })
        local DropValueLabel=New("TextLabel", { BackgroundTransparency=1, Position=UDim2.fromOffset(8,0), Size=UDim2.new(1,-30,1,0), Text=Dropdown.Multi and "None" or (Dropdown.Value or "None"), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=VX.Text, Parent=DropButton })
        -- Arrow icon
        local ArrowLabel=New("TextLabel", { AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1, Position=UDim2.new(1,-8,0.5,0), Size=UDim2.fromOffset(14,14), Text="▾", TextSize=14, TextColor3=VX.AccentGlow, Parent=DropButton })

        -- Dropdown menu
        local ItemHeight=24; local MaxVisible=math.min(#Dropdown.Values,Dropdown.MaxVisibleDropdownItems)
        local MenuSize=UDim2.fromOffset(0, MaxVisible*ItemHeight+8)
        local MenuTable=Library:AddContextMenu(DropButton, function() return UDim2.fromOffset(DropButton.AbsoluteSize.X, math.min(#Dropdown.Values,Dropdown.MaxVisibleDropdownItems)*ItemHeight+8) end, function() return {0,DropButton.AbsoluteSize.Y+2} end, 2, function(Active) TweenService:Create(ArrowLabel,Library.TweenInfo,{Rotation=Active and 180 or 0}):Play(); TweenService:Create(DropStroke,Library.TweenInfo,{Color=Active and Library.Scheme.AccentColor or VX.Border}):Play() end)
        Dropdown.Menu=MenuTable
        local ItemButtons={}

        function Dropdown:RecalculateListSize()
            MenuTable:SetSize(function() return UDim2.fromOffset(DropButton.AbsoluteSize.X, math.min(#Dropdown.Values,Dropdown.MaxVisibleDropdownItems)*ItemHeight+8) end)
        end

        local function UpdateDisplay()
            if Dropdown.Multi then
                local keys={}; for k,_ in Dropdown.Value do table.insert(keys,k) end
                DropValueLabel.Text=#keys==0 and "None" or table.concat(keys,", ")
            else DropValueLabel.Text=Dropdown.Value or "None" end
        end

        local function CreateItemButton(Value)
            local IsDisabled=table.find(Dropdown.DisabledValues,Value)~=nil
            local IsSelected=Dropdown.Multi and Dropdown.Value[Value] or Dropdown.Value==Value
            local Item=New("TextButton", {
                BackgroundColor3=IsSelected and VX.SurfaceTop or VX.SurfaceUp,
                BackgroundTransparency=IsSelected and 0 or 1,
                Size=UDim2.new(1,0,0,ItemHeight), Text="", Parent=MenuTable.Menu,
            })
            local Label2=New("TextLabel", { BackgroundTransparency=1, Position=UDim2.fromOffset(10,0), Size=UDim2.new(1,-30,1,0), Text=tostring(Value), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=IsSelected and VX.AccentGlow or (IsDisabled and VX.TextFaint or VX.Text), Parent=Item })
            if IsSelected then
                local checkMark=New("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),Size=UDim2.fromOffset(14,14),Text="✓",TextSize=13,TextColor3=VX.AccentGlow,Parent=Item})
            end
            Item.MouseEnter:Connect(function() if IsDisabled then return end; TweenService:Create(Item,Library.TweenInfo,{BackgroundTransparency=0,BackgroundColor3=VX.SurfaceTop}):Play(); TweenService:Create(Label2,Library.TweenInfo,{TextColor3=VX.AccentGlow}):Play() end)
            Item.MouseLeave:Connect(function() if IsDisabled then return end; TweenService:Create(Item,Library.TweenInfo,{BackgroundTransparency=IsSelected and 0 or 1}):Play(); TweenService:Create(Label2,Library.TweenInfo,{TextColor3=IsSelected and VX.AccentGlow or VX.Text}):Play() end)
            Item.MouseButton1Click:Connect(function()
                if IsDisabled then return end
                if Dropdown.Multi then
                    if Dropdown.Value[Value] then Dropdown.Value[Value]=nil else Dropdown.Value[Value]=true end
                else Dropdown.Value=Dropdown.Value==Value and (Dropdown.AllowNull and nil or Dropdown.Value) or Value; MenuTable:Close() end
                UpdateDisplay(); Dropdown:Rebuild()
                Library:SafeCallback(Dropdown.Callback,Dropdown.Value); Library:SafeCallback(Dropdown.Changed,Dropdown.Value)
            end)
            return Item
        end

        function Dropdown:Rebuild()
            for _,v in ipairs(MenuTable.Menu:GetChildren()) do if v:IsA("GuiObject") and v.Name~="UIListLayout" and v.Name~="UIStroke" and v.Name~="UICorner" then v:Destroy() end end
            -- Re-add padding
            New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),Parent=MenuTable.Menu})
            for _,Value in ipairs(Dropdown.Values) do CreateItemButton(Value) end
            Dropdown:RecalculateListSize()
        end

        function Dropdown:SetValue(Value)
            if Dropdown.Multi then if typeof(Value)=="table" then Dropdown.Value=Value else Dropdown.Value[Value]=Dropdown.Value[Value] and nil or true end
            else Dropdown.Value=Value end
            UpdateDisplay(); Dropdown:Rebuild()
            Library:SafeCallback(Dropdown.Callback,Dropdown.Value); Library:SafeCallback(Dropdown.Changed,Dropdown.Value)
        end
        function Dropdown:SetValues(Values) Dropdown.Values=Values; if not Dropdown.Multi and Dropdown.Value and not table.find(Values,Dropdown.Value) then Dropdown.Value=nil end; UpdateDisplay(); if MenuTable.Active then Dropdown:Rebuild() end end
        function Dropdown:SetDisabled(Disabled) Dropdown.Disabled=Disabled; DropButton.Active=not Disabled; TweenService:Create(DropLabel,Library.TweenInfo,{TextTransparency=Disabled and 0.8 or 0}):Play(); TweenService:Create(DropValueLabel,Library.TweenInfo,{TextTransparency=Disabled and 0.8 or 0}):Play() end
        function Dropdown:SetVisible(Visible) Dropdown.Visible=Visible; Holder.Visible=Visible; Groupbox:Resize() end

        DropButton.MouseButton1Click:Connect(function() if Dropdown.Disabled then return end; Dropdown:Rebuild(); MenuTable:Toggle() end)
        if Info.Default and not Dropdown.Multi then Dropdown.Value=Info.Default
        elseif Dropdown.Multi and Info.Default then for _,v in Info.Default do Dropdown.Value[v]=true end end
        UpdateDisplay()
        if typeof(Dropdown.Tooltip)=="string" or typeof(Dropdown.DisabledTooltip)=="string" then Dropdown.TooltipTable=Library:AddTooltip(Dropdown.Tooltip,Dropdown.DisabledTooltip,DropButton); Dropdown.TooltipTable.Disabled=Dropdown.Disabled end
        Groupbox:Resize(); Dropdown.Holder=Holder; table.insert(Groupbox.Elements,Dropdown); Dropdown.Default=Dropdown.Value; Options[Idx]=Dropdown
        return Dropdown
    end

    -- ── AddDependencyBox ───────────────────────────
    function Funcs:AddDependencyBox()
        local Groupbox=self; local Container=Groupbox.Container
        local DepboxContainer=New("Frame",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Visible=false,Parent=Container})
        local DepboxList=New("UIListLayout",{Padding=UDim.new(0,8),Parent=DepboxContainer})
        local Depbox={Visible=false,Dependencies={},Holder=DepboxContainer,Container=DepboxContainer,Elements={},DependencyBoxes={}}
        function Depbox:Resize() DepboxContainer.Size=UDim2.new(1,0,0,DepboxList.AbsoluteContentSize.Y/Library.DPIScale); Groupbox:Resize() end
        function Depbox:Update(CancelSearch)
            for _,Dependency in Depbox.Dependencies do
                local Element=Dependency[1]; local Value=Dependency[2]
                if Element.Type=="Toggle" and Element.Value~=Value then DepboxContainer.Visible=false; Depbox.Visible=false; return
                elseif Element.Type=="Dropdown" then
                    if typeof(Element.Value)=="table" then if not Element.Value[Value] then DepboxContainer.Visible=false; Depbox.Visible=false; return end
                    else if Element.Value~=Value then DepboxContainer.Visible=false; Depbox.Visible=false; return end end
                end
            end
            Depbox.Visible=true; DepboxContainer.Visible=true
            if not Library.Searching then task.defer(function() Depbox:Resize() end)
            elseif not CancelSearch then Library:UpdateSearch(Library.SearchText) end
        end
        DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if not Depbox.Visible then return end; Depbox:Resize() end)
        function Depbox:SetupDependencies(Dependencies) for _,D in Dependencies do assert(typeof(D)=="table","Dependency should be a table."); assert(D[1]~=nil,"Missing element."); assert(D[2]~=nil,"Missing expected value.") end; Depbox.Dependencies=Dependencies; Depbox:Update() end
        DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function() Depbox:Resize() end)
        setmetatable(Depbox,BaseGroupbox); table.insert(Groupbox.DependencyBoxes,Depbox); table.insert(Library.DependencyBoxes,Depbox)
        return Depbox
    end

    -- ── AddDependencyGroupbox ──────────────────────
    function Funcs:AddDependencyGroupbox()
        local Groupbox=self; local Tab=Groupbox.Tab; local BoxHolder=Groupbox.BoxHolder
        local DepGroupboxContainer=New("Frame",{BackgroundColor3=VX.Surface,Size=UDim2.fromScale(1,0),Visible=false,Parent=BoxHolder})
        New("UICorner",{CornerRadius=UDim.new(0,12),Parent=DepGroupboxContainer})
        New("UIStroke",{Color=VX.Border,Thickness=1,Parent=DepGroupboxContainer})
        local DepGroupboxList=New("UIListLayout",{Padding=UDim.new(0,8),Parent=DepGroupboxContainer})
        New("UIPadding",{PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),Parent=DepGroupboxContainer})
        local DepGroupbox={Visible=false,Dependencies={},BoxHolder=BoxHolder,Holder=DepGroupboxContainer,Container=DepGroupboxContainer,Tab=Tab,Elements={},DependencyBoxes={}}
        function DepGroupbox:Resize() DepGroupboxContainer.Size=UDim2.new(1,0,0,(DepGroupboxList.AbsoluteContentSize.Y/Library.DPIScale)+20) end
        function DepGroupbox:Update(CancelSearch)
            for _,Dependency in DepGroupbox.Dependencies do
                local Element=Dependency[1]; local Value=Dependency[2]
                if Element.Type=="Toggle" and Element.Value~=Value then DepGroupboxContainer.Visible=false; DepGroupbox.Visible=false; return
                elseif Element.Type=="Dropdown" then
                    if typeof(Element.Value)=="table" then if not Element.Value[Value] then DepGroupboxContainer.Visible=false; DepGroupbox.Visible=false; return end
                    else if Element.Value~=Value then DepGroupboxContainer.Visible=false; DepGroupbox.Visible=false; return end end
                end
            end
            DepGroupbox.Visible=true
            if not Library.Searching then DepGroupboxContainer.Visible=true; DepGroupbox:Resize()
            elseif not CancelSearch then Library:UpdateSearch(Library.SearchText) end
        end
        function DepGroupbox:SetupDependencies(Dependencies) for _,D in Dependencies do assert(typeof(D)=="table"); assert(D[1]~=nil); assert(D[2]~=nil) end; DepGroupbox.Dependencies=Dependencies; DepGroupbox:Update() end
        setmetatable(DepGroupbox,BaseGroupbox); table.insert(Tab.DependencyGroupboxes,DepGroupbox); table.insert(Library.DependencyBoxes,DepGroupbox)
        return DepGroupbox
    end

    BaseGroupbox.__index=Funcs
    BaseGroupbox.__namecall=function(_,Key,...) return Funcs[Key](...) end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- CREATE WINDOW  (the big one)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function Library:CreateWindow(WindowInfo)
    WindowInfo=Library:Validate(WindowInfo,Templates.Window)
    local ViewportSize=workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X<=5 and ViewportSize.Y<=5 then repeat ViewportSize=workspace.CurrentCamera.ViewportSize; task.wait() until ViewportSize.X>5 and ViewportSize.Y>5 end
    local MaxX=ViewportSize.X-64; local MaxY=ViewportSize.Y-64
    Library.OriginalMinSize=Vector2.new(math.min(Library.OriginalMinSize.X,MaxX),math.min(Library.OriginalMinSize.Y,MaxY)); Library.MinSize=Library.OriginalMinSize
    WindowInfo.Size=UDim2.fromOffset(math.clamp(WindowInfo.Size.X.Offset,Library.MinSize.X,MaxX),math.clamp(WindowInfo.Size.Y.Offset,Library.MinSize.Y,MaxY))
    if typeof(WindowInfo.Font)=="EnumItem" then WindowInfo.Font=Font.fromEnum(WindowInfo.Font) end
    WindowInfo.CornerRadius=math.min(WindowInfo.CornerRadius,20)
    if WindowInfo.Compact~=nil then WindowInfo.SidebarCompacted=WindowInfo.Compact end
    if WindowInfo.SidebarMinWidth~=nil then WindowInfo.MinSidebarWidth=WindowInfo.SidebarMinWidth end
    WindowInfo.MinSidebarWidth=math.max(64,WindowInfo.MinSidebarWidth); WindowInfo.SidebarCompactWidth=math.max(48,WindowInfo.SidebarCompactWidth); WindowInfo.SidebarCollapseThreshold=math.clamp(WindowInfo.SidebarCollapseThreshold,0.1,0.9); WindowInfo.CompactWidthActivation=math.max(48,WindowInfo.CompactWidthActivation)
    Library.CornerRadius=WindowInfo.CornerRadius; Library:SetNotifySide(WindowInfo.NotifySide); Library.ShowCustomCursor=WindowInfo.ShowCustomCursor; Library.Scheme.Font=WindowInfo.Font; Library.ToggleKeybind=WindowInfo.ToggleKeybind; Library.GlobalSearch=WindowInfo.GlobalSearch
    local IsDefaultSearchbarSize=WindowInfo.SearchbarSize==UDim2.fromScale(1,1)
    local MainFrame,DividerLine,TitleHolder,WindowTitle,WindowIcon,RightWrapper,SearchBox,CurrentTabInfo,CurrentTabLabel,CurrentTabDescription,ResizeButton,Tabs,Container
    local InitialLeftWidth=math.ceil(WindowInfo.Size.X.Offset*0.28)
    local IsCompact=WindowInfo.SidebarCompacted; local LastExpandedWidth=InitialLeftWidth

    do
        Library.KeybindFrame,Library.KeybindContainer=Library:AddDraggableMenu("Keybinds")
        Library.KeybindFrame.AnchorPoint=Vector2.new(0,0.5); Library.KeybindFrame.Position=UDim2.new(0,8,0.5,0); Library.KeybindFrame.Visible=false

        -- ── MAIN WINDOW FRAME ──────────────────────────
        MainFrame=New("TextButton", {
            BackgroundColor3=VX.Surface, Name="VoidexMain", Text="",
            Position=WindowInfo.Position, Size=WindowInfo.Size, Visible=false, Parent=ScreenGui,
        })
        New("UICorner", { CornerRadius=UDim.new(0,WindowInfo.CornerRadius), Parent=MainFrame })
        table.insert(Library.Scales, New("UIScale", { Parent=MainFrame }))
        -- Premium border: glowing accent stroke
        local MainStroke=Instance.new("UIStroke"); MainStroke.Color=Library.Scheme.AccentColor; MainStroke.Thickness=1; MainStroke.Transparency=0.5; MainStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; MainStroke.Parent=MainFrame
        local ShadowStroke=Instance.new("UIStroke"); ShadowStroke.Color=Color3.new(0,0,0); ShadowStroke.Thickness=2; ShadowStroke.Transparency=0.5; ShadowStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; ShadowStroke.Parent=MainFrame

        -- Subtle background gradient
        local mainGrad=Instance.new("UIGradient",MainFrame); mainGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(8,5,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(4,2,12))}); mainGrad.Rotation=135

        -- Animated top glow bar
        local GlowBar=New("Frame", { BackgroundColor3=Library.Scheme.AccentColor, Size=UDim2.new(1,0,0,2), ZIndex=5, Parent=MainFrame })
        New("UICorner", { CornerRadius=UDim.new(0,WindowInfo.CornerRadius), Parent=GlowBar })
        local gbGrad=Instance.new("UIGradient",GlowBar); gbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(0.5,VX.Pink),ColorSequenceKeypoint.new(1,VX.AccentGlow)})
        -- Animate the gradient rotation
        local glowT=tick()
        Library:GiveSignal(RunService.Heartbeat:Connect(function()
            if not GlowBar.Parent then return end
            gbGrad.Rotation=(tick()-glowT)*30%360
        end))

        -- Separator line under topbar
        local TopSep=New("Frame", { BackgroundColor3=Library.Scheme.OutlineColor, Position=UDim2.fromOffset(0,52), Size=UDim2.new(1,0,0,1), Parent=MainFrame })
        local tGrad=Instance.new("UIGradient",TopSep); tGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Library.Scheme.AccentColor),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}); tGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,1)})

        -- Center window
        if WindowInfo.Center then MainFrame.Position=UDim2.new(0.5,-MainFrame.Size.X.Offset/2,0.5,-MainFrame.Size.Y.Offset/2) end

        -- ── TOP BAR ────────────────────────────────────
        local TopBar=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,52), Parent=MainFrame })
        Library:MakeDraggable(MainFrame,TopBar,false,true)

        -- Title section (left of topbar)
        TitleHolder=New("Frame", { BackgroundTransparency=1, Size=UDim2.new(0,InitialLeftWidth,1,0), Parent=TopBar })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,8), Parent=TitleHolder })

        if WindowInfo.Icon then
            WindowIcon=New("ImageLabel", { Image=tonumber(WindowInfo.Icon) and string.format("rbxassetid://%d",WindowInfo.Icon) or WindowInfo.Icon, Size=WindowInfo.IconSize, Parent=TitleHolder })
        else
            WindowIcon=New("TextLabel", { BackgroundTransparency=1, Size=WindowInfo.IconSize, Text=WindowInfo.Title:sub(1,1), TextScaled=true, Visible=false, TextColor3=VX.AccentGlow, Parent=TitleHolder })
        end
        local X=Library:GetTextBounds(WindowInfo.Title,Library.Scheme.Font,18,TitleHolder.AbsoluteSize.X-(WindowInfo.Icon and WindowInfo.IconSize.X.Offset+8 or 0)-12)
        WindowTitle=New("TextLabel", { BackgroundTransparency=1, Size=UDim2.new(0,X,1,0), Text=WindowInfo.Title, TextSize=18, TextColor3=VX.AccentGlow, Parent=TitleHolder })
        -- Gradient on title text
        local titleGrad2=Instance.new("UIGradient",WindowTitle); titleGrad2.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(0.5,VX.Pink),ColorSequenceKeypoint.new(1,VX.AccentGlow)})
        local titleT=tick()
        Library:GiveSignal(RunService.Heartbeat:Connect(function()
            if not WindowTitle.Parent then return end
            titleGrad2.Rotation = (tick()-titleT)*20%360
        end))

        -- Vertical divider (sidebar | content)
        DividerLine=New("Frame", { BackgroundColor3=VX.Border, Position=UDim2.fromOffset(InitialLeftWidth,0), Size=UDim2.new(0,1,1,-24), Parent=MainFrame })
        local dvGrad=Instance.new("UIGradient",DividerLine); dvGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Library.Scheme.AccentColor),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}); dvGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.15,0),NumberSequenceKeypoint.new(0.85,0),NumberSequenceKeypoint.new(1,1)}); dvGrad.Rotation=90

        -- Right wrapper (search / tab info)
        RightWrapper=New("Frame", { AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1, Position=UDim2.new(1,-12,0.5,0), Size=UDim2.new(1,-InitialLeftWidth-20,1,-16), Parent=TopBar })
        New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Left, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,8), Parent=RightWrapper })

        CurrentTabInfo=New("Frame",{Size=UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.5,1),Visible=false,BackgroundTransparency=1,Parent=RightWrapper})
        New("UIFlexItem",{FlexMode=Enum.UIFlexMode.Grow,Parent=CurrentTabInfo})
        New("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Left,VerticalAlignment=Enum.VerticalAlignment.Center,Parent=CurrentTabInfo})
        New("UIPadding",{PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,4),Parent=CurrentTabInfo})
        CurrentTabLabel=New("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.AutomaticSize.Y,Text="",TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=VX.AccentGlow,Parent=CurrentTabInfo})
        CurrentTabDescription=New("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.AutomaticSize.Y,Text="",TextWrapped=true,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=0.4,TextColor3=VX.TextDim,Parent=CurrentTabInfo})

        -- Premium search box
        SearchBox=New("TextBox", {
            BackgroundColor3=VX.SurfaceTop, PlaceholderText="🔍  Search...", Size=WindowInfo.SearchbarSize,
            TextScaled=true, Visible=not (WindowInfo.DisableSearch or false),
            TextColor3=VX.Text, PlaceholderColor3=VX.TextFaint, Parent=RightWrapper,
        })
        New("UIFlexItem",{FlexMode=Enum.UIFlexMode.Shrink,Parent=SearchBox})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=SearchBox})
        New("UIPadding",{PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),PaddingTop=UDim.new(0,6),Parent=SearchBox})
        local searchStroke=New("UIStroke",{Color=VX.Border,Thickness=1,Parent=SearchBox})
        SearchBox.Focused:Connect(function() TweenService:Create(searchStroke,Library.TweenInfo,{Color=Library.Scheme.AccentColor}):Play() end)
        SearchBox.FocusLost:Connect(function() TweenService:Create(searchStroke,Library.TweenInfo,{Color=VX.Border}):Play() end)

        -- ── BOTTOM BAR ─────────────────────────────────
        local BottomBg=New("Frame", { AnchorPoint=Vector2.new(0,1), BackgroundColor3=VX.SurfaceTop, Position=UDim2.fromScale(0,1), Size=UDim2.new(1,0,0,24), Parent=MainFrame })
        New("UICorner",{CornerRadius=UDim.new(0,WindowInfo.CornerRadius),Parent=BottomBg})
        local botSep=New("Frame",{BackgroundColor3=VX.Border,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,1),Parent=BottomBg})
        local bGrad=Instance.new("UIGradient",botSep); bGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Library.Scheme.AccentColor),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}); bGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,1)})
        local BottomBar=New("Frame",{AnchorPoint=Vector2.new(0,1),BackgroundTransparency=1,Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,0,24),Parent=MainFrame})
        New("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text=WindowInfo.Footer,TextSize=12,TextTransparency=0.5,TextColor3=VX.TextDim,Parent=BottomBar})
        -- Resize handle
        if WindowInfo.Resizable then
            ResizeButton=New("TextButton",{AnchorPoint=Vector2.new(1,0),BackgroundTransparency=1,Position=UDim2.new(1,-WindowInfo.CornerRadius/4,0,0),Size=UDim2.fromScale(1,1),SizeConstraint=Enum.SizeConstraint.RelativeYY,Text="",Parent=BottomBar})
            Library:MakeResizable(MainFrame,ResizeButton,function() for _,Tab in Library.Tabs do if Tab.Resize then Tab:Resize(true) end end end)
            New("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1,1),Text="⊿",TextSize=12,TextColor3=VX.TextFaint,Parent=ResizeButton})
        end

        -- ── SIDEBAR TABS ───────────────────────────────
        Tabs=New("ScrollingFrame", { AutomaticCanvasSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, CanvasSize=UDim2.fromScale(0,0), Position=UDim2.fromOffset(0,53), ScrollBarThickness=0, Size=UDim2.new(0,InitialLeftWidth,1,-77), Parent=MainFrame })
        New("UIListLayout",{Padding=UDim.new(0,2),Parent=Tabs})
        New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),Parent=Tabs})

        -- ── CONTENT AREA ───────────────────────────────
        Container=New("Frame",{ AnchorPoint=Vector2.new(1,0), BackgroundTransparency=1, Name="Container", Position=UDim2.new(1,0,0,53), Size=UDim2.new(1,-InitialLeftWidth-1,1,-77), Parent=MainFrame })
        New("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),Parent=Container})
    end

    -- ── WINDOW TABLE ───────────────────────────────
    local Window={}

    function Window:ChangeTitle(title) assert(typeof(title)=="string"); WindowTitle.Text=title; WindowInfo.Title=title end
    function Window:SetFooter(footer) assert(typeof(footer)=="string"); WindowInfo.Footer=footer end

    local function ApplyCompact()
        IsCompact=Window:GetSidebarWidth()==WindowInfo.SidebarCompactWidth
        if WindowInfo.DisableCompactingSnap then IsCompact=Window:GetSidebarWidth()<=WindowInfo.CompactWidthActivation end
        WindowTitle.Visible=not IsCompact
        if not WindowInfo.Icon then WindowIcon.Visible=IsCompact end
        for _, Button in Library.TabButtons do
            if not Button.Icon then continue end
            Button.Label.Visible=not IsCompact
            Button.Padding.PaddingBottom=UDim.new(0,IsCompact and 6 or 10)
            Button.Padding.PaddingLeft=UDim.new(0,IsCompact and 6 or 12)
            Button.Padding.PaddingRight=UDim.new(0,IsCompact and 6 or 12)
            Button.Padding.PaddingTop=UDim.new(0,IsCompact and 6 or 10)
            Button.Icon.SizeConstraint=IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
        end
    end

    function Window:IsSidebarCompacted() return IsCompact end
    function Window:SetCompact(State) Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth) end
    function Window:GetSidebarWidth() return Tabs.Size.X.Offset end
    function Window:SetSidebarWidth(Width)
        Width=math.clamp(Width,48,MainFrame.Size.X.Offset-WindowInfo.MinContainerWidth-1)
        DividerLine.Position=UDim2.fromOffset(Width,0)
        TitleHolder.Size=UDim2.new(0,Width,1,0)
        RightWrapper.Size=UDim2.new(1,-Width-20,1,-16)
        Tabs.Size=UDim2.new(0,Width,1,-77)
        Container.Size=UDim2.new(1,-Width-1,1,-77)
        if WindowInfo.EnableCompacting then ApplyCompact() end
        if not IsCompact then LastExpandedWidth=Width end
    end
    function Window:ShowTabInfo(Name,Description) CurrentTabLabel.Text=Name; CurrentTabDescription.Text=Description; if IsDefaultSearchbarSize then SearchBox.Size=UDim2.fromScale(0.5,1) end; CurrentTabInfo.Visible=true end
    function Window:HideTabInfo() CurrentTabInfo.Visible=false; if IsDefaultSearchbarSize then SearchBox.Size=UDim2.fromScale(1,1) end end

    -- ── ADD TAB ─────────────────────────────────────
    function Window:AddTab(...)
        local Name,Icon,Description
        if select("#",...)== 1 and typeof(...)=="table" then local Info=select(1,...); Name=Info.Name or "Tab"; Icon=Info.Icon; Description=Info.Description
        else Name=select(1,...); Icon=select(2,...); Description=select(3,...) end
        Icon=Library:GetCustomIcon(Icon)

        local TabButton,TabLabel,TabIcon,TabContainer,TabLeft,TabRight
        do
            -- Premium tab button
            TabButton=New("TextButton",{BackgroundColor3=VX.SurfaceTop,BackgroundTransparency=1,Size=UDim2.new(1,0,0,38),Text="",Parent=Tabs})
            New("UICorner",{CornerRadius=UDim.new(0,8),Parent=TabButton})
            local ButtonPadding=New("UIPadding",{PaddingBottom=UDim.new(0,IsCompact and 6 or 10),PaddingLeft=UDim.new(0,IsCompact and 6 or 12),PaddingRight=UDim.new(0,IsCompact and 6 or 12),PaddingTop=UDim.new(0,IsCompact and 6 or 10),Parent=TabButton})
            -- Active indicator line (left side)
            local ActiveBar=New("Frame",{AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Library.Scheme.AccentColor,Position=UDim2.fromOffset(0,0.5),Size=UDim2.new(0,3,0.7,0),Visible=false,ZIndex=TabButton.ZIndex+1,Parent=TabButton})
            New("UICorner",{CornerRadius=UDim.new(1,0),Parent=ActiveBar})

            TabLabel=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(Icon and 26 or 0,0),Size=UDim2.new(1,Icon and -26 or 0,1,0),Text=Name,TextSize=15,TextTransparency=0.5,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=VX.Text,Visible=not IsCompact,Parent=TabButton})
            if Icon then
                TabIcon=New("ImageLabel",{Image=Icon.Url,ImageColor3=Icon.Custom and "WhiteColor" or "AccentColor",ImageRectOffset=Icon.ImageRectOffset,ImageRectSize=Icon.ImageRectSize,ImageTransparency=0.5,ScaleType=Enum.ScaleType.Fit,Size=UDim2.fromScale(1,1),SizeConstraint=IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,Parent=TabButton})
            end
            table.insert(Library.TabButtons,{Label=TabLabel,Padding=ButtonPadding,Icon=TabIcon,ActiveBar=ActiveBar})

            -- Hover glow
            TabButton.MouseEnter:Connect(function()
                TweenService:Create(TabButton,Library.TweenInfo,{BackgroundTransparency=0,BackgroundColor3=VX.SurfaceTop}):Play()
                TweenService:Create(TabLabel,Library.TweenInfo,{TextTransparency=0.2}):Play()
            end)
            TabButton.MouseLeave:Connect(function()
                if Library.ActiveTab and Library.ActiveTab.Button==TabButton then return end
                TweenService:Create(TabButton,Library.TweenInfo,{BackgroundTransparency=1}):Play()
                TweenService:Create(TabLabel,Library.TweenInfo,{TextTransparency=0.5}):Play()
            end)

            -- Content area for this tab
            TabContainer=New("Frame",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Visible=false,Parent=Container})
            TabLeft=New("ScrollingFrame",{AutomaticCanvasSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,CanvasSize=UDim2.fromScale(0,0),ScrollBarImageTransparency=1,ScrollBarThickness=0,Size=UDim2.new(0.5,-4,1,0),Parent=TabContainer})
            New("UIListLayout",{Padding=UDim.new(0,4),Parent=TabLeft})
            New("UIPadding",{PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,2),PaddingTop=UDim.new(0,4),Parent=TabLeft})
            New("Frame",{BackgroundTransparency=1,LayoutOrder=-1,Parent=TabLeft})
            New("Frame",{BackgroundTransparency=1,LayoutOrder=1,Parent=TabLeft})
            TabRight=New("ScrollingFrame",{AnchorPoint=Vector2.new(1,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,CanvasSize=UDim2.fromScale(0,0),Position=UDim2.fromScale(1,0),ScrollBarImageTransparency=1,ScrollBarThickness=0,Size=UDim2.new(0.5,-4,1,0),Parent=TabContainer})
            New("UIListLayout",{Padding=UDim.new(0,4),Parent=TabRight})
            New("UIPadding",{PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,4),Parent=TabRight})
            New("Frame",{BackgroundTransparency=1,LayoutOrder=-1,Parent=TabRight})
            New("Frame",{BackgroundTransparency=1,LayoutOrder=1,Parent=TabRight})
        end

        local Tab={Groupboxes={},Tabboxes={},DependencyGroupboxes={},Sides={TabLeft,TabRight},Button=TabButton}

        function Tab:RefreshSides() for _,Side in Tab.Sides do Side.Position=UDim2.new(Side.Position.X.Scale,0,0,0); Side.Size=UDim2.new(0.5,-4,1,0) end end
        function Tab:Resize() Tab:RefreshSides() end

        function Tab:Show()
            if Library.ActiveTab then
                Library.ActiveTab.Button.BackgroundTransparency=1
                TweenService:Create(Library.ActiveTab.Button,Library.TweenInfo,{BackgroundTransparency=1}):Play()
                -- Find and hide active bar
                for _, bInfo in Library.TabButtons do if bInfo.ActiveBar then bInfo.ActiveBar.Visible=false end end
                if Library.ActiveTab.TabContainer then Library.ActiveTab.TabContainer.Visible=false end
                Library.ActiveTab=nil
            end
            Library.ActiveTab=Tab; Tab.TabContainer=TabContainer; TabContainer.Visible=true
            TweenService:Create(TabButton,Library.TweenInfo,{BackgroundTransparency=0,BackgroundColor3=VX.SurfaceTop}):Play()
            TweenService:Create(TabLabel,Library.TweenInfo,{TextTransparency=0,TextColor3=VX.AccentGlow}):Play()
            if TabIcon then TweenService:Create(TabIcon,Library.TweenInfo,{ImageTransparency=0}):Play() end
            -- Activate the glow bar for this tab
            for _, bInfo in Library.TabButtons do if bInfo.ActiveBar then bInfo.ActiveBar.Visible=(bInfo.Label==TabLabel) end end
            if Description then Window:ShowTabInfo(Name,Description) else Window:HideTabInfo() end
            Library.Tabs[Name]=Tab
        end

        TabButton.MouseButton1Click:Connect(function() Tab:Show() end)

        function Tab:AddGroupbox(Info)
            local BoxHolder=New("Frame",{AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Size=UDim2.fromScale(1,0),Parent=Info.Side==1 and TabLeft or TabRight})
            New("UIListLayout",{Padding=UDim.new(0,6),Parent=BoxHolder})
            New("UIPadding",{PaddingBottom=UDim.new(0,4),PaddingTop=UDim.new(0,4),Parent=BoxHolder})

            -- VOIDEX Premium Groupbox
            local GroupboxHolder=New("Frame",{BackgroundColor3=VX.SurfaceUp,Size=UDim2.fromScale(1,0),Parent=BoxHolder})
            New("UICorner",{CornerRadius=UDim.new(0,12),Parent=GroupboxHolder})
            -- Glowing border
            local gbStroke=New("UIStroke",{Color=VX.Border,Thickness=1,Parent=GroupboxHolder})
            -- Accent top strip
            local gbTopStrip=New("Frame",{BackgroundColor3=Library.Scheme.AccentColor,Size=UDim2.new(1,0,0,2),ZIndex=GroupboxHolder.ZIndex+1,Parent=GroupboxHolder})
            New("UICorner",{CornerRadius=UDim.new(0,12),Parent=gbTopStrip})
            local gbGrad2=Instance.new("UIGradient",gbTopStrip); gbGrad2.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(0.5,VX.Pink),ColorSequenceKeypoint.new(1,VX.AccentGlow)})
            -- Bottom half cover for top strip (so it doesn't show on bottom corners)
            local gbCover=New("Frame",{BackgroundColor3=VX.SurfaceUp,Position=UDim2.fromOffset(0,1),Size=UDim2.new(1,0,0,12),ZIndex=GroupboxHolder.ZIndex,Parent=GroupboxHolder})

            -- Icon
            local BoxIcon=Library:GetCustomIcon(Info.IconName)
            if BoxIcon then
                New("ImageLabel",{Image=BoxIcon.Url,ImageColor3=BoxIcon.Custom and Color3.new(1,1,1) or Library.Scheme.AccentColor,ImageRectOffset=BoxIcon.ImageRectOffset,ImageRectSize=BoxIcon.ImageRectSize,Position=UDim2.fromOffset(10,10),Size=UDim2.fromOffset(18,18),Parent=GroupboxHolder})
            end

            -- Groupbox label / header
            local GroupboxLabel=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(BoxIcon and 30 or 0,0),Size=UDim2.new(1,0,0,36),Text=Info.Name,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=VX.AccentGlow,Parent=GroupboxHolder})
            New("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),Parent=GroupboxLabel})
            -- Header underline
            local gbUnderline=New("Frame",{BackgroundColor3=VX.Border,Position=UDim2.fromOffset(0,36),Size=UDim2.new(1,0,0,1),Parent=GroupboxHolder})
            local gbUGrad=Instance.new("UIGradient",gbUnderline); gbUGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Library.Scheme.AccentColor),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}); gbUGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0),NumberSequenceKeypoint.new(0.7,0),NumberSequenceKeypoint.new(1,1)})

            -- Content container
            local GroupboxContainer=New("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,38),Size=UDim2.new(1,0,1,-38),Parent=GroupboxHolder})
            local GroupboxList=New("UIListLayout",{Padding=UDim.new(0,8),Parent=GroupboxContainer})
            New("UIPadding",{PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),Parent=GroupboxContainer})

            -- Hover glow effect on groupbox
            GroupboxHolder.MouseEnter:Connect(function()
                TweenService:Create(gbStroke,Library.TweenInfo,{Color=Library.Scheme.AccentColor,Transparency=0.5}):Play()
            end)
            GroupboxHolder.MouseLeave:Connect(function()
                TweenService:Create(gbStroke,Library.TweenInfo,{Color=VX.Border,Transparency=0}):Play()
            end)

            local Groupbox={BoxHolder=BoxHolder,Holder=GroupboxHolder,Container=GroupboxContainer,Tab=Tab,DependencyBoxes={},Elements={}}
            function Groupbox:Resize() GroupboxHolder.Size=UDim2.new(1,0,0,(GroupboxList.AbsoluteContentSize.Y/Library.DPIScale)+52) end
            setmetatable(Groupbox,BaseGroupbox); Groupbox:Resize(); Tab.Groupboxes[Info.Name]=Groupbox
            return Groupbox
        end

        function Tab:AddLeftGroupbox(Name, IconName) return Tab:AddGroupbox({Side=1,Name=Name,IconName=IconName}) end
        function Tab:AddRightGroupbox(Name, IconName) return Tab:AddGroupbox({Side=2,Name=Name,IconName=IconName}) end

        function Tab:AddTabbox(Info)
            local BoxHolder=New("Frame",{AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Size=UDim2.fromScale(1,0),Parent=Info.Side==1 and TabLeft or TabRight})
            New("UIListLayout",{Padding=UDim.new(0,6),Parent=BoxHolder})
            New("UIPadding",{PaddingBottom=UDim.new(0,4),PaddingTop=UDim.new(0,4),Parent=BoxHolder})

            local TabboxHolder=New("Frame",{BackgroundColor3=VX.SurfaceUp,Size=UDim2.fromScale(1,0),Parent=BoxHolder})
            New("UICorner",{CornerRadius=UDim.new(0,12),Parent=TabboxHolder})
            New("UIStroke",{Color=VX.Border,Thickness=1,Parent=TabboxHolder})

            local TabboxButtons=New("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,36),Parent=TabboxHolder})
            New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalFlex=Enum.UIFlexAlignment.Fill,Parent=TabboxButtons})
            New("UIPadding",{PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),Parent=TabboxButtons})
            local TabboxButtonsUnderline=New("Frame",{BackgroundColor3=VX.Border,Position=UDim2.fromOffset(0,36),Size=UDim2.new(1,0,0,1),Parent=TabboxHolder})

            local Tabbox={ActiveTab=nil,BoxHolder=BoxHolder,Holder=TabboxHolder,Tabs={}}
            function Tabbox:AddTab(Name2, IconName2)
                local BoxIcon2=Library:GetCustomIcon(IconName2)
                local Button=New("TextButton",{BackgroundColor3=VX.SurfaceTop,BackgroundTransparency=1,Size=UDim2.fromOffset(0,28),Text="",Parent=TabboxButtons})
                New("UICorner",{CornerRadius=UDim.new(0,7),Parent=Button})
                local ButtonContent=New("Frame",{AnchorPoint=Vector2.new(0.5,0.5),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(0,16),Parent=Button})
                New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,6),Parent=ButtonContent})
                local ButtonIcon2
                if BoxIcon2 then ButtonIcon2=New("ImageLabel",{Image=BoxIcon2.Url,ImageColor3=BoxIcon2.Custom and Color3.new(1,1,1) or Library.Scheme.AccentColor,ImageRectOffset=BoxIcon2.ImageRectOffset,ImageRectSize=BoxIcon2.ImageRectSize,ImageTransparency=0.5,Size=UDim2.fromOffset(14,14),Parent=ButtonContent}) end
                local ButtonLabel2=New("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Size=UDim2.fromOffset(0,14),Text=Name2,TextSize=13,TextTransparency=0.5,TextColor3=VX.Text,Parent=ButtonContent})
                local SubContainer=New("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,38),Size=UDim2.new(1,0,1,-38),Visible=false,Parent=TabboxHolder})
                local SubList=New("UIListLayout",{Padding=UDim.new(0,8),Parent=SubContainer})
                New("UIPadding",{PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),Parent=SubContainer})
                local SubTab={ButtonHolder=Button,Container=SubContainer,Tab=Tab,Elements={},DependencyBoxes={}}
                function SubTab:Show()
                    if Tabbox.ActiveTab then
                        TweenService:Create(Tabbox.ActiveTab.ButtonHolder,Library.TweenInfo,{BackgroundTransparency=1}):Play()
                        local ol=Tabbox.ActiveTab.ButtonHolder:FindFirstChild("ActiveLine"); if ol then ol:Destroy() end
                        Tabbox.ActiveTab.Container.Visible=false
                    end
                    Tabbox.ActiveTab=SubTab; SubContainer.Visible=true
                    TweenService:Create(Button,Library.TweenInfo,{BackgroundTransparency=0}):Play()
                    TweenService:Create(ButtonLabel2,Library.TweenInfo,{TextTransparency=0,TextColor3=VX.AccentGlow}):Play()
                    if ButtonIcon2 then TweenService:Create(ButtonIcon2,Library.TweenInfo,{ImageTransparency=0}):Play() end
                    -- Bottom indicator line
                    local line=Instance.new("Frame",Button); line.Name="ActiveLine"; line.BackgroundColor3=Library.Scheme.AccentColor; line.AnchorPoint=Vector2.new(0.5,1); line.Position=UDim2.fromScale(0.5,1); line.Size=UDim2.new(0.8,0,0,2); Instance.new("UICorner",line).CornerRadius=UDim.new(1,0); line.ZIndex=Button.ZIndex+1
                    local lg=Instance.new("UIGradient",line); lg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,VX.AccentGlow),ColorSequenceKeypoint.new(1,VX.Pink)})
                    Tabbox:Resize()
                end
                function SubTab:Hide() SubContainer.Visible=false; local ol=Button:FindFirstChild("ActiveLine"); if ol then ol:Destroy() end; TweenService:Create(Button,Library.TweenInfo,{BackgroundTransparency=1}):Play(); TweenService:Create(ButtonLabel2,Library.TweenInfo,{TextTransparency=0.5,TextColor3=VX.Text}):Play() end
                function SubTab:Resize() TabboxHolder.Size=UDim2.new(1,0,0,(SubList.AbsoluteContentSize.Y/Library.DPIScale)+52) end
                setmetatable(SubTab,BaseGroupbox)
                Button.MouseButton1Click:Connect(function() SubTab:Show() end)
                Button.MouseEnter:Connect(function() if Tabbox.ActiveTab==SubTab then return end; TweenService:Create(Button,Library.TweenInfo,{BackgroundTransparency=0,BackgroundColor3=VX.SurfaceTop}):Play() end)
                Button.MouseLeave:Connect(function() if Tabbox.ActiveTab==SubTab then return end; TweenService:Create(Button,Library.TweenInfo,{BackgroundTransparency=1}):Play() end)
                Tabbox.Tabs[Name2]=SubTab; if not Tabbox.ActiveTab then SubTab:Show() end
                return SubTab
            end
            function Tabbox:Resize()
                if Tabbox.ActiveTab then
                    local List=Tabbox.ActiveTab.Container:FindFirstChildOfClass("UIListLayout")
                    local ContentH=List and List.AbsoluteContentSize.Y/Library.DPIScale or 0
                    TabboxHolder.Size=UDim2.new(1,0,0,ContentH+52)
                end
            end
            function Tab:AddLeftTabbox() return Tab:AddTabbox({Side=1}) end
            function Tab:AddRightTabbox() return Tab:AddTabbox({Side=2}) end
            Tab.Tabboxes[#Tab.Tabboxes+1]=Tabbox
            return Tabbox
        end

        function Tab:AddLeftTabbox() return Tab:AddTabbox({Side=1}) end
        function Tab:AddRightTabbox() return Tab:AddTabbox({Side=2}) end

        Library.Tabs[Name]=Tab
        return Tab
    end

    -- ── TOGGLE (show/hide window) ───────────────────
    function Library:Toggle(Value)
        if typeof(Value)=="boolean" then Library.Toggled=Value
        else Library.Toggled=not Library.Toggled end
        -- Premium show/hide tween
        if Library.Toggled then
            MainFrame.Visible=true
            MainFrame.Size=UDim2.fromOffset(WindowInfo.Size.X.Offset*0.95,WindowInfo.Size.Y.Offset*0.95)
            TweenService:Create(MainFrame,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=WindowInfo.Size}):Play()
        else
            TweenService:Create(MainFrame,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.fromOffset(WindowInfo.Size.X.Offset*0.95,WindowInfo.Size.Y.Offset*0.95)}):Play()
            task.delay(0.15,function() if not Library.Toggled then MainFrame.Visible=false end end)
        end
        if WindowInfo.UnlockMouseWhileOpen then ModalElement.Modal=Library.Toggled end
        if Library.Toggled and not Library.IsMobile then
            local OldMouseIconEnabled=UserInputService.MouseIconEnabled
            pcall(function() RunService:UnbindFromRenderStep("ShowCursor") end)
            RunService:BindToRenderStep("ShowCursor",Enum.RenderPriority.Last.Value,function()
                UserInputService.MouseIconEnabled=not Library.ShowCustomCursor
                Cursor.Position=UDim2.fromOffset(Mouse.X,Mouse.Y)
                Cursor.Visible=Library.ShowCustomCursor
                if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then UserInputService.MouseIconEnabled=OldMouseIconEnabled; Cursor.Visible=false; RunService:UnbindFromRenderStep("ShowCursor") end
            end)
        elseif not Library.Toggled then
            TooltipLabel.Visible=false
            for _, Option in Library.Options do
                if Option.Type=="ColorPicker" then Option.ColorMenu:Close(); Option.ContextMenu:Close()
                elseif Option.Type=="Dropdown" or Option.Type=="KeyPicker" then Option.Menu:Close() end
            end
        end
    end

    -- Sidebar resize
    if WindowInfo.EnableSidebarResize then
        local Threshold=(WindowInfo.MinSidebarWidth+WindowInfo.SidebarCompactWidth)*WindowInfo.SidebarCollapseThreshold
        local StartPos,StartWidth; local Dragging=false; local Changed2
        local SidebarGrabber=New("TextButton",{AnchorPoint=Vector2.new(0.5,0),BackgroundTransparency=1,Position=UDim2.fromScale(0.5,0),Size=UDim2.new(0,8,1,0),Text="",Parent=DividerLine})
        SidebarGrabber.MouseEnter:Connect(function() TweenService:Create(DividerLine,Library.TweenInfo,{BackgroundColor3=Library:GetLighterColor(Library.Scheme.OutlineColor)}):Play() end)
        SidebarGrabber.MouseLeave:Connect(function() if Dragging then return end; TweenService:Create(DividerLine,Library.TweenInfo,{BackgroundColor3=Library.Scheme.OutlineColor}):Play() end)
        SidebarGrabber.InputBegan:Connect(function(Input)
            if not IsClickInput(Input) then return end; Library.CantDragForced=true; StartPos=Input.Position; StartWidth=Window:GetSidebarWidth(); Dragging=true
            Changed2=Input.Changed:Connect(function() if Input.UserInputState~=Enum.UserInputState.End then return end; Library.CantDragForced=false; TweenService:Create(DividerLine,Library.TweenInfo,{BackgroundColor3=Library.Scheme.OutlineColor}):Play(); Dragging=false; if Changed2 and Changed2.Connected then Changed2:Disconnect(); Changed2=nil end end)
        end)
        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input)
            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then Dragging=false; if Changed2 and Changed2.Connected then Changed2:Disconnect(); Changed2=nil end; return end
            if Dragging and IsHoverInput(Input) then
                local Delta=Input.Position-StartPos; local Width=StartWidth+Delta.X
                if WindowInfo.DisableCompactingSnap then Window:SetSidebarWidth(Width); return end
                if Width>Threshold then Window:SetSidebarWidth(math.max(Width,WindowInfo.MinSidebarWidth)) else Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth) end
            end
        end))
    end

    if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth) end
    if WindowInfo.AutoShow then task.spawn(Library.Toggle) end

    if Library.IsMobile then
        local ToggleButton=Library:AddDraggableButton("Toggle",function() Library:Toggle() end,true)
        local LockButton=Library:AddDraggableButton("Lock",function(self) Library.CantDragForced=not Library.CantDragForced; self:SetText(Library.CantDragForced and "Unlock" or "Lock") end,true)
        if WindowInfo.MobileButtonsSide=="Right" then ToggleButton.Button.Position=UDim2.new(1,-6,0,6); ToggleButton.Button.AnchorPoint=Vector2.new(1,0); LockButton.Button.Position=UDim2.new(1,-6,0,46); LockButton.Button.AnchorPoint=Vector2.new(1,0)
        else LockButton.Button.Position=UDim2.fromOffset(6,46) end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Library:UpdateSearch(SearchBox.Text) end)
    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
        if Library.Unloaded then return end
        if UserInputService:GetFocusedTextBox() then return end
        if (typeof(Library.ToggleKeybind)=="table" and Library.ToggleKeybind.Type=="KeyPicker" and Input.KeyCode.Name==Library.ToggleKeybind.Value) or Input.KeyCode==Library.ToggleKeybind then Library.Toggle() end
    end))
    Library:GiveSignal(UserInputService.WindowFocused:Connect(function() Library.IsRobloxFocused=true end))
    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function() Library.IsRobloxFocused=false end))

    return Window
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PLAYER / TEAM CHANGE HANDLERS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function OnPlayerChange()
    if Library.Unloaded then return end
    local PlayerList,ExcludedPlayerList=GetPlayers(),GetPlayers(true)
    for _, Dropdown in Options do
        if Dropdown.Type=="Dropdown" and Dropdown.SpecialType=="Player" then Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList) end
    end
end
local function OnTeamChange()
    if Library.Unloaded then return end
    local TeamList=GetTeams()
    for _, Dropdown in Options do if Dropdown.Type=="Dropdown" and Dropdown.SpecialType=="Team" then Dropdown:SetValues(TeamList) end end
end
Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))
Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- EXPORT
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
getgenv().Library = Library
return Library
