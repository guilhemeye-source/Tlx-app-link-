--// Loader.lua
--// Para uso no seu próprio jogo Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "AimHub"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Painel
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 210)
Main.Position = UDim2.new(0.5, -115, 0.5, -105)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "🎯 AIM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- Criador de botão
local function CreateButton(text, y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -30, 0, 42)
    Button.Position = UDim2.new(0, 15, 0, y)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    Button.Text = text .. " : OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.Parent = Main

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 10)
    C.Parent = Button

    return Button
end

local AimbotButton = CreateButton("Aimbot", 55)
local FOVButton = CreateButton("FOV", 105)
local ESPButton = CreateButton("ESP", 155)

local Aimbot = false
local FOV = false
local ESP = false

-- FOV
local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.new(0, 180, 0, 180)
FOVCircle.Position = UDim2.new(0.5, -90, 0.5, -90)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = Gui

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 80, 180)
Stroke.Parent = FOVCircle

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FOVCircle

-- ESP
local ESPObjects = {}

local function AddESP(player)
    if player == LocalPlayer then return end

    local function CharacterAdded(character)
        task.wait(0.5)

        local highlight = Instance.new("Highlight")
        highlight.Name = "AimHubESP"
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
        highlight.FillColor = Color3.fromRGB(255, 60, 60)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Enabled = ESP
        highlight.Parent = character

        ESPObjects[player] = highlight
    end

    if player.Character then
        CharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(CharacterAdded)
end

for _, player in ipairs(Players:GetPlayers()) do
    AddESP(player)
end

Players.PlayerAdded:Connect(AddESP)

-- Botão Aimbot
AimbotButton.MouseButton1Click:Connect(function()
    Aimbot = not Aimbot

    AimbotButton.Text = "Aimbot : " .. (Aimbot and "ON" or "OFF")

    if Aimbot then
        AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 40, 120)
    else
        AimbotButton.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    end
end)

-- Botão FOV
FOVButton.MouseButton1Click:Connect(function()
    FOV = not FOV

    FOVButton.Text = "FOV : " .. (FOV and "ON" or "OFF")
    FOVCircle.Visible = FOV

    if FOV then
        FOVButton.BackgroundColor3 = Color3.fromRGB(180, 40, 120)
    else
        FOVButton.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    end
end)

-- Botão ESP
ESPButton.MouseButton1Click:Connect(function()
    ESP = not ESP

    ESPButton.Text = "ESP : " .. (ESP and "ON" or "OFF")

    if ESP then
        ESPButton.BackgroundColor3 = Color3.fromRGB(180, 40, 120)
    else
        ESPButton.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    end

    for _, highlight in pairs(ESPObjects) do
        if highlight then
            highlight.Enabled = ESP
        end
    end
end)

-- Aimbot simples para NPCs/personagens dentro do seu jogo
local function GetClosestTarget()
    local closest = nil
    local shortest = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local root = player.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and root and humanoid.Health > 0 then
                local screenPos, visible =
                    Camera:WorldToViewportPoint(root.Position)

                if visible then
                    local center = Vector2.new(
                        Camera.ViewportSize.X / 2,
                        Camera.ViewportSize.Y / 2
                    )

                    local distance = (
                        Vector2.new(screenPos.X, screenPos.Y) - center
                    ).Magnitude

                    if distance < shortest then
                        shortest = distance
                        closest = root
                    end
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if Aimbot then
        local target = GetClosestTarget()

        if target then
            Camera.CFrame = CFrame.lookAt(
                Camera.CFrame.Position,
                target.Position
            )
        end
    end
end)

-- Bolinha de minimizar
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 55, 0, 55)
Mini.Position = UDim2.new(0, 20, 0.5, -27)
Mini.BackgroundColor3 = Color3.fromRGB(180, 40, 120)
Mini.Text = "◉"
Mini.TextColor3 = Color3.new(1, 1, 1)
Mini.TextSize = 25
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.Parent = Gui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = Mini

-- Botão para minimizar
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 35, 0, 30)
Minimize.Position = UDim2.new(1, -40, 0, 7)
Minimize.BackgroundTransparency = 1
Minimize.Text = "—"
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.TextSize = 22
Minimize.Parent = Main

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)
