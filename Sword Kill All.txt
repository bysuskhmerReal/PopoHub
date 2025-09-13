--// Services //--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

--// Settings //--
local player = Players.LocalPlayer
local range = 5000
local settings = {
    autoUpdate = true,
    showDistance = true,
    showHealth = true,
    soundEnabled = true,
    transparency = 0,
    autoTargetNewPlayers = true
}

--// Spectate System Variables //--
local spectateMode = false
local spectateTarget = nil
local spectateConnection = nil
local originalCFrame = nil
local spectateIndex = 1
local spectatePlayers = {}
local lastActivatedTool = "None"

--// Sound Effects //--
local sounds = {
    click = Instance.new("Sound"),
    activate = Instance.new("Sound"),
    toggle = Instance.new("Sound")
}

sounds.click.SoundId = "rbxasset://sounds/electronicpingshort.wav"
sounds.click.Volume = 0.5
sounds.activate.SoundId = "rbxasset://sounds/impact_water.mp3"
sounds.activate.Volume = 0.3
sounds.toggle.SoundId = "rbxasset://sounds/button.wav"
sounds.toggle.Volume = 0.4

for _, sound in pairs(sounds) do
    sound.Parent = SoundService
end

--// GUI Setup //--
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "EnhancedPlayerTargetingUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- NEW: Toggle GUI Button (outside main frame)
local ToggleGUIButton = Instance.new("TextButton", ScreenGui)
ToggleGUIButton.Size = UDim2.new(0, 80, 0, 30)
ToggleGUIButton.Position = UDim2.new(0, 10, 0, 10) -- Top-left corner
ToggleGUIButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleGUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGUIButton.Font = Enum.Font.SourceSansBold
ToggleGUIButton.TextSize = 14
ToggleGUIButton.Text = "Toggle GUI"

local ToggleGUICorner = Instance.new("UICorner", ToggleGUIButton)
ToggleGUICorner.CornerRadius = UDim.new(0, 4)

--// Main Frame - Mobile Size 240x280 //--
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 280)
Frame.Position = UDim2.new(0, 10, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true -- Start visible

local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 8)

local FrameStroke = Instance.new("UIStroke", Frame)
FrameStroke.Color = Color3.fromRGB(60, 60, 60)
FrameStroke.Thickness = 1

--// Header //--
local Header = Instance.new("Frame", Frame)
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -65, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎯 Target System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

--// Control Buttons - Larger Size //--
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 22)
CloseBtn.Position = UDim2.new(1, -32, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 12

local CloseBtnCorner = Instance.new("UICorner", CloseBtn)
CloseBtnCorner.CornerRadius = UDim.new(0, 4)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 28, 0, 22)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(108, 117, 125)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 14

local MinBtnCorner = Instance.new("UICorner", MinBtn)
MinBtnCorner.CornerRadius = UDim.new(0, 4)

local minimized = false

--// Stats Panel //--
local StatsFrame = Instance.new("Frame", Frame)
StatsFrame.Size = UDim2.new(1, -8, 0, 38)
StatsFrame.Position = UDim2.new(0, 4, 0, 36)
StatsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local StatsCorner = Instance.new("UICorner", StatsFrame)
StatsCorner.CornerRadius = UDim.new(0, 6)

local OnlineLabel = Instance.new("TextLabel", StatsFrame)
OnlineLabel.Size = UDim2.new(0.33, -2, 0.5, 0)
OnlineLabel.Position = UDim2.new(0, 4, 0, 2)
OnlineLabel.BackgroundTransparency = 1
OnlineLabel.Text = "Online: 0"
OnlineLabel.TextColor3 = Color3.fromRGB(40, 167, 69)
OnlineLabel.Font = Enum.Font.SourceSans
OnlineLabel.TextSize = 9
OnlineLabel.TextXAlignment = Enum.TextXAlignment.Left

local TargetedLabel = Instance.new("TextLabel", StatsFrame)
TargetedLabel.Size = UDim2.new(0.33, -2, 0.5, 0)
TargetedLabel.Position = UDim2.new(0.33, 0, 0, 2)
TargetedLabel.BackgroundTransparency = 1
TargetedLabel.Text = "Targeted: 0"
TargetedLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
TargetedLabel.Font = Enum.Font.SourceSans
TargetedLabel.TextSize = 9
TargetedLabel.TextXAlignment = Enum.TextXAlignment.Left

