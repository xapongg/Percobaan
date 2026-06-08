-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/hatchacow.lua"))()

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


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- AUTO DETECT PLOT
--------------------------------------------------
local function GetMyPlot()
    for _, Plot in ipairs(workspace.Plots:GetChildren()) do
        pcall(function()

            local Label = Plot.Sign.owner_text.UI.Frame.ownername

            if Label and Label:IsA("TextLabel") then
                local Text = Label.Text:lower()

                if Text == (LocalPlayer.Name:lower() .. "'s plot") then
                    return Plot
                end
            end

        end)
    end

    -- fallback
    for _, Plot in ipairs(workspace.Plots:GetChildren()) do
        local success, Label = pcall(function()
            return Plot.Sign.owner_text.UI.Frame.ownername
        end)

        if success and Label then
            if string.find(
                Label.Text:lower(),
                LocalPlayer.Name:lower(),
                1,
                true
            ) then
                return Plot
            end
        end
    end

    return nil
end

--------------------------------------------------
-- CHECK PLOT BUTTON
--------------------------------------------------
MainTab:Button({
    Title = "Check My Plot",
    Callback = function()

        local Plot = GetMyPlot()

        if Plot then
            print("FOUND PLOT:", Plot.Name)

            WindUI:Notify({
                Title = "Success",
                Content = "Found "..Plot.Name,
                Duration = 3
            })
        else
            warn("PLOT NOT FOUND")

            WindUI:Notify({
                Title = "Error",
                Content = "Plot Not Found",
                Duration = 3
            })
        end
    end
})

--------------------------------------------------
-- MOVE ALL COLLECTPAD
--------------------------------------------------
MainTab:Button({
    Title = "Move All CollectPads",
    Callback = function()

        local Plot = GetMyPlot()

        if not Plot then
            warn("Plot not found")
            return
        end

        local Floor1 = Plot:FindFirstChild("Floor1")
        if not Floor1 then
            warn("Floor1 not found")
            return
        end

        local Stable1 = Floor1:FindFirstChild("Stable1")
        if not Stable1 then
            warn("Stable1 not found")
            return
        end

        local TargetPad = Stable1:FindFirstChild("CollectPad")
        if not TargetPad then
            warn("Target CollectPad not found")
            return
        end

        local TargetPivot

        pcall(function()
            TargetPivot = TargetPad:GetPivot()
        end)

        local moved = 0

        for _, Floor in ipairs(Plot:GetChildren()) do

            if Floor.Name:match("^Floor%d+$") then

                for _, Stable in ipairs(Floor:GetChildren()) do

                    if Stable.Name:match("^Stable%d+$") then

                        local Pad = Stable:FindFirstChild("CollectPad")

                        if Pad and Pad ~= TargetPad then

                            pcall(function()

                                if Pad:IsA("BasePart") then
                                    Pad.CFrame = TargetPivot

                                elseif Pad:IsA("Model") then
                                    Pad:PivotTo(TargetPivot)

                                elseif Pad.GetPivot then
                                    Pad:PivotTo(TargetPivot)
                                end

                            end)

                            moved += 1
                        end
                    end
                end
            end
        end

        print("Moved:", moved)

        WindUI:Notify({
            Title = "Done",
            Content = "Moved "..moved.." CollectPads",
            Duration = 5
        })
    end
})


local AutoFarm = false
local SeedName = "Melon"

