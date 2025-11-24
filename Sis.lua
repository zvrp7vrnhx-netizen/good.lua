--== Ultra High Jump GUI ==--
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- زر القفزة
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Text = "High Jump OFF"
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local highJump = false
local highJumpPower = 250 -- قوة القفزة العالية
local defaultJump = 50 -- القفزة الأصلية

-- تابع لتغيير JumpPower باستمرار
local function applyHighJump()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if highJump then
            player.Character.Humanoid.JumpPower = highJumpPower
        else
            player.Character.Humanoid.JumpPower = defaultJump
        end
    end
end

-- تحديث كل إطار لضمان القفزة العالية تعمل دائماً
RunService.Heartbeat:Connect(applyHighJump)

-- التعامل مع Respawn
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    applyHighJump()
end)

-- زر التشغيل والإيقاف
btn.MouseButton1Click:Connect(function()
    highJump = not highJump
    if highJump then
        btn.Text = "High Jump ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
    else
        btn.Text = "High Jump OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    end
end)
