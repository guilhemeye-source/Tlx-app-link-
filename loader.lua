--// TLX MM2 COPY HUB
--// Interface visual renovada para uso no Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local KEY = "Rlltxw"

local ESP_ENABLED = true
local NOCLIP_ENABLED = false
local INFINITE_JUMP_ENABLED = false

local ESP = {}

--==================================================
-- DETECTAR PAPEL PELA ARMA/FACA
--==================================================

local function getRole(player)
    local backpack = player:FindFirstChild("Backpack")

    if backpack then
        if backpack:FindFirstChild("Knife") then
            return "Murderer"
        end

        if backpack:FindFirstChild("Gun") then
            return "Sheriff"
        end
    end

    local character = player.Character

    if character then
        if character:FindFirstChild("Knife") then
            return "Murderer"
        end

        if character:FindFirstChild("Gun") then
            return "Sheriff"
        end
    end

    return "Innocent"
end

--==================================================
-- REMOVER ESP
--==================================================

local function removeESP(player)
    if ESP[player] then
        ESP[player]:Destroy()
        ESP[player] = nil
    end
end

--==================================================
-- ATUALIZAR ESP
--==================================================

local function updateESP(player)
    if player == LocalPlayer then
        return
    end

    local character = player.Character

    if not character then
        removeESP(player)
        return
    end

    if not ESP_ENABLED then
        if ESP[player] then
            ESP[player].Enabled = false
        end
        return
    end

    local highlight = ESP[player]

    if not highlight or highlight.Parent ~= character then
        if highlight then
            highlight:Destroy()
        end

        highlight = Instance.new("Highlight")
        highlight.Name = "TLXRoleESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.45
        highlight.OutlineTransparency = 0
        highlight.Parent = character

        ESP[player] = highlight
    end

    local role = getRole(player)

    highlight.Enabled = true

    if role == "Murderer" then
        highlight.FillColor = Color3.fromRGB(239, 68, 68)
        highlight.OutlineColor = Color3.fromRGB(248, 113, 113)
    elseif role == "Sheriff" then
        highlight.FillColor = Color3.fromRGB(59, 130, 246)
        highlight.OutlineColor = Color3.fromRGB(96, 165, 250)
    else
        highlight.FillColor = Color3.fromRGB(34, 197, 94)
        highlight.OutlineColor = Color3.fromRGB(74, 222, 128)
    end
end

--==================================================
-- LOOP ESP
--==================================================

task.spawn(function()
    while task.wait(0.2) do
        for _, player in ipairs(Players:GetPlayers()) do
            updateESP(player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

local function setupPlayer(player)
    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(function()
        removeESP(player)
        task.wait(0.5)
        updateESP(player)
    end)

    player.CharacterRemoving:Connect(function()
        removeESP(player)
    end)

    if player.Character then
        task.spawn(function()
            task.wait(0.5)
            updateESP(player)
        end)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)

--==================================================
-- NOCLIP
--==================================================

local function setNoclip(enabled)
    NOCLIP_ENABLED = enabled

    local character = LocalPlayer.Character

    if not character then
        return
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

RunService.Stepped:Connect(function()
    if not NOCLIP_ENABLED then
        return
    end

    local character = LocalPlayer.Character

    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--==================================================
-- INFINITE JUMP
--==================================================

UserInputService.JumpRequest:Connect(function()
    if not INFINITE_JUMP_ENABLED then
        return
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--==================================================
-- ESTILO DA INTERFACE
--==================================================

-- ID da imagem de fundo. Substitua pelo Asset ID da imagem enviada ao Roblox.
local BACKGROUND_IMAGE = "rbxassetid://COLOQUE_SEU_ASSET_ID_AQUI"

local COLORS = {
    Background = Color3.fromRGB(11, 14, 24),
    Surface = Color3.fromRGB(19, 24, 38),
    SurfaceLight = Color3.fromRGB(29, 36, 55),
    Accent = Color3.fromRGB(168, 85, 247),
    AccentLight = Color3.fromRGB(236, 72, 153),
    Text = Color3.fromRGB(248, 250, 252),
    Muted = Color3.fromRGB(148, 163, 184),
    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
}

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function addStroke(instance, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

local function addGradient(instance, colorA, colorB, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colorA, colorB)
    gradient.Rotation = rotation or 0
    gradient.Parent = instance
    return gradient
end

local function addShadow(parent, size, position)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = size
    shadow.Position = position
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.55
    shadow.ZIndex = 0
    shadow.Parent = parent
    addCorner(shadow, 18)
    return shadow
end

local function addHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, 0, button.Size.Y.Offset + 2),
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = normalColor,
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, 0, button.Size.Y.Offset - 2),
        }):Play()
    end)
