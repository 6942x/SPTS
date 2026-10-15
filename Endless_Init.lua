local e = game:GetService("Players")
local e1 = game:GetService("RunService")
local e2 = game:GetService("HttpService")

local e3 = Color3.fromRGB

local e4 = e.LocalPlayer
if not e4 then
    warn("[eSPTS] Players.LocalPlayer is nil - execute inside the game client")
    return
end

local e5 = typeof(getgenv) == "function" and getgenv() or _G

local function e6(e7)
    if typeof(e7) ~= "table" or e7.dead then
        return
    end
    e7.dead = true
    if typeof(e7.unload) == "function" then
        pcall(e7.unload)
    end
    for e8, e9 in pairs(e7.th or {}) do
        if typeof(e9) == "thread" and coroutine.status(e9) ~= "dead" then
            pcall(task.cancel, e9)
        end
    end
    for e8, e9 in pairs(e7.cn or {}) do
        pcall(e9.Disconnect, e9)
    end
    e7.th = {}
    e7.cn = {}
    if typeof(e7.gui) == "Instance" then
        pcall(e7.gui.Destroy, e7.gui)
    end
    if e5.eSPTS_ObsidianRegistry == e7 then
        e5.eSPTS_ObsidianRegistry = nil
    end
end

local function e10(e7)
    local e9 = {}
    local e11, e12 = pcall(function()
        return typeof(gethui) == "function" and gethui() or nil
    end)
    if e11 and typeof(e12) == "Instance" then
        e9[#e9 + 1] = e12
    end
    local e13, e14 = pcall(function()
        return game:GetService("CoreGui")
    end)
    if e13 and typeof(e14) == "Instance" then
        e9[#e9 + 1] = e14
    end
    local e15, e16 = pcall(function()
        return e4:FindFirstChildOfClass("PlayerGui")
    end)
    if e15 and typeof(e16) == "Instance" then
        e9[#e9 + 1] = e16
    end
    for e8, e17 in ipairs(e9) do
        for e8, e18 in ipairs(e17:GetChildren()) do
            if e18 ~= e7 and e18:IsA("ScreenGui") and (e18.Name == "Obsidian" or e18.Name == "eSPTS") then
                pcall(e18.Destroy, e18)
            end
        end
    end
end

e6(e5.eSPTS_ObsidianRegistry)
e10(nil)

local e19 = { cn = {}, th = {}, dead = false }
e5.eSPTS_ObsidianRegistry = e19

local function e20()
    if e19.dead then
        return false
    end
    return e5.eSPTS_ObsidianRegistry == e19
end

local function e21(e7, e9, e11)
    e11 = e11 or 30
    local e12 = e7:WaitForChild(e9, e11)
    if not e12 then
        warn("[eSPTS] timeout '" .. e9 .. "' in " .. e7:GetFullName())
        error("[eSPTS] '" .. e9 .. "' not found - wrong game or updated instances", 0)
    end
    return e12
end

local e22 = e21(e4, "PlayerGui")
local e23 = e21(e22, "ScreenGui")

if not e20() then
    return
end

local e24 = e21(game:GetService("ReplicatedStorage"), "RemoteEvent")
local e25 = e21(e21(e23, "MenuFrame"), "InfoFrame")
local e26 = e21(e21(workspace, "Map"), "Training_Collisions")

if not e20() then
    return
end

local function e27(e7)
    e24:FireServer(e7)
end

local e28 = { "Add_FS_Request" }
local e29 = { "Add_MS_Request" }
local e30 = { "Add_JF_Request" }

local e31, e32 = e4.Name, e4.UserId
if not e31 or e31 == "" then
    repeat
        e31 = e4.Name
        task.wait()
    until e31 and e31 ~= ""
end

if not e20() then
    return
end

local e33 = {
    key = "G",
    stat = nil,
    weight = false,
    as = true,
    tab = "Auto Farm",
    save = nil,
    mode = nil,
    hide = false,
    rsp = false,
    rtype = "Normal",
    alsm = nil,
    ui = nil,
}

local e34 = "eSPTS_Obsidian/Accounts/" .. e31 .. ".json"
local e35 = { t = 0, f = false }

local function e36()
    if not makefolder or not isfolder then
        return
    end
    if not isfolder("eSPTS_Obsidian") then
        makefolder("eSPTS_Obsidian")
    end
    if not isfolder("eSPTS_Obsidian/Accounts") then
        makefolder("eSPTS_Obsidian/Accounts")
    end
end

local function e37()
    if not e20() or not writefile then
        return false
    end
    e36()
    local e7 = e33.save and { e33.save:GetComponents() } or nil
    local e9 = {
        uid = e32,
        name = e31,
        key = e33.key,
        stat = e33.stat,
        weight = e33.weight,
        as = e33.as,
        tab = e33.tab,
        save = e7,
        mode = e33.mode,
        hide = e33.hide,
        rsp = e33.rsp,
        rtype = e33.rtype,
        alsm = e33.alsm,
        ui = e33.ui,
    }
    local e11 = pcall(function()
        writefile(e34, e2:JSONEncode(e9))
    end)
    if e19.smSave then
        pcall(e19.smSave)
    end
    if e11 then
        e35.t = tick()
        e35.f = false
        return true
    end
    e35.f = false
    return false
end

local function e38()
    if e35.f then
        return
    end
    e35.f = true
    local e7 = tick() - e35.t
    if e7 >= 0.1 then
        e37()
    else
        task.delay(0.1 - e7, function()
            if e35.f then
                e37()
            end
        end)
    end
end

local function e39(e7, e9)
    if typeof(e33.ui) ~= "table" then
        e33.ui = {}
    end
    if e33.ui[e7] == e9 then
        return
    end
    e33.ui[e7] = e9
    e38()
end

local function e40()
    if not readfile or not isfile or not isfile(e34) then
        return false
    end
    local e7, e9 = pcall(function()
        return e2:JSONDecode(readfile(e34))
    end)
    if not e7 or typeof(e9) ~= "table" or e9.uid ~= e32 then
        return false
    end
    e33.key = typeof(e9.key) == "string" and e9.key ~= "" and e9.key or "G"
    if not pcall(function()
        return Enum.KeyCode[e33.key]
    end) then
        e33.key = "G"
    end
    e33.stat = table.find(
        { "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" },
        e9.stat
    ) and e9.stat or nil
    e33.weight = e9.weight or false
    e33.as = e9.as ~= false
    e33.tab = e9.tab or "Auto Farm"
    if e33.tab == "Position Man" then
        e33.tab = "Position Manager"
    end
    if typeof(e9.save) == "table" and #e9.save == 12 then
        e33.save = CFrame.new(unpack(e9.save))
    end
    e33.mode = e9.mode
    e33.rsp = e9.rsp == true
    e33.rtype = (e9.rtype == "Risky" or e9.rtype == "Normal") and e9.rtype or "Normal"
    e33.hide = e9.hide or false
    e33.alsm = typeof(e9.alsm) == "string" and e9.alsm ~= "" and e9.alsm or nil
    e33.ui = typeof(e9.ui) == "table" and e9.ui or nil
    return true
end

local e41 = e40()

local function e42(e7)
    local e9 = e19.th[e7]
    if not e9 then
        return
    end
    e19.th[e7] = nil
    if typeof(e9) == "thread" and coroutine.status(e9) ~= "dead" then
        pcall(task.cancel, e9)
    end
end

local function e43(e7, e9)
    e42(e7)
    e19.th[e7] = task.spawn(e9)
end

local function e44(e7, e9)
    local e11 = e7:Connect(e9)
    e19.cn[#e19.cn + 1] = e11
    return e11
end

local e45
do
    local e7 = {}
    e45 = function(e9, e11)
        if e7[e9] then
            return false
        end
        e7[e9] = true
        task.delay(e11 or 0.3, function()
            e7[e9] = false
        end)
        return true
    end
end

local e46 = {}
local e47

local function e48(e7)
    local e9 = os.date and os.date("%H:%M:%S") or "\xe2\x80\x94"
    e46[#e46 + 1] = { t = e9, m = e7 }
    if #e46 > 40 then
        table.remove(e46, 1)
    end
    if e47 then
        e47()
    end
end
local e49 = {
    FistStrength = {
        TrainingArea_2 = { req = "0e0", multi = "x1e1" },
        TrainingArea_3 = { req = "1e6", multi = "x1e2" },
        StarFSTraining1 = { req = "1e9", multi = "x2e3" },
        StarFSTraining2 = { req = "1e11", multi = "x4e4" },
        StarFSTraining3 = { req = "1e13", multi = "x8e5" },
        AFK_FS_1 = { req = "1e15", multi = "x6e6" },
        AFK_FS_2 = { req = "1e17", multi = "x3e8" },
        AFK_FS_3 = { req = "1.5e19", multi = "x2.1e10" },
        AFK_FS_4 = { req = "2.5e21", multi = "x2.308e12" },
        AFK_FS_5 = { req = "1e24", multi = "x3.475e14" },
        AFK_FS_6 = { req = "5e26", multi = "x5.2e16" },
        AFK_FS_7 = { req = "2.5e29", multi = "x7.8e18" },
        AFK_FS_8 = { req = "1.5e32", multi = "??" },
        AFK_FS_9 = { req = "5.5e34", multi = "??" },
        AFK_FS_10 = { req = "3e37", multi = "??" },
        AFK_FS_11 = { req = "1.1e40", multi = "??" },
    },
    BodyToughness = {
        FireBathTouchPart = { req = "5e2", multi = "x1e1" },
        Water = { req = "5e0", multi = "x5e0" },
        IcePart = { req = "5e3", multi = "x2e1" },
        LavaPart = { req = "5e5", multi = "x1e2" },
        TornadoTouchPart = { req = "5e4", multi = "x5e1" },
        GreenFirePart = { req = "5e7", multi = "x2e3" },
        AcidPart = { req = "5e9", multi = "x4e4" },
        LavaPart2 = { req = "5e11", multi = "x8e5" },
        AFK_BT_1 = { req = "7.383e12", multi = "x6e6" },
        AFK_BT_2 = { req = "6.55e14", multi = "x1.8e8" },
        AFK_BT_3 = { req = "6.66e16", multi = "x5.5e9" },
        AFK_BT_4 = { req = "5.1e18", multi = "x1.625e11" },
        AFK_BT_5 = { req = "4.6e20", multi = "x5e12" },
        AFK_BT_6 = { req = "4.005e22", multi = "x1.5e14" },
        AFK_BT_7 = { req = "3.55e24", multi = "x4.5e15" },
        AFK_BT_8 = { req = "3.14e26", multi = "x1.312e17" },
        AFK_BT_9 = { req = "2.778e28", multi = "x3.925e18" },
        AFK_BT_10 = { req = "2.473e30", multi = "x1.18e20" },
        AFK_BT_11 = { req = "2.175e32", multi = "x3.55e21" },
        AFK_BT_12 = { req = "1.95e34", multi = "x1.062e23" },
        AFK_BT_13 = { req = "1.7e36", multi = "x3.2e24" },
        AFK_BT_14 = { req = "1.55e38", multi = "x9.574e25" },
        AFK_BT_15 = { req = "1.356e40", multi = "x2.5e27" },
    },
    MovementSpeed = {
        AFK_MS_1 = { req = "1e14", multi = "x1.3e6" },
        AFK_MS_2 = { req = "2.22e15", multi = "x1.69e7" },
        AFK_MS_3 = { req = "6e16", multi = "x2.197e8" },
        AFK_MS_4 = { req = "1.5e18", multi = "x2.85e9" },
        AFK_MS_5 = { req = "4e19", multi = "x3.72e10" },
        AFK_MS_6 = { req = "1e21", multi = "x4.824e11" },
        AFK_MS_7 = { req = "2.5e22", multi = "x6.274e12" },
        AFK_MS_8 = { req = "7.5e23", multi = "x8.15e13" },
        AFK_MS_9 = { req = "1.55e25", multi = "x2.12e15" },
        AFK_MS_10 = { req = "4e26", multi = "x1.377e16" },
        AFK_MS_11 = { req = "1e28", multi = "x1.792e17" },
    },
    JumpForce = {
        AFK_JF_1 = { req = "1e14", multi = "x1.7e6" },
        AFK_JF_2 = { req = "5e15", multi = "x3.05e7" },
        AFK_JF_3 = { req = "1.5e17", multi = "x5.5e8" },
        AFK_JF_4 = { req = "5e18", multi = "x9.92e9" },
        AFK_JF_5 = { req = "2e20", multi = "??" },
        AFK_JF_6 = { req = "1e22", multi = "??" },
        AFK_JF_7 = { req = "3e23", multi = "??" },
        AFK_JF_8 = { req = "1.5e25", multi = "??" },
        AFK_JF_9 = { req = "4e26", multi = "??" },
    },
    PsychicPower = {
        PPTrainingPart1 = { req = "1e6", multi = "x1e2" },
        PPTrainingPart2 = { req = "1e9", multi = "x1e4" },
        PPTrainingPart3 = { req = "1e12", multi = "x1e6" },
        PPTrainingPart4 = { req = "1e15", multi = "x1e8" },
        AFK_PP_1 = { req = "3.33e17", multi = "x2.5e9" },
        AFK_PP_2 = { req = "1.11e20", multi = "x2.5e11" },
        AFK_PP_3 = { req = "3.33e22", multi = "x2.5e13" },
        AFK_PP_4 = { req = "1.11e25", multi = "x2.5e15" },
        AFK_PP_5 = { req = "3.36e27", multi = "x2.5e17" },
        AFK_PP_6 = { req = "1.11e30", multi = "x2.5e19" },
        AFK_PP_7 = { req = "4.44e32", multi = "x2.5e21" },
        AFK_PP_8 = { req = "1.11e35", multi = "??" },
        AFK_PP_9 = { req = "5.55e37", multi = "??" },
        AFK_PP_10 = { req = "2.22e40", multi = "??" },
    },
}

local e50 = {
    { n = "1e2 LB", m = 1e2, j = 5e3 },
    { n = "1e0 TON", m = 5e3, j = 2e5 },
    { n = "1e1 TON", m = 5e5, j = 2e6 },
    { n = "1e2 TON", m = 1e7, j = 1e7 },
    { n = "1e3 TON", m = 1e8, j = 2e8 },
    { n = "1e4 TON", m = 1e9, j = 1e9 },
    { n = "1e5 TON", m = 1e10, j = 1e10 },
    { n = "1e6 TON", m = 1e11, j = 1e11 },
    { n = "1e7 TON", m = 1e12, j = 1e12 },
    { n = "1e9 TON", m = 1e13, j = 1e13 },
    { n = "1e11 TON", m = 2.56e28, j = 1.54e28 },
    { n = "1e13 TON", m = 0e0, j = 6e26 },
    { n = "1e15 TON", m = 1.68e32, j = 2.221e31 },
    { n = "1e17 TON", m = 4.288e33, j = 8.48e31 },
    { n = "1e19 TON", m = 1.082e34, j = 3.226e33 },
    { n = "1e21 TON", m = 2.823e36, j = 1.229e36 },
    { n = "1e23 TON", m = 7.02e37, j = 4.683e37 },
    { n = "1e25 TON", m = 1.852e39, j = 1.785e39 },
    { n = "1e28 TON", m = 4.744e39, j = 6.8e39 },
}

local e51 = {
    { "K", 1e3 },
    { "M", 1e6 },
    { "B", 1e9 },
    { "T", 1e12 },
    { "Qa", 1e15 },
    { "Qi", 1e18 },
    { "Sx", 1e21 },
    { "Sp", 1e24 },
    { "Oc", 1e27 },
    { "No", 1e30 },
    { "Dc", 1e33 },
    { "Ud", 1e36 },
    { "Dd", 1e39 },
    { "Td", 1e42 },
    { "Qad", 1e45 },
    { "Qid", 1e48 },
    { "Sxd", 1e51 },
    { "Spd", 1e54 },
    { "Ocd", 1e57 },
    { "Nod", 1e60 },
    { "Vg", 1e63 },
    { "Uvg", 1e66 },
    { "Dvg", 1e69 },
    { "Tvg", 1e72 },
    { "Qavg", 1e75 },
    { "Qivg", 1e78 },
    { "Sxvg", 1e81 },
    { "Spvg", 1e84 },
    { "Ocvg", 1e87 },
    { "Novg", 1e90 },
    { "Tg", 1e93 },
    { "Utg", 1e96 },
    { "Dtg", 1e99 },
    { "Ttg", 1e102 },
    { "Qatg", 1e105 },
    { "Qitg", 1e108 },
    { "Sxtg", 1e111 },
    { "Sptg", 1e114 },
    { "Octg", 1e117 },
    { "Notg", 1e120 },
}

local function e52(e7)
    if not e7 then
        return 0
    end
    local e9 = tonumber(e7)
    if e9 then
        return e9
    end
    local e11 = tostring(e7):gsub("[,%s]", "")
    local e12, e = e11:match("([%d%.]+)(%a*)$")
    local e13 = tonumber(e12) or 0
    if e == "" then
        return e13
    end
    for e8, e14 in ipairs(e51) do
        if e14[1] == e then
            return e13 * e14[2]
        end
    end
    return e13
end

local function e53(e7)
    local e9 = tonumber(e7)
    if not e9 then
        return tostring(e7)
    end
    if e9 < 1000 then
        return string.format("%g", e9)
    end
    local e11, e12
    for e8, e in ipairs(e51) do
        if e9 >= e[2] then
            e11, e12 = e[1], e[2]
        end
    end
    local e13 = e9 / e12
    local e14 = e13 >= 100 and 0 or e13 >= 10 and 1 or 2
    local e15 = string.format("%." .. e14 .. "f", e13)
    if e15:find("%.") then
        e15 = e15:gsub("0+$", ""):gsub("%.$", "")
    end
    return e15 .. e11
end

local e54 = {}
for e7, e9 in pairs(e49) do
    e54[e7] = {}
    for e11, e12 in pairs(e9) do
        e54[e7][e11] = e52(e12.req)
    end
end

local e55 = {
    FistStrength = e21(e25, "FSTxt"),
    BodyToughness = e21(e25, "BTTxt"),
    MovementSpeed = e21(e25, "MSTxt"),
    JumpForce = e21(e25, "JFTxt"),
    PsychicPower = e21(e25, "PPTxt"),
}

if not e20() then
    return
end

local e56 = {}
local e57 = {
    FS_Gained_Handler = "FistStrength",
    BT_Gained_Handler = "BodyToughness",
    MS_Gained_Handler = "MovementSpeed",
    JF_Gained_Handler = "JumpForce",
    PP_Gained_Handler = "PsychicPower",
}

for e8, e7 in ipairs({ "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" }) do
    e56[e7] = { b = {}, r = 0 }
end

local function e58(e7, e9)
    local e11 = e56[e7]
    if not e11 then
        return
    end
    local e12 = tick()
    while #e11.b > 0 and e12 - e11.b[1][1] > 10 do
        table.remove(e11.b, 1)
    end
    e11.b[#e11.b + 1] = { e12, e9 }
    local e = 0
    for e8, e13 in ipairs(e11.b) do
        e = e + e13[2]
    end
    local e14 = e12 - e11.b[1][1]
    e11.r = e / (e14 < 1 and 1 or e14)
end

local function e59(e7)
    local e9 = e56[e7]
    if e9 and e9.r > 0 then
        return " (+" .. e53(e9.r) .. "/s)"
    end
    return ""
end

e44(e24.OnClientEvent, function(e7)
    if type(e7) ~= "table" or type(e7[1]) ~= "string" then
        return
    end
    local e9 = e57[e7[1]]
    if e9 and type(e7[3]) == "number" and e7[3] > 0 then
        e58(e9, e7[3])
    end
end)

local function e60(e7)
    local e9 = e55[e7]
    if not e9 then
        return 0
    end
    return e52(e9.Text)
end

local function e61(e7, e9)
    local e11 = e54[e7]
    if not e11 then
        return nil
    end
    local e12, e = nil, -1
    for e13, e14 in pairs(e11) do
        if e9 >= e14 and e14 > e then
            e12 = e13
            e = e14
        end
    end
    return e12
end

local function e62(e7, e9)
    local e11 = e54[e7]
    if not e11 then
        return nil
    end
    local e12, e, e13, e14 = nil, -1, nil, -1
    for e15, e16 in pairs(e11) do
        if e9 >= e16 and e16 > e then
            e13 = e12
            e14 = e
            e12 = e15
            e = e16
        elseif e9 >= e16 and e16 > e14 and e16 < e then
            e13 = e15
            e14 = e16
        end
    end
    return e13
end

local function e63(e7, e9)
    local e11 = e26:FindFirstChild(e7)
    if not e11 then
        return nil
    end
    return e11:FindFirstChild(e9)
end

local function e64(e7)
    if not e7 then
        return false
    end
    local e9 = e4.Character
    if not e9 then
        return false
    end
    local e11 = e9:FindFirstChild("HumanoidRootPart")
    if not e11 then
        return false
    end
    local e12
    if e7:IsA("BasePart") then
        e12 = e7.CFrame
    else
        local e = e7.PrimaryPart or e7:FindFirstChildWhichIsA("BasePart")
        if e then
            e12 = e.CFrame
        end
    end
    if not e12 then
        return false
    end
    local e13 = e12 + Vector3.new(0, 5, 0)
    local e14, e15
    if e7:IsA("BasePart") then
        e14, e15 = e7.CFrame, e7.Size
    elseif e7:IsA("Model") then
        local e16, e17, e18 = pcall(e7.GetBoundingBox, e7)
        if e16 and e17 and e18 then
            e14, e15 = e17, e18
        end
    end
    if e14 and e15 then
        local e65 = e14:PointToObjectSpace(e11.Position)
        local e66 = e15.Y <= 8 and 4 or e15.Y / 2
        if
            math.abs(e65.X) <= e15.X / 2
            and math.abs(e65.Z) <= e15.Z / 2
            and e65.Y >= -e15.Y / 2
            and e65.Y <= e66
        then
            local e67 = Vector3.new(e11.Position.X, math.min(e11.Position.Y, e13.Position.Y), e11.Position.Z)
            return true, CFrame.new(e67) * (e13 - e13.Position)
        end
    end
    e11.CFrame = e13
    return true, e13
end

local function e68(e7)
    local e9 = e60("MovementSpeed")
    local e11 = e60("JumpForce")
    local e12, e = nil, 1
    for e13, e14 in ipairs(e50) do
        if e9 >= e14.m and e11 >= e14.j then
            e12 = e14
            e = e13
        end
    end
    if e12 and (e7 or e ~= e19.we) then
        e19.we = e
        e27({ "EquipWeight_Request", e })
    end
end

local function e69(e7)
    if e7 then
        e43("PP", function()
            task.wait(0.4)
            local e9
            while e33.stat == "PsychicPower" and e20() do
                local e11 = e4.Character
                local e12 = e11 and e11:FindFirstChildOfClass("Humanoid")
                local e13 = e11 and e11:FindFirstChild("Meditate")
                local e14 = e4:FindFirstChild("Backpack")
                local e15 = e14 and e14:FindFirstChild("Meditate")
                local e16 = e61("PsychicPower", e60("PsychicPower"))
                local e17 = e16 ~= nil and string.find(e16, "AFK_PP", 1, true) ~= nil
                if e17 then
                    if e9 ~= 3 then
                        e9 = 3
                        e48("Psychic Power \xe2\x80\x94 AFK Zone (no Meditate needed)", e3(170, 120, 255))
                    end
                    if e13 and e14 then
                        pcall(function()
                            e13.Parent = e14
                        end)
                    end
                    task.wait(0.5)
                elseif e13 then
                    if e9 ~= 0 then
                        e9 = 0
                        e48("Psychic Power \xe2\x80\x94 Meditating", e3(170, 120, 255))
                    end
                    task.wait(0.5)
                elseif e15 and e12 and e12.Health > 0 then
                    if e9 ~= 1 then
                        e9 = 1
                        e48("Psychic Power \xe2\x80\x94 Re-equipping Meditate", e3(170, 120, 255))
                    end
                    pcall(e12.EquipTool, e12, e15)
                    task.wait(0.3)
                elseif not e15 then
                    if e9 ~= 2 then
                        e9 = 2
                        e48("Psychic Power \xe2\x80\x94 Meditate tool not found", e3(255, 150, 80))
                    end
                    task.wait(0.4)
                else
                    task.wait(0.4)
                end
            end
        end)
    else
        e42("PP")
        local e9 = e4.Character
        if e9 and e9:FindFirstChild("Meditate") then
            local e11 = e9:FindFirstChildOfClass("Humanoid")
            if e11 then
                e11:UnequipTools()
            end
        end
    end
end

local function e70(e7)
    local e9 = "eSPTS_Obsidian/cached_" .. e7:match("([^/]+)$")
    local e11, e12 = pcall(function()
        return game:HttpGet(e7)
    end)
    if e11 and typeof(e12) == "string" and #e12 > 200 then
        e36()
        if writefile then
            pcall(writefile, e9, e12)
        end
        return e12
    end
    if readfile and isfile and isfile(e9) then
        local e13, e14 = pcall(readfile, e9)
        if e13 and typeof(e14) == "string" and #e14 > 200 then
            warn("[eSPTS] download failed - using cached copy for " .. e7)
            return e14
        end
    end
    warn("[eSPTS] could not download " .. e7 .. " - " .. tostring(e12))
    error(
        "[eSPTS] required library unavailable - download failed and no cached copy - check internet or executor http access",
        0
    )
end

local e71 = (function()
    local e7, e9 = pcall(function()
        return loadstring(e70("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
    end)
    if not e7 or typeof(e9) ~= "table" then
        error("[eSPTS] Obsidian library failed to load - " .. tostring(e9), 0)
    end
    return e9
end)()

if not e20() then
    pcall(function()
        if e71.ScreenGui then
            e71.ScreenGui:Destroy()
        end
    end)
    return
end

local e72 = e71.Options
local e73 = e71.Toggles

e19.gui = e71.ScreenGui
pcall(function()
    e19.gui.Name = "eSPTS"
end)

e19.unload = function()
    pcall(function()
        e71:Unload()
    end)
    pcall(function()
        if e19.gui and e19.gui.Parent then
            e19.gui:Destroy()
        end
    end)
end

e10(e19.gui)

local e74 = e71:CreateWindow({
    Title = "eSPTS",
    Footer = "SPTS: Endless",
    Icon = "zap",
    Center = true,
    AutoShow = not e33.hide,
    ShowCustomCursor = false,
    NotifySide = "Right",
    ToggleKeybind = Enum.KeyCode[e33.key],
})

if e33.hide then
    e48("Interface started hidden - press " .. e33.key .. " to show it")
    task.delay(0.5, function()
        if not e20() or e71.Unloaded then
            return
        end
        e71:Notify({
            Title = "eSPTS",
            Description = "Loaded hidden - press " .. e33.key .. " to show the interface",
            Time = 6,
        })
    end)
end

local e75 = {
    ["Auto Farm"] = e74:AddTab("Auto Farm", "flame"),
    ["Auto Weights"] = e74:AddTab("Auto Weights", "dumbbell"),
    ["Auto Respawn"] = e74:AddTab("Auto Respawn", "skull"),
    ["Position Manager"] = e74:AddTab("Position Manager", "crosshair"),
    ["Settings"] = e74:AddTab("Settings", "settings"),
}

for e7, e9 in pairs(e75) do
    local e11 = e9.Show
    e9.Show = function(e12, ...)
        e33.tab = e7
        e38()
        return e11(e12, ...)
    end
end
local e76 = false
local function e77(e7)
    e76 = true
    local e9, e11 = pcall(e7)
    e76 = false
    return e9, e11
end

local e78 = { area = nil, anchor = nil, thr = 0, rtr = 0, base = nil, status = nil, names = nil, rows = nil }

do
    local e7 = e75["Auto Farm"]:AddLeftGroupbox("Stat Training", "flame")
    local e9 = e7:AddLabel("No active training", true)
    e78.status = e9
    e7:AddDivider()
    e7:AddLabel("Select a stat to automatically train at the best available area", true)
    local e11 = {
        FistStrength = "Fist Strength",
        BodyToughness = "Body Toughness",
        MovementSpeed = "Movement Speed",
        JumpForce = "Jump Force",
        PsychicPower = "Psychic Power",
    }
    local e12 = { "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" }
    e78.names = e11
    e78.rows = {}
    for e13, e14 in ipairs(e12) do
        e78.rows[e14] = "Stat_" .. e14
        e7:AddToggle("Stat_" .. e14, {
            Text = e11[e14],
            Default = false,
            Callback = function(e15)
                if e76 then
                    return
                end
                if e15 then
                    e77(function()
                        for e16, e17 in pairs(e78.rows) do
                            if e16 ~= e14 then
                                if e73[e17].Value then
                                    e73[e17]:SetValue(false)
                                end
                                if e16 == "PsychicPower" then
                                    e69(false)
                                end
                            end
                        end
                        if e14 ~= "BodyToughness" then
                            if e73.BTCurrent.Value then
                                e73.BTCurrent:SetValue(false)
                            end
                            if e73.BTNext.Value then
                                e73.BTNext:SetValue(false)
                            end
                        end
                    end)
                    e33.stat = e14
                    e78.area = nil
                    e78.anchor = nil
                    e78.base = nil
                    if e14 ~= "BodyToughness" then
                        e33.mode = nil
                    end
                    if e14 == "PsychicPower" then
                        e69(true)
                    end
                    local e16 = e60(e14)
                    local e17 = e61(e14, e16)
                    if not e17 then
                        e78.status:SetText(e11[e14] .. " \xe2\x80\x94 No available area")
                        e78.area = nil
                        e33.mode = nil
                        e38()
                        e48(e11[e14] .. " \xe2\x80\x94 No area found")
                        return
                    end
                    local e18 = e63(e14, e17)
                    e78.area = e18
                    if not e18 then
                        e78.status:SetText("Area '" .. e17 .. "' not found!")
                        e33.mode = nil
                        e38()
                        e48("Area '" .. e17 .. "' not found")
                        return
                    end
                    local e65, e66 = e64(e18)
                    if e65 then
                        e78.anchor = e66
                        e78.status:SetText(
                            e11[e14]
                                .. " \xe2\x80\x94 Area: "
                                .. e17
                                .. " (req "
                                .. e49[e14][e17].req
                                .. " --> "
                                .. e53(e49[e14][e17].req)
                                .. ")"
                                .. e59(e14)
                        )
                        e78.base = e78.status.Text:gsub(" %(%+.-/s%)$", "")
                        e48(e11[e14] .. " \xe2\x80\x94 " .. e17)
                    else
                        e78.status:SetText("Teleport failed!")
                        e48("Teleport failed")
                    end
                else
                    e33.stat = nil
                    e78.area = nil
                    e78.anchor = nil
                    e33.mode = nil
                    if e14 == "PsychicPower" then
                        e69(false)
                    end
                    e77(function()
                        if e73.BTCurrent.Value then
                            e73.BTCurrent:SetValue(false)
                        end
                        if e73.BTNext.Value then
                            e73.BTNext:SetValue(false)
                        end
                    end)
                    e78.status:SetText("No active training")
                    e48(e11[e14] .. " \xe2\x80\x94 Stopped")
                end
                e38()
            end,
        })
    end
end

do
    local e7 = e75["Auto Farm"]:AddRightGroupbox("Body Toughness Mode", "shield")
    e7:AddLabel("Train in your current area or jump ahead to the next unlocked one", true)
    e7:AddDivider()
    e7:AddToggle("BTCurrent", {
        Text = "BT: Current Area",
        Default = false,
        Callback = function(e9)
            if e76 then
                return
            end
            if e9 then
                e77(function()
                    for e11, e12 in pairs(e78.rows) do
                        if e11 ~= "BodyToughness" and e73[e12].Value then
                            e73[e12]:SetValue(false)
                        end
                        if e11 == "PsychicPower" then
                            e69(false)
                        end
                    end
                    if not e73.Stat_BodyToughness.Value then
                        e73.Stat_BodyToughness:SetValue(true)
                    end
                    if e73.BTNext.Value then
                        e73.BTNext:SetValue(false)
                    end
                end)
                e33.mode = "c"
                e33.stat = "BodyToughness"
                e78.anchor = nil
                e78.base = nil
                local e11 = e60("BodyToughness")
                local e12 = e62("BodyToughness", e11)
                if not e12 then
                    e78.status:SetText("Body Toughness \xe2\x80\x94 No available area")
                    e78.area = nil
                    e33.mode = nil
                    e38()
                    e48("BT Current \xe2\x80\x94 No area")
                    return
                end
                local e13 = e63("BodyToughness", e12)
                e78.area = e13
                if not e13 then
                    e78.status:SetText("Area '" .. e12 .. "' not found!")
                    e33.mode = nil
                    e38()
                    e48("Area not found")
                    return
                end
                local e14, e15 = e64(e13)
                if e14 then
                    e78.anchor = e15
                    e78.status:SetText(
                        "Body Toughness (Current) \xe2\x80\x94 Area: "
                            .. e12
                            .. " (req "
                            .. e49.BodyToughness[e12].req
                            .. " --> "
                            .. e53(e49.BodyToughness[e12].req)
                            .. ")"
                            .. e59("BodyToughness")
                    )
                    e78.base = e78.status.Text:gsub(" %(%+.-/s%)$", "")
                    e48("BT Current \xe2\x80\x94 " .. e12)
                else
                    e78.status:SetText("Teleport failed!")
                    e48("Teleport failed")
                end
            else
                e33.mode = nil
                e33.stat = nil
                e78.area = nil
                e78.anchor = nil
                e77(function()
                    for e11, e12 in pairs(e78.rows) do
                        if e73[e12].Value then
                            e73[e12]:SetValue(false)
                        end
                    end
                end)
                e78.status:SetText("No active training")
                e48("BT mode off")
            end
            e38()
        end,
    })
    e7:AddToggle("BTNext", {
        Text = "BT: Next Area",
        Default = false,
        Callback = function(e9)
            if e76 then
                return
            end
            if e9 then
                e77(function()
                    for e11, e12 in pairs(e78.rows) do
                        if e11 ~= "BodyToughness" and e73[e12].Value then
                            e73[e12]:SetValue(false)
                        end
                        if e11 == "PsychicPower" then
                            e69(false)
                        end
                    end
                    if not e73.Stat_BodyToughness.Value then
                        e73.Stat_BodyToughness:SetValue(true)
                    end
                    if e73.BTCurrent.Value then
                        e73.BTCurrent:SetValue(false)
                    end
                end)
                e33.mode = "n"
                e33.stat = "BodyToughness"
                e78.anchor = nil
                e78.base = nil
                local e11 = e60("BodyToughness")
                local e12 = e61("BodyToughness", e11)
                if not e12 then
                    e78.status:SetText("Body Toughness \xe2\x80\x94 No available area")
                    e78.area = nil
                    e33.mode = nil
                    e38()
                    e48("BT Next \xe2\x80\x94 No area")
                    return
                end
                local e13 = e63("BodyToughness", e12)
                e78.area = e13
                if not e13 then
                    e78.status:SetText("Area '" .. e12 .. "' not found!")
                    e33.mode = nil
                    e38()
                    e48("Area not found")
                    return
                end
                local e14, e15 = e64(e13)
                if e14 then
                    e78.anchor = e15
                    e78.status:SetText(
                        "Body Toughness (Next) \xe2\x80\x94 Area: "
                            .. e12
                            .. " (req "
                            .. e49.BodyToughness[e12].req
                            .. " --> "
                            .. e53(e49.BodyToughness[e12].req)
                            .. ")"
                            .. e59("BodyToughness")
                    )
                    e78.base = e78.status.Text:gsub(" %(%+.-/s%)$", "")
                    e48("BT Next \xe2\x80\x94 " .. e12)
                else
                    e78.status:SetText("Teleport failed!")
                    e48("Teleport failed")
                end
            else
                e33.mode = nil
                e33.stat = nil
                e78.area = nil
                e78.anchor = nil
                e77(function()
                    for e11, e12 in pairs(e78.rows) do
                        if e73[e12].Value then
                            e73[e12]:SetValue(false)
                        end
                    end
                end)
                e78.status:SetText("No active training")
                e48("BT mode off")
            end
            e38()
        end,
    })
end

local e79, e80, e81
e79 = { s = nil }

do
    local e7 = e75["Auto Weights"]:AddLeftGroupbox("Auto Weight", "dumbbell")
    e79.s = e7:AddLabel("Auto weight system inactive", true)
    e7:AddDivider()
    e7:AddLabel("Automatically equip the best available weight based on your stats", true)
    e7:AddToggle("AutoWeight", {
        Text = "Auto Weight",
        Default = e33.weight,
        Callback = function(e9)
            if e76 then
                return
            end
            e33.weight = e9
            e81()
            e38()
        end,
    })
end

e80 = function()
    e42("W")
    if not e33.weight then
        return
    end
    e19.th.W = task.spawn(function()
        local e7 = 0
        while e33.weight and e20() do
            task.wait(0.1)
            if e33.weight and not e71.Unloaded then
                e27(e29)
                e27(e30)
                e7 = e7 + 1
                e68(e7 >= 30)
                if e7 >= 30 then
                    e7 = 0
                end
            end
        end
        e19.th.W = nil
    end)
end

e81 = function(e7)
    e42("W")
    if not e33.weight then
        e79.s:SetText("Auto weight system inactive")
        if not e7 then
            e48("Auto Weight disabled")
        end
        return
    end
    e79.s:SetText("Auto Weight active \xe2\x80\x94 farming MS and JF automatically")
    e68(true)
    e80()
    if not e7 then
        e48("Auto Weight enabled")
    end
end

local function e82()
    e42("R")
    if not e33.rsp then
        return
    end
    local function e7()
        local e9 = game:GetService("Lighting"):FindFirstChild("Blur")
        if e9 then
            e9.Size = 0
            e9.Enabled = false
        end
        local e11 = e22:FindFirstChild("IntroGui")
        if e11 and e11:IsA("ScreenGui") then
            e11.Enabled = false
        end
        if e23 then
            e23.Enabled = true
        end
    end
    e19.th.R = task.spawn(function()
        while e33.rsp and e20() and not e71.Unloaded do
            local e11 = e33.rtype
            local e12 = e22:FindFirstChild("IntroGui")
            local e13 = e12 and e12:IsA("ScreenGui") and e12.Enabled
            local e14 = e4.Character
            local e15 = e14 and e14:FindFirstChildOfClass("Humanoid")
            local e16 = not e14 or not e15 or e15.Health <= 0 or e15:GetState() == Enum.HumanoidStateType.Dead
            local e17 = game:GetService("Lighting"):FindFirstChild("Blur")
            if e11 == "Risky" then
                if e13 then
                    e12.Enabled = false
                end
                if e17 and (e17.Enabled or e17.Size > 0) then
                    e17.Enabled = false
                    e17.Size = 0
                end
                if
                    (e14 and e15 and (e15.Health <= 0 or e15:GetState() == Enum.HumanoidStateType.Dead))
                    or (e13 and not e14)
                then
                    pcall(function()
                        local e18 = game:GetService("SoundService"):FindFirstChild("LocalSoundStorage")
                        local e65 = e18 and e18:FindFirstChild("DeathSound")
                        if e65 then
                            e65:Stop()
                        end
                    end)
                    e27({ "Respawn" })
                    local e18 = 0
                    while e18 < 5 and e33.rsp and e33.rtype == "Risky" do
                        e18 = e18 + 1
                        task.wait(0.1)
                        if e12 and e12.Parent and e12.Enabled then
                            e12.Enabled = false
                        end
                        if e17 then
                            if e17.Enabled then
                                e17.Enabled = false
                            end
                            if e17.Size > 0 then
                                e17.Size = 0
                            end
                        end
                    end
                else
                    if not e16 and e23 and not e23.Enabled then
                        local e18 = workspace.CurrentCamera
                        if e18 then
                            e18.CameraType = Enum.CameraType.Custom
                            e18.CameraSubject = e15
                        end
                        e7()
                    end
                    task.wait(0.05)
                end
            else
                if e13 and e16 then
                    e27({ "Respawn" })
                    task.wait(0.5)
                else
                    if not e16 and (e13 or (e17 and e17.Enabled) or (e23 and not e23.Enabled)) then
                        e7()
                    end
                    task.wait(0.4)
                end
            end
        end
        e19.th.R = nil
    end)
end

local e83 = {
    s = nil,
    d = nil,
    descs = {
        Risky = "Instant respawn on death, skips all animations",
        Normal = "Basic respawn when the intro screen appears",
    },
}
local e84 = {}

do
    local e7 = e75["Auto Respawn"]:AddLeftGroupbox("Auto Respawn", "skull")
    e83.s = e7:AddLabel("Auto respawn inactive", true)
    e7:AddDivider()
    e7:AddToggle("AutoRespawn", {
        Text = "Enable Auto Respawn",
        Default = e33.rsp,
        Callback = function(e9)
            if e76 then
                return
            end
            e33.rsp = e9
            e83.s:SetText(
                e9 and "Auto respawn armed \xe2\x80\x94 mode: " .. e33.rtype or "Auto respawn inactive"
            )
            e48(e9 and "Auto Respawn enabled" or "Auto Respawn disabled")
            e82()
            e38()
        end,
    })
    e7:AddLabel("Respawn Mode")
    e7:AddDropdown("RespawnMode", {
        Values = { "Risky", "Normal" },
        Default = e33.rtype or "Normal",
        Multi = false,
        Text = "Respawn Mode",
        Callback = function(e9)
            if e76 then
                return
            end
            e33.rtype = e9
            e83.d:SetText(e83.descs[e9])
            if e33.rsp then
                e83.s:SetText("Auto respawn armed \xe2\x80\x94 mode: " .. e9)
            end
            e82()
            e38()
        end,
    })
    e83.d = e7:AddLabel(e83.descs[e33.rtype or "Normal"], true)
    e84.apply = function()
        e77(function()
            e73.AutoRespawn:SetValue(e33.rsp)
            e72.RespawnMode:SetValue(e33.rtype or "Normal")
        end)
        e83.d:SetText(e83.descs[e33.rtype or "Normal"])
        e83.s:SetText(
            e33.rsp and "Auto respawn armed \xe2\x80\x94 mode: " .. e33.rtype or "Auto respawn inactive"
        )
        e82()
    end
end

local e85 = { s = nil }

do
    local e7 = e75["Position Manager"]:AddLeftGroupbox("Position Manager", "crosshair")
    e85.s = e7:AddLabel("No position saved", true)
    e7:AddDivider()
    e7:AddButton({
        Text = "Save Current Position",
        Func = function()
            if e4.Character and e4.Character:FindFirstChild("HumanoidRootPart") then
                e33.save = e4.Character.HumanoidRootPart.CFrame
                e85.s:SetText("Position saved! You will respawn here and be pulled back if you go too far.")
                e48("Position saved")
                e71:Notify({ Title = "eSPTS", Description = "Position saved", Time = 3 })
                task.wait(0.5)
                e38()
            end
        end,
    })
    e7:AddButton({
        Text = "Clear Saved Position",
        Func = function()
            e33.save = nil
            e85.s:SetText("Position cleared!")
            e48("Position cleared")
            e71:Notify({ Title = "eSPTS", Description = "Position cleared", Time = 3 })
            task.wait(0.5)
            e85.s:SetText("No position saved")
            e38()
        end,
    })
end

do
    local e11 = e75["Settings"]:AddLeftGroupbox("UI Settings", "wrench")
    e11:AddToggle("KeybindMenuOpen", {
        Text = "Open Keybind Menu",
        Default = e71.KeybindFrame.Visible,
        Callback = function(e12)
            e71.KeybindFrame.Visible = e12
            e39("kbmenu", e12)
        end,
    })
    e11:AddToggle("ShowCustomCursor", {
        Text = "Custom Cursor",
        Default = e71.ShowCustomCursor,
        Callback = function(e12)
            e71.ShowCustomCursor = e12
            e39("cur", e12)
        end,
    })
    e11:AddToggle("AlwaysOnTop", {
        Text = "Always On Top",
        Default = e74.AlwaysOnTop,
        Callback = function(e12)
            e74:SetAlwaysOnTop(e12)
            e39("top", e12)
        end,
    })
    e11:AddDropdown("NotificationSide", {
        Values = { "Left", "Right" },
        Default = "Right",
        Multi = false,
        Text = "Notification Side",
        Callback = function(e12)
            e71:SetNotifySide(e12)
            e39("nside", e12)
        end,
    })
    e11:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "100%",
        Multi = false,
        Text = "DPI Scale",
        Callback = function(e12)
            e71:SetDPIScale(tonumber(e12:gsub("%%", "")))
            e39("dpi", e12)
        end,
    })
    e11:AddSlider("UICornerSlider", {
        Text = "Corner Radius",
        Default = e71.CornerRadius,
        Min = 0,
        Max = 20,
        Rounding = 0,
        Callback = function(e12)
            e74:SetCornerRadius(e12)
            e39("corner", e12)
        end,
    })
    e11:AddDivider()
    e11:AddLabel("Menu bind")
    e11:AddLabel("Press to capture a new key for toggling the interface", true)
    e11:AddLabel("Keybind"):AddKeyPicker("MenuKeybind", {
        Default = e33.key,
        Mode = "Toggle",
        Text = "Toggle eSPTS",
        NoUI = true,
        ChangedCallback = function(e12)
            if e76 then
                return
            end
            e33.key = e12.Name
            e38()
            e48("Keybind \xe2\x80\x94 " .. e12.Name)
        end,
    })
    e71.ToggleKeybind = e72.MenuKeybind
    e11:AddDivider()
    e11:AddToggle("AutoHide", {
        Text = "Auto Hide UI",
        Default = e33.hide,
        Callback = function(e12)
            if e76 then
                return
            end
            e33.hide = e12
            e48(e12 and "Auto Hide enabled" or "Auto Hide disabled")
            e38()
        end,
    })
    e11:AddLabel("Auto Hide starts the interface hidden on the next execution.", true)
    if typeof(e33.ui) == "table" then
        local e12 = e33.ui
        if typeof(e12.cur) == "boolean" then
            e73.ShowCustomCursor:SetValue(e12.cur)
        end
        if typeof(e12.top) == "boolean" then
            e73.AlwaysOnTop:SetValue(e12.top)
        end
        if e12.nside == "Left" or e12.nside == "Right" then
            e72.NotificationSide:SetValue(e12.nside)
        end
        if typeof(e12.dpi) == "string" and table.find(e72.DPIDropdown.Values or {}, e12.dpi) then
            e72.DPIDropdown:SetValue(e12.dpi)
        end
        if typeof(e12.corner) == "number" and e12.corner >= 0 and e12.corner <= 20 then
            e72.UICornerSlider:SetValue(e12.corner)
        end
        if typeof(e12.kbmenu) == "boolean" then
            e73.KeybindMenuOpen:SetValue(e12.kbmenu)
        end
    end
    local e7, e9 = nil, nil
    pcall(function()
        e7 = loadstring(
            e70("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua")
        )()
    end)
    if not e20() or e71.Unloaded then
        return
    end
    pcall(function()
        e9 = loadstring(
            e70("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua")
        )()
    end)
    if not e20() or e71.Unloaded then
        return
    end
    if typeof(e7) == "table" then
        e7:SetLibrary(e71)
        e7:SetFolder("eSPTS_Obsidian")
        e7:ApplyToTab(e75["Settings"])
        e19.thmData = function()
            local e12 = {}
            for e8, e13 in ipairs({
                "BackgroundColor",
                "MainColor",
                "AccentColor",
                "OutlineColor",
                "FontColor",
            }) do
                local e14 = e72[e13]
                if e14 and typeof(e14.Value) == "Color3" then
                    e12[e13] = "#" .. e14.Value:ToHex()
                end
            end
            local e13 = e72.FontFace
            if e13 and typeof(e13.Value) == "string" then
                e12.FontFace = e13.Value
            end
            local e14 = e72.BackgroundImage
            if e14 and typeof(e14.Value) == "string" and e14.Value ~= "" then
                e12.BackgroundImage = e14.Value
            end
            return e12
        end
        if typeof(e33.ui) == "table" and typeof(e33.ui.td) == "table" then
            pcall(e7.ApplyThemeData, e7, e33.ui.td)
        end
        e43("THM", function()
            local e12 = nil
            while e20() and not e71.Unloaded do
                local e13 = {}
                for e8, e14 in ipairs({
                    "BackgroundColor",
                    "MainColor",
                    "AccentColor",
                    "OutlineColor",
                    "FontColor",
                    "FontFace",
                    "BackgroundImage",
                }) do
                    local e15 = e72[e14]
                    if e15 then
                        e13[#e13 + 1] = e14 .. "=" .. tostring(e15.Value)
                    end
                end
                table.sort(e13)
                local e14 = table.concat(e13, "|")
                if e12 ~= nil and e14 ~= e12 and e19.thmData then
                    local e15, e16 = pcall(e19.thmData)
                    if e15 and typeof(e16) == "table" then
                        if typeof(e33.ui) ~= "table" then
                            e33.ui = {}
                        end
                        e33.ui.td = e16
                        e38()
                    end
                end
                e12 = e14
                task.wait(1.5)
            end
        end)
    else
        warn("[eSPTS] ThemeManager unavailable - Themes section skipped")
        e48("Themes section skipped \xe2\x80\x94 ThemeManager could not load")
    end
    if typeof(e9) == "table" then
        e9:SetLibrary(e71)
        e9:IgnoreThemeSettings()
        e9:SetIgnoreIndexes({ "MenuKeybind" })
        e9:SetFolder("eSPTS_Obsidian")
        local e12 = { e9.SaveAutoloadConfig, e9.DeleteAutoLoadConfig }
        e9.GetAutoloadConfig = function()
            if typeof(e33.alsm) == "string" and e33.alsm ~= "" then
                e9.AutoloadConfig = e33.alsm
                return e33.alsm, true
            end
            e9.AutoloadConfig = nil
            return "none", false, "Autoload config is not set"
        end
        e9.SaveAutoloadConfig = function(e13, e14)
            local e15, e16 = e12[1](e9, e14)
            if e15 then
                e33.alsm = e14
                e38()
            end
            return e15, e16
        end
        e9.DeleteAutoLoadConfig = function(e13)
            local e15, e16 = e12[2](e9)
            if e15 then
                e33.alsm = nil
                e38()
            end
            return e15, e16
        end
        e19.smSave = function()
            pcall(e9.Save, e9, e31)
        end
        e19.smSave()
        e43("SM", function()
            local e13 = nil
            while e20() and not e71.Unloaded do
                local e14 = {}
                for e15, e16 in pairs(e71.Toggles) do
                    if e16.Type and not e9.Ignore[e15] then
                        e14[#e14 + 1] = e15 .. "=" .. tostring(e16.Value)
                    end
                end
                for e15, e16 in pairs(e71.Options) do
                    if e16.Type and not e9.Ignore[e15] then
                        e14[#e14 + 1] = e15 .. "=" .. tostring(e16.Value)
                    end
                end
                table.sort(e14)
                local e15 = table.concat(e14, "|")
                if e13 ~= nil and e15 ~= e13 then
                    e38()
                end
                e13 = e15
                task.wait(1.5)
            end
        end)
        e9:BuildConfigSection(e75["Settings"])
        e9:LoadAutoloadConfig()
    else
        warn("[eSPTS] SaveManager unavailable - Configuration section skipped")
        e48("Configuration section skipped \xe2\x80\x94 SaveManager could not load")
    end
end

do
    local e7 = e75["Settings"]:AddRightGroupbox("Activity Log", "scroll")
    local e9 = e7:AddLabel("No activity yet.", true)
    e47 = function()
        local e11 = {}
        local e12 = math.max(1, #e46 - 11)
        for e13 = e12, #e46 do
            e11[#e11 + 1] = "[" .. e46[e13].t .. "] " .. e46[e13].m
        end
        e9:SetText(#e11 > 0 and table.concat(e11, "\n") or "No activity yet.")
    end
    e47()
    e7:AddButton({
        Text = "Clear",
        Func = function()
            table.clear(e46)
            e47()
        end,
    })
end

do
    local e7 = e75["Settings"]:AddRightGroupbox("Danger Zone", "triangle-alert")
    e7:AddLabel("Fully unloads eSPTS and closes everything it created", true)
    local e9 = false
    local e11
    local function e12()
        pcall(e37)
        e6(e19)
    end
    local e13
    e13 = e7:AddButton({
        Text = "Uninject",
        Func = function()
            if not e45("UN", 0.15) then
                return
            end
            if not e9 then
                e9 = true
                e13:SetText("Click again to confirm")
                e71:Notify({ Title = "eSPTS", Description = "Click Uninject again to confirm", Time = 3 })
                e11 = task.delay(3, function()
                    e9 = false
                    e13:SetText("Uninject")
                end)
                return
            end
            if e11 then
                pcall(task.cancel, e11)
            end
            e9 = false
            e13:SetText("Uninjecting...")
            task.delay(0.15, function()
                e12()
            end)
        end,
    })
end

e71:OnUnload(function()
    pcall(e37)
    e6(e19)
end)

do
    local e7 = e41
    if e7 then
        e77(function()
            e73.AutoWeight:SetValue(e33.weight)
        end)
        e81(true)
        e84.apply()
        if e33.stat then
            for e9, e11 in pairs(e78.rows) do
                if e9 == e33.stat then
                    e77(function()
                        e73[e11]:SetValue(true)
                    end)
                    local e12 = e60(e9)
                    local e13
                    if e9 == "BodyToughness" and e33.mode == "c" then
                        e13 = e62(e9, e12)
                    else
                        e13 = e61(e9, e12)
                    end
                    if e13 then
                        local e14 = e63(e9, e13)
                        if e14 then
                            local e15, e16 = e64(e14)
                            if e15 then
                                e78.area = e14
                                e78.anchor = e16
                                if e9 == "BodyToughness" and e33.mode then
                                    local e17 = e33.mode == "n" and "Next" or "Current"
                                    e78.status:SetText(
                                        e78.names[e9]
                                            .. " ("
                                            .. e17
                                            .. ") \xe2\x80\x94 Area: "
                                            .. e13
                                            .. " (req "
                                            .. e49[e9][e13].req
                                            .. " --> "
                                            .. e53(e49[e9][e13].req)
                                            .. ")"
                                            .. e59(e9)
                                    )
                                else
                                    e78.status:SetText(
                                        e78.names[e9]
                                            .. " \xe2\x80\x94 Area: "
                                            .. e13
                                            .. " (req "
                                            .. e49[e9][e13].req
                                            .. " --> "
                                            .. e53(e49[e9][e13].req)
                                            .. ")"
                                            .. e59(e9)
                                    )
                                end
                                e78.base = e78.status.Text:gsub(" %(%+.-/s%)$", "")
                            end
                        end
                    end
                end
            end
            if e33.stat == "BodyToughness" and e33.mode then
                e77(function()
                    e73[e33.mode == "c" and "BTCurrent" or "BTNext"]:SetValue(true)
                end)
            end
            if e33.stat == "PsychicPower" then
                e69(true)
            end
        else
            e78.status:SetText("No active training")
        end
        if e33.save then
            e85.s:SetText("Position loaded from config!")
        end
        local e14 = e75[e33.tab]
        if e14 then
            e14:Show()
        else
            e75["Auto Farm"]:Show()
        end
        e48("Config loaded for " .. e31)
        e71:Notify({ Title = "eSPTS", Description = "Config loaded for " .. e31, Time = 4 })
    else
        e75["Auto Farm"]:Show()
        e48("Fresh start \xe2\x80\x94 no saved config")
        e71:Notify({ Title = "eSPTS", Description = "Fresh start \xe2\x80\x94 no saved config", Time = 4 })
    end
end

e44(e1.Heartbeat, function()
    if e71.Unloaded or not e20() or not e19.gui or not e19.gui.Parent then
        e6(e19)
        return
    end
    if e33.save and not e33.stat and e4.Character and e4.Character:FindFirstChild("HumanoidRootPart") then
        local e7 = e4.Character.HumanoidRootPart
        if (e7.Position - e33.save.Position).Magnitude > 20 then
            e7.CFrame = e33.save
        end
    end
    if tick() - e78.rtr >= 0.5 then
        e78.rtr = tick()
        local e7 = e56[e33.stat]
        if e7 and #e7.b > 0 and tick() - e7.b[#e7.b][1] > 10.5 then
            e7.r = 0
        end
        if e78.base and e33.stat and e78.status.Text:find(" \xe2\x80\x94 Area: ", 1, true) then
            e78.status:SetText(e78.base .. e59(e33.stat))
        end
    end
    if not e33.stat then
        return
    end
    local e9 = e4.Character
    if not e9 then
        return
    end
    local e11 = e9:FindFirstChild("HumanoidRootPart")
    if not e11 then
        return
    end
    local e12 = e60(e33.stat)
    local e13
    if e33.mode == "c" and e33.stat == "BodyToughness" then
        e13 = e62(e33.stat, e12)
    else
        e13 = e61(e33.stat, e12)
    end
    if e13 and (not e78.area or e78.area.Name ~= e13) then
        local e14 = e63(e33.stat, e13)
        if e14 then
            local e15, e16 = e64(e14)
            if e15 then
                e78.area = e14
                e78.anchor = e16
                if e33.stat == "BodyToughness" and e33.mode then
                    local e17 = e33.mode == "n" and "Next" or "Current"
                    e78.status:SetText(
                        e78.names[e33.stat]
                            .. " ("
                            .. e17
                            .. ") \xe2\x80\x94 Area: "
                            .. e13
                            .. " (req "
                            .. e49[e33.stat][e13].req
                            .. " --> "
                            .. e53(e49[e33.stat][e13].req)
                            .. ")"
                            .. e59(e33.stat)
                    )
                else
                    e78.status:SetText(
                        e78.names[e33.stat]
                            .. " \xe2\x80\x94 Area: "
                            .. e13
                            .. " (req "
                            .. e49[e33.stat][e13].req
                            .. " --> "
                            .. e53(e49[e33.stat][e13].req)
                            .. ")"
                            .. e59(e33.stat)
                    )
                end
                e78.base = e78.status.Text:gsub(" %(%+.-/s%)$", "")
            end
        end
    end
    if e78.anchor and (e11.Position - e78.anchor.Position).Magnitude > 45 then
        e11.CFrame = e78.anchor
    end
    if e33.stat == "FistStrength" then
        e27(e28)
    elseif e33.stat == "MovementSpeed" then
        if tick() - e78.thr >= 0.1 then
            e78.thr = tick()
            e27(e29)
        end
    elseif e33.stat == "JumpForce" then
        if tick() - e78.thr >= 0.1 then
            e78.thr = tick()
            e27(e30)
        end
    end
end)

e44(e4.CharacterAdded, function(e7)
    if e71.Unloaded or not e20() then
        return
    end
    task.wait(0.5)
    if e71.Unloaded or not e20() then
        return
    end
    local e9 = e7:WaitForChild("HumanoidRootPart", 5)
    if e33.save and not e33.stat then
        task.wait(0.1)
        if e9 then
            e9.CFrame = e33.save
        end
    end
    if e33.weight then
        task.wait(0.15)
        e68(true)
        e80()
    end
    if e33.stat and e78.area then
        local e11, e12 = e64(e78.area)
        if e11 then
            e78.anchor = e12
        end
    end
    if e33.stat == "PsychicPower" then
        e69(true)
    end
end)

if e4.Character then
    task.wait(0.5)
    if e71.Unloaded or not e20() then
        return
    end
    if e33.save and not e33.stat and e4.Character:FindFirstChild("HumanoidRootPart") then
        e4.Character.HumanoidRootPart.CFrame = e33.save
    end
end