MainTab:Toggle({
    Title = "Auto Plant & Harvest",
    Default = false,
    Callback = function(Value)
        AutoFarm = Value

        if not Value then
            return
        end

        task.spawn(function()

            local RS = game:GetService("ReplicatedStorage")
            local PlantRemote = RS.Remotes.PlantSeed
            local HarvestRemote = RS.Remotes.HarvestCrop

            while AutoFarm do

                local CropShop = workspace:FindFirstChild("CropShop")
                local RowsFolder = CropShop and CropShop:FindFirstChild("Rows")

                if not RowsFolder then
                    task.wait(1)
                    continue
                end

                local planted = 0

                -- Plant Semua Row & Slot
                for _, Row in ipairs(RowsFolder:GetChildren()) do

                    local RowNumber = tonumber(Row.Name:match("%d+"))

                    if RowNumber then
                        for _, Slot in ipairs(Row:GetChildren()) do

                            local SlotNumber = tonumber(Slot.Name:match("Slot(%d+)"))

                            if SlotNumber then
                                PlantRemote:FireServer(
                                    RowNumber,
                                    SlotNumber,
                                    SeedName
                                )

                                planted += 1
                                task.wait(0.03)
                            end
                        end
                    end
                end

                WindUI:Notify({
                    Title = "Plant Done",
                    Content = "Planted "..planted.." "..SeedName,
                    Duration = 3
                })

                -- Cooldown 6 Menit
                for i = 1, 360 do
                    if not AutoFarm then
                        return
                    end
                    task.wait(1)
                end

                local harvested = 0

                -- Harvest Semua Row & Slot
                for _, Row in ipairs(RowsFolder:GetChildren()) do

                    local RowNumber = tonumber(Row.Name:match("%d+"))

                    if RowNumber then
                        for _, Slot in ipairs(Row:GetChildren()) do

                            local SlotNumber = tonumber(Slot.Name:match("Slot(%d+)"))

                            if SlotNumber then
                                HarvestRemote:FireServer(
                                    RowNumber,
                                    SlotNumber
                                )

                                harvested += 1
                                task.wait(0.03)
                            end
                        end
                    end
                end

                WindUI:Notify({
                    Title = "Harvest Done",
                    Content = "Harvested "..harvested,
                    Duration = 3
                })

                -- Cooldown 5 detik sebelum plant lagi
                for i = 1, 5 do
                    if not AutoFarm then
                        return
                    end
                    task.wait(1)
                end
            end
        end)
    end
})

local AutoSell = false

MainTab:Toggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(Value)
        AutoSell = Value

        if Value then
            task.spawn(function()
                local SellRemote = game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("SellRequest")

                while AutoSell do
                    SellRemote:FireServer("hand")
                    task.wait(0.1) -- interval sell
                end
            end)
        end
    end
})

--------------------------------------------------
-- FPS BOOST
--------------------------------------------------
local FPSBoost = false

MainTab:Toggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(Value)
        FPSBoost = Value

        if not Value then
            return
        end

        task.spawn(function()

            -- Remove Rocks
            pcall(function()
                local Rocks = workspace.Environment:FindFirstChild("Rocks")
                if Rocks then
                    Rocks:ClearAllChildren()
                end
            end)

            -- Remove Trees
            pcall(function()
                local Trees = workspace.Environment:FindFirstChild("Trees")
                if Trees then
                    Trees:ClearAllChildren()
                end
            end)

            -- Lighting Optimization
            pcall(function()
                local Lighting = game:GetService("Lighting")

                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 0

                if Lighting:FindFirstChildOfClass("BloomEffect") then
                    Lighting:FindFirstChildOfClass("BloomEffect").Enabled = false
                end

                if Lighting:FindFirstChildOfClass("BlurEffect") then
                    Lighting:FindFirstChildOfClass("BlurEffect").Enabled = false
                end

                if Lighting:FindFirstChildOfClass("SunRaysEffect") then
                    Lighting:FindFirstChildOfClass("SunRaysEffect").Enabled = false
                end

                if Lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                    Lighting:FindFirstChildOfClass("ColorCorrectionEffect").Enabled = false
                end
            end)

            -- Workspace Optimization
            for _, v in ipairs(workspace:GetDescendants()) do

                pcall(function()

                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                        v.CastShadow = false
                    end

                    if v:IsA("Decal")
                    or v:IsA("Texture") then
                        v:Destroy()
                    end

                    if v:IsA("ParticleEmitter")
                    or v:IsA("Trail")
                    or v:IsA("Beam")
                    or v:IsA("Smoke")
                    or v:IsA("Fire")
                    or v:IsA("Sparkles") then
                        v.Enabled = false
                    end

                end)

            end

            WindUI:Notify({
                Title = "FPS Boost",
                Content = "FPS Boost Applied",
                Duration = 5
            })

        end)
    end
})

--------------------------------------------------
-- DELETE OTHER PLOTS TOGGLE
--------------------------------------------------
local DeleteOtherPlots = false

