-- AIM ASSIST + ESP
-- Para usar no seu próprio jogo no Roblox Studio

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AIM_ENABLED = true
local ESP_ENABLED = true
local FOV = 150

-- Criar círculo do FOV na tela
local gui = Instance.new("ScreenGui")
gui.Name = "AimAssistGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local circle = Instance.new("Frame")
circle.Name = "FOV"
circle.Size = UDim2.fromOffset(FOV * 2, FOV * 2)
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = circle

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle

-- FOV fica sempre no centro da tela
local function updateFOV()
	local viewport = Camera.ViewportSize

	circle.Position = UDim2.fromOffset(
		viewport.X / 2,
		viewport.Y / 2
	)

	circle.Visible = AIM_ENABLED
end

-- ESP
local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character then return end

	local highlight = player.Character:FindFirstChild("GameESP")

	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "GameESP"
		highlight.FillTransparency = 0.7
		highlight.OutlineTransparency = 0
		highlight.Parent = player.Character
	end

	highlight.Enabled = ESP_ENABLED
end

local function setupPlayer(player)
	if player == LocalPlayer then return end

	player.CharacterAdded:Connect(function()
		task.wait(1)
		createESP(player)
	end)

	if player.Character then
		createESP(player)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)

-- Atualização
RunService.RenderStepped:Connect(function()
	updateFOV()
end)

updateFOV()
