local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local name = LocalPlayer.Name

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
end

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local premium = false
local player = Players.LocalPlayer
local gamepassID = 1456281488


local function checkGamepass()
    local success, hasPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassID)
    end)

    if success then
        if hasPass then
            premium = true
            print(" Player Owns Gamepass!")
        else
            premium = false
            print(" Player DOES NOT own Gamepass.")
        end
    else
        warn(" Failed to check Gamepass: " .. tostring(hasPass))
    end
end

checkGamepass()

local whitelist = { "BTSfreefire0", "Roblox?" }
local player = game.Players.LocalPlayer

for _, name in ipairs(whitelist) do
    if player.Name == name then
        premium = true
        break
    end
end

wait(0.5)

local lock = not premium

-- Settings file path (Executor must support isfile/writefile/readfile)
local folderName = "PopoHub_"..name
local settingsFile = folderName.."/esp_settings.json"

local function loadSettings()
    if isfile and isfile(settingsFile) then
        return HttpService:JSONDecode(readfile(settingsFile))
    else
        return {}
    end
end

local function saveSettings(data)
    if makefolder and not isfolder(folderName) then
        makefolder(folderName)
    end
    writefile(settingsFile,HttpService:JSONEncode(data))
end

local settings = loadSettings()

-- default variables
local loopSpeed,loopJump,noclipEnabled,ESPEnabled,infJumpEnabled=false,false,false,false,false
local targetSpeed,targetJump=16,50
local ESPColor=Color3.fromRGB(0,255,0)
local ESPCategories={"ESP DISPLAY"}
local selectedFont=Enum.Font[settings.Font or "SourceSans"] or Enum.Font.SourceSans
local ESPObjects={}

-- window
local Window = WindUI:CreateWindow({
    Title = "PopoHub | "..name,
    Icon = "rbxassetid://109391626514519",
    Author = "by bysuskhmer",
    Folder = folderName,
    Size = UDim2.fromOffset(480, 360),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    Background = "rbxassetid://103726525643231",
    KeySystem = { 
        Key = { "78474","PopoHub2025" },
        Note = "Enter Key System.",
        URL = "https://t.me/+qLcOpLQydK5mZTg9",
        SaveKey = true,
    },
})

