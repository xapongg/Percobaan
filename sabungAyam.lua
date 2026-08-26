-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/sabungAyam.lua"))()

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
    IdleConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.2)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)

    task.spawn(function()
        while AntiAFK_Enabled do
            task.wait(60) 
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
})

WindUI:Notify({
    Title = "Welcome",
    Content = "XapVerse Loaded",
    Icon = "rbxassetid://135878568033396",
    Duration = 5,
    CanClose = false,
})

pcall(function()
    Window:EditOpenButton({ Enabled = false })
end)

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XapVerseHub_Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.fromOffset(55, 55)
ToggleButton.Position = UDim2.new(0, 20, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.BackgroundTransparency = 0
ToggleButton.Image = "rbxassetid://135878568033396"
ToggleButton.ImageColor3 = Color3.fromRGB(255,255,255)
ToggleButton.ZIndex = 999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Parent = ToggleButton

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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    Window:Toggle()
end)

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
--// AUTO TWEEN SCRAP & REBIRTH (PERFECT HEIGHT & SPEED)
--------------------------------------------------
local TweenService = game:GetService("TweenService")
local AutoScrapTween = false

MainTab:Button({
    Title = "Start Scrap & Rebirth Tween",
    Desc = "Tween pas di atas lantai (ga tenggelam) & kecepatan aman",
    Callback = function()
        if AutoScrapTween then return end 
        AutoScrapTween = true

        task.spawn(function()
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
            
            if not rootPart or not humanoid then
                WindUI:Notify({Title = "Error", Content = "Karakter tidak ditemukan!", Duration = 3})
                AutoScrapTween = false
                return
            end

            -- Kecepatan aman anti-kick (disesuaikan agar server tidak memutus koneksi)
            local tweenSpeed = 28 

            -- Tinggi offset kaki berdiri (HipHeight + setengah ukuran RootPart)
            local heightOffset = Vector3.new(0, humanoid.HipHeight + (rootPart.Size.Y / 2), 0)

            -- Helper Tween: Mengunci posisi agar tegak & pas di permukaan tanah
            local function tweenTo(targetPosition)
                -- Tambahkan offset tinggi agar karakter berdiri tepat di atas target
                local adjustedPos = targetPosition + heightOffset
                local currentYaw = math.rad(rootPart.Orientation.Y)
                local uprightCFrame = CFrame.new(adjustedPos) * CFrame.Angles(0, currentYaw, 0)

                local distance = (rootPart.Position - adjustedPos).Magnitude
                local tweenTime = distance / tweenSpeed
                local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
                
                local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = uprightCFrame})
                tween:Play()
                return tween
            end

            -- 1. Tween ke semua workspace.PitScrap.Loose
            local pitScrap = workspace:FindFirstChild("PitScrap")
            if pitScrap then
                for _, looseItem in ipairs(pitScrap:GetChildren()) do
                    if looseItem.Name == "Loose" and AutoScrapTween then
                        local targetPart = looseItem:IsA("BasePart") and looseItem or looseItem:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            local tw = tweenTo(targetPart.Position)
                            tw.Completed:Wait()
                            task.wait(0.05)
                        end
                    end
                end
            end

            -- 2. Tween ke Recycler1 + Fire Rebirth instan 10 studs sebelum sampai
            local recyclers = workspace:FindFirstChild("Recyclers")
            local recycler1 = recyclers and recyclers:FindFirstChild("Recycler1")
            
            if recycler1 then
                local targetPart = recycler1:IsA("BasePart") and recycler1 or recycler1:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    local targetPos = targetPart.Position
                    local startPos = rootPart.Position
                    
                    local direction = (targetPos - startPos).Unit
                    local totalDistance = (targetPos - startPos).Magnitude
                    local stopDistance = math.max(0, totalDistance - 10)
                    local positionBeforeRecycler = startPos + (direction * stopDistance)

                    -- Phase 1: Tween ke titik 10 studs dari Recycler
                    local tw1 = tweenTo(positionBeforeRecycler)
                    tw1.Completed:Wait()

                    -- Fire Rebirth INSTAN tanpa jeda
                    task.spawn(function()
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Rebirth"):InvokeServer()
                        end)
                    end)
                    WindUI:Notify({Title = "Rebirth", Content = "Rebirth Fired on Timing!", Duration = 2})

                    -- Phase 2: Langsung sambung ke target Recycler1
                    local tw2 = tweenTo(targetPos)
                    tw2.Completed:Wait()
                end
            end

            AutoScrapTween = false
        end)
    end
})


