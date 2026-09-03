--// TLX MM2 COPY HUB - VERSÃO MELHORADA
--// Para sua própria cópia no Roblox Studio

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
        if backpack:FindFirstChild("Knife") then return "Murderer" end
        if backpack:FindFirstChild("Gun") then return "Sheriff" end
    end

    local character = player.Character
    if character then
        if character:FindFirstChild("Knife") then return "Murderer" end
        if character:FindFirstChild("Gun") then return "Sheriff" end
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
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then removeESP(player) return end

    if not ESP_ENABLED then
        if ESP[player] then ESP[player].Enabled = false end
        return
    end

    local highlight = ESP[player]
    if not highlight or highlight.Parent ~= character then
        if highlight then highlight:Destroy() end
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
        highlight.FillColor = Color3.fromRGB(255, 60, 60)
        highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
    elseif role == "Sheriff" then
        highlight.FillColor = Color3.fromRGB(60, 140, 255)
        highlight.OutlineColor = Color3.fromRGB(60, 140, 255)
    else
        highlight.FillColor = Color3.fromRGB(80, 255, 140)
        highlight.OutlineColor = Color3.fromRGB(80, 255, 140)
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

Players.PlayerRemoving:Connect(removeESP)

local function setupPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function()
        removeESP(player)
        task.wait(0.5)
        updateESP(player)
    end)
    player.CharacterRemoving:Connect(removeESP)
    if player.Character then
        task.spawn(function() task.wait(0.5) updateESP(player) end)
    end
end

for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end
Players.PlayerAdded:Connect(setupPlayer)

--==================================================
-- NOCLIP
--==================================================

local function setNoclip(enabled)
    NOCLIP_ENABLED = enabled
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = not enabled end
    end
end

RunService.Stepped:Connect(function()
    if not NOCLIP_ENABLED then return end
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

--==================================================
-- INFINITE JUMP
--==================================================

UserInputService.JumpRequest:Connect(function()
    if not INFINITE_JUMP_ENABLED then return end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--==================================================
-- FUNÇÕES DE ANIMAÇÃO
--==================================================

local function addButtonEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = button.ActiveColor or Color3.fromRGB(210, 60, 160),
            Size = UDim2.new(1, -20, 0, 47)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        local originalColor = button.OriginalColor or Color3.fromRGB(180, 40, 130)
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = button.Toggled and originalColor or Color3.fromRGB(40, 40, 55),
            Size = UDim2.new(1, -30, 0, 45)
        }):Play()
    end)
end

--==================================================
-- TELA DE KEY - MELHORADA
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TLXKey"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(340, 200)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(255, 90, 200)
KeyStroke.Thickness = 3
KeyStroke.Transparency = 0.1
KeyStroke.Parent = KeyFrame

local KeyShadow = Instance.new("UIGradient")
KeyShadow.Rotation = 90
KeyShadow.Transparency = NumberSequence.new{
    Keypoints = {
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.3)
    }
}
KeyShadow.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.Position = UDim2.fromOffset(0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "✨ TLX HUB ✨"
KeyTitle.TextColor3 = Color3.fromRGB(255, 110, 210)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 26
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -50, 0, 45)
KeyBox.Position = UDim2.fromOffset(25, 75)
KeyBox.PlaceholderText = "🔑 Digite sua key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(240, 240, 240)
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.TextSize = 16
KeyBox.Parent = KeyFrame

Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)
local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Color3.fromRGB(100, 100, 130)
BoxStroke.Thickness = 1.5
BoxStroke.Parent = KeyBox

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1, -50, 0, 45)
Enter.Position = UDim2.fromOffset(25, 135)
Enter.Text = "🚀 ENTRAR"
Enter.TextColor3 = Color3.fromRGB(255, 255, 255)
Enter.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 17
Enter.AutoLocalize = false
Enter.Parent = KeyFrame

Instance.new("UICorner", Enter).CornerRadius = UDim.new(0, 10)
local EnterStroke = Instance.new("UIStroke")
EnterStroke.Color = Color3.fromRGB(255, 130, 200)
EnterStroke.Thickness = 1.5
EnterStroke.Parent = Enter

--==================================================
-- ABRIR HUB PRINCIPAL
--==================================================