MainTab:Toggle({
    Title = "Delete Other Plots",
    Default = false,
    Callback = function(Value)
        DeleteOtherPlots = Value

        task.spawn(function()
            local MyPlot = GetMyPlot()
            if not MyPlot then
                WindUI:Notify({
                    Title = "Error",
                    Content = "My plot not found!",
                    Duration = 3
                })
                return
            end

            while DeleteOtherPlots do
                for _, Plot in ipairs(workspace.Plots:GetChildren()) do
                    if Plot ~= MyPlot then
                        pcall(function()
                            Plot:Destroy()
                        end)
                    end
                end
                task.wait(5)
            end
        end)
    end
})

--------------------------------------------------
-- DELETE MY COWS & BABIES TOGGLE
--------------------------------------------------
local DeleteMyAnimals = false

MainTab:Toggle({
    Title = "Delete My Cows & Babies",
    Default = false,
    Callback = function(Value)
        DeleteMyAnimals = Value

        task.spawn(function()
            while DeleteMyAnimals do
                local MyPlot = GetMyPlot()
                if MyPlot then
                    for _, Floor in ipairs(MyPlot:GetChildren()) do
                        if Floor.Name:match("^Floor%d+$") then
                            for _, Stable in ipairs(Floor:GetChildren()) do
                                if Stable.Name:match("^Stable%d+$") then
                                    for _, Animal in ipairs(Stable:GetChildren()) do
                                        if Animal.Name:match("^Cow_") or Animal.Name:match("^Baby_") then
                                            pcall(function()
                                                Animal:Destroy()
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(5)
            end
        end)
    end
})

--------------------------------------------------
-- AUTO FEED COWS (CHECK HUNGRY ONLY)
--------------------------------------------------

local AutoFeed = false
local ExcludedFloors = {}

MainTab:Dropdown({
    Title = "Exclude Floor",
    Values = {
        "Floor1","Floor2","Floor3","Floor4","Floor5",
        "Floor6","Floor7","Floor8","Floor9","Floor10","Floor11","Floor12"
    },
    Multi = true,
    Value = {"Floor1","Floor2","Floor3","Floor4"},
    Callback = function(Value)
        ExcludedFloors = Value or {}
    end
})

local function isExcluded(floorName)
    for _, v in ipairs(ExcludedFloors) do
        if v == floorName then
            return true
        end
    end
    return false
end

local function firePrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
    end
end

local function CowNeedsFood(cow)
    local anchor = cow:FindFirstChild("BillboardAnchor")
    if not anchor then
        return false
    end

    return not anchor:FindFirstChild("FedCowBillboard")
end

MainTab:Toggle({
    Title = "Auto Feed Hungry Cows",
    Default = false,
    Callback = function(Value)
        AutoFeed = Value

        if not Value then
            return
        end

        task.spawn(function()

            while AutoFeed do

                local MyPlot = GetMyPlot()

                if MyPlot then

                    local Character = game.Players.LocalPlayer.Character
                    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                    if HRP then

                        for floorIndex = 1, 50 do

                            if not AutoFeed then
                                break
                            end

                            local Floor = MyPlot:FindFirstChild("Floor" .. floorIndex)

                            if not Floor then
                                break
                            end

                            if isExcluded(Floor.Name) then
                                continue
                            end

                            for _, obj in ipairs(Floor:GetDescendants()) do

                                if not AutoFeed then
                                    break
                                end

                                if obj:IsA("ProximityPrompt")
                                and obj.Name == "PickupPrompt" then

                                    local Cow = obj:FindFirstAncestorOfClass("Model")

                                    if Cow
                                    and Cow.Name:match("^Cow_")
                                    and CowNeedsFood(Cow) then

                                        -- teleport cepat
                                        HRP.CFrame = Cow:GetPivot()

                                        task.wait(0.15)

                                        pcall(function()
                                            obj.HoldDuration = 0
                                            obj.RequiresLineOfSight = false
                                            obj.MaxActivationDistance = 10
                                        end)

                                        -- trigger prompt
                                        firePrompt(obj)

                                        task.wait(0.15)
                                    end
                                end
                            end
                        end
                    end
                end

                -- jeda sebelum scan ulang
                task.wait(2)
            end
        end)
    end
})

local AutoFeedManual = false
local FedCache = {}

MainTab:Toggle({
    Title = "Auto Feed Manual",
    Default = false,
    Callback = function(Value)
        AutoFeedManual = Value

        if not Value then
            table.clear(FedCache)
            return
        end

        task.spawn(function()

            while AutoFeedManual do

                local MyPlot = GetMyPlot()

                if MyPlot then

                    local Character = LocalPlayer.Character
                    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                    if HRP then

                        for _, obj in ipairs(MyPlot:GetDescendants()) do

                            if obj:IsA("ProximityPrompt")
                            and obj.Name == "PickupPrompt" then

                                local Cow = obj:FindFirstAncestorOfClass("Model")

                                if Cow
                                and Cow.Name:match("^Cow_")
                                and CowNeedsFood(Cow)
                                and not FedCache[Cow] then

                                    local PromptPart = obj.Parent

                                    if PromptPart
                                    and PromptPart:IsA("BasePart")
                                    and (HRP.Position - PromptPart.Position).Magnitude <= 10 then

                                        obj.HoldDuration = 0
                                        obj.RequiresLineOfSight = false
                                        obj.MaxActivationDistance = 10

                                        FedCache[Cow] = true
                                        firePrompt(obj)
                                    end
                                end
                            end
                        end
                    end
                end

                -- reset cache kalau sapi lapar lagi
                for Cow in pairs(FedCache) do
                    if not Cow or not Cow.Parent or CowNeedsFood(Cow) then
                        FedCache[Cow] = nil
                    end
                end

                task.wait(1)
            end
        end)
    end
})

--------------------------------------------------
-- PLAYER ESP (TRACER + DISTANCE)
--------------------------------------------------

local ESPEnabled = false
local ESPObjects = {}

local function RemoveESP()
    for _, ESP in pairs(ESPObjects) do
        pcall(function()
            if ESP.Line then
                ESP.Line:Remove()
            end

            if ESP.Text then
                ESP.Text:Remove()
            end
        end)
    end

    table.clear(ESPObjects)
end

Players.PlayerRemoving:Connect(function(Player)

    local ESP = ESPObjects[Player]

    if ESP then

        pcall(function()
            ESP.Line:Remove()
            ESP.Text:Remove()
        end)

        ESPObjects[Player] = nil
    end
end)

MainTab:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(Value)

        ESPEnabled = Value

        if not Value then
            RemoveESP()
            return
        end

        task.spawn(function()

            while ESPEnabled do

                local MyCharacter = LocalPlayer.Character
                local MyHRP = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")

                if MyHRP then

                    local MyPos = Camera:WorldToViewportPoint(MyHRP.Position)

                    for _, Player in ipairs(Players:GetPlayers()) do

                        if Player ~= LocalPlayer then

                            local Character = Player.Character
                            local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                            if HRP then

                                if not ESPObjects[Player] then

                                    local Line = Drawing.new("Line")
                                    Line.Thickness = 1.5
                                    Line.Color = Color3.fromRGB(255,255,255)
                                    Line.Transparency = 1

                                    local Text = Drawing.new("Text")
                                    Text.Size = 14
                                    Text.Center = true
                                    Text.Outline = true
                                    Text.Color = Color3.fromRGB(255,255,255)

                                    ESPObjects[Player] = {
                                        Line = Line,
                                        Text = Text
                                    }
                                end

                                local ESP = ESPObjects[Player]

                                local RootPos = Camera:WorldToViewportPoint(HRP.Position)

                                local ScreenSize = Camera.ViewportSize

                                local X = math.clamp(
                                    RootPos.X,
                                    0,
                                    ScreenSize.X
                                )

                                local Y = math.clamp(
                                    RootPos.Y,
                                    0,
                                    ScreenSize.Y
                                )

                                local Distance = math.floor(
                                    (MyHRP.Position - HRP.Position).Magnitude
                                )

                                ESP.Line.From = Vector2.new(
                                    MyPos.X,
                                    MyPos.Y
                                )

                                ESP.Line.To = Vector2.new(
                                    X,
                                    Y
                                )

                                ESP.Line.Visible = true

                                ESP.Text.Text =
                                    Player.Name ..
                                    " [" .. Distance .. " studs]"

                                ESP.Text.Position = Vector2.new(
                                    X,
                                    Y - 18
                                )

                                ESP.Text.Visible = true

                            else

                                if ESPObjects[Player] then
                                    ESPObjects[Player].Line.Visible = false
                                    ESPObjects[Player].Text.Visible = false
                                end
                            end
                        end
                    end
                end

                task.wait()
            end

            RemoveESP()
        end)
    end
})

