--[[ SAMBUNG KATA ]]
-- Prevent re-execution
if _G.BeverlyHubUnload then
    pcall(function() _G.BeverlyHubUnload() end)
end

-- [[ LOAD ADONIS BYPASS DARI GITHUB ]]
pcall(function()
    local bypassURL = "https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua"
    local scriptContent = game:HttpGet(bypassURL, true)
    if scriptContent and #scriptContent > 0 then
        local fn, err = loadstring(scriptContent)
        if fn then
            fn()
            print("[BYPASS] Adonis bypass berhasil dimuat!")
        else
            warn("[BYPASS] Gagal compile bypass: " .. tostring(err))
        end
    else
        warn("[BYPASS] Gagal mengambil bypass dari URL")
    end
end)
task.wait(3) -- Tunggu bypass selesai ter-load (3 detik)

-- Loading screen
do
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    
    local loadScreen = Instance.new("ScreenGui", CoreGui)
    loadScreen.Name = "BEV_Loading"
    loadScreen.DisplayOrder = 99999
    loadScreen.IgnoreGuiInset = true -- Full screen 100%

    -- Background Full Hitam (Solid)
    local bg = Instance.new("Frame", loadScreen)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0

    -- Tulisan Utama
    local loadText = Instance.new("TextLabel", bg)
    loadText.Size = UDim2.new(1, 0, 0, 50)
    loadText.Position = UDim2.new(0, 0, 0.5, -30) 
    loadText.Text = "Solara & Xeno Not Supported | Velocity Semi-Supported"
    loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadText.BackgroundTransparency = 1
    loadText.Font = Enum.Font.GothamBold
    loadText.TextSize = 18 

    -- Efek Gleam (Cahaya Menyapu) untuk Teks Utama
    local gradient = Instance.new("UIGradient", loadText)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
    })
    gradient.Rotation = 35 
    gradient.Offset = Vector2.new(-1, 0)

    local textTweenInfo = TweenInfo.new(3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false)
    local gleamTween = TweenService:Create(gradient, textTweenInfo, {Offset = Vector2.new(1, 0)})
    gleamTween:Play()

    -- === PREMIUM LOADING BAR ===
    local barBg = Instance.new("Frame", bg)
    barBg.AnchorPoint = Vector2.new(0.5, 0.5)
    barBg.Position = UDim2.new(0.5, 0, 0.5, 20)
    barBg.Size = UDim2.new(0, 220, 0, 2)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barFill.BorderSizePixel = 0
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    -- Animasi pergerakan Loading Bar (Durasi 4 detik)
    local barTweenInfo = TweenInfo.new(4.0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local barTween = TweenService:Create(barFill, barTweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    barTween:Play()

    -- === STATUS TEXT (Loading Up -> Loaded) ===
    local statusText = Instance.new("TextLabel", bg)
    statusText.AnchorPoint = Vector2.new(0.5, 0.5)
    statusText.Position = UDim2.new(0.5, 0, 0.5, 45) -- Posisinya di bawah bar
    statusText.Size = UDim2.new(0, 200, 0, 20)
    statusText.Text = "Beverly Hub Loading Up..."
    statusText.TextColor3 = Color3.fromRGB(150, 150, 150) -- Abu-abu elegan
    statusText.BackgroundTransparency = 1
    statusText.Font = Enum.Font.GothamMedium
    statusText.TextSize = 12

    -- Tunggu sampai bar hampir penuh (4 detik)
    task.wait(4.0)

    -- Animasi Fade Down (Menghilang & Turun)
    local fadeOutInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local fadeOutTween = TweenService:Create(statusText, fadeOutInfo, {
        TextTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 55) -- Turun 10 pixel
    })
    fadeOutTween:Play()
    fadeOutTween.Completed:Wait() -- Tunggu sampai animasinya selesai

    -- Ganti Teks & Reset posisi ke atas sedikit untuk efek jatuh
    statusText.Text = "Beverly Hub is Loaded"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Berubah jadi putih terang
    statusText.Position = UDim2.new(0.5, 0, 0.5, 35)

    -- Animasi Fade Down IN (Muncul & Turun dengan efek membal/bouncy yang cool)
    local fadeInInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out) 
    local fadeInTween = TweenService:Create(statusText, fadeInInfo, {
        TextTransparency = 0,
        Position = UDim2.new(0.5, 0, 0.5, 45) -- Kembali ke titik awal
    })
    fadeInTween:Play()

    -- Beri waktu sejenak biar usernya bisa baca tulisan "Loaded"
    task.wait(1.5)

    -- Hentikan animasi kilauan cahaya teks utama
    gleamTween:Cancel()

    -- Efek Fade Out Layar (menghilang untuk masuk ke game)
    for i = 0, 1, 0.05 do 
        bg.BackgroundTransparency = i
        loadText.TextTransparency = i
        barBg.BackgroundTransparency = i
        barFill.BackgroundTransparency = i
        statusText.TextTransparency = i
        task.wait(0.03) -- Agak dicepetin biar transisi ke game nggak kelamaan
    end

    loadScreen:Destroy()
end


local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    CoreGui = game:GetService("CoreGui"),
    RunService = game:GetService("RunService")
}

local LocalPlayer = Services.Players.LocalPlayer

local State = {
    IsRunning = true,
    AutoEnabled = false,
    AutoBlacklist = true,
    SkakmatEnabled = false,
    SkakmatPrefix = "Random",
    UsedWords = {},
    RejectedWords = {},
    Index = {},
    GlobalDict = {},
    ActiveTask = false,
    IsBackspacing = false,
    HasSubmitted = false,
    SubmitPending = false,
    AutoFarmEnabled = false,  -- Renamed from BlatantEnabled
    Disable3DRender = false,  -- NEW: Disable 3D rendering in autofarm
    BlatantMode = false,      -- NEW: Accept any word regardless of prefix
    BlatantDelay = 0.0,
    BlatantPredict = false,
    AutoFarmPipeline = false,  -- Farming pipeline
    KaitunExecId = 0,
    LastKaitunPrefix = "",
    LastKaitunDispatch = 0,
    KaitunBusy = false,
    TargetTable = "",
    FarmRole = "Farming",
    AFKTimeout = 8.0,
    OverlayMinimized = false,
    OverlayScale = 1.0,
    IsMyTurn = false,
    TurnCounter = 0,
    CurrentSoal = "",
    LastWordAttempted = "",
    LastSubmitTime = 0,
    LastTurnTime = 0,
    LockedWord = "",
    LockedPrefix = "",
    TotalWordsFound = 0,
    TotalCorrect = 0, -- FIX: Menambahkan koma yang tadinya hilang
    TotalErrors = 0,
    ConsecutiveErrors = 0,
    TypingDelayMin = 0.25,
    TypingDelayMax = 0.4,
    ThinkDelayMin = 0.8,
    ThinkDelayMax = 2.5,
    HumanizeEnabled = false,
    WordPreference = "balanced",
    WordMode = "balanced",
    InconsistentTyping = true,
    PreferredLength = 0,
    BackspaceDelayMin = 0.03,
    BackspaceDelayMax = 0.09,
    CurrentTypedText = "",
    MatchRemoteConn = nil,
    ActiveCategory = "Semua",
    CategoryList = { "Semua" },
    CategoryWords = {},
    TypoModeEnabled = false,
    TypoModeDelayWrongChar = 0.5,
    TypoModeDelayLastChars = 1.0,
}

local function SyncAutoFarmPipeline()
    State.AutoFarmPipeline = State.AutoFarmEnabled
end

-- Load kamus
local RAW_KAMUS = {}

local loadSuccess, loadError = pcall(function()
    RAW_KAMUS = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/bevankeren/sambung-kata/master/kamus_lengkap.lua"
    ))()
end)

if not loadSuccess then
    WindUI:Notify({
        Title = "Kamus Error",
        Content = "Gagal load kamus external: " .. tostring(loadError),
        Duration = 5,
    })
    RAW_KAMUS = {
        ["a"] = { "aku", "ada", "apa", "asal", "aman" },
        ["b"] = { "bisa", "baik", "baru", "buat" },
        ["c"] = { "coba", "cari", "cara" },
        ["d"] = { "dari", "dan", "dengan" },
    }
end

-- Build index by first character
for key, wordList in pairs(RAW_KAMUS) do
    local validWords = {}
    for _, word in ipairs(wordList) do
        if #word >= 3 then
            table.insert(validWords, word)
            State.GlobalDict[word] = true
        end
    end
    table.sort(validWords, function(a, b) return #a < #b end)
    State.Index[key] = validWords
end

-- Load categorized common words
local COMMON_WORDS = {}
do
    local kamusUmumSuccess, kamusUmumData = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/bevankeren/sambung-kata/master/kamus_umum.lua"
        ))()
    end)

    if kamusUmumSuccess and kamusUmumData and kamusUmumData.words then
        if kamusUmumData.categories then
            State.CategoryList = kamusUmumData.categories
        end
        for word, cat in pairs(kamusUmumData.words) do
            COMMON_WORDS[word] = true
            State.CategoryWords[word] = cat
        end
        WindUI:Notify({
            Title = "Kamus Umum",
            Content = "Loaded! Kata umum terkategori siap digunakan.",
            Duration = 3,
        })
    else
        WindUI:Notify({
            Title = "Kamus Umum",
            Content = "Gagal load kamus umum external, pakai fallback.",
            Duration = 3,
        })
        for _, w in ipairs({
            "aku", "ada", "apa", "akan", "atau", "anak", "air", "ambil", "aman", "ayah",
            "bisa", "buat", "baik", "baru", "beli", "besar", "buka", "bawa", "bantu", "baca",
            "coba", "cari", "cara", "cinta", "cantik", "cuci", "cepat", "cerita",
            "dari", "dan", "dengan", "dalam", "dapat", "dia", "dulu", "datang",
            "enak", "empat", "emas", "entah",
            "guna", "guru", "gaji", "ganti", "gampang",
            "hari", "harus", "habis", "harga", "hidup", "hitam", "hujan",
            "ini", "itu", "ingin", "ikut", "ibu", "ikan", "indah",
            "jadi", "juga", "jalan", "jawab", "jauh", "jelas",
            "kamu", "kalau", "kata", "kerja", "kasih", "kecil", "kuat",
            "lagi", "lain", "lama", "lari", "laut", "lihat", "luas",
            "mau", "makan", "masuk", "main", "mulai", "minta", "minum",
            "nama", "nanti", "naik", "nilai", "nasi",
            "orang", "oleh",
            "punya", "pergi", "pakai", "pasti", "pintar", "pulang",
            "rumah", "rasa", "rajin", "ramai", "rapi",
            "saya", "sudah", "sama", "suka", "siap", "satu", "sakit",
            "tidak", "tahu", "teman", "tulis", "tiga", "tanya", "tidur",
            "untuk", "uang", "usaha", "udara", "umur",
            "waktu", "warna", "wajib", "wanita",
            "yang", "yakin"
        }) do COMMON_WORDS[w] = true end
    end
end

-- Word finding logic

local HARD_PREFIXES = {
    -- Original prefixes
    ["ndi"] = true, ["iam"] = true, ["pao"] = true, ["if"] = true,
    ["nyx"] = true, ["syx"] = true, ["joi"] = true,
    ["ex"] = true, ["is"] = true, ["ksa"] = true, ["exo"] = true,
    ["hk"] = true, ["ax"] = true,
    -- Single letters yang susah
    ["x"] = true, ["q"] = true, ["v"] = true, ["z"] = true,
    ["w"] = true, ["f"] = true, ["c"] = true,
    -- V3.5: Prefix MEMATIKAN dari analisis kamus (hanya 1 kata di kamus!)
    ["ct"] = true, ["rt"] = true, ["dt"] = true, ["ww"] = true,
    ["tw"] = true, ["kv"] = true, ["gw"] = true, ["iv"] = true,
    ["rn"] = true, ["ow"] = true, ["tv"] = true,
    -- 3-huruf deadly (1 kata saja di kamus)
    ["umj"] = true, ["mpp"] = true, ["baq"] = true, ["thr"] = true,
    ["taq"] = true, ["mee"] = true, ["mbr"] = true, ["eid"] = true,
    ["trh"] = true, ["tkh"] = true, ["aid"] = true, ["smd"] = true,
    ["ait"] = true, ["tpt"] = true, ["zuk"] = true, ["atd"] = true,
    ["pjt"] = true, ["skd"] = true, ["tku"] = true, ["okb"] = true,
    ["tkp"] = true, ["pjk"] = true, ["ttm"] = true, ["sbg"] = true,
    ["fez"] = true, ["jav"] = true, ["ojk"] = true, ["tdl"] = true,
    ["gaa"] = true, ["ekb"] = true, ["tbc"] = true, ["ekg"] = true,
    ["gkg"] = true, ["fkg"] = true, ["tkr"] = true, ["tps"] = true,
    ["waq"] = true, ["ugd"] = true, ["veh"] = true, ["irs"] = true,
    ["bmd"] = true, ["jra"] = true, ["pib"] = true, ["nib"] = true,
    ["twi"] = true, ["jue"] = true, ["kfl"] = true, ["odh"] = true,
    ["pdh"] = true, ["tez"] = true, ["roo"] = true, ["mfl"] = true,
    ["tev"] = true, ["dpo"] = true, ["stk"] = true, ["kkl"] = true,
    ["yib"] = true, ["dll"] = true, ["lbh"] = true, ["ibh"] = true,
    ["kbh"] = true, ["gbh"] = true, ["fax"] = true, ["fud"] = true,
    ["tvr"] = true, ["bkd"] = true, ["otk"] = true, ["akd"] = true,
    ["moa"] = true,
}


