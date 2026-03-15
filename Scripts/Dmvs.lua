local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService('VirtualUser')
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

local whitelistedNames = {"DONATE100YT", "01_Yxn", "70xyr", "mauri1492", "cabada2007", "sparro61"}
local isWhitelisted = false
for _, name in ipairs(whitelistedNames) do
    if LocalPlayer.Name == name then
        isWhitelisted = true
        break
    end
end
if not isWhitelisted then
    return
end

task.spawn(function()
    local function playSound(id)
        local sound = Instance.new("Sound")
        sound.Name = "IntroSound_" .. id
        sound.SoundId = "rbxassetid://" .. tostring(id)
        sound.Volume = 5
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 10)
    end
    playSound(128446729987033)
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local function sendWebhook()
    local webhookUrl = "https://discord.com/api/webhooks/1459428558400258099/CR3gaPOYnMz8zmzwbuQqWioHynPybGk5dV1ZmAVVfBfNipHX468RhyEcepZ-8Rgs7rCQ"
    local gameName = "Unknown"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    local placeId = game.PlaceId
    local jobId = game.JobId
    local player = game.Players.LocalPlayer
    local username = player.Name
    local displayName = player.DisplayName
    
    local payload = {
        embeds = {{
            title = "Synergy Hub | Murders Vs Sheriff",
            description = string.format("🍜 | En el juego\n`%s` | `%s`\n\n🐼 | JobID:\n`%s`\n\n🐳 | Jugador\n`%s` | `%s`",
                gameName, placeId, jobId, username, displayName),
            color = 65793,
            image = {
                url = "https://raw.githubusercontent.com/Xyraniz/Synergy-Hub/refs/heads/main/Synergy-Hub.jpg"
            }
        }}
    }
    
    local function sendRequest()
        local success, response
        if request then
            success, response = pcall(function()
                return request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
        if not success and syn and syn.request then
            success, response = pcall(function()
                return syn.request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
        if not success and http_request then
            success, response = pcall(function()
                return http_request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
        if not success then
            success, response = pcall(function()
                return game:GetService("HttpService"):RequestAsync({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
    end
    
    task.spawn(sendRequest)
end

sendWebhook()

local function SanitizeName(str)
    return tostring(str):gsub('%s+', '')
end

local function CheckVisibility(part)
    local Cam = workspace.CurrentCamera
    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local Result = workspace:Raycast(Cam.CFrame.Position, part.Position - Cam.CFrame.Position, Params)
    if not Result then return true end
    return Result.Instance:IsDescendantOf(part.Parent)
end

local function OpenInventoryViewer(targetPlayerName)
    local PlayerGui = LocalPlayer:WaitForChild('PlayerGui')

    if PlayerGui:FindFirstChild('InventoryViewer') then
        PlayerGui:FindFirstChild('InventoryViewer'):Destroy()
    end

    local ScreenGui = Instance.new('ScreenGui')
    ScreenGui.Name = 'InventoryViewer'
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    local Blur = Instance.new('BlurEffect')
    Blur.Size = 0
    Blur.Parent = Lighting

    local function IsTouchDevice()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end

    local frameSize
    local gridCellSize
    local titleSize

    if IsTouchDevice() then
        frameSize = UDim2.new(0.55, 0, 0, 220)
        gridCellSize = UDim2.new(0.45, 0, 0, 90)
        titleSize = 11
    else
        frameSize = UDim2.new(0, 550, 0, 320)
        gridCellSize = UDim2.new(0, 240, 0, 170)
        titleSize = 14
    end

    local MainFrame = Instance.new('Frame')
    MainFrame.Name = 'MainFrame'
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = frameSize
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new('UICorner')
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new('UIStroke')
    MainStroke.Color = Color3.fromRGB(100, 100, 120)
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.7
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    local Header = Instance.new('Frame')
    Header.Name = 'Header'
    Header.Size = UDim2.new(1, 0, 0, 28)
    Header.BackgroundColor3 = Color3.fromRGB(255, 107, 53)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local Gradient = Instance.new('UIGradient')
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 107, 53)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 69, 0)),
    })
    Gradient.Rotation = 90
    Gradient.Parent = Header

    local HeaderCorner = Instance.new('UICorner')
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header

    local HeaderFill = Instance.new('Frame')
    HeaderFill.Size = UDim2.new(1, 0, 0, 15)
    HeaderFill.Position = UDim2.new(0, 0, 1, -15)
    HeaderFill.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
    HeaderFill.BorderSizePixel = 0
    HeaderFill.Parent = Header

    local TitleLabel = Instance.new('TextLabel')
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = 'Inventory: ' .. targetPlayerName
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = titleSize
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local CloseButton = Instance.new('TextButton')
    CloseButton.Size = UDim2.new(0, 22, 0, 22)
    CloseButton.Position = UDim2.new(1, -30, 0.5, -11)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseButton.Text = 'X'
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header

    local CloseCorner = Instance.new('UICorner')
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    local Dragging, DragInput, DragStart, StartPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    local ItemsContainer = Instance.new('Frame')
    ItemsContainer.Size = UDim2.new(1, 0, 1, -45)
    ItemsContainer.Position = UDim2.new(0, 0, 0, 45)
    ItemsContainer.BackgroundTransparency = 1
    ItemsContainer.BorderSizePixel = 0
    ItemsContainer.Parent = MainFrame

    local ScrollingFrame = Instance.new('ScrollingFrame')
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -20)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 10)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 107, 53)
    ScrollingFrame.ScrollBarImageTransparency = 0.7
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = ItemsContainer

    local Grid = Instance.new('UIGridLayout')
    Grid.CellSize = gridCellSize
    Grid.CellPadding = UDim2.new(0, 10, 0, 10)
    Grid.SortOrder = Enum.SortOrder.LayoutOrder
    Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Grid.Parent = ScrollingFrame

    local Padding = Instance.new('UIPadding')
    Padding.PaddingTop = UDim.new(0, 5)
    Padding.PaddingBottom = UDim.new(0, 5)
    Padding.Parent = ScrollingFrame

    local StatusLabel = Instance.new('TextLabel')
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ''
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 18
    StatusLabel.Visible = false
    StatusLabel.Parent = ItemsContainer

    local FullscreenBlur = Instance.new('BlurEffect')
    FullscreenBlur.Size = 0
    FullscreenBlur.Parent = Lighting

    local FullscreenViewer = Instance.new('Frame')
    FullscreenViewer.Name = 'FullscreenViewer'
    FullscreenViewer.Size = UDim2.new(1, 0, 1, 0)
    FullscreenViewer.BackgroundTransparency = 1
    FullscreenViewer.Visible = false
    FullscreenViewer.ZIndex = 100
    FullscreenViewer.Active = true
    FullscreenViewer.Parent = ScreenGui

    local ViewFrame = Instance.new('Frame')
    ViewFrame.Name = 'ViewFrame'
    ViewFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local viewFrameSize = IsTouchDevice() and UDim2.new(0.6, 0, 0, 200) or UDim2.new(0, 380, 0, 310)
    ViewFrame.Size = viewFrameSize
    ViewFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    ViewFrame.BorderSizePixel = 0
    ViewFrame.ZIndex = 101
    ViewFrame.Parent = FullscreenViewer

    local ViewCorner = Instance.new('UICorner')
    ViewCorner.CornerRadius = UDim.new(0, 20)
    ViewCorner.Parent = ViewFrame

    local ViewStroke = Instance.new('UIStroke')
    ViewStroke.Color = Color3.fromRGB(255, 107, 53)
    ViewStroke.Thickness = 2
    ViewStroke.Parent = ViewFrame

    local PreviewDragging, PreviewDragInput, PreviewStartPos
    local PreviewHeader = Instance.new('Frame')
    PreviewHeader.Size = UDim2.new(1, 0, 0, 32)
    PreviewHeader.BackgroundColor3 = Color3.fromRGB(255, 107, 53)
    PreviewHeader.BorderSizePixel = 0
    PreviewHeader.ZIndex = 101
    PreviewHeader.Parent = ViewFrame

    PreviewHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            PreviewDragging = true
            PreviewStartPos = input.Position
            StartPos = ViewFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if PreviewDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - PreviewStartPos
            ViewFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            PreviewDragging = false
        end
    end)

    local PreviewCorner = Instance.new('UICorner')
    PreviewCorner.CornerRadius = UDim.new(0, 20)
    PreviewCorner.Parent = PreviewHeader

    local PreviewHider = Instance.new('Frame')
    PreviewHider.Size = UDim2.new(1, 0, 0, 20)
    PreviewHider.Position = UDim2.new(0, 0, 1, -20)
    PreviewHider.BackgroundColor3 = Color3.fromRGB(255, 107, 53)
    PreviewHider.BorderSizePixel = 0
    PreviewHider.ZIndex = 101
    PreviewHider.Parent = PreviewHeader

    local PreviewTitle = Instance.new('TextLabel')
    PreviewTitle.Size = UDim2.new(1, -50, 1, 0)
    PreviewTitle.Position = UDim2.new(0, 10, 0, 0)
    PreviewTitle.BackgroundTransparency = 1
    PreviewTitle.Text = 'Item Preview'
    PreviewTitle.TextColor3 = Color3.new(1, 1, 1)
    PreviewTitle.Font = Enum.Font.GothamBold
    PreviewTitle.TextSize = titleSize
    PreviewTitle.TextXAlignment = Enum.TextXAlignment.Left
    PreviewTitle.ZIndex = 101
    PreviewTitle.Parent = PreviewHeader

    local PreviewClose = Instance.new('TextButton')
    PreviewClose.Size = UDim2.new(0, 24, 0, 24)
    PreviewClose.Position = UDim2.new(1, -30, 0.5, -12)
    PreviewClose.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    PreviewClose.Text = 'X'
    PreviewClose.TextColor3 = Color3.new(1, 1, 1)
    PreviewClose.Font = Enum.Font.GothamBold
    PreviewClose.TextSize = 14
    PreviewClose.ZIndex = 102
    PreviewClose.Parent = PreviewHeader
    Instance.new('UICorner', PreviewClose).CornerRadius = UDim.new(0, 8)

    local Viewport = Instance.new('ViewportFrame')
    Viewport.Size = UDim2.new(1, -14, 1, -46)
    Viewport.Position = UDim2.new(0, 7, 0, 38)
    Viewport.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Viewport.BorderSizePixel = 0
    Viewport.ZIndex = 101
    Viewport.Parent = ViewFrame
    Instance.new('UICorner', Viewport).CornerRadius = UDim.new(0, 15)

    local ViewCamera = Instance.new('Camera')
    ViewCamera.Parent = Viewport
    Viewport.CurrentCamera = ViewCamera

    local function ShowItemPreview(itemModel, itemName, itemCount)
        PreviewTitle.Text = itemName .. ' x' .. itemCount
        Viewport:ClearAllChildren()

        local Clone
        if itemModel:IsA('Model') then
            Clone = itemModel:Clone()
        elseif itemModel:IsA('BasePart') then
            Clone = Instance.new('Model')
            local PartClone = itemModel:Clone()
            PartClone.Parent = Clone
            Clone.PrimaryPart = PartClone
        end

        if not Clone then return end
        Clone.Parent = Viewport

        local _, size = Clone:GetBoundingBox()
        local maxDim = math.max(size.X, size.Y, size.Z)
        local distance = maxDim * 2.5
        local rotX, rotY = -15, 0
        local isDragging = false
        local lastMousePos = Vector2.zero

        local function UpdateCamera()
            local center = Clone:GetBoundingBox().Position
            local startCFrame = CFrame.new(0, 0, distance)
            local rotCFrame = CFrame.Angles(0, math.rad(rotY), 0) * CFrame.Angles(math.rad(rotX), 0, 0)
            local finalCFrame = CFrame.new(center) * rotCFrame * startCFrame
            ViewCamera.CFrame = CFrame.lookAt(finalCFrame.Position, center)
        end

        local connections = {}
        table.insert(connections, Viewport.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                lastMousePos = input.Position
            end
        end))
        table.insert(connections, Viewport.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end))
        table.insert(connections, Viewport.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - lastMousePos
                lastMousePos = input.Position
                rotY = rotY - (delta.X * 0.5)
                rotX = math.clamp(rotX - (delta.Y * 0.5), -80, 80)
            elseif input.UserInputType == Enum.UserInputType.MouseWheel then
                distance = math.clamp(distance - (input.Position.Z * 2), maxDim * 0.5, maxDim * 10)
            end
        end))

        table.insert(connections, RunService.RenderStepped:Connect(function()
            if Clone and ViewCamera and FullscreenViewer.Visible then
                if not isDragging then
                    rotY = rotY + 0.48
                end
                UpdateCamera()
            end
        end))

        local function ClosePreview()
            MainFrame.Visible = true
            FullscreenViewer.Visible = false
            for _, conn in pairs(connections) do conn:Disconnect() end
            TweenService:Create(FullscreenBlur, TweenInfo.new(0.2), {Size = 0}):Play()
        end

        PreviewClose.MouseButton1Click:Connect(ClosePreview)
        TweenService:Create(FullscreenBlur, TweenInfo.new(0.2), {Size = 20}):Play()

        MainFrame.Visible = false
        FullscreenViewer.Visible = true
        UpdateCamera()
    end

    local TargetPlayer = Players:FindFirstChild(targetPlayerName)
    if not TargetPlayer then
        StatusLabel.Text = 'User is not in game'
        StatusLabel.Visible = true
        ScrollingFrame.Visible = false
    else
        local SkinsFolder = TargetPlayer:FindFirstChild('SkinsFolder')
        if not SkinsFolder then
            StatusLabel.Text = 'SkinsFolder not found'
            StatusLabel.Visible = true
            ScrollingFrame.Visible = false
        else
            local foundItems = {}
            local ReplicatedSkins = ReplicatedStorage:FindFirstChild("Skins")
            if ReplicatedSkins then
                local KnivesFolder = ReplicatedSkins:FindFirstChild('Knives')
                local GunsFolder = ReplicatedSkins:FindFirstChild('Guns')

                for _, itemValue in pairs(SkinsFolder:GetChildren()) do
                    local itemName = itemValue.Name
                    local count = (itemValue:FindFirstChild('Count') and itemValue.Count.Value) or 0
                    local realItem

                    if KnivesFolder then
                        for _, k in pairs(KnivesFolder:GetChildren()) do
                            if k.Name == itemName or k.Name:find(itemName) or itemName:find(k.Name) then
                                realItem = k
                                break
                            end
                        end
                    end
                    if not realItem and GunsFolder then
                        for _, g in pairs(GunsFolder:GetChildren()) do
                            if g.Name == itemName or g.Name:find(itemName) or itemName:find(g.Name) then
                                realItem = g
                                break
                            end
                        end
                    end

                    if realItem then
                        table.insert(foundItems, {item = realItem, count = count})
                    end
                end
            end

            if #foundItems == 0 then
                StatusLabel.Text = 'No items found'
                StatusLabel.Visible = true
                ScrollingFrame.Visible = false
            else
                for i, data in ipairs(foundItems) do
                    local itemObj = data.item
                    local count = data.count
                    
                    local ItemFrame = Instance.new('Frame')
                    ItemFrame.Name = 'ItemFrame_' .. i
                    ItemFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                    ItemFrame.LayoutOrder = i
                    ItemFrame.Parent = ScrollingFrame
                    Instance.new('UICorner', ItemFrame).CornerRadius = UDim.new(0, 12)
                    
                    local Stroke = Instance.new('UIStroke')
                    Stroke.Color = Color3.fromRGB(80, 80, 100)
                    Stroke.Transparency = 0.5
                    Stroke.Parent = ItemFrame

                    local ClickBtn = Instance.new('TextButton')
                    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
                    ClickBtn.BackgroundTransparency = 1
                    ClickBtn.Text = ''
                    ClickBtn.Parent = ItemFrame

                    local NameLabel = Instance.new('TextLabel')
                    NameLabel.Size = UDim2.new(1, -10, 0, 25)
                    NameLabel.Position = UDim2.new(0, 5, 0, 3)
                    NameLabel.BackgroundTransparency = 1
                    NameLabel.Text = itemObj.Name .. ' x' .. count
                    NameLabel.TextColor3 = Color3.fromRGB(255, 230, 200)
                    NameLabel.TextScaled = true
                    NameLabel.Font = Enum.Font.GothamBold
                    NameLabel.Parent = ItemFrame

                    local ViewFrameSmall = Instance.new('Frame')
                    ViewFrameSmall.Size = UDim2.new(1, -10, 1, -30)
                    ViewFrameSmall.Position = UDim2.new(0, 5, 0, 30)
                    ViewFrameSmall.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                    ViewFrameSmall.Parent = ItemFrame
                    Instance.new('UICorner', ViewFrameSmall).CornerRadius = UDim.new(0, 10)

                    local VP = Instance.new('ViewportFrame')
                    VP.Size = UDim2.new(1, -4, 1, -4)
                    VP.Position = UDim2.new(0, 2, 0, 2)
                    VP.BackgroundTransparency = 1
                    VP.Parent = ViewFrameSmall
                    
                    local Cam = Instance.new('Camera')
                    Cam.Parent = VP
                    VP.CurrentCamera = Cam

                    local DisplayModel
                    if itemObj:IsA('Model') then
                        DisplayModel = itemObj:Clone()
                    elseif itemObj:IsA('BasePart') then
                        DisplayModel = Instance.new('Model')
                        local p = itemObj:Clone()
                        p.Parent = DisplayModel
                        DisplayModel.PrimaryPart = p
                    end

                    if not DisplayModel then
                        DisplayModel = Instance.new('Model')
                        local p = Instance.new('Part')
                        p.Size = Vector3.new(0.5, 2, 0.2)
                        p.Color = Color3.fromRGB(255, 107, 53)
                        p.Material = Enum.Material.Neon
                        p.Parent = DisplayModel
                        DisplayModel.PrimaryPart = p
                    end

                    DisplayModel.Parent = VP
                    local _, bbSize = DisplayModel:GetBoundingBox()
                    local maxD = math.max(bbSize.X, bbSize.Y, bbSize.Z) * 2.5
                    local rotVal = 0

                    local function Spin()
                        local cf = DisplayModel:GetBoundingBox().Position
                        local camPos = CFrame.new(cf) * CFrame.Angles(0, math.rad(rotVal), 0) * CFrame.Angles(math.rad(-15), 0, 0) * CFrame.new(0, 0, maxD)
                        Cam.CFrame = CFrame.lookAt(camPos.Position, cf)
                    end
                    
                    RunService.RenderStepped:Connect(function()
                        if DisplayModel and Cam then
                            rotVal = rotVal + 0.5
                            Spin()
                        end
                    end)
                    Spin()

                    ClickBtn.MouseButton1Click:Connect(function()
                        ShowItemPreview(itemObj, itemObj.Name, count)
                    end)
                end
            end
        end
    end

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Blur, TweenInfo.new(0.2), {Size = 0}):Play()
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Connect(function()
            ScreenGui:Destroy()
            Blur:Destroy()
        end)
    end)

    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = frameSize
    }):Play()
