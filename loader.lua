--// Free Kailruis - Versão Neon
--// Aviso: Para uso apenas em jogos próprios e ambientes de teste!
--// O uso em servidores públicos viola os Termos de Serviço da Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- CORES NEON 🔥
local COLORS = {
    DarkBg = Color3.fromRGB(8, 8, 14),
    CardBg = Color3.fromRGB(22, 18, 35),
    NeonPink = Color3.fromRGB(255, 45, 180),
    NeonCyan = Color3.fromRGB(45, 255, 255),
    NeonPurple = Color3.fromRGB(160, 60, 255),
    NeonGreen = Color3.fromRGB(60, 255, 140),
    NeonRed = Color3.fromRGB(255, 65, 95),
    NeonYellow = Color3.fromRGB(255, 230, 60),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextGray = Color3.fromRGB(180, 180, 200)
}

-- Notificação
local function Notify(title, msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = 3
        })
    end)
end

-- Remove painel antigo
local old = playerGui:FindFirstChild("FreeKailruisHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FreeKailruisHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- Painel principal com brilho
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(280, 430)
panel.Position = UDim2.new(0.5, -140, 0.5, -215)
panel.BackgroundColor3 = COLORS.DarkBg
panel.BorderSizePixel = 0
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 20)
panelCorner.Parent = panel

-- Contorno Neon Rosa (brilho externo)
local outline1 = Instance.new("UIStroke")
outline1.Thickness = 2
outline1.Transparency = 0.5
outline1.Color = COLORS.NeonPink
outline1.Parent = panel

local outline2 = Instance.new("UIStroke")
outline2.Thickness = 4
outline2.Transparency = 0.8
outline2.Color = COLORS.NeonPurple
outline2.Parent = panel

-- Título com brilho
local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, 0, 0, 60)
titleContainer.BackgroundColor3 = COLORS.CardBg
titleContainer.BackgroundTransparency = 0.3
titleContainer.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleContainer

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.fromOffset(20, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ FREE KAILRUIS ⚡"
title.TextColor3 = COLORS.NeonCyan
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local titleGlow = Instance.new("UIStroke")
titleGlow.Thickness = 1
titleGlow.Transparency = 0.6
titleGlow.Color = COLORS.NeonCyan
titleGlow.Parent = title

-- Minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(40, 40)
minimize.Position = UDim2.new(1, -45, 0, 10)
minimize.BackgroundTransparency = 1
minimize.Text = "−"
minimize.TextColor3 = COLORS.NeonPink
minimize.TextSize = 30
minimize.AutoButtonColor = false
minimize.Parent = panel

-- Criar botão com estilo Neon
local function createButton(icon, text, y, neonColor)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -40, 0, 44)
    b.Position = UDim2.fromOffset(20, y)
    b.BackgroundColor3 = COLORS.CardBg
    b.Text = icon .. "  " .. text .. "        ❌ OFF"
    b.TextColor3 = COLORS.TextGray
    b.TextSize = 15
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = panel

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 12)
    c.Parent = b

    local glow = Instance.new("UIStroke")
    glow.Name = "NeonGlow"
    glow.Thickness = 1
    glow.Transparency = 0.9
    glow.Color = neonColor
    glow.Parent = b

    -- Efeito hover
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(35, 28, 55)
        }):Play()
        TweenService:Create(glow, TweenInfo.new(0.15), {
            Transparency = 0.5,
            Thickness = 2
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        if b:GetAttribute("Enabled") then return end
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.CardBg
        }):Play()
        TweenService:Create(glow, TweenInfo.new(0.15), {
            Transparency = 0.9,
            Thickness = 1
        }):Play()
    end)

    return b, glow
end

-- Botões com cores neon diferentes
local aimButton, aimGlow = createButton("🎯", "Aimbot", 70, COLORS.NeonPink)
local espButton, espGlow = createButton("👥", "ESP", 126, COLORS.NeonRed)
local fovButton, fovGlow = createButton("👁", "FOV", 182, COLORS.NeonCyan)
local noclipButton, noclipGlow = createButton("👻", "Noclip", 238, COLORS.NeonGreen)

-- Estados
local aimEnabled = false
local espEnabled = false
local fovEnabled = false
local noclipEnabled = false

--------------------------------------------------
-- SLIDER COM ESTILO NEON
--------------------------------------------------

local function createSlider(name, y, minValue, maxValue, defaultValue, neonColor)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 22)
    label.Position = UDim2.fromOffset(20, y)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(defaultValue)
    label.TextColor3 = COLORS.TextWhite
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -40, 0, 10)
    bar.Position = UDim2.fromOffset(20, y + 28)
    bar.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
    bar.BorderSizePixel = 0
    bar.Parent = panel

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local barGlow = Instance.new("UIStroke")
    barGlow.Thickness = 1
    barGlow.Transparency = 0.7
    barGlow.Color = neonColor
    barGlow.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(
        (defaultValue - minValue) / (maxValue - minValue),
        0,
        1,
        0
    )
    fill.BackgroundColor3 = neonColor
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local fillGlow = Instance.new("UIStroke")
    fillGlow.Thickness = 1
    fillGlow.Transparency = 0.5
    fillGlow.Color = neonColor
    fillGlow.Parent = fill

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(
        (defaultValue - minValue) / (maxValue - minValue),
        0,
        0.5,
        0
    )
    knob.BackgroundColor3 = COLORS.TextWhite
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.Parent = bar

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local knobGlow = Instance.new("UIStroke")
    knobGlow.Thickness = 2
    knobGlow.Transparency = 0.3
    knobGlow.Color = neonColor
    knobGlow.Parent = knob

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

    return function() return value end
