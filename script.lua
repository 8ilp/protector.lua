--[[
    8ilp ULTIMATE PROTECTION v4.0
    Architect Engine 2099 | Military Grade
--]]

local Protection = {}

-- ============================================
-- 🔐 LAYER 1: STRING OBFUSCATOR
-- ============================================
local Obfuscator = {}
local Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

function Obfuscator:RandomString(len)
    local str = ""
    for i = 1, len do
        str = str .. string.sub(Charset, math.random(1, #Charset), math.random(1, #Charset))
    end
    return str
end

function Obfuscator:ObfuscateVariableNames(code)
    local protected = {
        ["game"] = Obfuscator:RandomString(8),
        ["workspace"] = Obfuscator:RandomString(8),
        ["Players"] = Obfuscator:RandomString(6),
        ["LocalPlayer"] = Obfuscator:RandomString(10),
        ["Character"] = Obfuscator:RandomString(8),
        ["Humanoid"] = Obfuscator:RandomString(7),
        ["HumanoidRootPart"] = Obfuscator:RandomString(12),
        ["Camera"] = Obfuscator:RandomString(6),
    }
    
    for original, obf in pairs(protected) do
        code = string.gsub(code, original, obf)
    end
    return code
end

-- ============================================
-- 🔐 LAYER 2: BYTECODE CONVERTER
-- ============================================
local Bytecode = {}

function Bytecode:ToByteArray(code)
    local bytes = {}
    for i = 1, #code do
        bytes[i] = string.byte(code, i) + 13  -- shift
    end
    return table.concat(bytes, ",")
end

function Bytecode:FromByteArray(data)
    local bytes = {}
    for num in string.gmatch(data, "%d+") do
        table.insert(bytes, string.char(tonumber(num) - 13))
    end
    return table.concat(bytes)
end

-- ============================================
-- 🔐 LAYER 3: ANTI-DEBUG / ANTI-TAMPER
-- ============================================
local AntiDebug = {}

function AntiDebug:AntiDump()
    local oldIndex = getmetatable(game).__index
    local called = 0
    setreadonly(getmetatable(game), false)
    getmetatable(game).__index = function(self, key)
        called = called + 1
        if called > 1000 then
            -- Self destruct
            while true do end
        end
        return oldIndex(self, key)
    end
    setreadonly(getmetatable(game), true)
end

function AntiDebug:DetectInjection()
    local suspicious = {
        "dex",
        "dump",
        "inject",
        "attach",
        "debug",
        "hookfunction",
        "getsenv",
        "getgenv"
    }
    
    local env = getgenv()
    for _, keyword in pairs(suspicious) do
        if rawget(env, keyword) then
            return true
        end
    end
    
    -- Check for common exploit scripts
    if getsenv or hookmetamethod or getnamecallmethod then
        return true
    end
    
    return false
end

function AntiDebug:AntiHook()
    local old
    old = hookfunction(Instance.new, function(...)
        local args = {...}
        if args[1] == "Script" or args[1] == "LocalScript" then
            -- Block script creation
            return nil
        end
        return old(...)
    end)
end

-- ============================================
-- 🔐 LAYER 4: POLYMORPHIC LOADER
-- ============================================
local Polymorphic = {}

function Polymorphic:SplitCode(code)
    local chunks = {}
    local size = math.random(20, 50)
    
    for i = 1, #code, size do
        local chunk = string.sub(code, i, math.min(i + size - 1, #code))
        local varName = Obfuscator:RandomString(12)
        table.insert(chunks, {name = varName, data = chunk})
    end
    
    -- Shuffle chunks
    for i = #chunks, 2, -1 do
        local j = math.random(i)
        chunks[i], chunks[j] = chunks[j], chunks[i]
    end
    
    return chunks
end

function Polymorphic:GenerateLoader(chunks)
    local loader = "local function loadChunks()\n"
    loader = loader .. "local parts = {}\n"
    
    for i, chunk in ipairs(chunks) do
        loader = loader .. "parts[" .. i .. "] = [[" .. chunk.data .. "]]\n"
    end
    
    loader = loader .. [[
        local code = table.concat(parts)
        local f = loadstring(code)
        if f then f() end
    end
    loadChunks()
    ]]
    
    return loader
end

-- ============================================
-- 🔐 LAYER 5: VM PROTECTION
-- ============================================
local VMProtect = {}

function VMProtect:GenerateVM(code)
    local instructions = {}
    local bytecode = {}
    
    -- تحويل الكود إلى تعليمات وهمية
    for i = 1, #code do
        table.insert(bytecode, string.byte(code, i))
    end
    
    local vmCode = [[
        local vm = {}
        local memory = {}
        local ip = 1
        
        function vm:load(data)
            for i, v in ipairs(data) do
                memory[i] = v
            end
        end
        
        function vm:execute()
            local output = ""
            while ip <= #memory do
                local opcode = memory[ip]
                output = output .. string.char(opcode)
                ip = ip + 1
            end
            return output
        end
        
        local data = {]] .. table.concat(bytecode, ",") .. [[}
        vm:load(data)
        local result = vm:execute()
        loadstring(result)()
    ]]
    
    return vmCode
end

-- ============================================
-- 🛡️ MASTER PROTECTION WRAPPER
-- ============================================
function Protection:UltraProtect(code, key)
    -- Layer 1: Variable Obfuscation
    local obfCode = Obfuscator:ObfuscateVariableNames(code)
    
    -- Layer 2: Polymorphic Split
    local chunks = Polymorphic:SplitCode(obfCode)
    local polyCode = Polymorphic:GenerateLoader(chunks)
    
    -- Layer 3: VM Wrap
    local vmCode = VMProtect:GenerateVM(polyCode)
    
    -- Layer 4: XOR + Base64
    local function xorEncrypt(data, k)
        local r = ""
        for i = 1, #data do
            local d = string.byte(data, i)
            local kc = string.byte(k, ((i-1) % #k) + 1)
            r = r .. string.char(bit32.bxor(d, kc))
        end
        return r
    end
    
    local function b64Encode(data)
        local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        local result = {}
        for i = 1, #data, 3 do
            local a, b, c = string.byte(data, i, i+2)
            b, c = b or 0, c or 0
            local n = a * 65536 + b * 256 + c
            local n1, n2, n3, n4 = math.floor(n/262144)%64, math.floor(n/4096)%64, math.floor(n/64)%64, n%64
            table.insert(result, string.sub(chars, n1+1, n1+1) .. string.sub(chars, n2+1, n2+1) .. string.sub(chars, n3+1, n3+1) .. string.sub(chars, n4+1, n4+1))
        end
        return table.concat(result)
    end
    
    local xorData = xorEncrypt(vmCode, key)
    local finalEncrypted = b64Encode(xorData)
    
    -- Layer 5: Wrapper with Anti-Debug
    local finalWrapper = [[
        -- 8ilp Protection Layer
        if getgenv().detected then return end
        
        local function checkEnv()
            local bad = {"]]
    
    local badStrings = {"dex", "dump", "inject", "hookfunction", "getsenv"}
    for i, s in ipairs(badStrings) do
        finalWrapper = finalWrapper .. '"' .. s .. '",'
    end
    finalWrapper = finalWrapper .. [[}
            for _, s in ipairs(bad) do
                if getgenv()[s] then
                    getgenv().detected = true
                    return false
                end
            end
            return true
        end
        
        if not checkEnv() then return end
        
        local key = "]] .. key .. [["
        local encrypted = "]] .. finalEncrypted .. [["
        
        local function decode(data)
            local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            data = string.gsub(data, '[^'..chars..'=]', '')
            local result = {}
            for i = 1, #data, 4 do
                local a, b, c, d = string.byte(data, i, i+3)
                a = a and (string.find(chars, string.char(a))-1) or 0
                b = b and (string.find(chars, string.char(b))-1) or 0
                c = c and (string.find(chars, string.char(c))-1) or 0
                d = d and (string.find(chars, string.char(d))-1) or 0
                local n = a * 262144 + b * 4096 + c * 64 + d
                table.insert(result, string.char(math.floor(n/65536)))
                if c ~= 0 then table.insert(result, string.char(math.floor((n%65536)/256))) end
                if d ~= 0 then table.insert(result, string.char(n%256)) end
            end
            return table.concat(result)
        end
        
        local function xorDecrypt(data, k)
            local r = ""
            for i = 1, #data do
                local d = string.byte(data, i)
                local kc = string.byte(k, ((i-1) % #k) + 1)
                r = r .. string.char(bit32.bxor(d, kc))
            end
            return r
        end
        
        local dec = decode(encrypted)
        local final = xorDecrypt(dec, key)
        loadstring(final)()
    ]]
    
    return finalWrapper
end

-- ============================================
-- 🚀 USAGE EXAMPLE
-- ============================================
local MASTER_KEY = "8ilp_X9kL2mN7pQ4rT8vY1wB6zA3dF5hJ0cE!_ULTRA"

-- Protect your code
local myCode = [[
    print("8ilp Protected Code Executed!")
    game.Players.LocalPlayer:Kick("Protected by 8ilp")
]]

local protectedCode = Protection:UltraProtect(myCode, MASTER_KEY)

-- protectedCode is now ready to upload to GitHub

return {
    Protection = Protection,
    UltraProtect = Protection.UltraProtect,
    MASTER_KEY = MASTER_KEY,
    
    -- إرجاع كود جاهز للتنفيذ
    ExecuteProtected = function(code, key)
        return Protection:UltraProtect(code, key or MASTER_KEY)
    end
}