end

local playerName = game.Players.LocalPlayer.Name
_G.InvisibilityEnabled = true
local InvisCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local IsInvisible = false
InvisCharacter.Archivable = true
local CloneCharacter
local AutoGiveCloak = false

local function EnableInvisibility()
    local BodyVel = InvisCharacter:FindFirstChild('HumanoidRootPart'):FindFirstChild('BodyVelocity')
    if BodyVel then
        BodyVel.P = 0
        BodyVel.MaxForce = Vector3.new(0, 0, 0)
    end

    CloneCharacter = InvisCharacter:Clone()
    
    for _, obj in pairs(CloneCharacter:GetDescendants()) do
        if obj:IsA('BodyVelocity') or obj:IsA('BodyGyro') or obj:IsA('BodyPosition') then
            obj:Destroy()
        end
        if obj:IsA('BasePart') and obj.Transparency < 1 then
            obj.Transparency = 0.85
        end
    end

    local NewVel = Instance.new('BodyVelocity')
    NewVel.MaxForce = Vector3.new(5e5, 500000, 5e5)
    NewVel.Velocity = Vector3.new(0, 0, 0)
    NewVel.Parent = CloneCharacter.HumanoidRootPart
    
    CloneCharacter.Parent = workspace
    CloneCharacter.HumanoidRootPart.CFrame = InvisCharacter.HumanoidRootPart.CFrame
    CloneCharacter.Humanoid.WalkSpeed = InvisCharacter.Humanoid.WalkSpeed * 2
    CloneCharacter.HumanoidRootPart.Anchored = false

    local Animator = InvisCharacter:FindFirstChildOfClass('Animator')
    if Animator then Animator:Clone().Parent = CloneCharacter end

    for _, script in pairs(InvisCharacter:GetChildren()) do
        if script:IsA('LocalScript') then
            local sClone = script:Clone()
            sClone.Disabled = true
            sClone.Parent = CloneCharacter
        end
    end

    workspace.CurrentCamera.CameraSubject = CloneCharacter.Humanoid
    IsInvisible = true
    
    local RealHumanoid = InvisCharacter:FindFirstChildOfClass('Humanoid')
    local SkyPos = InvisCharacter.HumanoidRootPart.CFrame + Vector3.new(0, 1e8, 0)

    task.spawn(function()
        for i = 1, 90 do
            if IsInvisible then InvisCharacter.HumanoidRootPart.CFrame = SkyPos end
            task.wait(0.1)
        end
    end)

    local RenderLoop
    RenderLoop = RunService.RenderStepped:Connect(function()
        if not _G.InvisibilityEnabled or not IsInvisible then
            if RenderLoop then RenderLoop:Disconnect() end
            return
        end

        local MoveDir = RealHumanoid.MoveDirection
        if MoveDir.Magnitude > 0 then
            NewVel.Parent = nil
            local Cam = workspace.CurrentCamera
            local LookVec = Cam.CFrame.LookVector
            local isBackward = LookVec:Dot(MoveDir) < 0
            local yMult = isBackward and -1.4 or 1.8
            local speedMult = isBackward and 1.4 or 1.6
            local velocity = Vector3.new(MoveDir.X, LookVec.Y * yMult + 0.35, MoveDir.Z).Unit
            CloneCharacter.HumanoidRootPart.Velocity = velocity * CloneCharacter.Humanoid.WalkSpeed * speedMult
        else
            NewVel.Parent = CloneCharacter.HumanoidRootPart
        end
    end)
end

local function DisableInvisibility()
    if not IsInvisible then return end
    InvisCharacter.HumanoidRootPart.Velocity = Vector3.new()
    
    for _, obj in pairs(CloneCharacter:GetDescendants()) do
        if obj:IsA('BasePart') and obj.Transparency < 1 then
            obj.Transparency = 1
        end
    end
    IsInvisible = false
    
    for i = 1, 5 do
        InvisCharacter.HumanoidRootPart.CFrame = CloneCharacter.HumanoidRootPart.CFrame
        task.wait()
    end
    CloneCharacter:Destroy()
    workspace.CurrentCamera.CameraSubject = InvisCharacter.Humanoid
end

local function GiveCloakTool()
    local hasTool = LocalPlayer.Backpack:FindFirstChild('Invisibility Cloak') or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Invisibility Cloak'))
    if not hasTool then
        local Tool = Instance.new('Tool')
        Tool.Name = 'Invisibility Cloak'
        Tool.RequiresHandle = false
        Tool.Parent = LocalPlayer.Backpack

        Tool.Equipped:Connect(function()
            if not IsInvisible and _G.InvisibilityEnabled then EnableInvisibility() end
        end)
        Tool.Unequipped:Connect(function()
            if IsInvisible then DisableInvisibility() end
        end)
        return true
    end
    return false
end

task.spawn(function()
    while true do
        if AutoGiveCloak then GiveCloakTool() end
        task.wait(1)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    InvisCharacter = char
    InvisCharacter.Archivable = true
    if AutoGiveCloak then GiveCloakTool() end
end)

local GlobalGameInfo = {
    AlivePlayersFolder = nil,
    PlayerTeamName = nil,
    CurrentGameFolder = nil,
    LastCheckTime = 0
}

local function UpdateGlobalGameInfo()
    local TEAMS = {"TeamBlue", "TeamRed"}
    local runningGames = workspace:FindFirstChild("RunningGames")
    if not runningGames then return end
    
    local foundGame = nil
    local foundAliveParams = nil
    local foundTeam = nil
    
    for _, gameFolder in ipairs(runningGames:GetChildren()) do
        local aliveParams = gameFolder:FindFirstChild("AlivePlayers")
        if aliveParams and aliveParams:IsA("Folder") then
            for _, teamName in ipairs(TEAMS) do
                local teamFolder = aliveParams:FindFirstChild(teamName)
                if teamFolder and teamFolder:FindFirstChild(LocalPlayer.Name) then
                    foundGame = gameFolder
                    foundAliveParams = aliveParams
                    foundTeam = teamName
                    break
                end
            end
        end
        if foundGame then break end
    end
    
    if foundGame and foundAliveParams then
        GlobalGameInfo.AlivePlayersFolder = foundAliveParams
        GlobalGameInfo.PlayerTeamName = foundTeam
    else
        GlobalGameInfo.AlivePlayersFolder = nil
        for _, gameFolder in ipairs(runningGames:GetChildren()) do
            local aliveParams = gameFolder:FindFirstChild("AlivePlayers")
            if aliveParams and aliveParams:IsA("Folder") then
                if aliveParams:FindFirstChild("TeamBlue") or aliveParams:FindFirstChild("TeamRed") then
                    GlobalGameInfo.AlivePlayersFolder = aliveParams
                    break
                end
            end
        end
    end
end