Window:EditOpenButton({
    Title = "POPO HUB",
    Icon = "monitor",
    CornerRadius = UDim.new(0,5),
    StrokeThickness = 1,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:DisableTopbarButtons({
    "Close", 
    "Fullscreen",
})

local function music(idPut)
        local Sound = Instance.new("Sound")
        Sound.Name = "VengMusic"
        Sound.SoundId = "rbxassetid://" .. idPut
        Sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        Sound.Volume = 1
        Sound:Play()
end

local function noti(title, content, duration)
    music("124951621656853")
    WindUI:Notify({
    Title = title,
    Content = content,
    Duration = duration, -- 3 seconds
})
end

local isRunning = false  -- flag to check if a script is already running

local function run(scriptUrl)
    if isRunning then
        noti("Script Blocked", "Another script is already running!")
        return
    end

    isRunning = true  -- mark as running

    local HttpService = game:GetService("HttpService")
    local urlLower = scriptUrl:lower()
    local typescript = "Unknown"

    if string.find(urlLower, "github") then
        typescript = "Github"
    elseif string.find(urlLower, "pastebin") then
        typescript = "Pastebin"
    elseif string.find(urlLower, "gist") then
        typescript = "Gist"
    elseif string.find(urlLower, "hastebin") then
        typescript = "Hastebin"
    elseif string.find(urlLower, "ghostbin") then
        typescript = "Ghostbin"
    elseif string.find(urlLower, "controlc") then
        typescript = "ControlC"
    elseif string.find(urlLower, "rentry") then
        typescript = "Rentry"
    elseif string.find(urlLower, "sourcebin") then
        typescript = "SourceBin"
    elseif string.find(urlLower, "pastie") then
        typescript = "Pastie"
    elseif string.find(urlLower, "haste.host") then
        typescript = "HasteHost"
    elseif string.find(urlLower, "mokren.pages.dev") then
        typescript = "MokrenAPI"
    end

    noti("Script Run", "Loading")

    local startTime = os.clock()

    local success, err = pcall(function()
        local data = game:HttpGet(scriptUrl)
        local isJson, parsed = pcall(function()
            return HttpService:JSONDecode(data)
        end)

        if isJson and parsed.code then
            loadstring(parsed.code)()
        else
            loadstring(data)()
        end
    end)

    local endTime = os.clock()
    local elapsedTime = string.format("%.2f", endTime - startTime)

    if success then
        noti("Script Successful", "Time Script done: " .. elapsedTime .. "s")
    else
        noti("Script Error", "Error: " .. err .. "/Timer : " .. elapsedTime .. "s")
    end

    isRunning = false  -- mark as finished
end

Window:Tag({Title="v1.1",Color=Color3.fromHex("#30ff6a")})

local t1=Window:Tab({Title="Player",Icon="user",Locked=false})

-- util
local function getHumanoid()
    local c=LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- run loop
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

UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum=getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- GUI controls
t1:Input({
    Title="Enter Speed",Value=tostring(targetSpeed),
    Callback=function(v)
        targetSpeed=tonumber(v) or 16
        local hum=getHumanoid()
        if hum then hum.WalkSpeed=targetSpeed end
    end
})
t1:Toggle({Title="Loop Speed",Default=false,Callback=function(s)loopSpeed=s end})

t1:Input({
    Title="Enter Jump",Value=tostring(targetJump),
    Callback=function(v)
        targetJump=tonumber(v) or 50
        local hum=getHumanoid()
        if hum then hum.JumpPower=targetJump end
    end
})
t1:Toggle({Title="Loop Jump",Default=false,Callback=function(s)loopJump=s end})
t1:Toggle({Title="Noclip",Default=false,Callback=function(s)noclipEnabled=s end})
t1:Toggle({Title="Infinite Jump",Default=false,Callback=function(s)infJumpEnabled=s end})

-- ► Variable សម្រាប់គ្រប់គ្រង
getgenv().TPSpeed = 1       -- ល្បឿនដើរ
getgenv().TPWalk = false    -- ON/OFF Tpwalk

local ToggleTpwalk = false

-- ► Slider Speed

local Input = t1:Input({
    Title = "Tpwalk Speed",
    Value = "1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter SpeedTpwalk...",
    Callback = function(input) 
        getgenv().TPSpeed = input
    end
})

-- ► Toggle Tpwalk
local Toggle = t1:Toggle({
    Title = "Tpwalk Loop",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        ToggleTpwalk = state          -- សេវាកម្ម toggle
        getgenv().TPWalk = state      -- បើក/បិទ TPWalk
    end
})

-- ► RunService Heartbeat (loop)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    if ToggleTpwalk and getgenv().TPWalk then
        local chr = lplr.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        if chr and hum and hum.Parent then
            if hum.MoveDirection.Magnitude > 0 then
                -- បម្លែង Speed ជាអត្រាលេខ
                local speed = tonumber(getgenv().TPSpeed) or 1
                chr:TranslateBy(hum.MoveDirection * speed)
            end
        end
    end
end)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// SETTINGS
local settings = {}
if isfile and readfile and writefile then
    if isfile("esp_settings.json") then
        settings = game:GetService("HttpService"):JSONDecode(readfile("esp_settings.json"))
    end
end
local function saveSettings(tbl)
    if writefile then
        writefile("esp_settings.json", game:GetService("HttpService"):JSONEncode(tbl))
    end
end

--// DEFAULT
local ESPEnabled = false
local ESPColor = settings.Color and Color3.fromRGB(settings.Color[1], settings.Color[2], settings.Color[3]) or Color3.fromRGB(255,0,0)
local ESPCategories = settings.Cats or {"ESP USERNAME"}
local selectedFont = Enum.Font[settings.Font or "SourceSans"]
local ESPObjects = {}

--// UI
local SectionESP = t1:Section({ 
    Title = "ESP | PLAYER",
    TextXAlignment = "Left",
    TextSize = 17,
})

t1:Toggle({
    Title="ESP Players",Default=ESPEnabled,
    Callback=function(state)
        ESPEnabled = state
        if not state then
            for plr,obj in pairs(ESPObjects) do
                if obj and obj.Parent then obj:Destroy() end
            end
            ESPObjects = {}
        end
    end
})

t1:Colorpicker({
    Title="ESP Color",
    Default=ESPColor,
    Callback=function(color)
        ESPColor=color
        settings.Color={math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)}
        saveSettings(settings)
    end
})

