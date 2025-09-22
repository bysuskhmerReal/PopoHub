function Mobile()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local name = LocalPlayer.Name
local folderName = "PopoHub/".. name.. "/"
local admin = false
if name == "bysuskhmer_100" then
    
else

end

local function music(idPut, id)
        local Sound = Instance.new("Sound")
        Sound.Name = id or "SONG POPO"
        Sound.SoundId = "rbxassetid://" .. idPut
        Sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        Sound.Volume = 1
        Sound:Play()
end

local function noti(title, content, duration)
    music("124951621656853")
    WindUI:Notify({
    Title = title or "",
    Content = content or "",
    Duration = duration or 3, -- 3 seconds
})
end

function SaveFile(Filename, Value)
    local HttpService = game:GetService("HttpService")
    local data = HttpService:JSONEncode(Value)
    writefile(folderName .. Filename, data)
end

function LoadFile(Filename)
    local HttpService = game:GetService("HttpService")
    if isfile(folderName .. Filename) then
        local raw = readfile(folderName .. Filename)
        local data = HttpService:JSONDecode(raw)
        return data
    else
        return nil
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

if Check("PopoMain.json") then
    PopoGui = LoadFile("PopoMain.json")
else
    -- Save
PopoGui = {
    Title = "Popo Hub",
    Version = "v2",
    SizeGui = 480,
    SizeGui2 = 360,
    HideSearchBar = false,
    Icon = "cat"
}
SaveFile("PopoMain.json", PopoGui)
end

--// SAFE SETTINGS
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

--// NOTIFICATION FUNCTION
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

    -- Block TeleportService methods
    if self == TeleportService and (method == "Teleport" or method == "TeleportToPlaceInstance") then
        ShowNotification("Safe Rejoin","Blocked Teleport/Rejoin attempt!",5)
        if Safe.AllowRejoin then
            return oldNamecall(self,...)
        else
            warn("Blocked Teleport / TeleportToPlaceInstance attempt")
            return nil
        end
    end

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

--// BLOCK SERVER KICK VIA PLAYERREMOVING
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer and not Safe.AllowKick then
        ShowNotification("Safe Rejoin","Blocked server kick attempt!",5)
        warn("Blocked PlayerRemoving attempt")
    end
end)

print("✅ Full Safe Rejoin + Hook Kick + Block Teleport Activated")
print("AllowRejoin =", Safe.AllowRejoin, "| AllowKick =", Safe.AllowKick)

local function PopoHub(administration)

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
end

local loopSpeed,loopJump,noclipEnabled,ESPEnabled,infJumpEnabled=false,false,false,false,false
local targetSpeed,targetJump=16,50
local ESPObjects={}

-- window
local Window = WindUI:CreateWindow({
    Title = PopoGui.Title,
    Icon = PopoGui.Icon, -- lucide icon
    Author = "by .bysuskhmer",
    Folder = folderName,
    Size = UDim2.fromOffset(PopoGui.SizeGui, PopoGui.SizeGui2),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Crimson",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = PopoGui.HideSearchBar,
    ScrollBarEnabled = false,
})

script1()
script2()
script3()

end

function script1()

Window:Tag({
    Title = PopoGui.Version,
    Color = Color3.fromRGB(255, 0, 0), -- red
    Radius = 5,
})

local PingTag = Window:Tag({
    Title = "Ping 0ms",
    Color = Color3.fromRGB(0, 0, 255), -- blue
    Radius = 5,
})

local FpsTag = Window:Tag({
    Title = "0 FPS",
    Color = Color3.fromRGB(255, 255, 0), -- yellow
    Radius = 5,
})

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Timer: ចាប់ពេលចូល
local startTime = tick()

-- Create Tags
local PosTag = Window:Tag({
    Title = "Pos: 0,0,0",
    Color = Color3.fromRGB(0,255,255),
    Radius = 5,
})

local ToolTag = Window:Tag({
    Title = "Tool: None",
    Color = Color3.fromRGB(255, 165, 0),
    Radius = 5,
})

local MemTag = Window:Tag({
    Title = "Memory: 0 MB",
    Color = Color3.fromRGB(0,255,0),
    Radius = 5,
})

local TimeTag = Window:Tag({
    Title = "Time: 0s",
    Color = Color3.fromRGB(255,255,255),
    Radius = 5,
})

local PlayerCountTag = Window:Tag({
    Title = "Players: 0",
    Color = Color3.fromRGB(255, 0, 255),
    Radius = 5,
})

