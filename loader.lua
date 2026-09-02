--// TEST HUB - PAINEL COMPLETO
--// Para uso no seu próprio jogo/teste
--// Key: Rlltxw

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Settings = {
    PlayerESP = false,
    SheriffESP = false,
    MurdererESP = false,
    AimAssist = false,
    Noclip = false,
    InfiniteJump = false
}

local KEY = "Rlltxw"

--==================================================
-- KEY SYSTEM
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TestHubKey"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(300, 180)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "TEST HUB"
KeyTitle.TextColor3 = Color3.fromRGB(255, 80, 180)
KeyTitle.TextSize = 24
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.fromOffset(20, 60)
KeyBox.PlaceholderText = "Digite a Key"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.Parent = KeyFrame

Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1, -40, 0, 40)
Enter.Position = UDim2.fromOffset(20, 115)
Enter.Text = "ENTRAR"
Enter.TextColor3 = Color3.new(1, 1, 1)
Enter.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 16
Enter.Parent = KeyFrame

Instance.new("UICorner", Enter).CornerRadius = UDim.new(0, 8)

--==================================================
-- PAINEL
--==================================================

local function CreatePanel()

    KeyGui:Destroy()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TestHub"
    Gui.ResetOnSpawn = false
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(330, 400)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Main.Parent = Gui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 70, 180)
    Stroke.Thickness = 2
    Stroke.Parent = Main

    --==================================================
    -- DRAG
    --==================================================

    local dragging = false
    local dragStart
    local startPos

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = Main.Position

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
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    --==================================================
    -- TITLE
    --==================================================

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 0, 50)
    Title.Position = UDim2.fromOffset(15, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "TEST HUB"
    Title.TextColor3 = Color3.fromRGB(255, 80, 180)
    Title.TextSize = 23
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    --==================================================
    -- CLOSE
    --==================================================

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(40, 40)
    Close.Position = UDim2.new(1, -48, 0, 10)
    Close.Text = "×"
    Close.TextSize = 28
    Close.TextColor3 = Color3.new(1, 1, 1)
    Close.BackgroundColor3 = Color3.fromRGB(150, 35, 80)
    Close.Parent = Main

    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

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
    -- SCROLL
    --==================================================

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -20, 1, -65)
    Scroll.Position = UDim2.fromOffset(10, 60)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 4
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = Scroll

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 10
        )
    end)

    --==================================================
    -- BUTTON
    --==================================================

    local function AddButton(text, setting)

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0, 45)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.TextSize = 16
        Button.Font = Enum.Font.GothamBold
        Button.Text = text .. " [OFF]"
        Button.Parent = Scroll

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 9)

        local function Update()

            if Settings[setting] then
                Button.Text = text .. " [ON]"
                Button.BackgroundColor3 = Color3.fromRGB(180, 40, 130)
            else
                Button.Text = text .. " [OFF]"
                Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            end

        end

        Button.MouseButton1Click:Connect(function()
            Settings[setting] = not Settings[setting]
            Update()
        end)

        return Button
    end

    AddButton("Player ESP", "PlayerESP")
    AddButton("Sheriff ESP", "SheriffESP")
    AddButton("Murderer ESP", "MurdererESP")
    AddButton("Aim Assist", "AimAssist")
    AddButton("Noclip", "Noclip")
    AddButton("Infinite Jump", "InfiniteJump")

    --==================================================
    -- ROLE DETECTION
    -- MESMA IDEIA DO YAMA
    --==================================================

    local function HasRoleMarker(character, role)

        if not character then
            return false
        end

        local names

        if role == "Murderer" then
            names = {
                "MurdererPowers",
                "Murderer",
                "MurdererRole"
            }

        elseif role == "Sheriff" then
            names = {
                "SheriffPowers",
                "Sheriff",
                "SheriffRole"
            }
        end

        for _, name in ipairs(names) do
            if character:FindFirstChild(name) then
                return true
            end
        end

        return false
    end

    local function GetMurderer()

        for _, player in ipairs(Players:GetPlayers()) do

            if HasRoleMarker(player.Character, "Murderer") then
                return player
            end

        end

        return nil
    end

    local function GetSheriff()

        for _, player in ipairs(Players:GetPlayers()) do

            if HasRoleMarker(player.Character, "Sheriff") then
                return player
            end

        end

        return nil
    end

    --==================================================
    -- ESP
    --==================================================

    local Highlights = {}

    local function RemoveESP(player)

        if Highlights[player] then
            Highlights[player]:Destroy()
            Highlights[player] = nil
        end

    end

    local function CreateESP(player)

        if player == LocalPlayer then
            return
        end

        if not player.Character then
            return
        end

        RemoveESP(player)

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "TestHubESP"
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = 0.45
        Highlight.OutlineTransparency = 0
        Highlight.Parent = player.Character

        Highlights[player] = Highlight
    end

    local function UpdateESP()

        local murderer = GetMurderer()
        local sheriff = GetSheriff()

        for _, player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer and player.Character then

                if not Highlights[player] then
                    CreateESP(player)
                end

                local highlight = Highlights[player]

                if Settings.MurdererESP and player == murderer then

                    highlight.Enabled = true
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)

                elseif Settings.SheriffESP and player == sheriff then

                    highlight.Enabled = true
                    highlight.FillColor = Color3.fromRGB(0, 120, 255)
                    highlight.OutlineColor = Color3.fromRGB(0, 120, 255)

                elseif Settings.PlayerESP then

                    highlight.Enabled = true
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)

                else

                    highlight.Enabled = false

                end

            end
        end
    end

    Players.PlayerRemoving:Connect(RemoveESP)

    Players.PlayerAdded:Connect(function(player)

        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            CreateESP(player)
        end)

    end)

    --==================================================
    -- NOCLIP
    --==================================================

    RunService.Stepped:Connect(function()

        if Settings.Noclip then

            local character = LocalPlayer.Character

            if character then

                for _, part in ipairs(character:GetDescendants()) do

                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end

                end
            end
        end
    end)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    UserInputService.JumpRequest:Connect(function()

        if Settings.InfiniteJump then

            local character = LocalPlayer.Character

            if character then

                local humanoid =
                    character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid:ChangeState(
                        Enum.HumanoidStateType.Jumping
                    )
                end

            end
        end
    end)

    --==================================================
    -- AIM ASSIST
    -- SOMENTE ALVOS DO SEU JOGO
    --==================================================

    local function GetClosestTarget()

        local character = LocalPlayer.Character
        if not character then
            return nil
        end

        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then
            return nil
        end

        local closest
        local distance = math.huge

        for _, player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer and player.Character then

                local targetRoot =
                    player.Character:FindFirstChild("HumanoidRootPart")

                local humanoid =
                    player.Character:FindFirstChildOfClass("Humanoid")

                if targetRoot and humanoid and humanoid.Health > 0 then

                    local d =
                        (targetRoot.Position - root.Position).Magnitude

                    if d < distance then
                        distance = d
                        closest = targetRoot
                    end

                end
            end
        end

        return closest
    end

    RunService.RenderStepped:Connect(function()

        UpdateESP()

        if Settings.AimAssist then

            local target = GetClosestTarget()

            if target then

                local camera = workspace.CurrentCamera

                camera.CFrame = CFrame.lookAt(
                    camera.CFrame.Position,
                    target.Position
                )

            end
        end
    end)

end

--==================================================
-- VALIDAR KEY
--==================================================

Enter.MouseButton1Click:Connect(function()

    if KeyBox.Text == KEY then

        CreatePanel()

    else

        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key incorreta!"
    end

end)
