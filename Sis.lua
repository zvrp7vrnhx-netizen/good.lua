--== Teleport GUI FIXED ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- زر التلبورت
local tpBtn = Instance.new("TextButton", gui)
tpBtn.Size = UDim2.new(0,150,0,50)
tpBtn.Position = UDim2.new(0.5,-75,0.5,-25)
tpBtn.Text = "Go to PRESTIGE"
tpBtn.TextScaled = true
tpBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.Active = true
tpBtn.Draggable = true

-- وظيفة الزر
tpBtn.MouseButton1Click:Connect(function()
    local shop = workspace:FindFirstChild("PRESTIGE")
    if shop then
        local targetPart
        if shop:IsA("BasePart") then
            targetPart = shop
        elseif shop:IsA("Model") then
            -- نستخدم PrimaryPart أو أول Part نجده
            if shop.PrimaryPart then
                targetPart = shop.PrimaryPart
            else
                for _, v in pairs(shop:GetDescendants()) do
                    if v:IsA("BasePart") then
                        targetPart = v
                        break
                    end
                end
            end
        end

        if targetPart then
            hrp.CFrame = targetPart.CFrame + Vector3.new(0,5,0) -- فوق المتجر 5 وحدات
            print("Teleported to PRESTIGE")
        else
            warn("⚠ ما لقيت BasePart داخل PRESTIGE")
        end
    else
        warn("⚠ ما لقيت PRESTIGE في Workspace")
    end
end)
