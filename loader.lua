--// TLX SCRIPT MM2
--// Roblox Studio - sistema de teste para sua própria experiência

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local KEY = "Rlltxw"

local ESP_ENABLED = true
local NOCLIP_ENABLED = false
local INFJUMP_ENABLED = false
local AIM_ENABLED = false
local AIM_FOV = 120

local ESP = {}
local noclipConnection
local aimConnection

--==================================================
-- ESP DE ROLES
--==================================================

local function getRole(player)
    local backpack = player:FindFirstChild("Backpack")

    if backpack then
        if backpack:FindFirstChild("Knife") then
            return "Murderer"
        elseif backpack:FindFirstChild("Gun") then
            return "Sheriff"
        end
    end

    local character = player.Character

    if character then
        if character:FindFirstChild("Knife") then
            return "Murderer"
        elseif character:FindFirstChild("Gun") then
            return "Sheriff"
        end
    end

    return "Unknown"
end

local function removeESP(player)
    if ESP[player] then
        ESP[player]:Destroy()
        ESP[player] = nil
    end
end

local function updateESP(player)
    if player == LocalPlayer then return end

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

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "TLXRoleESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.45
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        ESP[player] = highlight
    end

    local role = getRole(player)

    if role == "Murderer" then
        highlight.Enabled = true
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)

    elseif role == "Sheriff" then
        highlight.Enabled = true
        highlight.FillColor = Color3.fromRGB(0, 120, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 120, 255)

    else
        highlight.Enabled = false
    end
end

task.spawn(function()
    while task.wait(0.2) do
        for _, player in ipairs(Players:GetPlayers()) do
            updateESP(player)
        end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

--==================================================
-- KEY
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TLXKey"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = PlayerGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(300, 175)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "TLX SCRIPT MM2"
KeyTitle.TextColor3 = Color3.fromRGB(255, 70, 180)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 21
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
-- HUB
--==================================================

Enter.MouseButton1Click:Connect(function()

    if KeyBox.Text ~= KEY then
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key incorreta!"
        return
    end

    KeyGui:Destroy()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TLXScriptMM2"
    Gui.ResetOnSpawn = false
    Gui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(340, 390)
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
    -- ARRASTAR
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
        (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then

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
    Title.Text = "TLX SCRIPT MM2"
    Title.TextColor3 = Color3.fromRGB(255, 70, 180)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 21
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    --==================================================
    -- FECHAR / ABRIR
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

    local Open = Instance.new("TextButton")
    Open.Size = UDim2.fromOffset(58, 58)
    Open.Position = UDim2.fromOffset(15, 200)
    Open.Text = "TLX"
    Open.TextSize = 16
    Open.Font = Enum.Font.GothamBold
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
    -- CRIADOR DE BOTÕES
    --==================================================

    local function createButton(text, y)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -30, 0, 45)
        button.Position = UDim2.fromOffset(15, y)
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 15
        button.Parent = Main

        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 9)

        return button
    end

    --==================================================
    -- ESP
    --==================================================

    local ESPButton = createButton("ESP ROLES [ON]", 60)

    ESPButton.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED

        ESPButton.Text = "ESP ROLES [" .. (ESP_ENABLED and "ON" or "OFF") .. "]"

        if not ESP_ENABLED then
            for _, highlight in pairs(ESP) do
                highlight.Enabled = false
            end
        end
    end)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local JumpButton = createButton("INFINITE JUMP [OFF]", 112)

    JumpButton.MouseButton1Click:Connect(function()
        INFJUMP_ENABLED = not INFJUMP_ENABLED
        JumpButton.Text = "INFINITE JUMP [" ..
            (INFJUMP_ENABLED and "ON" or "OFF") .. "]"
    end)

    UserInputService.JumpRequest:Connect(function()
        if INFJUMP_ENABLED then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    --==================================================
    -- NOCLIP
    --==================================================

    local NoclipButton = createButton("NOCLIP [OFF]", 164)

    NoclipButton.MouseButton1Click:Connect(function()
        NOCLIP_ENABLED = not NOCLIP_ENABLED

        NoclipButton.Text = "NOCLIP [" ..
            (NOCLIP_ENABLED and "ON" or "OFF") .. "]"

        if NOCLIP_ENABLED then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character

                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        elseif noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end)

    --==================================================
    -- AIM DE TREINO / FOV
    -- Apenas NPCs com atributo "TLXTarget"
    --==================================================

    local AimButton = createButton("AIM TRAINER [OFF]", 216)

    AimButton.MouseButton1Click:Connect(function()
        AIM_ENABLED = not AIM_ENABLED

        AimButton.Text = "AIM TRAINER [" ..
            (AIM_ENABLED and "ON" or "OFF") .. "]"

        if AIM_ENABLED then
            aimConnection = RunService.RenderStepped:Connect(function()
                -- O alvo de treino pode ser encontrado aqui:
                -- NPC com atributo TLXTarget = true
                -- mantendo a mira dentro do FOV configurado.
            end)
        elseif aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
    end)

    --==================================================
    -- FOV
    --==================================================

    local FOVButton = createButton("FOV: 120", 268)

    FOVButton.MouseButton1Click:Connect(function()
        AIM_FOV += 20

        if AIM_FOV > 240 then
            AIM_FOV = 40
        end

        FOVButton.Text = "FOV: " .. AIM_FOV
    end)

    --==================================================
    -- INFO
    --==================================================

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -30, 0, 40)
    Info.Position = UDim2.fromOffset(15, 325)
    Info.BackgroundTransparency = 1
    Info.Text = "TLX SCRIPT MM2 • TEST HUB"
    Info.TextColor3 = Color3.fromRGB(180, 180, 190)
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 12
    Info.Parent = Main

end)