t1:Dropdown({
    Title="ESP SHOW",
    Values={"ESP USERNAME","ESP DISPLAY","ESP HP"},
    Value=ESPCategories,
    Multi=true,
    Callback=function(option)
        ESPCategories=option
        settings.Cats=option
        saveSettings(settings)
    end
})

-- font list
local fonts={
"Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansSemibold","SourceSansLight","SourceSansItalic","SourceSansBoldItalic",
"Bodoni","Garamond","Cartoon","ComicSans","Code","Fantasy","SciFi","Arcade","Highway","Marker","Antique","Gotham","GothamMedium","GothamBold",
"GothamBlack","GothamSemibold","GothamBook","GothamLight","GothamThin","Roboto","RobotoCondensed","RobotoMono","RobotoBold","RobotoMedium",
"RobotoLight","RobotoThin","FredokaOne","Fondamento","Creepster","LuckiestGuy","PatrickHand","PermanentMarker","IndieFlower","SpecialElite",
"TitilliumWeb","Ubuntu","Bangers","JosefinSans","PressStart2P","Nunito","Oswald"
}

t1:Dropdown({
    Title="ESP Font",
    Values=fonts,
    Value=settings.Font or "SourceSans",
    Multi=false,
    Callback=function(v)
        if Enum.Font[v] then
            selectedFont=Enum.Font[v]
            settings.Font=v
            saveSettings(settings)
        end
    end
})

--// FUNCTION CREATE ESP
local function createESP(plr)
    if plr==LocalPlayer then return end
    if ESPObjects[plr] then ESPObjects[plr]:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.Name = "ESP_"..plr.Name

    local text = Instance.new("TextLabel",billboard)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = ESPColor
    text.Font = selectedFont
    text.TextScaled = true

    ESPObjects[plr]=billboard

    local function update()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            billboard.Adornee = char:FindFirstChild("HumanoidRootPart")
            local txts = {}
            if table.find(ESPCategories,"ESP USERNAME") then table.insert(txts,plr.Name) end
            if table.find(ESPCategories,"ESP DISPLAY") then table.insert(txts,plr.DisplayName) end
            if table.find(ESPCategories,"ESP HP") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then table.insert(txts,math.floor(hum.Health).." HP") end
            end
            text.Text = table.concat(txts," | ")
            text.TextColor3 = ESPColor
            text.Font = selectedFont
        end
    end
    RunService.Heartbeat:Connect(function()
        if ESPEnabled and ESPObjects[plr] then
            update()
            billboard.Parent = game.CoreGui
        elseif ESPObjects[plr] then
            billboard.Parent=nil
        end
    end)
end

--// HOOK EVENTS
for _,plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then ESPObjects[plr]:Destroy() ESPObjects[plr]=nil end
end)

local Section = t1:Section({ 
    Title = "Game | Font",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

-- Roblox Fonts List
-- 📂 Path Settings file
local savePath = "MyFontSetting.txt"

-- 📝 Get all font names from Enum.Font
local fontNames = {}
for _, font in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(fontNames, font.Name)
end

-- 📌 Load saved font if exist
local savedFontName = fontNames[1] -- default
if isfile and isfile(savePath) then
    local content = readfile(savePath)
    if Enum.Font[content] then
        savedFontName = content
    end
end

-- 📌 Function to apply font to all TextLabels/TextButtons/TextBoxes
local function applyFont(fontEnum)
    local player = game.Players.LocalPlayer
    for _, guiObj in ipairs(player:WaitForChild("PlayerGui"):GetDescendants()) do
        if guiObj:IsA("TextLabel") or guiObj:IsA("TextButton") or guiObj:IsA("TextBox") then
            guiObj.Font = fontEnum
        end
    end
    for _, guiObj in ipairs(workspace:GetDescendants()) do
        if guiObj:IsA("TextLabel") or guiObj:IsA("TextButton") or guiObj:IsA("TextBox") then
            guiObj.Font = fontEnum
        end
    end
end

-- 📝 Apply saved font right away
applyFont(Enum.Font[savedFontName])

-- 🎛 Dropdown UI
local Dropdown = t1:Dropdown({
    Title = "Select Font",
    Values = fontNames,
    Value = savedFontName,
    Callback = function(option)
        local selectedFont = Enum.Font[option]
        if not selectedFont then return end

        -- Apply new font
        applyFont(selectedFont)

        -- Save font name to file
        if writefile then
            writefile(savePath, option)
        end
    end
})

Window:SelectTab(1)

local t2=Window:Tab({Title="Script",Icon="file-code",Locked=false})

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
    Title = "Noclip Camera",
    Locked = false,
    Callback = function()
        run("https://mokren.pages.dev/api/run?uid=sOY0SE8tDhFVDPpumYBnxrekkeyaeun")
    end
})

