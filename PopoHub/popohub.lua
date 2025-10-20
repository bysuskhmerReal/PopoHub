local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


--// Version
local VersionRoot = "1.5"

-- 🌟 Emoji List
local emojiList = {
    -- International Days
    ["01 01"] = "🎆", -- New Year
    ["02 14"] = "❤️", -- Valentine
    ["03 08"] = "💐", -- International Women's Day
    ["10 20"] = "🎃", -- Halloween
    ["12 25"] = "🎄", -- Christmas
    ["12 31"] = "🎉", -- New Year's Eve

    -- Khmer Holidays
    ["04 14"] = "🇰🇭🎉", -- Khmer New Year Day 1
    ["04 15"] = "🎉🙏", -- Khmer New Year Day 2
    ["04 16"] = "💦🎊", -- Khmer New Year Day 3
    ["09 28"] = "🕯️🙏", -- Pchum Ben
    ["09 29"] = "🕯️🙏",
    ["09 30"] = "🕯️🙏",
}

-- 🌟 Function to calculate Easter date (returns "MM DD")
local function getEasterDate(year)
    local A = math.floor(year / 100)
    local B = math.floor((13 + 8 * A) / 25)
    local C = (15 - B + A - math.floor(A / 4)) % 30
    local D = (4 + A - math.floor(A / 4)) % 7
    local E = (19 * (year % 19) + C) % 30
    local F = (2 * (year % 4) + 4 * (year % 7) + 6 * E + D) % 7
    local G = 22 + E + F

    if E == 29 and F == 6 then
        return "04 19"
    elseif E == 28 and F == 6 then
        return "04 18"
    elseif G > 31 then
        return ("04 %02d"):format(G - 31)
    else
        return ("03 %02d"):format(G)
    end
end

-- Add Easter to emojiList
local currentYear = tonumber(os.date("%Y"))
emojiList[getEasterDate(currentYear)] = "🥚"

-- 🌟 Function to get today's emoji
local function getEmoji(date)
    local today = date or os.date("%m %d")
    return emojiList[today]
end

-- 🌅 Determine what to display today
local emojiToday = getEmoji() -- Get today's emoji
local Day = emojiToday and emojiToday or ("🌅 " .. Title.Text)

-- 🌄 Set background for Halloween
local BackgroundImage
if emojiToday == "🎃" then
    BackgroundImage = "rbxassetid://139507819886758"
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TelegramBotToken = "7737355847:AAGjjEm-QsFsP2rPzFy_TD_AacugFznsThM" -- ប្ដូរជា Bot Token របស់ញុម
local ChatID = "6031386319"       -- ប្ដូរជា Chat ID របស់ Group ញុម
local userInput = ""
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local function getHumanoid()
    local c=LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden =  missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden =  missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
queueteleport =  missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
httprequest =  missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
firetouchinterest = missing("function", firetouchinterest)
waxwritefile, waxreadfile = writefile, readfile
writefile = missing("function", waxwritefile) and function(file, data, safe)
    if safe == true then return pcall(waxwritefile, file, data) end
    waxwritefile(file, data)
end
readfile = missing("function", waxreadfile) and function(file, safe)
    if safe == true then return pcall(waxreadfile, file) end
    return waxreadfile(file)
end
isfile = missing("function", isfile, readfile and function(file)
    local success, result = pcall(function()
        return readfile(file)
    end)
    return success and result ~= nil and result ~= ""
end)
makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)
waxgetcustomasset = missing("function", getcustomasset or getsynasset)
hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)
--// VARIABLES
local ESPEnabled = false
local ESPCategories = {"ESP USERNAME"}
local ESPObjects = {}

local defaultColor = Color3.fromRGB(255,0,0)
local defaultFontName = "UI" -- one of fontNames below
local settings
local GravityOriginal = workspace.Gravity
local ValueGravity = workspace.Gravity
local LoopGravity = false
-- ផ្ទាល់តម្លៃ workspace.Gravity
local value = math.floor(workspace.Gravity) -- 196.2 -> 196
print(value)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local speaker = Players.LocalPlayer
local antifling -- បង្កើត variable សម្រាប់ Disconnect ពេលចុចម្តងទៀត
local lock = false -- បើអ្នកចង់ Lock Button ដំបូង

local player = game.Players.LocalPlayer
local speaker = player
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")

local espParts = {}
local isEspEnabled = false
local LoopGoto = false
local LoopBring = false
local gotopartDelay = 0
local walkflinging = false


local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- បន្ថែម function ឬ variable ដែលគេចង់ប្រើ
local speaker = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function ដើម្បីពិនិត្យ R15
local function r15(player)
    local char = player.Character
    if not char then return false end
    return char:FindFirstChild("UpperTorso") ~= nil
end

-- Function ដើម្បីយក root part
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

-- Function ដើម្បីយក torso
local function getTorso(char)
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

-- Function យក player
local function getPlayer(name)
    local found = {}
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(name)) then
            table.insert(found, p)
        end
    end
    return found
end

-- Variable បន្ថែម
local args = {nil, 3}  -- 🔹 speed default

--== ESP FUNCTION ==--
function AddESP(part)
    if not part:IsA("BasePart") then return end

    -- បើមាន ESP រួចហើយ កុំបន្ថែមទៀត
    for _, v in ipairs(part:GetChildren()) do
        if v.Name == part.Name .. "_TextESP" then
            return
        end
    end

    --== Billboard Text ==--
    local billboard = Instance.new("BillboardGui")
    billboard.Name = part.Name .. "_TextESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "📍 " .. part.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold

    billboard.Parent = part

    --== Highlight (Outline Around Part) ==--
    local highlight = Instance.new("Highlight")
    highlight.Name = part.Name .. "_ESPHighlight"
    highlight.Adornee = part
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0

    highlight.Parent = part
end

-- Fonts for Drawing API (limited)
local fontNames = {"UI","System","Plex","Monospace"}
local fontMap = { UI = 0, System = 1, Plex = 2, Monospace = 3 }
local infJump = false
local loopSpeed,loopJump,noclipEnabled,ESPEnabled,infJumpEnabled=false,false,false,false,false
local targetSpeed,targetJump=16,50
local ESPObjects={}
--// Detect HTTP Request Function
local requestfunc = (syn and syn.request) or http_request or request or http and http.request
--// Player Variables
local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local name = LocalPlayer.Name

--// Character Variables
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local function SetChar(char)
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end

local hum=getHumanoid()

--// Toggles & Settings
local ToggleTpwalk = false
local Multiplication = 0.5
local JumpBypaasPower = 70
getgenv().TPSpeed = getgenv().TPSpeed or 2
getgenv().TPWalk = getgenv().TPWalk or false
local ToggleDestroy = false
local NotifyDistance = 10

local bangAnim, bang, bangLoop, bangDied

--// Admin
local admin = false
local adminList = { "bysuskhmer_100", "bysuskhmer" }
-- Services
if table.find(adminList, name) then
    admin = true
end

local folderName

if admin then
 folderName = "PoppHub/Admin/"
else
 folderName = "PoppHub/".. name.. "/"
end



local whatsNew = {
    "编辑 ESP",
    "为 ESP 添加新字体",
    "自动检查字体游戏和 Gui 的新 Gui",
    "编辑传送地图 Afk",
    "新脚本飞垫",
    "删除所有标签",
    "文件夹中自动保存通知",
    "修复错误保存和加载"
}

local function buildWhatsNew(entries)
    for i = 1, #entries do
        entries[i] = "[-] " .. entries[i]
    end
    return table.concat(entries, "\n")
end

local MessageeWhatNew = buildWhatsNew(whatsNew)

print(MessageeWhatNew)

local function music(idPut, id)
        local Sound = Instance.new("Sound")
        Sound.Name = id or "SONG POPO"
        Sound.SoundId = "rbxassetid://" .. idPut
        Sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        Sound.Volume = 1
        Sound:Play()
end

local function noti(title, content, duration, icons)
    pcall(function()
        music("124951621656853")
    end)

    pcall(function()
        WindUI:Notify({
            Title = title or "",
            Content = content or "",
            Duration = duration or 3,
            Icon = icons or "bell",
        })
    end)
end

function PoppHubCom()

function SaveFile(Filename, Value)
    local HttpService = game:GetService("HttpService")
    local success, err = pcall(function()
        local data = HttpService:JSONEncode(Value)
        writefile(folderName .. Filename, data)
    end)

    if not success then
        warn("Failed to save file: " .. tostring(err))
    end
end

function LoadFile(Filename)
    local HttpService = game:GetService("HttpService")
    local filePath = folderName .. Filename

    if isfile(filePath) then
        local raw = readfile(filePath)
        local success, data = pcall(function()
            return HttpService:JSONDecode(raw)
        end)

        if success and data then
            return data
        else
            return "nii" 
        end
    else
        return "nii"
    end
end

function Check(filename)
    if isfile(folderName .. filename) then
        return true
    else
        return false
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")

local PopoGui

if Check("PoppMain_" .. VersionRoot .. ".json") then
    PopoGui = LoadFile("PoppMain_" .. VersionRoot .. ".json")
else
PopoGui = {
    Title = "Popp Hub",
    Version = "v" .. VersionRoot,
    SizeGui = 480,
    SizeGui2 = 360,
    HideSearchBar = false,
    Icon = "rbxassetid://123394150216440"
}
SaveFile("PoppMain_" .. VersionRoot .. ".json", PopoGui)
end