-- Function គណនា FPS
local fps = 0
local lastTime = tick()

game:GetService("RunService").RenderStepped:Connect(function()
    local currentTime = tick()
    fps = math.floor(1 / (currentTime - lastTime))
    lastTime = currentTime
end)

task.spawn(function()
	while true do
		-- ping (ms) របស់ LocalPlayer
		local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())

		-- update Title
		FpsTag:SetTitle(fps .. " FPS")
		PingTag:SetTitle("Ping " .. ping .. "ms")
		

		-- Player count
		local playerCount = #game.Players:GetPlayers()

	local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local pos = char.HumanoidRootPart.Position
			PosTag:SetTitle(("Pos: %d,%d,%d"):format(pos.X, pos.Y, pos.Z))
		end

		-- Tool Equipped
		local backpack = LocalPlayer.Backpack
		local charTools = {}
		if char then
			for _,tool in ipairs(char:GetChildren()) do
				if tool:IsA("Tool") then
					table.insert(charTools, tool.Name)
				end
			end
		end
		for _,tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") then
				table.insert(charTools, tool.Name)
			end
		end
		if #charTools > 0 then
			ToolTag:SetTitle("Tool: " .. table.concat(charTools,", "))
		else
			ToolTag:SetTitle("Tool: None")
		end

		-- Memory Usage (Estimate CPU/GPU)
		local memory = math.floor(Stats:GetTotalMemoryUsageMb())
		MemTag:SetTitle("Memory: " .. memory .. " MB")

		-- Timer Play game
		local playTime = math.floor(tick() - startTime)
		TimeTag:SetTitle("Time: " .. playTime .. "s")
		PlayerCountTag:SetTitle("Players: " .. playerCount)

		task.wait(1) -- update half second
	end
end)

Window:DisableTopbarButtons({
    "Minimize", 
    "Fullscreen",
})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmallTopLeftButton"
screenGui.ResetOnSpawn = false 
screenGui.Parent = playerGui

-- Container
local container = Instance.new("Frame")
container.Size = UDim2.new(0,100,0,50)
container.Position = UDim2.new(0,10,0,10)
container.BackgroundColor3 = Color3.fromRGB(50,50,50)
container.BackgroundTransparency = 1
container.Parent = screenGui

-- Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1,0,1,0)
button.Text = "Hide"
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = container
button.Visible = true

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = button

-- Rainbow text effect
spawn(function()
    local rainbowColors = {
        Color3.fromRGB(255,0,0),
        Color3.fromRGB(255,127,0),
        Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0),
        Color3.fromRGB(0,0,255),
        Color3.fromRGB(75,0,130),
        Color3.fromRGB(148,0,211)
    }
    local i = 1
    while true do
        if button and button.Parent then
            button.TextColor3 = rainbowColors[i]
            i = i + 1
            if i > #rainbowColors then i = 1 end
        end
        task.wait(0.1)
    end
end)

-- Toggle visibility when clicked

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    container.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = container.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                -- snap to nearest horizontal edge
                local viewportSize = workspace.CurrentCamera.ViewportSize
                local snapX = (container.AbsolutePosition.X + container.AbsoluteSize.X/2 > viewportSize.X/2)
                    and (viewportSize.X - container.AbsoluteSize.X - 10) or 10
                local newPos = UDim2.new(0,snapX,0,math.clamp(container.AbsolutePosition.Y,10,viewportSize.Y-container.AbsoluteSize.Y-10))
                TweenService:Create(container,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=newPos}):Play()
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local ClickTimer = false

-- Click function
button.MouseButton1Click:Connect(function()
if button.Text == "Gui Destroyed" then

else
  if ClickTimer == false then
    Window:Toggle()
    ClickTimer = true
    wait(0.7)
    ClickTimer = false
    else
    button.Text = "Too fast"
    end
 end
end)

Window:OnClose(function()
    button.Text = "Show"
end)

Window:OnOpen(function()
    button.Text = "Hide"
end)

Window:OnDestroy(function()
    button.Text = "Gui Destroyed"
end)

Window:CreateTopbarButton("ShowToggle", "mouse-pointer-click",    function()
 button.Visible = not button.Visible
 end, 990)

local isRunning = false 

function run(scriptUrl)
noti("Script Run")
loadstring(game:HttpGet(scriptUrl))()
end

local t1=Window:Tab({Title="Local Player",Icon="user",Locked=false})

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

