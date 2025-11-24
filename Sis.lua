--=== Rainbow Hitbox Expander ===--

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0.5, -80, 0.6, 0)
btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Text = "Hitbox OFF"
btn.Active = true
btn.Draggable = true

local enabled = false
local size = Vector3.new(7,7,7)
local transparency = 0.6

btn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		btn.Text = "Hitbox ON"
		btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
	else
		btn.Text = "Hitbox OFF"
		btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
	end
end)

-- تابع يعطي ألوان متغيرة (Rainbow)
local function rainbowColor(tick)
	local hue = tick % 1
	return Color3.fromHSV(hue, 1, 1)
end

task.spawn(function()
	while true do
		task.wait(0.1)
		if enabled then
			local color = rainbowColor(tick() % 1)
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer and plr.Character then
					local head = plr.Character:FindFirstChild("Head")
					if head then
						head.Size = size
						head.Transparency = transparency
						head.Color = color
						head.Material = Enum.Material.Neon
						head.CanCollide = false
					end
				end
			end
		else
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer and plr.Character then
					local head = plr.Character:FindFirstChild("Head")
					if head then
						head.Size = Vector3.new(2,1,1)
						head.Transparency = 0
						head.Material = Enum.Material.SmoothPlastic
					end
				end
			end
		end
	end
end)
