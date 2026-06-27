-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/HatchCowChestOnly.lua"))()

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

local CowIcons = require(game:GetService("ReplicatedStorage")
    :WaitForChild("Modules")
    :WaitForChild("CowIcons")
)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Inventory = LocalPlayer.PlayerGui
    :WaitForChild("BackpackGui")
    :WaitForChild("Backpack")
    :WaitForChild("Inventory")
    :WaitForChild("list")

--------------------------------------------------
-- CACHE (biar lebih cepat dari looping pairs tiap render)
--------------------------------------------------
local ImageToName = {}

for name, id in pairs(CowIcons) do
    ImageToName[id] = name
end

--------------------------------------------------
-- BLACKLIST (hapus fake item kayak Bob)
--------------------------------------------------
local Blacklist = {
    Bob = true
}

--------------------------------------------------
-- UI
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InventoryViewer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 340, 0, 430)
Frame.Position = UDim2.new(0, 20, 0.5, -215)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame)

local UIS = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.Parent = Frame

Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Inventory Viewer"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Header

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -40)
Scroll.Position = UDim2.new(0, 10, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.Parent = Frame

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 4)


local function update(input)
    local delta = input.Position - dragStart

    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)
--------------------------------------------------
-- DATA COLLECT
--------------------------------------------------
local function getData()

    local data = {}
    local total = 0

    for _, cow in ipairs(Inventory:GetChildren()) do

        local img = cow:FindFirstChild("CowImage")

        if img then
            local name = ImageToName[img.Image]

            if name and not Blacklist[name] then

                data[name] = data[name] or {Normal = 0, Baby = 0}

                local scale = img.Size.X.Scale

                if math.abs(scale - 0.7) < 0.01 then
                    data[name].Baby += 1
                else
                    data[name].Normal += 1
                end

                total += 1
            end
        end
    end

    return data, total
end

--------------------------------------------------
-- RENDER
--------------------------------------------------
local function render()

    for _, v in ipairs(Scroll:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end

    local data, total = getData()

    -- header total
    local totalLabel = Instance.new("TextLabel")
    totalLabel.Size = UDim2.new(1, -10, 0, 25)
    totalLabel.BackgroundTransparency = 1
    totalLabel.TextXAlignment = Enum.TextXAlignment.Left
    totalLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
    totalLabel.Font = Enum.Font.GothamBold
    totalLabel.TextSize = 14
    totalLabel.Text = "Total Cows: " .. total
    totalLabel.Parent = Scroll

    -- sorting biar rapi (terbanyak di atas)
    local sorted = {}

    for name, v in pairs(data) do
        table.insert(sorted, {
            name = name,
            total = v.Normal + v.Baby,
            Normal = v.Normal,
            Baby = v.Baby
        })
    end

    table.sort(sorted, function(a,b)
        return a.total > b.total
    end)

    for _, v in ipairs(sorted) do

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 24)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14

        label.Text = string.format(
            "▸ %s | N:%d B:%d",
            v.name,
            v.Normal,
            v.Baby
        )

        label.Parent = Scroll
    end

    task.wait()
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
end

--------------------------------------------------
-- LOOP UPDATE (lebih ringan + no spam render)
--------------------------------------------------
task.spawn(function()
    while true do
        if ScreenGui.Enabled then
            pcall(render)
        end
        task.wait(1)
    end
end)


--// TAB MAIN
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.home
})

MainTab:Select()

MainTab:Toggle({
    Title = "Show Inventory",
    Default = false,
    Callback = function(value)
        ScreenGui.Enabled = value
    end
})


--------------------------------------------------
-- AUTO ROLL (ADMIN EGG BOOST ONLY)
--------------------------------------------------

local AutoRoll = false
local Rolling = false
local LastFinish = 0
local Cooldown = 180 -- 3 menit

local AutoAdminToggle = MainTab:Toggle({
    Title = "Auto Roll Admin Egg Boost",
    Default = false,
    Callback = function(Value)

        AutoRoll = Value

        if not Value then
            Rolling = false
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

                    local CurrentEvent = TitleLabel.Text

                    if CurrentEvent == "Admin Egg Boost"
                    and not Rolling
                    and (tick() - LastFinish >= Cooldown) then

                        Rolling = true

                        print("[AUTO ROLL] Admin Egg Boost detected -> Rolling for 2 minutes")

                        local EndTime = tick() + 120 -- 2 menit

                        while AutoRoll and tick() < EndTime do

                            pcall(function()

                                GetSpinState:InvokeServer()
                                SpinRequest:InvokeServer()
                                ClaimSpinResult:InvokeServer()

                            end)

                            task.wait()
                        end

                        LastFinish = tick()
                        Rolling = false

                        print("[AUTO ROLL] Finished -> Cooldown 3 minutes")
                    end

                end)

                task.wait(1)
            end
        end)
    end
})


local AutoChest = false
local CurrentCapybara = nil

