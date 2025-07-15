-- Хітбокси невидимі, але активні
for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        local char = player.Character or player.CharacterAdded:Wait()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local box = char:FindFirstChild("HitBox") or Instance.new("BoxHandleAdornment")
            box.Name = "HitBox"
            box.Adornee = char.HumanoidRootPart
            box.Size = Vector3.new(5, 5, 5) -- розмір хітбоксу
            box.Transparency = 1           -- невидимий
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.Color3 = Color3.new(1, 0, 0)
            box.Parent = char
        end
    end
end

-- Супер потужна подача
local function powerfulServe()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local ball = workspace:FindFirstChild("Volleyball")
    if not ball then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        ball.CFrame = hrp.CFrame * CFrame.new(0, 3, -2)
        ball.Velocity = hrp.CFrame.lookVector * 200 + Vector3.new(0, 80, 0)
    end
end

-- Простий GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, 0, 0.5, 0)
Button.Position = UDim2.new(0, 0, 0, 0)
Button.Text = "Супер подача"
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.MouseButton1Click:Connect(powerfulServe)

local HitboxToggle = Instance.new("TextButton", Frame)
HitboxToggle.Size = UDim2.new(1, 0, 0.5, 0)
HitboxToggle.Position = UDim2.new(0, 0, 0.5, 0)
HitboxToggle.Text = "Показати/сховати хітбокси"
HitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

local hitboxesVisible = false
HitboxToggle.MouseButton1Click:Connect(function()
    hitboxesVisible = not hitboxesVisible
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HitBox") then
                char.HitBox.Transparency = hitboxesVisible and 0.3 or 1
            end
        end
    end
end)
