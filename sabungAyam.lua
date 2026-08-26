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
--// AUTO SPAM LIVE UFO (STEALTH VERSION)
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
    Desc = "Spam remote chaos dengan delay acak biar ga kena kick",
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
                        task.wait(math.random(21, 35) / 10) 
                    else
                        task.wait(1) 
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO FUSE CHICKENS (SAFE NON-KICK SCANNER)
--------------------------------------------------
local AutoFuse = false
local SelectedRawName = ""

-- Safe UI Grid Getter (Menggunakan Safe Indexing)
local function getChickenGrid()
    local success, result = pcall(function()
        return LocalPlayer.PlayerGui.Collection.Frame.main.panel.face.content.content.right.panel.face.content.inner.grid
    end)
    if success and result then return result end
    return nil
end

local FuseDropdown = MainTab:Dropdown({
    Title = "Pilih Target Fuse",
    Desc = "Pilih jenis ayam yang ingin digabungkan",
    Values = {"(Klik Scan Dulu)"},
    Value = "(Klik Scan Dulu)",
    Callback = function(Value)
        -- Ambil teks murni nama ayam tanpa teks jumlah "(x)"
        SelectedRawName = string.gsub(Value, "%s*%(%d+%)", "")
    end
})

MainTab:Button({
    Title = "Scan Inventory Ayam",
    Desc = "Scan aman tanpa memicu Kick Anti-Cheat",
    Callback = function()
        local grid = getChickenGrid()
        if not grid then 
            WindUI:Notify({Title = "Error", Content = "Buka menu Collection/Inventory di game dulu!", Duration = 3})
            return 
        end

        local nameCounts = {}
        local rawChildren = grid:GetChildren()

        -- Scan dengan Proteksi Thread (Per-Batch 10 item)
        for i = 1, #rawChildren do
            local item = rawChildren[i]
            if i % 10 == 0 then task.wait() end

            pcall(function()
                if item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" and item.Visible then
                    local nameLabel = item.name.name
                    if nameLabel and nameLabel.Text ~= "" then
                        local cName = nameLabel.Text
                        nameCounts[cName] = (nameCounts[cName] or 0) + 1
                    end
                end
            end)
        end

        local formattedList = {}
        for chickenName, count in pairs(nameCounts) do
            if count >= 2 then
                table.insert(formattedList, chickenName .. " (" .. count .. ")")
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
                    if SelectedRawName ~= "" and SelectedRawName ~= "(Klik Scan Dulu)" then
                        local grid = getChickenGrid()
                        
                        if grid then
                            local targetIds = {}

                            for _, item in ipairs(grid:GetChildren()) do
                                pcall(function()
                                    if item:IsA("GuiObject") and string.sub(item.Name, 1, 1) == "c" then
                                        if item.name.name.Text == SelectedRawName then
                                            table.insert(targetIds, item.Name)
                                        end
                                    end
                                end)
                            end

                            -- Fuse Pasangan (Dengan Delay Aman Anti-Ban)
                            while #targetIds >= 2 and AutoFuse do
                                local id1 = table.remove(targetIds, 1)
                                local id2 = table.remove(targetIds, 1)

                                pcall(function()
                                    local args = { id1, id2, {}, [5] = "a" }
                                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FuseChickens"):InvokeServer(unpack(args))
                                end)

                                task.wait(0.5) -- Jeda disesuaikan menjadi 0.5s agar server tidak mendeteksi spam remote
                            end
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end
})
