--// MM2 COPY HUB
--// Para sua própria cópia/teste
--// Key: Rlltxw

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local KEY = "Rlltxw"

local Settings = {
    PlayerESP = false,
    SheriffESP = false,
    MurdererESP = false,
    AimAssist = false,
    Noclip = false,
    InfiniteJump = false
}

--==================================================
-- KEY
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "MM2CopyKey"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(310, 190)
KeyFrame.Position = UDim2.fromScale(.5, .5)
KeyFrame.AnchorPoint = Vector2.new(.5, .5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(17,17,24)
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "MM2 COPY HUB"
Title.TextColor3 = Color3.fromRGB(255,70,180)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1,-40,0,42)
KeyBox.Position = UDim2.fromOffset(20,60)
KeyBox.PlaceholderText = "Digite a Key"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.Parent = KeyFrame

Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,8)

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1,-40,0,42)
Enter.Position = UDim2.fromOffset(20,120)
Enter.Text = "ENTRAR"
Enter.TextColor3 = Color3.new(1,1,1)
Enter.BackgroundColor3 = Color3.fromRGB(180,40,130)
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 16
Enter.Parent = KeyFrame

Instance.new("UICorner", Enter).CornerRadius = UDim.new(0,8)

--==================================================
-- PAINEL
--==================================================