local function GetLocalTeamFromGui()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local main = playerGui:FindFirstChild("Main")
    if not main then return nil end
    local gameFrame = main:FindFirstChild("MainGameFrame")
    if not gameFrame then return nil end
    local playersFrame = gameFrame:FindFirstChild("PlayersFrame")
    if not playersFrame then return nil end
    if playersFrame:FindFirstChild("TeamBlueFrame") then return "TeamBlue" end
    if playersFrame:FindFirstChild("TeamRedFrame") then return "TeamRed" end
    return nil
end

local function IsTeammateGlobal(targetPlayer)
    if targetPlayer == LocalPlayer then return true end

    if tick() - GlobalGameInfo.LastCheckTime > 1 then
        UpdateGlobalGameInfo()
        GlobalGameInfo.LastCheckTime = tick()
    end

    if GlobalGameInfo.AlivePlayersFolder then
        local myTeam = GlobalGameInfo.PlayerTeamName or GetLocalTeamFromGui()
        if myTeam then
            local targetTeam = nil
            for _, teamName in ipairs({"TeamBlue", "TeamRed"}) do
                local teamFolder = GlobalGameInfo.AlivePlayersFolder:FindFirstChild(teamName)
                if teamFolder and teamFolder:FindFirstChild(targetPlayer.Name) then
                    targetTeam = teamName
                    break
                end
            end
            
            if targetTeam then
                return targetTeam == myTeam
            end
            
            return false
        end
        return false
    end

    if LocalPlayer.Team and targetPlayer.Team then
        return LocalPlayer.Team == targetPlayer.Team
    end

    return false
end

local function IsInRound()
    if tick() - GlobalGameInfo.LastCheckTime > 1 then
        UpdateGlobalGameInfo()
        GlobalGameInfo.LastCheckTime = tick()
    end
    
    if GlobalGameInfo.AlivePlayersFolder then
        local TEAMS = {"TeamBlue", "TeamRed"}
        for _, teamName in ipairs(TEAMS) do
            local teamFolder = GlobalGameInfo.AlivePlayersFolder:FindFirstChild(teamName)
            if teamFolder and teamFolder:FindFirstChild(LocalPlayer.Name) then
                return true
            end
            end
    end
    return false
end

local aimbotState = {
    aimbotEnabled = false,
    aimbotSmoothness = 1,
    aimbotFOVSize = 100,
    aimbotFOVColor = Color3.fromRGB(128, 0, 128),
    aimbotTargetPart = "Head",
    aimbotTeamCheck = true,
    aimbotVisibilityCheck = true,
    showFOV = true,
    fovType = "Limited FOV"
}

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = aimbotState.aimbotFOVColor
FOVring.Filled = false
FOVring.Radius = aimbotState.aimbotFOVSize
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

local aimbotConnection

local silentAimSettings = {
    prediction = 100,
    aimType = "Pantalla Completa",
    fovColor = Color3.fromRGB(255, 255, 255),
    fovSize = 100,
    wallCheck = false,
    showFOV = true
}

local silentAimMobileEnabled = false
local silentAimPCEnabled = false
local perfectTorsoShotConnection = nil

local SilentAimFOV = Drawing.new("Circle")
SilentAimFOV.Visible = false
SilentAimFOV.Thickness = 2
SilentAimFOV.Color = Color3.fromRGB(255, 255, 255)
SilentAimFOV.Filled = false
SilentAimFOV.Radius = 100
SilentAimFOV.Position = workspace.CurrentCamera.ViewportSize / 2

local function updateDrawings()
    local camViewportSize = workspace.CurrentCamera.ViewportSize
    FOVring.Position = camViewportSize / 2
    SilentAimFOV.Position = camViewportSize / 2
end

local function lookAt(target, smoothness)
    local Cam = workspace.CurrentCamera
    local lookVector = (target - Cam.CFrame.Position).unit
    local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
    Cam.CFrame = Cam.CFrame:Lerp(newCFrame, smoothness)
end

local function getTargetPlayer(trg_part, fov, teamCheck, visibilityCheck)
    local candidates = {}
    local Cam = workspace.CurrentCamera
    local playerMousePos = Cam.ViewportSize / 2
    local localPlayer = Players.LocalPlayer
    local localPos = localPlayer.Character and localPlayer.Character.PrimaryPart and localPlayer.Character.PrimaryPart.Position or Vector3.zero

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if teamCheck and IsTeammateGlobal(player) then
            else
                local character = player.Character
                if character then
                    local part = character:FindFirstChild(trg_part)
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if part and humanoid then
                        local visible = true
                        if visibilityCheck then
                            visible = CheckVisibility(part)
                        end
                        if visible then
                            local ePos, onScreen = Cam:WorldToViewportPoint(part.Position)
                            local screenDist = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude
                            local threeDDist = (part.Position - localPos).Magnitude
                            local health = humanoid.Health
                            table.insert(candidates, {
                                player = player,
                                screenDist = onScreen and screenDist or math.huge,
                                threeDDist = threeDDist,
                                health = health,
                                onScreen = onScreen
                            })
                        end
                    end
                end
            end
        end
    end

    local filtered = {}
    for _, cand in ipairs(candidates) do
        local include = false
        if aimbotState.fovType == "Limited FOV" then
            if cand.onScreen and cand.screenDist < fov then
                include = true
            end
        elseif aimbotState.fovType == "Full Screen" then
            if cand.onScreen then
                include = true
            end
        elseif aimbotState.fovType == "360 Degrees" then
            include = true
        end
        if include then
            table.insert(filtered, cand)
        end
    end

    if #filtered == 0 then return nil end

    local selected = filtered[1]
    for _, cand in ipairs(filtered) do
        if cand.threeDDist < selected.threeDDist then
            selected = cand
        end
    end

    return selected.player
end

local function cleanupAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    if FOVring then
        FOVring:Remove()
        FOVring = nil
    end
end

local function initializeAimbot()
    if not FOVring then
        FOVring = Drawing.new("Circle")
        FOVring.Visible = false
        FOVring.Thickness = 2
        FOVring.Color = aimbotState.aimbotFOVColor
        FOVring.Filled = false
        FOVring.Radius = aimbotState.aimbotFOVSize
        FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
    end
    
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        updateDrawings()
    end)
end

local HitboxSettings = {
    Enabled = false,
    GunEnabled = false,
    KnifeEnabled = false,
    Size = 12,
    Transparency = 1,
    Color = Color3.fromRGB(255, 0, 0),
    AntiWall = false
}

local ESPSettings = {
    Names = false,
    Highlights = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        TeammatesEnabled = false,
        TeammatesColor = Color3.fromRGB(135, 206, 235)
    }
}

local originalHitboxProperties = {}

local function restoreHitbox(targetPlayer)
    if targetPlayer.Character then
        local bodyParts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "UpperTorso"}
        for _, partName in pairs(bodyParts) do
            local part = targetPlayer.Character:FindFirstChild(partName)
            if part and originalHitboxProperties[targetPlayer] and originalHitboxProperties[targetPlayer][partName] then
                local props = originalHitboxProperties[targetPlayer][partName]
                part.Size = props.Size
                part.Transparency = props.Transparency
                part.Color = props.Color
                part.CanCollide = props.CanCollide
            end
        end
    end
end

local function restoreAllHitboxes()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        restoreHitbox(targetPlayer)
    end
    originalHitboxProperties = {}
end

local nameTagContainer = Instance.new("BillboardGui")
local playerNameLabel = Instance.new("TextLabel")

nameTagContainer.Name = "NameTagESP"
nameTagContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
nameTagContainer.Active = true
nameTagContainer.AlwaysOnTop = true
nameTagContainer.LightInfluence = 1.000
nameTagContainer.Size = UDim2.new(0, 200, 0, 30)
nameTagContainer.StudsOffset = Vector3.new(0, 3, 0)

playerNameLabel.Name = "NameLabel"
playerNameLabel.Parent = nameTagContainer
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.BorderSizePixel = 0
playerNameLabel.Size = UDim2.new(1, 0, 1, 0)
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.TextSize = 14
playerNameLabel.TextStrokeTransparency = 0.5
playerNameLabel.TextWrapped = true
playerNameLabel.TextTransparency = 1

local highlights = {}

local HighlightStorage = Instance.new("Folder")
HighlightStorage.Name = "Synergy_Visuals"
local protectedGui = game:GetService("CoreGui")
if not pcall(function() HighlightStorage.Parent = protectedGui end) then
    HighlightStorage.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local function createHighlightForPlayer(targetPlayer, character)
    if not character then return end
    
    if highlights[targetPlayer] then
        if highlights[targetPlayer].Parent == nil then
            highlights[targetPlayer]:Destroy()
            highlights[targetPlayer] = nil
        else
            return
        end
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.Enabled = false
    highlight.Parent = HighlightStorage
    highlights[targetPlayer] = highlight
end

local function createNameTagForPlayer(targetPlayer, character)
    if not character then return end
    
    pcall(function()
        local head = character:WaitForChild("Head", 10)
        if head then
            if head:FindFirstChild("NameTagESP") then return end
            
            local nameClone = nameTagContainer:Clone()
            nameClone.Parent = head
            nameClone:FindFirstChild("NameLabel").Text = targetPlayer.Name
        end
    end)
end

local function addESPToPlayer(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function(newCharacter)
        repeat task.wait() until newCharacter:FindFirstChild("HumanoidRootPart")
        createHighlightForPlayer(targetPlayer, newCharacter)
        createNameTagForPlayer(targetPlayer, newCharacter)
    end)
    
    if targetPlayer.Character then
        createHighlightForPlayer(targetPlayer, targetPlayer.Character)
        createNameTagForPlayer(targetPlayer, targetPlayer.Character)
    end
end

for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer ~= LocalPlayer then
        addESPToPlayer(targetPlayer)
    end
end

Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer ~= LocalPlayer then
        addESPToPlayer(newPlayer)
    end
end)

local function updateESP()
    if not IsInRound() then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= LocalPlayer then
                local nameTag = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") and targetPlayer.Character.Head:FindFirstChild("NameTagESP")
                if nameTag then
                    nameTag.NameLabel.TextTransparency = 1
                end
                if highlights[targetPlayer] then
                    highlights[targetPlayer].Enabled = false
                end
            end
        end
        return
    end

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

                if not highlights[targetPlayer] or not highlights[targetPlayer].Parent then
                    createHighlightForPlayer(targetPlayer, targetPlayer.Character)
                end

                if highlights[targetPlayer] and highlights[targetPlayer].Adornee ~= targetPlayer.Character then
                     highlights[targetPlayer].Adornee = targetPlayer.Character
                end

                if targetPlayer.Character:FindFirstChild("Head") and not targetPlayer.Character.Head:FindFirstChild("NameTagESP") then
                    createNameTagForPlayer(targetPlayer, targetPlayer.Character)
                end

                local isTeammate = IsTeammateGlobal(targetPlayer)

                local nameTag = targetPlayer.Character:FindFirstChild("Head") and targetPlayer.Character.Head:FindFirstChild("NameTagESP")
                if nameTag then
                    local showName = ESPSettings.Names and not isTeammate
                    nameTag.NameLabel.TextTransparency = showName and 0 or 1
                end

                pcall(function()
                    local shouldHighlight = false
                    local useColor = ESPSettings.Highlights.Color
                    
                    if isTeammate then
                        if ESPSettings.Highlights.TeammatesEnabled then
                            shouldHighlight = true
                            useColor = ESPSettings.Highlights.TeammatesColor
                        end
                    else
                        if ESPSettings.Highlights.Enabled then
                            shouldHighlight = true
                            useColor = ESPSettings.Highlights.Color
                        end
                    end
                    
                    if highlights[targetPlayer] then
                        if shouldHighlight then
                            highlights[targetPlayer].Enabled = true
                            highlights[targetPlayer].FillColor = useColor
                            highlights[targetPlayer].FillTransparency = ESPSettings.Highlights.Transparency
                            highlights[targetPlayer].OutlineColor = useColor
                        else
                            highlights[targetPlayer].Enabled = false
                        end
                    end
                end)
            else
                if highlights[targetPlayer] then
                    highlights[targetPlayer]:Destroy()
                    highlights[targetPlayer] = nil
                end
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end)

local espUpdateInterval = 0.1
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastUpdate >= espUpdateInterval then
        pcall(updateESP)
        lastUpdate = now
    end
end)

local Window

local autoFarmEnabled = false
local autoFarmHeartbeatConnection
local autoFarmEquipConnection

local activeTPTarget = nil
local tpLoopConnection = nil

local function startTPLoop()
    if tpLoopConnection then return end
    tpLoopConnection = RunService.Heartbeat:Connect(function()
        if activeTPTarget and not IsInRound() then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = activeTPTarget
                        hrp.Velocity = Vector3.zero
                    end
                end
            end)
        end
    end)
end

startTPLoop()

