-- FULL GOD MODE + DAMAGE BLOCKER
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local function protectChar(char)
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- 1) منع نقص الدم نهائياً
    hum.Health = hum.MaxHealth
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        hum.Health = hum.MaxHealth
    end)

    -- 2) حذف أي أداة تسبب دمج لمن تلمسك
    char.DescendantAdded:Connect(function(part)
        if part:IsA("TouchTransmitter") or part:IsA("BasePart") then
            part.CanTouch = false
            pcall(function()
                part.Touched:Connect(function() end)
            end)
        end
    end)

    -- 3) منع أي سكربت Damage من التأثير عليك
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            pcall(function()
                v.Disabled = true
            end)
        end
    end

    -- 4) تنظيف الدمج المستقبلي كل ثانية
    task.spawn(function()
        while char.Parent do
            hum.Health = hum.MaxHealth
            hum.MaxHealth = hum.MaxHealth
            task.wait(0.1)
        end
    end)
end

-- حماية عند الرسبنة
LP.CharacterAdded:Connect(protectChar)

-- حماية للشخصية الحالية
if LP.Character then
    protectChar(LP.Character)
end