local hum=getHumanoid()

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
t1:Toggle({Title="Infinite Jump",Default=false,Callback=function(s)infJumpEnabled=s end})

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// VARIABLES
local ESPEnabled = false
local ESPCategories = {"ESP USERNAME"}
local ESPObjects = {}

local defaultColor = Color3.fromRGB(255,0,0)
local defaultFont = Enum.Font.SourceSans

local settings -- defined outside if/else

--// SAVE/LOAD JSON FUNCTIONS
local function SaveSettings()
    local saveData = {
        ESPTYPE = settings.ESPTYPE,
        ESPCOLOR = {r = settings.ESPCOLOR.R, g = settings.ESPCOLOR.G, b = settings.ESPCOLOR.B},
        ESPFONT = settings.ESPFONT.Name -- save only the font name
    }
    SaveFile("ESPSETTINGS.json", saveData)
end

local function LoadSettings()
    if Check("ESPSETTINGS.json") then
        local dataSave = LoadFile("ESPSETTINGS.json")
        settings = {
            ESPTYPE = dataSave.ESPTYPE or ESPCategories,
            ESPCOLOR = dataSave.ESPCOLOR and Color3.new(dataSave.ESPCOLOR.r, dataSave.ESPCOLOR.g, dataSave.ESPCOLOR.b) or defaultColor,
            ESPFONT = dataSave.ESPFONT and Enum.Font[dataSave.ESPFONT] or defaultFont
        }
    else
        settings = {
            ESPTYPE = ESPCategories,
            ESPCOLOR = defaultColor,
            ESPFONT = defaultFont
        }
        SaveSettings()
    end
end

-- load initial settings
LoadSettings()

local selectedFont = settings.ESPFONT
local ESPColor = settings.ESPCOLOR

--// UI SECTION
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
                if obj and obj.Parent then obj:Destroy() end
            end
            ESPObjects = {}
        end
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
    Values={"ESP USERNAME","ESP DISPLAY","ESP HP"},
    Value=settings.ESPTYPE,
    Multi=true,
    Callback=function(option)
        ESPCategories = option
        settings.ESPTYPE = option
        SaveSettings()
    end
})

-- Get all Roblox fonts dynamically
local fonts = {}
for _, font in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(fonts, font.Name)
end

-- Font Dropdown
t1:Dropdown({
    Title="ESP Font",
    Values=fonts,
    Value=selectedFont.Name, -- current font name
    Multi=false,
    Callback=function(v)
        if Enum.Font[v] then
            selectedFont = Enum.Font[v]
            settings.ESPFONT = selectedFont
            SaveSettings()
        end
    end
})

--// FUNCTION CREATE ESP
local function createESP(plr)
    if plr == LocalPlayer then return end
    if ESPObjects[plr] then ESPObjects[plr]:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.Name = "ESP_"..plr.Name

    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = ESPColor
    text.Font = selectedFont
    text.TextScaled = true

    ESPObjects[plr] = billboard

    local function update()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            billboard.Adornee = char:FindFirstChild("HumanoidRootPart")
            local txts = {}
            if table.find(ESPCategories,"ESP USERNAME") then table.insert(txts, plr.Name) end
            if table.find(ESPCategories,"ESP DISPLAY") then table.insert(txts, plr.DisplayName) end
            if table.find(ESPCategories,"ESP HP") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then table.insert(txts, math.floor(hum.Health).." HP") end
            end
            text.Text = table.concat(txts," | ")
            text.TextColor3 = ESPColor
            text.Font = selectedFont
        end
    end

    RunService.Heartbeat:Connect(function()
        if ESPEnabled and ESPObjects[plr] then
            update()
            billboard.Parent = game:GetService("CoreGui")
        elseif ESPObjects[plr] then
            billboard.Parent = nil
        end
    end)
end

--// HOOK EVENTS
for _, plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then ESPObjects[plr]:Destroy() ESPObjects[plr] = nil end
end)