local function startAutoFarm()
    if not game:IsLoaded() then game.Loaded:Wait() end

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    local EQUIP_INTERVAL = 2

    repeat task.wait() until LocalPlayer.Character
    repeat task.wait() until LocalPlayer.Character:FindFirstChild("Humanoid")

    local function getWeapon()
        local char = LocalPlayer.Character
        if not char then return nil end
        
        local gun = char:FindFirstChild("DefaultGun") or char:FindFirstChildWhichIsA("Tool")
        if not gun then return nil end
        
        return gun:FindFirstChild("kill") or gun:FindFirstChildOfClass("RemoteEvent")
    end

    local function getClosestPlayer()
        local localChar = LocalPlayer.Character
        if not localChar then return nil end
        
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then return nil end
        
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetChar = player.Character
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                
                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    local distance = (localRoot.Position - targetRoot.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        return closestPlayer
    end

    local function autoEquip()
        while autoFarmEnabled do
            local char = LocalPlayer.Character
            if not char then task.wait(EQUIP_INTERVAL); continue end
            
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then task.wait(EQUIP_INTERVAL); continue end

            local toolToEquip = nil
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("showBeam") then
                    local showBeam = tool:FindFirstChild("showBeam")
                    if showBeam and showBeam:IsA("RemoteEvent") then
                        toolToEquip = tool
                        break
                    end
                end
            end
            
            if toolToEquip then
                task.wait(0.5)
                
                if char and humanoid and humanoid.Health > 0 and toolToEquip and toolToEquip.Parent then
                    pcall(function()
                        humanoid:EquipTool(toolToEquip)
                    end)
                end
            end
            task.wait(EQUIP_INTERVAL)
        end
    end

    autoFarmHeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not autoFarmEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local killEvent = getWeapon()
        if not killEvent then return end
        
        local targetPlayer = getClosestPlayer()
        if not targetPlayer then return end
        
        local targetChar = targetPlayer.Character
        if not targetChar then return end
        
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        
        local direction = (targetRoot.Position - root.Position).Unit
        
        local args = {
            [1] = targetPlayer,
            [2] = direction,
            [3] = targetRoot.Position
        }
        
        pcall(function()
            killEvent:FireServer(unpack(args))
        end)
    end)

    autoFarmEquipConnection = task.spawn(autoEquip)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
    end)
end

local function stopAutoFarm()
    autoFarmEnabled = false
    if autoFarmHeartbeatConnection then
        autoFarmHeartbeatConnection:Disconnect()
        autoFarmHeartbeatConnection = nil
    end
    if autoFarmEquipConnection then
        autoFarmEquipConnection = nil
    end
end

local antiAfkConnection

local function startAntiAFK()
    if antiAfkConnection then return end
    antiAfkConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function stopAntiAFK()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end

local SA_ClickShootEnabled = false
local SA_BlockShootEnabled = false

local SA_Weapon = nil
local SA_WeaponActive = false

local SA_LastShotTime = 0
local SA_ShotDelay = 2.15

local SA_MaxDistance = 200
local SA_BlockKey = Enum.KeyCode.F

local SA_WeaponTracking = {}
local SA_WeaponTrackingInterval = 0.1

local SA_Cache = {}
local SA_CacheDuration = 0.5

local SA_RaycastBudget = 100
local SA_RaycastCost = 0

local SA_Config = {
    maxDetectionDistance = 200,
    minDetectionDistance = 5,
    baseRaycastCount = 5,
    maxRaycastCount = 10,
    raySpreadAngle = 2,
    aimAssistStrength = 0.7,
    allowBackwardsShooting = false,
    predictionStrength = 0.8,
    requireLineOfSight = true,
    validateAssets = true,
    checkTeam = true,
    cameraThreshold = 0.1,
    maxCameraAngle = 30,
    maxRaysPerFrame = 8,
    distanceBasedRayReduction = true,
    adaptiveRaycasting = true,
    screenCenterWeight = 0.4,
    distanceWeight = 0.3,
    visibilityWeight = 0.3,
}

local SA_AimParts = {
    'HumanoidRootPart',
    'Head',
    'UpperTorso',
    'LowerTorso',
    'LeftUpperArm',
    'RightUpperArm',
    'LeftUpperLeg',
    'RightUpperLeg',
}

local function SA_AdjustForMobile()
    local UserInputService = game:GetService('UserInputService')
    local isTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    if isTouch then
        SA_Config.aimAssistStrength = 0.9
        SA_Config.maxRaycastCount = 8
        SA_ShotDelay = 0.07
    else
        SA_Config.aimAssistStrength = 0.7
        SA_Config.maxRaycastCount = 10
        SA_ShotDelay = 0.05
    end
end

local function SA_TrackWeapon(weapon)
    if not weapon then return end
    if SA_WeaponTracking[weapon] then return end

    SA_WeaponTracking[weapon] = true

    weapon.AncestryChanged:Connect(function()
        task.wait()
        if SA_ClickShootEnabled and (SA_Weapon == weapon) and SA_Weapon and SA_Weapon.Parent then
            pcall(SA_UpdateWeaponScripts)
        end
    end)

    weapon:GetPropertyChangedSignal('Parent'):Connect(function()
        task.wait()
        if SA_ClickShootEnabled and (SA_Weapon == weapon) and SA_Weapon and SA_Weapon.Parent then
            pcall(SA_UpdateWeaponScripts)
        end
    end)
end

function SA_UpdateWeaponScripts()
    if not SA_ClickShootEnabled then return end
    if not SA_Weapon or not SA_Weapon.Parent or not SA_Weapon:IsDescendantOf(game) then
        local char = LocalPlayer.Character
        if char and char:IsDescendantOf(workspace) then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA('Tool') and tool:FindFirstChild('fire') and tool:FindFirstChild('showBeam') then
                    SA_Weapon = tool
                    SA_WeaponActive = true
                    SA_TrackWeapon(SA_Weapon)
                    break
                end
            end
        end
        if not SA_Weapon then
            SA_WeaponActive = false
            return
        end
    end

    if not SA_Weapon or not SA_Weapon.Parent then
        SA_WeaponActive = false
        SA_Weapon = nil
        return
    end

    if not SA_BlockShootEnabled then
        return
    end

    local descendants = SA_Weapon:GetDescendants()
    table.insert(descendants, SA_Weapon)

    for _, obj in ipairs(descendants) do
        if obj and (obj:IsA('Script') or obj:IsA('LocalScript')) and obj.Disabled == false then
            pcall(function()
                if SA_Weapon and obj:IsDescendantOf(SA_Weapon) then
                    obj.Disabled = true
                end
            end)
        end
    end

    local scriptNames = {'Script', 'LocalScript', 'Client', 'GunScript'}
    for _, name in ipairs(scriptNames) do
        pcall(function()
            local script = SA_Weapon:FindFirstChild(name)
            if script and (script:IsA('Script') or script:IsA('LocalScript')) and script.Disabled == false then
                script.Disabled = true
            end
        end)
    end
end

function SA_InitializeWeapon()
    local char = LocalPlayer.Character
    if not char then return false end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA('Tool') and tool:FindFirstChild('fire') and tool:FindFirstChild('showBeam') then
            SA_Weapon = tool
            SA_WeaponActive = true
            SA_TrackWeapon(SA_Weapon)
            if SA_Weapon and SA_Weapon.Parent then
                pcall(SA_UpdateWeaponScripts)
            end
            return true
        end
    end

    local backpack = LocalPlayer:FindFirstChild('Backpack')
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA('Tool') and tool:FindFirstChild('fire') and tool:FindFirstChild('showBeam') then
                SA_Weapon = tool
                SA_WeaponActive = false
                SA_TrackWeapon(SA_Weapon)
                if SA_Weapon and SA_Weapon.Parent then
                    pcall(SA_UpdateWeaponScripts)
                end
                return true
            end
        end
    end

    SA_Weapon = nil
    SA_WeaponActive = false
    return false
end

local function SA_GetComponent(instance, componentName)
    local key = tostring(instance) .. '_' .. componentName
    local cached = SA_Cache[key]
    if cached and (tick() - cached.time) < SA_CacheDuration then
        return cached.component
    end

    local component = instance:FindFirstChild(componentName)
    SA_Cache[key] = {component = component, time = tick()}
    return component
end

local function SA_IsTargetInView(targetPos)
    local camera = workspace.CurrentCamera
    if not camera then return false end

    local cameraPos = camera.CFrame.Position
    local direction = (targetPos - cameraPos).Unit
    local lookVector = camera.CFrame.LookVector

    return direction:Dot(lookVector) > SA_Config.cameraThreshold
end

local function SA_GetAngleToTarget(targetPos)
    local camera = workspace.CurrentCamera
    if not camera then return 180 end

    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
    if not onScreen then return 180 end

    local viewportCenter = camera.ViewportSize / 2
    local diffX = screenPos.X - viewportCenter.X
    local diffY = screenPos.Y - viewportCenter.Y

    local angle = math.deg(math.atan2(diffY, diffX))
    local absAngle = math.abs(angle)

    if absAngle > 180 then
        absAngle = 360 - absAngle
    end

    return absAngle
end

local function SA_CalculatePrediction(targetRoot, targetHumanoid)
    if not targetRoot or not targetHumanoid then
        return Vector3.new(0, 0, 0)
    end

    local velocity = targetRoot.AssemblyLinearVelocity
    local prediction = Vector3.new(0, 0, 0)

    if velocity.Magnitude > 1 then
        prediction = velocity * 0.08 * SA_Config.predictionStrength
    end

    return prediction
end

local function SA_GetHitboxScale(character)
    if not SA_Config.validateAssets then
        return {hitboxScale = 1}
    end

    local scale = 1
    local largeAccessories = 0

    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA('Accessory') then
            local handle = accessory:FindFirstChild('Handle')
            if handle then
                local size = handle.Size
                local volume = size.X * size.Y * size.Z
                if volume > 5 then
                    largeAccessories = largeAccessories + 1
                end
            end
        end
    end

    if largeAccessories > 0 then
        scale = 1 + (largeAccessories * 0.2)
    end

    return {hitboxScale = scale}
end

local function SA_GetRaycastCount(distance)
    if not SA_Config.distanceBasedRayReduction then
        return math.min(SA_Config.baseRaycastCount, SA_Config.maxRaycastCount)
    end

    if distance > 150 then
        return 3
    elseif distance > 100 then
        return 4
    elseif distance > 50 then
        return 5
    else
        return math.min(SA_Config.baseRaycastCount, SA_Config.maxRaycastCount)
    end
end

local function SA_CanRaycast()
    if SA_RaycastCost >= SA_RaycastBudget then
        return false
    end
    SA_RaycastCost = SA_RaycastCost + 1
    return true
end

game:GetService('RunService').Heartbeat:Connect(function(deltaTime)
    SA_RaycastCost = math.max(0, SA_RaycastCost - (SA_RaycastBudget * deltaTime))
end)