local RangeLabel = Instance.new("TextLabel", StatsFrame)
RangeLabel.Size = UDim2.new(0.34, -2, 0.5, 0)
RangeLabel.Position = UDim2.new(0.66, 0, 0, 2)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "Range: ∞"
RangeLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
RangeLabel.Font = Enum.Font.SourceSans
RangeLabel.TextSize = 9
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpectateLabel = Instance.new("TextLabel", StatsFrame)
SpectateLabel.Size = UDim2.new(1, -8, 0.5, 0)
SpectateLabel.Position = UDim2.new(0, 4, 0.5, 0)
SpectateLabel.BackgroundTransparency = 1
SpectateLabel.Text = "Spectate: OFF | Last Tool: None"
SpectateLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
SpectateLabel.Font = Enum.Font.SourceSans
SpectateLabel.TextSize = 8
SpectateLabel.TextXAlignment = Enum.TextXAlignment.Left

--// Search Bar //--
local SearchFrame = Instance.new("Frame", Frame)
SearchFrame.Size = UDim2.new(1, -8, 0, 24)
SearchFrame.Position = UDim2.new(0, 4, 0, 78)
SearchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local SearchCorner = Instance.new("UICorner", SearchFrame)
SearchCorner.CornerRadius = UDim.new(0, 6)

local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -8, 1, -4)
SearchBox.Position = UDim2.new(0, 4, 0, 2)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "🔍 Search..."
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 10
SearchBox.TextXAlignment = Enum.TextXAlignment.Left

--// Player List //--
local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Position = UDim2.new(0, 4, 0, 106)
Scroll.Size = UDim2.new(1, -8, 1, -150)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

local ScrollCorner = Instance.new("UICorner", Scroll)
ScrollCorner.CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

local UIPadding = Instance.new("UIPadding", Scroll)
UIPadding.PaddingTop = UDim.new(0, 3)
UIPadding.PaddingBottom = UDim.new(0, 3)
UIPadding.PaddingLeft = UDim.new(0, 3)
UIPadding.PaddingRight = UDim.new(0, 3)

--// Control Buttons - Larger Size //--
local ButtonFrame = Instance.new("Frame", Frame)
ButtonFrame.Size = UDim2.new(1, -8, 0, 38)
ButtonFrame.Position = UDim2.new(0, 4, 1, -42)
ButtonFrame.BackgroundTransparency = 1

local ToggleAllBtn = Instance.new("TextButton", ButtonFrame)
ToggleAllBtn.Size = UDim2.new(0.48, 0, 0, 18)
ToggleAllBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleAllBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
ToggleAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAllBtn.Font = Enum.Font.SourceSansBold
ToggleAllBtn.TextSize = 9
ToggleAllBtn.Text = "✅ All"

local ToggleCorner = Instance.new("UICorner", ToggleAllBtn)
ToggleCorner.CornerRadius = UDim.new(0, 4)

local ClearAllBtn = Instance.new("TextButton", ButtonFrame)
ClearAllBtn.Size = UDim2.new(0.48, 0, 0, 18)
ClearAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
ClearAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearAllBtn.Font = Enum.Font.SourceSansBold
ClearAllBtn.TextSize = 9
ClearAllBtn.Text = "❌ Clear"

local ClearCorner = Instance.new("UICorner", ClearAllBtn)
ClearCorner.CornerRadius = UDim.new(0, 4)

local SettingsBtn = Instance.new("TextButton", ButtonFrame)
SettingsBtn.Size = UDim2.new(1, 0, 0, 16)
SettingsBtn.Position = UDim2.new(0, 0, 0, 21)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(108, 117, 125)
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.Font = Enum.Font.SourceSans
SettingsBtn.TextSize = 8
SettingsBtn.Text = "⚙️ Auto-Target: ON"

local SettingsCorner = Instance.new("UICorner", SettingsBtn)
SettingsCorner.CornerRadius = UDim.new(0, 4)

--// Spectate Controls Frame - Larger Buttons //--
local SpectateFrame = Instance.new("Frame", ScreenGui)
SpectateFrame.Size = UDim2.new(0, 260, 0, 75)
SpectateFrame.Position = UDim2.new(0.5, -130, 0, 200)
SpectateFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpectateFrame.Visible = false

local SpectateCorner = Instance.new("UICorner", SpectateFrame)
SpectateCorner.CornerRadius = UDim.new(0, 8)

