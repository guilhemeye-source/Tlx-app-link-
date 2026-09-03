--// TLX MM2 COPY HUB
--// Para sua própria cópia no Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)

    elseif role == "Sheriff" then

        highlight.FillColor = Color3.fromRGB(0, 120, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 120, 255)

    else

        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)

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
-- KEY GUI
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TLXKey"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(300, 170)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "TLX HUB"
KeyTitle.TextColor3 = Color3.fromRGB(255, 70, 180)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 22
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.fromOffset(20, 55)
KeyBox.PlaceholderText = "Digite a key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 15
KeyBox.Parent = KeyFrame

Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1, -40, 0, 40)
Enter.Position = UDim2.fromOffset(20, 110)
Enter.Text = "ENTRAR"
Enter.TextColor3 = Color3.new(1, 1, 1)
Enter.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 15
Enter.Parent = KeyFrame

Instance.new("UICorner", Enter).CornerRadius = UDim.new(0, 8)

--==================================================
-- ABRIR HUB
--==================================================

Enter.MouseButton1Click:Connect(function()

    if KeyBox.Text ~= KEY then
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key incorreta!"
        return
    end

    KeyGui:Destroy()

    --==================================================
    -- HUB
    --==================================================

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TLXHub"
    Gui.ResetOnSpawn = false
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(320, 330)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
    Main.Parent = Gui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 70, 180)
    Stroke.Thickness = 2
    Stroke.Parent = Main

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

        if dragging and
        (
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

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -55, 0, 50)
    Title.Position = UDim2.fromOffset(15, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "TLX MM2 HUB"
    Title.TextColor3 = Color3.fromRGB(255, 70, 180)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 21
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    --==================================================
    -- FECHAR
    --==================================================

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(38, 38)
    Close.Position = UDim2.new(1, -48, 0, 10)
    Close.Text = "×"
    Close.TextSize = 25
    Close.TextColor3 = Color3.new(1, 1, 1)
    Close.BackgroundColor3 = Color3.fromRGB(150, 35, 80)
    Close.Parent = Main

    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

    --==================================================
    -- BOTÃO FLUTUANTE
    --==================================================

    local Open = Instance.new("TextButton")
    Open.Size = UDim2.fromOffset(55, 55)
    Open.Position = UDim2.fromOffset(15, 200)
    Open.Text = "☰"
    Open.TextSize = 25
    Open.TextColor3 = Color3.new(1, 1, 1)
    Open.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
    Open.Visible = false
    Open.Parent = Gui

    Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)

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
    ESPButton.Size = UDim2.new(1, -30, 0, 45)
    ESPButton.Position = UDim2.fromOffset(15, 60)
    ESPButton.Text = "ESP ROLES [ON]"
    ESPButton.TextColor3 = Color3.new(1, 1, 1)
    ESPButton.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
    ESPButton.Font = Enum.Font.GothamBold
    ESPButton.TextSize = 15
    ESPButton.Parent = Main

    Instance.new("UICorner", ESPButton).CornerRadius = UDim.new(0, 9)

    ESPButton.MouseButton1Click:Connect(function()

        ESP_ENABLED = not ESP_ENABLED

        ESPButton.Text = ESP_ENABLED
            and "ESP ROLES [ON]"
            or "ESP ROLES [OFF]"

        ESPButton.BackgroundColor3 = ESP_ENABLED
            and Color3.fromRGB(180, 40, 130)
            or Color3.fromRGB(35, 35, 45)

        if not ESP_ENABLED then
            for _, highlight in pairs(ESP) do
                if highlight then
                    highlight.Enabled = false
                end
            end
        end
    end)

    --==================================================
    -- NOCLIP
    --==================================================

    local NoclipButton = Instance.new("TextButton")
    NoclipButton.Size = UDim2.new(1, -30, 0, 45)
    NoclipButton.Position = UDim2.fromOffset(15, 112)
    NoclipButton.Text = "NOCLIP [OFF]"
    NoclipButton.TextColor3 = Color3.new(1, 1, 1)
    NoclipButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    NoclipButton.Font = Enum.Font.GothamBold
    NoclipButton.TextSize = 15
    NoclipButton.Parent = Main

    Instance.new("UICorner", NoclipButton).CornerRadius = UDim.new(0, 9)

    NoclipButton.MouseButton1Click:Connect(function()

        setNoclip(not NOCLIP_ENABLED)

        if NOCLIP_ENABLED then
            NoclipButton.Text = "NOCLIP [ON]"
            NoclipButton.BackgroundColor3 =
                Color3.fromRGB(180, 40, 130)
        else
            NoclipButton.Text = "NOCLIP [OFF]"
            NoclipButton.BackgroundColor3 =
                Color3.fromRGB(35, 35, 45)
        end
    end)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local JumpButton = Instance.new("TextButton")
    JumpButton.Size = UDim2.new(1, -30, 0, 45)
    JumpButton.Position = UDim2.fromOffset(15, 164)
    JumpButton.Text = "INFINITE JUMP [OFF]"
    JumpButton.TextColor3 = Color3.new(1, 1, 1)
    JumpButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    JumpButton.Font = Enum.Font.GothamBold
    JumpButton.TextSize = 15
    JumpButton.Parent = Main

    Instance.new("UICorner", JumpButton).CornerRadius = UDim.new(0, 9)

    JumpButton.MouseButton1Click:Connect(function()

        INFINITE_JUMP_ENABLED = not INFINITE_JUMP_ENABLED

        if INFINITE_JUMP_ENABLED then
            JumpButton.Text = "INFINITE JUMP [ON]"
            JumpButton.BackgroundColor3 =
                Color3.fromRGB(180, 40, 130)
        else
            JumpButton.Text = "INFINITE JUMP [OFF]"
            JumpButton.BackgroundColor3 =
                Color3.fromRGB(35, 35, 45)
        end
    end)

    --==================================================
    -- LEGENDA
    --==================================================

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -30, 0, 85)
    Info.Position = UDim2.fromOffset(15, 220)
    Info.BackgroundTransparency = 1

    Info.Text =
        "🔴 Murderer   |   🔵 Sheriff   |   🟢 Innocent\n" ..
        "Murderer = Knife\n" ..
        "Sheriff = Gun\n" ..
        "Sem arma = Innocent"

    Info.TextColor3 = Color3.fromRGB(220, 220, 220)
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 14
    Info.TextWrapped = true
    Info.Parent = Main

end)
