-- NEON GLASS VIEWER
-- Author: Muxammaddin Tairov

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local enabled = false
local marked = {}

-- old GUI clean
for _, g in pairs(player.PlayerGui:GetChildren()) do
	if g:IsA("ScreenGui") and g.Name == "NeonGamingGUI" then
		g:Destroy()
	end
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NeonGamingGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 230)
main.Position = UDim2.new(0.5, -210, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(15,18,25)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Parent = gui
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 22)

-- Neon Stroke
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 220, 220)
stroke.Transparency = 0.25
stroke.Parent = main

-- Glow animation
task.spawn(function()
	while true do
		TweenService:Create(
			stroke,
			TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{Transparency = 0.7}
		):Play()
		task.wait(1.4)
		TweenService:Create(
			stroke,
			TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{Transparency = 0.25}
		):Play()
		task.wait(1.4)
	end
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "Muxammaddin Tairov"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(0,255,255)
title.Parent = main

-- BUTTON
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.65, 0, 0, 50)
btn.Position = UDim2.new(0.175, 0, 0.55, 0)
btn.BackgroundColor3 = Color3.fromRGB(0,190,190)
btn.Text = "Oynaklarni Ko‘rish"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20
btn.TextColor3 = Color3.fromRGB(0,0,0)
btn.Parent = main

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

-- Hover effect
btn.MouseEnter:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(0,255,255),
		Size = UDim2.new(0.7,0,0,55)
	}):Play()
end)

btn.MouseLeave:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(0,190,190),
		Size = UDim2.new(0.65,0,0,50)
	}):Play()
end)

-- ===== OYNAKLARNI KO‘RSATISH LOGIKASI =====
local function enableGlass()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart")
			and obj.Transparency < 0.9
			and obj.CanCollide == true
			and (obj.Material == Enum.Material.Glass or obj.Material == Enum.Material.SmoothPlastic)
		then
			if not marked[obj] then
				marked[obj] = {
					Color = obj.Color,
					Material = obj.Material
				}

				obj.Color = Color3.fromRGB(0,255,0)
				obj.Material = Enum.Material.Neon

				local gui = Instance.new("BillboardGui")
				gui.Name = "SafeGlassMark"
				gui.Size = UDim2.new(0, 70, 0, 70)
				gui.StudsOffset = Vector3.new(0, 3, 0)
				gui.AlwaysOnTop = true
				gui.Parent = obj

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1,0,1,0)
				label.BackgroundTransparency = 1
				label.Text = "✓"
				label.TextScaled = true
				label.Font = Enum.Font.GothamBlack
				label.TextColor3 = Color3.fromRGB(255,255,255)
				label.Parent = gui
			end
		end
	end
end

local function disableGlass()
	for obj, data in pairs(marked) do
		if obj and obj.Parent then
			obj.Color = data.Color
			obj.Material = data.Material
			if obj:FindFirstChild("SafeGlassMark") then
				obj.SafeGlassMark:Destroy()
			end
		end
	end
	marked = {}
end

-- CLICK
btn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		enableGlass()
		btn.Text = "O‘CHIRISH"
		btn.BackgroundColor3 = Color3.fromRGB(255,80,80)
	else
		disableGlass()
		btn.Text = "Oynaklarni Ko‘rish"
		btn.BackgroundColor3 = Color3.fromRGB(0,190,190)
	end
end)
