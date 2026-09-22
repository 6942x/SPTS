local w  = game:GetService("Players")
local w1 = game:GetService("RunService")
local w2 = game:GetService("UserInputService")
local w3 = game:GetService("TweenService")
local w4 = game:GetService("HttpService")

local w5, w6, w7, w8, w9 = Color3.fromRGB, UDim2.new, UDim.new, Vector2.new, Instance.new
local w10, w11, w12      = Enum.Font.Gotham, Enum.Font.GothamBold, Enum.Font.Code
local w13, w14, w15      = Enum.TextXAlignment.Left, Enum.TextYAlignment.Top, Enum.TextYAlignment.Center

local w16 = w.LocalPlayer
if not w16 then
        warn("[eSPTS] Players.LocalPlayer is nil - execute inside the game client")
        return
end

local function wr(a, b, c)
        c = c or 30
        local d = a:WaitForChild(b, c)
        if not d then
                warn("[eSPTS] timeout '" .. b .. "' in " .. a:GetFullName())
                error("[eSPTS] '" .. b .. "' not found - wrong game or updated instances", 0)
        end
        return d
end

local w17 = wr(w16, "PlayerGui")
local w18 = wr(w17, "ScreenGui")

do
        local a = w18:FindFirstChild("eSPTSUI")
        if a then
                a:Destroy()
                task.wait(0.1)
        end
end

if w19 then
        for _, a in pairs(w19.cn or {}) do pcall(a.Disconnect, a) end
        for _, a in pairs(w19.tw or {}) do pcall(a.Cancel, a) end
        for _, a in pairs(w19.th or {}) do
                if typeof(a) == "thread" and coroutine.status(a) ~= "dead" then pcall(task.cancel, a) end
        end
end
w19 = { cn = {}, tw = {}, th = {} }

local w20, w21 = w16.Name, w16.UserId
if not w20 or w20 == "" then
        repeat w20 = w16.Name task.wait() until w20 and w20 ~= ""
end

local w22 = {
        key    = "G",
        stat   = nil,
        weight = false,
        as     = true,
        tab    = "Auto Farm",
        save   = nil,
        pos    = nil,
        icon   = nil,
        mode   = nil,
        hide   = false
}

local w23 = "eSPTS/Accounts/" .. w20 .. ".json"
local w24 = { t = 0, f = false }
local w25 = wr(game:GetService("ReplicatedStorage"), "RemoteEvent")
local w26 = wr(wr(w18, "MenuFrame"), "InfoFrame")
local w27 = wr(wr(workspace, "Map"), "Training_Collisions")
local w79, w80

local function wfr(a)
        w25:FireServer(a)
end

local wF = { "Add_FS_Request" }
local wM = { "Add_MS_Request" }
local wJ = { "Add_JF_Request" }

local function wdr()
        if not makefolder or not isfolder then return end
        if not isfolder("eSPTS") then makefolder("eSPTS") end
        if not isfolder("eSPTS/Accounts") then makefolder("eSPTS/Accounts") end
end

local function wsv()
        if not writefile then return false end
        wdr()
        if w79 and w79.Visible then w22.pos = { X = w79.Position.X.Offset, Y = w79.Position.Y.Offset } end
        if w80 and w80.Visible then w22.icon = { X = w80.Position.X.Offset, Y = w80.Position.Y.Offset } end
        local a = w22.save and { w22.save:GetComponents() } or nil
        local b = {
                uid = w21, name = w20, key = w22.key, stat = w22.stat, weight = w22.weight,
                as = w22.as, tab = w22.tab, save = a, pos = w22.pos, icon = w22.icon,
                mode = w22.mode, hide = w22.hide, rsp = w22.rsp, rtype = w22.rtype
        }
        local c = pcall(function() writefile(w23, w4:JSONEncode(b)) end)
        if c then
                w24.t = tick()
                w24.f = false
                return true
        end
        w24.f = false
        return false
end

local function wsq()
        if w24.f then return end
        w24.f = true
        local a = tick() - w24.t
        if a >= 0.1 then
                wsv()
        else
                task.delay(0.1 - a, function()
                        if w24.f then wsv() end
                end)
        end
end

local function wld()
        if not readfile or not isfile or not isfile(w23) then return false end
        local a, b = pcall(function() return w4:JSONDecode(readfile(w23)) end)
        if not a or not b or b.uid ~= w21 then return false end
        w22.key = b.key or "G"
        w22.stat = b.stat
        w22.weight = b.weight or false
        w22.as = b.as ~= nil and b.as or true
        w22.tab = b.tab or "Auto Farm"
        if w22.tab == "Position Man" then w22.tab = "Position Manager" end
        if b.save and #b.save == 12 then w22.save = CFrame.new(unpack(b.save)) end
        w22.pos = b.pos
        w22.icon = b.icon
        w22.mode = b.mode
        w22.rsp = b.rsp == true
        w22.rtype = (b.rtype == "Risky" or b.rtype == "Normal") and b.rtype or "Normal"
        w22.hide = b.hide or false
        return true
end

