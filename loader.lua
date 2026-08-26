-- Loader.lua
-- TELECINESE - PARA USO NO SEU PRÓPRIO JOGO

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =========================
-- CONFIGURAÇÃO
-- =========================

local TELEKINESIS_DISTANCE = 35
local HOLD_DISTANCE = 12
local FORCE = 8000

local telekinesisEnabled = false
local holdingObject = nil
local bodyPosition = nil

-- =========================
-- GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Painel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 330, 0, 230)
panel.Position = UDim2.new(0.5, -165, 0.5, -115)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = panel

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "LOADER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.Parent = panel

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 30)
subtitle.Position = UDim2.new(0, 15, 0, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Painel de funções"
subtitle.TextColor3 = Color3.fromRGB(160, 160, 170)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = panel

-- Botão Telecinese
local teleButton = Instance.new("TextButton")
teleButton.Size = UDim2.new(1, -30, 0, 60)
teleButton.Position = UDim2.new(0, 15, 0, 90)
teleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
teleButton.BorderSizePixel = 0
teleButton.Text = "TELECINESE  •  OFF"
teleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleButton.TextSize = 17
teleButton.Font = Enum.Font.GothamBold
teleButton.Parent = panel

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = teleButton

-- Informação
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -30, 0, 50)
info.Position = UDim2.new(0, 15, 0, 160)
info.BackgroundTransparency = 1
info.Text = "Ative e clique em um objeto físico\npara segurá-lo e movê-lo."
info.TextColor3 = Color3.fromRGB(170, 170, 180)
info.TextSize = 13
info.Font = Enum.Font.Gotham
info.TextWrapped = true
info.Parent = panel

-- =========================
-- BOLINHA FLUTUANTE
-- =========================

local ball = Instance.new("TextButton")
ball.Size = UDim2.new(0, 60, 0, 60)
ball.Position = UDim2.new(1, -80, 0.5, -30)
ball.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
ball.BorderSizePixel = 0
ball.Text = "TK"
ball.TextColor3 = Color3.fromRGB(255, 255, 255)
ball.TextSize = 18
ball.Font = Enum.Font.GothamBold
ball.Visible = true
ball.Parent = gui

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = ball

-- =========================
-- FUNÇÕES
-- =========================

local function updateButton()
	if telekinesisEnabled then
		teleButton.Text = "TELECINESE  •  ON"
		teleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)

		ball.Text = "ON"
		ball.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
	else
		teleButton.Text = "TELECINESE  •  OFF"
		teleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)

		ball.Text = "TK"
		ball.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
	end
end

local function releaseObject()
	if bodyPosition then
		bodyPosition:Destroy()
		bodyPosition = nil
	end

	holdingObject = nil
end

local function getTarget()
	if not mouse.Target then
		return nil
	end

	local target = mouse.Target

	if not target:IsA("BasePart") then
		return nil
	end

	if target.Anchored then
		return nil
	end

	local character = player.Character
	if not character then
		return nil
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end

	local distance = (target.Position - root.Position).Magnitude

	if distance > TELEKINESIS_DISTANCE then
		return nil
	end

	return target
end

local function grabObject()
	if not telekinesisEnabled then
		return
	end

	local target = getTarget()

	if not target then
		return
	end

	releaseObject()

	holdingObject = target

	bodyPosition = Instance.new("BodyPosition")
	bodyPosition.MaxForce = Vector3.new(FORCE, FORCE, FORCE)
	bodyPosition.P = 30000
	bodyPosition.D = 1500
	bodyPosition.Position = target.Position
	bodyPosition.Parent = target
end

-- =========================
-- ATIVAR / DESATIVAR
-- =========================

local function toggleTelekinesis()
	telekinesisEnabled = not telekinesisEnabled

	if not telekinesisEnabled then
		releaseObject()
	end

	updateButton()
end

teleButton.MouseButton1Click:Connect(toggleTelekinesis)
ball.MouseButton1Click:Connect(toggleTelekinesis)

-- =========================
-- PEGAR OBJETO
-- =========================

mouse.Button1Down:Connect(function()
	if telekinesisEnabled then
		grabObject()
	end
end)

mouse.Button1Up:Connect(function()
	if telekinesisEnabled then
		releaseObject()
	end
end)

-- =========================
-- MOVIMENTO DO OBJETO
-- =========================

RunService.RenderStepped:Connect(function()
	if not holdingObject or not bodyPosition then
		return
	end

	if not holdingObject.Parent then
		releaseObject()
		return
	end

	local camera = workspace.CurrentCamera

	if not camera then
		return
	end

	local targetPosition =
		camera.CFrame.Position +
		camera.CFrame.LookVector * HOLD_DISTANCE

	bodyPosition.Position = targetPosition
end)

-- =========================
-- MOSTRAR / ESCONDER PAINEL
-- =========================

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.RightShift then
		panel.Visible = not panel.Visible
	end
end)

updateButton()
