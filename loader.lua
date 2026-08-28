-- Miranda-style Hub
-- Para uso no seu próprio jogo Roblox Studio

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MirandaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Janela
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 430, 0, 500)
main.Position = UDim2.new(0.5, -215, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 65)
title.BackgroundTransparency = 1
title.Text = "MIRANDA HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 58)
subtitle.BackgroundTransparency = 1
subtitle.Text = "SEU JOGO • PAINEL DE ITENS"
subtitle.TextColor3 = Color3.fromRGB(160, 160, 170)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = main

-- Lista
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -160)
list.Position = UDim2.new(0, 10, 0, 95)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = list

local items = {
	{"Eternal Lunar Dragon", "199.47m", "Eternal"},
	{"Snowy Owl", "5.76m", "Legendary"},
	{"Blue Dragon", "1.53m", "Legendary"},
	{"Ancient Egg", "1.50m", "Mythic"},
	{"Red Panda", "361k", "Mythic"}
}

for _, data in ipairs(items) do
	local item = Instance.new("Frame")
	item.Size = UDim2.new(1, -5, 0, 65)
	item.BackgroundColor3 = Color3.fromRGB(34, 34, 41)
	item.BorderSizePixel = 0
	item.Parent = list

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = item

	local name = Instance.new("TextLabel")
	name.Size = UDim2.new(0.62, 0, 0, 30)
	name.Position = UDim2.new(0, 15, 0, 7)
	name.BackgroundTransparency = 1
	name.Text = data[1]
	name.TextColor3 = Color3.fromRGB(245, 245, 245)
	name.TextSize = 17
	name.Font = Enum.Font.GothamBold
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.Parent = item

	local rarity = Instance.new("TextLabel")
	rarity.Size = UDim2.new(0.5, 0, 0, 20)
	rarity.Position = UDim2.new(0, 15, 0, 37)
	rarity.BackgroundTransparency = 1
	rarity.Text = data[3]
	rarity.TextColor3 = Color3.fromRGB(180, 60, 220)
	rarity.TextSize = 13
	rarity.Font = Enum.Font.Gotham
	rarity.TextXAlignment = Enum.TextXAlignment.Left
	rarity.Parent = item

	local value = Instance.new("TextLabel")
	value.Size = UDim2.new(0.3, -10, 1, 0)
	value.Position = UDim2.new(0.7, 0, 0, 0)
	value.BackgroundTransparency = 1
	value.Text = data[2]
	value.TextColor3 = Color3.fromRGB(70, 230, 120)
	value.TextSize = 17
	value.Font = Enum.Font.GothamBold
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.Parent = item
end

-- GO
local go = Instance.new("TextButton")
go.Size = UDim2.new(0.48, -10, 0, 55)
go.Position = UDim2.new(0, 10, 1, -65)
go.BackgroundColor3 = Color3.fromRGB(255, 45, 45)
go.Text = "GO"
go.TextColor3 = Color3.new(1, 1, 1)
go.TextSize = 22
go.Font = Enum.Font.GothamBold
go.Parent = main

local goCorner = Instance.new("UICorner")
goCorner.CornerRadius = UDim.new(0, 12)
goCorner.Parent = go

-- STOP
local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0.48, -10, 0, 55)
stop.Position = UDim2.new(0.52, 0, 1, -65)
stop.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
stop.Text = "STOP"
stop.TextColor3 = Color3.fromRGB(255, 80, 80)
stop.TextSize = 22
stop.Font = Enum.Font.GothamBold
stop.Parent = main

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 12)
stopCorner.Parent = stop

local running = false

go.MouseButton1Click:Connect(function()
	running = true
	go.Text = "ATIVO"
	print("Sistema iniciado")
end)

stop.MouseButton1Click:Connect(function()
	running = false
	go.Text = "GO"
	print("Sistema parado")
end)
