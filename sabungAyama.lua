-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/sabungAyama.lua"))()

if not game:IsLoaded() then game.Loaded:Wait() end

--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

--// Safe Anti-AFK (Bypass 20 Menit Tanpa Kick)
task.spawn(function()
    pcall(function()
        local connections = getconnections or get_signal_cons
        if connections then
            for _, conn in pairs(connections(LocalPlayer.Idled)) do
                if conn.Disable then
                    conn:Disable()
                elseif conn.Disconnect then
                    conn:Disconnect()
                end
            end
        end
    end)
end)

LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

--// Wind UI & Icons
local Icons = loadstring(game:HttpGetAsync(
    "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
))()

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// Window
local Window = WindUI:CreateWindow({
    Title = "XapVerseHub - Sabung Ayam | v0.0.0.1",
    Folder = "SabungAyamHub",
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
    Content = "XapVerse Loaded Safely",
    Icon = "rbxassetid://135878568033396",
    Duration = 5,
    CanClose = false,
})

pcall(function()
    Window:EditOpenButton({ Enabled = false })
end)

--// Open Button Milik Kamu (Ditempatkan di gethui agar aman dari anti-cheat PlayerGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XapVerseHub_Toggle"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = gethui and gethui() or LocalPlayer:WaitForChild("PlayerGui")
end)

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
--// AUTO CLAIM INCUBATOR (SAFE RANDOM 4-7 MENIT)
--------------------------------------------------
local AutoClaimIncubator = false

MainTab:Toggle({
    Title = "Auto Claim Incubator",
    Desc = "Otomatis claim incubator secara acak tiap 4-7 menit",
    Value = false,
    Callback = function(Value)
        AutoClaimIncubator = Value

        if AutoClaimIncubator then
            task.spawn(function()
                while AutoClaimIncubator do
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("IncubatorClaim"):InvokeServer()
                    end)
                    local randomDelay = math.random(240, 420)
                    task.wait(randomDelay)
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO TOUCH NEST EGG (SLOW & STABLE)
--------------------------------------------------
local AutoTouchEgg = false

MainTab:Toggle({
    Title = "Auto Touch Nest Egg (Safe Mode)",
    Desc = "Touch NestEgg dengan jeda aman 4 detik",
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
                            local shortestDistance = 18 

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

                            if closestEggPart then
                                firetouchinterest(rootPart, closestEggPart, 0)
                                task.wait(0.15)
                                firetouchinterest(rootPart, closestEggPart, 1)
                            end
                        end
                    end)
                    task.wait(4)
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO SPAM LIVE UFO (REDUCED FREQUENCY)
--------------------------------------------------
local AutoSpamUFO = false

local function isLiveUFOActive()
    local success, result = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local liveUfo = playerGui.EventChips.Frame.holder["live-ufo"]
        if liveUfo and liveUfo:FindFirstChild("time") and liveUfo.Visible then
            return true
        end
        return false
    end)
    return success and result
end

MainTab:Toggle({
    Title = "Auto Chaos (Live UFO)",
    Desc = "Spam remote chaos dengan jeda aman",
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
                        task.wait(math.random(60, 80) / 10) 
                    else
                        if wasUfoActive then
                            wasUfoActive = false
                            pcall(function()
                                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetChickenOrder"):FireServer("coop")
                            end)
                        end
                        task.wait(3) 
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO FUSE CHICKENS (SAFE BATCH)
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
    Desc = "Scan aman membaca semua ayam berdasarkan Unique ID",
    Callback = function()
        local grid = getChickenGrid()
        if not grid then 
            WindUI:Notify({Title = "Error", Content = "Buka menu Collection/Inventory di game dulu!", Duration = 3})
            return 
        end

        WindUI:Notify({Title = "Scanning...", Content = "Sedang memindai inventory ayam...", Duration = 2})

        task.spawn(function()
            local comboCounts = {}
            local rawChildren = grid:GetChildren()

            for i = 1, #rawChildren do
                local item = rawChildren[i]
                -- Beri jeda tiap 35 item agar client tidak lag
                if i % 35 == 0 then task.wait(0.02) end

                pcall(function()
                    -- Mengecek apakah objek adalah GuiObject dan namanya diawali huruf 'c' (misal c1, c5552)
                    if item and item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" and item.Visible then
                        local nameLabel = item:FindFirstChild("name") and item.name:FindFirstChild("name")
                        local faceFrame = item:FindFirstChild("face")

                        if nameLabel and faceFrame and nameLabel.Text ~= "" then
                            local cName = nameLabel.Text
                            local cRarity = getRarityFromColor(faceFrame.BackgroundColor3)
                            
                            if cRarity ~= "Unknown" then
                                local comboKey = cName .. "-" .. cRarity
                                comboCounts[comboKey] = (comboCounts[comboKey] or 0) + 1
                            end
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
                WindUI:Notify({Title = "Scan Sukses", Content = "Berhasil memuat " .. #formattedList .. " jenis ayam kembar.", Duration = 4})
            else
                WindUI:Notify({Title = "Scan Selesai", Content = "Tidak ada pasang ayam yang memenuhi syarat (Min 2).", Duration = 3})
            end
        end)
    end
})


MainTab:Toggle({
    Title = "Auto Fuse Target Terpilih",
    Desc = "Menjalankan Fuse dengan jeda santai",
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

                            if #targetIds >= 2 then
                                local id1 = table.remove(targetIds, 1)
                                local id2 = table.remove(targetIds, 1)

                                pcall(function()
                                    local args = { id1, id2, {}, [5] = "a" }
                                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FuseChickens"):InvokeServer(unpack(args))
                                end)
                            end
                        end
                    end
                    task.wait(3)
                end
            end)
        end
    end
})
