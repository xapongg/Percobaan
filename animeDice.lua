-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xapongg/Percobaan/refs/heads/main/animeDice.lua"))()

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
                            for i = 1, 24 do
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

MainTab:Section({
    Title = "Auto Rolls",
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

--// Referensi Remote Leaf Dice (Taruh bersama remote lainnya)
local leafDiceRollRF
pcall(function()
	leafDiceRollRF = ReplicatedStorage:WaitForChild("Network", 5)
		:WaitForChild("LeafDiceService", 5)
		:WaitForChild("RF", 5)
		:WaitForChild("Roll", 5)
end)

--// Toggle Auto Leaf Dice (Taruh di dalam Tab / Section)
MainTab:Toggle({
	Title = "Auto Leaf Dice (5)",
	Default = false,
	Callback = function(Value)
		_G.AutoLeafDice = Value
		if Value then
			task.spawn(function()
				while _G.AutoLeafDice do
					pcall(function()
						if leafDiceRollRF then
							leafDiceRollRF:InvokeServer(5)
						end
					end)
					task.wait(0.1)
				end
			end)
		end
	end
})

MainTab:Section({
    Title = "Events",
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


MainTab:Section({
    Title = "Level Up Unit",
})

--// Referensi Remote Level Up Slot (Taruh bersama remote lainnya)
local levelUpSlotRE
pcall(function()
	levelUpSlotRE = ReplicatedStorage:WaitForChild("Network", 5)
		:WaitForChild("PlotService", 5)
		:WaitForChild("RE", 5)
		:WaitForChild("LevelUpSlot", 5)
end)

--// Helper: Cari plot milik LocalPlayer berdasarkan PlayerName
local function getOwnedPlot()
	local plotsFolder = workspace:FindFirstChild("Plots")
	local claimedFolder = plotsFolder and plotsFolder:FindFirstChild("Claimed")
	if not claimedFolder then
		return nil
	end

	for _, plot in ipairs(claimedFolder:GetChildren()) do
		local label = plot:FindFirstChild("Label")
		local billboard = label and label:FindFirstChild("BillboardGui")
		local playerNameLabel = billboard and billboard:FindFirstChild("PlayerName")

		if playerNameLabel and (playerNameLabel:IsA("TextLabel") or playerNameLabel:IsA("TextBox")) then
			local txt = playerNameLabel.Text
			if txt == LocalPlayer.DisplayName or txt == LocalPlayer.Name then
				return plot
			end
		end
	end

	return nil
end

--// Helper: Parse level saat ini dari teks "Lvl 100 > 101"
local function getSlotCurrentLevel(slot)
	local upgrade = slot:FindFirstChild("Upgrade")
	local board = upgrade and upgrade:FindFirstChild("Board")
	local surfaceGui = board and board:FindFirstChild("SurfaceGui")
	local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
	local levelLabel = frame and frame:FindFirstChild("Level")

	if levelLabel and (levelLabel:IsA("TextLabel") or levelLabel:IsA("TextBox")) then
		local currentLvl = tonumber(levelLabel.Text:match("Lvl%s*(%d+)"))
		return currentLvl
	end

	return nil
end

--// State Slider & Toggle
local TargetSlotLevel = 15
_G.AutoLevelUpSlot = false

MainTab:Slider({
	Title = "Target Slot Level",
	Step = 5,
	Value = {
		Min = 15,
		Max = 125,
		Default = 15,
	},
	Callback = function(Value)
		TargetSlotLevel = tonumber(Value) or 15
	end
})

MainTab:Toggle({
	Title = "Auto Level Up Slots",
	Default = false,
	Callback = function(Value)
		_G.AutoLevelUpSlot = Value
		if Value then
			task.spawn(function()
				while _G.AutoLevelUpSlot do
					pcall(function()
						if not levelUpSlotRE then return end

						local ownedPlot = getOwnedPlot()
						local slotsFolder = ownedPlot and ownedPlot:FindFirstChild("Slots")
						if not slotsFolder then return end

						for _, slot in ipairs(slotsFolder:GetChildren()) do
							if not _G.AutoLevelUpSlot then break end

							local slotNum = tonumber(slot.Name)
							local currentLvl = getSlotCurrentLevel(slot)

							if slotNum and currentLvl and currentLvl < TargetSlotLevel then
								levelUpSlotRE:FireServer(slotNum)
								task.wait(0.05)
							end
						end
					end)
					task.wait(0.3)
				end
			end)
		end
	end
})



--// Referensi Remote Shop (Taruh di bagian atas bersama remote lainnya)
local buyRF
pcall(function()
    buyRF = ReplicatedStorage:WaitForChild("Network", 5):WaitForChild("AppleShopService", 5):WaitForChild("RF", 5):WaitForChild("Buy", 5)
end)

--// Daftar Semua Item
local AllItemsList = { 
    "Apple Juice III", 
    "Orchard Luck III", 
    "Maple Syrup III", 
    "Acorn Luck II", 
    "Harvest Luck II", 
    "Golden Harvest II", 
    "Leaf Feast II" 
}

--// Agar langsung otomatis terpilih semua saat pertama kali dimuat
local SelectedItems = {}
for _, item in ipairs(AllItemsList) do
    table.insert(SelectedItems, item)
end

--// Bagian Section & Komponen GUI (Taruh di dalam Tab utama Anda)
MainTab:Section({
    Title = "Shop Automation",
})

MainTab:Dropdown({
    Title = "Select Items to Buy",
    Desc = "Pilih item yang ingin dibeli (Otomatis terpilih semua).",
    Values = AllItemsList,
    Multi = true, 
    Default = SelectedItems, -- Otomatis ter-check semua dari awal
    Callback = function(Options)
        SelectedItems = Options
    end
})

MainTab:Toggle({
    Title = "Auto Buy Selected Items (Fast)",
    Default = false,
    Callback = function(Value)
        _G.AutoBuySelected = Value
        if Value then
            task.spawn(function()
                while _G.AutoBuySelected do
                    pcall(function()
                        if buyRF and SelectedItems then
                            for _, itemName in pairs(SelectedItems) do
                                if not _G.AutoBuySelected then break end
                                -- Mengirim request beli secara langsung tanpa jeda per item
                                buyRF:InvokeServer(itemName)
                            end
                        end
                    end)
                    -- Jeda antar putaran loop besar dipercepat jadi 0.2 detik saja (atau task.wait() jika ingin terus menerus)
                    task.wait(0.07) 
                end
            end)
        end
    end
})

local PotionTab = Window:Tab({
    Title = "Potion",
    Icon = Icons.home
})

PotionTab:Button({
	Title = "Fuse All Potion",
	Desc = "Fuse semua potion berdasarkan ImageLabel & qty di Backpack.",
	Callback = function()
		task.spawn(function()
			pcall(function()
				local fuseRF = ReplicatedStorage:WaitForChild("Network", 5)
					:WaitForChild("PotionFusingService", 5)
					:WaitForChild("RF", 5)
					:WaitForChild("Fuse", 5)
				if not fuseRF then
					WindUI:Notify({
						Title = "Fuse All Potion",
						Content = "Remote PotionFusingService tidak ditemukan.",
						Icon = "rbxassetid://135878568033396",
						Duration = 4,
					})
					return
				end

				-- Mapping rbxassetid -> Nama Potion (aman tanpa require module server)
				local imageToPotion = {
					-- Luck
					["rbxassetid://93245201833668"] = "Luck I",
					["rbxassetid://85698878401581"] = "Luck II",
					["rbxassetid://91965171788183"] = "Luck III",
					["rbxassetid://117963596381615"] = "Luck IV",
					-- Damage
					["rbxassetid://124596070717233"] = "Damage I",
					["rbxassetid://70584782547968"] = "Damage II",
					["rbxassetid://111302231084388"] = "Damage III",
					["rbxassetid://123724570204292"] = "Damage IV",
					-- Income
					["rbxassetid://119991678124207"] = "Income I",
					["rbxassetid://75334053811561"] = "Income II",
					["rbxassetid://81194080706183"] = "Income III",
					["rbxassetid://115440267661902"] = "Income IV",
					-- Dragon Luck
					["rbxassetid://127826219882177"] = "Dragon Luck I",
					["rbxassetid://76446260762133"] = "Dragon Luck II",
					["rbxassetid://94752357346540"] = "Dragon Luck III",
					-- Dragon Income
					["rbxassetid://73628557029746"] = "Dragon Income I",
					["rbxassetid://103483997183139"] = "Dragon Income II",
					["rbxassetid://103787019330436"] = "Dragon Income III",
					-- Dragon Damage
					["rbxassetid://75201547247633"] = "Dragon Damage I",
					["rbxassetid://95966294229859"] = "Dragon Damage II",
					["rbxassetid://111136274425937"] = "Dragon Damage III",
					-- Cursed Luck
					["rbxassetid://71363822879198"] = "Cursed Luck I",
					["rbxassetid://80108808339087"] = "Cursed Luck II",
					["rbxassetid://80617638445046"] = "Cursed Luck III",
					-- Cursed Damage
					["rbxassetid://138644400139140"] = "Cursed Damage I",
					["rbxassetid://101378917658521"] = "Cursed Damage II",
					["rbxassetid://140479658091648"] = "Cursed Damage III",
					-- Cursed Income
					["rbxassetid://81413926887882"] = "Cursed Income I",
					["rbxassetid://130975380547694"] = "Cursed Income II",
					["rbxassetid://132395072084470"] = "Cursed Income III",
					-- Pirate Luck
					["rbxassetid://120218959260781"] = "Pirate Luck I",
					["rbxassetid://114152786488147"] = "Pirate Luck II",
					["rbxassetid://131126928757467"] = "Pirate Luck III",
					-- Pirate Damage
					["rbxassetid://111393119467456"] = "Pirate Damage I",
					["rbxassetid://139925991266253"] = "Pirate Damage II",
					["rbxassetid://125755237110851"] = "Pirate Damage III",
					-- Pirate Income
					["rbxassetid://126761542736591"] = "Pirate Income I",
					["rbxassetid://104499040058898"] = "Pirate Income II",
					["rbxassetid://79460260406522"] = "Pirate Income III",
					-- Leaf Luck
					["rbxassetid://128224106401932"] = "Leaf Luck I",
					["rbxassetid://83394624841645"] = "Leaf Luck II",
					["rbxassetid://81580939058227"] = "Leaf Luck III",
					-- Leaf Damage
					["rbxassetid://82779813256784"] = "Leaf Damage I",
					["rbxassetid://76470855803733"] = "Leaf Damage II",
					["rbxassetid://91092967304960"] = "Leaf Damage III",
					-- Leaf Income
					["rbxassetid://96180473071367"] = "Leaf Income I",
					["rbxassetid://140304666937111"] = "Leaf Income II",
					["rbxassetid://78711511658583"] = "Leaf Income III",
					-- Slayer Luck
					["rbxassetid://77267883920893"] = "Slayer Luck I",
					["rbxassetid://129476052656340"] = "Slayer Luck II",
					["rbxassetid://72267133850226"] = "Slayer Luck III",
					-- Slayer Damage
					["rbxassetid://73631942541117"] = "Slayer Damage I",
					["rbxassetid://133856085944183"] = "Slayer Damage II",
					["rbxassetid://92712726805446"] = "Slayer Damage III",
					-- Slayer Income
					["rbxassetid://128341202717589"] = "Slayer Income I",
					["rbxassetid://140071444582593"] = "Slayer Income II",
					["rbxassetid://80716128391703"] = "Slayer Income III",
					-- Shadow Luck
					["rbxassetid://117769392053142"] = "Shadow Luck I",
					["rbxassetid://132139828430156"] = "Shadow Luck II",
					["rbxassetid://79496251153007"] = "Shadow Luck III",
					["rbxassetid://129252630926495"] = "Shadow Luck IV",
					-- Shadow Speed
					["rbxassetid://109091214266675"] = "Shadow Speed I",
					["rbxassetid://98013255237329"] = "Shadow Speed II",
					["rbxassetid://72815005185910"] = "Shadow Speed III",
					["rbxassetid://71889551787507"] = "Shadow Speed IV",
					-- Shadow Income
					["rbxassetid://84632919658205"] = "Shadow Income I",
					["rbxassetid://73632570980831"] = "Shadow Income II",
					["rbxassetid://88956120242917"] = "Shadow Income III",
					["rbxassetid://135223442357884"] = "Shadow Income IV",
					-- Soul Luck
					["rbxassetid://79736706870257"] = "Soul Luck I",
					["rbxassetid://75485663422385"] = "Soul Luck II",
					["rbxassetid://131925838442541"] = "Soul Luck III",
					["rbxassetid://71772459921161"] = "Soul Luck IV",
					-- Soul Damage
					["rbxassetid://116336829837469"] = "Soul Damage I",
					["rbxassetid://111303620424320"] = "Soul Damage II",
					["rbxassetid://75814670476701"] = "Soul Damage III",
					["rbxassetid://132058488365078"] = "Soul Damage IV",
					-- Soul Income
					["rbxassetid://82390389237007"] = "Soul Income I",
					["rbxassetid://139933533695911"] = "Soul Income II",
					["rbxassetid://71128619176383"] = "Soul Income III",
					["rbxassetid://80367846313786"] = "Soul Income IV",
					-- Spooky Luck
					["rbxassetid://92343115732907"] = "Spooky Luck I",
					["rbxassetid://128124483478724"] = "Spooky Luck II",
					["rbxassetid://110689264512922"] = "Spooky Luck III",
				}

				local toRoman = { [1] = "I", [2] = "II", [3] = "III", [4] = "IV" }
				local fromRoman = { ["I"] = 1, ["II"] = 2, ["III"] = 3, ["IV"] = 4 }

				local scrolling = LocalPlayer:WaitForChild("PlayerGui")
					:WaitForChild("Root"):WaitForChild("Menus"):WaitForChild("Backpack")
					:WaitForChild("Items"):WaitForChild("ScrollingFrame")

				local ownedQty = {}

				for _, catFrame in ipairs(scrolling:GetChildren()) do
					if catFrame.Name:find("Potion") then
						local grid = catFrame:FindFirstChild("Grid")
						if grid then
							for _, entry in ipairs(grid:GetChildren()) do
								if entry:IsA("GuiObject") and entry.Visible then
									local imgLabel = entry:FindFirstChild("ImageLabel") or entry:FindFirstChildWhichIsA("ImageLabel", true)
									local numId = imgLabel and tostring(imgLabel.Image):match("(%d+)")
									local potionName = numId and imageToPotion["rbxassetid://" .. numId]

									if potionName then
										local topLabel = entry:FindFirstChild("TopLabel", true)
										local qty = 1
										if topLabel and (topLabel:IsA("TextLabel") or topLabel:IsA("TextBox")) then
											local parsed = tonumber(topLabel.Text:match("%d+"))
											if parsed then
												qty = parsed
											end
										end
										ownedQty[potionName] = (ownedQty[potionName] or 0) + qty
									end
								end
							end
						end
					end
				end

				local fuseCost = 5
				local payload = {}
				local totalCrafted = 0

				for tier = 1, 3 do
					for name, qty in pairs(ownedQty) do
						local baseName, roman = name:match("^(.-)%s+([IV]+)$")
						if baseName and roman and fromRoman[roman] == tier then
							local craftCount = math.floor(qty / fuseCost)
							if craftCount >= 1 and toRoman[tier + 1] then
								local nextName = baseName .. " " .. toRoman[tier + 1]
								payload[nextName] = (payload[nextName] or 0) + craftCount
								ownedQty[nextName] = (ownedQty[nextName] or 0) + craftCount
								totalCrafted = totalCrafted + craftCount
							end
						end
					end
				end

				if next(payload) ~= nil then
					fuseRF:InvokeServer(payload)
					WindUI:Notify({
						Title = "Fuse All Potion",
						Content = "Selesai! Berhasil fuse " .. tostring(totalCrafted) .. " potion.",
						Icon = "rbxassetid://135878568033396",
						Duration = 4,
					})
				else
					WindUI:Notify({
						Title = "Fuse All Potion",
						Content = "Tidak ada potion yang cukup untuk di-fuse.",
						Icon = "rbxassetid://135878568033396",
						Duration = 4,
					})
				end
			end)
		end)
	end
})
