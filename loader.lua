-- Loader.lua
-- Telecinese para uso no seu próprio jogo Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local enabled = false
local grabbed = nil

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TelekinesisLoader"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- PAINEL
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(330, 220)
panel.Position = UDim2.new(0.5, -165, 0.5, -110)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
panel.BorderSizePixel = 0
panel.Parent = gui

local pc = Instance.new("UICorner")
pc.CornerRadius = UDim.new(0, 16)
pc.Parent = panel

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "LOADER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.Parent = panel

-- BOTÃO
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -30, 0, 65)
button.Position = UDim2.fromOffset(15, 70)
button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
button.BorderSizePixel = 0
button.Text = "TELECINESE • OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 17
button.Font = Enum.Font.GothamBold
button.Parent = panel

local bc = Instance.new("UICorner")
bc.CornerRadius = UDim.new(0, 12)
bc.Parent = button

-- INFO
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -30, 0, 55)
info.Position = UDim2.fromOffset(15, 145)
info.BackgroundTransparency = 1
info.Text = "Ative e segure o clique em uma peça física."
info.TextColor3 = Color3.fromRGB(170, 170, 180)
info.TextSize = 13
info.Font = Enum.Font.Gotham
info.TextWrapped = true
info.Parent = panel

-- BOLINHA
local ball = Instance.new("TextButton")
ball.Size = UDim2.fromOffset(60, 60)
ball.Position = UDim2.new(1, -75, 0.5, -30)
ball.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ball.BorderSizePixel = 0
ball.Text = "TK"
ball.TextColor3 = Color3.new(1, 1, 1)
ball.TextSize = 18
ball.Font = Enum.Font.GothamBold
ball.Parent = gui

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = ball

-- ATIVAR/DESATIVAR
local function toggle()
	enabled = not enabled

	if enabled then
		button.Text = "TELECINESE • ON"
		button.BackgroundColor3 = Color3.fromRGB(60, 130, 255)

		ball.Text = "ON"
		ball.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
	else
		button.Text = "TELECINESE • OFF"
		button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)

		ball.Text = "TK"
		ball.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

		grabbed = nil
	end
end

button.MouseButton1Click:Connect(toggle)
ball.MouseButton1Click:Connect(toggle)

-- PEGAR OBJETO
mouse.Button1Down:Connect(function()
	if not enabled then
		return
	end

	local target = mouse.Target

	if not target then
		return
	end

	if not target:IsA("BasePart") then
		return
	end

	if target.Anchored then
		return
	end

	grabbed = target
end)

-- SOLTAR
mouse.Button1Up:Connect(function()
	grabbed = nil
end)

-- MOVER
RunService.RenderStepped:Connect(function()
	if not enabled or not grabbed then
		return
	end

	if not grabbed.Parent then
		grabbed = nil
		return
	end

	local camera = workspace.CurrentCamera

	local position =
		camera.CFrame.Position +
		camera.CFrame.LookVector * 12

	grabbed.AssemblyLinearVelocity =
		(position - grabbed.Position) * 10
end)