Enter.MouseButton1Click:Connect(function()
    if KeyBox.Text ~= KEY then
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "❌ Key incorreta! Tente novamente"
        BoxStroke.Color = Color3.fromRGB(255, 80, 80)
        task.wait(2)
        BoxStroke.Color = Color3.fromRGB(100, 100, 130)
        return
    end

    KeyGui:Destroy()

    --==================================================
    -- HUB PRINCIPAL - REDESIGN COMPLETO
    --==================================================

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TLXHub"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(350, 380)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    Main.Parent = Gui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 90, 200)
    MainStroke.Thickness = 2.5
    MainStroke.Transparency = 0.15
    MainStroke.Parent = Main

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Rotation = 90
    MainGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(1, 0.25)
    }
    MainGradient.Parent = Main

    --==================================================
    -- ARRASTAR PAINEL
    --==================================================

    local dragging = false
    local dragStart
    local startPosition

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
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
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    --==================================================
    -- TÍTULO
    --==================================================

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 55)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.Parent = Main

    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 18)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.fromOffset(20, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🌸 TLX MM2 HUB 🌸"
    Title.TextColor3 = Color3.fromRGB(255, 110, 210)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    --==================================================
    -- BOTÃO FECHAR
    --==================================================

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(42, 42)
    Close.Position = UDim2.new(1, -52, 0, 6)
    Close.Text = "✕"
    Close.TextSize = 22
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundColor3 = Color3.fromRGB(220, 70, 120)
    Close.AutoLocalize = false
    Close.Parent = TitleBar

    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 12)
    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Color = Color3.fromRGB(255, 130, 160)
    CloseStroke.Thickness = 1.5
    CloseStroke.Parent = Close

    --==================================================
    -- BOTÃO FLUTUANTE
    --==================================================

    local Open = Instance.new("TextButton")
    Open.Size = UDim2.fromOffset(60, 60)
    Open.Position = UDim2.fromOffset(20, 220)
    Open.Text = "⚙️"
    Open.TextSize = 28
    Open.TextColor3 = Color3.new(1, 1, 1)
    Open.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
    Open.Visible = false
    Open.AutoLocalize = false
    Open.Parent = Gui

    Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)
    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(255, 130, 200)
    OpenStroke.Thickness = 2
    OpenStroke.Parent = Open

    Close.MouseButton1Click:Connect(function()
        Main.Visible = false
        Open.Visible = true
    end)

    Open.MouseButton1Click:Connect(function()
        Main.Visible = true
        Open.Visible = false
    end)

    --==================================================
    -- BOTÃO ESP
    --==================================================

    local ESPButton = Instance.new("TextButton")
    ESPButton.Size = UDim2.new(1, -40, 0, 48)
    ESPButton.Position = UDim2.fromOffset(20, 75)
    ESPButton.Text = "👁️ ESP ROLES [ON]"
    ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPButton.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
    ESPButton.Font = Enum.Font.GothamBold
    ESPButton.TextSize = 16
    ESPButton.AutoLocalize = false
    ESPButton.Toggled = true
    ESPButton.OriginalColor = Color3.fromRGB(200, 50, 150)
    ESPButton.ActiveColor = Color3.fromRGB(230, 70, 180)
    ESPButton.Parent = Main

    Instance.new("UICorner", ESPButton).CornerRadius = UDim.new(0, 12)
    local ESPStroke = Instance.new("UIStroke")
    ESPStroke.Color = Color3.fromRGB(255, 130, 200)
    ESPStroke.Thickness = 1.5
    ESPStroke.Parent = ESPButton
    addButtonEffect(ESPButton)

    ESPButton.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        ESPButton.Toggled = ESP_ENABLED
        ESPButton.Text = ESP_ENABLED
            and "👁️ ESP ROLES [ON]"
            or "👁️ ESP ROLES [OFF]"

        local targetColor = ESP_ENABLED
            and Color3.fromRGB(200, 50, 150)
            or Color3.fromRGB(45, 45, 65)

        TweenService:Create(ESPButton, TweenInfo.new(0.2), {
            BackgroundColor3 = targetColor
        }):Play()

        if not ESP_ENABLED then
            for _, highlight in pairs(ESP) do
                if highlight then highlight.Enabled = false end
            end
        end
    end)

    --==================================================
    -- NOCLIP
    --==================================================

    local NoclipButton = Instance.new("TextButton")
    NoclipButton.Size = UDim2.new(1, -40, 0, 48)
    NoclipButton.Position = UDim2.fromOffset(20, 133)
    NoclipButton.Text = "💀 NOCLIP [OFF]"
    NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoclipButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    NoclipButton.Font = Enum.Font.GothamBold
    NoclipButton.TextSize = 16
    NoclipButton.AutoLocalize = false
    NoclipButton.Toggled = false
    NoclipButton.OriginalColor = Color3.fromRGB(200, 50, 150)
    NoclipButton.ActiveColor = Color3.fromRGB(230, 70, 180)
    NoclipButton.Parent = Main

    Instance.new("UICorner", NoclipButton).CornerRadius = UDim.new(0, 12)
    local NoclipStroke = Instance.new("UIStroke")
    NoclipStroke.Color = Color3.fromRGB(110, 110, 140)
    NoclipStroke.Thickness = 1.5
    NoclipStroke.Parent = NoclipButton
    addButtonEffect(NoclipButton)

    NoclipButton.MouseButton1Click:Connect(function()
        setNoclip(not NOCLIP_ENABLED)
        NoclipButton.Toggled = NOCLIP_ENABLED

        if NOCLIP_ENABLED then
            NoclipStroke.Color = Color3.fromRGB(255, 130, 200)
            TweenService:Create(NoclipButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(200, 50, 150)
            }):Play()
            NoclipButton.Text = "💀 NOCLIP [ON]"
        else
            NoclipStroke.Color = Color3.fromRGB(110, 110, 140)
            TweenService:Create(NoclipButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            }):Play()
            NoclipButton.Text = "💀 NOCLIP [OFF]"
        end
    end)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local JumpButton = Instance.new("TextButton")
    JumpButton.Size = UDim2.new(1, -40, 0, 48)
    JumpButton.Position = UDim2.fromOffset(20, 191)
    JumpButton.Text = "🦘 INFINITE JUMP [OFF]"
    JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    JumpButton.Font = Enum.Font.GothamBold
    JumpButton.TextSize = 16
    JumpButton.AutoLocalize = false
    JumpButton.Toggled = false
    JumpButton.OriginalColor = Color3.fromRGB(200, 50, 150)
    JumpButton.ActiveColor = Color3.fromRGB(230, 70, 180)
    JumpButton.Parent = Main

    Instance.new("UICorner", JumpButton).CornerRadius = UDim.new(0, 12)
    local JumpStroke = Instance.new("UIStroke")
    JumpStroke.Color = Color3.fromRGB(110, 110, 140)
    JumpStroke.Thickness = 1.5
    JumpStroke.Parent = JumpButton
    addButtonEffect(JumpButton)

    JumpButton.MouseButton1Click:Connect(function()
        INFINITE_JUMP_ENABLED = not INFINITE_JUMP_ENABLED
        JumpButton.Toggled = INFINITE_JUMP_ENABLED

        if INFINITE_JUMP_ENABLED then
            JumpStroke.Color = Color3.fromRGB(255, 130, 200)
            TweenService:Create(JumpButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(200, 50, 150)
            }):Play()
            JumpButton.Text = "🦘 INFINITE JUMP [ON]"
        else
            JumpStroke.Color = Color3.fromRGB(110, 110, 140)
            TweenService:Create(JumpButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            }):Play()
            JumpButton.Text = "🦘 INFINITE JUMP [OFF]"
        end
    end)

    --==================================================
    -- LEGENDA
    --==================================================

    local InfoContainer = Instance.new("Frame")
    InfoContainer.Size = UDim2.new(1, -40, 0, 75)
    InfoContainer.Position = UDim2.fromOffset(20, 255)
    InfoContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    InfoContainer.BackgroundTransparency = 0.2
    InfoContainer.Parent = Main

    Instance.new("UICorner", InfoContainer).CornerRadius = UDim.new(0, 12)
    local InfoStroke = Instance.new("UIStroke")
    InfoStroke.Color = Color3.fromRGB(100, 100, 140)
    InfoStroke.Thickness = 1
    InfoStroke.Transparency = 0.3
    InfoStroke.Parent = InfoContainer

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -24, 1, 0)
    Info.Position = UDim2.fromOffset(12, 0)
    Info.BackgroundTransparency = 1
    Info.Text =
        "🔴 Murderer = Tem faca\n" ..
        "🔵 Sheriff = Tem arma\n" ..
        "🟢 Innocent = Sem arma"
    Info.TextColor3 = Color3.fromRGB(230, 230, 230)
    Info.Font = Enum.Font.GothamMedium
    Info.TextSize = 15
    Info.TextWrapped = true
    Info.TextYAlignment = Enum.TextYAlignment.Center
    Info.Parent = InfoContainer

end)
