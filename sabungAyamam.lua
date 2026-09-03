-- Tunggu hingga game selesai dimuat agar tidak error
if not game:IsLoaded() then game.Loaded:Wait() end

--// Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--------------------------------------------------
--// AUTO ANTI AFK (ANTI DISCONNECT)
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

--------------------------------------------------
--// RAYFIELD GEN 2 UI (WITH ANTI-DETECT FEATURES)
--------------------------------------------------
-- Rayfield otomatis menggunakan gethui() secara internal jika executor mendukung,
-- sehingga game tidak dapat mendeteksi keberadaan UI ini.
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "XapVerseHub | Sabung Ayam",
    Icon = 0, -- 0 untuk tanpa icon, bisa diubah ke AssetID
    LoadingTitle = "Loading XapVerseHub...",
    LoadingSubtitle = "by xapongg",
    Theme = "Default",
    
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = true, -- Mematikan warning agar tidak mengganggu

    ConfigurationSaving = {
        Enabled = false,
        FolderName = "XapVerse",
        FileName = "SabungAyamConfig"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false,
})

Rayfield:Notify({
    Title = "Injector Success",
    Content = "XapVerse Loaded. UI Tersembunyi dari sistem game (Anti-Detect).",
    Duration = 5,
    Image = 4483362458,
})

--------------------------------------------------
--// TAB MAIN
--------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458) 

--------------------------------------------------
--// AUTO CLAIM INCUBATOR (RANDOM 3 - 5 MENIT)
--------------------------------------------------
local AutoClaimIncubator = false

MainTab:CreateToggle({
    Name = "Auto Claim Incubator",
    CurrentValue = false,
    Flag = "AutoClaimIncubatorFlag",
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
    end,
})

--------------------------------------------------
--// AUTO TOUCH NEST EGG (FAST & CLOSEST DETECTOR)
--------------------------------------------------
local AutoTouchEgg = false

MainTab:CreateToggle({
    Name = "Auto Touch Nest Egg (Realtime)",
    CurrentValue = false,
    Flag = "AutoTouchEggFlag",
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
                            local shortestDistance = 20 -- Jarak maksimal (studs)

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

                            -- Jika menemukan telur, langsung sentuh (Touch)
                            if closestEggPart then
                                firetouchinterest(rootPart, closestEggPart, 0)
                                task.wait(0.02)
                                firetouchinterest(rootPart, closestEggPart, 1)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

--------------------------------------------------
--// AUTO SPAM LIVE UFO
--------------------------------------------------
local AutoSpamUFO = false

local function isLiveUFOActive()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local liveUfo
    pcall(function()
        liveUfo = playerGui.EventChips.Frame.holder["live-ufo"]
    end)

    if liveUfo and liveUfo:FindFirstChild("time") and liveUfo.Visible then
        return true
    end
    return false
end

MainTab:CreateToggle({
    Name = "Auto Chaos (Live UFO)",
    CurrentValue = false,
    Flag = "AutoChaosFlag",
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
    end,
})

--------------------------------------------------
--// AUTO FUSE CHICKENS
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

local FuseDropdown = MainTab:CreateDropdown({
    Name = "Pilih Target Fuse",
    Options = {"(Klik Scan Dulu)"},
    CurrentOption = {"(Klik Scan Dulu)"},
    MultipleOptions = false,
    Flag = "FuseDropdownFlag",
    Callback = function(Option)
        local val = type(Option) == "table" and Option[1] or Option
        local name, rarity = string.match(val, "^(.-)%s*%[(.-)%]")
        if name and rarity then
            SelectedComboTarget = name .. "-" .. rarity
        else
            SelectedComboTarget = ""
        end
    end,
})

MainTab:CreateButton({
    Name = "Scan Inventory Ayam",
    Callback = function()
        local grid = getChickenGrid()
        if not grid then 
            Rayfield:Notify({Title = "Error", Content = "Buka menu Collection/Inventory di game dulu!", Duration = 3})
            return 
        end

        local comboCounts = {}
        local rawChildren = grid:GetChildren()

        for i = 1, #rawChildren do
            local item = rawChildren[i]
            if i % 15 == 0 then task.wait() end -- Mencegah freeze

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
            FuseDropdown:Refresh(formattedList, true)
            Rayfield:Notify({Title = "Scan Sukses", Content = "Ditemukan " .. #formattedList .. " jenis ayam.", Duration = 3})
        else
            Rayfield:Notify({Title = "Scan Selesai", Content = "Tidak ada pasang ayam yang memenuhi syarat (Min 2).", Duration = 3})
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Fuse Target Terpilih",
    CurrentValue = false,
    Flag = "AutoFuseFlag",
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
    end,
})