local Safe
if Check("SystemSafe.json") then
    Safe = LoadFile("SystemSafe.json")
else
    Safe = {
        AllowRejoin = false,
        AllowKick = false
    }
    SaveFile("SystemSafe.json", Safe)
end

local function ShowNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title or "Alert",
        Text = text or "",
        Duration = duration or 5
    })
end

--// BLOCK REMOTES
local blockedRemotes = {"TeleportEvent","AutoRejoinFunction"}
for _, name in ipairs(blockedRemotes) do
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote then
        if remote:IsA("RemoteEvent") then
            local oldFireServer = remote.FireServer
            remote.FireServer = function(...)
                ShowNotification("Safe Rejoin", "Blocked RemoteEvent: "..name, 5)
                if Safe.AllowRejoin then
                    return oldFireServer(remote, ...)
                end
            end
        elseif remote:IsA("RemoteFunction") then
            local oldInvokeServer = remote.InvokeServer
            remote.InvokeServer = function(...)
                ShowNotification("Safe Rejoin", "Blocked RemoteFunction: "..name, 5)
                if Safe.AllowRejoin then
                    return oldInvokeServer(remote, ...)
                end
                return nil
            end
        end
    end
end

--// HOOK TELEPORT & KICK
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt,false)

mt.__namecall = newcclosure(function(self,...)
    local method = getnamecallmethod()
    -- Block Kick
    if self == LocalPlayer and method == "Kick" then
        ShowNotification("Safe Rejoin","Blocked Kick attempt!",5)
        if Safe.AllowKick then
            return oldNamecall(self,...)
        else
            warn("Blocked Kick attempt")
            return nil
        end
    end

    return oldNamecall(self,...)
end)

setreadonly(mt,true)

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer and not Safe.AllowKick then
        ShowNotification("Safe Rejoin","Blocked server kick attempt!",5)
        warn("Blocked PlayerRemoving attempt")
    end
end)

print("✅ Full Safe Rejoin + Hook Kick + Block Teleport Activated")
print("AllowRejoin =", Safe.AllowRejoin, "| AllowKick =", Safe.AllowKick)

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
end

WindUI:AddTheme({
    Name = "God",
    Accent = "#FFD700",       -- មាសភ្លឺ
    Dialog = "#1C1C1C",       -- ខ្មៅចាស់
    Outline = "#FFFFFF",      -- សស្រស់
    Text = "#FFFFFF",         -- ស
    Placeholder = "#CCCCCC",  -- ពណ៌ប្រផេះស្រាល
    Background = "#0A0A0A",  -- ខ្មៅជ្រៅ
    Button = "#FFD700",       -- មាស
    Icon = "#FFFFFF",         -- ស
})

WindUI:AddTheme({
    Name = "Hacker",
    Accent = "#00FF00",      
    Dialog = "#000000",       -- ខ្មៅ
    Outline = "#00FF00",      -- បៃតង
    Text = "#00FF00",         -- បៃតង
    Placeholder = "#00AA00",  -- បៃតងស្រាល
    Background = "#0D0D0D",  -- ខ្មៅជ្រៅ
    Button = "#003300",       -- បៃតងងងឹត
    Icon = "#00FF00",         -- បៃតង
})

 Window = WindUI:CreateWindow({
    Title = PopoGui.Title .. " | " .. Day .. " | ",
    Icon = PopoGui.Icon,
    Author = "by .bysuskhmer",
    Folder = folderName,
    Size = UDim2.fromOffset(PopoGui.SizeGui, PopoGui.SizeGui2),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = PopoGui.HideSearchBar,
    ScrollBarEnabled = false,
    Background = BackgroundImage,
})

if not firetouchinterest then
		noti("Incompatible Exploit", "Your exploit does not support this command (missing firetouchinterest)")
end

local isRunning = false 

function run(scriptUrl)
    if isRunning then
        noti("脚本已在运行...")
        return
    end
    
    local Dialog = Window:Dialog({
        Icon = "shield-check",
        Title = "旅行时要小心.",
        Content = "某些脚本不被认为是安全的。",
        Buttons = {
            {
                Title = "跑步",
                Callback = function()
                    isRunning = true
                    local success, result = pcall(function()
                        local scriptSource = game:HttpGet(scriptUrl)
                        return loadstring(scriptSource)()
                    end)

                    if not success then
                        noti("错误: " .. tostring(result))
                        warn("脚本错误:", result)
                    else
                        noti("脚本加载成功")
                    end

                    isRunning = false
                end,
            },
            {
                Title = "取消",
                Callback = function()
                    print("Cancelled!")
                    noti("脚本已取消。")
                    isRunning = false
                end,
            },
        },
    })
end

local info = Window:Tab({
    Title = "信息",
    Icon = "info",
    Locked = false,
})

local Paragraph = info:Paragraph({
    Title = "有哪些新更新 : " .. VersionRoot,
    Desc = MessageeWhatNew,
    Locked = false,
})

local Section = info:Section({ 
    Title = "支持",
    TextXAlignment = "Left",
    TextSize = 30, -- Default Size
})

local Paragraph = info:Paragraph({
    Title = "@bysuskhmer",
    Desc = "所有者脚本",
    Locked = false,
})

local Paragraph = info:Paragraph({
    Title = "@X_Mobile",
    Desc = "共同所有人脚本",
    Locked = false,
})

local Paragraph = info:Paragraph({
    Title = "WindUI",
    Desc = "https://footagesus.github.io/WindUI-Docs/docs/load-windui",
    Locked = false,
})

local Paragraph = info:Paragraph({
    Title = "Infinite Yield",
    Desc = "https://github.com/DarkNetworks/Infinite-Yield",
    Locked = false,
})

local Section = info:Section({ 
    Title = "接触",
    TextXAlignment = "Left",
    TextSize = 30, -- Default Size
})

--// Telegram Config
if not requestfunc then
    warn("❌ Exploit not support HTTP requests!")
    return
end

local Input = info:Input({
    Title = "提供反馈并报告问题。",
    Value = "",
    Type = "Textarea",
    Placeholder = "输入文本...",
    Callback = function(input)
        userInput = input
        print("Text entered: " .. input)
    end
})

--// Button to Send Message
local Button = info:Button({
    Title = "发送消息至 Telegram",
    Locked = false,
    Callback = function()
        if userInput == "" then
            warn("⚠️ 发送前请输入消息！")
            return
        end

        -- Message Format
        local msg = "📩 Feedback from user: `" .. game.Players.LocalPlayer.Name .. "`\n\n`" .. userInput .. "`"

        -- Telegram API URL
        local url = "https://api.telegram.org/bot" .. TelegramBotToken .. "/sendMessage"

        -- Request Data
        local body = {
            chat_id = ChatID,
            text = msg
        }

        -- Send Request
        local success, err = pcall(function()
            requestfunc({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode(body)
            })
        end)

        if success then
            noti("✅ 消息已成功发送至 Telegram！机器人")
        else
            warn("❌ Failed to send Telegram message: " .. tostring(err))
        end
    end
})


local ScriptContext = game:GetService("ScriptContext")

local logIndex = 0
local allLogs = "" -- សម្រាប់រក្សាទុកសារទាំងអស់

local bug = info:Code({
    Title = "通知",
    Code = "不，没有消息。"
})

-- Function បន្ថែមសារ
local function logMessage(messageType, message)
	logIndex += 1
	local time = os.date("%H:%M")
	local prefix = ""

	if messageType == "error" then
		prefix = "❌ ERROR"
	elseif messageType == "success" then
		prefix = "✅ SUCCESS"
	elseif messageType == "warn" then
		prefix = "⚠️ WARNING"
	else
		prefix = "ℹ️ INFO"
	end

	local formatted = string.format("%d - [%s] %s : %s", logIndex, time, prefix, message)

	-- បន្ថែមសារថ្មីចូលទៅក្នុង log ចាស់ៗ
	allLogs = allLogs .. formatted .. "\n\n"

	-- បង្ហាញសារទាំងអស់
	bug:SetCode(allLogs)
end

-- ប្រើសម្រាប់ ScriptContext.Error (សារ error)
ScriptContext.Error:Connect(function(message, trace)
	logMessage("error", message .. "\n\n" .. trace)
end)

-- សារ ពោលដោយដៃ
logMessage("success", "脚本加载成功！")
logMessage("warn", "有些脚本响应时间太长。")
logMessage("info", "@ChnaBODY 的通知")

local t1= Window:Tab({Title="本地玩家",Icon="user",Locked=false})

-- util