local SpectateStroke = Instance.new("UIStroke", SpectateFrame)
SpectateStroke.Color = Color3.fromRGB(60, 60, 60)
SpectateStroke.Thickness = 1

-- Close Button - Top Right - Larger Size //--
local SpectateCloseBtn = Instance.new("TextButton", SpectateFrame)
SpectateCloseBtn.Size = UDim2.new(0, 26, 0, 22)
SpectateCloseBtn.Position = UDim2.new(1, -30, 0, 4)
SpectateCloseBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
SpectateCloseBtn.Text = "×"
SpectateCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpectateCloseBtn.Font = Enum.Font.SourceSansBold
SpectateCloseBtn.TextSize = 14

local SpectateCloseCorner = Instance.new("UICorner", SpectateCloseBtn)
SpectateCloseCorner.CornerRadius = UDim.new(0, 4)

-- Spectate Player Info
local SpectateIcon = Instance.new("ImageLabel", SpectateFrame)
SpectateIcon.Size = UDim2.new(0, 35, 0, 35)
SpectateIcon.Position = UDim2.new(0, 6, 0, 5)
SpectateIcon.BackgroundTransparency = 1
SpectateIcon.Image = ""

local SpectateIconCorner = Instance.new("UICorner", SpectateIcon)
SpectateIconCorner.CornerRadius = UDim.new(0, 17)

local SpectatePlayerName = Instance.new("TextLabel", SpectateFrame)
SpectatePlayerName.Size = UDim2.new(1, -120, 0, 12)
SpectatePlayerName.Position = UDim2.new(0, 45, 0, 5)
SpectatePlayerName.BackgroundTransparency = 1
SpectatePlayerName.Text = "Player Name"
SpectatePlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
SpectatePlayerName.Font = Enum.Font.SourceSansBold
SpectatePlayerName.TextSize = 10
SpectatePlayerName.TextXAlignment = Enum.TextXAlignment.Left

local SpectatePlayerHP = Instance.new("TextLabel", SpectateFrame)
SpectatePlayerHP.Size = UDim2.new(1, -120, 0, 10)
SpectatePlayerHP.Position = UDim2.new(0, 45, 0, 16)
SpectatePlayerHP.BackgroundTransparency = 1
SpectatePlayerHP.Text = "HP: 100"
SpectatePlayerHP.TextColor3 = Color3.fromRGB(100, 255, 100)
SpectatePlayerHP.Font = Enum.Font.SourceSans
SpectatePlayerHP.TextSize = 8
SpectatePlayerHP.TextXAlignment = Enum.TextXAlignment.Left

local SpectatePlayerTool = Instance.new("TextLabel", SpectateFrame)
SpectatePlayerTool.Size = UDim2.new(1, -120, 0, 10)
SpectatePlayerTool.Position = UDim2.new(0, 45, 0, 25)
SpectatePlayerTool.BackgroundTransparency = 1
SpectatePlayerTool.Text = "Tool: None"
SpectatePlayerTool.TextColor3 = Color3.fromRGB(150, 150, 255)
SpectatePlayerTool.Font = Enum.Font.SourceSans
SpectatePlayerTool.TextSize = 7
SpectatePlayerTool.TextXAlignment = Enum.TextXAlignment.Left

-- Navigation Buttons - Larger Size //--
local PrevBtn = Instance.new("TextButton", SpectateFrame)
PrevBtn.Size = UDim2.new(0, 35, 0, 26)
PrevBtn.Position = UDim2.new(1, -100, 0, 43)
PrevBtn.BackgroundColor3 = Color3.fromRGB(108, 117, 125)
PrevBtn.Text = "←"
PrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrevBtn.Font = Enum.Font.SourceSansBold
PrevBtn.TextSize = 16

local PrevCorner = Instance.new("UICorner", PrevBtn)
PrevCorner.CornerRadius = UDim.new(0, 4)

local NextBtn = Instance.new("TextButton", SpectateFrame)
NextBtn.Size = UDim2.new(0, 35, 0, 26)
NextBtn.Position = UDim2.new(1, -35, 0, 43)
NextBtn.BackgroundColor3 = Color3.fromRGB(108, 117, 125)
NextBtn.Text = "→"
NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBtn.Font = Enum.Font.SourceSansBold
NextBtn.TextSize = 16

local NextCorner = Instance.new("UICorner", NextBtn)
NextCorner.CornerRadius = UDim.new(0, 4)

