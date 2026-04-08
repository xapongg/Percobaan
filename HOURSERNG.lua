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

--------------------------------------------------
--// PLAYER
--------------------------------------------------
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--------------------------------------------------
--// REMOTE
--------------------------------------------------
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("46662ded6ad24c718654c69592dce366"):WaitForChild("e8a601ce1f9144a19050eb70f2813b6f")




--------------------------------------------------
--// FOOD DATA MANUAL
--------------------------------------------------
local FoodData = {
    {ItemName = "Grass", Price = 5},
    {ItemName = "Wheat", Price = 12},
    {ItemName = "Apple", Price = 20},
    {ItemName = "Carrots", Price = 30},
    {ItemName = "Sugar Cubes", Price = 40},
    {ItemName = "Oats", Price = 50},
    {ItemName = "Molasses", Price = 60},
    {ItemName = "Beet", Price = 70},
    {ItemName = "Corn", Price = 80},
    {ItemName = "Berries", Price = 85},
    {ItemName = "Potato", Price = 90},
    {ItemName = "Tomato", Price = 95},
    {ItemName = "Peppermints", Price = 100},
    {ItemName = "Banana", Price = 105},
    {ItemName = "Cookies", Price = 110},
    {ItemName = "Toffee Carrots", Price = 115},
    {ItemName = "Toffee Apple", Price = 120},
    {ItemName = "Oat Bars", Price = 125},
    {ItemName = "Strawberry", Price = 150},
    {ItemName = "Orange", Price = 185},
    {ItemName = "Enchanted Wheat", Price = 225},
    {ItemName = "Starfruit", Price = 300},
    {ItemName = "Rainbow Sugar Cubes", Price = 350},
    {ItemName = "Galaxy Grain", Price = 425},
    {ItemName = "Crystal Carrots", Price = 550},
    {ItemName = "Meteor Shards", Price = 675},
    {ItemName = "Golden Apple", Price = 875},
    {ItemName = "Golden Carrot", Price = 1025},
    {ItemName = "Enchanted Golden Apple", Price = 1200},
    {ItemName = "White Strawberry", Price = 1400},
    {ItemName = "Skull Fruit", Price = 1600},
    {ItemName = "Watermelon", Price = 2500},
    {ItemName = "Blood Orange", Price = 3500},
    {ItemName = "Honeycomb", Price = 4750},
    {ItemName = "Hay Bale", Price = 5500},
    {ItemName = "Cheese", Price = 7000},
    {ItemName = "Chocolate", Price = 9000},
    {ItemName = "Cupcake", Price = 11500},
    {ItemName = "Embercherry", Price = 15000},
    {ItemName = "Magma Fruit", Price = 20000},
    {ItemName = "Veil Fruit", Price = 20000},
    {ItemName = "Prismelon", Price = 35000},
    {ItemName = "Cotton Candy", Price = 45000},
}

--------------------------------------------------
--// STATE
--------------------------------------------------
local SelectedItems = {}
local AutoBuy = false

--------------------------------------------------
--// DROPDOWN MULTI
--------------------------------------------------
local ItemNames = {}
for _, item in ipairs(FoodData) do
    table.insert(ItemNames, item.ItemName)
end

MainTab:Dropdown({
    Title = "Select Food",
    Values = ItemNames,
    Multi = true,

    Callback = function(value)
        SelectedItems = value
        print("Selected Updated")
    end
})

--------------------------------------------------
--// GET STOCK
--------------------------------------------------
local function GetStock(itemName)
    local itemGui = PlayerGui.Main.Stores.Food.Main.Content:FindFirstChild(itemName)
    if not itemGui then return 0 end

    local stockLabel = itemGui.Content:FindFirstChild("Stock")
    if not stockLabel then return 0 end

    local num = stockLabel.Text:match("%d+")
    return tonumber(num) or 0
end

--------------------------------------------------
--// GET PRICE
--------------------------------------------------
local function GetPrice(itemName)
    for _, item in ipairs(FoodData) do
        if item.ItemName == itemName then
            return item.Price
        end
    end
    return math.huge
end

--------------------------------------------------
--// AUTO BUY LOOP
--------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        if not AutoBuy then continue end

        for _, itemName in ipairs(SelectedItems) do
            local money = Player.leaderstats.Dollars.Value
            local stock = GetStock(itemName)
            local price = GetPrice(itemName)

            if stock > 0 and money >= price then
                pcall(function()
                    local args = {
                        {
                            StoreName = "Food",
                            ItemName = itemName
                        }
                    }
                    Remote:FireServer(unpack(args))
                    print("Bought:", itemName)
                end)
                task.wait(0.25)
            end
        end
    end
end)

--------------------------------------------------
--// TOGGLE
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Buy Selected Food",
    Default = false,

    Callback = function(state)
        AutoBuy = state
        print("AutoBuy:", state)
    end
})
