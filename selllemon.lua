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
    Title = "XapVerseHub - Nama Game | v0.0.0.1",
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
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.home
})

MainTab:Select()

-- Tambahkan variabel status & memori ini di baris paling atas bagian MainTab
local AutoTycoon = false
local AutoTouch = false
local WasTouchActiveBefore = false -- Variabel memori untuk mengingat status awal Auto Touch
local TouchToggleInstance = nil    -- Variabel bantuan UI

-- 1. TOGGLE AUTO ALL TYCOON (CLICK DETECTOR)
MainTab:Toggle({
    Title = "Auto All Tycoon",
    Default = false,
    Callback = function(v)
        AutoTycoon = v
        if v then
            -- SIMPAN STATUS: Ingat apakah sebelum ini Auto Touch lagi nyala
            WasTouchActiveBefore = AutoTouch
            
            -- Jika Auto Touch lagi nyala, matikan sementara secara sistem dan UI
            if AutoTouch then
                AutoTouch = false
                if TouchToggleInstance then
                    TouchToggleInstance:Set(false)
                end
            end
            
            task.spawn(function()
                while AutoTycoon do
                    for i = 1, 10 do
                        if not AutoTycoon then break end
                        local tycoon = workspace:FindFirstChild("Tycoon"..i)
                        if tycoon then
                            for _,obj in ipairs(tycoon:GetDescendants()) do
                                if not AutoTycoon then break end
                                if obj:IsA("ClickDetector") then
                                    pcall(function()
                                        local part = obj.Parent
                                        if part and part:IsA("BasePart") then
                                            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                            if hrp then hrp.CFrame = part.CFrame + Vector3.new(0,3,0) end
                                        end
                                        fireclickdetector(obj)
                                    end)
                                    task.wait(0.05)
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            -- PAS ALL TYCOON MATI: Cek memori, kalau awalnya nyala, hidupkan lagi otomatis
            if WasTouchActiveBefore then
                WasTouchActiveBefore = false -- Reset memori
                if TouchToggleInstance then
                    TouchToggleInstance:Set(true) -- Ini akan otomatis memicu callback Auto Touch di bawah menjadi true
                end
            end
        end
    end
})

-- 2. TOGGLE AUTO TOUCH SMART FILTER (TOUCH INTEREST)
TouchToggleInstance = MainTab:Toggle({
    Title = "Auto Touch Smart Filter",
    Desc = "Hanya memicu tombol yang sudah kebuka (melewati abu-abu)",
    Default = false,
    Callback = function(v)
        -- Proteksi: Jika AutoTycoon lagi aktif, jangan biarkan user menyalakan manual
        if AutoTycoon and v then
            if TouchToggleInstance then
                TouchToggleInstance:Set(false)
            end
            WindUI:Notify({
                Title = "Sistem Dikunci",
                Content = "Matikan 'Auto All Tycoon' terlebih dahulu!",
                Duration = 3
            })
            return
        end

        AutoTouch = v
        if v then
            task.spawn(function()
                while AutoTouch do
                    if AutoTycoon then break end

                    -- Cari tycoon milik player
                    local myTycoon = nil
                    for i = 1, 10 do
                        local tycoon = workspace:FindFirstChild("Tycoon"..i)
                        if tycoon and tycoon:FindFirstChild("Owner") and (tycoon.Owner.Value == LocalPlayer or tycoon.Owner.Value == LocalPlayer.Name) then
                            myTycoon = tycoon
                            break
                        end
                    end

                    -- Loop semua Purchases jika tycoon ditemukan
                    if myTycoon and myTycoon:FindFirstChild("Purchases") then
                        for _, obj in ipairs(myTycoon.Purchases:GetDescendants()) do
                            if not AutoTouch or AutoTycoon then break end
                            
                            if obj:IsA("TouchTransmitter") then
                                pcall(function()
                                    local part = obj.Parent
                                    local char = LocalPlayer.Character
                                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                    
                                    if part and part:IsA("BasePart") and hrp then
                                        -- Filter warna abu-abu (102, 102, 102)
                                        local grayColor = Color3.fromRGB(102, 102, 102)
                                        if part.Color == grayColor then
                                            return
                                        end
                                        
                                        local originalCFrame = hrp.CFrame
                                        
                                        firetouchinterest(hrp, part, 0)
                                        task.wait()
                                        firetouchinterest(hrp, part, 1)
                                        
                                        hrp.CFrame = originalCFrame
                                    end
                                end)
                                task.wait(0.03)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})



local looping = false
local currentSpeed = 20
local savedSpeed = nil
local conn = nil

-- Slider
MainTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust character speed",
    Step = 1,
    Value = {
        Min = 20,
        Max = 200,
        Default = 20,
    },
    Callback = function(speed)
        currentSpeed = speed
    end
})

-- Toggle
MainTab:Toggle({
    Title = "Enable WalkSpeed Loop",
    Desc = "Loop mengikuti slider",
    Default = false,
    Callback = function(state)
        looping = state

        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if not humanoid then return end

        if state then
            -- simpan speed saat ini (termasuk buff)
            savedSpeed = humanoid.WalkSpeed

            conn = task.spawn(function()
                while looping do
                    local c = player.Character
                    local h = c and c:FindFirstChildOfClass("Humanoid")

                    if h then
                        h.WalkSpeed = currentSpeed
                    end

                    task.wait(0.1)
                end
            end)

        else
            -- stop loop
            looping = false

            -- restore ke speed sebelum toggle ON (bukan 16)
            if humanoid and savedSpeed then
                humanoid.WalkSpeed = savedSpeed
            end
        end
    end
})


