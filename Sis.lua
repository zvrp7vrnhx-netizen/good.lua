-- Auto Job + Auto Farm Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Config
local JobName = "Shelf Stocker" -- اسم الوظيفة
local BoxName = "صندوق"         -- اسم الصندوق
local WorkZoneName = "اكتمال"    -- اسم المكان/الدائرة الزرقاء
local WaitTime = 10              -- المدة اللي توقف فيها للحصول على الفلوس

local AutoFarmEnabled = true

-- Function to teleport to CFrame
local function teleportTo(pos)
    HumanoidRootPart.CFrame = CFrame.new(pos)
end

-- Function to take job
local function takeJob()
    local jobPrompt = workspace:FindFirstChild(JobName)
    if jobPrompt then
        HumanoidRootPart.CFrame = jobPrompt.CFrame + Vector3.new(0,3,0)
        task.wait(0.5)
        if jobPrompt:FindFirstChild("ProximityPrompt") then
            jobPrompt.ProximityPrompt:InputHoldBegin()
            task.wait(1)
            jobPrompt.ProximityPrompt:InputHoldEnd()
        end
    end
end

-- Function to pick up box
local function pickBox(box)
    if box then
        teleportTo(box.Position + Vector3.new(0,3,0))
        task.wait(1.5) -- انتظر ثانية أو ثانيتين
    end
end

-- Function to put box in work zone
local function putBox(workZone)
    if workZone then
        teleportTo(workZone.Position + Vector3.new(0,3,0))
        task.wait(WaitTime) -- انتظر المدة للحصول على الفلوس
    end
end

-- Main Loop
task.spawn(function()
    while AutoFarmEnabled do
        -- تحديث الشخصية
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        -- أخذ الوظيفة
        takeJob()

        -- إيجاد الصندوق
        local box = workspace:FindFirstChild(BoxName)
        if box then
            pickBox(box)
        end

        -- الذهاب للدائرة الزرقاء
        local zone = workspace:FindFirstChild(WorkZoneName)
        if zone then
            putBox(zone)
        end

        task.wait(0.5)
    end
end)