RunService.RenderStepped:Connect(function()
    local hum=getHumanoid()
    local c=LocalPlayer.Character
    if hum then
        if loopSpeed then hum.WalkSpeed=targetSpeed end
        if loopJump then hum.JumpPower=targetJump end
        if noclipEnabled and c then
            for _,part in ipairs(c:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
    -- ESP update
    if ESPEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=LocalPlayer then
                if plr.Character then
                    local head=plr.Character:FindFirstChild("Head")
                    if head then
                        local esp=ESPObjects[plr]
                        if not esp then
                            esp=Instance.new("BillboardGui")
                            esp.Name="ESP"
                            esp.Adornee=head
                            esp.Size=UDim2.new(0,150,0,50)
                            esp.StudsOffset=Vector3.new(0,2,0)
                            esp.AlwaysOnTop=true
                            esp.Parent=head
                            ESPObjects[plr]=esp
                        else
                            esp.Adornee=head
                            esp.Parent=head
                        end
                        esp:ClearAllChildren()
                        local offsetY=0
                        for _,cat in pairs(ESPCategories) do
                            local textLabel=Instance.new("TextLabel")
                            textLabel.Parent=esp
                            textLabel.Position=UDim2.new(0,0,0,offsetY)
                            textLabel.Size=UDim2.new(1,0,0,16)
                            textLabel.BackgroundTransparency=1
                            textLabel.TextColor3=ESPColor
                            textLabel.Font=selectedFont
                            textLabel.TextStrokeTransparency=0
                            textLabel.TextScaled=true
                            if cat=="ESP DISPLAY" then
                                textLabel.Text=plr.DisplayName
                            elseif cat=="ESP USERNAME" then
                                textLabel.Text=plr.Name
                            elseif cat=="ESP HP" then
                                local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                                textLabel.Text=hum and "HP: "..math.floor(hum.Health) or "HP: 0"
                            end
                            offsetY=offsetY+16
                        end
                    end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        ESPObjects[plr]:Destroy()
        ESPObjects[plr]=nil
    end
end)

-- GUI controls
t1:Input({
    Title="Enter Speed",Value=tostring(hum.WalkSpeed),
    Callback=function(v)
        targetSpeed=tonumber(v) or 16
        local hum=getHumanoid()
        if hum then hum.WalkSpeed=targetSpeed end
    end
})
t1:Toggle({Title="Loop Speed",Default=false,Callback=function(s)loopSpeed=s end})

t1:Input({
    Title="Enter Jump",Value=tostring(hum.JumpPower),
    Callback=function(v)
        targetJump=tonumber(v) or 50
        local hum=getHumanoid()
        if hum then hum.JumpPower=targetJump end
    end
})
t1:Toggle({Title="Loop Jump",Default=false,Callback=function(s)loopJump=s end})
t1:Toggle({Title="Noclip",Default=false,Callback=function(s)noclipEnabled=s end})

t1:Divider()
local InfiniteJump = t1:Section({
    Title = "InfiniteJump Bypass",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Input = t1:Input({
    Title = "Jump Power",
    Value = "70",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter Power...",
    Callback = function(input) 
        JumpBypaasPower = input
    end
})

UIS.JumpRequest:Connect(function()
        if infJump and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, JumpBypaasPower, 0)
        end
end)

t1:Toggle({Title="Infinite Jump",Default=false,Callback=function(s)infJump=s end})

getgenv().TPSpeed = 1       -- ល្បឿនដើរ
getgenv().TPWalk = false    -- ON/OFF Tpwalk

t1:Divider()
local SectionESP = t1:Section({
    Title = "Tpwalk",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Input = t1:Input({
    Title = "Multiplication",
    Value = "0.5",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter text...",
    Callback = function(input) 
        Multiplication = input
    end
})


local Input = t1:Input({
    Title = "Tpwalk Speed",
    Value = "1",
    Type = "Input",
    Placeholder = "Enter Tpwalk speed...",
    Callback = function(input) 
        getgenv().TPSpeed = tonumber(input) or 1
    end
})

-- Toggle for Tpwalk
local Toggle = t1:Toggle({
    Title = "Tpwalk",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        getgenv().TPWalk = state
    end
})

t1:Divider()

local Gravity = t1:Section({
    Title = "Gravity",
    TextXAlignment = "Left",
    TextSize = 17,
})

local InputGravity = t1:Input({
    Title = "Input Gravity",
    Value = tostring(math.floor(workspace.Gravity)),
    Type = "Input",
    Placeholder = "Enter Gravity...",
    Callback = function(input)
        -- convert to number
        local num = tonumber(input)
        if num then
            ValueGravity = num
        else
            warn("⚠️ Invalid gravity input:", input)
        end
    end
})

local Toggle = t1:Toggle({
    Title = "Loop Gravity",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        LoopGravity = state
    end
})

local Button = t1:Button({
    Title = "Gravity Normal",
    Desc = "Reset Gravity",
    Locked = false,
    Callback = function()
        ValueGravity = GravityOriginal
        InputGravity:Set(tostring(GravityOriginal))
    end
})

-- safer loop
spawn(function()
    while true do
       if LoopGravity then
        workspace.Gravity = ValueGravity
        end
        wait(1)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer


-- តភ្ជាប់ពេល Character ផ្លាស់ប្តូរ
SetChar(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
LocalPlayer.CharacterAdded:Connect(SetChar)

-- បិទការភ្ជាប់ចាស់
if TPConnection then
    TPConnection:Disconnect()
end

-- ភ្ជាប់ថ្មី
TPConnection = RunService.RenderStepped:Connect(function()
    if getgenv().TPWalk and LocalPlayer.Character and hrp and humanoid then
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveDir.Unit * (getgenv().TPSpeed or 1) * Multiplication
        end
    end
end)

-- Full Drawing API ESP with Team Check toggle

--// SAVE/LOAD JSON FUNCTIONS
local function SaveSettings()
    local saveData = {
        ESPTYPE = settings.ESPTYPE,
        ESPCOLOR = { r = settings.ESPCOLOR.R, g = settings.ESPCOLOR.G, b = settings.ESPCOLOR.B },
        ESPFONT = settings.ESPFONT, -- store font name string
        TEAMCHECK = settings.TEAMCHECK and true or false
    }
    SaveFile("ESPSETTINGS.json", saveData)
end

local function LoadSettings()
    if Check("ESPSETTINGS.json") then
        local dataSave = LoadFile("ESPSETTINGS.json")
        settings = {
            ESPTYPE = dataSave.ESPTYPE or ESPCategories,
            ESPCOLOR = dataSave.ESPCOLOR and Color3.new(dataSave.ESPCOLOR.r, dataSave.ESPCOLOR.g, dataSave.ESPCOLOR.b) or defaultColor,
            ESPFONT = dataSave.ESPFONT or defaultFontName,
            TEAMCHECK = dataSave.TEAMCHECK or false
        }
    else
        settings = {
            ESPTYPE = ESPCategories,
            ESPCOLOR = defaultColor,
            ESPFONT = defaultFontName,
            TEAMCHECK = false
        }
        SaveSettings()
    end
end

LoadSettings()

local selectedFontName = settings.ESPFONT
local ESPColor = settings.ESPCOLOR

-- Helper: get color for a player (team check)
local function GetPlayerColor(plr)
    if settings.TEAMCHECK and plr and plr.Team and plr.TeamColor then
        -- plr.TeamColor is a BrickColor; .Color returns Color3
        return plr.TeamColor.Color
    end
    return ESPColor
end

--// Function to create ESP object (Drawing)
local function CreateESP(plr)
    if not plr or plr == LocalPlayer then return end
    if ESPObjects[plr] then return end

    local esp = {
        Text = Drawing.new("Text"),
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line")
    }

    -- Text
    esp.Text.Size = 15
    esp.Text.Color = GetPlayerColor(plr)
    esp.Text.Center = true
    esp.Text.Visible = false
    esp.Text.Font = fontMap[selectedFontName] or 0

    -- Box
    esp.Box.Thickness = 1
    esp.Box.Color = GetPlayerColor(plr)
    esp.Box.Filled = false
    esp.Box.Visible = false

    -- Line (rope)
    esp.Line.Thickness = 1
    esp.Line.Color = GetPlayerColor(plr)
    esp.Line.Visible = false

    ESPObjects[plr] = esp
end

--// Remove ESP
local function RemoveESP(plr)
    local obj = ESPObjects[plr]
    if obj then
        for _,v in pairs(obj) do
            if v and v.Remove then
                pcall(function() v:Remove() end)
            end
        end
        ESPObjects[plr] = nil
    end
end

-- Clean up when player leaves
Players.PlayerRemoving:Connect(function(plr)
    RemoveESP(plr)
end)

--// Update Loop
RunService.RenderStepped:Connect(function()
    -- keep loop cheap if disabled
    if not ESPEnabled then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            CreateESP(plr)
            local esp = ESPObjects[plr]
            if not esp then continue end

            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            if onscreen then
                -- determine color (team or picker)
                local color = GetPlayerColor(plr)
                -- update font (in case changed)
                esp.Text.Font = fontMap[selectedFontName] or 0

                -- Username / Display / HP / Distance
                local parts = {}
                if table.find(settings.ESPTYPE, "ESP USERNAME") then table.insert(parts, plr.Name) end
                if table.find(settings.ESPTYPE, "ESP DISPLAY") then table.insert(parts, "("..plr.DisplayName..")") end
                if table.find(settings.ESPTYPE, "ESP HP") then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then table.insert(parts, "["..math.floor(hum.Health).." HP]") end
                end
                if table.find(settings.ESPTYPE, "ESP DISTANCE") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local lpHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local dist = (lpHRP.Position - hrp.Position).Magnitude
                        table.insert(parts, "["..math.floor(dist).."m]")
                    end
                end

                esp.Text.Text = table.concat(parts, " ")
                esp.Text.Position = Vector2.new(pos.X, pos.Y - 30)
                esp.Text.Color = color
                esp.Text.Visible = true

                -- Box
                if table.find(settings.ESPTYPE, "ESP BOX") then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum and plr.Character:FindFirstChild("Head") then
                        local headPos = Camera:WorldToViewportPoint(plr.Character.Head.Position + Vector3.new(0,0.5,0))
                        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, hum.HipHeight or 1, 0))
                        local height = math.abs(headPos.Y - legPos.Y)
                        if height < 10 then height = 10 end
                        local width = height / 2
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                        esp.Box.Color = color
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end
                else
                    esp.Box.Visible = false
                end

                -- Rope/Line
                if table.find(settings.ESPTYPE, "ESP ROPE") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local lpPos, lpOn = Camera:WorldToViewportPoint(LocalPlayer.Character.HumanoidRootPart.Position)
                        esp.Line.From = Vector2.new(lpPos.X, lpPos.Y)
                        esp.Line.To = Vector2.new(pos.X, pos.Y)
                        esp.Line.Color = color
                        esp.Line.Visible = true
                    else
                        esp.Line.Visible = false
                    end
                else
                    esp.Line.Visible = false
                end
            else
                esp.Text.Visible = false
                esp.Box.Visible = false
                esp.Line.Visible = false
            end
        else
            -- no character -> remove esp
            RemoveESP(plr)
        end
    end
end)

t1:Divider()

--// UI SECTION (assumes t1 UI lib available)
local SectionESP = t1:Section({
    Title = "ESP | PLAYER",
    TextXAlignment = "Left",
    TextSize = 17,
})

-- ESP Toggle
t1:Toggle({
    Title="ESP Players", Default=ESPEnabled,
    Callback=function(state)
        ESPEnabled = state
        if not state then
            for plr,obj in pairs(ESPObjects) do
                RemoveESP(plr)
            end
            ESPObjects = {}
        end
    end
})

-- Team Check Toggle
t1:Toggle({
    Title="Team Check (use team color if available)", Default = settings.TEAMCHECK,
    Callback=function(state)
        settings.TEAMCHECK = state
        SaveSettings()
    end
})

-- ESP Colorpicker
t1:Colorpicker({
    Title="ESP Color",
    Default=ESPColor,
    Callback=function(color)
        ESPColor = color
        settings.ESPCOLOR = color
        SaveSettings()
    end
})

-- ESP Show Dropdown
t1:Dropdown({
    Title="ESP SHOW",
    Values={"ESP USERNAME","ESP DISPLAY","ESP HP","ESP DISTANCE","ESP BOX","ESP ROPE"},
    Value=settings.ESPTYPE,
    Multi=true,
    Callback=function(option)
        settings.ESPTYPE = option
        SaveSettings()
    end
})

-- Font Dropdown (Drawing API fonts)
t1:Dropdown({
    Title="ESP Font",
    Values=fontNames,
    Value = settings.ESPFONT,
    Multi=false,
    Callback=function(v)
        if v and fontMap[v] then
            selectedFontName = v
            settings.ESPFONT = v
            -- apply to existing ESP texts
            for _,obj in pairs(ESPObjects) do
                if obj and obj.Text then
                    obj.Text.Font = fontMap[v]
                end
            end
            SaveSettings()
        end
    end
})

t1:Divider()


local Section = t1:Section({ 
    Title = "Notification",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--===== ConfigManager =====
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("NotificationSettings")

--===== Notification Table (store toggle states) =====
local notificationV = {
    notificationPlayerJoinGame = true,   -- ✅ default true
    notificationPlayerLeaveGame = false, -- ❌ default false
    notificationfriend = true             -- ✅ default true
}

--===== Function: Get Avatar Image =====
local function getAvatar(player)
    local success, thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)
    if success then
        return thumbnail
    else
        return nil
    end
end

--===== Function: Show Notification =====
local function notiPlayer(title, content, duration, player)
    local iconUrl = player and getAvatar(player) or "bell"
    pcall(function()
        WindUI:Notify({
            Title = title or "",
            Content = content or "",
            Duration = duration or 3,
            Icon = iconUrl,
        })
    end)
end

--===== Create Toggles =====
local ToggleJoin = t1:Toggle({
    Title = "Notification Player Join",
    Desc = "Show when someone joins the game",
    Default = notificationV.notificationPlayerJoinGame,
    Callback = function(state)
        notificationV.notificationPlayerJoinGame = state
        myConfig:Save()
    end
})

local ToggleLeave = t1:Toggle({
    Title = "Notification Player Leave",
    Desc = "Show when someone leaves the game",
    Default = notificationV.notificationPlayerLeaveGame,
    Callback = function(state)
        notificationV.notificationPlayerLeaveGame = state
        myConfig:Save()
    end
})

local ToggleFriend = t1:Toggle({
    Title = "Notification Friend Join/Leave",
    Desc = "Notify when your friend joins or leaves",
    Default = notificationV.notificationfriend,
    Callback = function(state)
        notificationV.notificationfriend = state
        myConfig:Save()
    end
})

myConfig:Register("toggleJoin", ToggleJoin)
myConfig:Register("toggleLeave", ToggleLeave)
myConfig:Register("toggleFriend", ToggleFriend)

myConfig:Load()

if ToggleJoin.Value == nil then ToggleJoin:Set(true) end
if ToggleLeave.Value == nil then ToggleLeave:Set(false) end
if ToggleFriend.Value == nil then ToggleFriend:Set(true) end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        if notificationV.notificationPlayerJoinGame then
            notiPlayer("Player Joined ✅", player.Name .. " has joined the game", 3, player)
        end
        if notificationV.notificationfriend and LocalPlayer:IsFriendsWith(player.UserId) then
            notiPlayer("Friend Joined ✅", player.Name .. " your friend joined!", 3, player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        if notificationV.notificationPlayerLeaveGame then
            notiPlayer("Player Left ❌", player.Name .. " has left the game", 3, player)
        end
        if notificationV.notificationfriend and LocalPlayer:IsFriendsWith(player.UserId) then
            notiPlayer("Friend Left ❌", player.Name .. " your friend left!", 3, player)
        end
    end
end)

Window:SelectTab(1)

local t2=Window:Tab({Title="脚本",Icon="file-code",Locked=false})

local Button = t2:Button({
    Title = "Rejoin Game",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

local Button = t2:Button({
    Title = "Rejoin Server",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

function ScriptAdd(title, raw)
local Button = t2:Button({
    Title = title,
    Locked = false,
    Callback = function()
        run(raw)
    end
})
end

local pp = false
local RunService = game:GetService("RunService")
-- 🔧 Variable Setup
local Lighting = game:GetService("Lighting")

-- 💾 Save Original Lighting Settings
local BrightnessOld = Lighting.Brightness
local ClockTimeOld = Lighting.ClockTime
local FogEndOld = Lighting.FogEnd
local GlobalShadowsOld = Lighting.GlobalShadows
local OutdoorAmbientOld = Lighting.OutdoorAmbient

-- ⚙️ Function to Apply or Reset Lighting
local function updateLighting()
    if pp then
        -- Enable Full Bright
        pcall(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end)
    else
        -- Reset to Original
        pcall(function()
            Lighting.Brightness = BrightnessOld
            Lighting.ClockTime = ClockTimeOld
            Lighting.FogEnd = FogEndOld
            Lighting.GlobalShadows = GlobalShadowsOld
            Lighting.OutdoorAmbient = OutdoorAmbientOld
        end)
    end
end

local Toggle = t2:Toggle({
    Title = "Full Brightness",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        pp = state
        updateLighting()
    end
})

local Player = game.Players.LocalPlayer

local toggleRemoveFogEnd = game.Lighting.FogEnd
local toggleRemoveFogStart = game.Lighting.FogStart
local toggleRemoveFogAmbient = game.Lighting.Ambient
local toggleRemoveFogOutDoors = game.Lighting.OutdoorAmbient

local function ScriptRemoveFog()
    game.Lighting.FogEnd = math.huge
    game.Lighting.FogStart = 0
    game.Lighting.Ambient = Color3.fromRGB(167, 167, 167)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(167, 167, 167)
end

local function ScriptRemoveFogReast()
    game.Lighting.FogEnd = toggleRemoveFogEnd
    game.Lighting.FogStart = toggleRemoveFogStart
    game.Lighting.Ambient = toggleRemoveFogAmbient
    game.Lighting.OutdoorAmbient = toggleRemoveFogOutDoors
end

local Toggle = t2:Toggle({
    Title = "Remove Fog",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        if state then
            ScriptRemoveFog()
        else
            ScriptRemoveFogReast()
        end
    end
})

local Button = t2:Button({
    Title = "Sword Kill All",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/bysuskhmerReal/PopoHub/refs/heads/main/Sword%20Kill%20All.txt")
    end
})

local Button = t2:Button({
    Title = "FE Lag Switch",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/0Ben1/fe/main/Protected%20-%202023-05-28T225112.055.lua.txt")
    end
})

local Toggle = t2:Toggle({
    Title = "Auto Process ProximityPrompt",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        ToggleDestroy = state
    end
})

-- 📌 Notification GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProximityNotificationUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game.CoreGui

local currentNotification = nil -- holds the current notification

-- 🔔 Show Notification Function
local function showNotification(text, duration)
    duration = duration or 2

    -- delete old notification if exists
    if currentNotification then
        currentNotification:Destroy()
        currentNotification = nil
    end

    local label = Instance.new("TextLabel")
    label.Parent = screenGui
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.5, 0, 0.1, 0)
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.TextWrapped = true
    label.ZIndex = 10

    currentNotification = label -- save current notification

    -- Fade out animation
    task.spawn(function()
        task.wait(duration)
        for i = 0, 1, 0.05 do
            label.TextTransparency = i
            task.wait(0.03)
        end
        if currentNotification == label then
            currentNotification = nil
        end
        label:Destroy()
    end)
end

-- ✅ Prompt List
local prompts = {}

-- ✅ Add Prompt Function
local function addPrompt(prompt)
    if not table.find(prompts, prompt) then
        table.insert(prompts, prompt)
    end
end

-- ✅ Initial Scan
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        addPrompt(obj)
    end
end

-- ✅ Listen for New Prompts
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        addPrompt(obj)
    end
end)

-- ✅ Remove Prompt if Deleted
workspace.DescendantRemoving:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        for i, v in ipairs(prompts) do
            if v == obj then
                table.remove(prompts, i)
                break
            end
        end
    end
end)

-- ✅ Auto Process Prompt Near Player
task.spawn(function()
    while true do
        task.wait(0.2)
        if ToggleDestroy then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart

                for _, prompt in ipairs(prompts) do
                    if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then
                        local dist = (hrp.Position - prompt.Parent.Position).Magnitude
                        if dist <= NotifyDistance and prompt.HoldDuration ~= 0 then
                            prompt.HoldDuration = 0
                            showNotification("✅ Auto Processed: " .. prompt.Parent.Name, 2)
                        end
                    end
                end
            end
        end
    end
end)

local t3=Window:Tab({Title="游戏",Icon="gamepad-2",Locked=false})

-- Create Section
function Addgame(Gamename, funcTable)
    local Section = t3:Section({ 
        Title = Gamename,
        TextXAlignment = "Left",
        TextSize = 17,
    })

    -- Execute all functions in table, pass Section as parent
    if funcTable then
        for _, f in ipairs(funcTable) do
            f(Section)
        end
    end

    return Section
end

-- Add script button
function AddScriptGame(section, gamename, SCRIPTURL)
    local Button = section:Button({
        Title = gamename,
        Locked = false,
        Callback = function()
            if type(SCRIPTURL) == "string" then
                run(SCRIPTURL)
            else
                run(tostring(SCRIPTURL))
            end
        end
    })
end

local Button = t2:Button({
    Title = "Walking on Air",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        WalkingonAir()
    end
})

ScriptAdd("Fly {Vehicle}", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui")
ScriptAdd("Fly Car", "https://safetycode-free.vercel.app/api/run?uid=sOVkfQrqmoqsd576b7x")

ScriptAdd("Unlock {Emotes}", "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua")
ScriptAdd("Jump {PAD}", "https://raw.githubusercontent.com/bysuskhmerReal/PopoHub/refs/heads/main/Script/Jump%20Pad.txt")
ScriptAdd("Chat Bypasser", "https://raw.githubusercontent.com/vqmpjayZ/Bypass/8e92f1a31635629214ab4ac38217b97c2642d113/vadrifts")
ScriptAdd("Webhook Tool", "https://raw.githubusercontent.com/venoxhh/universalscripts/main/webhook_tools")
ScriptAdd("FPS Counter", "https://mokren.pages.dev/api/run?uid=sOYB4wbzbhFVaADxjLOSqxvyhlozdnb")
ScriptAdd("Old Hitbox Expander", "https://mokren.pages.dev/api/run?uid=sOY4To7IGY0kS9yIRoj9fwngtawvqvq")
ScriptAdd("Kawaii Freaky Fling", "https://raw.githubusercontent.com/hellohellohell012321/KAWAII-FREAKY-FLING/main/kawaii_freaky_fling.lua")
ScriptAdd("FE Animation Changer", "https://pastebin.com/raw/6pQYX6gU")
ScriptAdd("Orca Hub (Toggle Key = K)", "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua")
ScriptAdd("FE (R6/R15) 210+ Emotes / 31 Animations", "https://raw.githubusercontent.com/Eazvy/public-scripts/main/Universal_Animations_Emotes.lua")
ScriptAdd("ShiftLock", "https://mokren.pages.dev/api/run?uid=sOY4TiqzqfcnlbGZuPUhmxxdudpddux")
ScriptAdd("Keyboard", "https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/VirtualKeyboard.lua.txt")
ScriptAdd("Fe Invisible", "https://pastebin.com/raw/3Rnd9rHf")
ScriptAdd("Fps Boost", "https://raw.githubusercontent.com/UhGbaaaa/Script-Roblox-New/refs/heads/main/Fps%20boost%202024")
ScriptAdd("Free Emoji", "https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/Emoji.txt")
ScriptAdd("Wallhop", "https://raw.githubusercontent.com/aceurss/AcxScripter/refs/heads/main/FakeWallHopScript")
ScriptAdd("Aimbot", "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile")
ScriptAdd("Teleport Player", "https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/Teleport%20Gui.lua")
ScriptAdd("FE Lag Switch", "https://raw.githubusercontent.com/0Ben1/fe/main/Protected%20-%202023-05-28T225112.055.lua.txt")
ScriptAdd("Gubby Spawner", "https://pastebin.com/raw/Vs4J3jni")
ScriptAdd("Noclip Camera", "https://mokren.pages.dev/api/run?uid=sOY0SE8tDhFVDPpumYBnxrekkeyaeun")

local Button = t2:Button({
    Title = "Fall Gui",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source")
        Ioad("35487fdd8d70227a1537e4dfa2d21e5c")
    end
})


local Button = t2:Button({
    Title = "Anti Fling",
    Desc = "AntiFling Protect us from straying far away.",
    Locked = lock,
    Callback = function()
    noti("Anti Fling Successfully")
        if antifling then
            antifling:Disconnect()
            antifling = nil
        end

        -- បង្កើត antifling ថ្មី
        antifling = RunService.Stepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= speaker and player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
})

local Button = t2:Button({
    Title = "Anti Void",
    Desc = "Protects against falling leaves, but may cause phone crashes",
    Locked = lock,
    Callback = function()
    noti("Anti Void Successfully")
antivoidloop = RunService.Stepped:Connect(function()
    local root = getRoot(speaker.Character)
    if root and root.Position.Y <= OrgDestroyHeight + 25 then
        root.Velocity = root.Velocity + Vector3.new(0, 250, 0)
    end
end)
    end
})

local Section = t2:Section({ 
    Title = "workspaces",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Camera = game.Workspace.CurrentCamera
local PovOriginal = Camera.FieldOfView

local Input = t2:Input({
    Title = "Fov",
    Desc = "Input Fov (1 - 120)",
    Value = tostring(Camera.FieldOfView),
    InputIcon = "",
    Type = "Input",
    Placeholder = "Enter Fov...",
    Callback = function(input)
        local num = tonumber(input)
        if num and num >= 1 and num <= 120 then
            Camera.FieldOfView = num
            print("FOV set to:", num)
        else
            warn("Invalid FOV input:", input)
        end
    end
})

local Players = game:GetService("Players")
local PlrNs = Players.LocalPlayer

local DefaultCameraMode = "Classic" -- fallback default

if PlrNs.CameraMode == Enum.CameraMode.LockFirstPerson then
    DefaultCameraMode = "LockFirstPerson"
end

local Dropdown = t2:Dropdown({
    Title = "CameraMode (Select)",
    Values = { "Classic", "LockFirstPerson" },
    Value = DefaultCameraMode,
    Callback = function(option) 
        if option == "Classic" then
            PlrNs.CameraMode = Enum.CameraMode.Classic
        elseif option == "LockFirstPerson" then
            PlrNs.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end
})

local Players = game:GetService("Players")
local PlrNs = Players.LocalPlayer

local modeToIndex = {
    UserChoice = 1,
    Thumbstick = 2,
    DPad = 3,
    Thumbpad = 4,
    ClickToMove = 5,
    Scriptable = 6,
}

local currentModeName = PlrNs.DevTouchMovementMode.Name
local DefaultDexTouchMove = modeToIndex[currentModeName] or 1

local Dropdown = t2:Dropdown({
    Title = "DevTouchMovementMode (Select)",
    Values = { "UserChoice", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "Scriptable" },
    Value = DefaultDexTouchMove,
    Callback = function(Value)
        local enumValue = Enum.DevTouchMovementMode[Value]
        if enumValue then
            PlrNs.DevTouchMovementMode = enumValue
            print("DevTouchMovementMode changed to:", Value)
        else
            warn("Invalid DevTouchMovementMode selected:", Value)
        end
    end
})

-- Usage
Addgame("plant vs brinrot", {
    function(sec)
        AddScriptGame(sec, "plant vs brinrot (Blessed-Hub-X)", "https://raw.githubusercontent.com/mynamewendel-ctrl/Blessed-Hub-X-/refs/heads/main/Plants-Vs-Brainrots.lua")
    end
})

Addgame("Volleyball Legends", {
    function(sec)
        AddScriptGame(sec, "Volleyball Legends (Zeckhubv1)", "https://raw.githubusercontent.com/scriptshubzeck/Zeckhubv1/refs/heads/main/zeckhub")
    end
})

Addgame("99 nights in the forest", {
    function(sec)
        AddScriptGame(sec, "99 nights in the forest (Qiwikox12)", "https://raw.githubusercontent.com/Qiwikox12/stubrawl/refs/heads/main/99Night.txt")
    end,
    function(sec)
        AddScriptGame(sec, "99 nights in the forest (VapeVoidware)", "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua")
    end
})

local t4=Window:Tab({Title="命中框",Icon="box",Locked=false})

getgenv().HitboxSize = 10
getgenv().HitboxTransparency = 0.9

getgenv().HitboxStatus = false
getgenv().TeamCheck = false

local Input = t4:Input({
    Title = "Hitbox Player",
    Value = "10",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter Size Hitbox...",
    Callback = function(input) 
        getgenv().HitboxSize = input
    end
})

local Slider = t4:Slider({
    Title = "Hitbox Transparency",
    Step = 0.1,
    
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.9,
    },
    Callback = function(value)
        getgenv().HitboxTransparency = value
    end
})

local Toggle = t4:Toggle({
    Title = "Team Check",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        getgenv().TeamCheck = state
    end
})

local Toggle = t4:Toggle({
    Title = "Status",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        getgenv().HitboxStatus = state
    game:GetService('RunService').RenderStepped:connect(function()
		if HitboxStatus == true and TeamCheck == false then
			for i,v in next, game:GetService('Players'):GetPlayers() do
				if v.Name ~= game:GetService('Players').LocalPlayer.Name then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						v.Character.HumanoidRootPart.Transparency = HitboxTransparency
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
						v.Character.HumanoidRootPart.Material = "Neon"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		elseif HitboxStatus == true and TeamCheck == true then
			for i,v in next, game:GetService('Players'):GetPlayers() do
				if game:GetService('Players').LocalPlayer.Team ~= v.Team then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						v.Character.HumanoidRootPart.Transparency = HitboxTransparency
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
						v.Character.HumanoidRootPart.Material = "Neon"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		else
		    for i,v in next, game:GetService('Players'):GetPlayers() do
				if v.Name ~= game:GetService('Players').LocalPlayer.Name then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
						v.Character.HumanoidRootPart.Transparency = 1
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
						v.Character.HumanoidRootPart.Material = "Plastic"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		end
	end)
    end
})

local t5 = Window:Tab({Title="玩家", Icon="user-cog", Locked=false})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Safe teleport height
local SAFE_Y = 50000
local SAFE_CF = CFrame.new(0, SAFE_Y, 0)
local SAFE_PART_POS = Vector3.new(0, SAFE_Y - 0.5, 0)

-- State
local selectedPlayerName = nil
local viewing = false
local originalCFrame = nil
local savedPartStates = {}
local savedPlatformStand = nil
local safePart = nil

-- Helper: get player names
local function getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

-- Save character state
local function saveCharacterState(char)
    savedPartStates = {}
    for _, inst in ipairs(char:GetDescendants()) do
        if inst:IsA("BasePart") then
            savedPartStates[inst] = {Class="BasePart", Transparency=inst.Transparency, CanCollide=inst.CanCollide, Anchored=inst.Anchored}
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            savedPartStates[inst] = {Class="Decal", Transparency=inst.Transparency}
        end
    end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    savedPlatformStand = hum and hum.PlatformStand or nil
end

-- Make character invisible (but not anchored HumanoidRootPart)
local function setCharacterSpectateSafe(char)
    for _, inst in ipairs(char:GetDescendants()) do
        if inst:IsA("BasePart") and inst.Name ~= "HumanoidRootPart" then
            pcall(function() inst.Transparency=1 inst.CanCollide=false end)
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            pcall(function() inst.Transparency=1 end)
        end
    end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum then pcall(function() hum.PlatformStand=false end) end
end

-- Restore character state
local function restoreCharacterState(char)
    for inst, state in pairs(savedPartStates) do
        if inst and inst.Parent then
            if state.Class=="BasePart" then
                pcall(function()
                    inst.Transparency=state.Transparency or 0
                    inst.CanCollide=state.CanCollide~=nil and state.CanCollide or true
                    inst.Anchored=state.Anchored~=nil and state.Anchored or false
                end)
            elseif state.Class=="Decal" then
                pcall(function() inst.Transparency=state.Transparency or 0 end)
            end
        end
    end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum and savedPlatformStand~=nil then
        pcall(function() hum.PlatformStand=savedPlatformStand end)
    end
    savedPartStates={}
    savedPlatformStand=nil
end

-- Toggle View Player
local function ToggleViewPlayer(state)
    viewing = state
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("Local character not ready")
        viewing=false
        return
    end
    if state then
        if not selectedPlayerName then
            warn("Select a player first")
            viewing=false
            return
        end

        originalCFrame=LocalPlayer.Character.HumanoidRootPart.CFrame

        saveCharacterState(LocalPlayer.Character)
        setCharacterSpectateSafe(LocalPlayer.Character)

        -- teleport to high safe Y
        pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame=SAFE_CF end)

        -- create invisible safe platform
        safePart=Instance.new("Part")
        safePart.Size=Vector3.new(1000,1,1000)
        safePart.Anchored=true
        safePart.CanCollide=true
        safePart.Transparency=0
        safePart.Position=SAFE_PART_POS
        safePart.Name="Spectate_SafePlatform"
        safePart.Parent=workspace

        -- camera follow target
        local target=Players:FindFirstChild(selectedPlayerName)
        if target and target.Character then
            local th=target.Character:FindFirstChildWhichIsA("Humanoid")
            if th then pcall(function() Camera.CameraType=Enum.CameraType.Custom Camera.CameraSubject=th end) end
        end
    else
        -- restore camera
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
            pcall(function() Camera.CameraType=Enum.CameraType.Custom Camera.CameraSubject=LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") end)
        end
        -- teleport back
        if originalCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame=originalCFrame end)
        end
        -- restore state
        if LocalPlayer.Character then restoreCharacterState(LocalPlayer.Character) end
        -- destroy safe part
        if safePart then pcall(function() safePart:Destroy() end) safePart=nil end
    end
end

-- Dropdown
local Dropdown=t5:Dropdown({
    Title="Select Player",
    Values=getPlayerNames(),
    Value=getPlayerNames()[1],
    Callback=function(option)
        selectedPlayerName=option
        if viewing then
            ToggleViewPlayer(false)
            task.wait(0.05)
            ToggleViewPlayer(true)
        end
    end
})

Players.PlayerAdded:Connect(function() Dropdown:Refresh(getPlayerNames(), true) end)
Players.PlayerRemoving:Connect(function() Dropdown:Refresh(getPlayerNames(), true) end)
-- teleport once button
local Button = t5:Button({
    Title = "Teleport To Player",
    Callback = function()
        if not selectedPlayerName then
            warn("No player selected")
            return
        end
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") 
            and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        else
            warn("Target or local character not ready")
        end
    end
})

-- loop teleport toggle
local loopTeleport = false
local LoopToggle = t5:Toggle({
    Title = "Loop Teleport",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        loopTeleport = state
    end
})

-- loop teleport task
task.spawn(function()
    while true do
        if loopTeleport and selectedPlayerName then
            local target = Players:FindFirstChild(selectedPlayerName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") 
                and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
            end
        end
        task.wait(0.5)
    end
end)

-- View Player Toggle
local ToggleView=t5:Toggle({
    Title="View Player (Safe)",
    Type="Checkbox",
    Default=false,
    Callback=function(state) ToggleViewPlayer(state) end
})

-- Handle respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    if viewing then
        task.wait(0.2)
        saveCharacterState(char)
        setCharacterSpectateSafe(char)
        pcall(function() char:WaitForChild("HumanoidRootPart",2).CFrame=SAFE_CF end)
    end
end)

local BangToggle = t5:Toggle({
    Title = "Bang Player",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
            bangAnim = Instance.new("Animation")
            bangAnim.AnimationId = not r15(speaker) and "rbxassetid://148840371" or "rbxassetid://5918726674"
            bang = humanoid:LoadAnimation(bangAnim)
            bang:Play(0.1, 1, 1)
            bang:AdjustSpeed(args[2] or 3)

            bangDied = humanoid.Died:Connect(function()
                bang:Stop()
                bangAnim:Destroy()
                bangDied:Disconnect()
                bangLoop:Disconnect()
            end)

            if selectedPlayerName then
                local players = getPlayer(selectedPlayerName)
                for _, v in pairs(players) do
                    local bangplr = v.Name
                    local bangOffset = CFrame.new(0, 0, 1.1)
                    bangLoop = RunService.Stepped:Connect(function()
                        pcall(function()
                            local otherRoot = getTorso(v.Character)
                            getRoot(speaker.Character).CFrame = otherRoot.CFrame * bangOffset
                        end)
                    end)
                end
            end
        else
            if bangDied then bangDied:Disconnect() end
            if bang then bang:Stop() end
            if bangAnim then bangAnim:Destroy() end
            if bangLoop then bangLoop:Disconnect() end
        end
    end
})



local t6 = Window:Tab({Title="工具 / 中心", Icon="pencil-ruler", Locked=false})

t6:Paragraph({
    Title = "Script",
    Desc = "Script Hub ",
    Image = "shield-alert",
    ImageSize = 20,
    Color = "White"
})

local Button = t6:Button({
    Title = "Explorer",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
    end
})

local Button = t6:Button({
    Title = "Infinite Yield",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
})

local Button = t6:Button({
    Title = "GhostPlayer",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
    end
})

local Button = t6:Button({
    Title = "Swamp Monster Hub",
    Locked = false,
    Callback = function()
        run("https://pastefy.app/2tC7nRAK/raw")
    end
})

t6:Paragraph({
    Title = "Script",
    Desc = "Script Troll ",
    Image = "rabbit",
    ImageSize = 20,
    Color = "White"
})

local RunService = game:GetService("RunService")
local speaker = game.Players.LocalPlayer

local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local Toggle = t6:Toggle({
    Title = "Walk Fling",
    Desc = "Walk to Player for fling",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        walkflinging = state
        noti("Walk Fling " .. state)

        while walkflinging do
            RunService.Heartbeat:Wait()

            local character = speaker.Character
            local root = getRoot(character)
            if not (character and character.Parent and root and root.Parent) then continue end

            local vel = root.Velocity
            local movel = 0.1

            root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

            RunService.RenderStepped:Wait()
            if character and character.Parent and root and root.Parent then
                root.Velocity = vel
            end

            RunService.Stepped:Wait()
            if character and character.Parent and root and root.Parent then
                root.Velocity = vel + Vector3.new(0, movel, 0)
                movel = -movel
            end
        end
    end
})

local Button = t6:Button({
    Title = "saMtiek2",
    Locked = false,
    Callback = function()
        run("https://pastebin.com/raw/saMtiek2")
    end
})

local Button = t6:Button({
    Title = "TrollGui",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/AVG/refs/heads/main/Fe%20Troll%20Fling")
    end
})

local Button = t6:Button({
    Title = "Auto Fling Player",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Auto%20Fling%20Player")
    end
})

t6:Paragraph({
    Title = "Script",
    Desc = "Script ToolsHelp ",
    Image = "pencil-ruler",
    ImageSize = 20,
    Color = "White"
})

local Button = t6:Button({
    Title = "Position finder gui",
    Locked = false,
    Callback = function()
        run("https://pastebin.com/raw/BjViRedU")
    end
})

local Button = t6:Button({
    Title = "Part Gui",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source"))()
        Ioad("583e3bd54554f2bfdcd007a49fa6b035")
    end
})

local Button = t6:Button({
    Title = "Turtle spy",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/source.lua.txt")
    end
})

local Button = t6:Button({
    Title = "SimpleSpy",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/UhGbaaaa/Android-Value/main/SimpleSpyMobile.txt")
    end
})

local Button = t6:Button({
    Title = "OctoSpy",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/Octo%7ESpy.lua.txt")
    end
})

local Button = t6:Button({
    Title = "Gui Make",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/Key-System-/refs/heads/main/Gui%20Maker.txt")
    end
})

t6:Paragraph({
    Title = "Map",
    Desc = "Map Teleport and Anti",
    Image = "rabbit",
    ImageSize = 20,
    Color = "White"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local afkBase, timerPart, timerLabel
local afkTime = 0
local timerRunning = false
local timerTask
local savedCFrame = nil
local antiAfkTask = nil

-- Create 4 chairs with lights
local function createChairs()
    if not afkBase then return end

    local basePos = afkBase.Position + Vector3.new(0, 1, 0) -- កៅអីនៅលើដី
    local spacing = 8 -- ចន្លោះកៅអី

    for i = 1, 4 do
        -- Chair base
        local chair = Instance.new("Part")
        chair.Size = Vector3.new(4, 1, 4)
        chair.Anchored = true
        chair.Material = Enum.Material.Wood
        chair.Color = Color3.fromRGB(139, 69, 19)
        chair.Name = "AFK_Chair_"..i

        local offset = Vector3.new((i-2.5) * spacing, 0, 0)
        chair.Position = basePos + offset
        chair.Parent = workspace

        -- Seat
        local seat = Instance.new("Seat")
        seat.Size = Vector3.new(4, 1, 4)
        seat.Anchored = true
        seat.Position = chair.Position + Vector3.new(0, 1, 0)
        seat.Name = "Seat_"..i
        seat.Parent = workspace

        -- Light
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 15
        light.Color = Color3.fromRGB(255, 200, 150)
        light.Parent = seat
    end
end

-- Create AFK Base + Timer
local function createAFKBase()
    afkBase = Instance.new("Part")
    afkBase.Size = Vector3.new(1000,1,1000)
    afkBase.Anchored = true
    afkBase.Position = Vector3.new(0,0,5000)
    afkBase.Material = Enum.Material.Grass
    afkBase.Color = Color3.fromRGB(34,139,34)
    afkBase.Name = "AFK_Base"
    afkBase.Parent = workspace

    timerPart = Instance.new("Part")
    timerPart.Size = Vector3.new(10,5,1)
    timerPart.Anchored = true
    timerPart.Position = afkBase.Position + Vector3.new(0,5,0)
    timerPart.Transparency = 1
    timerPart.CanCollide = false
    timerPart.Name = "AFK_Timer_Part"
    timerPart.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.Adornee = timerPart
    billboard.AlwaysOnTop = true
    billboard.Parent = timerPart

    timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1,0,1,0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextColor3 = Color3.new(1,1,1)
    timerLabel.TextScaled = true
    timerLabel.Text = "AFK Timer: 0s"
    timerLabel.Parent = billboard

    -- Add chairs
    createChairs()
end

-- Destroy AFK Base + Timer
local function destroyAFKBase()
    if afkBase then afkBase:Destroy() end
    if timerPart then timerPart:Destroy() end
    -- Clear chairs
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:match("AFK_Chair_") or obj.Name:match("Seat_") then
            obj:Destroy()
        end
    end
    afkBase, timerPart, timerLabel = nil, nil, nil
    afkTime = 0
    timerRunning = false
end

-- Timer
local function startTimer()
    timerRunning = true
    timerTask = task.spawn(function()
        while timerRunning do
            afkTime += 1
            if timerLabel then
                timerLabel.Text = "AFK Timer: "..afkTime.."s"
            end
            task.wait(1)
        end
    end)
end

local function stopTimer()
    timerRunning = false
    timerTask = nil
end

-- Anti AFK Jump
local function startAntiAfkJump()
    antiAfkTask = task.spawn(function()
        while true do
            task.wait(60)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end)
end

local function stopAntiAfkJump()
    if antiAfkTask then
        task.cancel(antiAfkTask)
        antiAfkTask = nil
    end
end

-- Toggle
local Toggle = t6:Toggle({
    Title = "Teleport Map Afk",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            -- Save position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
            createAFKBase()
            -- Teleport player
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = afkBase.CFrame + Vector3.new(0,5,0)
            end
            startTimer()
            startAntiAfkJump()
        else
            -- Back to position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and savedCFrame then
                LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
            end
            stopTimer()
            destroyAFKBase()
            stopAntiAfkJump()
        end
    end
})

local t7 = Window:Tab({
    Title = "部分脚本",
    Icon = "cuboid", -- optional
    Locked = false,
})

local Button = t7:Button({
    Title = "Part Name",
    Desc = "Get Part name Click in part and shoe part name",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/partname.lua.txt")
    end
})

t7:Divider()

--== Variables ==--
--== Input: Multiple Part Names ==--
local Input = t7:Input({
    Title = "Input Part Name(s)",
    Desc = "Example: part1, part2, part3 or one part",
    Value = "",
    InputIcon = "",
    Type = "Input",
    Placeholder = "Enter part names separated by comma...",
    Callback = function(Value)
        local partList = {}
        for name in string.gmatch(Value, "[^,]+") do
            name = name:gsub("^%s*(.-)%s*$", "%1") -- trim space
            table.insert(partList, name)
        end
        getgenv().PartNames = partList
        print("✅ Loaded Parts:", table.concat(partList, ", "))
    end
})

--== ESP Toggle ==--
local Toggle = t7:Toggle({
    Title = "Part ESP",
    Desc = "Show direction to parts",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        isEspEnabled = state
        if state then
            espParts = getgenv().PartNames or {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    for _, name in pairs(espParts) do
                        if v.Name:lower() == name:lower() then
                            AddESP(v)
                        end
                    end
                end
            end
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    for _, name in pairs(espParts) do
                        local adornment = part:FindFirstChild(name.."_TextESP")
                        if adornment then
                            adornment:Destroy()
                        end
                    end
                end
            end
            espParts = {}
        end
    end
})

--== GOTO Button ==--
local Button = t7:Button({
    Title = "Goto",
    Desc = "Teleport to all selected parts",
    Locked = false,
    Callback = function()
        if not getgenv().PartNames then return end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                for _, name in pairs(getgenv().PartNames) do
                    if v.Name:lower() == name:lower() then
                        local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.SeatPart then
                            humanoid.Sit = false
                            task.wait(0.1)
                        end
                        local root = getRoot(speaker.Character)
                        if root then
                            root.CFrame = v.CFrame
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
    end
})

--== Loop Goto ==--
local Toggle = t7:Toggle({
    Title = "Loop Goto",
    Desc = "Auto teleport to all parts",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(v)
        LoopGoto = v
        if v then
            task.spawn(function()
                while LoopGoto do
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") then
                            for _, name in pairs(getgenv().PartNames or {}) do
                                if v.Name:lower() == name:lower() then
                                    local root = getRoot(speaker.Character)
                                    if root then
                                        root.CFrame = v.CFrame
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

--== Bring Button ==--
local Button = t7:Button({
    Title = "Bring",
    Desc = "Bring all parts to you",
    Locked = false,
    Callback = function()
        local root = getRoot(speaker.Character)
        if not root then return end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                for _, name in pairs(getgenv().PartNames or {}) do
                    if v.Name:lower() == name:lower() then
                        v.CFrame = root.CFrame
                        task.wait(0.1)
                    end
                end
            end
        end
    end
})

--== Loop Bring ==--
local Toggle = t7:Toggle({
    Title = "Loop Bring",
    Desc = "Auto bring parts",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        LoopBring = state
        if state then
            task.spawn(function()
                while LoopBring do
                    local root = getRoot(speaker.Character)
                    if root then
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("BasePart") then
                                for _, name in pairs(getgenv().PartNames or {}) do
                                    if v.Name:lower() == name:lower() then
                                        v.CFrame = root.CFrame
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

--== Touch Button ==--
t7:Button({
    Title = "Touch",
    Desc = "Touch all selected parts",
    Callback = function()
        if typeof(firetouchinterest) ~= "function" then
            WindUI:Notify({
                Title = "Unsupported",
                Content = "firetouchinterest not supported by this executor.",
                Duration = 5
            })
            return
        end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                for _, name in pairs(getgenv().PartNames or {}) do
                    if v.Name:lower() == name:lower() then
                        firetouchinterest(humanoidRoot, v, 0)
                        firetouchinterest(humanoidRoot, v, 1)
                        task.wait(0.05)
                    end
                end
            end
        end
    end
})

--== Auto Update ESP / Goto / Bring ==--
workspace.DescendantAdded:Connect(function(part)
    if not getgenv().PartNames then return end
    if not part:IsA("BasePart") then return end

    for _, name in pairs(getgenv().PartNames) do
        if part.Name:lower() == name:lower() then
            if isEspEnabled then AddESP(part) end
            if LoopGoto then
                task.delay(gotopartDelay or 0, function()
                    local root = getRoot(speaker.Character)
                    if root then
                        root.CFrame = part.CFrame
                    end
                end)
            end
            if LoopBring then
                task.delay(0, function()
                    local root = getRoot(speaker.Character)
                    if root then
                        part.CFrame = root.CFrame
                    end
                end)
            end
        end
    end
end)

local safe = Window:Tab({
    Title = "安全与防护",
    Icon = "shield-check", -- optional
    Locked = false,
})

local Safe

if Check("SystemSafe.json") then
Safe = LoadFile("SystemSafe.json")
else
Safe = {
    AllowKick = false,
    AllowRejoin = false
}

SaveFile("SystemSafe.json", Safe)
end

-- Toggle UI for Allow Kick
local ToggleKick = safe:Toggle({
    Title = "Allow Kick",
    Desc = "They can remove you from the game.",
    Type = "Checkbox",
    Default = Safe.AllowKick,
    Callback = function(state) 
        Safe.AllowKick = state          -- update Safe
        SaveFile("SystemSafe.json", Safe)  -- save changes
    end
})

-- Toggle UI for Allow Rejoin
local ToggleRejoin = safe:Toggle({
    Title = "Allow Rejoin",
    Desc = "You will enter a new game without permission.",
    Type = "Checkbox",
    Default = Safe.AllowRejoin,
    Callback = function(state) 
        Safe.AllowRejoin = state        -- update Safe
        SaveFile("SystemSafe.json", Safe)  -- save changes
    end
})

	local st = Window:Tab({Title = "设置", Icon = "settings",  Locked = false })

st:Paragraph({
    Title = "Popo Toggle",
    Desc = "Toggle for PC And Mobile",
    Image = "crown",
    ImageSize = 20,
    Color = "White"
})

local UIS = game:GetService("UserInputService")

if UIS.TouchEnabled then
    if button and button.Visible ~= nil then
        button.Visible = true
    end
end

local Keybind = st:Keybind({
    Title = "Toggle For PC",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

st:Paragraph({
    Title = "Customize Theme",
    Desc = "Select your Theme",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

--== Variables ==--
local canchangetheme = true
local canchangedropdown = true

--== Functions Save/Load ==--
local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

local DataKI

if Check("Theme.json") then
DataKI = LoadFile("Theme.json")

WindUI:SetTheme(DataKI.Theme)
else
 DataKI = {
   Theme = "Dark"
}

SaveFile("Theme.json", DataKI)

WindUI:SetTheme(DataKI.Theme)
end

--== Create Dropdown UI ==--
local themeDropdown = st:Dropdown({
    Title = "Select Theme",
    Values = themes,
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = DataKI.Theme or "Dark",
    Callback = function(theme)
        canchangedropdown = false
        WindUI:SetTheme(theme)
        DataKI.Theme = theme
        WindUI:Notify({
            Title = "Theme Applied",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
        SaveFile("Theme.json", DataKI)
        canchangedropdown = true
    end
})

--== Transparency Slider ==--
local transparencySlider = st:Slider({
    Title = "Transparency",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

Window:OnClose(function()
    print("Window Closed")
end)

Window:OnOpen(function()
    print("Window Opened")
end)

Window:OnDestroy(function()
    print("Window Destroyed")
end)

end

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Forbidden games
local Forbidden = {
    [109983668079237] = true, -- ហាមហ្គេមនេះ
    [96342491571673] = true, -- ហាមហ្គេមនេះផងដែរ
}
local placeId = game.PlaceId

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PoppHubLoadingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 0.4
bg.Parent = screenGui

-- Card panel
local card = Instance.new("Frame")
card.Size = UDim2.new(0,450,0,200)
card.Position = UDim2.new(0.5,0,0.5,0)
card.AnchorPoint = Vector2.new(0.5,0.5)
card.BackgroundColor3 = Color3.fromRGB(25,25,25)
card.BorderSizePixel = 0
card.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,20)
corner.Parent = card

local shadow = Instance.new("UIStroke")
shadow.Thickness = 5
shadow.Transparency = 0.6
shadow.Color = Color3.fromRGB(0,0,0)
shadow.Parent = card

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,0,50)
title.Position = UDim2.new(0,20,0,20)
title.BackgroundTransparency = 1
title.Text = "PoppHub Loading"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = card

-- Loading bar container
local barContainer = Instance.new("Frame")
barContainer.Size = UDim2.new(0.8,0,0,25)
barContainer.Position = UDim2.new(0.1,0,0,140)
barContainer.BackgroundColor3 = Color3.fromRGB(50,50,50)
barContainer.BorderSizePixel = 0
barContainer.Parent = card

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,12)
barCorner.Parent = barContainer

-- Loading bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
barFill.BorderSizePixel = 0
barFill.Parent = barContainer

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0,12)
barFillCorner.Parent = barFill

-- Loading percent text
local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1,0,0,25)
percentText.Position = UDim2.new(0,0,0,115)
percentText.BackgroundTransparency = 1
percentText.TextColor3 = Color3.fromRGB(255,255,255)
percentText.TextScaled = true
percentText.Font = Enum.Font.Gotham
percentText.Text = "0%"
percentText.Parent = card

-- Fade-in card and text
card.BackgroundTransparency = 1
title.TextTransparency = 1
barContainer.BackgroundTransparency = 1
percentText.TextTransparency = 1

TweenService:Create(card, TweenInfo.new(1), {BackgroundTransparency=0}):Play()
TweenService:Create(title, TweenInfo.new(1), {TextTransparency=0}):Play()
TweenService:Create(barContainer, TweenInfo.new(1), {BackgroundTransparency=0}):Play()
TweenService:Create(percentText, TweenInfo.new(1), {TextTransparency=0}):Play()

local TimerEnd
if admin then
TimerEnd = 2
local stages = {
    {text="Load Scripts...", percent=99, delay=1},
}

else
TimerEnd = 13
local stages = {
    {text="Load Scripts...", percent=1, delay=1},
    {text="Load Game...", percent=20, delay=2},
    {text="Network Check...", percent=25, delay=1.5},
    {text="Finalizing Load...", percent=30, delay=1},
    {text="Finalizing Load...", percent=math.random(31, 70), delay=1.5},
    {text="Finalizing Load...", percent=math.random(71, 99), delay=2},
    {text="Finalizing Load...", percent=100, delay=1.5},
}
end

-- Function to Tween bar smoothly
local function tweenBar(targetPercent, duration)
    TweenService:Create(barFill, TweenInfo.new(duration), {Size=UDim2.new(targetPercent/100,0,1,0)}):Play()
end

-- Run loading stages
stages = stages or {} -- fallback

spawn(function()
    if type(stages) ~= "table" then
        warn("stages is not a table!", stages)
        return
    end

    for _, stage in ipairs(stages) do
        percentText.Text = stage.percent.."% - "..stage.text
        tweenBar(stage.percent, stage.delay)
        wait(stage.delay)
    end
end)

-- Fade out & Popup
delay(TimerEnd,function()
    if Forbidden[placeId] then
        percentText.Text = "This game cannot run scripts.popphub"
        return
    end
    
    local fadeOut = TweenInfo.new(1)
    TweenService:Create(card, fadeOut, {BackgroundTransparency=1}):Play()
    TweenService:Create(title, fadeOut, {TextTransparency=1}):Play()
    TweenService:Create(barContainer, fadeOut, {BackgroundTransparency=1}):Play()
    TweenService:Create(barFill, fadeOut, {Size=UDim2.new(0,0,1,0)}):Play()
    TweenService:Create(percentText, fadeOut, {TextTransparency=1}):Play()

    delay(1,function() screenGui:Destroy() end)

    -- Popup safe check
    if typeof(WindUI) == "table" and typeof(WindUI.Popup) == "function" then
        pcall(function()
            WindUI:Popup({
                Title = "PopoHub",
                Icon = "shield-alert",
                Content = "For weak phones, please do not run because this code requires strong phone power.",
                Buttons = {
                    {
                        Title = "Cancel",
                        Callback = function() print("Cancel clicked") end,
                        Variant = "Tertiary",
                    },
                    {
                        Title = "Continue",
                        Icon = "check",
                        Callback = function()
                            print("Continue clicked")
                            if typeof(PoppHubCom) == "function" then
                                PoppHubCom()
                            else
                                warn("PoppHubCom is not defined!")
                            end
                        end,
                        Variant = "Primary",
                    }
                }
            })
        end)
    else
        warn("WindUI or WindUI:Popup not defined, skipping popup.")
    end
end)