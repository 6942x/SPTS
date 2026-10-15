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

xpcall(function()
    if getgenv().cLTR_State then
        local c1 = getgenv().cLTR_State
        for c2, c3 in pairs(c1.th) do
            if typeof(c3) == "thread" and coroutine.status(c3) ~= "dead" then
                pcall(task.cancel, c3)
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
    local c4 = getgenv().cLTR_State

    local c5 = game:GetService("Players")
    local c6 = game:GetService("HttpService")

    local c7 = c5.LocalPlayer
    local c8 = 0
    while not c7 and c8 < 20 do
        task.wait(0.5)
        c8 = c8 + 1
        c7 = c5.LocalPlayer
    end
    if not c7 then
        error("[cLTR] Could not find the LocalPlayer - join a game first, then re-execute", 0)
    end
    local c9 = c7:WaitForChild("PlayerGui", 10)

    local function c10(c1)
        return type(c1) == "string"
            and (c1:find("RunChanged", 1, true) ~= nil or c1:find("SafeCallback", 1, true) ~= nil)
    end

    local c11 = false

    local function c12(c1, c3, c13)
        local c14
        local c15
        local c16 = c13 or c1:match("([^/]+)$")
        for c17 = 1, 2 do
            local c18, c19 = pcall(function()
                return game:HttpGetAsync(c1)
            end)
            if c18 and typeof(c19) == "string" and #c19 > 200 and c19:find(c3, 1, true) then
                if c10(c19) then
                    c15 = c15 or c19
                else
                    c14 = c19
                    break
                end
            end
            task.wait(0.5)
        end
        if not c14 and readfile then
            pcall(function()
                if isfile and isfile("TrainingCalc/cache_" .. c16) then
                    local c17 = readfile("TrainingCalc/cache_" .. c16)
                    if typeof(c17) == "string" and #c17 > 200 and c17:find(c3, 1, true) then
                        if c10(c17) then
                            c15 = c15 or c17
                        else
                            c14 = c17
                        end
                    end
                end
            end)
        end
        if not c14 and c15 then
            c11 = true
            error(
                "[cLTR] The Starlight copy served to this executor is outdated and breaks the UI (tonumber base out of range errors) - delete the TrainingCalc cache folder, rejoin the game so the executor drops its cached download, then re-execute",
                0
            )
        end
        if c14 and writefile then
            pcall(function()
                if isfolder and not isfolder("TrainingCalc") then
                    makefolder("TrainingCalc")
                end
                writefile("TrainingCalc/cache_" .. c16, c14)
            end)
        end
        if not c14 then
            error(
                "[cLTR] Failed to download "
                    .. c1:match("([^/]+)$")
                    .. " - check your internet connection and re-execute",
                0
            )
        end
        return c14
    end

    local function c20(c1)
        local c3, c14 = c1:gsub(
            "Parent%.Instance%.Header%.Size = UDim2%.fromOffset%(Parent%.Instance%.Header%.Size%.X%.Offset ([-+]) 26, 20%)",
            'if Parent.Instance:FindFirstChild("Header") then Parent.Instance.Header.Size = UDim2.fromOffset(Parent.Instance.Header.Size.X.Offset %1 26, 20) end'
        )
        if c14 == 0 then
            warn("[cLTR] Starlight destroy-guard patch did not match the downloaded library source")
        end
        c3 = c3:gsub(
            "label%.FontFace = Font%.fromId%(12187365364, Enum%.FontWeight%.Regular%)",
            'label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")'
        )
        local c17, c18, c19
        c3, c17 = c3:gsub(
            "Tween%(Tab%.Instances%.Button%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Light }%)",
            'Tween(Tab.Instances.Button.Header, { TextColor3 = Tab.Instances.Button.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Light })'
        )
        c3, c18 = c3:gsub(
            "Tween%(Tab%.Instances%.Button%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Medium }%)",
            'Tween(Tab.Instances.Button.Header, { TextColor3 = Tab.Instances.Button.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Medium })'
        )
        c3, c19 = c3:gsub(
            "Tween%(OtherTab%.Header, { TextColor3 = Starlight%.CurrentTheme%.Foregrounds%.Medium }%)",
            'Tween(OtherTab.Header, { TextColor3 = OtherTab.Header:GetAttribute("cTabTint") or Starlight.CurrentTheme.Foregrounds.Medium })'
        )
        c3 = c3:gsub(
            "OtherTab%.Header%.AccentBrighter%.Enabled = false",
            'OtherTab.Header.AccentBrighter.Enabled = OtherTab.Header:GetAttribute("cTabTint") ~= nil'
        )
        if c17 + c18 + c19 == 0 then
            warn("[cLTR] Starlight tab-color patch did not match the downloaded library source")
        end
        local c21, c22, c23
        c3, c21 = c3:gsub(
            "function NestedElement:Set%(NewNestedSettings, NewNestedIndex%)%s+NewNestedIndex = NewNestedIndex or NestedIndex%s+for i, v in pairs%(NestedElement%.Values%) do%s+if NewNestedSettings%[i%] == nil then%s+NewNestedSettings%[i%] = v%s+end%s+end%s+NestedSettings = NewNestedSettings%s+NestedIndex = NewNestedIndex%s+NestedElement%.Values = NestedSettings%s+if NestedElement%.Values%.CurrentOption then",
            "function NestedElement:Set(NewNestedSettings, NewNestedIndex) local cPrevOpts = NestedElement.Values and NestedElement.Values.Options or nil NewNestedIndex = NewNestedIndex or NestedIndex for i, v in pairs(NestedElement.Values) do if NewNestedSettings[i] == nil then NewNestedSettings[i] = v end end NestedSettings = NewNestedSettings NestedIndex = NewNestedIndex NestedElement.Values = NestedSettings if NestedElement.Values.CurrentOption then"
        )
        c3, c22 = c3:gsub(
            "Refresh%(%)(%s+)local preoptions = table%.clone%(NestedElement%.Values%.CurrentOption or %{}%)",
            'local cReuseOpts = false if typeof(NestedElement.Instances) == "table" and typeof(NestedElement.Instances[2]) == "Instance" and NestedElement.Instances[2]:FindFirstChild("List") ~= nil and NestedElement.Instances[2].List:FindFirstChildOfClass("Frame") ~= nil and (NestedElement.Values.Special == nil or NestedElement.Values.Special == 0) and type(cPrevOpts) == "table" and type(NewNestedSettings.Options) == "table" and #cPrevOpts == #NewNestedSettings.Options then cReuseOpts = true for ci = 1, #cPrevOpts do if cPrevOpts[ci] ~= NewNestedSettings.Options[ci] then cReuseOpts = false break end end end if not cReuseOpts then Refresh() end%1local preoptions = table.clone(NestedElement.Values.CurrentOption or {})'
        )
        c3, c23 = c3:gsub(
            'themeEvent%.Event:Connect%(function%(%)%s+if optioninstance:GetAttribute%("Active"%) then%s+Activate%(optioninstance%)%s+else%s+Deactivate%(optioninstance%)%s+end%s+end%)',
            'local cc cc = themeEvent.Event:Connect(function() if not optioninstance.Parent then cc:Disconnect() return end if optioninstance:GetAttribute("Active") then Activate(optioninstance) else Deactivate(optioninstance) end end) optioninstance.AncestryChanged:Connect(function() if not optioninstance.Parent then cc:Disconnect() end end)'
        )
        if c21 + c22 + c23 < 3 then
            warn("[cLTR] Starlight memory-leak patch did not match the downloaded library source")
        end
        local c24, c25, c26, c27
        c3, c24 = c3:gsub(
            "themeEvent%.Event:Connect%(set%)%s+set%(%)",
            'local cc cc = themeEvent.Event:Connect(function() if typeof(object) ~= "Instance" or not object.Parent then cc:Disconnect() return end set() end) object.AncestryChanged:Connect(function() if typeof(object) ~= "Instance" or not object.Parent then cc:Disconnect() end end) set()'
        )
        c3, c25 = c3:gsub(
            'CollectionService:AddTag%(newNotification, "__starlight_ExpiredNotification"%)',
            'CollectionService:AddTag(newNotification, "__starlight_ExpiredNotification") task.delay(1.5, function() local cExp = CollectionService:GetTagged("__starlight_ExpiredNotification") for ni = 1, #cExp - 6 do pcall(function() cExp[ni]:Destroy() end) end end)'
        )
        c3, c26 = c3:gsub(
            'if v%.ClassName == "Frame" and v ~= option then%s+Deactivate%(v%)%s+NestedElement%.Values%.CurrentOption = %{}%s+end',
            'if v.ClassName == "Frame" and v ~= option then if v:GetAttribute("Active") == true then Deactivate(v) end NestedElement.Values.CurrentOption = {} end'
        )
        c3, c27 = c3:gsub(
            "RunService%.RenderStepped:Connect%(function%(dt%)%s+if not IsHovering then%s+return%s+end",
            "local cTRS cTRS = RunService.RenderStepped:Connect(function(dt) if not HoverInstance.Parent then cTRS:Disconnect() return end if not IsHovering then return end if Starlight.Minimized or not Starlight.Instance.MainWindow.Visible then IsHovering = false tooltip.Visible = false return end"
        )
        if c24 + c25 + c26 + c27 < 4 then
            warn("[cLTR] Starlight notification-cleanup patch did not match the downloaded library source")
        end
        local c28, c29, c30
        c3, c28 = c3:gsub(
            "ConfigMethods%.Load%(object%.idx, object%.data%)",
            'if typeof(object) == "table" and typeof(object.data) == "table" then ConfigMethods.Load(object.idx, object.data) end'
        )
        c3, c29 = c3:gsub("for key, value in pairs%(Data%) do", "for key, value in pairs(Data or {}) do")
        c3, c30 = c3:gsub(
            "table%.insert%(data%.objects, ConfigMethods%.Save%(fullidx, object%.Values, object%.Class%)%)",
            'if typeof(object.Values) == "table" then table.insert(data.objects, ConfigMethods.Save(fullidx, object.Values, object.Class)) end'
        )
        if c28 + c29 + c30 < 3 then
            warn("[cLTR] Starlight config-safety patch did not match the downloaded library source")
        end
        local c31, c32, c33, c34, c35
        c3, c31 = c3:gsub(
            "Element%.Instance%.PART_Backdrop%.PART_Input%.Text = Element%.Values%.CurrentValue%s+Tween%(%s+Element%.Instance%.PART_Backdrop%.PART_Input,%s+{ Size = UDim2%.new%(0, Element%.Instance%.PART_Backdrop%.PART_Input%.TextBounds%.X, 1, 0%) }%s+%)%s+Tween%(%s+Element%.Instance%.PART_Backdrop,%s+{%s+Size = UDim2%.new%(%s+0,%s+Element%.Instance%.PART_Backdrop%.PART_Input%.TextBounds%.X %+ 30,%s+0,%s+Element%.Instance%.PART_Backdrop%.Size%.Y%.Offset%s+%),%s+}%s+%)",
            'Element.Instance.PART_Backdrop.PART_Input.Text = Element.Values.CurrentValue local cLTRii = Element.Instance.PART_Backdrop.PART_Input local function cLTRme(a) local b, c = pcall(function() return game:GetService("TextService"):GetTextSize(a, cLTRii.TextSize, Enum.Font.Gotham, Vector2.new(10000, 10000)).X end) if b and c then return c end local d = cLTRii.Text cLTRii.Text = a local e = cLTRii.TextBounds.X cLTRii.Text = d return e end local cLTRiw = cLTRii.Text ~= "" and cLTRme(cLTRii.Text) or 0 if cLTRii.PlaceholderText ~= "" then cLTRiw = math.max(cLTRiw, cLTRme(cLTRii.PlaceholderText)) end if Element.__cLTRiw ~= cLTRiw then Element.__cLTRiw = cLTRiw Tween(cLTRii, { Size = UDim2.new(0, cLTRiw, 1, 0) }) Tween(Element.Instance.PART_Backdrop, { Size = UDim2.new(0, cLTRiw + 30, 0, Element.Instance.PART_Backdrop.Size.Y.Offset) }) end'
        )
        c3, c32 = c3:gsub(
            'local Acrylic = isStudio and require%(ReplicatedStorage%.AcrylicBundled%)%s+or loadstring%(game:HttpGet%("https://raw%." %.%. website %.%. "/AcrylicModule%.luau"%)%)%(%)%s+Acrylic%.Init%(%)',
            'local Acrylic = { Init = function() end, AcrylicPaint = function() local cLTRf = Instance.new("Frame") cLTRf.Name = "cLTRAcrylic" cLTRf.BackgroundTransparency = 1 local cLTRs = Instance.new("ImageLabel") cLTRs.Name = "shadow" cLTRs.BackgroundTransparency = 1 cLTRs.Visible = false cLTRs.Parent = cLTRf return { AddParent = function() end, Frame = cLTRf, Model = { Size = Vector3.new(1, 1, 0.001) } } end }'
        )
        c3, c33 = c3:gsub(
            "mainWindow%.Sidebar%.Player%.PlayerIcon%.Image =%s+Players:GetUserThumbnailAsync%(Player%.UserId, Enum%.ThumbnailType%.HeadShot, Enum%.ThumbnailSize%.Size48x48%)",
            "task.spawn(function() local cLTRok, cLTRimg = pcall(function() return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) if cLTRok and cLTRimg then mainWindow.Sidebar.Player.PlayerIcon.Image = cLTRimg end end)"
        )
        c3, c34 =
            c3:gsub("ContentProvider:PreloadAsync%({", "task.spawn(function() ContentProvider:PreloadAsync({")
        c3, c35 = c3:gsub(
            "print%(`loaded asset {asset}`%)%s+end%s+end%)",
            "print(`loaded asset {asset}`) end end) end)"
        )
        if c31 + c32 + c33 + c34 + c35 < 5 then
            warn("[cLTR] Starlight boot-perf patch did not match the downloaded library source")
        end
        local c36
        c3, c36 = c3:gsub(
            "Starlight%.Minimized = true%s+end",
            'Starlight.Minimized = true pcall(function() local cTT = Starlight.Instance and Starlight.Instance:FindFirstChild("Tooltips") if cTT then for _, t in ipairs(cTT:GetChildren()) do t.Visible = false end end end) end'
        )
        if c36 < 1 then
            warn("[cLTR] Starlight tooltip-hide patch did not match the downloaded library source")
        end
        local c37
        c3, c37 = c3:gsub(
            'if option:GetAttribute%("Active"%) == false then%s+Activate%(option%)%s+local Success, Response = pcall%(function%(%)',
            'if option:GetAttribute("Active") == false then Activate(option) if not NestedElement.Values.MultipleOptions then close() end local Success, Response = pcall(function()'
        )
        if c37 < 1 then
            warn("[cLTR] Starlight dropdown-close patch did not match the downloaded library source")
        end
        local c38
        c3, c38 = c3:gsub(
            "local function close%(%)%s+Tween%(%s*NestedElement%.Instances%[2%]%.List",
            "local function close() NestedElement.__cLTRopen = false if NestedElement.Instances[2].Size.Y.Offset <= 0 then NestedElement.Instances[2].Visible = false end task.delay(0.25, function() if NestedElement and NestedElement.Instances ~= nil and not NestedElement.__cLTRopen and NestedElement.Instances[2].Size.Y.Offset <= 0 then NestedElement.Instances[2].Visible = false end end) Tween(NestedElement.Instances[2].List"
        )
        if c38 < 1 then
            warn("[cLTR] Starlight dropdown-close-guard patch did not match the downloaded library source")
        end
        local c39
        c3, c39 = c3:gsub(
            "Size = UDim2%.fromOffset%(NestedElement%.Instances%[2%]%.Size%.X%.Offset, 0%)%s*},%s*function%(%)%s*if NestedElement and NestedElement%.Instances ~= nil then%s+NestedElement%.Instances%[2%]%.Visible = false",
            "Size = UDim2.fromOffset(NestedElement.Instances[2].Size.X.Offset, 0) }, function() if NestedElement and NestedElement.Instances ~= nil then if not NestedElement.__cLTRopen and NestedElement.Instances[2].Size.Y.Offset <= 0 then NestedElement.Instances[2].Visible = false end"
        )
        if c39 < 1 then
            warn("[cLTR] Starlight dropdown-close-callback patch did not match the downloaded library source")
        end
        local c40
        c3, c40 = c3:gsub(
            "NestedElement%.Instances%[1%]%.Interact%.MouseButton1Click:Connect%(function%(%)%s+if NestedElement%.Instances%[2%]%.Visible then%s+close%(%)%s+else%s+NestedElement%.Instances%[2%]%.Visible = true%s+height = NestedElement%.Instances%[2%]%.List",
            "NestedElement.Instances[1].Interact.MouseButton1Click:Connect(function() if NestedElement.Instances[2].Visible and NestedElement.Instances[2].Size.Y.Offset > 1 then close() else NestedElement.Instances[2].Visible = true NestedElement.__cLTRopen = true height = NestedElement.Instances[2].List"
        )
        if c40 < 1 then
            warn("[cLTR] Starlight dropdown-reopen-toggle patch did not match the downloaded library source")
        end
        local c41, c42, c43
        c3, c41 = c3:gsub(
            "StarlightUI%.MainWindow%.Visible = false%s+StarlightUI%.MainWindow%.AnchorPoint = Vector2%.zero",
            'StarlightUI.MainWindow.Visible = false StarlightUI.MainWindow.AnchorPoint = Vector2.zero pcall(function() local cN = StarlightUI:FindFirstChild("Notifications") if cN then cN.AnchorPoint = Vector2.new(0, 1) cN.Position = UDim2.new(0, 20, 1, -20) end end)'
        )
        c3, c42 = c3:gsub(
            "StarlightUI%.Notifications%.Position = UDim2%.new%(1, %-20, 1, %-%(24 %+ jumpButton%.AbsoluteSize%.Y%)%)",
            "StarlightUI.Notifications.AnchorPoint = Vector2.new(0, 1) StarlightUI.Notifications.Position = UDim2.new(0, 20, 1, -(24 + jumpButton.AbsoluteSize.Y))"
        )
        c3, c43 = c3:gsub(
            "StarlightUI%.Notifications%.Position = UDim2%.new%(1, %-20, 1, %-20%)",
            "StarlightUI.Notifications.AnchorPoint = Vector2.new(0, 1) StarlightUI.Notifications.Position = UDim2.new(0, 20, 1, -20)"
        )
        if c41 + c42 + c43 < 3 then
            warn("[cLTR] Starlight notification-side patch did not match the downloaded library source")
        end
        local c44
        c3, c44 = c3:gsub(
            'Tab%.Instances%.Button%.Interact%["MouseButton1Click"%]:Connect%(Activate%)',
            'Tab.Instances.Button.Interact["MouseButton1Click"]:Connect(Activate) function Tab:Activate() Activate() end'
        )
        if c44 < 3 then
            warn("[cLTR] Starlight tab-activate patch did not match the downloaded library source")
        end
        local c45
        c3, c45 = c3:gsub(
            "for _, option in ipairs%(NestedElement%.Values%.Options%) do%s+local optioninstance = Resources%.Elements%.DropdownPopup%.List%.Option_TEMPLATE:Clone%(%)",
            'local cLSL = NestedElement.Instances[2].List:FindFirstChildOfClass("UIListLayout") if cLSL then cLSL.SortOrder = Enum.SortOrder.LayoutOrder end for i, option in ipairs(NestedElement.Values.Options) do local optioninstance = Resources.Elements.DropdownPopup.List.Option_TEMPLATE:Clone() optioninstance.LayoutOrder = i'
        )
        if c45 < 1 then
            warn("[cLTR] Starlight dropdown-order patch did not match the downloaded library source")
        end
        return c3
    end

    local c46
    do
        local c1, c3 = pcall(function()
            return loadstring(
                c20(
                    c12(
                        "https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/Gen1/Source.lua",
                        "Starlight Interface Suite",
                        "starlight_g1_v3"
                    )
                )
            )()
        end)
        if c1 and typeof(c3) == "table" then
            c46 = c3
        end
    end
    if not c46 then
        local c1, c3 = pcall(function()
            return loadstring(
                c20(
                    c12(
                        "https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/master/Source.lua",
                        "Starlight Interface Suite",
                        "starlight_m_v3"
                    )
                )
            )()
        end)
        if c1 and typeof(c3) == "table" then
            c46 = c3
        end
    end
    if not c46 then
        if c11 then
            error(
                "[cLTR] Starlight could not be loaded -- the executor keeps serving an outdated copy - delete the TrainingCalc cache folder, rejoin the game, then re-execute",
                0
            )
        end
        error("[cLTR] Starlight could not be loaded - check your internet connection and re-execute", 0)
    end
    c4.lib = c46
    c46.WindowKeybind = "F2"

    pcall(function()
        local c1 = c46.Instance
        local c3 = c1 and c1:FindFirstChild("MainWindow")
        local c14 = c3 and c3:FindFirstChild("Content")
        local c17 = c14 and c14:FindFirstChild("ContentMain")
        local c18 = c17 and c17:FindFirstChild("Elements")
        local c19 = c18 and c18:FindFirstChild("HomeTab")
        if c19 then
            c19:Destroy()
        end
    end)

    local c47 = {
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
    c47.m = { million = 1e6, billion = 1e9, trillion = 1e12 }
    for c2, c1 in ipairs(c47) do
        c47.m[c1[1]] = c1[2]
        c47.m[string.lower(c1[1])] = c1[2]
    end

    local function c48(c1)
        c1 = tonumber(c1)
        if not c1 then
            return "0"
        end
        local c3 = math.abs(c1)
        for c14 = #c47, 1, -1 do
            local c17 = c47[c14]
            if c3 >= c17[2] then
                return (string.format("%.2f", c1 / c17[2]):gsub("%.?0+$", "")) .. c17[1]
            end
        end
        return tostring(c1)
    end

    local function c49(c1)
        c1 = tostring(c1):gsub("[,%s]", "")
        c1 = c1:gsub("^[xX]", "")
        local c3 = tonumber(c1)
        if c3 then
            return c3
        end
        local c14, c17 = string.match(c1, "^([%d%.]+)(%a+)$")
        local c18 = c14 and tonumber(c14)
        local c19 = c17 and c47.m[string.lower(c17)]
        if c18 and c19 then
            return c18 * c19
        end
        return nil
    end

    local function c50(c1)
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
        local c3 = math.floor(c1 / 8.64e4)
        if c3 >= 1e6 then
            return c48(c3) .. " days"
        end
        local c14 = math.floor((c1 % 8.64e4) / 3600)
        local c17 = math.floor((c1 % 3600) / 60)
        return string.format("%.0fd %.0fh %.0fm", c3, c14, c17)
    end

    local function c51(c1, c3)
        return c1 .. " -- " .. c48(c49(c3) or 0)
    end

    local c52 = {
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

    local c53 = { "FS", "BT", "MS", "JF", "PP" }

    local c54 = { FS = "1e15", BT = "7.383e12", PP = "3.33e17" }
    local c55 = {}
    for c1, c3 in pairs(c54) do
        for c14, c17 in ipairs(c52[c1]) do
            if c17.req == c3 then
                c55[c1] = c14
                break
            end
        end
    end

    local function c56(c1, c3)
        local c14 = 1
        for c17, c18 in ipairs(c52[c1]) do
            local c19 = c49(c18.req)
            if c19 and c19 <= c3 then
                c14 = c17
            else
                break
            end
        end
        return c14
    end

    local c57 = {
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
    local c58 = { MS = true, JF = true }

    local function c59(c1)
        local c3 = string.match(c1, "^(%S+)")
        local c14 = c3 and c49(c3)
        if c14 then
            return c1 .. " - " .. c48(c14) .. string.sub(c1, #c3 + 1)
        end
        return c1
    end

    local function c60(c1, c3)
        local c14 = nil
        for c17, c18 in ipairs(c57) do
            local c19 = c49(c18.ms)
            local c61 = c49(c18.jf)
            local c62 = c19 == 0 or (c1 ~= nil and c19 ~= nil and c19 <= c1)
            local c63 = c61 == 0 or (c3 ~= nil and c61 ~= nil and c61 <= c3)
            if c62 and c63 then
                c14 = c17
            end
        end
        return c14
    end

    local c64 = {}

    local function c65(c1)
        if c64[c1] then
            return c64[c1]
        end
        local c3 = {}
        if c58[c1] then
            local c14 = c49(c1 == "MS" and c57[1].ms or c57[1].jf)
            if c14 and c14 > 0 then
                c3[#c3 + 1] = { nm = "No Weight", mu = "x1", bo = false, th = 0 }
            end
            for c17, c18 in ipairs(c57) do
                local c19 = c49(c1 == "MS" and c18.ms or c18.jf)
                if c19 and c19 > 0 then
                    local c61 = c1 == "MS" and c18.mm or c18.jm
                    c3[#c3 + 1] = { nm = c18.name, dn = c59(c18.name), mu = c61 or "?", bo = false, th = c19 }
                end
            end
        end
        for c17, c18 in ipairs(c52[c1]) do
            c3[#c3 + 1] = {
                nm = c18.name,
                mu = c18.multi,
                bo = not c55[c1] or c17 >= c55[c1],
                th = c49(c1 == "BT" and c18.min or c18.req),
            }
        end
        table.sort(c3, function(c14, c17)
            return (c14.th or 0) < (c17.th or 0)
        end)
        c64[c1] = c3
        return c3
    end

    local function c66(c1, c3)
        local c14 = c65(c1)
        local c17 = nil
        for c18 = 1, #c14 do
            local c19 = c14[c18].th
            if c19 and c19 <= c3 then
                c17 = c18
            end
        end
        return c17
    end

    local c67 = "TrainingCalc/" .. c7.Name .. ".json"
    local c68 = {
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
    for c2, c1 in ipairs(c53) do
        c68.md[c1] = false
        c68.sp[c1] = false
        c68.gn[c1] = false
        c68.st[c1] = false
        c68.mem[c1] = { cur = {}, oth = {} }
    end
    c68.md.TK = false
    c68.md.ML = false

    local function c69(c1)
        local c3 = c68.mem[c1]
        if not c3 then
            c3 = { cur = {}, oth = {} }
            c68.mem[c1] = c3
        end
        return c3[c68.md[c1] and "cur" or "oth"]
    end

    local c70
    local c71

    c70 = function()
        if not writefile then
            return
        end
        if isfolder and not isfolder("TrainingCalc") then
            pcall(function()
                makefolder("TrainingCalc")
            end)
        end
        pcall(function()
            writefile(c67, c6:JSONEncode(c68))
        end)
    end

    local c72 = nil
    local function c73()
        if c72 then
            pcall(task.cancel, c72)
        end
        c72 = task.delay(1, function()
            if getgenv().cLTR_State ~= c4 then
                return
            end
            c72 = nil
            c70()
        end)
    end

    c71 = function()
        if not readfile then
            return
        end
        local c1, c3 = pcall(function()
            if isfile and not isfile(c67) then
                return
            end
            return readfile(c67)
        end)
        if not c1 or not c3 then
            return
        end
        local c14, c17 = pcall(function()
            return c6:JSONDecode(c3)
        end)
        if not c14 or type(c17) ~= "table" then
            return
        end

        local function c18(c19, c61, c62)
            local c63 = type(c61) == "table" and c61 or {}
            local c74 = type(c62) == "table" and c62 or {}
            local c75 = c63[c19]
            if c75 == nil then
                c75 = c74[c19]
            end
            return c75
        end

        local function c19(c61, c62)
            local c63 = c68.mem[c61]
            local c74 = type(c62.cur) == "table" and c62.cur or nil
            local c75 = type(c62.oth) == "table" and c62.oth or nil
            c63.cur.pw = tostring(c18("pw", c74, c62) or c18("power", c74, c62) or "")
            c63.oth.pw = tostring(c18("pw", c75, c62) or c18("power", c75, c62) or "")
            c63.cur.ob = tostring(c18("ob", c74, c62) or c18("pobj", c74, c62) or "")
            c63.oth.ob = tostring(c18("ob", c75, c62) or c18("pobj", c75, c62) or "")
            local c76 = tonumber(c18("ar", c74, c62) or c18("area", c74, c62))
            local c77 = tonumber(c18("ar", c75, c62) or c18("area", c75, c62))
            c63.cur.ar = c76 and math.floor(c76) or nil
            c63.oth.ar = c77 and math.floor(c77) or nil
            local c15 = c18("mu", c74, c62) or c18("mult", c74, c62)
            local c78 = c18("mu", c75, c62) or c18("mult", c75, c62)
            c63.cur.mu = c15 ~= nil and tostring(c15) or nil
            c63.oth.mu = c78 ~= nil and tostring(c78) or nil
            c63.cur.mv = tonumber(c18("mv", c74, c62) or c18("val", c74, c62))
            c63.oth.mv = tonumber(c18("mv", c75, c62) or c18("val", c75, c62))
            local c79 = tonumber(c18("wt", c74, c62))
            local c80 = tonumber(c18("wt", c75, c62))
            c63.cur.wt = c79 and math.floor(c79) or nil
            c63.oth.wt = c80 and math.floor(c80) or nil
        end

        local function c61(c62)
            local c63 = type(c62.cur) == "table" and c62.cur or nil
            local c74 = type(c62.oth) == "table" and c62.oth or nil
            if not c63 and not c74 then
                local c75 = { tk = c62.tk or c62.tokens, tp = c62.tp or c62.tpm }
                if c62.mode == "cur" then
                    c63 = c75
                else
                    c74 = c75
                end
            end
            local c76 = { cur = c63, oth = c74 }
            for c77, c15 in pairs(c76) do
                local c78 = c68.tok[c77]
                c78.tk = tostring(c18("tk", c15, c62) or c18("tokens", c15, c62) or "")
                c78.tp = tostring(c18("tp", c15, c62) or c18("tpm", c15, c62) or "")
                c78.ob = tostring(c18("ob", c15, c62) or c18("obj", c15, c62) or "")
                c78.to = tostring(c18("to", c15, c62) or c18("tpo", c15, c62) or "")
                c78.sp = tostring(c18("sp", c15, c62) or c18("spent", c15, c62) or "")
            end
        end

        c68.hide = c17.hide == true
        if type(c17.view) == "number" and c17.view >= 1 and c17.view <= 5 then
            c68.view = math.floor(c17.view)
        end
        if c52[c17.cat] then
            c68.cat = c17.cat
        end
        if typeof(c17.alsm) == "string" and c17.alsm ~= "" then
            c68.alsm = c17.alsm
        end
        local c62 = c17.speed == true
        local c63 = c17.train == true
        local c74 = c17.stay == true
        for c2, c75 in ipairs(c53) do
            if type(c17.md) == "table" then
                c68.md[c75] = c17.md[c75] == true
            end
            if type(c17.sp) == "table" then
                c68.sp[c75] = c17.sp[c75] == true or (c17.sp[c75] == nil and c62)
            else
                c68.sp[c75] = c62
            end
            if type(c17.gn) == "table" then
                c68.gn[c75] = c17.gn[c75] == true or (c17.gn[c75] == nil and c63)
            else
                c68.gn[c75] = c63
            end
            if type(c17.st) == "table" then
                c68.st[c75] = c17.st[c75] == true or (c17.st[c75] == nil and c74)
            else
                c68.st[c75] = c74
            end
            if type(c17.mem) == "table" and type(c17.mem[c75]) == "table" then
                c19(c75, c17.mem[c75])
            end
        end
        if type(c17.md) == "table" then
            c68.md.TK = c17.md.TK == true
            c68.md.ML = c17.md.ML == true
        end
        if type(c17.tok) == "table" then
            c61(c17.tok)
        end
        if type(c17.ml) == "table" then
            for c2, c75 in ipairs(c53) do
                local c76 = (type(c17.ml.cur) == "table" and c17.ml.cur[c75]) or nil
                local c77 = (type(c17.ml.oth) == "table" and c17.ml.oth[c75]) or nil
                if c76 ~= nil then
                    c68.ml.cur[c75] = tostring(c76)
                end
                if c77 ~= nil then
                    c68.ml.oth[c75] = tostring(c77)
                end
            end
            if type(c17.ml.ov) == "table" then
                for c75, c76 in pairs(c17.ml.ov) do
                    if c76 == true then
                        c68.ml.ov[c75] = true
                    end
                end
            end
            local c15 = tonumber(c17.ml.tg)
            if c15 then
                c68.ml.tg = c15
            end
            if c17.ml.tm ~= nil then
                c68.ml.tm = tostring(c17.ml.tm)
            end
        end
        if type(c17.msg) == "table" then
            local function c81(c77)
                c77 = string.lower(tostring(c77))
                return c77:find("couldn", 1, true) ~= nil
                    or c77:find("select ", 1, true) ~= nil
                    or c77:find("enter a valid", 1, true) ~= nil
                    or c77:find("you already", 1, true) ~= nil
                    or c77:find("failed", 1, true) ~= nil
                    or c77:find("skipped", 1, true) ~= nil
                    or c77:find("did not match", 1, true) ~= nil
            end
            for c75, c76 in pairs(c17.msg) do
                local c77 = tostring(c76)
                if c75 == "Farming" or c75 == "Tokens" or c75 == "Multipliers" then
                    c68.msg[c75] = (c77 ~= "" and not c81(c77)) and c77 or ""
                end
            end
        end
    end

    c71()

    local c82 = c68.view
    local c83 = c46:CreateWindow({
        Name = "cLTR Calculators",
        Subtitle = "Starlight",
        LoadingEnabled = false,
        InterfaceAdvertisingPrompts = false,
        NotifyOnCallbackError = true,
        FileSettings = { ConfigFolder = "cLTR_Starlight" },
    })

    pcall(function()
        c83.Instance.Visible = false
        c46.Instance.Drag.Visible = false
        if c68.hide then
            c46.Minimized = true
        end
    end)

    local c84 = {
        FS = Color3.fromRGB(255, 82, 82),
        BT = Color3.fromRGB(255, 148, 40),
        MS = Color3.fromRGB(88, 235, 128),
        JF = Color3.fromRGB(255, 224, 92),
        PP = Color3.fromRGB(190, 122, 255),
    }
    local c85 = {
        FS = "Fist Strength",
        BT = "Body Toughness",
        MS = "Movement Speed",
        JF = "Jump Force",
        PP = "Psychic Power",
    }
    local c86 = {}
    for c1, c3 in pairs(c84) do
        c86[c1] = "rgb("
            .. math.floor(c3.R * 255 + 0.5)
            .. ","
            .. math.floor(c3.G * 255 + 0.5)
            .. ","
            .. math.floor(c3.B * 255 + 0.5)
            .. ")"
    end
    local c87 = Color3.fromRGB(255, 221, 0)
    local c88 = "rgb(255,221,0)"
    local c89 = Color3.fromRGB(255, 140, 0)
    local c90 = Color3.fromRGB(255, 198, 88)
    local c91 = "rgb(255,198,88)"
    local c92 = "rgb(255,99,163)"
    local c93 = "rgb(64,255,218)"
    local c94 = "rgb(96,170,255)"
    local c95 = "rgb(255,214,90)"

    local function c96(c1)
        local c3 = tostring(c1):gsub('<font color="rgb%([%d,]+%)">', "")
        c3 = c3:gsub("</font>", "")
        return c3
    end

    local function c97(c1)
        if type(c1) ~= "string" or c1 == "" then
            return nil
        end
        for c2, c3 in ipairs(c53) do
            if c1:find(c85[c3], 1, true) then
                return c3
            end
        end
        for c2, c3 in ipairs(c53) do
            if c1:sub(1, #c3 + 1) == c3 .. " " then
                return c3
            end
        end
        return nil
    end

    local function c98(c1)
        local c3 = tostring(c1)
        for c2, c14 in ipairs(c53) do
            c3 = c3:gsub("%f[%w]" .. c14 .. "%f[%W]", '<font color="' .. c86[c14] .. '">' .. c14 .. "</font>")
        end
        c3 = c3:gsub("Main Quest (%d+)%+", '<font color="' .. c91 .. '">Main Quest %1+</font>')
        c3 = c3:gsub("%f[%w]LV(%d+)", '<font color="' .. c91 .. '">LV%1</font>')
        c3 = c3:gsub("%f[%w]T(%d+)%f[%W]", '<font color="' .. c92 .. '">T%1</font>')
        c3 = c3:gsub("{Passive}", '<i><font color="rgb(150,153,163)">{Passive}</font></i>')
        return c3
    end

    local function c99(c1)
        local c3 = "\1" .. tostring(c1)
        local c14 = '<font color="' .. c93 .. '">'
        local c17 = '<font color="' .. c94 .. '">'
        c3 = c3:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", function(c18, c19)
            if c19:match("^[%d%.]+e[+%-]?%d+$") then
                return c18 .. c17 .. c19 .. "</font>"
            end
            return c18 .. c14 .. c19 .. "</font>"
        end)
        return (c3:gsub("\1", ""))
    end

    local function c100(c1)
        local c3 = "\1" .. tostring(c1)
        local c14 = '<font color="' .. c88 .. '">'
        local c17 = '<font color="' .. c95 .. '">'
        local c18 = '<font color="rgb(168,175,228)">'
        local c19 = {}
        local c61 = {}
        local function c62(c63)
            c19[#c19 + 1] = c63
            local c74 = ""
            local c75 = #c19
            while c75 > 0 do
                c74 = string.char(97 + (c75 - 1) % 26) .. c74
                c75 = math.floor((c75 - 1) / 26)
            end
            return "\2" .. c74 .. "\3"
        end
        local function c76(c63)
            c61[#c61 + 1] = c63
            local c74 = ""
            local c75 = #c61
            while c75 > 0 do
                c74 = string.char(97 + (c75 - 1) % 26) .. c74
                c75 = math.floor((c75 - 1) / 26)
            end
            return "\4" .. c74 .. "\5"
        end
        c3 = c3:gsub("%f[%d]%d+d %d+h %d+m", c62)
        c3 = c3:gsub("%f[%d][%d%.]+%a* days", c62)
        c3 = c3:gsub("%f[%d]%d+ min", c62)
        c3 = c3:gsub("Never", c62)
        c3 = c3:gsub("Token objective", c76)
        c3 = c3:gsub("TPM objective", c76)
        c3 = c3:gsub("Time spent", c76)
        c3 = c3:gsub("Current stats", c76)
        c3 = c3:gsub("Remaining:", c76)
        c3 = c3:gsub("Estimated time:", c76)
        c3 = c3:gsub("TPM on arrival:", c76)
        c3 = c3:gsub("TPM to gain:", c76)
        c3 = c3:gsub("TPM at end:", c76)
        c3 = c3:gsub("Tokens by then:", c76)
        c3 = c3:gsub("Tokens gained:", c76)
        c3 = c3:gsub("Tokens at end:", c76)
        c3 = c3:gsub("Next %+1 TPM in", c76)
        c3 = c3:gsub("Tokens:", c76)
        c3 = c3:gsub("TPM:", c76)
        c3 = c3:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", "%1" .. c14 .. "%2</font>")
        c3 = c3:gsub("\2(%a+)\3", function(c63)
            local c74 = 0
            for c75 = 1, #c63 do
                c74 = c74 * 26 + string.byte(c63, c75) - 96
            end
            return c17 .. (c19[c74] or "") .. "</font>"
        end)
        c3 = c3:gsub("\4(%a+)\5", function(c63)
            local c74 = 0
            for c75 = 1, #c63 do
                c74 = c74 * 26 + string.byte(c63, c75) - 96
            end
            return c18 .. (c61[c74] or "") .. "</font>"
        end)
        return (c3:gsub("\1", ""))
    end

    local function c101(c1)
        local c3 = {}
        for c14 in tostring(c1):gmatch("[^\n]+") do
            local c18 = c14
            for c2, c17 in ipairs(c53) do
                c18 = c18:gsub("^" .. c17 .. ":", '<font color="' .. c86[c17] .. '">' .. c17 .. "</font>:")
            end
            c3[#c3 + 1] = c18
        end
        local c19 = table.concat(c3, "\n")
        c19 = c19:gsub("x(%d[%d%.]*%a*)", '<font color="' .. c93 .. '">x%1</font>')
        c19 = c19:gsub("%((%d+) (upgrades?)%)", '<font color="' .. c92 .. '">(%1 %2)</font>')
        c19 = c19:gsub("([^%s]+) Tokens", '<font color="' .. c88 .. '">%1 Tokens</font>')
        return c19
    end

    local function c102(c1)
        local c3 = "\1" .. tostring(c1)
        local c14 = '<font color="' .. c93 .. '">'
        local c17 = '<font color="' .. c95 .. '">'
        local c18 = {}
        local function c19(c61)
            c18[#c18 + 1] = c61
            local c62 = ""
            local c63 = #c18
            while c63 > 0 do
                c62 = string.char(97 + (c63 - 1) % 26) .. c62
                c63 = math.floor((c63 - 1) / 26)
            end
            return "\2" .. c62 .. "\3"
        end
        c3 = c3:gsub("%d%d?%d?d %d%d?%d?h %d%d?%d?m", c19)
        c3 = c3:gsub("%f[%d][%d%.]+%a* days", c19)
        c3 = c3:gsub("Never", c19)
        c3 = c3:gsub("([^%w_])%f[%d]([%d%,%.]+%a*%d*)", "%1" .. c14 .. "%2</font>")
        c3 = c3:gsub("\2(%a+)\3", function(c61)
            local c62 = 0
            for c63 = 1, #c61 do
                c62 = c62 * 26 + string.byte(c61, c63) - 96
            end
            return c17 .. (c18[c62] or "") .. "</font>"
        end)
        c3 = c3:gsub("\1", "")
        local c74 = {}
        for c75 in c3:gmatch("[^\n]+") do
            local c76, c77 = c75:match("^([%a%s]+):%s*(.+)$")
            if c76 and #c76 > 3 then
                c74[#c74 + 1] = '<font color="rgb(168,175,228)">' .. c76 .. ":</font> " .. c77
            else
                c74[#c74 + 1] = c75
            end
        end
        return table.concat(c74, "\n")
    end

    local c103 = c83:CreateTabSection("cLTR")
    local c104 = {
        c103:CreateTab({ Name = "Farming", Columns = 2 }, "farming"),
        c103:CreateTab({ Name = "Tokens", Columns = 2 }, "tokens"),
        c103:CreateTab({ Name = "Multipliers", Columns = 2 }, "multipliers"),
        c103:CreateTab({ Name = "Wiki", Columns = 2 }, "wiki"),
        c103:CreateTab({ Name = "Settings", Columns = 2 }, "settings"),
    }
    local c105 = { "Farming", "Tokens", "Multipliers", "Wiki", "Settings" }

    local c106 = true
    local c107 = 0
    local c108 = false
    local c109

    local c110
    c110 = function(c1)
        c1 = (c1 or 0) + 1
        local c3 = 0
        for c14, c17 in ipairs(c104) do
            pcall(function()
                local c18 = c17.Instances and c17.Instances.Button and c17.Instances.Button.Interact
                if c18 and not c18:GetAttribute("cViewT") then
                    c18:SetAttribute("cViewT", c14)
                    c18.MouseButton1Click:Connect(function()
                        if getgenv().cLTR_State ~= c4 then
                            return
                        end
                        c68.view = c14
                        c82 = c14
                        c107 = os.clock()
                        c108 = true
                        c106 = false
                        c73()
                        task.defer(function()
                            if getgenv().cLTR_State == c4 and c68.view == c14 and c109 then
                                c109(c17)
                            end
                        end)
                        task.delay(0.3, function()
                            if getgenv().cLTR_State == c4 and c68.view == c14 and c109 then
                                c109(c17)
                            end
                        end)
                    end)
                    c3 = c3 + 1
                end
            end)
        end
        if c3 < #c104 and c1 < 12 then
            task.delay(0.25, function()
                c110(c1)
            end)
        end
    end
    c110()

    local c111 = false

    local function c112(c1)
        local c3 = c1 and c1.Values
        if not c3 then
            return nil
        end
        if c3.Options ~= nil or c3.CurrentOption ~= nil then
            local c14 = c3.CurrentOption
            if type(c14) == "table" then
                return c14[1]
            end
            return c14
        end
        return c3.CurrentValue
    end

    local c113 = {}

    local function c114(c1, c3, c14)
        if not c1 then
            return
        end
        local c17 = c113[c1]
        local c18 = c14
        local c19 = ""
        if type(c3) == "table" then
            for c61 = 1, #c3 do
                c19 = c19 .. "\1" .. tostring(c3[c61])
            end
        else
            c19 = tostring(c3)
        end
        if c17 and c17[2] == c18 and c17[3] == c19 and c112(c1) == c18 then
            return
        end
        c113[c1] = { c3, c18, c19, os.clock() }
        c1:Set({ Options = c3, CurrentOption = c14 })
    end

    local function c115(c1)
        local c3 = c1 and c113[c1]
        return c3 ~= nil and c3[4] ~= nil and os.clock() - c3[4] < 0.15
    end

    local function c116(c1, c3)
        if not c1 then
            return
        end
        local c14 = tostring(c3)
        local c17 = c113[c1]
        if c17 and c17[2] == "v" and c17[1] == c14 and c112(c1) == c3 then
            return
        end
        c113[c1] = { c14, "v" }
        c1:Set({ CurrentValue = c3 })
    end

    local function c117(c1, c3)
        if not c1 then
            return
        end
        local c14 = tostring(c3)
        local c17 = c113[c1]
        if c17 and c17[2] == "p" and c17[1] == c14 then
            return
        end
        c113[c1] = { c14, "p" }
        c1:Set({ Content = c3 })
        pcall(function()
            local c18 = c1.Instance and c1.Instance:FindFirstChild("Content")
            if c18 then
                c18.RichText = true
            end
        end)
    end

    local function c118(c1)
        local c3 = c1 and c1.Instance
        if not c3 then
            return false
        end
        local c14 = c3:FindFirstChild("PART_Backdrop")
        local c17 = c14 and c14:FindFirstChild("PART_Input")
        return c17 ~= nil and c17:IsFocused()
    end

    local function c119(c1)
        local c3 = c1 and c1.Instance
        if not c3 then
            return
        end
        local c14 = c3:FindFirstChild("PART_Backdrop")
        local c17 = c14 and c14:FindFirstChild("PART_Input")
        if not c17 then
            return
        end
        pcall(function()
            local c15 = game:GetService("TextService")
            local function c120(c13)
                local c78, c79 = pcall(function()
                    return c15:GetTextSize(c13, c17.TextSize, Enum.Font.Gotham, Vector2.new(10000, 10000)).X
                end)
                if c78 and c79 then
                    return c79
                end
                local c80 = c17.Text
                c17.Text = c13
                local c121 = c17.TextBounds.X
                c17.Text = c80
                return c121
            end
            local c18 = c17.Text
            local c19 = c18 ~= "" and c120(c18) or 0
            if c17.PlaceholderText ~= "" then
                c19 = math.max(c19, c120(c17.PlaceholderText))
            end
            local c61 = c19 + 30
            if c61 < 100 then
                c61 = 100
            end
            local c62 = c14.Parent and c14.Parent.AbsoluteSize.X or 0
            local c63 = c3:FindFirstChild("Header")
            local c74 = c63 and math.ceil(c63.TextBounds.X) or 0
            if c62 > 140 then
                local c75 = math.max(100, c62 - c74 - 20)
                if c61 > c75 then
                    c61 = c75
                end
            end
            if math.abs(c14.Size.X.Offset - c61) > 1 then
                c14.Size = UDim2.new(0, c61, 0, c14.Size.Y.Offset)
                c17.Size = UDim2.new(0, math.max(1, c61 - 30), 1, 0)
            end
        end)
    end

    local c122 = {}
    local c123 = nil
    local c124 = "rgb(212,186,106)"
    local c125 = {
        Info = "rgb(200,205,215)",
        Farming = "rgb(64,255,218)",
        Tokens = "rgb(255,140,0)",
        Multipliers = "rgb(80,218,226)",
    }
    local function c126(c1, c3)
        local c14 = tostring(c1)
        local c17 = "rgb(168,175,228)"
        if c3 then
            local c18 = c14:lower()
            if
                c18:find("couldn", 1, true)
                or c18:find("select ", 1, true)
                or c18:find("enter a valid", 1, true)
                or c18:find("you already", 1, true)
                or c18:find("failed", 1, true)
                or c18:find("skipped", 1, true)
                or c18:find("did not match", 1, true)
            then
                c17 = "rgb(255,106,97)"
            else
                c17 = "rgb(255,214,90)"
            end
        end
        local c19 = c3 or "Info"
        table.insert(
            c122,
            1,
            '<font color="'
                .. c124
                .. '">['
                .. os.date("%H:%M:%S")
                .. "]</font> "
                .. '<font color="'
                .. (c125[c19] or c125.Info)
                .. '">['
                .. c19
                .. "]</font> "
                .. '<font color="'
                .. c17
                .. '">'
                .. c14
                .. "</font>"
        )
        if #c122 > 10 then
            table.remove(c122)
        end
        if c123 then
            c117(c123, table.concat(c122, "\n"))
        end
    end

    local c127 = {}
    local function c128(c1, c3)
        if getgenv().cLTR_State ~= c4 then
            return
        end
        if c1 == "Farming" and c3 ~= "" then
            c3 = c102(c3)
        end
        c68.msg[c1] = c3
        local c14 = c127[c1]
        if c14 then
            c117(c14, c3 ~= "" and c3 or "Result appears here.")
        end
        if c3 ~= "" and not string.find(c3, "\n", 1, true) then
            c126(c96(c3), c1)
        end
        c73()
    end

    local c129 = {}
    local function c130()
        local c1 = {}
        if not c9 then
            return c1
        end
        local c3 = c129[1] and c129[1].Parent and c129[1] or c9:FindFirstChild("ScreenGui")
        if not (c3 and c3.Parent) then
            c3 = c129[6]
            if not (c3 and c3.Parent) then
                c3 = c9:FindFirstChild("ScreenGui", true) or c9
                c129[6] = c3
            end
        end
        c129[1] = c3
        local c14 = c129[2] and c129[2].Parent and c129[2]
            or (c3 and (c3:FindFirstChild("MenuFrame") or c3:FindFirstChild("MenuFrame", true)))
        c129[2] = c14
        local c17 = c129[3] and c129[3].Parent and c129[3]
            or (c14 and (c14:FindFirstChild("InfoFrame") or c14:FindFirstChild("InfoFrame", true)))
        c129[3] = c17
        local c121 = c17 or c3
        local c18 = c129[7]
        if not c18 then
            c18 = {}
            c129[7] = c18
        end
        if c121 then
            for c2, c19 in ipairs(c53) do
                local c61 = {}
                local c62 = c18[c19]
                if typeof(c62) == "Instance" and not c62.Parent then
                    c62 = nil
                end
                if not c62 and c18[c19] == false and os.clock() - (c18[c19 .. "T"] or 0) > 10 then
                    c18[c19] = nil
                end
                if not c62 and c18[c19] ~= false then
                    c62 = c121:FindFirstChild(c19 .. "Txt") or c121:FindFirstChild(c19 .. "Txt", true)
                    if not c62 and c3 and c121 ~= c3 then
                        c62 = c3:FindFirstChild(c19 .. "Txt", true)
                    end
                    c18[c19] = c62 or false
                    c18[c19 .. "T"] = os.clock()
                end
                if c62 and c62.Text and c62.Text ~= "" then
                    local c63 = string.match(c62.Text, ".*:%s*(.-)%s*$")
                        or string.match(c62.Text, "([%d%.]+%a+)%s*$")
                    if c63 and c49(c63) then
                        c61.v = c63
                    end
                end
                local c74 = c18[c19 .. "M"]
                if typeof(c74) == "Instance" and not c74.Parent then
                    c74 = nil
                end
                if not c74 and c18[c19 .. "M"] == false and os.clock() - (c18[c19 .. "MT"] or 0) > 10 then
                    c18[c19 .. "M"] = nil
                end
                if not c74 and c18[c19 .. "M"] ~= false then
                    c74 = c121:FindFirstChild(c19 .. "MultiplierTxt")
                        or c121:FindFirstChild(c19 .. "MultiplierTxt", true)
                    if not c74 and c3 and c121 ~= c3 then
                        c74 = c3:FindFirstChild(c19 .. "MultiplierTxt", true)
                    end
                    c18[c19 .. "M"] = c74 or false
                    c18[c19 .. "MT"] = os.clock()
                end
                if c74 and c74.Text and c74.Text ~= "" then
                    local c75 = c49(c74.Text)
                    if c75 then
                        c61.m = c75
                    end
                end
                if c61.v or c61.m then
                    c1[c19] = c61
                end
            end
        end
        return c1
    end

    local function c131()
        local c1, c3, c14 = nil, nil, nil
        if not c9 then
            return c1, c3, c14
        end
        local c17 = c129[1] and c129[1].Parent and c129[1] or c9:FindFirstChild("ScreenGui")
        c129[1] = c17
        if c17 then
            local c18 = c129[2] and c129[2].Parent and c129[2] or c17:FindFirstChild("MenuFrame")
            c129[2] = c18
            local c19 = c129[4] and c129[4].Parent and c129[4] or (c18 and c18:FindFirstChild("SpecialFrame"))
            c129[4] = c19
            if c19 then
                local c61 = c19:FindFirstChild("CurrentTokenEarning_Txt")
                if c61 and c61.Text and c61.Text ~= "" then
                    c3 = c49(c61.Text)
                end
                local c62 = c19:FindFirstChild("NextTokenEarningUpgrade_Txt")
                if c62 and c62.Text and c62.Text ~= "" then
                    local c63 = string.match(c62.Text, "(%d+)%s*[mM]in") or string.match(c62.Text, "(%d+)")
                    if c63 then
                        c14 = math.clamp(tonumber(c63), 1, 240)
                    end
                end
            end
            local c74 = c129[5] and c129[5].Parent and c129[5] or c17:FindFirstChild("CurrentGemImgBtn")
            c129[5] = c74
            local c75 = c74 and c74:FindFirstChild("AmountTxtBtn")
            if c75 and c75.Text and c75.Text ~= "" then
                c1 = c49(c75.Text)
            end
        end
        return c1, c3, c14
    end

    local c132 = c104[1]:CreateGroupbox({ Name = "Setup", Column = 1 }, "cF0")
    local c133 = c104[1]:CreateGroupbox({ Name = "Mode", Column = 1 }, "cF1")
    local c134 = c104[1]:CreateGroupbox({ Name = "Calculate", Column = 2 }, "cF2")

    local c135, c136, c137, c138, c139, c140, c141, c142
    local c143, c144, c145, c146, c147
    local c148
    local c149
    local c150 = false
    local c151 = {}
    local c152 = {}
    local c153 = {}
    local c154 = {}

    local c155 = {}
    for c1 = 0, 37 do
        local c3 = 2 ^ c1
        local c14 = c48(c3)
        c155[#c155 + 1] = c14
        c153[c14] = c3
    end

    local function c156(c1)
        local c3 = {}
        for c14, c17 in ipairs(c52[c1]) do
            c3[#c3 + 1] = c51(c17.name, c17.req)
        end
        return c3
    end

    local function c157()
        local c1 = {}
        for c2, c3 in ipairs(c57) do
            c1[#c1 + 1] = c3.name
                .. " -- "
                .. c48(c49(c3.ms) or 0)
                .. " MS / "
                .. c48(c49(c3.jf) or 0)
                .. " JF"
        end
        return c1
    end

    local function c158(c1)
        c151 = c156(c1)
        c114(c137, c151, nil)
        if c58[c1] then
            c152 = c157()
            c114(c139, c152, nil)
        else
            c152 = {}
            c114(c139, { "Not used" }, "Not used")
        end
    end

    local function c159(c1)
        local c3 = c69(c1)
        if not c118(c141) then
            c116(c141, c3.pw ~= "" and c3.pw or "")
        end
        if not c118(c142) then
            c116(c142, c3.ob or "")
        end
        if c3.ar and c52[c1][c3.ar] then
            c114(c137, c151, c151[c3.ar])
        else
            c114(c137, c151, nil)
        end
        if c58[c1] then
            if c3.wt and c57[c3.wt] then
                c114(c139, c152, c152[c3.wt])
            else
                c114(c139, c152, nil)
            end
        end
        if c3.mu and c153[c3.mu] then
            c114(c140, c155, c3.mu)
        elseif c3.mv then
            local c14 = c48(c3.mv)
            if c153[c14] then
                c114(c140, c155, c14)
            end
        end
        c150 = true
        c116(c145, c68.sp[c1])
        c116(c146, c68.gn[c1])
        c116(c147, c68.st[c1])
        c116(c143, c68.md[c1])
        c116(c144, not c68.md[c1])
        c150 = false
    end

    local c160, c161 = 0, nil
    local function c162(c1)
        c160 = os.clock()
        c161 = c1
        c158(c1)
        c159(c1)
        if c68.md[c1] then
            c149(c1, false)
        end
    end

    local function c163(c1)
        local c3 = (c1 and c84[c1]) or Color3.fromRGB(235, 236, 242)
        pcall(function()
            local c14 = c136 and c136.Instance and c136.Instance:FindFirstChild("Header")
            if c14 then
                c14.TextColor3 = c3
            end
        end)
        pcall(function()
            local c14 = c141 and c141.Instance and c141.Instance:FindFirstChild("Header")
            if c14 then
                c14.TextColor3 = c3
            end
        end)
        pcall(function()
            local c14 = c142 and c142.Instance and c142.Instance:FindFirstChild("Header")
            if c14 then
                c14.TextColor3 = c3
            end
        end)
        pcall(function()
            local c14 = c141 and c141.Instance and c141.Instance:FindFirstChild("PART_Backdrop")
            local c17 = c14 and c14:FindFirstChild("PART_Input")
            if c17 then
                c17.TextColor3 = Color3.fromRGB(64, 255, 218)
            end
        end)
        pcall(function()
            local c14 = c142 and c142.Instance and c142.Instance:FindFirstChild("PART_Backdrop")
            local c17 = c14 and c14:FindFirstChild("PART_Input")
            if c17 then
                c17.TextColor3 = Color3.fromRGB(96, 170, 255)
            end
        end)
    end

    local function c164(c1)
        pcall(function()
            local c3 = c138 and c138.Instance
            if c3 and c3.Parent then
                c3.Visible = (c1 == "MS" or c1 == "JF")
            end
        end)
    end

    c136 = c132:CreateLabel({ Name = "Category" }, "cFcat_l")
    c135 = c136:AddDropdown({
        Options = c53,
        Placeholder = "Select",
        Callback = function(c1)
            if not c111 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c52[c1] then
                return
            end
            c68.cat = c1
            c163(c1)
            c164(c1)
            if c1 == c161 and os.clock() - c160 < 1 then
                c73()
                return
            end
            c162(c1)
            c117(c148, c68.msg.Farming ~= "" and c68.msg.Farming or "Result appears here.")
            c73()
        end,
    }, "cFcat")

    c137 = c132:CreateLabel({ Name = "Area" }, "cFare_l"):AddDropdown({
        Options = { "Not selected" },
        Placeholder = "Select",
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c115(c137) then
                return
            end
            local c14 = c69(c3)
            local c17 = c1 and table.find(c151, c1) or nil
            c14.ar = c17
            c73()
        end,
    }, "cFare")

    c138 = c132:CreateLabel({ Name = "Weight (MS / JF)" }, "cFwgt_l")
    c139 = c138:AddDropdown({
        Options = { "Not used" },
        Placeholder = "Select",
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 or not c58[c3] then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c115(c139) then
                return
            end
            local c14 = c69(c3)
            c14.wt = c1 and table.find(c152, c1) or nil
            c73()
        end,
    }, "cFwgt")

    c140 = c132:CreateLabel({ Name = "Multiplier" }, "cFmul_l"):AddDropdown({
        Options = c155,
        Placeholder = "Select",
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c115(c140) then
                return
            end
            local c14 = c69(c3)
            if c1 then
                c14.mu = c1
                c14.mv = c153[c1] or c49(c1)
            else
                c14.mu = nil
                c14.mv = nil
            end
            c73()
        end,
    }, "cFmul")

    c141 = c132:CreateInput({
        Name = "Current Power",
        PlaceholderText = "Current power",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c69(c3).pw = tostring(c1)
            c73()
        end,
    }, "cFpw")

    c142 = c132:CreateInput({
        Name = "Power Objective",
        PlaceholderText = "Power objective",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c69(c3).ob = tostring(c1)
            c73()
        end,
    }, "cFob")

    c143 = c133:CreateToggle({
        Name = "Use Current Stats",
        Tooltip = "Live-syncs power, area and weight from the game GUI for this category.",
        CurrentValue = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if c150 then
                return
            end
            if not c3 then
                if c1 then
                    c150 = true
                    c116(c143, false)
                    c150 = false
                    c128("Farming", "Select a category first.")
                end
                return
            end
            c68.md[c3] = c1
            c150 = true
            c116(c144, not c1)
            c150 = false
            if c1 then
                c149(c3, true)
            else
                c159(c3)
            end
            c73()
        end,
    }, "cFcur")

    c144 = c133:CreateToggle({
        Name = "Use Other Stats",
        Tooltip = "Manual mode -- type your stats by hand.",
        CurrentValue = true,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if c150 then
                return
            end
            if not c3 then
                if c1 then
                    c150 = true
                    c116(c144, false)
                    c150 = false
                    c128("Farming", "Select a category first.")
                end
                return
            end
            c68.md[c3] = not c1
            c150 = true
            c116(c143, not c1)
            c150 = false
            if c1 then
                c159(c3)
            else
                c149(c3, true)
            end
            c73()
        end,
    }, "cFoth")

    c145 = c133:CreateToggle({
        Name = "Speed 2x",
        Tooltip = "Halves the time in boostable areas.",
        CurrentValue = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c68.sp[c3] = c1
            c73()
        end,
    }, "cFsp")

    c146 = c133:CreateToggle({
        Name = "Training 2x",
        Tooltip = "Doubles the gain in boostable areas.",
        CurrentValue = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c68.gn[c3] = c1
            c73()
        end,
    }, "cFgn")

    c147 = c133:CreateToggle({
        Name = "Stay on this area",
        Tooltip = "Ignores the next area and calculates with the selected one only.",
        CurrentValue = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.cat
            if not c3 then
                return
            end
            c68.st[c3] = c1
            c73()
        end,
    }, "cFst")

    c149 = function(c1, c3)
        local c14 = c130()
        local c17 = false
        local c18 = c69(c1)
        local c19 = c14[c1]
        if c19 then
            if c19.v then
                c18.pw = c19.v
            end
            if c19.m then
                c18.mu = tostring(c19.m)
                c18.mv = c19.m
            end
        end
        if c68.md[c1] and not c68.st[c1] then
            local c61 = c49(c18.pw)
            if c61 and c61 >= 0 then
                if c58[c1] and c61 < c49(c52[c1][1].req) then
                    if not c18.ar then
                        local c62, c63
                        if c1 == "MS" then
                            c62 = c61
                            c63 = c14.JF and c14.JF.v and c49(c14.JF.v) or nil
                        else
                            c63 = c61
                            c62 = c14.MS and c14.MS.v and c49(c14.MS.v) or nil
                        end
                        if c62 and c63 then
                            local c74 = c60(c62, c63)
                            if c74 and (not c18.wt or c74 > c18.wt or not c154[c1]) then
                                c18.wt = c74
                                c17 = true
                            end
                        end
                    end
                else
                    local c75 = c56(c1, c61)
                    if not c18.ar or c75 > c18.ar or not c154[c1] then
                        c18.ar = c75
                        c17 = true
                    end
                    if c18.wt then
                        c18.wt = nil
                        c17 = true
                    end
                end
                c154[c1] = true
            end
        end
        if not c118(c141) and c112(c141) ~= (c18.pw ~= "" and c18.pw or "") then
            c116(c141, c18.pw ~= "" and c18.pw or "")
        end
        if not c118(c142) and c112(c142) ~= (c18.ob or "") then
            c116(c142, c18.ob or "")
        end
        c114(c137, c151, c18.ar and c52[c1][c18.ar] and c151[c18.ar] or nil)
        if c58[c1] then
            c114(c139, c152, c18.wt and c57[c18.wt] and c152[c18.wt] or nil)
        end
        local c61 = c18.mu and c153[c18.mu] and c18.mu or nil

        if not c61 and c18.mv then
            local c62 = c48(c18.mv)
            c61 = c153[c62] and c62 or nil
        end

        c114(c140, c155, c61)
        if c3 and not c19 then
            c128("Farming", "Couldn't read your current stats. Put them manually or use Other Stats.")
        end
        return c17
    end

    c148 = c134:CreateParagraph(
        { Name = "Result", Content = c68.msg.Farming ~= "" and c68.msg.Farming or "Result appears here." },
        "cFres"
    )
    c127.Farming = c148

    c134:CreateButton({
        Name = "Calculate",
        Tooltip = "Estimates production and time for the selected setup.",
        Callback = function()
            local c1 = c68.cat
            if not c1 then
                c128("Farming", "Select a category first.")
                return
            end
            if c68.md[c1] then
                c149(c1, false)
            end
            local c165 = c112(c141)
            if c68.md[c1] and (c69(c1).pw or "") ~= "" then
                c165 = c69(c1).pw
            end
            local c166 = c49(c165)
            local c167 = 0
            if c58[c1] and c112(c139) then
                local c3 = table.find(c152, c112(c139))
                c167 = c3 or 0
            end
            local c168
            if c58[c1] and (not c166 or c166 < c49(c52[c1][1].req)) then
                if c167 > 0 and c57[c167] then
                    local c3 = c1 == "MS" and c57[c167].mm or c57[c167].jm
                    c168 = { name = c57[c167].name, multi = c3 or "?" }
                else
                    c167 = 0
                    c168 = { name = "No Weight", multi = "x1" }
                end
            end
            local c14 = table.find(c151, c112(c137))
            local c17 = c14 and c52[c1][c14] and c52[c1][c14].multi or nil
            if not c168 and (not c17 or not c14) then
                c128("Farming", "Select an area.")
                return
            end
            local c169 = c112(c140)
            local c18 = c169 and c153[c169] or nil
            if not c18 then
                c128("Farming", "Select a multiplier.")
                return
            end
            local function c170(c19, c61, c62)
                local c63 = c19
                local c74, c75, c76 = 0, {}, false
                local c77 = c65(c1)
                local function c15(c78, c79)
                    local c80 = c66(c1, c78) or 1
                    local c121 = c77[c80]
                    local c171 = c49(c121.mu)
                    local c13 = c121.bo
                    if not c171 then
                        c76 = true
                        c75[#c75 + 1] = c48(c78)
                            .. " > "
                            .. c48(c79)
                            .. " ("
                            .. (c121.dn or c121.nm)
                            .. "): ?"
                        return
                    end
                    local c16 = c171 * c18
                    if c68.gn[c1] and c13 then
                        c16 = c16 * 2
                    end
                    local c172 = (c79 - c78) / c16
                    if c68.sp[c1] and c13 then
                        c172 = c172 / 2
                    end
                    c74 = c74 + c172
                    c75[#c75 + 1] = c48(c78)
                        .. " > "
                        .. c48(c79)
                        .. " ("
                        .. (c121.dn or c121.nm)
                        .. "): "
                        .. c50(c172)
                end
                for c78 = 1, #c77 do
                    local c79 = c77[c78]
                    local c80 = c79.th
                    if c80 and c80 > c19 and c80 <= c61 then
                        c15(c19, c80)
                        c19 = c80
                    end
                end
                if c61 > c19 then
                    c15(c19, c61)
                end
                c128(
                    "Farming",
                    c62
                        .. c48(c63)
                        .. " to "
                        .. c48(c61)
                        .. " -- Total: "
                        .. (c76 and "?" or c50(c74))
                        .. "\n"
                        .. table.concat(c75, "\n")
                        .. (c76 and "\n-- ? = unknown multiplier" or "")
                )
            end
            if (c112(c142) or "") ~= "" then
                local c3 = c49(c112(c142))
                if not c3 or c3 <= 0 then
                    c128("Farming", "Power objective: enter a valid value above 0.")
                    return
                end
                local c19 = c49(c165)
                if not c19 or c19 <= 0 then
                    if c14 then
                        c19 = c49(c52[c1][c14].req) or 0
                    else
                        c19 = 0
                    end
                end
                if c3 <= c19 then
                    c128("Farming", "Power objective: you already have more than that! Put another value.")
                    return
                end
                local c61 = c19
                if c68.st[c1] then
                    local c62, c63
                    if c168 then
                        c62 = c49(c168.multi)
                        c63 = c59(c168.name)
                    else
                        c62 = c49(c17)
                        c63 = c52[c1][c14].name
                    end
                    local c74 = c168 and false or (not c55[c1] or c14 >= c55[c1])
                    local c75 = c62 and c62 * c18 or nil
                    if c75 and c68.gn[c1] and c74 then
                        c75 = c75 * 2
                    end
                    if c75 and c68.sp[c1] and c74 then
                        c75 = c75 * 2
                    end
                    local c76 = c75 and (c3 - c61) / c75 or nil
                    if not c76 then
                        c128(
                            "Farming",
                            "Power objective -- staying in "
                                .. c63
                                .. ": ?"
                                .. "\n-- ? = unknown "
                                .. (c168 and "weight" or "area")
                                .. " multiplier"
                        )
                        return
                    end
                    c128(
                        "Farming",
                        "Power objective -- "
                            .. c48(c61)
                            .. " to "
                            .. c48(c3)
                            .. " -- Staying in "
                            .. c63
                            .. "\nGain per second: "
                            .. c48(c75)
                            .. "\nGain per minute: "
                            .. c48(c75 * 60)
                            .. "\nGain per hour: "
                            .. c48(c75 * 3600)
                            .. "\nGain per day: "
                            .. c48(c75 * 8.64e4)
                            .. "\nGain per week: "
                            .. c48(c75 * 6.048e5)
                            .. "\nGain per month: "
                            .. c48(c75 * 2.592e6)
                            .. "\nGain per year: "
                            .. c48(c75 * 3.1536e7)
                            .. "\nTotal: "
                            .. c50(c76)
                    )
                    return
                end
                c170(c61, c3, "Power objective -- ")
                return
            end
            local c62, c63
            if c168 then
                if c14 and c52[c1][c14] then
                    c62 = c49(c52[c1][c14].req)
                    c63 = c52[c1][c14].name
                end
            elseif c58[c1] and c167 > 0 and c57[c167] then
                local c74 = c49(c1 == "MS" and c57[c167].ms or c57[c167].jf)
                if c74 and c166 and c74 > c166 then
                    c62 = c74
                    c63 = c59(c57[c167].name)
                end
            end
            if c62 and not c68.st[c1] then
                c170(c166 or 0, c62, "Path to " .. c63 .. " -- ")
                return
            end
            local c74, c75, c76
            if c168 then
                c74 = c49(c168.multi)
                c75 = false
                if c57[c167 + 1] then
                    c76 = c49(c1 == "MS" and c57[c167 + 1].ms or c57[c167 + 1].jf)
                else
                    c76 = c49(c52[c1][1].req)
                end
            else
                c74 = c49(c17)
                c75 = not c55[c1] or c14 >= c55[c1]
                if c52[c1][c14 + 1] then
                    local c77 = c52[c1][c14 + 1]
                    c76 = c49(c1 == "BT" and c77.min or c77.req)
                end
            end
            if not c74 then
                if c168 then
                    local c77 = "Unknown weight multiplier."
                    if c76 then
                        c77 = c77
                            .. "\nNext: "
                            .. (c57[c167 + 1] and c59(c57[c167 + 1].name) or c52[c1][1].name)
                            .. " at "
                            .. c48(c76)
                    end
                    c128("Farming", c77)
                else
                    c128("Farming", "Unknown area multiplier.")
                end
                return
            end
            local c77 = c74 * c18
            if c68.gn[c1] and c75 then
                c77 = c77 * 2
            end
            if c68.sp[c1] and c75 then
                c77 = c77 * 2
            end
            local c15 = c76 and math.max(0, c76 - (c49(c165) or 0)) or 0
            local c78 = c76 and c15 / c77 or 0
            local c79
            if c68.st[c1] then
                c79 = c168 and "Staying with this weight -- put a Power Objective to calculate the time."
                    or "Staying in this area -- put a Power Objective to calculate the time."
            elseif c76 then
                c79 = "Estimated time to next "
                    .. (c168 and (c57[c167 + 1] and "weight" or "area") or "area")
                    .. ": "
                    .. c50(c78)
            else
                c79 = "Last area selected."
            end
            c128(
                "Farming",
                "Production per second: "
                    .. c48(c77)
                    .. "\nPer minute: "
                    .. c48(c77 * 60)
                    .. "\nPer hour: "
                    .. c48(c77 * 3600)
                    .. "\nPer day: "
                    .. c48(c77 * 8.64e4)
                    .. "\n"
                    .. c79
            )
        end,
    }, "cFcalc")

    local c173 = c104[2]:CreateGroupbox({ Name = "Setup", Column = 1 }, "cT0")
    local c174 = c104[2]:CreateGroupbox({ Name = "Mode", Column = 1 }, "cT1")
    local c175 = c104[2]:CreateGroupbox({ Name = "Calculate", Column = 2 }, "cT2")

    local c176, c177, c178, c179, c180
    local c181, c182
    local c183
    local c184
    local c185
    local c186 = false

    c176 = c173:CreateInput({
        Name = "Tokens",
        PlaceholderText = "Tokens",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.md.TK and c68.tok.cur or c68.tok.oth
            c3.tk = tostring(c1)
            c73()
        end,
    }, "cTtok")

    c177 = c173:CreateInput({
        Name = "TPM",
        PlaceholderText = "TPM",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.md.TK and c68.tok.cur or c68.tok.oth
            c3.tp = tostring(c1)
            c73()
        end,
    }, "cTtpm")

    c178 = c173:CreateInput({
        Name = "Tokens Objective",
        PlaceholderText = "Tokens objective",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.md.TK and c68.tok.cur or c68.tok.oth
            c3.ob = tostring(c1)
            c73()
        end,
    }, "cTtob")

    c179 = c173:CreateInput({
        Name = "TPM Objective",
        PlaceholderText = "TPM objective",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.md.TK and c68.tok.cur or c68.tok.oth
            c3.to = tostring(c1)
            c73()
        end,
    }, "cTtto")

    c180 = c173:CreateInput({
        Name = "Time Spent",
        PlaceholderText = "e.g. 9d10h22m",
        RemoveTextOnFocus = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            local c3 = c68.md.TK and c68.tok.cur or c68.tok.oth
            c3.sp = tostring(c1)
            c73()
        end,
    }, "cTtsp")

    c173:CreateParagraph(
        {
            Name = "Passive growth",
            Content = "+1 TPM every 4H -- +6 TPM per day. Those numbers are based if you 24/7.",
        },
        "cTtinfo"
    )

    c181 = c174:CreateToggle({
        Name = "Use Current Stats",
        Tooltip = "Live-syncs tokens and TPM from the game GUI.",
        CurrentValue = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            if c186 then
                return
            end
            c68.md.TK = c1
            c186 = true
            c116(c182, not c1)
            c186 = false
            if c1 then
                c184(true)
            else
                c185()
            end
            c73()
        end,
    }, "cTcur")

    c182 = c174:CreateToggle({
        Name = "Use Other Stats",
        Tooltip = "Manual mode -- type your tokens and TPM by hand.",
        CurrentValue = true,
        Callback = function(c1)
            if not c111 then
                return
            end
            if c186 then
                return
            end
            c68.md.TK = not c1
            c186 = true
            c116(c181, not c1)
            c186 = false
            if c1 then
                c185()
            else
                c184(true)
            end
            c73()
        end,
    }, "cTgoth")

    c183 = c175:CreateParagraph(
        { Name = "Result", Content = c68.msg.Tokens ~= "" and c68.msg.Tokens or "Result appears here." },
        "cTres"
    )
    c127.Tokens = c183

    local function c187(c1, c3, c14)
        local c17 = math.floor(c14 / 240)
        local c18 = c14 - c17 * 240
        return c1 + c3 * c14 + 240 * c17 * (c17 - 1) / 2 + c18 * c17
    end

    local function c188(c1)
        c1 = tostring(c1):lower():gsub("%s", "")
        if c1 == "" then
            return nil
        end
        local c3, c14 = 0, nil
        for c17, c18 in c1:gmatch("([%d%.]+)([wdhms])") do
            local c19 = tonumber(c17)
            if c19 then
                c14 = true
                c3 = c3
                    + c19
                        * (c18 == "w" and 1.008e4 or c18 == "d" and 1440 or c18 == "h" and 60 or c18 == "m" and 1 or 1 / 60)
            end
        end
        if c14 then
            return c3
        end
        return tonumber(c1)
    end

    local function c189(c1, c3, c14, c17)
        if c14 <= c17 then
            return c1 + c3 * c14
        end
        return c1 + c3 * c17 + c187(0, c3 + 1, c14 - c17)
    end

    local function c190(c1, c3, c14)
        local c17 = c14 - c1
        if c17 <= 0 then
            return 0
        end
        if c3 <= 0 then
            return nil
        end
        local c18 = 240 * (-c3 + math.sqrt(c3 * c3 + c17 / 120))
        local c19 = math.max(1, math.ceil(c18))
        while c187(c1, c3, c19) < c14 do
            c19 = c19 * 2
        end
        local c61 = 0
        while c61 < c19 do
            local c62 = math.floor((c61 + c19) / 2)
            if c187(c1, c3, c62) < c14 then
                c61 = c62 + 1
            else
                c19 = c62
            end
        end
        return c61
    end

    c184 = function(c1)
        local c3, c14 = c131()
        local c17 = false
        if c3 then
            local c18 = tostring(c3)
            if c68.tok.cur.tk ~= c18 then
                c68.tok.cur.tk = c18
                c17 = true
            end
            if not c118(c176) and c112(c176) ~= c18 then
                c116(c176, c18)
            end
        end
        if c14 then
            local c18 = tostring(c14)
            if c68.tok.cur.tp ~= c18 then
                c68.tok.cur.tp = c18
                c17 = true
            end
            if not c118(c177) and c112(c177) ~= c18 then
                c116(c177, c18)
            end
        end
        local c18 = c68.md.TK and c68.tok.cur or c68.tok.oth
        if not c3 and not c118(c176) and c112(c176) ~= (c18.tk or "") then
            c116(c176, c18.tk or "")
        end
        if not c14 and not c118(c177) and c112(c177) ~= (c18.tp or "") then
            c116(c177, c18.tp or "")
        end
        if not c118(c178) and c112(c178) ~= (c18.ob or "") then
            c116(c178, c18.ob or "")
        end
        if not c118(c179) and c112(c179) ~= (c18.to or "") then
            c116(c179, c18.to or "")
        end
        if not c118(c180) and c112(c180) ~= (c18.sp or "") then
            c116(c180, c18.sp or "")
        end
        if c1 and not c3 and not c14 then
            c128("Tokens", "Couldn't read your current stats. Put them manually or use Other Stats.")
        end
        return c17
    end

    c185 = function()
        local c1 = c68.md.TK and c68.tok.cur or c68.tok.oth
        c186 = true
        c116(c181, c68.md.TK)
        c116(c182, not c68.md.TK)
        c186 = false
        if not c118(c176) then
            c116(c176, c1.tk or "")
        end
        if not c118(c177) then
            c116(c177, c1.tp or "")
        end
        if not c118(c178) then
            c116(c178, c1.ob or "")
        end
        if not c118(c179) then
            c116(c179, c1.to or "")
        end
        if not c118(c180) then
            c116(c180, c1.sp or "")
        end
    end

    c175:CreateButton({
        Name = "Calculate",
        Tooltip = "Token objective, TPM objective and time spent in one run.",
        Callback = function()
            local c1 = c49(c112(c176))
            local c3 = c49(c112(c177))
            local c14 = c49(c112(c178))
            local c17 = c49(c112(c179))
            local c18, c19, c79 = nil, nil, nil
            local c61 = 240
            if c68.md.TK then
                local c62, c63, c74 = c131()
                if c63 then
                    c3 = c63
                    c116(c177, tostring(c63))
                    c68.tok.cur.tp = tostring(c63)
                end
                if c62 then
                    c1 = c62
                    c116(c176, tostring(c62))
                    c68.tok.cur.tk = tostring(c62)
                end
                if c74 then
                    c61 = c74
                end
                if c62 or c63 then
                    c73()
                end
                if not c63 then
                    c128(
                        "Tokens",
                        "Current stats: couldn't read your TPM. Put it manually or use Other Stats."
                    )
                    return
                end
            end
            if c14 then
                if not c1 then
                    c18 = "Token objective: enter valid tokens."
                elseif not c3 or c3 <= 0 then
                    c18 = "Token objective: enter a TPM above 0."
                elseif c14 <= c1 then
                    c18 = "Token objective: you already have more than that! Put another value."
                else
                    local c75
                    if c14 - c1 <= c3 * c61 then
                        c75 = math.ceil((c14 - c1) / c3)
                    else
                        c75 = c61 + c190(c1 + c3 * c61, c3 + 1, c14)
                    end
                    local c76 = c75 > c61 and math.floor((c75 - c61 - 1) / 240) + 1 or 0
                    c18 = "Token objective -- Remaining: "
                        .. c48(c14 - c1)
                        .. "\nEstimated time: "
                        .. c50(c75 * 60)
                        .. "\nTPM on arrival: "
                        .. c48(c3 + c76)
                end
            end
            if c17 then
                if not c3 then
                    c19 = "TPM objective: enter a valid TPM."
                elseif c17 <= c3 then
                    c19 = "TPM objective: you already have more than that! Put another value."
                else
                    local c75 = c61 + (c17 - c3 - 1) * 240
                    c19 = "TPM objective -- TPM to gain: "
                        .. c48(c17 - c3)
                        .. "\nEstimated time: "
                        .. c50(c75 * 60)
                    if c1 then
                        c19 = c19 .. "\nTokens by then: " .. c48(c189(c1, c3, c75, c61))
                    else
                        c19 = c19 .. "\nTokens gained: " .. c48(c189(0, c3, c75, c61))
                    end
                end
            end
            local c76 = c188(c112(c180))
            if c76 then
                if not c3 or c3 <= 0 then
                    c79 = "Time spent: enter a TPM above 0."
                elseif c76 <= 0 then
                    c79 = "Time spent: enter a valid duration above 0."
                else
                    local c77, c15
                    if c76 <= c61 then
                        c77 = c3 * c76
                        c15 = c76 == c61 and 1 or 0
                    else
                        c77 = c3 * c61 + c187(0, c3 + 1, c76 - c61)
                        c15 = 1 + math.floor((c76 - c61) / 240)
                    end
                    c79 = "Time spent -- "
                        .. c50(c76 * 60)
                        .. "\nTokens gained: "
                        .. c48(c77)
                        .. (c1 and "\nTokens at end: " .. c48(c1 + c77) or "")
                        .. "\nTPM at end: "
                        .. c48(c3 + c15)
                end
            end
            local c77 = ""
            if c68.md.TK then
                c77 = "Current stats -- Tokens: "
                    .. (c1 and c48(c1) or "?")
                    .. " -- TPM: "
                    .. (c3 and c48(c3) or "?")
                    .. " -- Next +1 TPM in "
                    .. c61
                    .. " min\n\n"
            end
            local c15 = {}
            if c18 then
                c15[#c15 + 1] = c18
            end
            if c19 then
                c15[#c15 + 1] = c19
            end
            if c79 then
                c15[#c15 + 1] = c79
            end
            c128(
                "Tokens",
                c100(
                    c77
                        .. (
                            c15[1] and table.concat(c15, "\n-- --\n")
                            or "Fill TPM and at least one objective or a time spent to calculate."
                        )
                )
            )
        end,
    }, "cTcalc")

    local c191 = c104[3]:CreateGroupbox({ Name = "Setup", Column = 1 }, "cM0")
    local c192 = c104[3]:CreateGroupbox({ Name = "Mode", Column = 1 }, "cM1")
    local c193 = c104[3]:CreateGroupbox({ Name = "Calculate", Column = 2 }, "cM2")

    local c194 = {
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

    local function c195(c1)
        if not c1 or c1 <= 0 then
            return nil
        end
        local c3 = math.clamp(math.floor(math.log(c1) / math.log(2) + 0.5), 1, #c194)
        return c194[c3][1]
    end

    local function c196(c1)
        if not c1 or c1 == "" then
            return nil
        end
        local c3 = c49(c1)
        return c3 and c195(c3) or nil
    end

    for c2, c1 in ipairs(c53) do
        for c2, c3 in ipairs({ c68.ml.cur, c68.ml.oth }) do
            local c14 = c196(c3[c1])
            c3[c1] = c14 and tostring(c14) or nil
        end
    end

    local c197, c198
    local c199 = {}
    local c200 = false
    local c201
    local c202

    local c203 = {}
    local c204 = {}
    for c2, c1 in ipairs(c194) do
        local c3 = "x" .. c48(c1[1])
        c204[#c204 + 1] = c3
        c203[c3] = c1[1]
    end

    local c205, c206
    local c207 = {}
    local c208 = {}
    for c2, c1 in ipairs(c194) do
        local c3 = "x" .. c48(c1[1]) .. " -- " .. c48(c1[2])
        c208[#c208 + 1] = c3
        c207[c3] = c1[1]
    end

    c201 = function(c1)
        local c3 = c130()
        local c14, c17 = false, false
        for c2, c18 in ipairs(c53) do
            local c19 = c3[c18]
            if c19 and c19.m then
                c14 = true
                if not c68.ml.ov[c18] then
                    local c61 = c195(c19.m)
                    if c61 and c68.ml.cur[c18] ~= tostring(c61) then
                        c68.ml.cur[c18] = tostring(c61)
                        c17 = true
                    end
                end
            end
        end
        for c2, c18 in ipairs(c53) do
            local c19 = c196(c68.ml.cur[c18])
            local c61 = c199[c18]
            if c61 then
                if c19 then
                    c114(c61, c204, "x" .. c48(c19))
                else
                    c114(c61, c204, nil)
                end
            end
        end
        c114(c205, c208, c68.ml.tm)
        if c1 then
            if c14 then
                if c68.msg.Multipliers ~= "" and c68.msg.Multipliers:find("Couldn't read", 1, true) then
                    c128("Multipliers", "")
                end
            else
                c128("Multipliers", "Couldn't read your multipliers. Select them from the dropdowns.")
            end
        end
        return c17
    end

    c202 = function()
        c200 = true
        c116(c197, c68.md.ML)
        c116(c198, not c68.md.ML)
        c200 = false
        local c1 = c68.md.ML and c68.ml.cur or c68.ml.oth
        for c2, c3 in ipairs(c53) do
            local c14 = c196(c1[c3])
            if c14 then
                c114(c199[c3], c204, "x" .. c48(c14))
            else
                c114(c199[c3], c204, nil)
            end
        end
        if c68.ml.tg and c68.ml.tm and c207[c68.ml.tm] then
            c114(c205, c208, c68.ml.tm)
        end
    end

    for c2, c1 in ipairs(c53) do
        c199[c1] = c191:CreateLabel({ Name = c1 .. " Multiplier" }, "cM" .. c1 .. "_l"):AddDropdown({
            Options = c204,
            Placeholder = "Select",
            Callback = function(c3)
                if not c111 then
                    return
                end
                c3 = type(c3) == "table" and c3[1] or c3
                if not c3 and c115(c199[c1]) then
                    return
                end
                local c14 = c3 and c203[c3] or nil
                local c17 = c68.md.ML and c68.ml.cur or c68.ml.oth
                if c14 then
                    c17[c1] = tostring(c14)
                    if c68.md.ML then
                        c68.ml.ov[c1] = true
                    end
                else
                    c17[c1] = nil
                    if c68.md.ML then
                        c68.ml.ov[c1] = nil
                    end
                end
                c73()
            end,
        }, "cM" .. c1)
    end

    c205 = c191:CreateLabel({ Name = "Objective" }, "cMobj_l"):AddDropdown({
        Options = c208,
        Placeholder = "Select",
        Callback = function(c1)
            if not c111 then
                return
            end
            c1 = type(c1) == "table" and c1[1] or c1
            if not c1 and c115(c205) then
                return
            end
            if c1 and c207[c1] then
                c68.ml.tg = c207[c1]
                c68.ml.tm = c1
            else
                c68.ml.tg = nil
                c68.ml.tm = nil
            end
            c73()
        end,
    }, "cMobj")

    c197 = c192:CreateToggle({
        Name = "Use Current Stats",
        Tooltip = "Live-syncs your multipliers from the game GUI. Manual picks override the sync.",
        CurrentValue = false,
        Callback = function(c1)
            if not c111 then
                return
            end
            if c200 then
                return
            end
            c68.md.ML = c1
            c200 = true
            c116(c198, not c1)
            c200 = false
            if c1 then
                c201(true)
            else
                c202()
            end
            c73()
        end,
    }, "cMcur")

    c198 = c192:CreateToggle({
        Name = "Use Other Stats",
        Tooltip = "Manual mode -- pick your multipliers by hand.",
        CurrentValue = true,
        Callback = function(c1)
            if not c111 then
                return
            end
            if c200 then
                return
            end
            c68.md.ML = not c1
            c200 = true
            c116(c197, not c1)
            c200 = false
            if c1 then
                c202()
            else
                c201(true)
            end
            c73()
        end,
    }, "cMgoth")

    c206 = c193:CreateParagraph(
        {
            Name = "Result",
            Content = c68.msg.Multipliers ~= "" and c68.msg.Multipliers or "Result appears here.",
        },
        "cMres"
    )
    c127.Multipliers = c206

    c193:CreateButton({
        Name = "Calculate",
        Tooltip = "Sums the token cost of every upgrade up to the objective.",
        Callback = function()
            if c68.md.ML then
                c201(false)
            end
            local c1 = c68.ml.tg
            if not c1 then
                c128("Multipliers", "Select an objective multiplier.")
                return
            end
            local c3, c14, c17 = {}, 0, 0
            for c2, c18 in ipairs(c53) do
                local c19 = (c68.md.ML and c68.ml.cur or c68.ml.oth)[c18]
                local c61 = c196(c19)
                if not c61 then
                    c3[#c3 + 1] = c18 .. ": no multiplier"
                else
                    c17 = c17 + 1
                    local c62, c63 = 0, 0
                    for c2, c74 in ipairs(c194) do
                        if c74[1] > c61 and c74[1] <= c1 then
                            c62 = c62 + c74[2]
                            c63 = c63 + 1
                        end
                    end
                    if c63 == 0 then
                        c3[#c3 + 1] = c18 .. ": already x" .. c48(c61) .. " or higher"
                    else
                        c3[#c3 + 1] = c18
                            .. ": "
                            .. c48(c62)
                            .. " Tokens ("
                            .. c63
                            .. (c63 > 1 and " upgrades)" or " upgrade)")
                        c14 = c14 + c62
                    end
                end
            end
            if c17 == 0 then
                c128("Multipliers", "Multipliers -- select your multipliers or use Current Stats.")
                return
            end
            c128(
                "Multipliers",
                c101(
                    "Multipliers -- objective x"
                        .. c48(c1)
                        .. "\n"
                        .. table.concat(c3, "\n")
                        .. (
                            c14 > 0 and "\nTotal: " .. c48(c14) .. " Tokens"
                            or "\nNothing to buy for this objective."
                        )
                )
            )
        end,
    }, "cMcalc")

    local function c209(c1)
        local c3 = c48(c1)
        local c14, c17 = string.match(string.format("%.14e", c1), "([%d%.]+)e%+?(-?%d+)")
        c14 = c14:gsub("%.?0+$", "")
        return c3 .. " (" .. c14 .. "e" .. c17 .. ")"
    end

    local c210 = {
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

    local c211 = {
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

    local c212 = {}
    local c213 = {}

    do
        local c1 = c104[4]:CreateGroupbox({ Name = "Quest Skills", Column = 1 }, "cW0")
        c212[#c212 + 1] = c1
        local c3 = {}
        for c2, c14 in ipairs(c211) do
            c3[#c3 + 1] = c98(
                '<font color="rgb(235,236,242)">' .. c14[1] .. "</font>  --  Main Quest " .. c14[2] .. "+"
            )
            if c14[3] then
                c3[#c3 + 1] = c98(c99("   " .. c14[3]))
            end
            if c14[4] then
                for c2, c17 in ipairs(c14[4]) do
                    c3[#c3 + 1] = c98(c99("   " .. c17))
                end
            end
        end
        c213[#c213 + 1] =
            c1:CreateParagraph({ Name = "Quest Skills", Content = table.concat(c3, "\n") }, "cWq")
    end

    for c17, c1 in ipairs(c53) do
        local c3 = c210[c1]
        local c14 = c104[4]:CreateGroupbox(
            { Name = c3[1] .. " (" .. c1 .. ")", Column = c17 % 2 == 0 and 1 or 2 },
            "cW" .. c1
        )
        c212[#c212 + 1] = c14
        local c18 = {}
        for c2, c19 in ipairs(c3[2]) do
            c18[#c18 + 1] = '<font color="rgb(235,236,242)">'
                .. c19[2]
                .. '</font>  --  <font color="'
                .. c86[c1]
                .. '">'
                .. c19[1]
                .. '</font>  --  <font color="'
                .. c92
                .. '">Tier '
                .. c19[3]
                .. "</font>"
            for c61 = 1, 6 do
                c18[#c18 + 1] = '   <font color="'
                    .. c86[c1]
                    .. '">LVL'
                    .. c61
                    .. ":</font> "
                    .. c99(c209(c19[4][c61]))
            end
        end
        c213[#c213 + 1] =
            c14:CreateParagraph({ Name = c3[1], Content = table.concat(c18, "\n") }, "cWp" .. c1)
    end

    local c214 = c104[5]:CreateGroupbox({ Name = "General", Column = 1 }, "cS0")

    c214:CreateToggle({
        Name = "Auto Hide UI",
        Tooltip = "Enabled -- the UI starts minimized on next execution (restore with your Minimize Bind).",
        CurrentValue = c68.hide,
        Callback = function(c1)
            if not c111 then
                return
            end
            c68.hide = c1
            c126("Auto Hide UI " .. (c1 and "enabled" or "disabled"))
            c73()
        end,
    }, "cShide")

    local c215 = tostring(c46.WindowKeybind or "F2")

    c214:CreateLabel({ Name = "Minimize Keybind" }, "cSbind_l"):AddBind({
        CurrentValue = c215,
        WindowSetting = true,
        Tooltip = "Key to hide or show the cLTR window.",
        Callback = function() end,
        OnChangedCallback = function(c1)
            pcall(function()
                c1 = tostring(c1)
                if c1 ~= c215 then
                    c215 = c1
                    c126("Minimize keybind set to " .. c1)
                end
            end)
        end,
    }, "cSbind")

    local c216 = c104[5]:CreateGroupbox({ Name = "Autoload (this account)", Column = 1 }, "cS2")

    local c217
    do
        local c1, c3 = pcall(function()
            return c104[5]:BuildConfigGroupbox(2)
        end)
        if c1 and typeof(c3) == "table" then
            c217 = c3
        end
    end
    if not c217 then
        c126("Configuration section skipped -- Starlight config system could not build")
    end
    pcall(function()
        if c217 and c217.Elements then
            for c1, c3 in pairs(c217.Elements) do
                if c3 and c3.Class == "Divider" then
                    c3.IgnoreConfig = true
                end
            end
        end
    end)

    local function c218()
        local c1 = nil
        pcall(function()
            local c3 = c217 and c217.Elements and c217.Elements["__prebuiltConfigSelector_lbl"]
            local c14 = c3 and c3.NestedElements and c3.NestedElements["__prebuiltConfigSelector_lbl"]
            local c17 = c14 and c14.Values and c14.Values.CurrentOption
            if type(c17) == "table" then
                c1 = c17[1]
            elseif type(c17) == "string" then
                c1 = c17
            end
        end)
        return c1
    end

    local c219 = c216:CreateButton({
        Name = "Set autoload for this account",
        Tooltip = "Current: none",
        Callback = function()
            local c1 = c218()
            if typeof(c1) ~= "string" or c1 == "" then
                c46:Notification({
                    Title = "cLTR Calculators",
                    Content = "Autoload\nPick a config in the Configuration list first.",
                    Duration = 6,
                })
                return
            end
            c68.alsm = c1
            cSaload:Set({ Tooltip = "Current: " .. c1 })
            c126("Autoload for this account set to " .. c1)
            c73()
        end,
    }, "cSaload")

    c216:CreateButton({
        Name = "Clear autoload for this account",
        Tooltip = "Falls back to the shared autoload config, if any.",
        Callback = function()
            c68.alsm = nil
            c219:Set({ Tooltip = "Current: none" })
            c126("Autoload for this account cleared")
            c73()
        end,
    }, "cSalclean")

    if typeof(c68.alsm) == "string" and c68.alsm ~= "" then
        c219:Set({ Tooltip = "Current: " .. c68.alsm })
    end

    local c220 = c104[5]:CreateGroupbox({ Name = "Activity Log", Column = 1 }, "cS1")
    c123 = c220:CreateParagraph({ Name = "Log", Content = "No activity yet." }, "cSlog")
    if #c122 > 0 then
        c117(c123, table.concat(c122, "\n"))
    end
    c220:CreateButton({
        Name = "Clear",
        Tooltip = "Clears the activity log.",
        Callback = function()
            table.clear(c122)
            c117(c123, "No activity yet.")
        end,
    }, "cSclear")

    local c221 = c104[5]:CreateGroupbox({ Name = "Danger Zone", Column = 2 }, "cS3")

    local function c222()
        c70()
        pcall(function()
            local c1 = c46.FileSystem and c46.FileSystem.AutoloadConfigPath
            if c1 and isfolder and isfolder(c1) then
                c46.FileSystem:SaveConfig(c7.Name, c1)
            end
        end)
        if c72 then
            pcall(task.cancel, c72)
        end
        for c2, c1 in pairs(c4.th) do
            if typeof(c1) == "thread" and coroutine.status(c1) ~= "dead" then
                pcall(task.cancel, c1)
            end
        end
        table.clear(c4.th)
        pcall(function()
            c46.Window = nil
            c46:Destroy()
        end)
        pcall(function()
            if c46.Instance and c46.Instance.Parent then
                c46.Instance:Destroy()
            end
        end)
        table.clear(c113)
        table.clear(c122)
        table.clear(c64)
        getgenv().cLTR_State = nil
    end

    c221:CreateButton({
        Name = "Uninject",
        Tooltip = "Fully unloads cLTR and closes everything it created.",
        Callback = function()
            c83:PromptDialog({
                Name = "Uninject",
                Content = "Fully unload cLTR Calculators and close everything it created?",
                Type = 1,
                Actions = {
                    Primary = {
                        Name = "Confirm",
                        Callback = c222,
                    },
                    {
                        Name = "Cancel",
                        Callback = function() end,
                    },
                },
            })
        end,
    }, "cSunj")

    local function c223()
        local c1 = nil
        pcall(function()
            c1 = c46.FileSystem and c46.FileSystem.AutoloadConfigPath
        end)
        if not c1 or not isfolder or not isfolder(c1) then
            return
        end
        if typeof(c68.alsm) == "string" and c68.alsm ~= "" and not isfile(c1 .. "autoload.txt") then
            pcall(function()
                writefile(c1 .. "autoload.txt", c68.alsm)
            end)
        end
    end

    local c224 = {
        [1] = { Color3.fromRGB(255, 228, 64), Color3.fromRGB(158, 132, 20) },
        [3] = { Color3.fromRGB(80, 218, 226), Color3.fromRGB(24, 122, 130) },
        [4] = { Color3.fromRGB(178, 132, 255), Color3.fromRGB(96, 60, 158) },
        [5] = { Color3.fromRGB(176, 182, 192), Color3.fromRGB(88, 94, 104) },
    }
    local function c225()
        for c3, c14 in pairs(c224) do
            pcall(function()
                local c17 = c104[c3] and c104[c3].Instances and c104[c3].Instances.Button
                local c18 = c17 and c17:FindFirstChild("Header")
                if c18 then
                    if c18:GetAttribute("cTabTint") ~= c14[1] then
                        c18:SetAttribute("cTabTint", c14[1])
                    end
                    if c18.TextColor3 ~= c14[1] then
                        c18.TextColor3 = c14[1]
                    end
                    local c19 = c18:FindFirstChild("AccentBrighter")
                    if c19 then
                        if not c19.Enabled or c19.Color ~= c14[2] then
                            c19.Enabled = true
                            c19.Color = c14[2]
                        end
                    end
                end
            end)
        end
    end

    local function c226()
        pcall(function()
            local c1 = c46.Instance and c46.Instance:FindFirstChild("Tooltips")
            if not c1 then
                return
            end
            for c2, c3 in ipairs(c1:GetChildren()) do
                c3.Visible = false
            end
        end)
    end

    c4.th[#c4.th + 1] = task.spawn(function()
        while true do
            task.wait(1)
            if (not c46.Instance or not c46.Instance.Parent) or getgenv().cLTR_State ~= c4 then
                break
            end
            if c111 and not c46.Minimized then
                pcall(function()
                    if c68.cat and c68.md[c68.cat] then
                        c149(c68.cat, false)
                    end
                end)
                pcall(function()
                    if c68.md.TK then
                        c184(false)
                    end
                end)
                pcall(function()
                    if c68.md.ML then
                        c201(false)
                    end
                end)
                pcall(function()
                    if c106 or os.clock() - c107 < 0.5 then
                        return
                    end
                    if c109 then
                        c109(c104[c68.view] or c104[1])
                    end
                end)
                c225()
            else
                c226()
            end
        end
    end)

    pcall(function()
        local c227 = Font.new("rbxasset://fonts/families/GothamSSm.json")
        local c228 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
        local c229 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
        local c230 = c46.Instance
        if typeof(c230) ~= "Instance" then
            return
        end
        local c231 = Color3.fromRGB(161, 169, 225)
        local c232 = Color3.fromRGB(235, 236, 242)
        local c233 = Color3.fromRGB(186, 189, 199)
        local c234 = Color3.fromRGB(168, 175, 228)
        local c235 = Color3.fromRGB(150, 153, 163)
        local c170 = Color3.fromRGB(207, 211, 221)
        local c236 = {}
        for c2, c1 in ipairs(c212) do
            pcall(function()
                if c1.Instance then
                    c236[c1.Instance] = true
                end
            end)
        end
        local c237 = {}
        for c2, c1 in ipairs(c213) do
            pcall(function()
                if c1.Instance then
                    local c3 = c1.Instance:FindFirstChild("Content")
                    if c3 then
                        c237[c3] = true
                    end
                end
            end)
        end
        local c238 = {}
        for c2, c1 in pairs(c127) do
            pcall(function()
                if c1.Instance then
                    local c3 = c1.Instance:FindFirstChild("Content")
                    if c3 then
                        c238[c3] = true
                    end
                end
            end)
        end
        for c2, c1 in ipairs(c230:GetDescendants()) do
            if c1:IsA("TextBox") or c1:IsA("TextLabel") or c1:IsA("TextButton") then
                local c3 = c1.Parent
                local c14 = c3 and c3.Name or ""
                local c17 = false
                local c18 = c1
                while c18 and c18 ~= c230 do
                    if c18.Name == "Loading Screen" then
                        c17 = true
                        break
                    end
                    c18 = c18.Parent
                end
                if not c17 then
                    if c1:IsA("TextBox") then
                        c1.FontFace = c227
                        c1.TextSize = 12
                    elseif c14 == "Sidebar" and c1.Name == "Header" then
                        c1.FontFace = c229
                        c1.TextSize = 17
                        c1.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif c1.Name == "subheader" then
                        c1.FontFace = c227
                        c1.TextSize = 11
                        c1.TextColor3 = c235
                    elseif c14 == "Player" then
                        c1.FontFace = c228
                        c1.TextSize = 13
                        c1.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif c14 == "Headers" then
                        c1.FontFace = c228
                        c1.TextSize = 13
                        c1.TextColor3 = c234
                    elseif c14:match("^TAB_%d+$") and c1.Name == "Header" then
                        c1.FontFace = c228
                        c1.TextSize = 14
                    elseif c14:match("^GROUPBOX_%d+$") and c1.Name == "Header" then
                        c1.FontFace = c229
                        c1.TextSize = c236[c3] and 16 or 13
                        c1.TextColor3 = c231
                    elseif c1.Name == "Content" and c14:match("^PARAGRAPH_") then
                        c1.FontFace = c227
                        c1.TextSize = c237[c1] and 16 or (c238[c1] and 14 or 12)
                        c1.TextColor3 = c237[c1] and c170 or (c238[c1] and c232 or c233)
                        c1.RichText = true
                    elseif
                        c1.Name == "Header"
                        and (
                            c14:match("^BUTTON_")
                            or c14:match("^CHECKBOX_")
                            or c14:match("^SWITCH_")
                            or c14:match("^BIND_")
                            or c14:match("^LABEL_")
                            or c14:match("^INPUT_")
                            or c14:match("^DROPDOWN_")
                            or c14:match("^PARAGRAPH_")
                        )
                    then
                        c1.FontFace = c228
                        c1.TextSize = 13
                        c1.TextColor3 = c232
                    else
                        c1.FontFace = c227
                    end
                    local c19 = c1.Text
                    if type(c19) == "string" and c19 ~= "" and not (c14:match("^TAB_%d+$")) then
                        local c61 = c97(c19)
                        if c61 then
                            c1.TextColor3 = c84[c61]
                        elseif c19 == "Quest Skills" then
                            c1.TextColor3 = c90
                        elseif c19 == "Tokens" or c19 == "Tokens Objective" then
                            c1.TextColor3 = c87
                            c1.TextStrokeColor3 = c89
                            c1.TextStrokeTransparency = 0.4
                        end
                    end
                end
            end
        end
    end)

    for c1, c3 in pairs(c127) do
        if c68.msg[c1] ~= nil and c68.msg[c1] ~= "" then
            c117(c3, c68.msg[c1])
        end
    end
    for c2, c1 in ipairs({ c141, c142, c176, c177, c178, c179, c180 }) do
        c119(c1)
    end
    task.delay(1.25, function()
        for c2, c1 in ipairs({ c141, c142, c176, c177, c178, c179, c180 }) do
            c119(c1)
        end
    end)

    c225()

    c111 = true

    pcall(function()
        local c1 = c46.Window and c46.Window.TabSections
        for c2, c3 in pairs(c1 or {}) do
            for c2, c14 in pairs(c3.Tabs or {}) do
                for c2, c17 in pairs(c14.Groupboxes or {}) do
                    for c2, c18 in pairs(c17.Elements or {}) do
                        if c18.Class ~= "Bind" then
                            c18.IgnoreConfig = true
                        end
                        for c2, c19 in pairs(c18.NestedElements or {}) do
                            if c19.Class ~= "Bind" then
                                c19.IgnoreConfig = true
                            end
                        end
                    end
                end
            end
        end
    end)

    if c68.cat and c52[c68.cat] then
        c114(c135, c53, c68.cat)
        c163(c68.cat)
        c164(c68.cat)
        c162(c68.cat)
        c117(c148, c68.msg.Farming ~= "" and c68.msg.Farming or "Result appears here.")
    end

    c163(c68.cat)

    c164(c68.cat)

    c185()

    c202()

    pcall(function()
        if c68.md.TK then
            c184(false)
        end
        if c68.md.ML then
            c201(false)
        end
        if c68.cat and c68.md[c68.cat] then
            c149(c68.cat, false)
        end
    end)

    pcall(function()
        if c68.md[c68.cat] then
            if c68.msg.Farming == "" then
                c128(
                    "Farming",
                    "Use Current Stats is on -- "
                        .. c68.cat
                        .. " auto selected, live stats sync into the inputs."
                )
            end
        elseif c68.msg.Farming:find("Use Current Stats is on", 1, true) then
            c128("Farming", "")
        end
        if c68.md.TK then
            if c68.msg.Tokens == "" then
                c128("Tokens", "Use Current Stats is on -- your current tokens and TPM sync into the inputs.")
            end
        elseif c68.msg.Tokens:find("Use Current Stats is on", 1, true) then
            c128("Tokens", "")
        end
        if c68.md.ML then
            if c68.msg.Multipliers == "" then
                c128(
                    "Multipliers",
                    "Use Current Stats is on -- your current multipliers sync into the dropdowns."
                )
            end
        elseif c68.msg.Multipliers:find("Use Current Stats is on", 1, true) then
            c128("Multipliers", "")
        end
    end)

    c4.th[#c4.th + 1] = task.delay(0.8, function()
        if getgenv().cLTR_State ~= c4 or not c111 then
            return
        end
        pcall(function()
            if c68.cat and c52[c68.cat] then
                if c68.md[c68.cat] then
                    c149(c68.cat, false)
                end
                c159(c68.cat)
            end
        end)
        pcall(function()
            if c68.md.TK then
                c184(false)
            end
            c185()
        end)
        pcall(function()
            if c68.md.ML then
                c201(false)
            end
            c202()
        end)
        c225()
    end)

    if typeof(c68.alsm) ~= "string" or c68.alsm == "" then
        c68.alsm = c7.Name
        c73()
    end
    pcall(function()
        local c1 = c46.FileSystem and c46.FileSystem.AutoloadConfigPath
        local c3 = c46.FileSystem and c46.FileSystem.FileExtension or ".starlight"
        if c1 and isfolder and isfolder(c1) and isfile and not isfile(c1 .. c7.Name .. c3) then
            local c14, c17 = pcall(function()
                return c46.FileSystem:SaveConfig(c7.Name, c1)
            end)
            if c14 and c17 == true then
                c126("Auto created config " .. c7.Name .. " for this account")
            end
        end
    end)
    pcall(function()
        if typeof(c68.alsm) == "string" and c68.alsm ~= "" then
            c219:Set({ Tooltip = "Current: " .. c68.alsm })
        end
    end)

    c223()

    c109 = function(c1)
        pcall(function()
            for c3, c14 in pairs(c46.Window.TabSections) do
                for c17, c18 in pairs(c14.Tabs) do
                    c18.Active = false
                end
            end
        end)
        for c3, c14 in ipairs(c104) do
            pcall(function()
                local c17 = c14.Instances.Button
                local c18 = (c14 == c1)
                local c19 = c46.CurrentTheme and c46.CurrentTheme.Foregrounds
                c14.Active = c18
                c17.BackgroundTransparency = c18 and 0.5 or 1
                if c17.Header then
                    c17.Header.TextColor3 = c17.Header:GetAttribute("cTabTint")
                        or (c18 and c19.Light or c19.Medium)
                    local c61 = c17.Header:FindFirstChild("AccentBrighter")
                    if c61 then
                        c61.Enabled = c18 or c17.Header:GetAttribute("cTabTint") ~= nil
                    end
                end
                if c17.Icon then
                    c17.Icon.ImageColor3 = c18 and c19.Light or c19.Medium
                    local c61 = c17.Icon:FindFirstChild("AccentBrighter")
                    if c61 then
                        c61.Enabled = c18
                    end
                end
            end)
        end
        pcall(function()
            c46.Window.CurrentTab = c1
        end)
        pcall(function()
            local c3 = c1.Instances.Page.Parent:FindFirstChildOfClass("UIPageLayout")
            if c3 and c3.CurrentPage ~= c1.Instances.Page then
                c3:JumpTo(c1.Instances.Page)
            end
        end)
    end
    local function c239(c1)
        c1 = c1 or 0
        if getgenv().cLTR_State ~= c4 then
            return
        end
        if c108 or c1 >= 10 then
            c106 = false
            return
        end
        pcall(function()
            local c3 = c46.Instance
            local c14 = c3 and c3:FindFirstChild("Content")
            local c17 = c14 and c14:FindFirstChild("ContentMain")
            local c18 = c17 and c17:FindFirstChild("Elements")
            local c19 = c18 and c18:FindFirstChild("HomeTab")
            if c19 then
                c19:Destroy()
            end
        end)
        local c3 = c104[c82] or c104[1]
        local c14 = c3 and c3.Instances and c3.Instances.Page
        if not c14 or not c14.Parent then
            task.delay(0.25, function()
                c239(c1 + 1)
            end)
            return
        end
        local c17 = c14.Parent:FindFirstChildOfClass("UIPageLayout")
        if c17 and c17.CurrentPage ~= c14 then
            pcall(function()
                c17:JumpTo(c14)
            end)
        end
        pcall(c109, c3)
        local c61 = c107
        task.delay(0.3, function()
            if getgenv().cLTR_State ~= c4 then
                return
            end
            if c107 ~= c61 then
                c108 = true
                c106 = false
                return
            end
            local c62 = c14.Parent and c14.Parent:FindFirstChildOfClass("UIPageLayout")
            if c62 and c62.CurrentPage == c14 then
                c109(c3)
                c68.view = c82
                c73()
                c108 = true
                c106 = false
                c107 = os.clock()
            else
                c239(c1 + 1)
            end
        end)
    end
    c239()

    c4.th[#c4.th + 1] = task.spawn(function()
        for c2 = 1, 5 do
            task.wait(1)
            if getgenv().cLTR_State ~= c4 then
                break
            end
            pcall(function()
                local c1 = c83.Instance
                local c3 = c1 and c1:FindFirstChild("Content")
                local c14 = c3 and c3:FindFirstChild("ContentMain")
                local c17 = c14 and c14:FindFirstChild("Elements")
                if c17 then
                    local c18 = c17:FindFirstChild("HomeTab")
                    if c18 then
                        c18:Destroy()
                    end
                end
            end)
            if not c108 then
                pcall(function()
                    c239(0)
                end)
            end
        end
    end)
    task.delay(0.75, c225)
    if c68.hide then
        c46.Minimized = true
        pcall(function()
            c83.Instance.Visible = false
            c46.Instance.Drag.Visible = false
        end)
        c226()
    else
        c4.th[#c4.th + 1] = task.delay(0.35, function()
            pcall(function()
                if c46.Minimized then
                    return
                end
                c83.Instance.Visible = true
                c46.Instance.Drag.Visible = true
                local c1 = c83.Instance:FindFirstChildOfClass("UIScale")
                if not c1 then
                    c1 = Instance.new("UIScale")
                    c1.Scale = 0.96
                    c1.Parent = c83.Instance
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

    c46:Notification({
        Title = "cLTR Calculators",
        Content = "Loaded -- press " .. tostring(c46.WindowKeybind or "F2") .. " to show or hide this UI",
        Duration = 6,
    })

    c126(
        "Session started -- Auto Hide UI "
            .. (c68.hide and "ON" or "OFF")
            .. " -- hide/show key: "
            .. tostring(c46.WindowKeybind or "F2")
    )
    c70()
end, function(c18)
    pcall(function()
        local c1 = getgenv().cLTR_State
        local c3 = c1 and c1.lib
        if c3 and c3.Instance then
            c3.Minimized = false
            local c14 = c3.Instance:FindFirstChild("MainWindow")
            if c14 then
                c14.Visible = true
            end
            local c17 = c3.Instance:FindFirstChild("Drag")
            if c17 then
                c17.Visible = true
            end
        end
    end)
    c("Startup failed -- " .. tostring(c18):sub(1, 140))
    warn("[cLTR] " .. debug.traceback(tostring(c18), 2))
end)
