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
-- AUTO SPIN ROLL
--------------------------------------------------

local AutoSpinRoll = false

MainTab:Toggle({
    Title = "Auto Spin Roll",
    Default = false,
    Callback = function(Value)

        AutoSpinRoll = Value

        if not Value then
            return
        end

        task.spawn(function()

            local Remotes = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes")

            local GetSpinState = Remotes:WaitForChild("GetSpinState")
            local SpinRequest = Remotes:WaitForChild("SpinRequest")
            local ClaimSpinResult = Remotes:WaitForChild("ClaimSpinResult")

            while AutoSpinRoll do

                pcall(function()

                    -- 1. Refresh state
                    GetSpinState:InvokeServer()

                    task.wait()

                    -- 2. Roll
                    SpinRequest:InvokeServer()

                    task.wait()

                    -- 3. Claim result
                    ClaimSpinResult:InvokeServer()

                end)

                task.wait()
            end

        end)
    end
})




--------------------------------------------------
-- AUTO ROLL (ADMIN EGG BOOST ONLY)
--------------------------------------------------

local AutoRoll = false

MainTab:Toggle({
    Title = "Auto Roll Admin Egg Boost",
    Default = false,
    Callback = function(Value)

        AutoRoll = Value

        if not Value then
            return
        end

        task.spawn(function()

            local Remotes = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes")

            local GetSpinState = Remotes:WaitForChild("GetSpinState")
            local SpinRequest = Remotes:WaitForChild("SpinRequest")
            local ClaimSpinResult = Remotes:WaitForChild("ClaimSpinResult")

            local PlayerGui = game:GetService("Players")
                .LocalPlayer
                :WaitForChild("PlayerGui")

            while AutoRoll do

                pcall(function()

                    local TitleLabel = PlayerGui
                        :WaitForChild("MutationEventGui")
                        :WaitForChild("Holder")
                        :WaitForChild("TitleLabel")

                    if TitleLabel.Text == "Admin Egg Boost" then

                        -- 1. Refresh state
                        GetSpinState:InvokeServer()

                        task.wait()

                        -- 2. Roll
                        SpinRequest:InvokeServer()

                        task.wait()

                        -- 3. Claim result
                        ClaimSpinResult:InvokeServer()

                        print("[AUTO ROLL] Admin Egg Boost detected -> Rolling")
                    end

                end)

                task.wait()
            end
        end)
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
                                task.wait()

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

                                task.wait() -- super fast loop
                            end
                        end
                    end
                end

                task.wait()
            end
        end)
    end
})


local WebhookURL = "https://discord.com/api/webhooks/1498259284834779166/K6vk6z6p-BqWKapCqgjstB3In897U82O0xDmH58LQ5LwJc7diZGhaSHiHYrjzATHPuvJ"

local request =
    http_request or
    request or
    (syn and syn.request)

local Sent = false
local HttpService = game:GetService("HttpService")

task.spawn(function()

    while task.wait(3) do

        pcall(function()

            local TitleLabel = game:GetService("Players")
                .LocalPlayer
                .PlayerGui
                .MutationEventGui
                .Holder
                .TitleLabel

            local CurrentText = TitleLabel.Text

            if CurrentText == "Admin Egg Boost" and not Sent then

                Sent = true

                for i = 1, 3 do

                    request({
                        Url = WebhookURL,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json"
                        },
                        Body = HttpService:JSONEncode({
                            content =
                                "@everyone 🚨 " ..
                                CurrentText ..
                                " 🚨\n" ..
                                "Player: " .. game.Players.LocalPlayer.Name
                        })
                    })

                    task.wait(1)
                end

            elseif CurrentText ~= "Admin Egg Boost" then
                Sent = false
            end

        end)

    end

end)