end

local function styleButton(button, icon, title, description, enabled)
    button.Text = ""
    button.AutoButtonColor = false
    button.BackgroundColor3 = enabled and COLORS.SurfaceLight or COLORS.Surface
    addCorner(button, 12)
    addStroke(button, enabled and COLORS.Accent or Color3.fromRGB(51, 65, 85), 0.35, 1)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.fromOffset(34, 34)
    iconLabel.Position = UDim2.fromOffset(12, 7)
    iconLabel.BackgroundColor3 = enabled and COLORS.Accent or Color3.fromRGB(51, 65, 85)
    iconLabel.Text = icon
    iconLabel.TextColor3 = COLORS.Text
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 15
    iconLabel.Parent = button
    addCorner(iconLabel, 9)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -118, 0, 22)
    titleLabel.Position = UDim2.fromOffset(58, 7)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = COLORS.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = button

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Name = "State"
    stateLabel.Size = UDim2.fromOffset(52, 24)
    stateLabel.Position = UDim2.new(1, -64, 0.5, -12)
    stateLabel.BackgroundColor3 = enabled and COLORS.Success or Color3.fromRGB(51, 65, 85)
    stateLabel.BackgroundTransparency = enabled and 0.75 or 0
    stateLabel.Text = enabled and "ON" or "OFF"
    stateLabel.TextColor3 = enabled and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.TextSize = 11
    stateLabel.Parent = button
    addCorner(stateLabel, 7)

    return stateLabel
end

--==================================================
-- KEY GUI
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TLXKey"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyShadow = addShadow(KeyGui, UDim2.fromOffset(342, 232), UDim2.fromScale(0.5, 0.5))
KeyShadow.AnchorPoint = Vector2.new(0.5, 0.5)

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(330, 220)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = COLORS.Background
KeyFrame.ZIndex = 1
KeyFrame.Parent = KeyGui
addCorner(KeyFrame, 18)
addStroke(KeyFrame, COLORS.Accent, 0.2, 1.5)

local KeyTop = Instance.new("Frame")
KeyTop.Size = UDim2.new(1, 0, 0, 70)
KeyTop.BackgroundColor3 = COLORS.Accent
KeyTop.Parent = KeyFrame
addCorner(KeyTop, 18)
addGradient(KeyTop, COLORS.Accent, COLORS.AccentLight, 25)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -40, 0, 28)
KeyTitle.Position = UDim2.fromOffset(20, 12)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "TLX HUB"
KeyTitle.TextColor3 = COLORS.Text
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 23
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Parent = KeyTop

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, -40, 0, 18)
KeySubtitle.Position = UDim2.fromOffset(20, 40)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Acesso seguro ao seu painel"
KeySubtitle.TextColor3 = Color3.fromRGB(245, 232, 255)
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.TextSize = 12
KeySubtitle.TextXAlignment = Enum.TextXAlignment.Left
KeySubtitle.Parent = KeyTop

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 42)
KeyBox.Position = UDim2.fromOffset(20, 88)
KeyBox.PlaceholderText = "Digite sua key..."
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.TextColor3 = COLORS.Text
KeyBox.PlaceholderColor3 = COLORS.Muted
KeyBox.BackgroundColor3 = COLORS.Surface
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = KeyFrame
addCorner(KeyBox, 10)
addStroke(KeyBox, Color3.fromRGB(71, 85, 105), 0.25, 1)

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1, -40, 0, 42)
Enter.Position = UDim2.fromOffset(20, 145)
Enter.Text = "ENTRAR NO HUB"
Enter.TextColor3 = COLORS.Text
Enter.BackgroundColor3 = COLORS.Accent
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 13
Enter.AutoButtonColor = false
Enter.Parent = KeyFrame
addCorner(Enter, 10)
addGradient(Enter, COLORS.Accent, COLORS.AccentLight, 25)
addHover(Enter, COLORS.Accent, COLORS.AccentLight)

