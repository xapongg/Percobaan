--// loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/faf.lua"))()
--// pepek
--// pepekjrmnuy





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

    destroyInventoryUI()
end)

--// TAB MAIN
--// TAB MAIN
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.home
})



--// =========================
-- DATA CRAFT
--// =========================
local CraftRecipes = {
    ["TimeJumper"] = {
        Submit = {"TeleportWand","TeleportWand","TeleportWand","TeleportWand","TeleportWand","TeleportWand","TeleportWand","TeleportWand","TeleportWand","TeleportWand","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","MagnifyingGlass","SupremeAutoFeeder"}
    },

    ["DiamondCookie"] = {
        Submit = {"XpCookie","GoldenCookie","PetToy"}
    },

    ["NetRetractor"] = {
        Submit = {"NetMover","NetMover","NetMover","NetMover","NetMover","ExtremeAutoFeeder"}
    },

    ["YolkBreaker"] = {
        Submit = {"EggIncubator","EggHatcher","GoldenCookie"}
    },

    ["ShieldLock"] = {
        Submit = {"StarLock","StarLock","StarLock","StarLock","StarLock","StarLock","StarLock","StarLock","StarLock","StarLock","TimeJumper","ExtremeAutoFeeder"}
    }
}

local SelectedCraft = "DiamondCookie"

local CraftList = {}
for name, _ in pairs(CraftRecipes) do
    table.insert(CraftList, name)
end

MainTab:Dropdown({
    Title = "Select Craft",
    Values = CraftList,
    Multi = false,
    Value = CraftList[1],
    Callback = function(value)
        SelectedCraft = value
    end
})

--// =========================
-- REMOTES
--// =========================
local base = game:GetService("ReplicatedStorage")
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")

local Craft_Remote_Select = base:WaitForChild("crafting.selectCraftingItem")
local Craft_Remote_Submit = base:WaitForChild("crafting.submitItems")
local Craft_Remote_Start = base:WaitForChild("crafting.startCraft")
local Craft_Remote_Collect = base:WaitForChild("crafting.collectCraft")

