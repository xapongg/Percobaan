-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/netafish.lua"))()


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

local AutoEquipBest_Enabled = false
local AutoReelIn_Enabled = false
local ReelIn_Delay = 60

local function getOwnedBase()
    local mapFolder = workspace:FindFirstChild("Map")
    local basesFolder = mapFolder and mapFolder:FindFirstChild("Bases")
    if not basesFolder then return nil end

    local displayName = LocalPlayer.DisplayName
    local userName = LocalPlayer.Name

    for _, base in ipairs(basesFolder:GetChildren()) do
        local ownerBadge = base:FindFirstChild("OwnerBadge")
        local badgePart = ownerBadge and ownerBadge:FindFirstChild("Badge")
        local textLabel = badgePart and badgePart:FindFirstChild("TextLabel")

        if textLabel and textLabel:IsA("TextLabel") then
            local labelText = tostring(textLabel.Text)
            if labelText == displayName
                or string.find(labelText, displayName, 1, true)
                or labelText == userName
                or string.find(labelText, userName, 1, true)
            then
                return base
            end
        end
    end

    return nil
end

local function mergeCollectsToPedestal1()
    local ownedBase = getOwnedBase()
    if not ownedBase then
        WindUI:Notify({
            Title = "Collect Failed",
            Content = "Base milik " .. LocalPlayer.DisplayName .. " tidak ditemukan",
            Duration = 4,
        })
        return
    end

    local pedestals = ownedBase:FindFirstChild("Pedestals")
    local pedestal1 = pedestals and pedestals:FindFirstChild("Pedestal1")
    local targetCollect = pedestal1 and pedestal1:FindFirstChild("Collect")
    local targetPad = targetCollect and (targetCollect:FindFirstChild("Pad") or targetCollect:FindFirstChildWhichIsA("BasePart"))

    if not targetCollect or not targetPad then
        WindUI:Notify({
            Title = "Collect Failed",
            Content = "Pedestal1.Collect tidak ditemukan",
            Duration = 4,
        })
        return
    end

    local targetCFrame = targetPad.CFrame
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    -- Gabungkan semua Collect dari Pedestal 1 sampai 10 ke posisi Pedestal1.Collect
    for i = 1, 10 do
        local ped = pedestals:FindFirstChild("Pedestal" .. i)
        local collectObj = ped and ped:FindFirstChild("Collect")
        if collectObj then
            if collectObj:IsA("Model") then
                pcall(function()
                    collectObj:PivotTo(targetCFrame)
                end)
            elseif collectObj:IsA("BasePart") then
                collectObj.CFrame = targetCFrame
                collectObj.CanCollide = false
            end

            for _, desc in ipairs(collectObj:GetDescendants()) do
                if desc:IsA("BasePart") then
                    desc.CFrame = targetCFrame
                    desc.CanCollide = false
                    if rootPart and firetouchinterest then
                        pcall(function()
                            firetouchinterest(rootPart, desc, 0)
                            task.wait(0.02)
                            firetouchinterest(rootPart, desc, 1)
                        end)
                    end
                end
            end
        end
    end

    local collectRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CollectPadReq")
    for padIndex = 1, 10 do
        pcall(function()
            collectRemote:FireServer(padIndex)
        end)
    end

    WindUI:Notify({
        Title = "Merged & Collected",
        Content = "Collect Pedestal 1 - 10 digabung di Pedestal1 (" .. ownedBase.Name .. ")",
        Duration = 3,
    })
end

MainTab:Button({
    Title = "Collect Pads (1 - 10)",
    Desc = "Merges Pedestal 1 - 10 Collect into Pedestal1 and collects all",
    Callback = function()
        mergeCollectsToPedestal1()
    end
})

MainTab:Toggle({
    Title = "Auto Equip Best",
    Desc = "Equips best setup every 15 seconds",
    Default = false,
    Callback = function(state)
        AutoEquipBest_Enabled = state
        if not AutoEquipBest_Enabled then return end

        task.spawn(function()
            while AutoEquipBest_Enabled do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BestSetup"):FireServer()
                end)

                local elapsed = 0
                while AutoEquipBest_Enabled and elapsed < 15 do
                    local dt = task.wait(0.25)
                    elapsed += dt
                end
            end
        end)
    end
})

MainTab:Slider({
    Title = "Reel In Delay (Seconds)",
    Desc = "Set delay between ReelIn calls (30 - 120s)",
    Step = 1,
    Value = {
        Min = 30,
        Max = 120,
        Default = 60,
    },
    Callback = function(value)
        ReelIn_Delay = tonumber(value) or 60
    end
})

MainTab:Toggle({
    Title = "Auto Reel In",
    Desc = "Fires ReelIn based on slider delay",
    Default = false,
    Callback = function(state)
        AutoReelIn_Enabled = state
        if not AutoReelIn_Enabled then return end

        task.spawn(function()
            while AutoReelIn_Enabled do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ReelIn"):FireServer()
                end)

                local elapsed = 0
                while AutoReelIn_Enabled and elapsed < ReelIn_Delay do
                    local dt = task.wait(0.25)
                    elapsed += dt
                end
            end
        end)
    end
})
