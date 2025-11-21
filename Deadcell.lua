local settings = {
    folder_name = "visajas";
    default_accent = Color3.fromRGB(61, 100, 227);
};

local function load_custom_font()
    local v2="Font_"..tostring(math.random(10000,99999))
    local v24="Folder_"..tostring(math.random(10000,99999))
    if isfolder("UI_Fonts") then delfolder("UI_Fonts") end
    makefolder(v24)
    local v3=v24.."/"..v2..".ttf"
    local v4=v24.."/"..v2..".json"
    local v5=v24.."/"..v2..".rbxmx"
    
    if not isfile(v3) then
        local v8=pcall(function()
            local v9=request({Url="https://raw.githubusercontent.com/bluescan/proggyfonts/refs/heads/master/ProggyOriginal/ProggyClean.ttf",Method="GET"})
            if v9 and v9.Success then 
                writefile(v3,v9.Body)
                return true 
            end
            return false
        end)
        if not v8 then 
            return Font.fromEnum(Enum.Font.Code)
        end
    end
    
    local v12=pcall(function()
        local v13=readfile(v3)
        local v14=game:GetService("TextService"):RegisterFontFaceAsync(v13,v2)
        return v14
    end)
    if v12 then return v12 end
    
    local v15=pcall(function()
        return Font.fromFilename(v3)
    end)
    if v15 then return v15 end
    
    local v16={name=v2,faces={{name="Regular",weight=400,style="Normal",assetId=getcustomasset(v3)}}}
    writefile(v4,game:GetService("HttpService"):JSONEncode(v16))
    local v17,v18=pcall(function()
        return Font.new(getcustomasset(v4))
    end)
    if v17 then return v18 end
    
    local v19=[[
<?xml version="1.0" encoding="utf-8"?>
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
<External>null</External>
<External>nil</External>
<Item class="FontFace" referent="RBX0">
<Properties>
<Content name="FontData">
<url>rbxasset://]]..v3..[[</url>
</Content>
<string name="Family">]]..v2..[[</string>
<token name="Style">0</token>
<token name="Weight">400</token>
</Properties>
</Item>
</roblox>]]
    writefile(v5,v19)
    return Font.fromEnum(Enum.Font.Code)
end

local custom_font = load_custom_font()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VisaJasUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local function create_drawing_library()
    local drawing = {}
    drawing.__index = drawing
    
    function drawing.new(type)
        local self = setmetatable({}, drawing)
        self.Type = type
        self.Visible = true
        self.ZIndex = 1
        self.Transparency = 1
        self.Color = Color3.new(1, 1, 1)
        self.Size = UDim2.new(0, 100, 0, 100)
        self.Position = UDim2.new(0, 0, 0, 0)
        self.Filled = false
        self.Thickness = 1
        self.Text = ""
        self.FontFace = custom_font
        self.TextSize = 14
        self.Outline = false
        self.OutlineColor = Color3.new(0, 0, 0)
        self.Center = false
        self.Parent = nil
        
        if type == "Square" then
            self.Instance = Instance.new("Frame")
            self.Instance.BackgroundColor3 = self.Color
            self.Instance.BorderSizePixel = 0
            self.Instance.Size = self.Size
            self.Instance.Position = self.Position
            self.Instance.BackgroundTransparency = self.Transparency
            self.Instance.ZIndex = self.ZIndex
            self.Instance.Parent = screenGui
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""
            button.ZIndex = self.ZIndex + 10
            button.Parent = self.Instance
            
            self.MouseButton1Click = button.MouseButton1Click
            self.MouseButton1Down = button.MouseButton1Down
            self.MouseButton1Up = button.MouseButton1Up
            self.MouseEnter = button.MouseEnter
            self.MouseLeave = button.MouseLeave
            
        elseif type == "Text" then
            self.Instance = Instance.new("TextLabel")
            self.Instance.BackgroundTransparency = 1
            self.Instance.TextColor3 = self.Color
            self.Instance.Text = self.Text
            self.Instance.FontFace = self.FontFace
            self.Instance.TextSize = self.TextSize
            self.Instance.Size = self.Size
            self.Instance.Position = self.Position
            self.Instance.ZIndex = self.ZIndex
            self.Instance.TextTransparency = self.Transparency
            self.Instance.TextXAlignment = self.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
            self.Instance.Parent = screenGui
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""
            button.ZIndex = self.ZIndex + 10
            button.Parent = self.Instance
            
            self.MouseButton1Click = button.MouseButton1Click
            self.MouseButton1Down = button.MouseButton1Down
            self.MouseButton1Up = button.MouseButton1Up
            self.MouseEnter = button.MouseEnter
            self.MouseLeave = button.MouseLeave
        end
        
        return self
    end
    
    function drawing:Remove()
        if self.Instance then
            self.Instance:Destroy()
        end
    end
    
    function drawing:AddListLayout(padding)
        if self.Instance then
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.Padding = UDim.new(0, padding or 0)
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Parent = self.Instance
        end
    end
    
    function drawing:MakeScrollable()
        if self.Instance then
            local scrollingFrame = Instance.new("ScrollingFrame")
            scrollingFrame.Size = self.Instance.Size
            scrollingFrame.Position = self.Instance.Position
            scrollingFrame.BackgroundTransparency = 1
            scrollingFrame.ScrollBarThickness = 0
            scrollingFrame.ZIndex = self.Instance.ZIndex
            scrollingFrame.Parent = self.Instance.Parent
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""
            button.ZIndex = self.Instance.ZIndex + 10
            button.Parent = scrollingFrame
            
            self.MouseButton1Click = button.MouseButton1Click
            self.MouseButton1Down = button.MouseButton1Down
            self.MouseButton1Up = button.MouseButton1Up
            
            self.Instance.Size = UDim2.new(1, 0, 1, 0)
            self.Instance.Position = UDim2.new(0, 0, 0, 0)
            self.Instance.Parent = scrollingFrame
            
            self.Instance = scrollingFrame
        end
    end
    
    function drawing:RefreshScrolling()
        if self.Instance and self.Instance:IsA("ScrollingFrame") then
        end
    end
    
    function drawing:__newindex(key, value)
        rawset(self, key, value)
        
        if self.Instance then
            if key == "Visible" then
                self.Instance.Visible = value
            elseif key == "Transparency" then
                if self.Instance:IsA("Frame") then
                    self.Instance.BackgroundTransparency = value
                elseif self.Instance:IsA("TextLabel") then
                    self.Instance.TextTransparency = value
                end
            elseif key == "Color" then
                if self.Instance:IsA("Frame") then
                    self.Instance.BackgroundColor3 = value
                elseif self.Instance:IsA("TextLabel") then
                    self.Instance.TextColor3 = value
                end
            elseif key == "Size" then
                self.Instance.Size = value
            elseif key == "Position" then
                self.Instance.Position = value
            elseif key == "Text" then
                if self.Instance:IsA("TextLabel") then
                    self.Instance.Text = value
                end
            elseif key == "FontFace" then
                if self.Instance:IsA("TextLabel") then
                    self.Instance.FontFace = value
                end
            elseif key == "TextSize" then
                if self.Instance:IsA("TextLabel") then
                    self.Instance.TextSize = value
                end
            elseif key == "Center" then
                if self.Instance:IsA("TextLabel") then
                    self.Instance.TextXAlignment = value and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
                end
            elseif key == "Parent" then
                if value and value.Instance then
                    self.Instance.Parent = value.Instance
                else
                    self.Instance.Parent = screenGui
                end
            elseif key == "ZIndex" then
                self.Instance.ZIndex = value
                if self.Instance:FindFirstChildWhichIsA("TextButton") then
                    self.Instance:FindFirstChildWhichIsA("TextButton").ZIndex = value + 10
                end
            end
        end
    end
    
    drawing.Fonts = {
        Plex = custom_font,
        UI = custom_font,
        System = custom_font,
        Monospace = custom_font
    }
    
    return drawing
