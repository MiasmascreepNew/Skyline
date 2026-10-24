
-- Example:
local SKYLINELIB = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local UIConfig = {
    CornerRadius = UDim.new(0, 6),
    ElementHeight = 32,
    FontMain = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    FontSemi = Enum.Font.GothamSemibold,
    ColorBackground = Color3.fromRGB(15, 15, 15),
    ColorSidebar = Color3.fromRGB(18, 18, 18),
    ColorElement = Color3.fromRGB(25, 25, 25),
    ColorElementHover = Color3.fromRGB(30, 30, 30),
    ColorTextMain = Color3.fromRGB(255, 255, 255),
    ColorTextDim = Color3.fromRGB(150, 150, 150)
}

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function FetchAsset(url, fileName)
    if isfile(fileName) then
        if readfile(fileName):len() < 100 then
            delfile(fileName)
        end
    end

    if not isfile(fileName) then
        local bodyData = nil

        if httpRequest then
            local response = httpRequest({
                Url = url,
                Method = "GET"
            })
            if response and (response.StatusCode == 200 or response.Success) then
                bodyData = response.Body
            end
        end

        if not bodyData then
            local success, result = pcall(function()
                return game:HttpGet(url)
            end)
            if success and #result > 100 then
                bodyData = result
            end
        end

        if bodyData then
            writefile(fileName, bodyData)
            task.wait(0.2)
        end
    end

    local assetFunc = getsynasset or getcustomasset or getasset
    if assetFunc then
        local success, res = pcall(function()
            return assetFunc(fileName)
        end)
        if success and res then
            return res
        end

        local success2, res2 = pcall(function()
            return assetFunc("workspace/" .. fileName)
        end)
        if success2 and res2 then
            return res2
        end
    end

    return ""
end