--==================================================
-- ABRIR HUB
--==================================================

Enter.MouseButton1Click:Connect(function()
    if KeyBox.Text ~= KEY then
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key incorreta. Tente novamente."
        return
    end

    KeyGui:Destroy()

    --==================================================
    -- HUB
    --==================================================

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TLXHub"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainShadow = addShadow(Gui, UDim2.fromOffset(412, 498), UDim2.fromScale(0.5, 0.5))
    MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(400, 486)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = COLORS.Background
    Main.ZIndex = 1
    Main.Parent = Gui
    addCorner(Main, 20)
    addStroke(Main, COLORS.Accent, 0.15, 1.5)

    -- IMAGEM DE FUNDO
    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "PurpleBackground"
    BackgroundImage.Size = UDim2.fromScale(1, 1)
    BackgroundImage.Position = UDim2.fromScale(0, 0)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.Image = BACKGROUND_IMAGE
    BackgroundImage.ImageTransparency = 0.42
    BackgroundImage.ImageColor3 = Color3.fromRGB(220, 190, 255)
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ZIndex = 1
    BackgroundImage.Parent = Main
    addCorner(BackgroundImage, 20)

    -- ARRASTAR PAINEL
    local dragging = false
    local dragStart
    local startPosition

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    -- CABEÇALHO
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 92)
    Header.BackgroundColor3 = COLORS.Accent
    Header.Parent = Main
    addCorner(Header, 20)
    addGradient(Header, COLORS.Accent, COLORS.AccentLight, 25)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 0, 30)
    Title.Position = UDim2.fromOffset(22, 17)
    Title.BackgroundTransparency = 1
    Title.Text = "TLX MM2 HUB"
    Title.TextColor3 = COLORS.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 23
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -80, 0, 18)
    Subtitle.Position = UDim2.fromOffset(22, 51)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Painel de recursos e visualização"
    Subtitle.TextColor3 = Color3.fromRGB(245, 232, 255)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Visible = false
    Subtitle.Parent = Header

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(38, 38)
    Close.Position = UDim2.new(1, -54, 0, 18)
    Close.Text = "×"
    Close.TextSize = 25
    Close.TextColor3 = COLORS.Text
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 0.82
    Close.AutoButtonColor = false
    Close.Parent = Header
    addCorner(Close, 10)
    addHover(Close, Color3.fromRGB(255, 255, 255), COLORS.Danger)

    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, -40, 0, 20)
    Section.Position = UDim2.fromOffset(20, 108)
    Section.BackgroundTransparency = 1
    Section.Text = "CONTROLES PRINCIPAIS"
    Section.TextColor3 = COLORS.Muted
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 11
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = Main

    local function makeControl(y, icon, title, description, enabled)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -40, 0, 50)
        button.Position = UDim2.fromOffset(20, y)
        button.Parent = Main
        local state = styleButton(button, icon, title, description, enabled)
        return button, state
    end

    -- ESP
    local ESPButton, ESPState = makeControl(134, "E", "ESP DE ROLES", "Exibe o papel de cada jogador", ESP_ENABLED)
    addHover(ESPButton, COLORS.SurfaceLight, Color3.fromRGB(42, 51, 76))

    ESPButton.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        ESPState.Text = ESP_ENABLED and "ON" or "OFF"
        ESPState.BackgroundColor3 = ESP_ENABLED and COLORS.Success or Color3.fromRGB(51, 65, 85)
        ESPState.BackgroundTransparency = ESP_ENABLED and 0.75 or 0
        ESPState.TextColor3 = ESP_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted

        if not ESP_ENABLED then
            for _, highlight in pairs(ESP) do
                if highlight then
                    highlight.Enabled = false
                end
            end
        end
    end)

    -- NOCLIP
    local NoclipButton, NoclipState = makeControl(194, "N", "NOCLIP", "Alterna a colisão do personagem", NOCLIP_ENABLED)
    addHover(NoclipButton, COLORS.Surface, Color3.fromRGB(42, 51, 76))

    NoclipButton.MouseButton1Click:Connect(function()
        setNoclip(not NOCLIP_ENABLED)
        NoclipState.Text = NOCLIP_ENABLED and "ON" or "OFF"
        NoclipState.BackgroundColor3 = NOCLIP_ENABLED and COLORS.Success or Color3.fromRGB(51, 65, 85)
        NoclipState.BackgroundTransparency = NOCLIP_ENABLED and 0.75 or 0
        NoclipState.TextColor3 = NOCLIP_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    end)

    -- INFINITE JUMP
    local JumpButton, JumpState = makeControl(254, "J", "INFINITE JUMP", "Permite saltos consecutivos", INFINITE_JUMP_ENABLED)
    addHover(JumpButton, COLORS.Surface, Color3.fromRGB(42, 51, 76))

    JumpButton.MouseButton1Click:Connect(function()
        INFINITE_JUMP_ENABLED = not INFINITE_JUMP_ENABLED
        JumpState.Text = INFINITE_JUMP_ENABLED and "ON" or "OFF"
        JumpState.BackgroundColor3 = INFINITE_JUMP_ENABLED and COLORS.Success or Color3.fromRGB(51, 65, 85)
        JumpState.BackgroundTransparency = INFINITE_JUMP_ENABLED and 0.75 or 0
        JumpState.TextColor3 = INFINITE_JUMP_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    end)

    -- LEGENDA
    local LegendFrame = Instance.new("Frame")
    LegendFrame.Size = UDim2.new(1, -40, 0, 116)
    LegendFrame.Position = UDim2.fromOffset(20, 324)
    LegendFrame.BackgroundColor3 = COLORS.Surface
    LegendFrame.Visible = false
    LegendFrame.Parent = Main
    addCorner(LegendFrame, 12)
    addStroke(LegendFrame, Color3.fromRGB(51, 65, 85), 0.35, 1)

    local LegendTitle = Instance.new("TextLabel")
    LegendTitle.Size = UDim2.new(1, -24, 0, 22)
    LegendTitle.Position = UDim2.fromOffset(12, 10)
    LegendTitle.BackgroundTransparency = 1
    LegendTitle.Text = "LEGENDA DE ROLES"
    LegendTitle.TextColor3 = COLORS.Text
    LegendTitle.Font = Enum.Font.GothamBold
    LegendTitle.TextSize = 12
    LegendTitle.TextXAlignment = Enum.TextXAlignment.Left
    LegendTitle.Parent = LegendFrame

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -24, 0, 65)
    Info.Position = UDim2.fromOffset(12, 36)
    Info.BackgroundTransparency = 1
    Info.Text = "VERMELHO  •  Murderer   |   AZUL  •  Sheriff\nVERDE  •  Innocent\nMurderer = Knife  •  Sheriff = Gun  •  Sem arma = Innocent"
    Info.TextColor3 = COLORS.Muted
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 11
    Info.TextWrapped = true
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Parent = LegendFrame

    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(1, -40, 0, 20)
    Footer.Position = UDim2.fromOffset(20, 324)
    Footer.BackgroundTransparency = 1
    Footer.Text = "TLX  •  Interface renovada"
    Footer.TextColor3 = Color3.fromRGB(100, 116, 139)
    Footer.Font = Enum.Font.Gotham
    Footer.TextSize = 10
    Footer.TextXAlignment = Enum.TextXAlignment.Center
    Footer.Parent = Main

    local Open = Instance.new("TextButton")
    Open.Size = UDim2.fromOffset(58, 58)
    Open.Position = UDim2.fromOffset(18, 210)
    Open.Text = "TLX"
    Open.TextSize = 14
    Open.TextColor3 = COLORS.Text
    Open.BackgroundColor3 = COLORS.Accent
    Open.AutoButtonColor = false
    Open.Visible = false
    Open.Parent = Gui
    addCorner(Open, 18)
    addStroke(Open, COLORS.AccentLight, 0.2, 1.5)
    addGradient(Open, COLORS.Accent, COLORS.AccentLight, 25)

    Close.MouseButton1Click:Connect(function()
        Main.Visible = false
        MainShadow.Visible = false
        Open.Visible = true
    end)

    Open.MouseButton1Click:Connect(function()
        Main.Visible = true
        MainShadow.Visible = true
        Open.Visible = false
    end)
end)

--// Fim do TLX MM2 Copy Hub