--------------------------------------------------
-- CHEST ESP
--------------------------------------------------

local ChestESP = false
local ChestESPObjects = {}

local function ClearChestESP()
    for _, ESP in pairs(ChestESPObjects) do
        pcall(function()
            ESP.Line:Remove()
            ESP.Text:Remove()
        end)
    end

    table.clear(ChestESPObjects)
end

MainTab:Toggle({
    Title = "Chest ESP",
    Default = false,
    Callback = function(Value)

        ChestESP = Value

        if not Value then
            ClearChestESP()
            return
        end

        task.spawn(function()

            while ChestESP do

                local Character = LocalPlayer.Character
                local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                if HRP then

                    local MyPos = Camera:WorldToViewportPoint(HRP.Position)

                    local ChestFolder = workspace:FindFirstChild("ChestSpawns")

                    if ChestFolder then

                        for _, Chest in ipairs(ChestFolder:GetChildren()) do

                            local Prompt = Chest:FindFirstChild("ChestPrompt")

                            if Prompt then

                                if not ChestESPObjects[Chest] then

                                    local Line = Drawing.new("Line")
                                    Line.Thickness = 1.5
                                    Line.Color = Color3.fromRGB(255, 0, 0)
                                    Line.Transparency = 1

                                    local Text = Drawing.new("Text")
                                    Text.Size = 14
                                    Text.Center = true
                                    Text.Outline = true
                                    Text.Color = Color3.fromRGB(255, 0, 0)

                                    ChestESPObjects[Chest] = {
                                        Line = Line,
                                        Text = Text
                                    }
                                end

                                local ESP = ChestESPObjects[Chest]

                                local ChestPos = Chest:GetPivot().Position

                                local ScreenPos, Visible =
                                    Camera:WorldToViewportPoint(ChestPos)

                                local Distance = math.floor(
                                    (HRP.Position - ChestPos).Magnitude
                                )

                                ESP.Line.From = Vector2.new(
                                    MyPos.X,
                                    MyPos.Y
                                )

                                ESP.Line.To = Vector2.new(
                                    ScreenPos.X,
                                    ScreenPos.Y
                                )

                                ESP.Line.Visible = true

                                ESP.Text.Text =
                                    "Chest [" .. Distance .. "]"

                                ESP.Text.Position = Vector2.new(
                                    ScreenPos.X,
                                    ScreenPos.Y - 18
                                )

                                ESP.Text.Visible = Visible

                            elseif ChestESPObjects[Chest] then

                                ChestESPObjects[Chest].Line.Visible = false
                                ChestESPObjects[Chest].Text.Visible = false
                            end
                        end

                        -- cleanup chest yg hilang
                        for Chest, ESP in pairs(ChestESPObjects) do
                            if not Chest or not Chest.Parent then

                                ESP.Line:Remove()
                                ESP.Text:Remove()

                                ChestESPObjects[Chest] = nil
                            end
                        end
                    end
                end

                task.wait()
            end

            ClearChestESP()
        end)
    end
})