local Section = t1:Section({ 
    Title = "Game | Font",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

-- Get all font names
--// Prepare font list
local fontNames = {}
for _, font in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(fontNames, font.Name)
end

--// Check and create JSON file if not exists
if not Check("FontSettings.json") then
    local defaultFontName = fontNames[1] -- first font
    local FontData = {
        FontGV = defaultFontName
    }
    SaveFile("FontSettings.json", FontData)
end

--// Load saved font
local DATAFONT = LoadFile("FontSettings.json")
local selectedFont = Enum.Font[DATAFONT.FontGV] or Enum.Font.SourceSans -- default safe

--// Function to apply font to all GUI elements
local function applyFont(fontEnum)
    local player = game.Players.LocalPlayer
    -- PlayerGui
    for _, guiObj in ipairs(player:WaitForChild("PlayerGui"):GetDescendants()) do
        if guiObj:IsA("TextLabel") or guiObj:IsA("TextButton") or guiObj:IsA("TextBox") then
            guiObj.Font = fontEnum
        end
    end
    -- Workspace (if you have Text objects in workspace)
    for _, guiObj in ipairs(workspace:GetDescendants()) do
        if guiObj:IsA("TextLabel") or guiObj:IsA("TextButton") or guiObj:IsA("TextBox") then
            guiObj.Font = fontEnum
        end
    end
end

--// Apply saved font immediately
applyFont(selectedFont)

--// Create Dropdown UI
local Dropdown = t1:Dropdown({
    Title = "Select Font",
    Values = fontNames,
    Value = DATAFONT.FontGV, -- string name
    Multi = false,
    Callback = function(option)
        local fontEnum = Enum.Font[option] or Enum.Font.SourceSans
        selectedFont = fontEnum
        applyFont(selectedFont)
        -- save new selection
        local FontData = {FontGV = option}
        SaveFile("FontSettings.json", FontData)
    end
})

Window:SelectTab(1)

end

function script2()

local t2=Window:Tab({Title="Script",Icon="file-code",Locked=false})

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
    Title = "Noclip Camera",
    Locked = false,
    Callback = function()
        run("https://mokren.pages.dev/api/run?uid=sOY0SE8tDhFVDPpumYBnxrekkeyaeun")
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

ScriptAdd("Fly {Vehicle}", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui")
ScriptAdd("Fly Car", "https://safetycode-free.vercel.app/api/run?uid=sOVkfQrqmoqsd576b7x")
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
Addgame("Volleyball Legends (Zeckhubv1)", {
    function(sec)
        AddScriptGame(sec, "Volleyball Legends", "https://raw.githubusercontent.com/scriptshubzeck/Zeckhubv1/refs/heads/main/zeckhub")
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

local t5 = Window:Tab({Title="Player", Icon="user-cog", Locked=false})

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

end

function script3()

local t6 = Window:Tab({Title="Tools / Hub", Icon="pencil-ruler", Locked=false})

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
local UserInputService = game:GetService("UserInputService")

local afkBase, timerPart, timerLabel
local afkTime = 0
local timerRunning = false
local timerTask
local savedCFrame = nil
local antiAfkTask = nil

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
end

-- Destroy AFK Base + Timer
local function destroyAFKBase()
    if afkBase then afkBase:Destroy() end
    if timerPart then timerPart:Destroy() end
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

-- Anti-AFK Jump every 1 minute
local function startAntiAfkJump()
    antiAfkTask = task.spawn(function()
        while true do
            task.wait(60) -- wait 1 minute
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
            -- Save current position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
            createAFKBase()
            -- Teleport to AFK Base
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = afkBase.CFrame + Vector3.new(0,5,0)
            end
            startTimer()
            startAntiAfkJump()
        else
            -- Teleport back to saved position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and savedCFrame then
                LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
            end
            stopTimer()
            destroyAFKBase()
            stopAntiAfkJump()
        end
    end
})

local safe = Window:Tab({
    Title = "Safety and protection",
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

local Settings = {
	local s1 = Window:Tab({Title = "Settings", Icon = "settings",  Locked = false })
}

Settings.s1:Paragraph({
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

local Keybind = Settings.s1:Keybind({
    Title = "Toggle For PC",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

Settings.s1:Paragraph({
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
   Theme = "Crimson"
}

SaveFile("Theme.json", DataKI)

WindUI:SetTheme(DataKI.Theme)
end

--== Create Dropdown UI ==--
local themeDropdown = Settings.s1:Dropdown({
    Title = "Select Theme",
    Values = themes,
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = DataKI.Theme or "Crimson",
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
local transparencySlider = Settings.s1:Slider({
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

WindUI:OnThemeChange(function(theme)
    canchangetheme = false
    ThemeToggle:Set(theme == "Dark")
    canchangetheme = true
end)

end


WindUI:Popup({
    Title = "PopoHub ",
    Icon = "shield-alert",
    Content = "For weak phones, please do not run because this code requires strong phone power.",
    Buttons = {
        {
            Title = "Cancel",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Continue",
            Icon = "check",
            Callback = function()
            
             PopoHub()
             end,
            Variant = "Primary",
        }
    }
})
end

Mobile()