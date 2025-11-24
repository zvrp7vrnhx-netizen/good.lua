--== Main GUI ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

--------------------------
--  زر فيصل الدائري
--------------------------
local circleBtn = Instance.new("ImageButton", gui)
circleBtn.Size = UDim2.new(0, 80, 0, 80)
circleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
circleBtn.BackgroundTransparency = 1
circleBtn.Active = true
circleBtn.Draggable = true
circleBtn.Image = "rbxassetid://0" -- بدون صورة، دائرة فقط

-- خلفية دائرة
local circleFrame = Instance.new("Frame", circleBtn)
circleFrame.Size = UDim2.new(1, 0, 1, 0)
circleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
circleFrame.BackgroundTransparency = 0
circleFrame.BorderSizePixel = 0
circleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
circleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
circleFrame.ZIndex = 1
circleFrame.ClipsDescendants = true
circleFrame.Shape = Enum.UiElementShape.Circle

-- نص فيصل
local nameText = Instance.new("TextLabel", circleFrame)
nameText.Size = UDim2.new(1, 0, 1, 0)
nameText.Text = "فيصل"
nameText.TextColor3 = Color3.fromRGB(255,255,255)
nameText.BackgroundTransparency = 1
nameText.TextScaled = true
nameText.Font = Enum.Font.GothamBold

-----------------------------------
--  قائمة قابلة للتحريك
-----------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 250, 0, 170)
menu.Position = UDim2.new(0.3, 0, 0.4, 0)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.BorderSizePixel = 0

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "القائمة"
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.BorderSizePixel = 0

-----------------------------------
-- زر Aim Lock داخل القائمة
-----------------------------------
local aimBtn = Instance.new("TextButton", menu)
aimBtn.Size = UDim2.new(1, -20, 0, 50)
aimBtn.Position = UDim2.new(0, 10, 0, 60)
aimBtn.Text = "Aim Lock"
aimBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
aimBtn.TextColor3 = Color3.fromRGB(255,255,255)
aimBtn.TextScaled = true
aimBtn.BorderSizePixel = 0

-----------------------------------
--  نظام Aim Lock ثابت على لاعب واحد
-----------------------------------
local aimEnabled = false
local lockedTarget = nil

local function getClosest()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closestDist = math.huge
    local tgt = nil

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
            local dist = (char.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                tgt = p.Character
            end
        end
    end
    return tgt
end

task.spawn(function()
    while true do
        task.wait()
        if aimEnabled and lockedTarget and lockedTarget:FindFirstChild("Head") then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, lockedTarget.Head.Position)
        end
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled

    if aimEnabled then
        lockedTarget = getClosest()
        aimBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
        aimBtn.Text = "Aim ON"

        if not lockedTarget then
            aimBtn.Text = "No Target"
            aimEnabled = false
        end
    else
        lockedTarget = nil
        aimBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
        aimBtn.Text = "Aim OFF"
    end
end)

-----------------------------------
-- فتح وإغلاق القائمة بزر فيصل
-----------------------------------
local menuOpen = false

circleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menu.Visible = menuOpen
end)
