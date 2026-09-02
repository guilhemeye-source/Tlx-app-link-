--// TLX HUB - PARA SEU PRÓPRIO JOGO
--// Key: Rlltxw

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local KEY = "Rlltxw"

local Settings = {
    ESP = false,
    SheriffESP = false,
    MurdererESP = false,
    AimAssist = false,
    Noclip = false,
    InfiniteJump = false
}

--==================================================
-- KEY SYSTEM
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "TLX_Key"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(300, 170)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.Parent = KeyGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "TLX HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = KeyFrame

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(1, -40, 0, 45)
Box.Position = UDim2.fromOffset(20, 60)
Box.PlaceholderText = "Digite a Key"
Box.Text = ""
Box.TextSize = 17
Box.Font = Enum.Font.Gotham
Box.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Box.TextColor3 = Color3.new(1,1,1)
Box.Parent = KeyFrame

Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.new(1, -40, 0, 35)
Enter.Position = UDim2.fromOffset(20, 115)
Enter.Text = "ENTRAR"
Enter.TextSize = 16
Enter.Font = Enum.Font.GothamBold
Enter.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
Enter.TextColor3 = Color3.new(1,1,1)
Enter.Parent = KeyFrame

Instance.new("UICorner", Enter).CornerRadius = UDim.new(0, 10)

--==================================================
-- MAIN GUI
--==================================================

