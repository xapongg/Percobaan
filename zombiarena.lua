--// Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--------------------------------------------------
--// AUTO ANTI AFK (BUILT-IN TEMPLATE)
--------------------------------------------------
local AntiAFK_Enabled = true
local IdleConn

if AntiAFK_Enabled then
    -- Method 1: Roblox Idle event
    IdleConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.2)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)

    -- Method 2: Backup key input tiap 60 detik
    task.spawn(function()
        while AntiAFK_Enabled do
            task.wait(60) -- aman (tidak terlalu cepat, tidak terlalu lama)

            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
            end)
        end
    end)
end

--// Wind UI
local Icons = loadstring(game:HttpGetAsync(
    "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
))()

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// Window
local Window = WindUI:CreateWindow({
    Title = "XapVerseHub - Zombie Arena | v0.0.0.1",
    Folder = "NamaGame",

	Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    IconSize = 28,
    SideBarWidth = 220,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },

    Topbar = {
        Height = 44,
        ButtonsType = "Mac", -- Default or Mac
    },
})


WindUI:Notify({
	Title = "Welcome",
	Content = "XapVerse Loaded",
	Icon = "rbxassetid://135878568033396",
	Duration = 5,
	CanClose = false,
})

-- Disable default open button
pcall(function()
    Window:EditOpenButton({ Enabled = false })
end)

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XapVerseHub_Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create Icon Button
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.fromOffset(55, 55)

-- Posisi kiri atas (dengan sedikit jarak dari edge)
ToggleButton.Position = UDim2.new(0, 20, 0, 50)

ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.BackgroundTransparency = 0
ToggleButton.Image = "rbxassetid://135878568033396"
ToggleButton.ImageColor3 = Color3.fromRGB(255,255,255)
ToggleButton.ZIndex = 999

-- Sudut rounded (tidak tajam tapi tidak bulat penuh)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) -- 12px rounded
UICorner.Parent = ToggleButton

-- Optional: Stroke biar clean
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Parent = ToggleButton

-- Drag Logic (PC + Mobile Support)
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        dragInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Toggle Window (menggunakan method resmi)
ToggleButton.MouseButton1Click:Connect(function()
    Window:Toggle() -- pakai method resmi
end)

-- Pastikan icon ilang saat window di-destroy
Window:OnDestroy(function()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

--// TAB MAIN
--// TAB MAIN
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.home
})

--------------------------------------------------
--// AUTO PRESS R
--------------------------------------------------
local AutoR = false
local RDelay = 17 -- default delay

-- Toggle
MainTab:Toggle({
    Title = "Auto Press R",
    Desc = "Otomatis pencet tombol R",
    Value = false,
    Callback = function(state)
        AutoR = state

        if state then
            task.spawn(function()
                while AutoR do
                    -- pencet R
                    VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                    task.wait(0.05)
                    VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)

                    -- fixed delay
                    task.wait(RDelay)
                end
            end)
        end
    end
})

-- Slider Delay
MainTab:Slider({
    Title = "Delay Auto R",
    Step = 1,
    Value = {
        Min = 17,
        Max = 20,
        Default = 17,
    },
    Callback = function(value)
        RDelay = value
    end
})


--------------------------------------------------
--// SAFE ZONE
--------------------------------------------------
local TpWall = false
local OldCFrame = nil
local SafePart = nil

MainTab:Toggle({
    Title = "Safe Zone",
    Desc = "Teleport ke spot aman",
    Value = false,
    Callback = function(state)
        TpWall = state

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return
        end

        if state then
            -- simpan posisi lama
            OldCFrame = HumanoidRootPart.CFrame

            -- buat part safe zone
            SafePart = Instance.new("Part")
            SafePart.Name = "SafeArenaPart"
            SafePart.Parent = workspace

            SafePart.Size = Vector3.new(300, 2, 300)
            SafePart.Position = Vector3.new(-239, 508, -359)

            SafePart.Anchored = true
            SafePart.CanCollide = true
            SafePart.Transparency = 1
            SafePart.Material = Enum.Material.SmoothPlastic
            SafePart.Color = Color3.fromRGB(163,162,165)

            -- teleport ke atas part
            HumanoidRootPart.CFrame = SafePart.CFrame + Vector3.new(0, 5, 0)

        else
            -- balik posisi
            if OldCFrame then
                HumanoidRootPart.CFrame = OldCFrame
            end

            -- hapus part biar gak berat
            if SafePart then
                SafePart:Destroy()
                SafePart = nil
            end
        end
    end
})