local w28 = {
        q = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        m = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        b = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        i = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        s = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

local function w30(a)
        local b = w19.tw[a]
        if b then
                b:Cancel()
                w19.tw[a] = nil
        end
end

local function w29(a, b, c)
        w30(a)
        local d = w3:Create(a, b, c)
        w19.tw[a] = d
        d:Play()
        d.Completed:Connect(function(e)
                if e == Enum.PlaybackState.Completed then w19.tw[a] = nil end
        end)
        return d
end

local function w31(a)
        local b = w19.th[a]
        if b then
                w19.th[a] = nil
                if typeof(b) == "thread" and coroutine.status(b) ~= "dead" then pcall(task.cancel, b) end
        end
end

local function w32(a, b)
        w31(a)
        w19.th[a] = task.spawn(b)
end

local function w33(a, b)
        local c = a:Connect(b)
        w19.cn[#w19.cn + 1] = c
        return c
end

local w34
do
        local a = {}
        w34 = function(b, c)
                if a[b] then return false end
                a[b] = true
                task.delay(c or 0.3, function() a[b] = false end)
                return true
        end
end

local w35 = {}
local w36
local function w37(a, b)
        if w36 then
                w36(a, b)
        else
                w35[#w35 + 1] = { a, b }
        end
end

local w38 = {
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

local w39 = {
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

local w40 = {
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

local function w41(a)
        if not a then return 0 end
        local b = tonumber(a)
        if b then return b end
        local c = tostring(a):gsub("%s+", "")
        local d, e = c:match("([%d%.]+)(%a*)$")
        local f = tonumber(d) or 0
        if e == "" then return f end
        for _, g in ipairs(w40) do
                if g[1] == e then return f * g[2] end
        end
        return f
end

local function wab(a)
        local b = tonumber(a)
        if not b then return tostring(a) end
        if b < 1000 then return string.format("%g", b) end
        local c, d
        for _, e in ipairs(w40) do
                if b >= e[2] then c, d = e[1], e[2] end
        end
        local f = b / d
        local g = f >= 100 and 0 or f >= 10 and 1 or 2
        local h = string.format("%." .. g .. "f", f)
        if h:find("%.") then h = h:gsub("0+$", ""):gsub("%.$", "") end
        return h .. c
end

local w38n = {}
for a, b in pairs(w38) do
        w38n[a] = {}
        for c, d in pairs(b) do
                w38n[a][c] = w41(d.req)
        end
end

local w42 = {
        FistStrength  = wr(w26, "FSTxt"),
        BodyToughness = wr(w26, "BTTxt"),
        MovementSpeed = wr(w26, "MSTxt"),
        JumpForce     = wr(w26, "JFTxt"),
        PsychicPower  = wr(w26, "PPTxt")
}

local wgr = {}
local wgs = {
        FS_Gained_Handler = "FistStrength",
        BT_Gained_Handler = "BodyToughness",
        MS_Gained_Handler = "MovementSpeed",
        JF_Gained_Handler = "JumpForce",
        PP_Gained_Handler = "PsychicPower"
}
for _, a in ipairs({ "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" }) do
        wgr[a] = { b = {}, r = 0 }
end
local function wgt(a, b)
        local c = wgr[a]
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
local function wgv(a)
        local b = wgr[a]
        if b and b.r > 0 then
                return " (+" .. wab(b.r) .. "/s)"
        end
        return ""
end
w33(w25.OnClientEvent, function(a)
        if type(a) ~= "table" or type(a[1]) ~= "string" then return end
        local b = wgs[a[1]]
        if b and type(a[3]) == "number" and a[3] > 0 then
                wgt(b, a[3])
        end
end)

local function w43(a)
        local b = w42[a]
        if not b then return 0 end
        return w41(b.Text)
end

local function w44(a, b)
        local c = w38n[a]
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

local function w45(a, b)
        local c = w38n[a]
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

local function w46(a, b)
        local c = w27:FindFirstChild(a)
        if not c then return nil end
        return c:FindFirstChild(b)
end

local function w47(a)
        if not a then return false end
        local b = w16.Character
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
        if d then
                c.CFrame = d + Vector3.new(0, 5, 0)
                return true, d + Vector3.new(0, 5, 0)
        end
        return false
end

local function w48(a)
        local b = w43("MovementSpeed")
        local c = w43("JumpForce")
        local d, e = nil, 1
        for f, g in ipairs(w39) do
                if b >= g.m and c >= g.j then
                        d = g
                        e = f
                else
                        break
                end
        end
        if d and (a or e ~= w19.we) then
                w19.we = e
                wfr({ "EquipWeight_Request", e })
        end
end

local function wpm(a)
        if a then
                w32("PP", function()
                        task.wait(0.4)
                        local b
                        while w22.stat == "PsychicPower" do
                                local c = w16.Character
                                local d = c and c:FindFirstChildOfClass("Humanoid")
                                local e = c and c:FindFirstChild("Meditate")
                                local f = w16:FindFirstChild("Backpack")
                                local g = f and f:FindFirstChild("Meditate")
                                local h = w44("PsychicPower", w43("PsychicPower"))
                                local i = h ~= nil and string.find(h, "AFK_PP", 1, true) ~= nil
                                if i then
                                        if b ~= 3 then
                                                b = 3
                                                w37("Psychic Power \xe2\x80\x94 AFK Zone (no Meditate needed)", w5(170, 120, 255))
                                        end
                                        if e and f then pcall(function() e.Parent = f end) end
                                        task.wait(0.5)
                                elseif e then
                                        if b ~= 0 then
                                                b = 0
                                                w37("Psychic Power \xe2\x80\x94 Meditating", w5(170, 120, 255))
                                        end
                                        task.wait(0.5)
                                elseif g and d and d.Health > 0 then
                                        if b ~= 1 then
                                                b = 1
                                                w37("Psychic Power \xe2\x80\x94 Re-equipping Meditate", w5(170, 120, 255))
                                        end
                                        pcall(d.EquipTool, d, g)
                                        task.wait(0.3)
                                elseif not g then
                                        if b ~= 2 then
                                                b = 2
                                                w37("Psychic Power \xe2\x80\x94 Meditate tool not found", w5(255, 150, 80))
                                        end
                                        task.wait(0.4)
                                else
                                        task.wait(0.4)
                                end
                        end
                end)
        else
                w31("PP")
                local b = w16.Character
                if b and b:FindFirstChild("Meditate") then
                        local c = b:FindFirstChildOfClass("Humanoid")
                        if c then c:UnequipTools() end
                end
        end
end

local function w49(a, b)
        local c = w9("UICorner", a)
        c.CornerRadius = w7(0, b or 8)
        return c
end

local function w50(a, b, c, d)
        local e = w9("UIGradient", a)
        e.Color = ColorSequence.new { ColorSequenceKeypoint.new(0, b), ColorSequenceKeypoint.new(1, c) }
        e.Rotation = d or 90
        return e
end

local function w51(a, b, c)
        local d = w9("Frame", a)
        d.Size = w6(1, 0, 0, b)
        d.BackgroundColor3 = w5(32, 24, 45)
        d.BorderSizePixel = 0
        d.LayoutOrder = c or 1
        w49(d, 10)
        w50(d, w5(32, 24, 45), w5(38, 28, 52), 90)
        return d
end

local function w52(a, b, c)
        local d = w9("TextLabel", a)
        d.Size = w6(1, -20, 0, 20)
        d.Position = w6(0, 10, 0, c)
        d.BackgroundTransparency = 1
        d.Text = b
        d.Font = w10
        d.TextSize = 12
        d.TextColor3 = w5(150, 150, 150)
        d.TextXAlignment = w13
        return d
end

local function w53(a, b, c)
        local d = w9("TextLabel", a)
        d.Size = w6(1, -20, 0, 26)
        d.Position = w6(0, 10, 0, c)
        d.BackgroundTransparency = 1
        d.Text = b
        d.Font = w11
        d.TextSize = 18
        d.TextXAlignment = w13
        return d
end

local function w54(a, b, c)
        local d = w9("Frame", a)
        d.Size = w6(1, -20, 0, 40)
        d.Position = w6(0, 10, 0, c)
        d.BackgroundColor3 = w5(38, 28, 52)
        d.BorderSizePixel = 0
        w49(d, 8)
        local e = w9("TextLabel", d)
        e.Size = w6(1, -70, 1, 0)
        e.Position = w6(0, 14, 0, 0)
        e.BackgroundTransparency = 1
        e.Text = b
        e.Font = w11
        e.TextSize = 14
        e.TextColor3 = w5(200, 200, 200)
        e.TextXAlignment = w13
        return d, e
end

local function w55(a, b, c)
        local d = b.X.Offset or 56
        local e = b.Y.Offset or 28
        local f = e - 6
        local g = 3
        local h = d - f - 3
        local i = w9("Frame", a)
        i.Size = w6(0, d, 0, e)
        i.Position = w6(1, -(d + 14), 0.5, 0)
        i.AnchorPoint = w8(0, 0.5)
        i.BorderSizePixel = 0
        i.BackgroundColor3 = c and w5(50, 220, 100) or w5(70, 50, 90)
        w49(i, e / 2)
        local j = w9("Frame", i)
        j.Size = w6(0, f, 0, f)
        j.Position = w6(0, c and h or g, 0.5, 0)
        j.AnchorPoint = w8(0, 0.5)
        j.BackgroundColor3 = w5(255, 255, 255)
        j.BorderSizePixel = 0
        w49(j, f / 2)
        local k = w9("TextButton", i)
        k.Size = w6(1, 0, 1, 0)
        k.BackgroundTransparency = 1
        k.Text = ""
        k.ZIndex = i.ZIndex + 2
        return k, { on = c, t = i, k = j, a = g, b = h }
end

local function w56(a, b)
        if not a then return end
        a.on = b
        w29(a.t, w28.q, { BackgroundColor3 = b and w5(50, 220, 100) or w5(70, 50, 90) })
        w29(a.k, w28.q, { Position = w6(0, b and a.b or a.a, 0.5, 0) })
end

local function w57(a, b, c, d)
        w33(a.MouseEnter, function() w29(a, w28.q, c) end)
        w33(a.MouseLeave, function() w29(a, w28.q, b) end)
        w33(a.MouseButton1Down, function() w29(a, w28.q, d) end)
        w33(a.MouseButton1Up, function() w29(a, w28.q, c) end)
end

local function w58(a, b, c, d)
        w33(a.MouseEnter, function()
                if not d() then w29(a, w28.q, { BackgroundColor3 = b }) end
        end)
        w33(a.MouseLeave, function()
                if not d() then w29(a, w28.q, { BackgroundColor3 = c }) end
        end)
end

local function w59(a, b, c, d)
        local e = w9("Frame", a)
        e.Size = b
        e.Position = c
        e.BackgroundColor3 = w5(28, 20, 40)
        e.BorderSizePixel = 0
        w49(e, 8)
        w9("UIStroke", e).Color = w5(70, 45, 95)
        local f = w9("TextLabel", e)
        f.Size = w6(1, -10, 1, -10)
        f.Position = w6(0, 5, 0, 5)
        f.BackgroundTransparency = 1
        f.Text = d
        f.Font = w10
        f.TextSize = 14
        f.TextColor3 = w5(180, 180, 180)
        f.TextXAlignment = w13
        f.TextWrapped = true
        f.TextYAlignment = w14
        return e, f
end

local function w60(a, b)
        local c = w9("Frame", a)
        c.Size = w6(1, -20, 0, 1)
        c.Position = w6(0, 10, 0, b)
        c.BackgroundColor3 = w5(70, 45, 95)
        c.BorderSizePixel = 0
        return c
end

local function w61(a, b, c)
        local d = w9("Frame", a)
        d.Size = b
        d.Position = c
        d.BackgroundColor3 = w5(18, 14, 26)
        d.BorderSizePixel = 0
        w49(d, 8)
        w9("UIStroke", d).Color = w5(70, 45, 95)
        local e = w9("ScrollingFrame", d)
        e.Size = w6(1, -4, 1, -4)
        e.Position = w6(0, 2, 0, 2)
        e.BackgroundTransparency = 1
        e.BorderSizePixel = 0
        e.ScrollBarThickness = 3
        e.ScrollBarImageColor3 = w5(150, 80, 255)
        e.ScrollBarImageTransparency = 0.5
        e.CanvasSize = w6(0, 0, 0, 0)
        e.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local f = w9("UIListLayout", e)
        f.SortOrder = Enum.SortOrder.LayoutOrder
        f.Padding = w7(0, 2)
        local g = w9("UIPadding", e)
        g.PaddingLeft = w7(0, 6)
        g.PaddingRight = w7(0, 6)
        g.PaddingTop = w7(0, 4)
        g.PaddingBottom = w7(0, 4)
        local h = w9("TextLabel", e)
        h.Size = w6(1, 0, 0, 20)
        h.BackgroundTransparency = 1
        h.Font = w12
        h.TextSize = 11
        h.TextColor3 = w5(90, 90, 100)
        h.TextXAlignment = w13
        h.LayoutOrder = 1
        local i = 1
        local q = {}
        local function j(k, l)
                h.Visible = false
                i = i + 1
                local m = os.date and os.date("%H:%M:%S") or "\xe2\x80\x94"
                local n = w9("TextLabel", e)
                n.Size = w6(1, 0, 0, 0)
                n.AutomaticSize = Enum.AutomaticSize.Y
                n.BackgroundTransparency = 1
                n.Text = "[" .. m .. "] " .. k
                n.Font = w12
                n.TextSize = 11
                n.TextColor3 = l or w5(220, 220, 220)
                n.TextXAlignment = w13
                n.TextYAlignment = w14
                n.TextWrapped = true
                n.LayoutOrder = i
                q[#q + 1] = n
                if #q > 40 then
                        q[1]:Destroy()
                        table.remove(q, 1)
                end
                task.defer(function() e.CanvasPosition = w8(0, math.huge) end)
                return n
        end
        local function o()
                for _, p in ipairs(e:GetChildren()) do
                        if p:IsA("TextLabel") and p ~= h then p:Destroy() end
                end
                q = {}
                i = 1
                h.Visible = true
        end
        return d, e, h, j, o
end

local w62 = w9("ScreenGui")
w62.Name = "eSPTSUI"
w62.ResetOnSpawn = false
w62.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
w62.Parent = w18

local w63, w64, w65 = 600, 480, 56
local w66 = 1
local w67

local function w68()
        return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or w8(1920, 1080)
end

local function w69(a)
        return math.clamp(math.min(a.X / 1920, a.Y / 1080), 0.75, 1.4)
end

local function w70(a, b)
        local c, d = w63 * b, w64 * b
        return math.max(0, (a.X - c) / 2), math.max(0, (a.Y - d) / 2)
end

local function w71(a, b)
        local c = math.floor(w65 * b)
        return c, math.max(0, (a.X - c) / 3), math.max(0, math.min(30, a.Y - c))
end

local function w72()
        local a = w68()
        if a.X < 100 or a.Y < 100 then
                local b = tick() + 10
                while (w68().X < 100 or w68().Y < 100) and tick() < b do
                        task.wait()
                end
        end
        return w68()
end

local function w73()
        return math.floor(w65 * w66)
end

w79 = w9("Frame", w62)
w79.Name = "MainFrame"
w79.Size = w6(0, 0, 0, 0)
w79.Position = w6(0, 0, 0, 0)
w79.BackgroundColor3 = w5(22, 18, 32)
w79.BorderSizePixel = 0
w79.Active = true
w79.ClipsDescendants = true
w79.Visible = false
w49(w79, 16)

w67 = w9("UIScale", w79)
w67.Scale = 1

do
        local function a(b, c)
                local d, e, f, g = false, nil, nil, nil
                w33(b.InputBegan, function(h)
                        if h.UserInputType == Enum.UserInputType.MouseButton1 or h.UserInputType == Enum.UserInputType.Touch then
                                d = true
                                f = h.Position
                                g = b.Position
                                if e then e:Disconnect() end
                                e = w2.InputChanged:Connect(function(i)
                                        if (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) and d then
                                                local j = i.Position - f
                                                b.Position = w6(g.X.Scale, g.X.Offset + j.X, g.Y.Scale, g.Y.Offset + j.Y)
                                        end
                                end)
                                h.Changed:Connect(function()
                                        if h.UserInputState == Enum.UserInputState.End then
                                                d = false
                                                if e then
                                                        e:Disconnect()
                                                        e = nil
                                                end
                                                if c then c() end
                                        end
                                end)
                        end
                end)
        end
        a(w79, function() wsq() end)
end

do
        local a = w9("ImageLabel", w79)
        a.BackgroundTransparency = 1
        a.Position = w6(0, -15, 0, -15)
        a.Size = w6(1, 30, 1, 30)
        a.ZIndex = 0
        a.Image = "rbxassetid://6014261993"
        a.ImageColor3 = w5(10, 5, 15)
        a.ImageTransparency = 0.5
        a.ScaleType = Enum.ScaleType.Slice
        a.SliceCenter = Rect.new(49, 49, 450, 450)
end

local w74 = w9("Frame", w79)
w74.Size = w6(1, 0, 0, 46)
w74.BackgroundColor3 = w5(32, 24, 45)
w74.BorderSizePixel = 0
w49(w74, 16)
w50(w74, w5(35, 26, 48), w5(26, 20, 38), 90)

do
        local a = w9("TextLabel", w74)
        a.Size = w6(1, -60, 1, 0)
        a.Position = w6(0, 14, 0, 0)
        a.BackgroundTransparency = 1
        a.Text = "eSPTS"
        a.Font = w11
        a.TextSize = 22
        a.TextColor3 = w5(255, 255, 255)
        a.TextXAlignment = w13
end

local w75 = w9("ImageButton", w74)
w75.Size = w6(0, 28, 0, 28)
w75.Position = w6(1, -14, 0.5, 0)
w75.AnchorPoint = w8(1, 0.5)
w75.BackgroundColor3 = w5(180, 50, 220)
w75.BorderSizePixel = 0
w75.Image = "rbxassetid://3926305904"
w75.ImageRectOffset = w8(284, 4)
w75.ImageRectSize = w8(24, 24)
w75.ImageColor3 = w5(255, 255, 255)
w49(w75, 8)

w33(w75.MouseEnter, function()
        w29(w75, w28.q, { BackgroundColor3 = w5(240, 70, 70), Size = w6(0, 32, 0, 32), Rotation = 90 })
end)
w33(w75.MouseLeave, function()
        w29(w75, w28.q, { BackgroundColor3 = w5(180, 50, 220), Size = w6(0, 28, 0, 28), Rotation = 0 })
end)
w33(w75.MouseButton1Down, function()
        w29(w75, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = w6(0, 24, 0, 24) })
end)
w33(w75.MouseButton1Up, function()
        w29(w75, w28.q, { Size = w6(0, 28, 0, 28) })
end)

local w76 = w9("Frame", w79)
w76.Size = w6(0, 165, 1, -52)
w76.Position = w6(0, 5, 0, 52)
w76.BackgroundColor3 = w5(28, 20, 40)
w76.BorderSizePixel = 0
w49(w76, 10)
w50(w76, w5(28, 20, 40), w5(22, 18, 32), 90)

local w77 = w9("Frame", w79)
w77.Size = w6(1, -180, 1, -57)
w77.Position = w6(0, 178, 0, 52)
w77.BackgroundTransparency = 1
w77.BorderSizePixel = 0
w77.ClipsDescendants = true

w80 = w9("ImageButton", w62)
w80.Name = "ReopenButton"
w80.Size = w6(0, w73(), 0, w73())
w80.Position = w6(0, 100, 0, 100)
w80.BackgroundColor3 = w5(150, 80, 255)
w80.BorderSizePixel = 0
w80.Visible = false
w80.ZIndex = 10
w80.Active = true
w80.ImageTransparency = 1
w49(w80, 100)
w50(w80, w5(150, 80, 255), w5(130, 60, 235), 45)

local w78 = w9("TextLabel", w80)
w78.Size = w6(1, 0, 1, 0)
w78.BackgroundTransparency = 1
w78.Text = "eSPTS"
w78.Font = w11
w78.TextSize = 13
w78.TextColor3 = w5(255, 255, 255)
w78.TextTransparency = 0

local w81, w82

local function w83()
        if w81 then
                w81:Disconnect()
                w81 = nil
        end
        w82 = false
end

local function w84()
        if w82 then return end
        w82 = true
        if w81 then w81:Disconnect() end
        w81 = w1.RenderStepped:Connect(function(a)
                if w80.Visible then
                        w80.Rotation = (w80.Rotation + (a * 180)) % 360
                else
                        w83()
                end
        end)
end

local wc

do
        local a1, b1, c1 = false, false, false
        local d1, e1, f1

        w33(w80.InputBegan, function(a)
                if a.UserInputType == Enum.UserInputType.MouseButton1 or a.UserInputType == Enum.UserInputType.Touch then
                        b1 = false
                        c1 = false
                        a1 = true
                        e1 = a.Position
                        f1 = w80.Position
                        w84()
                        if d1 then d1:Disconnect() end
                        d1 = w2.InputChanged:Connect(function(b)
                                if (b.UserInputType == Enum.UserInputType.MouseMovement or b.UserInputType == Enum.UserInputType.Touch) and a1 then
                                        local c = b.Position - e1
                                        if math.abs(c.X) > 5 or math.abs(c.Y) > 5 then b1 = true end
                                        w80.Position = w6(0, f1.X.Offset + c.X, 0, f1.Y.Offset + c.Y)
                                end
                        end)
                        a.Changed:Connect(function()
                                if a.UserInputState == Enum.UserInputState.End or a.UserInputState == Enum.UserInputState.Cancel then
                                        a1 = false
                                        if d1 then
                                                d1:Disconnect()
                                                d1 = nil
                                        end
                                        if b1 then
                                                c1 = true
                                                w22.icon = { X = w80.Position.X.Offset, Y = w80.Position.Y.Offset }
                                                wsv()
                                                task.delay(0.05, function() c1 = false end)
                                        end
                                        b1 = false
                                end
                        end)
                end
        end)

        w33(w80.MouseEnter, function()
                if not a1 then
                        w29(w80, w28.m, { Size = w6(0, math.floor(w73() * 1.17), 0, math.floor(w73() * 1.17)) })
                        w84()
                end
        end)
        w33(w80.MouseLeave, function()
                if not a1 then
                        w83()
                        w29(w80, w28.m, { Size = w6(0, w73(), 0, w73()), Rotation = 0 })
                end
        end)

        w33(w80.MouseButton1Click, function()
                if c1 then return end
                wc()
        end)
end

local function w85(a, b, c, d)
        w80.Size = w6(0, 0, 0, 0)
        w80.Position = w6(0, a, 0, b)
        w80.ImageTransparency = 1
        w80.Rotation = -180
        w78.TextTransparency = 1
        w80.Visible = true
        w29(w80, w28.b, { Size = w6(0, w73(), 0, w73()), Position = w6(0, c, 0, d), ImageTransparency = 0, Rotation = 0 })
        task.delay(0.15, function()
                w29(w78, w28.q, { TextTransparency = 0 })
        end)
end

local function w86(a, b, c)
        w79.Visible = true
        w67.Scale = 0
        w79.Size = w6(0, w63, 0, w64)
        w79.Position = w6(0, a, 0, b + 18)
        w79.BackgroundTransparency = 1
        w29(w79, w28.m, { Position = w6(0, a, 0, b), BackgroundTransparency = 0 })
        w29(w67, c, { Scale = w66 })
end

local w87 = {
        { n = "Auto Farm",        i = "\xf0\x9f\x94\xa5",             o = 1 },
        { n = "Auto Weights",     i = "\xf0\x9f\x8f\x8b\xef\xb8\x8f", o = 2 },
        { n = "Auto Respawn",     i = "\xe2\x98\xa0\xef\xb8\x8f",             o = 3 },
        { n = "Position Manager", i = "\xf0\x9f\x8e\xaf",             o = 4, s = 11 },
        { n = "Settings",         i = "\xe2\x9a\x99\xef\xb8\x8f",     o = 5 }
}

local w88, w89 = {}, {}

local function w90(a, b, c, s)
        local d = w9("TextButton", w76)
        d.Name = a .. "Tab"
        d.Size = w6(1, -10, 0, 50)
        d.Position = w6(0.5, 0, 0, 8 + ((c - 1) * 55) + 27)
        d.AnchorPoint = w8(0.5, 0.5)
        d.BackgroundColor3 = w5(32, 24, 45)
        d.BorderSizePixel = 0
        d.Text = ""
        d.AutoButtonColor = false
        w49(d, 8)
        local e = w9("TextLabel", d)
        e.Size = w6(0, 30, 1, 0)
        e.Position = w6(0, 10, 0, 0)
        e.BackgroundTransparency = 1
        e.Text = b
        e.Font = w11
        e.TextSize = 18
        e.TextColor3 = w5(180, 180, 180)
        e.TextXAlignment = w13
        local f = w9("TextLabel", d)
        f.Size = w6(1, -46, 1, 0)
        f.Position = w6(0, 45, 0, 0)
        f.BackgroundTransparency = 1
        f.Text = a
        f.Font = w11
        f.TextSize = s or 13
        f.TextColor3 = w5(180, 180, 180)
        f.TextXAlignment = w13
        w88[a] = { b = d, i = e, l = f }
        w33(d.MouseEnter, function()
                local g = w22.tab == a
                if g then
                        w29(d, w28.q, { Size = w6(1, -4, 0, 54) })
                        w29(e, w28.q, { TextSize = 21 })
                        w29(f, w28.q, { TextSize = (s or 13) + 1 })
                else
                        w29(d, w28.q, { BackgroundColor3 = w5(45, 32, 62), Size = w6(1, -4, 0, 54) })
                        w29(e, w28.q, { TextColor3 = w5(200, 200, 200), TextSize = 21 })
                        w29(f, w28.q, { TextColor3 = w5(200, 200, 200), TextSize = (s or 13) + 1 })
                end
        end)
        w33(d.MouseLeave, function()
                local g = w22.tab == a
                if g then
                        w29(d, w28.q, { BackgroundColor3 = w5(150, 80, 255), Size = w6(1, -10, 0, 50) })
                        w29(e, w28.q, { TextColor3 = w5(255, 255, 255), TextSize = 18 })
                        w29(f, w28.q, { TextColor3 = w5(255, 255, 255), TextSize = s or 13 })
                else
                        w29(d, w28.q, { BackgroundColor3 = w5(32, 24, 45), Size = w6(1, -10, 0, 50) })
                        w29(e, w28.q, { TextColor3 = w5(180, 180, 180), TextSize = 18 })
                        w29(f, w28.q, { TextColor3 = w5(180, 180, 180), TextSize = s or 13 })
                end
        end)
        w33(d.MouseButton1Down, function()
                local g = w22.tab == a
                if g then
                        w29(d, w28.q, { Size = w6(1, -14, 0, 46) })
                else
                        w29(d, w28.q, { BackgroundColor3 = w5(55, 38, 72), Size = w6(1, -14, 0, 46) })
                end
                w29(e, w28.q, { TextSize = 16 })
        end)
        w33(d.MouseButton1Up, function()
                local g = w22.tab == a
                if g then
                        w29(d, w28.q, { BackgroundColor3 = w5(150, 80, 255), Size = w6(1, -4, 0, 54) })
                else
                        w29(d, w28.q, { BackgroundColor3 = w5(45, 32, 62), Size = w6(1, -4, 0, 54) })
                end
                w29(e, w28.q, { TextSize = 21 })
        end)
        return d
end

local function w91(a)
        local b = w9("ScrollingFrame", w77)
        b.Name = a .. "Content"
        b.Size = w6(1, -10, 1, -10)
        b.Position = w6(0, 5, 0, 5)
        b.BackgroundTransparency = 1
        b.BorderSizePixel = 0
        b.ScrollBarThickness = 4
        b.ScrollBarImageColor3 = w5(150, 80, 255)
        b.ScrollBarImageTransparency = 0.5
        b.CanvasSize = w6(0, 0, 0, 0)
        b.Visible = false
        b.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local c = w9("UIListLayout", b)
        c.SortOrder = Enum.SortOrder.LayoutOrder
        c.Padding = w7(0, 10)
        local d = w9("UIPadding", b)
        d.PaddingLeft = w7(0, 5)
        d.PaddingRight = w7(0, 5)
        d.PaddingTop = w7(0, 5)
        d.PaddingBottom = w7(0, 5)
        w89[a] = b
        return b
end

for _, a in ipairs(w87) do
        w90(a.n, a.i, a.o, a.s)
        w91(a.n)
end

local function w92(a)
        for b, c in pairs(w88) do
                w30(c.b)
                w30(c.i)
                w30(c.l)
                local d = b == a
                c.b.BackgroundColor3 = d and w5(150, 80, 255) or w5(32, 24, 45)
                c.b.Size = d and w6(1, -4, 0, 54) or w6(1, -10, 0, 50)
                c.i.TextColor3 = d and w5(255, 255, 255) or w5(180, 180, 180)
                c.i.TextSize = d and 19 or 18
                c.l.TextColor3 = d and w5(255, 255, 255) or w5(180, 180, 180)
        end
end

local function w93(a)
        if not w34("T", 0.15) then return end
        w22.tab = a
        wsq()
        for b, c in pairs(w89) do
                if b == a then
                        c.Visible = true
                        c.Position = w6(0, 15, 0, 0)
                        w29(c, w28.s, { Position = w6(0, 5, 0, 0) })
                else
                        c.Visible = false
                end
        end
        w92(a)
end

for _, a in ipairs(w87) do
        w33(w88[a.n].b.MouseButton1Click, function() w93(a.n) end)
end

local w94 = { area = nil, anchor = nil, thr = 0, rtr = 0, base = nil }

do
        local a = w89["Auto Farm"]
        local b = w51(a, 50, 1)
        local _, c = w59(b, w6(1, -20, 0, 32), w6(0, 10, 0, 9), "No active training")
        c.TextYAlignment = w15
        w94.status = c
        local d = w51(a, 410, 2)
        w53(d, "\xf0\x9f\x94\xa5 Stat Training", 8)
        w52(d, "Select a stat to automatically train at the best available area", 34)
        w60(d, 56)
        local e = {
                FistStrength  = "Fist Strength",
                BodyToughness = "Body Toughness",
                MovementSpeed = "Movement Speed",
                JumpForce     = "Jump Force",
                PsychicPower  = "Psychic Power"
        }
        local f = { "FistStrength", "BodyToughness", "MovementSpeed", "JumpForce", "PsychicPower" }
        local g, h = {}, {}
        local i
        for j, k in ipairs(f) do
                local l, m = w54(d, e[k], 64 + ((j - 1) * 42))
                local n, o = w55(l, w6(0, 56, 0, 28), false)
                g[k] = { f = l, l = m, t = o }
                w58(l, w5(45, 32, 62), w5(38, 28, 52), function() return w22.stat == k end)
                w33(n.MouseButton1Click, function()
                        if not w34("S" .. k, 0.15) then return end
                        local p = not o.on
                        w56(o, p)
                        if p then
                                for q, r in pairs(g) do
                                        if q ~= k then
                                                w56(r.t, false)
                                                w29(r.f, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                                                r.l.TextColor3 = w5(200, 200, 200)
                                                if q == "PsychicPower" then wpm(false) end
                                        end
                                end
                                w22.stat = k
                                if k ~= "BodyToughness" then w22.mode = nil end
                                if k == "PsychicPower" then wpm(true) end
                                w29(l, w28.q, { BackgroundColor3 = w5(55, 30, 75) })
                                m.TextColor3 = w5(255, 255, 255)
                                local s = w43(k)
                                local t = w44(k, s)
                                if not t then
                                        w94.status.Text = e[k] .. " \xe2\x80\x94 No available area"
                                        w94.area = nil
                                        w22.mode = nil
                                        i()
                                        wsq()
                                        w37(e[k] .. " \xe2\x80\x94 No area found", w5(255, 150, 80))
                                        return
                                end
                                local u = w46(k, t)
                                w94.area = u
                                if not u then
                                        w94.status.Text = "Area '" .. t .. "' not found!"
                                        w94.area = nil
                                        w22.mode = nil
                                        i()
                                        wsq()
                                        w37("Area '" .. t .. "' not found", w5(255, 150, 80))
                                        return
                                end
                                local v, x = w47(u)
                                if v then
                                        w94.anchor = x
                                        w94.status.Text = e[k] .. " \xe2\x80\x94 Area: " .. t .. " (req " .. w38[k][t].req .. " --> " .. wab(w38[k][t].req) .. ")" .. wgv(k)
                                        w94.base = w94.status.Text
                                        w37(e[k] .. " \xe2\x80\x94 " .. t, w5(80, 220, 120))
                                else
                                        w94.status.Text = "Teleport failed!"
                                        w37("Teleport failed", w5(255, 80, 80))
                                end
                        else
                                w22.stat = nil
                                w94.area = nil
                                w94.anchor = nil
                                w22.mode = nil
                                if k == "PsychicPower" then wpm(false) end
                                w29(l, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                                m.TextColor3 = w5(200, 200, 200)
                                w94.status.Text = "No active training"
                                w37(e[k] .. " \xe2\x80\x94 Stopped", w5(180, 180, 180))
                        end
                        i()
                        wsq()
                end)
        end
        w60(d, 278)
        w52(d, "Body Toughness Mode", 288)
        local function y(z, aa, ab)
                local ac = w9("Frame", d)
                ac.Size = w6(1, -20, 0, 40)
                ac.Position = w6(0, 10, 0, z)
                ac.BackgroundColor3 = w5(38, 28, 52)
                ac.BorderSizePixel = 0
                w49(ac, 10)
                local ad = w9("TextButton", ac)
                ad.Size = w6(1, 0, 1, 0)
                ad.BackgroundTransparency = 1
                ad.Text = aa
                ad.TextColor3 = ab
                ad.Font = w11
                ad.TextSize = 13
                ad.AutoButtonColor = false
                ad.TextXAlignment = Enum.TextXAlignment.Center
                return ac, ad
        end
        local ae, af = y(312, "BT: Current Area", w5(180, 160, 220))
        h.c = { f = ae, l = af }
        local ag, ah = y(358, "BT: Next Area", w5(160, 160, 220))
        h.n = { f = ag, l = ah }
        w58(ae, w5(50, 35, 68), w5(38, 28, 52), function() return w22.mode == "c" end)
        w58(ag, w5(50, 35, 68), w5(38, 28, 52), function() return w22.mode == "n" end)
        w33(af.MouseButton1Down, function()
                w29(ae, w28.q, { BackgroundColor3 = w22.mode ~= "c" and w5(60, 42, 75) or w5(45, 35, 60) })
        end)
        w33(af.MouseButton1Up, function() i() end)
        w33(ah.MouseButton1Down, function()
                w29(ag, w28.q, { BackgroundColor3 = w22.mode ~= "n" and w5(60, 42, 75) or w5(45, 35, 60) })
        end)
        w33(ah.MouseButton1Up, function() i() end)
        i = function()
                local z = w22.mode == "c"
                local aa = w22.mode == "n"
                w29(h.c.f, w28.q, { BackgroundColor3 = z and w5(55, 30, 75) or w5(38, 28, 52) })
                h.c.l.TextColor3 = z and w5(255, 255, 255) or w5(180, 160, 220)
                w29(h.n.f, w28.q, { BackgroundColor3 = aa and w5(55, 30, 75) or w5(38, 28, 52) })
                h.n.l.TextColor3 = aa and w5(255, 255, 255) or w5(160, 160, 220)
        end
        local function ai(aj)
                local ak = w22.mode ~= aj
                if ak then
                        w22.mode = aj
                        w22.stat = "BodyToughness"
                        for al, am in pairs(g) do
                                if al == "BodyToughness" then
                                        w56(am.t, true)
                                        w29(am.f, w28.q, { BackgroundColor3 = w5(55, 30, 75) })
                                        am.l.TextColor3 = w5(255, 255, 255)
                                else
                                        w56(am.t, false)
                                        w29(am.f, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                                        am.l.TextColor3 = w5(200, 200, 200)
                                        if al == "PsychicPower" then wpm(false) end
                                end
                        end
                        local an = w43("BodyToughness")
                        local ao
                        if aj == "c" then ao = w45("BodyToughness", an) else ao = w44("BodyToughness", an) end
                        if not ao then
                                w94.status.Text = "Body Toughness \xe2\x80\x94 No available area"
                                w94.area = nil
                                w22.mode = nil
                                i()
                                wsq()
                                w37("BT " .. (aj == "n" and "Next" or "Current") .. " \xe2\x80\x94 No area", w5(255, 150, 80))
                                return
                        end
                        local ap = w46("BodyToughness", ao)
                        w94.area = ap
                        if not ap then
                                w94.status.Text = "Area '" .. ao .. "' not found!"
                                w94.area = nil
                                w22.mode = nil
                                i()
                                wsq()
                                w37("Area not found", w5(255, 80, 80))
                                return
                        end
                        local aq, ar = w47(ap)
                        if aq then
                                w94.anchor = ar
                                local as = aj == "n" and "Next" or "Current"
                                w94.status.Text = "Body Toughness (" .. as .. ") \xe2\x80\x94 Area: " .. ao .. " (req " .. w38.BodyToughness[ao].req .. " --> " .. wab(w38.BodyToughness[ao].req) .. ")" .. wgv("BodyToughness")
                                w94.base = w94.status.Text
                                w37("BT " .. as .. " \xe2\x80\x94 " .. ao, w5(80, 220, 120))
                        else
                                w94.status.Text = "Teleport failed!"
                                w37("Teleport failed", w5(255, 80, 80))
                        end
                else
                        w22.mode = nil
                        w22.stat = nil
                        w94.area = nil
                        w94.anchor = nil
                        for at, au in pairs(g) do
                                w56(au.t, false)
                                w29(au.f, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                                au.l.TextColor3 = w5(200, 200, 200)
                        end
                        w94.status.Text = "No active training"
                        w37("BT mode off", w5(180, 180, 180))
                end
                i()
                wsq()
        end
        w33(af.MouseButton1Click, function()
                if w34("BC", 0.15) then ai("c") end
        end)
        w33(ah.MouseButton1Click, function()
                if w34("BN", 0.15) then ai("n") end
        end)
        w94.names = e
        w94.rows = g
        w94.refresh = i
end

local w95, w96, w97, w100

do
        local a = w89["Auto Weights"]
        local b = w51(a, 135, 1)
        w53(b, "\xf0\x9f\x8f\x8b\xef\xb8\x8f Auto Weight", 8)
        w52(b, "Automatically equip the best available weight based on your stats", 32)
        local _, c = w59(b, w6(1, -20, 0, 30), w6(0, 10, 0, 54), "Auto weight system inactive")
        c.TextYAlignment = w15
        local d, e = w54(b, "Auto Weight", 90)
        local f, g = w55(d, w6(0, 52, 0, 26), false)
        w95 = { f = d, l = e, t = g, s = c }
        w96 = function()
                w31("W")
                if not w22.weight then return end
                w19.th.W = task.spawn(function()
                        local a = 0
                        while w22.weight do
                                task.wait(0.1)
                                if w22.weight and w62 and w62.Parent then
                                        wfr(wM)
                                        wfr(wJ)
                                        a = a + 1
                                        w48(a >= 30)
                                        if a >= 30 then a = 0 end
                                end
                        end
                        w19.th.W = nil
                end)
        end
        w97 = function(a)
                if w22.weight then
                        w29(w95.f, w28.q, { BackgroundColor3 = w5(55, 30, 75) })
                        w95.l.TextColor3 = w5(255, 255, 255)
                        w95.s.Text = "Auto Weight active \xe2\x80\x94 farming MS and JF automatically"
                        w48(true)
                        w96()
                        if not a then w37("Auto Weight enabled", w5(80, 220, 120)) end
                else
                        w29(w95.f, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                        w95.l.TextColor3 = w5(200, 200, 200)
                        w95.s.Text = "Auto weight system inactive"
                        w31("W")
                        if not a then w37("Auto Weight disabled", w5(180, 180, 180)) end
                end
        end
        w33(f.MouseButton1Click, function()
                if not w34("AW", 0.15) then return end
                w22.weight = not w22.weight
                w56(g, w22.weight)
                w97()
                wsq()
        end)
        w58(d, w5(45, 32, 62), w5(38, 28, 52), function() return w22.weight end)
end

local function wrm()
        w31("R")
        if not w22.rsp then return end
        local function a()
                local b = game:GetService("Lighting"):FindFirstChild("Blur")
                if b then
                        b.Size = 0
                        b.Enabled = false
                end
                local c = w17:FindFirstChild("IntroGui")
                if c and c:IsA("ScreenGui") then c.Enabled = false end
                if w18 then w18.Enabled = true end
        end
        w19.th.R = task.spawn(function()
                while w22.rsp and w62 and w62.Parent do
                        local c = w22.rtype
                        local d = w17:FindFirstChild("IntroGui")
                        local e = d and d:IsA("ScreenGui") and d.Enabled
                        local f = w16.Character
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
                                        wfr({ "Respawn" })
                                        local k = 0
                                        while k < 5 and w22.rsp and w22.rtype == "Risky" do
                                                k = k + 1
                                                task.wait(0.1)
                                                if d and d.Parent and d.Enabled then d.Enabled = false end
                                                if i then
                                                        if i.Enabled then i.Enabled = false end
                                                        if i.Size > 0 then i.Size = 0 end
                                                end
                                        end
                                else
                                        if not h and w18 and not w18.Enabled then
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
                                        wfr({ "Respawn" })
                                        task.wait(0.5)
                                else
                                        if not h and (e or (i and i.Enabled) or (w18 and not w18.Enabled)) then
                                                a()
                                        end
                                        task.wait(0.4)
                                end
                        end
                end
                w19.th.R = nil
        end)
end

do
        local a = w89["Auto Respawn"]
        local b = w51(a, 316, 1)
        w53(b, "\xe2\x98\xa0\xef\xb8\x8f Auto Respawn", 8)
        w52(b, "Automatically respawn to cut idle time between training cycles", 32)
        local _, c = w59(b, w6(1, -20, 0, 30), w6(0, 10, 0, 54), "Auto respawn inactive")
        c.TextYAlignment = w15
        local d, e = w54(b, "Enable Auto Respawn", 90)
        local f, g = w55(d, w6(0, 52, 0, 26), false)
        w58(d, w5(45, 32, 62), w5(38, 28, 52), function() return w22.rsp end)
        w52(b, "Respawn Mode", 138)
        local h = {
                { n = "Risky",  t = "Instant respawn on death, skips all animations" },
                { n = "Normal", t = "Basic respawn when the intro screen appears" }
        }
        w22.rtype = w22.rtype or "Normal"
        local i, j = w22.rtype, {}
        local k
        for l, m in ipairs(h) do
                local n = w9("Frame", b)
                n.Size = w6(1, -20, 0, 44)
                n.Position = w6(0, 10, 0, 160 + ((l - 1) * 50))
                n.BackgroundColor3 = w5(38, 28, 52)
                n.BorderSizePixel = 0
                w49(n, 10)
                local o = w9("TextButton", n)
                o.Size = w6(1, 0, 1, 0)
                o.BackgroundTransparency = 1
                o.Text = ""
                o.AutoButtonColor = false
                local p = w9("TextLabel", n)
                p.Size = w6(1, -20, 0, 16)
                p.Position = w6(0, 10, 0, 5)
                p.BackgroundTransparency = 1
                p.Text = m.n
                p.Font = w11
                p.TextSize = 14
                p.TextColor3 = w5(180, 160, 220)
                p.TextXAlignment = w13
                local q = w9("TextLabel", n)
                q.Size = w6(1, -20, 0, 13)
                q.Position = w6(0, 10, 0, 24)
                q.BackgroundTransparency = 1
                q.Text = m.t
                q.Font = w10
                q.TextSize = 11
                q.TextColor3 = w5(150, 150, 150)
                q.TextXAlignment = w13
                j[m.n] = { f = n, l = p }
                w33(o.MouseButton1Click, function()
                        if not w34("R" .. m.n, 0.15) then return end
                        i = m.n
                        w22.rtype = m.n
                        k()
                        wrm()
                        if w22.rsp then
                                c.Text = "Auto respawn armed \xe2\x80\x94 mode: " .. m.n
                        end
                        wsq()
                end)
                w58(n, w5(45, 32, 62), w5(38, 28, 52), function() return i == m.n end)
        end
        k = function()
                for l, m in pairs(j) do
                        local n = i == l
                        w29(m.f, w28.q, { BackgroundColor3 = n and w5(55, 30, 75) or w5(38, 28, 52) })
                        m.l.TextColor3 = n and w5(255, 255, 255) or w5(180, 160, 220)
                end
        end
        k()
        w33(f.MouseButton1Click, function()
                if not w34("AR", 0.15) then return end
                w22.rsp = not w22.rsp
                w56(g, w22.rsp)
                c.Text = w22.rsp and "Auto respawn armed \xe2\x80\x94 mode: " .. i or "Auto respawn inactive"
                w37(w22.rsp and "Auto Respawn enabled" or "Auto Respawn disabled", w22.rsp and w5(80, 220, 120) or w5(180, 180, 180))
                wrm()
                wsq()
        end)
        w100 = {}
        w100.apply = function()
                i = w22.rtype
                k()
                w56(g, w22.rsp)
                c.Text = w22.rsp and "Auto respawn armed \xe2\x80\x94 mode: " .. i or "Auto respawn inactive"
                wrm()
        end
end

local w98 = {}

do
        local a = w89["Position Manager"]
        local b = w51(a, 130, 1)
        w53(b, "\xf0\x9f\x93\x8c Position Manager", 8)
        w52(b, "Save and restore your position for automatic respawning and pullback", 32)
        local _, c = w59(b, w6(1, -20, 0, 48), w6(0, 10, 0, 54), "No position saved")
        c.TextYAlignment = w15
        w98.s = c
        local function d(e, f)
                local g = w9("Frame", a)
                g.Size = w6(1, 0, 0, 55)
                g.BackgroundColor3 = w5(38, 28, 52)
                g.BorderSizePixel = 0
                g.LayoutOrder = f
                w49(g, 10)
                local h = w9("TextButton", g)
                h.Size = w6(1, 0, 1, 0)
                h.BackgroundTransparency = 1
                h.Text = e
                h.TextColor3 = w5(200, 200, 200)
                h.Font = w11
                h.TextSize = 14
                h.AutoButtonColor = false
                w57(h,
                        { BackgroundColor3 = w5(38, 28, 52), Size = w6(1, 0, 0, 55) },
                        { BackgroundColor3 = w5(50, 36, 68), Size = w6(1, 0, 0, 58) },
                        { BackgroundColor3 = w5(60, 44, 78), Size = w6(1, 0, 0, 51) }
                )
                return g, h
        end
        local i, j = d("Save Current Position", 2)
        local k, l = d("Clear Saved Position", 3)
        w33(j.MouseButton1Click, function()
                if w16.Character and w16.Character:FindFirstChild("HumanoidRootPart") then
                        w22.save = w16.Character.HumanoidRootPart.CFrame
                        w29(i, w28.q, { BackgroundColor3 = w5(50, 220, 100) })
                        j.TextColor3 = w5(255, 255, 255)
                        w98.s.Text = "Position saved! You will respawn here and be pulled back if you go too far."
                        w37("Position saved", w5(80, 220, 120))
                        task.wait(0.5)
                        w29(i, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                        j.TextColor3 = w5(200, 200, 200)
                        wsq()
                end
        end)
        w33(l.MouseButton1Click, function()
                w22.save = nil
                w29(k, w28.q, { BackgroundColor3 = w5(180, 50, 220) })
                l.TextColor3 = w5(255, 255, 255)
                w98.s.Text = "Position cleared!"
                w37("Position cleared", w5(255, 150, 100))
                task.wait(0.5)
                w29(k, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                l.TextColor3 = w5(200, 200, 200)
                w98.s.Text = "No position saved"
                wsq()
        end)
end

local w99 = {}

do
        local a = w89["Settings"]
        local b = w51(a, 626, 1)
        w53(b, "\xe2\x9a\x99\xef\xb8\x8f UI Configuration", 8)
        w52(b, "Customize interface preferences and keybinds", 34)
        w60(b, 60)
        w52(b, "Toggle Keybind", 70)
        local c = w9("TextButton", b)
        c.Size = w6(1, -20, 0, 40)
        c.Position = w6(0, 10, 0, 90)
        c.BackgroundColor3 = w5(45, 32, 62)
        c.BorderSizePixel = 0
        c.Text = "Current Key: " .. w22.key
        c.TextColor3 = w5(255, 255, 255)
        c.Font = w11
        c.TextSize = 13
        c.AutoButtonColor = false
        w49(c, 8)
        w57(c,
                { BackgroundColor3 = w5(45, 32, 62), Size = w6(1, -20, 0, 40) },
                { BackgroundColor3 = w5(55, 42, 72), Size = w6(1, -15, 0, 44) },
                { BackgroundColor3 = w5(68, 52, 85), Size = w6(1, -25, 0, 36) }
        )
        w99.key = c
        local d = false
        w33(c.MouseButton1Click, function()
                if d then return end
                d = true
                c.Text = "Press any key..."
                w37("Changing keybind...", w5(255, 200, 100))
                c.Active = false
                local e, f
                f = task.delay(5, function()
                        if d then
                                d = false
                                c.Text = "Current Key: " .. w22.key
                                c.Active = true
                                w37("Keybind timeout", w5(255, 100, 100))
                        end
                end)
                e = w33(w2.InputBegan, function(g, h)
                        if h then return end
                        if g.UserInputType == Enum.UserInputType.Keyboard then
                                pcall(task.cancel, f)
                                w22.key = g.KeyCode.Name
                                c.Text = "Current Key: " .. w22.key
                                w37("Keybind \xe2\x80\x94 " .. w22.key, w5(100, 200, 255))
                                wsq()
                                d = false
                                c.Active = true
                                e:Disconnect()
                        end
                end)
        end)
        w60(b, 145)
        local i, j = w54(b, "Auto Hide UI", 157)
        local k, l = w55(i, w6(0, 52, 0, 26), w22.hide)
        local m = w9("TextLabel", b)
        m.Size = w6(1, -20, 0, 20)
        m.Position = w6(0, 10, 0, 206)
        m.BackgroundTransparency = 1
        m.Font = w10
        m.TextSize = 12
        m.TextXAlignment = w13
        m.TextWrapped = true
        w99.hideRow = i
        w99.hideLabel = j
        w99.hideToggle = l
        w99.note = m
        local function n()
                w56(l, w22.hide)
                if w22.hide then
                        m.Text = "Auto Hide enabled \xe2\x80\x94 UI starts hidden on next execution."
                        m.TextColor3 = w5(50, 220, 100)
                        j.TextColor3 = w5(255, 255, 255)
                        w29(i, w28.q, { BackgroundColor3 = w5(55, 30, 75) })
                else
                        m.Text = "Auto Hide disabled \xe2\x80\x94 UI shows normally on start."
                        m.TextColor3 = w5(180, 180, 180)
                        j.TextColor3 = w5(200, 200, 200)
                        w29(i, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                end
        end
        w99.update = n
        n()
        w33(k.MouseButton1Click, function()
                if not w34("AH", 0.15) then return end
                w22.hide = not w22.hide
                w56(l, w22.hide)
                n()
                w37(w22.hide and "Auto Hide enabled" or "Auto Hide disabled", w22.hide and w5(50, 220, 100) or w5(180, 180, 180))
                wsq()
        end)
        w60(b, 238)
        w52(b, "Activity Log", 248)
        local o = w9("TextButton", b)
        o.Size = w6(0, 50, 0, 18)
        o.Position = w6(1, -60, 0, 246)
        o.BackgroundColor3 = w5(70, 45, 95)
        o.BorderSizePixel = 0
        o.Text = "Clear"
        o.Font = w10
        o.TextSize = 11
        o.TextColor3 = w5(200, 180, 220)
        o.AutoButtonColor = false
        w49(o, 5)
        w57(o,
                { BackgroundColor3 = w5(70, 45, 95), Size = w6(0, 50, 0, 18) },
                { BackgroundColor3 = w5(90, 60, 115), Size = w6(0, 54, 0, 20) },
                { BackgroundColor3 = w5(110, 70, 130), Size = w6(0, 46, 0, 16) }
        )
        local _, _, p, q, r = w61(b, w6(1, -20, 0, 200), w6(0, 10, 0, 270))
        p.Text = "No activity yet."
        w36 = q
        for _, s in ipairs(w35) do q(s[1], s[2]) end
        w35 = {}
        w33(o.MouseButton1Click, function() r() end)
        w60(b, 482)
        local s1 = w53(b, "\xe2\x9a\xa0\xef\xb8\x8f Danger Zone", 492)
        s1.TextSize = 14
        s1.TextColor3 = w5(255, 90, 90)
        w52(b, "Fully unloads eSPTS and closes everything it created", 518)
        local u3 = w9("TextButton", b)
        u3.Size = w6(1, -20, 0, 40)
        u3.Position = w6(0, 10, 0, 544)
        u3.BackgroundColor3 = w5(120, 38, 48)
        u3.BorderSizePixel = 0
        u3.Text = "Uninject"
        u3.TextColor3 = w5(255, 255, 255)
        u3.Font = w11
        u3.TextSize = 14
        u3.AutoButtonColor = false
        w49(u3, 8)
        w57(u3,
                { BackgroundColor3 = w5(120, 38, 48), Size = w6(1, -20, 0, 40) },
                { BackgroundColor3 = w5(150, 48, 58), Size = w6(1, -15, 0, 44) },
                { BackgroundColor3 = w5(180, 58, 68), Size = w6(1, -25, 0, 36) }
        )
        local function wun()
                pcall(wsv)
                for _, a in pairs(w19.th) do
                        if typeof(a) == "thread" and coroutine.status(a) ~= "dead" then pcall(task.cancel, a) end
                end
                for _, a in pairs(w19.cn) do pcall(a.Disconnect, a) end
                for _, a in pairs(w19.tw) do pcall(a.Cancel, a) end
                w83()
                w19 = { cn = {}, tw = {}, th = {} }
                w62:Destroy()
        end
        local u1 = false
        local u2
        w33(u3.MouseButton1Click, function()
                if not w34("UN", 0.15) then return end
                if not u1 then
                        u1 = true
                        u3.Text = "Click again to confirm"
                        u2 = task.delay(3, function()
                                u1 = false
                                u3.Text = "Uninject"
                        end)
                        return
                end
                if u2 then pcall(task.cancel, u2) end
                u1 = false
                u3.Text = "Uninjecting..."
                task.delay(0.15, wun)
        end)
end

local wb = { busy = false, last = w8(0, 0), rbusy = false }
local wd

wc = function()
        if wb.busy then return end
        wb.busy = true
        task.spawn(function()
                if w79.Visible then
                        w22.pos = { X = w79.Position.X.Offset, Y = w79.Position.Y.Offset }
                        w29(w67, w28.s, { Scale = 0 })
                        w79.Size = w6(0, w63, 0, w64)
                        w29(w79, w28.i, { Size = w6(0, 0, 0, 0), BackgroundTransparency = 1 })
                        task.wait(0.35)
                        w79.Visible = false
                        w79.BackgroundTransparency = 0
                        local a, b
                        if w22.icon and w22.icon.X and w22.icon.Y then
                                a, b = w22.icon.X, w22.icon.Y
                        else
                                local _, c, d = w71(w68(), w66)
                                a, b = c, d
                        end
                        w85(a + 270, b + 210, a, b)
                else
                        w83()
                        if w80.Visible then
                                w22.icon = { X = w80.Position.X.Offset, Y = w80.Position.Y.Offset }
                        end
                        w29(w80, w28.i, { Size = w6(0, 0, 0, 0), Rotation = 90, ImageTransparency = 1 })
                        w29(w78, w28.q, { TextTransparency = 1 })
                        task.wait(0.35)
                        w80.Visible = false
                        w80.Rotation = 0
                        w80.ImageTransparency = 0
                        w78.TextTransparency = 0
                        local a, b
                        if w22.pos and w22.pos.X and w22.pos.Y then
                                a, b = w22.pos.X, w22.pos.Y
                        else
                                a, b = w70(w68(), w66)
                        end
                        w86(a, b, w28.b)
                end
                wsq()
                wb.busy = false
        end)
end

wd = function()
        if wb.rbusy then return end
        wb.rbusy = true
        task.delay(0.1, function()
                wb.rbusy = false
                local a = w68()
                if math.abs(a.X - wb.last.X) < 2 and math.abs(a.Y - wb.last.Y) < 2 then return end
                wb.last = a
                local b = w69(a)
                w66 = b
                local c, d = w70(a, w66)
                local e, f, g = w71(a, w66)
                if w79.Visible then
                        w22.pos = { X = w79.Position.X.Offset, Y = w79.Position.Y.Offset }
                        w29(w67, w28.s, { Scale = w66 })
                        w79.Size = w6(0, w63, 0, w64)
                        w79.Position = w6(0, c, 0, d)
                        w22.pos = nil
                        w22.icon = nil
                        w80.Size = w6(0, e, 0, e)
                        w80.Position = w6(0, f, 0, g)
                elseif w80.Visible then
                        w22.icon = { X = w80.Position.X.Offset, Y = w80.Position.Y.Offset }
                        w22.pos = nil
                        w22.icon = nil
                        w80.Size = w6(0, e, 0, e)
                        w80.Position = w6(0, f, 0, g)
                else
                        w22.pos = nil
                        w22.icon = nil
                        w79.Size = w6(0, w63, 0, w64)
                        w79.Position = w6(0, c, 0, d)
                        w80.Size = w6(0, e, 0, e)
                        w80.Position = w6(0, f, 0, g)
                end
                wsv()
        end)
end

if workspace.CurrentCamera then
        w33(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), wd)
end
w33(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
        if workspace.CurrentCamera then
                w33(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), wd)
        end
end)

w33(w75.MouseButton1Click, function() wc() end)

w33(w2.InputBegan, function(a, b)
        if b then return end
        if a.KeyCode == Enum.KeyCode[w22.key] and not wb.busy then wc() end
end)

w33(w79.Destroying, function()
        wsv()
        w83()
        for _, a in pairs(w19.th) do
                if typeof(a) == "thread" and coroutine.status(a) ~= "dead" then pcall(task.cancel, a) end
        end
end)

local a0 = wld()
if a0 then
        w99.key.Text = "Current Key: " .. w22.key
        w56(w95.t, w22.weight)
        w97(true)
        w100.apply()
        if w22.stat then
                for a, b in pairs(w94.rows) do
                        if a == w22.stat then
                                w56(b.t, true)
                                w29(b.f, w28.q, { BackgroundColor3 = w5(55, 30, 75) })
                                b.l.TextColor3 = w5(255, 255, 255)
                                local c = w43(a)
                                local d
                                if a == "BodyToughness" and w22.mode == "c" then d = w45(a, c) else d = w44(a, c) end
                                if d then
                                        local e = w46(a, d)
                                        if e then
                                                local f, g = w47(e)
                                                if f then
                                                        w94.area = e
                                                        w94.anchor = g
                                                        if a == "BodyToughness" and w22.mode then
                                                                local h = w22.mode == "n" and "Next" or "Current"
                                                                w94.status.Text = w94.names[a] .. " (" .. h .. ") \xe2\x80\x94 Area: " .. d .. " (req " .. w38[a][d].req .. " --> " .. wab(w38[a][d].req) .. ")" .. wgv(a)
                                                        else
                                                                w94.status.Text = w94.names[a] .. " \xe2\x80\x94 Area: " .. d .. " (req " .. w38[a][d].req .. " --> " .. wab(w38[a][d].req) .. ")" .. wgv(a)
                                                        end
                                                        w94.base = w94.status.Text
                                                end
                                        end
                                end
                        else
                                w56(b.t, false)
                                w29(b.f, w28.q, { BackgroundColor3 = w5(38, 28, 52) })
                                b.l.TextColor3 = w5(200, 200, 200)
                        end
                end
                if w22.stat == "PsychicPower" then wpm(true) end
        else
                w94.status.Text = "No active training"
        end
        w94.refresh()
        if w22.save then w98.s.Text = "Position loaded from config!" end
        if w22.pos and w22.pos.X and w22.pos.Y then w79.Position = w6(0, w22.pos.X, 0, w22.pos.Y) end
        w99.update()
        w93(w22.tab or "Auto Farm")
        w37("Config loaded for " .. w20, w5(100, 200, 255))
else
        w94.refresh()
        w99.update()
        w93("Auto Farm")
        w37("Fresh start \xe2\x80\x94 no saved config", w5(255, 200, 100))
end

w33(w1.Heartbeat, function()
        if not w62 or not w62.Parent then return end
        if w22.save and w16.Character and w16.Character:FindFirstChild("HumanoidRootPart") then
                local a = w16.Character.HumanoidRootPart
                if (a.Position - w22.save.Position).Magnitude > 20 then a.CFrame = w22.save end
        end
        if tick() - w94.rtr >= 0.5 then
                w94.rtr = tick()
                local a = wgr[w22.stat]
                if a and #a.b > 0 and tick() - a.b[#a.b][1] > 10.5 then a.r = 0 end
                if w94.base and w22.stat and w94.status.Text:find(" \xe2\x80\x94 Area: ", 1, true) then
                        w94.status.Text = w94.base .. wgv(w22.stat)
                end
        end
        if not w22.stat then return end
        local b = w16.Character
        if not b then return end
        local c = b:FindFirstChild("HumanoidRootPart")
        if not c then return end
        local d = w43(w22.stat)
        local e
        if w22.mode == "c" and w22.stat == "BodyToughness" then e = w45(w22.stat, d) else e = w44(w22.stat, d) end
        if e and (not w94.area or w94.area.Name ~= e) then
                local f = w46(w22.stat, e)
                if f then
                        local g, h = w47(f)
                        if g then
                                w94.area = f
                                w94.anchor = h
                                if w22.stat == "BodyToughness" and w22.mode then
                                        local i = w22.mode == "n" and "Next" or "Current"
                                        w94.status.Text = w94.names[w22.stat] .. " (" .. i .. ") \xe2\x80\x94 Area: " .. e .. " (req " .. w38[w22.stat][e].req .. " --> " .. wab(w38[w22.stat][e].req) .. ")" .. wgv(w22.stat)
                                else
                                        w94.status.Text = w94.names[w22.stat] .. " \xe2\x80\x94 Area: " .. e .. " (req " .. w38[w22.stat][e].req .. " --> " .. wab(w38[w22.stat][e].req) .. ")" .. wgv(w22.stat)
                                end
                                w94.base = w94.status.Text
                        end
                end
        end
        if w94.anchor and (c.Position - w94.anchor.Position).Magnitude > 15 then c.CFrame = w94.anchor end
        if w22.stat == "FistStrength" then
                wfr(wF)
        elseif w22.stat == "MovementSpeed" then
                if tick() - w94.thr >= 0.1 then
                        w94.thr = tick()
                        wfr(wM)
                end
        elseif w22.stat == "JumpForce" then
                if tick() - w94.thr >= 0.1 then
                        w94.thr = tick()
                        wfr(wJ)
                end
        end
end)

w33(w16.CharacterAdded, function(a)
        if not w62 or not w62.Parent then return end
        task.wait(0.5)
        local b = a:WaitForChild("HumanoidRootPart", 5)
        if w22.save then
                task.wait(0.1)
                if b then b.CFrame = w22.save end
        end
        if w22.weight then
                task.wait(0.15)
                w48(true)
                w96()
        end
        if w22.stat and w94.area then
                local c, d = w47(w94.area)
                if c then w94.anchor = d end
        end
        if w22.stat == "PsychicPower" then wpm(true) end
end)

if w16.Character then
        task.wait(0.5)
        if w22.save and w16.Character:FindFirstChild("HumanoidRootPart") then
                w16.Character.HumanoidRootPart.CFrame = w22.save
        end
end

local a0 = w72()
wb.last = a0
w66 = w69(a0)
if w22.hide then
        local b, c, d = w71(a0, w66)
        w85(c + b / 2, d + b / 2, c, d)
else
        local b, c
        if w22.pos and w22.pos.X and w22.pos.Y then
                b, c = w22.pos.X, w22.pos.Y
        else
                b, c = w70(a0, w66)
        end
        w86(b, c, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
end