--------------------------------------------------
--// AUTO CLAIM INCUBATOR (RANDOM 3 - 5 MENIT)
--------------------------------------------------
local AutoClaimIncubator = false

MainTab:Toggle({
    Title = "Auto Claim Incubator",
    Desc = "Otomatis claim incubator secara acak tiap 3-5 menit",
    Value = false,
    Callback = function(Value)
        AutoClaimIncubator = Value

        if AutoClaimIncubator then
            task.spawn(function()
                while AutoClaimIncubator do
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("IncubatorClaim"):InvokeServer()
                    end)

                    local randomDelay = math.random(180, 300)
                    task.wait(randomDelay)
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO TOUCH NEST EGG (FAST & CLOSEST DETECTOR)
--------------------------------------------------
local AutoTouchEgg = false

MainTab:Toggle({
    Title = "Auto Touch Nest Egg (Realtime)",
    Desc = "Touch NestEgg terdekat secara instan saat telur spawn",
    Value = false,
    Callback = function(Value)
        AutoTouchEgg = Value

        if AutoTouchEgg then
            task.spawn(function()
                while AutoTouchEgg do
                    pcall(function()
                        local nestEggsFolder = workspace:FindFirstChild("NestEggs")
                        local character = LocalPlayer.Character
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if nestEggsFolder and rootPart then
                            local closestEggPart = nil
                            local shortestDistance =20 -- Jarak maksimal 15 studs (hanya yang dekat)

                            for _, egg in ipairs(nestEggsFolder:GetChildren()) do
                                local eggPart = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart")
                                if eggPart then
                                    local dist = (rootPart.Position - eggPart.Position).Magnitude
                                    if dist <= shortestDistance then
                                        shortestDistance = dist
                                        closestEggPart = eggPart
                                    end
                                end
                            end

                            -- Jika menemukan telur di jarak dekat, langsung sentuh
                            if closestEggPart then
                                firetouchinterest(rootPart, closestEggPart, 0)
                                task.wait(0.02)
                                firetouchinterest(rootPart, closestEggPart, 1)
                            end
                        end
                    end)

                    -- Jeda mikro (0.1 detik) agar loop berjalan cepat merespon telur spawn tanpa bikin FPS drop
                    task.wait(1)
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO SPAM LIVE UFO (STEALTH + AUTO RESET COOP)
--------------------------------------------------
local AutoSpamUFO = false

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
    if timeLabel and liveUfo.Visible then
        return true
    end
    return false
end

MainTab:Toggle({
    Title = "Auto Chaos (Live UFO)",
    Desc = "Spam remote chaos saat UFO ada, dan set 'coop' 1x saat UFO hilang",
    Value = false,
    Callback = function(Value)
        AutoSpamUFO = Value

        if AutoSpamUFO then
            task.spawn(function()
                local wasUfoActive = false

                while AutoSpamUFO do
                    if isLiveUFOActive() then
                        wasUfoActive = true
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetChickenOrder"):FireServer("chaos")
                        end)
                        task.wait(math.random(21, 35) / 10) 
                    else
                        if wasUfoActive then
                            wasUfoActive = false
                            pcall(function()
                                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetChickenOrder"):FireServer("coop")
                            end)
                        end
                        task.wait(1) 
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO FUSE CHICKENS (FIXED PATTERN & NON-KICK)
--------------------------------------------------
local AutoFuse = false
local SelectedComboTarget = ""

local RarityColors = {
    ["Common"]    = Color3.fromRGB(118, 142, 176), 
    ["Uncommon"]  = Color3.fromRGB(95, 190, 78),     
    ["Rare"]      = Color3.fromRGB(0, 168, 255),     
    ["Epic"]      = Color3.fromRGB(128, 0, 128),   
    ["Legendary"] = Color3.fromRGB(255, 165, 0)    
}

local function getRarityFromColor(color)
    for rarityName, rarityColor in pairs(RarityColors) do
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
    local success, result = pcall(function()
        return LocalPlayer.PlayerGui.Collection.Frame.main.panel.face.content.content.right.panel.face.content.inner.grid
    end)
    if success and result then return result end
    return nil
end

local FuseDropdown = MainTab:Dropdown({
    Title = "Pilih Target Fuse",
    Desc = "Format: Nama [Rarity] (Jumlah)",
    Values = {"(Klik Scan Dulu)"},
    Value = "(Klik Scan Dulu)",
    Callback = function(Value)
        local name, rarity = string.match(Value, "^(.-)%s*%[(.-)%]")
        if name and rarity then
            SelectedComboTarget = name .. "-" .. rarity
        else
            SelectedComboTarget = ""
        end
    end
})

MainTab:Button({
    Title = "Scan Inventory Ayam",
    Desc = "Scan aman membaca semua ID ayam (c1, c527, dst.)",
    Callback = function()
        local grid = getChickenGrid()
        if not grid then 
            WindUI:Notify({Title = "Error", Content = "Buka menu Collection/Inventory di game dulu!", Duration = 3})
            return 
        end

        local comboCounts = {}
        local rawChildren = grid:GetChildren()

        for i = 1, #rawChildren do
            local item = rawChildren[i]
            if i % 15 == 0 then task.wait() end

            pcall(function()
                if item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" and item.Visible then
                    local nameLabel = item:FindFirstChild("name") and item.name:FindFirstChild("name")
                    local faceFrame = item:FindFirstChild("face")

                    if nameLabel and faceFrame and nameLabel.Text ~= "" then
                        local cName = nameLabel.Text
                        local cRarity = getRarityFromColor(faceFrame.BackgroundColor3)
                        local comboKey = cName .. "-" .. cRarity

                        comboCounts[comboKey] = (comboCounts[comboKey] or 0) + 1
                    end
                end
            end)
        end

        local formattedList = {}
        for comboKey, count in pairs(comboCounts) do
            if count >= 2 then
                local name, rarity = string.match(comboKey, "^(.-)%-(.+)$")
                if name and rarity then
                    table.insert(formattedList, name .. " [" .. rarity .. "] (" .. count .. ")")
                end
            end
        end

        if #formattedList > 0 then
            table.sort(formattedList)
            FuseDropdown:Refresh(formattedList)
            WindUI:Notify({Title = "Scan Sukses", Content = "Berhasil memuat " .. #formattedList .. " jenis ayam.", Duration = 3})
        else
            WindUI:Notify({Title = "Scan Selesai", Content = "Tidak ada pasang ayam yang memenuhi syarat (Min 2).", Duration = 3})
        end
    end
})

MainTab:Toggle({
    Title = "Auto Fuse Target Terpilih",
    Desc = "Menjalankan Fuse otomatis",
    Value = false,
    Callback = function(Value)
        AutoFuse = Value

        if AutoFuse then
            task.spawn(function()
                while AutoFuse do
                    if SelectedComboTarget ~= "" then
                        local grid = getChickenGrid()
                        
                        if grid then
                            local targetIds = {}

                            for _, item in ipairs(grid:GetChildren()) do
                                pcall(function()
                                    if item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" then
                                        local nameLabel = item:FindFirstChild("name") and item.name:FindFirstChild("name")
                                        local faceFrame = item:FindFirstChild("face")

                                        if nameLabel and faceFrame then
                                            local cName = nameLabel.Text
                                            local cRarity = getRarityFromColor(faceFrame.BackgroundColor3)
                                            local currentCombo = cName .. "-" .. cRarity

                                            if currentCombo == SelectedComboTarget then
                                                table.insert(targetIds, item.Name)
                                            end
                                        end
                                    end
                                end)
                            end

                            while #targetIds >= 2 and AutoFuse do
                                local id1 = table.remove(targetIds, 1)
                                local id2 = table.remove(targetIds, 1)

                                pcall(function()
                                    local args = { id1, id2, {}, [5] = "a" }
                                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FuseChickens"):InvokeServer(unpack(args))
                                end)

                                task.wait(0.5)
                            end
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end
})

