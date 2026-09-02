--// TLX MM2 COPY HUB
--// Para sua própria cópia no Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local KEY = "Rlltxw"

local ESP_ENABLED = true
local ESP = {}

--==================================================
-- FUNÇÃO: DETECTAR PAPEL PELA ARMA/FACA
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

    return "Unknown"
end

--==================================================
-- ESP
--==================================================

local function removeESP(player)
    if ESP[player] then
        ESP[player]:Destroy()
        ESP[player] = nil
    end
end

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
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.OutlineColor = Color3.fromRGB(255,0,0)

    elseif role == "Sheriff" then

        highlight.Enabled = true
        highlight.FillColor = Color3.fromRGB(0,120,255)
        highlight.OutlineColor = Color3.fromRGB(0,120,255)

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

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        updateESP(player)
    end)
end)

--==================================================
-- KEY
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TLXKey"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(300,170)
KeyFrame.Position = UDim2.fromScale(0.5,0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5,0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,28)
KeyFrame.Parent = KeyGui

Instance.new("UICorner",KeyFrame).CornerRadius = UDim.new(0,12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1,0,0,45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "TLX HUB"
KeyTitle.TextColor3 = Color3.fromRGB(255,70,180)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 22
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1,-40,0,40)
KeyBox.Position = UDim2.fromOffset(20,55)
KeyBox.PlaceholderText = "Digite a key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 15
KeyBox.Parent = KeyFrame

Instance.new("UICorner",KeyBox).CornerRadius = UDim.new(0,8)

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1,-40,0,40)
Enter.Position = UDim2.fromOffset(20,110)
Enter.Text = "ENTRAR"
Enter.TextColor3 = Color3.new(1,1,1)
Enter.BackgroundColor3 = Color3.fromRGB(180,40,130)
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 15
Enter.Parent = KeyFrame

Instance.new("UICorner",Enter).CornerRadius = UDim.new(0,8)

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
    Gui.Name = "TLXHub"
    Gui.ResetOnSpawn = false
    Gui.Parent = LocalPlayer.PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(320,230)
    Main.Position = UDim2.fromScale(.5,.5)
    Main.AnchorPoint = Vector2.new(.5,.5)
    Main.BackgroundColor3 = Color3.fromRGB(17,17,24)
    Main.Parent = Gui

    Instance.new("UICorner",Main).CornerRadius = UDim.new(0,14)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255,70,180)
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
    Title.Size = UDim2.new(1,-55,0,50)
    Title.Position = UDim2.fromOffset(15,5)
    Title.BackgroundTransparency = 1
    Title.Text = "TLX MM2 HUB"
    Title.TextColor3 = Color3.fromRGB(255,70,180)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 21
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    --==================================================
    -- FECHAR
    --==================================================

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(38,38)
    Close.Position = UDim2.new(1,-48,0,10)
    Close.Text = "×"
    Close.TextSize = 25
    Close.TextColor3 = Color3.new(1,1,1)
    Close.BackgroundColor3 = Color3.fromRGB(150,35,80)
    Close.Parent = Main

    Instance.new("UICorner",Close).CornerRadius = UDim.new(0,8)

    local Open = Instance.new("TextButton")
    Open.Size = UDim2.fromOffset(55,55)
    Open.Position = UDim2.fromOffset(15,200)
    Open.Text = "☰"
    Open.TextSize = 25
    Open.TextColor3 = Color3.new(1,1,1)
    Open.BackgroundColor3 = Color3.fromRGB(180,40,130)
    Open.Visible = false
    Open.Parent = Gui

    Instance.new("UICorner",Open).CornerRadius = UDim.new(1,0)

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
    ESPButton.Size = UDim2.new(1,-30,0,50)
    ESPButton.Position = UDim2.fromOffset(15,65)
    ESPButton.Text = "ESP ROLES  [ON]"
    ESPButton.TextColor3 = Color3.new(1,1,1)
    ESPButton.BackgroundColor3 = Color3.fromRGB(180,40,130)
    ESPButton.Font = Enum.Font.GothamBold
    ESPButton.TextSize = 16
    ESPButton.Parent = Main

    Instance.new("UICorner",ESPButton).CornerRadius = UDim.new(0,9)

    ESPButton.MouseButton1Click:Connect(function()

        ESP_ENABLED = not ESP_ENABLED

        if ESP_ENABLED then
            ESPButton.Text = "ESP ROLES  [ON]"
            ESPButton.BackgroundColor3 =
                Color3.fromRGB(180,40,130)
        else
            ESPButton.Text = "ESP ROLES  [OFF]"
            ESPButton.BackgroundColor3 =
                Color3.fromRGB(35,35,45)
        end

    end)

    --==================================================
    -- LEGENDA
    --==================================================

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1,-30,0,70)
    Info.Position = UDim2.fromOffset(15,125)
    Info.BackgroundTransparency = 1
    Info.Text = "🔴 Murderer   |   🔵 Sheriff\nESP detecta Knife/Gun no Backpack ou Character."
    Info.TextColor3 = Color3.fromRGB(220,220,220)
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 14
    Info.TextWrapped = true
    Info.Parent = Main

end)
