local e  = game:GetService("Players")
local e1 = game:GetService("RunService")
local e2 = game:GetService("HttpService")

local e3 = Color3.fromRGB

local e4 = e.LocalPlayer
if not e4 then
        warn("[eSPTS] Players.LocalPlayer is nil - execute inside the game client")
        return
end

local function er(a, b, c)
        c = c or 30
        local d = a:WaitForChild(b, c)
        if not d then
                warn("[eSPTS] timeout '" .. b .. "' in " .. a:GetFullName())
                error("[eSPTS] '" .. b .. "' not found - wrong game or updated instances", 0)
        end
        return d
end

local e5 = er(e4, "PlayerGui")
local e6 = er(e5, "ScreenGui")

do
        local a = typeof(getgenv) == "function" and getgenv() or _G
        local b = a.eSPTS_ObsidianRegistry
        if typeof(b) == "table" then
                if typeof(b.unload) == "function" then pcall(b.unload) end
                for _, c in pairs(b.th or {}) do
                        if typeof(c) == "thread" and coroutine.status(c) ~= "dead" then pcall(task.cancel, c) end
                end
                for _, c in pairs(b.cn or {}) do pcall(c.Disconnect, c) end
                if typeof(b.gui) == "Instance" and b.gui.Parent then pcall(b.gui.Destroy, b.gui) end
        end
        a.eSPTS_ObsidianRegistry = nil
end
e7 = { cn = {}, th = {} }
(typeof(getgenv) == "function" and getgenv() or _G).eSPTS_ObsidianRegistry = e7

local e8, e9 = e4.Name, e4.UserId
if not e8 or e8 == "" then
        repeat e8 = e4.Name task.wait() until e8 and e8 ~= ""
end

local e10 = {
        key    = "G",
        stat   = nil,
        weight = false,
        as     = true,
        tab    = "Auto Farm",
        save   = nil,
        mode   = nil,
        hide   = false,
        rsp    = false,
        rtype  = "Normal",
        alsm   = nil,
        ui     = nil
}

local e11 = "eSPTS_Obsidian/Accounts/" .. e8 .. ".json"
local e12 = { t = 0, f = false }
local e13 = er(game:GetService("ReplicatedStorage"), "RemoteEvent")
local e14 = er(er(e6, "MenuFrame"), "InfoFrame")
local e15 = er(er(workspace, "Map"), "Training_Collisions")

local function efr(a)
        e13:FireServer(a)
end

local eF = { "Add_FS_Request" }
local eM = { "Add_MS_Request" }
local eJ = { "Add_JF_Request" }

local function edr()
        if not makefolder or not isfolder then return end
        if not isfolder("eSPTS_Obsidian") then makefolder("eSPTS_Obsidian") end
        if not isfolder("eSPTS_Obsidian/Accounts") then makefolder("eSPTS_Obsidian/Accounts") end
end

local function esv()
        if not writefile then return false end
        edr()
        local a = e10.save and { e10.save:GetComponents() } or nil
        local b = {
                uid = e9, name = e8, key = e10.key, stat = e10.stat, weight = e10.weight,
                as = e10.as, tab = e10.tab, save = a, mode = e10.mode,
                hide = e10.hide, rsp = e10.rsp, rtype = e10.rtype, alsm = e10.alsm, ui = e10.ui
        }
        local c = pcall(function() writefile(e11, e2:JSONEncode(b)) end)
        if e7.smSave then pcall(e7.smSave) end
        if c then
                e12.t = tick()
                e12.f = false
                return true
        end
        e12.f = false
        return false
end

local function esq()
        if e12.f then return end
        e12.f = true
        local a = tick() - e12.t
        if a >= 0.1 then
                esv()
        else
                task.delay(0.1 - a, function()
                        if e12.f then esv() end
                end)
        end
end

local function eui(a, b)
        if typeof(e10.ui) ~= "table" then e10.ui = {} end
        if e10.ui[a] == b then return end
        e10.ui[a] = b
        esq()
end

local function eld()
        if not readfile or not isfile or not isfile(e11) then return false end
        local a, b = pcall(function() return e2:JSONDecode(readfile(e11)) end)
        if not a or not b or b.uid ~= e9 then return false end
        e10.key = b.key or "G"
        e10.stat = b.stat
        e10.weight = b.weight or false
        e10.as = b.as ~= nil and b.as or true
        e10.tab = b.tab or "Auto Farm"
        if e10.tab == "Position Man" then e10.tab = "Position Manager" end
        if b.save and #b.save == 12 then e10.save = CFrame.new(unpack(b.save)) end
        e10.mode = b.mode
        e10.rsp = b.rsp == true
        e10.rtype = (b.rtype == "Risky" or b.rtype == "Normal") and b.rtype or "Normal"
        e10.hide = b.hide or false
        e10.alsm = typeof(b.alsm) == "string" and b.alsm ~= "" and b.alsm or nil
        e10.ui = typeof(b.ui) == "table" and b.ui or nil
        return true
end

local e49 = eld()

local function e16(a)
        local b = e7.th[a]
        if b then
                e7.th[a] = nil
                if typeof(b) == "thread" and coroutine.status(b) ~= "dead" then pcall(task.cancel, b) end
        end
end

local function e17(a, b)
        e16(a)
        e7.th[a] = task.spawn(b)
end