end

local drawing = create_drawing_library()

local function create_tween_library()
    local tween = {}
    
    function tween.new(instance, tweenInfo, properties)
        local tweenService = game:GetService("TweenService")
        local tweenObject = tweenService:Create(instance.Instance, tweenInfo, properties)
        
        return {
            Play = function()
                tweenObject:Play()
            end,
            Pause = function()
                tweenObject:Pause()
            end,
            Cancel = function()
                tweenObject:Cancel()
            end
        }
    end
    
    return tween
end

local tween = create_tween_library()

if not isfolder(settings.folder_name) then
    makefolder(settings.folder_name);
    makefolder(settings.folder_name.."/configs");
    makefolder(settings.folder_name.."/assets");
end;

local services = setmetatable({}, {
    __index = function(_, k)
        k = (k == "InputService" and "UserInputService") or k
        return game:GetService(k)
    end
})

local client = services.Players.LocalPlayer

local utility = {}
local totalunnamedflags = 0

function utility.dragify(main, dragoutline, object)
    local start, objectposition, dragging, currentpos

    local function handleInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            dragoutline.Visible = true
            objectposition = object.Position
        end
    end

    local function handleMove(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                currentpos = UDim2.new(objectposition.X.Scale, objectposition.X.Offset + (input.Position - start).X, objectposition.Y.Scale, objectposition.Y.Offset + (input.Position - start).Y)
                dragoutline.Position = currentpos
            end
        end
    end

    local function handleEnd(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then 
            dragging = false
            dragoutline.Visible = false
            object.Position = currentpos
        end
    end

    main.MouseButton1Down:Connect(handleInput)
    utility.connect(services.InputService.InputChanged, handleMove)
    utility.connect(services.InputService.InputEnded, handleEnd)
end

function utility.textlength(str, font, fontsize)
    local text = drawing.new("Text")
    text.Text = str
    text.FontFace = font
    text.TextSize = fontsize

    local textbounds = text.Instance.TextBounds
    text:Remove()

    return textbounds
end

function utility.getcenter(sizeX, sizeY)
    return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
end

function utility.table(tbl, usemt)
    tbl = tbl or {}

    local oldtbl = table.clone(tbl)
    table.clear(tbl)

    for i, v in next, oldtbl do
        if type(i) == "string" then
            tbl[i:lower()] = v
        else
            tbl[i] = v
        end
    end

    if usemt == true then
        setmetatable(tbl, {
            __index = function(t, k)
                return rawget(t, k:lower()) or rawget(t, k)
            end,

            __newindex = function(t, k, v)
                if type(k) == "string" then
                    rawset(t, k:lower(), v)
                else
                    rawset(t, k, v)
                end
            end
        })
    end

    return tbl
end

function utility.colortotable(color)
    local r, g, b = math.floor(color.R * 255),  math.floor(color.G * 255), math.floor(color.B * 255)
    return {r, g, b}
end

function utility.tabletocolor(tbl)
    return Color3.fromRGB(unpack(tbl))
end

function utility.round(number, float)
    return float * math.floor(number / float)
end

function utility.getrgb(color)
    local r = color.R * 255
    local g = color.G * 255
    local b = color.B * 255

    return r, g, b
end

function utility.changecolor(color, number)
    local r, g, b = utility.getrgb(color)
    r, g, b = math.clamp(r + number, 0, 255), math.clamp(g + number, 0, 255), math.clamp(b + number, 0, 255)
    return Color3.fromRGB(r, g, b)
end

function utility.nextflag()
    totalunnamedflags = totalunnamedflags + 1
    return string.format("%.14g", totalunnamedflags)
end

function utility.rgba(r, g, b, alpha)
    local rgb = Color3.fromRGB(r, g, b)
    local mt = table.clone(getrawmetatable(rgb))

    setreadonly(mt, false)
    local old = mt.__index

    mt.__index = newcclosure(function(self, key)
        if key:lower() == "a" then
            return alpha
        end

        return old(self, key)
    end)

    setrawmetatable(rgb, mt)

    return rgb
end

function utility.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(library.connections, connection)

    return connection
end

function utility.disconnect(connection)
    local index = table.find(library.connections, connection)
    connection:Disconnect()

    if index then
        table.remove(library.connections, index)
    end
end

local themes = {
    ["Default"] = {
        ["Accent"] = settings.default_accent,
        ["Window Outline Background"] = Color3.fromRGB(39,39,47),
        ["Window Inline Background"] = Color3.fromRGB(23,23,30),
        ["Window Holder Background"] = Color3.fromRGB(32,32,38),
        ["Page Unselected"] = Color3.fromRGB(32,32,38),
        ["Page Selected"] = Color3.fromRGB(55,55,64),
        ["Section Background"] = Color3.fromRGB(27,27,34),
        ["Section Inner Border"] = Color3.fromRGB(50,50,58),
        ["Section Outer Border"] = Color3.fromRGB(19,19,27),
        ["Window Border"] = Color3.fromRGB(58,58,67),
        ["Text"] = Color3.fromRGB(245, 245, 245),
        ["Risky Text"] = Color3.fromRGB(245, 239, 120),
        ["Object Background"] = Color3.fromRGB(41,41,50)
    };
}

local themeobjects = {}
local library = {theme = table.clone(themes.Default),currentcolor = nil, folder = "visajas", flags = {}, open = true, mousestate = services.InputService.MouseIconEnabled, cursor = nil, holder = nil, connections = {}, notifications = {}};
local decode = (syn and syn.crypt.base64.decode) or (crypt and crypt.base64decode) or base64_decode

library.utility = utility

function utility.outline(obj, color)
    local outline = drawing:new("Square")
    outline.Parent = obj
    outline.Size = UDim2.new(1, 2, 1, 2)
    outline.Position = UDim2.new(0, -1, 0, -1)
    outline.ZIndex = obj.ZIndex - 1

    if typeof(color) == "Color3" then
        outline.Color = color
    else
        outline.Color = library.theme[color]
        themeobjects[outline] = color
    end

    outline.Parent = obj
    outline.Filled = false
    outline.Thickness = 1

    return outline
end

function utility.create(class, properties)
    local obj = drawing:new(class)

    for prop, v in next, properties do
        if prop == "Theme" then
            themeobjects[obj] = v
            obj.Color = library.theme[v]
        else
            obj[prop] = v
        end
    end

    return obj
end

function utility.changeobjecttheme(object, color)
    themeobjects[object] = color
    object.Color = library.theme[color]
end

function utility.hextorgb(hex)
    return Color3.fromRGB(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x"..hex:sub(5, 6)))
end

local accentobjs = {}

local flags = {}

local configignores = {}

function library:ConfigIgnore(flag)
    table.insert(configignores, flag)
end

function library:Close()
    self.open = not self.open

    if self.holder then
        self.holder.Visible = self.open
    end

    if self.cursor then
        self.cursor.Visible = self.open
    end
end

function library:ChangeThemeOption(option, color)
    self.theme[option] = color

    for obj, theme in next, themeobjects do
        if rawget(obj, "exists") == true and theme == option then
            obj.Color = color
        end
    end
end

function library:SetTheme(theme)
    self.currenttheme = theme

    self.theme = table.clone(theme)

    for object, color in next, themeobjects do
        if rawget(object, "exists") == true then
            object.Color = self.theme[color]
        end
    end
end

function library.notify(message, time, color)
    time = time or 5

    local notification = {};

    library.notifications[notification] = true

    do
        local objs = notification;
        local z = 10;

        notification.holder = utility.create('Square', {
            Position = UDim2.new(0, 0, 0, 75);
            Transparency = 0;
            Thickness = 1;
        })
        
        notification.background = utility.create('Square', {
            Size = UDim2.new(1,0,1,0);
            Position = UDim2.new(0, -500, 0, 0);
            Parent = notification.holder;
            Theme = 'Object Background';
            ZIndex = z;
            Thickness = 1;
            Filled = true;
        })

        notification.border1 = utility.create('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            Theme = 'Section Inner Border';
            Parent = notification.background;
            ZIndex = z-1;
            Thickness = 1;
            Filled = true;
        })

        objs.border2 = utility.create('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            Theme = 'Section Outer Border';
            Parent = objs.border1;
            ZIndex = z-2;
            Thickness = 1;
            Filled = true;
        })

        notification.accentBar = utility.create('Square',{
            Size = UDim2.new(0,1,1,1);
            Position = UDim2.new(0,-1,0,0);
            Parent = notification.background;
            Theme = color == nil and 'Accent' or '';
            ZIndex = z+5;
            Thickness = 1;
            Filled = true;
        })

        notification.accentBottomBar = utility.create('Square',{
            Size = UDim2.new(0,0,0,1);
            Position = UDim2.new(0,0,1,0);
            Parent = notification.background;
            Theme = color == nil and 'Accent' or '';
            ZIndex = z+5;
            Thickness = 1;
            Filled = true;
        })

        notification.text = utility.create('Text', {
            Position = UDim2.new(0,5,0,2);
            Theme = 'Text';
            Text = message;
            Outline = true;
            FontFace = custom_font;
            Size = 13;
            ZIndex = z+4;
            Parent = notification.background;
        })

        if color then
            notification.accentBar.Color = color;
        end

    end

    function notification:remove()
        self.holder:Remove();
        library.notifications[notification] = nil;
        library.update_notifications()
    end

    task.spawn(function()
        library.update_notifications();
        notification.background.Size = UDim2.new(0, notification.text.TextBounds.X + 10, 0, 19)
        local sizetween = tween.new(notification.accentBottomBar, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0, 1)})
        sizetween:Play()
        local postween = tween.new(notification.background, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)})
        postween:Play()
        task.wait(time);
        library.update_notifications2(notification)
        task.wait(1.2)
        notification:remove()
    end)

    return notification
