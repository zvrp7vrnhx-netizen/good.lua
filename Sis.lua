--===== SUPER DASH / BOOST =====--
local UIS = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- زر التشغيل
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
btn.Text = "Boost OFF"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local boostEnabled = false

btn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	if boostEnabled then
		btn.Text = "Boost ON"
		btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
	else
		btn.Text = "Boost OFF"
		btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
	end
end)

-- ====== قوة الدفع ======
local BOOST_POWER = 80

UIS.InputBegan:Connect(function(key)
	if boostEnabled and key.KeyCode == Enum.KeyCode.Space then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			
			-- دفعة قوية للأعلى + للأمام
			hrp.Velocity = hrp.CFrame.LookVector * BOOST_POWER + Vector3.new(0, BOOST_POWER * 1.3, 0)
		end
	end
end)