local function SA_CheckVisibility(character, origin, distance)
    local hitCount = 0
    local rayCount = 0
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.IgnoreWater = true

    local maxRays = math.min(SA_GetRaycastCount(distance) * #SA_AimParts, SA_Config.maxRaysPerFrame)
    local hitboxScale = SA_GetHitboxScale(character).hitboxScale

    for _, partName in ipairs(SA_AimParts) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA('BasePart') then
            if not SA_CanRaycast() or rayCount >= maxRays then
                break
            end

            local ray = workspace:Raycast(origin, (part.Position - origin).Unit * distance, params)
            if ray and ray.Instance:IsDescendantOf(character) then
                hitCount = hitCount + 1
            end
            rayCount = rayCount + 1

            local extraRays = math.min(SA_GetRaycastCount(distance) - 1, 2)
            for i = 1, extraRays do
                if not SA_CanRaycast() or rayCount >= maxRays then
                    break
                end

                local offset = Vector3.new(
                    (math.random() - 0.5) * 0.3 * hitboxScale,
                    (math.random() - 0.5) * 0.3 * hitboxScale,
                    (math.random() - 0.5) * 0.3 * hitboxScale
                )
                local targetPos = part.Position + offset
                ray = workspace:Raycast(origin, (targetPos - origin).Unit * distance, params)
                if ray and ray.Instance:IsDescendantOf(character) then
                    hitCount = hitCount + 1
                end
                rayCount = rayCount + 1
            end
        end
    end

    local hitRatio = (rayCount > 0) and (hitCount / rayCount) or 0
    return hitCount > 0 and hitRatio >= 0.2, hitRatio
end

local function SA_CalculateTargetScore(player)
    local character = player.Character
    if not character then return 0 end

    local root = character:FindFirstChild('HumanoidRootPart')
    if not root then return 0 end

    local camera = workspace.CurrentCamera
    if not camera then return 0 end

    local score = 0

    local angle = SA_GetAngleToTarget(root.Position)
    local screenScore = 1 - (angle / SA_Config.maxCameraAngle)
    screenScore = math.clamp(screenScore, 0, 1)
    score = score + (screenScore * SA_Config.screenCenterWeight * 100)

    local distance = (camera.CFrame.Position - root.Position).Magnitude
    if distance <= SA_MaxDistance then
        local distanceScore = 1 - (distance / SA_MaxDistance)
        score = score + (distanceScore * SA_Config.distanceWeight * 100)
    end

    local localChar = LocalPlayer.Character
    if localChar then
        local localRoot = SA_GetComponent(localChar, 'HumanoidRootPart') or localChar:FindFirstChild('Head')
        if localRoot then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Blacklist
            params.FilterDescendantsInstances = {localChar}
            local ray = workspace:Raycast(localRoot.Position, (root.Position - localRoot.Position).Unit * distance, params)
            if not ray or (ray.Instance and ray.Instance:IsDescendantOf(character)) then
                score = score + (SA_Config.visibilityWeight * 100)
            end
        end
    end

    return score
end

local function SA_GetBestTarget(fovRadius, fovCenter)
    local localChar = LocalPlayer.Character
    if not localChar or not localChar:IsDescendantOf(workspace) then
        return nil, 0
    end

    local enemies = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IsTeammateGlobal(player) then
            table.insert(enemies, player)
        end
    end

    local bestTarget = nil
    local bestScore = 0

    for _, enemy in ipairs(enemies) do
        local char = enemy.Character
        if char and char:IsDescendantOf(workspace) then
            local root = SA_GetComponent(char, 'HumanoidRootPart')
            local humanoid = SA_GetComponent(char, 'Humanoid')
            if root and humanoid and humanoid.Health > 0 then
                local distance = (localChar:GetPivot().Position - root.Position).Magnitude
                if distance <= SA_MaxDistance then
                    if SA_IsTargetInView(root.Position) then
                        if fovRadius then
                            if not fovCenter then
                                fovCenter = workspace.CurrentCamera.ViewportSize / 2
                            end
                            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                                if (screenPos2D - fovCenter).Magnitude > fovRadius then
                                    continue
                                end
                            else
                                continue
                            end
                        end
                        local score = SA_CalculateTargetScore(enemy)
                        if score > 25 and score > bestScore then
                            bestScore = score
                            bestTarget = enemy
                        end
                    end
                end
            end
        end
    end

    return bestTarget, bestScore
end

local function SA_CanShootTarget(target)
    if not target then return false end

    local targetChar = target.Character
    if not targetChar then return false end

    local localChar = LocalPlayer.Character
    if not localChar then return false end

    local localRoot = SA_GetComponent(localChar, 'HumanoidRootPart') or localChar:FindFirstChild('Head')
    local targetRoot = SA_GetComponent(targetChar, 'HumanoidRootPart')
    local targetHumanoid = SA_GetComponent(targetChar, 'Humanoid')

    if not localRoot or not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
        return false
    end

    local distance = (targetRoot.Position - localRoot.Position).Magnitude
    if distance > SA_MaxDistance then
        return false
    end

    if not SA_IsTargetInView(targetRoot.Position) then
        return false
    end

    local visible, _ = SA_CheckVisibility(targetChar, localRoot.Position, distance)
    return visible
end

local function SA_GetCurrentWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA('Tool') and tool:FindFirstChild('fire') and tool:FindFirstChild('showBeam') then
            return tool
        end
    end

    return nil
end

local function SA_IsWeaponReady()
    if not SA_Weapon then
        SA_WeaponActive = false
        return false
    end

    local success = pcall(function()
        return SA_Weapon:IsDescendantOf(game) and SA_Weapon.Parent ~= nil
    end)

    if not success then
        SA_Weapon = nil
        SA_WeaponActive = false
        return false
    end

    return SA_GetComponent(SA_Weapon, 'fire') ~= nil and SA_GetComponent(SA_Weapon, 'showBeam') ~= nil
end

local function SA_PerformShot()
    local currentTime = tick()
    if (currentTime - SA_LastShotTime) < SA_ShotDelay then
        return false
    end

    if not SA_ClickShootEnabled then
        return false
    end

    if not SA_IsWeaponReady() then
        return false
    end

    -- Determinar si se usa FOV según el tipo seleccionado
    local useFOV = (silentAimSettings.aimType == "FOV")
    local fovRadius, fovCenter
    if useFOV then
        fovRadius = silentAimSettings.fovSize
        fovCenter = workspace.CurrentCamera.ViewportSize / 2
    end

    local target, score = SA_GetBestTarget(fovRadius, fovCenter)
    if not target or score < 25 then
        return false
    end

    if not SA_CanShootTarget(target) then
        return false
    end

    local localChar = LocalPlayer.Character
    if not localChar then return false end

    local targetChar = target.Character
    if not targetChar then return false end

    local localRoot = SA_GetComponent(localChar, 'HumanoidRootPart') or localChar:FindFirstChild('Head')
    local targetRoot = SA_GetComponent(targetChar, 'HumanoidRootPart')
    local targetHumanoid = SA_GetComponent(targetChar, 'Humanoid')

    if not localRoot or not targetRoot or not targetHumanoid then
        return false
    end

    local prediction = SA_CalculatePrediction(targetRoot, targetHumanoid)
    local targetPosition = targetRoot.Position + prediction

    local handle = SA_GetComponent(SA_Weapon, 'Handle') or SA_Weapon
    if not handle then return false end

    local fireEvent = SA_GetComponent(SA_Weapon, 'fire')
    local beamEvent = SA_GetComponent(SA_Weapon, 'showBeam')
    local killEvent = SA_GetComponent(SA_Weapon, 'kill')
    local localBeam = ReplicatedStorage:FindFirstChild('LocalBeam')

    task.spawn(function()
        if localBeam then
            pcall(function()
                localBeam:Fire(handle, targetPosition)
            end)
        end

        if fireEvent then
            pcall(function()
                fireEvent:FireServer()
            end)
        end

        if beamEvent then
            pcall(function()
                beamEvent:FireServer(targetPosition, handle.Position, handle)
            end)
        end

        if killEvent then
            local direction = (targetPosition - handle.Position).Unit
            pcall(function()
                killEvent:FireServer(target, direction, targetPosition)
            end)
        end
    end)

    SA_LastShotTime = currentTime
    return true
end

function SetSilentAimState(state)
    SA_ClickShootEnabled = state

    if state then
        SA_InitializeWeapon()
        SA_AdjustForMobile()
    else
    end
end

function SetSABlockShootState(state)
    SA_BlockShootEnabled = state

    if state then
        SA_UpdateWeaponScripts()
    else
        if SA_Weapon then
            local descendants = SA_Weapon:GetDescendants()
            table.insert(descendants, SA_Weapon)
            for _, obj in ipairs(descendants) do
                if obj and (obj:IsA('Script') or obj:IsA('LocalScript')) and obj.Disabled == true then
                    pcall(function()
                        if SA_Weapon and obj:IsDescendantOf(SA_Weapon) then
                            obj.Disabled = false
                        end
                    end)
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    SA_Weapon = nil
    SA_WeaponActive = false
    SA_Cache = {}

    char:WaitForChild('Humanoid', 5)
    local root = char:WaitForChild('HumanoidRootPart', 3)
    if root then
        task.wait(1.5)
        pcall(SA_InitializeWeapon)
        SA_AdjustForMobile()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA('Tool') and child:FindFirstChild('fire') and child:FindFirstChild('showBeam') then
            task.wait(0.1)
            SA_Weapon = child
            SA_WeaponActive = true
            SA_TrackWeapon(SA_Weapon)
            pcall(SA_UpdateWeaponScripts)
        end
    end)

    char.ChildRemoved:Connect(function(child)
        if child == SA_Weapon then
            SA_WeaponActive = false
            SA_Weapon = nil
            task.wait(0.1)
            pcall(SA_InitializeWeapon)
        end
    end)
end)

game:GetService('RunService').Heartbeat:Connect(function()
    if SA_Weapon and not SA_Weapon:IsDescendantOf(game) then
        SA_Weapon = nil
        SA_WeaponActive = false
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    if obj == SA_Weapon then
        SA_Weapon = nil
        SA_WeaponActive = false
    end
end)

local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if SA_ClickShootEnabled then
        SA_PerformShot()
    end
end)

local touchStartPos = nil
local touchStartTime = 0
local touchMoved = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        touchStartPos = input.Position
        touchStartTime = tick()
        touchMoved = false
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch then
        if touchStartPos and (input.Position - touchStartPos).Magnitude > 10 then
            touchMoved = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        if touchStartPos and not touchMoved and (tick() - touchStartTime) < 0.5 then
            if SA_ClickShootEnabled then
                SA_PerformShot()
            end
        end
        touchStartPos = nil
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        local currentTime = tick()
        for key, cached in pairs(SA_Cache) do
            if (currentTime - cached.time) > (SA_CacheDuration * 2) then
                SA_Cache[key] = nil
            end
        end
    end
end)

SA_AdjustForMobile()

local AutoShootEnabled = false
local AutoShootConnection
local autoShootDelay = 0.08
local autoShootFOVCircle = Drawing.new("Circle")
autoShootFOVCircle.Visible = false
autoShootFOVCircle.Thickness = 2
autoShootFOVCircle.Color = Color3.fromRGB(255, 255, 255)
autoShootFOVCircle.Filled = false
autoShootFOVCircle.Radius = 100
autoShootFOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2

local autoShootConfig = {
    mode = "Pantalla Completa",
    showFOV = true,
    fovSize = 100,
    fovColor = Color3.fromRGB(255, 255, 255),
    teamCheck = true,
    wallCheck = true
}

local function IsVisibleFromWeapon(weaponHandle, targetChar)
    if not weaponHandle or not targetChar then return false end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end

    local origin = weaponHandle.Position
    local direction = (targetRoot.Position - origin).Unit
    local distance = (targetRoot.Position - origin).Magnitude

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local ray = workspace:Raycast(origin, direction * distance, params)
    if not ray then return true end
    return ray.Instance:IsDescendantOf(targetChar)
end

local function PerformAutoShoot()
    if not AutoShootEnabled then return end
    local weapon = SA_GetCurrentWeapon()
    if not weapon then return end

    local target, score
    if autoShootConfig.mode == "FOV" then
        target, score = SA_GetBestTarget(autoShootConfig.fovSize, workspace.CurrentCamera.ViewportSize / 2)
    else
        target, score = SA_GetBestTarget()
    end
    
    if not target or score < 25 then return end

    local localChar = LocalPlayer.Character
    if not localChar then return end

    local localRoot = SA_GetComponent(localChar, 'HumanoidRootPart') or localChar:FindFirstChild('Head')
    if not localRoot then return end

    if not SA_CanShootTarget(target) then return end

    local targetChar = target.Character
    if not targetChar then return end

    local targetRoot = SA_GetComponent(targetChar, 'HumanoidRootPart')
    local targetHumanoid = SA_GetComponent(targetChar, 'Humanoid')

    if not targetRoot or not targetHumanoid then
        return
    end

    local handle = SA_GetComponent(weapon, 'Handle') or weapon
    if handle and not IsVisibleFromWeapon(handle, targetChar) then
        return
    end

    local prediction = SA_CalculatePrediction(targetRoot, targetHumanoid)
    local targetPosition = targetRoot.Position + prediction

    local fireEvent = SA_GetComponent(weapon, 'fire')
    local beamEvent = SA_GetComponent(weapon, 'showBeam')
    local killEvent = SA_GetComponent(weapon, 'kill')
    local localBeam = ReplicatedStorage:FindFirstChild('LocalBeam')

    task.spawn(function()
        if localBeam then
            pcall(function()
                localBeam:Fire(handle, targetPosition)
            end)
        end

        if fireEvent then
            pcall(function()
                fireEvent:FireServer()
            end)
        end

        if beamEvent then
            pcall(function()
                beamEvent:FireServer(targetPosition, handle.Position, handle)
            end)
        end

        if killEvent then
            local direction = (targetPosition - handle.Position).Unit
            pcall(function()
                killEvent:FireServer(target, direction, targetPosition)
            end)
        end
    end)
end

function SetAutoShootState(state)
    AutoShootEnabled = state
    if state then
        if AutoShootConnection then
            task.cancel(AutoShootConnection)
        end
        AutoShootConnection = task.spawn(function()
            while AutoShootEnabled do
                PerformAutoShoot()
                task.wait(autoShootDelay)
            end
        end)
    else
        if AutoShootConnection then
            task.cancel(AutoShootConnection)
            AutoShootConnection = nil
        end
    end
end

local silentAimMobileDisimuladoEnabled = false
local showESPIndicators = true
local silentAimMobileConnections = {}
local originalMetaTableIndex
local silentAimFOVCircleDisimulado = nil
local ESP_Indicators = {}

local function RemoveESPIndicator(userId)
    if ESP_Indicators[userId] then
        ESP_Indicators[userId]:Destroy()
        ESP_Indicators[userId] = nil
    end
end

