![1000054107](https://github.com/user-attachments/assets/24731205-9859-4da4-97c5-39583d8b0e84)

# _Alien Library_
Custom Library Made by ARS (The Source) & MIYKO (Animations, Ideas and Custom Themes).
# Important
This library only has a few things at the moment, so I'll leave you the documentation so you can see it for yourself.
# Documentation
**Load The library:**
```Luau
local Library = loadstring(game:HttpGet("https://arch.rest/files/e9da91cdc38db8ea153257b7f6917074"))()
```
**Create a window:**
```Luau
local Window = Library:CreateWindow({
    Title = "My Hub", -- Set Any Name
    Size = UDim2.fromOffset(580, 460),
    SideBarWidth = 170,
    BackgroundImageTransparency = 0.5,
    SelectBackground = "Meguna", -- Choose The Custom Theme
    ToggleName = "Open" -- Set Toggle Name
})
```

**Custom Themes:**
```Luau
SelectBackground = "SukunaVSMahoraga",
SelectBackground = "Astolfo",
SelectBackground = "Sukuna",
SelectBackground = "Sukuna MS",
SelectBackground = "Itadori",
SelectBackground = "reze",
SelectBackground = "Gojo M",
SelectBackground = "Mahoraga",
SelectBackground = "Miku",
SelectBackground = "teto",
SelectBackground = "Minecraft",
```

**Create Tab:**
```Luau
local Tab = Window:Tab({
    Title = "Tab" -- Put u title
})

-- Or Locked Tab

Window:LockedTab({
    Title = "Locked tab", -- Put u title
    NotifyTitle = "Title", -- Put u title
    NotifyDesc = "Desc" -- Put u Desc
})
```

**Create Button:**
```Luau
Tab:Button({
    Title = "Button", -- Put u title
    Callback = function()
        Print("Hello")
    end
})
```

**Create Toggle:**
```Luau
Tab:Toggle({
    Title = "Toggle", -- Put u title
    Default = false,
    Callback = function(state)
        print("State:", state)
    end
})
```

**Create Slider:**
```Luau
Tab:Slider({
    Title = "Slider", -- Put u title
    Min = 0,
    Max = 100,
    Default = 49,
    Callback = function(value)
        print("Number:", value)
    end
})
```

**Create Section:**
```Luau
Tab:Section({ Title = "Section" }) -- Put u title
```

**Create Paragraph:**
```Luau
Tab:Paragraph({
    Title = "Paragraph title", -- Put u Title
    Desc = "Paragraph Desc" -- Put u Desc
})
```

**Insert Image:**
```Luau
Tab:Image({
    Image = "rbxassetid://103493475647848", -- Put u Raw image or roblox id
    AspectRatio = true,
    Radius = 9
})
```

**Create Notify:**
```Luau
Window:Notify({
    Title = "Notify", -- Put u Title
    Desc = "Yep", -- Put u Desc
    Time = 5 -- Put the duration
})
```

**Create Textbox:**
```Luau
MainTab:Insert({
    Title = "This is a textbox",
    Placeholder = "Input text...",
    Callback = function(text) end
})
```

**Create Dropdown:**
```Luau
MainTab:Pick({
    Title = "This is a dropdown",
    Options = {"Option 1", "Option 2"},
    Callback = function(option) end
})
```


- [Example](https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Alien-Library/refs/heads/Abandoned/Things/Example.luau)
