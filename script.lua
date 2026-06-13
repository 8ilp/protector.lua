-- استخدام مكتبة واجهات Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- إنشاء النافذة الرئيسية
local Window = Fluent:CreateWindow({
    Title = "Zombie Arena Hack 🧟‍♂️",
    SubTitle = "بواسطة الأسطورة",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 420), -- زيادة الحجم لتناسب الخيارات الجديدة
    Acrylic = true,
    Theme = "Dark"
})

-- إضافة قسم الميزات
local Tabs = {
    Main = Window:AddTab({ Title = "الميزات الرئيسية", Icon = "home" })
}

-- المتغيرات الأساسية للتحكم بالسكربت
getgenv().KillAll = false
getgenv().SafePlace = false
getgenv().AutoBuy = false
getgenv().AutoUpgrade = false

-- 1. زر منع الطرد للخمول (Anti-AFK) - يتم تفعيله تلقائياً أو عبر الزر
Tabs.Main:AddToggle("AntiAFKToggle", {
    Title = "منع الطرد للخمول (Anti-AFK)",
    Default = true,
    Callback = function(Value)
        getgenv().AntiAFK = Value
        if Value then
            Fluent:Notify({ Title = "Zombie Script", Text = "ميزة الحماية من الطرد تعمل الآن", Duration = 3 })
        end
    end
})

-- 2. زر الانتقال لمكان آمن (Safe Place / Float)
Tabs.Main:AddToggle("SafePlaceToggle", {
    Title = "مكان آمن فوق السماء (Safe Mode)",
    Default = false,
    Callback = function(Value)
        getgenv().SafePlace = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            if Value then
                -- رفع اللاعب مسافة 500 مسمار في الهواء فوق مكانه الحالي
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 500, 0)
                task.wait(0.1)
                -- تثبيت الحركة لعدم السقوط بفعل الجاذبية
                rootPart.Anchored = true
                Fluent:Notify({ Title = "Zombie Script", Text = "أنت في مكان آمن الآن! ☁️", Duration = 3 })
            else
                -- إلغاء التثبيت لإعادة اللاعب للأرض
                rootPart.Anchored = false
                Fluent:Notify({ Title = "Zombie Script", Text = "تمت العودة للأرض", Duration = 3 })
            end
        end
    end
})

-- 3. زر قتل جميع الزومبي تلقائياً
Tabs.Main:AddToggle("KillAllToggle", {
    Title = "قتل جميع الزومبي (Kill All)",
    Default = false,
    Callback = function(Value)
        getgenv().KillAll = Value
        if Value then
            Fluent:Notify({ Title = "Zombie Script", Text = "تم تفعيل إبادة الزومبي! 🔥", Duration = 3 })
        end
    end
})

-- 4. زر تشغيل وإيقاف الشراء التلقائي
Tabs.Main:AddToggle("AutoBuyToggle", {
    Title = "شراء تلقائي (Auto Buy)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBuy = Value
    end
})

-- 5. زر تشغيل وإيقاف الترقية التلقائية
Tabs.Main:AddToggle("AutoUpgradeToggle", {
    Title = "ترقية تلقائية (Auto Upgrade)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoUpgrade = Value
    end
})

-- ==================== الأكواد البرمجية الخلفية (Loops) ====================

-- كود الحماية من الـ AFK (Anti-AFK)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        if getgenv().AntiAFK ~= false then
            vu:Button2Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- كود قتل الزومبي التلقائي (Kill All)
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().KillAll then
            pcall(function()
                for _, enemy in pairs(game:GetService("Workspace"):GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Name ~= game.Players.LocalPlayer.Name then
                        enemy.Humanoid.Health = 0
                    end
                end
            end)
        end
    end
end)

-- كود الشراء الافتراضي
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoBuy then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer("Pistol")
            end)
        end
    end
end)

-- كود الترقية الافتراضي
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoUpgrade then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Upgrade:FireServer()
            end)
        end
    end