local function CreateHub()

    KeyGui:Destroy()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "MM2CopyHub"
    Gui.ResetOnSpawn = false
    Gui.Parent = LocalPlayer.PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(340,420)
    Main.Position = UDim2.fromScale(.5,.5)
    Main.AnchorPoint = Vector2.new(.5,.5)
    Main.BackgroundColor3 = Color3.fromRGB(15,15,22)
    Main.Parent = Gui

    Instance.new("UICorner",Main).CornerRadius = UDim.new(0,14)

    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(255,70,180)
    Border.Thickness = 2
    Border.Parent = Main

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

    local HubTitle = Instance.new("TextLabel")
    HubTitle.Size = UDim2.new(1,-60,0,50)
    HubTitle.Position = UDim2.fromOffset(15,5)
    HubTitle.BackgroundTransparency = 1
    HubTitle.Text = "MM2 COPY HUB"
    HubTitle.TextColor3 = Color3.fromRGB(255,70,180)
    HubTitle.Font = Enum.Font.GothamBold
    HubTitle.TextSize = 22
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left
    HubTitle.Parent = Main

    --==================================================
    -- FECHAR
    --==================================================

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(40,40)
    Close.Position = UDim2.new(1,-50,0,10)
    Close.Text = "×"
    Close.TextSize = 28
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
    -- SCROLL
    --==================================================

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1,-20,1,-65)
    Scroll.Position = UDim2.fromOffset(10,60)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 4
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
    Scroll.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = Scroll

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

        Scroll.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 10
        )

    end)

    --==================================================
    -- BOTÕES
    --==================================================

    local function AddButton(text,setting)

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1,-10,0,45)
        Button.Text = text.." [OFF]"
        Button.TextColor3 = Color3.new(1,1,1)
        Button.TextSize = 16
        Button.Font = Enum.Font.GothamBold
        Button.BackgroundColor3 = Color3.fromRGB(30,30,40)
        Button.Parent = Scroll

        Instance.new("UICorner",Button).CornerRadius = UDim.new(0,9)

        Button.MouseButton1Click:Connect(function()

            Settings[setting] = not Settings[setting]

            if Settings[setting] then

                Button.Text = text.." [ON]"
                Button.BackgroundColor3 =
                    Color3.fromRGB(180,40,130)

            else

                Button.Text = text.." [OFF]"
                Button.BackgroundColor3 =
                    Color3.fromRGB(30,30,40)

            end

        end)

    end

    AddButton("Player ESP","PlayerESP")
    AddButton("Sheriff ESP","SheriffESP")
    AddButton("Murderer ESP","MurdererESP")
    AddButton("Aim Assist","AimAssist")
    AddButton("Noclip","Noclip")
    AddButton("Infinite Jump","InfiniteJump")

    --==================================================
    -- DETECÇÃO IGUAL À IDEIA DO YAMA
    --==================================================

    local function GetMurderer()

        for _,player in ipairs(Players:GetPlayers()) do

            local character = player.Character

            if character and
            character:FindFirstChild("MurdererPowers") then

                return player

            end

        end

        return nil
    end

    local function GetSheriff()

        for _,player in ipairs(Players:GetPlayers()) do

            local character = player.Character

            if character and
            character:FindFirstChild("SheriffPowers") then

                return player

            end

        end

        return nil
    end

    --==================================================
    -- ESP
    --==================================================

    local ESP = {}

    local function RemoveESP(player)

        if ESP[player] then
            ESP[player]:Destroy()
            ESP[player] = nil
        end

    end

    local function MakeESP(player)

        if player == LocalPlayer then
            return
        end

        if not player.Character then
            return
        end

        RemoveESP(player)

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "MM2CopyESP"
        Highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        Highlight.FillTransparency = .45
        Highlight.OutlineTransparency = 0
        Highlight.Parent = player.Character

        ESP[player] = Highlight

    end

    local function UpdateESP()

        local murderer = GetMurderer()
        local sheriff = GetSheriff()

        for _,player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer
            and player.Character then

                if not ESP[player] then
                    MakeESP(player)
                end

                local highlight = ESP[player]

                if Settings.MurdererESP
                and player == murderer then

                    highlight.Enabled = true
                    highlight.FillColor =
                        Color3.fromRGB(255,0,0)

                    highlight.OutlineColor =
                        Color3.fromRGB(255,0,0)

                elseif Settings.SheriffESP
                and player == sheriff then

                    highlight.Enabled = true
                    highlight.FillColor =
                        Color3.fromRGB(0,120,255)

                    highlight.OutlineColor =
                        Color3.fromRGB(0,120,255)

                elseif Settings.PlayerESP then

                    highlight.Enabled = true
                    highlight.FillColor =
                        Color3.fromRGB(0,255,0)

                    highlight.OutlineColor =
                        Color3.fromRGB(0,255,0)

                else

                    highlight.Enabled = false

                end

            end

        end

    end

    --==================================================
    -- NOCLIP
    --==================================================

    RunService.Stepped:Connect(function()

        if not Settings.Noclip then
            return
        end

        local character = LocalPlayer.Character

        if character then

            for _,part in ipairs(character:GetDescendants()) do

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

        if not Settings.InfiniteJump then
            return
        end

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

    end)

    --==================================================
    -- AIM ASSIST
    --==================================================

    local function GetClosestPlayer()

        local character = LocalPlayer.Character

        if not character then
            return nil
        end

        local root =
            character:FindFirstChild("HumanoidRootPart")

        if not root then
            return nil
        end

        local closest
        local shortest = math.huge

        for _,player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer
            and player.Character then

                local targetRoot =
                    player.Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if targetRoot then

                    local distance =
                        (targetRoot.Position -
                        root.Position).Magnitude

                    if distance < shortest then

                        shortest = distance
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

            local target = GetClosestPlayer()

            if target then

                local camera = workspace.CurrentCamera

                camera.CFrame = CFrame.lookAt(
                    camera.CFrame.Position,
                    target.Position
                )

            end

        end

    end)

    Players.PlayerRemoving:Connect(RemoveESP)

    Players.PlayerAdded:Connect(function(player)

        player.CharacterAdded:Connect(function()

            task.wait(.5)
            MakeESP(player)

        end)

    end)

end

--==================================================
-- VALIDAR KEY
--==================================================

Enter.MouseButton1Click:Connect(function()

    if KeyBox.Text == KEY then

        CreateHub()

    else

        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key incorreta!"

    end

end)