end

function library.update_notifications()
    local i = 0
    for v in next, library.notifications do
        local tween = tween.new(v.holder, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0, 75 + (i * 30))})
        tween:Play()
        i = i + 1
    end
end

function library.update_notifications2(drawing)
    local tween = tween.new(drawing.background, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -(drawing.background.Size.X.Offset + 10), 0, drawing.background.Position.Y)})
    tween:Play()

    for i,v in pairs(drawing) do
        if type(v) == "table" then
            local tween = tween.new(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0})
            tween:Play()
        end
    end
end

function library.createkeybindlist()
    local keybind_list_tbl = {keybinds = {}};
    local keybind_list_drawings = {};
    
    local list_outline = utility.create("Square", {Visible = true, Transparency = 1, Theme = "Window Outline Background", Size = UDim2.new(0, 180, 0, 30), Position = UDim2.new(0, 10, 0.4, 0), Thickness = 1, Filled = true, ZIndex = 100}) do
        local outline = utility.outline(list_outline, "Window Border");
        utility.outline(outline, Color3.new(0,0,0));
    end;
    
    local list_inline = utility.create("Square", {Parent = list_outline, Visible = true, Transparency = 1, Theme = "Window Inline Background", Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), Thickness = 1, Filled = true, ZIndex = 101}) do
        local outline = utility.outline(list_inline, "Window Border");
    end;
    
    local list_accent = utility.create("Square", {Parent = list_inline, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,-2,0,2), Position = UDim2.new(0,1,0,1), Thickness = 1, Filled = true, ZIndex = 101});
    
    local list_title = utility.create("Text", {Text = "Keybinds", Parent = list_inline, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, OutlineColor = Color3.fromRGB(50,50,50), FontFace = custom_font, Position = UDim2.new(0.5,0,0,5), ZIndex = 101});
    
    local list_content = utility.create("Square", {Parent = list_outline, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,33), Thickness = 1, Filled = true, ZIndex = 101});
    list_content:AddListLayout(1)
    
    function keybind_list_tbl:add_keybind(name, key)
        local key_settings = {};
        
        local key_holder = utility.create("Square", {Parent = list_content, Size = UDim2.new(1,0,0,22), ZIndex = 100, Transparency = 1, Visible = true, Filled = true, Thickness = 1, Theme = "Window Outline Background"}) do
            local outline = utility.outline(key_holder, "Window Border");
            utility.outline(outline, Color3.new(0,0,0));
        end;
        
        local list_title = utility.create("Text", {Text = tostring(name .." ["..key.."]"), Parent = key_holder, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = true, FontFace = custom_font, Position = UDim2.new(0,2,0,4), ZIndex = 101});
        
        function key_settings:is_active(state)
            if state then
                utility.changeobjecttheme(list_title, "Accent");
            else
                utility.changeobjecttheme(list_title, "Text");
            end
        end;
        
        function key_settings:update_text(text)
            list_title.Text = text
        end;
        
        function key_settings:Remove()
            key_holder:Remove()
            list_title:Remove()
            keybind_list_tbl.keybinds[name] = nil;
            key_settings = nil;
        end;
        
        keybind_list_tbl.keybinds[name] = name;
        
        return key_settings;
    end;
    
    function keybind_list_tbl:remove_keybind(name)
        if name and keybind_list_tbl.keybinds[name] then
            keybind_list_tbl.keybinds[name]:remove()
            keybind_list_tbl.keybinds[name] = nil
        end
    end;
    
    function keybind_list_tbl:set_visible(state)
        list_outline.Visible = state;
    end;
    
    utility.connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),function()
        list_outline.Position = UDim2.new(0, 10, 0.4, 0)
    end);
    
    return keybind_list_tbl