--// Data Storage //--
local targetList = {}
local buttonRefs = {}
local playerData = {}
local searchFilter = ""

--// Utility Functions //--
local function playSound(soundName)
    if settings.soundEnabled and sounds[soundName] then
        sounds[soundName]:Play()
    end
end

local function formatDistance(distance)
    if distance == math.huge then return "∞" end
    if distance > 1000 then
        return string.format("%.1fkm", distance / 1000)
    else
        return string.format("%.0fm", distance)
    end
end

local function getPlayerDistance(targetPlayer)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    return (player.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
end

local function getPlayerHealth(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        return math.floor(targetPlayer.Character.Humanoid.Health)
    end
    return 0
end

local function getPlayerTool(targetPlayer)
    if targetPlayer.Character then
        local tool = targetPlayer.Character:FindFirstChildOfClass("Tool")
        return tool and tool.Name or "None"
    end
    return "None"
end

local function updateStats()
    local onlineCount = #Players:GetPlayers() - 1
    local targetedCount = 0
    
    for _, isTargeted in pairs(targetList) do
        if isTargeted then targetedCount = targetedCount + 1 end
    end
    
    OnlineLabel.Text = "Online: " .. onlineCount
    TargetedLabel.Text = "Targeted: " .. targetedCount
    RangeLabel.Text = "Range: " .. formatDistance(range)
    
    local spectateText = "Spectate: " .. (spectateMode and "ON" or "OFF") .. " | Last Tool: " .. lastActivatedTool
    SpectateLabel.Text = spectateText
    SpectateLabel.TextColor3 = spectateMode and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
end

-- Spectate System Functions
local function updateSpectateInfo()
    if spectateTarget then
        SpectateIcon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. spectateTarget.UserId .. "&width=48&height=48&format=png"
        SpectatePlayerName.Text = spectateTarget.DisplayName
        
        local health = getPlayerHealth(spectateTarget)
        local tool = getPlayerTool(spectateTarget)
        
        SpectatePlayerHP.Text = "HP: " .. health
        SpectatePlayerTool.Text = "Tool: " .. tool
        
        -- Color coding for health
        if health <= 0 then
            SpectatePlayerHP.TextColor3 = Color3.fromRGB(220, 53, 69)
        elseif health < 50 then
            SpectatePlayerHP.TextColor3 = Color3.fromRGB(255, 193, 7)
        else
            SpectatePlayerHP.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
end

local function startSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    spectateMode = true
    spectateTarget = targetPlayer
    
    -- Store original camera position
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        originalCFrame = player.Character.HumanoidRootPart.CFrame
    end
    
    -- Set camera to target player
    local camera = Workspace.CurrentCamera
    camera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
    camera.CameraType = Enum.CameraType.Custom
    
    SpectateFrame.Visible = true
    updateSpectateInfo()
    updateStats()
end

local function stopSpectate()
    spectateMode = false
    spectateTarget = nil
    
    -- Restore camera to local player
    local camera = Workspace.CurrentCamera
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = player.Character.Humanoid
    end
    camera.CameraType = Enum.CameraType.Custom
    
    SpectateFrame.Visible = false
    updateStats()
end

local function updateSpectateList()
    spectatePlayers = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            table.insert(spectatePlayers, plr)
        end
    end
end

local function spectateNext()
    updateSpectateList()
    if #spectatePlayers == 0 then return end
    
    spectateIndex = spectateIndex + 1
    if spectateIndex > #spectatePlayers then
        spectateIndex = 1
    end
    
    startSpectate(spectatePlayers[spectateIndex])
end

local function spectatePrevious()
    updateSpectateList()
    if #spectatePlayers == 0 then return end
    
    spectateIndex = spectateIndex - 1
    if spectateIndex < 1 then
        spectateIndex = #spectatePlayers
    end
    
    startSpectate(spectatePlayers[spectateIndex])
end

--// Player Button Creation - Larger Buttons //--
local function createPlayerButton(plr)
    local Row = Instance.new("Frame", Scroll)
    Row.Size = UDim2.new(1, -6, 0, 48)
    Row.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Row.Name = plr.Name .. "_Row"
    
    local RowCorner = Instance.new("UICorner", Row)
    RowCorner.CornerRadius = UDim.new(0, 6)
    
    local RowStroke = Instance.new("UIStroke", Row)
    RowStroke.Color = Color3.fromRGB(60, 60, 60)
    RowStroke.Thickness = 1
    
    -- Add margin with UIPadding
    local RowPadding = Instance.new("UIPadding", Row)
    RowPadding.PaddingTop = UDim.new(0, 2)
    RowPadding.PaddingBottom = UDim.new(0, 2)
    RowPadding.PaddingLeft = UDim.new(0, 2)
    RowPadding.PaddingRight = UDim.new(0, 2)
    
    local Icon = Instance.new("ImageLabel", Row)
    Icon.Size = UDim2.new(0, 32, 0, 32)
    Icon.Position = UDim2.new(0, 3, 0, 3)
    Icon.BackgroundTransparency = 1
    Icon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=48&height=48&format=png"
    
    local IconCorner = Instance.new("UICorner", Icon)
    IconCorner.CornerRadius = UDim.new(0, 16)
    
    local NameLabel = Instance.new("TextLabel", Row)
    NameLabel.Position = UDim2.new(0, 40, 0, 2)
    NameLabel.Size = UDim2.new(1, -95, 0, 11)
    NameLabel.Text = plr.DisplayName
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 9
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    local UsernameLabel = Instance.new("TextLabel", Row)
    UsernameLabel.Position = UDim2.new(0, 40, 0, 12)
    UsernameLabel.Size = UDim2.new(1, -95, 0, 9)
    UsernameLabel.Text = "@" .. plr.Name
    UsernameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Font = Enum.Font.SourceSans
    UsernameLabel.TextSize = 7
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local StatsLabel = Instance.new("TextLabel", Row)
    StatsLabel.Position = UDim2.new(0, 40, 0, 20)
    StatsLabel.Size = UDim2.new(1, -95, 0, 9)
    StatsLabel.Text = "HP: 100 | 0m"
    StatsLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.Font = Enum.Font.SourceSans
    StatsLabel.TextSize = 7
    StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToolLabel = Instance.new("TextLabel", Row)
    ToolLabel.Position = UDim2.new(0, 40, 0, 29)
    ToolLabel.Size = UDim2.new(1, -95, 0, 8)
    ToolLabel.Text = "Tool: None"
    ToolLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    ToolLabel.BackgroundTransparency = 1
    ToolLabel.Font = Enum.Font.SourceSans
    ToolLabel.TextSize = 6
    ToolLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Larger Target Button
    local TargetBtn = Instance.new("TextButton", Row)
    TargetBtn.Size = UDim2.new(0, 28, 0, 20)
    TargetBtn.Position = UDim2.new(1, -55, 0, 3)
    TargetBtn.BackgroundColor3 = targetList[plr.Name] and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(60, 60, 60)
    TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TargetBtn.Font = Enum.Font.SourceSansBold
    TargetBtn.TextSize = 10
    TargetBtn.Text = targetList[plr.Name] and "✅" or "❌"
    
    local BtnCorner = Instance.new("UICorner", TargetBtn)
    BtnCorner.CornerRadius = UDim.new(0, 4)
    
    -- Larger Spectate Button
    local SpectateBtn = Instance.new("TextButton", Row)
    SpectateBtn.Size = UDim2.new(0, 28, 0, 20)
    SpectateBtn.Position = UDim2.new(1, -25, 0, 3)
    SpectateBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
    SpectateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpectateBtn.Font = Enum.Font.SourceSansBold
    SpectateBtn.TextSize = 12
    SpectateBtn.Text = "👁️"
    
    local SpectateCorner = Instance.new("UICorner", SpectateBtn)
    SpectateCorner.CornerRadius = UDim.new(0, 4)
    
    -- Button Events
    TargetBtn.MouseButton1Click:Connect(function()
        playSound("click")
        targetList[plr.Name] = not targetList[plr.Name]
        TargetBtn.Text = targetList[plr.Name] and "✅" or "❌"
        TargetBtn.BackgroundColor3 = targetList[plr.Name] and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(60, 60, 60)
        
        local tween = TweenService:Create(TargetBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 25, 0, 18)})
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(TargetBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 28, 0, 20)}):Play()
        end)
        
        updateStats()
    end)
    
    SpectateBtn.MouseButton1Click:Connect(function()
        playSound("click")
        if spectateMode and spectateTarget == plr then
            stopSpectate()
        else
            updateSpectateList()
            for i, p in ipairs(spectatePlayers) do
                if p == plr then
                    spectateIndex = i
                    break
                end
            end
            startSpectate(plr)
        end
    end)
    
    TargetBtn.MouseEnter:Connect(function()
        TweenService:Create(TargetBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetList[plr.Name] and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(80, 80, 80)}):Play()
    end)
    
    TargetBtn.MouseLeave:Connect(function()
        TweenService:Create(TargetBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetList[plr.Name] and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    SpectateBtn.MouseEnter:Connect(function()
        TweenService:Create(SpectateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 169, 255)}):Play()
    end)
    
    SpectateBtn.MouseLeave:Connect(function()
        TweenService:Create(SpectateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 149, 237)}):Play()
    end)
    
    buttonRefs[plr.Name] = {
        button = TargetBtn,
        spectateBtn = SpectateBtn,
        row = Row,
        statsLabel = StatsLabel,
        nameLabel = NameLabel,
        toolLabel = ToolLabel
    }
    
    playerData[plr.Name] = {
        health = getPlayerHealth(plr),
        distance = getPlayerDistance(plr),
        lastSeen = tick()
    }
    
    return Row
