local function cnote(a)
        pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "cLTR Calculators",
                        Content = a,
                        Duration = 8
                })
        end)
        warn("[cLTR] " .. a)
end

xpcall(function()
        if getgenv().cLTR_State then
                local a = getgenv().cLTR_State
                for _, b in pairs(a.th) do
                        if typeof(b) == "thread" and coroutine.status(b) ~= "dead" then pcall(task.cancel, b) end
                end
                if a.lib then
                        pcall(function()
                                a.lib.Window = nil
                                a.lib:Destroy()
                        end)
                        pcall(function()
                                if a.lib.Instance and a.lib.Instance.Parent then a.lib.Instance:Destroy() end
                        end)
                end
        end

        getgenv().cLTR_State = {th = {}, lib = nil}
        local c1 = getgenv().cLTR_State

        local c2 = game:GetService("Players")
        local c3 = game:GetService("HttpService")

        local c4 = c2.LocalPlayer
        local cw = 0
        while not c4 and cw < 20 do
                task.wait(0.5)
                cw = cw + 1
                c4 = c2.LocalPlayer
        end
        if not c4 then
                error("[cLTR] Could not find the LocalPlayer - join a game first, then re-execute", 0)
        end
        local c5 = c4:WaitForChild("PlayerGui", 10)

        local function cstale(a)
                return type(a) == "string" and (a:find("RunChanged", 1, true) ~= nil or a:find("SafeCallback", 1, true) ~= nil)
        end

        local cStaleHit = false

        local function clr(a, b, t)
                local c
                local n
                local u = t or a:match("([^/]+)$")
                for d = 1, 2 do
                        local e, f = pcall(function()
                                return game:HttpGetAsync(a)
                        end)
                        if e and typeof(f) == "string" and #f > 200 and f:find(b, 1, true) then
                                if cstale(f) then
                                        n = n or f
                                else
                                        c = f
                                        break
                                end
                        end
                        task.wait(0.5)
                end
                if not c and readfile then
                        pcall(function()
                                if isfile and isfile("TrainingCalc/cache_" .. u) then
                                        local d = readfile("TrainingCalc/cache_" .. u)
                                        if typeof(d) == "string" and #d > 200 and d:find(b, 1, true) then
                                                if cstale(d) then
                                                        n = n or d
                                                else
                                                        c = d
                                                end
                                        end
                                end
                        end)
                end
                if not c and n then
                        cStaleHit = true
                        error("[cLTR] The Starlight copy served to this executor is outdated and breaks the UI (tonumber base out of range errors) - delete the TrainingCalc cache folder, rejoin the game so the executor drops its cached download, then re-execute", 0)
                end
                if c and writefile then
                        pcall(function()
                                if isfolder and not isfolder("TrainingCalc") then makefolder("TrainingCalc") end
                                writefile("TrainingCalc/cache_" .. u, c)
                        end)
                end
                if not c then
                        error("[cLTR] Failed to download " .. a:match("([^/]+)$") .. " - check your internet connection and re-execute", 0)
                end
                return c
        end

        local function cslp(a)
                local b, c = a:gsub('Parent%.Instance%.Header%.Size = UDim2%.fromOffset%(Parent%.Instance%.Header%.Size%.X%.Offset ([-+]) 26, 20%)', 'if Parent.Instance:FindFirstChild("Header") then Parent.Instance.Header.Size = UDim2.fromOffset(Parent.Instance.Header.Size.X.Offset %1 26, 20) end')
                if c == 0 then
                        warn("[cLTR] Starlight destroy-guard patch did not match the downloaded library source")
                end
                b = b:gsub('label%.FontFace = Font%.fromId%(12187365364, Enum%.FontWeight%.Regular%)', 'label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")')
                local d, e, f
                b, d = b:gsub('Tween%(Tab%.Instances%.Button%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Light }%)', 'Tween(Tab.Instances.Button.Header, { TextColor3 = Tab.Instances.Button.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Light })')
                b, e = b:gsub('Tween%(Tab%.Instances%.Button%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Medium }%)', 'Tween(Tab.Instances.Button.Header, { TextColor3 = Tab.Instances.Button.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Medium })')
                b, f = b:gsub('Tween%(OtherTab%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Medium }%)', 'Tween(OtherTab.Header, { TextColor3 = OtherTab.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Medium })')
                b = b:gsub('OtherTab%.Header%.AccentBrighter%.Enabled = false', 'OtherTab.Header.AccentBrighter.Enabled = OtherTab.Header:GetAttribute("cTabTint") ~= nil')
                if d + e + f == 0 then
                        warn("[cLTR] Starlight tab-color patch did not match the downloaded library source")
                end
                local g1, g2, g3
                b, g1 = b:gsub('function NestedElement:Set%(NewNestedSettings, NewNestedIndex%)%s+NewNestedIndex = NewNestedIndex or NestedIndex%s+for i, v in pairs%(NestedElement%.Values%) do%s+if NewNestedSettings%[i%] == nil then%s+NewNestedSettings%[i%] = v%s+end%s+end%s+NestedSettings = NewNestedSettings%s+NestedIndex = NewNestedIndex%s+NestedElement%.Values = NestedSettings%s+if NestedElement%.Values%.CurrentOption then', 'function NestedElement:Set(NewNestedSettings, NewNestedIndex) local cPrevOpts = NestedElement.Values and NestedElement.Values.Options or nil NewNestedIndex = NewNestedIndex or NestedIndex for i, v in pairs(NestedElement.Values) do if NewNestedSettings[i] == nil then NewNestedSettings[i] = v end end NestedSettings = NewNestedSettings NestedIndex = NewNestedIndex NestedElement.Values = NestedSettings if NestedElement.Values.CurrentOption then')
                b, g2 = b:gsub('Refresh%(%)(%s+)local preoptions = table%.clone%(NestedElement%.Values%.CurrentOption or %{}%)', 'local cReuseOpts = false if typeof(NestedElement.Instances) == "table" and typeof(NestedElement.Instances[2]) == "Instance" and NestedElement.Instances[2]:FindFirstChild("List") ~= nil and NestedElement.Instances[2].List:FindFirstChildOfClass("Frame") ~= nil and (NestedElement.Values.Special == nil or NestedElement.Values.Special == 0) and type(cPrevOpts) == "table" and type(NewNestedSettings.Options) == "table" and #cPrevOpts == #NewNestedSettings.Options then cReuseOpts = true for ci = 1, #cPrevOpts do if cPrevOpts[ci] ~= NewNestedSettings.Options[ci] then cReuseOpts = false break end end end if not cReuseOpts then Refresh() end%1local preoptions = table.clone(NestedElement.Values.CurrentOption or {})')
                b, g3 = b:gsub('themeEvent%.Event:Connect%(function%(%)%s+if optioninstance:GetAttribute%("Active"%) then%s+Activate%(optioninstance%)%s+else%s+Deactivate%(optioninstance%)%s+end%s+end%)', 'local cc cc = themeEvent.Event:Connect(function() if not optioninstance.Parent then cc:Disconnect() return end if optioninstance:GetAttribute("Active") then Activate(optioninstance) else Deactivate(optioninstance) end end) optioninstance.AncestryChanged:Connect(function() if not optioninstance.Parent then cc:Disconnect() end end)')
                if g1 + g2 + g3 < 3 then
                        warn("[cLTR] Starlight memory-leak patch did not match the downloaded library source")
                end
                local g4, g5, g6, g7
                b, g4 = b:gsub('themeEvent%.Event:Connect%(set%)%s+set%(%)', 'local cc cc = themeEvent.Event:Connect(function() if typeof(object) ~= "Instance" or not object.Parent then cc:Disconnect() return end set() end) object.AncestryChanged:Connect(function() if typeof(object) ~= "Instance" or not object.Parent then cc:Disconnect() end end) set()')
                b, g5 = b:gsub('CollectionService:AddTag%(newNotification, "__starlight_ExpiredNotification"%)', 'CollectionService:AddTag(newNotification, "__starlight_ExpiredNotification") task.delay(1.5, function() local cExp = CollectionService:GetTagged("__starlight_ExpiredNotification") for ni = 1, #cExp - 6 do pcall(function() cExp[ni]:Destroy() end) end end)')
                b, g6 = b:gsub('if v%.ClassName == "Frame" and v ~= option then%s+Deactivate%(v%)%s+NestedElement%.Values%.CurrentOption = %{}%s+end', 'if v.ClassName == "Frame" and v ~= option then if v:GetAttribute("Active") == true then Deactivate(v) end NestedElement.Values.CurrentOption = {} end')
                b, g7 = b:gsub('RunService%.RenderStepped:Connect%(function%(dt%)%s+if not IsHovering then%s+return%s+end', 'local cTRS cTRS = RunService.RenderStepped:Connect(function(dt) if not HoverInstance.Parent then cTRS:Disconnect() return end if not IsHovering then return end if Starlight.Minimized or not Starlight.Instance.MainWindow.Visible then IsHovering = false tooltip.Visible = false return end')
                if g4 + g5 + g6 + g7 < 4 then
                        warn("[cLTR] Starlight notification-cleanup patch did not match the downloaded library source")
                end
                local g8, g9, g10
                b, g8 = b:gsub('ConfigMethods%.Load%(object%.idx, object%.data%)', 'if typeof(object) == "table" and typeof(object.data) == "table" then ConfigMethods.Load(object.idx, object.data) end')
                b, g9 = b:gsub('for key, value in pairs%(Data%) do', 'for key, value in pairs(Data or {}) do')
                b, g10 = b:gsub('table%.insert%(data%.objects, ConfigMethods%.Save%(fullidx, object%.Values, object%.Class%)%)', 'if typeof(object.Values) == "table" then table.insert(data.objects, ConfigMethods.Save(fullidx, object.Values, object.Class)) end')
                if g8 + g9 + g10 < 3 then
                        warn("[cLTR] Starlight config-safety patch did not match the downloaded library source")
                end
                local g11, g12, g13, g14, g15
                b, g11 = b:gsub('Element%.Instance%.PART_Backdrop%.PART_Input%.Text = Element%.Values%.CurrentValue%s+Tween%(%s+Element%.Instance%.PART_Backdrop%.PART_Input,%s+{ Size = UDim2%.new%(0, Element%.Instance%.PART_Backdrop%.PART_Input%.TextBounds%.X, 1, 0%) }%s+%)%s+Tween%(%s+Element%.Instance%.PART_Backdrop,%s+{%s+Size = UDim2%.new%(%s+0,%s+Element%.Instance%.PART_Backdrop%.PART_Input%.TextBounds%.X %+ 30,%s+0,%s+Element%.Instance%.PART_Backdrop%.Size%.Y%.Offset%s+%),%s+}%s+%)', 'Element.Instance.PART_Backdrop.PART_Input.Text = Element.Values.CurrentValue local cLTRii = Element.Instance.PART_Backdrop.PART_Input local function cLTRme(a) local b, c = pcall(function() return game:GetService("TextService"):GetTextSize(a, cLTRii.TextSize, Enum.Font.Gotham, Vector2.new(10000, 10000)).X end) if b and c then return c end local d = cLTRii.Text cLTRii.Text = a local e = cLTRii.TextBounds.X cLTRii.Text = d return e end local cLTRiw = cLTRii.Text ~= "" and cLTRme(cLTRii.Text) or 0 if cLTRii.PlaceholderText ~= "" then cLTRiw = math.max(cLTRiw, cLTRme(cLTRii.PlaceholderText)) end if Element.__cLTRiw ~= cLTRiw then Element.__cLTRiw = cLTRiw Tween(cLTRii, { Size = UDim2.new(0, cLTRiw, 1, 0) }) Tween(Element.Instance.PART_Backdrop, { Size = UDim2.new(0, cLTRiw + 30, 0, Element.Instance.PART_Backdrop.Size.Y.Offset) }) end')
                b, g12 = b:gsub('local Acrylic = isStudio and require%(ReplicatedStorage%.AcrylicBundled%)%s+or loadstring%(game:HttpGet%("https://raw%." %.%. website %.%. "/AcrylicModule%.luau"%)%)%(%)%s+Acrylic%.Init%(%)', 'local Acrylic = { Init = function() end, AcrylicPaint = function() local cLTRf = Instance.new("Frame") cLTRf.Name = "cLTRAcrylic" cLTRf.BackgroundTransparency = 1 local cLTRs = Instance.new("ImageLabel") cLTRs.Name = "shadow" cLTRs.BackgroundTransparency = 1 cLTRs.Visible = false cLTRs.Parent = cLTRf return { AddParent = function() end, Frame = cLTRf, Model = { Size = Vector3.new(1, 1, 0.001) } } end }')
                b, g13 = b:gsub('mainWindow%.Sidebar%.Player%.PlayerIcon%.Image =%s+Players:GetUserThumbnailAsync%(Player%.UserId, Enum%.ThumbnailType%.HeadShot, Enum%.ThumbnailSize%.Size48x48%)', 'task.spawn(function() local cLTRok, cLTRimg = pcall(function() return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) if cLTRok and cLTRimg then mainWindow.Sidebar.Player.PlayerIcon.Image = cLTRimg end end)')
                b, g14 = b:gsub('ContentProvider:PreloadAsync%({', 'task.spawn(function() ContentProvider:PreloadAsync({')
                b, g15 = b:gsub('print%(`loaded asset {asset}`%)%s+end%s+end%)', 'print(`loaded asset {asset}`) end end) end)')
                if g11 + g12 + g13 + g14 + g15 < 5 then
                        warn("[cLTR] Starlight boot-perf patch did not match the downloaded library source")
                end
                local g16
                b, g16 = b:gsub('Starlight%.Minimized = true%s+end', 'Starlight.Minimized = true pcall(function() local cTT = Starlight.Instance and Starlight.Instance:FindFirstChild("Tooltips") if cTT then for _, t in ipairs(cTT:GetChildren()) do t.Visible = false end end end) end')
                if g16 < 1 then
                        warn("[cLTR] Starlight tooltip-hide patch did not match the downloaded library source")
                end
                return b
        end

        local c6
        do
                local a, b = pcall(function()
                        return loadstring(cslp(clr("https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/Gen1/Source.lua", "Starlight Interface Suite", "starlight_g1_v3")))()
                end)
                if a and typeof(b) == "table" then c6 = b end
        end
        if not c6 then
                local a, b = pcall(function()
                        return loadstring(cslp(clr("https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/master/Source.lua", "Starlight Interface Suite", "starlight_m_v3")))()
                end)
                if a and typeof(b) == "table" then c6 = b end
        end
        if not c6 then
                if cStaleHit then
                        error("[cLTR] Starlight could not be loaded -- the executor keeps serving an outdated copy - delete the TrainingCalc cache folder, rejoin the game, then re-execute", 0)
                end
                error("[cLTR] Starlight could not be loaded - check your internet connection and re-execute", 0)
        end
        c1.lib = c6
        c6.WindowKeybind = "F2"

        pcall(function()
                local a = c6.Instance
                local b = a and a:FindFirstChild("MainWindow")
                local c = b and b:FindFirstChild("Content")
                local d = c and c:FindFirstChild("ContentMain")
                local e = d and d:FindFirstChild("Elements")
                local f = e and e:FindFirstChild("HomeTab")
                if f then
                        f:Destroy()
                end
        end)

        local c7 = {
                {"K", 1e3}, {"M", 1e6}, {"B", 1e9}, {"T", 1e12},
                {"Qa", 1e15}, {"Qi", 1e18}, {"Sx", 1e21}, {"Sp", 1e24},
                {"Oc", 1e27}, {"No", 1e30}, {"Dc", 1e33}, {"Ud", 1e36},
                {"Dd", 1e39}, {"Td", 1e42}, {"Qad", 1e45}, {"Qid", 1e48},
                {"Sxd", 1e51}, {"Spd", 1e54}, {"Ocd", 1e57}, {"Nod", 1e60},
                {"Vg", 1e63}, {"Uvg", 1e66}, {"Dvg", 1e69}, {"Tvg", 1e72},
                {"Qavg", 1e75}, {"Qivg", 1e78}, {"Sxvg", 1e81}, {"Spvg", 1e84},
                {"Ocvg", 1e87}, {"Novg", 1e90}, {"Tg", 1e93}, {"Utg", 1e96},
                {"Dtg", 1e99}, {"Ttg", 1e102}, {"Qatg", 1e105}, {"Qitg", 1e108},
                {"Sxtg", 1e111}, {"Sptg", 1e114}, {"Octg", 1e117}, {"Notg", 1e120}
        }
        c7.m = {million = 1e6, billion = 1e9, trillion = 1e12}
        for _, a in ipairs(c7) do
                c7.m[a[1]] = a[2]
                c7.m[string.lower(a[1])] = a[2]
        end

        local function c8(a)
                a = tonumber(a)
                if not a then return "0" end
                local b = math.abs(a)
                for c = #c7, 1, -1 do
                        local d = c7[c]
                        if b >= d[2] then
                                return (string.format("%.2f", a / d[2]):gsub("%.?0+$", "")) .. d[1]
                        end
                end
                return tostring(a)
        end

        local function c9(a)
                a = tostring(a):gsub("[,%s]", "")
                a = a:gsub("^[xX]", "")
                local b = tonumber(a)
                if b then return b end
                local c, d = string.match(a, "([%d%.]+)%s*(%a+)")
                if c then return tonumber(c) * (c7.m[string.lower(d)] or 1) end
                return nil
        end

        local function c10(a)
                a = tonumber(a)
                if not a or a ~= a then return "0d 0h 0m" end
                if a == math.huge or a <= -1e18 then return "Never" end
                if a < 0 then a = 0 end
                local b = math.floor(a / 8.64e4)
                if b >= 1e6 then return c8(b) .. " days" end
                local c = math.floor((a % 8.64e4) / 3600)
                local d = math.floor((a % 3600) / 60)
                return string.format("%.0fd %.0fh %.0fm", b, c, d)
        end

        local function c11(a, b)
                return a .. " -- " .. c8(c9(b) or 0)
        end

        local c12 = {
                FS = {
                        {name = "TrainingArea_2", req = "0e0", multi = "x1e1"},
                        {name = "TrainingArea_3", req = "1e6", multi = "x1e2"},
                        {name = "StarFSTraining1", req = "1e9", multi = "x2e3"},
                        {name = "StarFSTraining2", req = "1e11", multi = "x4e4"},
                        {name = "StarFSTraining3", req = "1e13", multi = "x8e5"},
                        {name = "AFK_FS_1", req = "1e15", multi = "x6e6"},
                        {name = "AFK_FS_2", req = "1e17", multi = "x3e8"},
                        {name = "AFK_FS_3", req = "1.5e19", multi = "x2.1e10"},
                        {name = "AFK_FS_4", req = "2.5e21", multi = "x2.308e12"},
                        {name = "AFK_FS_5", req = "1e24", multi = "x3.475e14"},
                        {name = "AFK_FS_6", req = "5e26", multi = "x5.2e16"},
                        {name = "AFK_FS_7", req = "2.5e29", multi = "x7.8e18"},
                        {name = "AFK_FS_8", req = "1.5e32", multi = "?"},
                        {name = "AFK_FS_9", req = "5.5e34", multi = "?"},
                        {name = "AFK_FS_10", req = "3e37", multi = "?"},
                        {name = "AFK_FS_11", req = "1.1e40", multi = "?"}
                },
                BT = {
                        {name = "Water", req = "5e0", min = "5e0", multi = "x5e0"},
                        {name = "FireBathTouchPart", req = "5e2", min = "5e2", multi = "x1e1"},
                        {name = "IcePart", req = "5e3", min = "5e3", multi = "x2e1"},
                        {name = "TornadoTouchPart", req = "5e4", min = "5e4", multi = "x5e1"},
                        {name = "LavaPart", req = "5e5", min = "5e5", multi = "x1e2"},
                        {name = "GreenFirePart", req = "5e7", min = "5e7", multi = "x2e3"},
                        {name = "AcidPart", req = "5e9", min = "5e9", multi = "x4e4"},
                        {name = "LavaPart2", req = "5e11", min = "5e11", multi = "x8e5"},
                        {name = "AFK_BT_1", req = "7.383e12", min = "7.383e12", multi = "x6e6"},
                        {name = "AFK_BT_2", req = "6.55e14", min = "6.55e14", multi = "x1.8e8"},
                        {name = "AFK_BT_3", req = "6.66e16", min = "6.66e16", multi = "x5.5e9"},
                        {name = "AFK_BT_4", req = "5.1e18", min = "5.1e18", multi = "x1.625e11"},
                        {name = "AFK_BT_5", req = "4.6e20", min = "4.6e20", multi = "x5e12"},
                        {name = "AFK_BT_6", req = "4.005e22", min = "4.005e22", multi = "x1.5e14"},
                        {name = "AFK_BT_7", req = "3.55e24", min = "3.55e24", multi = "x4.5e15"},
                        {name = "AFK_BT_8", req = "3.14e26", min = "3.14e26", multi = "x1.312e17"},
                        {name = "AFK_BT_9", req = "2.778e28", min = "2.778e28", multi = "x3.925e18"},
                        {name = "AFK_BT_10", req = "2.473e30", min = "2.473e30", multi = "x1.18e20"},
                        {name = "AFK_BT_11", req = "2.175e32", min = "2.175e32", multi = "x3.55e21"},
                        {name = "AFK_BT_12", req = "1.95e34", min = "1.95e34", multi = "x1.062e23"},
                        {name = "AFK_BT_13", req = "1.7e36", min = "1.7e36", multi = "x3.2e24"},
                        {name = "AFK_BT_14", req = "1.55e38", min = "1.55e38", multi = "x9.574e25"},
                        {name = "AFK_BT_15", req = "1.356e40", min = "1.356e40", multi = "x2.5e27"}
                },
                MS = {
                        {name = "AFK_MS_1", req = "1e14", multi = "x1.3e6"},
                        {name = "AFK_MS_2", req = "2.22e15", multi = "x1.69e7"},
                        {name = "AFK_MS_3", req = "6e16", multi = "x2.197e8"},
                        {name = "AFK_MS_4", req = "1.5e18", multi = "x2.85e9"},
                        {name = "AFK_MS_5", req = "4e19", multi = "x3.72e10"},
                        {name = "AFK_MS_6", req = "1e21", multi = "x4.824e11"},
                        {name = "AFK_MS_7", req = "2.5e22", multi = "x6.274e12"},
                        {name = "AFK_MS_8", req = "7.5e23", multi = "x8.15e13"},
                        {name = "AFK_MS_9", req = "1.55e25", multi = "x2.12e15"},
                        {name = "AFK_MS_10", req = "4e26", multi = "x1.377e16"},
                        {name = "AFK_MS_11", req = "1e28", multi = "x1.792e17"}
                },
                JF = {
                        {name = "AFK_JF_1", req = "1e14", multi = "x1.7e6"},
                        {name = "AFK_JF_2", req = "5e15", multi = "x3.05e7"},
                        {name = "AFK_JF_3", req = "1.5e17", multi = "x5.5e8"},
                        {name = "AFK_JF_4", req = "5e18", multi = "x9.92e9"},
                        {name = "AFK_JF_5", req = "2e20", multi = "?"},
                        {name = "AFK_JF_6", req = "1e22", multi = "?"},
                        {name = "AFK_JF_7", req = "3e23", multi = "?"},
                        {name = "AFK_JF_8", req = "1.5e25", multi = "?"},
                        {name = "AFK_JF_9", req = "4e26", multi = "?"}
                },
                PP = {
                        {name = "PPTrainingPart1", req = "1e6", multi = "x1e2"},
                        {name = "PPTrainingPart2", req = "1e9", multi = "x1e4"},
                        {name = "PPTrainingPart3", req = "1e12", multi = "x1e6"},
                        {name = "PPTrainingPart4", req = "1e15", multi = "x1e8"},
                        {name = "AFK_PP_1", req = "3.33e17", multi = "x2.5e9"},
                        {name = "AFK_PP_2", req = "1.11e20", multi = "x2.5e11"},
                        {name = "AFK_PP_3", req = "3.33e22", multi = "x2.5e13"},
                        {name = "AFK_PP_4", req = "1.11e25", multi = "x2.5e15"},
                        {name = "AFK_PP_5", req = "3.36e27", multi = "x2.5e17"},
                        {name = "AFK_PP_6", req = "1.11e30", multi = "x2.5e19"},
                        {name = "AFK_PP_7", req = "4.44e32", multi = "x2.5e21"},
                        {name = "AFK_PP_8", req = "1.11e35", multi = "?"},
                        {name = "AFK_PP_9", req = "5.55e37", multi = "?"},
                        {name = "AFK_PP_10", req = "2.22e40", multi = "?"}
                }
        }

        local c13 = {"FS", "BT", "MS", "JF", "PP"}

        local c14 = {FS = "1e15", BT = "7.383e12", PP = "3.33e17"}
        local c15 = {}
        for a, b in pairs(c14) do
                for c, d in ipairs(c12[a]) do
                        if d.req == b then
                                c15[a] = c
                                break
                        end
                end
        end

        local function c16(a, b)
                local c = 1
                for d, e in ipairs(c12[a]) do
                        local f = c9(e.req)
                        if f and f <= b then c = d else break end
                end
                return c
        end

        local c17 = {
                {name = "1e2 LB", ms = "1e2", jf = "5e3", mm = "x2", jm = "x2"},
                {name = "1e0 TON", ms = "5e3", jf = "2e5", mm = "x5", jm = "x5"},
                {name = "1e1 TON", ms = "5e5", jf = "2e6", mm = "x10", jm = "x10"},
                {name = "1e2 TON", ms = "1e7", jf = "1e7", mm = "x20", jm = "x20"},
                {name = "1e3 TON", ms = "1e8", jf = "2e8", mm = "x150", jm = "x150"},
                {name = "1e4 TON", ms = "1e9", jf = "1e9", mm = "x750", jm = "x750"},
                {name = "1e5 TON", ms = "1e10", jf = "1e10", mm = "x3.5K", jm = "x3.5K"},
                {name = "1e6 TON", ms = "1e11", jf = "1e11", mm = "x18K", jm = "x18K"},
                {name = "1e7 TON", ms = "1e12", jf = "1e12", mm = "x90K", jm = "x90K"},
                {name = "1e9 TON", ms = "1e13", jf = "1e13", mm = "x400K", jm = "x400K"},
                {name = "1e11 TON", ms = "2.56e28", jf = "1.54e28", mm = "x9.32 Qi", jm = "x1.35 Qi"},
                {name = "1e13 TON", ms = "0e0", jf = "6e26", jm = "x21.9 Qi"},
                {name = "1e15 TON", ms = "1.68e32", jf = "2.221e31", mm = "x1.569 Sx", jm = "x436.9 Qi"},
                {name = "1e17 TON", ms = "4.288e33", jf = "8.48e31", mm = "x20.38 Sx", jm = "x7.869 Sx"},
                {name = "1e19 TON", ms = "1.082e34", jf = "3.226e33", mm = "x264.7 Sx", jm = "x141.9 Sx"},
                {name = "1e21 TON", ms = "2.823e36", jf = "1.229e36", mm = "x3.437 Sp", jm = "x2.552 Sp"},
                {name = "1e23 TON", ms = "7.02e37", jf = "4.683e37", mm = "x44.63 Sp", jm = "x45.89 Sp"},
                {name = "1e25 TON", ms = "1.852e39", jf = "1.785e39", mm = "x579.6 Sp", jm = "x825.3 Sp"},
                {name = "1e28 TON", ms = "4.744e39", jf = "6.8e39", mm = "x7.527 Oc", jm = "x14.84 Oc"}
        }
        local c18 = {MS = true, JF = true}

        local function c19(a)
                local b = string.match(a, "^(%S+)")
                local c = b and c9(b)
                if c then
                        return a .. " - " .. c8(c) .. string.sub(a, #b + 1)
                end
                return a
        end

        local function c20(a, b)
                local c = nil
                for d, e in ipairs(c17) do
                        local f = c9(e.ms)
                        local g = c9(e.jf)
                        local h = f == 0 or (a ~= nil and f ~= nil and f <= a)
                        local i = g == 0 or (b ~= nil and g ~= nil and g <= b)
                        if h and i then
                                c = d
                        end
                end
                return c
        end

        local c21 = {}

        local function c22(a)
                if c21[a] then
                        return c21[a]
                end
                local b = {}
                if c18[a] then
                        local c = c9(a == "MS" and c17[1].ms or c17[1].jf)
                        if c and c > 0 then
                                b[#b + 1] = {nm = "No Weight", mu = "x1", bo = false, th = 0}
                        end
                        for d, e in ipairs(c17) do
                                local f = c9(a == "MS" and e.ms or e.jf)
                                if f and f > 0 then
                                        local g = a == "MS" and e.mm or e.jm
                                        b[#b + 1] = {nm = e.name, dn = c19(e.name), mu = g or "?", bo = false, th = f}
                                end
                        end
                end
                for d, e in ipairs(c12[a]) do
                        b[#b + 1] = {nm = e.name, mu = e.multi, bo = not c15[a] or d >= c15[a], th = c9(a == "BT" and e.min or e.req)}
                end
                table.sort(b, function(c, d) return (c.th or 0) < (d.th or 0) end)
                c21[a] = b
                return b
        end

        local function c23(a, b)
                local c = c22(a)
                local d = nil
                for e = 1, #c do
                        local f = c[e].th
                        if f and f <= b then
                                d = e
                        end
                end
                return d
        end

        local c24 = "TrainingCalc/" .. c4.Name .. ".json"
        local c25 = {
                hide = false, view = 1, cat = nil, alsm = nil,
                md = {}, sp = {}, gn = {}, st = {}, mem = {},
                tok = {cur = {}, oth = {}},
                ml = {cur = {}, oth = {}, ov = {}, tg = nil, tm = nil},
                msg = {Farming = "", Tokens = "", Multipliers = ""}
        }
        for _, a in ipairs(c13) do
                c25.md[a] = false
                c25.sp[a] = false
                c25.gn[a] = false
                c25.st[a] = false
                c25.mem[a] = {cur = {}, oth = {}}
        end
        c25.md.TK = false
        c25.md.ML = false

        local function c26(a)
                local b = c25.mem[a]
                if not b then
                        b = {cur = {}, oth = {}}
                        c25.mem[a] = b
                end
                return b[c25.md[a] and "cur" or "oth"]
        end

        local csv
        local cld

        csv = function()
                if not writefile then return end
                if isfolder and not isfolder("TrainingCalc") then
                        pcall(function() makefolder("TrainingCalc") end)
                end
                pcall(function() writefile(c24, c3:JSONEncode(c25)) end)
        end

        local cqT = nil
        local function cq()
                if cqT then pcall(task.cancel, cqT) end
                cqT = task.delay(1, function()
                        cqT = nil
                        csv()
                end)
        end

        cld = function()
                if not readfile then return end
                local a, b = pcall(function()
                        if isfile and not isfile(c24) then return end
                        return readfile(c24)
                end)
                if not a or not b then return end
                local c, d = pcall(function() return c3:JSONDecode(b) end)
                if not c or type(d) ~= "table" then return end

                local function e(f, g, h)
                        local i = type(g) == "table" and g or {}
                        local j = type(h) == "table" and h or {}
                        local k = i[f]
                        if k == nil then k = j[f] end
                        return k
                end

                local function f(g, h)
                        local i = c25.mem[g]
                        local j = type(h.cur) == "table" and h.cur or nil
                        local k = type(h.oth) == "table" and h.oth or nil
                        i.cur.pw = tostring(e("pw", j, h) or e("power", j, h) or "")
                        i.oth.pw = tostring(e("pw", k, h) or e("power", k, h) or "")
                        i.cur.ob = tostring(e("ob", j, h) or e("pobj", j, h) or "")
                        i.oth.ob = tostring(e("ob", k, h) or e("pobj", k, h) or "")
                        local l = tonumber(e("ar", j, h) or e("area", j, h))
                        local m = tonumber(e("ar", k, h) or e("area", k, h))
                        i.cur.ar = l and math.floor(l) or nil
                        i.oth.ar = m and math.floor(m) or nil
                        local n = e("mu", j, h) or e("mult", j, h)
                        local o = e("mu", k, h) or e("mult", k, h)
                        i.cur.mu = n ~= nil and tostring(n) or nil
                        i.oth.mu = o ~= nil and tostring(o) or nil
                        i.cur.mv = tonumber(e("mv", j, h) or e("val", j, h))
                        i.oth.mv = tonumber(e("mv", k, h) or e("val", k, h))
                        local p = tonumber(e("wt", j, h))
                        local q = tonumber(e("wt", k, h))
                        i.cur.wt = p and math.floor(p) or nil
                        i.oth.wt = q and math.floor(q) or nil
                end

                local function g(h)
                        local i = type(h.cur) == "table" and h.cur or nil
                        local j = type(h.oth) == "table" and h.oth or nil
                        if not i and not j then
                                local k = {tk = h.tk or h.tokens, tp = h.tp or h.tpm}
                                if h.mode == "cur" then i = k else j = k end
                        end
                        local l = {cur = i, oth = j}
                        for m, n in pairs(l) do
                                local o = c25.tok[m]
                                o.tk = tostring(e("tk", n, h) or e("tokens", n, h) or "")
                                o.tp = tostring(e("tp", n, h) or e("tpm", n, h) or "")
                                o.ob = tostring(e("ob", n, h) or e("obj", n, h) or "")
                                o.to = tostring(e("to", n, h) or e("tpo", n, h) or "")
                                o.sp = tostring(e("sp", n, h) or e("spent", n, h) or "")
                        end
                end

                c25.hide = d.hide == true
                if type(d.view) == "number" and d.view >= 1 and d.view <= 5 then
                        c25.view = math.floor(d.view)
                end
                if c12[d.cat] then
                        c25.cat = d.cat
                end
                if typeof(d.alsm) == "string" and d.alsm ~= "" then
                        c25.alsm = d.alsm
                end
                local h = d.speed == true
                local i = d.train == true
                local j = d.stay == true
                for _, k in ipairs(c13) do
                        if type(d.md) == "table" then
                                c25.md[k] = d.md[k] == true
                        end
                        if type(d.sp) == "table" then
                                c25.sp[k] = d.sp[k] == true or (d.sp[k] == nil and h)
                        else
                                c25.sp[k] = h
                        end
                        if type(d.gn) == "table" then
                                c25.gn[k] = d.gn[k] == true or (d.gn[k] == nil and i)
                        else
                                c25.gn[k] = i
                        end
                        if type(d.st) == "table" then
                                c25.st[k] = d.st[k] == true or (d.st[k] == nil and j)
                        else
                                c25.st[k] = j
                        end
                        if type(d.mem) == "table" and type(d.mem[k]) == "table" then
                                f(k, d.mem[k])
                        end
                end
                if type(d.md) == "table" then
                        c25.md.TK = d.md.TK == true
                        c25.md.ML = d.md.ML == true
                end
                if type(d.tok) == "table" then
                        g(d.tok)
                end
                if type(d.ml) == "table" then
                        for _, k in ipairs(c13) do
                                local l = (type(d.ml.cur) == "table" and d.ml.cur[k]) or nil
                                local m = (type(d.ml.oth) == "table" and d.ml.oth[k]) or nil
                                if l ~= nil then c25.ml.cur[k] = tostring(l) end
                                if m ~= nil then c25.ml.oth[k] = tostring(m) end
                        end
                        if type(d.ml.ov) == "table" then
                                for k, l in pairs(d.ml.ov) do
                                        if l == true then c25.ml.ov[k] = true end
                                end
                        end
                        local n = tonumber(d.ml.tg)
                        if n then c25.ml.tg = n end
                        if d.ml.tm ~= nil then c25.ml.tm = tostring(d.ml.tm) end
                end
                if type(d.msg) == "table" then
                        local function cnag(m)
                                m = string.lower(tostring(m))
                                return m:find("couldn", 1, true) ~= nil or m:find("select ", 1, true) ~= nil or m:find("enter a valid", 1, true) ~= nil or m:find("you already", 1, true) ~= nil or m:find("failed", 1, true) ~= nil or m:find("skipped", 1, true) ~= nil or m:find("did not match", 1, true) ~= nil
                        end
                        for k, l in pairs(d.msg) do
                                local m = tostring(l)
                                if k == "Farming" or k == "Tokens" or k == "Multipliers" then
                                        c25.msg[k] = (m ~= "" and not cnag(m)) and m or ""
                                end
                        end
                end
        end

        cld()

        local cWindow = c6:CreateWindow({
                Name = "cLTR Calculators",
                Subtitle = "Starlight",
                LoadingEnabled = false,
                InterfaceAdvertisingPrompts = false,
                NotifyOnCallbackError = true,
                FileSettings = {ConfigFolder = "cLTR_Starlight"}
        })

        pcall(function()
                cWindow.Instance.Visible = false
                c6.Instance.Drag.Visible = false
                if c25.hide then
                        c6.Minimized = true
                end
        end)

        local cStatCol = {
                FS = Color3.fromRGB(255, 82, 82),
                BT = Color3.fromRGB(255, 148, 40),
                MS = Color3.fromRGB(88, 235, 128),
                JF = Color3.fromRGB(255, 224, 92),
                PP = Color3.fromRGB(190, 122, 255)
        }
        local cStatName = {FS = "Fist Strength", BT = "Body Toughness", MS = "Movement Speed", JF = "Jump Force", PP = "Psychic Power"}
        local cStatRGB = {}
        for a, b in pairs(cStatCol) do
                cStatRGB[a] = "rgb(" .. math.floor(b.R * 255 + 0.5) .. "," .. math.floor(b.G * 255 + 0.5) .. "," .. math.floor(b.B * 255 + 0.5) .. ")"
        end
        local cTokCol = Color3.fromRGB(255, 221, 0)
        local cTokRGB = "rgb(255,221,0)"
        local cTokStroke = Color3.fromRGB(255, 140, 0)
        local cWkCol = Color3.fromRGB(255, 198, 88)
        local cWkRGB = "rgb(255,198,88)"
        local cTierRGB = "rgb(255,99,163)"
        local cNumRGB = "rgb(64,255,218)"
        local cExpRGB = "rgb(96,170,255)"
        local cTimeRGB = "rgb(255,214,90)"

        local function cplain(a)
                local b = tostring(a):gsub('<font color="rgb%([%d,]+%)">', "")
                b = b:gsub("</font>", "")
                return b
        end

        local function cStatOf(a)
                if type(a) ~= "string" or a == "" then return nil end
                for _, b in ipairs(c13) do
                        if a:find(cStatName[b], 1, true) then return b end
                end
                for _, b in ipairs(c13) do
                        if a:sub(1, #b + 1) == b .. " " then return b end
                end
                return nil
        end

        local function cWcol(a)
                local b = tostring(a)
                for _, c in ipairs(c13) do
                        b = b:gsub("%f[%w]" .. c .. "%f[%W]", '<font color="' .. cStatRGB[c] .. '">' .. c .. "</font>")
                end
                b = b:gsub("Main Quest (%d+)%+", '<font color="' .. cWkRGB .. '">Main Quest %1+</font>')
                b = b:gsub("%f[%w]LV(%d+)", '<font color="' .. cWkRGB .. '">LV%1</font>')
                b = b:gsub("%f[%w]T(%d+)%f[%W]", '<font color="' .. cTierRGB .. '">T%1</font>')
                b = b:gsub("{Passive}", '<i><font color="rgb(150,153,163)">{Passive}</font></i>')
                return b
        end

        local function cNum(a)
                local b = "\1" .. tostring(a)
                local c = '<font color="' .. cNumRGB .. '">'
                local d = '<font color="' .. cExpRGB .. '">'
                b = b:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", function(e, f)
                        if f:match("^[%d%.]+e[+%-]?%d+$") then
                                return e .. d .. f .. "</font>"
                        end
                        return e .. c .. f .. "</font>"
                end)
                return (b:gsub("\1", ""))
        end

        local function cTcol(a)
                local b = "\1" .. tostring(a)
                local c = '<font color="' .. cTokRGB .. '">'
                local d = '<font color="' .. cTimeRGB .. '">'
                local e = '<font color="rgb(168,175,228)">'
                local f = {}
                local g = {}
                local function h(i)
                        f[#f + 1] = i
                        local j = ""
                        local k = #f
                        while k > 0 do
                                j = string.char(97 + (k - 1) % 26) .. j
                                k = math.floor((k - 1) / 26)
                        end
                        return "\2" .. j .. "\3"
                end
                local function l(i)
                        g[#g + 1] = i
                        local j = ""
                        local k = #g
                        while k > 0 do
                                j = string.char(97 + (k - 1) % 26) .. j
                                k = math.floor((k - 1) / 26)
                        end
                        return "\4" .. j .. "\5"
                end
                b = b:gsub("%f[%d]%d+d %d+h %d+m", h)
                b = b:gsub("%f[%d][%d%.]+%a* days", h)
                b = b:gsub("%f[%d]%d+ min", h)
                b = b:gsub("Never", h)
                b = b:gsub("Token objective", l)
                b = b:gsub("TPM objective", l)
                b = b:gsub("Time spent", l)
                b = b:gsub("Current stats", l)
                b = b:gsub("Remaining:", l)
                b = b:gsub("Estimated time:", l)
                b = b:gsub("TPM on arrival:", l)
                b = b:gsub("TPM to gain:", l)
                b = b:gsub("TPM at end:", l)
                b = b:gsub("Tokens by then:", l)
                b = b:gsub("Tokens gained:", l)
                b = b:gsub("Tokens at end:", l)
                b = b:gsub("Next %+1 TPM in", l)
                b = b:gsub("Tokens:", l)
                b = b:gsub("TPM:", l)
                b = b:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", "%1" .. c .. "%2</font>")
                b = b:gsub("\2(%a+)\3", function(i)
                        local j = 0
                        for k = 1, #i do j = j * 26 + string.byte(i, k) - 96 end
                        return d .. (f[j] or "") .. "</font>"
                end)
                b = b:gsub("\4(%a+)\5", function(i)
                        local j = 0
                        for k = 1, #i do j = j * 26 + string.byte(i, k) - 96 end
                        return e .. (g[j] or "") .. "</font>"
                end)
                return (b:gsub("\1", ""))
        end

        local function cMcol(a)
                local b = {}
                for c in tostring(a):gmatch("[^\n]+") do
                        local e = c
                        for _, d in ipairs(c13) do
                                e = e:gsub("^" .. d .. ":", '<font color="' .. cStatRGB[d] .. '">' .. d .. "</font>:")
                        end
                        b[#b + 1] = e
                end
                local f = table.concat(b, "\n")
                f = f:gsub("x(%d[%d%.]*%a*)", '<font color="' .. cNumRGB .. '">x%1</font>')
                f = f:gsub("%((%d+) (upgrades?)%)", '<font color="' .. cTierRGB .. '">(%1 %2)</font>')
                f = f:gsub("([^%s]+) Tokens", '<font color="' .. cTokRGB .. '">%1 Tokens</font>')
                return f
        end

        local function cFcol(a)
                local b = "\1" .. tostring(a)
                local c = '<font color="' .. cNumRGB .. '">'
                local d = '<font color="' .. cTimeRGB .. '">'
                local e = {}
                local function f(g)
                        e[#e + 1] = g
                        local h = ""
                        local i = #e
                        while i > 0 do
                                h = string.char(97 + (i - 1) % 26) .. h
                                i = math.floor((i - 1) / 26)
                        end
                        return "\2" .. h .. "\3"
                end
                b = b:gsub("%d%d?%d?d %d%d?%d?h %d%d?%d?m", f)
                b = b:gsub("%f[%d][%d%.]+%a* days", f)
                b = b:gsub("Never", f)
                b = b:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", "%1" .. c .. "%2</font>")
                b = b:gsub("\2(%a+)\3", function(g)
                        local h = 0
                        for i = 1, #g do h = h * 26 + string.byte(g, i) - 96 end
                        return d .. (e[h] or "") .. "</font>"
                end)
                b = b:gsub("\1", "")
                local j = {}
                for k in b:gmatch("[^\n]+") do
                        local l, m = k:match("^([%a%s]+):%s*(.+)$")
                        if l and #l > 3 then
                                j[#j + 1] = '<font color="rgb(168,175,228)">' .. l .. ":</font> " .. m
                        else
                                j[#j + 1] = k
                        end
                end
                return table.concat(j, "\n")
        end

        local cTS = cWindow:CreateTabSection("cLTR")
        local cTabs = {
                cTS:CreateTab({Name = "Farming", Columns = 2}, "farming"),
                cTS:CreateTab({Name = "Tokens", Columns = 2}, "tokens"),
                cTS:CreateTab({Name = "Multipliers", Columns = 2}, "multipliers"),
                cTS:CreateTab({Name = "Wiki", Columns = 2}, "wiki"),
                cTS:CreateTab({Name = "Settings", Columns = 2}, "settings")
        }
        local cViewNames = {"Farming", "Tokens", "Multipliers", "Wiki", "Settings"}

        task.defer(function()
                for a, b in ipairs(cTabs) do
                        pcall(function()
                                local c = b.Instances and b.Instances.Button and b.Instances.Button.Interact
                                if c and not c:GetAttribute("cViewT") then
                                        c:SetAttribute("cViewT", a)
                                        c.MouseButton1Click:Connect(function()
                                                c25.view = a
                                                cq()
                                        end)
                                end
                        end)
                end
        end)

        local cUIok = false

        local function cfv(a)
                local b = a and a.Values
                if not b then return nil end
                if b.Options ~= nil or b.CurrentOption ~= nil then
                        local c = b.CurrentOption
                        if type(c) == "table" then return c[1] end
                        return c
                end
                return b.CurrentValue
        end

        local cSyncMem = {}

        local function csdd(a, b, c)
                if not a then return end
                local d = cSyncMem[a]
                local e = c == nil and false or c
                local f = ""
                if type(b) == "table" then
                        for g = 1, #b do f = f .. "\1" .. tostring(b[g]) end
                else
                        f = tostring(b)
                end
                if d and d[2] == e and d[3] == f then return end
                cSyncMem[a] = {b, e, f, os.clock()}
                a:Set({Options = b, CurrentOption = c})
        end

        local function cdguard(a)
                local b = a and cSyncMem[a]
                return b ~= nil and b[4] ~= nil and os.clock() - b[4] < 0.15
        end

        local function csvl(a, b)
                if not a then return end
                local c = tostring(b)
                local d = cSyncMem[a]
                if d and d[2] == "v" and d[1] == c then return end
                cSyncMem[a] = {c, "v"}
                a:Set({CurrentValue = b})
        end

        local function cspa(a, b)
                if not a then return end
                local c = tostring(b)
                local d = cSyncMem[a]
                if d and d[2] == "p" and d[1] == c then return end
                cSyncMem[a] = {c, "p"}
                a:Set({Content = b})
                pcall(function()
                        local e = a.Instance and a.Instance:FindFirstChild("Content")
                        if e then e.RichText = true end
                end)
        end

        local function cfocus(a)
                local b = a and a.Instance
                if not b then return false end
                local c = b:FindFirstChild("PART_Backdrop")
                local d = c and c:FindFirstChild("PART_Input")
                return d ~= nil and d:IsFocused()
        end

        local function cinfit(a)
                local b = a and a.Instance
                if not b then return end
                local c = b:FindFirstChild("PART_Backdrop")
                local d = c and c:FindFirstChild("PART_Input")
                if not d then return end
                pcall(function()
                        local n = game:GetService("TextService")
                        local function w(t)
                                local o, p = pcall(function()
                                        return n:GetTextSize(t, d.TextSize, Enum.Font.Gotham, Vector2.new(10000, 10000)).X
                                end)
                                if o and p then return p end
                                local q = d.Text
                                d.Text = t
                                local r = d.TextBounds.X
                                d.Text = q
                                return r
                        end
                        local e = d.Text
                        local f = e ~= "" and w(e) or 0
                        if d.PlaceholderText ~= "" then
                                f = math.max(f, w(d.PlaceholderText))
                        end
                        local g = f + 30
                        if g < 100 then g = 100 end
                        local h = c.Parent and c.Parent.AbsoluteSize.X or 0
                        local i = b:FindFirstChild("Header")
                        local j = i and math.ceil(i.TextBounds.X) or 0
                        if h > 140 then
                                local k = math.max(100, h - j - 20)
                                if g > k then g = k end
                        end
                        if math.abs(c.Size.X.Offset - g) > 1 then
                                c.Size = UDim2.new(0, g, 0, c.Size.Y.Offset)
                                d.Size = UDim2.new(0, math.max(1, g - 30), 1, 0)
                        end
                end)
        end

        local cLogLines = {}
        local cLogBox = nil
        local cLogTimeRGB = "rgb(212,186,106)"
        local cLogTag = {Info = "rgb(200,205,215)", Farming = "rgb(64,255,218)", Tokens = "rgb(255,140,0)", Multipliers = "rgb(80,218,226)"}
        local function clg(a, b)
                local c = tostring(a)
                local d = "rgb(168,175,228)"
                if b then
                        local e = c:lower()
                        if e:find("couldn", 1, true) or e:find("select ", 1, true) or e:find("enter a valid", 1, true) or e:find("you already", 1, true) or e:find("failed", 1, true) or e:find("skipped", 1, true) or e:find("did not match", 1, true) then
                                d = "rgb(255,106,97)"
                        else
                                d = "rgb(255,214,90)"
                        end
                end
                local f = b or "Info"
                table.insert(cLogLines, 1, '<font color="' .. cLogTimeRGB .. '">[' .. os.date("%H:%M:%S") .. "]</font> " .. '<font color="' .. (cLogTag[f] or cLogTag.Info) .. '">[' .. f .. "]</font> " .. '<font color="' .. d .. '">' .. c .. "</font>")
                if #cLogLines > 10 then table.remove(cLogLines) end
                if cLogBox then cspa(cLogBox, table.concat(cLogLines, "\n")) end
        end

        local cMsgBox = {}
        local function cmsg(a, b)
                if a == "Farming" and b ~= "" then b = cFcol(b) end
                c25.msg[a] = b
                local c = cMsgBox[a]
                if c then cspa(c, b ~= "" and b or "Result appears here.") end
                if b ~= "" and not string.find(b, "\n", 1, true) then
                        clg(cplain(b), a)
                end
                cq()
        end

        local cReadG = {}
        local function cread()
                local a = {}
                if not c5 then return a end
                local b = cReadG[1] and cReadG[1].Parent and cReadG[1] or c5:FindFirstChild("ScreenGui")
                if not (b and b.Parent) then
                        b = cReadG[6]
                        if not (b and b.Parent) then
                                b = c5:FindFirstChild("ScreenGui", true) or c5
                                cReadG[6] = b
                        end
                end
                cReadG[1] = b
                local c = cReadG[2] and cReadG[2].Parent and cReadG[2] or (b and (b:FindFirstChild("MenuFrame") or b:FindFirstChild("MenuFrame", true)))
                cReadG[2] = c
                local d = cReadG[3] and cReadG[3].Parent and cReadG[3] or (c and (c:FindFirstChild("InfoFrame") or c:FindFirstChild("InfoFrame", true)))
                cReadG[3] = d
                local r = d or b
                local e = cReadG[7]
                if not e then
                        e = {}
                        cReadG[7] = e
                end
                if r then
                        for _, f in ipairs(c13) do
                                local g = {}
                                local h = e[f]
                                if h and not h.Parent then h = nil end
                                if not h and e[f] == false and os.clock() - (e[f .. "T"] or 0) > 10 then e[f] = nil end
                                if not h and e[f] ~= false then
                                        h = r:FindFirstChild(f .. "Txt") or r:FindFirstChild(f .. "Txt", true)
                                        if not h and b and r ~= b then
                                                h = b:FindFirstChild(f .. "Txt", true)
                                        end
                                        e[f] = h or false
                                        e[f .. "T"] = os.clock()
                                end
                                if h and h.Text and h.Text ~= "" then
                                        local i = string.match(h.Text, ".*:%s*(.-)%s*$") or string.match(h.Text, "([%d%.]+%a+)%s*$")
                                        if i and c9(i) then g.v = i end
                                end
                                local j = e[f .. "M"]
                                if j and not j.Parent then j = nil end
                                if not j and e[f .. "M"] == false and os.clock() - (e[f .. "MT"] or 0) > 10 then e[f .. "M"] = nil end
                                if not j and e[f .. "M"] ~= false then
                                        j = r:FindFirstChild(f .. "MultiplierTxt") or r:FindFirstChild(f .. "MultiplierTxt", true)
                                        if not j and b and r ~= b then
                                                j = b:FindFirstChild(f .. "MultiplierTxt", true)
                                        end
                                        e[f .. "M"] = j or false
                                        e[f .. "MT"] = os.clock()
                                end
                                if j and j.Text and j.Text ~= "" then
                                        local k = c9(j.Text)
                                        if k then g.m = k end
                                end
                                if g.v or g.m then a[f] = g end
                        end
                end
                return a
        end

        local function ctread()
                local a, b, c = nil, nil, nil
                if not c5 then return a, b, c end
                local d = cReadG[1] and cReadG[1].Parent and cReadG[1] or c5:FindFirstChild("ScreenGui")
                cReadG[1] = d
                if d then
                        local e = cReadG[2] and cReadG[2].Parent and cReadG[2] or d:FindFirstChild("MenuFrame")
                        cReadG[2] = e
                        local f = cReadG[4] and cReadG[4].Parent and cReadG[4] or (e and e:FindFirstChild("SpecialFrame"))
                        cReadG[4] = f
                        if f then
                                local g = f:FindFirstChild("CurrentTokenEarning_Txt")
                                if g and g.Text and g.Text ~= "" then
                                        b = c9(g.Text)
                                end
                                local h = f:FindFirstChild("NextTokenEarningUpgrade_Txt")
                                if h and h.Text and h.Text ~= "" then
                                        local i = string.match(h.Text, "(%d+)%s*[mM]in") or string.match(h.Text, "(%d+)")
                                        if i then
                                                c = math.clamp(tonumber(i), 1, 240)
                                        end
                                end
                        end
                        local j = cReadG[5] and cReadG[5].Parent and cReadG[5] or d:FindFirstChild("CurrentGemImgBtn")
                        cReadG[5] = j
                        local k = j and j:FindFirstChild("AmountTxtBtn")
                        if k and k.Text and k.Text ~= "" then
                                a = c9(k.Text)
                        end
                end
                return a, b, c
        end

        local cF0 = cTabs[1]:CreateGroupbox({Name = "Setup", Column = 1}, "cF0")
        local cF1 = cTabs[1]:CreateGroupbox({Name = "Mode", Column = 1}, "cF1")
        local cF2 = cTabs[1]:CreateGroupbox({Name = "Calculate", Column = 2}, "cF2")

        local cFcat, cFcatlbl, cFarea, cFwgtlbl, cFwgt, cFmul, cFpw, cFob
        local cFcur, cFoth, cFsp, cFgn, cFst
        local cFres
        local cFsync
        local cFlock = false
        local cFareaLbls = {}
        local cFwgtLbls = {}
        local cFmulVals = {}
        local cFlive = {}

        local cFmuls = {}
        for a = 0, 37 do
                local b = 2 ^ a
                local c = c8(b)
                cFmuls[#cFmuls + 1] = c
                cFmulVals[c] = b
        end

        local function cFareas(a)
                local b = {}
                for c, d in ipairs(c12[a]) do
                        b[#b + 1] = c11(d.name, d.req)
                end
                return b
        end

        local function cFwlabels()
                local a = {}
                for _, b in ipairs(c17) do
                        a[#a + 1] = b.name .. " -- " .. c8(c9(b.ms) or 0) .. " MS / " .. c8(c9(b.jf) or 0) .. " JF"
                end
                return a
        end

        local function cFbld(a)
                cFareaLbls = cFareas(a)
                csdd(cFarea, cFareaLbls, nil)
                if c18[a] then
                        cFwgtLbls = cFwlabels()
                        csdd(cFwgt, cFwgtLbls, nil)
                else
                        cFwgtLbls = {}
                        csdd(cFwgt, {"Not used"}, "Not used")
                end
        end

        local function cFapply(a)
                local b = c26(a)
                if not cfocus(cFpw) then csvl(cFpw, b.pw ~= "" and b.pw or "") end
                if not cfocus(cFob) then csvl(cFob, b.ob or "") end
                if b.ar and c12[a][b.ar] then
                        csdd(cFarea, cFareaLbls, cFareaLbls[b.ar])
                else
                        csdd(cFarea, cFareaLbls, nil)
                end
                if c18[a] then
                        if b.wt and c17[b.wt] then
                                csdd(cFwgt, cFwgtLbls, cFwgtLbls[b.wt])
                        else
                                csdd(cFwgt, cFwgtLbls, nil)
                        end
                end
                if b.mu and cFmulVals[b.mu] then
                        csdd(cFmul, cFmuls, b.mu)
                elseif b.mv then
                        local c = c8(b.mv)
                        if cFmulVals[c] then csdd(cFmul, cFmuls, c) end
                end
                cFlock = true
                csvl(cFsp, c25.sp[a])
                csvl(cFgn, c25.gn[a])
                csvl(cFst, c25.st[a])
                csvl(cFcur, c25.md[a])
                csvl(cFoth, not c25.md[a])
                cFlock = false
        end

        local cFchainT, cFchainC = 0, nil
        local function cFchain(a)
                cFchainT = os.clock()
                cFchainC = a
                cFbld(a)
                cFapply(a)
                if c25.md[a] then
                        cFsync(a, false)
                end
        end

        local function cFpaint(a)
                local b = (a and cStatCol[a]) or Color3.fromRGB(235, 236, 242)
                pcall(function()
                        local c = cFcatlbl and cFcatlbl.Instance and cFcatlbl.Instance:FindFirstChild("Header")
                        if c then c.TextColor3 = b end
                end)
                pcall(function()
                        local c = cFpw and cFpw.Instance and cFpw.Instance:FindFirstChild("Header")
                        if c then c.TextColor3 = b end
                end)
                pcall(function()
                        local c = cFob and cFob.Instance and cFob.Instance:FindFirstChild("Header")
                        if c then c.TextColor3 = b end
                end)
                pcall(function()
                        local c = cFpw and cFpw.Instance and cFpw.Instance:FindFirstChild("PART_Backdrop")
                        local d = c and c:FindFirstChild("PART_Input")
                        if d then d.TextColor3 = Color3.fromRGB(64, 255, 218) end
                end)
                pcall(function()
                        local c = cFob and cFob.Instance and cFob.Instance:FindFirstChild("PART_Backdrop")
                        local d = c and c:FindFirstChild("PART_Input")
                        if d then d.TextColor3 = Color3.fromRGB(96, 170, 255) end
                end)
        end

        local function cFwshow(a)
                pcall(function()
                        local b = cFwgtlbl and cFwgtlbl.Instance
                        if b and b.Parent then
                                b.Visible = (a == "MS" or a == "JF")
                        end
                end)
        end

        cFcatlbl = cF0:CreateLabel({Name = "Category"}, "cFcat_l")
        cFcat = cFcatlbl:AddDropdown({
                Options = c13,
                Placeholder = "Select",
                Callback = function(a)
                        if not cUIok then return end
                        a = type(a) == "table" and a[1] or a
                        if not c12[a] then return end
                        c25.cat = a
                        cFpaint(a)
                        cFwshow(a)
                        if a == cFchainC and os.clock() - cFchainT < 1 then
                                cq()
                                return
                        end
                        cFchain(a)
                        cspa(cFres, c25.msg.Farming ~= "" and c25.msg.Farming or "Result appears here.")
                        cq()
                end
        }, "cFcat")

        cFarea = cF0:CreateLabel({Name = "Area"}, "cFare_l"):AddDropdown({
                Options = {"Not selected"},
                Placeholder = "Select",
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        a = type(a) == "table" and a[1] or a
                        if not a and cdguard(cFarea) then return end
                        local c = c26(b)
                        local d = a and table.find(cFareaLbls, a) or nil
                        c.ar = d
                        cq()
                end
        }, "cFare")

        cFwgtlbl = cF0:CreateLabel({Name = "Weight (MS / JF)"}, "cFwgt_l")
        cFwgt = cFwgtlbl:AddDropdown({
                Options = {"Not used"},
                Placeholder = "Select",
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b or not c18[b] then return end
                        a = type(a) == "table" and a[1] or a
                        if not a and cdguard(cFwgt) then return end
                        local c = c26(b)
                        c.wt = a and table.find(cFwgtLbls, a) or nil
                        cq()
                end
        }, "cFwgt")

        cFmul = cF0:CreateLabel({Name = "Multiplier"}, "cFmul_l"):AddDropdown({
                Options = cFmuls,
                Placeholder = "Select",
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        a = type(a) == "table" and a[1] or a
                        if not a and cdguard(cFmul) then return end
                        local c = c26(b)
                        if a then
                                c.mu = a
                                c.mv = cFmulVals[a] or c9(a)
                        else
                                c.mu = nil
                                c.mv = nil
                        end
                        cq()
                end
        }, "cFmul")

        cFpw = cF0:CreateInput({
                Name = "Current Power",
                PlaceholderText = "Current power",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        c26(b).pw = tostring(a)
                        cq()
                end
        }, "cFpw")

        cFob = cF0:CreateInput({
                Name = "Power Objective",
                PlaceholderText = "Power objective",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        c26(b).ob = tostring(a)
                        cq()
                end
        }, "cFob")

        cFcur = cF1:CreateToggle({
                Name = "Use Current Stats",
                Tooltip = "Live-syncs power, area and weight from the game GUI for this category.",
                CurrentValue = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if cFlock then return end
                        if not b then
                                if a then
                                        cFlock = true
                                        csvl(cFcur, false)
                                        cFlock = false
                                        cmsg("Farming", "Select a category first.")
                                end
                                return
                        end
                        c25.md[b] = a
                        cFlock = true
                        csvl(cFoth, not a)
                        cFlock = false
                        if a then
                                cFsync(b, true)
                        else
                                cFapply(b)
                        end
                        cq()
                end
        }, "cFcur")

        cFoth = cF1:CreateToggle({
                Name = "Use Other Stats",
                Tooltip = "Manual mode -- type your stats by hand.",
                CurrentValue = true,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if cFlock then return end
                        if not b then
                                if a then
                                        cFlock = true
                                        csvl(cFoth, false)
                                        cFlock = false
                                        cmsg("Farming", "Select a category first.")
                                end
                                return
                        end
                        c25.md[b] = not a
                        cFlock = true
                        csvl(cFcur, not a)
                        cFlock = false
                        if a then
                                cFapply(b)
                        else
                                cFsync(b, true)
                        end
                        cq()
                end
        }, "cFoth")

        cFsp = cF1:CreateToggle({
                Name = "Speed 2x",
                Tooltip = "Halves the time in boostable areas.",
                CurrentValue = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        c25.sp[b] = a
                        cq()
                end
        }, "cFsp")

        cFgn = cF1:CreateToggle({
                Name = "Training 2x",
                Tooltip = "Doubles the gain in boostable areas.",
                CurrentValue = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        c25.gn[b] = a
                        cq()
                end
        }, "cFgn")

        cFst = cF1:CreateToggle({
                Name = "Stay on this area",
                Tooltip = "Ignores the next area and calculates with the selected one only.",
                CurrentValue = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.cat
                        if not b then return end
                        c25.st[b] = a
                        cq()
                end
        }, "cFst")

        cFsync = function(a, b)
                local c = cread()
                local d = false
                local e = c26(a)
                local f = c[a]
                if f then
                        if f.v then
                                e.pw = f.v
                                if not cfocus(cFpw) and cfv(cFpw) ~= f.v then csvl(cFpw, f.v) end
                        end
                        if f.m then
                                local g = tostring(f.m)
                                e.mu = g
                                e.mv = f.m
                                local h = c8(f.m)
                                if cFmulVals[h] and cfv(cFmul) ~= h then csdd(cFmul, cFmuls, h) end
                        end
                end
                if c25.md[a] and not c25.st[a] then
                        local g = c9(e.pw)
                        if g and g > 0 then
                                if c18[a] and g < c9(c12[a][1].req) then
                                        if not e.ar then
                                                local h, i
                                                if a == "MS" then
                                                        h = g
                                                        i = c.JF and c.JF.v and c9(c.JF.v) or nil
                                                else
                                                        i = g
                                                        h = c.MS and c.MS.v and c9(c.MS.v) or nil
                                                end
                                                if h and i then
                                                        local j = c20(h, i)
                                                        if j and (not e.wt or j > e.wt or not cFlive[a]) then
                                                                e.wt = j
                                                                d = true
                                                        end
                                                end
                                        end
                                else
                                        local k = c16(a, g)
                                        if not e.ar or k > e.ar or not cFlive[a] then
                                                e.ar = k
                                                d = true
                                        end
                                        if e.wt then
                                                e.wt = nil
                                                d = true
                                        end
                                end
                                cFlive[a] = true
                        end
                end
                if not cfocus(cFpw) and cfv(cFpw) ~= (e.pw ~= "" and e.pw or "") then csvl(cFpw, e.pw ~= "" and e.pw or "") end
                if e.ar and c12[a][e.ar] and cfv(cFarea) ~= cFareaLbls[e.ar] then
                        csdd(cFarea, cFareaLbls, cFareaLbls[e.ar])
                end
                if c18[a] then
                        if e.wt and c17[e.wt] then
                                if cfv(cFwgt) ~= cFwgtLbls[e.wt] then csdd(cFwgt, cFwgtLbls, cFwgtLbls[e.wt]) end
                        elseif cfv(cFwgt) and cfv(cFwgt) ~= "Not used" then
                                csdd(cFwgt, cFwgtLbls, nil)
                        end
                end
                if b and not f then
                        cmsg("Farming", "Couldn't read your current stats. Put them manually or use Other Stats.")
                end
                return d
        end

        cFres = cF2:CreateParagraph({Name = "Result", Content = c25.msg.Farming ~= "" and c25.msg.Farming or "Result appears here."}, "cFres")
        cMsgBox.Farming = cFres

        cF2:CreateButton({
                Name = "Calculate",
                Tooltip = "Estimates production and time for the selected setup.",
                Callback = function()
                        local a = c25.cat
                        if not a then
                                cmsg("Farming", "Select a category first.")
                                return
                        end
                        if c25.md[a] then
                                cFsync(a, false)
                        end
                        local cPw = cfv(cFpw)
                        if c25.md[a] and (c26(a).pw or "") ~= "" then
                                cPw = c26(a).pw
                        end
                        local dP = c9(cPw)
                        local cKI = 0
                        if c18[a] and cfv(cFwgt) then
                                local b = table.find(cFwgtLbls, cfv(cFwgt))
                                cKI = b or 0
                        end
                        local cK
                        if c18[a] and (not dP or dP < c9(c12[a][1].req)) then
                                if cKI > 0 and c17[cKI] then
                                        local b = a == "MS" and c17[cKI].mm or c17[cKI].jm
                                        cK = {name = c17[cKI].name, multi = b or "?"}
                                else
                                        cKI = 0
                                        cK = {name = "No Weight", multi = "x1"}
                                end
                        end
                        local c = table.find(cFareaLbls, cfv(cFarea))
                        local d = c and c12[a][c] and c12[a][c].multi or nil
                        if not cK and (not d or not c) then
                                cmsg("Farming", "Select an area.")
                                return
                        end
                        local cFmv = cfv(cFmul)
                        local e = cFmv and cFmulVals[cFmv] or nil
                        if not e then
                                cmsg("Farming", "Select a multiplier.")
                                return
                        end
                        local function cWk(f, g, h)
                                local i = f
                                local j, k, l = 0, {}, false
                                local m = c22(a)
                                local function n(o, p)
                                        local q = c23(a, o) or 1
                                        local r = m[q]
                                        local s = c9(r.mu)
                                        local t = r.bo
                                        if not s then
                                                l = true
                                                k[#k + 1] = c8(o) .. " > " .. c8(p) .. " (" .. (r.dn or r.nm) .. "): ?"
                                                return
                                        end
                                        local u = s * e
                                        if c25.gn[a] and t then u = u * 2 end
                                        local v = (p - o) / u
                                        if c25.sp[a] and t then v = v / 2 end
                                        j = j + v
                                        k[#k + 1] = c8(o) .. " > " .. c8(p) .. " (" .. (r.dn or r.nm) .. "): " .. c10(v)
                                end
                                for o = 1, #m do
                                        local p = m[o]
                                        local q = p.th
                                        if q and q > f and q <= g then
                                                n(f, q)
                                                f = q
                                        end
                                end
                                if g > f then
                                        n(f, g)
                                end
                                cmsg("Farming", h .. c8(i) .. " to " .. c8(g) .. " -- Total: " .. (l and "?" or c10(j)) ..
                                        "\n" .. table.concat(k, "\n") ..
                                        (l and "\n-- ? = unknown multiplier" or ""))
                        end
                        if (cfv(cFob) or "") ~= "" then
                                local b = c9(cfv(cFob))
                                if not b or b <= 0 then
                                        cmsg("Farming", "Power objective: enter a valid value above 0.")
                                        return
                                end
                                local f = c9(cPw)
                                if not f or f <= 0 then
                                        if c then
                                                f = c9(c12[a][c].req) or 0
                                        else
                                                f = 0
                                        end
                                end
                                if b <= f then
                                        cmsg("Farming", "Power objective: you already have more than that! Put another value.")
                                        return
                                end
                                local g = f
                                if c25.st[a] then
                                        local h, i
                                        if cK then
                                                h = c9(cK.multi)
                                                i = c19(cK.name)
                                        else
                                                h = c9(d)
                                                i = c12[a][c].name
                                        end
                                        local j = cK and false or (not c15[a] or c >= c15[a])
                                        local k = h and h * e or nil
                                        if k and c25.gn[a] and j then
                                                k = k * 2
                                        end
                                        local l = k and (b - g) / k or nil
                                        if l and c25.sp[a] and j then
                                                l = l / 2
                                        end
                                        if not l then
                                                cmsg("Farming", "Power objective -- staying in " .. i .. ": ?" ..
                                                        "\n-- ? = unknown " .. (cK and "weight" or "area") .. " multiplier")
                                                return
                                        end
                                        cmsg("Farming", "Power objective -- " .. c8(g) .. " to " .. c8(b) .. " -- Staying in " .. i ..
                                                "\nGain per second: " .. c8(k) ..
                                                "\nGain per minute: " .. c8(k * 60) ..
                                                "\nGain per hour: " .. c8(k * 3600) ..
                                                "\nGain per day: " .. c8(k * 8.64e4) ..
                                                "\nGain per week: " .. c8(k * 6.048e5) ..
                                                "\nGain per month: " .. c8(k * 2.592e6) ..
                                                "\nGain per year: " .. c8(k * 3.1536e7) ..
                                                "\nTotal: " .. c10(l))
                                        return
                                end
                                cWk(g, b, "Power objective -- ")
                                return
                        end
                        local h, i
                        if cK then
                                if c and c12[a][c] then
                                        h = c9(c12[a][c].req)
                                        i = c12[a][c].name
                                end
                        elseif c18[a] and cKI > 0 and c17[cKI] then
                                local j = c9(a == "MS" and c17[cKI].ms or c17[cKI].jf)
                                if j and dP and j > dP then
                                        h = j
                                        i = c19(c17[cKI].name)
                                end
                        end
                        if h and not c25.st[a] then
                                cWk(dP or 0, h, "Path to " .. i .. " -- ")
                                return
                        end
                        local j, k, l
                        if cK then
                                j = c9(cK.multi)
                                k = false
                                if c17[cKI + 1] then
                                        l = c9(a == "MS" and c17[cKI + 1].ms or c17[cKI + 1].jf)
                                else
                                        l = c9(c12[a][1].req)
                                end
                        else
                                j = c9(d)
                                k = not c15[a] or c >= c15[a]
                                if c12[a][c + 1] then
                                        local m = c12[a][c + 1]
                                        l = c9(a == "BT" and m.min or m.req)
                                end
                        end
                        if not j then
                                if cK then
                                        local m = "Unknown weight multiplier."
                                        if l then
                                                m = m .. "\nNext: " .. (c17[cKI + 1] and c19(c17[cKI + 1].name) or c12[a][1].name) .. " at " .. c8(l)
                                        end
                                        cmsg("Farming", m)
                                else
                                        cmsg("Farming", "Unknown area multiplier.")
                                end
                                return
                        end
                        local m = j * e
                        if c25.gn[a] and k then m = m * 2 end
                        local n = l and math.max(0, l - (c9(cPw) or 0)) or 0
                        local o = l and n / m or 0
                        if c25.sp[a] and k then o = o / 2 end
                        local p
                        if c25.st[a] then
                                p = cK and "Staying with this weight -- put a Power Objective to calculate the time." or "Staying in this area -- put a Power Objective to calculate the time."
                        elseif l then
                                p = "Estimated time to next " .. (cK and (c17[cKI + 1] and "weight" or "area") or "area") .. ": " .. c10(o)
                        else
                                p = "Last area selected."
                        end
                        cmsg("Farming", "Production per second: " .. c8(m) ..
                                "\nPer minute: " .. c8(m * 60) ..
                                "\nPer hour: " .. c8(m * 3600) ..
                                "\nPer day: " .. c8(m * 8.64e4) ..
                                "\n" .. p)
                end
        }, "cFcalc")

        local cT0 = cTabs[2]:CreateGroupbox({Name = "Setup", Column = 1}, "cT0")
        local cT1 = cTabs[2]:CreateGroupbox({Name = "Mode", Column = 1}, "cT1")
        local cT2 = cTabs[2]:CreateGroupbox({Name = "Calculate", Column = 2}, "cT2")

        local cTtok, cTtpm, cTtob, cTtto, cTtsp
        local cTcur, cTgoth
        local cTres
        local cTsync
        local cTapply
        local cTlock = false

        cTtok = cT0:CreateInput({
                Name = "Tokens",
                PlaceholderText = "Tokens",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.md.TK and c25.tok.cur or c25.tok.oth
                        b.tk = tostring(a)
                        cq()
                end
        }, "cTtok")

        cTtpm = cT0:CreateInput({
                Name = "TPM",
                PlaceholderText = "TPM",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.md.TK and c25.tok.cur or c25.tok.oth
                        b.tp = tostring(a)
                        cq()
                end
        }, "cTtpm")

        cTtob = cT0:CreateInput({
                Name = "Tokens Objective",
                PlaceholderText = "Tokens objective",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.md.TK and c25.tok.cur or c25.tok.oth
                        b.ob = tostring(a)
                        cq()
                end
        }, "cTtob")

        cTtto = cT0:CreateInput({
                Name = "TPM Objective",
                PlaceholderText = "TPM objective",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.md.TK and c25.tok.cur or c25.tok.oth
                        b.to = tostring(a)
                        cq()
                end
        }, "cTtto")

        cTtsp = cT0:CreateInput({
                Name = "Time Spent",
                PlaceholderText = "e.g. 9d10h22m",
                RemoveTextOnFocus = false,
                Callback = function(a)
                        if not cUIok then return end
                        local b = c25.md.TK and c25.tok.cur or c25.tok.oth
                        b.sp = tostring(a)
                        cq()
                end
        }, "cTtsp")

        cT0:CreateParagraph({Name = "Passive growth", Content = "+1 TPM every 4H -- +6 TPM per day. Those numbers are based if you 24/7."}, "cTtinfo")

        cTcur = cT1:CreateToggle({
                Name = "Use Current Stats",
                Tooltip = "Live-syncs tokens and TPM from the game GUI.",
                CurrentValue = false,
                Callback = function(a)
                        if not cUIok then return end
                        if cTlock then return end
                        c25.md.TK = a
                        cTlock = true
                        csvl(cTgoth, not a)
                        cTlock = false
                        if a then
                                cTsync(true)
                        else
                                cTapply()
                        end
                        cq()
                end
        }, "cTcur")

        cTgoth = cT1:CreateToggle({
                Name = "Use Other Stats",
                Tooltip = "Manual mode -- type your tokens and TPM by hand.",
                CurrentValue = true,
                Callback = function(a)
                        if not cUIok then return end
                        if cTlock then return end
                        c25.md.TK = not a
                        cTlock = true
                        csvl(cTcur, not a)
                        cTlock = false
                        if a then
                                cTapply()
                        else
                                cTsync(true)
                        end
                        cq()
                end
        }, "cTgoth")

        cTres = cT2:CreateParagraph({Name = "Result", Content = c25.msg.Tokens ~= "" and c25.msg.Tokens or "Result appears here."}, "cTres")
        cMsgBox.Tokens = cTres

        local function cTaccum(a, b, c)
                local d = math.floor(c / 240)
                local e = c - d * 240
                return a + b * c + 240 * d * (d - 1) / 2 + e * d
        end

        local function cTdur(a)
                a = tostring(a):lower():gsub("%s", "")
                if a == "" then return nil end
                local b, c = 0, nil
                for d, e in a:gmatch("([%d%.]+)([wdhms])") do
                        local f = tonumber(d)
                        if f then
                                c = true
                                b = b + f * (e == "w" and 1.008e4 or e == "d" and 1440 or e == "h" and 60 or e == "m" and 1 or 1 / 60)
                        end
                end
                if c then return b end
                return tonumber(a)
        end

        local function cTafter(a, b, c, d)
                if c <= d then return a + b * c end
                return a + b * d + cTaccum(0, b + 1, c - d)
        end

        local function cTsearch(a, b, c)
                local d = c - a
                if d <= 0 then return 0 end
                if b <= 0 then return nil end
                local e = 240 * (-b + math.sqrt(b * b + d / 120))
                local f = math.max(1, math.ceil(e))
                while cTaccum(a, b, f) < c do f = f * 2 end
                local g = 0
                while g < f do
                        local h = math.floor((g + f) / 2)
                        if cTaccum(a, b, h) < c then g = h + 1 else f = h end
                end
                return g
        end

        cTsync = function(a)
                local b, c = ctread()
                local d = false
                if b then
                        local e = tostring(b)
                        if c25.tok.cur.tk ~= e then
                                c25.tok.cur.tk = e
                                d = true
                        end
                        if not cfocus(cTtok) and cfv(cTtok) ~= e then csvl(cTtok, e) end
                end
                if c then
                        local e = tostring(c)
                        if c25.tok.cur.tp ~= e then
                                c25.tok.cur.tp = e
                                d = true
                        end
                        if not cfocus(cTtpm) and cfv(cTtpm) ~= e then csvl(cTtpm, e) end
                end
                if a and not b and not c then
                        cmsg("Tokens", "Couldn't read your current stats. Put them manually or use Other Stats.")
                end
                return d
        end

        cTapply = function()
                local a = c25.md.TK and c25.tok.cur or c25.tok.oth
                cTlock = true
                csvl(cTcur, c25.md.TK)
                csvl(cTgoth, not c25.md.TK)
                cTlock = false
                if not cfocus(cTtok) then csvl(cTtok, a.tk or "") end
                if not cfocus(cTtpm) then csvl(cTtpm, a.tp or "") end
                if not cfocus(cTtob) then csvl(cTtob, a.ob or "") end
                if not cfocus(cTtto) then csvl(cTtto, a.to or "") end
                if not cfocus(cTtsp) then csvl(cTtsp, a.sp or "") end
        end

        cT2:CreateButton({
                Name = "Calculate",
                Tooltip = "Token objective, TPM objective and time spent in one run.",
                Callback = function()
                        local a = c9(cfv(cTtok))
                        local b = c9(cfv(cTtpm))
                        local c = c9(cfv(cTtob))
                        local d = c9(cfv(cTtto))
                        local e, f, p = nil, nil, nil
                        local g = 240
                        if c25.md.TK then
                                local h, i, j = ctread()
                                if i then
                                        b = i
                                        csvl(cTtpm, tostring(i))
                                        c25.tok.cur.tp = tostring(i)
                                end
                                if h then
                                        a = h
                                        csvl(cTtok, tostring(h))
                                        c25.tok.cur.tk = tostring(h)
                                end
                                if j then
                                        g = j
                                end
                                if h or i then
                                        cq()
                                end
                                if not i then
                                        cmsg("Tokens", "Current stats: couldn't read your TPM. Put it manually or use Other Stats.")
                                        return
                                end
                        end
                        if c then
                                if not a then
                                        e = "Token objective: enter valid tokens."
                                elseif not b or b <= 0 then
                                        e = "Token objective: enter a TPM above 0."
                                elseif c <= a then
                                        e = "Token objective: you already have more than that! Put another value."
                                else
                                        local k
                                        if c - a <= b * g then
                                                k = math.ceil((c - a) / b)
                                        else
                                                k = g + cTsearch(a + b * g, b + 1, c)
                                        end
                                        local l = k > g and math.floor((k - g - 1) / 240) + 1 or 0
                                        e = "Token objective -- Remaining: " .. c8(c - a) ..
                                                "\nEstimated time: " .. c10(k * 60) ..
                                                "\nTPM on arrival: " .. c8(b + l)
                                end
                        end
                        if d then
                                if not b then
                                        f = "TPM objective: enter a valid TPM."
                                elseif d <= b then
                                        f = "TPM objective: you already have more than that! Put another value."
                                else
                                        local k = g + (d - b - 1) * 240
                                        f = "TPM objective -- TPM to gain: " .. c8(d - b) ..
                                                "\nEstimated time: " .. c10(k * 60)
                                        if a then
                                                f = f .. "\nTokens by then: " .. c8(cTafter(a, b, k, g))
                                        else
                                                f = f .. "\nTokens gained: " .. c8(cTafter(0, b, k, g))
                                        end
                                end
                        end
                        local l = cTdur(cfv(cTtsp))
                        if l then
                                if not b or b <= 0 then
                                        p = "Time spent: enter a TPM above 0."
                                elseif l <= 0 then
                                        p = "Time spent: enter a valid duration above 0."
                                else
                                        local m, n
                                        if l <= g then
                                                m = b * l
                                                n = 0
                                        else
                                                m = b * g + cTaccum(0, b + 1, l - g)
                                                n = 1 + math.floor((l - g) / 240)
                                        end
                                        p = "Time spent -- " .. c10(l * 60) ..
                                                "\nTokens gained: " .. c8(m) ..
                                                (a and "\nTokens at end: " .. c8(a + m) or "") ..
                                                "\nTPM at end: " .. c8(b + n)
                                end
                        end
                        local m = ""
                        if c25.md.TK then
                                m = "Current stats -- Tokens: " .. (a and c8(a) or "?") .. " -- TPM: " .. (b and c8(b) or "?") ..
                                        " -- Next +1 TPM in " .. g .. " min\n\n"
                        end
                        local n = {}
                        if e then n[#n + 1] = e end
                        if f then n[#n + 1] = f end
                        if p then n[#n + 1] = p end
                        cmsg("Tokens", cTcol(m .. (n[1] and table.concat(n, "\n-- --\n") or "Fill TPM and at least one objective or a time spent to calculate.")))
                end
        }, "cTcalc")

        local cM0 = cTabs[3]:CreateGroupbox({Name = "Setup", Column = 1}, "cM0")
        local cM1 = cTabs[3]:CreateGroupbox({Name = "Mode", Column = 1}, "cM1")
        local cM2 = cTabs[3]:CreateGroupbox({Name = "Calculate", Column = 2}, "cM2")

        local cMcost = {
                {2, 100}, {4, 200}, {8, 500},
                {16, 1000}, {32, 2000}, {64, 5000},
                {128, 1e4}, {256, 1.5e4}, {512, 2e4},
                {1024, 5e4}, {2048, 1e5}, {4096, 2e5},
                {8192, 5e5}, {1.6384e4, 1e6}, {3.2768e4, 2e6},
                {6.5536e4, 5e6}, {1.31072e5, 1e7}, {2.62144e5, 2e7},
                {5.24288e5, 5e7}, {1.048576e6, 1e8}, {2.097152e6, 2e8},
                {4.194304e6, 5e8}, {8.388608e6, 1e9}, {1.6777216e7, 2e9},
                {3.3554432e7, 5e9}, {6.7108864e7, 1e10}, {1.34217728e8, 2e10},
                {2.68435456e8, 5e10}, {5.36870912e8, 1e11}, {1.073741824e9, 2e11}
        }

        local function cMsnap(a)
                if not a or a <= 0 then return nil end
                local b = math.clamp(math.floor(math.log(a) / math.log(2) + 0.5), 1, #cMcost)
                return cMcost[b][1]
        end

        local function cMval(a)
                if not a or a == "" then return nil end
                local b = c9(a)
                return b and cMsnap(b) or nil
        end

        for _, a in ipairs(c13) do
                for _, b in ipairs({c25.ml.cur, c25.ml.oth}) do
                        local c = cMval(b[a])
                        b[a] = c and tostring(c) or nil
                end
        end

        local cMcur, cMgoth
        local cMels = {}
        local cMlock = false
        local cMsync
        local cMapply

        local cMvals = {}
        local cMlist = {}
        for _, a in ipairs(cMcost) do
                local b = "x" .. c8(a[1])
                cMlist[#cMlist + 1] = b
                cMvals[b] = a[1]
        end

        local cMobj, cMres
        local cMobjVals = {}
        local cMobjList = {}
        for _, a in ipairs(cMcost) do
                local b = "x" .. c8(a[1]) .. " -- " .. c8(a[2])
                cMobjList[#cMobjList + 1] = b
                cMobjVals[b] = a[1]
        end

        cMsync = function(a)
                local b = cread()
                local c, d = false, false
                for _, e in ipairs(c13) do
                        local f = b[e]
                        if f and f.m then
                                c = true
                                if not c25.ml.ov[e] then
                                        local g = cMsnap(f.m)
                                        if g and c25.ml.cur[e] ~= tostring(g) then
                                                c25.ml.cur[e] = tostring(g)
                                                d = true
                                        end
                                end
                        end
                end
                for _, e in ipairs(c13) do
                        local f = cMval(c25.ml.cur[e])
                        local g = cMels[e]
                        if g and f and cfv(g) ~= ("x" .. c8(f)) then
                                csdd(g, cMlist, "x" .. c8(f))
                        end
                end
                if a then
                        if c then
                                if c25.msg.Multipliers ~= "" and c25.msg.Multipliers:find("Couldn't read", 1, true) then
                                        cmsg("Multipliers", "")
                                end
                        else
                                cmsg("Multipliers", "Couldn't read your multipliers. Select them from the dropdowns.")
                        end
                end
                return d
        end

        cMapply = function()
                cMlock = true
                csvl(cMcur, c25.md.ML)
                csvl(cMgoth, not c25.md.ML)
                cMlock = false
                local a = c25.md.ML and c25.ml.cur or c25.ml.oth
                for _, b in ipairs(c13) do
                        local c = cMval(a[b])
                        if c then
                                csdd(cMels[b], cMlist, "x" .. c8(c))
                        else
                                csdd(cMels[b], cMlist, nil)
                        end
                end
                if c25.ml.tg and c25.ml.tm and cMobjVals[c25.ml.tm] then
                        csdd(cMobj, cMobjList, c25.ml.tm)
                end
        end

        for _, a in ipairs(c13) do
                cMels[a] = cM0:CreateLabel({Name = a .. " Multiplier"}, "cM" .. a .. "_l"):AddDropdown({
                        Options = cMlist,
                        Placeholder = "Select",
                        Callback = function(b)
                                if not cUIok then return end
                                b = type(b) == "table" and b[1] or b
                                if not b and cdguard(cMels[a]) then return end
                                local c = b and cMvals[b] or nil
                                local d = c25.md.ML and c25.ml.cur or c25.ml.oth
                                if c then
                                        d[a] = tostring(c)
                                        if c25.md.ML then c25.ml.ov[a] = true end
                                else
                                        d[a] = nil
                                        if c25.md.ML then c25.ml.ov[a] = nil end
                                end
                                cq()
                        end
                }, "cM" .. a)
        end

        cMobj = cM0:CreateLabel({Name = "Objective"}, "cMobj_l"):AddDropdown({
                Options = cMobjList,
                Placeholder = "Select",
                Callback = function(a)
                        if not cUIok then return end
                        a = type(a) == "table" and a[1] or a
                        if not a and cdguard(cMobj) then return end
                        if a and cMobjVals[a] then
                                c25.ml.tg = cMobjVals[a]
                                c25.ml.tm = a
                        else
                                c25.ml.tg = nil
                                c25.ml.tm = nil
                        end
                        cq()
                end
        }, "cMobj")

        cMcur = cM1:CreateToggle({
                Name = "Use Current Stats",
                Tooltip = "Live-syncs your multipliers from the game GUI. Manual picks override the sync.",
                CurrentValue = false,
                Callback = function(a)
                        if not cUIok then return end
                        if cMlock then return end
                        c25.md.ML = a
                        cMlock = true
                        csvl(cMgoth, not a)
                        cMlock = false
                        if a then
                                cMsync(true)
                        else
                                cMapply()
                        end
                        cq()
                end
        }, "cMcur")

        cMgoth = cM1:CreateToggle({
                Name = "Use Other Stats",
                Tooltip = "Manual mode -- pick your multipliers by hand.",
                CurrentValue = true,
                Callback = function(a)
                        if not cUIok then return end
                        if cMlock then return end
                        c25.md.ML = not a
                        cMlock = true
                        csvl(cMcur, not a)
                        cMlock = false
                        if a then
                                cMapply()
                        else
                                cMsync(true)
                        end
                        cq()
                end
        }, "cMgoth")

        cMres = cM2:CreateParagraph({Name = "Result", Content = c25.msg.Multipliers ~= "" and c25.msg.Multipliers or "Result appears here."}, "cMres")
        cMsgBox.Multipliers = cMres

        cM2:CreateButton({
                Name = "Calculate",
                Tooltip = "Sums the token cost of every upgrade up to the objective.",
                Callback = function()
                        if c25.md.ML then
                                cMsync(false)
                        end
                        local a = c25.ml.tg
                        if not a then
                                cmsg("Multipliers", "Select an objective multiplier.")
                                return
                        end
                        local b, c, d = {}, 0, 0
                        for _, e in ipairs(c13) do
                                local f = (c25.md.ML and c25.ml.cur or c25.ml.oth)[e]
                                local g = cMval(f)
                                if not g then
                                        b[#b + 1] = e .. ": no multiplier"
                                else
                                        d = d + 1
                                        local h, i = 0, 0
                                        for _, j in ipairs(cMcost) do
                                                if j[1] > g and j[1] <= a then
                                                        h = h + j[2]
                                                        i = i + 1
                                                end
                                        end
                                        if i == 0 then
                                                b[#b + 1] = e .. ": already x" .. c8(g) .. " or higher"
                                        else
                                                b[#b + 1] = e .. ": " .. c8(h) .. " Tokens (" .. i .. (i > 1 and " upgrades)" or " upgrade)")
                                                c = c + h
                                        end
                                end
                        end
                        if d == 0 then
                                cmsg("Multipliers", "Multipliers -- select your multipliers or use Current Stats.")
                                return
                        end
                        cmsg("Multipliers", cMcol("Multipliers -- objective x" .. c8(a) .. "\n" .. table.concat(b, "\n") ..
                                (c > 0 and "\nTotal: " .. c8(c) .. " Tokens" or "\nNothing to buy for this objective.")))
                end
        }, "cMcalc")

        local function cUj(a)
                local b = c8(a)
                local c, d = string.match(string.format("%.14e", a), "([%d%.]+)e%+?(-?%d+)")
                c = c:gsub("%.?0+$", "")
                return b .. " (" .. c .. "e" .. d .. ")"
        end

        local cU = {
                FS = {"Fist Strength", {
                        {"Whan Skill 2", "Soul Devourer", 4, {2e15, 2e16, 2e17, 2e18, 2e19, 2e20}},
                        {"Joe Skill 3", "Crystal Burst", 5, {9e17, 9e18, 9e19, 9e20, 9e21, 9e22}},
                        {"Nan Skill 1", "Annihilation Beam", 5, {6e19, 6e20, 6e21, 6e22, 6e23, 6e24}},
                        {"Nu Skill 5", "Inferno Spikes", 6, {8e22, 8e23, 8e24, 8e25, 8e26, 8e27}},
                        {"Gob Skill 2", "Spiral Nova", 6, {5e25, 5e26, 5e27, 5e28, 5e29, 5e30}},
                        {"Nu Skill 1", "Fury Fist", 7, {4e28, 4e29, 4e30, 4e31, 4e32, 4e33}},
                        {"Oum Skill 4", "Rage Smash", 7, {7e31, 7e32, 7e33, 7e34, 7e35, 7e36}},
                        {"Gob Skill 8", "Chaos Barrage", 8, {3e34, 3e35, 3e36, 3e37, 3e38, 3e39}},
                        {"Moo Skill 5", "Radiant Burst", 8, {1e37, 1e38, 1e39, 1e40, 1e41, 1e42}},
                        {"Gob Skill 6", "Blazequake", 9, {2e40, 2e42, 2e44, 2e46, 2e48, 2e50}}
                }},
                BT = {"Body Toughness", {
                        {"Ton Skill 2", "Asteroid Strike", 5, {1e18, 1e19, 1e20, 1e21, 1e22, 1e23}},
                        {"Nit Skill 3", "Nether Blast", 6, {8e24, 8e25, 8e26, 8e27, 8e28, 8e29}},
                        {"Moo Skill 2", "Meteor Smash", 7, {2e30, 2e31, 2e32, 2e33, 2e34, 2e35}},
                        {"Oum Skill 3", "Soul Explosion", 8, {4e35, 4e36, 4e37, 4e38, 4e39, 4e40}},
                        {"Gob Skill 1", "Aura Eruption", 9, {6e40, 6e42, 6e44, 6e46, 6e48, 6e50}}
                }},
                MS = {"Movement Speed", {
                        {"Ton Skill 1", "Mystic Tornado", 5, {9e14, 9e15, 9e16, 9e17, 9e18, 9e19}},
                        {"Nit Skill 2", "Whirling Havoc", 6, {8e20, 8e21, 8e22, 8e23, 8e24, 8e25}},
                        {"Oum Skill 1", "Arcane Blast", 7, {7e26, 7e27, 7e28, 7e29, 7e30, 7e31}},
                        {"Nu Skill 3", "Cyclone Surge", 8, {6e33, 6e34, 6e35, 6e36, 6e37, 6e38}},
                        {"Gob Skill 5", "Skyfall Strike", 9, {5e40, 5e42, 5e44, 5e46, 5e48, 5e50}}
                }},
                JF = {"Jump Force", {
                        {"Nan Skill 2", "Death Wrath", 4, {2e16, 2e17, 2e18, 2e19, 2e20, 2e21}},
                        {"Moo Skill 1", "Raging Tempest", 7, {3e21, 3e22, 3e23, 3e24, 3e25, 3e26}},
                        {"Moo Skill 3", "Judgement Light", 7, {4e27, 4e28, 4e29, 4e30, 4e31, 4e32}},
                        {"Nu Skill 2", "Glacial Bloom", 8, {5e33, 5e34, 5e35, 5e36, 5e37, 5e38}},
                        {"Gob Skill 3", "Thunderburst", 9, {7e40, 7e42, 7e44, 7e46, 7e48, 7e50}}
                }},
                PP = {"Psychic Power", {
                        {"Pear Skill 2", "Demonic Cage", 5, {1e12, 1e13, 1e14, 1e15, 1e16, 1e17}},
                        {"Whan Skill 1", "Spatial Distortion", 6, {1e15, 1e16, 1e17, 1e18, 1e19, 1e20}},
                        {"Gob Skill 9", "Phantom Summon", 6, {1e18, 1e19, 1e20, 1e21, 1e22, 1e23}},
                        {"Nu Skill 4", "Supernova Bomb", 7, {1e21, 1e22, 1e23, 1e24, 1e25, 1e26}},
                        {"Moo Skill 4", "Magma Wave", 7, {1e24, 1e25, 1e26, 1e27, 1e28, 1e29}},
                        {"Gob Skill 7", "Void Piercer", 8, {1e27, 1e28, 1e29, 1e30, 1e31, 1e32}},
                        {"Gob Skill 4", "Hell's Quicksand", 8, {1e30, 1e31, 1e32, 1e33, 1e34, 1e35}},
                        {"Joe Skill 1", "Enchanted Doom", 9, {1e33, 1e34, 1e35, 1e36, 1e37, 1e38}},
                        {"Oum Skill 2", "Endless Storm", 9, {1e36, 1e37, 1e38, 1e39, 1e40, 1e41}},
                        {"Joe Skill 2", "Blade Dance", 9, {1e39, 1e41, 1e43, 1e45, 1e47, 1e49}}
                }}
        }

        local cUt = {
                {"Energy Sphere Punch", 5, "FS 1,000 to unlock", {"LV1: T2 -- FS 1K (1e3)", "LV2: T3 -- FS 10K (1e4)", "LV3: T3 -- FS 1M (1e6)", "LV4: T4 -- FS 100M (1e8)", "LV5: T4 -- FS 100B (1e11)", "LV6: T5 -- FS 1Qa (1e15)", "LV7: T6 -- FS 100Qi (1e20)", "LV8: T7 -- FS 10Sp (1e25)", "LV9: T8 -- FS 1No (1e30)", "LV10 MAX: T9 -- FS 10Dd (1e40)"}},
                {"Damage Reflection", 6, "{Passive}"},
                {"Water Run", 7, "{Passive}", {"Toggle needs MS 1,000 + PP 1,000"}},
                {"Teleport", 9},
                {"Fly", 10, "{Double Jump}"},
                {"Bullet Punch", 11, "FS 100K to unlock", {"LV1: T3 -- FS 100K (1e5)", "LV2: T4 -- FS 10M (1e7)", "LV3: T5 -- FS 1T (1e12)", "LV4: T6 -- FS 10Sx (1e22)", "LV5: T7 -- FS 100No (1e32)", "LV6 MAX: T8 -- FS 1Td (1e42)"}},
                {"Soul Attack", 12, nil, {"LV1: T3 -- from unlock", "LV2: T3 -- PP 100K (1e5)", "LV3: T4 -- PP 100M (1e8)", "LV4: T4 -- PP 1T (1e12)", "LV5: T5 -- PP 10Qa (1e16)", "LV6: T5 -- PP 100Qi (1e20)", "LV7: T6 -- PP 10Sp (1e25)", "LV8: T7 -- PP 1No (1e30)", "LV9: T8 -- PP 100Dc (1e35)", "LV10 MAX: T9 -- PP 100Dd (1e41)"}},
                {"Conceal/Reveal Aura", 13},
                {"Killing Intent Aura", 14}
        }

        local cWikiGB = {}
        local cWikiPar = {}

        do
                local a = cTabs[4]:CreateGroupbox({Name = "Quest Skills", Column = 1}, "cW0")
                cWikiGB[#cWikiGB + 1] = a
                local b = {}
                for _, c in ipairs(cUt) do
                        b[#b + 1] = cWcol('<font color="rgb(235,236,242)">' .. c[1] .. '</font>  --  Main Quest ' .. c[2] .. '+')
                        if c[3] then b[#b + 1] = cWcol(cNum("   " .. c[3])) end
                        if c[4] then
                                for _, d in ipairs(c[4]) do
                                        b[#b + 1] = cWcol(cNum("   " .. d))
                                end
                        end
                end
                cWikiPar[#cWikiPar + 1] = a:CreateParagraph({Name = "Quest Skills", Content = table.concat(b, "\n")}, "cWq")
        end

        for d, a in ipairs(c13) do
                local b = cU[a]
                local c = cTabs[4]:CreateGroupbox({Name = b[1] .. " (" .. a .. ")", Column = d % 2 == 0 and 1 or 2}, "cW" .. a)
                cWikiGB[#cWikiGB + 1] = c
                local e = {}
                for _, f in ipairs(b[2]) do
                        e[#e + 1] = '<font color="rgb(235,236,242)">' .. f[2] .. '</font>  --  <font color="' .. cStatRGB[a] .. '">' .. f[1] .. '</font>  --  <font color="' .. cTierRGB .. '">Tier ' .. f[3] .. '</font>'
                        for g = 1, 6 do
                                e[#e + 1] = '   <font color="' .. cStatRGB[a] .. '">LVL' .. g .. ':</font> ' .. cNum(cUj(f[4][g]))
                        end
                end
                cWikiPar[#cWikiPar + 1] = c:CreateParagraph({Name = b[1], Content = table.concat(e, "\n")}, "cWp" .. a)
        end

        local cS0 = cTabs[5]:CreateGroupbox({Name = "General", Column = 1}, "cS0")

        cS0:CreateToggle({
                Name = "Auto Hide UI",
                Tooltip = "Enabled -- the UI starts minimized on next execution (restore with your Minimize Bind).",
                CurrentValue = c25.hide,
                Callback = function(a)
                        if not cUIok then return end
                        c25.hide = a
                        clg("Auto Hide UI " .. (a and "enabled" or "disabled"))
                        cq()
                end
        }, "cShide")

        local cSlastkey = tostring(c6.WindowKeybind or "F2")

        cS0:CreateLabel({Name = "Minimize Keybind"}, "cSbind_l"):AddBind({
                CurrentValue = cSlastkey,
                WindowSetting = true,
                Tooltip = "Key to hide or show the cLTR window.",
                Callback = function() end,
                OnChangedCallback = function(a)
                        pcall(function()
                                a = tostring(a)
                                if a ~= cSlastkey then
                                        cSlastkey = a
                                        clg("Minimize keybind set to " .. a)
                                end
                        end)
                end
        }, "cSbind")

        local cS2 = cTabs[5]:CreateGroupbox({Name = "Autoload (this account)", Column = 1}, "cS2")

        local cCfg
        do
                local a, b = pcall(function()
                        return cTabs[5]:BuildConfigGroupbox(2)
                end)
                if a and typeof(b) == "table" then cCfg = b end
        end
        if not cCfg then
                clg("Configuration section skipped -- Starlight config system could not build")
        end
        pcall(function()
                if cCfg and cCfg.Elements then
                        for a, b in pairs(cCfg.Elements) do
                                if b and b.Class == "Divider" then
                                        b.IgnoreConfig = true
                                end
                        end
                end
        end)

        local function cCfgSel()
                local a = nil
                pcall(function()
                        local b = cCfg and cCfg.Elements and cCfg.Elements["__prebuiltConfigSelector_lbl"]
                        local c = b and b.NestedElements and b.NestedElements["__prebuiltConfigSelector_lbl"]
                        local d = c and c.Values and c.Values.CurrentOption
                        if type(d) == "table" then
                                a = d[1]
                        elseif type(d) == "string" then
                                a = d
                        end
                end)
                return a
        end

        local cSaload = cS2:CreateButton({
                Name = "Set autoload for this account",
                Tooltip = "Current: none",
                Callback = function()
                        local a = cCfgSel()
                        if typeof(a) ~= "string" or a == "" then
                                c6:Notification({
                                        Title = "cLTR Calculators",
                                        Content = "Autoload\nPick a config in the Configuration list first.",
                                        Duration = 6
                                })
                                return
                        end
                        c25.alsm = a
                        cSaload:Set({Tooltip = "Current: " .. a})
                        clg("Autoload for this account set to " .. a)
                        cq()
                end
        }, "cSaload")

        cS2:CreateButton({
                Name = "Clear autoload for this account",
                Tooltip = "Falls back to the shared autoload config, if any.",
                Callback = function()
                        c25.alsm = nil
                        cSaload:Set({Tooltip = "Current: none"})
                        clg("Autoload for this account cleared")
                        cq()
                end
        }, "cSalclean")

        if typeof(c25.alsm) == "string" and c25.alsm ~= "" then
                cSaload:Set({Tooltip = "Current: " .. c25.alsm})
        end

        local cS1 = cTabs[5]:CreateGroupbox({Name = "Activity Log", Column = 1}, "cS1")
        cLogBox = cS1:CreateParagraph({Name = "Log", Content = "No activity yet."}, "cSlog")
        if #cLogLines > 0 then cspa(cLogBox, table.concat(cLogLines, "\n")) end
        cS1:CreateButton({
                Name = "Clear",
                Tooltip = "Clears the activity log.",
                Callback = function()
                        table.clear(cLogLines)
                        cspa(cLogBox, "No activity yet.")
                end
        }, "cSclear")

        local cS3 = cTabs[5]:CreateGroupbox({Name = "Danger Zone", Column = 2}, "cS3")

        local function cUnj()
                csv()
                pcall(function()
                        local a = c6.FileSystem and c6.FileSystem.AutoloadConfigPath
                        if a and isfolder and isfolder(a) then
                                c6.FileSystem:SaveConfig(c4.Name, a)
                        end
                end)
                if cqT then pcall(task.cancel, cqT) end
                for _, a in pairs(c1.th) do
                        if typeof(a) == "thread" and coroutine.status(a) ~= "dead" then pcall(task.cancel, a) end
                end
                table.clear(c1.th)
                pcall(function()
                        c6.Window = nil
                        c6:Destroy()
                end)
                pcall(function()
                        if c6.Instance and c6.Instance.Parent then c6.Instance:Destroy() end
                end)
                table.clear(cSyncMem)
                table.clear(cLogLines)
                table.clear(c21)
                getgenv().cLTR_State = nil
        end

        cS3:CreateButton({
                Name = "Uninject",
                Tooltip = "Fully unloads cLTR and closes everything it created.",
                Callback = function()
                        cWindow:PromptDialog({
                                Name = "Uninject",
                                Content = "Fully unload cLTR Calculators and close everything it created?",
                                Type = 1,
                                Actions = {
                                        Primary = {
                                                Name = "Confirm",
                                                Callback = cUnj
                                        },
                                        {
                                                Name = "Cancel",
                                                Callback = function() end
                                        }
                                }
                        })
                end
        }, "cSunj")

        local function cSauto()
                local a = nil
                pcall(function()
                        a = c6.FileSystem and c6.FileSystem.AutoloadConfigPath
                end)
                if not a or not isfolder or not isfolder(a) then return end
                if typeof(c25.alsm) == "string" and c25.alsm ~= "" and not isfile(a .. "autoload.txt") then
                        pcall(function()
                                writefile(a .. "autoload.txt", c25.alsm)
                        end)
                end
        end

        local cTints = {
                [1] = {Color3.fromRGB(255, 228, 64), Color3.fromRGB(158, 132, 20)},
                [3] = {Color3.fromRGB(80, 218, 226), Color3.fromRGB(24, 122, 130)},
                [4] = {Color3.fromRGB(178, 132, 255), Color3.fromRGB(96, 60, 158)},
                [5] = {Color3.fromRGB(176, 182, 192), Color3.fromRGB(88, 94, 104)}
        }
        local function cTheal()
                for b, c in pairs(cTints) do
                        pcall(function()
                                local d = cTabs[b] and cTabs[b].Instances and cTabs[b].Instances.Button
                                local e = d and d:FindFirstChild("Header")
                                if e then
                                        if e:GetAttribute("cTabTint") ~= c[1] then e:SetAttribute("cTabTint", c[1]) end
                                        if e.TextColor3 ~= c[1] then e.TextColor3 = c[1] end
                                        local f = e:FindFirstChild("AccentBrighter")
                                        if f then
                                                if not f.Enabled or f.Color ~= c[2] then
                                                        f.Enabled = true
                                                        f.Color = c[2]
                                                end
                                        end
                                end
                        end)
                end
        end

        local function cTiphide()
                pcall(function()
                        local a = c6.Instance and c6.Instance:FindFirstChild("Tooltips")
                        if not a then return end
                        for _, b in ipairs(a:GetChildren()) do
                                b.Visible = false
                        end
                end)
        end

        c1.th[#c1.th + 1] = task.spawn(function()
                while true do
                        task.wait(1)
                        if (not c6.Instance or not c6.Instance.Parent) or getgenv().cLTR_State ~= c1 then break end
                        if cUIok and not c6.Minimized then
                                pcall(function()
                                        if c25.cat and c25.md[c25.cat] then cFsync(c25.cat, false) end
                                end)
                                pcall(function()
                                        if c25.md.TK then cTsync(false) end
                                end)
                                pcall(function()
                                        if c25.md.ML then cMsync(false) end
                                end)
                                pcall(function()
                                        local a = cTabs[1] and cTabs[1].Instances and cTabs[1].Instances.Page
                                        local b = a and a.Parent and a.Parent:FindFirstChildOfClass("UIPageLayout")
                                        local c = b and b.CurrentPage
                                        if c then
                                                for d, e in ipairs(cTabs) do
                                                        if e.Instances and e.Instances.Page == c and c25.view ~= d then
                                                                c25.view = d
                                                                cq()
                                                                break
                                                        end
                                                end
                                        end
                                end)
                                cTheal()
                        else
                                cTiphide()
                        end
                end
        end)

        pcall(function()
                local cFr = Font.new("rbxasset://fonts/families/GothamSSm.json")
                local cFm = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
                local cFb = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
                local cRoot = c6.Instance
                if typeof(cRoot) ~= "Instance" then return end
                local cAc = Color3.fromRGB(161, 169, 225)
                local cHe = Color3.fromRGB(235, 236, 242)
                local cBd = Color3.fromRGB(186, 189, 199)
                local cSu = Color3.fromRGB(168, 175, 228)
                local cGy = Color3.fromRGB(150, 153, 163)
                local cWk = Color3.fromRGB(207, 211, 221)
                local cWGB = {}
                for _, a in ipairs(cWikiGB) do
                        pcall(function()
                                if a.Instance then cWGB[a.Instance] = true end
                        end)
                end
                local cWPar = {}
                for _, a in ipairs(cWikiPar) do
                        pcall(function()
                                if a.Instance then
                                        local b = a.Instance:FindFirstChild("Content")
                                        if b then cWPar[b] = true end
                                end
                        end)
                end
                local cResP = {}
                for _, a in pairs(cMsgBox) do
                        pcall(function()
                                if a.Instance then
                                        local b = a.Instance:FindFirstChild("Content")
                                        if b then cResP[b] = true end
                                end
                        end)
                end
                for _, a in ipairs(cRoot:GetDescendants()) do
                        if a:IsA("TextBox") or a:IsA("TextLabel") or a:IsA("TextButton") then
                                local b = a.Parent
                                local c = b and b.Name or ""
                                local d = false
                                local e = a
                                while e and e ~= cRoot do
                                        if e.Name == "Loading Screen" then
                                                d = true
                                                break
                                        end
                                        e = e.Parent
                                end
                                if not d then
                                        if a:IsA("TextBox") then
                                                a.FontFace = cFr
                                                a.TextSize = 12
                                        elseif c == "Sidebar" and a.Name == "Header" then
                                                a.FontFace = cFb
                                                a.TextSize = 17
                                                a.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        elseif a.Name == "subheader" then
                                                a.FontFace = cFr
                                                a.TextSize = 11
                                                a.TextColor3 = cGy
                                        elseif c == "Player" then
                                                a.FontFace = cFm
                                                a.TextSize = 13
                                                a.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        elseif c == "Headers" then
                                                a.FontFace = cFm
                                                a.TextSize = 13
                                                a.TextColor3 = cSu
                                        elseif c:match("^TAB_%d+$") and a.Name == "Header" then
                                                a.FontFace = cFm
                                                a.TextSize = 14
                                        elseif c:match("^GROUPBOX_%d+$") and a.Name == "Header" then
                                                a.FontFace = cFb
                                                a.TextSize = cWGB[b] and 16 or 13
                                                a.TextColor3 = cAc
                                        elseif a.Name == "Content" and c:match("^PARAGRAPH_") then
                                                a.FontFace = cFr
                                                a.TextSize = cWPar[a] and 16 or (cResP[a] and 14 or 12)
                                                a.TextColor3 = cWPar[a] and cWk or (cResP[a] and cHe or cBd)
                                                a.RichText = true
                                        elseif a.Name == "Header" and (c:match("^BUTTON_") or c:match("^CHECKBOX_") or c:match("^SWITCH_") or c:match("^BIND_") or c:match("^LABEL_") or c:match("^INPUT_") or c:match("^DROPDOWN_") or c:match("^PARAGRAPH_")) then
                                                a.FontFace = cFm
                                                a.TextSize = 13
                                                a.TextColor3 = cHe
                                        else
                                                a.FontFace = cFr
                                        end
                                        local f = a.Text
                                        if type(f) == "string" and f ~= "" and not (c:match("^TAB_%d+$")) then
                                                local g = cStatOf(f)
                                                if g then
                                                        a.TextColor3 = cStatCol[g]
                                                elseif f == "Quest Skills" then
                                                        a.TextColor3 = cWkCol
                                                elseif f == "Tokens" or f == "Tokens Objective" then
                                                        a.TextColor3 = cTokCol
                                                        a.TextStrokeColor3 = cTokStroke
                                                        a.TextStrokeTransparency = 0.4
                                                end
                                        end
                                end
                        end
                end
        end)

        for a, b in pairs(cMsgBox) do
                if c25.msg[a] ~= nil and c25.msg[a] ~= "" then cspa(b, c25.msg[a]) end
        end
        for _, a in ipairs({cFpw, cFob, cTtok, cTtpm, cTtob, cTtto, cTtsp}) do
                cinfit(a)
        end
        task.delay(1.25, function()
                for _, a in ipairs({cFpw, cFob, cTtok, cTtpm, cTtob, cTtto, cTtsp}) do
                        cinfit(a)
                end
        end)

        cTheal()

        cUIok = true

        pcall(function()
                local a = c6.Window and c6.Window.TabSections
                for _, b in pairs(a or {}) do
                        for _, c in pairs(b.Tabs or {}) do
                                for _, d in pairs(c.Groupboxes or {}) do
                                        for _, e in pairs(d.Elements or {}) do
                                                if e.Class ~= "Bind" then e.IgnoreConfig = true end
                                                for _, f in pairs(e.NestedElements or {}) do
                                                        if f.Class ~= "Bind" then f.IgnoreConfig = true end
                                                end
                                        end
                                end
                        end
                end
        end)

        if c25.cat and c12[c25.cat] then
                csdd(cFcat, c13, c25.cat)
                cFpaint(c25.cat)
                cFwshow(c25.cat)
                cFchain(c25.cat)
                cspa(cFres, c25.msg.Farming ~= "" and c25.msg.Farming or "Result appears here.")
        end

        cFpaint(c25.cat)

        cFwshow(c25.cat)

        cTapply()

        cMapply()

        pcall(function()
                if c25.md.TK then cTsync(false) end
                if c25.md.ML then cMsync(false) end
                if c25.cat and c25.md[c25.cat] then cFsync(c25.cat, false) end
        end)

        pcall(function()
                if c25.md[c25.cat] then
                        if c25.msg.Farming == "" then
                                cmsg("Farming", "Use Current Stats is on -- " .. c25.cat .. " auto selected, live stats sync into the inputs.")
                        end
                elseif c25.msg.Farming:find("Use Current Stats is on", 1, true) then
                        cmsg("Farming", "")
                end
                if c25.md.TK then
                        if c25.msg.Tokens == "" then
                                cmsg("Tokens", "Use Current Stats is on -- your current tokens and TPM sync into the inputs.")
                        end
                elseif c25.msg.Tokens:find("Use Current Stats is on", 1, true) then
                        cmsg("Tokens", "")
                end
                if c25.md.ML then
                        if c25.msg.Multipliers == "" then
                                cmsg("Multipliers", "Use Current Stats is on -- your current multipliers sync into the dropdowns.")
                        end
                elseif c25.msg.Multipliers:find("Use Current Stats is on", 1, true) then
                        cmsg("Multipliers", "")
                end
        end)

        c1.th[#c1.th + 1] = task.delay(0.8, function()
                if getgenv().cLTR_State ~= c1 or not cUIok then return end
                pcall(function()
                        if c25.cat and c12[c25.cat] then
                                if c25.md[c25.cat] then cFsync(c25.cat, false) end
                                cFapply(c25.cat)
                        end
                end)
                pcall(function()
                        if c25.md.TK then cTsync(false) end
                        cTapply()
                end)
                pcall(function()
                        if c25.md.ML then cMsync(false) end
                        cMapply()
                end)
                cTheal()
        end)

        if typeof(c25.alsm) ~= "string" or c25.alsm == "" then
                c25.alsm = c4.Name
                cq()
        end
        pcall(function()
                local a = c6.FileSystem and c6.FileSystem.AutoloadConfigPath
                local b = c6.FileSystem and c6.FileSystem.FileExtension or ".starlight"
                if a and isfolder and isfolder(a) and isfile and not isfile(a .. c4.Name .. b) then
                        local c, d = pcall(function()
                                return c6.FileSystem:SaveConfig(c4.Name, a)
                        end)
                        if c and d == true then
                                clg("Auto created config " .. c4.Name .. " for this account")
                        end
                end
        end)
        pcall(function()
                if typeof(c25.alsm) == "string" and c25.alsm ~= "" then
                        cSaload:Set({Tooltip = "Current: " .. c25.alsm})
                end
        end)

        cSauto()

        pcall(function()
                local a = cTabs[c25.view] or cTabs[1]
                if not a or not a.Instances then return end
                local b = a.Instances.Page
                local c = b and b.Parent and b.Parent:FindFirstChildOfClass("UIPageLayout")
                if b and c then
                        pcall(function()
                                c:JumpTo(b)
                        end)
                end
                local d = a.Instances.Button and a.Instances.Button.Interact
                if d and getconnections then
                        for _, e in ipairs(getconnections(d.MouseButton1Click)) do
                                pcall(function()
                                        e:Fire()
                                end)
                        end
                end
        end)

        c1.th[#c1.th + 1] = task.spawn(function()
                for _ = 1, 5 do
                        task.wait(1)
                        pcall(function()
                                local a = cWindow.Instance
                                local b = a and a:FindFirstChild("Content")
                                local c = b and b:FindFirstChild("ContentMain")
                                local d = c and c:FindFirstChild("Elements")
                                if d then
                                        local e = d:FindFirstChild("HomeTab")
                                        if e then
                                                e:Destroy()
                                        end
                                end
                                local f = cTabs[1] and cTabs[1].Instances and cTabs[1].Instances.Page
                                if cWindow.CurrentTab == nil and cTabs[1] and cTabs[1].Instances and cTabs[1].Instances.Button and cTabs[1].Instances.Button.Interact then
                                        local i = cTabs[1].Instances.Button.Interact
                                        if getconnections then
                                                for _, j in ipairs(getconnections(i.MouseButton1Click)) do
                                                        pcall(function()
                                                                j:Fire()
                                                        end)
                                                end
                                        else
                                                local k = f and f.Parent and f.Parent:FindFirstChildOfClass("UIPageLayout")
                                                if k and f then
                                                        pcall(function()
                                                                k:JumpTo(f)
                                                        end)
                                                end
                                        end
                                end
                        end)
                end
        end)
        task.delay(0.75, cTheal)
        if c25.hide then
                c6.Minimized = true
                pcall(function()
                        cWindow.Instance.Visible = false
                        c6.Instance.Drag.Visible = false
                end)
                cTiphide()
        else
                c1.th[#c1.th + 1] = task.delay(0.35, function()
                        pcall(function()
                                if c6.Minimized then return end
                                cWindow.Instance.Visible = true
                                c6.Instance.Drag.Visible = true
                                local a = cWindow.Instance:FindFirstChildOfClass("UIScale")
                                if not a then
                                        a = Instance.new("UIScale")
                                        a.Scale = 0.96
                                        a.Parent = cWindow.Instance
                                end
                                game:GetService("TweenService"):Create(a, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                        end)
                end)
        end

        c6:Notification({
                Title = "cLTR Calculators",
                Content = "Loaded -- press " .. tostring(c6.WindowKeybind or "F2") .. " to show or hide this UI",
                Duration = 6
        })

        clg("Session started -- Auto Hide UI " .. (c25.hide and "ON" or "OFF") .. " -- hide/show key: " .. tostring(c6.WindowKeybind or "F2"))
        csv()

end, function(e)
        pcall(function()
                local a = getgenv().cLTR_State
                local b = a and a.lib
                if b and b.Instance then
                        b.Minimized = false
                        local c = b.Instance:FindFirstChild("MainWindow")
                        if c then
                                c.Visible = true
                        end
                        local d = b.Instance:FindFirstChild("Drag")
                        if d then
                                d.Visible = true
                        end
                end
        end)
        cnote("Startup failed -- " .. tostring(e):sub(1, 140))
        warn("[cLTR] " .. debug.traceback(tostring(e), 2))
end)
