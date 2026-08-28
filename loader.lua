--// Free Kailruis - Loader.lua
--// Uso: seu próprio jogo Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Remove painel antigo
local old = playerGui:FindFirstChild("FreeKailruisHub")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FreeKailruisHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(240, 365)
panel.Position = UDim2.new(0.5, -120, 0.5, -182)
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 45)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "FREE KAILRUIS"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- Minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(35, 35)
minimize.Position = UDim2.new(1, -40, 0, 5)
minimize.BackgroundTransparency = 1
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 25
minimize.Parent = panel

-- Criador de botões
local function button(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -30, 0, 42)
    b.Position = UDim2.fromOffset(15, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.Text = text .. "  OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = panel

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = b

    return b
end

local aimButton = button("Aimbot", 50)
local fovButton = button("FOV", 98)
local espButton = button("ESP", 146)
local noclipButton = button("Noclip", 194)
local wallshotButton = button("Wallshot", 242)
local botTargetButton = button("Bot Target", 290)

local aimEnabled = false
local fovEnabled = false
local espEnabled = false
local noclipEnabled = false
local wallshotEnabled = false
local botTargetEnabled = false

-- FOV
local fov = Instance.new("Frame")
fov.Size = UDim2.fromOffset(180, 180)
fov.AnchorPoint = Vector2.new(0.5, 0.5)
fov.Position = UDim2.fromScale(0.5, 0.5)
fov.BackgroundTransparency = 1
fov.Visible = false
fov.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fov

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 2
fovStroke.Color = Color3.fromRGB(255, 70, 180)
fovStroke.Parent = fov

-- ESP
local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight =
                plr.Character:FindFirstChild("FreeKailruisESP")

            if espEnabled and not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "FreeKailruisESP"
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0
                highlight.FillColor = Color3.fromRGB(255, 70, 70)
                highlight.Parent = plr.Character

            elseif not espEnabled and highlight then
                highlight:Destroy()
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.3)
        updateESP()
    end)
end)

-- Aimbot
local function getTarget()
    local bestTarget
    local bestDistance = math.huge

    local center = Vector2.new(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2
    )

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local humanoid =
                plr.Character:FindFirstChildOfClass("Humanoid")

            local root =
                plr.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and root and humanoid.Health > 0 then
                local pos, visible =
                    camera:WorldToViewportPoint(root.Position)

                if visible then
                    local distance =
                        (Vector2.new(pos.X, pos.Y) - center).Magnitude

                    if distance < bestDistance then
                        bestDistance = distance
                        bestTarget = root
                    end
                end
            end
        end
    end

    return bestTarget
end

RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getTarget()

        if target then
            camera.CFrame = CFrame.lookAt(
                camera.CFrame.Position,
                target.Position
            )
        end
    end
end)

-- Noclip
local function setNoclip(enabled)
    noclipEnabled = enabled

    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end
end

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)

    if noclipEnabled then
        setNoclip(true)
    end
end)

-- Bot Target
local currentBotHighlight

local function clearBotTarget()
    if currentBotHighlight then
        currentBotHighlight:Destroy()
        currentBotHighlight = nil
    end
end

local function findNearestBot()
    local character = player.Character
    if not character then
        return nil
    end

    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return nil
    end

    local nearestBot
    local nearestDistance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= character then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")

            -- NPCs/bots normalmente possuem Humanoid,
            -- mas não são jogadores.
            if humanoid and root
                and humanoid.Health > 0
                and not Players:GetPlayerFromCharacter(obj) then

                local distance =
                    (root.Position - myRoot.Position).Magnitude

                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestBot = obj
                end
            end
        end
    end

    return nearestBot
end

local function updateBotTarget()
    clearBotTarget()

    if not botTargetEnabled then
        return
    end

    local bot = findNearestBot()

    if bot then
        currentBotHighlight = Instance.new("Highlight")
        currentBotHighlight.Name = "FreeKailruisBotTarget"
        currentBotHighlight.FillTransparency = 0.65
        currentBotHighlight.OutlineTransparency = 0
        currentBotHighlight.FillColor =
            Color3.fromRGB(255, 190, 40)
        currentBotHighlight.Parent = bot
    end
end

-- Atualiza o alvo periodicamente
task.spawn(function()
    while gui.Parent do
        if botTargetEnabled then
            updateBotTarget()
        end

        task.wait(0.5)
    end
end)

-- Botões
aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimButton.Text =
        "Aimbot  " .. (aimEnabled and "ON" or "OFF")
end)

fovButton.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    fov.Visible = fovEnabled
    fovButton.Text =
        "FOV  " .. (fovEnabled and "ON" or "OFF")
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text =
        "ESP  " .. (espEnabled and "ON" or "OFF")

    updateESP()
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text =
        "Noclip  " .. (noclipEnabled and "ON" or "OFF")

    setNoclip(noclipEnabled)
end)

wallshotButton.MouseButton1Click:Connect(function()
    wallshotEnabled = not wallshotEnabled
    wallshotButton.Text =
        "Wallshot  " .. (wallshotEnabled and "ON" or "OFF")
end)

botTargetButton.MouseButton1Click:Connect(function()
    botTargetEnabled = not botTargetEnabled

    botTargetButton.Text =
        "Bot Target  " .. (botTargetEnabled and "ON" or "OFF")

    if botTargetEnabled then
        updateBotTarget()
    else
        clearBotTarget()
    end
end)

-- Bolinha
local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(58, 58)
mini.Position = UDim2.new(0, 20, 0.5, -29)
mini.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
mini.Text = "●"
mini.TextColor3 = Color3.new(1, 1, 1)
mini.TextSize = 25
mini.Visible = false
mini.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = mini

-- Minimizar
minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    mini.Visible = true
end)

-- Restaurar
mini.MouseButton1Click:Connect(function()
    panel.Visible = true
    mini.Visible = false
end)



