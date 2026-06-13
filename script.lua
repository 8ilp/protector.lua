-- ==========================================
-- قائمة الأسطورة المحمية (النسخة الكاملة)
-- ==========================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "قائمة الأسطورة المحمية 👑",
    SubTitle = "كل الأدوات في مكان واحد",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 500),
    Theme = "Dark"
})

local MainTab = Window:AddTab({ Title = "الرئيسية", Icon = "home" })
local SpamTab = Window:AddTab({ Title = "أدوات السبام", Icon = "message" })
local ExtraTab = Window:AddTab({ Title = "أدوات إضافية", Icon = "unlock" })
local TrackTab = Window:AddTab({ Title = "تتبع وتحكم", Icon = "search" })

-- 1. الحماية (Anti-Log)
task.spawn(function()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and (key == "RemoteEvent" or key == "RemoteFunction") then return nil end
        return oldIndex(self, key)
    end)
end)

-- 2. ميزة الاختراق والاختفاء
ExtraTab:AddToggle("NoclipToggle", {
    Title = "اختراق الجدران (Noclip)",
    Callback = function(Value)
        getgenv().Noclip = Value
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().Noclip then
                local char = game.Players.LocalPlayer.Character
                if char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            end
        end)
    end
})

ExtraTab:AddToggle("InvisibleToggle", {
    Title = "تفعيل الاختفاء",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = Value and 1 or 0 end
            end
        end
    end
})

-- 3. ميزة السبام
local MySpamText = "فعاليات رسم للعرب 🎨"
SpamTab:AddInput("SpamInput", { Title = "نص السبام", Default = "فعاليات رسم للعرب 🎨", Callback = function(Value) MySpamText = Value end })
SpamTab:AddToggle("SpamToggle", {
    Title = "تفعيل السبام (3/ثانية)",
    Callback = function(Value)
        getgenv().SpamActive = Value
        task.spawn(function()
            while getgenv().SpamActive do
                game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and 
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(MySpamText, "All")
                task.wait(0.33) 
            end
        end)
    end
})

-- 4. ميزة التتبع والتحكم
local TargetInput = ""
TrackTab:AddInput("TrackInput", { Title = "اسم اللاعب (أو جزء منه)", Placeholder = "اكتب هنا...", Callback = function(Value) TargetInput = Value end })

local function sendCommand(cmd)
    if TargetInput ~= "" then
        local msg = cmd .. " " .. TargetInput
        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and 
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

TrackTab:AddButton({ Title = "أمر /re [اسم اللاعب]", Callback = function() sendCommand("/re") end })
TrackTab:AddButton({ Title = "أمر /res [اسم اللاعب]", Callback = function() sendCommand("/res") end })
TrackTab:AddButton({ Title = "أمر /logs [اسم اللاعب]", Callback = function() sendCommand("/logs") end })

game:GetService("Players").PlayerAdded:Connect(function(plr)
    if TargetInput ~= "" and plr.Name:lower():find(TargetInput:lower()) then
        Fluent:Notify({ Title = "تنبيه تتبع", Text = plr.Name .. " انضم للسيرفر", Duration = 5 })
    end
end)

Fluent:SelectTab(1)
Fluent:Notify({ Title = "تم التحميل", Text = "القائمة جاهزة يا أسطورة!", Duration = 5 })