local function e18(a, b)
        local c = a:Connect(b)
        e7.cn[#e7.cn + 1] = c
        return c
end

local e19
do
        local a = {}
        e19 = function(b, c)
                if a[b] then return false end
                a[b] = true
                task.delay(c or 0.3, function() a[b] = false end)
                return true
        end
end

local e20 = {}
local e21
local function e22(a)
        local b = os.date and os.date("%H:%M:%S") or "\xe2\x80\x94"
        e20[#e20 + 1] = { t = b, m = a }
        if #e20 > 40 then table.remove(e20, 1) end
        if e21 then e21() end
end

local e23 = {
        FistStrength = {
                TrainingArea_2  = { req = "0e0",    multi = "x1e1"    },
                TrainingArea_3  = { req = "1e6",    multi = "x1e2"    },
                StarFSTraining1 = { req = "1e9",    multi = "x2e3"    },
                StarFSTraining2 = { req = "1e11",   multi = "x4e4"    },
                StarFSTraining3 = { req = "1e13",   multi = "x8e5"    },
                AFK_FS_1        = { req = "1e15",   multi = "x6e6"    },
                AFK_FS_2        = { req = "1e17",   multi = "x3e8"    },
                AFK_FS_3        = { req = "1.5e19", multi = "x2.1e10" },
                AFK_FS_4        = { req = "2.5e21", multi = "x2.308e12" },
                AFK_FS_5        = { req = "1e24",   multi = "x3.475e14" },
                AFK_FS_6        = { req = "5e26",   multi = "x5.2e16" },
                AFK_FS_7        = { req = "2.5e29", multi = "x7.8e18" },
                AFK_FS_8        = { req = "1.5e32", multi = "??" },
                AFK_FS_9        = { req = "5.5e34", multi = "??" },
                AFK_FS_10       = { req = "3e37",   multi = "??" },
                AFK_FS_11       = { req = "1.1e40", multi = "??" }
        },
        BodyToughness = {
                FireBathTouchPart = { req = "5e2",      multi = "x1e1" },
                Water             = { req = "5e0",      multi = "x5e0" },
                IcePart           = { req = "5e3",      multi = "x2e1" },
                LavaPart          = { req = "5e5",      multi = "x1e2" },
                TornadoTouchPart  = { req = "5e4",      multi = "x5e1" },
                GreenFirePart     = { req = "5e7",      multi = "x2e3" },
                AcidPart          = { req = "5e9",      multi = "x4e4" },
                LavaPart2         = { req = "5e11",     multi = "x8e5" },
                AFK_BT_1          = { req = "7.383e12", multi = "x6e6" },
                AFK_BT_2          = { req = "6.55e14",  multi = "x1.8e8" },
                AFK_BT_3          = { req = "6.66e16",  multi = "x5.5e9" },
                AFK_BT_4          = { req = "5.1e18",   multi = "x1.625e11" },
                AFK_BT_5          = { req = "4.6e20",   multi = "x5e12" },
                AFK_BT_6          = { req = "4.005e22", multi = "x1.5e14" },
                AFK_BT_7          = { req = "3.55e24",  multi = "x4.5e15" },
                AFK_BT_8          = { req = "3.14e26",  multi = "x1.312e17" },
                AFK_BT_9          = { req = "2.778e28", multi = "x3.925e18" },
                AFK_BT_10         = { req = "2.473e30", multi = "x1.18e20" },
                AFK_BT_11         = { req = "2.175e32", multi = "x3.55e21" },
                AFK_BT_12         = { req = "1.95e34",  multi = "x1.062e23" },
                AFK_BT_13         = { req = "1.7e36",   multi = "x3.2e24" },
                AFK_BT_14         = { req = "1.55e38",  multi = "x9.574e25" },
                AFK_BT_15         = { req = "1.356e40", multi = "x2.5e27" }
        },
        MovementSpeed = {
                AFK_MS_1  = { req = "1e14",    multi = "x1.3e6" },
                AFK_MS_2  = { req = "2.22e15", multi = "x1.69e7" },
                AFK_MS_3  = { req = "6e16",    multi = "x2.197e8" },
                AFK_MS_4  = { req = "1.5e18",  multi = "x2.85e9" },
                AFK_MS_5  = { req = "4e19",    multi = "x3.72e10" },
                AFK_MS_6  = { req = "1e21",    multi = "x4.824e11" },
                AFK_MS_7  = { req = "2.5e22",  multi = "x6.274e12" },
                AFK_MS_8  = { req = "7.5e23",  multi = "x8.15e13" },
                AFK_MS_9  = { req = "1.55e25", multi = "x2.12e15" },
                AFK_MS_10 = { req = "4e26",    multi = "x1.377e16" },
                AFK_MS_11 = { req = "1e28",    multi = "x1.792e17" }
        },
        JumpForce = {
                AFK_JF_1 = { req = "1e14",    multi = "x1.7e6" },
                AFK_JF_2 = { req = "5e15",    multi = "x3.05e7" },
                AFK_JF_3 = { req = "1.5e17",  multi = "x5.5e8" },
                AFK_JF_4 = { req = "5e18",    multi = "x9.92e9" },
                AFK_JF_5 = { req = "2e20",    multi = "??" },
                AFK_JF_6 = { req = "1e22",    multi = "??" },
                AFK_JF_7 = { req = "3e23",    multi = "??" },
                AFK_JF_8 = { req = "1.5e25",  multi = "??" },
                AFK_JF_9 = { req = "4e26",    multi = "??" }
        },
        PsychicPower = {
                PPTrainingPart1 = { req = "1e6",     multi = "x1e2" },
                PPTrainingPart2 = { req = "1e9",     multi = "x1e4" },
                PPTrainingPart3 = { req = "1e12",    multi = "x1e6" },
                PPTrainingPart4 = { req = "1e15",    multi = "x1e8" },
                AFK_PP_1        = { req = "3.33e17", multi = "x2.5e9" },
                AFK_PP_2        = { req = "1.11e20", multi = "x2.5e11" },
                AFK_PP_3        = { req = "3.33e22", multi = "x2.5e13" },
                AFK_PP_4        = { req = "1.11e25", multi = "x2.5e15" },
                AFK_PP_5        = { req = "3.36e27", multi = "x2.5e17" },
                AFK_PP_6        = { req = "1.11e30", multi = "x2.5e19" },
                AFK_PP_7        = { req = "4.44e32", multi = "x2.5e21" },
                AFK_PP_8        = { req = "1.11e35", multi = "??" },
                AFK_PP_9        = { req = "5.55e37", multi = "??" },
                AFK_PP_10       = { req = "2.22e40", multi = "??" }
        }
}

local e24 = {
        { n = "1e2 LB",  m = 1e2,     j = 5e3 },
        { n = "1e0 TON", m = 5e3,     j = 2e5 },
        { n = "1e1 TON", m = 5e5,     j = 2e6 },
        { n = "1e2 TON", m = 1e7,     j = 1e7 },
        { n = "1e3 TON", m = 1e8,     j = 2e8 },
        { n = "1e4 TON", m = 1e9,     j = 1e9 },
        { n = "1e5 TON", m = 1e10,    j = 1e10 },
        { n = "1e6 TON", m = 1e11,    j = 1e11 },
        { n = "1e7 TON", m = 1e12,    j = 1e12 },
        { n = "1e9 TON", m = 1e13,    j = 1e13 },
        { n = "1e11 TON", m = 2.56e28, j = 1.54e28 },
        { n = "1e13 TON", m = 0e0,     j = 6e26 },
        { n = "1e15 TON", m = 1.68e32, j = 2.221e31 },
        { n = "1e17 TON", m = 4.288e33, j = 8.48e31 },
        { n = "1e19 TON", m = 1.082e34, j = 3.226e33 },
        { n = "1e21 TON", m = 2.823e36, j = 1.229e36 },
        { n = "1e23 TON", m = 7.02e37,  j = 4.683e37 },
        { n = "1e25 TON", m = 1.852e39, j = 1.785e39 },
        { n = "1e28 TON", m = 4.744e39, j = 6.8e39 }
}

local e25 = {
        { "K",    1e3   },
        { "M",    1e6   },
        { "B",    1e9   },
        { "T",    1e12  },
        { "Qa",   1e15  },
        { "Qi",   1e18  },
        { "Sx",   1e21  },
        { "Sp",   1e24  },
        { "Oc",   1e27  },
        { "No",   1e30  },
        { "Dc",   1e33  },
        { "Ud",   1e36  },
        { "Dd",   1e39  },
        { "Td",   1e42  },
        { "Qad",  1e45  },
        { "Qid",  1e48  },
        { "Sxd",  1e51  },
        { "Spd",  1e54  },
        { "Ocd",  1e57  },
        { "Nod",  1e60  },
        { "Vg",   1e63  },
        { "Uvg",  1e66  },
        { "Dvg",  1e69  },
        { "Tvg",  1e72  },
        { "Qavg", 1e75  },
        { "Qivg", 1e78  },
        { "Sxvg", 1e81  },
        { "Spvg", 1e84  },
        { "Ocvg", 1e87  },
        { "Novg", 1e90  },
        { "Tg",   1e93  },
        { "Utg",  1e96  },
        { "Dtg",  1e99  },
        { "Ttg",  1e102 },
        { "Qatg", 1e105 },
        { "Qitg", 1e108 },
        { "Sxtg", 1e111 },
        { "Sptg", 1e114 },
        { "Octg", 1e117 },
        { "Notg", 1e120 }
}

local function e26(a)
        if not a then return 0 end
        local b = tonumber(a)
        if b then return b end
        local c = tostring(a):gsub("%s+", "")
        local d, e = c:match("([%d%.]+)(%a*)$")
        local f = tonumber(d) or 0
        if e == "" then return f end
        for _, g in ipairs(e25) do
                if g[1] == e then return f * g[2] end
        end
        return f
end

local function eab(a)
        local b = tonumber(a)
        if not b then return tostring(a) end
        if b < 1000 then return string.format("%g", b) end
        local c, d
        for _, e in ipairs(e25) do
                if b >= e[2] then c, d = e[1], e[2] end
        end
        local f = b / d
        local g = f >= 100 and 0 or f >= 10 and 1 or 2
        local h = string.format("%." .. g .. "f", f)
        if h:find("%.") then h = h:gsub("0+$", ""):gsub("%.$", "") end
        return h .. c
end

local e27 = {}
for a, b in pairs(e23) do
        e27[a] = {}
        for c, d in pairs(b) do
                e27[a][c] = e26(d.req)
        end
end

local e28 = {
        FistStrength  = er(e14, "FSTxt"),
        BodyToughness = er(e14, "BTTxt"),
        MovementSpeed = er(e14, "MSTxt"),
        JumpForce     = er(e14, "JFTxt"),
        PsychicPower  = er(e14, "PPTxt")
}

local egr = {}
local egs = {
        FS_Gained_Handler = "FistStrength",
        BT_Gained_Handler = "BodyToughness",
        MS_Gained_Handler = "MovementSpeed",
        JF_Gained_Handler = "JumpForce",
        PP_Gained_Handler = "PsychicPower"
}
for _, a in ipairs({ "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" }) do
        egr[a] = { b = {}, r = 0 }
end
local function egt(a, b)
        local c = egr[a]
        if not c then return end
        local d = tick()
        while #c.b > 0 and d - c.b[1][1] > 10 do
                table.remove(c.b, 1)
        end
        c.b[#c.b + 1] = { d, b }
        local e = 0
        for _, g in ipairs(c.b) do
                e = e + g[2]
        end
        local f = d - c.b[1][1]
        c.r = e / (f < 1 and 1 or f)
end
local function egv(a)
        local b = egr[a]
        if b and b.r > 0 then
                return " (+" .. eab(b.r) .. "/s)"
        end
        return ""
end
e18(e13.OnClientEvent, function(a)
        if type(a) ~= "table" or type(a[1]) ~= "string" then return end
        local b = egs[a[1]]
        if b and type(a[3]) == "number" and a[3] > 0 then
                egt(b, a[3])
        end
end)

local function e29(a)
        local b = e28[a]
        if not b then return 0 end
        return e26(b.Text)
end

local function e30(a, b)
        local c = e27[a]
        if not c then return nil end
        local d, e = nil, -1
        for f, g in pairs(c) do
                if b >= g and g > e then
                        d = f
                        e = g
                end
        end
        return d
end

local function e31(a, b)
        local c = e27[a]
        if not c then return nil end
        local d, e, f, g = nil, -1, nil, -1
        for h, i in pairs(c) do
                if b >= i and i > e then
                        f = d
                        g = e
                        d = h
                        e = i
                elseif b >= i and i > g and i < e then
                        f = h
                        g = i
                end
        end
        return f
end

local function e32(a, b)
        local c = e15:FindFirstChild(a)
        if not c then return nil end
        return c:FindFirstChild(b)
end

local function e33(a)
        if not a then return false end
        local b = e4.Character
        if not b then return false end
        local c = b:FindFirstChild("HumanoidRootPart")
        if not c then return false end
        local d
        if a:IsA("BasePart") then
                d = a.CFrame
        else
                local e = a.PrimaryPart or a:FindFirstChildWhichIsA("BasePart")
                if e then d = e.CFrame end
        end
        if not d then return false end
        local f = d + Vector3.new(0, 5, 0)
        local g, h
        if a:IsA("BasePart") then
                g, h = a.CFrame, a.Size
        elseif a:IsA("Model") then
                local i, j, k = pcall(a.GetBoundingBox, a)
                if i and j and k then
                        g, h = j, k
                end
        end
        if g and h then
                local l = g:PointToObjectSpace(c.Position)
                local m = h.Y <= 8 and 4 or h.Y / 2
                if math.abs(l.X) <= h.X / 2 and math.abs(l.Z) <= h.Z / 2 and l.Y >= -h.Y / 2 and l.Y <= m then
                        local n = Vector3.new(c.Position.X, math.min(c.Position.Y, f.Position.Y), c.Position.Z)
                        return true, CFrame.new(n) * (f - f.Position)
                end
        end
        c.CFrame = f
        return true, f
end

local function e34(a)
        local b = e29("MovementSpeed")
        local c = e29("JumpForce")
        local d, e = nil, 1
        for f, g in ipairs(e24) do
                if b >= g.m and c >= g.j then
                        d = g
                        e = f
                else
                        break
                end
        end
        if d and (a or e ~= e7.we) then
                e7.we = e
                efr({ "EquipWeight_Request", e })
        end
end

local function epm(a)
        if a then
                e17("PP", function()
                        task.wait(0.4)
                        local b
                        while e10.stat == "PsychicPower" do
                                local c = e4.Character
                                local d = c and c:FindFirstChildOfClass("Humanoid")
                                local e = c and c:FindFirstChild("Meditate")
                                local f = e4:FindFirstChild("Backpack")
                                local g = f and f:FindFirstChild("Meditate")
                                local h = e30("PsychicPower", e29("PsychicPower"))
                                local i = h ~= nil and string.find(h, "AFK_PP", 1, true) ~= nil
                                if i then
                                        if b ~= 3 then
                                                b = 3
                                                e22("Psychic Power \xe2\x80\x94 AFK Zone (no Meditate needed)", e3(170, 120, 255))
                                        end
                                        if e and f then pcall(function() e.Parent = f end) end
                                        task.wait(0.5)
                                elseif e then
                                        if b ~= 0 then
                                                b = 0
                                                e22("Psychic Power \xe2\x80\x94 Meditating", e3(170, 120, 255))
                                        end
                                        task.wait(0.5)
                                elseif g and d and d.Health > 0 then
                                        if b ~= 1 then
                                                b = 1
                                                e22("Psychic Power \xe2\x80\x94 Re-equipping Meditate", e3(170, 120, 255))
                                        end
                                        pcall(d.EquipTool, d, g)
                                        task.wait(0.3)
                                elseif not g then
                                        if b ~= 2 then
                                                b = 2
                                                e22("Psychic Power \xe2\x80\x94 Meditate tool not found", e3(255, 150, 80))
                                        end
                                        task.wait(0.4)
                                else
                                        task.wait(0.4)
                                end
                        end
                end)
        else
                e16("PP")
                local b = e4.Character
                if b and b:FindFirstChild("Meditate") then
                        local c = b:FindFirstChildOfClass("Humanoid")
                        if c then c:UnequipTools() end
                end
        end
end

local function elr(a)
        local b = "eSPTS_Obsidian/cached_" .. a:match("([^/]+)$")
        local c, d = pcall(function()
                return game:HttpGet(a)
        end)
        if c and typeof(d) == "string" and #d > 200 then
                edr()
                if writefile then pcall(writefile, b, d) end
                return d
        end
        if readfile and isfile and isfile(b) then
                local e, f = pcall(readfile, b)
                if e and typeof(f) == "string" and #f > 200 then
                        warn("[eSPTS] download failed - using cached copy for " .. a)
                        return f
                end
        end
        warn("[eSPTS] could not download " .. a .. " - " .. tostring(d))
        error("[eSPTS] required library unavailable - download failed and no cached copy - check internet or executor http access", 0)
end

local e35 = (function()
        local a, b = pcall(function()
                return loadstring(elr("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
        end)
        if not a or typeof(b) ~= "table" then
                error("[eSPTS] Obsidian library failed to load - " .. tostring(b), 0)
        end
        return b
end)()
local e36 = e35.Options
local e37 = e35.Toggles
e7.gui = e35.ScreenGui

e7.unload = function()
        pcall(function()
                e35:Unload()
        end)
        pcall(function()
                if e7.gui and e7.gui.Parent then e7.gui:Destroy() end
        end)
end

local e38 = e35:CreateWindow({
        Title = "eSPTS",
        Footer = "SPTS: Endless",
        Icon = "zap",
        Center = true,
        AutoShow = not e10.hide,
        ShowCustomCursor = false,
        NotifySide = "Right",
        ToggleKeybind = Enum.KeyCode[e10.key]
})

if e10.hide then
        e22("Interface started hidden - press " .. e10.key .. " to show it")
        task.delay(0.5, function()
                e35:Notify({ Title = "eSPTS", Description = "Loaded hidden - press " .. e10.key .. " to show the interface", Time = 6 })
        end)
end

local e39 = {
        ["Auto Farm"]        = e38:AddTab("Auto Farm", "flame"),
        ["Auto Weights"]     = e38:AddTab("Auto Weights", "dumbbell"),
        ["Auto Respawn"]     = e38:AddTab("Auto Respawn", "skull"),
        ["Position Manager"] = e38:AddTab("Position Manager", "crosshair"),
        ["Settings"]         = e38:AddTab("Settings", "settings")
}

for a, b in pairs(e39) do
        local c = b.Show
        b.Show = function(d, ...)
                e10.tab = a
                esq()
                return c(d, ...)
        end
end

local e40 = false
local function e41(a)
        e40 = true
        local b, c = pcall(a)
        e40 = false
        return b, c
end

local e42 = { area = nil, anchor = nil, thr = 0, rtr = 0, base = nil, status = nil, names = nil, rows = nil }

do
        local a = e39["Auto Farm"]:AddLeftGroupbox("Stat Training", "flame")
        local b = a:AddLabel("No active training", true)
        e42.status = b
        a:AddDivider()
        a:AddLabel("Select a stat to automatically train at the best available area", true)
        local c = {
                FistStrength  = "Fist Strength",
                BodyToughness = "Body Toughness",
                MovementSpeed = "Movement Speed",
                JumpForce     = "Jump Force",
                PsychicPower  = "Psychic Power"
        }
        local d = { "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" }
        e42.names = c
        e42.rows = {}
        for e, f in ipairs(d) do
                e42.rows[f] = "Stat_" .. f
                a:AddToggle("Stat_" .. f, {
                        Text = c[f],
                        Default = false,
                        Callback = function(g)
                                if e40 then return end
                                if g then
                                        e41(function()
                                                for h, i in pairs(e42.rows) do
                                                        if h ~= f then
                                                                if e37[i].Value then e37[i]:SetValue(false) end
                                                                if h == "PsychicPower" then epm(false) end
                                                        end
                                                end
                                                if f ~= "BodyToughness" then
                                                        if e37.BTCurrent.Value then e37.BTCurrent:SetValue(false) end
                                                        if e37.BTNext.Value then e37.BTNext:SetValue(false) end
                                                end
                                        end)
                                        e10.stat = f
                                        if f ~= "BodyToughness" then e10.mode = nil end
                                        if f == "PsychicPower" then epm(true) end
                                        local h = e29(f)
                                        local i = e30(f, h)
                                        if not i then
                                                e42.status:SetText(c[f] .. " \xe2\x80\x94 No available area")
                                                e42.area = nil
                                                e10.mode = nil
                                                esq()
                                                e22(c[f] .. " \xe2\x80\x94 No area found")
                                                return
                                        end
                                        local j = e32(f, i)
                                        e42.area = j
                                        if not j then
                                                e42.status:SetText("Area '" .. i .. "' not found!")
                                                e10.mode = nil
                                                esq()
                                                e22("Area '" .. i .. "' not found")
                                                return
                                        end
                                        local k, l = e33(j)
                                        if k then
                                                e42.anchor = l
                                                e42.status:SetText(c[f] .. " \xe2\x80\x94 Area: " .. i .. " (req " .. e23[f][i].req .. " --> " .. eab(e23[f][i].req) .. ")" .. egv(f))
                                                e42.base = e42.status.Text
                                                e22(c[f] .. " \xe2\x80\x94 " .. i)
                                        else
                                                e42.status:SetText("Teleport failed!")
                                                e22("Teleport failed")
                                        end
                                else
                                        e10.stat = nil
                                        e42.area = nil
                                        e42.anchor = nil
                                        e10.mode = nil
                                        if f == "PsychicPower" then epm(false) end
                                        e41(function()
                                                if e37.BTCurrent.Value then e37.BTCurrent:SetValue(false) end
                                                if e37.BTNext.Value then e37.BTNext:SetValue(false) end
                                        end)
                                        e42.status:SetText("No active training")
                                        e22(c[f] .. " \xe2\x80\x94 Stopped")
                                end
                                esq()
                        end
                })
        end
end

do
        local a = e39["Auto Farm"]:AddRightGroupbox("Body Toughness Mode", "shield")
        a:AddLabel("Train in your current area or jump ahead to the next unlocked one", true)
        a:AddDivider()
        a:AddToggle("BTCurrent", {
                Text = "BT: Current Area",
                Default = false,
                Callback = function(b)
                        if e40 then return end
                        if b then
                                e41(function()
                                        for c, d in pairs(e42.rows) do
                                                if c ~= "BodyToughness" and e37[d].Value then e37[d]:SetValue(false) end
                                                if c == "PsychicPower" then epm(false) end
                                        end
                                        if not e37.Stat_BodyToughness.Value then e37.Stat_BodyToughness:SetValue(true) end
                                        if e37.BTNext.Value then e37.BTNext:SetValue(false) end
                                end)
                                e10.mode = "c"
                                e10.stat = "BodyToughness"
                                local c = e29("BodyToughness")
                                local d = e31("BodyToughness", c)
                                if not d then
                                        e42.status:SetText("Body Toughness \xe2\x80\x94 No available area")
                                        e42.area = nil
                                        e10.mode = nil
                                        esq()
                                        e22("BT Current \xe2\x80\x94 No area")
                                        return
                                end
                                local e = e32("BodyToughness", d)
                                e42.area = e
                                if not e then
                                        e42.status:SetText("Area '" .. d .. "' not found!")
                                        e10.mode = nil
                                        esq()
                                        e22("Area not found")
                                        return
                                end
                                local f, g = e33(e)
                                if f then
                                        e42.anchor = g
                                        e42.status:SetText("Body Toughness (Current) \xe2\x80\x94 Area: " .. d .. " (req " .. e23.BodyToughness[d].req .. " --> " .. eab(e23.BodyToughness[d].req) .. ")" .. egv("BodyToughness"))
                                        e42.base = e42.status.Text
                                        e22("BT Current \xe2\x80\x94 " .. d)
                                else
                                        e42.status:SetText("Teleport failed!")
                                        e22("Teleport failed")
                                end
                        else
                                e10.mode = nil
                                e10.stat = nil
                                e42.area = nil
                                e42.anchor = nil
                                e41(function()
                                        for c, d in pairs(e42.rows) do
                                                if e37[d].Value then e37[d]:SetValue(false) end
                                        end
                                end)
                                e42.status:SetText("No active training")
                                e22("BT mode off")
                        end
                        esq()
                end
        })
        a:AddToggle("BTNext", {
                Text = "BT: Next Area",
                Default = false,
                Callback = function(b)
                        if e40 then return end
                        if b then
                                e41(function()
                                        for c, d in pairs(e42.rows) do
                                                if c ~= "BodyToughness" and e37[d].Value then e37[d]:SetValue(false) end
                                                if c == "PsychicPower" then epm(false) end
                                        end
                                        if not e37.Stat_BodyToughness.Value then e37.Stat_BodyToughness:SetValue(true) end
                                        if e37.BTCurrent.Value then e37.BTCurrent:SetValue(false) end
                                end)
                                e10.mode = "n"
                                e10.stat = "BodyToughness"
                                local c = e29("BodyToughness")
                                local d = e30("BodyToughness", c)
                                if not d then
                                        e42.status:SetText("Body Toughness \xe2\x80\x94 No available area")
                                        e42.area = nil
                                        e10.mode = nil
                                        esq()
                                        e22("BT Next \xe2\x80\x94 No area")
                                        return
                                end
                                local e = e32("BodyToughness", d)
                                e42.area = e
                                if not e then
                                        e42.status:SetText("Area '" .. d .. "' not found!")
                                        e10.mode = nil
                                        esq()
                                        e22("Area not found")
                                        return
                                end
                                local f, g = e33(e)
                                if f then
                                        e42.anchor = g
                                        e42.status:SetText("Body Toughness (Next) \xe2\x80\x94 Area: " .. d .. " (req " .. e23.BodyToughness[d].req .. " --> " .. eab(e23.BodyToughness[d].req) .. ")" .. egv("BodyToughness"))
                                        e42.base = e42.status.Text
                                        e22("BT Next \xe2\x80\x94 " .. d)
                                else
                                        e42.status:SetText("Teleport failed!")
                                        e22("Teleport failed")
                                end
                        else
                                e10.mode = nil
                                e10.stat = nil
                                e42.area = nil
                                e42.anchor = nil
                                e41(function()
                                        for c, d in pairs(e42.rows) do
                                                if e37[d].Value then e37[d]:SetValue(false) end
                                        end
                                end)
                                e42.status:SetText("No active training")
                                e22("BT mode off")
                        end
                        esq()
                end
        })
end

local e43, e44, e45
e43 = { s = nil }

do
        local a = e39["Auto Weights"]:AddLeftGroupbox("Auto Weight", "dumbbell")
        e43.s = a:AddLabel("Auto weight system inactive", true)
        a:AddDivider()
        a:AddLabel("Automatically equip the best available weight based on your stats", true)
        a:AddToggle("AutoWeight", {
                Text = "Auto Weight",
                Default = e10.weight,
                Callback = function(b)
                        if e40 then return end
                        e10.weight = b
                        e45()
                        esq()
                end
        })
end

e44 = function()
        e16("W")
        if not e10.weight then return end
        e7.th.W = task.spawn(function()
                local a = 0
                while e10.weight do
                        task.wait(0.1)
                        if e10.weight and not e35.Unloaded then
                                efr(eM)
                                efr(eJ)
                                a = a + 1
                                e34(a >= 30)
                                if a >= 30 then a = 0 end
                        end
                end
                e7.th.W = nil
        end)
end

e45 = function(a)
        e16("W")
        if not e10.weight then
                e43.s:SetText("Auto weight system inactive")
                if not a then e22("Auto Weight disabled") end
                return
        end
        e43.s:SetText("Auto Weight active \xe2\x80\x94 farming MS and JF automatically")
        e34(true)
        e44()
        if not a then e22("Auto Weight enabled") end
end

local function erm()
        e16("R")
        if not e10.rsp then return end
        local function a()
                local b = game:GetService("Lighting"):FindFirstChild("Blur")
                if b then
                        b.Size = 0
                        b.Enabled = false
                end
                local c = e5:FindFirstChild("IntroGui")
                if c and c:IsA("ScreenGui") then c.Enabled = false end
                if e6 then e6.Enabled = true end
        end
        e7.th.R = task.spawn(function()
                while e10.rsp and not e35.Unloaded do
                        local c = e10.rtype
                        local d = e5:FindFirstChild("IntroGui")
                        local e = d and d:IsA("ScreenGui") and d.Enabled
                        local f = e4.Character
                        local g = f and f:FindFirstChildOfClass("Humanoid")
                        local h = not f or not g or g.Health <= 0 or g:GetState() == Enum.HumanoidStateType.Dead
                        local i = game:GetService("Lighting"):FindFirstChild("Blur")
                        if c == "Risky" then
                                if e then d.Enabled = false end
                                if i and (i.Enabled or i.Size > 0) then
                                        i.Enabled = false
                                        i.Size = 0
                                end
                                if (f and g and (g.Health <= 0 or g:GetState() == Enum.HumanoidStateType.Dead)) or (e and not f) then
                                        pcall(function()
                                                local k = game:GetService("SoundService"):FindFirstChild("LocalSoundStorage")
                                                local l = k and k:FindFirstChild("DeathSound")
                                                if l then l:Stop() end
                                        end)
                                        efr({ "Respawn" })
                                        local k = 0
                                        while k < 5 and e10.rsp and e10.rtype == "Risky" do
                                                k = k + 1
                                                task.wait(0.1)
                                                if d and d.Parent and d.Enabled then d.Enabled = false end
                                                if i then
                                                        if i.Enabled then i.Enabled = false end
                                                        if i.Size > 0 then i.Size = 0 end
                                                end
                                        end
                                else
                                        if not h and e6 and not e6.Enabled then
                                                local k = workspace.CurrentCamera
                                                if k then
                                                        k.CameraType = Enum.CameraType.Custom
                                                        k.CameraSubject = g
                                                end
                                                a()
                                        end
                                        task.wait(0.05)
                                end
                        else
                                if e and h then
                                        efr({ "Respawn" })
                                        task.wait(0.5)
                                else
                                        if not h and (e or (i and i.Enabled) or (e6 and not e6.Enabled)) then
                                                a()
                                        end
                                        task.wait(0.4)
                                end
                        end
                end
                e7.th.R = nil
        end)
end

local e46 = { s = nil, d = nil, descs = { Risky = "Instant respawn on death, skips all animations", Normal = "Basic respawn when the intro screen appears" } }
local e47 = {}

do
        local a = e39["Auto Respawn"]:AddLeftGroupbox("Auto Respawn", "skull")
        e46.s = a:AddLabel("Auto respawn inactive", true)
        a:AddDivider()
        a:AddToggle("AutoRespawn", {
                Text = "Enable Auto Respawn",
                Default = e10.rsp,
                Callback = function(b)
                        if e40 then return end
                        e10.rsp = b
                        e46.s:SetText(b and "Auto respawn armed \xe2\x80\x94 mode: " .. e10.rtype or "Auto respawn inactive")
                        e22(b and "Auto Respawn enabled" or "Auto Respawn disabled")
                        erm()
                        esq()
                end
        })
        a:AddLabel("Respawn Mode")
        a:AddDropdown("RespawnMode", {
                Values = { "Risky", "Normal" },
                Default = e10.rtype or "Normal",
                Multi = false,
                Text = "Respawn Mode",
                Callback = function(b)
                        if e40 then return end
                        e10.rtype = b
                        e46.d:SetText(e46.descs[b])
                        if e10.rsp then
                                e46.s:SetText("Auto respawn armed \xe2\x80\x94 mode: " .. b)
                        end
                        erm()
                        esq()
                end
        })
        e46.d = a:AddLabel(e46.descs[e10.rtype or "Normal"], true)
        e47.apply = function()
                e41(function()
                        e37.AutoRespawn:SetValue(e10.rsp)
                        e36.RespawnMode:SetValue(e10.rtype or "Normal")
                end)
                e46.d:SetText(e46.descs[e10.rtype or "Normal"])
                e46.s:SetText(e10.rsp and "Auto respawn armed \xe2\x80\x94 mode: " .. e10.rtype or "Auto respawn inactive")
                erm()
        end
end

local e48 = { s = nil }

do
        local a = e39["Position Manager"]:AddLeftGroupbox("Position Manager", "crosshair")
        e48.s = a:AddLabel("No position saved", true)
        a:AddDivider()
        a:AddButton({
                Text = "Save Current Position",
                Func = function()
                        if e4.Character and e4.Character:FindFirstChild("HumanoidRootPart") then
                                e10.save = e4.Character.HumanoidRootPart.CFrame
                                e48.s:SetText("Position saved! You will respawn here and be pulled back if you go too far.")
                                e22("Position saved")
                                e35:Notify({ Title = "eSPTS", Description = "Position saved", Time = 3 })
                                task.wait(0.5)
                                esq()
                        end
                end
        })
        a:AddButton({
                Text = "Clear Saved Position",
                Func = function()
                        e10.save = nil
                        e48.s:SetText("Position cleared!")
                        e22("Position cleared")
                        e35:Notify({ Title = "eSPTS", Description = "Position cleared", Time = 3 })
                        task.wait(0.5)
                        e48.s:SetText("No position saved")
                        esq()
                end
        })
end

do
        local c = e39["Settings"]:AddLeftGroupbox("UI Settings", "wrench")
        c:AddToggle("KeybindMenuOpen", {
                Text = "Open Keybind Menu",
                Default = e35.KeybindFrame.Visible,
                Callback = function(d)
                        e35.KeybindFrame.Visible = d
                        eui("kbmenu", d)
                end
        })
        c:AddToggle("ShowCustomCursor", {
                Text = "Custom Cursor",
                Default = e35.ShowCustomCursor,
                Callback = function(d)
                        e35.ShowCustomCursor = d
                        eui("cur", d)
                end
        })
        c:AddToggle("AlwaysOnTop", {
                Text = "Always On Top",
                Default = e38.AlwaysOnTop,
                Callback = function(d)
                        e38:SetAlwaysOnTop(d)
                        eui("top", d)
                end
        })
        c:AddDropdown("NotificationSide", {
                Values = { "Left", "Right" },
                Default = "Right",
                Multi = false,
                Text = "Notification Side",
                Callback = function(d)
                        e35:SetNotifySide(d)
                        eui("nside", d)
                end
        })
        c:AddDropdown("DPIDropdown", {
                Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
                Default = "100%",
                Multi = false,
                Text = "DPI Scale",
                Callback = function(d)
                        e35:SetDPIScale(tonumber(d:gsub("%%", "")))
                        eui("dpi", d)
                end
        })
        c:AddSlider("UICornerSlider", {
                Text = "Corner Radius",
                Default = e35.CornerRadius,
                Min = 0,
                Max = 20,
                Rounding = 0,
                Callback = function(d)
                        e38:SetCornerRadius(d)
                        eui("corner", d)
                end
        })
        c:AddDivider()
        c:AddLabel("Menu bind")
        c:AddLabel("Press to capture a new key for toggling the interface", true)
        c:AddLabel("Keybind"):AddKeyPicker("MenuKeybind", {
                Default = e10.key,
                Mode = "Toggle",
                Text = "Toggle eSPTS",
                NoUI = true,
                ChangedCallback = function(d)
                        if e40 then return end
                        e10.key = d.Name
                        esq()
                        e22("Keybind \xe2\x80\x94 " .. d.Name)
                end
        })
        e35.ToggleKeybind = e36.MenuKeybind
        c:AddDivider()
        c:AddToggle("AutoHide", {
                Text = "Auto Hide UI",
                Default = e10.hide,
                Callback = function(d)
                        if e40 then return end
                        e10.hide = d
                        e22(d and "Auto Hide enabled" or "Auto Hide disabled")
                        esq()
                end
        })
        c:AddLabel("Auto Hide starts the interface hidden on the next execution.", true)
        if typeof(e10.ui) == "table" then
                local d = e10.ui
                if typeof(d.cur) == "boolean" then e37.ShowCustomCursor:SetValue(d.cur) end
                if typeof(d.top) == "boolean" then e37.AlwaysOnTop:SetValue(d.top) end
                if d.nside == "Left" or d.nside == "Right" then e36.NotificationSide:SetValue(d.nside) end
                if typeof(d.dpi) == "string" and table.find(e36.DPIDropdown.Values or {}, d.dpi) then
                        e36.DPIDropdown:SetValue(d.dpi)
                end
                if typeof(d.corner) == "number" and d.corner >= 0 and d.corner <= 20 then e36.UICornerSlider:SetValue(d.corner) end
                if typeof(d.kbmenu) == "boolean" then e37.KeybindMenuOpen:SetValue(d.kbmenu) end
        end
        local a, b = nil, nil
        pcall(function()
                a = loadstring(elr("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
        end)
        pcall(function()
                b = loadstring(elr("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()
        end)
        if typeof(a) == "table" then
                a:SetLibrary(e35)
                a:SetFolder("eSPTS_Obsidian")
                a:ApplyToTab(e39["Settings"])
                e7.thmData = function()
                        local d = {}
                        for _, e in ipairs({ "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor" }) do
                                local f = e36[e]
                                if f and typeof(f.Value) == "Color3" then
                                        d[e] = "#" .. f.Value:ToHex()
                                end
                        end
                        local e = e36.FontFace
                        if e and typeof(e.Value) == "string" then d.FontFace = e.Value end
                        local f = e36.BackgroundImage
                        if f and typeof(f.Value) == "string" and f.Value ~= "" then d.BackgroundImage = f.Value end
                        return d
                end
                if typeof(e10.ui) == "table" and typeof(e10.ui.td) == "table" then
                        pcall(a.ApplyThemeData, a, e10.ui.td)
                end
                e17("THM", function()
                        local d = nil
                        while not e35.Unloaded do
                                local e = {}
                                for _, f in ipairs({ "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "FontFace", "BackgroundImage" }) do
                                        local g = e36[f]
                                        if g then e[#e + 1] = f .. "=" .. tostring(g.Value) end
                                end
                                table.sort(e)
                                local f = table.concat(e, "|")
                                if d ~= nil and f ~= d and e7.thmData then
                                        local g, h = pcall(e7.thmData)
                                        if g and typeof(h) == "table" then
                                                if typeof(e10.ui) ~= "table" then e10.ui = {} end
                                                e10.ui.td = h
                                                esq()
                                        end
                                end
                                d = f
                                task.wait(1.5)
                        end
                end)
        else
                warn("[eSPTS] ThemeManager unavailable - Themes section skipped")
                e22("Themes section skipped \xe2\x80\x94 ThemeManager could not load")
        end
        if typeof(b) == "table" then
                b:SetLibrary(e35)
                b:IgnoreThemeSettings()
                b:SetIgnoreIndexes({ "MenuKeybind" })
                b:SetFolder("eSPTS_Obsidian")
                local d = { b.SaveAutoloadConfig, b.DeleteAutoLoadConfig }
                b.GetAutoloadConfig = function()
                        if typeof(e10.alsm) == "string" and e10.alsm ~= "" then
                                b.AutoloadConfig = e10.alsm
                                return e10.alsm, true
                        end
                        b.AutoloadConfig = nil
                        return "none", false, "Autoload config is not set"
                end
                b.SaveAutoloadConfig = function(e, f)
                        local g, h = d[1](b, f)
                        if g then
                                e10.alsm = f
                                esq()
                        end
                        return g, h
                end
                b.DeleteAutoLoadConfig = function(e)
                        local g, h = d[2](b)
                        if g then
                                e10.alsm = nil
                                esq()
                        end
                        return g, h
                end
                e7.smSave = function()
                        pcall(b.Save, b, e8)
                end
                e7.smSave()
                e17("SM", function()
                        local g = nil
                        while not e35.Unloaded do
                                local h = {}
                                for i, j in pairs(e35.Toggles) do
                                        if j.Type and not b.Ignore[i] then
                                                h[#h + 1] = i .. "=" .. tostring(j.Value)
                                        end
                                end
                                for i, j in pairs(e35.Options) do
                                        if j.Type and not b.Ignore[i] then
                                                h[#h + 1] = i .. "=" .. tostring(j.Value)
                                        end
                                end
                                table.sort(h)
                                local k = table.concat(h, "|")
                                if g ~= nil and k ~= g then
                                        esq()
                                end
                                g = k
                                task.wait(1.5)
                        end
                end)
                b:BuildConfigSection(e39["Settings"])
                b:LoadAutoloadConfig()
        else
                warn("[eSPTS] SaveManager unavailable - Configuration section skipped")
                e22("Configuration section skipped \xe2\x80\x94 SaveManager could not load")
        end
end

do
        local a = e39["Settings"]:AddRightGroupbox("Activity Log", "scroll")
        local b = a:AddLabel("No activity yet.", true)
        e21 = function()
                local c = {}
                local d = math.max(1, #e20 - 11)
                for e = d, #e20 do
                        c[#c + 1] = "[" .. e20[e].t .. "] " .. e20[e].m
                end
                b:SetText(#c > 0 and table.concat(c, "\n") or "No activity yet.")
        end
        e21()
        a:AddButton({
                Text = "Clear",
                Func = function()
                        table.clear(e20)
                        e21()
                end
        })
end

do
        local a = e39["Settings"]:AddRightGroupbox("Danger Zone", "triangle-alert")
        a:AddLabel("Fully unloads eSPTS and closes everything it created", true)
        local b = false
        local c
        local function d()
                pcall(esv)
                for _, e in pairs(e7.th) do
                        if typeof(e) == "thread" and coroutine.status(e) ~= "dead" then pcall(task.cancel, e) end
                end
                for _, e in pairs(e7.cn) do pcall(e.Disconnect, e) end
                e7.th = {}
                e7.cn = {}
                e35:Unload()
        end
        local e
        e = a:AddButton({
                Text = "Uninject",
                Func = function()
                        if not e19("UN", 0.15) then return end
                        if not b then
                                b = true
                                e:SetText("Click again to confirm")
                                e35:Notify({ Title = "eSPTS", Description = "Click Uninject again to confirm", Time = 3 })
                                c = task.delay(3, function()
                                        b = false
                                        e:SetText("Uninject")
                                end)
                                return
                        end
                        if c then pcall(task.cancel, c) end
                        b = false
                        e:SetText("Uninjecting...")
                        task.delay(0.15, function() d() end)
                end
        })
end

e35:OnUnload(function()
        pcall(esv)
        for _, a in pairs(e7.th) do
                if typeof(a) == "thread" and coroutine.status(a) ~= "dead" then pcall(task.cancel, a) end
        end
        for _, a in pairs(e7.cn) do pcall(a.Disconnect, a) end
        e7.th = {}
        e7.cn = {}
end)

do
        local a = e49
        if a then
                e41(function()
                        e37.AutoWeight:SetValue(e10.weight)
                end)
                e45(true)
                e47.apply()
                if e10.stat then
                        for b, c in pairs(e42.rows) do
                                if b == e10.stat then
                                        e41(function()
                                                e37[c]:SetValue(true)
                                        end)
                                        local d = e29(b)
                                        local e
                                        if b == "BodyToughness" and e10.mode == "c" then e = e31(b, d) else e = e30(b, d) end
                                        if e then
                                                local f = e32(b, e)
                                                if f then
                                                        local g, h = e33(f)
                                                        if g then
                                                                e42.area = f
                                                                e42.anchor = h
                                                                if b == "BodyToughness" and e10.mode then
                                                                        local i = e10.mode == "n" and "Next" or "Current"
                                                                        e42.status:SetText(e42.names[b] .. " (" .. i .. ") \xe2\x80\x94 Area: " .. e .. " (req " .. e23[b][e].req .. " --> " .. eab(e23[b][e].req) .. ")" .. egv(b))
                                                                else
                                                                        e42.status:SetText(e42.names[b] .. " \xe2\x80\x94 Area: " .. e .. " (req " .. e23[b][e].req .. " --> " .. eab(e23[b][e].req) .. ")" .. egv(b))
                                                                end
                                                                e42.base = e42.status.Text
                                                        end
                                                end
                                        end
                                end
                        end
                        if e10.stat == "BodyToughness" and e10.mode then
                                e41(function()
                                        e37[e10.mode == "c" and "BTCurrent" or "BTNext"]:SetValue(true)
                                end)
                        end
                        if e10.stat == "PsychicPower" then epm(true) end
                else
                        e42.status:SetText("No active training")
                end
                if e10.save then e48.s:SetText("Position loaded from config!") end
                local j = e39[e10.tab]
                if j then j:Show() else e39["Auto Farm"]:Show() end
                e22("Config loaded for " .. e8)
                e35:Notify({ Title = "eSPTS", Description = "Config loaded for " .. e8, Time = 4 })
        else
                e39["Auto Farm"]:Show()
                e22("Fresh start \xe2\x80\x94 no saved config")
                e35:Notify({ Title = "eSPTS", Description = "Fresh start \xe2\x80\x94 no saved config", Time = 4 })
        end
end

e18(e1.Heartbeat, function()
        if e35.Unloaded then return end
        if e10.save and e4.Character and e4.Character:FindFirstChild("HumanoidRootPart") then
                local a = e4.Character.HumanoidRootPart
                if (a.Position - e10.save.Position).Magnitude > 20 then a.CFrame = e10.save end
        end
        if tick() - e42.rtr >= 0.5 then
                e42.rtr = tick()
                local a = egr[e10.stat]
                if a and #a.b > 0 and tick() - a.b[#a.b][1] > 10.5 then a.r = 0 end
                if e42.base and e10.stat and e42.status.Text:find(" \xe2\x80\x94 Area: ", 1, true) then
                        e42.status:SetText(e42.base .. egv(e10.stat))
                end
        end
        if not e10.stat then return end
        local b = e4.Character
        if not b then return end
        local c = b:FindFirstChild("HumanoidRootPart")
        if not c then return end
        local d = e29(e10.stat)
        local e
        if e10.mode == "c" and e10.stat == "BodyToughness" then e = e31(e10.stat, d) else e = e30(e10.stat, d) end
        if e and (not e42.area or e42.area.Name ~= e) then
                local f = e32(e10.stat, e)
                if f then
                        local g, h = e33(f)
                        if g then
                                e42.area = f
                                e42.anchor = h
                                if e10.stat == "BodyToughness" and e10.mode then
                                        local i = e10.mode == "n" and "Next" or "Current"
                                        e42.status:SetText(e42.names[e10.stat] .. " (" .. i .. ") \xe2\x80\x94 Area: " .. e .. " (req " .. e23[e10.stat][e].req .. " --> " .. eab(e23[e10.stat][e].req) .. ")" .. egv(e10.stat))
                                else
                                        e42.status:SetText(e42.names[e10.stat] .. " \xe2\x80\x94 Area: " .. e .. " (req " .. e23[e10.stat][e].req .. " --> " .. eab(e23[e10.stat][e].req) .. ")" .. egv(e10.stat))
                                end
                                e42.base = e42.status.Text
                        end
                end
        end
        if e42.anchor and (c.Position - e42.anchor.Position).Magnitude > 15 then c.CFrame = e42.anchor end
        if e10.stat == "FistStrength" then
                efr(eF)
        elseif e10.stat == "MovementSpeed" then
                if tick() - e42.thr >= 0.1 then
                        e42.thr = tick()
                        efr(eM)
                end
        elseif e10.stat == "JumpForce" then
                if tick() - e42.thr >= 0.1 then
                        e42.thr = tick()
                        efr(eJ)
                end
        end
end)

e18(e4.CharacterAdded, function(a)
        if e35.Unloaded then return end
        task.wait(0.5)
        local b = a:WaitForChild("HumanoidRootPart", 5)
        if e10.save then
                task.wait(0.1)
                if b then b.CFrame = e10.save end
        end
        if e10.weight then
                task.wait(0.15)
                e34(true)
                e44()
        end
        if e10.stat and e42.area then
                local c, d = e33(e42.area)
                if c then e42.anchor = d end
        end
        if e10.stat == "PsychicPower" then epm(true) end
end)

if e4.Character then
        task.wait(0.5)
        if e10.save and e4.Character:FindFirstChild("HumanoidRootPart") then
                e4.Character.HumanoidRootPart.CFrame = e10.save
        end
end
