--== Speed Boost GUI ==--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- زر السرعة
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Text = "Speed OFF"
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local speedEnabled = false
local defaultSpeed = 16 -- السرعة الأصلية
local speedBoost = 50   -- سرعة عالية

-- تابع لتطبيق السرعة
local function applySpeed()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.WalkSpeed = speedEnabled and speedBoost or defaultSpeed
    end
end

-- تحديث كل إطار للتأكد من استمرار السرعة
RunService.Heartbeat:Connect(applySpeed)

-- التعامل مع Respawn
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    applySpeed()
end)

-- زر التشغيل والإيقاف
btn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        btn.Text = "Speed ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
    else
        btn.Text = "Speed OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    end
    applySpeed()
end)