end;

local pickers = {}

function library.createcolorpicker(default, parent, count, flag, callback, offset)
    local icon = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Color = default,
        Parent = parent,
        Transparency = 1,
        Size = UDim2.new(0, 17, 0, 9),
        Position = UDim2.new(1, -17 - (count * 17) - (count * 6), 0, 4 + offset),
        ZIndex = 8
    })

    local outline = utility.outline(icon, "Section Inner Border")
    utility.outline(outline, "Section Outer Border")

    local window = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = icon,
        Theme = "Object Background",
        Size = UDim2.new(0, 185, 0, 200),
        Visible = false,
        Position = UDim2.new(1, -185 + (count * 20) + (count * 6), 1, 6),
        ZIndex = 20
    })

    table.insert(pickers, window)

    local outline1 = utility.outline(window, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")

    local saturation = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Color = default,
        Size = UDim2.new(0, 154, 0, 150),
        Position = UDim2.new(0, 6, 0, 6),
        ZIndex = 24
    })

    utility.outline(saturation, "Section Inner Border")

    local saturationpicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = saturation,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 2, 0, 2),
        ZIndex = 26
    })

    utility.outline(saturationpicker, Color3.fromRGB(0, 0, 0))

    local hueframe = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Size = UDim2.new(0,15, 0, 150),
        Position = UDim2.new(0, 165, 0, 6),
        ZIndex = 24
    })

    utility.outline(hueframe, "Section Inner Border")

    local huepicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = hueframe,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1,0,0,1),
        ZIndex = 26
    })

    utility.outline(huepicker, Color3.fromRGB(0, 0, 0))

    local rgbinput = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 6, 0, 160),
        ZIndex = 24,
        Parent = window
    })

    local outline2 = utility.outline(rgbinput, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")

    local text = utility.create("Text", {
        Text = string.format("%s, %s, %s", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
        FontFace = custom_font,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, 0),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = rgbinput
    })

    local copy = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0, 6, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    local outline3 = utility.outline(copy, "Section Inner Border")
    utility.outline(outline3, "Section Outer Border")

    utility.create("Text", {
        Text = "copy",
        FontFace = custom_font,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = copy
    })

    local paste = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0.5, 15, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    utility.create("Text", {
        Text = "paste",
        FontFace = custom_font,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = paste
    })

    local outline4 = utility.outline(paste, "Section Inner Border")
    utility.outline(outline4, "Section Outer Border")

    utility.connect(copy.MouseButton1Click, function()
        library.currentcolor = current_val
    end)

    local function set(color, nopos, setcolor)
        if type(color) == "table" then
            color = Color3.fromHex(color.color)
        end

        if type(color) == "string" then
            color = Color3.fromHex(color)
        end

        local oldcolor = hsv

        hue, sat, val = color:ToHSV()
        hsv = Color3.fromHSV(hue, sat, val)

        if hsv ~= oldcolor then
            icon.Color = hsv

            if not nopos then
                saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)), 0, (math.clamp((1 - val) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 2)))
                huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 4))
                if setcolor then
                    saturation.Color = hsv
                end
            end

            text.Text = string.format("%s, %s, %s", math.round(hsv.R * 255), math.round(hsv.G * 255), math.round(hsv.B * 255))

            if flag then
                library.flags[flag] = utility.rgba(hsv.r * 255, hsv.g * 255, hsv.b * 255)
            end

            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))

            current_val = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
        end
    end

    utility.connect(paste.MouseButton1Click, function()
        if library.currentcolor ~= nil then
            set(library.currentcolor, false, true)
        end;
    end);

    flags[flag] = set

    set(default)

    local defhue, _, _ = default:ToHSV()

    local curhuesizey = defhue

    local function updatesatval(input)
        local sizeX = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
        local sizeY = 1 - math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) + 36) / saturation.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y) * saturation.AbsoluteSize.Y + 36, 0, saturation.AbsoluteSize.Y - 2)
        local posX = math.clamp(((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X) * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)

        saturationpicker.Position = UDim2.new(0, posX, 0, posY)

        set(Color3.fromHSV(curhuesizey or hue, sizeX, sizeY), true, false)
    end

    local slidingsaturation = false

    saturation.MouseButton1Down:Connect(function()
        slidingsaturation = true
    end)

    saturation.MouseButton1Up:Connect(function()
        slidingsaturation = false
    end)

    local slidinghue = false

    local function updatehue(input)
        local sizeY = 1 - math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) + 36) / hueframe.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y + 36, 0, hueframe.AbsoluteSize.Y - 2)

        huepicker.Position = UDim2.new(0, 0, 0, posY)
        saturation.Color = Color3.fromHSV(sizeY, 1, 1)
        curhuesizey = sizeY

        set(Color3.fromHSV(sizeY, sat, val), true, true)
    end

    hueframe.MouseButton1Down:Connect(function()
        slidinghue = true
    end)

    hueframe.MouseButton1Up:Connect(function()
        slidinghue = false
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then

            if slidinghue then
                updatehue(input)
            end

            if slidingsaturation then
                updatesatval(input)
            end
        end
    end)

    icon.MouseButton1Click:Connect(function()
        for _, picker in next, pickers do
            if picker ~= window then
                picker.Visible = false
            end
        end

        window.Visible = not window.Visible

        if slidinghue then
            slidinghue = false
        end

        if slidingsaturation then
            slidingsaturation = false
        end
    end)

    local colorpickertypes = {}

    function colorpickertypes:set(color)
        set(color)
    end

    return colorpickertypes, window