function SKYLINELIB:Init(Config)
    Config = Config or {}
    local Hub = {}
    
    local Themes = {
        SukunaVSMahoraga = { Color = Color3.fromRGB(255, 60, 60), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_222333.jpg" },
        Astolfo = { Color = Color3.fromRGB(255, 105, 180), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_224131.jpg" },
        Sukuna = { Color = Color3.fromRGB(255, 0, 0), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_224106.jpg" },
        ["Sukuna MS"] = { Color = Color3.fromRGB(255, 0, 0), Stroke = Color3.fromRGB(0, 0, 0), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_224118.jpg" },
        Itadori = { Color = Color3.fromRGB(255, 120, 120), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_221721.jpg" },
        reze = { Color = Color3.fromRGB(150, 0, 200), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_222312.jpg" },
        ["Gojo M"] = { Color = Color3.fromRGB(90, 80, 255), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260208_002655.jpg" },
        Mahoraga = { Color = Color3.fromRGB(255, 255, 255), Stroke = Color3.fromRGB(0, 0, 0), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_222256.jpg" },
        Miku = { Color = Color3.fromRGB(0, 255, 255), ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_221806.jpg" },
        teto = { 
            Color = Color3.fromRGB(255, 50, 100), 
            Gradient = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 105, 180)),
            Stroke = Color3.fromRGB(0, 0, 0),
            ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_221750.jpg" 
        },
        Minecraft = { 
            Color = Color3.fromRGB(255, 255, 0), 
            Gradient = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(144, 238, 144)),
            Stroke = Color3.fromRGB(0, 0, 0),
            ImageUrl = "https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/IMG_20260226_221738.jpg" 
        }
    }

    local CurrentThemeName = Config.SelectBackground or "Sukuna"
    local CurrentTheme = Themes[CurrentThemeName] or Themes["Sukuna"] or { Color = Color3.fromRGB(255, 255, 255) }
    local Accent = CurrentTheme.Color

    local function ApplyTextTheme(obj)
        if CurrentTheme.Gradient then
            local grad = Instance.new("UIGradient", obj)
            grad.Color = CurrentTheme.Gradient
        end
        if CurrentTheme.Stroke then
            local stroke = obj:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", obj)
            stroke.Color = CurrentTheme.Stroke
            stroke.Thickness = 1
        end
    end

    local Root = Instance.new("ScreenGui")
    Root.Name = "Skyline_Runtime"
    Root.Parent = CoreGui
    Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Trigger = Instance.new("TextButton")
    Trigger.Name = "Trigger"
    Trigger.Size = UDim2.new(0, 45, 0, 45)
    Trigger.Position = UDim2.new(0, 20, 0, 20)
    Trigger.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Trigger.BorderSizePixel = 0
    Trigger.Text = Config.ToggleName or "SKY"
    Trigger.TextColor3 = Accent
    Trigger.Font = UIConfig.FontBold
    Trigger.TextSize = 12
    Trigger.Parent = Root

    local Corner = Instance.new("UICorner", Trigger)
    Corner.CornerRadius = UDim.new(1, 0)

    local TriggerStroke = Trigger:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", Trigger)
    TriggerStroke.Color = CurrentTheme.Stroke or Accent
    TriggerStroke.Thickness = CurrentTheme.Stroke and 1 or 2
    TriggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    ApplyTextTheme(Trigger)

    local function DragHandler(gui)
        local dragging, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    DragHandler(Trigger)

    local BaseFrame = Instance.new("Frame")
    BaseFrame.Size = Config.Size or UDim2.fromOffset(450, 320)
    BaseFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    BaseFrame.BackgroundColor3 = UIConfig.ColorBackground
    BaseFrame.ClipsDescendants = true
    BaseFrame.Parent = Root
    Instance.new("UICorner", BaseFrame).CornerRadius = UIConfig.CornerRadius

    local TopBar = Instance.new("Frame", BaseFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundTransparency = 1
    
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "SKYLINELIB"
    TitleLabel.TextColor3 = Accent
    TitleLabel.Font = UIConfig.FontBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = "Left"
    ApplyTextTheme(TitleLabel)

    local VisualLayer = Instance.new("ImageLabel", BaseFrame)
    VisualLayer.Name = "BackgroundVisual"
    VisualLayer.Size = UDim2.new(1, 0, 1, 0)
    VisualLayer.BackgroundTransparency = 1
    VisualLayer.ImageTransparency = Config.BackgroundImageTransparency or 0
    VisualLayer.ScaleType = Enum.ScaleType.Stretch
    VisualLayer.ZIndex = 0

    if CurrentTheme and CurrentTheme.ImageUrl then
        task.spawn(function()
            local safeFileName = string.gsub(CurrentThemeName, "[^%w_]", "_") .. "_bg.png"
            local localAsset = FetchAsset(CurrentTheme.ImageUrl, safeFileName)
            if localAsset ~= "" then
                VisualLayer.Image = localAsset
            end
            if CurrentTheme.ImageDimensions then
                VisualLayer.ImageRectSize = CurrentTheme.ImageDimensions
            end
        end)
    end

    local NavSide = Instance.new("Frame", BaseFrame)
    NavSide.Size = UDim2.new(0, Config.SideBarWidth or 130, 1, -35)
    NavSide.Position = UDim2.new(0, 0, 0, 35)
    NavSide.BackgroundColor3 = UIConfig.ColorSidebar
    NavSide.BackgroundTransparency = 0.4
    
    local NavLayout = Instance.new("UIListLayout", NavSide)
    NavLayout.Padding = UDim.new(0, 4)
    NavLayout.HorizontalAlignment = "Center"

    local Viewport = Instance.new("Frame", BaseFrame)
    Viewport.Size = UDim2.new(1, -(Config.SideBarWidth or 130) - 20, 1, -45)
    Viewport.Position = UDim2.new(0, (Config.SideBarWidth or 130) + 10, 0, 40)
    Viewport.BackgroundTransparency = 1

    DragHandler(BaseFrame)
    Trigger.MouseButton1Click:Connect(function() BaseFrame.Visible = not BaseFrame.Visible end)

    local Pages = {} 
    local IsFirst = true

    function Hub:AddMenu(opts)
        local Page = {} 
        local OrderIndex = 0
        
        local MenuBtn = Instance.new("TextButton", NavSide)
        MenuBtn.Size = UDim2.new(0.9, 0, 0, 30)
        MenuBtn.Text = opts.Title
        MenuBtn.BackgroundColor3 = UIConfig.ColorElementHover
        MenuBtn.BackgroundTransparency = IsFirst and 0.2 or 1
        MenuBtn.TextColor3 = IsFirst and Accent or UIConfig.ColorTextDim
        MenuBtn.Font = UIConfig.FontSemi 
        MenuBtn.TextSize = 12 
        Instance.new("UICorner", MenuBtn).CornerRadius = UIConfig.CornerRadius
        
        local grad, stroke
        if CurrentTheme.Gradient then
            grad = Instance.new("UIGradient", MenuBtn)
            grad.Color = CurrentTheme.Gradient
            grad.Enabled = IsFirst
        end
        if CurrentTheme.Stroke then
            stroke = Instance.new("UIStroke", MenuBtn)
            stroke.Color = CurrentTheme.Stroke
            stroke.Thickness = 1
            stroke.Enabled = IsFirst
        end

        local Container = Instance.new("ScrollingFrame", Viewport)
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = IsFirst
        Container.ScrollBarThickness = 2
        Container.ScrollBarImageColor3 = Accent
        Container.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local List = Instance.new("UIListLayout", Container)
        List.Padding = UDim.new(0, 6)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
        end)

        table.insert(Pages, {Btn = MenuBtn, Content = Container, Grad = grad, Stroke = stroke})
        IsFirst = false

        MenuBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do 
                p.Content.Visible = false 
                p.Btn.BackgroundTransparency = 1 
                p.Btn.TextColor3 = UIConfig.ColorTextDim
                if p.Grad then p.Grad.Enabled = false end
                if p.Stroke then p.Stroke.Enabled = false end
            end
            Container.Visible = true 
            MenuBtn.BackgroundTransparency = 0.2 
            MenuBtn.TextColor3 = Accent
            if grad then grad.Enabled = true end
            if stroke then stroke.Enabled = true end
        end)

        function Page:Title(t)
            OrderIndex = OrderIndex + 1
            local l = Instance.new("TextLabel", Container)
            l.LayoutOrder = OrderIndex
            l.Size = UDim2.new(1, -10, 0, 25)
            l.BackgroundTransparency = 1
            l.Text = t:upper()
            l.TextColor3 = Accent
            l.Font = UIConfig.FontBold
            l.TextSize = 11
            l.TextXAlignment = "Left"
            ApplyTextTheme(l)
        end

        function Page:Execute(cfg)
            OrderIndex = OrderIndex + 1
            local b = Instance.new("TextButton", Container)
            b.LayoutOrder = OrderIndex
            b.Size = UDim2.new(1, -10, 0, UIConfig.ElementHeight)
            b.BackgroundColor3 = UIConfig.ColorElement
            b.Text = cfg.Title
            b.TextColor3 = UIConfig.ColorTextMain
            b.Font = UIConfig.FontMain
            b.TextSize = 12
            Instance.new("UICorner", b).CornerRadius = UIConfig.CornerRadius
            b.MouseButton1Click:Connect(function() if cfg.Callback then cfg.Callback() end end)
        end

        function Page:Switch(cfg)
            OrderIndex = OrderIndex + 1
            local f = Instance.new("Frame", Container)
            f.LayoutOrder = OrderIndex
            f.Size = UDim2.new(1, -10, 0, UIConfig.ElementHeight)
            f.BackgroundColor3 = UIConfig.ColorElement
            Instance.new("UICorner", f).CornerRadius = UIConfig.CornerRadius
            
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -45, 1, 0)
            l.Position = UDim2.new(0, 10, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = cfg.Title
            l.TextColor3 = UIConfig.ColorTextMain
            l.Font = UIConfig.FontMain
            l.TextSize = 12
            l.TextXAlignment = "Left"
            
            local s = Instance.new("TextButton", f)
            s.Size = UDim2.new(0, 28, 0, 14)
            s.Position = UDim2.new(1, -38, 0.5, -7)
            s.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            s.Text = ""
            Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
            
            local d = Instance.new("Frame", s)
            d.Size = UDim2.new(0, 10, 0, 10)
            d.Position = UDim2.new(0, 2, 0.5, -5)
            d.BackgroundColor3 = UIConfig.ColorTextMain
            Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
            
            local active = cfg.Active or false
            local function sync()
                TweenService:Create(d, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
                TweenService:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = active and Accent or Color3.fromRGB(50, 50, 50)}):Play()
                if cfg.Callback then cfg.Callback(active) end
            end
            
            sync()
            s.MouseButton1Click:Connect(function() active = not active; sync() end)
        end

        function Page:Value(cfg)
            OrderIndex = OrderIndex + 1
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local default = cfg.Default or min
            
            local f = Instance.new("Frame", Container)
            f.LayoutOrder = OrderIndex
            f.Size = UDim2.new(1, -10, 0, 45)
            f.BackgroundColor3 = UIConfig.ColorElement
            Instance.new("UICorner", f).CornerRadius = UIConfig.CornerRadius
            
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -20, 0, 20)
            l.Position = UDim2.new(0, 10, 0, 5)
            l.BackgroundTransparency = 1
            l.Text = cfg.Title .. ": " .. default
            l.TextColor3 = UIConfig.ColorTextMain
            l.Font = UIConfig.FontMain
            l.TextSize = 12
            l.TextXAlignment = "Left"
            
            local bg = Instance.new("Frame", f)
            bg.Size = UDim2.new(1, -20, 0, 4)
            bg.Position = UDim2.new(0, 10, 0, 30)
            bg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            
            local fill = Instance.new("Frame", bg)
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Accent
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max - min) * pos)
                l.Text = cfg.Title .. ": " .. val
                if cfg.Callback then cfg.Callback(val) end
            end
            
            bg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
        end

        function Page:Pick(cfg)
            OrderIndex = OrderIndex + 1
            local open = false
            local f = Instance.new("Frame", Container)
            f.LayoutOrder = OrderIndex
            f.Size = UDim2.new(1, -10, 0, UIConfig.ElementHeight)
            f.BackgroundColor3 = UIConfig.ColorElement
            f.ClipsDescendants = true
            Instance.new("UICorner", f).CornerRadius = UIConfig.CornerRadius
            
            local btn = Instance.new("TextButton", f)
            btn.Size = UDim2.new(1, 0, 0, UIConfig.ElementHeight)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -40, 0, UIConfig.ElementHeight)
            l.Position = UDim2.new(0, 10, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = cfg.Title .. " (None)"
            l.TextColor3 = UIConfig.ColorTextMain
            l.Font = UIConfig.FontMain
            l.TextSize = 12
            l.TextXAlignment = "Left"
            
            local a = Instance.new("TextLabel", f)
            a.Size = UDim2.new(0, 35, 0, UIConfig.ElementHeight)
            a.Position = UDim2.new(1, -35, 0, 0)
            a.BackgroundTransparency = 1
            a.Text = "V"
            a.TextColor3 = Accent
            a.Font = UIConfig.FontBold
            a.TextSize = 10
            ApplyTextTheme(a)
            
            local list = Instance.new("Frame", f)
            list.Size = UDim2.new(1, 0, 0, 0)
            list.Position = UDim2.new(0, 0, 0, UIConfig.ElementHeight)
            list.BackgroundTransparency = 1
            
            local lay = Instance.new("UIListLayout", list)
            lay.Padding = UDim.new(0, 2)

            local function toggle()
                open = not open
                local targetSize = open and UDim2.new(1, -10, 0, UIConfig.ElementHeight + lay.AbsoluteContentSize.Y + 5) or UDim2.new(1, -10, 0, UIConfig.ElementHeight)
                TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
                TweenService:Create(a, TweenInfo.new(0.3), {Rotation = open and 180 or 0}):Play()
            end

            btn.MouseButton1Click:Connect(toggle)

            for _, v in pairs(cfg.Options) do
                local o = Instance.new("TextButton", list)
                o.Size = UDim2.new(1, -10, 0, 25)
                o.BackgroundColor3 = UIConfig.ColorElementHover
                o.Text = v
                o.TextColor3 = Color3.fromRGB(200, 200, 200)
                o.Font = UIConfig.FontMain
                o.TextSize = 11
                Instance.new("UICorner", o).CornerRadius = UIConfig.CornerRadius
                
                o.MouseButton1Click:Connect(function()
                    l.Text = cfg.Title .. " (" .. v .. ")"
                    toggle()
                    if cfg.Callback then cfg.Callback(v) end
                end)
            end
        end

        function Page:Insert(cfg)
            OrderIndex = OrderIndex + 1
            local w = Instance.new("Frame", Container)
            w.LayoutOrder = OrderIndex
            w.Size = UDim2.new(1, -10, 0, 62)
            w.BackgroundTransparency = 1
            
            local t = Instance.new("TextLabel", w)
            t.Size = UDim2.new(1, 0, 0, 22)
            t.BackgroundTransparency = 1
            t.Text = cfg.Title
            t.TextColor3 = Color3.fromRGB(230, 230, 230)
            t.Font = UIConfig.FontSemi
            t.TextSize = 13
            t.TextXAlignment = "Left"
            
            local b = Instance.new("Frame", w)
            b.Size = UDim2.new(1, 0, 0, 34)
            b.Position = UDim2.new(0, 0, 0, 26)
            b.BackgroundColor3 = UIConfig.ColorElementHover
            Instance.new("UICorner", b).CornerRadius = UIConfig.CornerRadius
            
            local s = Instance.new("UIStroke", b)
            s.Color = Color3.fromRGB(55, 55, 55)
            s.Thickness = 1.2
            
            local i = Instance.new("TextBox", b)
            i.Size = UDim2.new(1, -24, 1, 0)
            i.Position = UDim2.new(0, 12, 0, 0)
            i.BackgroundTransparency = 1
            i.Text = cfg.Default or ""
            i.PlaceholderText = cfg.Placeholder or "Type here..."
            i.TextColor3 = UIConfig.ColorTextMain
            i.Font = UIConfig.FontMain
            i.TextSize = 13
            i.TextXAlignment = "Left"
            i.ClearTextOnFocus = false
            
            i.FocusLost:Connect(function(res) if cfg.Callback then cfg.Callback(i.Text, res) end end)
        end

        function Page:Doc(cfg)
            OrderIndex = OrderIndex + 1
            local f = Instance.new("Frame", Container)
            f.LayoutOrder = OrderIndex
            f.Size = UDim2.new(1, -10, 0, 0)
            f.BackgroundColor3 = UIConfig.ColorElement
            f.AutomaticSize = "Y"
            Instance.new("UICorner", f).CornerRadius = UIConfig.CornerRadius
            
            local l = Instance.new("UIListLayout", f)
            l.Padding = UDim.new(0, 2)
            l.HorizontalAlignment = "Center"
            
            local t = Instance.new("TextLabel", f)
            t.Size = UDim2.new(1, -16, 0, 20)
            t.BackgroundTransparency = 1
            t.Text = cfg.Title
            t.TextColor3 = Accent
            t.Font = UIConfig.FontBold
            t.TextSize = 12
            t.TextXAlignment = "Left"
            ApplyTextTheme(t)
            
            local d = Instance.new("TextLabel", f)
            d.Size = UDim2.new(1, -16, 0, 0)
            d.AutomaticSize = "Y"
            d.BackgroundTransparency = 1
            d.Text = cfg.Desc
            d.TextColor3 = Color3.fromRGB(180, 180, 180)
            d.Font = UIConfig.FontMain
            d.TextSize = 11
            d.TextWrapped = true
            d.TextXAlignment = "Left"
            
            local pad = Instance.new("UIPadding", f)
            pad.PaddingTop = UDim.new(0, 5)
            pad.PaddingBottom = UDim.new(0, 5)
            pad.PaddingLeft = UDim.new(0, 8)
        end

        function Page:Image(cfg)
            OrderIndex = OrderIndex + 1
            local img = Instance.new("ImageLabel", Container)
            img.LayoutOrder = OrderIndex
            img.Size = UDim2.new(1, -10, 0, cfg.Height or 150)
            img.Image = cfg.Image
            img.BackgroundTransparency = 1
            img.ScaleType = Enum.ScaleType.Fit
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, cfg.Radius or 9)
        end

        return Page
    end

    function Hub:LockedTab(cfg)
        local btn = Instance.new("TextButton", NavSide)
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Text = "🔒 " .. cfg.Title
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.TextColor3 = Color3.fromRGB(80, 80, 80)
        btn.Font = UIConfig.FontSemi
        btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UIConfig.CornerRadius
        
        btn.MouseButton1Click:Connect(function()
            Hub:Message({Title = cfg.NotifyTitle or "Locked", Desc = cfg.NotifyDesc or "This section is restricted."})
        end)
    end

    function Hub:Message(cfg)
        local n = Instance.new("Frame", Root)
        n.Size = UDim2.new(0, 220, 0, 60)
        n.Position = UDim2.new(1, 10, 1, -70)
        n.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", n).CornerRadius = UIConfig.CornerRadius
        
        local s = Instance.new("UIStroke", n)
        s.Color = Accent
        
        local t = Instance.new("TextLabel", n)
        t.Size = UDim2.new(1, -10, 0, 20)
        t.Position = UDim2.new(0, 5, 0, 5)
        t.BackgroundTransparency = 1
        t.Text = cfg.Title
        t.TextColor3 = Accent
        t.Font = UIConfig.FontBold
        t.TextSize = 13
        ApplyTextTheme(t)
        
        local d = Instance.new("TextLabel", n)
        d.Size = UDim2.new(1, -10, 0, 30)
        d.Position = UDim2.new(0, 5, 0, 25)
        d.BackgroundTransparency = 1
        d.Text = cfg.Desc
        d.TextColor3 = Color3.fromRGB(200, 200, 200)
        d.Font = UIConfig.FontMain
        d.TextSize = 11
        d.TextWrapped = true
        
        TweenService:Create(n, TweenInfo.new(0.4), {Position = UDim2.new(1, -230, 1, -70)}):Play()
        task.delay(cfg.Time or 3, function() 
            TweenService:Create(n, TweenInfo.new(0.4), {Position = UDim2.new(1, 10, 1, -70)}):Play()
            task.wait(0.4) 
            n:Destroy() 
        end)
    end

    return Hub
end

return SKYLINELIB
