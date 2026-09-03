-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/sabungAyama.lua"))()

--// Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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


--// TAB MAIN
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.home
})

MainTab:Select()


--------------------------------------------------
--// AUTO CLAIM INCUBATOR (RANDOM 3 - 5 MENIT)
--------------------------------------------------
local AutoClaimIncubator = false

MainTab:Toggle({
    Title = "Auto Claim Incubator",
    Desc = "Otomatis claim incubator secara acak tiap 3-5 menit",
    Value = false,
    Callback = function(Value)
        AutoClaimIncubator = Value

        if AutoClaimIncubator then
            task.spawn(function()
                while AutoClaimIncubator do
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("IncubatorClaim"):InvokeServer()
                    end)

                    local randomDelay = math.random(180, 300)
                    task.wait(randomDelay)
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO TOUCH NEST EGG (FAST & CLOSEST DETECTOR)
--------------------------------------------------
local AutoTouchEgg = false

MainTab:Toggle({
    Title = "Auto Touch Nest Egg (Realtime)",
    Desc = "Touch NestEgg terdekat secara instan saat telur spawn",
    Value = false,
    Callback = function(Value)
        AutoTouchEgg = Value

        if AutoTouchEgg then
            task.spawn(function()
                while AutoTouchEgg do
                    pcall(function()
                        local nestEggsFolder = workspace:FindFirstChild("NestEggs")
                        local character = LocalPlayer.Character
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if nestEggsFolder and rootPart then
                            local closestEggPart = nil
                            local shortestDistance =20 -- Jarak maksimal 15 studs (hanya yang dekat)

                            for _, egg in ipairs(nestEggsFolder:GetChildren()) do
                                local eggPart = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart")
                                if eggPart then
                                    local dist = (rootPart.Position - eggPart.Position).Magnitude
                                    if dist <= shortestDistance then
                                        shortestDistance = dist
                                        closestEggPart = eggPart
                                    end
                                end
                            end

                            -- Jika menemukan telur di jarak dekat, langsung sentuh
                            if closestEggPart then
                                firetouchinterest(rootPart, closestEggPart, 0)
                                task.wait(0.02)
                                firetouchinterest(rootPart, closestEggPart, 1)
                            end
                        end
                    end)

                    -- Jeda mikro (0.1 detik) agar loop berjalan cepat merespon telur spawn tanpa bikin FPS drop
                    task.wait(1)
                end
            end)
        end
    end
})

--------------------------------------------------
--// AUTO SPAM LIVE UFO (STEALTH + AUTO RESET COOP)
--------------------------------------------------
local AutoSpamUFO = false

local function isLiveUFOActive()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    local eventChips = playerGui:FindFirstChild("EventChips")
    if not eventChips then return false end
    local frame = eventChips:FindFirstChild("Frame")
    if not frame then return false end
    local holder = frame:FindFirstChild("holder")
    if not holder then return false end
    local liveUfo = holder:FindFirstChild("live-ufo")
    if not liveUfo then return false end

    local timeLabel = liveUfo:FindFirstChild("time")
    if timeLabel and liveUfo.Visible then
        return true
    end
    return false
end

MainTab:Toggle({
    Title = "Auto Chaos (Live UFO)",
    Desc = "Spam remote chaos saat UFO ada, dan set 'coop' 1x saat UFO hilang",
    Value = false,
    Callback = function(Value)
        AutoSpamUFO = Value

        if AutoSpamUFO then
            task.spawn(function()
                local wasUfoActive = false

                while AutoSpamUFO do
                    if isLiveUFOActive() then
                        wasUfoActive = true
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetChickenOrder"):FireServer("chaos")
                        end)
                        task.wait(math.random(21, 35) / 10) 
                    else
                        if wasUfoActive then
                            wasUfoActive = false
                            pcall(function()
                                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetChickenOrder"):FireServer("coop")
                            end)
                        end
                        task.wait(1) 
                    end
                end
            end)
        end
    end
})