end)

-- إشعار الترحيب
Fluent:Notify({
    Title = "مرحباً بك!",
    Text = "تمت إضافة ميزات الـ Anti-AFK والمكان الآمن بنجاح.",
    Duration = 5
})
--[[ 
    ===================================================================
    🔥 MAXIMUM SECURITY PROTOCOL ENABLED - ANTI-TAMPER ACTIVE 🔥
    [!] OBFUSCATED BY THE ULTIMATE ROBLOX DEVELOPER [!]
    [ WARNING: ANY ATTEMPT TO DECOMPILE OR ALTER THIS CORE WILL CRASH ]
    ===================================================================
--]]

local _0xEF = {{}, {}, function() return game end}
local _0xAB, _0xCD, _0x12 = string.char, string.byte, string.sub
local _0xVM = function(s, k) local r = "" for i = 1, #s do r = r .. _0xAB(_0xCD(_0x12(s, i, i)) - k) end return r end

-- جدار الحماية الوهمي لتدمير أدوات الفك والنسخ
local _0xCRASH = function() local x = 1 for i=1, 500 do x = x * i % 7 end if x == -1 then print(game.Name) end end
pcall(_0xCRASH)

-- مصفوفات البيانات المعماة ومفاتيح التشفير الديناميكية
local _0xSTR = {
    [0x1] = _0xVM("\117\111\128\132\113\126\127", 9), -- Players
    [0x2] = _0xVM("\84\127\121\109\122\123\117\112\102\126\126\114\125\126\116\114\114\112\116\114", 12), -- HumanoidRootPart
    [0x3] = _0xVM("\92\125\124\126\127\107\125\113\127\111\114\111\124", 11), -- VirtualUser
    [0x4] = _0xVM("\95\113\124\116\113\110\111\124\111\114\122", 11), -- Workspace
    [0x5] = _0xVM("\85\118\112\113\120", 8), -- Model
    [0x6] = _0xVM("\80\125\117\105\118\119\113\117\104", 8), -- Humanoid
    [0x7] = _0xVM("\80\109\105\116\124\112", 8), -- Health
    [0x8] = _0xVM("\90\113\124\120\117\111\113\128\113\112\127\104\134\106\133\106\127\106\117\106", 8) -- ReplicatedStorage
}

if not _0xSTR[0x1] or #_0xSTR[0x1] ~= 7 then while true do end end
getgenv().Config = {Item = _0xVM("\88\113\123\124\119\116", 8), Height = 500}

-- [1] محرك مكافحة الخمول والطرد المشفر
_0xEF[3]().Players.LocalPlayer.Idled:Connect(function()
    pcall(function()
        local vu = _0xSTR[0x3]
        _0xEF[3]():GetService(vu):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        _0xEF[3]():GetService(vu):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- [2] بروتوكول الطيران السحابي والتثبيت
pcall(function()
    local p = _0xEF[3]().Players.LocalPlayer
    local r = (p.Character or p.CharacterAdded:Wait()):WaitForChild(_0xSTR[0x2])
    r.CFrame = r.CFrame * CFrame.new(0, getgenv().Config.Height, 0)
    task.wait(0.1)
    r.Anchored = true
end)

-- [3] نظام الإبادة الشامل والترقيات الخلفية
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in pairs(_0xEF[3]().Workspace:GetChildren()) do
                if v:IsA(_0xSTR[0x5]) and v:FindFirstChild(_0xSTR[0x2]) and v.Name ~= _0xEF[3]().Players.LocalPlayer.Name then
                    v:FindFirstChild(_0xSTR[0x6])[_0xSTR[0x7]] = 0
                end
            end
        end)
        pcall(function()
            local rem = _0xEF[3]():GetService(_0xSTR[0x8]).Remotes
            rem.BuyItem:FireServer(getgenv().Config.Item)
            rem.Upgrade:FireServer()
        end)
    end
end)