-- Detect Capybara spawn/despawn
workspace.ChildAdded:Connect(function(obj)
    if obj.Name == "Capybara" and obj:IsA("Model") then
        CurrentCapybara = obj
        print("[CAPYBARA] Spawn detected")
    end
end)

workspace.ChildRemoved:Connect(function(obj)
    if obj == CurrentCapybara then
        CurrentCapybara = nil
        print("[CAPYBARA] Removed")
    end
end)

-- Kalau pas script start Capybara sudah ada
local ExistingCapybara = workspace:FindFirstChild("Capybara")
if ExistingCapybara and ExistingCapybara:IsA("Model") then
    CurrentCapybara = ExistingCapybara
end

local AutoChestToggle = MainTab:Toggle({
    Title = "Auto Chest (Fast)",
    Default = false,
    Callback = function(Value)

        AutoChest = Value

        if not Value then
            return
        end

        task.spawn(function()

            while AutoChest do

                if Rolling then
                    task.wait(1)
                    continue
                end

                local Character = LocalPlayer.Character
                local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                if HRP then

                    --------------------------------------------------
                    -- PRIORITAS CAPYBARA
                    --------------------------------------------------
                    if CurrentCapybara and CurrentCapybara.Parent then

                        local Prompt = CurrentCapybara:FindFirstChildWhichIsA(
                            "ProximityPrompt",
                            true
                        )

                        if Prompt then

                            local Pos = CurrentCapybara:GetPivot().Position

                            HRP.CFrame = CFrame.new(Pos + Vector3.new(0,2,0))

                            task.wait(0.15)

                            pcall(function()

                                Prompt.HoldDuration = 0
                                Prompt.RequiresLineOfSight = false
                                Prompt.MaxActivationDistance = 20

                                if fireproximityprompt then
                                    fireproximityprompt(Prompt)
                                else
                                    Prompt:InputHoldBegin()
                                    Prompt:InputHoldEnd()
                                end

                            end)

                            task.wait(0.5)
                        end

                        continue
                    end

                    --------------------------------------------------
                    -- AUTO CHEST
                    --------------------------------------------------
                    local ChestFolder = workspace:FindFirstChild("ChestSpawns")

                    if ChestFolder then

                        for _, Chest in ipairs(ChestFolder:GetChildren()) do

                            if not AutoChest then
                                break
                            end

                            if Rolling then
                                break
                            end

                            -- Kalau Capybara muncul saat lagi chest
                            if CurrentCapybara then
                                break
                            end

                            local Prompt = Chest:FindFirstChild(
                                "ChestPrompt",
                                true
                            )

                            if Prompt then

                                local Pos = Chest:GetPivot().Position

                                HRP.CFrame = CFrame.new(
                                    Pos + Vector3.new(0,2,0)
                                )

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
                            end
                        end
                    end
                end

                task.wait()
            end
        end)
    end
})



--------------------------------------------------
-- FPS BOOST
--------------------------------------------------
local FPSBoost = false

local FPS = MainTab:Toggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(Value)
        FPSBoost = Value

        if not Value then
            return
        end

        task.spawn(function()
		
			pcall(function()
				local MiddlePath = workspace:FindFirstChild("MiddlePath")

				if MiddlePath then
					for _, v in ipairs(MiddlePath:GetChildren()) do
						if v.Name ~= "Center" then
							v:Destroy()
						end
					end

					local Center = MiddlePath:FindFirstChild("Center")
					if Center then
						for _, v in ipairs(Center:GetChildren()) do
							if v.Name ~= "SpinWheel" then
								v:Destroy()
							end
						end
					end
				end

				local Environment = workspace:FindFirstChild("Environment")

				if Environment then
					for _, v in ipairs(Environment:GetChildren()) do
						if v.Name == "Filler" then
							v:Destroy()
						end
					end
				end

                local Rocks = workspace.Environment:FindFirstChild("Rocks")
                if Rocks then
                    Rocks:ClearAllChildren()
                end

                local Trees = workspace.Environment:FindFirstChild("Trees")
                if Trees then
                    Trees:ClearAllChildren()
                end

				local CropShop = workspace:FindFirstChild("CropShop")
				if CropShop then
					CropShop:Destroy()
				end

				local Barn = workspace:FindFirstChild("Barn")
				if Barn then
					Barn:Destroy()
				end

				local LeaderBoardsv2 = workspace:FindFirstChild("LeaderBoardsv2")
				if LeaderBoardsv2 then
					LeaderBoardsv2:ClearAllChildren() -- atau :Destroy()
				end

				local Plots = workspace:FindFirstChild("Plots")
				if Plots then
					for _, plot in ipairs(Plots:GetChildren()) do
						plot:Destroy()
					end
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

task.defer(function()
    AutoChestToggle:Set(true) -- tambah ini
	AutoAdminToggle:Set(true)
	FPS:Set(false)
end)

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