MainTab:Button({
    Title = "Teleport To Chest (Instant)",
    Callback = function()

        local Character = LocalPlayer.Character
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HRP then return end

        local ChestFolder = workspace:FindFirstChild("ChestSpawns")
        if not ChestFolder then return end

        local ClosestChest = nil
        local ClosestDistance = math.huge

        -- cari chest aktif (punya ChestPrompt)
        for _, Chest in ipairs(ChestFolder:GetChildren()) do
            local Prompt = Chest:FindFirstChild("ChestPrompt")

            if Prompt then
                local Pos = Chest:GetPivot().Position
                local Dist = (HRP.Position - Pos).Magnitude

                if Dist < ClosestDistance then
                    ClosestDistance = Dist
                    ClosestChest = Chest
                end
            end
        end

        if not ClosestChest then
            WindUI:Notify({
                Title = "Chest",
                Content = "No active chest found",
                Duration = 3
            })
            return
        end

        -- teleport
        HRP.CFrame = ClosestChest:GetPivot() + Vector3.new(0, 3, 0)

        task.wait(0.15) -- kasih waktu render setelah teleport

        local Prompt = ClosestChest:FindFirstChild("ChestPrompt", true)

        if Prompt then

            Prompt.HoldDuration = 0
            Prompt.RequiresLineOfSight = false
            Prompt.MaxActivationDistance = 999

            task.wait() -- 1 frame extra stabilisasi

            pcall(function()
                if fireproximityprompt then
                    fireproximityprompt(Prompt)
                else
                    Prompt:InputHoldBegin()
                    task.wait()
                    Prompt:InputHoldEnd()
                end
            end)
        end

        WindUI:Notify({
            Title = "Success",
            Content = "Teleported & opened chest instantly",
            Duration = 3
        })

    end
})

