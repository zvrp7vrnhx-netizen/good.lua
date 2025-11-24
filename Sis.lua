--== Simple AimLock Button ==--

-- Create ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- Aim Button
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.5, -75, 0.8, 0)
btn.Text = "Aim Lock"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local aimEnabled = false
local lockedTarget = nil

-- Function to get closest player (only when toggled ON)
local function getClosest()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closestDist = math.huge
    local target = nil

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local dist = (char.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                target = v.Character
            end
        end
    end
    return target
end

-- Aim loop (looks at target head)
task.spawn(function()
    while true do
        task.wait()

        if aimEnabled and lockedTarget and lockedTarget:FindFirstChild("Head") then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, lockedTarget.Head.Position)
        end
    end
end)

-- Button toggle
btn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled

    if aimEnabled then
        lockedTarget = getClosest()
        btn.Text = "Aim ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,120,0)

        if not lockedTarget then
            btn.Text = "No Target"
            aimEnabled = false
        end
    else
        lockedTarget = nil
        btn.Text = "Aim OFF"
        btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
    end
end)