end

function library.createdropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, islist, size, section, sectioncontent)
    local dropdown = utility.create("Square", {
        Filled = true,
        Visible = not islist,
        Thickness = 0,
        Theme = "Object Background",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        ZIndex = 7,
        Parent = holder
    })

    local outline1 = utility.outline(dropdown, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")

    local value = utility.create("Text", {
        Text = "",
        FontFace = custom_font,
        Size = 13,
        Position = UDim2.new(0, 2, 0, 0),
        Theme = "Text",
        ZIndex = 9,
        Outline = false,
        Parent = dropdown
    })

    local icon = utility.create("Text", {
        Text = "▼",
        FontFace = custom_font,
        Size = 13,
        Position = UDim2.new(1, -13, 0, 1),
        Theme = "Text",
        ZIndex = 9,
        Outline = false,
        Parent = dropdown
    })

    local contentframe = utility.create("Square", {
        Filled = true,
        Visible = islist or false,
        Thickness = 0,
        Theme = "Object Background",
        Size = islist and size == "Fill" and UDim2.new(1, 0, 1, -30) or islist and size ~= "Fill" and UDim2.new(1,0,0,size) or UDim2.new(1,0,0,0),
        Position = islist and UDim2.new(0, 0, 0, 14) or UDim2.new(0, 0, 1, 6),
        ZIndex = 12,
        Parent = islist and holder or dropdown
    })

    local outline2 = utility.outline(contentframe, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")

    local contentholder = utility.create("Square", {
        Transparency = 0,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        Parent = contentframe
    })

    if scrollable then
        contentholder:MakeScrollable()
    end

    contentholder:AddListLayout(3)

    local opened = false

    if not islist then
        dropdown.MouseButton1Click:Connect(function()
            opened = not opened
            contentframe.Visible = opened
            icon.Text = opened and "▲" or "▼"
        end)
    end

    local optioninstances = {}
    local count = 0
    local countindex = {}

    local function createoption(name)
        optioninstances[name] = {}

        countindex[name] = count + 1

        local button = utility.create("Square", {
            Filled = true,
            Transparency = 0,
            Thickness = 1,
            Theme = "Object Background",
            Size = UDim2.new(1, 0, 0, 16),
            ZIndex = 14,
            Parent = contentholder
        })

        optioninstances[name].button = button

        local title = utility.create("Text", {
            Text = name,
            FontFace = custom_font,
            Size = 13,
            Position = UDim2.new(0, 8, 0, 1),
            Theme = "Text",
            ZIndex = 15,
            Outline = true,
            Parent = button
        })

        optioninstances[name].text = title

        if scrollable then
            if count < scrollingmax and not islist then
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end
        else
            if not islist then
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end
        end

        if islist then
            holder.Position = holder.Position
        end

        count = count + 1

        return button, title
    end

    local chosen = max and {}

    local function handleoptionclick(option, button, text)
        button.MouseButton1Click:Connect(function()
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    utility.changeobjecttheme(text, "Text")

                    library.flags[flag] = chosen
                    callback(chosen)
                else
                    if #chosen == max then
                        utility.changeobjecttheme(optioninstances[chosen[1]].text, "Text")

                        table.remove(chosen, 1)
                    end

                    table.insert(chosen, option)

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    utility.changeobjecttheme(text, "Accent")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            else
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        utility.changeobjecttheme(tbl.text, "Text")
                    end
                end

                chosen = option

                value.Text = option

                utility.changeobjecttheme(text, "Accent")

                library.flags[flag] = option
                callback(option)

            end
        end)
    end

    local function createoptions(tbl)
        for _, option in next, tbl do
            local button, text = createoption(option)
            handleoptionclick(option, button, text)
        end
    end

    createoptions(content)

    local set
    set = function(option)
        if max then
            option = type(option) == "table" and option or {}
            table.clear(chosen)

            for opt, tbl in next, optioninstances do
                if not table.find(option, opt) then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end

            for i, opt in next, option do
                if table.find(content, opt) and #chosen < max then
                    table.insert(chosen, opt)
                    utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                end
            end

            local textchosen = {}
            local cutobject = false

            for _, opt in next, chosen do
                table.insert(textchosen, opt)

                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                    cutobject = true
                    table.remove(textchosen, #textchosen)
                end
            end

            value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

            library.flags[flag] = chosen
            callback(chosen)
        end

        if not max then
            for opt, tbl in next, optioninstances do
                if opt ~= option then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end

            if table.find(content, option) then
                chosen = option

                value.Text = option

                utility.changeobjecttheme(optioninstances[option].text, "Accent")

                library.flags[flag] = chosen
                callback(chosen)
            else
                chosen = nil

                value.Text = ""

                library.flags[flag] = chosen
                callback(chosen)
            end
        end
    end

    flags[flag] = set

    set(default)

    local dropdowntypes = utility.table({}, true)

    function dropdowntypes:set(option)
        set(option)
    end

    function dropdowntypes:refresh(tbl)
        content = table.clone(tbl)
        count = 0

        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Remove()
            end)()
        end

        table.clear(optioninstances)

        createoptions(tbl)

        if scrollable then
            contentholder:RefreshScrolling()
        end

        value.Text = ""

        if max then
            table.clear(chosen)
        else
            chosen = nil
        end

        library.flags[flag] = chosen
        callback(chosen)
    end

    function dropdowntypes:add(option)
        table.insert(content, option)
        local button, text = createoption(option)
        handleoptionclick(option, button, text)
    end

    function dropdowntypes:remove(option)
        if optioninstances[option] then
            count = count - 1

            optioninstances[option].button:Remove()

            if scrollable then
                contentframe.Size = UDim2.new(1, 0, 0, math.clamp(contentholder.AbsoluteContentSize, 0, (scrollingmax * 16) + ((scrollingmax - 1) * 3)) + 6)
            else
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end

            optioninstances[option] = nil

            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            end
        end
    end

    return dropdowntypes
end

local allowedcharacters = {}
local shiftcharacters = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    ["["] = "{",
    ["\\"] = "|",
    [";"] = ":",
    ["'"] = "\"",
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~"
}

for i = 32, 126 do
    table.insert(allowedcharacters, utf8.char(i))
end

function library.createbox(box, text, callback, finishedcallback)
    box.MouseButton1Click:Connect(function()
        services.ContextActionService:BindActionAtPriority("disablekeyboard", function() return Enum.ContextActionResult.Sink end, false, 3000, Enum.UserInputType.Keyboard)

        local connection
        local backspaceconnection

        local keyqueue = 0

        if not connection then
            connection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode ~= Enum.KeyCode.Backspace then
                        local str = services.InputService:GetStringForKeyCode(input.KeyCode)

                        if table.find(allowedcharacters, str) then
                            keyqueue = keyqueue + 1
                            local currentqueue = keyqueue

                            if not services.InputService:IsKeyDown(Enum.KeyCode.RightShift) and not services.InputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                text.Text = text.Text .. str:lower()
                                callback(text.Text)

                                local ended = false

                                coroutine.wrap(function()
                                    task.wait(0.5)

                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. str:lower()
                                        callback(text.Text)

                                        task.wait(0.02)
                                    end
                                end)()
                            else
                                text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                callback(text.Text)

                                coroutine.wrap(function()
                                    task.wait(0.5)

                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                        callback(text.Text)

                                        task.wait(0.02)
                                    end
                                end)()
                            end
                        end
                    end

                    if input.KeyCode == Enum.KeyCode.Return then
                        services.ContextActionService:UnbindAction("disablekeyboard")
                        utility.disconnect(backspaceconnection)
                        utility.disconnect(connection)
                        finishedcallback(text.Text)
                    end
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    services.ContextActionService:UnbindAction("disablekeyboard")
                    utility.disconnect(backspaceconnection)
                    utility.disconnect(connection)
                    finishedcallback(text.Text)
                end
            end)

            local backspacequeue = 0

            backspaceconnection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Backspace then
                    backspacequeue = backspacequeue + 1

                    text.Text = text.Text:sub(1, -2)
                    callback(text.Text)

                    local currentqueue = backspacequeue

                    coroutine.wrap(function()
                        task.wait(0.5)

                        if backspacequeue == currentqueue then
                            while services.InputService:IsKeyDown(Enum.KeyCode.Backspace) do
                                text.Text = text.Text:sub(1, -2)
                                callback(text.Text)

                                task.wait(0.02)
                            end
                        end
                    end)()
                end
            end)
        end
    end)