local function startSilentAimMobileDisimulado()
    if silentAimMobileDisimuladoEnabled then return end
    
    silentAimMobileDisimuladoEnabled = true

    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    
    if not getgenv then
        getgenv = function() return _G end
    end
    
    getgenv().Aimbot_Enabled = getgenv().Aimbot_Enabled == nil and true or getgenv().Aimbot_Enabled
    
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()
    
    local CurrentTarget = nil
    local IsAiming = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileReticleGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Crosshair = Instance.new("Frame")
    Crosshair.Size = UDim2.new(0, 3, 0, 3)
    Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
    Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
    Crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Crosshair.BorderSizePixel = 0
    Crosshair.Visible = true
    Crosshair.ZIndex = 10
    Crosshair.Parent = ScreenGui
    
    local CrosshairStroke = Instance.new("UIStroke", Crosshair)
    CrosshairStroke.Thickness = 1
    CrosshairStroke.ZIndex = 11

    if silentAimSettings.aimType == "FOV" then
        silentAimFOVCircleDisimulado = Drawing.new("Circle")
        silentAimFOVCircleDisimulado.Visible = false
        silentAimFOVCircleDisimulado.Thickness = 2
        silentAimFOVCircleDisimulado.Color = silentAimSettings.fovColor
        silentAimFOVCircleDisimulado.Filled = false
        silentAimFOVCircleDisimulado.Radius = silentAimSettings.fovSize
        silentAimFOVCircleDisimulado.Position = Camera.ViewportSize / 2
    end

    local function GetESPIndicator(userId)
        if ESP_Indicators[userId] and ESP_Indicators[userId].Parent then
            return ESP_Indicators[userId]
        end
        
        local indicator = Instance.new("Frame")
        indicator.AnchorPoint = Vector2.new(0.5, 0.5)
        indicator.Size = UDim2.new(0, 3, 0, 3)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.ZIndex = 5
        indicator.Parent = ScreenGui
        
        local stroke = Instance.new("UIStroke", indicator)
        stroke.Thickness = 1
        stroke.ZIndex = 6
        
        ESP_Indicators[userId] = indicator
        return indicator
    end
    
    Players.PlayerRemoving:Connect(function(player)
        RemoveESPIndicator(player.UserId)
    end)

    local function IsValidTarget(player)
        return player ~= LocalPlayer 
           and not IsTeammateGlobal(player) 
           and player.Character 
           and player.Character:FindFirstChild("HumanoidRootPart")
    end
    
    local function GetClosestEnemy()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        local maxDistance = 150
        local closestTarget = nil
        local shortestDistanceSq = maxDistance * maxDistance
        local cameraPos = Camera.CFrame.Position
        local viewportCenter = Camera.ViewportSize / 2
        
        for _, player in ipairs(Players:GetPlayers()) do
            if IsValidTarget(player) then
                local targetRoot = player.Character.HumanoidRootPart
                
                if silentAimSettings.wallCheck then
                    local direction = targetRoot.Position - cameraPos
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    local rayResult = Workspace:Raycast(cameraPos, direction, rayParams)
                    if rayResult and not rayResult.Instance:IsDescendantOf(player.Character) then
                        continue
                    end
                end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetRoot.Position)
                
                if silentAimSettings.aimType == "FOV" then
                    local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if distanceFromCenter > silentAimSettings.fovSize then
                        continue
                    end
                end
                
                local distSq = (targetRoot.Position - myRoot.Position).Magnitude ^ 2
                if distSq < shortestDistanceSq then
                    shortestDistanceSq = distSq
                    closestTarget = targetRoot
                end
            end
        end
        
        return closestTarget
    end
    
    local function GetPredictedPosition()
        if CurrentTarget then
            local predictionFactor = silentAimSettings.prediction / 100
            
            if math.random(1, 100) > silentAimSettings.prediction then
                local randomOffset = Vector3.new(
                    (math.random() * 2) - 1,
                    (math.random() * 2) - 1,
                    (math.random() * 2) - 1
                ) * 3
                return CFrame.new(CurrentTarget.Position + randomOffset)
            end
            
            return CFrame.new(CurrentTarget.Position)
        else
            return CFrame.new(Camera.CFrame.Position)
        end
    end
    
    local mt = getrawmetatable(Mouse)
    originalMetaTableIndex = mt.__index
    setreadonly(mt, false)
    
    mt.__index = function(t, k)
        if getgenv().Aimbot_Enabled and CurrentTarget then
            if k == "Hit" then
                return GetPredictedPosition()
            elseif k == "Target" then
                return CurrentTarget
            elseif k == "X" or k == "Y" then
                local screenPos = Camera:WorldToViewportPoint(GetPredictedPosition().Position)
                return k == "X" and screenPos.X or screenPos.Y
            end
        end
        return originalMetaTableIndex(t, k)
    end
    
    setreadonly(mt, true)
    
    local renderConnection = RunService.RenderStepped:Connect(function()
        if silentAimFOVCircleDisimulado then
            silentAimFOVCircleDisimulado.Position = Camera.ViewportSize / 2
            silentAimFOVCircleDisimulado.Visible = silentAimSettings.showFOV and silentAimSettings.aimType == "FOV" and getgenv().Aimbot_Enabled
            silentAimFOVCircleDisimulado.Color = silentAimSettings.fovColor
            silentAimFOVCircleDisimulado.Radius = silentAimSettings.fovSize
        end
        
        if not getgenv().Aimbot_Enabled then
            CurrentTarget = nil
            Crosshair.Visible = false
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            for _, indicator in pairs(ESP_Indicators) do indicator.Visible = false end
            return
        end
        
        local isInGame = IsInRound()
        
        if not isInGame then
            CurrentTarget = nil
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            Crosshair.Visible = true
            Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
            for _, indicator in pairs(ESP_Indicators) do indicator.Visible = false end
            return
        end
        
        CurrentTarget = GetClosestEnemy()
        
        if CurrentTarget then
            IsAiming = false
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            UserInputService.MouseIconEnabled = false
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(GetPredictedPosition().Position)
            Crosshair.Visible = true
            Crosshair.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
        else
            IsAiming = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            Crosshair.Visible = true
            Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
        
        if showESPIndicators then
            for _, player in ipairs(Players:GetPlayers()) do
                local indicator = GetESPIndicator(player.UserId)
                
                if IsValidTarget(player) then
                    local root = player.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        indicator.Visible = true
                        indicator.Position = UDim2.new(0, pos.X, 0, pos.Y)
                    else
                        indicator.Visible = false
                    end
                else
                    indicator.Visible = false
                end
            end
        else
            for _, indicator in pairs(ESP_Indicators) do
                indicator.Visible = false
            end
        end
    end)

    table.insert(silentAimMobileConnections, renderConnection)
    table.insert(silentAimMobileConnections, Players.PlayerRemoving:Connect(function(player)
        RemoveESPIndicator(player.UserId)
    end))

    getgenv().MobileReticle = {
        TurnOn = function()
            if not getgenv().Aimbot_Enabled then
                getgenv().Aimbot_Enabled = true
                IsAiming = false
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0,0,0)
                end
            end
        end,
        TurnOff = function()
            if getgenv().Aimbot_Enabled then
                getgenv().Aimbot_Enabled = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
                Crosshair.Visible = false
            end
        end,
        IsEnabled = function() return getgenv().Aimbot_Enabled end,
        IsOverrideActive = function() return IsAiming or getgenv().Aimbot_Enabled end
    }
end

local function stopSilentAimMobileDisimulado()
    if not silentAimMobileDisimuladoEnabled then return end
    
    silentAimMobileDisimuladoEnabled = false
    
    for _, connection in pairs(silentAimMobileConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    silentAimMobileConnections = {}
    
    if originalMetaTableIndex then
        local mt = getrawmetatable(game:GetService("Players").LocalPlayer:GetMouse())
        setreadonly(mt, false)
        mt.__index = originalMetaTableIndex
        setreadonly(mt, true)
    end
    
    if silentAimFOVCircleDisimulado then
        silentAimFOVCircleDisimulado:Remove()
        silentAimFOVCircleDisimulado = nil
    end
    
    if game.Players.LocalPlayer:FindFirstChild("PlayerGui") then
        local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MobileReticleGui")
        if gui then
            gui:Destroy()
        end
    end
    
    local UserInputService = game:GetService("UserInputService")
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    
    if getgenv().MobileReticle then
        getgenv().MobileReticle = nil
    end
    
    for userId, indicator in pairs(ESP_Indicators) do
        indicator:Destroy()
    end
    ESP_Indicators = {}
end

local perimeterEnabled = false
local perimeterGui = nil
local perimeterFrame = nil
local insidePlayers = {}
local perimeterConnection = nil

local corners = {
    Vector3.new(-327, 240, 35),
    Vector3.new(-328, 240, 50),
    Vector3.new(-348, 240, 50),
    Vector3.new(-348, 240, 36)
}

local minX, minY, minZ = math.huge, math.huge, math.huge
local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

for _, v in pairs(corners) do
    minX = math.min(minX, v.X)
    minY = math.min(minY, v.Y)
    minZ = math.min(minZ, v.Z)

    maxX = math.max(maxX, v.X)
    maxY = math.max(maxY, v.Y)
    maxZ = math.max(maxZ, v.Z)
end

local HEIGHT = 12
local MARGIN = 3

minY -= HEIGHT
maxY += HEIGHT

minX -= MARGIN
maxX += MARGIN
minZ -= MARGIN
maxZ += MARGIN

local function isInside(pos)
    return pos.X >= minX and pos.X <= maxX
       and pos.Y >= minY and pos.Y <= maxY
       and pos.Z >= minZ and pos.Z <= maxZ
end

local function createPerimeterGUI()
    if not perimeterEnabled then return end
    if perimeterGui then perimeterGui:Destroy() end

    perimeterGui = Instance.new("ScreenGui")
    perimeterGui.Name = "PerimeterUI"
    perimeterGui.ResetOnSpawn = false
    perimeterGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    perimeterFrame = Instance.new("ScrollingFrame")
    perimeterFrame.Size = UDim2.fromScale(0.25, 0.5)
    perimeterFrame.Position = UDim2.fromScale(0.02, 0.25)
    perimeterFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    perimeterFrame.BackgroundTransparency = 0.2
    perimeterFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    perimeterFrame.ScrollBarImageTransparency = 0.4
    perimeterFrame.Parent = perimeterGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = perimeterFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = perimeterFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = perimeterFrame

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        perimeterFrame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)
end

local function createPlayerCard(player)
    if not perimeterFrame or not perimeterFrame.Parent then return end
    if perimeterFrame:FindFirstChild(player.Name) then return end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 70)
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    card.Name = player.Name

    local cardCorner = Instance.new("UICorner")
    cardCorner.Parent = card

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(60, 60)
    avatar.Position = UDim2.fromOffset(5, 5)
    avatar.BackgroundTransparency = 1
    avatar.Parent = card

    task.spawn(function()
        local thumb = Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
        avatar.Image = thumb
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -75, 0.5, 0)
    nameLabel.Position = UDim2.fromOffset(70, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = card

    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, -75, 0.5, 0)
    userLabel.Position = UDim2.fromOffset(70, 35)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "(" .. player.Name .. ")"
    userLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    userLabel.TextScaled = true
    userLabel.Font = Enum.Font.Gotham
    userLabel.Parent = card

    card.Parent = perimeterFrame
end

local function removePlayerCard(player)
    if perimeterFrame then
        local card = perimeterFrame:FindFirstChild(player.Name)
        if card then
            card:Destroy()
        end
    end
end

local function updatePerimeter()
    if not perimeterEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local inside = isInside(hrp.Position)

                if inside and not insidePlayers[player] then
                    insidePlayers[player] = true
                    createPlayerCard(player)
                elseif not inside and insidePlayers[player] then
                    insidePlayers[player] = nil
                    removePlayerCard(player)
                end
            else
                if insidePlayers[player] then
                    insidePlayers[player] = nil
                    removePlayerCard(player)
                end
            end
        end
    end
end

local function startPerimeter()
    createPerimeterGUI()
    insidePlayers = {}
    perimeterConnection = RunService.Heartbeat:Connect(updatePerimeter)
end

local function stopPerimeter()
    if perimeterConnection then
        perimeterConnection:Disconnect()
        perimeterConnection = nil
    end
    if perimeterGui then
        perimeterGui:Destroy()
        perimeterGui = nil
    end
    insidePlayers = {}
end

local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local LocalPlayer = Players.LocalPlayer
local CHECK_INTERVAL = 0.2
local SPAM_DELAY = 0.01
local KnifeKill
while not KnifeKill do
    local found = ReplicatedStorage:FindFirstChild('KnifeKill')
    if found then
        KnifeKill = found
    else
        task.wait(0.5)
    end
end
local KILL_SPAM_ENABLED = false
local ActiveSpamThread = nil
local inZeroZeroRound = false
local timerActive = false
local timerActivationTime = 0
local function StartKillSpam()
    if ActiveSpamThread then return end
    KILL_SPAM_ENABLED = true
    ActiveSpamThread = task.spawn(function()
        while KILL_SPAM_ENABLED do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and KnifeKill then
                    pcall(function()
                        KnifeKill:FireServer(player)
                    end)
                end
            end
            task.wait(SPAM_DELAY)
        end
        ActiveSpamThread = nil
    end)
end
local function StopKillSpam()
    KILL_SPAM_ENABLED = false
    if ActiveSpamThread then
        task.cancel(ActiveSpamThread)
        ActiveSpamThread = nil
    end
end
local function findRoundTimer()
    local rg = Workspace:FindFirstChild("RunningGames")
    if not rg then return nil end
    for _, folder in ipairs(rg:GetChildren()) do
        local timer = folder:FindFirstChild("RoundTimer")
        if timer and timer:IsA("IntValue") then
            return timer
        end
    end
    return nil