end

--// Update Player List //--
local function updatePlayerButtons()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("_Row") then
            child:Destroy()
        end
    end
    buttonRefs = {}
    
    local visiblePlayers = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local matchesSearch = searchFilter == "" or 
                string.lower(plr.Name):find(string.lower(searchFilter)) or 
                string.lower(plr.DisplayName):find(string.lower(searchFilter))
            
            if matchesSearch then
                table.insert(visiblePlayers, plr)
                
                -- Initialize target state if not already set
                if targetList[plr.Name] == nil then
                    targetList[plr.Name] = settings.autoTargetNewPlayers
                end
            end
        end
    end
    
    table.sort(visiblePlayers, function(a, b)
        return getPlayerDistance(a) < getPlayerDistance(b)
    end)
    
    for i, plr in ipairs(visiblePlayers) do
        local row = createPlayerButton(plr)
        row.LayoutOrder = i
    end
    
    wait(0.1)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 8)
    updateStats()
end

--// Real-time Updates //--
local function updatePlayerStats()
    for playerName, refs in pairs(buttonRefs) do
        local plr = Players:FindFirstChild(playerName)
        if plr and plr.Character then
            local health = getPlayerHealth(plr)
            local distance = getPlayerDistance(plr)
            local tool = getPlayerTool(plr)
            
            refs.statsLabel.Text = string.format("HP: %d | %s", health, formatDistance(distance))
            refs.toolLabel.Text = "Tool: " .. tool
            
            if health <= 0 then
                refs.statsLabel.TextColor3 = Color3.fromRGB(220, 53, 69)
                refs.nameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            elseif health < 50 then
                refs.statsLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
                refs.nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                refs.statsLabel.TextColor3 = Color3.fromRGB(40, 167, 69)
                refs.nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            playerData[playerName] = {
                health = health,
                distance = distance,
                lastSeen = tick()
            }
        end
    end
    
    -- Update spectate info if spectating
    if spectateMode then
        updateSpectateInfo()
    end
