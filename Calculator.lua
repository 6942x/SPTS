local function c(c1)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "cLTR Calculators",
            Content = c1,
            Duration = 8,
        })
    end)
    warn("[cLTR] " .. c1)
end

local c2

xpcall(function()
    if getgenv().cLTR_State then
        local c1 = getgenv().cLTR_State
        if
            c1.loading
            and typeof(c1.startup) == "thread"
            and c1.startup ~= coroutine.running()
            and coroutine.status(c1.startup) ~= "dead"
        then
            c1.loading = false
            pcall(task.cancel, c1.startup)
        end
        for c3, c4 in pairs(c1.th or {}) do
            if typeof(c4) == "thread" and coroutine.status(c4) ~= "dead" then
                pcall(task.cancel, c4)
            end
        end
        if c1.lib then
            pcall(function()
                c1.lib.Window = nil
                c1.lib:Destroy()
            end)
            pcall(function()
                if c1.lib.Instance and c1.lib.Instance.Parent then
                    c1.lib.Instance:Destroy()
                end
            end)
        end
    end

    getgenv().cLTR_State = { th = {}, lib = nil }
    local c5 = getgenv().cLTR_State
    c2 = c5
    c5.loading = true
    c5.startup = coroutine.running()

    local c6 = game:GetService("Players")
    local c7 = game:GetService("HttpService")

    local c8 = c6.LocalPlayer
    local c9 = 0
    while not c8 and c9 < 20 do
        task.wait(0.5)
        c9 = c9 + 1
        c8 = c6.LocalPlayer
    end
    if not c8 then
        error("[cLTR] Could not find the LocalPlayer - join a game first, then re-execute", 0)
    end
    local c10 = c8:WaitForChild("PlayerGui", 10)

    local function c11(c1)
        return type(c1) == "string"
            and (c1:find("RunChanged", 1, true) ~= nil or c1:find("SafeCallback", 1, true) ~= nil)
    end

    local c12 = false

    local function c13(c1, c4, c14)
        local c15
        local c16
        local c17 = c14 or c1:match("([^/]+)$")
        for c18 = 1, 2 do
            local c19, c20 = pcall(function()
                return game:HttpGetAsync(c1)
            end)
            if c19 and typeof(c20) == "string" and #c20 > 200 and c20:find(c4, 1, true) then
                if c11(c20) then
                    c16 = c16 or c20
                else
                    c15 = c20
                    break
                end
            end
            task.wait(0.5)
        end
        if not c15 and readfile then
            pcall(function()
                if isfile and isfile("TrainingCalc/cache_" .. c17) then
                    local c18 = readfile("TrainingCalc/cache_" .. c17)
                    if typeof(c18) == "string" and #c18 > 200 and c18:find(c4, 1, true) then
                        if c11(c18) then
                            c16 = c16 or c18
                        else
                            c15 = c18
                        end
                    end
                end
            end)
        end
        if not c15 and c16 then
            c12 = true
            error(
                "[cLTR] The Starlight copy served to this executor is outdated and breaks the UI (tonumber base out of range errors) - delete the TrainingCalc cache folder, rejoin the game so the executor drops its cached download, then re-execute",
                0
            )
        end
        if c15 and writefile then
            pcall(function()
                if isfolder and not isfolder("TrainingCalc") then
                    makefolder("TrainingCalc")
                end
                writefile("TrainingCalc/cache_" .. c17, c15)
            end)
        end
        if not c15 then
            error(
                "[cLTR] Failed to download "
                    .. c1:match("([^/]+)$")
                    .. " - check your internet connection and re-execute",
                0
            )
        end
        return c15
    end

    local function c21(c1)
        local c4, c15 = c1:gsub(
            "Parent%.Instance%.Header%.Size = UDim2%.fromOffset%(Parent%.Instance%.Header%.Size%.X%.Offset ([-+]) 26, 20%)",
            'if Parent.Instance:FindFirstChild("Header") then Parent.Instance.Header.Size = UDim2.fromOffset(Parent.Instance.Header.Size.X.Offset %1 26, 20) end'
        )
        if c15 == 0 then
            warn("[cLTR] Starlight destroy-guard patch did not match the downloaded library source")
        end
        c4 = c4:gsub(
            "label%.FontFace = Font%.fromId%(12187365364, Enum%.FontWeight%.Regular%)",
            'label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")'
        )
        local c18, c19, c20
        c4, c18 = c4:gsub(
            "Tween%(Tab%.Instances%.Button%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Light }%)",
            'Tween(Tab.Instances.Button.Header, { TextColor3 = Tab.Instances.Button.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Light })'
        )
        c4, c19 = c4:gsub(
            "Tween%(Tab%.Instances%.Button%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Medium }%)",
            'Tween(Tab.Instances.Button.Header, { TextColor3 = Tab.Instances.Button.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Medium })'
        )
        c4, c20 = c4:gsub(
            "Tween%(OtherTab%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Medium }%)",
            'Tween(OtherTab.Header, { TextColor3 = OtherTab.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Medium })'
        )
        c4 = c4:gsub(
            "OtherTab%.Header%.AccentBrighter%.Enabled = false",
            'OtherTab.Header.AccentBrighter.Enabled = OtherTab.Header:GetAttribute("cTabTint") ~= nil'
        )
        if c18 + c19 + c20 == 0 then
            warn("[cLTR] Starlight tab-color patch did not match the downloaded library source")
        end
        local c22, c23, c24
        c4, c22 = c4:gsub(
            "function NestedElement:Set%(NewNestedSettings, NewNestedIndex%)%s+NewNestedIndex = NewNestedIndex or NestedIndex%s+for i, v in pairs%(NestedElement%.Values%) do%s+if NewNestedSettings%[i%] == nil then%s+NewNestedSettings%[i%] = v%s+end%s+end%s+NestedSettings = NewNestedSettings%s+NestedIndex = NewNestedIndex%s+NestedElement%.Values = NestedSettings%s+if NestedElement%.Values%.CurrentOption then",
            "function NestedElement:Set(NewNestedSettings, NewNestedIndex) local cPrevOpts = NestedElement.Values and NestedElement.Values.Options or nil NewNestedIndex = NewNestedIndex or NestedIndex for i, v in pairs(NestedElement.Values) do if NewNestedSettings[i] == nil then NewNestedSettings[i] = v end end NestedSettings = NewNestedSettings NestedIndex = NewNestedIndex NestedElement.Values = NestedSettings if NestedElement.Values.CurrentOption then"
        )
        c4, c23 = c4:gsub(
            "Refresh%(%)(%s+)local preoptions = table%.clone%(NestedElement%.Values%.CurrentOption or %{}%)",
            'local cReuseOpts = false if typeof(NestedElement.Instances) == "table" and typeof(NestedElement.Instances[2]) == "Instance" and NestedElement.Instances[2]:FindFirstChild("List") ~= nil and NestedElement.Instances[2].List:FindFirstChildOfClass("Frame") ~= nil and (NestedElement.Values.Special == nil or NestedElement.Values.Special == 0) and type(cPrevOpts) == "table" and type(NewNestedSettings.Options) == "table" and #cPrevOpts == #NewNestedSettings.Options then cReuseOpts = true for ci = 1, #cPrevOpts do if cPrevOpts[ci] ~= NewNestedSettings.Options[ci] then cReuseOpts = false break end end end if not cReuseOpts then Refresh() end%1local preoptions = table.clone(NestedElement.Values.CurrentOption or {})'
        )
        c4, c24 = c4:gsub(
            'themeEvent%.Event:Connect%(function%(%)%s+if optioninstance:GetAttribute%("Active"%) then%s+Activate%(optioninstance%)%s+else%s+Deactivate%(optioninstance%)%s+end%s+end%)',
            'local cc cc = themeEvent.Event:Connect(function() if not optioninstance.Parent then cc:Disconnect() return end if optioninstance:GetAttribute("Active") then Activate(optioninstance) else Deactivate(optioninstance) end end) optioninstance.AncestryChanged:Connect(function() if not optioninstance.Parent then cc:Disconnect() end end)'
        )
        if c22 + c23 + c24 < 3 then
            warn("[cLTR] Starlight memory-leak patch did not match the downloaded library source")
        end
        local c25, c26, c27, c28
        c4, c25 = c4:gsub(
            "themeEvent%.Event:Connect%(set%)%s+set%(%)",
            'local cc cc = themeEvent.Event:Connect(function() if typeof(object) ~= "Instance" or not object.Parent then cc:Disconnect() return end set() end) object.AncestryChanged:Connect(function() if typeof(object) ~= "Instance" or not object.Parent then cc:Disconnect() end end) set()'
        )
        c4, c26 = c4:gsub(
            'CollectionService:AddTag%(newNotification, "__starlight_ExpiredNotification"%)',
            'CollectionService:AddTag(newNotification, "__starlight_ExpiredNotification") task.delay(1.5, function() local cExp = CollectionService:GetTagged("__starlight_ExpiredNotification") for ni = 1, #cExp - 6 do pcall(function() cExp[ni]:Destroy() end) end end)'
        )
        c4, c27 = c4:gsub(
            'if v%.ClassName == "Frame" and v ~= option then%s+Deactivate%(v%)%s+NestedElement%.Values%.CurrentOption = %{}%s+end',
            'if v.ClassName == "Frame" and v ~= option then if v:GetAttribute("Active") == true then Deactivate(v) end NestedElement.Values.CurrentOption = {} end'
        )
        c4, c28 = c4:gsub(
            "RunService%.RenderStepped:Connect%(function%(dt%)%s+if not IsHovering then%s+return%s+end",
            "local cTRS cTRS = RunService.RenderStepped:Connect(function(dt) if not HoverInstance.Parent then cTRS:Disconnect() return end if not IsHovering then return end if Starlight.Minimized or not Starlight.Instance.MainWindow.Visible then IsHovering = false tooltip.Visible = false return end"
        )
        if c25 + c26 + c27 + c28 < 4 then
            warn("[cLTR] Starlight notification-cleanup patch did not match the downloaded library source")
        end
        local c29, c30, c31
        c4, c29 = c4:gsub(
            "ConfigMethods%.Load%(object%.idx, object%.data%)",
            'if typeof(object) == "table" and typeof(object.data) == "table" then ConfigMethods.Load(object.idx, object.data) end'
        )
        c4, c30 = c4:gsub("for key, value in pairs%(Data%) do", "for key, value in pairs(Data or {}) do")
        c4, c31 = c4:gsub(
            "table%.insert%(data%.objects, ConfigMethods%.Save%(fullidx, object%.Values, object%.Class%)%)",
            'if typeof(object.Values) == "table" then table.insert(data.objects, ConfigMethods.Save(fullidx, object.Values, object.Class)) end'
        )
        if c29 + c30 + c31 < 3 then
            warn("[cLTR] Starlight config-safety patch did not match the downloaded library source")
        end
        local c32, c33, c34, c35, c36
        c4, c32 = c4:gsub(
            "Element%.Instance%.PART_Backdrop%.PART_Input%.Text = Element%.Values%.CurrentValue%s+Tween%(%s+Element%.Instance%.PART_Backdrop%.PART_Input,%s+{ Size = UDim2%.new%(0, Element%.Instance%.PART_Backdrop%.PART_Input%.TextBounds%.X, 1, 0%) }%s+%)%s+Tween%(%s+Element%.Instance%.PART_Backdrop,%s+{%s+Size = UDim2%.new%(%s+0,%s+Element%.Instance%.PART_Backdrop%.PART_Input%.TextBounds%.X %+ 30,%s+0,%s+Element%.Instance%.PART_Backdrop%.Size%.Y%.Offset%s+%),%s+}%s+%)",
            'Element.Instance.PART_Backdrop.PART_Input.Text = Element.Values.CurrentValue local cLTRii = Element.Instance.PART_Backdrop.PART_Input local function cLTRme(a) local b, c = pcall(function() return game:GetService("TextService"):GetTextSize(a, cLTRii.TextSize, Enum.Font.Gotham, Vector2.new(10000, 10000)).X end) if b and c then return c end local d = cLTRii.Text cLTRii.Text = a local e = cLTRii.TextBounds.X cLTRii.Text = d return e end local cLTRiw = cLTRii.Text ~= "" and cLTRme(cLTRii.Text) or 0 if cLTRii.PlaceholderText ~= "" then cLTRiw = math.max(cLTRiw, cLTRme(cLTRii.PlaceholderText)) end if Element.__cLTRiw ~= cLTRiw then Element.__cLTRiw = cLTRiw Tween(cLTRii, { Size = UDim2.new(0, cLTRiw, 1, 0) }) Tween(Element.Instance.PART_Backdrop, { Size = UDim2.new(0, cLTRiw + 30, 0, Element.Instance.PART_Backdrop.Size.Y.Offset) }) end'
        )
        c4, c33 = c4:gsub(
            'local Acrylic = isStudio and require%(ReplicatedStorage%.AcrylicBundled%)%s+or loadstring%(game:HttpGet%("https://raw%." %.%. website %.%. "/AcrylicModule%.luau"%)%)%(%)%s+Acrylic%.Init%(%)',
            'local Acrylic = { Init = function() end, AcrylicPaint = function() local cLTRf = Instance.new("Frame") cLTRf.Name = "cLTRAcrylic" cLTRf.BackgroundTransparency = 1 local cLTRs = Instance.new("ImageLabel") cLTRs.Name = "shadow" cLTRs.BackgroundTransparency = 1 cLTRs.Visible = false cLTRs.Parent = cLTRf return { AddParent = function() end, Frame = cLTRf, Model = { Size = Vector3.new(1, 1, 0.001) } } end }'
        )
        c4, c34 = c4:gsub(
            "mainWindow%.Sidebar%.Player%.PlayerIcon%.Image =%s+Players:GetUserThumbnailAsync%(Player%.UserId, Enum%.ThumbnailType%.HeadShot, Enum%.ThumbnailSize%.Size48x48%)",
            "task.spawn(function() local cLTRok, cLTRimg = pcall(function() return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) if cLTRok and cLTRimg then mainWindow.Sidebar.Player.PlayerIcon.Image = cLTRimg end end)"
        )
        c4, c35 =
            c4:gsub("ContentProvider:PreloadAsync%({", "task.spawn(function() ContentProvider:PreloadAsync({")
        c4, c36 = c4:gsub(
            "print%(`loaded asset {asset}`%)%s+end%s+end%)",
            "print(`loaded asset {asset}`) end end) end)"
        )
        if c32 + c33 + c34 + c35 + c36 < 5 then
            warn("[cLTR] Starlight boot-perf patch did not match the downloaded library source")
        end
        local c37
        c4, c37 = c4:gsub(
            "Starlight%.Minimized = true%s+end",
            'Starlight.Minimized = true pcall(function() local cTT = Starlight.Instance and Starlight.Instance:FindFirstChild("Tooltips") if cTT then for _, t in ipairs(cTT:GetChildren()) do t.Visible = false end end end) end'
        )
        if c37 < 1 then
            warn("[cLTR] Starlight tooltip-hide patch did not match the downloaded library source")
        end
        local c38
        c4, c38 = c4:gsub(
            'if option:GetAttribute%("Active"%) == false then%s+Activate%(option%)%s+local Success, Response = pcall%(function%(%)',
            'if option:GetAttribute("Active") == false then Activate(option) if not NestedElement.Values.MultipleOptions then close() end local Success, Response = pcall(function()'
        )
        if c38 < 1 then
            warn("[cLTR] Starlight dropdown-close patch did not match the downloaded library source")
        end
        local c39
        c4, c39 = c4:gsub(
            "local function close%(%)%s+Tween%(%s*NestedElement%.Instances%[2%]%.List",
            "local function close() NestedElement.__cLTRopen = false if NestedElement.Instances[2].Size.Y.Offset <= 0 then NestedElement.Instances[2].Visible = false end task.delay(0.25, function() if NestedElement and NestedElement.Instances ~= nil and not NestedElement.__cLTRopen and NestedElement.Instances[2].Size.Y.Offset <= 0 then NestedElement.Instances[2].Visible = false end end) Tween(NestedElement.Instances[2].List"
        )
        if c39 < 1 then
            warn("[cLTR] Starlight dropdown-close-guard patch did not match the downloaded library source")
        end
        local c40
        c4, c40 = c4:gsub(
            "Size = UDim2%.fromOffset%(NestedElement%.Instances%[2%]%.Size%.X%.Offset, 0%)%s*},%s*function%(%)%s*if NestedElement and NestedElement%.Instances ~= nil then%s+NestedElement%.Instances%[2%]%.Visible = false",
            "Size = UDim2.fromOffset(NestedElement.Instances[2].Size.X.Offset, 0) }, function() if NestedElement and NestedElement.Instances ~= nil then if not NestedElement.__cLTRopen and NestedElement.Instances[2].Size.Y.Offset <= 0 then NestedElement.Instances[2].Visible = false end"
        )
        if c40 < 1 then
            warn("[cLTR] Starlight dropdown-close-callback patch did not match the downloaded library source")
        end
        local c41
        c4, c41 = c4:gsub(
            "NestedElement%.Instances%[1%]%.Interact%.MouseButton1Click:Connect%(function%(%)%s+if NestedElement%.Instances%[2%]%.Visible then%s+close%(%)%s+else%s+NestedElement%.Instances%[2%]%.Visible = true%s+height = NestedElement%.Instances%[2%]%.List",
            "NestedElement.Instances[1].Interact.MouseButton1Click:Connect(function() if NestedElement.Instances[2].Visible and NestedElement.Instances[2].Size.Y.Offset > 1 then close() else NestedElement.Instances[2].Visible = true NestedElement.__cLTRopen = true height = NestedElement.Instances[2].List"
        )
        if c41 < 1 then
            warn("[cLTR] Starlight dropdown-reopen-toggle patch did not match the downloaded library source")
        end
        local c42, c43, c44
        c4, c42 = c4:gsub(
            "StarlightUI%.MainWindow%.Visible = false%s+StarlightUI%.MainWindow%.AnchorPoint = Vector2%.zero",
            'StarlightUI.MainWindow.Visible = false StarlightUI.MainWindow.AnchorPoint = Vector2.zero pcall(function() local cN = StarlightUI:FindFirstChild("Notifications") if cN then cN.AnchorPoint = Vector2.new(0, 1) cN.Position = UDim2.new(0, 20, 1, -20) end end)'
        )
        c4, c43 = c4:gsub(
            "StarlightUI%.Notifications%.Position = UDim2%.new%(1, %-20, 1, %-%(24 %+ jumpButton%.AbsoluteSize%.Y%)%)",
            "StarlightUI.Notifications.AnchorPoint = Vector2.new(0, 1) StarlightUI.Notifications.Position = UDim2.new(0, 20, 1, -(24 + jumpButton.AbsoluteSize.Y))"
        )
        c4, c44 = c4:gsub(
            "StarlightUI%.Notifications%.Position = UDim2%.new%(1, %-20, 1, %-20%)",
            "StarlightUI.Notifications.AnchorPoint = Vector2.new(0, 1) StarlightUI.Notifications.Position = UDim2.new(0, 20, 1, -20)"
        )
        if c42 + c43 + c44 < 3 then
            warn("[cLTR] Starlight notification-side patch did not match the downloaded library source")
        end
        local c45
        c4, c45 = c4:gsub(
            'Tab%.Instances%.Button%.Interact%["MouseButton1Click"%]:Connect%(Activate%)',
            'Tab.Instances.Button.Interact["MouseButton1Click"]:Connect(Activate) function Tab:Activate() Activate() end'
        )
        if c45 < 3 then
            warn("[cLTR] Starlight tab-activate patch did not match the downloaded library source")
        end
        local c46
        c4, c46 = c4:gsub(
            "for _, option in ipairs%(NestedElement%.Values%.Options%) do%s+local optioninstance = Resources%.Elements%.DropdownPopup%.List%.Option_TEMPLATE:Clone%(%)",
            'local cLSL = NestedElement.Instances[2].List:FindFirstChildOfClass("UIListLayout") if cLSL then cLSL.SortOrder = Enum.SortOrder.LayoutOrder end for i, option in ipairs(NestedElement.Values.Options) do local optioninstance = Resources.Elements.DropdownPopup.List.Option_TEMPLATE:Clone() optioninstance.LayoutOrder = i'
        )
        if c46 < 1 then
            warn("[cLTR] Starlight dropdown-order patch did not match the downloaded library source")
        end
        c4 = c4:gsub(
            "local function Activate%(%)",
            'local function Activate() if not Starlight.Window or type(Starlight.Window.TabSections) ~= "table" then return end'
        )
        return c4
    end

    local c47
    do
        local c1, c4 = pcall(function()
            return loadstring(
                c21(
                    c13(
                        "https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/Gen1/Source.lua",
                        "Starlight Interface Suite",
                        "starlight_g1_v3"
                    )
                )
            )()
        end)
        if c1 and typeof(c4) == "table" then
            c47 = c4
        end
    end
    if not c47 then
        local c1, c4 = pcall(function()
            return loadstring(
                c21(
                    c13(
                        "https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/master/Source.lua",
                        "Starlight Interface Suite",
                        "starlight_m_v3"
                    )
                )
            )()
        end)
        if c1 and typeof(c4) == "table" then
            c47 = c4
        end
    end
    if not c47 then
        if c12 then
            error(
                "[cLTR] Starlight could not be loaded -- the executor keeps serving an outdated copy - delete the TrainingCalc cache folder, rejoin the game, then re-execute",
                0
            )
        end
        error("[cLTR] Starlight could not be loaded - check your internet connection and re-execute", 0)
    end
    if getgenv().cLTR_State ~= c5 then
        pcall(c47.Destroy, c47)
        return
    end
    c5.lib = c47
    c47.WindowKeybind = "F2"

    pcall(function()
        local c1 = c47.Instance
        local c4 = c1 and c1:FindFirstChild("MainWindow")
        local c15 = c4 and c4:FindFirstChild("Content")
        local c18 = c15 and c15:FindFirstChild("ContentMain")
        local c19 = c18 and c18:FindFirstChild("Elements")
        local c20 = c19 and c19:FindFirstChild("HomeTab")
        if c20 then
            c20:Destroy()
        end
    end)

    local c48 = {
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
    c48.m = { million = 1e6, billion = 1e9, trillion = 1e12 }
    for c3, c1 in ipairs(c48) do
        c48.m[c1[1]] = c1[2]
        c48.m[string.lower(c1[1])] = c1[2]
    end

    local function c49(c1)
        c1 = tonumber(c1)
        if not c1 then
            return "0"
        end
        local c4 = math.abs(c1)
        for c15 = #c48, 1, -1 do
            local c18 = c48[c15]
            if c4 >= c18[2] then
                return (string.format("%.2f", c1 / c18[2]):gsub("%.?0+$", "")) .. c18[1]
            end
        end
        return tostring(c1)
    end

    local function c50(c1)
        c1 = tostring(c1):gsub("[,%s]", "")
        c1 = c1:gsub("^[xX]", "")
        local c4 = tonumber(c1)
        if c4 then
            return c4
        end
        local c15, c18 = string.match(c1, "^([%d%.]+)(%a+)$")
        local c19 = c15 and tonumber(c15)
        local c20 = c18 and c48.m[string.lower(c18)]
        if c19 and c20 then
            return c19 * c20
        end
        return nil
    end

    local function c51(c1)
        c1 = tonumber(c1)
        if not c1 or c1 ~= c1 then
            return "0d 0h 0m"
        end
        if c1 == math.huge or c1 <= -1e18 then
            return "Never"
        end
        if c1 < 0 then
            c1 = 0
        end
        local c4 = math.floor(c1 / 8.64e4)
        if c4 >= 1e6 then
            return c49(c4) .. " days"
        end
        local c15 = math.floor((c1 % 8.64e4) / 3600)
        local c18 = math.floor((c1 % 3600) / 60)
        return string.format("%.0fd %.0fh %.0fm", c4, c15, c18)
    end

    local function c52(c1, c4)
        return c1 .. " -- " .. c49(c50(c4) or 0)
    end

    local c53 = {
        FS = {
            { name = "TrainingArea_2", req = "0e0", multi = "x1e1" },
            { name = "TrainingArea_3", req = "1e6", multi = "x1e2" },
            { name = "StarFSTraining1", req = "1e9", multi = "x2e3" },
            { name = "StarFSTraining2", req = "1e11", multi = "x4e4" },
            { name = "StarFSTraining3", req = "1e13", multi = "x8e5" },
            { name = "AFK_FS_1", req = "1e15", multi = "x6e6" },
            { name = "AFK_FS_2", req = "1e17", multi = "x3e8" },
            { name = "AFK_FS_3", req = "1.5e19", multi = "x2.1e10" },
            { name = "AFK_FS_4", req = "2.5e21", multi = "x2.308e12" },
            { name = "AFK_FS_5", req = "1e24", multi = "x3.475e14" },
            { name = "AFK_FS_6", req = "5e26", multi = "x5.2e16" },
            { name = "AFK_FS_7", req = "2.5e29", multi = "x7.8e18" },
            { name = "AFK_FS_8", req = "1.5e32", multi = "?" },
            { name = "AFK_FS_9", req = "5.5e34", multi = "?" },
            { name = "AFK_FS_10", req = "3e37", multi = "?" },
            { name = "AFK_FS_11", req = "1.1e40", multi = "?" },
        },
        BT = {
            { name = "Water", req = "5e0", min = "5e0", multi = "x5e0" },
            { name = "FireBathTouchPart", req = "5e2", min = "5e2", multi = "x1e1" },
            { name = "IcePart", req = "5e3", min = "5e3", multi = "x2e1" },
            { name = "TornadoTouchPart", req = "5e4", min = "5e4", multi = "x5e1" },
            { name = "LavaPart", req = "5e5", min = "5e5", multi = "x1e2" },
            { name = "GreenFirePart", req = "5e7", min = "5e7", multi = "x2e3" },
            { name = "AcidPart", req = "5e9", min = "5e9", multi = "x4e4" },
            { name = "LavaPart2", req = "5e11", min = "5e11", multi = "x8e5" },
            { name = "AFK_BT_1", req = "7.383e12", min = "7.383e12", multi = "x6e6" },
            { name = "AFK_BT_2", req = "6.55e14", min = "6.55e14", multi = "x1.8e8" },
            { name = "AFK_BT_3", req = "6.66e16", min = "6.66e16", multi = "x5.5e9" },
            { name = "AFK_BT_4", req = "5.1e18", min = "5.1e18", multi = "x1.625e11" },
            { name = "AFK_BT_5", req = "4.6e20", min = "4.6e20", multi = "x5e12" },
            { name = "AFK_BT_6", req = "4.005e22", min = "4.005e22", multi = "x1.5e14" },
            { name = "AFK_BT_7", req = "3.55e24", min = "3.55e24", multi = "x4.5e15" },
            { name = "AFK_BT_8", req = "3.14e26", min = "3.14e26", multi = "x1.312e17" },
            { name = "AFK_BT_9", req = "2.778e28", min = "2.778e28", multi = "x3.925e18" },
            { name = "AFK_BT_10", req = "2.473e30", min = "2.473e30", multi = "x1.18e20" },
            { name = "AFK_BT_11", req = "2.175e32", min = "2.175e32", multi = "x3.55e21" },
            { name = "AFK_BT_12", req = "1.95e34", min = "1.95e34", multi = "x1.062e23" },
            { name = "AFK_BT_13", req = "1.7e36", min = "1.7e36", multi = "x3.2e24" },
            { name = "AFK_BT_14", req = "1.55e38", min = "1.55e38", multi = "x9.574e25" },
            { name = "AFK_BT_15", req = "1.356e40", min = "1.356e40", multi = "x2.5e27" },
        },
        MS = {
            { name = "AFK_MS_1", req = "1e14", multi = "x1.3e6" },
            { name = "AFK_MS_2", req = "2.22e15", multi = "x1.69e7" },
            { name = "AFK_MS_3", req = "6e16", multi = "x2.197e8" },
            { name = "AFK_MS_4", req = "1.5e18", multi = "x2.85e9" },
            { name = "AFK_MS_5", req = "4e19", multi = "x3.72e10" },
            { name = "AFK_MS_6", req = "1e21", multi = "x4.824e11" },
            { name = "AFK_MS_7", req = "2.5e22", multi = "x6.274e12" },
            { name = "AFK_MS_8", req = "7.5e23", multi = "x8.15e13" },
            { name = "AFK_MS_9", req = "1.55e25", multi = "x2.12e15" },
            { name = "AFK_MS_10", req = "4e26", multi = "x1.377e16" },
            { name = "AFK_MS_11", req = "1e28", multi = "x1.792e17" },
        },
        JF = {
            { name = "AFK_JF_1", req = "1e14", multi = "x1.7e6" },
            { name = "AFK_JF_2", req = "5e15", multi = "x3.05e7" },
            { name = "AFK_JF_3", req = "1.5e17", multi = "x5.5e8" },
            { name = "AFK_JF_4", req = "5e18", multi = "x9.92e9" },
            { name = "AFK_JF_5", req = "2e20", multi = "?" },
            { name = "AFK_JF_6", req = "1e22", multi = "?" },
            { name = "AFK_JF_7", req = "3e23", multi = "?" },
            { name = "AFK_JF_8", req = "1.5e25", multi = "?" },
            { name = "AFK_JF_9", req = "4e26", multi = "?" },
        },
        PP = {
            { name = "PPTrainingPart1", req = "1e6", multi = "x1e2" },
            { name = "PPTrainingPart2", req = "1e9", multi = "x1e4" },
            { name = "PPTrainingPart3", req = "1e12", multi = "x1e6" },
            { name = "PPTrainingPart4", req = "1e15", multi = "x1e8" },
            { name = "AFK_PP_1", req = "3.33e17", multi = "x2.5e9" },
            { name = "AFK_PP_2", req = "1.11e20", multi = "x2.5e11" },
            { name = "AFK_PP_3", req = "3.33e22", multi = "x2.5e13" },
            { name = "AFK_PP_4", req = "1.11e25", multi = "x2.5e15" },
            { name = "AFK_PP_5", req = "3.36e27", multi = "x2.5e17" },
            { name = "AFK_PP_6", req = "1.11e30", multi = "x2.5e19" },
            { name = "AFK_PP_7", req = "4.44e32", multi = "x2.5e21" },
            { name = "AFK_PP_8", req = "1.11e35", multi = "?" },
            { name = "AFK_PP_9", req = "5.55e37", multi = "?" },
            { name = "AFK_PP_10", req = "2.22e40", multi = "?" },
        },
    }

    local c54 = { "FS", "BT", "MS", "JF", "PP" }

    local c55 = { FS = "1e15", BT = "7.383e12", PP = "3.33e17" }
    local c56 = {}
    for c1, c4 in pairs(c55) do
        for c15, c18 in ipairs(c53[c1]) do
            if c18.req == c4 then
                c56[c1] = c15
                break
            end
        end
    end

    local function c57(c1, c4)
        local c15 = 1
        for c18, c19 in ipairs(c53[c1]) do
            local c20 = c50(c19.req)
            if c20 and c20 <= c4 then
                c15 = c18
            else
                break
            end
        end
        return c15
    end

    local c58 = {
        { name = "1e2 LB", ms = "1e2", jf = "5e3", mm = "x2", jm = "x2" },
        { name = "1e0 TON", ms = "5e3", jf = "2e5", mm = "x5", jm = "x5" },
        { name = "1e1 TON", ms = "5e5", jf = "2e6", mm = "x10", jm = "x10" },
        { name = "1e2 TON", ms = "1e7", jf = "1e7", mm = "x20", jm = "x20" },
        { name = "1e3 TON", ms = "1e8", jf = "2e8", mm = "x150", jm = "x150" },
        { name = "1e4 TON", ms = "1e9", jf = "1e9", mm = "x750", jm = "x750" },
        { name = "1e5 TON", ms = "1e10", jf = "1e10", mm = "x3.5K", jm = "x3.5K" },
        { name = "1e6 TON", ms = "1e11", jf = "1e11", mm = "x18K", jm = "x18K" },
        { name = "1e7 TON", ms = "1e12", jf = "1e12", mm = "x90K", jm = "x90K" },
        { name = "1e9 TON", ms = "1e13", jf = "1e13", mm = "x400K", jm = "x400K" },
        { name = "1e11 TON", ms = "2.56e28", jf = "1.54e28", mm = "x9.32 Qi", jm = "x1.35 Qi" },
        { name = "1e13 TON", ms = "0e0", jf = "6e26", jm = "x21.9 Qi" },
        { name = "1e15 TON", ms = "1.68e32", jf = "2.221e31", mm = "x1.569 Sx", jm = "x436.9 Qi" },
        { name = "1e17 TON", ms = "4.288e33", jf = "8.48e31", mm = "x20.38 Sx", jm = "x7.869 Sx" },
        { name = "1e19 TON", ms = "1.082e34", jf = "3.226e33", mm = "x264.7 Sx", jm = "x141.9 Sx" },
        { name = "1e21 TON", ms = "2.823e36", jf = "1.229e36", mm = "x3.437 Sp", jm = "x2.552 Sp" },
        { name = "1e23 TON", ms = "7.02e37", jf = "4.683e37", mm = "x44.63 Sp", jm = "x45.89 Sp" },
        { name = "1e25 TON", ms = "1.852e39", jf = "1.785e39", mm = "x579.6 Sp", jm = "x825.3 Sp" },
        { name = "1e28 TON", ms = "4.744e39", jf = "6.8e39", mm = "x7.527 Oc", jm = "x14.84 Oc" },
    }
    local c59 = { MS = true, JF = true }

    local function c60(c1)
        local c4 = string.match(c1, "^(%S+)")
        local c15 = c4 and c50(c4)
        if c15 then
            return c1 .. " - " .. c49(c15) .. string.sub(c1, #c4 + 1)
        end
        return c1
    end

    local function c61(c1, c4)
        local c15 = nil
        for c18, c19 in ipairs(c58) do
            local c20 = c50(c19.ms)
            local c62 = c50(c19.jf)
            local c63 = c20 == 0 or (c1 ~= nil and c20 ~= nil and c20 <= c1)
            local c64 = c62 == 0 or (c4 ~= nil and c62 ~= nil and c62 <= c4)
            if c63 and c64 then
                c15 = c18
            end
        end
        return c15
    end

    local c65 = {}

    local function c66(c1)
        if c65[c1] then
            return c65[c1]
        end
        local c4 = {}
        if c59[c1] then
            local c15 = c50(c1 == "MS" and c58[1].ms or c58[1].jf)
            if c15 and c15 > 0 then
                c4[#c4 + 1] = { nm = "No Weight", mu = "x1", bo = false, th = 0 }
            end
            for c18, c19 in ipairs(c58) do
                local c20 = c50(c1 == "MS" and c19.ms or c19.jf)
                if c20 and c20 > 0 then
                    local c62 = c1 == "MS" and c19.mm or c19.jm
                    c4[#c4 + 1] = { nm = c19.name, dn = c60(c19.name), mu = c62 or "?", bo = false, th = c20 }
                end
            end
        end
        for c18, c19 in ipairs(c53[c1]) do
            c4[#c4 + 1] = {
                nm = c19.name,
                mu = c19.multi,
                bo = not c56[c1] or c18 >= c56[c1],
                th = c50(c1 == "BT" and c19.min or c19.req),
            }
        end
        table.sort(c4, function(c15, c18)
            return (c15.th or 0) < (c18.th or 0)
        end)
        c65[c1] = c4
        return c4
    end

    local function c67(c1, c4)
        local c15 = c66(c1)
        local c18 = nil
        for c19 = 1, #c15 do
            local c20 = c15[c19].th
            if c20 and c20 <= c4 then
                c18 = c19
            end
        end
        return c18
    end

    local c68 = "TrainingCalc/" .. c8.Name .. ".json"
    local c69 = {
        hide = false,
        view = 1,
        cat = nil,
        alsm = nil,
        md = {},
        sp = {},
        gn = {},
        st = {},
        mem = {},
        tok = { cur = {}, oth = {} },
        ml = { cur = {}, oth = {}, ov = {}, tg = nil, tm = nil },
        msg = { Farming = "", Tokens = "", Multipliers = "" },
    }
    for c3, c1 in ipairs(c54) do
        c69.md[c1] = false
        c69.sp[c1] = false
        c69.gn[c1] = false
        c69.st[c1] = false
        c69.mem[c1] = { cur = {}, oth = {} }
    end
    c69.md.TK = false
    c69.md.ML = false

    local function c70(c1)
        local c4 = c69.mem[c1]
        if not c4 then
            c4 = { cur = {}, oth = {} }
            c69.mem[c1] = c4
        end
        return c4[c69.md[c1] and "cur" or "oth"]
    end

    local c71
    local c72

    c71 = function()
        if not writefile then
            return
        end
        if isfolder and not isfolder("TrainingCalc") then
            pcall(function()
                makefolder("TrainingCalc")
            end)
        end
        pcall(function()
            writefile(c68, c7:JSONEncode(c69))
        end)
    end

    local c73 = nil
    local function c74()
        if c73 then
            pcall(task.cancel, c73)
        end
        c73 = task.delay(1, function()
            if getgenv().cLTR_State ~= c5 then
                return
            end
            c73 = nil
            c71()
        end)
    end

    c72 = function()
        if not readfile then
            return
        end
        local c1, c4 = pcall(function()
            if isfile and not isfile(c68) then
                return
            end
            return readfile(c68)
        end)
        if not c1 or not c4 then
            return
        end
        local c15, c18 = pcall(function()
            return c7:JSONDecode(c4)
        end)
        if not c15 or type(c18) ~= "table" then
            return
        end

        local function c19(c20, c62, c63)
            local c64 = type(c62) == "table" and c62 or {}
            local c75 = type(c63) == "table" and c63 or {}
            local c76 = c64[c20]
            if c76 == nil then
                c76 = c75[c20]
            end
            return c76
        end

        local function c20(c62, c63)
            local c64 = c69.mem[c62]
            local c75 = type(c63.cur) == "table" and c63.cur or nil
            local c76 = type(c63.oth) == "table" and c63.oth or nil
            c64.cur.pw = tostring(c19("pw", c75, c63) or c19("power", c75, c63) or "")
            c64.oth.pw = tostring(c19("pw", c76, c63) or c19("power", c76, c63) or "")
            c64.cur.ob = tostring(c19("ob", c75, c63) or c19("pobj", c75, c63) or "")
            c64.oth.ob = tostring(c19("ob", c76, c63) or c19("pobj", c76, c63) or "")
            local c77 = tonumber(c19("ar", c75, c63) or c19("area", c75, c63))
            local c78 = tonumber(c19("ar", c76, c63) or c19("area", c76, c63))
            c64.cur.ar = c77 and math.floor(c77) or nil
            c64.oth.ar = c78 and math.floor(c78) or nil
            local c16 = c19("mu", c75, c63) or c19("mult", c75, c63)
            local c79 = c19("mu", c76, c63) or c19("mult", c76, c63)
            c64.cur.mu = c16 ~= nil and tostring(c16) or nil
            c64.oth.mu = c79 ~= nil and tostring(c79) or nil
            c64.cur.mv = tonumber(c19("mv", c75, c63) or c19("val", c75, c63))
            c64.oth.mv = tonumber(c19("mv", c76, c63) or c19("val", c76, c63))
            local c80 = tonumber(c19("wt", c75, c63))
            local c81 = tonumber(c19("wt", c76, c63))
            c64.cur.wt = c80 and math.floor(c80) or nil
            c64.oth.wt = c81 and math.floor(c81) or nil
        end

        local function c62(c63)
            local c64 = type(c63.cur) == "table" and c63.cur or nil
            local c75 = type(c63.oth) == "table" and c63.oth or nil
            if not c64 and not c75 then
                local c76 = { tk = c63.tk or c63.tokens, tp = c63.tp or c63.tpm }
                if c63.mode == "cur" then
                    c64 = c76
                else
                    c75 = c76
                end
            end
            local c77 = { cur = c64, oth = c75 }
            for c78, c16 in pairs(c77) do
                local c79 = c69.tok[c78]
                c79.tk = tostring(c19("tk", c16, c63) or c19("tokens", c16, c63) or "")
                c79.tp = tostring(c19("tp", c16, c63) or c19("tpm", c16, c63) or "")
                c79.ob = tostring(c19("ob", c16, c63) or c19("obj", c16, c63) or "")
                c79.to = tostring(c19("to", c16, c63) or c19("tpo", c16, c63) or "")
                c79.sp = tostring(c19("sp", c16, c63) or c19("spent", c16, c63) or "")
            end
        end

        c69.hide = c18.hide == true
        if type(c18.view) == "number" and c18.view >= 1 and c18.view <= 5 then
            c69.view = math.floor(c18.view)
        end
        if c53[c18.cat] then
            c69.cat = c18.cat
        end
        if typeof(c18.alsm) == "string" and c18.alsm ~= "" then
            c69.alsm = c18.alsm
        end
        local c63 = c18.speed == true
        local c64 = c18.train == true
        local c75 = c18.stay == true
        for c3, c76 in ipairs(c54) do
            if type(c18.md) == "table" then
                c69.md[c76] = c18.md[c76] == true
            end
            if type(c18.sp) == "table" then
                c69.sp[c76] = c18.sp[c76] == true or (c18.sp[c76] == nil and c63)
            else
                c69.sp[c76] = c63
            end
            if type(c18.gn) == "table" then
                c69.gn[c76] = c18.gn[c76] == true or (c18.gn[c76] == nil and c64)
            else
                c69.gn[c76] = c64
            end
            if type(c18.st) == "table" then
                c69.st[c76] = c18.st[c76] == true or (c18.st[c76] == nil and c75)
            else
                c69.st[c76] = c75
            end
            if type(c18.mem) == "table" and type(c18.mem[c76]) == "table" then
                c20(c76, c18.mem[c76])
            end
        end
        if type(c18.md) == "table" then
            c69.md.TK = c18.md.TK == true
            c69.md.ML = c18.md.ML == true
        end
        if type(c18.tok) == "table" then
            c62(c18.tok)
        end
        if type(c18.ml) == "table" then
            for c3, c76 in ipairs(c54) do
                local c77 = (type(c18.ml.cur) == "table" and c18.ml.cur[c76]) or nil
                local c78 = (type(c18.ml.oth) == "table" and c18.ml.oth[c76]) or nil
                if c77 ~= nil then
                    c69.ml.cur[c76] = tostring(c77)
                end
                if c78 ~= nil then
                    c69.ml.oth[c76] = tostring(c78)
                end
            end
            if type(c18.ml.ov) == "table" then
                for c76, c77 in pairs(c18.ml.ov) do
                    if c77 == true then
                        c69.ml.ov[c76] = true
                    end
                end
            end
            local c16 = tonumber(c18.ml.tg)
            if c16 then
                c69.ml.tg = c16
            end
            if c18.ml.tm ~= nil then
                c69.ml.tm = tostring(c18.ml.tm)
            end
        end
        if type(c18.msg) == "table" then
            local function c82(c78)
                c78 = string.lower(tostring(c78))
                return c78:find("couldn", 1, true) ~= nil
                    or c78:find("select ", 1, true) ~= nil
                    or c78:find("enter a valid", 1, true) ~= nil
                    or c78:find("you already", 1, true) ~= nil
                    or c78:find("failed", 1, true) ~= nil
                    or c78:find("skipped", 1, true) ~= nil
                    or c78:find("did not match", 1, true) ~= nil
            end
            for c76, c77 in pairs(c18.msg) do
                local c78 = tostring(c77)
                if c76 == "Farming" or c76 == "Tokens" or c76 == "Multipliers" then
                    c69.msg[c76] = (c78 ~= "" and not c82(c78)) and c78 or ""
                end
            end
        end
    end

    c72()

    local c83 = c69.view
    local c84 = c47:CreateWindow({
        Name = "cLTR Calculators",
        Subtitle = "Starlight",
        LoadingEnabled = false,
        InterfaceAdvertisingPrompts = false,
        NotifyOnCallbackError = true,
        FileSettings = { ConfigFolder = "cLTR_Starlight" },
    })

    if getgenv().cLTR_State ~= c5 then
        return
    end
    assert(
        typeof(c84) == "table" and typeof(c84.TabSections) == "table",
        "[cLTR] Starlight window did not initialize"
    )
    c47.Window = c84

    pcall(function()
        c84.Instance.Visible = false
        c47.Instance.Drag.Visible = false
        if c69.hide then
            c47.Minimized = true
        end
    end)

    local c85 = {
        FS = Color3.fromRGB(255, 82, 82),
        BT = Color3.fromRGB(255, 148, 40),
        MS = Color3.fromRGB(88, 235, 128),
        JF = Color3.fromRGB(255, 224, 92),
        PP = Color3.fromRGB(190, 122, 255),
    }
    local c86 = {
        FS = "Fist Strength",
        BT = "Body Toughness",
        MS = "Movement Speed",
        JF = "Jump Force",
        PP = "Psychic Power",
    }
    local c87 = {}
    for c1, c4 in pairs(c85) do
        c87[c1] = "rgb("
            .. math.floor(c4.R * 255 + 0.5)
            .. ","
            .. math.floor(c4.G * 255 + 0.5)
            .. ","
            .. math.floor(c4.B * 255 + 0.5)
            .. ")"
    end
    local c88 = Color3.fromRGB(255, 221, 0)
    local c89 = "rgb(255,221,0)"
    local c90 = Color3.fromRGB(255, 140, 0)
    local c91 = Color3.fromRGB(255, 198, 88)
    local c92 = "rgb(255,198,88)"
    local c93 = "rgb(255,99,163)"
    local c94 = "rgb(64,255,218)"
    local c95 = "rgb(96,170,255)"
    local c96 = "rgb(255,214,90)"

    local function c97(c1)
        local c4 = tostring(c1):gsub('<font color="rgb%([%d,]+%)">', "")
        c4 = c4:gsub("</font>", "")
        return c4
    end

    local function c98(c1)
        if type(c1) ~= "string" or c1 == "" then
            return nil
        end
        for c3, c4 in ipairs(c54) do
            if c1:find(c86[c4], 1, true) then
                return c4
            end
        end
        for c3, c4 in ipairs(c54) do
            if c1:sub(1, #c4 + 1) == c4 .. " " then
                return c4
            end
        end
        return nil
    end

    local function c99(c1)
        local c4 = tostring(c1)
        for c3, c15 in ipairs(c54) do
            c4 = c4:gsub("%f[%w]" .. c15 .. "%f[%W]", '<font color="' .. c87[c15] .. '">' .. c15 .. "</font>")
        end
        c4 = c4:gsub("Main Quest (%d+)%+", '<font color="' .. c92 .. '">Main Quest %1+</font>')
        c4 = c4:gsub("%f[%w]LV(%d+)", '<font color="' .. c92 .. '">LV%1</font>')
        c4 = c4:gsub("%f[%w]T(%d+)%f[%W]", '<font color="' .. c93 .. '">T%1</font>')
        c4 = c4:gsub("{Passive}", '<i><font color="rgb(150,153,163)">{Passive}</font></i>')
        return c4
    end

    local function c100(c1)
        local c4 = "\1" .. tostring(c1)
        local c15 = '<font color="' .. c94 .. '">'
        local c18 = '<font color="' .. c95 .. '">'
        c4 = c4:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", function(c19, c20)
            if c20:match("^[%d%.]+e[+%-]?%d+$") then
                return c19 .. c18 .. c20 .. "</font>"
            end
            return c19 .. c15 .. c20 .. "</font>"
        end)
        return (c4:gsub("\1", ""))
    end

    local function c101(c1)
        local c4 = "\1" .. tostring(c1)
        local c15 = '<font color="' .. c89 .. '">'
        local c18 = '<font color="' .. c96 .. '">'
        local c19 = '<font color="rgb(168,175,228)">'
        local c20 = {}
        local c62 = {}
        local function c63(c64)
            c20[#c20 + 1] = c64
            local c75 = ""
            local c76 = #c20
            while c76 > 0 do
                c75 = string.char(97 + (c76 - 1) % 26) .. c75
                c76 = math.floor((c76 - 1) / 26)
            end
            return "\2" .. c75 .. "\3"
        end
        local function c77(c64)
            c62[#c62 + 1] = c64
            local c75 = ""
            local c76 = #c62
            while c76 > 0 do
                c75 = string.char(97 + (c76 - 1) % 26) .. c75
                c76 = math.floor((c76 - 1) / 26)
            end
            return "\4" .. c75 .. "\5"
        end
        c4 = c4:gsub("%f[%d]%d+d %d+h %d+m", c63)
        c4 = c4:gsub("%f[%d][%d%.]+%a* days", c63)
        c4 = c4:gsub("%f[%d]%d+ min", c63)
        c4 = c4:gsub("Never", c63)
        c4 = c4:gsub("Token objective", c77)
        c4 = c4:gsub("TPM objective", c77)
        c4 = c4:gsub("Time spent", c77)
        c4 = c4:gsub("Current stats", c77)
        c4 = c4:gsub("Remaining:", c77)
        c4 = c4:gsub("Estimated time:", c77)
        c4 = c4:gsub("TPM on arrival:", c77)
        c4 = c4:gsub("TPM to gain:", c77)
        c4 = c4:gsub("TPM at end:", c77)
        c4 = c4:gsub("Tokens by then:", c77)
        c4 = c4:gsub("Tokens gained:", c77)
        c4 = c4:gsub("Tokens at end:", c77)
        c4 = c4:gsub("Next %+1 TPM in", c77)
        c4 = c4:gsub("Tokens:", c77)
        c4 = c4:gsub("TPM:", c77)
        c4 = c4:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", "%1" .. c15 .. "%2</font>")
        c4 = c4:gsub("\2(%a+)\3", function(c64)
            local c75 = 0
            for c76 = 1, #c64 do
                c75 = c75 * 26 + string.byte(c64, c76) - 96
            end
            return c18 .. (c20[c75] or "") .. "</font>"
        end)
        c4 = c4:gsub("\4(%a+)\5", function(c64)
            local c75 = 0
            for c76 = 1, #c64 do
                c75 = c75 * 26 + string.byte(c64, c76) - 96
            end
            return c19 .. (c62[c75] or "") .. "</font>"
        end)
        return (c4:gsub("\1", ""))
    end

    local function c102(c1)
        local c4 = {}
        for c15 in tostring(c1):gmatch("[^\n]+") do
            local c19 = c15
            for c3, c18 in ipairs(c54) do
                c19 = c19:gsub("^" .. c18 .. ":", '<font color="' .. c87[c18] .. '">' .. c18 .. "</font>:")
            end
            c4[#c4 + 1] = c19
        end
        local c20 = table.concat(c4, "\n")
        c20 = c20:gsub("x(%d[%d%.]*%a*)", '<font color="' .. c94 .. '">x%1</font>')
        c20 = c20:gsub("%((%d+) (upgrades?)%)", '<font color="' .. c93 .. '">(%1 %2)</font>')
        c20 = c20:gsub("([^%s]+) Tokens", '<font color="' .. c89 .. '">%1 Tokens</font>')
        return c20
    end

    local function c103(c1)
        local c4 = "\1" .. tostring(c1)
        local c15 = '<font color="' .. c94 .. '">'
        local c18 = '<font color="' .. c96 .. '">'
        local c19 = {}
        local function c20(c62)
            c19[#c19 + 1] = c62
            local c63 = ""
            local c64 = #c19
            while c64 > 0 do
                c63 = string.char(97 + (c64 - 1) % 26) .. c63
                c64 = math.floor((c64 - 1) / 26)
            end
            return "\2" .. c63 .. "\3"
        end
        c4 = c4:gsub("%d%d?%d?d %d%d?%d?h %d%d?%d?m", c20)
        c4 = c4:gsub("%f[%d][%d%.]+%a* days", c20)
        c4 = c4:gsub("Never", c20)
        c4 = c4:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", "%1" .. c15 .. "%2</font>")
        c4 = c4:gsub("\2(%a+)\3", function(c62)
            local c63 = 0
            for c64 = 1, #c62 do
                c63 = c63 * 26 + string.byte(c62, c64) - 96
            end
            return c18 .. (c19[c63] or "") .. "</font>"
        end)
        c4 = c4:gsub("\1", "")
        local c75 = {}
        for c76 in c4:gmatch("[^\n]+") do
            local c77, c78 = c76:match("^([%a%s]+):%s*(.+)$")
            if c77 and #c77 > 3 then
                c75[#c75 + 1] = '<font color="rgb(168,175,228)">' .. c77 .. ":</font> " .. c78
            else
                c75[#c75 + 1] = c76
            end
        end
        return table.concat(c75, "\n")
    end

    local c104 = c84:CreateTabSection("cLTR")
    local c105 = {
        c104:CreateTab({ Name = "Farming", Columns = 2 }, "farming"),
        c104:CreateTab({ Name = "Tokens", Columns = 2 }, "tokens"),
        c104:CreateTab({ Name = "Multipliers", Columns = 2 }, "multipliers"),
        c104:CreateTab({ Name = "Wiki", Columns = 2 }, "wiki"),
        c104:CreateTab({ Name = "Settings", Columns = 2 }, "settings"),
    }
    local c106 = { "Farming", "Tokens", "Multipliers", "Wiki", "Settings" }

    local c107 = true
    local c108 = 0
    local c109 = false
    local c110

    local c111
    c111 = function(c1)
        c1 = (c1 or 0) + 1
        local c4 = 0
        for c15, c18 in ipairs(c105) do
            pcall(function()
                local c19 = c18.Instances and c18.Instances.Button and c18.Instances.Button.Interact
                if c19 and not c19:GetAttribute("cViewT") then
                    c19:SetAttribute("cViewT", c15)
                    c19.MouseButton1Click:Connect(function()
                        if getgenv().cLTR_State ~= c5 then
                            return
                        end
                        c69.view = c15
                        c83 = c15
                        c108 = os.clock()
                        c109 = true
                        c107 = false
                        c74()
                        task.defer(function()
                            if getgenv().cLTR_State == c5 and c69.view == c15 and c110 then
                                c110(c18)
                            end
                        end)
                        task.delay(0.3, function()
                            if getgenv().cLTR_State == c5 and c69.view == c15 and c110 then
                                c110(c18)
                            end
                        end)
                    end)
                    c4 = c4 + 1
                end
            end)
        end
        if c4 < #c105 and c1 < 12 then
            task.delay(0.25, function()
                c111(c1)
            end)
        end
    end
    c111()

    local c112 = false

    local function c113(c1)
        local c4 = c1 and c1.Values
        if not c4 then
            return nil
        end
        if c4.Options ~= nil or c4.CurrentOption ~= nil then
            local c15 = c4.CurrentOption
            if type(c15) == "table" then
                return c15[1]
            end
            return c15
        end
        return c4.CurrentValue
    end

    local c114 = {}

    local function c115(c1, c4, c15)
        if not c1 then
            return
        end
        local c18 = c114[c1]
        local c19 = c15
        local c20 = ""
        if type(c4) == "table" then
            for c62 = 1, #c4 do
                c20 = c20 .. "\1" .. tostring(c4[c62])
            end
        else
            c20 = tostring(c4)
        end
        if c18 and c18[2] == c19 and c18[3] == c20 and c113(c1) == c19 then
            return
        end
        c114[c1] = { c4, c19, c20, os.clock() }
        c1:Set({ Options = c4, CurrentOption = c15 })
    end

    local function c116(c1)
        local c4 = c1 and c114[c1]
        return c4 ~= nil and c4[4] ~= nil and os.clock() - c4[4] < 0.15
    end

    local function c117(c1, c4)
        if not c1 then
            return
        end
        local c15 = tostring(c4)
        local c18 = c114[c1]
        if c18 and c18[2] == "v" and c18[1] == c15 and c113(c1) == c4 then
            return
        end
        c114[c1] = { c15, "v" }
        c1:Set({ CurrentValue = c4 })
    end

    local function c118(c1, c4)
        if not c1 then
            return
        end
        local c15 = tostring(c4)
        local c18 = c114[c1]
        if c18 and c18[2] == "p" and c18[1] == c15 then
            return
        end
        c114[c1] = { c15, "p" }
        c1:Set({ Content = c4 })
        pcall(function()
            local c19 = c1.Instance and c1.Instance:FindFirstChild("Content")
            if c19 then
                c19.RichText = true
            end
        end)
    end

    local function c119(c1)
        local c4 = c1 and c1.Instance
        if not c4 then
            return false
        end
        local c15 = c4:FindFirstChild("PART_Backdrop")
        local c18 = c15 and c15:FindFirstChild("PART_Input")
        return c18 ~= nil and c18:IsFocused()
    end

    local function c120(c1)
        local c4 = c1 and c1.Instance
        if not c4 then
            return
        end
        local c15 = c4:FindFirstChild("PART_Backdrop")
        local c18 = c15 and c15:FindFirstChild("PART_Input")
        if not c18 then
            return
        end
        pcall(function()
            local c16 = game:GetService("TextService")
            local function c121(c14)
                local c79, c80 = pcall(function()
                    return c16:GetTextSize(c14, c18.TextSize, Enum.Font.Gotham, Vector2.new(10000, 10000)).X
                end)
                if c79 and c80 then
                    return c80
                end
                local c81 = c18.Text
                c18.Text = c14
                local c122 = c18.TextBounds.X
                c18.Text = c81
                return c122
            end
            local c19 = c18.Text
            local c20 = c19 ~= "" and c121(c19) or 0
            if c18.PlaceholderText ~= "" then
                c20 = math.max(c20, c121(c18.PlaceholderText))
            end
            local c62 = c20 + 30
            if c62 < 100 then
                c62 = 100
            end
            local c63 = c15.Parent and c15.Parent.AbsoluteSize.X or 0
            local c64 = c4:FindFirstChild("Header")
            local c75 = c64 and math.ceil(c64.TextBounds.X) or 0
            if c63 > 140 then
                local c76 = math.max(100, c63 - c75 - 20)
                if c62 > c76 then
                    c62 = c76
                end
            end
            if math.abs(c15.Size.X.Offset - c62) > 1 then
                c15.Size = UDim2.new(0, c62, 0, c15.Size.Y.Offset)
                c18.Size = UDim2.new(0, math.max(1, c62 - 30), 1, 0)
            end
        end)
    end

    local c123 = {}
    local c124 = nil
    local c125 = "rgb(212,186,106)"
    local c126 = {
        Info = "rgb(200,205,215)",
        Farming = "rgb(64,255,218)",
        Tokens = "rgb(255,140,0)",
        Multipliers = "rgb(80,218,226)",
    }
    local function c127(c1, c4)
        local c15 = tostring(c1)
        local c18 = "rgb(168,175,228)"
        if c4 then
            local c19 = c15:lower()
            if
                c19:find("couldn", 1, true)
                or c19:find("select ", 1, true)
                or c19:find("enter a valid", 1, true)
                or c19:find("you already", 1, true)
                or c19:find("failed", 1, true)
                or c19:find("skipped", 1, true)
                or c19:find("did not match", 1, true)
            then
                c18 = "rgb(255,106,97)"
            else
                c18 = "rgb(255,214,90)"
            end
        end
        local c20 = c4 or "Info"
        table.insert(
            c123,
            1,
            '<font color="'
                .. c125
                .. '">['
                .. os.date("%H:%M:%S")
                .. "]</font> "
                .. '<font color="'
                .. (c126[c20] or c126.Info)
                .. '">['
                .. c20
                .. "]</font> "
                .. '<font color="'
                .. c18
                .. '">'
                .. c15
                .. "</font>"
        )
        if #c123 > 10 then
            table.remove(c123)
        end
        if c124 then
            c118(c124, table.concat(c123, "\n"))
        end
    end

    local c128 = {}
    local function c129(c1, c4)
        if getgenv().cLTR_State ~= c5 then
            return
        end
        if c1 == "Farming" and c4 ~= "" then
            c4 = c103(c4)
        end
        c69.msg[c1] = c4
        local c15 = c128[c1]
        if c15 then
            c118(c15, c4 ~= "" and c4 or "Result appears here.")
        end
        if c4 ~= "" and not string.find(c4, "\n", 1, true) then
            c127(c97(c4), c1)
        end
        c74()
    end

    local c130 = {}
    local function c131()
        local c1 = {}
        if not c10 then
            return c1
        end
        local c4 = c130[1] and c130[1].Parent and c130[1] or c10:FindFirstChild("ScreenGui")
        if not (c4 and c4.Parent) then
            c4 = c130[6]
            if not (c4 and c4.Parent) then
                c4 = c10:FindFirstChild("ScreenGui", true) or c10
                c130[6] = c4
            end
        end
        c130[1] = c4
        local c15 = c130[2] and c130[2].Parent and c130[2]
            or (c4 and (c4:FindFirstChild("MenuFrame") or c4:FindFirstChild("MenuFrame", true)))
        c130[2] = c15
        local c18 = c130[3] and c130[3].Parent and c130[3]
            or (c15 and (c15:FindFirstChild("InfoFrame") or c15:FindFirstChild("InfoFrame", true)))
        c130[3] = c18
        local c122 = c18 or c4
        local c19 = c130[7]
        if not c19 then
            c19 = {}
            c130[7] = c19
        end
        if c122 then
            for c3, c20 in ipairs(c54) do
                local c62 = {}
                local c63 = c19[c20]
                if typeof(c63) == "Instance" and not c63.Parent then
                    c63 = nil
                end
                if not c63 and c19[c20] == false and os.clock() - (c19[c20 .. "T"] or 0) > 10 then
                    c19[c20] = nil
                end
                if not c63 and c19[c20] ~= false then
                    c63 = c122:FindFirstChild(c20 .. "Txt") or c122:FindFirstChild(c20 .. "Txt", true)
                    if not c63 and c4 and c122 ~= c4 then
                        c63 = c4:FindFirstChild(c20 .. "Txt", true)
                    end
                    c19[c20] = c63 or false
                    c19[c20 .. "T"] = os.clock()
                end
                if c63 and c63.Text and c63.Text ~= "" then
                    local c64 = string.match(c63.Text, ".*:%s*(.-)%s*$")
                        or string.match(c63.Text, "([%d%.]+%a+)%s*$")
                    if c64 and c50(c64) then
                        c62.v = c64
                    end
                end
                local c75 = c19[c20 .. "M"]
                if typeof(c75) == "Instance" and not c75.Parent then
                    c75 = nil
                end
                if not c75 and c19[c20 .. "M"] == false and os.clock() - (c19[c20 .. "MT"] or 0) > 10 then
                    c19[c20 .. "M"] = nil
                end
                if not c75 and c19[c20 .. "M"] ~= false then
                    c75 = c122:FindFirstChild(c20 .. "MultiplierTxt")
                        or c122:FindFirstChild(c20 .. "MultiplierTxt", true)
                    if not c75 and c4 and c122 ~= c4 then
                        c75 = c4:FindFirstChild(c20 .. "MultiplierTxt", true)
                    end
                    c19[c20 .. "M"] = c75 or false
                    c19[c20 .. "MT"] = os.clock()
                end
                if c75 and c75.Text and c75.Text ~= "" then
                    local c76 = c50(c75.Text)
                    if c76 then
                        c62.m = c76
                    end
                end
                if c62.v or c62.m then
                    c1[c20] = c62
                end
            end
        end
        return c1
    end

    local function c132()
        local c1, c4, c15 = nil, nil, nil
        if not c10 then
            return c1, c4, c15
        end
        local c18 = c130[1] and c130[1].Parent and c130[1] or c10:FindFirstChild("ScreenGui")
        c130[1] = c18
        if c18 then
            local c19 = c130[2] and c130[2].Parent and c130[2] or c18:FindFirstChild("MenuFrame")
            c130[2] = c19
            local c20 = c130[4] and c130[4].Parent and c130[4] or (c19 and c19:FindFirstChild("SpecialFrame"))
            c130[4] = c20
            if c20 then
                local c62 = c20:FindFirstChild("CurrentTokenEarning_Txt")
                if c62 and c62.Text and c62.Text ~= "" then
                    c4 = c50(c62.Text)
                end
                local c63 = c20:FindFirstChild("NextTokenEarningUpgrade_Txt")
                if c63 and c63.Text and c63.Text ~= "" then
                    local c64 = string.match(c63.Text, "(%d+)%s*[mM]in") or string.match(c63.Text, "(%d+)")
                    if c64 then
                        c15 = math.clamp(tonumber(c64), 1, 240)
                    end
                end
            end
            local c75 = c130[5] and c130[5].Parent and c130[5] or c18:FindFirstChild("CurrentGemImgBtn")
            c130[5] = c75
            local c76 = c75 and c75:FindFirstChild("AmountTxtBtn")
            if c76 and c76.Text and c76.Text ~= "" then
                c1 = c50(c76.Text)
            end
        end
        return c1, c4, c15
    end

    local c133 = c105[1]:CreateGroupbox({ Name = "Setup", Column = 1 }, "cF0")
    local c134 = c105[1]:CreateGroupbox({ Name = "Mode", Column = 1 }, "cF1")
    local c135 = c105[1]:CreateGroupbox({ Name = "Calculate", Column = 2 }, "cF2")

    local c136, c137, c138, c139, c140, c141, c142, c143
    local c144, c145, c146, c147, c148
    local c149
    local c150
    local c151 = false
    local c152 = {}
    local c153 = {}
    local c154 = {}
    local c155 = {}

    local c156 = {}
    for c1 = 0, 37 do
        local c4 = 2 ^ c1
        local c15 = c49(c4)
        c156[#c156 + 1] = c15
        c154[c15] = c4
    end

    local function c157(c1)
        local c4 = {}
        for c15, c18 in ipairs(c53[c1]) do
            c4[#c4 + 1] = c52(c18.name, c18.req)
        end
        return c4
    end

    local function c158()
        local c1 = {}
        for c3, c4 in ipairs(c58) do
            c1[#c1 + 1] = c4.name
                .. " -- "
                .. c49(c50(c4.ms) or 0)
                .. " MS / "
                .. c49(c50(c4.jf) or 0)
                .. " JF"
        end
        return c1
    end

    local function c159(c1)
        c152 = c157(c1)
        c115(c138, c152, nil)
        if c59[c1] then
            c153 = c158()
            c115(c140, c153, nil)
        else
            c153 = {}
            c115(c140, { "Not used" }, "Not used")
        end
    end

    local function c160(c1)
        local c4 = c70(c1)
        if not c119(c142) then
            c117(c142, c4.pw ~= "" and c4.pw or "")
        end
        if not c119(c143) then
            c117(c143, c4.ob or "")
        end
        if c4.ar and c53[c1][c4.ar] then
            c115(c138, c152, c152[c4.ar])
        else
            c115(c138, c152, nil)
        end
        if c59[c1] then
            if c4.wt and c58[c4.wt] then
                c115(c140, c153, c153[c4.wt])
            else
                c115(c140, c153, nil)
            end
        end
        if c4.mu and c154[c4.mu] then
            c115(c141, c156, c4.mu)
        elseif c4.mv then
            local c15 = c49(c4.mv)
            if c154[c15] then
                c115(c141, c156, c15)
            end
        end
        c151 = true
        c117(c146, c69.sp[c1])
        c117(c147, c69.gn[c1])
        c117(c148, c69.st[c1])
        c117(c144, c69.md[c1])
        c117(c145, not c69.md[c1])
        c151 = false
    end

    local c161, c162 = 0, nil
    local function c163(c1)
        c161 = os.clock()
        c162 = c1
        c159(c1)
        c160(c1)
        if c69.md[c1] then
            c150(c1, false)
        end
    end

    local function c164(c1)
        local c4 = (c1 and c85[c1]) or Color3.fromRGB(235, 236, 242)
        pcall(function()
            local c15 = c137 and c137.Instance and c137.Instance:FindFirstChild("Header")
            if c15 then
                c15.TextColor3 = c4
            end
        end)
        pcall(function()
            local c15 = c142 and c142.Instance and c142.Instance:FindFirstChild("Header")
            if c15 then
                c15.TextColor3 = c4
            end
        end)
        pcall(function()
            local c15 = c143 and c143.Instance and c143.Instance:FindFirstChild("Header")
            if c15 then
                c15.TextColor3 = c4
            end
        end)
        pcall(function()
            local c15 = c142 and c142.Instance and c142.Instance:FindFirstChild("PART_Backdrop")
            local c18 = c15 and c15:FindFirstChild("PART_Input")
            if c18 then
                c18.TextColor3 = Color3.fromRGB(64, 255, 218)
            end
        end)
        pcall(function()
            local c15 = c143 and c143.Instance and c143.Instance:FindFirstChild("PART_Backdrop")
            local c18 = c15 and c15:FindFirstChild("PART_Input")
            if c18 then
                c18.TextColor3 = Color3.fromRGB(96, 170, 255)
            end
        end)
    end

    local function c165(c1)
        pcall(function()
            local c4 = c139 and c139.Instance
            if c4 and c4.Parent then
                c4.Visible = (c1 == "MS" or c1 == "JF")
            end
        end)
    end

    c137 = c133:CreateLabel({ Name = "Category" }, "cFcat_l")
    c136 = c137:AddDropdown({
        Options = c54,
        Placeholder = "Select",
        Callback = function(c1)
            if not c112 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c53[c1] then
                return
            end
            c69.cat = c1
            c164(c1)
            c165(c1)
            if c1 == c162 and os.clock() - c161 < 1 then
                c74()
                return
            end
            c163(c1)
            c118(c149, c69.msg.Farming ~= "" and c69.msg.Farming or "Result appears here.")
            c74()
        end,
    }, "cFcat")

    c138 = c133:CreateLabel({ Name = "Area" }, "cFare_l"):AddDropdown({
        Options = { "Not selected" },
        Placeholder = "Select",
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c116(c138) then
                return
            end
            local c15 = c70(c4)
            local c18 = c1 and table.find(c152, c1) or nil
            c15.ar = c18
            c74()
        end,
    }, "cFare")

    c139 = c133:CreateLabel({ Name = "Weight (MS / JF)" }, "cFwgt_l")
    c140 = c139:AddDropdown({
        Options = { "Not used" },
        Placeholder = "Select",
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 or not c59[c4] then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c116(c140) then
                return
            end
            local c15 = c70(c4)
            c15.wt = c1 and table.find(c153, c1) or nil
            c74()
        end,
    }, "cFwgt")

    c141 = c133:CreateLabel({ Name = "Multiplier" }, "cFmul_l"):AddDropdown({
        Options = c156,
        Placeholder = "Select",
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c116(c141) then
                return
            end
            local c15 = c70(c4)
            if c1 then
                c15.mu = c1
                c15.mv = c154[c1] or c50(c1)
            else
                c15.mu = nil
                c15.mv = nil
            end
            c74()
        end,
    }, "cFmul")

    c142 = c133:CreateInput({
        Name = "Current Power",
        PlaceholderText = "Current power",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c70(c4).pw = tostring(c1)
            c74()
        end,
    }, "cFpw")

    c143 = c133:CreateInput({
        Name = "Power Objective",
        PlaceholderText = "Power objective",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c70(c4).ob = tostring(c1)
            c74()
        end,
    }, "cFob")

    c144 = c134:CreateToggle({
        Name = "Use Current Stats",
        Tooltip = "Live-syncs power, area and weight from the game GUI for this category.",
        CurrentValue = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if c151 then
                return
            end
            if not c4 then
                if c1 then
                    c151 = true
                    c117(c144, false)
                    c151 = false
                    c129("Farming", "Select a category first.")
                end
                return
            end
            c69.md[c4] = c1
            c151 = true
            c117(c145, not c1)
            c151 = false
            if c1 then
                c150(c4, true)
            else
                c160(c4)
            end
            c74()
        end,
    }, "cFcur")

    c145 = c134:CreateToggle({
        Name = "Use Other Stats",
        Tooltip = "Manual mode -- type your stats by hand.",
        CurrentValue = true,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if c151 then
                return
            end
            if not c4 then
                if c1 then
                    c151 = true
                    c117(c145, false)
                    c151 = false
                    c129("Farming", "Select a category first.")
                end
                return
            end
            c69.md[c4] = not c1
            c151 = true
            c117(c144, not c1)
            c151 = false
            if c1 then
                c160(c4)
            else
                c150(c4, true)
            end
            c74()
        end,
    }, "cFoth")

    c146 = c134:CreateToggle({
        Name = "Speed 2x",
        Tooltip = "Halves the time in boostable areas.",
        CurrentValue = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c69.sp[c4] = c1
            c74()
        end,
    }, "cFsp")

    c147 = c134:CreateToggle({
        Name = "Training 2x",
        Tooltip = "Doubles the gain in boostable areas.",
        CurrentValue = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c69.gn[c4] = c1
            c74()
        end,
    }, "cFgn")

    c148 = c134:CreateToggle({
        Name = "Stay on this area",
        Tooltip = "Ignores the next area and calculates with the selected one only.",
        CurrentValue = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.cat
            if not c4 then
                return
            end
            c69.st[c4] = c1
            c74()
        end,
    }, "cFst")

    c150 = function(c1, c4)
        local c15 = c131()
        local c18 = false
        local c19 = c70(c1)
        local c20 = c15[c1]
        if c20 then
            if c20.v then
                c19.pw = c20.v
            end
            if c20.m then
                c19.mu = tostring(c20.m)
                c19.mv = c20.m
            end
        end
        if c69.md[c1] and not c69.st[c1] then
            local c62 = c50(c19.pw)
            if c62 and c62 >= 0 then
                if c59[c1] and c62 < c50(c53[c1][1].req) then
                    if not c19.ar then
                        local c63, c64
                        if c1 == "MS" then
                            c63 = c62
                            c64 = c15.JF and c15.JF.v and c50(c15.JF.v) or nil
                        else
                            c64 = c62
                            c63 = c15.MS and c15.MS.v and c50(c15.MS.v) or nil
                        end
                        if c63 and c64 then
                            local c75 = c61(c63, c64)
                            if c75 and (not c19.wt or c75 > c19.wt or not c155[c1]) then
                                c19.wt = c75
                                c18 = true
                            end
                        end
                    end
                else
                    local c76 = c57(c1, c62)
                    if not c19.ar or c76 > c19.ar or not c155[c1] then
                        c19.ar = c76
                        c18 = true
                    end
                    if c19.wt then
                        c19.wt = nil
                        c18 = true
                    end
                end
                c155[c1] = true
            end
        end
        if not c119(c142) and c113(c142) ~= (c19.pw ~= "" and c19.pw or "") then
            c117(c142, c19.pw ~= "" and c19.pw or "")
        end
        if not c119(c143) and c113(c143) ~= (c19.ob or "") then
            c117(c143, c19.ob or "")
        end
        c115(c138, c152, c19.ar and c53[c1][c19.ar] and c152[c19.ar] or nil)
        if c59[c1] then
            c115(c140, c153, c19.wt and c58[c19.wt] and c153[c19.wt] or nil)
        end
        local c62 = c19.mu and c154[c19.mu] and c19.mu or nil

        if not c62 and c19.mv then
            local c63 = c49(c19.mv)
            c62 = c154[c63] and c63 or nil
        end

        c115(c141, c156, c62)
        if c4 and not c20 then
            c129("Farming", "Couldn't read your current stats. Put them manually or use Other Stats.")
        end
        return c18
    end

    c149 = c135:CreateParagraph(
        { Name = "Result", Content = c69.msg.Farming ~= "" and c69.msg.Farming or "Result appears here." },
        "cFres"
    )
    c128.Farming = c149

    c135:CreateButton({
        Name = "Calculate",
        Tooltip = "Estimates production and time for the selected setup.",
        Callback = function()
            local c1 = c69.cat
            if not c1 then
                c129("Farming", "Select a category first.")
                return
            end
            if c69.md[c1] then
                c150(c1, false)
            end
            local c166 = c113(c142)
            if c69.md[c1] and (c70(c1).pw or "") ~= "" then
                c166 = c70(c1).pw
            end
            local c167 = c50(c166)
            local c168 = 0
            if c59[c1] and c113(c140) then
                local c4 = table.find(c153, c113(c140))
                c168 = c4 or 0
            end
            local c169
            if c59[c1] and (not c167 or c167 < c50(c53[c1][1].req)) then
                if c168 > 0 and c58[c168] then
                    local c4 = c1 == "MS" and c58[c168].mm or c58[c168].jm
                    c169 = { name = c58[c168].name, multi = c4 or "?" }
                else
                    c168 = 0
                    c169 = { name = "No Weight", multi = "x1" }
                end
            end
            local c15 = table.find(c152, c113(c138))
            local c18 = c15 and c53[c1][c15] and c53[c1][c15].multi or nil
            if not c169 and (not c18 or not c15) then
                c129("Farming", "Select an area.")
                return
            end
            local c170 = c113(c141)
            local c19 = c170 and c154[c170] or nil
            if not c19 then
                c129("Farming", "Select a multiplier.")
                return
            end
            local function c171(c20, c62, c63)
                local c64 = c20
                local c75, c76, c77 = 0, {}, false
                local c78 = c66(c1)
                local function c16(c79, c80)
                    local c81 = c67(c1, c79) or 1
                    local c122 = c78[c81]
                    local c172 = c50(c122.mu)
                    local c14 = c122.bo
                    if not c172 then
                        c77 = true
                        c76[#c76 + 1] = c49(c79)
                            .. " > "
                            .. c49(c80)
                            .. " ("
                            .. (c122.dn or c122.nm)
                            .. "): ?"
                        return
                    end
                    local c17 = c172 * c19
                    if c69.gn[c1] and c14 then
                        c17 = c17 * 2
                    end
                    local c173 = (c80 - c79) / c17
                    if c69.sp[c1] and c14 then
                        c173 = c173 / 2
                    end
                    c75 = c75 + c173
                    c76[#c76 + 1] = c49(c79)
                        .. " > "
                        .. c49(c80)
                        .. " ("
                        .. (c122.dn or c122.nm)
                        .. "): "
                        .. c51(c173)
                end
                for c79 = 1, #c78 do
                    local c80 = c78[c79]
                    local c81 = c80.th
                    if c81 and c81 > c20 and c81 <= c62 then
                        c16(c20, c81)
                        c20 = c81
                    end
                end
                if c62 > c20 then
                    c16(c20, c62)
                end
                c129(
                    "Farming",
                    c63
                        .. c49(c64)
                        .. " to "
                        .. c49(c62)
                        .. " -- Total: "
                        .. (c77 and "?" or c51(c75))
                        .. "\n"
                        .. table.concat(c76, "\n")
                        .. (c77 and "\n-- ? = unknown multiplier" or "")
                )
            end
            if (c113(c143) or "") ~= "" then
                local c4 = c50(c113(c143))
                if not c4 or c4 <= 0 then
                    c129("Farming", "Power objective: enter a valid value above 0.")
                    return
                end
                local c20 = c50(c166)
                if not c20 or c20 <= 0 then
                    if c15 then
                        c20 = c50(c53[c1][c15].req) or 0
                    else
                        c20 = 0
                    end
                end
                if c4 <= c20 then
                    c129("Farming", "Power objective: you already have more than that! Put another value.")
                    return
                end
                local c62 = c20
                if c69.st[c1] then
                    local c63, c64
                    if c169 then
                        c63 = c50(c169.multi)
                        c64 = c60(c169.name)
                    else
                        c63 = c50(c18)
                        c64 = c53[c1][c15].name
                    end
                    local c75 = c169 and false or (not c56[c1] or c15 >= c56[c1])
                    local c76 = c63 and c63 * c19 or nil
                    if c76 and c69.gn[c1] and c75 then
                        c76 = c76 * 2
                    end
                    if c76 and c69.sp[c1] and c75 then
                        c76 = c76 * 2
                    end
                    local c77 = c76 and (c4 - c62) / c76 or nil
                    if not c77 then
                        c129(
                            "Farming",
                            "Power objective -- staying in "
                                .. c64
                                .. ": ?"
                                .. "\n-- ? = unknown "
                                .. (c169 and "weight" or "area")
                                .. " multiplier"
                        )
                        return
                    end
                    c129(
                        "Farming",
                        "Power objective -- "
                            .. c49(c62)
                            .. " to "
                            .. c49(c4)
                            .. " -- Staying in "
                            .. c64
                            .. "\nGain per second: "
                            .. c49(c76)
                            .. "\nGain per minute: "
                            .. c49(c76 * 60)
                            .. "\nGain per hour: "
                            .. c49(c76 * 3600)
                            .. "\nGain per day: "
                            .. c49(c76 * 8.64e4)
                            .. "\nGain per week: "
                            .. c49(c76 * 6.048e5)
                            .. "\nGain per month: "
                            .. c49(c76 * 2.592e6)
                            .. "\nGain per year: "
                            .. c49(c76 * 3.1536e7)
                            .. "\nTotal: "
                            .. c51(c77)
                    )
                    return
                end
                c171(c62, c4, "Power objective -- ")
                return
            end
            local c63, c64
            if c169 then
                if c15 and c53[c1][c15] then
                    c63 = c50(c53[c1][c15].req)
                    c64 = c53[c1][c15].name
                end
            elseif c59[c1] and c168 > 0 and c58[c168] then
                local c75 = c50(c1 == "MS" and c58[c168].ms or c58[c168].jf)
                if c75 and c167 and c75 > c167 then
                    c63 = c75
                    c64 = c60(c58[c168].name)
                end
            end
            if c63 and not c69.st[c1] then
                c171(c167 or 0, c63, "Path to " .. c64 .. " -- ")
                return
            end
            local c75, c76, c77
            if c169 then
                c75 = c50(c169.multi)
                c76 = false
                if c58[c168 + 1] then
                    c77 = c50(c1 == "MS" and c58[c168 + 1].ms or c58[c168 + 1].jf)
                else
                    c77 = c50(c53[c1][1].req)
                end
            else
                c75 = c50(c18)
                c76 = not c56[c1] or c15 >= c56[c1]
                if c53[c1][c15 + 1] then
                    local c78 = c53[c1][c15 + 1]
                    c77 = c50(c1 == "BT" and c78.min or c78.req)
                end
            end
            if not c75 then
                if c169 then
                    local c78 = "Unknown weight multiplier."
                    if c77 then
                        c78 = c78
                            .. "\nNext: "
                            .. (c58[c168 + 1] and c60(c58[c168 + 1].name) or c53[c1][1].name)
                            .. " at "
                            .. c49(c77)
                    end
                    c129("Farming", c78)
                else
                    c129("Farming", "Unknown area multiplier.")
                end
                return
            end
            local c78 = c75 * c19
            if c69.gn[c1] and c76 then
                c78 = c78 * 2
            end
            if c69.sp[c1] and c76 then
                c78 = c78 * 2
            end
            local c16 = c77 and math.max(0, c77 - (c50(c166) or 0)) or 0
            local c79 = c77 and c16 / c78 or 0
            local c80
            if c69.st[c1] then
                c80 = c169 and "Staying with this weight -- put a Power Objective to calculate the time."
                    or "Staying in this area -- put a Power Objective to calculate the time."
            elseif c77 then
                c80 = "Estimated time to next "
                    .. (c169 and (c58[c168 + 1] and "weight" or "area") or "area")
                    .. ": "
                    .. c51(c79)
            else
                c80 = "Last area selected."
            end
            c129(
                "Farming",
                "Production per second: "
                    .. c49(c78)
                    .. "\nPer minute: "
                    .. c49(c78 * 60)
                    .. "\nPer hour: "
                    .. c49(c78 * 3600)
                    .. "\nPer day: "
                    .. c49(c78 * 8.64e4)
                    .. "\n"
                    .. c80
            )
        end,
    }, "cFcalc")

    local c174 = c105[2]:CreateGroupbox({ Name = "Setup", Column = 1 }, "cT0")
    local c175 = c105[2]:CreateGroupbox({ Name = "Mode", Column = 1 }, "cT1")
    local c176 = c105[2]:CreateGroupbox({ Name = "Calculate", Column = 2 }, "cT2")

    local c177, c178, c179, c180, c181
    local c182, c183
    local c184
    local c185
    local c186
    local c187 = false

    c177 = c174:CreateInput({
        Name = "Tokens",
        PlaceholderText = "Tokens",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.md.TK and c69.tok.cur or c69.tok.oth
            c4.tk = tostring(c1)
            c74()
        end,
    }, "cTtok")

    c178 = c174:CreateInput({
        Name = "TPM",
        PlaceholderText = "TPM",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.md.TK and c69.tok.cur or c69.tok.oth
            c4.tp = tostring(c1)
            c74()
        end,
    }, "cTtpm")

    c179 = c174:CreateInput({
        Name = "Tokens Objective",
        PlaceholderText = "Tokens objective",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.md.TK and c69.tok.cur or c69.tok.oth
            c4.ob = tostring(c1)
            c74()
        end,
    }, "cTtob")

    c180 = c174:CreateInput({
        Name = "TPM Objective",
        PlaceholderText = "TPM objective",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.md.TK and c69.tok.cur or c69.tok.oth
            c4.to = tostring(c1)
            c74()
        end,
    }, "cTtto")

    c181 = c174:CreateInput({
        Name = "Time Spent",
        PlaceholderText = "e.g. 9d10h22m",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            local c4 = c69.md.TK and c69.tok.cur or c69.tok.oth
            c4.sp = tostring(c1)
            c74()
        end,
    }, "cTtsp")

    c174:CreateParagraph(
        {
            Name = "Passive growth",
            Content = "+1 TPM every 4H -- +6 TPM per day. Those numbers are based if you 24/7.",
        },
        "cTtinfo"
    )

    c182 = c175:CreateToggle({
        Name = "Use Current Stats",
        Tooltip = "Live-syncs tokens and TPM from the game GUI.",
        CurrentValue = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            if c187 then
                return
            end
            c69.md.TK = c1
            c187 = true
            c117(c183, not c1)
            c187 = false
            if c1 then
                c185(true)
            else
                c186()
            end
            c74()
        end,
    }, "cTcur")

    c183 = c175:CreateToggle({
        Name = "Use Other Stats",
        Tooltip = "Manual mode -- type your tokens and TPM by hand.",
        CurrentValue = true,
        Callback = function(c1)
            if not c112 then
                return
            end
            if c187 then
                return
            end
            c69.md.TK = not c1
            c187 = true
            c117(c182, not c1)
            c187 = false
            if c1 then
                c186()
            else
                c185(true)
            end
            c74()
        end,
    }, "cTgoth")

    c184 = c176:CreateParagraph(
        { Name = "Result", Content = c69.msg.Tokens ~= "" and c69.msg.Tokens or "Result appears here." },
        "cTres"
    )
    c128.Tokens = c184

    local function c188(c1, c4, c15)
        local c18 = math.floor(c15 / 240)
        local c19 = c15 - c18 * 240
        return c1 + c4 * c15 + 240 * c18 * (c18 - 1) / 2 + c19 * c18
    end

    local function c189(c1)
        c1 = tostring(c1):lower():gsub("%s", "")
        if c1 == "" then
            return nil
        end
        local c4, c15 = 0, nil
        for c18, c19 in c1:gmatch("([%d%.]+)([wdhms])") do
            local c20 = tonumber(c18)
            if c20 then
                c15 = true
                c4 = c4
                    + c20
                        * (c19 == "w" and 1.008e4 or c19 == "d" and 1440 or c19 == "h" and 60 or c19 == "m" and 1 or 1 / 60)
            end
        end
        if c15 then
            return c4
        end
        return tonumber(c1)
    end

    local function c190(c1, c4, c15, c18)
        if c15 <= c18 then
            return c1 + c4 * c15
        end
        return c1 + c4 * c18 + c188(0, c4 + 1, c15 - c18)
    end

    local function c191(c1, c4, c15)
        local c18 = c15 - c1
        if c18 <= 0 then
            return 0
        end
        if c4 <= 0 then
            return nil
        end
        local c19 = 240 * (-c4 + math.sqrt(c4 * c4 + c18 / 120))
        local c20 = math.max(1, math.ceil(c19))
        while c188(c1, c4, c20) < c15 do
            c20 = c20 * 2
        end
        local c62 = 0
        while c62 < c20 do
            local c63 = math.floor((c62 + c20) / 2)
            if c188(c1, c4, c63) < c15 then
                c62 = c63 + 1
            else
                c20 = c63
            end
        end
        return c62
    end

    c185 = function(c1)
        local c4, c15 = c132()
        local c18 = false
        if c4 then
            local c19 = tostring(c4)
            if c69.tok.cur.tk ~= c19 then
                c69.tok.cur.tk = c19
                c18 = true
            end
            if not c119(c177) and c113(c177) ~= c19 then
                c117(c177, c19)
            end
        end
        if c15 then
            local c19 = tostring(c15)
            if c69.tok.cur.tp ~= c19 then
                c69.tok.cur.tp = c19
                c18 = true
            end
            if not c119(c178) and c113(c178) ~= c19 then
                c117(c178, c19)
            end
        end
        local c19 = c69.md.TK and c69.tok.cur or c69.tok.oth
        if not c4 and not c119(c177) and c113(c177) ~= (c19.tk or "") then
            c117(c177, c19.tk or "")
        end
        if not c15 and not c119(c178) and c113(c178) ~= (c19.tp or "") then
            c117(c178, c19.tp or "")
        end
        if not c119(c179) and c113(c179) ~= (c19.ob or "") then
            c117(c179, c19.ob or "")
        end
        if not c119(c180) and c113(c180) ~= (c19.to or "") then
            c117(c180, c19.to or "")
        end
        if not c119(c181) and c113(c181) ~= (c19.sp or "") then
            c117(c181, c19.sp or "")
        end
        if c1 and not c4 and not c15 then
            c129("Tokens", "Couldn't read your current stats. Put them manually or use Other Stats.")
        end
        return c18
    end

    c186 = function()
        local c1 = c69.md.TK and c69.tok.cur or c69.tok.oth
        c187 = true
        c117(c182, c69.md.TK)
        c117(c183, not c69.md.TK)
        c187 = false
        if not c119(c177) then
            c117(c177, c1.tk or "")
        end
        if not c119(c178) then
            c117(c178, c1.tp or "")
        end
        if not c119(c179) then
            c117(c179, c1.ob or "")
        end
        if not c119(c180) then
            c117(c180, c1.to or "")
        end
        if not c119(c181) then
            c117(c181, c1.sp or "")
        end
    end

    c176:CreateButton({
        Name = "Calculate",
        Tooltip = "Token objective, TPM objective and time spent in one run.",
        Callback = function()
            local c1 = c50(c113(c177))
            local c4 = c50(c113(c178))
            local c15 = c50(c113(c179))
            local c18 = c50(c113(c180))
            local c19, c20, c80 = nil, nil, nil
            local c62 = 240
            if c69.md.TK then
                local c63, c64, c75 = c132()
                if c64 then
                    c4 = c64
                    c117(c178, tostring(c64))
                    c69.tok.cur.tp = tostring(c64)
                end
                if c63 then
                    c1 = c63
                    c117(c177, tostring(c63))
                    c69.tok.cur.tk = tostring(c63)
                end
                if c75 then
                    c62 = c75
                end
                if c63 or c64 then
                    c74()
                end
                if not c64 then
                    c129(
                        "Tokens",
                        "Current stats: couldn't read your TPM. Put it manually or use Other Stats."
                    )
                    return
                end
            end
            if c15 then
                if not c1 then
                    c19 = "Token objective: enter valid tokens."
                elseif not c4 or c4 <= 0 then
                    c19 = "Token objective: enter a TPM above 0."
                elseif c15 <= c1 then
                    c19 = "Token objective: you already have more than that! Put another value."
                else
                    local c76
                    if c15 - c1 <= c4 * c62 then
                        c76 = math.ceil((c15 - c1) / c4)
                    else
                        c76 = c62 + c191(c1 + c4 * c62, c4 + 1, c15)
                    end
                    local c77 = c76 > c62 and math.floor((c76 - c62 - 1) / 240) + 1 or 0
                    c19 = "Token objective -- Remaining: "
                        .. c49(c15 - c1)
                        .. "\nEstimated time: "
                        .. c51(c76 * 60)
                        .. "\nTPM on arrival: "
                        .. c49(c4 + c77)
                end
            end
            if c18 then
                if not c4 then
                    c20 = "TPM objective: enter a valid TPM."
                elseif c18 <= c4 then
                    c20 = "TPM objective: you already have more than that! Put another value."
                else
                    local c76 = c62 + (c18 - c4 - 1) * 240
                    c20 = "TPM objective -- TPM to gain: "
                        .. c49(c18 - c4)
                        .. "\nEstimated time: "
                        .. c51(c76 * 60)
                    if c1 then
                        c20 = c20 .. "\nTokens by then: " .. c49(c190(c1, c4, c76, c62))
                    else
                        c20 = c20 .. "\nTokens gained: " .. c49(c190(0, c4, c76, c62))
                    end
                end
            end
            local c77 = c189(c113(c181))
            if c77 then
                if not c4 or c4 <= 0 then
                    c80 = "Time spent: enter a TPM above 0."
                elseif c77 <= 0 then
                    c80 = "Time spent: enter a valid duration above 0."
                else
                    local c78, c16
                    if c77 <= c62 then
                        c78 = c4 * c77
                        c16 = c77 == c62 and 1 or 0
                    else
                        c78 = c4 * c62 + c188(0, c4 + 1, c77 - c62)
                        c16 = 1 + math.floor((c77 - c62) / 240)
                    end
                    c80 = "Time spent -- "
                        .. c51(c77 * 60)
                        .. "\nTokens gained: "
                        .. c49(c78)
                        .. (c1 and "\nTokens at end: " .. c49(c1 + c78) or "")
                        .. "\nTPM at end: "
                        .. c49(c4 + c16)
                end
            end
            local c78 = ""
            if c69.md.TK then
                c78 = "Current stats -- Tokens: "
                    .. (c1 and c49(c1) or "?")
                    .. " -- TPM: "
                    .. (c4 and c49(c4) or "?")
                    .. " -- Next +1 TPM in "
                    .. c62
                    .. " min\n\n"
            end
            local c16 = {}
            if c19 then
                c16[#c16 + 1] = c19
            end
            if c20 then
                c16[#c16 + 1] = c20
            end
            if c80 then
                c16[#c16 + 1] = c80
            end
            c129(
                "Tokens",
                c101(
                    c78
                        .. (
                            c16[1] and table.concat(c16, "\n-- --\n")
                            or "Fill TPM and at least one objective or a time spent to calculate."
                        )
                )
            )
        end,
    }, "cTcalc")

    local c192 = c105[3]:CreateGroupbox({ Name = "Setup", Column = 1 }, "cM0")
    local c193 = c105[3]:CreateGroupbox({ Name = "Mode", Column = 1 }, "cM1")
    local c194 = c105[3]:CreateGroupbox({ Name = "Calculate", Column = 2 }, "cM2")

    local c195 = {
        { 2, 100 },
        { 4, 200 },
        { 8, 500 },
        { 16, 1000 },
        { 32, 2000 },
        { 64, 5000 },
        { 128, 1e4 },
        { 256, 1.5e4 },
        { 512, 2e4 },
        { 1024, 5e4 },
        { 2048, 1e5 },
        { 4096, 2e5 },
        { 8192, 5e5 },
        { 1.6384e4, 1e6 },
        { 3.2768e4, 2e6 },
        { 6.5536e4, 5e6 },
        { 1.31072e5, 1e7 },
        { 2.62144e5, 2e7 },
        { 5.24288e5, 5e7 },
        { 1.048576e6, 1e8 },
        { 2.097152e6, 2e8 },
        { 4.194304e6, 5e8 },
        { 8.388608e6, 1e9 },
        { 1.6777216e7, 2e9 },
        { 3.3554432e7, 5e9 },
        { 6.7108864e7, 1e10 },
        { 1.34217728e8, 2e10 },
        { 2.68435456e8, 5e10 },
        { 5.36870912e8, 1e11 },
        { 1.073741824e9, 2e11 },
    }

    local function c196(c1)
        if not c1 or c1 <= 0 then
            return nil
        end
        local c4 = math.clamp(math.floor(math.log(c1) / math.log(2) + 0.5), 1, #c195)
        return c195[c4][1]
    end

    local function c197(c1)
        if not c1 or c1 == "" then
            return nil
        end
        local c4 = c50(c1)
        return c4 and c196(c4) or nil
    end

    for c3, c1 in ipairs(c54) do
        for c3, c4 in ipairs({ c69.ml.cur, c69.ml.oth }) do
            local c15 = c197(c4[c1])
            c4[c1] = c15 and tostring(c15) or nil
        end
    end

    local c198, c199
    local c200 = {}
    local c201 = false
    local c202
    local c203

    local c204 = {}
    local c205 = {}
    for c3, c1 in ipairs(c195) do
        local c4 = "x" .. c49(c1[1])
        c205[#c205 + 1] = c4
        c204[c4] = c1[1]
    end

    local c206, c207
    local c208 = {}
    local c209 = {}
    for c3, c1 in ipairs(c195) do
        local c4 = "x" .. c49(c1[1]) .. " -- " .. c49(c1[2])
        c209[#c209 + 1] = c4
        c208[c4] = c1[1]
    end

    c202 = function(c1)
        local c4 = c131()
        local c15, c18 = false, false
        for c3, c19 in ipairs(c54) do
            local c20 = c4[c19]
            if c20 and c20.m then
                c15 = true
                if not c69.ml.ov[c19] then
                    local c62 = c196(c20.m)
                    if c62 and c69.ml.cur[c19] ~= tostring(c62) then
                        c69.ml.cur[c19] = tostring(c62)
                        c18 = true
                    end
                end
            end
        end
        for c3, c19 in ipairs(c54) do
            local c20 = c197(c69.ml.cur[c19])
            local c62 = c200[c19]
            if c62 then
                if c20 then
                    c115(c62, c205, "x" .. c49(c20))
                else
                    c115(c62, c205, nil)
                end
            end
        end
        c115(c206, c209, c69.ml.tm)
        if c1 then
            if c15 then
                if c69.msg.Multipliers ~= "" and c69.msg.Multipliers:find("Couldn't read", 1, true) then
                    c129("Multipliers", "")
                end
            else
                c129("Multipliers", "Couldn't read your multipliers. Select them from the dropdowns.")
            end
        end
        return c18
    end

    c203 = function()
        c201 = true
        c117(c198, c69.md.ML)
        c117(c199, not c69.md.ML)
        c201 = false
        local c1 = c69.md.ML and c69.ml.cur or c69.ml.oth
        for c3, c4 in ipairs(c54) do
            local c15 = c197(c1[c4])
            if c15 then
                c115(c200[c4], c205, "x" .. c49(c15))
            else
                c115(c200[c4], c205, nil)
            end
        end
        if c69.ml.tg and c69.ml.tm and c208[c69.ml.tm] then
            c115(c206, c209, c69.ml.tm)
        end
    end

    for c3, c1 in ipairs(c54) do
        c200[c1] = c192:CreateLabel({ Name = c1 .. " Multiplier" }, "cM" .. c1 .. "_l"):AddDropdown({
            Options = c205,
            Placeholder = "Select",
            Callback = function(c4)
                if not c112 then
                    return
                end
                c4 = type(c4) == "table" and c4[1] or c4
                if not c4 and c116(c200[c1]) then
                    return
                end
                local c15 = c4 and c204[c4] or nil
                local c18 = c69.md.ML and c69.ml.cur or c69.ml.oth
                if c15 then
                    c18[c1] = tostring(c15)
                    if c69.md.ML then
                        c69.ml.ov[c1] = true
                    end
                else
                    c18[c1] = nil
                    if c69.md.ML then
                        c69.ml.ov[c1] = nil
                    end
                end
                c74()
            end,
        }, "cM" .. c1)
    end

    c206 = c192:CreateLabel({ Name = "Objective" }, "cMobj_l"):AddDropdown({
        Options = c209,
        Placeholder = "Select",
        Callback = function(c1)
            if not c112 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c116(c206) then
                return
            end
            if c1 and c208[c1] then
                c69.ml.tg = c208[c1]
                c69.ml.tm = c1
            else
                c69.ml.tg = nil
                c69.ml.tm = nil
            end
            c74()
        end,
    }, "cMobj")

    c198 = c193:CreateToggle({
        Name = "Use Current Stats",
        Tooltip = "Live-syncs your multipliers from the game GUI. Manual picks override the sync.",
        CurrentValue = false,
        Callback = function(c1)
            if not c112 then
                return
            end
            if c201 then
                return
            end
            c69.md.ML = c1
            c201 = true
            c117(c199, not c1)
            c201 = false
            if c1 then
                c202(true)
            else
                c203()
            end
            c74()
        end,
    }, "cMcur")

    c199 = c193:CreateToggle({
        Name = "Use Other Stats",
        Tooltip = "Manual mode -- pick your multipliers by hand.",
        CurrentValue = true,
        Callback = function(c1)
            if not c112 then
                return
            end
            if c201 then
                return
            end
            c69.md.ML = not c1
            c201 = true
            c117(c198, not c1)
            c201 = false
            if c1 then
                c203()
            else
                c202(true)
            end
            c74()
        end,
    }, "cMgoth")

    c207 = c194:CreateParagraph(
        {
            Name = "Result",
            Content = c69.msg.Multipliers ~= "" and c69.msg.Multipliers or "Result appears here.",
        },
        "cMres"
    )
    c128.Multipliers = c207

    c194:CreateButton({
        Name = "Calculate",
        Tooltip = "Sums the token cost of every upgrade up to the objective.",
        Callback = function()
            if c69.md.ML then
                c202(false)
            end
            local c1 = c69.ml.tg
            if not c1 then
                c129("Multipliers", "Select an objective multiplier.")
                return
            end
            local c4, c15, c18 = {}, 0, 0
            for c3, c19 in ipairs(c54) do
                local c20 = (c69.md.ML and c69.ml.cur or c69.ml.oth)[c19]
                local c62 = c197(c20)
                if not c62 then
                    c4[#c4 + 1] = c19 .. ": no multiplier"
                else
                    c18 = c18 + 1
                    local c63, c64 = 0, 0
                    for c3, c75 in ipairs(c195) do
                        if c75[1] > c62 and c75[1] <= c1 then
                            c63 = c63 + c75[2]
                            c64 = c64 + 1
                        end
                    end
                    if c64 == 0 then
                        c4[#c4 + 1] = c19 .. ": already x" .. c49(c62) .. " or higher"
                    else
                        c4[#c4 + 1] = c19
                            .. ": "
                            .. c49(c63)
                            .. " Tokens ("
                            .. c64
                            .. (c64 > 1 and " upgrades)" or " upgrade)")
                        c15 = c15 + c63
                    end
                end
            end
            if c18 == 0 then
                c129("Multipliers", "Multipliers -- select your multipliers or use Current Stats.")
                return
            end
            c129(
                "Multipliers",
                c102(
                    "Multipliers -- objective x"
                        .. c49(c1)
                        .. "\n"
                        .. table.concat(c4, "\n")
                        .. (
                            c15 > 0 and "\nTotal: " .. c49(c15) .. " Tokens"
                            or "\nNothing to buy for this objective."
                        )
                )
            )
        end,
    }, "cMcalc")

    local function c210(c1)
        local c4 = c49(c1)
        local c15, c18 = string.match(string.format("%.14e", c1), "([%d%.]+)e%+?(-?%d+)")
        c15 = c15:gsub("%.?0+$", "")
        return c4 .. " (" .. c15 .. "e" .. c18 .. ")"
    end

    local c211 = {
        FS = {
            "Fist Strength",
            {
                { "Whan Skill 2", "Soul Devourer", 4, { 2e15, 2e16, 2e17, 2e18, 2e19, 2e20 } },
                { "Joe Skill 3", "Crystal Burst", 5, { 9e17, 9e18, 9e19, 9e20, 9e21, 9e22 } },
                { "Nan Skill 1", "Annihilation Beam", 5, { 6e19, 6e20, 6e21, 6e22, 6e23, 6e24 } },
                { "Nu Skill 5", "Inferno Spikes", 6, { 8e22, 8e23, 8e24, 8e25, 8e26, 8e27 } },
                { "Gob Skill 2", "Spiral Nova", 6, { 5e25, 5e26, 5e27, 5e28, 5e29, 5e30 } },
                { "Nu Skill 1", "Fury Fist", 7, { 4e28, 4e29, 4e30, 4e31, 4e32, 4e33 } },
                { "Oum Skill 4", "Rage Smash", 7, { 7e31, 7e32, 7e33, 7e34, 7e35, 7e36 } },
                { "Gob Skill 8", "Chaos Barrage", 8, { 3e34, 3e35, 3e36, 3e37, 3e38, 3e39 } },
                { "Moo Skill 5", "Radiant Burst", 8, { 1e37, 1e38, 1e39, 1e40, 1e41, 1e42 } },
                { "Gob Skill 6", "Blazequake", 9, { 2e40, 2e42, 2e44, 2e46, 2e48, 2e50 } },
            },
        },
        BT = {
            "Body Toughness",
            {
                { "Ton Skill 2", "Asteroid Strike", 5, { 1e18, 1e19, 1e20, 1e21, 1e22, 1e23 } },
                { "Nit Skill 3", "Nether Blast", 6, { 8e24, 8e25, 8e26, 8e27, 8e28, 8e29 } },
                { "Moo Skill 2", "Meteor Smash", 7, { 2e30, 2e31, 2e32, 2e33, 2e34, 2e35 } },
                { "Oum Skill 3", "Soul Explosion", 8, { 4e35, 4e36, 4e37, 4e38, 4e39, 4e40 } },
                { "Gob Skill 1", "Aura Eruption", 9, { 6e40, 6e42, 6e44, 6e46, 6e48, 6e50 } },
            },
        },
        MS = {
            "Movement Speed",
            {
                { "Ton Skill 1", "Mystic Tornado", 5, { 9e14, 9e15, 9e16, 9e17, 9e18, 9e19 } },
                { "Nit Skill 2", "Whirling Havoc", 6, { 8e20, 8e21, 8e22, 8e23, 8e24, 8e25 } },
                { "Oum Skill 1", "Arcane Blast", 7, { 7e26, 7e27, 7e28, 7e29, 7e30, 7e31 } },
                { "Nu Skill 3", "Cyclone Surge", 8, { 6e33, 6e34, 6e35, 6e36, 6e37, 6e38 } },
                { "Gob Skill 5", "Skyfall Strike", 9, { 5e40, 5e42, 5e44, 5e46, 5e48, 5e50 } },
            },
        },
        JF = {
            "Jump Force",
            {
                { "Nan Skill 2", "Death Wrath", 4, { 2e16, 2e17, 2e18, 2e19, 2e20, 2e21 } },
                { "Moo Skill 1", "Raging Tempest", 7, { 3e21, 3e22, 3e23, 3e24, 3e25, 3e26 } },
                { "Moo Skill 3", "Judgement Light", 7, { 4e27, 4e28, 4e29, 4e30, 4e31, 4e32 } },
                { "Nu Skill 2", "Glacial Bloom", 8, { 5e33, 5e34, 5e35, 5e36, 5e37, 5e38 } },
                { "Gob Skill 3", "Thunderburst", 9, { 7e40, 7e42, 7e44, 7e46, 7e48, 7e50 } },
            },
        },
        PP = {
            "Psychic Power",
            {
                { "Pear Skill 2", "Demonic Cage", 5, { 1e12, 1e13, 1e14, 1e15, 1e16, 1e17 } },
                { "Whan Skill 1", "Spatial Distortion", 6, { 1e15, 1e16, 1e17, 1e18, 1e19, 1e20 } },
                { "Gob Skill 9", "Phantom Summon", 6, { 1e18, 1e19, 1e20, 1e21, 1e22, 1e23 } },
                { "Nu Skill 4", "Supernova Bomb", 7, { 1e21, 1e22, 1e23, 1e24, 1e25, 1e26 } },
                { "Moo Skill 4", "Magma Wave", 7, { 1e24, 1e25, 1e26, 1e27, 1e28, 1e29 } },
                { "Gob Skill 7", "Void Piercer", 8, { 1e27, 1e28, 1e29, 1e30, 1e31, 1e32 } },
                { "Gob Skill 4", "Hell's Quicksand", 8, { 1e30, 1e31, 1e32, 1e33, 1e34, 1e35 } },
                { "Joe Skill 1", "Enchanted Doom", 9, { 1e33, 1e34, 1e35, 1e36, 1e37, 1e38 } },
                { "Oum Skill 2", "Endless Storm", 9, { 1e36, 1e37, 1e38, 1e39, 1e40, 1e41 } },
                { "Joe Skill 2", "Blade Dance", 9, { 1e39, 1e41, 1e43, 1e45, 1e47, 1e49 } },
            },
        },
    }

    local c212 = {
        {
            "Energy Sphere Punch",
            5,
            "FS 1,000 to unlock",
            {
                "LV1: T2 -- FS 1K (1e3)",
                "LV2: T3 -- FS 10K (1e4)",
                "LV3: T3 -- FS 1M (1e6)",
                "LV4: T4 -- FS 100M (1e8)",
                "LV5: T4 -- FS 100B (1e11)",
                "LV6: T5 -- FS 1Qa (1e15)",
                "LV7: T6 -- FS 100Qi (1e20)",
                "LV8: T7 -- FS 10Sp (1e25)",
                "LV9: T8 -- FS 1No (1e30)",
                "LV10 MAX: T9 -- FS 10Dd (1e40)",
            },
        },
        { "Damage Reflection", 6, "{Passive}" },
        { "Water Run", 7, "{Passive}", { "Toggle needs MS 1,000 + PP 1,000" } },
        { "Teleport", 9 },
        { "Fly", 10, "{Double Jump}" },
        {
            "Bullet Punch",
            11,
            "FS 100K to unlock",
            {
                "LV1: T3 -- FS 100K (1e5)",
                "LV2: T4 -- FS 10M (1e7)",
                "LV3: T5 -- FS 1T (1e12)",
                "LV4: T6 -- FS 10Sx (1e22)",
                "LV5: T7 -- FS 100No (1e32)",
                "LV6 MAX: T8 -- FS 1Td (1e42)",
            },
        },
        {
            "Soul Attack",
            12,
            nil,
            {
                "LV1: T3 -- from unlock",
                "LV2: T3 -- PP 100K (1e5)",
                "LV3: T4 -- PP 100M (1e8)",
                "LV4: T4 -- PP 1T (1e12)",
                "LV5: T5 -- PP 10Qa (1e16)",
                "LV6: T5 -- PP 100Qi (1e20)",
                "LV7: T6 -- PP 10Sp (1e25)",
                "LV8: T7 -- PP 1No (1e30)",
                "LV9: T8 -- PP 100Dc (1e35)",
                "LV10 MAX: T9 -- PP 100Dd (1e41)",
            },
        },
        { "Conceal/Reveal Aura", 13 },
        { "Killing Intent Aura", 14 },
    }

    local c213 = {}
    local c214 = {}

    do
        local c1 = c105[4]:CreateGroupbox({ Name = "Quest Skills", Column = 1 }, "cW0")
        c213[#c213 + 1] = c1
        local c4 = {}
        for c3, c15 in ipairs(c212) do
            c4[#c4 + 1] = c99(
                '<font color="rgb(235,236,242)">' .. c15[1] .. "</font>  --  Main Quest " .. c15[2] .. "+"
            )
            if c15[3] then
                c4[#c4 + 1] = c99(c100("   " .. c15[3]))
            end
            if c15[4] then
                for c3, c18 in ipairs(c15[4]) do
                    c4[#c4 + 1] = c99(c100("   " .. c18))
                end
            end
        end
        c214[#c214 + 1] =
            c1:CreateParagraph({ Name = "Quest Skills", Content = table.concat(c4, "\n") }, "cWq")
    end

    for c18, c1 in ipairs(c54) do
        local c4 = c211[c1]
        local c15 = c105[4]:CreateGroupbox(
            { Name = c4[1] .. " (" .. c1 .. ")", Column = c18 % 2 == 0 and 1 or 2 },
            "cW" .. c1
        )
        c213[#c213 + 1] = c15
        local c19 = {}
        for c3, c20 in ipairs(c4[2]) do
            c19[#c19 + 1] = '<font color="rgb(235,236,242)">'
                .. c20[2]
                .. '</font>  --  <font color="'
                .. c87[c1]
                .. '">'
                .. c20[1]
                .. '</font>  --  <font color="'
                .. c93
                .. '">Tier '
                .. c20[3]
                .. "</font>"
            for c62 = 1, 6 do
                c19[#c19 + 1] = '   <font color="'
                    .. c87[c1]
                    .. '">LVL'
                    .. c62
                    .. ":</font> "
                    .. c100(c210(c20[4][c62]))
            end
        end
        c214[#c214 + 1] =
            c15:CreateParagraph({ Name = c4[1], Content = table.concat(c19, "\n") }, "cWp" .. c1)
    end

    local c215 = c105[5]:CreateGroupbox({ Name = "General", Column = 1 }, "cS0")

    c215:CreateToggle({
        Name = "Auto Hide UI",
        Tooltip = "Enabled -- the UI starts minimized on next execution (restore with your Minimize Bind).",
        CurrentValue = c69.hide,
        Callback = function(c1)
            if not c112 then
                return
            end
            c69.hide = c1
            c127("Auto Hide UI " .. (c1 and "enabled" or "disabled"))
            c74()
        end,
    }, "cShide")

    local c216 = tostring(c47.WindowKeybind or "F2")

    c215:CreateLabel({ Name = "Minimize Keybind" }, "cSbind_l"):AddBind({
        CurrentValue = c216,
        WindowSetting = true,
        Tooltip = "Key to hide or show the cLTR window.",
        Callback = function() end,
        OnChangedCallback = function(c1)
            pcall(function()
                c1 = tostring(c1)
                if c1 ~= c216 then
                    c216 = c1
                    c127("Minimize keybind set to " .. c1)
                end
            end)
        end,
    }, "cSbind")

    local c217 = c105[5]:CreateGroupbox({ Name = "Autoload (this account)", Column = 1 }, "cS2")

    local c218
    do
        local c1, c4 = pcall(function()
            return c105[5]:BuildConfigGroupbox(2)
        end)
        if c1 and typeof(c4) == "table" then
            c218 = c4
        end
    end
    if not c218 then
        c127("Configuration section skipped -- Starlight config system could not build")
    end
    pcall(function()
        if c218 and c218.Elements then
            for c1, c4 in pairs(c218.Elements) do
                if c4 and c4.Class == "Divider" then
                    c4.IgnoreConfig = true
                end
            end
        end
    end)

    local function c219()
        local c1 = nil
        pcall(function()
            local c4 = c218 and c218.Elements and c218.Elements["__prebuiltConfigSelector_lbl"]
            local c15 = c4 and c4.NestedElements and c4.NestedElements["__prebuiltConfigSelector_lbl"]
            local c18 = c15 and c15.Values and c15.Values.CurrentOption
            if type(c18) == "table" then
                c1 = c18[1]
            elseif type(c18) == "string" then
                c1 = c18
            end
        end)
        return c1
    end

    local c220 = c217:CreateButton({
        Name = "Set autoload for this account",
        Tooltip = "Current: none",
        Callback = function()
            local c1 = c219()
            if typeof(c1) ~= "string" or c1 == "" then
                c47:Notification({
                    Title = "cLTR Calculators",
                    Content = "Autoload\nPick a config in the Configuration list first.",
                    Duration = 6,
                })
                return
            end
            c69.alsm = c1
            cSaload:Set({ Tooltip = "Current: " .. c1 })
            c127("Autoload for this account set to " .. c1)
            c74()
        end,
    }, "cSaload")

    c217:CreateButton({
        Name = "Clear autoload for this account",
        Tooltip = "Falls back to the shared autoload config, if any.",
        Callback = function()
            c69.alsm = nil
            c220:Set({ Tooltip = "Current: none" })
            c127("Autoload for this account cleared")
            c74()
        end,
    }, "cSalclean")

    if typeof(c69.alsm) == "string" and c69.alsm ~= "" then
        c220:Set({ Tooltip = "Current: " .. c69.alsm })
    end

    local c221 = c105[5]:CreateGroupbox({ Name = "Activity Log", Column = 1 }, "cS1")
    c124 = c221:CreateParagraph({ Name = "Log", Content = "No activity yet." }, "cSlog")
    if #c123 > 0 then
        c118(c124, table.concat(c123, "\n"))
    end
    c221:CreateButton({
        Name = "Clear",
        Tooltip = "Clears the activity log.",
        Callback = function()
            table.clear(c123)
            c118(c124, "No activity yet.")
        end,
    }, "cSclear")

    local c222 = c105[5]:CreateGroupbox({ Name = "Danger Zone", Column = 2 }, "cS3")

    local function c223()
        if getgenv().cLTR_State ~= c5 then
            return
        end
        c5.loading = false
        c5.startup = nil
        c71()
        pcall(function()
            local c1 = c47.FileSystem and c47.FileSystem.AutoloadConfigPath
            if c1 and isfolder and isfolder(c1) then
                c47.FileSystem:SaveConfig(c8.Name, c1)
            end
        end)
        if c73 then
            pcall(task.cancel, c73)
        end
        for c3, c1 in pairs(c5.th) do
            if typeof(c1) == "thread" and coroutine.status(c1) ~= "dead" then
                pcall(task.cancel, c1)
            end
        end
        table.clear(c5.th)
        pcall(function()
            c47.Window = nil
            c47:Destroy()
        end)
        pcall(function()
            if c47.Instance and c47.Instance.Parent then
                c47.Instance:Destroy()
            end
        end)
        table.clear(c114)
        table.clear(c123)
        table.clear(c65)
        getgenv().cLTR_State = nil
    end

    c222:CreateButton({
        Name = "Uninject",
        Tooltip = "Fully unloads cLTR and closes everything it created.",
        Callback = function()
            c84:PromptDialog({
                Name = "Uninject",
                Content = "Fully unload cLTR Calculators and close everything it created?",
                Type = 1,
                Actions = {
                    Primary = {
                        Name = "Confirm",
                        Callback = c223,
                    },
                    {
                        Name = "Cancel",
                        Callback = function() end,
                    },
                },
            })
        end,
    }, "cSunj")

    local function c224()
        local c1 = nil
        pcall(function()
            c1 = c47.FileSystem and c47.FileSystem.AutoloadConfigPath
        end)
        if not c1 or not isfolder or not isfolder(c1) then
            return
        end
        if typeof(c69.alsm) == "string" and c69.alsm ~= "" and not isfile(c1 .. "autoload.txt") then
            pcall(function()
                writefile(c1 .. "autoload.txt", c69.alsm)
            end)
        end
    end

    local c225 = {
        [1] = { Color3.fromRGB(255, 228, 64), Color3.fromRGB(158, 132, 20) },
        [3] = { Color3.fromRGB(80, 218, 226), Color3.fromRGB(24, 122, 130) },
        [4] = { Color3.fromRGB(178, 132, 255), Color3.fromRGB(96, 60, 158) },
        [5] = { Color3.fromRGB(176, 182, 192), Color3.fromRGB(88, 94, 104) },
    }
    local function c226()
        for c4, c15 in pairs(c225) do
            pcall(function()
                local c18 = c105[c4] and c105[c4].Instances and c105[c4].Instances.Button
                local c19 = c18 and c18:FindFirstChild("Header")
                if c19 then
                    if c19:GetAttribute("cTabTint") ~= c15[1] then
                        c19:SetAttribute("cTabTint", c15[1])
                    end
                    if c19.TextColor3 ~= c15[1] then
                        c19.TextColor3 = c15[1]
                    end
                    local c20 = c19:FindFirstChild("AccentBrighter")
                    if c20 then
                        if not c20.Enabled or c20.Color ~= c15[2] then
                            c20.Enabled = true
                            c20.Color = c15[2]
                        end
                    end
                end
            end)
        end
    end

    local function c227()
        pcall(function()
            local c1 = c47.Instance and c47.Instance:FindFirstChild("Tooltips")
            if not c1 then
                return
            end
            for c3, c4 in ipairs(c1:GetChildren()) do
                c4.Visible = false
            end
        end)
    end

    c5.th[#c5.th + 1] = task.spawn(function()
        while true do
            task.wait(1)
            if (not c47.Instance or not c47.Instance.Parent) or getgenv().cLTR_State ~= c5 then
                break
            end
            if c112 and not c47.Minimized then
                pcall(function()
                    if c69.cat and c69.md[c69.cat] then
                        c150(c69.cat, false)
                    end
                end)
                pcall(function()
                    if c69.md.TK then
                        c185(false)
                    end
                end)
                pcall(function()
                    if c69.md.ML then
                        c202(false)
                    end
                end)
                pcall(function()
                    if c107 or os.clock() - c108 < 0.5 then
                        return
                    end
                    if c110 then
                        c110(c105[c69.view] or c105[1])
                    end
                end)
                c226()
            else
                c227()
            end
        end
    end)

    pcall(function()
        local c228 = Font.new("rbxasset://fonts/families/GothamSSm.json")
        local c229 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
        local c230 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
        local c231 = c47.Instance
        if typeof(c231) ~= "Instance" then
            return
        end
        local c232 = Color3.fromRGB(161, 169, 225)
        local c233 = Color3.fromRGB(235, 236, 242)
        local c234 = Color3.fromRGB(186, 189, 199)
        local c235 = Color3.fromRGB(168, 175, 228)
        local c236 = Color3.fromRGB(150, 153, 163)
        local c171 = Color3.fromRGB(207, 211, 221)
        local c237 = {}
        for c3, c1 in ipairs(c213) do
            pcall(function()
                if c1.Instance then
                    c237[c1.Instance] = true
                end
            end)
        end
        local c238 = {}
        for c3, c1 in ipairs(c214) do
            pcall(function()
                if c1.Instance then
                    local c4 = c1.Instance:FindFirstChild("Content")
                    if c4 then
                        c238[c4] = true
                    end
                end
            end)
        end
        local c239 = {}
        for c3, c1 in pairs(c128) do
            pcall(function()
                if c1.Instance then
                    local c4 = c1.Instance:FindFirstChild("Content")
                    if c4 then
                        c239[c4] = true
                    end
                end
            end)
        end
        for c3, c1 in ipairs(c231:GetDescendants()) do
            if c1:IsA("TextBox") or c1:IsA("TextLabel") or c1:IsA("TextButton") then
                local c4 = c1.Parent
                local c15 = c4 and c4.Name or ""
                local c18 = false
                local c19 = c1
                while c19 and c19 ~= c231 do
                    if c19.Name == "Loading Screen" then
                        c18 = true
                        break
                    end
                    c19 = c19.Parent
                end
                if not c18 then
                    if c1:IsA("TextBox") then
                        c1.FontFace = c228
                        c1.TextSize = 12
                    elseif c15 == "Sidebar" and c1.Name == "Header" then
                        c1.FontFace = c230
                        c1.TextSize = 17
                        c1.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif c1.Name == "subheader" then
                        c1.FontFace = c228
                        c1.TextSize = 11
                        c1.TextColor3 = c236
                    elseif c15 == "Player" then
                        c1.FontFace = c229
                        c1.TextSize = 13
                        c1.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif c15 == "Headers" then
                        c1.FontFace = c229
                        c1.TextSize = 13
                        c1.TextColor3 = c235
                    elseif c15:match("^TAB_%d+$") and c1.Name == "Header" then
                        c1.FontFace = c229
                        c1.TextSize = 14
                    elseif c15:match("^GROUPBOX_%d+$") and c1.Name == "Header" then
                        c1.FontFace = c230
                        c1.TextSize = c237[c4] and 16 or 13
                        c1.TextColor3 = c232
                    elseif c1.Name == "Content" and c15:match("^PARAGRAPH_") then
                        c1.FontFace = c228
                        c1.TextSize = c238[c1] and 16 or (c239[c1] and 14 or 12)
                        c1.TextColor3 = c238[c1] and c171 or (c239[c1] and c233 or c234)
                        c1.RichText = true
                    elseif
                        c1.Name == "Header"
                        and (
                            c15:match("^BUTTON_")
                            or c15:match("^CHECKBOX_")
                            or c15:match("^SWITCH_")
                            or c15:match("^BIND_")
                            or c15:match("^LABEL_")
                            or c15:match("^INPUT_")
                            or c15:match("^DROPDOWN_")
                            or c15:match("^PARAGRAPH_")
                        )
                    then
                        c1.FontFace = c229
                        c1.TextSize = 13
                        c1.TextColor3 = c233
                    else
                        c1.FontFace = c228
                    end
                    local c20 = c1.Text
                    if type(c20) == "string" and c20 ~= "" and not (c15:match("^TAB_%d+$")) then
                        local c62 = c98(c20)
                        if c62 then
                            c1.TextColor3 = c85[c62]
                        elseif c20 == "Quest Skills" then
                            c1.TextColor3 = c91
                        elseif c20 == "Tokens" or c20 == "Tokens Objective" then
                            c1.TextColor3 = c88
                            c1.TextStrokeColor3 = c90
                            c1.TextStrokeTransparency = 0.4
                        end
                    end
                end
            end
        end
    end)

    for c1, c4 in pairs(c128) do
        if c69.msg[c1] ~= nil and c69.msg[c1] ~= "" then
            c118(c4, c69.msg[c1])
        end
    end
    for c3, c1 in ipairs({ c142, c143, c177, c178, c179, c180, c181 }) do
        c120(c1)
    end
    task.delay(1.25, function()
        for c3, c1 in ipairs({ c142, c143, c177, c178, c179, c180, c181 }) do
            c120(c1)
        end
    end)

    c226()

    c112 = true

    pcall(function()
        local c1 = c47.Window and c47.Window.TabSections
        for c3, c4 in pairs(c1 or {}) do
            for c3, c15 in pairs(c4.Tabs or {}) do
                for c3, c18 in pairs(c15.Groupboxes or {}) do
                    for c3, c19 in pairs(c18.Elements or {}) do
                        if c19.Class ~= "Bind" then
                            c19.IgnoreConfig = true
                        end
                        for c3, c20 in pairs(c19.NestedElements or {}) do
                            if c20.Class ~= "Bind" then
                                c20.IgnoreConfig = true
                            end
                        end
                    end
                end
            end
        end
    end)

    if c69.cat and c53[c69.cat] then
        c115(c136, c54, c69.cat)
        c164(c69.cat)
        c165(c69.cat)
        c163(c69.cat)
        c118(c149, c69.msg.Farming ~= "" and c69.msg.Farming or "Result appears here.")
    end

    c164(c69.cat)

    c165(c69.cat)

    c186()

    c203()

    pcall(function()
        if c69.md.TK then
            c185(false)
        end
        if c69.md.ML then
            c202(false)
        end
        if c69.cat and c69.md[c69.cat] then
            c150(c69.cat, false)
        end
    end)

    pcall(function()
        if c69.md[c69.cat] then
            if c69.msg.Farming == "" then
                c129(
                    "Farming",
                    "Use Current Stats is on -- "
                        .. c69.cat
                        .. " auto selected, live stats sync into the inputs."
                )
            end
        elseif c69.msg.Farming:find("Use Current Stats is on", 1, true) then
            c129("Farming", "")
        end
        if c69.md.TK then
            if c69.msg.Tokens == "" then
                c129("Tokens", "Use Current Stats is on -- your current tokens and TPM sync into the inputs.")
            end
        elseif c69.msg.Tokens:find("Use Current Stats is on", 1, true) then
            c129("Tokens", "")
        end
        if c69.md.ML then
            if c69.msg.Multipliers == "" then
                c129(
                    "Multipliers",
                    "Use Current Stats is on -- your current multipliers sync into the dropdowns."
                )
            end
        elseif c69.msg.Multipliers:find("Use Current Stats is on", 1, true) then
            c129("Multipliers", "")
        end
    end)

    c5.th[#c5.th + 1] = task.delay(0.8, function()
        if getgenv().cLTR_State ~= c5 or not c112 then
            return
        end
        pcall(function()
            if c69.cat and c53[c69.cat] then
                if c69.md[c69.cat] then
                    c150(c69.cat, false)
                end
                c160(c69.cat)
            end
        end)
        pcall(function()
            if c69.md.TK then
                c185(false)
            end
            c186()
        end)
        pcall(function()
            if c69.md.ML then
                c202(false)
            end
            c203()
        end)
        c226()
    end)

    if typeof(c69.alsm) ~= "string" or c69.alsm == "" then
        c69.alsm = c8.Name
        c74()
    end
    pcall(function()
        local c1 = c47.FileSystem and c47.FileSystem.AutoloadConfigPath
        local c4 = c47.FileSystem and c47.FileSystem.FileExtension or ".starlight"
        if c1 and isfolder and isfolder(c1) and isfile and not isfile(c1 .. c8.Name .. c4) then
            local c15, c18 = pcall(function()
                return c47.FileSystem:SaveConfig(c8.Name, c1)
            end)
            if c15 and c18 == true then
                c127("Auto created config " .. c8.Name .. " for this account")
            end
        end
    end)
    pcall(function()
        if typeof(c69.alsm) == "string" and c69.alsm ~= "" then
            c220:Set({ Tooltip = "Current: " .. c69.alsm })
        end
    end)

    c224()

    c110 = function(c1)
        pcall(function()
            for c4, c15 in pairs(c47.Window.TabSections) do
                for c18, c19 in pairs(c15.Tabs) do
                    c19.Active = false
                end
            end
        end)
        for c4, c15 in ipairs(c105) do
            pcall(function()
                local c18 = c15.Instances.Button
                local c19 = (c15 == c1)
                local c20 = c47.CurrentTheme and c47.CurrentTheme.Foregrounds
                c15.Active = c19
                c18.BackgroundTransparency = c19 and 0.5 or 1
                if c18.Header then
                    c18.Header.TextColor3 = c18.Header:GetAttribute("cTabTint")
                        or (c19 and c20.Light or c20.Medium)
                    local c62 = c18.Header:FindFirstChild("AccentBrighter")
                    if c62 then
                        c62.Enabled = c19 or c18.Header:GetAttribute("cTabTint") ~= nil
                    end
                end
                if c18.Icon then
                    c18.Icon.ImageColor3 = c19 and c20.Light or c20.Medium
                    local c62 = c18.Icon:FindFirstChild("AccentBrighter")
                    if c62 then
                        c62.Enabled = c19
                    end
                end
            end)
        end
        pcall(function()
            c47.Window.CurrentTab = c1
        end)
        pcall(function()
            local c4 = c1.Instances.Page.Parent:FindFirstChildOfClass("UIPageLayout")
            if c4 and c4.CurrentPage ~= c1.Instances.Page then
                c4:JumpTo(c1.Instances.Page)
            end
        end)
    end
    local function c240(c1)
        c1 = c1 or 0
        if getgenv().cLTR_State ~= c5 then
            return
        end
        if c109 or c1 >= 10 then
            c107 = false
            return
        end
        pcall(function()
            local c4 = c47.Instance
            local c15 = c4 and c4:FindFirstChild("Content")
            local c18 = c15 and c15:FindFirstChild("ContentMain")
            local c19 = c18 and c18:FindFirstChild("Elements")
            local c20 = c19 and c19:FindFirstChild("HomeTab")
            if c20 then
                c20:Destroy()
            end
        end)
        local c4 = c105[c83] or c105[1]
        local c15 = c4 and c4.Instances and c4.Instances.Page
        if not c15 or not c15.Parent then
            task.delay(0.25, function()
                c240(c1 + 1)
            end)
            return
        end
        local c18 = c15.Parent:FindFirstChildOfClass("UIPageLayout")
        if c18 and c18.CurrentPage ~= c15 then
            pcall(function()
                c18:JumpTo(c15)
            end)
        end
        pcall(c110, c4)
        local c62 = c108
        task.delay(0.3, function()
            if getgenv().cLTR_State ~= c5 then
                return
            end
            if c108 ~= c62 then
                c109 = true
                c107 = false
                return
            end
            local c63 = c15.Parent and c15.Parent:FindFirstChildOfClass("UIPageLayout")
            if c63 and c63.CurrentPage == c15 then
                c110(c4)
                c69.view = c83
                c74()
                c109 = true
                c107 = false
                c108 = os.clock()
            else
                c240(c1 + 1)
            end
        end)
    end
    c240()

    c5.th[#c5.th + 1] = task.spawn(function()
        for c3 = 1, 5 do
            task.wait(1)
            if getgenv().cLTR_State ~= c5 then
                break
            end
            pcall(function()
                local c1 = c84.Instance
                local c4 = c1 and c1:FindFirstChild("Content")
                local c15 = c4 and c4:FindFirstChild("ContentMain")
                local c18 = c15 and c15:FindFirstChild("Elements")
                if c18 then
                    local c19 = c18:FindFirstChild("HomeTab")
                    if c19 then
                        c19:Destroy()
                    end
                end
            end)
            if not c109 then
                pcall(function()
                    c240(0)
                end)
            end
        end
    end)
    task.delay(0.75, c226)
    if c69.hide then
        c47.Minimized = true
        pcall(function()
            c84.Instance.Visible = false
            c47.Instance.Drag.Visible = false
        end)
        c227()
    else
        c5.th[#c5.th + 1] = task.delay(0.35, function()
            pcall(function()
                if c47.Minimized then
                    return
                end
                c84.Instance.Visible = true
                c47.Instance.Drag.Visible = true
                local c1 = c84.Instance:FindFirstChildOfClass("UIScale")
                if not c1 then
                    c1 = Instance.new("UIScale")
                    c1.Scale = 0.96
                    c1.Parent = c84.Instance
                end
                game:GetService("TweenService")
                    :Create(
                        c1,
                        TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        { Scale = 1 }
                    )
                    :Play()
            end)
        end)
    end

    c47:Notification({
        Title = "cLTR Calculators",
        Content = "Loaded -- press " .. tostring(c47.WindowKeybind or "F2") .. " to show or hide this UI",
        Duration = 6,
    })

    c127(
        "Session started -- Auto Hide UI "
            .. (c69.hide and "ON" or "OFF")
            .. " -- hide/show key: "
            .. tostring(c47.WindowKeybind or "F2")
    )
    c71()
    c5.loading = false
    c5.startup = nil
end, function(c19)
    if not c2 or getgenv().cLTR_State ~= c2 then
        return
    end
    c2.loading = false
    c2.startup = nil
    pcall(function()
        local c1 = getgenv().cLTR_State
        local c4 = c1 and c1.lib
        if c4 and typeof(c4.Instance) == "Instance" and c4.Instance.Parent then
            local c15 = c4.Instance:FindFirstChild("MainWindow")
            c4.Minimized = false
            if c15 then
                c15.Visible = true
            end
            local c18 = c4.Instance:FindFirstChild("Drag")
            if c18 then
                c18.Visible = true
            end
        end
    end)
    c("Startup failed -- " .. tostring(c19):sub(1, 140))
    warn("[cLTR] " .. debug.traceback(tostring(c19), 2))
end)