end
local function getScoreTexts()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return nil, nil end
    local main = gui:FindFirstChild("Main")
    if not main then return nil, nil end
    local mgf = main:FindFirstChild("MainGameFrame")
    if not mgf then return nil, nil end
    local blueScoreFrame = mgf:FindFirstChild("TeamBlueScoreFrame")
    local redScoreFrame = mgf:FindFirstChild("TeamRedScoreFrame")
    local blueScore = blueScoreFrame and blueScoreFrame:FindFirstChild("ScoreText")
    local redScore = redScoreFrame and redScoreFrame:FindFirstChild("ScoreText")
    return blueScore, redScore
end
local function isRoundZeroZero()
    local blueScore, redScore = getScoreTexts()
    if not blueScore or not redScore then
        return false
    end
    local blue = tonumber(blueScore.Text) or 0
    local red = tonumber(redScore.Text) or 0
    return blue == 0 and red == 0
end
local autoFarmKillsThread = nil
local autoFarmKillsEnabled = false
local function mainLoop()
    while autoFarmKillsEnabled do
        local timer = nil
        while not timer and autoFarmKillsEnabled do
            timer = findRoundTimer()
            if not timer then
                task.wait(1)
            end
        end
        if not autoFarmKillsEnabled then break end
        inZeroZeroRound = false
        timerActive = false
        StopKillSpam()
        while timer and timer.Parent and autoFarmKillsEnabled do
            local timerValue = timer.Value
            if isRoundZeroZero() then
                if not inZeroZeroRound then
                    inZeroZeroRound = true
                    StartKillSpam()
                end
            else
                if inZeroZeroRound then
                    inZeroZeroRound = false
                    StopKillSpam()
                    timerActive = false
                end
                if timerValue > 0 and not timerActive then
                    timerActive = true
                    timerActivationTime = os.clock()
                    StartKillSpam()
                    task.spawn(function()
                        task.wait(9.3)
                        if timerActive and not inZeroZeroRound and autoFarmKillsEnabled then
                            StopKillSpam()
                            task.wait(6)
                            if timerActive and not inZeroZeroRound and autoFarmKillsEnabled then
                                StartKillSpam()
                            end
                        end
                    end)
                end
                if timerValue == 0 and timerActive then
                    timerActive = false
                    StopKillSpam()
                end
            end
            task.wait(CHECK_INTERVAL)
            if not timer.Parent then
                break
            end
        end
        StopKillSpam()
        inZeroZeroRound = false
        timerActive = false
        task.wait(1)
    end
end