local AutoChest = false

MainTab:Toggle({
    Title = "Auto Chest (Fast)",
    Default = false,
    Callback = function(Value)

        AutoChest = Value

        if not Value then return end

        task.spawn(function()

            while AutoChest do

                local Character = LocalPlayer.Character
                local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                if HRP then

                    local ChestFolder = workspace:FindFirstChild("ChestSpawns")

                    if ChestFolder then

                        for _, Chest in ipairs(ChestFolder:GetChildren()) do

                            if not AutoChest then break end

                            local Prompt = Chest:FindFirstChild("ChestPrompt", true)

                            if Prompt then

                                local Pos = Chest:GetPivot().Position

                                -- teleport "silent" (no delay feel)
                                HRP.CFrame = CFrame.new(Pos + Vector3.new(0, 2, 0))

                                -- kecil delay biar server register
                                task.wait(0.25)

                                pcall(function()
                                    Prompt.HoldDuration = 0
                                    Prompt.RequiresLineOfSight = false
                                    Prompt.MaxActivationDistance = 10

                                    if fireproximityprompt then
                                        fireproximityprompt(Prompt)
                                    else
                                        Prompt:InputHoldBegin()
                                        Prompt:InputHoldEnd()
                                    end
                                end)

                                task.wait(0.05) -- super fast loop
                            end
                        end
                    end
                end

                task.wait(0.1)
            end
        end)
    end
})

--------------------------------------------------
-- AUTO BUY EGG
--------------------------------------------------
local AutoBuyEgg = false
local SelectedEggs = {}

MainTab:Dropdown({
    Title = "Select Eggs",
    Multi = true,
    AllowNone = true,

    Values = {
        "Fruit",
        "IceCream",
        "Alien",
        "Dino",
        "Foodie",
        "Robot",
    },

    Value = {"Robot"},

    Callback = function(Value)
        SelectedEggs = Value or {}
    end
})

MainTab:Toggle({
    Title = "Auto Buy Egg",
    Default = false,
    Callback = function(Value)

        AutoBuyEgg = Value

        if not Value then
            return
        end

        task.spawn(function()

            local HatchRemote = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes")
                :WaitForChild("HatchEgg")

            local PlayerGui = game:GetService("Players")
                .LocalPlayer
                :WaitForChild("PlayerGui")

            while AutoBuyEgg do

                for _, EggName in ipairs(SelectedEggs) do

                    pcall(function()

                        local EggFrame = PlayerGui
                            .EggShopGui
                            .Frame
                            .Holder
                            .ScrollingFrame
                            :FindFirstChild("Egg_" .. EggName)

                        if not EggFrame then
                            return
                        end

                        local StockLabel =
                            EggFrame:FindFirstChild("StockLabel")

                        if not StockLabel then
                            return
                        end

                        local Stock =
                            tonumber(
                                StockLabel.Text:match(
                                    "Remaining:%s*(%d+)"
                                )
                            ) or 0

                        if Stock > 0 then

                            HatchRemote:InvokeServer(
                                EggName,
                                9999
                            )

                            print(
                                "[AUTO BUY]",
                                EggName,
                                "| Remaining:",
                                Stock
                            )
                        end

                    end)

                    task.wait(0.1)
                end

                task.wait(1)
            end
        end)
    end
})
