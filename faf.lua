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
--// TAB MAIN
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.home
})

--------------------------------------------------
--// FUNCTION HELPER (ALL SELECTOR)
--------------------------------------------------
local function HandleSelection(values, fullList)
    local result = {}

    if table.find(values, "All") then
        for _, v in ipairs(fullList) do
            if v ~= "All" then
                table.insert(result, v)
            end
        end
    else
        result = values
    end

    return result
end

--------------------------------------------------
--// AUTO BUY ITEM
--------------------------------------------------
local AutoBuy = false
local SelectedItems = {}

local ItemList = {
    "All",
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

MainTab:Dropdown({
    Title = "Select Items",
    Values = ItemList,
    Multi = true,
    Value = {"All"},
    Callback = function(values)
        SelectedItems = HandleSelection(values, ItemList)
    end
})

local AutoBuyToggle = MainTab:Toggle({
    Title = "Auto Buy Items",
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
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO BUY EGG
--------------------------------------------------
local AutoBuyEgg = false
local SelectedEggs = {}

local EggList = {
    "All",
    "Starter",
	"Novice",
	"Forest",
	"Polar",
	"Tropical",
	"Exotic",
}

MainTab:Dropdown({
    Title = "Select Eggs",
    Values = EggList,
    Multi = true,
    Value = {"Polar", "Tropical", "Exotic"},
    Callback = function(values)
        SelectedEggs = HandleSelection(values, EggList)
    end
})

local AutoBuyEggToggle = MainTab:Toggle({
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
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO BUY EVENT
--------------------------------------------------
local AutoBuyEvent = false
local SelectedEvents = {}

local EventList = {
    "All",
    "baitpack:Easter",
    "egg:Easter",
}

MainTab:Dropdown({
    Title = "Select Event Items",
    Values = EventList,
    Multi = true,
    Value = {"egg:Easter"},
    Callback = function(values)
        SelectedEvents = HandleSelection(values, EventList)
    end
})

local AutoBuyEventToggle = MainTab:Toggle({
    Title = "Auto Buy Event",
    Default = false,
    Callback = function(state)
        AutoBuyEvent = state

        if state then
            task.spawn(function()
                while AutoBuyEvent do
                    task.wait(1)

                    for _, event in pairs(SelectedEvents) do
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
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO BUY BAIT
--------------------------------------------------
local AutoBuyBait = false
local SelectedBaits = {}

local BaitList = {
    "All",
    "Koi",
    "River",
    "Puffer",
    "Glo",
    "Seal",
    "Ray",
    "Octopus",
    "Axolotl",
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

MainTab:Dropdown({
    Title = "Select Baits",
    Values = BaitList,
    Multi = true,
	Value = {"All"},
    Callback = function(values)
        SelectedBaits = HandleSelection(values, BaitList)
    end
})

local AutoBuyBaitToggle = MainTab:Toggle({
    Title = "Auto Buy Bait",
    Default = false,
    Callback = function(state)
        AutoBuyBait = state

        if state then
            task.spawn(function()
                while AutoBuyBait do
                    task.wait(1)

                    for _, bait in pairs(SelectedBaits) do
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
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO BUY MERCHANT
--------------------------------------------------
local AutoBuyMerchant = false
local SelectedMerchantItems = {}

-- List (isi sendiri nanti)
local MerchantList = {
    "All",
    "Wild",
    "Punk",
    "Boba",
    "Ashen",
    -- tambah di sini
}

MainTab:Dropdown({
    Title = "Select Merchant Items",
    Values = MerchantList,
    Multi = true,
    Value = {"All"},
    Callback = function(values)
        SelectedMerchantItems = HandleSelection(values, MerchantList)
    end
})

local AutoBuyMerchantToggle = MainTab:Toggle({
    Title = "Auto Buy Merchant",
    Default = false,
    Callback = function(state)
        AutoBuyMerchant = state

        if state then
            task.spawn(function()
                while AutoBuyMerchant do
                    task.wait(1)

                    for _, item in pairs(SelectedMerchantItems) do
                        pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("rbxts_include")
                                :WaitForChild("node_modules")
                                :WaitForChild("@rbxts")
                                :WaitForChild("remo")
                                :WaitForChild("src")
                                :WaitForChild("container")
                                :WaitForChild("merchant.purchaseItem")
                                :FireServer("travelling", item)
                        end)

                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})



task.defer(function()
    AutoBuyToggle:Set(true)
    AutoBuyEggToggle:Set(true)
    AutoBuyEventToggle:Set(true)
    AutoBuyBaitToggle:Set(true)
    AutoBuyMerchantToggle:Set(true)
end)