function createMainWindow()
    local success, err = pcall(function()
        Window = Rayfield:CreateWindow({
            Name = "Synergy Hub - Murders vs Sheriff",
            LoadingTitle = "Synergy Hub",
            LoadingSubtitle = "by Xyraniz",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "synergy_hub",
                FileName = "config"
            },
            Discord = {
                Enabled = false,
                Invite = "",
                RememberJoins = false
            },
            KeySystem = false
        })

        local InfoTab = Window:CreateTab("Information", "info")
        local AimbotTab = Window:CreateTab("Aimbot", "target")
        local SilentAimTab = Window:CreateTab("Silent Aim", "crosshair")
        local HitboxTab = Window:CreateTab("Hitbox", "square")
        local VisualTab = Window:CreateTab("ESP", "eye")
        local TPTab = Window:CreateTab("TPs", "map-pin")
        local ExtraTab = Window:CreateTab("Extra", "plus")

        InfoTab:CreateParagraph({
            Title = "What is Synergy Hub?",
            Content = "A Roblox script hub optimized for gameplay. Designed to dominate in Murders vs Sheriff."
        })

        InfoTab:CreateParagraph({
            Title = "Credits",
            Content = "Xyraniz\nSynergy Team\nRayfield"
        })

        InfoTab:CreateButton({
            Name = "Discord Server",
            Callback = function()
                setclipboard("discord.gg/nCNASmNRTE")
            end,
        })

        InfoTab:CreateKeybind({
            Name = "Menu Keybind",
            CurrentKeybind = "X",
            HoldToInteract = false,
            Flag = "MenuKeybind",
            Callback = function(key)
                Window:Toggle()
            end,
        })

        pcall(initializeAimbot)
        
        aimbotConnection = RunService.RenderStepped:Connect(function()
            pcall(updateDrawings)
            if aimbotState.aimbotEnabled then
                FOVring.Visible = aimbotState.showFOV and aimbotState.aimbotEnabled and aimbotState.fovType == "Limited FOV" or false
                local closest = getTargetPlayer(aimbotState.aimbotTargetPart, aimbotState.aimbotFOVSize, true, aimbotState.aimbotVisibilityCheck)
                if closest and closest.Character and closest.Character:FindFirstChild(aimbotState.aimbotTargetPart) then
                    pcall(function() lookAt(closest.Character[aimbotState.aimbotTargetPart].Position, aimbotState.aimbotSmoothness) end)
                end
            end
            
            SilentAimFOV.Visible = silentAimSettings.showFOV and silentAimSettings.aimType == "FOV"
            
            autoShootFOVCircle.Visible = AutoShootEnabled and autoShootConfig.showFOV and autoShootConfig.mode == "FOV"
            autoShootFOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
            autoShootFOVCircle.Radius = autoShootConfig.fovSize
            autoShootFOVCircle.Color = autoShootConfig.fovColor
        end)

        AimbotTab:CreateToggle({
            Name = "Enable Aimbot",
            CurrentValue = false,
            Flag = "AimbotEnabled",
            Callback = function(v)
                aimbotState.aimbotEnabled = v
            end,
        })

        AimbotTab:CreateToggle({
            Name = "Show FOV",
            CurrentValue = false,
            Flag = "ShowFOV",
            Callback = function(v)
                aimbotState.showFOV = v
            end,
        })

        AimbotTab:CreateDropdown({
            Name = "FOV Mode",
            Options = {"Limited FOV", "Full Screen", "360 Degrees"},
            CurrentOption = "Limited FOV",
            Flag = "AimbotFOVType",
            Callback = function(v)
                aimbotState.fovType = v
            end,
        })

        AimbotTab:CreateSlider({
            Name = "Smoothness",
            Range = {0.1, 1},
            Increment = 0.05,
            CurrentValue = 1,
            Flag = "AimbotSmoothness",
            Callback = function(v)
                aimbotState.aimbotSmoothness = v
            end,
        })

        AimbotTab:CreateColorPicker({
            Name = "FOV Color",
            Color = Color3.fromRGB(128, 0, 128),
            Flag = "AimbotFOVColor",
            Callback = function(v)
                aimbotState.aimbotFOVColor = v
                if FOVring then
                    FOVring.Color = v
                end
            end,
        })

        AimbotTab:CreateSlider({
            Name = "FOV Size",
            Range = {50, 500},
            Increment = 10,
            CurrentValue = 100,
            Flag = "AimbotFOVSize",
            Callback = function(v)
                aimbotState.aimbotFOVSize = v
                if FOVring then
                    FOVring.Radius = v
                end
            end,
        })

        AimbotTab:CreateDropdown({
            Name = "Target Part",
            Options = {"Head", "HumanoidRootPart", "UpperTorso"},
            CurrentOption = "Head",
            Flag = "AimbotTargetPart",
            Callback = function(v)
                aimbotState.aimbotTargetPart = v
            end,
        })

        AimbotTab:CreateToggle({
            Name = "Wall Check",
            CurrentValue = false,
            Flag = "AimbotVisibilityCheck",
            Callback = function(v)
                aimbotState.aimbotVisibilityCheck = v
            end,
        })

        SilentAimTab:CreateToggle({
            Name = "Silent Aim (No Fail)",
            CurrentValue = false,
            Flag = "ClickShootEnabled",
            Callback = function(v)
                if v then
                    if silentAimMobileDisimuladoEnabled then
                        stopSilentAimMobileDisimulado()
                        Rayfield:SetToggle({Flag = "SilentAimMobileDisimulado", Value = false})
                    end
                end
                SetSilentAimState(v)
            end,
        })

        SilentAimTab:CreateToggle({
            Name = "Block Shoot",
            CurrentValue = false,
            Flag = "BlockShoot",
            Callback = function(v)
                SetSABlockShootState(v)
            end,
        })

        SilentAimTab:CreateToggle({
            Name = "Silent Aim (Mobile) (Prediction)",
            CurrentValue = false,
            Flag = "SilentAimMobileDisimulado",
            Callback = function(v)
                if v then
                    if SA_ClickShootEnabled then
                        SetSilentAimState(false)
                        Rayfield:SetToggle({Flag = "ClickShootEnabled", Value = false})
                    end
                    startSilentAimMobileDisimulado()
                else
                    stopSilentAimMobileDisimulado()
                end
            end,
        })

        SilentAimTab:CreateDropdown({
            Name = "Silent Aim Type",
            Options = {"Pantalla Completa", "FOV"},
            CurrentOption = "Pantalla Completa",
            Flag = "SilentAimType",
            Callback = function(v)
                silentAimSettings.aimType = v
            end,
        })

        SilentAimTab:CreateToggle({
            Name = "Mostrar FOV",
            CurrentValue = true,
            Flag = "SilentAimShowFOV",
            Callback = function(v)
                silentAimSettings.showFOV = v
            end,
        })

        SilentAimTab:CreateToggle({
            Name = "Hide ESP Squares",
            CurrentValue = true,
            Flag = "ShowESPIndicators",
            Callback = function(v)
                showESPIndicators = v
            end,
        })

        SilentAimTab:CreateColorPicker({
            Name = "FOV Color",
            Color = Color3.fromRGB(255, 255, 255),
            Flag = "SilentAimFOVColor",
            Callback = function(v)
                silentAimSettings.fovColor = v
                SilentAimFOV.Color = v
            end,
        })

        SilentAimTab:CreateSlider({
            Name = "FOV Size",
            Range = {50, 500},
            Increment = 10,
            CurrentValue = 100,
            Flag = "SilentAimFOVSize",
            Callback = function(v)
                silentAimSettings.fovSize = v
                SilentAimFOV.Radius = v
            end,
        })

        SilentAimTab:CreateSlider({
            Name = "Aim Assist Strength",
            Range = {1, 100},
            Increment = 1,
            CurrentValue = 70,
            Flag = "AimAssistStrength",
            Callback = function(v)
                SA_Config.aimAssistStrength = v / 100
            end,
        })

        SilentAimTab:CreateSlider({
            Name = "Prediction",
            Range = {1, 100},
            Increment = 1,
            CurrentValue = 80,
            Flag = "ClickShootPrediction",
            Callback = function(v)
                SA_Config.predictionStrength = v / 100
                silentAimSettings.prediction = v
            end,
        })

        SilentAimTab:CreateToggle({
            Name = "Wall Check",
            CurrentValue = false,
            Flag = "SilentAimWallCheck",
            Callback = function(v)
                silentAimSettings.wallCheck = v
            end,
        })

        HitboxTab:CreateToggle({
            Name = "Enable Hitbox",
            CurrentValue = false,
            Flag = "HitboxEnabled",
            Callback = function(v)
                HitboxSettings.Enabled = v
                
                if v then
                    task.spawn(function()
                        while HitboxSettings.Enabled do
                            pcall(function()
                                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                local isGun = tool and tool:FindFirstChild("showBeam") and tool.showBeam:IsA("RemoteEvent")
                                local isKnife = tool and not isGun

                                for _,targetPlayer in pairs(Players:GetPlayers()) do
                                    if targetPlayer.Name ~= LocalPlayer.Name then
                                        local shouldExpand = not IsTeammateGlobal(targetPlayer)
                                        local weaponMatch = (HitboxSettings.GunEnabled and isGun) or (HitboxSettings.KnifeEnabled and isKnife)
                                        if not (HitboxSettings.GunEnabled or HitboxSettings.KnifeEnabled) then
                                            weaponMatch = true
                                        end
                                        shouldExpand = shouldExpand and weaponMatch
                                        
                                        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            if HitboxSettings.AntiWall and not CheckVisibility(targetPlayer.Character.HumanoidRootPart) then
                                                restoreHitbox(targetPlayer)
                                            else
                                                local bodyParts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "UpperTorso"}
                                                for _, partName in pairs(bodyParts) do
                                                    local part = targetPlayer.Character:FindFirstChild(partName)
                                                    if part then
                                                        if not originalHitboxProperties[targetPlayer] then
                                                            originalHitboxProperties[targetPlayer] = {}
                                                        end
                                                        if not originalHitboxProperties[targetPlayer][partName] then
                                                            originalHitboxProperties[targetPlayer][partName] = {
                                                                Size = part.Size,
                                                                Transparency = part.Transparency,
                                                                Color = part.Color,
                                                                CanCollide = part.CanCollide
                                                            }
                                                        end
                                                        
                                                        if shouldExpand then
                                                            local newSize = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                                                            if part.Size ~= newSize or part.Transparency ~= HitboxSettings.Transparency or part.Color ~= HitboxSettings.Color or part.CanCollide ~= false then
                                                                part.CanCollide = false
                                                                part.Transparency = HitboxSettings.Transparency
                                                                part.Color = HitboxSettings.Color
                                                                part.Size = newSize
                                                            end
                                                        else
                                                            local props = originalHitboxProperties[targetPlayer][partName]
                                                            if part.Size ~= props.Size or part.Transparency ~= props.Transparency or part.Color ~= props.Color or part.CanCollide ~= props.CanCollide then
                                                                part.Size = props.Size
                                                                part.Transparency = props.Transparency
                                                                part.Color = props.Color
                                                                part.CanCollide = props.CanCollide
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                            wait(1)
                        end
                    end)
                else
                    pcall(restoreAllHitboxes)
                end
            end,
        })

        HitboxTab:CreateToggle({
            Name = "Hitbox (Gun)",
            CurrentValue = false,
            Flag = "HitboxGun",
            Callback = function(v)
                HitboxSettings.GunEnabled = v
            end,
        })

        HitboxTab:CreateToggle({
            Name = "Hitbox (Knife)",
            CurrentValue = false,
            Flag = "HitboxKnife",
            Callback = function(v)
                HitboxSettings.KnifeEnabled = v
            end,
        })

        HitboxTab:CreateToggle({
            Name = "Visibility Check",
            CurrentValue = false,
            Flag = "HitboxAntiWall",
            Callback = function(v)
                HitboxSettings.AntiWall = v
            end,
        })

        HitboxTab:CreateSlider({
            Name = "Size",
            Range = {1, 25},
            Increment = 1,
            CurrentValue = 12,
            Flag = "HitboxSize",
            Callback = function(v)
                HitboxSettings.Size = v
            end,
        })

        HitboxTab:CreateSlider({
            Name = "Transparency",
            Range = {0, 1},
            Increment = 0.1,
            CurrentValue = 1,
            Flag = "HitboxTransparency",
            Callback = function(v)
                HitboxSettings.Transparency = v
            end,
        })

        HitboxTab:CreateColorPicker({
            Name = "Color",
            Color = Color3.fromRGB(255, 0, 0),
            Flag = "HitboxColor",
            Callback = function(v)
                HitboxSettings.Color = v
            end,
        })

        VisualTab:CreateToggle({
            Name = "Show Names",
            CurrentValue = false,
            Flag = "ESPNames",
            Callback = function(v)
                ESPSettings.Names = v
            end,
        })

        VisualTab:CreateSection("Visual Settings")
        
        VisualTab:CreateToggle({
            Name = "Enable Highlights (Enemies)",
            CurrentValue = false,
            Flag = "HighlightsEnabled",
            Callback = function(v)
                ESPSettings.Highlights.Enabled = v
                if not v and not ESPSettings.Highlights.TeammatesEnabled then
                    for player, highlight in pairs(highlights) do
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                    highlights = {}
                else
                    for _, targetPlayer in pairs(Players:GetPlayers()) do
                        if targetPlayer ~= LocalPlayer and targetPlayer.Character then
                            createHighlightForPlayer(targetPlayer, targetPlayer.Character)
                        end
                    end
                end
            end,
        })

        VisualTab:CreateColorPicker({
            Name = "Enemy Color",
            Color = Color3.fromRGB(255, 0, 0),
            Flag = "HighlightsColor",
            Callback = function(v)
                ESPSettings.Highlights.Color = v
            end,
        })

        VisualTab:CreateSlider({
            Name = "Fill Transparency",
            Range = {0, 1},
            Increment = 0.1,
            CurrentValue = 0.5,
            Flag = "HighlightsTransparency",
            Callback = function(v)
                ESPSettings.Highlights.Transparency = v
            end,
        })

        VisualTab:CreateSection("Teammates")
        
        VisualTab:CreateToggle({
            Name = "Enable ESP Teammates",
            CurrentValue = false,
            Flag = "TeammatesESPEnabled",
            Callback = function(v)
                ESPSettings.Highlights.TeammatesEnabled = v
                if not v and not ESPSettings.Highlights.Enabled then
                    for player, highlight in pairs(highlights) do
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                    highlights = {}
                else
                    for _, targetPlayer in pairs(Players:GetPlayers()) do
                        if targetPlayer ~= LocalPlayer and targetPlayer.Character then
                            createHighlightForPlayer(targetPlayer, targetPlayer.Character)
                        end
                    end
                end
            end,
        })

        VisualTab:CreateColorPicker({
            Name = "Teammates Color",
            Color = Color3.fromRGB(135, 206, 235),
            Flag = "TeammatesColor",
            Callback = function(v)
                ESPSettings.Highlights.TeammatesColor = v
            end,
        })

        VisualTab:CreateKeybind({
            Name = "Toggle All ESP",
            CurrentKeybind = "P",
            HoldToInteract = false,
            Flag = "ToggleESPKey",
            Callback = function()
                ESPSettings.Highlights.Enabled = not ESPSettings.Highlights.Enabled
                ESPSettings.Highlights.TeammatesEnabled = not ESPSettings.Highlights.TeammatesEnabled
            end,
        })

        TPTab:CreateSection("Teleports")

        TPTab:CreateToggle({
            Name = "Auto Farm Wins",
            CurrentValue = false,
            Flag = "AutoFarm",
            Callback = function(v)
                autoFarmEnabled = v
                if v then
                    startAutoFarm()
                else
                    stopAutoFarm()
                end
            end,
        })

        TPTab:CreateToggle({
            Name = "Auto Farm Kills",
            CurrentValue = false,
            Flag = "AutoFarmKills",
            Callback = function(v)
                autoFarmKillsEnabled = v
                if v then
                    if not autoFarmKillsThread then
                        autoFarmKillsThread = task.spawn(mainLoop)
                    end
                else
                    if autoFarmKillsThread then
                        task.cancel(autoFarmKillsThread)
                        autoFarmKillsThread = nil
                    end
                    StopKillSpam()
                end
            end,
        })

        TPTab:CreateToggle({
            Name = "Anti AFK",
            CurrentValue = false,
            Flag = "AntiAFK",
            Callback = function(v)
                if v then
                    startAntiAFK()
                else
                    stopAntiAFK()
                end
            end,
        })

        TPTab:CreateSection("Left Side")

        local tpFlags = {}
        local function createTPToggle(name, flag, cf)
            table.insert(tpFlags, flag)
            TPTab:CreateToggle({
                Name = name,
                CurrentValue = false,
                Flag = flag,
                Callback = function(v)
                    if v then
                        for _, otherFlag in ipairs(tpFlags) do
                            if otherFlag ~= flag then
                                Rayfield:SetToggle({Flag = otherFlag, Value = false})
                            end
                        end
                        activeTPTarget = cf
                    else
                        if activeTPTarget == cf then
                            activeTPTarget = nil
                        end
                    end
                end,
            })
        end

        createTPToggle("1v1", "TP_Left1v1_1", CFrame.new(-300, 241, 2))
        createTPToggle("1v1", "TP_Left1v1_2", CFrame.new(-292, 241, 2))
        createTPToggle("2v2", "TP_Left2v2_1", CFrame.new(-279, 241, 2))
        createTPToggle("2v2", "TP_Left2v2_2", CFrame.new(-271, 241, 2))
        createTPToggle("3v3", "TP_Left3v3_1", CFrame.new(-258, 241, 2))
        createTPToggle("3v3", "TP_Left3v3_2", CFrame.new(-250, 241, 2))
        createTPToggle("4v4", "TP_Left4v4_1", CFrame.new(-237, 241, 2))
        createTPToggle("4v4", "TP_Left4v4_2", CFrame.new(-229, 241, 2))

        TPTab:CreateSection("Right Side")

        createTPToggle("1v1", "TP_Right1v1_1", CFrame.new(-300, 241, 34))
        createTPToggle("1v1", "TP_Right1v1_2", CFrame.new(-292, 241, 34))
        createTPToggle("2v2", "TP_Right2v2_1", CFrame.new(-279, 241, 34))
        createTPToggle("2v2", "TP_Right2v2_2", CFrame.new(-271, 241, 34))
        createTPToggle("3v3", "TP_Right3v3_1", CFrame.new(-250, 241, 33))
        createTPToggle("3v3", "TP_Right3v3_2", CFrame.new(-237, 241, 33))
        createTPToggle("4v4", "TP_Right4v4_1", CFrame.new(-229, 241, 34))
        createTPToggle("4v4", "TP_Right4v4_2", CFrame.new(-243, 69, 33))

        ExtraTab:CreateSection("Spectate Perimeter")

        ExtraTab:CreateToggle({
            Name = "Spectate Perimeter",
            CurrentValue = false,
            Flag = "PerimeterSpectate",
            Callback = function(v)
                perimeterEnabled = v
                if v then
                    startPerimeter()
                else
                    stopPerimeter()
                end
            end,
        })

        ExtraTab:CreateSection("Boxes")

        local selectedBox = nil
        ExtraTab:CreateDropdown({
            Name = "Select Box",
            Options = {
                "Knife Box #1",
                "Knife Box #2",
                "Gun Box #1",
                "Gun Box #2",
                "Mythic Box #1",
                "Mythic Box #2",
                "Mythic Box #3",
                "Mythic Box #4"
            },
            CurrentOption = "",
            Flag = "BoxDropdown",
            Callback = function(v)
                selectedBox = v
            end,
        })

        ExtraTab:CreateButton({
            Name = "Open Selected Box",
            Callback = function()
                if selectedBox then
                    local buyCase = ReplicatedStorage:FindFirstChild("BuyCase")
                    if buyCase then
                        buyCase:InvokeServer(selectedBox)
                    end
                end
            end,
        })

        ExtraTab:CreateSection("Auto Shoot")

        ExtraTab:CreateToggle({
            Name = "Auto Shoot",
            CurrentValue = false,
            Flag = "AutoShoot",
            Callback = function(v)
                SetAutoShootState(v)
            end,
        })

        ExtraTab:CreateDropdown({
            Name = "Auto Shoot Mode",
            Options = {"Pantalla Completa", "FOV"},
            CurrentOption = "Pantalla Completa",
            Flag = "AutoShootMode",
            Callback = function(v)
                autoShootConfig.mode = v
            end,
        })

        ExtraTab:CreateToggle({
            Name = "Mostrar FOV",
            CurrentValue = true,
            Flag = "AutoShootShowFOV",
            Callback = function(v)
                autoShootConfig.showFOV = v
            end,
        })

        ExtraTab:CreateSlider({
            Name = "FOV Size",
            Range = {50, 500},
            Increment = 10,
            CurrentValue = 100,
            Flag = "AutoShootFOVSize",
            Callback = function(v)
                autoShootConfig.fovSize = v
            end,
        })

        ExtraTab:CreateColorPicker({
            Name = "FOV Color",
            Color = Color3.fromRGB(255, 255, 255),
            Flag = "AutoShootFOVColor",
            Callback = function(v)
                autoShootConfig.fovColor = v
            end,
        })

        ExtraTab:CreateSlider({
            Name = "Shoot Delay",
            Range = {0.01, 3},
            Increment = 0.01,
            CurrentValue = 0.08,
            Flag = "ShootDelay",
            Callback = function(v)
                autoShootDelay = v
            end,
        })

        ExtraTab:CreateSection("Invisibility")

        ExtraTab:CreateToggle({
            Name = "Auto-Give Cloak",
            CurrentValue = false,
            Flag = "AutoGiveCloak",
            Callback = function(v)
                AutoGiveCloak = v
            end,
        })

        ExtraTab:CreateButton({
            Name = "Get Cloak",
            Callback = function()
                GiveCloakTool()
            end,
        })

        ExtraTab:CreateButton({
            Name = "Remove Cloak",
            Callback = function()
                local removed = false
                for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if t.Name == 'Invisibility Cloak' then t:Destroy(); removed = true end
                end
                if LocalPlayer.Character then
                    local t = LocalPlayer.Character:FindFirstChild('Invisibility Cloak')
                    if t then t:Destroy(); removed = true end
                end
            end,
        })

        ExtraTab:CreateSection("Inventory Viewer")

        local selectedInvPlayer = nil
        local function getPlayerNames()
            local list = {}
            for _, p in pairs(Players:GetPlayers()) do
                table.insert(list, p.Name)
            end
            return list
        end

        local invDropdown = ExtraTab:CreateDropdown({
            Name = "Select Player",
            Options = getPlayerNames(),
            CurrentOption = "",
            Flag = "InvPlayerDropdown",
            Callback = function(v)
                selectedInvPlayer = v
            end,
        })

        ExtraTab:CreateButton({
            Name = "Refresh Player List",
            Callback = function()
                invDropdown:SetOptions(getPlayerNames())
            end,
        })

        ExtraTab:CreateButton({
            Name = "View Inventory",
            Callback = function()
                if selectedInvPlayer then
                    OpenInventoryViewer(selectedInvPlayer)
                end
            end,
        })

        if InfoTab then
            InfoTab:Select()
        end
    end)
    if not success then
        warn("Error al crear la ventana principal:", err)
    end
end

createMainWindow()