--// =========================
-- READY CHECK (FAST + RELIABLE)
--// =========================
local function isReady()
    local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return false end

    for _, v in pairs(pg:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text == "READY!" then
            return true
        end
    end

    return false
end

-- 🔥 tunggu READY stabil (anti fake / lag UI)
local function waitReadyStable()
    local count = 0

    while true do
        if isReady() then
            count += 1
        else
            count = 0
        end

        if count >= 3 then
            break
        end

        task.wait(1)
    end
end

-- 🔥 force collect (debug + retry safe)
local function forceCollect()
    local success, err = pcall(function()
        Craft_Remote_Collect:FireServer("gear")
    end)

    print("COLLECT:", success, err)
end

-- 🔥 bersihin READY sebelum craft baru
local function clearReady()
    while isReady() do
        print("CLEARING READY...")
        forceCollect()
        task.wait(0.5)
    end
end


--// =========================
-- AUTO CRAFT
--// =========================
local AutoCraft = false

MainTab:Toggle({
    Title = "Auto Craft (FIXED STABLE)",
    Default = false,
    Callback = function(state)
        AutoCraft = state

        if state then
            task.spawn(function()
                while AutoCraft do

                    local recipe = CraftRecipes[SelectedCraft]
                    if not recipe then
                        task.wait(1)
                        continue
                    end

                    -- 🔒 1. CLEAN STATE DULU
                    clearReady()

                    -- 2. SELECT
                    pcall(function()
                        Craft_Remote_Select:FireServer(SelectedCraft, "gear")
                    end)

                    task.wait(0.2)

                    -- 3. SUBMIT
                    pcall(function()
                        Craft_Remote_Submit:FireServer(recipe.Submit, "gear")
                    end)

                    task.wait(0.2)

                    -- 4. START
                    pcall(function()
                        Craft_Remote_Start:FireServer("gear")
                    end)

                    -- 🔥 5. WAIT READY STABLE (INI FIX UTAMA)
                    waitReadyStable()

                    task.wait(0.5) -- buffer sync server

                    -- 6. COLLECT
                    forceCollect()

                    task.wait(0.3)
                end
            end)
        end
    end
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
--// SELL ALL (FIXED)
--------------------------------------------------
local SellRemote = ReplicatedStorage
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("sellFish.sellAllFish")

local function SellAllFish()
    local success, err = pcall(function()
        SellRemote:FireServer()
    end)

    if success then
        WindUI:Notify({
            Title = "Sell Fish",
            Content = "All fish sold 🐟",
            Duration = 3
        })
    end
end

--------------------------------------------------
--// AUTO SELL (1 DETIK)
--------------------------------------------------
local AutoSell = false

local AutoSellToggle = MainTab:Toggle({
    Title = "Auto Sell Fish (1s)",
    Default = false,
    Callback = function(state)
        AutoSell = state

        if state then
            task.spawn(function()
                while AutoSell do
                    pcall(function()
                        SellRemote:FireServer()
                    end)

                    task.wait(30) -- 1 detik
                end
            end)
        end
    end
})

--------------------------------------------------
--// KEYBIND Q (HARD FIX)
--------------------------------------------------
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Q then
        SellAllFish()
    end
end)


--------------------------------------------------
--// AUTO COLLECT ALL FISH (MULTI POND)
--------------------------------------------------
local AutoCollect = false

local CollectRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("bait.collectAllFish")

-- ambil semua ID pond (UUID)
local function GetAllPondIDs()
    local ids = {}

    for _, pond in pairs(workspace:WaitForChild("Ponds"):GetChildren()) do
        local buildings = pond:FindFirstChild("Buildings")
        if buildings then
            for _, obj in pairs(buildings:GetChildren()) do
                -- biasanya name = UUID
                if typeof(obj.Name) == "string" and string.find(obj.Name, "-") then
                    table.insert(ids, obj.Name)
                end
            end
        end
    end

    return ids
end

-- toggle UI
local AutoCollectToggle = MainTab:Toggle({
    Title = "Auto Collect Fish (All Pond)",
    Default = false,
    Callback = function(state)
        AutoCollect = state

        if state then
			task.spawn(function()
				while AutoCollect do
					local ids = GetAllPondIDs()

					for _, id in ipairs(ids) do
						if not AutoCollect then break end

						-- spam dikit biar lebih cepet collect
						for i = 1, 2 do
							pcall(function()
								CollectRemote:FireServer(id)
							end)
						end

						task.wait() -- super cepat
					end
				end
			end)
        end
    end
})

--------------------------------------------------
--// AUTO OPEN BAIT PACK (MOON)
--------------------------------------------------
local AutoOpenBaitPack = false

local BaitPackRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("store.openBaitPack")

local AutoBaitPackToggle = MainTab:Toggle({
    Title = "Auto Open Bait Pack (Moon)",
    Default = false,
    Callback = function(state)
        AutoOpenBaitPack = state

        if state then
            task.spawn(function()
                while AutoOpenBaitPack do
                    -- spam cepat tapi masih aman
                    for i = 1, 2 do
                        pcall(function()
                            BaitPackRemote:FireServer("Moon:normal")
                        end)
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

--------------------------------------------------
--// FOOD TRAY
--------------------------------------------------

local SelectedFoodTray = "SupremeFoodTray"

local FoodTrayList = {
    "BasicFoodTray",
    "AdvancedFoodTray",
    "SupremeFoodTray",
}

MainTab:Dropdown({
    Title = "Select Food Tray",
    Values = FoodTrayList,
    Multi = false,
    Value = "SupremeFoodTray",
    Callback = function(value)
        SelectedFoodTray = value
    end
})

--------------------------------------------------
--// POSITIONS
--------------------------------------------------

local MutationBeaconPositions = {

    vector.create(26.362998962402344, -0.012000083923339844, 41.5),
    vector.create(76.36299896240234,  -0.012000083923339844, 40.5),
    vector.create(126.36299896240234, -0.012000083923339844, 41.5),

    vector.create(126.36299896240234, -0.012000083923339844, -41.5),
    vector.create(76.36299896240234,  -0.012000083923339844, -40.5),
    vector.create(26.362998962402344, -0.012000083923339844, -41.5),
}

local FoodTrayPositions = {
    vector.create(10.862998962402344, -0.012000083923339844, 11),
}

--------------------------------------------------
--// REMOTE
--------------------------------------------------

local PlaceBuildingRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("ponds.placeBuilding")

--------------------------------------------------
--// BUTTON PLACE BEACON
--------------------------------------------------

MainTab:Button({
    Title = "Place 6 Mutation Beacon",
    Callback = function()

        if #MutationBeaconPositions == 0 then
            warn("No beacon positions")
            return
        end

        task.spawn(function()

            for _, pos in ipairs(MutationBeaconPositions) do

                pcall(function()
                    PlaceBuildingRemote:InvokeServer(
                        "booster",
                        "MutationBeacon",
                        pos
                    )
                end)

                task.wait(0.15)
            end

        end)
    end
})

--------------------------------------------------
--// AUTO PLACE FOOD TRAY
--------------------------------------------------

local AutoPlaceFoodTray = false

MainTab:Toggle({
    Title = "Auto Place Food Tray (3 Menit)",
    Default = false,
    Callback = function(state)

        AutoPlaceFoodTray = state

        if state then
            task.spawn(function()
                while AutoPlaceFoodTray do

                    if #FoodTrayPositions == 0 then
                        warn("No FoodTray positions")
                        task.wait(5)
                        continue
                    end

                    -- PLACE ALL POSITIONS
                    for _, pos in ipairs(FoodTrayPositions) do
                        pcall(function()
                            PlaceBuildingRemote:InvokeServer(
                                "booster",
                                SelectedFoodTray,
                                pos
                            )
                        end)

                        task.wait(0.25)
                    end

                    -- COOLDOWN 3 MENIT
                    for i = 1, 180 do
                        if not AutoPlaceFoodTray then
                            break
                        end

                        task.wait(1)
                    end

                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO SUBMIT SUSHI
--------------------------------------------------
local AutoSubmitTotem = false

local TotemRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("tiki.submitToTotem")

local AutoTotemToggle = MainTab:Toggle({
    Title = "Auto Submit Totem",
    Default = false,
    Callback = function(state)
        AutoSubmitTotem = state

        if state then
            task.spawn(function()
                while AutoSubmitTotem do

                    for i = 1, 3 do
                        pcall(function()
                            TotemRemote:FireServer(i)
                        end)
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
})


--------------------------------------------------
--// AUTO BUY ITEM
--------------------------------------------------
local ShopTab = Window:Tab({Title = "Shop", Icon = "sfsymbols:cart"})


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
	"GodlyAutoFeeder",
}

ShopTab:Dropdown({
    Title = "Select Items",
    Values = ItemList,
    Multi = true,
    Value = {"All"},
    Callback = function(values)
        SelectedItems = HandleSelection(values, ItemList)
    end
})

local AutoBuyToggle = ShopTab:Toggle({
    Title = "Auto Buy Items",
    Default = false,
    Callback = function(state)
        AutoBuy = state

        if state then
            task.spawn(function()
                while AutoBuy do
                    task.wait(0.1)

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
                        task.wait(0.05)
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

ShopTab:Dropdown({
    Title = "Select Eggs",
    Values = EggList,
    Multi = true,
    Value = {"Polar", "Tropical", "Exotic"},
    Callback = function(values)
        SelectedEggs = HandleSelection(values, EggList)
    end
})

local AutoBuyEggToggle = ShopTab:Toggle({
    Title = "Auto Buy Egg",
    Default = false,
    Callback = function(state)
        AutoBuyEgg = state

        if state then
            task.spawn(function()
                while AutoBuyEgg do
                    task.wait(0.1)

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
                        task.wait(0.05)
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
    "Starter",
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
	"Serpent",
}

ShopTab:Dropdown({
    Title = "Select Baits",
    Values = BaitList,
    Multi = true,
	Value = {"All"},
    Callback = function(values)
        SelectedBaits = HandleSelection(values, BaitList)
    end
})

local AutoBuyBaitToggle = ShopTab:Toggle({
    Title = "Auto Buy Bait",
    Default = false,
    Callback = function(state)
        AutoBuyBait = state

        if state then
            task.spawn(function()
                while AutoBuyBait do
                    task.wait(0.1)

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
                        task.wait(0.05)
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

ShopTab:Dropdown({
    Title = "Select Merchant Items",
    Values = MerchantList,
    Multi = true,
    Value = {"All"},
    Callback = function(values)
        SelectedMerchantItems = HandleSelection(values, MerchantList)
    end
})

local AutoBuyMerchantToggle = ShopTab:Toggle({
    Title = "Auto Buy Merchant",
    Default = false,
    Callback = function(state)
        AutoBuyMerchant = state

        if state then
            task.spawn(function()
                while AutoBuyMerchant do
                    task.wait(0.1)

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

                        task.wait(0.05)
                    end
                end
            end)
        end
    end
})



--------------------------------------------------
--// INVENTORY DISPLAY UI (MODERN)
--------------------------------------------------
local BpTab = Window:Tab({Title = "Backpack", Icon = "sfsymbols:bag"})



local InventoryUI = nil
local InventoryRunning = false

local function createInventoryUI()
    if InventoryUI then return end

    local InvenGui = Instance.new("ScreenGui")
    InvenGui.Name = "InventoryDisplayUI"
    InvenGui.ResetOnSpawn = false
    InvenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(220, 70)
    Frame.Position = UDim2.new(0.5, -110, 0.15, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = InvenGui

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(80, 80, 80)
    Stroke.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Inventory: loading..."
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 16
    Title.Parent = Frame

    -- drag
    local dragging, dragInput, startPos, startInput

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = Frame.Position
            startInput = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startInput
            Frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    InventoryUI = {
        Gui = InvenGui,
        Label = Title
    }
end


local function destroyInventoryUI()
    InventoryRunning = false

    -- destroy referensi kalau ada
    if InventoryUI and InventoryUI.Gui then
        InventoryUI.Gui:Destroy()
    end
    InventoryUI = nil

    -- 🔥 FORCE CLEAN (INI YANG SERING KELUPA)
    local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local gui = pg:FindFirstChild("InventoryDisplayUI")
        if gui then
            gui:Destroy()
        end
    end
end

local function getInventoryText()
    local player = game.Players.LocalPlayer
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return "Inventory: ?" end

    local path = pg:FindFirstChild("toolbar")
    if not path then return "Inventory: not found" end

    local ok, txt = pcall(function()
        local label = path
            .Frame
            .CanvasGroup
            .Frame
            .Frame
            .Frame
            .Frame
            .Frame
            .TextLabel

        return label.Text
    end)

    if ok and txt then
        return txt
    end

    return "Inventory: error"
end

local function startInventoryLoop()
    if InventoryRunning then return end
    InventoryRunning = true

    task.spawn(function()
        while InventoryRunning do
            if InventoryUI then
                InventoryUI.Label.Text = getInventoryText()
            end
            task.wait(0.2)
        end
    end)
end

BpTab:Toggle({
    Title = "Show Inventory UI",
    Default = false,
    Callback = function(state)

        if state then
            createInventoryUI()
            startInventoryLoop()
        else
            destroyInventoryUI()
        end

    end
})

--------------------------------------------------
--// Walk Speed
--------------------------------------------------
local MiscTab = Window:Tab({Title = "Misc", Icon = "sfsymbols:wrenchAndScrewdriver"})

local ExtremeFPS = false

local function applyExtreme(state)
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")

    if state then
        -- 🔥 LIGHTING KILL
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0

        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                v.Enabled = false
            end
        end

        -- 🔥 GRAPHIC DOWNGRADE
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        -- 🌍 TERRAIN CLEAN
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        -- 🐾 REMOVE PETS
        for _, v in pairs(workspace:GetChildren()) do
            if string.sub(v.Name, 1, 3):lower() == "pet" then
                pcall(function()
                    v:Destroy()
                end)
            end
        end

        -- 💨 REMOVE PARTICLES / EFFECTS
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Beam") then
                pcall(function()
                    v.Enabled = false
                end)
            end
        end

    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end

-- 🔁 LOOP CLEAN PETS + EFFECTS
task.spawn(function()
    while true do
        if ExtremeFPS then
            for _, v in pairs(workspace:GetChildren()) do
                if string.sub(v.Name, 1, 3):lower() == "pet" then
                    pcall(function()
                        v:Destroy()
                    end)
                end
            end
        end
        task.wait(2)
    end
end)

-- 🎛️ TOGGLE
local FpsToggle = MiscTab:Toggle({
    Title = "⚡ Extreme FPS Boost",
    Default = false,
    Callback = function(state)
        ExtremeFPS = state
        applyExtreme(state)
    end
})



local looping = false
local currentSpeed = 20
local savedSpeed = nil
local conn = nil

-- Slider
MiscTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust character speed",
    Step = 1,
    Value = {
        Min = 20,
        Max = 100,
        Default = 20,
    },
    Callback = function(speed)
        currentSpeed = speed
    end
})

-- Toggle
MiscTab:Toggle({
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


task.defer(function()
    AutoBuyToggle:Set(true)
	AutoTotemToggle:Set(true)
    AutoBuyEggToggle:Set(true)
    AutoBuyBaitToggle:Set(true)
    AutoBuyMerchantToggle:Set(true)
    FpsToggle:Set(true)
end)



--// DISCORD IMAGE LOGGER (AUTO EVENT UI)

task.spawn(function()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")

    local WEBHOOK_URL = "wehbool"
    local ROLE_ID = "1412768888634216478"

    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local AssetNames = {
		["127186374521571"] = "Moon",
		["136755835939322"] = "Wet",
		["139140888833311"] = "Rainbow",
		["86377903629124"] = "Snowy",
		["139489888298750"] = "Sunny",
		["76115335291557"] = "Night",
		["107677789023567"] = "Fire",
		["119395566421956"] = "Frost",
		["101011969289510"] = "Windstruck",
		["88785950117411"] = "Blood Moon",
		["87686114195984"] = "Radioactive",
		["92048929392817"] = "Ghost",
		["134106694861110"] = "Aurora",
		["123550552285357"] = "Starry",
		["131897766910339"] = "Charged",
		["92010517589355"] = "Twirly",
	}

    -- 🔥 FILTER ASSET ID (ISI YANG MAU DI-DETECT SAJA)
    local ALLOWED_IDS = {
		-- "127186374521571",
	}

	local detectedIds = {}

    -- cek apakah id diizinkan
    local function isAllowed(id)
        if #ALLOWED_IDS == 0 then
            return true -- kalau kosong = semua boleh
        end

        for _, v in pairs(ALLOWED_IDS) do
            if tostring(v) == tostring(id) then
                return true
            end
        end

        return false
    end

	local function sendToDiscord(id, name, path)
		local req = (syn and syn.request) or http_request
		if not req then return end

		local player = Players.LocalPlayer
		local username = player.Name
		local displayName = player.DisplayName

		local data = {
			-- 👇 mention + event name
			content = "<@&"..ROLE_ID.."> 🎯 **"..tostring(name).."**",

			embeds = {{
				title = "🎯 Event Detected",
				description =
					"👤 Player: **"..displayName.."** (`"..username.."`)\n"..
					"🖼️ Event Name: **"..tostring(name).."**\n"..
					"🆔 Asset ID: `" ..tostring(id).."`\n"..
					"📍 Path: `" ..tostring(path).."`"
			}}
		}

		req({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end

    local function hookImage(img)
        if not img:IsA("ImageLabel") then return end

        -- filter biar cuma folder events
        if not string.find(img:GetFullName(), "events") then return end

			local function process()
				local raw = img.Image
				local id = string.match(raw, "%d+")

                if not id then return end
                if not isAllowed(id) then return end -- ⬅️ FILTER DI SINI

                if detectedIds[id] then return end
                detectedIds[id] = true

				local name = AssetNames[id] or ("Unknown_" .. id)
				local path = img:GetFullName()

				sendToDiscord(id, name, path)
			end

        -- kirim sekali kalau sudah ada
        task.wait(0.2)
        process()

        -- detect perubahan image
        img:GetPropertyChangedSignal("Image"):Connect(process)
    end

    -- scan awal
    for _, v in pairs(PlayerGui:GetDescendants()) do
        hookImage(v)
    end

    -- detect UI baru
    PlayerGui.DescendantAdded:Connect(function(obj)
        hookImage(obj)
    end)
end)


--// HEARTBEAT WEBHOOK (30 DETIK - AMAN)

task.spawn(function()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")

    local WEBHOOK_URL = "https://discord.com/api/webhooks/1498259284834779166/K6vk6z6p-BqWKapCqgjstB3In897U82O0xDmH58LQ5LwJc7diZGhaSHiHYrjzATHPuvJ"

    local player = Players.LocalPlayer

    while true do
        task.wait(30 + math.random(0,5)) -- 30-35 detik (lebih aman)

        local req = (syn and syn.request) or http_request
        if not req then continue end

        local username = player.Name
        local displayName = player.DisplayName
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")

        local data = {
            content = "🟢 Still Active",
            embeds = {{
                title = "Heartbeat Status",
                description =
                    "👤 Player: **"..displayName.."** (`"..username.."`)\n"..
                    "⏱️ Time: `"..timestamp.."`\n"..
                    "📡 Status: ACTIVE"
            }}
        }

        pcall(function()
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end)
