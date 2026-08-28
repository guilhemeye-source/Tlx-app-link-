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

-- Painel
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(260, 360)
panel.Position = UDim2.new(0.5, -130, 0.5, -180)
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = panel

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 45)
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

-- Criar botão
local function createButton(text, y)
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

local aimButton = createButton("Aimbot", 50)
local espButton = createButton("ESP", 98)
local fovButton = createButton("FOV", 146)

-- Estados
local aimEnabled = false
local espEnabled = false
local fovEnabled = false

-- Valores dos sliders
local aimStrength = 0.5
local fovSize = 180

--------------------------------------------------
-- SLIDER GENÉRICO
--------------------------------------------------

local function createSlider(name, y, minValue, maxValue, defaultValue)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 22)
    label.Position = UDim2.fromOffset(15, y)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(defaultValue)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -30, 0, 8)
    bar.Position = UDim2.fromOffset(15, y + 28)
    bar.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    bar.BorderSizePixel = 0
    bar.Parent = panel

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(
        (defaultValue - minValue) / (maxValue - minValue),
        0,
        1,
        0
    )
    fill.BackgroundColor3 = Color3.fromRGB(255, 70, 180)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(
        (defaultValue - minValue) / (maxValue - minValue),
        0,
        0.5,
        0
    )
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.Parent = bar

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false
    local value = defaultValue

    local function update(inputX)
        local percent = math.clamp(
            (inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0,
            1
        )

        value = minValue + (maxValue - minValue) * percent

        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, 0, 0.5, 0)

        label.Text = name .. ": " .. math.floor(value)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            update(input.Position.X)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            update(mouse.X)
        end
    end)

    return function()
        return value
    end
end

local getAimStrength = createSlider(
    "Aimbot",
    205,
    1,
    100,
    50
)

local getFovSize = createSlider(
    "FOV",
    270,
    50,
    400,
    180
)

--------------------------------------------------
-- FOV VISUAL
--------------------------------------------------

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.Size = UDim2.fromOffset(fovSize, fovSize)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 2
fovStroke.Color = Color3.fromRGB(255, 70, 180)
fovStroke.Parent = fovCircle

--------------------------------------------------
-- ESP
--------------------------------------------------

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
                highlight.FillColor =
                    Color3.fromRGB(255, 70, 70)

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

--------------------------------------------------
-- AIMBOT
--------------------------------------------------

local function getTarget()
    local bestTarget
    local bestDistance = math.huge

    local center = Vector2.new(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2
    )

    local radius = getFovSize()

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

                    if distance <= radius / 2
                        and distance < bestDistance then

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

    -- Atualiza tamanho do FOV
    local currentFov = getFovSize()

    fovCircle.Size =
        UDim2.fromOffset(currentFov, currentFov)

    -- Aimbot
    if aimEnabled then

        local target = getTarget()

        if target then

            local strength =
                math.clamp(getAimStrength() / 100, 0.01, 1)

            local desired =
                CFrame.lookAt(
                    camera.CFrame.Position,
                    target.Position
                )

            camera.CFrame =
                camera.CFrame:Lerp(
                    desired,
                    strength
                )
        end
    end
end)

--------------------------------------------------
-- BOTÕES
--------------------------------------------------

aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled

    aimButton.Text =
        "Aimbot  " .. (aimEnabled and "ON" or "OFF")
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled

    espButton.Text =
        "ESP  " .. (espEnabled and "ON" or "OFF")

    updateESP()
end)

fovButton.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled

    fovCircle.Visible = fovEnabled

    fovButton.Text =
        "FOV  " .. (fovEnabled and "ON" or "OFF")
end)

--------------------------------------------------
-- BOLINHA
--------------------------------------------------

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

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    panel.Visible = true
    mini.Visible = false
end)


