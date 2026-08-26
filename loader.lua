-- LOADER + AIM ASSIST + ESP
-- Para uso no seu próprio jogo Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimEnabled = false
local ESPEnabled = true
local FOVRadius = 120
local Smoothness = 0.15
local MaxDistance = 500

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "AimESP"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- FOV FIXO
local FOV = Instance.new("Frame")
FOV.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
FOV.Position = UDim2.fromScale(0.5, 0.5)
FOV.AnchorPoint = Vector2.new(0.5, 0.5)
FOV.BackgroundTransparency = 1
FOV.Parent = Gui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOV

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 2
FOVStroke.Parent = FOV

-- PAINEL
local Panel = Instance.new("Frame")
Panel.Size = UDim2.fromOffset(200, 125)
Panel.Position = UDim2.fromOffset(20, 100)
Panel.BackgroundTransparency = 0.15
Panel.Parent = Gui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 12)
PanelCorner.Parent = Panel

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "AIM + ESP"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Panel

local AimButton = Instance.new("TextButton")
AimButton.Size = UDim2.new(1, -20, 0, 32)
AimButton.Position = UDim2.fromOffset(10, 38)
AimButton.Text = "AIM: OFF"
AimButton.TextScaled = true
AimButton.Font = Enum.Font.GothamBold
AimButton.Parent = Panel

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 32)
ESPButton.Position = UDim2.fromOffset(10, 78)
ESPButton.Text = "ESP: ON"
ESPButton.TextScaled = true
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Parent = Panel

-- ESP
local function AddESP(Player)
    if Player == LocalPlayer then
        return
    end

    local function Setup(Character)
        if not ESPEnabled then
            return
        end

        local Old = Character:FindFirstChild("PlayerESP")
        if Old then
            Old:Destroy()
        end

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "PlayerESP"
        Highlight.Adornee = Character
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = 0.7
        Highlight.OutlineTransparency = 0
        Highlight.Parent = Character
    end

    Player.CharacterAdded:Connect(function(Character)
        task.wait(0.3)
        Setup(Character)
    end)

    if Player.Character then
        Setup(Player.Character)
    end
end

for _, Player in ipairs(Players:GetPlayers()) do
    AddESP(Player)
end

Players.PlayerAdded:Connect(AddESP)

-- PEGAR ALVO MAIS PRÓXIMO DO CENTRO
local function GetTarget()
    local Target = nil
    local Closest = FOVRadius

    local Center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character then

            local Character = Player.Character
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local Head = Character:FindFirstChild("Head")

            if Humanoid and Head and Humanoid.Health > 0 then

                local Position, Visible =
                    Camera:WorldToViewportPoint(Head.Position)

                if Visible then

                    local ScreenPosition =
                        Vector2.new(Position.X, Position.Y)

                    local ScreenDistance =
                        (ScreenPosition - Center).Magnitude

                    local Distance =
                        (Camera.CFrame.Position - Head.Position).Magnitude

                    if ScreenDistance < Closest
                        and Distance <= MaxDistance then

                        Closest = ScreenDistance
                        Target = Head
                    end
                end
            end
        end
    end

    return Target
end

-- AIM
RunService.RenderStepped:Connect(function()

    if not AimEnabled then
        return
    end

    local Target = GetTarget()

    if Target then

        local LookAt = CFrame.lookAt(
            Camera.CFrame.Position,
            Target.Position
        )

        Camera.CFrame =
            Camera.CFrame:Lerp(LookAt, Smoothness)
    end
end)

-- BOTÃO AIM
AimButton.MouseButton1Click:Connect(function()

    AimEnabled = not AimEnabled

    if AimEnabled then
        AimButton.Text = "AIM: ON"
    else
        AimButton.Text = "AIM: OFF"
    end
end)

-- BOTÃO ESP
ESPButton.MouseButton1Click:Connect(function()

    ESPEnabled = not ESPEnabled

    ESPButton.Text =
        ESPEnabled and "ESP: ON" or "ESP: OFF"

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player.Character then

            local ESP =
                Player.Character:FindFirstChild("PlayerESP")

            if ESPEnabled then

                if not ESP and Player ~= LocalPlayer then
                    AddESP(Player)
                end

            elseif ESP then
                ESP:Destroy()
            end
        end
    end
end)

-- TECLA Q
UserInputService.InputBegan:Connect(function(Input, Processed)

    if Processed then
        return
    end

    if Input.KeyCode == Enum.KeyCode.Q then

        AimEnabled = not AimEnabled

        AimButton.Text =
            AimEnabled and "AIM: ON" or "AIM: OFF"
    end
end)