--------------------------------------------------
--// FARM SHARD TELEPORT
--------------------------------------------------
local FarmShard = false
local OldShardCFrame = nil
local FarmPart = nil

MainTab:Toggle({
    Title = "Farm Shard",
    Desc = "Teleport ke area farm shard",
    Value = false,
    Callback = function(state)
        FarmShard = state

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return
        end

        if state then
            -- simpan posisi sebelum teleport
            OldShardCFrame = HumanoidRootPart.CFrame

            -- buat platform
            FarmPart = Instance.new("Part")
            FarmPart.Name = "FastCleaner_Fox"
            FarmPart.Parent = workspace

            FarmPart.Size = Vector3.new(300, 1, 300)
            FarmPart.Position = Vector3.new(-5, -161, 15)

            FarmPart.Anchored = true
            FarmPart.CanCollide = true
            FarmPart.Transparency = 0.5
            FarmPart.Material = Enum.Material.SmoothPlastic
            FarmPart.Color = Color3.fromRGB(100,180,255)

            -- teleport player ke atas platform
            HumanoidRootPart.CFrame = CFrame.new(
                -5,
                -155,
                15
            )

        else
            -- balik ke posisi awal
            if OldShardCFrame then
                HumanoidRootPart.CFrame = OldShardCFrame
            end

            -- hapus platform biar gak berat
            if FarmPart then
                FarmPart:Destroy()
                FarmPart = nil
            end
        end
    end
})


--------------------------------------------------
--// FULL BRIGHT
--------------------------------------------------
local FullBright = false

local Lighting = game:GetService("Lighting")

-- simpan setting lama
local OldBrightness = Lighting.Brightness
local OldClockTime = Lighting.ClockTime
local OldFogEnd = Lighting.FogEnd
local OldGlobalShadows = Lighting.GlobalShadows
local OldAmbient = Lighting.Ambient

MainTab:Toggle({
    Title = "Full Bright",
    Desc = "Mencerahkan map",
    Value = false,
    Callback = function(state)
        FullBright = state

        if state then
            Lighting.Brightness = 3
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255,255,255)

            -- force fullbright terus aktif
            task.spawn(function()
                while FullBright do
                    Lighting.Brightness = 3
                    Lighting.ClockTime = 12
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                    Lighting.Ambient = Color3.fromRGB(255,255,255)

                    task.wait(1)
                end
            end)
        else
            -- balikin setting awal
            Lighting.Brightness = OldBrightness
            Lighting.ClockTime = OldClockTime
            Lighting.FogEnd = OldFogEnd
            Lighting.GlobalShadows = OldGlobalShadows
            Lighting.Ambient = OldAmbient
        end
    end
})


--------------------------------------------------
--// AUTO OPEN CRATE
--------------------------------------------------
local AutoCrate = false
local CrateDelay = 0.3 -- 300ms

MainTab:Toggle({
    Title = "Auto Open Crate",
    Desc = "Auto buka crate terus menerus",
    Value = false,
    Callback = function(state)
        AutoCrate = state

        if state then
            task.spawn(function()
                while AutoCrate do
                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("EventRemotes")
                            :WaitForChild("GalacticRequestSpin")
                            :InvokeServer()
                    end)

                    task.wait(CrateDelay)
                end
            end)
        end
    end
})


--------------------------------------------------
--// DESTROY ZOMBIES LOCAL (ANTI LAG)
--------------------------------------------------
local RemoveZombies = false
local ZombiesFolder = workspace:WaitForChild("Zombies_Local")

MainTab:Toggle({
    Title = "Destroy Zombies Local",
    Desc = "Hapus zombie local biar ringan",
    Value = false,
    Callback = function(state)
        RemoveZombies = state

        if state then
            task.spawn(function()
                while RemoveZombies do
                    pcall(function()
                        for _, zombie in ipairs(ZombiesFolder:GetChildren()) do
                            zombie:Destroy()
                        end
                    end)

                    task.wait(0.2)
                end
            end)
        end
    end
})