end

--// Event Connections //--
CloseBtn.MouseButton1Click:Connect(function()
    playSound("click")
    if spectateMode then
        stopSpectate()
    end
    Frame.Visible = false -- Hide the main frame instead of destroying ScreenGui
    
    -- Reset all targets when GUI is closed
    for name in pairs(targetList) do
        targetList[name] = false
    end
    updatePlayerButtons() -- Refresh UI to show all untargeted
    updateStats()
end)

MinBtn.MouseButton1Click:Connect(function()
    playSound("click")
    minimized = not minimized
    
    local targetSize = minimized and UDim2.new(0, 240, 0, 32) or UDim2.new(0, 240, 0, 280)
    TweenService:Create(Frame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    
    StatsFrame.Visible = not minimized
    SearchFrame.Visible = not minimized
    Scroll.Visible = not minimized
    ButtonFrame.Visible = not minimized
end)

ToggleAllBtn.MouseButton1Click:Connect(function()
    playSound("toggle")
    -- Always set all players to targeted
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            targetList[plr.Name] = true -- Always target
            if buttonRefs[plr.Name] then
                buttonRefs[plr.Name].button.Text = "✅" -- Set to targeted icon
                buttonRefs[plr.Name].button.BackgroundColor3 = Color3.fromRGB(40, 167, 69) -- Set to targeted color
            end
        end
    end
    
    ToggleAllBtn.Text = "✅ Target All" -- Keep text consistent
    updateStats()
end)

ClearAllBtn.MouseButton1Click:Connect(function()
    playSound("toggle")
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            targetList[plr.Name] = false
            if buttonRefs[plr.Name] then
                buttonRefs[plr.Name].button.Text = "❌"
                buttonRefs[plr.Name].button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end
    end
    updateStats()
end)

SettingsBtn.MouseButton1Click:Connect(function()
    playSound("click")
    settings.autoTargetNewPlayers = not settings.autoTargetNewPlayers
    SettingsBtn.Text = settings.autoTargetNewPlayers and "⚙️ Auto-Target: ON" or "⚙️ Auto-Target: OFF"
    SettingsBtn.BackgroundColor3 = settings.autoTargetNewPlayers and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
end)

SearchBox.Changed:Connect(function(property)
    if property == "Text" then
        searchFilter = SearchBox.Text
        updatePlayerButtons()
    end
end)

-- Spectate Controls Events
PrevBtn.MouseButton1Click:Connect(function()
    playSound("click")
    spectatePrevious()
end)

NextBtn.MouseButton1Click:Connect(function()
    playSound("click")
    spectateNext()
end)

SpectateCloseBtn.MouseButton1Click:Connect(function()
    playSound("click")
    stopSpectate()
end)

-- NEW: Toggle GUI Button Event
ToggleGUIButton.MouseButton1Click:Connect(function()
    playSound("click")
    Frame.Visible = not Frame.Visible
    if Frame.Visible then
        -- Reset targets when GUI is shown again
        for name in pairs(targetList) do
            targetList[name] = false
        end
        updatePlayerButtons() -- Re-render player list with reset state
        updateStats()
    end
end)

Players.PlayerAdded:Connect(function(newPlayer)
    wait(2)
    
    if settings.autoTargetNewPlayers then
        local notification = Instance.new("TextLabel", ScreenGui)
        notification.Size = UDim2.new(0, 180, 0, 22)
        notification.Position = UDim2.new(0.5, -90, 0, 70)
        notification.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.Text = "✅ " .. newPlayer.DisplayName .. " targeted!"
        notification.Font = Enum.Font.SourceSansBold
        notification.TextSize = 9
        notification.TextXAlignment = Enum.TextXAlignment.Center
        
        local notifCorner = Instance.new("UICorner", notification)
        notifCorner.CornerRadius = UDim.new(0, 6)
        
        notification.Position = UDim2.new(0.5, -90, 0, 50)
        TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -90, 0, 70)}):Play()
        
        wait(3)
        TweenService:Create(notification, TweenInfo.new(0.5), {
            Position = UDim2.new(0.5, -90, 0, 50),
            BackgroundTransparency = 1,
            TextTransparency = 1
        }):Play()
        
        wait(0.5)
        notification:Destroy()
    end
    
    updatePlayerButtons()