end

local keys = {
    [Enum.KeyCode.LeftShift] = "LeftShift",
    [Enum.KeyCode.RightShift] = "RightShift",
    [Enum.KeyCode.LeftControl] = "LeftControl",
    [Enum.KeyCode.RightControl] = "RightControl",
    [Enum.KeyCode.LeftAlt] = "LeftAlt",
    [Enum.KeyCode.RightAlt] = "RightAlt",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Numpad1",
    [Enum.KeyCode.KeypadTwo] = "Numpad2",
    [Enum.KeyCode.KeypadThree] = "Numpad3",
    [Enum.KeyCode.KeypadFour] = "Numpad4",
    [Enum.KeyCode.KeypadFive] = "Numpad5",
    [Enum.KeyCode.KeypadSix] = "Numpad6",
    [Enum.KeyCode.KeypadSeven] = "Numpad7",
    [Enum.KeyCode.KeypadEight] = "Numpad8",
    [Enum.KeyCode.KeypadNine] = "Numpad9",
    [Enum.KeyCode.KeypadZero] = "Numpad0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MouseButton1",
    [Enum.UserInputType.MouseButton2] = "MouseButton2",
    [Enum.UserInputType.MouseButton3] = "MouseButton3"
}

function library:new_window(cfg)
    local window_tbl = {pages = {}, page_buttons = {}, page_accents = {}};
    local window_size = cfg.size or cfg.Size or Vector2.new(600,400);
    local size_x = window_size.X;
    local size_y = window_size.Y;
    
    local window_outline = utility.create("Square", {Visible = true, Transparency = 1, Theme = "Window Outline Background", Size = UDim2.new(0,size_x,0,size_y), Position = UDim2.new(0.5, -(size_x / 2), 0.5, -(size_y / 2)), Thickness = 1, Filled = true, ZIndex = 1}) do
        local outline = utility.outline(window_outline, "Window Border");
        utility.outline(outline, Color3.new(0,0,0));
    end;
    
    library.holder = window_outline;
    
    local window_inline = utility.create("Square", {Parent = window_outline, Visible = true, Transparency = 1, Theme = "Window Inline Background", Size = UDim2.new(1,-10,1,-10), Position = UDim2.new(0,5,0,5), Thickness = 1, Filled = true, ZIndex = 2}) do
        local outline = utility.outline(window_inline, "Window Border");
    end;
    
    local window_accent = utility.create("Square", {Parent = window_inline, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,-2,0,2), Position = UDim2.new(0,1,0,1), Thickness = 1, Filled = true, ZIndex = 2});
    
    local window_holder = utility.create("Square", {Parent = window_inline, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(1,-30,1,-30), Position = UDim2.new(0,15,0,15), Thickness = 1, Filled = true, ZIndex = 3}) do
        local outline = utility.outline(window_holder, "Window Border");
    end;
    
    local window_pages_holder = utility.create("Square", {Parent = window_holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 3})
    
    local window_drag = utility.create("Square", {Parent = window_outline, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 10})
    
    local dragoutline = utility.create("Square", {
        Size = UDim2.new(0, size_x, 0, size_y),
        Position = utility.getcenter(size_x, size_y),
        Filled = false,
        Thickness = 1,
        Theme = "Accent",
        ZIndex = 1,
        Visible = false,
    })
    
    utility.dragify(window_drag, dragoutline, window_outline);
    
    local window_key_list = library.createkeybindlist();
    window_key_list:set_visible(false);
    
    function window_tbl:new_page(cfg)
        local page_tbl = {sections = {}};
        local page_name = cfg.name or cfg.Name or "new page";
        
        local page_button = utility.create("Square", {Parent = window_pages_holder, Visible = true, Transparency = 1, Theme = "Page Unselected", Size = UDim2.new(0,0,0,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 4}) do
            local outline = utility.outline(page_button, "Window Border");
            table.insert(self.page_buttons, page_button);
        end;
        
        local page_title = utility.create("Text", {Text = page_name, Parent = page_button, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, OutlineColor = Color3.fromRGB(50,50,50), FontFace = custom_font, Position = UDim2.new(0.5,0,0,6), ZIndex = 4});
        
        local page_button_accent = utility.create("Square", {Parent = page_button, Visible = false, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,0,1), Thickness = 1, Filled = true, ZIndex = 4}) do
            table.insert(self.page_accents, page_button_accent);
        end;
        
        local page = utility.create("Square", {Parent = window_holder, Visible = false, Transparency = 0, Size = UDim2.new(1,-40,1,-45), Position = UDim2.new(0,20,0,40), Thickness = 1, Filled = false, ZIndex = 4}) do
            table.insert(self.pages, page);
        end;
        
        local left = utility.create("Square", {Transparency = 0,Filled = false,Thickness = 1,ZIndex = 4,Parent = page,Size = UDim2.new(0.5, -14, 1, -10);});
        left:AddListLayout(15)
        local right = utility.create("Square", {Transparency = 0,Filled = false,Thickness = 1,Parent = page,ZIndex = 3,Size = UDim2.new(0.5, -14, 1, -10),Position = UDim2.new(0.5, 14, 0, 0);});
        right:AddListLayout(15)
        
        page_button.MouseButton1Click:Connect(function()
            for i,v in next, self.page_buttons do
                if v ~= page_button then
                    utility.changeobjecttheme(v, "Page Unselected");
                end;
            end;
            
            for i,v in next, self.page_accents do
                if v ~= page_button_accent then
                    v.Visible = false;
                end;
            end;
            
            for i,v in next, self.pages do
                if v ~= page then
                    v.Visible = false;
                end;
            end;
            
            utility.changeobjecttheme(page_button, "Page Selected");
            page_button_accent.Visible = true;
            page.Visible = true;
        end);
        
        for _,v in next, self.page_buttons do
            v.Size = UDim2.new(1 / #self.page_buttons, _ == 1 and 1 or _ == #self.page_buttons and -2 or -1, 1, 0);
            v.Position = UDim2.new(1 / (#self.page_buttons / (_ - 1)), _ == 1 and 0 or 2, 0, 0);
        end;
        
        function page_tbl:open()
            utility.changeobjecttheme(page_button, "Page Selected");
            page_button_accent.Visible = true;
            page.Visible = true;
        end;
        
        function page_tbl:new_section(cfg)
            local section_tbl = {};
            local section_name = cfg.name or cfg.Name or "new section";
            local section_side = cfg.side == "left" and left or cfg.Side == "left" and left or cfg.side == "right" and right or cfg.Side == "right" and right or left;
            local section_size = cfg.size or cfg.Size or 200;
            
            local section = utility.create("Square", {Parent = section_side, Visible = true, Transparency = 1, Theme = "Section Background", Size = section_size ~= "Fill" and UDim2.new(1,0,0,section_size) or UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 5}) do
                local outline = utility.outline(section, "Section Inner Border");
                utility.outline(outline, "Section Outer Border")
            end;
            
            local section_title_cover = utility.create("Square", {Parent = section, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(0,utility.textlength(section_name, drawing.Fonts.Plex, 13).X + 2,0,4), Position = UDim2.new(0,10,0,-4), Thickness = 1, Filled = true, ZIndex = 5})
            local section_title = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, FontFace = custom_font, Position = UDim2.new(0,10,0,-8), ZIndex = 5});
            local section_title_bold = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, FontFace = custom_font, Position = UDim2.new(0,11,0,-8), ZIndex = 5});
            
            local section_content = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, -32, 1, -10),Position = UDim2.new(0, 16, 0, 15),Parent = section,ZIndex = 6});
            section_content:AddListLayout(8)
            
            function section_tbl:new_toggle(cfg)
                local toggle_tbl = {colorpickers = 0};
                local toggle_name = cfg.name or cfg.Name or "new toggle";
                local toggle_risky = cfg.risky or cfg.Risky or false;
                local toggle_state = cfg.state or cfg.State or false;
                local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or cfg.Callback or function() end;
                local toggled = false;
                
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 8});
                
                local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) do
                    local outline = utility.outline(toggle_frame, "Section Inner Border");
                    utility.outline(outline, "Section Outer Border");
                end;
                
                local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Theme = toggle_risky and "Risky Text" or "Text", Size = 13, Center = false, Outline = false, FontFace = custom_font, Position = UDim2.new(0,13,0,-3), ZIndex = 6});
                
                local function setstate()
                    toggled = not toggled
                    if toggled then
                        utility.changeobjecttheme(toggle_frame, "Accent")
                    else
                        utility.changeobjecttheme(toggle_frame, "Object Background")
                    end
                    library.flags[toggle_flag] = toggled
                    callback(toggled)
                end;
                
                holder.MouseButton1Click:Connect(setstate);
                
                local function set(bool)
                    bool = type(bool) == "boolean" and bool or false
                    if toggled ~= bool then
                        setstate()
                    end;
                end;
                set(toggle_state);
                flags[toggle_flag] = set;
                
                local toggletypes = {}
                function toggletypes:set(bool)
                    set(bool)
                end;
                
                function toggletypes:new_colorpicker(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local colorpicker_tbl = {};
    
                    toggle_tbl.colorpickers += 1
    
                    local cp = library.createcolorpicker(default, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                    function colorpicker_tbl:set(color)
                        cp:set(color, false, true)
                    end

                    return colorpicker_tbl
                end;
                
                return toggletypes;
            end;
            
            return section_tbl;
        end;
        
        return page_tbl;
    end;
    
    function window_tbl:set_keybind_list_visibility(state)
        window_key_list:set_visible(state);
    end;
    
    function window_tbl:get_config()
        local configtbl = {}

        for flag, _ in next, flags do
            if not table.find(configignores, flag) then
                local value = library.flags[flag]

                if typeof(value) == "EnumItem" then
                    configtbl[flag] = tostring(value)
                elseif typeof(value) == "Color3" then
                    configtbl[flag] = value:ToHex()
                else
                    configtbl[flag] = value
                end
            end
        end

        local config = game:GetService("HttpService"):JSONEncode(configtbl)
        
        return config
    end;
    
    return window_tbl;
end;

return library;
