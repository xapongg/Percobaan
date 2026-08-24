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
startPos = nil

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

--------------------------------------------------
--// AUTO SPAM LIVE UFO
--------------------------------------------------
local AutoSpamUFO = false

-- Helper Function untuk cek apakah UI live-ufo sedang aktif
local function isLiveUFOActive()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end

    local eventChips = playerGui:FindFirstChild("EventChips")
    if not eventChips then return false end

    local frame = eventChips:FindFirstChild("Frame")
    if not frame then return false end

    local holder = frame:FindFirstChild("holder")
    if not holder then return false end

    local liveUfo = holder:FindFirstChild("live-ufo")
    if not liveUfo then return false end

    local timeLabel = liveUfo:FindFirstChild("time")
    
    -- Cek jika UI live-ufo ada dan terlihat di screen
    if timeLabel and liveUfo.Visible then
        return true
    end

    return false
end

-- Toggle Switch di Main Tab
MainTab:Toggle({
    Title = "Auto Chaos (Live UFO)",
    Desc = "Spam remote chaos 2 detik sekali saat event Live UFO berlangsung",
    Value = false,
    Callback = function(Value)
        AutoSpamUFO = Value

        if AutoSpamUFO then
            task.spawn(function()
                while AutoSpamUFO do
                    if isLiveUFOActive() then
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetChickenOrder"):FireServer("chaos")
                        end)
                    end
                    task.wait(2) -- Delay 2 detik
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO FUSE CHICKENS (BY NAME & RARITY SPECIFIC)
--------------------------------------------------
local AutoFuse = false
local SelectedFuseTarget = ""

-- 1. KONFIGURASI WARNA RARITY
-- Masukkan kode RGB yang bener nanti di sini
local RarityColors = {
    ["Common"]    = Color3.fromRGB(255, 255, 255), 
    ["Uncommon"]  = Color3.fromRGB(0, 255, 0),     
    ["Rare"]      = Color3.fromRGB(0, 0, 255),     
    ["Epic"]      = Color3.fromRGB(128, 0, 128),   
    ["Legendary"] = Color3.fromRGB(255, 165, 0)    
}

local function getRarityFromColor(color)
    for rarityName, rarityColor in pairs(RarityColors) do
        -- Mentoleransi sedikit error pembacaan RGB di Roblox
        local diffR = math.abs(color.R - rarityColor.R)
        local diffG = math.abs(color.G - rarityColor.G)
        local diffB = math.abs(color.B - rarityColor.B)
        
        if diffR < 0.05 and diffG < 0.05 and diffB < 0.05 then
            return rarityName
        end
    end
    return "Unknown"
end

local function getChickenGrid()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return nil end
    
    local collection = pGui:FindFirstChild("Collection")
    if not collection then return nil end

    local grid
    pcall(function()
        grid = collection.Frame.main.panel.face.content.content.right.panel.face.content.inner.grid
    end)
    
    return grid
end

-- 2. UI ELEMENTS (DROPDOWN & BUTTON & TOGGLE)

-- Dropdown dibuat menjadi variabel agar listnya bisa di-update (refresh) dari button
local FuseDropdown = MainTab:Dropdown({
    Title = "Pilih Target Fuse",
    Desc = "Format: Nama-Rarity. Silahkan tekan tombol Refresh dulu.",
    Values = {"Kosong, silahkan scan dulu"},
    Value = "Kosong, silahkan scan dulu",
    Callback = function(Value)
        SelectedFuseTarget = Value
    end
})

MainTab:Button({
    Title = "Scan Inventory Ayam",
    Desc = "Klik ini buat mendeteksi ayam & masukin ke dalam dropdown",
    Callback = function()
        local grid = getChickenGrid()
        if not grid then 
            WindUI:Notify({Title = "Error", Content = "Grid UI belum terload / tidak ditemukan", Duration = 3})
            return 
        end

        local uniqueList = {}
        local foundCombinations = {}

        for _, item in ipairs(grid:GetChildren()) do
            if item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" then
                local nameFrame = item:FindFirstChild("name")
                local faceFrame = item:FindFirstChild("face")
                
                if nameFrame and faceFrame then
                    local nameLabel = nameFrame:FindFirstChild("name")
                    if nameLabel and nameLabel:IsA("TextLabel") then
                        local chickenName = nameLabel.Text
                        local chickenColor = faceFrame.BackgroundColor3 
                        local chickenRarity = getRarityFromColor(chickenColor)
                        
                        -- Menggabungkan Nama dan Rarity jadi 1 teks utuh
                        local combination = chickenName .. "-" .. chickenRarity
                        
                        -- Filter duplikat, supaya di dropdown gak muncul teks yg sama berkali-kali
                        if not foundCombinations[combination] then
                            foundCombinations[combination] = true
                            table.insert(uniqueList, combination)
                        end
                    end
                end
            end
        end

        -- Update dropdown dengan hasil scan
        if #uniqueList > 0 then
            FuseDropdown:Refresh(uniqueList)
            WindUI:Notify({Title = "Scan Berhasil", Content = "Menemukan " .. #uniqueList .. " kombinasi ayam unik.", Duration = 3})
        else
            WindUI:Notify({Title = "Scan Gagal", Content = "Tidak ada ayam yang ditemukan di inventory.", Duration = 3})
        end
    end
})

MainTab:Toggle({
    Title = "Auto Fuse Target Terpilih",
    Desc = "Otomatis gabungin (fuse) ayam sesuai pilihan di atas",
    Value = false,
    Callback = function(Value)
        AutoFuse = Value

        if AutoFuse then
            task.spawn(function()
                while AutoFuse do
                    -- Cek kalau ada ayam yg valid dipilih
                    if SelectedFuseTarget ~= "" and SelectedFuseTarget ~= "Kosong, silahkan scan dulu" then
                        local grid = getChickenGrid()
                        
                        if grid then
                            local targetIds = {}

                            -- Looping ngumpulin semua C-ID ayam yang cocok sama pilihan dropdown
                            for _, item in ipairs(grid:GetChildren()) do
                                if item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" then
                                    local nameFrame = item:FindFirstChild("name")
                                    local faceFrame = item:FindFirstChild("face")
                                    
                                    if nameFrame and faceFrame then
                                        local nameLabel = nameFrame:FindFirstChild("name")
                                        if nameLabel and nameLabel:IsA("TextLabel") then
                                            local chickenName = nameLabel.Text
                                            local chickenColor = faceFrame.BackgroundColor3 
                                            local chickenRarity = getRarityFromColor(chickenColor)
                                            
                                            local currentCombo = chickenName .. "-" .. chickenRarity
                                            
                                            -- Jika string-nya cocok (misal: "Ninja-Rare" == "Ninja-Rare")
                                            if currentCombo == SelectedFuseTarget then
                                                table.insert(targetIds, item.Name)
                                            end
                                        end
                                    end
                                end
                            end

                            -- Fuse / Execute berpasangan selama ada minimal 2 ayam
                            while #targetIds >= 2 and AutoFuse do
                                local id1 = table.remove(targetIds, 1)
                                local id2 = table.remove(targetIds, 1)

                                pcall(function()
                                    local args = {
                                        id1,
                                        id2,
                                        {},
                                        [5] = "a"
                                    }
                                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FuseChickens"):InvokeServer(unpack(args))
                                end)

                                task.wait(0.3) -- Jeda biar remote gak dimakan cooldown gamenya
                            end
                        end
                    end
                    task.wait(2) -- Jeda 2 detik sebelum ngulang scan inventory
                end
            end)
        end
    end
})
