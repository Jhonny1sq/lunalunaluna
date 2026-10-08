local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jhonny1sq/lunalunaluna/refs/heads/main/lib.lua"))()

local replicatedstorage = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")

local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character
local weapons = replicatedstorage.Database.Custom.Weapons

if game.ReplicatedFirst:FindFirstChild("Sigma") then
    game.ReplicatedFirst:FindFirstChild("Sigma"):Destroy()
end
if game.ReplicatedFirst:FindFirstChild("LoadingScreen") then
    game.ReplicatedFirst:FindFirstChild("LoadingScreen"):Destroy()
end

local Window = Luna:CreateWindow({
    Name = "BloodHounds v1",
    Subtitle = "https://discord.gg/wPP2pwsKRA", 
    LogoID = "82795327169782",
    LoadingEnabled = false,
    LoadingTitle = "BloodHounds Multi-Game",
    LoadingSubtitle = "Loading...",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "BloodyHounds"
    },
    KeySystem = false
})

Window.Bind = Enum.KeyCode.Delete

Window:CreateHomeTab({
    SupportedExecutors = {"Fluxus", "Delta", "Codex", "Real", "Madium"},
    DiscordInvite      = "wPP2pwsKRA",   
    Icon               = 1,                
})

local Tab = Window:CreateTab({
	Name = "Visual",
	Icon = "visibility",
	ImageSource = "Material",
	ShowTitle = true
})

Tab:CreateSection("Chams")

local basiccham = false

local basicchamc

runservice.Heartbeat:Connect(function()
    for _, eplayer in pairs(players:GetPlayers()) do
        if eplayer == player then continue end
        if not basiccham then continue end

        local echaracter = eplayer.Character
        if not echaracter then continue end
        if not echaracter.Parent then continue end

        if echaracter:FindFirstChild("BasicCham") then
            local bcffc = echaracter:FindFirstChild("BasicCham")
            bcffc.FillColor = basicchamc
            bcffc.OutlineColor = basicchamc
        end

        if not player:GetAttribute("Team") then continue end
        if eplayer:GetAttribute("Team") == player:GetAttribute("Team") and echaracter:FindFirstChild("BasicCham") then echaracter.BasicCham:Destroy() end
        if eplayer:GetAttribute("Team") == player:GetAttribute("Team") then continue end
        if echaracter.Parent ~= workspace.Characters then continue end
        if echaracter:FindFirstChild("BasicCham") then continue end

        local bc = Instance.new("Highlight", echaracter)
        bc.Name = "BasicCham"
        bc.FillColor = basicchamc
        bc.OutlineColor = basicchamc
    end
end)

local Toggle = Tab:CreateToggle({
	Name = "Basic Cham",
	Description = nil,
	CurrentValue = false,
    	Callback = function(Value)
            basiccham = Value
    	end
}, "Chams1") 

local ColorPicker = Tab:CreateColorPicker({
	Name = "BasicCham Color",
	Color = Color3.fromRGB(0, 150, 255),
	Flag = "BasicChamPicker1", 
	Callback = function(Value)
		basicchamc = Value
	end
}, "BasicChamPicker")

local Tab = Window:CreateTab({
	Name = "Guns",
	Icon = "code",
	ImageSource = "Material",
	ShowTitle = true
})

Tab:CreateSection("Legit")



Tab:CreateSection("Rage")

local nospreade = false
local norecoile = false

local Toggle = Tab:CreateToggle({
	Name = "No Spread",
	Description = "Hooks game's getTrueSpread and makes it return 0",
	CurrentValue = false,
    	Callback = function(Value)
            nospreade = Value
    	end
}, "NoSpread") 

local Toggle = Tab:CreateToggle({
	Name = "No Recoil",
	Description = "Hooks game's setWeaponRecoil and makes it return 0",
	CurrentValue = false,
    	Callback = function(Value)
            norecoile = Value
    	end
}, "NoRecoil") 

local oldgettruespread; if typeof(hookfunction) == "function" then
    for _, obj in next, getgc(true) do
        if typeof(obj) == "table" and rawget(obj, "getTrueSpread") then
            oldgettruespread = hookfunction(obj.getTrueSpread, function(...)
                if nospreade then return 0 end
                return oldgettruespread(...)
            end)
            break
        end
    end
end

local oldCalculateRecoilOffset
local oldweaponKick
local oldsetWeaponRecoil
if typeof(hookfunction) == "function" then
    for _, obj in next, getgc(true) do
        if typeof(obj) == "table" and rawget(obj, "setWeaponRecoil") then
            oldsetWeaponRecoil = hookfunction(obj.setWeaponRecoil, function(...)
                if norecoile then return end 
                return oldsetWeaponRecoil(...)
            end)
            break
        end
        if type(obj) == "function" and not oldCalculateRecoilOffset then
            local info = debug.getinfo(obj)
            if info and info.name == "calculateRecoilOffset" then
                pcall(function()
                    oldCalculateRecoilOffset = hookfunction(obj, function(...)
                        if norecoile then return UDim2.new() end
                        return oldCalculateRecoilOffset(...)
                    end)
                end)
            end
        end
        if type(obj) == "table" and rawget(obj, "weaponKick") and not oldweaponKick then
            pcall(function()
                oldweaponKick = hookfunction(obj.weaponKick, function(p1, p2)
                    if norecoile then return end
                    return oldweaponKick(p1, p2)
                end)
            end)
        end

    end
end

local Tab = Window:CreateTab({
	Name = "Misc",
	Icon = "settings",
	ImageSource = "Material",
	ShowTitle = true
})

Tab:CreateSection("Movement")

Tab:CreateSection("Dev")

local oldwalkspeed = {}

local Toggle = Tab:CreateToggle({
	Name = "Knife WalkSpeed",
	Description = "Changes all the walkspeed values to a knife walkspeed",
	CurrentValue = true,
    	Callback = function(Value)
            if Value then
                local tables = filtergc("table", {Keys = {"WalkSpeed", "ShowCrosshair"}})
            
                for _, table in pairs(tables) do
                    oldwalkspeed[table] = table.WalkSpeed
                    setreadonly(table, false)
                    table.WalkSpeed = 20.2
                    task.delay(0.5, function()
                        setreadonly(table, true)
                    end)
                end
            else
                local tables = filtergc("table", {Keys = {"WalkSpeed", "ShowCrosshair"}})
            
                for _, table in pairs(tables) do
                    setreadonly(table, false)
                    table.WalkSpeed = oldwalkspeed[table]
                    task.delay(0.5, function()
                        setreadonly(table, true)
                    end)
                end
            end
        end
}, "KnifeWalkSpeed") 

Tab:CreateSection("Visuals")

local Toggle = Tab:CreateToggle({
	Name = "Keep Crosshair",
	Description = "Changes the ShowCrosshair Value",
	CurrentValue = true,
    	Callback = function(Value)
            for _, obj in getgc(true) do
                if typeof(obj) ~= "table" then
                    continue
                end

                if rawget(obj, "ShowCrosshair") == nil then
                    continue
                end

                setreadonly(obj, false)
                obj.ShowCrosshair = Value
                task.delay(0.5, function()
                    setreadonly(obj, true)
                end)
            end
        end
}, "KeepCrosshair") 

local Button = Tab:CreateButton({
	Name = "VIP",
	Description = "Gives you command access press O", 
    	Callback = function()
            player:SetAttribute("CanUseVIPMenu", true)
    	end
})
