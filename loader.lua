-- AIM ASSIST + ESP
-- Para uso no seu próprio jogo Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AIM_ENABLED = true
local ESP_ENABLED = true
local FOV = 150

-- Círculo do FOV
local circle = Drawing and Drawing.new("Circle")

if circle then
    circle.Radius = FOV
    circle.Thickness = 2
    circle.Filled = false
    circle.Visible = true
end

local function getClosestPlayer()
    local closest = nil
    local shortest = FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and head then
                local position, visible =
                    Camera:WorldToViewportPoint(head.Position)

                if visible then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance =
                        (Vector2.new(position.X, position.Y) - mousePos).Magnitude

                    if distance < shortest then
                        shortest = distance
                        closest = head
                    end
                end
            end
        end
    end

    return closest
end

local function createESP(player)
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

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        createESP(player)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            createESP(player)
        end)

        if player.Character then
            createESP(player)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if circle then
        circle.Position = UserInputService:GetMouseLocation()
        circle.Visible = AIM_ENABLED
    end

    if AIM_ENABLED then
        local target = getClosestPlayer()

        if target then
            local cameraPosition = Camera.CFrame.Position
            Camera.CFrame = CFrame.lookAt(cameraPosition, target.Position)
        end
    end
end)
