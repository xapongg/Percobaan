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
