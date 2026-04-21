--// loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/faf.lua"))()



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


--// AUTO BUY SYSTEM (MULTI)
local AutoBuy = false
local SelectedItems = {} -- sekarang table

-- List item (ISI SENDIRI)
local ItemList = {
    "BasicAutoFeeder",
	"FoodScoop",
	"BasicFoodTray",
	"NetMover",
	"MagnifyingGlass",
    "AdvancedAutoFeeder",
	"AdvancedFoodTray",
	"XpCookie",
	"TeleportWand",
	"StarLock",
    "SupremeAutoFeeder",
	"PetToy",
	"TradingTicket",
	"EggHatcher",
	"SupremeFoodTray",
	"PetWhistle",
	"GoldenCookie",
	"MutationBeacon",
	"EggIncubator",
	"ExtremeAutoFeeder",
}

-- Dropdown (MULTI)
MainTab:Dropdown({
    Title = "Select Items",
    Values = ItemList,
    Multi = true, -- penting
    Default = {},
    Callback = function(values)
        SelectedItems = values -- table of selected items
    end
})

-- Toggle
MainTab:Toggle({
    Title = "Auto Buy Multi",
    Default = false,
    Callback = function(state)
        AutoBuy = state

        if state then
            task.spawn(function()
                while AutoBuy do
                    task.wait(1)

                    for _, item in pairs(SelectedItems) do
                        pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("rbxts_include")
                                :WaitForChild("node_modules")
                                :WaitForChild("@rbxts")
                                :WaitForChild("remo")
                                :WaitForChild("src")
                                :WaitForChild("container")
                                :WaitForChild("shop.purchaseGear")
                                :FireServer(item)
                        end)

                        task.wait(0.2) -- delay antar item biar gak ke-detect spam
                    end
                end
            end)
        end
    end
})




--// AUTO BUY EGG SYSTEM (MULTI)
local AutoBuyEgg = false
local SelectedEggs = {}

-- List egg (ISI SENDIRI)
local EggList = {
    "Starter",
    "Novice",
    "Forest",
    "Polar",
    "Tropical",
    "Exotic",
}

-- Dropdown (MULTI)
MainTab:Dropdown({
    Title = "Select Eggs",
    Values = EggList,
    Multi = true,
    Default = {},
    Callback = function(values)
        SelectedEggs = values
    end
})

-- Toggle
MainTab:Toggle({
    Title = "Auto Buy Egg",
    Default = false,
    Callback = function(state)
        AutoBuyEgg = state

        if state then
            task.spawn(function()
                while AutoBuyEgg do
                    task.wait(1)

                    for _, egg in pairs(SelectedEggs) do
                        pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("rbxts_include")
                                :WaitForChild("node_modules")
                                :WaitForChild("@rbxts")
                                :WaitForChild("remo")
                                :WaitForChild("src")
                                :WaitForChild("container")
                                :WaitForChild("shop.purchaseEgg")
                                :FireServer(egg)
                        end)

                        task.wait(0.2) -- anti spam
                    end
                end
            end)
        end
    end
})



--// AUTO BUY EGG SYSTEM (MULTI)
local AutoBuyEvent = false
local SelectedItems = {}

-- List egg (ISI SENDIRI)
local EventList = {
    "baitpack:Easter",
}

-- Dropdown (MULTI)
MainTab:Dropdown({
    Title = "Select Items",
    Values = EventList,
    Multi = true,
    Default = {},
    Callback = function(values)
        SelectedItems = values
    end
})

-- Toggle
MainTab:Toggle({
    Title = "Auto Buy Event",
    Default = false,
    Callback = function(state)
        AutoBuyEvent = state

        if state then
            task.spawn(function()
                while AutoBuyEvent do
                    task.wait(1)

                    for _, event in pairs(SelectedItems) do
                        pcall(function()
							game:GetService("ReplicatedStorage")
								:WaitForChild("rbxts_include")
								:WaitForChild("node_modules")
								:WaitForChild("@rbxts")
								:WaitForChild("remo")
								:WaitForChild("src")
								:WaitForChild("container")
								:WaitForChild("shop.purchaseEventItem")
                                :FireServer(event)
                        end)

                        task.wait(0.2) -- anti spam
                    end
                end
            end)
        end
    end
})


--// AUTO BUY EGG SYSTEM (MULTI)
local AutoBuyBait = false
local SelectedBait = {}

-- List egg (ISI SENDIRI)
local BaitList = {
    "Jelly",
    "Whale",
    "Squid",
    "Shark",
    "Megalodon",
    "Kraken",
    "Maja",
    "Bloop",
    "OceanEater",
}

-- Dropdown (MULTI)
MainTab:Dropdown({
    Title = "Select Items",
    Values = BaitList,
    Multi = true,
    Default = {},
    Callback = function(values)
        SelectedBait = values
    end
})

-- Toggle
MainTab:Toggle({
    Title = "Auto Buy Bait",
    Default = false,
    Callback = function(state)
        AutoBuyBait = state

        if state then
            task.spawn(function()
                while AutoBuyBait do
                    task.wait(1)

                    for _, bait in pairs(SelectedBait) do
                        pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("rbxts_include")
                                :WaitForChild("node_modules")
                                :WaitForChild("@rbxts")
                                :WaitForChild("remo")
                                :WaitForChild("src")
                                :WaitForChild("container")
                                :WaitForChild("shop.purchaseBait")
                                :FireServer(bait)
                        end)

                        task.wait(0.2) -- anti spam
                    end
                end
            end)
        end
    end
})


