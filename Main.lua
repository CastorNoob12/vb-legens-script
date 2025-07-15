-- 🏐 Volleyball Legends GUI Script by ChatGPT
-- 🔓 No Key, Safe GUI, Custom Jump Power

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- AntiAFK
for _, v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end

-- UI LIBRARY
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeButton(text, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

-- Toggle Features
local toggles = {
    AutoHit = false,
    AutoJoin = false,
    Rollback = false,
    NoCooldowns = false,
    ESP = false,
    Hitbox = false
}

-- Hitbox Expander
RunService.RenderStepped:Connect(function()
    if toggles.Hitbox then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(8, 8, 8)
                hrp.Transparency = 0.6
            end
        end
    end
end)

-- AutoHit
task.spawn(function()
    while true do
        if toggles.AutoHit then
            ReplicatedStorage.Events.HitBall:FireServer()
        end
        task.wait(0.3)
    end
end)

-- AutoJoin
task.spawn(function()
    while true do
        if toggles.AutoJoin then
            ReplicatedStorage.Events.JoinMatch:FireServer()
        end
        task.wait(4)
    end
end)

-- Rollback
task.spawn(function()
    while true do
        if toggles.Rollback then
            ReplicatedStorage.Events.Spin:FireServer()
        end
        task.wait(1.5)
    end
end)

-- NoCooldowns
task.spawn(function()
    while true do
        if toggles.NoCooldowns then
            for _, ab in pairs({"Dive", "Spike", "Jump"}) do
                local abEvent = ReplicatedStorage.Abilities:FindFirstChild(ab)
                if abEvent then
                    abEvent:FireServer()
                end
            end
        end
        task.wait(0.5)
    end
end)

-- ESP
local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("Highlight") then
            local hl = Instance.new("Highlight", player.Character)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end

-- GUI Buttons
makeButton("Toggle Auto Hit", function()
    toggles.AutoHit = not toggles.AutoHit
end)

makeButton("Toggle Auto Join", function()
    toggles.AutoJoin = not toggles.AutoJoin
end)

makeButton("Toggle Rollback Spins", function()
    toggles.Rollback = not toggles.Rollback
end)

makeButton("Toggle No Cooldowns", function()
    toggles.NoCooldowns = not toggles.NoCooldowns
end)

makeButton("Toggle Hitbox Expand", function()
    toggles.Hitbox = not toggles.Hitbox
end)

makeButton("Enable ESP", function()
    toggles.ESP = true
    enableESP()
end)

-- 🔧 JUMP POWER SLIDER
local sliderLabel = Instance.new("TextLabel", Frame)
sliderLabel.Size = UDim2.new(1, -10, 0, 30)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Jump Power: 100"
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 16

local jumpValue = 100

local UIS = game:GetService("UserInputService")

-- Adjust jump power with keys
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Up then
        jumpValue = jumpValue + 5
    elseif input.KeyCode == Enum.KeyCode.Down then
        jumpValue = jumpValue - 5
    end
    jumpValue = math.clamp(jumpValue, 50, 200)
    sliderLabel.Text = "Jump Power: " .. jumpValue
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpValue
    end
end)

-- Set initial jump power
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.JumpPower = jumpValue
end

print("✅ Volleyball Legends GUI loaded!")