local function CreateMain()
    KeyGui:Destroy()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TLX_HUB"
    Gui.ResetOnSpawn = false
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(330, 390)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
    Main.Parent = Gui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

    -- Cabeçalho
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -50, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Text = "⚡ TLX HUB"
    Header.TextColor3 = Color3.new(1,1,1)
    Header.TextSize = 21
    Header.Font = Enum.Font.GothamBold
    Header.Parent = Main

    -- Fechar/minimizar
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.fromOffset(40, 40)
    Minimize.Position = UDim2.new(1, -45, 0, 5)
    Minimize.Text = "—"
    Minimize.TextSize = 25
    Minimize.BackgroundTransparency = 1
    Minimize.TextColor3 = Color3.new(1,1,1)
    Minimize.Parent = Main

    -- Container
    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, -20, 1, -60)
    List.Position = UDim2.fromOffset(10, 55)
    List.BackgroundTransparency = 1
    List.ScrollBarThickness = 4
    List.CanvasSize = UDim2.new()
    List.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = List

    local function AddButton(Name, Setting)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0, 43)
        Button.Text = Name .. ": OFF"
        Button.TextSize = 16
        Button.Font = Enum.Font.GothamBold
        Button.TextColor3 = Color3.new(1,1,1)
        Button.BackgroundColor3 = Color3.fromRGB(35,35,42)
        Button.Parent = List

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 10)

        Button.MouseButton1Click:Connect(function()
            Settings[Setting] = not Settings[Setting]

            Button.Text = Name .. (Settings[Setting] and ": ON" or ": OFF")

            if Settings[Setting] then
                Button.BackgroundColor3 = Color3.fromRGB(70,70,150)
            else
                Button.BackgroundColor3 = Color3.fromRGB(35,35,42)
            end
        end)
    end

    AddButton("👁️ ESP", "ESP")
    AddButton("🔵 Sheriff ESP", "SheriffESP")
    AddButton("🔴 Murderer ESP", "MurdererESP")
    AddButton("🎯 Aim Assist", "AimAssist")
    AddButton("🚪 Noclip", "Noclip")
    AddButton("♾️ Infinite Jump", "InfiniteJump")

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        List.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 10
        )
    end)

    --==================================================
    -- BOTÃO FLUTUANTE
    --==================================================

    local OpenButton = Instance.new("TextButton")
    OpenButton.Size = UDim2.fromOffset(55,55)
    OpenButton.Position = UDim2.fromOffset(20,250)
    OpenButton.Text = "⚡"
    OpenButton.TextSize = 25
    OpenButton.BackgroundColor3 = Color3.fromRGB(30,30,35)
    OpenButton.TextColor3 = Color3.new(1,1,1)
    OpenButton.Visible = false
    OpenButton.Parent = Gui

    Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1,0)

    Minimize.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenButton.Visible = true
    end)

    OpenButton.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenButton.Visible = false
    end)

    --==================================================
    -- PAINEL ARRASTÁVEL
    --==================================================

    local dragging = false
    local dragStart
    local startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
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

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    --==================================================
    -- DETECÇÃO AUTOMÁTICA DE ROLE
    --==================================================

    local function GetRole(Player)
        -- Team
        if Player.Team then
            local TeamName = string.lower(Player.Team.Name)

            if TeamName:find("sheriff") then
                return "Sheriff"
            end

            if TeamName:find("murder") then
                return "Murderer"
            end
        end

        -- Attribute
        local RoleAttribute = Player:GetAttribute("Role")

        if typeof(RoleAttribute) == "string" then
            local Role = string.lower(RoleAttribute)

            if Role:find("sheriff") then
                return "Sheriff"
            end

            if Role:find("murder") then
                return "Murderer"
            end
        end

        -- StringValue / Role
        local RoleObject = Player:FindFirstChild("Role")

        if RoleObject and RoleObject:IsA("StringValue") then
            local Role = string.lower(RoleObject.Value)

            if Role:find("sheriff") then
                return "Sheriff"
            end

            if Role:find("murder") then
                return "Murderer"
            end
        end

        -- Ferramentas
        local Character = Player.Character

        if Character then
            for _, Object in ipairs(Character:GetChildren()) do
                if Object:IsA("Tool") then
                    local Name = string.lower(Object.Name)

                    if Name:find("gun")
                    or Name:find("sheriff")
                    or Name:find("revolver") then
                        return "Sheriff"
                    end

                    if Name:find("knife")
                    or Name:find("murder") then
                        return "Murderer"
                    end
                end
            end
        end

        return "Player"
    end

    --==================================================
    -- ESP
    --==================================================

    local function AddESP(Player)
        if Player == LocalPlayer then
            return
        end

        local Character = Player.Character
        if not Character then return end

        local Old = Character:FindFirstChild("TLX_ESP")
        if Old then
            Old:Destroy()
        end

        local Role = GetRole(Player)

        local Show = Settings.ESP

        if Role == "Sheriff" and Settings.SheriffESP then
            Show = true
        end

        if Role == "Murderer" and Settings.MurdererESP then
            Show = true
        end

        if not Show then
            return
        end

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "TLX_ESP"
        Highlight.FillTransparency = 0.65
        Highlight.OutlineTransparency = 0

        if Role == "Sheriff" then
            Highlight.FillColor = Color3.fromRGB(40,120,255)
            Highlight.OutlineColor = Color3.fromRGB(40,120,255)

        elseif Role == "Murderer" then
            Highlight.FillColor = Color3.fromRGB(255,50,50)
            Highlight.OutlineColor = Color3.fromRGB(255,50,50)

        else
            Highlight.FillColor = Color3.fromRGB(255,255,255)
            Highlight.OutlineColor = Color3.fromRGB(255,255,255)
        end

        Highlight.Parent = Character
    end

    local function UpdateESP()
        for _, Player in ipairs(Players:GetPlayers()) do
            AddESP(Player)
        end
    end

    --==================================================
    -- NOCLIP
    --==================================================

    RunService.Stepped:Connect(function()
        if not Settings.Noclip then
            return
        end

        local Character = LocalPlayer.Character
        if not Character then return end

        for _, Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
    end)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    UIS.JumpRequest:Connect(function()
        if Settings.InfiniteJump then
            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    --==================================================
    -- AIM ASSIST
    --==================================================

    local function GetClosestPlayer()
        local Closest
        local Distance = math.huge

        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then

                local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                local Root = Player.Character:FindFirstChild("HumanoidRootPart")

                if Humanoid and Root and Humanoid.Health > 0 then

                    local Position, Visible =
                        Camera:WorldToViewportPoint(Root.Position)

                    if Visible then
                        local Center =
                            Vector2.new(
                                Camera.ViewportSize.X / 2,
                                Camera.ViewportSize.Y / 2
                            )

                        local Difference =
                            (Vector2.new(Position.X, Position.Y) - Center).Magnitude

                        if Difference < Distance then
                            Distance = Difference
                            Closest = Root
                        end
                    end
                end
            end
        end

        return Closest
    end

    RunService.RenderStepped:Connect(function()
        if not Settings.AimAssist then
            return
        end

        local Target = GetClosestPlayer()

        if Target then
            Camera.CFrame = CFrame.lookAt(
                Camera.CFrame.Position,
                Target.Position
            )
        end
    end)

    -- Atualiza ESP periodicamente
    task.spawn(function()
        while Gui.Parent do
            UpdateESP()
            task.wait(1)
        end
    end)

    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function()
            task.wait(1)
            AddESP(Player)
        end)
    end)
end

--==================================================
-- VALIDAR KEY
--==================================================

Enter.MouseButton1Click:Connect(function()
    if Box.Text == KEY then
        CreateMain()
    else
        Box.Text = ""
        Box.PlaceholderText = "Key incorreta!"
    end
end)

Box.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        if Box.Text == KEY then
            CreateMain()
        end
    end
end)