end)

Players.PlayerRemoving:Connect(function(plr)
    targetList[plr.Name] = nil
    playerData[plr.Name] = nil
    buttonRefs[plr.Name] = nil
    
    if spectateTarget == plr then
        stopSpectate()
    end
    
    updatePlayerButtons()
end)

--// Tool Activation System //--
local function onToolActivated()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("Handle") then 
        return 
    end
    
    -- Store the activated tool name
    lastActivatedTool = tool.Name
    
    playSound("activate")
    local activatedCount = 0
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetList[targetPlayer.Name] then
            local v = targetPlayer.Character
            if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                local distance = getPlayerDistance(targetPlayer)
                if distance <= range then
                    for _, part in pairs(v:GetChildren()) do
                        if part:IsA("BasePart") then
                            firetouchinterest(tool.Handle, part, 0)
                            firetouchinterest(tool.Handle, part, 1)
                        end
                    end
                    activatedCount = activatedCount + 1
                end
            end
        end
    end
    
    updateStats()
end

--// Character Management //--
local function onCharacterAdded(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Activated:Connect(onToolActivated)
        end
    end)
    
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") then
            child.Activated:Connect(onToolActivated)
        end
    end
    
    updateStats()
end

if player.Character then
    onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)

--// Main Update Loop //--
if settings.autoUpdate then
    spawn(function()
        while ScreenGui.Parent do
            updatePlayerStats()
            updateStats()
            wait(0.3)
        end
    end)
end

--// Initialize //--
updatePlayerButtons()
updateStats()

