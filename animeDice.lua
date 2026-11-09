--// Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

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

--// Referensi Remote (Menggunakan pcall/aman dari nil)
local collectBalanceRE, rollDiceRF
pcall(function()
    collectBalanceRE = ReplicatedStorage:WaitForChild("Network", 5):WaitForChild("PlotService", 5):WaitForChild("RE", 5):WaitForChild("CollectBalance", 5)
    rollDiceRF = ReplicatedStorage:WaitForChild("Network", 5):WaitForChild("RollService", 5):WaitForChild("RF", 5):WaitForChild("RollDice", 5)
end)

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

MainTab:Toggle({
    Title = "Auto Collect Balance (15s Delay)",
    Default = false,
    Callback = function(Value)
        _G.AutoCollect = Value
        if Value then
            task.spawn(function()
                while _G.AutoCollect do
                    pcall(function()
                        if collectBalanceRE then
                            for i = 1, 13 do
                                collectBalanceRE:FireServer(i)
                            end
                        end
                    end)
                    task.wait(15)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "Auto Roll Dice",
    Default = false,
    Callback = function(Value)
        _G.AutoRoll = Value
        if Value then
            task.spawn(function()
                while _G.AutoRoll do
                    pcall(function()
                        if rollDiceRF then
                            rollDiceRF:InvokeServer()
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "Auto Walk to Apple",
    Default = false,
    Callback = function(Value)
        _G.AutoWalkApple = Value
        if Value then
            task.spawn(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = char:WaitForChild("Humanoid")
                local rootPart = char:WaitForChild("HumanoidRootPart")

                while _G.AutoWalkApple do
                    pcall(function()
                        local applesFolder = Workspace:FindFirstChild("AutumnApples")
                        if applesFolder then
                            for _, obj in ipairs(applesFolder:GetChildren()) do
                                if not _G.AutoWalkApple then break end
                                
                                if obj.Name:sub(1, 6) == "Apple_" then
                                    local targetPos = nil
                                    if obj:IsA("BasePart") then
                                        targetPos = obj.Position
                                    elseif obj:IsA("Model") and obj.PrimaryPart then
                                        targetPos = obj.PrimaryPart.Position
                                    elseif obj:IsA("Model") then
                                        local part = obj:FindFirstChildWhichIsA("BasePart")
                                        if part then targetPos = part.Position end
                                    end

                                    if targetPos then
                                        humanoid:MoveTo(targetPos)
                                        local startTime = tick()
                                        repeat
                                            task.wait(0.1)
                                        until (rootPart.Position - targetPos).Magnitude < 4 or not _G.AutoWalkApple or (tick() - startTime) > 3
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})