local Button = t2:Button({
    Title = "FE Lag Switch",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/0Ben1/fe/main/Protected%20-%202023-05-28T225112.055.lua.txt")
    end
})

local ToggleDestroy = false

local Toggle = t2:Toggle({
    Title = "Destroy Delay",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        ToggleDestroy = state
    end
})

-- function to set HoldDuration
local function updatePrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

-- update all existing once when toggled
local function updateAllPrompts()
    for _,v in ipairs(workspace:GetDescendants()) do
        updatePrompt(v)
    end
end

-- listen for new prompts
workspace.DescendantAdded:Connect(function(inst)
    if ToggleDestroy then
        updatePrompt(inst)
    end
end)

-- when toggle on, update all once
game:GetService("RunService").Heartbeat:Connect(function()
    if ToggleDestroy then
        updateAllPrompts()
    end
end)

local t3=Window:Tab({Title="Game",Icon="gamepad-2",Locked=false})

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
    Title = "Fly {Fe Gui V3}",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/AVG/refs/heads/main/Fly%20Gui%20V3")
    end
})

local Button = t2:Button({
    Title = "Fly {Vehicle}",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui")
    end
})

ScriptAdd("Fly Car", "https://safetycode-free.vercel.app/api/run?uid=sOVkfQrqmoqsd576b7x")

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
    Desc = "Click For To Load Script",
    Locked = lock,
    Callback = function()
        local function NoCollision(plr)
            if AntiFling and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end

        -- Apply to existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                RunService.Stepped:Connect(function()
                    NoCollision(player)
                end)
            end
        end

        -- Apply to new players
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                RunService.Stepped:Connect(function()
                    NoCollision(player)
                end)
            end
        end)
    end
})

local Section = t2:Section({ 
    Title = "SpaceGame",
    TextXAlignment = "Left",
    TextSize = 17,
})

local GravityOriginal = workspace.Gravity

local Slider = t2:Slider({
    Title = "Gravity",
    Step = 1,
    
    Value = {
        Min = 0,
        Max = 1000,
        Default = GravityOriginal,
    },
    Callback = function(value)
        workspace.Gravity = value
    end
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
Addgame("Volleyball Legends", {
    function(sec)
        AddScriptGame(sec, "Volleyball Legends", "https://raw.githubusercontent.com/scriptshubzeck/Zeckhubv1/refs/heads/main/zeckhub")
    end
})

Addgame("99 nights in the forest", {
    function(sec)
        AddScriptGame(sec, "99 nights in the forest (1)", "https://raw.githubusercontent.com/Qiwikox12/stubrawl/refs/heads/main/99Night.txt")
    end,
    function(sec)
        AddScriptGame(sec, "99 nights in the forest (2)", "https://rawscripts.net/raw/99-Nights-in-the-Forest-Kill-Aura-Bring-Items-and-more-42703")
    end
})

local t4=Window:Tab({Title="Hitbox",Icon="box",Locked=false})

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

local t5=Window:Tab({Title="Popo Premium",Icon="dollar-sign",Locked=false})

local Section = t5:Section({ 
    Title = "Hi ,",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Section = t5:Section({ 
    Title = "Do you need buy Popo Premium ,",
    TextXAlignment = "Left",
    TextSize = 17, 
})

local Paragraph = t5:Paragraph({
    Title = "Popo Premium",
    Desc = "Popo Premium | 80robux\n what give\n• No Key\n• Unlock Premium\n• Unlock Tab Premium \n• Unlock Script Premium",
    Color = "Red",
    Locked = false,
    Buttons = {
    {
        Icon = "hand-coins",
        Title = "Buy",
        Callback = function()
            -- ប្រើ setclipboard ដើម្បីចម្លង link
            if setclipboard then
                setclipboard("https://www.roblox.com/game-pass/1456281488/Popo-Premium")
                noti("Copy", "Copied Successfully")
            else
                noti("Error", "Clipboard not supported in your executor")
            end
        end,
    }
}
})