end

local getAimStrength = createSlider("Força do Aimbot", 290, 1, 100, 50, COLORS.NeonPink)
local getFovSize = createSlider("Tamanho do FOV", 350, 50, 400, 180, COLORS.NeonCyan)

--------------------------------------------------
-- FOV VISUAL NEON
--------------------------------------------------

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.Size = UDim2.fromOffset(180, 180)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 3
fovStroke.Color = COLORS.NeonCyan
fovStroke.Transparency = 0.2
fovStroke.Parent = fovCircle

local fovStroke2 = Instance.new("UIStroke")
fovStroke2.Thickness = 6
fovStroke2.Color = COLORS.NeonPurple
fovStroke2.Transparency = 0.8
fovStroke2.Parent = fovCircle

--------------------------------------------------
-- ESP
--------------------------------------------------

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = plr.Character:FindFirstChild("FreeKailruisESP")
            if espEnabled and not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "FreeKailruisESP"
                highlight.FillTransparency = 0.6
                highlight.OutlineTransparency = 0
                highlight.FillColor = COLORS.NeonRed
                highlight.OutlineColor = COLORS.NeonPink
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
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
-- NOCLIP
--------------------------------------------------

local function UpdateNoclip()
    local character = player.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclipEnabled
        end
    end
end

RunService.Stepped:Connect(function()
    if noclipEnabled then UpdateNoclip() end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    if noclipEnabled then UpdateNoclip() end
end)

--------------------------------------------------
-- AIMBOT
--------------------------------------------------

local function getTarget()
    local bestTarget
    local bestDistance = math.huge
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local radius = getFovSize()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and root and humanoid.Health > 0 then
                local pos, visible = camera:WorldToViewportPoint(root.Position)
                if visible then
                    local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if distance <= radius / 2 and distance < bestDistance then
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
    local currentFov = getFovSize()
    fovCircle.Size = UDim2.fromOffset(currentFov, currentFov)

    if aimEnabled then
        local target = getTarget()
        if target then
            local strength = math.clamp(getAimStrength() / 100, 0.01, 1)
            local desired = CFrame.lookAt(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(desired, strength)
        end
    end
end)

--------------------------------------------------
-- FUNÇÃO DE TOGGLE DOS BOTÕES
--------------------------------------------------

local function SetButtonState(btn, glow, isOn, neonColor)
    btn:SetAttribute("Enabled", isOn)
    local stateText = isOn and "✅ ON" or "❌ OFF"
    local textColor = isOn and COLORS.TextWhite or COLORS.TextGray
    local bgColor = isOn and Color3.fromRGB(45, 35, 70) or COLORS.CardBg
    local glowTrans = isOn and 0.3 or 0.9
    local glowThick = isOn and 2.5 or 1

    local namePart = string.match(btn.Text, "^[^ ]+ [^ ]+") or string.match(btn.Text, "^.+")
    btn.Text = namePart .. "        " .. stateText
    btn.TextColor3 = textColor

    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = bgColor}):Play()
    TweenService:Create(glow, TweenInfo.new(0.15), {
        Transparency = glowTrans,
        Thickness = glowThick,
        Color = neonColor
    }):Play()
end

--------------------------------------------------
-- LIGAÇÃO DOS BOTÕES
--------------------------------------------------

aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    SetButtonState(aimButton, aimGlow, aimEnabled, COLORS.NeonPink)
    Notify("🎯 Aimbot", aimEnabled and "Ativado ✅" or "Desativado ❌")
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    SetButtonState(espButton, espGlow, espEnabled, COLORS.NeonRed)
    updateESP()
    Notify("👥 ESP", espEnabled and "Ativado ✅" or "Desativado ❌")
end)

fovButton.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    fovCircle.Visible = fovEnabled
    SetButtonState(fovButton, fovGlow, fovEnabled, COLORS.NeonCyan)
    Notify("👁 FOV", fovEnabled and "Círculo visível ✅" or "Círculo oculto ❌")
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    SetButtonState(noclipButton, noclipGlow, noclipEnabled, COLORS.NeonGreen)
    UpdateNoclip()
    Notify("👻 Noclip", noclipEnabled and "Ativado ✅ — atravessa paredes!" or "Desativado ❌")
end)

--------------------------------------------------
-- BOLINHA DE MINIMIZAR NEON
--------------------------------------------------

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(62, 62)
mini.Position = UDim2.new(0, 20, 0.5, -31)
mini.BackgroundColor3 = COLORS.CardBg
mini.Text = "⚡"
mini.TextColor3 = COLORS.NeonCyan
mini.TextSize = 26
mini.Visible = false
mini.AutoButtonColor = false
mini.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = mini

local miniGlow = Instance.new("UIStroke")
miniGlow.Thickness = 2
miniGlow.Transparency = 0.4
miniGlow.Color = COLORS.NeonPink
miniGlow.Parent = mini

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    panel.Visible = true
    mini.Visible = false
end)

Notify("⚡ Free Kailruis Neon", "Carregado com sucesso! ✨")