local function GetNextPrefix(prefix, word)
    local addedStr = word:sub(#prefix + 1)
    if #addedStr <= 3 and #addedStr > 0 then
        return addedStr
    else
        return word:sub(-1)
    end
end

-- Find word by prefix (if role=Tumbal, always lose)
local function FindWord(prefix, forceNew)
    if State.FarmRole == "Tumbal" then
        return (prefix or "") .. "nasihuy" .. string.char(math.random(97, 122), math.random(97, 122), math.random(97, 122))
    end

    if not prefix or prefix == "" then return nil end

    if not forceNew and State.LockedPrefix == prefix and State.LockedWord ~= "" then
        if not State.UsedWords[State.LockedWord] then
            return State.LockedWord
        end
    end

    local bucket = State.Index[prefix:sub(1, 1):lower()]
    if not bucket then return nil end

    local candidates = {}

    for _, word in ipairs(bucket) do
        if word:sub(1, #prefix) == prefix and not State.UsedWords[word] then
            table.insert(candidates, word)
        end
    end

    if #candidates > 0 then
        local selectedWord = nil

        if State.SkakmatEnabled then
            local skakmatCandidates = {}
            for _, word in ipairs(candidates) do
                local nPrefix = GetNextPrefix(prefix, word)
                if State.SkakmatPrefix == "Random" then
                    if HARD_PREFIXES[nPrefix] then
                        -- Score = berapa kata di kamus yang berawalan nPrefix (makin sedikit = makin mematikan)
                        local nBucket = State.Index[nPrefix:sub(1, 1):lower()] or {}
                        local count = 0
                        for _, w2 in ipairs(nBucket) do
                            if w2:sub(1, #nPrefix) == nPrefix and not State.UsedWords[w2] then
                                count = count + 1
                            end
                        end
                        table.insert(skakmatCandidates, {word = word, score = count})
                    end
                else
                    if nPrefix == State.SkakmatPrefix:lower() then
                        table.insert(skakmatCandidates, {word = word, score = 0})
                    end
                end
            end

            if #skakmatCandidates > 0 then
                -- Sort: prioritas score terendah (paling mematikan), lalu kata umum, lalu terpanjang
                table.sort(skakmatCandidates, function(a, b)
                    if a.score ~= b.score then return a.score < b.score end
                    local aCommon = COMMON_WORDS[a.word] and 1 or 0
                    local bCommon = COMMON_WORDS[b.word] and 1 or 0
                    if aCommon ~= bCommon then return aCommon > bCommon end
                    return #a.word > #b.word
                end)
                selectedWord = skakmatCandidates[1].word
            end
        end


        if not selectedWord and State.ConsecutiveErrors > 2 and State.PreferredLength > 0 then
            for _, word in ipairs(candidates) do
                if #word <= State.PreferredLength + 2 then
                    selectedWord = word
                    break
                end
            end
        end

        if not selectedWord then
            if State.WordMode == "umum" then
                local commonCandidates = {}
                local normalCandidates = {}
                for _, w in ipairs(candidates) do
                    if COMMON_WORDS[w] then
                        if State.ActiveCategory == "Semua" or State.CategoryWords[w] == State.ActiveCategory then
                            table.insert(commonCandidates, w)
                        end
                    elseif #w >= 4 and #w <= 7 then
                        table.insert(normalCandidates, w)
                    end
                end

                if #commonCandidates > 0 then
                    selectedWord = commonCandidates[math.random(1, #commonCandidates)]
                elseif #normalCandidates > 0 then
                    local maxIdx = math.min(math.ceil(#normalCandidates * 0.5), #normalCandidates)
                    maxIdx = math.max(1, maxIdx)
                    selectedWord = normalCandidates[math.random(1, maxIdx)]
                else
                    local maxIdx = math.min(math.ceil(#candidates * 0.4), #candidates)
                    maxIdx = math.max(1, maxIdx)
                    selectedWord = candidates[math.random(1, maxIdx)]
                end
            elseif State.WordMode == "aneh" then
                local startIdx = math.max(math.floor(#candidates * 0.7), 1)
                selectedWord = candidates[math.random(startIdx, #candidates)]
            else -- balanced
                local midIdx = math.floor(#candidates / 2) + math.random(0, math.floor(#candidates / 2))
                midIdx = math.max(1, math.min(midIdx, #candidates))
                selectedWord = candidates[midIdx]
            end
        end

        if not selectedWord then
            selectedWord = candidates[1]
        end

        State.LockedWord = selectedWord
        State.LockedPrefix = prefix
        State.TotalWordsFound = State.TotalWordsFound + 1

        return selectedWord
    end

    State.LockedWord = ""
    State.LockedPrefix = ""
    return nil
end

local function FindBlatantWord()
    if State.FarmRole == "Tumbal" then
        return State.CurrentSoal .. "nasihuy" .. string.char(math.random(97, 122), math.random(97, 122), math.random(97, 122))
    end
    
    -- Collect ALL valid words from index
    local allWords = {}
    for _, bucket in pairs(State.Index) do
        for _, word in ipairs(bucket) do
            if not State.UsedWords[word] then
                table.insert(allWords, word)
            end
        end
    end
    
    if #allWords == 0 then return nil end
    
    -- Return random word (weighted towards common words)
    local commonWords = {}
    local normalWords = {}
    
    for _, word in ipairs(allWords) do
        if COMMON_WORDS[word] then
            table.insert(commonWords, word)
        else
            table.insert(normalWords, word)
        end
    end
    
    if #commonWords > 0 then
        return commonWords[math.random(1, #commonWords)]
    else
        return allWords[math.random(1, #allWords)]
    end
end

local function UnlockWord()
    State.LockedWord = ""
    State.LockedPrefix = ""
end

local function ExtractStrings(t, result)
    result = result or {}
    local maxDepth = 4
    local function recurse(tbl, depth)
        if depth > maxDepth then return end
        for _, v in pairs(tbl) do
            if type(v) == "string" then
                table.insert(result, v)
            elseif type(v) == "table" then
                recurse(v, depth + 1)
            end
        end
    end
    if type(t) == "table" then
        recurse(t, 1)
    elseif type(t) == "string" then
        table.insert(result, t)
    end
    return result
end

-- Scan kata yang sudah dipakai pemain lain
local function ScanForUsedWords(args)
    if not State.AutoBlacklist then return nil end
    local newlyFoundWord = nil
    local strings = ExtractStrings(args)
    for _, val in ipairs(strings) do
        if #val > 2 then
            -- Bersihkan rich text tags dan whitespace
            local clean = val:lower():gsub("<.->", ""):gsub("^%s+", ""):gsub("%s+$", "")
            -- HANYA blacklist jika string INI SENDIRI adalah sebuah kata (bukan kalimat)
            -- Ini mencegah blacklist kata random dari pesan UI game
            if not clean:find("%s") and #clean > 2 then
                if State.GlobalDict[clean] and not State.UsedWords[clean] then
                    State.UsedWords[clean] = true
                    newlyFoundWord = clean
                end
            end
        end
    end
    return newlyFoundWord
end

-- Trigger keystroke sound effect
local function PlayKeystrokeSound()
    pcall(function()
        local typeSoundRemote = game:GetService("ReplicatedStorage"):FindFirstChild("TypeSound", true)
        if typeSoundRemote then
            pcall(function() typeSoundRemote:FireServer() end)
        end
        -- Juga putar suara lokal supaya kita sendiri bisa dengar
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            sound.Volume = 0.3
            sound.PlaybackSpeed = 1.8 + (math.random() * 0.4)
            sound.Parent = workspace
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 0.5)
        end)
    end)
end

local function GetDelay()
    -- Konsisten menggunakan slider Min dan Max
    local baseDelay = State.TypingDelayMin + (math.random() * (State.TypingDelayMax - State.TypingDelayMin))
    -- Tambahan jeda seperti mikir (random) jika InconsistentTyping menyala
    if State.InconsistentTyping and math.random() < 0.15 then
        baseDelay = baseDelay + (math.random(5, 15) / 100)
    end
    return baseDelay
end

-- Backspace until specified length
local function BackspaceText(visualRemote, currentText, stopAt)
    if State.BlatantMode then return end
    if State.IsBackspacing then return end
    if not currentText or currentText == "" then return end
    if not visualRemote then return end

    State.IsBackspacing = true
    stopAt = stopAt or 0

    for i = #currentText, stopAt + 1, -1 do
        if not State.AutoEnabled then
            State.IsBackspacing = false
            return
        end
        local partialText = currentText:sub(1, i - 1)
        pcall(function() visualRemote:FireServer(partialText) end)
        State.CurrentTypedText = partialText
        PlayKeystrokeSound()
        local bsDelay = State.BackspaceDelayMin + (math.random() * (State.BackspaceDelayMax - State.BackspaceDelayMin))
        task.wait(bsDelay)
    end
    State.IsBackspacing = false
end

-- Main typing executor
local function ExecuteReactivePlay(word, prefixLen, submitRemote, visualRemote)
    if State.BlatantMode then return end
    if State.ActiveTask then return end
    if State.IsBackspacing then return end
    if not word or word == "" then return end
    if not submitRemote or not visualRemote then return end

    State.ActiveTask = true
    State.HasSubmitted = false

    local currentWord = word
    local currentPrefix = State.CurrentSoal

    -- Fix: proper operator precedence (not binds tighter than == in Lua)
    if currentWord:sub(1, #currentPrefix):lower() ~= currentPrefix:lower() then
        State.ActiveTask = false
        return
    end

    local think = State.ThinkDelayMin + (math.random() * (State.ThinkDelayMax - State.ThinkDelayMin))
    task.wait(think)

    -- Failcheck after think delay
    if State.CurrentSoal ~= currentPrefix or not State.AutoEnabled then
        State.ActiveTask = false
        UnlockWord()
        return
    end

    local startIdx = prefixLen + 1
    if startIdx < 1 then startIdx = 1 end

    -- Helper: common failchecks during typing
    local function typingAborted()
        if not State.AutoEnabled then return true end
        if State.IsBackspacing then return true end
        if State.CurrentSoal ~= currentPrefix then return true end
        return false
    end

    -- Helper: check if word was used by someone else mid-typing
    local function wordStolen()
        if State.UsedWords[currentWord] then
            UnlockWord()
            local retry = FindWord(State.CurrentSoal, true)
            if retry then
                State.ActiveTask = false
                task.spawn(function() ExecuteReactivePlay(retry, #State.CurrentSoal, submitRemote, visualRemote) end)
            else
                State.ActiveTask = false
            end
            return true
        end
        return false
    end

    -- Helper: check if locked word changed
    local function wordSwitched()
        if State.LockedWord ~= currentWord and State.LockedPrefix == currentPrefix then
            State.ActiveTask = false
            task.spawn(function()
                ExecuteReactivePlay(State.LockedWord, #State.CurrentSoal, submitRemote, visualRemote)
            end)
            return true
        end
        return false
    end

    local typingSuccess = false

    if State.TypoModeEnabled and #currentWord > 4 then
        -- Typo mode: type all chars except last 2, then make a typo on last char
        for i = startIdx, #currentWord - 2 do
            if typingAborted() then State.ActiveTask = false; return end
            if wordStolen() then return end
            if wordSwitched() then return end
            local typed = currentWord:sub(1, i)
            pcall(function() visualRemote:FireServer(typed) end)
            State.CurrentTypedText = typed
            PlayKeystrokeSound()
            task.wait(GetDelay())
        end

        -- Check before typo sequence
        if not typingAborted() and not wordStolen() then
            -- Type up to second-to-last char
            local textBeforeLast = currentWord:sub(1, #currentWord - 1)
            pcall(function() visualRemote:FireServer(textBeforeLast) end)
            State.CurrentTypedText = textBeforeLast
            PlayKeystrokeSound()
            task.wait(GetDelay())

            if not typingAborted() then
                -- Type wrong last char
                local lastChar = currentWord:sub(-1, -1)
                local offset = (math.random(0, 1) * 2 - 1)
                local wrongByte = math.max(97, math.min(122, string.byte(lastChar) + offset))
                local wrongChar = string.char(wrongByte)
                local textWithWrongChar = textBeforeLast .. wrongChar
                pcall(function() visualRemote:FireServer(textWithWrongChar) end)
                State.CurrentTypedText = textWithWrongChar
                PlayKeystrokeSound()
                task.wait(State.TypoModeDelayWrongChar)

                if not typingAborted() then
                    -- Backspace the wrong char
                    pcall(function() visualRemote:FireServer(textBeforeLast) end)
                    State.CurrentTypedText = textBeforeLast
                    PlayKeystrokeSound()
                    task.wait(State.TypoModeDelayLastChars)

                    if not typingAborted() then
                        -- Type the correct full word
                        pcall(function() visualRemote:FireServer(currentWord) end)
                        State.CurrentTypedText = currentWord
                        PlayKeystrokeSound()
                        task.wait(GetDelay())
                        typingSuccess = true
                    end
                end
            end
        end
    else
        -- Normal mode: type each character
        for i = startIdx, #currentWord do
            if typingAborted() then State.ActiveTask = false; return end
            if wordStolen() then return end
            if wordSwitched() then return end
            local typed = currentWord:sub(1, i)
            pcall(function() visualRemote:FireServer(typed) end)
            State.CurrentTypedText = typed
            PlayKeystrokeSound()
            task.wait(GetDelay())
        end
        typingSuccess = true
    end

    -- Submit only if typing completed successfully
    if not typingSuccess then
        State.ActiveTask = false
        return
    end

    -- Small pause before submit (natural feel)
    task.wait(0.15)

    if not State.AutoEnabled then
        State.ActiveTask = false
        return
    end
    if State.CurrentSoal ~= currentPrefix then
        State.ActiveTask = false
        UnlockWord()
        return
    end
    if State.UsedWords[currentWord] then
        State.ActiveTask = false
        UnlockWord()
        return
    end

    pcall(function() submitRemote:FireServer(currentWord) end)
    State.LastWordAttempted = currentWord
    State.LastSubmitTime = tick()
    State.HasSubmitted = true
    State.SubmitPending = true
    State.UsedWords[currentWord] = true

    State.ActiveTask = false
end

-- Configuration system
local HttpService = game:GetService("HttpService")
local BaseFolder = "BeverlyHub"
local GameFolder = "BeverlyHub/SambungKata" -- FIX: Ubah ke slash
local ConfigFolder = "BeverlyHub/SambungKata/Configs" -- FIX: Ubah ke slash
local AutoLoadFile = "BeverlyHub/SambungKata/AutoLoad.txt" -- FIX: Ubah ke slash

-- Buat folder jika belum ada
pcall(function()
    if not isfolder(BaseFolder) then makefolder(BaseFolder) end
    if not isfolder(GameFolder) then makefolder(GameFolder) end
    if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
end)

local BeverlyConfig = {
    AutoEnabled = false,
    AutoBlacklist = true,
    TypingDelayMin = 0.25,
    TypingDelayMax = 0.4,
    ThinkDelayMin = 0.8,
    ThinkDelayMax = 2.5,
    BackspaceDelayMin = 0.03,
    BackspaceDelayMax = 0.09,
    WordMode = "balanced",
    ActiveCategory = "Semua",
    SkakmatEnabled = false,
    SkakmatPrefix = "Random",
    AutoFarmEnabled = false,
    Disable3DRender = false,
    FarmRole = "Farming",
    AFKTimeout = 8.0,
    BlatantMode = false,
    BlatantDelay = 0.0,
    BlatantPredict = false,
    AntiStaffEnabled = false,
    CustomBamboo = "Default",
    TypoModeEnabled = false,
    TypoModeDelayWrongChar = 0.5,
    TypoModeDelayLastChars = 1.0,
    RequestedEnding = "Off",
}

-- LOAD AUTO-LOAD CONFIG JIKA ADA
local loadedConfigName = nil
pcall(function()
    if isfile(AutoLoadFile) then
        local autoLoadName = readfile(AutoLoadFile)
        if autoLoadName and autoLoadName ~= "" then
            local targetPath = ConfigFolder .. "/" .. autoLoadName .. ".json" -- FIX: Slash
            if isfile(targetPath) then
                local decoded = HttpService:JSONDecode(readfile(targetPath))
                if type(decoded) == "table" then
                    for k, v in pairs(decoded) do
                        BeverlyConfig[k] = v
                    end
                    loadedConfigName = autoLoadName
                end
            end
        end
    end
end)


State.AutoEnabled = BeverlyConfig.AutoEnabled
State.AutoBlacklist = BeverlyConfig.AutoBlacklist ~= nil and BeverlyConfig.AutoBlacklist or true
State.TypingDelayMin = BeverlyConfig.TypingDelayMin
State.TypingDelayMax = BeverlyConfig.TypingDelayMax
State.ThinkDelayMin = BeverlyConfig.ThinkDelayMin
State.ThinkDelayMax = BeverlyConfig.ThinkDelayMax
State.BackspaceDelayMin = BeverlyConfig.BackspaceDelayMin or 0.03
State.BackspaceDelayMax = BeverlyConfig.BackspaceDelayMax or 0.09
State.WordMode = BeverlyConfig.WordMode
State.InconsistentTyping = BeverlyConfig.InconsistentTyping ~= nil and BeverlyConfig.InconsistentTyping or true
State.SkakmatEnabled = BeverlyConfig.SkakmatEnabled
State.SkakmatPrefix = BeverlyConfig.SkakmatPrefix
State.AutoFarmEnabled = BeverlyConfig.AutoFarmEnabled
State.Disable3DRender = BeverlyConfig.Disable3DRender or false
State.BlatantMode = BeverlyConfig.BlatantMode or false
State.BlatantDelay = BeverlyConfig.BlatantDelay
State.BlatantPredict = BeverlyConfig.BlatantPredict
State.FarmRole = BeverlyConfig.FarmRole or "Farming"
State.AFKTimeout = BeverlyConfig.AFKTimeout or 8.0
State.TypoModeEnabled = BeverlyConfig.TypoModeEnabled or false
State.TypoModeDelayWrongChar = BeverlyConfig.TypoModeDelayWrongChar or 0.5
State.TypoModeDelayLastChars = BeverlyConfig.TypoModeDelayLastChars or 1.0
State.ActiveCategory = BeverlyConfig.ActiveCategory or "Semua"
SyncAutoFarmPipeline()

-- UI Construction

local Window = WindUI:CreateWindow({
    Title = "Beverly Hub - V 4.0",
    Theme = "Dark",
    Accent = Color3.fromRGB(147, 51, 234), -- Warna ungu RGB
    Transparent = true,
    Resizable = true,
})





-- KEYBIND: Tekan RightControl untuk buka/tutup UI
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Window:Toggle()
    end
end)

-- INFO TAB (OPENS FIRST — disclaimer + developer info)
local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "solar:info-circle-bold",
    IconColor = Color3.fromHex("#FBBF24"),
    IconShape = "Square",
    Border = true,
})

local DisclaimerSection = InfoTab:Section({
    Title = "Peringatan",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

DisclaimerSection:Paragraph({
    Title = "Penggunaan yang Aman",
    Desc =
    "Gunakan Auto Play dengan delay tinggi dan jangan terus-menerus.\nSesekali jawab manual lewat panel Kamus agar natural.\nAktifkan Anti Staff di tab Misc untuk keamanan ekstra.",
})

local DevSection = InfoTab:Section({
    Title = "Beverly Hub V 4.0",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

DevSection:Paragraph({
    Title = "Developer",
    Desc = "Sambung Kata Pro — by Beverly\nDiscord: discord.gg/EDTnH7SY\nUI: Wind UI by Footagesus",
})

DevSection:Space()

DevSection:Paragraph({
    Title = "🆕 What's New? (Changelog V4.0)",
    Desc = "• WindUI Tema Keungu-unguan Baru\n• Konsistensi Typing Speed (Auto Play)\n• 97+ Killer Words Kamus Baru\n• Fitur Disable 3D Render (AutoFarm)\n• Velocity Semi-Supported",
})

DevSection:Space()

DevSection:Paragraph({
    Title = "Fitur Utama",
    Desc =
    "Auto Play (human-like typing + safe backspace)\n30.000+ kata KBBI + mode Umum/Balanced/Aneh\nPanel Kamus (manual pick + minimize)\nAuto Farm Blatant (instant submit)\nAnti Staff (auto leave jika admin join)\nFly, Noclip, Infinite Jump, FPS Booster\nKey System + Anti-Bypass",
})

DevSection:Space()

DevSection:Paragraph({
    Title = "Keybind",
    Desc = "Right Ctrl — Buka/tutup UI",
})

-- MAIN TAB
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "solar:home-2-bold",
    IconColor = Color3.fromHex("#C084FC"),
    IconShape = "Square",
    Border = true,
})

local AutoSection = MainTab:Section({
    Title = "✦ Auto Play",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

-- Build the Unload Function to be registered globally
_G.BeverlyHubUnload = function()
    pcall(function() State.IsRunning = false end)
    pcall(function() MiscState.IsRunning = false end)
    pcall(function()
        MiscState.FlyEnabled = false
        MiscState.NoclipEnabled = false
        MiscState.InfJumpEnabled = false
        MiscState.WalkAssistEnabled = false
        MiscState.JumpAssistEnabled = false
    end)
    pcall(function() if State.MatchRemoteConn then State.MatchRemoteConn:Disconnect() end end)
    pcall(function()
        if MiscState.HideIdentityConn then MiscState.HideIdentityConn:Disconnect() end
        if MiscState.NoclipConn then MiscState.NoclipConn:Disconnect() end
        if MiscState.FlyConn then MiscState.FlyConn:Disconnect() end
        if MiscState.FlyBody then MiscState.FlyBody:Destroy() end
        if MiscState.FlyGyro then MiscState.FlyGyro:Destroy() end
        if MiscState.MovementConn then MiscState.MovementConn:Disconnect() end
        if MiscState.InfJumpConn then MiscState.InfJumpConn:Disconnect() end
        if MiscState.AntiStaffConn then MiscState.AntiStaffConn:Disconnect() end
        if MiscState.ESPConn then MiscState.ESPConn:Disconnect() end
        if MiscState.BambooConn then MiscState.BambooConn:Disconnect() end
    end)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = MiscState.OriginalWalkSpeed
            hum.UseJumpPower = true
            hum.JumpPower = MiscState.OriginalJumpPower
        end
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name == "HumanoidRootPart" then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
    -- Cleanup ESP billboards
    pcall(function()
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player.Character then
                local bb = player.Character:FindFirstChild("BEV_ESP")
                if bb then bb:Destroy() end
            end
        end
    end)
    pcall(function() Window:Destroy() end)
    pcall(function() if _G.BEV_BlackScreen then _G.BEV_BlackScreen:Destroy() _G.BEV_BlackScreen = nil end end)
    pcall(function() if Services.CoreGui:FindFirstChild("BEV_Overlay") then Services.CoreGui.BEV_Overlay:Destroy() end end)
    _G.BeverlyHubUnload = nil
end

AutoSection:Slider({
    Title = "Ukuran Kamus Panel",
    Desc = "Atur skala overlay kamus (0.5 = kecil, 1.5 = besar)\nBerguna untuk HP agar lebih mudah dilihat",
    IsTooltip = true,
    Step = 0.1,
    Value = { Min = 0.5, Max = 1.5, Default = State.OverlayScale },
    Callback = function(v)
        State.OverlayScale = v
        if State._overlayUIScale then
            State._overlayUIScale.Scale = v
        end
    end
})

AutoSection:Space()

AutoSection:Toggle({
    Title = "Auto Play",
    Desc = "Otomatis jawab sambung kata",
    Default = State.AutoEnabled,
    Callback = function(v) State.AutoEnabled = v end
})

AutoSection:Space()

AutoSection:Toggle({
    Title = "Inconsistent Typing Speed",
    Desc = "Jeda ngetik acak seolah sedang mikir, mencegah ketikan terlalu linear layaknya bot.",
    Default = State.InconsistentTyping,
    Callback = function(v) State.InconsistentTyping = v end
})

AutoSection:Space()

AutoSection:Toggle({
    Title = "Auto Blacklist",
    Desc = "Otomatis tandai kata yang sudah dipakai",
    Default = true,
    Callback = function(v) State.AutoBlacklist = v end
})

AutoSection:Space()

AutoSection:Toggle({
    Title = "Skakmat Mode",
    Desc = "Mencari kata supaya musuh dapat prefix susah (Beta)",
    Default = State.SkakmatEnabled or false,
    Callback = function(v)
        State.SkakmatEnabled = v
        UnlockWord()
    end
})

AutoSection:Dropdown({
    Title = "Prefix Skakmat Target",
    Desc = "Memilih prefix target untuk meracuni musuh",
    Value = State.SkakmatPrefix or "Random",
    Values = {
        "Random",
        -- 2-huruf mematikan
        "ex", "ax", "hk", "if", "is", "ct", "rt", "dt", "ww", "tw", "kv", "gw", "iv", "rn", "ow", "tv",
        -- 1-huruf susah
        "x", "q", "v", "z", "w", "f", "c",
        -- 3-huruf (1 kata saja!)
        "taq", "baq", "waq", "fez", "tez", "zuk", "veh", "tev", "fax", "jav",
        "tkh", "tkp", "tkr", "tku", "tbc", "tps", "tpt", "tdl", "ttm",
        "pjk", "pjt", "ojk", "otk", "okb", "stk",
        "ksa", "exo", "fud", "moa", "gaa",
    },
    Callback = function(v)
        State.SkakmatPrefix = v
        UnlockWord()
    end
})

AutoSection:Space()


AutoSection:Toggle({
    Title = "Typo Mode",
    Desc = "Ketik natural: typo terakhir 2 huruf, backspace, baru ketik benar\nLebih human-like & menghindari anti-cheat",
    Default = State.TypoModeEnabled or false,
    Callback = function(v) 
        State.TypoModeEnabled = v 
    end
})

AutoSection:Space()

AutoSection:Dropdown({
    Title = "Mode Kata",
    Desc = "Umum: AI cari yg sering didengar\nBalanced: Campuran\nAneh: Jarang didengar",
    Multi = false,
    Value = "Balanced",
    Values = { "Umum", "Balanced", "Aneh" },
    Callback = function(v)
        State.WordMode = v:lower()
        UnlockWord()
    end
})

AutoSection:Space()

AutoSection:Dropdown({
    Title = "Kategori Kata",
    Desc = "Filter saran kata berdasarkan kategori\nHanya berlaku untuk Mode 'Umum'",
    Multi = false,
    Value = "Semua",
    Values = State.CategoryList,
    Callback = function(v)
        State.ActiveCategory = v
        UnlockWord()
    end
})

AutoSection:Space()

if State.TypoModeEnabled then
    AutoSection:Slider({
        Title = "Typo Mode: Delay Typo",
        Desc = "Jeda sebelum backspace typo (detik)",
        IsTooltip = true,
        Step = 0.1,
        Value = { Min = 0.1, Max = 2.0, Default = State.TypoModeDelayWrongChar },
        Callback = function(v) State.TypoModeDelayWrongChar = v end
    })

    AutoSection:Space()

    AutoSection:Slider({
        Title = "Typo Mode: Delay 2 Huruf Akhir",
        Desc = "Jeda sebelum ketik 2 huruf terakhir (detik)",
        IsTooltip = true,
        Step = 0.1,
        Value = { Min = 0.1, Max = 2.0, Default = State.TypoModeDelayLastChars },
        Callback = function(v) State.TypoModeDelayLastChars = v end
    })
end


-- SPEED TAB
local SpeedTab = Window:Tab({
    Title = "Kecepatan",
    Icon = "solar:alarm-bold",
    IconColor = Color3.fromHex("#F472B6"),
    IconShape = "Square",
    Border = true,
})

local TypingSection = SpeedTab:Section({
    Title = "Kecepatan Mengetik",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

TypingSection:Slider({
    Title = "Delay Minimum",
    Desc = "Delay tercepat antar huruf (detik)",
    IsTooltip = true,
    Step = 0.05,
    Value = { Min = 0.1, Max = 5.0, Default = 0.25 },
    Callback = function(v)
        State.TypingDelayMin = v
        if State.TypingDelayMin > State.TypingDelayMax then
            State.TypingDelayMax = State.TypingDelayMin
        end
    end
})

TypingSection:Space()

TypingSection:Slider({
    Title = "Delay Maksimum",
    Desc = "Delay terlama antar huruf (detik)",
    IsTooltip = true,
    Step = 0.05,
    Value = { Min = 0.1, Max = 5.0, Default = 0.4 },
    Callback = function(v)
        State.TypingDelayMax = v
        if State.TypingDelayMax < State.TypingDelayMin then
            State.TypingDelayMin = State.TypingDelayMax
        end
    end
})

TypingSection:Space()

TypingSection:Slider({
    Title = "Delay Min (Sebelum Ketik)",
    Desc = "Jeda tercepat sebelum mulai ngetik (detik)",
    IsTooltip = true,
    Step = 0.1,
    Value = { Min = 0.0, Max = 5.0, Default = 0.8 },
    Callback = function(v)
        State.ThinkDelayMin = v
        if State.ThinkDelayMin > State.ThinkDelayMax then
            State.ThinkDelayMax = State.ThinkDelayMin
        end
    end
})

TypingSection:Space()

TypingSection:Slider({
    Title = "Delay Max (Sebelum Ketik)",
    Desc = "Jeda terlama sebelum mulai ngetik (detik)",
    IsTooltip = true,
    Step = 0.1,
    Value = { Min = 0.0, Max = 5.0, Default = 2.5 },
    Callback = function(v)
        State.ThinkDelayMax = v
        if State.ThinkDelayMax < State.ThinkDelayMin then
            State.ThinkDelayMin = State.ThinkDelayMax
        end
    end
})

local BackspaceSection = SpeedTab:Section({
    Title = "Kecepatan Backspace",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

BackspaceSection:Slider({
    Title = "Backspace Speed",
    Desc = "Delay per huruf saat menghapus (detik)",
    IsTooltip = true,
    Step = 0.01,
    Value = { Min = 0.02, Max = 0.15, Default = 0.05 },
    Callback = function(v)
        State.BackspaceDelayMin = v * 0.6
        State.BackspaceDelayMax = v * 1.4
    end
})

-- ═══════════════════════════════════════════════════════════════════════
-- MISC TAB — Utility Features
-- ═══════════════════════════════════════════════════════════════════════
local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "solar:settings-bold",
    IconColor = Color3.fromHex("#34D399"),
    IconShape = "Square",
    Border = true,
})

-- Misc State
local MiscState = {
    FlyEnabled = false,
    FlySpeed = 50,
    FlyBody = nil,
    FlyGyro = nil,
    FlyConn = nil,
    NoclipEnabled = false,
    NoclipConn = nil,
    InfJumpEnabled = false,
    InfJumpConn = nil,
    WalkAssistEnabled = false,
    WalkAssistSpeed = 18,
    JumpAssistEnabled = false,
    JumpAssistPower = 55,
    MovementConn = nil,
    AntiStaffEnabled = false,
    AntiStaffConn = nil,
    OriginalWalkSpeed = 16,
    OriginalJumpPower = 50,
    OriginalGravity = 196.2,
    OriginalDisplayName = LocalPlayer.DisplayName,
    HideIdentityConn = nil,
    ESPEnabled = false,
    ESPConn = nil,
    CustomBamboo = "Default",
    BambooConn = nil,
}

-- Helper: get character safely
local function GetCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function TrimString(s, maxLen)
    maxLen = maxLen or 120
    if #s > maxLen then
        return s:sub(1, maxLen) .. "...(+" .. tostring(#s - maxLen) .. ")"
    end
    return s
end

local function ArgToString(v, depth)
    depth = depth or 0
    local t = type(v)
    if t == "string" then
        return "\"" .. TrimString(v, 120) .. "\""
    end
    if t == "number" or t == "boolean" or t == "nil" then
        return tostring(v)
    end
    if t == "Instance" then
        return "<" .. v.ClassName .. ":" .. v:GetFullName() .. ">"
    end
    if t == "table" then
        if depth >= 1 then
            return "{...}"
        end
        local parts = {}
        local count = 0
        for k, vv in pairs(v) do
            count = count + 1
            if count > 6 then
                table.insert(parts, "...")
                break
            end
            table.insert(parts, tostring(k) .. "=" .. ArgToString(vv, depth + 1))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    return tostring(v)
end

local function ArgsToString(args, maxItems)
    maxItems = maxItems or 8
    local out = {}
    for i = 1, math.min(#args, maxItems) do
        out[i] = ArgToString(args[i], 0)
    end
    if #args > maxItems then
        table.insert(out, "...(+" .. tostring(#args - maxItems) .. " args)")
    end
    return table.concat(out, " | ")
end

local UserInputService = game:GetService("UserInputService")

local function GetHumanoidFast()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function ApplyMovementAssist()
    local hum = GetHumanoidFast()
    if not hum then return end

    if MiscState.WalkAssistEnabled then
        hum.WalkSpeed = math.clamp(MiscState.WalkAssistSpeed, 16, 22)
    else
        hum.WalkSpeed = MiscState.OriginalWalkSpeed
    end

    if MiscState.JumpAssistEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = math.clamp(MiscState.JumpAssistPower, 50, 65)
    else
        hum.UseJumpPower = true
        hum.JumpPower = MiscState.OriginalJumpPower
    end
end

local function EnsureMovementLoop()
    if MiscState.MovementConn then return end
    MiscState.MovementConn = Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            if not MiscState.WalkAssistEnabled and not MiscState.JumpAssistEnabled then return end
            local hum = GetHumanoidFast()
            if not hum or hum.Health <= 0 then return end

            if MiscState.WalkAssistEnabled then
                local ws = math.clamp(MiscState.WalkAssistSpeed, 16, 22)
                if math.abs(hum.WalkSpeed - ws) > 0.5 then
                    hum.WalkSpeed = ws
                end
            end

            if MiscState.JumpAssistEnabled then
                local jp = math.clamp(MiscState.JumpAssistPower, 50, 65)
                hum.UseJumpPower = true
                if math.abs(hum.JumpPower - jp) > 1 then
                    hum.JumpPower = jp
                end
            end
        end)
    end)
end

local function StopMovementLoopIfIdle()
    if MiscState.WalkAssistEnabled or MiscState.JumpAssistEnabled then return end
    if MiscState.MovementConn then
        MiscState.MovementConn:Disconnect()
        MiscState.MovementConn = nil
    end
end

local function SetCharacterNoclip(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if enabled then
                part.CanCollide = false
            else
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
            end
        end
    end
end

local function StopFly()
    MiscState.FlyEnabled = false
    if MiscState.FlyConn then
        MiscState.FlyConn:Disconnect()
        MiscState.FlyConn = nil
    end
    if MiscState.FlyBody then
        pcall(function() MiscState.FlyBody:Destroy() end)
        MiscState.FlyBody = nil
    end
    if MiscState.FlyGyro then
        pcall(function() MiscState.FlyGyro:Destroy() end)
        MiscState.FlyGyro = nil
    end
end

local function StartFly()
    StopFly()
    local root = GetRootPart()
    if not root then return end

    MiscState.FlyEnabled = true

    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "BEV_FlyVelocity"
    bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVel.P = 1e5
    bodyVel.Velocity = Vector3.new()
    bodyVel.Parent = root
    MiscState.FlyBody = bodyVel

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "BEV_FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.P = 1e4
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    bodyGyro.Parent = root
    MiscState.FlyGyro = bodyGyro

    MiscState.FlyConn = Services.RunService.Heartbeat:Connect(function()
        if not MiscState.FlyEnabled then return end
        local hrp = GetRootPart()
        local hum = GetHumanoidFast()
        if not hrp or not hum or hum.Health <= 0 then
            StopFly()
            return
        end

        local cam = workspace.CurrentCamera
        local moveDir = hum.MoveDirection
        local vertical = 0

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
            vertical = -1
        end

        local speed = math.clamp(MiscState.FlySpeed, 30, 220)
        local flat = Vector3.new(moveDir.X, 0, moveDir.Z)
        local flatVel = flat.Magnitude > 0 and flat.Unit * speed or Vector3.new()
        local verticalVel = Vector3.new(0, vertical * speed, 0)

        bodyVel.Velocity = flatVel + verticalVel
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    pcall(ApplyMovementAssist)
    if MiscState.NoclipEnabled then
        pcall(function() SetCharacterNoclip(true) end)
    end
    if MiscState.FlyEnabled then
        task.wait(0.2)
        pcall(StartFly)
    end
end)

-- ══ MOVEMENT SECTION ══
local MovementSection = MiscTab:Section({
    Title = "🏃 Movement",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

MovementSection:Paragraph({
    Title = "Safe Movement",
    Desc = "Bukan bypass anti-cheat. Gunakan nilai kecil agar lebih aman dari deteksi.",
})

MovementSection:Space()

MovementSection:Toggle({
    Title = "WalkSpeed Assist",
    Desc = "Set kecepatan jalan ringan (disarankan 17-20).",
    Default = false,
    Callback = function(v)
        MiscState.WalkAssistEnabled = v
        if v then
            EnsureMovementLoop()
        else
            StopMovementLoopIfIdle()
        end
        pcall(ApplyMovementAssist)
    end
})

MovementSection:Space()

MovementSection:Slider({
    Title = "WalkSpeed Value",
    Desc = "Nilai target WalkSpeed assist",
    IsTooltip = true,
    Step = 1,
    Value = { Min = 16, Max = 22, Default = MiscState.WalkAssistSpeed },
    Callback = function(v)
        MiscState.WalkAssistSpeed = v
        if MiscState.WalkAssistEnabled then
            pcall(ApplyMovementAssist)
        end
    end
})

MovementSection:Space()

MovementSection:Toggle({
    Title = "JumpPower Assist",
    Desc = "Set daya lompat ringan (disarankan 52-60).",
    Default = false,
    Callback = function(v)
        MiscState.JumpAssistEnabled = v
        if v then
            EnsureMovementLoop()
        else
            StopMovementLoopIfIdle()
        end
        pcall(ApplyMovementAssist)
    end
})

MovementSection:Space()

MovementSection:Slider({
    Title = "JumpPower Value",
    Desc = "Nilai target JumpPower assist",
    IsTooltip = true,
    Step = 1,
    Value = { Min = 50, Max = 65, Default = MiscState.JumpAssistPower },
    Callback = function(v)
        MiscState.JumpAssistPower = v
        if MiscState.JumpAssistEnabled then
            pcall(ApplyMovementAssist)
        end
    end
})

MovementSection:Space()

MovementSection:Toggle({
    Title = "Infinite Jump (Soft)",
    Desc = "Memicu lompat tambahan saat tekan tombol jump.",
    Default = false,
    Callback = function(v)
        MiscState.InfJumpEnabled = v
        if MiscState.InfJumpConn then
            MiscState.InfJumpConn:Disconnect()
            MiscState.InfJumpConn = nil
        end
        if v then
            MiscState.InfJumpConn = UserInputService.JumpRequest:Connect(function()
                pcall(function()
                    local hum = GetHumanoidFast()
                    if hum and hum.Health > 0 then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end)
        end
    end
})

-- ══ FLY SECTION ══
local FlySection = MiscTab:Section({
    Title = "✈ Fly",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

FlySection:Paragraph({
    Title = "Fly Control",
    Desc = "Mode cepat. Space untuk naik, Ctrl/C untuk turun.",
})

FlySection:Space()

FlySection:Toggle({
    Title = "Fly",
    Desc = "Terbang dengan kecepatan tinggi.",
    Default = false,
    Callback = function(v)
        if v then
            StartFly()
        else
            StopFly()
        end
    end
})

FlySection:Space()

FlySection:Slider({
    Title = "Fly Speed",
    Desc = "Kecepatan fly (agak brutal).",
    IsTooltip = true,
    Step = 5,
    Value = { Min = 30, Max = 220, Default = MiscState.FlySpeed or 50 },
    Callback = function(v)
        MiscState.FlySpeed = v
    end
})

-- ══ WORLD SECTION ══
local WorldSection = MiscTab:Section({
    Title = "🌍 World",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

WorldSection:Toggle({
    Title = "Noclip",
    Desc = "Tembus objek saat aktif.",
    Default = false,
    Callback = function(v)
        MiscState.NoclipEnabled = v
        if v then
            if not MiscState.NoclipConn then
                MiscState.NoclipConn = Services.RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if MiscState.NoclipEnabled then
                            SetCharacterNoclip(true)
                        end
                    end)
                end)
            end
            pcall(function() SetCharacterNoclip(true) end)
        else
            if MiscState.NoclipConn then
                MiscState.NoclipConn:Disconnect()
                MiscState.NoclipConn = nil
            end
            pcall(function() SetCharacterNoclip(false) end)
        end
    end
})

WorldSection:Space()

WorldSection:Slider({
    Title = "Gravity",
    Desc = "Gravitasi dunia (default: 196.2)",
    IsTooltip = true,
    Step = 5,
    Value = { Min = 0, Max = 500, Default = 196 },
    Callback = function(v)
        pcall(function()
            workspace.Gravity = v
        end)
    end
})

WorldSection:Space()

WorldSection:Toggle({
    Title = "Hide Identity",
    Desc = "Samarkan nama karakter menjadi 'beverlyhub' (Client-side)",
    Default = false,
    Callback = function(v)
        if v then
            -- Enable Spoofing
            MiscState.HideIdentityConn = Services.RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.DisplayName ~= "beverlyhub" then
                            hum.DisplayName = "beverlyhub"
                        end

                        -- Spoof custom nametags (BillboardGuis, etc)
                        for _, obj in pairs(char:GetDescendants()) do
                            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                                local text = obj.Text
                                if text:find(MiscState.OriginalDisplayName) or text:find(LocalPlayer.Name) then
                                    obj.Text = text:gsub(MiscState.OriginalDisplayName, "beverlyhub"):gsub(
                                    LocalPlayer.Name, "beverlyhub")
                                end
                            end
                        end
                    end
                end)
            end)
        else
            -- Disable Spoofing
            if MiscState.HideIdentityConn then
                MiscState.HideIdentityConn:Disconnect()
                MiscState.HideIdentityConn = nil
            end
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.DisplayName = MiscState.OriginalDisplayName
                    end
                    -- Attempt to restore some tags (though usually they reset on respawn anyway)
                    for _, obj in pairs(char:GetDescendants()) do
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            if obj.Text:find("beverlyhub") then
                                obj.Text = obj.Text:gsub("beverlyhub", MiscState.OriginalDisplayName)
                            end
                        end
                    end
                end
            end)
        end
    end
})

WorldSection:Space()

WorldSection:Button({
    Title = "Rejoin Same Server",
    Desc = "Keluar dan masuk kembali ke server ini",
    Callback = function()
        pcall(function()
            WindUI:Notify({ Title = "Rejoin", Content = "Sedang mencoba rejoin ke server ini...", Duration = 3 })

            local ts = game:GetService("TeleportService")
            local p = game:GetService("Players").LocalPlayer

            -- Try method 1: specific to this job ID (works but sometimes blocked by some games)
            pcall(function()
                ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
            end)

            -- Try method 2: fallback (just teleport to the place, Roblox often puts you back in same/new server)
            task.wait(1)
            pcall(function()
                ts:Teleport(game.PlaceId, p)
            end)
        end)
    end
})

-- ══ PERFORMANCE SECTION ══
local PerfSection = MiscTab:Section({
    Title = "⚡ Performance",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

PerfSection:Toggle({
    Title = "FPS Booster",
    Desc = "Hapus efek visual untuk naikkan FPS",
    Default = false,
    Callback = function(v)
        pcall(function()
            local lighting = game:GetService("Lighting")
            if v then
                -- Disable heavy effects
                for _, effect in pairs(lighting:GetChildren()) do
                    if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or
                        effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") or
                        effect:IsA("ColorCorrectionEffect") then
                        effect.Enabled = false
                    end
                end
                -- Lower terrain detail
                pcall(function()
                    game:GetService("Terrain").WaterWaveSize = 0
                    game:GetService("Terrain").WaterWaveSpeed = 0
                    game:GetService("Terrain").WaterReflectance = 0
                    game:GetService("Terrain").WaterTransparency = 0
                end)
                -- Remove particles
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or
                        v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end

                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            else
                -- Re-enable
                for _, effect in pairs(lighting:GetChildren()) do
                    if effect:IsA("PostEffect") then
                        effect.Enabled = true
                    end
                end
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or
                        v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = true
                    end
                end
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end
        end)
    end
})

PerfSection:Space()

PerfSection:Toggle({
    Title = "ULTRA FPS Booster",
    Desc =
    "Mode ekstrem! Hapus SEMUA visual: texture, mesh, sound, accessories, shadow. Game jadi seperti kotak polos tapi FPS meledak.",
    Default = false,
    Callback = function(v)
        pcall(function()
            local lighting = game:GetService("Lighting")
            if v then
                -- === LEVEL 1: Semua yang FPS Booster biasa lakukan ===
                for _, effect in pairs(lighting:GetChildren()) do
                    if effect:IsA("PostEffect") then effect.Enabled = false end
                end
                pcall(function()
                    local terrain = game:GetService("Terrain")
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                    terrain.Decoration = false
                end)
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

                -- === LEVEL 2: ULTRA — Hapus segalanya ===
                for _, obj in pairs(workspace:GetDescendants()) do
                    pcall(function()
                        -- Matikan semua particle/visual
                        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or
                            obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") or
                            obj:IsA("Highlight") then
                            obj.Enabled = false
                        end
                        -- Hapus texture & decal (bikin semua permukaan polos)
                        if obj:IsA("Texture") or obj:IsA("Decal") then
                            obj.Transparency = 1
                        end
                        -- Hapus suara
                        if obj:IsA("Sound") then
                            obj.Volume = 0
                        end
                        -- Kurangi detail mesh
                        if obj:IsA("MeshPart") then
                            obj.TextureID = ""
                            obj.Material = Enum.Material.SmoothPlastic
                        end
                        if obj:IsA("SpecialMesh") then
                            obj.TextureId = ""
                        end
                    end)
                end

                -- Hapus semua accessories dari karakter (topi, rambut, dll)
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    pcall(function()
                        local char = player.Character
                        if char then
                            for _, acc in pairs(char:GetChildren()) do
                                if acc:IsA("Accessory") or acc:IsA("ShirtGraphic") then
                                    acc:Destroy()
                                end
                            end
                            -- Hapus shirt/pants texture
                            for _, clothing in pairs(char:GetChildren()) do
                                if clothing:IsA("Shirt") or clothing:IsA("Pants") then
                                    pcall(function() clothing:Destroy() end)
                                end
                            end
                        end
                    end)
                end

                -- Matikan shadow & global lighting berat
                pcall(function()
                    lighting.GlobalShadows = false
                    lighting.FogEnd = 9e9
                    lighting.Brightness = 1
                    lighting.EnvironmentDiffuseScale = 0
                    lighting.EnvironmentSpecularScale = 0
                end)

                -- Matikan 3D rendering (efek mata)
                pcall(function()
                    local sss = game:GetService("StarterGui")
                    sss:SetCore("SendNotification", { Title = "Ultra FPS", Text = "Mode ULTRA aktif!", Duration = 2 })
                end)

                WindUI:Notify({ Title = "Ultra FPS", Content = "Semua visual dihapus! FPS maksimal.", Duration = 3 })
            else
                -- Re-enable dasar
                for _, effect in pairs(lighting:GetChildren()) do
                    if effect:IsA("PostEffect") then effect.Enabled = true end
                end
                for _, obj in pairs(workspace:GetDescendants()) do
                    pcall(function()
                        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or
                            obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") or
                            obj:IsA("Highlight") then
                            obj.Enabled = true
                        end
                        if obj:IsA("Texture") or obj:IsA("Decal") then
                            obj.Transparency = 0
                        end
                        if obj:IsA("Sound") then
                            obj.Volume = 0.5
                        end
                    end)
                end
                pcall(function()
                    lighting.GlobalShadows = true
                    lighting.EnvironmentDiffuseScale = 1
                    lighting.EnvironmentSpecularScale = 1
                end)
                pcall(function() game:GetService("Terrain").Decoration = true end)
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
                WindUI:Notify({ Title = "Ultra FPS", Content = "Visual dikembalikan (rejoin untuk full restore).", Duration = 3 })
            end
        end)
    end
})

-- ══ VISUAL SECTION ══
local VisualSection = MiscTab:Section({
    Title = "🎭 Skin Changer",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

-- Dynamic Item List from the user's screenshot
local bambooList = {
    "Default", "BambuApi", "BambuAwan", "BambuBiru", "BambuEs",
    "BambuHati", "BambuHijau", "BambuHitam", "BambuKuning",
    "BambuMerah", "BambuMerahPutih", "BambuMetalik", "BambuPelangi",
    "BambuPink", "BambuPutih", "BambuUngu"
}

VisualSection:Dropdown({
    Title = "Custom Bamboo Skin",
    Desc = "Mengganti Visual Bambu Kamu",
    Multi = false,
    Value = MiscState.CustomBamboo or "Default",
    Values = bambooList,
    Callback = function(v)
        MiscState.CustomBamboo = v

        if v ~= "Default" and not MiscState.BambooConn then
            MiscState.BambooConn = Services.RunService.Heartbeat:Connect(function()
                pcall(function()
                    if MiscState.CustomBamboo == "Default" then return end
                    local char = LocalPlayer.Character
                    if not char then return end

                    -- Cari senjata di karakter
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        for _, child in pairs(char:GetChildren()) do
                            if child:IsA("Model") and (child.Name:lower():find("bambu") or child.Name:lower():find("weapon")) then
                                tool = child
                                break
                            end
                        end
                    end

                    if tool then
                        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart") or
                        (tool:IsA("Model") and tool.PrimaryPart)

                        -- Sembunyikan SEMUA part bawaan senjata (termasuk ruas/cincin default)
                        for _, p in pairs(tool:GetDescendants()) do
                            if (p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Decal")) and not p.Name:match("^VisualSkin_") then
                                p.Transparency = 1
                                -- Hide special meshes if exist
                                if p:IsA("BasePart") then
                                    local sm = p:FindFirstChildOfClass("SpecialMesh")
                                    if sm and sm.TextureId ~= "" then sm.TextureId = "" end
                                end
                            end
                        end

                        -- Cek apakah skin baru sudah tertempel
                        -- Kita gunakan atribut di 'tool' agar Heartbeat tidak melooping clone terus-menerus
                        if tool:GetAttribute("CurrentSkin") ~= MiscState.CustomBamboo then
                            -- Bersihkan skin/partikel lama yang pernah kita buat
                            for _, oldSkin in pairs(tool:GetChildren()) do
                                if oldSkin.Name:match("^VisualSkin_") then oldSkin:Destroy() end
                            end
                            if handle then
                                for _, oldPart in pairs(handle:GetChildren()) do
                                    if oldPart:IsA("ParticleEmitter") or oldPart:IsA("Trail") or oldPart:IsA("PointLight") then
                                        if oldPart:GetAttribute("IsCustomSkin") then oldPart:Destroy() end
                                    end
                                end
                            end

                            -- MENCARI MODEL KLONINGAN ASLI DI REPLICATEDSTORAGE
                            local rs = game:GetService("ReplicatedStorage")
                            local customModel = nil

                            -- Pengecekan folder berlapis sesuai struktur game
                            if rs:FindFirstChild("Weapons") then
                                customModel = rs.Weapons:FindFirstChild(MiscState.CustomBamboo)
                            elseif rs:FindFirstChild("WeaponUI") and rs.WeaponUI:FindFirstChild("Weapons") then
                                customModel = rs.WeaponUI.Weapons:FindFirstChild(MiscState.CustomBamboo)
                            elseif rs:FindFirstChild("WeaponUI") then
                                customModel = rs.WeaponUI:FindFirstChild(MiscState.CustomBamboo)
                            end

                            if customModel and handle then
                                -- KLONING SEMUA PART DARI SKIN ASLI (termasuk cincin, ruas, dll)
                                local baseOrigin = customModel:FindFirstChild("Batang") or
                                customModel:FindFirstChildWhichIsA("BasePart")

                                for _, partObj in pairs(customModel:GetDescendants()) do
                                    if partObj:IsA("BasePart") then
                                        local clone = partObj:Clone()
                                        clone.Name = "VisualSkin_" .. MiscState.CustomBamboo .. "_" .. partObj.Name
                                        clone.Anchored = false
                                        clone.CanCollide = false
                                        clone.Massless = true

                                        -- Jangan sampai partikel terduplikasi jika partikel ada di gagang asli
                                        -- (Efek partikel sudah otomatis ter-clone karena fungsi Clone())

                                        -- Menyesuaikan posisi ke pedang kita dengan akurat
                                        if baseOrigin then
                                            local offset = baseOrigin.CFrame:Inverse() * partObj.CFrame
                                            clone.CFrame = handle.CFrame * offset
                                        else
                                            clone.CFrame = handle.CFrame
                                        end

                                        -- Mengunci posisinya ke gagang asli
                                        local weld = Instance.new("WeldConstraint")
                                        weld.Part0 = handle
                                        weld.Part1 = clone
                                        weld.Parent = clone
                                        clone.Parent = tool
                                    end
                                end

                                -- Tandai bahwa skin ini sudah selesai di-clone
                                tool:SetAttribute("CurrentSkin", MiscState.CustomBamboo)
                            end
                        end
                    end
                end)
            end)
        elseif v == "Default" and MiscState.BambooConn then
            MiscState.BambooConn:Disconnect()
            MiscState.BambooConn = nil

            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        for _, child in pairs(char:GetChildren()) do
                            if child:IsA("Model") and (child.Name:lower():find("bambu") or child.Name:lower():find("weapon")) then
                                tool = child; break
                            end
                        end
                    end

                    if tool then
                        for _, p in pairs(tool:GetDescendants()) do
                            if p.Name:match("^VisualSkin_") then
                                p:Destroy()
                            elseif p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Decal") then
                                p.Transparency = 0
                            end
                        end
                        tool:SetAttribute("CurrentSkin", "Default")
                    end
                end
            end)
        end
    end
})

VisualSection:Space()

-- ═══════════════════════════════════════════════════════════════════════
-- TOP RANK SPOOF (Visual)
-- ═══════════════════════════════════════════════════════════════════════
local TopRankEnabled = false
local TopRankValue = 1
local TopRankLoop = nil

-- Warna rank berubah sesuai tier, tapi NAMA tetap putih (game asli)
local function getTopRankColor(rank)
    if rank == 1 then
        return Color3.fromRGB(255, 215, 0)     -- Gold (Top 1)
    elseif rank <= 3 then
        return Color3.fromRGB(192, 192, 192)   -- Silver (Top 2-3)
    elseif rank <= 10 then
        return Color3.fromRGB(205, 127, 50)    -- Bronze (Top 4-10)
    elseif rank <= 25 then
        return Color3.fromRGB(100, 200, 255)   -- Light Blue (Top 11-25)
    elseif rank <= 50 then
        return Color3.fromRGB(150, 255, 150)   -- Light Green (Top 26-50)
    elseif rank <= 99 then
        return Color3.fromRGB(200, 200, 200)   -- Gray (Top 51-99)
    else
        return Color3.fromRGB(165, 165, 165)   -- Dark Gray (Top 99+)
    end
end

-- Fitur ini hanya mengubah TEKS dan WARNA RankLabel, BUKAN NameLabel
local function applyTopRank()
    pcall(function()
        local player = Services.Players.LocalPlayer
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local overhead = head:FindFirstChild("Overhead")
        if not overhead then return end
        local frame = overhead:FindFirstChild("Frame")
        if not frame then return end
        
        local rankLabel = frame:FindFirstChild("RankLabel")
        if rankLabel then
            rankLabel.Text = "Top " .. TopRankValue
            rankLabel.TextColor3 = getTopRankColor(TopRankValue)
        end
    end)
end

local function resetTopRank()
    pcall(function()
        local player = Services.Players.LocalPlayer
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local overhead = head:FindFirstChild("Overhead")
        if not overhead then return end
        local frame = overhead:FindFirstChild("Frame")
        if not frame then return end
        
        local rankLabel = frame:FindFirstChild("RankLabel")
        if rankLabel then
            rankLabel.Text = "Top 99+"
            rankLabel.TextColor3 = Color3.fromRGB(165, 165, 165)
        end
    end)
end

VisualSection:Toggle({
    Title = "🏅 Top Rank Spoof",
    Desc = "Ubah teks dan warna Top Rank di nametag (nama tetap putih). Top 1=Emas, Top 2-3=Silver, Top 4-10=Perunggu, Top 11-25=Biru, Top 26-50=Hijau",
    Default = false,
    Callback = function(v)
        TopRankEnabled = v
        if v then
            applyTopRank()
            TopRankLoop = task.spawn(function()
                while TopRankEnabled and State.IsRunning do
                    applyTopRank()
                    task.wait(2) -- Re-apply setiap 2 detik (jaga-jaga server reset)
                end
            end)
        else
            resetTopRank()
            TopRankLoop = nil
        end
    end
})

VisualSection:Slider({
    Title = "Top Rank Value",
    Desc = "Pilih ranking yang ingin ditampilkan (1-99)",
    Value = { Min = 1, Max = 99, Default = 1 },
    Callback = function(v)
        TopRankValue = v
        if TopRankEnabled then
            applyTopRank()
        end
    end
})

VisualSection:Space()
local SafetySection = MiscTab:Section({
    Title = "Safety",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

local function CheckIfStaff(player)
    local isStaff = false
    pcall(function()
        local creatorId = game.CreatorId
        if game.CreatorType == Enum.CreatorType.Group then
            local rank = player:GetRankInGroup(creatorId)
            if rank >= 200 then
                isStaff = true
            end
        elseif game.CreatorType == Enum.CreatorType.User then
            if player.UserId == creatorId then
                isStaff = true
            end
        end
    end)
    return isStaff
end

SafetySection:Toggle({
    Title = "Anti Staff",
    Desc = "Otomatis keluar jika ada staff/admin game join server kamu",
    Default = MiscState.AntiStaffEnabled or false,
    Callback = function(v)
        MiscState.AntiStaffEnabled = v
        if v then
            -- Cek pemain yang sudah ada di server
            for _, player in pairs(Services.Players:GetPlayers()) do
                if player ~= LocalPlayer and CheckIfStaff(player) then
                    WindUI:Notify({ Title = "Anti Staff", Content = "Staff terdeteksi di server! Keluar dalam 3 detik...", Duration = 3 })
                    task.wait(3)
                    pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
                    return
                end
            end

            -- Monitor pemain baru yang masuk
            MiscState.AntiStaffConn = Services.Players.PlayerAdded:Connect(function(player)
                if not MiscState.AntiStaffEnabled then return end
                if CheckIfStaff(player) then
                    WindUI:Notify({ Title = "Anti Staff", Content = "Staff '" .. player.Name .. "' join! Keluar...", Duration = 3 })
                    task.wait(1)
                    pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
                end
            end)

            WindUI:Notify({ Title = "Anti Staff", Content =
            "Anti Staff aktif. Kamu akan otomatis keluar jika ada staff join.", Duration = 3 })
        else
            if MiscState.AntiStaffConn then
                MiscState.AntiStaffConn:Disconnect()
                MiscState.AntiStaffConn = nil
            end
        end
    end
})



-- ═══════════════════════════════════════════════════════════════════════
-- ESP SECTION — Player Stats
-- ═══════════════════════════════════════════════════════════════════════
local ESPSection = MiscTab:Section({
    Title = "👁 ESP",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

local function CreateESPBillboard(player)
    if player == LocalPlayer then return end
    pcall(function()
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        -- Hapus ESP lama kalau ada
        local old = char:FindFirstChild("BEV_ESP")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name = "BEV_ESP"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 180, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 200
        bb.Parent = char

        local frame = Instance.new("Frame", bb)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
        frame.BackgroundTransparency = 0.3
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = Color3.fromHex("#C084FC")
        frameStroke.Thickness = 1
        frameStroke.Transparency = 0.5

        -- Nama player
        local nameLabel = Instance.new("TextLabel", frame)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 12
        nameLabel.TextColor3 = Color3.fromHex("#E9D5FF")
        nameLabel.Text = player.DisplayName

        -- Stats (Win/Lose)
        local statsLabel = Instance.new("TextLabel", frame)
        statsLabel.Name = "StatsLabel"
        statsLabel.Size = UDim2.new(1, 0, 0.5, 0)
        statsLabel.Position = UDim2.new(0, 0, 0.5, 0)
        statsLabel.BackgroundTransparency = 1
        statsLabel.Font = Enum.Font.GothamMedium
        statsLabel.TextSize = 10
        statsLabel.TextColor3 = Color3.fromHex("#D8B4FE")

        -- Coba ambil stats dari leaderstats
        local function updateStats()
            pcall(function()
                local ls = player:FindFirstChild("leaderstats")
                if ls then
                    local wins = ls:FindFirstChild("Wins") or ls:FindFirstChild("Win") or ls:FindFirstChild("Menang")
                    local loses = ls:FindFirstChild("Loses") or ls:FindFirstChild("Lose") or ls:FindFirstChild("Kalah") or
                    ls:FindFirstChild("Loss")
                    local score = ls:FindFirstChild("Score") or ls:FindFirstChild("Skor") or ls:FindFirstChild("Points")
                    local money = ls:FindFirstChild("Money") or ls:FindFirstChild("Uang") or ls:FindFirstChild("Coins") or
                    ls:FindFirstChild("Cash")

                    local parts = {}
                    if wins then table.insert(parts, "W:" .. tostring(wins.Value)) end
                    if loses then table.insert(parts, "L:" .. tostring(loses.Value)) end
                    if score then table.insert(parts, "S:" .. tostring(score.Value)) end
                    if money then table.insert(parts, "$" .. tostring(money.Value)) end

                    if #parts > 0 then
                        statsLabel.Text = table.concat(parts, " | ")
                    else
                        -- Tampilkan semua stat yang ada
                        local allStats = {}
                        for _, stat in pairs(ls:GetChildren()) do
                            if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
                                table.insert(allStats, stat.Name .. ":" .. tostring(stat.Value))
                            end
                        end
                        statsLabel.Text = #allStats > 0 and table.concat(allStats, " | ") or "No stats"
                    end
                else
                    statsLabel.Text = "No leaderstats"
                end
            end)
        end

        updateStats()
        -- Auto-refresh stats tiap 5 detik
        task.spawn(function()
            while bb and bb.Parent and MiscState.ESPEnabled do
                task.wait(5)
                if bb and bb.Parent then updateStats() end
            end
        end)
    end)
end

local function CleanupAllESP()
    for _, player in pairs(Services.Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local bb = player.Character:FindFirstChild("BEV_ESP")
                if bb then bb:Destroy() end
            end
        end)
    end
end

ESPSection:Toggle({
    Title = "ESP Stats",
    Desc = "Tampilkan nama + stats (Win/Lose/Score) pemain lain di atas kepala mereka",
    Default = false,
    Callback = function(v)
        MiscState.ESPEnabled = v
        if v then
            -- Buat ESP untuk semua pemain yang ada
            for _, player in pairs(Services.Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreateESPBillboard(player)
                end
            end
            -- Monitor pemain baru dan respawn
            MiscState.ESPConn = Services.Players.PlayerAdded:Connect(function(player)
                if not MiscState.ESPEnabled then return end
                player.CharacterAdded:Connect(function()
                    task.wait(1)
                    if MiscState.ESPEnabled then
                        CreateESPBillboard(player)
                    end
                end)
            end)
            -- Monitor respawn pemain yang sudah ada
            for _, player in pairs(Services.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function()
                        task.wait(1)
                        if MiscState.ESPEnabled then
                            CreateESPBillboard(player)
                        end
                    end)
                end
            end
            WindUI:Notify({ Title = "ESP", Content = "ESP Stats aktif!", Duration = 2 })
        else
            if MiscState.ESPConn then
                MiscState.ESPConn:Disconnect()
                MiscState.ESPConn = nil
            end
            CleanupAllESP()
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════
-- KAITUN FARM — Auto Farm Coin AFK (gabungan dari Auto Farm + Pipeline)
-- ═══════════════════════════════════════════════════════════════════════
local FarmTab = Window:Tab({
    Title = "Kaitun Farm",
    Icon = "solar:wallet-bold",
    IconColor = Color3.fromHex("#84CC16"),
    IconShape = "Square",
    Border = true,
})

local FarmSection = FarmTab:Section({
    Title = "💰 Kaitun Farm",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

FarmSection:Paragraph({
    Title = "ℹ Info",
    Desc = "Farm coin otomatis tanpa henti:\n• Auto join meja → jawab instan → selesai → rejoin\n• Cocok untuk 2 akun di private server\n• Tinggal AFK, script jalan sendiri",
})

FarmSection:Space()

FarmSection:Toggle({
    Title = "Anti AFK",
    Desc = "Cegah auto-kick karena idle.\nSimulasi input otomatis tiap 30 detik.",
    Default = false,
    Callback = function(v)
        State.AntiAFKEnabled = v
        if v then
            WindUI:Notify({
                Title = "🛡 Anti AFK ON",
                Content = "Kamu tidak akan di-kick karena AFK.",
                Duration = 3,
            })
            task.spawn(function()
                local VirtualUser = game:GetService("VirtualUser")
                local Players = game:GetService("Players")
                local player = Players.LocalPlayer
                while State.AntiAFKEnabled do
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(0, 0))
                    end)
                    pcall(function()
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = player.Character.HumanoidRootPart
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0.001)
                            task.wait(0.1)
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.001)
                        end
                    end)
                    task.wait(30)
                end
            end)
        end
    end
})

FarmSection:Space()

FarmSection:Toggle({
    Title = "Kaitun Farm",
    Desc = "Aktifkan auto farm AFK.\nAuto join meja, jawab instan, dan rejoin otomatis.",
    Default = State.AutoFarmEnabled or false,
    Callback = function(v)
        State.AutoFarmEnabled = v
        State.KaitunBusy = false
        if not v then
            State.HasSubmitted = false
            State.SubmitPending = false
        end
        SyncAutoFarmPipeline()
        if v then
            State.AutoEnabled = false
            State.BlatantMode = false
            WindUI:Notify({
                Title = "💰 Kaitun Farm ON",
                Content = "Auto farm AFK dimulai! Tinggal santai.",
                Duration = 3,
            })
            
            -- Jika Disable 3D Render aktif, matikan render saat mulai farming
            if State.Disable3DRender then
                -- Tidak perlu Set3dRenderingEnabled lagi karena sudah dikontrol toggle utamanya
            end
        else
            -- Pastikan render balik nyala saat farming mati
            if State.Disable3DRender then
                -- Jangan nyalakan render jika state utamanya masih disable 3D render
            else
                pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(true) end)
                if _G.BEV_BlackScreen then
                    pcall(function() _G.BEV_BlackScreen:Destroy() end)
                    _G.BEV_BlackScreen = nil
                end
                pcall(function() settings().Rendering.QualityLevel = "Automatic" end)
            end
        end
    end
})

FarmSection:Space()

FarmSection:Toggle({
    Title = "Disable 3D Render (Anti Lag)",
    Desc = "Matikan layar grafik 3D SECARA INSTAN untuk menghemat CPU/GPU & cegah freeze.",
    Default = State.Disable3DRender or false,
    Callback = function(v)
        State.Disable3DRender = v
        if v then
            pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(false) end)
            if not _G.BEV_BlackScreen then
                local sg = Instance.new("ScreenGui")
                sg.Name = "BEV_BlackScreen"
                sg.IgnoreGuiInset = true
                sg.DisplayOrder = 999999
                local f = Instance.new("Frame", sg)
                f.Size = UDim2.new(1,0,1,0)
                f.BackgroundColor3 = Color3.fromRGB(0,0,0)
                local t = Instance.new("TextLabel", f)
                t.Size = UDim2.new(1,0,1,0)
                t.Text = "3D Render Disabled (Anti Lag)\nBeban CPU/GPU Berkurang drastis!\nMatikan fitur ini di GUI untuk memulihkan layar."
                t.TextColor3 = Color3.fromRGB(200, 200, 200)
                t.BackgroundTransparency = 1
                t.Font = Enum.Font.GothamBold
                t.TextSize = 24
                sg.Parent = game:GetService("CoreGui")
                _G.BEV_BlackScreen = sg
            end
            pcall(function() settings().Rendering.QualityLevel = 1 end)
        else
            pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(true) end)
            if _G.BEV_BlackScreen then
                pcall(function() _G.BEV_BlackScreen:Destroy() end)
                _G.BEV_BlackScreen = nil
            end
            pcall(function() settings().Rendering.QualityLevel = "Automatic" end)
        end
    end
})

FarmSection:Space()

FarmSection:Dropdown({
    Title = "Peran Akun",
    Desc = "Farming: Cari kata benar, menang otomatis\nTumbal: Sengaja salah agar akun Farming cepat menang",
    Multi = false,
    Value = State.FarmRole or "Farming",
    Values = { "Farming", "Tumbal" },
    Callback = function(v)
        State.FarmRole = v
        WindUI:Notify({ Title = "Peran Diubah", Content = "Sekarang: " .. v, Duration = 2 })
    end
})

FarmSection:Space()


FarmSection:Slider({
    Title = "Predictive Delay",
    Desc = "Jeda untuk Predictive Spam / Blatant (detik). Tidak mempengaruhi AutoFarm pipeline.",
    IsTooltip = true,
    Step = 0.05,
    Value = { Min = 0.0, Max = 1.0, Default = State.BlatantDelay or 0.0 },
    Callback = function(v)
        State.BlatantDelay = v
    end
})

FarmSection:Space()

FarmSection:Toggle({
    Title = "Predictive Spam",
    Desc = "Langsung tebak prefix selanjutnya tanpa nunggu server.\nSangat cepat untuk memenangkan permainan.",
    Default = State.BlatantPredict or false,
    Callback = function(v)
        State.BlatantPredict = v
    end
})

FarmSection:Space()

FarmSection:Slider({
    Title = "AFK Timeout",
    Desc = "Detik menunggu sebelum anggap match selesai & rejoin",
    IsTooltip = true,
    Step = 1.0,
    Value = { Min = 3.0, Max = 20.0, Default = State.AFKTimeout or 8.0 },
    Callback = function(v)
        State.AFKTimeout = v
    end
})

FarmSection:Space()


-- ═══════════════════════════════════════════════════════════════════════
-- BLATANT TAB — Exploit Features
-- ═══════════════════════════════════════════════════════════════════════
local BlatantTab = Window:Tab({
    Title = "Blatant",
    Icon = "solar:bomb-bold",
    IconColor = Color3.fromHex("#EF4444"),
    IconShape = "Square",
    Border = true,
})

local BlatantSection = BlatantTab:Section({
    Title = "💣 Blatant Mode",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

BlatantSection:Paragraph({
    Title = "⚠️ Peringatan",
    Desc = "Fitur ini mem-bypass filter kata. Kamu bisa menjawab dengan SEMBARANG KATA (asal ada di kamus) dan server akan menerimanya sebagai jawaban valid, MENGABAIKAN suku kata yang diminta.",
})

BlatantSection:Space()

BlatantSection:Toggle({
    Title = "Blatant Mode",
    Desc = "Bypass validasi suku kata server. Kirim kata apa saja = Valid.",
    Default = State.BlatantMode or false,
    Callback = function(v)
        State.BlatantMode = v
        if v then
            State.AutoEnabled = false
            State.AutoFarmEnabled = false
            SyncAutoFarmPipeline()
            State.SpoofedWord = ""
            State.SpoofedProgress = 0
            WindUI:Notify({
                Title = "💣 Blatant Mode ON",
                Content = "Semua yang kamu ketik akan dianggap valid oleh server!",
                Duration = 3,
            })
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════
-- SARAN KATA OVERLAY (V2 - Improved UX, Mobile, Kamus Integration)
-- ═══════════════════════════════════════════════════════════════════════
local OverlayScroll
local OverlayTitle
local OverlayCounter
local OverlayFrame
local OverlayLastSubmitRemote
local OverlayLastPrefix = ""
local OverlayStatsLabel
local OverlaySearchBox
local OverlayCategoryLabel
local OverlayCurrentCategoryIndex = 1
local OverlaySortMode = "random" -- random | asc | short | long
local OverlaySortLabel

local SORT_MODES = {"random", "asc", "short", "long"}
local SORT_LABELS = {random = "🔀 Acak", asc = "🔤 A-Z", short = "📏 Pendek", long = "📐 Panjang"}

-- Category color mapping
local CATEGORY_COLORS = {
    ["Semua"]     = Color3.fromHex("#A78BFA"),
    ["umum"]      = Color3.fromHex("#818CF8"),
    ["hewan"]     = Color3.fromHex("#34D399"),
    ["tumbuhan"]  = Color3.fromHex("#6EE7B7"),
    ["makanan"]   = Color3.fromHex("#FBBF24"),
    ["tempat"]    = Color3.fromHex("#60A5FA"),
    ["nama"]      = Color3.fromHex("#F472B6"),
    ["sifat"]     = Color3.fromHex("#FB923C"),
    ["kerja"]     = Color3.fromHex("#A78BFA"),
    ["benda"]     = Color3.fromHex("#38BDF8"),
}
local function getCatColor(cat)
    return CATEGORY_COLORS[cat] or Color3.fromHex("#94A3B8")
end

local function CreateOverlay()
    pcall(function() if Services.CoreGui:FindFirstChild("BEV_Overlay") then Services.CoreGui.BEV_Overlay:Destroy() end end)
    local Screen = Instance.new("ScreenGui", Services.CoreGui)
    Screen.Name = "BEV_Overlay"
    Screen.ResetOnSpawn = false
    Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local screenSize = Screen.AbsoluteSize
    local isMobile = screenSize.X < 800
    local overlayWidth = isMobile and math.max(screenSize.X * 0.42, 220) or math.max(math.min(screenSize.X * 0.26, 340), 240)
    local overlayHeight = isMobile and math.max(screenSize.Y * 0.6, 320) or math.max(math.min(screenSize.Y * 0.6, 600), 340)
    
    local Frame = Instance.new("Frame", Screen)
    OverlayFrame = Frame
    Frame.Size = UDim2.new(0, overlayWidth, 0, overlayHeight)
    Frame.Position = UDim2.new(1, -overlayWidth - 8, 0.06, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 10, 28)
    Frame.BackgroundTransparency = 0.03
    Frame.Active = true
    Frame.Draggable = true
    
    local corner = Instance.new("UICorner", Frame)
    corner.CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", Frame)
    stroke.Color = Color3.fromHex("#7C3AED")
    stroke.Thickness = 1.8
    stroke.Transparency = 0.2

    -- Drop shadow effect
    local shadow = Instance.new("ImageLabel", Frame)
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 0

    -- UIScale for mobile scaling
    local uiScale = Instance.new("UIScale", Frame)
    uiScale.Scale = State.OverlayScale
    State._overlayUIScale = uiScale

    -- ─── HEADER ────────────────────────────────────
    local headerHeight = isMobile and 56 or 52
    local headerBg = Instance.new("Frame", Frame)
    headerBg.Name = "Header"
    headerBg.Size = UDim2.new(1, 0, 0, headerHeight)
    headerBg.BackgroundColor3 = Color3.fromHex("#1E1042")
    headerBg.BorderSizePixel = 0
    headerBg.ZIndex = 2
    local headerCorner = Instance.new("UICorner", headerBg)
    headerCorner.CornerRadius = UDim.new(0, 16)
    -- Gradient on header
    local headerGradient = Instance.new("UIGradient", headerBg)
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#312E81")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#1E1042")),
    })
    headerGradient.Rotation = 90

    -- Drag handle indicator
    local dragHandle = Instance.new("Frame", headerBg)
    dragHandle.Size = UDim2.new(0, 40, 0, 4)
    dragHandle.Position = UDim2.new(0.5, -20, 0, 3)
    dragHandle.BackgroundColor3 = Color3.fromHex("#6D28D9")
    dragHandle.BackgroundTransparency = 0.4
    dragHandle.BorderSizePixel = 0
    dragHandle.ZIndex = 3
    local dhCorner = Instance.new("UICorner", dragHandle)
    dhCorner.CornerRadius = UDim.new(1, 0)

    -- Title
    OverlayTitle = Instance.new("TextLabel", headerBg)
    OverlayTitle.Size = UDim2.new(0.65, 0, 0, 22)
    OverlayTitle.Position = UDim2.new(0, 12, 0, 10)
    OverlayTitle.Text = "📖 KAMUS KATA"
    OverlayTitle.TextColor3 = Color3.fromHex("#F3E8FF")
    OverlayTitle.BackgroundTransparency = 1
    OverlayTitle.Font = Enum.Font.GothamBold
    OverlayTitle.TextSize = isMobile and 14 or 13
    OverlayTitle.TextXAlignment = Enum.TextXAlignment.Left
    OverlayTitle.ZIndex = 3

    -- Stats label (FPS/Ping)
    OverlayStatsLabel = Instance.new("TextLabel", headerBg)
    OverlayStatsLabel.Size = UDim2.new(0.35, -10, 0, 16)
    OverlayStatsLabel.Position = UDim2.new(0.6, 0, 0, 10)
    OverlayStatsLabel.Text = "-- fps"
    OverlayStatsLabel.TextColor3 = Color3.fromHex("#86EFAC")
    OverlayStatsLabel.BackgroundTransparency = 1
    OverlayStatsLabel.Font = Enum.Font.GothamMedium
    OverlayStatsLabel.TextSize = 10
    OverlayStatsLabel.TextXAlignment = Enum.TextXAlignment.Right
    OverlayStatsLabel.ZIndex = 3
    State._overlayStatsLabel = OverlayStatsLabel

    -- Counter (prefix info)
    OverlayCounter = Instance.new("TextLabel", headerBg)
    OverlayCounter.Size = UDim2.new(1, -20, 0, 14)
    OverlayCounter.Position = UDim2.new(0, 12, 0, 34)
    OverlayCounter.Text = "Menunggu soal..."
    OverlayCounter.TextColor3 = Color3.fromHex("#C4B5FD")
    OverlayCounter.BackgroundTransparency = 1
    OverlayCounter.Font = Enum.Font.Gotham
    OverlayCounter.TextSize = isMobile and 10 or 9
    OverlayCounter.TextXAlignment = Enum.TextXAlignment.Left
    OverlayCounter.ZIndex = 3

    -- Minimize button
    local minBtnSize = isMobile and 32 or 26
    local minBtn = Instance.new("TextButton", headerBg)
    minBtn.Size = UDim2.new(0, minBtnSize, 0, minBtnSize)
    minBtn.Position = UDim2.new(1, -minBtnSize - 6, 0, 10)
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.fromHex("#F3E8FF")
    minBtn.BackgroundColor3 = Color3.fromHex("#4C1D95")
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = isMobile and 18 or 16
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 4
    local minBtnCorner = Instance.new("UICorner", minBtn)
    minBtnCorner.CornerRadius = UDim.new(0, 8)

    -- ─── SEARCH BOX ────────────────────────────────
    local searchHeight = isMobile and 36 or 30
    local searchY = headerHeight + 6
    OverlaySearchBox = Instance.new("TextBox", Frame)
    OverlaySearchBox.Name = "SearchBox"
    OverlaySearchBox.Text = ""
    OverlaySearchBox.Size = UDim2.new(1, -14, 0, searchHeight)
    OverlaySearchBox.Position = UDim2.new(0, 7, 0, searchY)
    OverlaySearchBox.BackgroundColor3 = Color3.fromHex("#1A0F2E")
    OverlaySearchBox.TextColor3 = Color3.fromHex("#F3E8FF")
    OverlaySearchBox.PlaceholderText = "🔍 Cari kata..."
    OverlaySearchBox.PlaceholderColor3 = Color3.fromHex("#7C3AED")
    OverlaySearchBox.Font = Enum.Font.GothamMedium
    OverlaySearchBox.TextSize = isMobile and 14 or 12
    OverlaySearchBox.ClearTextOnFocus = false
    OverlaySearchBox.TextXAlignment = Enum.TextXAlignment.Left
    OverlaySearchBox.ZIndex = 2
    local searchCorner = Instance.new("UICorner", OverlaySearchBox)
    searchCorner.CornerRadius = UDim.new(0, 8)
    local searchStroke = Instance.new("UIStroke", OverlaySearchBox)
    searchStroke.Color = Color3.fromHex("#6D28D9")
    searchStroke.Thickness = 1
    local searchPadding = Instance.new("UIPadding", OverlaySearchBox)
    searchPadding.PaddingLeft = UDim.new(0, 8)

    -- ─── CATEGORY + SORT BAR ──────────────────────
    local barY = searchY + searchHeight + 4
    local barHeight = isMobile and 38 or 34
    local catBarBg = Instance.new("Frame", Frame)
    catBarBg.Name = "ControlBar"
    catBarBg.Size = UDim2.new(1, 0, 0, barHeight)
    catBarBg.Position = UDim2.new(0, 0, 0, barY)
    catBarBg.BackgroundColor3 = Color3.fromHex("#130B24")
    catBarBg.BorderSizePixel = 0
    catBarBg.ZIndex = 2

    -- Arrows and category
    local arrowSize = isMobile and 32 or 28
    local leftArrow = Instance.new("TextButton", catBarBg)
    leftArrow.Size = UDim2.new(0, arrowSize, 0, arrowSize)
    leftArrow.Position = UDim2.new(0, 3, 0.5, -arrowSize/2)
    leftArrow.Text = "◀"
    leftArrow.TextColor3 = Color3.fromHex("#E9D5FF")
    leftArrow.BackgroundColor3 = Color3.fromHex("#4C1D95")
    leftArrow.Font = Enum.Font.GothamBold
    leftArrow.TextSize = isMobile and 14 or 12
    leftArrow.AutoButtonColor = false
    leftArrow.ZIndex = 3
    local leftCorner = Instance.new("UICorner", leftArrow)
    leftCorner.CornerRadius = UDim.new(0, 6)

    OverlayCategoryLabel = Instance.new("TextLabel", catBarBg)
    OverlayCategoryLabel.Size = UDim2.new(0.48, -arrowSize, 0, arrowSize)
    OverlayCategoryLabel.Position = UDim2.new(0, arrowSize + 6, 0.5, -arrowSize/2)
    OverlayCategoryLabel.Text = "Semua"
    OverlayCategoryLabel.TextColor3 = getCatColor("Semua")
    OverlayCategoryLabel.BackgroundColor3 = Color3.fromHex("#1A0F2E")
    OverlayCategoryLabel.Font = Enum.Font.GothamBold
    OverlayCategoryLabel.TextSize = isMobile and 12 or 11
    OverlayCategoryLabel.ZIndex = 3
    local catCorner = Instance.new("UICorner", OverlayCategoryLabel)
    catCorner.CornerRadius = UDim.new(0, 6)

    local rightArrow = Instance.new("TextButton", catBarBg)
    rightArrow.Size = UDim2.new(0, arrowSize, 0, arrowSize)
    rightArrow.Position = UDim2.new(0.48, 2, 0.5, -arrowSize/2)
    rightArrow.Text = "▶"
    rightArrow.TextColor3 = Color3.fromHex("#E9D5FF")
    rightArrow.BackgroundColor3 = Color3.fromHex("#4C1D95")
    rightArrow.Font = Enum.Font.GothamBold
    rightArrow.TextSize = isMobile and 14 or 12
    rightArrow.AutoButtonColor = false
    rightArrow.ZIndex = 3
    local rightCornerBtn = Instance.new("UICorner", rightArrow)
    rightCornerBtn.CornerRadius = UDim.new(0, 6)

    -- Sort button
    OverlaySortLabel = Instance.new("TextButton", catBarBg)
    OverlaySortLabel.Size = UDim2.new(0.48, -6, 0, arrowSize)
    OverlaySortLabel.Position = UDim2.new(0.52, 0, 0.5, -arrowSize/2)
    OverlaySortLabel.Text = SORT_LABELS[OverlaySortMode]
    OverlaySortLabel.TextColor3 = Color3.fromHex("#FBBF24")
    OverlaySortLabel.BackgroundColor3 = Color3.fromHex("#1A0F2E")
    OverlaySortLabel.Font = Enum.Font.GothamBold
    OverlaySortLabel.TextSize = isMobile and 11 or 10
    OverlaySortLabel.AutoButtonColor = false
    OverlaySortLabel.ZIndex = 3
    local sortCorner = Instance.new("UICorner", OverlaySortLabel)
    sortCorner.CornerRadius = UDim.new(0, 6)

    -- ─── SCROLL LIST ───────────────────────────────
    local scrollY = barY + barHeight + 4
    OverlayScroll = Instance.new("ScrollingFrame", Frame)
    OverlayScroll.Name = "WordList"
    OverlayScroll.Size = UDim2.new(0.94, 0, 1, -scrollY - 6)
    OverlayScroll.Position = UDim2.new(0.03, 0, 0, scrollY)
    OverlayScroll.BackgroundTransparency = 1
    OverlayScroll.ScrollBarThickness = isMobile and 10 or 7
    OverlayScroll.ScrollBarImageColor3 = Color3.fromHex("#7C3AED")
    OverlayScroll.ScrollBarImageTransparency = 0.2
    OverlayScroll.Active = true
    OverlayScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    OverlayScroll.ElasticBehavior = Enum.ElasticBehavior.Always
    OverlayScroll.ZIndex = 2
    local layout = Instance.new("UIListLayout", OverlayScroll)
    layout.Padding = UDim.new(0, isMobile and 5 or 3)
    local scrollPadding = Instance.new("UIPadding", OverlayScroll)
    scrollPadding.PaddingRight = UDim.new(0, 4)

    -- ─── EVENT HANDLERS ────────────────────────────
    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Frame.Size = UDim2.new(0, overlayWidth, 0, headerHeight)
        else
            Frame.Size = UDim2.new(0, overlayWidth, 0, overlayHeight)
        end
        OverlayScroll.Visible = not isMinimized
        OverlaySearchBox.Visible = not isMinimized
        catBarBg.Visible = not isMinimized
        minBtn.Text = isMinimized and "+" or "−"
    end)

    leftArrow.MouseButton1Click:Connect(function()
        OverlayCurrentCategoryIndex = OverlayCurrentCategoryIndex - 1
        if OverlayCurrentCategoryIndex < 1 then
            OverlayCurrentCategoryIndex = #State.CategoryList
        end
        State.ActiveCategory = State.CategoryList[OverlayCurrentCategoryIndex]
        OverlayCategoryLabel.Text = State.ActiveCategory
        OverlayCategoryLabel.TextColor3 = getCatColor(State.ActiveCategory)
        if OverlayLastSubmitRemote then
            UpdateOverlay(OverlayLastPrefix, OverlayLastSubmitRemote)
        end
    end)

    rightArrow.MouseButton1Click:Connect(function()
        OverlayCurrentCategoryIndex = OverlayCurrentCategoryIndex + 1
        if OverlayCurrentCategoryIndex > #State.CategoryList then
            OverlayCurrentCategoryIndex = 1
        end
        State.ActiveCategory = State.CategoryList[OverlayCurrentCategoryIndex]
        OverlayCategoryLabel.Text = State.ActiveCategory
        OverlayCategoryLabel.TextColor3 = getCatColor(State.ActiveCategory)
        if OverlayLastSubmitRemote then
            UpdateOverlay(OverlayLastPrefix, OverlayLastSubmitRemote)
        end
    end)

    -- Sort cycle
    OverlaySortLabel.MouseButton1Click:Connect(function()
        local currentIdx = 1
        for i, mode in ipairs(SORT_MODES) do
            if mode == OverlaySortMode then currentIdx = i break end
        end
        currentIdx = currentIdx % #SORT_MODES + 1
        OverlaySortMode = SORT_MODES[currentIdx]
        OverlaySortLabel.Text = SORT_LABELS[OverlaySortMode]
        if OverlayLastSubmitRemote then
            UpdateOverlay(OverlayLastPrefix, OverlayLastSubmitRemote)
        end
    end)

    OverlaySearchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            if OverlayLastSubmitRemote then
                UpdateOverlay(OverlayLastPrefix, OverlayLastSubmitRemote)
            end
        end
    end)
end

local function UpdateOverlay(prefix, submitRemote)
    if not OverlayScroll then return end
    OverlayLastPrefix = prefix
    OverlayLastSubmitRemote = submitRemote
    for _, v in pairs(OverlayScroll:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end

    local searchTerm = OverlaySearchBox and OverlaySearchBox.Text:lower() or ""
    local bucket = State.Index[prefix:sub(1, 1):lower()] or {}
    local candidates = {}

    if searchTerm ~= "" then
        -- Global search dari semua database
        for firstLetter, wordBucket in pairs(State.Index) do
            for _, w in ipairs(wordBucket) do
                if not State.UsedWords[w] and w:lower():find(searchTerm, 1, true) then
                    table.insert(candidates, w)
                end
            end
        end
    else
        -- Prefix-based search dengan kategori filter
        for _, w in ipairs(bucket) do
            if w:sub(1, #prefix) == prefix and not State.UsedWords[w] then
                if State.ActiveCategory == "Semua" or State.CategoryWords[w] == State.ActiveCategory then
                    table.insert(candidates, w)
                end
            end
        end
    end

    -- Sort berdasarkan mode yang dipilih
    if OverlaySortMode == "asc" then
        table.sort(candidates, function(a, b) return a:lower() < b:lower() end)
    elseif OverlaySortMode == "short" then
        table.sort(candidates, function(a, b) return #a < #b end)
    elseif OverlaySortMode == "long" then
        table.sort(candidates, function(a, b) return #a > #b end)
    else -- random
        for i = #candidates, 2, -1 do
            local j = math.random(1, i)
            candidates[i], candidates[j] = candidates[j], candidates[i]
        end
    end

    -- Update counter text
    if OverlayCounter then
        local catText = searchTerm ~= "" and ("Cari: \"" .. searchTerm .. "\"") or ("Kategori: " .. State.ActiveCategory)
        OverlayCounter.Text = "\"" .. prefix .. "\" | " .. #candidates .. " kata | " .. catText
    end
    if OverlayTitle then
        OverlayTitle.Text = "📖 " .. (#candidates > 0 and #candidates or "0") .. " SARAN"
    end

    -- Limit display
    local MAX_SHOWN = 200
    local shown = 0
    local isMobile = (OverlayFrame and OverlayFrame.AbsoluteSize.X < 280)
    local btnHeight = isMobile and 42 or 36

    -- Color scheme (alternating rows)
    local rowColors = {
        Color3.fromHex("#1A0F2E"),
        Color3.fromHex("#170D28"),
    }

    for _, w in ipairs(candidates) do
        if shown >= MAX_SHOWN then break end
        
        local colorIdx = (shown % 2) + 1
        local catTag = State.CategoryWords[w] or "umum"
        local catColor = getCatColor(catTag)

        -- Main button container
        local btn = Instance.new("TextButton", OverlayScroll)
        btn.Name = "Word_" .. w
        btn.Size = UDim2.new(1, -4, 0, btnHeight)
        btn.BackgroundColor3 = rowColors[colorIdx]
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.ZIndex = 2
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)

        -- Left accent bar (category color)
        local accentBar = Instance.new("Frame", btn)
        accentBar.Size = UDim2.new(0, 3, 0.7, 0)
        accentBar.Position = UDim2.new(0, 2, 0.15, 0)
        accentBar.BackgroundColor3 = catColor
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 3
        local abCorner = Instance.new("UICorner", accentBar)
        abCorner.CornerRadius = UDim.new(1, 0)

        -- Word text (with prefix highlighted)
        local wordLabel = Instance.new("TextLabel", btn)
        wordLabel.Size = UDim2.new(0.65, -10, 0, btnHeight * 0.55)
        wordLabel.Position = UDim2.new(0, 12, 0, 2)
        wordLabel.BackgroundTransparency = 1
        wordLabel.Font = Enum.Font.GothamBold
        wordLabel.TextSize = isMobile and 14 or 13
        wordLabel.TextXAlignment = Enum.TextXAlignment.Left
        wordLabel.TextColor3 = Color3.fromHex("#F3E8FF")
        wordLabel.ZIndex = 3
        wordLabel.RichText = true
        -- Highlight prefix in word
        local prefixLen = #prefix
        if w:sub(1, prefixLen):lower() == prefix:lower() then
            wordLabel.Text = "<font color=\"#C084FC\"><b>" .. w:sub(1, prefixLen) .. "</b></font>" .. w:sub(prefixLen + 1)
        else
            wordLabel.Text = w
        end

        -- Word length + category badge row
        local infoLabel = Instance.new("TextLabel", btn)
        infoLabel.Size = UDim2.new(0.65, -10, 0, btnHeight * 0.35)
        infoLabel.Position = UDim2.new(0, 12, 0, btnHeight * 0.55 + 2)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = isMobile and 10 or 9
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.TextColor3 = Color3.fromHex("#9CA3AF")
        infoLabel.ZIndex = 3
        infoLabel.Text = #w .. " huruf"

        -- Category badge (right side)
        local badge = Instance.new("TextLabel", btn)
        badge.Size = UDim2.new(0, isMobile and 60 or 52, 0, isMobile and 20 or 18)
        badge.Position = UDim2.new(1, isMobile and -66 or -58, 0.5, isMobile and -10 or -9)
        badge.Text = catTag
        badge.TextColor3 = catColor
        badge.BackgroundColor3 = Color3.new(catColor.R * 0.2, catColor.G * 0.2, catColor.B * 0.2)
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = isMobile and 9 or 8
        badge.ZIndex = 3
        local badgeCorner = Instance.new("UICorner", badge)
        badgeCorner.CornerRadius = UDim.new(1, 0)

        local originalBg = btn.BackgroundColor3

        -- Hover effects
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromHex("#2D1B6B")
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = originalBg
        end)

        -- Click to submit
        btn.MouseButton1Click:Connect(function()
            submitRemote:FireServer(w)
            State.UsedWords[w] = true
            -- Success animation
            btn.BackgroundColor3 = Color3.fromHex("#065F46")
            wordLabel.Text = "✅ " .. w
            wordLabel.TextColor3 = Color3.fromHex("#A7F3D0")
            infoLabel.Text = "Terkirim!"
            infoLabel.TextColor3 = Color3.fromHex("#6EE7B7")
            badge.Visible = false
            accentBar.BackgroundColor3 = Color3.fromHex("#34D399")
            task.delay(1.2, function()
                if btn.Parent then btn:Destroy() end
            end)
        end)
        shown = shown + 1
    end

    OverlayScroll.CanvasSize = UDim2.new(0, 0, 0, shown * (btnHeight + (isMobile and 5 or 3)) + 10)
end

-- Main init loop
local function Init()
    CreateOverlay()
    local MatchRemote = Services.ReplicatedStorage:FindFirstChild("MatchUI", true)
    local SubmitRemote = Services.ReplicatedStorage:FindFirstChild("SubmitWord", true)
    local VisualRemote = Services.ReplicatedStorage:FindFirstChild("BillboardUpdate", true)

    if not MatchRemote or not SubmitRemote then
        WindUI:Notify({ Title = "Error", Content = "Remote tidak ditemukan!", Duration = 5 })
        return
    end

    -- ANTI AFK BAWAAN: Otomatis aktif saat Auto Play atau AutoFarm menyala
    task.spawn(function()
        while State.IsRunning do
            if State.AutoEnabled or State.AutoFarmEnabled then
                pcall(function()
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
                pcall(function()
                    local player = Services.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0.001)
                        task.wait(0.1)
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.001)
                    end
                end)
            end
            task.wait(30)
        end
    end)

    -- FLOW HIJACKER: Intercept ALL typing states and spoof the sequence
    State.IsScriptSpoofing = false
    State.SpoofedWord = ""
    State.SpoofedProgress = 0
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if checkcaller() then return oldNamecall(self, ...) end
        
        local method = getnamecallmethod()
        local remoteName = tostring(self)
        
        if method == "FireServer" then
            -- Let our own automated spoofing bypass the hook!
            if State.IsScriptSpoofing then
                return oldNamecall(self, ...)
            end

            -- If BlatantMode is ON, hijack typing sequence
            if State.BlatantMode and State.CurrentSoal ~= "" then
            
                -- 1. Pick winning word ketika submit, abaikan BillboardUpdate
                if remoteName == "BillboardUpdate" then
                    -- Biarkan ketikan ngawur dikirim secara visual ke musuh di layar
                    return oldNamecall(self, ...)
                end

                -- 2. Intercept final submit and send the winning word instead
                if remoteName == "SubmitWord" then
                    local args = {...}
                    if type(args[1]) == "string" then
                        local typedSpam = args[1]:lower()
                        local bestWord = nil
                        
                        -- Coba cari kata valid yang ujungnya sama dengan kata spam yg diketik user
                        -- Misal ngetik spam "kaloqwdwadjan", cari kata berawalan "KA" dan berakhiran "an", "n"
                        local searchSuffixes = {}
                        local spamLen = #typedSpam
                        if spamLen >= 4 then table.insert(searchSuffixes, typedSpam:sub(-4)) end
                        if spamLen >= 3 then table.insert(searchSuffixes, typedSpam:sub(-3)) end
                        if spamLen >= 2 then table.insert(searchSuffixes, typedSpam:sub(-2)) end
                        if spamLen >= 1 then table.insert(searchSuffixes, typedSpam:sub(-1)) end
                        
                        for _, suff in ipairs(searchSuffixes) do
                            local possible = {}
                            local prefix = State.CurrentSoal
                            local bucket = State.Index[prefix:sub(1,1):lower()] or {}
                            
                            for _, w in ipairs(bucket) do
                                if w:sub(1, #prefix) == prefix and not State.UsedWords[w] then
                                    if w:sub(-#suff) == suff then
                                        table.insert(possible, w)
                                    end
                                end
                            end
                            
                            if #possible > 0 then
                                -- Pilih kata acak yang berakhiran paling selaras dengan ketikan user
                                bestWord = possible[math.random(1, #possible)]
                                break
                            end
                        end
                        
                        -- Kalau ngga ada satupun kata yang akhirannya pas, fallback ke normal Blatant 
                        if not bestWord then
                            bestWord = FindWord(State.CurrentSoal) or ""
                        end
                        
                        if bestWord ~= "" then
                            -- Diam-diam tukar kata ngawur dengan kata valid & ngepas
                            task.spawn(function()
                                State.IsScriptSpoofing = true
                                local SubmitRemote = game:GetService("ReplicatedStorage"):FindFirstChild("SubmitWord", true)
                                if SubmitRemote then
                                    pcall(function() SubmitRemote:FireServer(bestWord) end)
                                end
                                State.IsScriptSpoofing = false
                            end)
                            
                            State.UsedWords[bestWord] = true
                            State.LastWordAttempted = bestWord
                            State.LastSubmitTime = tick()
                            State.HasSubmitted = true
                            State.SubmitPending = true
                            State.SpoofedWord = ""
                            State.SpoofedProgress = 0
                            UnlockWord()
                            
                            return oldNamecall(self, ...)
                        end
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)

    local function IsTumbalPipelineActive()
        return State.FarmRole == "Tumbal" and State.AutoFarmEnabled
    end

    local function IsFarmingPipelineActive()
        return State.FarmRole == "Farming" and State.AutoFarmEnabled
    end

    local function RunTumbalTurn(execId, prefix)
        if not prefix or prefix == "" then return 0 end
        if not IsTumbalPipelineActive() then return 0 end
        if State.KaitunExecId ~= execId then return 0 end

        local sent = 0
        while sent < 5
            and State.IsRunning
            and State.KaitunExecId == execId
            and State.CurrentSoal == prefix
            and IsTumbalPipelineActive()
        do
            local garbageWord = prefix .. "awikwok" .. string.char(math.random(97, 122), math.random(97, 122), math.random(97, 122))

            pcall(function()
                if VisualRemote then
                    VisualRemote:FireServer(prefix)
                    task.wait(0.03 + math.random() * 0.02)
                    VisualRemote:FireServer(garbageWord)
                end
            end)
            
            task.wait(0.04)
            pcall(function() SubmitRemote:FireServer(garbageWord) end)

            sent = sent + 1
            State.LastWordAttempted = garbageWord
            State.LastSubmitTime = tick()
            
            -- Jeda antar strike biar gak kecepetan tapi ttp efektif!
            task.wait(0.08 + math.random() * 0.07) 
        end

        if sent > 0 then
            State.HasSubmitted = true
            State.SubmitPending = true
        end
        return sent
    end

    local function RunFarmingTurn(execId, prefix)
        if not prefix or prefix == "" then return false end
        if not IsFarmingPipelineActive() then return false end
        if State.KaitunExecId ~= execId then return false end

        local word = FindWord(prefix)
        if word and not State.UsedWords[word] then
            pcall(function()
                if VisualRemote then
                    VisualRemote:FireServer(word)
                end
            end)
            pcall(function() SubmitRemote:FireServer(word) end)
            State.UsedWords[word] = true
            State.LastWordAttempted = word
            State.LastSubmitTime = tick()
            State.HasSubmitted = true
            State.SubmitPending = true
            UnlockWord()
            return true
        end
        return false
    end

    local function DispatchKaitun(prefix, requireTurn)
        if not State.AutoFarmEnabled then
            return
        end
        if State.KaitunBusy then
            return
        end

        if (not prefix or prefix == "") and requireTurn then
            local waited = 0
            while State.IsRunning
                and State.AutoFarmEnabled
                and State.IsMyTurn
                and (not State.CurrentSoal or State.CurrentSoal == "")
                and waited < 20
            do
                waited = waited + 1
                task.wait(0.05)
            end
            prefix = State.CurrentSoal
        end

        if not prefix or prefix == "" then
            return
        end
        if requireTurn and not State.IsMyTurn then
            return
        end

        -- Dedupe rapid duplicate event bursts
        if (not requireTurn)
            and State.LastKaitunPrefix == prefix
            and (tick() - State.LastKaitunDispatch) < 0.15
        then
            return
        end

        State.LastKaitunPrefix = prefix
        State.LastKaitunDispatch = tick()
        State.KaitunExecId = State.KaitunExecId + 1
        local execId = State.KaitunExecId
        State.KaitunBusy = true

        task.spawn(function()
            local function doneLog(msg)
                State.KaitunBusy = false
            end

            if not State.AutoFarmEnabled then doneLog("Abort"); return end
            if State.KaitunExecId ~= execId then doneLog("Abort"); return end
            if State.CurrentSoal ~= prefix then doneLog("Abort"); return end
            if requireTurn and not State.IsMyTurn then doneLog("Abort"); return end

            if State.FarmRole == "Tumbal" then
                local count = RunTumbalTurn(execId, prefix)
                doneLog("Tumbal sent")
            else
                local ok = RunFarmingTurn(execId, prefix)
                doneLog("Farming submitted")
            end
        end)
    end

    -- EVENT LISTENER
    State.MatchRemoteConn = MatchRemote.OnClientEvent:Connect(function(...)
        local args = { ... }

        local newlyUsedWord = nil
        pcall(function() newlyUsedWord = ScanForUsedWords(args) end)

        -- Turn tracking (pengganti BillboardStart/BillboardEnd)
        if args[1] == "StartTurn" then
            State.IsMyTurn = true
            if State.AutoFarmEnabled and State.FarmRole == "Tumbal" then
                DispatchKaitun(State.CurrentSoal, true)
            end
        elseif args[1] == "UpdateTimer" then
            local timerVal = tonumber(args[2])
            if timerVal
                and timerVal >= 13
                and timerVal <= 15
                and State.AutoFarmEnabled
                and State.FarmRole == "Tumbal"
                and State.IsMyTurn
                and not State.HasSubmitted
                and not State.SubmitPending
            then
                DispatchKaitun(State.CurrentSoal, true)
            end
        elseif args[1] == "EndTurn" then
            State.IsMyTurn = false
            State.KaitunBusy = false
            State.SpoofedWord = ""
            State.SpoofedProgress = 0
        end

        -- PREDICTIVE BLATANT MODE
        -- Kalau ada kata yang baru masuk (berarti ada yang baru jawab bener), langsung tebak huruf ujungnya!
        if State.AutoFarmEnabled and State.BlatantPredict and newlyUsedWord then
            local predictedPrefix = newlyUsedWord:sub(-1)
            task.spawn(function()
                if State.BlatantDelay > 0 then task.wait(State.BlatantDelay) end
                local word = FindWord(predictedPrefix)
                if word and not State.UsedWords[word] then
                    -- Tembak peluru sebelum server ganti giliran!
                    pcall(function() VisualRemote:FireServer(word) end)
                    pcall(function() SubmitRemote:FireServer(word) end)
                    State.UsedWords[word] = true
                    State.LastWordAttempted = word
                    State.LastSubmitTime = tick()
                    State.HasSubmitted = true
                    State.SubmitPending = true
                    UnlockWord()
                end
            end)
        end
        if args[1] == "UpdateServerLetter" and args[2] then
            local letter = tostring(args[2]):lower()
            State.LastTurnTime = tick() -- Reset detektor idle game over

            if State.CurrentSoal ~= letter then
                if State.LockedPrefix ~= letter then
                    UnlockWord()
                end

                -- Prefix berubah = jawaban sebelumnya diterima (atau orang lain jawab)
                if State.HasSubmitted and State.SubmitPending then
                    -- Jawaban BERHASIL! Prefix berubah berarti server menerima kata kita
                    State.TotalCorrect = State.TotalCorrect + 1
                    State.ConsecutiveErrors = 0
                end

                -- Reset semua state untuk soal baru
                State.CurrentSoal = letter
                State.ActiveTask = false
                State.IsBackspacing = false
                State.HasSubmitted = false
                State.SubmitPending = false
                State.CurrentTypedText = ""
                State.LastSubmitTime = tick() -- reset timer agar watchdog tidak langsung fire

                if State.AutoFarmEnabled then
                    pcall(function() UpdateOverlay(letter, SubmitRemote) end)
                    DispatchKaitun(letter, false)
                elseif State.AutoEnabled then
                    pcall(function() UpdateOverlay(letter, SubmitRemote) end)
                    -- Hapus task.spawn pengetikan proaktif di sini karena
                    -- pengetikan untuk AutoPlay sekarang dikendalikan pelatuk "StartTurn" 
                else
                    -- Mode manual (auto/blatant mati)
                    pcall(function() UpdateOverlay(letter, SubmitRemote) end)
                end
            end
        end

        -- Trigger pengetikan AutoPlay SAAT GILIRAN KITA dimulai 
        -- (menutup celah ngetik di giliran musuh)
        if args[1] == "StartTurn" and State.AutoEnabled and not State.AutoFarmEnabled then
            local currentSoalAtStart = State.CurrentSoal
            if currentSoalAtStart ~= "" then
                task.spawn(function()
                    local word = nil
                    local retries = 0
                    while not word and State.IsRunning do
                        word = FindWord(currentSoalAtStart)
                        if word then break end
                        retries = retries + 1
                        if retries > 10 then return end
                        task.wait(1)
                        if not State.AutoEnabled or State.CurrentSoal ~= currentSoalAtStart then return end
                    end
                    
                    if State.AutoEnabled and State.CurrentSoal == currentSoalAtStart and State.IsMyTurn then
                        ExecuteReactivePlay(word, #State.CurrentSoal, SubmitRemote, VisualRemote)
                    end
                end)
            end
        end
    end)

    -- POST-SUBMIT WATCHDOG
    -- Menangani rejection untuk KEDUA mode: AutoPlay dan Blatant
    task.spawn(function()
        while State.IsRunning do
            task.wait(0.8)

            -- === AUTO PLAY MODE WATCHDOG ===
            if State.AutoEnabled
                and State.HasSubmitted
                and State.SubmitPending
                and not State.ActiveTask
                and not State.IsBackspacing
                and State.CurrentSoal ~= ""
                and (tick() - State.LastSubmitTime > 2.5)
            then
                -- Kata ditolak server — backspace lalu retry
                State.TotalErrors = State.TotalErrors + 1
                State.ConsecutiveErrors = State.ConsecutiveErrors + 1

                if State.LastWordAttempted ~= "" then
                    State.RejectedWords[State.LastWordAttempted] = true
                    State.UsedWords[State.LastWordAttempted] = true
                end

                State.HasSubmitted = false
                State.SubmitPending = false

                -- Backspace: hapus hanya sampai prefix, sisakan prefix
                task.wait(0.3)
                if State.CurrentTypedText ~= "" and VisualRemote then
                    BackspaceText(VisualRemote, State.CurrentTypedText, #State.CurrentSoal)
                end

                UnlockWord()

                -- Coba kata baru
                local retry = FindWord(State.CurrentSoal, true)
                if retry then
                    State.ActiveTask = false
                    ExecuteReactivePlay(retry, #State.CurrentSoal, SubmitRemote, VisualRemote)
                else
                    State.ActiveTask = false
                    State.RejectedWords = {}
                end

                State.LastSubmitTime = tick()
            end

            -- === AUTO FARM (FARMING ROLE) RETRY WATCHDOG ===
            if State.AutoFarmEnabled
                and State.FarmRole == "Farming"
                and State.HasSubmitted
                and State.SubmitPending
                and State.CurrentSoal ~= ""
                and (tick() - State.LastSubmitTime > 0.8)
            then
                State.TotalErrors = State.TotalErrors + 1
                State.ConsecutiveErrors = State.ConsecutiveErrors + 1

                if State.LastWordAttempted ~= "" then
                    State.RejectedWords[State.LastWordAttempted] = true
                    State.UsedWords[State.LastWordAttempted] = true
                end

                State.HasSubmitted = false
                State.SubmitPending = false
                UnlockWord()

                local retry = FindWord(State.CurrentSoal, true)
                if retry then
                    pcall(function()
                        if VisualRemote then
                            VisualRemote:FireServer(retry)
                        end
                    end)
                    pcall(function() SubmitRemote:FireServer(retry) end)
                    State.UsedWords[retry] = true
                    State.LastWordAttempted = retry
                    State.LastSubmitTime = tick()
                    State.HasSubmitted = true
                    State.SubmitPending = true
                else
                    State.RejectedWords = {}
                    State.LastSubmitTime = tick()
                end
            end
        end
    end)

    -- AFK FARM PIPELINE WATCHDOG
    -- Kalau game selesai (berada di lobby) & fitur menyala, dia akan mencari meja dan Join
    task.spawn(function()
        local JoinTableRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
        if JoinTableRemote then JoinTableRemote = JoinTableRemote:WaitForChild("JoinTable", 5) end

        while State.IsRunning do
            task.wait(2.5)

            -- RESET LOGIC (Fallback Timeout Game Over)
            -- Kalau gamenya diam tanpa nge-print soal baru selama AFKTimeout detik,
            -- anggap match sudah kelar dan paksa kembali ke state lobby ("").
            -- HANYA aktif saat AutoFarm Pipeline, agar tidak membunuh Auto Play biasa
            if State.AutoFarmPipeline and State.CurrentSoal ~= "" and State.LastTurnTime > 0 and (tick() - State.LastTurnTime > State.AFKTimeout) then
                State.CurrentSoal = ""
                WindUI:Notify({ Title = "AFK Manager", Content = "Match Over terdeteksi (Idle " ..
                tostring(State.AFKTimeout) .. "s).", Duration = 2 })
            end

            if State.AutoFarmPipeline and State.CurrentSoal == "" then
                -- Kita sedang di luar match (lobby / game over)
                if not JoinTableRemote then continue end

                -- Bila TargetTable belum ada, paksa patok ke Table_2P_1
                -- Berguna untuk sinkronisasi 2 akun di private server agar selalu bertemu di meja yang sama!
                if State.TargetTable == "" then
                    State.TargetTable = "Table_2P_1"
                    WindUI:Notify({ Title = "AFK Pipeline", Content = "Memaksa join ke Table_2P_1", Duration = 2 })
                end

                -- Eksekusi Rejoin ke target meja
                if State.TargetTable ~= "" then
                    pcall(function()
                        JoinTableRemote:FireServer(State.TargetTable)
                    end)
                end
            end
        end
    end)

    -- LIVE STATS LOOP (FPS + Ping) — update overlay header
    task.spawn(function()
        while State.IsRunning do
            local fps = 60
            pcall(function()
                fps = math.floor(workspace:GetRealPhysicsFPS())
            end)

            local ping = 0
            pcall(function()
                ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            end)
            if ping == 0 then
                pcall(function()
                    local perfStats = game:GetService("Stats"):FindFirstChild("PerformanceStats")
                    if perfStats and perfStats:FindFirstChild("Ping") then
                        ping = math.floor(perfStats.Ping:GetValue())
                    end
                end)
            end

            pcall(function()
                local sl = State._overlayStatsLabel
                if sl then
                    local fpsColor = fps >= 50 and Color3.fromHex("#34D399") or
                    (fps >= 30 and Color3.fromHex("#FBBF24") or Color3.fromHex("#F87171"))
                    sl.Text = tostring(fps) .. " fps | " .. tostring(ping) .. " ms"
                    sl.TextColor3 = fpsColor
                end
            end)

            task.wait(1)
        end
    end)

    -- Initialize LastSubmitTime agar watchdog tidak langsung fire
    State.LastSubmitTime = tick()

    -- Hitung total kata di kamus
    local totalKata = 0
    for _, bucket in pairs(State.Index) do
        totalKata = totalKata + #bucket
    end

    WindUI:Notify({
        Title = "✦ Beverly Hub V 3.5",
        Content = "Loaded! Kamus: " .. tostring(loadSuccess and (totalKata .. " kata ✓") or "Fallback ⚠"),
        Icon = "solar:star-bold",
        Duration = 5,
    })
    -- ═══════════════════════════════════════════════════════════════════════
    -- CONFIGS TAB — Multi-Config User Interface
    -- ═══════════════════════════════════════════════════════════════════════
    local ConfigTab = Window:Tab({
        Title = "Configs",
        Icon = "folder-open",
        IconShape = "Square",
        Border = true,
    })

    local ConfigSection = ConfigTab:Section({
        Title = "⚙ Configuration Manager",
        Box = true,
        BoxBorder = true,
        Opened = true,
    })

    -- Helper Utilities
    local ConfigsList = {}
    local CurrentSelectedConfig = ""
    local NewConfigName = ""

    local function RefreshConfigsList()
        ConfigsList = {}
        pcall(function()
            if isfolder(ConfigFolder) then
                for _, file in ipairs(listfiles(ConfigFolder)) do
                    if file:match("%.json$") then
                        local fName = file:match("([^/\\]+)%.json$")
                        if fName then table.insert(ConfigsList, fName) end
                    end
                end
            end
        end)
        if #ConfigsList == 0 then table.insert(ConfigsList, "Belum ada config") end
    end
    RefreshConfigsList()

    local ConfigDropdown -- forward declare

    local function SaveCustomConfig(name)
        if name == "" or name == "Belum ada config" then return end
        local c = {}
        -- Auto Play
        c.AutoEnabled = State.AutoEnabled
        c.AutoBlacklist = State.AutoBlacklist
        c.SkakmatEnabled = State.SkakmatEnabled
        c.SkakmatPrefix = State.SkakmatPrefix
        c.TypoModeEnabled = State.TypoModeEnabled
        c.TypoModeDelayWrongChar = State.TypoModeDelayWrongChar
        c.TypoModeDelayLastChars = State.TypoModeDelayLastChars
        c.WordMode = State.WordMode
        c.InconsistentTyping = State.InconsistentTyping
        c.ActiveCategory = State.ActiveCategory
        -- Speed
        c.TypingDelayMin = State.TypingDelayMin
        c.TypingDelayMax = State.TypingDelayMax
        c.ThinkDelayMin = State.ThinkDelayMin
        c.ThinkDelayMax = State.ThinkDelayMax
        c.BackspaceDelayMin = State.BackspaceDelayMin
        c.BackspaceDelayMax = State.BackspaceDelayMax
        -- Farm
        c.AutoFarmEnabled = State.AutoFarmEnabled
        c.Disable3DRender = State.Disable3DRender
        c.FarmRole = State.FarmRole
        c.AFKTimeout = State.AFKTimeout
        c.BlatantPredict = State.BlatantPredict
        -- Blatant
        c.BlatantMode = State.BlatantMode
        c.BlatantDelay = State.BlatantDelay
        -- Misc
        c.CustomBamboo = MiscState and MiscState.CustomBamboo or "Default"
        c.AntiStaffEnabled = MiscState and MiscState.AntiStaffEnabled or false

        local saveOk, saveErr = pcall(function()
            writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(c))
        end)
        
        if saveOk then
            WindUI:Notify({ Title = "Config System", Content = "Berhasil menyimpan config: " .. name, Duration = 3 })
        else
            WindUI:Notify({ Title = "Config System", Content = "Gagal menyimpan: " .. tostring(saveErr), Duration = 4 })
        end

        -- Auto Refresh Dropdown
        RefreshConfigsList()
        if ConfigDropdown then
            pcall(function() ConfigDropdown:Refresh(ConfigsList) end)
            pcall(function() ConfigDropdown:SetValue(name) end)
        end
    end

    local function LoadCustomConfig(name)
        if name == "" or name == "Belum ada config" then return end
        local targetPath = ConfigFolder .. "/" .. name .. ".json"

        local success, loadErr = pcall(function()
            if isfile(targetPath) then
                local decoded = HttpService:JSONDecode(readfile(targetPath))
                if type(decoded) == "table" then
                    -- Auto Play
                    State.AutoEnabled = decoded.AutoEnabled or false
                    State.AutoBlacklist = decoded.AutoBlacklist ~= nil and decoded.AutoBlacklist or true
                    State.SkakmatEnabled = decoded.SkakmatEnabled or false
                    State.SkakmatPrefix = decoded.SkakmatPrefix or "Random"
                    State.TypoModeEnabled = decoded.TypoModeEnabled or false
                    State.TypoModeDelayWrongChar = decoded.TypoModeDelayWrongChar or 0.5
                    State.TypoModeDelayLastChars = decoded.TypoModeDelayLastChars or 1.0
                    State.WordMode = decoded.WordMode or "balanced"
                    State.InconsistentTyping = decoded.InconsistentTyping
                    if State.InconsistentTyping == nil then State.InconsistentTyping = true end
                    State.ActiveCategory = decoded.ActiveCategory or "Semua"
                    -- Speed
                    State.TypingDelayMin = decoded.TypingDelayMin or 0.25
                    State.TypingDelayMax = decoded.TypingDelayMax or 0.4
                    State.ThinkDelayMin = decoded.ThinkDelayMin or 0.8
                    State.ThinkDelayMax = decoded.ThinkDelayMax or 2.5
                    State.BackspaceDelayMin = decoded.BackspaceDelayMin or 0.03
                    State.BackspaceDelayMax = decoded.BackspaceDelayMax or 0.09
                    -- Farm
                    State.AutoFarmEnabled = decoded.AutoFarmEnabled or false
                    State.Disable3DRender = decoded.Disable3DRender or false
                    State.FarmRole = decoded.FarmRole or "Farming"
                    State.AFKTimeout = decoded.AFKTimeout or 8.0
                    State.BlatantPredict = decoded.BlatantPredict or false
                    -- Blatant
                    State.BlatantMode = decoded.BlatantMode or false
                    State.BlatantDelay = decoded.BlatantDelay or 0.0
                    -- Misc
                    if MiscState then
                        MiscState.CustomBamboo = decoded.CustomBamboo or "Default"
                        MiscState.AntiStaffEnabled = decoded.AntiStaffEnabled or false
                    end
                    SyncAutoFarmPipeline()
                    
                    WindUI:Notify({ Title = "Config Loaded!", Content =
                    "'" .. name .. "' berhasil dimuat.\nToggle UI akan sync saat re-execute script.", Duration = 5 })
                end
            else
                WindUI:Notify({ Title = "Config System", Content = "Config file tidak ditemukan!", Duration = 3 })
            end
        end)
        if not success then
            WindUI:Notify({ Title = "Config Error", Content = "Gagal memuat: " .. tostring(loadErr), Duration = 4 })
        end
    end

    -- Dropdown Select Existing Config
    ConfigDropdown = ConfigSection:Dropdown({
        Title = "Pilih Config",
        Multi = false,
        Value = loadedConfigName or ConfigsList[1],
        Values = ConfigsList,
        Callback = function(v)
            CurrentSelectedConfig = v
        end
    })
    CurrentSelectedConfig = loadedConfigName or ConfigsList[1]

    ConfigSection:Button({
        Title = "🔄 Refresh List Config",
        Desc = "Memperbarui daftar config di kotak dropdown.",
        Callback = function()
            RefreshConfigsList()
            if ConfigDropdown then
                pcall(function() ConfigDropdown:Refresh(ConfigsList) end)
            end
            WindUI:Notify({ Title = "Config System", Content = "Daftar config diperbarui!", Duration = 2 })
        end
    })

    ConfigSection:Input({
        Title = "Nama Config Baru",
        Desc = "Ketik nama untuk buat config baru",
        Placeholder = "my_legit_cfg",
        ClearText = false,
        Callback = function(v)
            NewConfigName = v
        end
    })

    ConfigSection:Space()

    ConfigSection:Button({
        Title = "💾 Create / Overwrite Config",
        Desc = "Simpan ke nama yang kamu ketik di kotak Input.",
        Callback = function()
            local targetName = NewConfigName
            if targetName == "" then targetName = CurrentSelectedConfig end
            SaveCustomConfig(targetName)
        end
    })

    ConfigSection:Button({
        Title = "📂 Load Config",
        Desc = "Load config dari Dropdown pilihan di atas.",
        Callback = function()
            LoadCustomConfig(CurrentSelectedConfig)
        end
    })

    ConfigSection:Button({
        Title = "📌 Jadikan Auto-Load",
        Desc = "Config di Dropdown akan otomatis terload saat script jalan.",
        Callback = function()
            if CurrentSelectedConfig ~= "" and CurrentSelectedConfig ~= "Belum ada config" then
                pcall(function() writefile(AutoLoadFile, CurrentSelectedConfig) end)
                WindUI:Notify({ Title = "Config System", Content = "'" ..
                CurrentSelectedConfig .. "' telah di set sebagai Auto-Load.", Duration = 3 })
            end
        end
    })

    ConfigSection:Space()

    ConfigSection:Button({
        Title = "🗑️ Hapus Config",
        Desc = "Menghapus config dari Dropdown secara permanen.",
        Callback = function()
            if CurrentSelectedConfig ~= "" and CurrentSelectedConfig ~= "Belum ada config" then
                pcall(function()
                    local targetPath = ConfigFolder .. "/" .. CurrentSelectedConfig .. ".json" -- FIX: Slash
                    if isfile(targetPath) then delfile(targetPath) end
                end)
                WindUI:Notify({ Title = "Config System", Content = "Berhasil menghapus config!", Duration = 3 })

                -- Auto Refresh Dropdown
                RefreshConfigsList()
                if ConfigDropdown then
                    pcall(function() ConfigDropdown:Refresh(ConfigsList) end)
                    pcall(function() ConfigDropdown:SetValue(ConfigsList[1]) end)
                end
            end
        end
    })
end

Init()