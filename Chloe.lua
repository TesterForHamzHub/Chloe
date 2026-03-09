-- Chloe X | FishIt - Clean Version (Hanya ambil dari document lu, ga kurang ga lebih)
-- GUI aku bikin sendiri biar rapi + ada Loading Screen pas execute
-- Fitur penting doang: Instant Fishing + Teleport (logic 100% dari document lu)
-- Tinggal execute bro, langsung jalan!

local v0 = {
    Players = game:GetService("Players"),
    RS = game:GetService("ReplicatedStorage"),
    Camera = workspace.CurrentCamera
}

local l_LocalPlayer_0 = v0.Players.LocalPlayer

-- === SETUP NET & FUNCTIONS (langsung dari document) ===
local v5 = {
    Net = v0.RS.Packages._Index["sleitnick_net@0.2.0"].net,
    FishingController = require(v0.RS.Controllers.FishingController)
}

local v6 = {
    Functions = {
        ChargeRod = v5.Net["RF/ChargeFishingRod"],
        StartMini = v5.Net["RF/RequestFishingMinigameStarted"]
    },
    Events = {
        REFishDone = v5.Net["RE/FishingCompleted"]
    }
}

-- === VARIABEL PENTING (dari document) ===
local v8 = {
    autoInstant = false,
    canFish = true,
    player = l_LocalPlayer_0
}

_G.DelayCast = _G.DelayCast or 0.2
_G.DelayComplete = _G.DelayComplete or 0.5

-- getFishCount (copy paste dari document)
local function getFishCount()
    local l_BagSize_0 = v8.player.PlayerGui:WaitForChild("Inventory"):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Options"):WaitForChild("Fish"):WaitForChild("Label"):WaitForChild("BagSize")
    return tonumber((l_BagSize_0.Text or "0/???"):match("(%d+)/")) or 0
end

-- Hook FishingMinigameChanged (copy paste dari document)
local l_net_0 = v0.RS.Packages._Index["sleitnick_net@0.2.0"].net
local v174 = l_net_0:FindFirstChild("RE/FishingMinigameChanged") or l_net_0:FindFirstChild("FishingMinigameChanged")
if v174 and not _G.HookedMini then
    _G.HookedMini = true
    v174.OnClientEvent:Connect(function(v175, v176)
        if v175 and v176 then
            _G.FishMiniData = v176
        end
    end)
end

-- === LOADING SCREEN (aku bikin sendiri biar keren) ===
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "ChloeXLoading"
loadingGui.Parent = l_LocalPlayer_0:WaitForChild("PlayerGui")
loadingGui.ResetOnSpawn = false

local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 420, 0, 180)
loadFrame.Position = UDim2.new(0.5, -210, 0.5, -90)
loadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadFrame.BorderSizePixel = 0
loadFrame.Parent = loadingGui

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 12)
loadCorner.Parent = loadFrame

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0.35, 0)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "Chloe X | FishIt"
loadTitle.TextColor3 = Color3.fromRGB(0, 208, 255)
loadTitle.TextScaled = true
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Parent = loadFrame

local loadStatus = Instance.new("TextLabel")
loadStatus.Size = UDim2.new(1, 0, 0.3, 0)
loadStatus.Position = UDim2.new(0, 0, 0.35, 0)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "Loading script... (dari document lu)"
loadStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
loadStatus.TextScaled = true
loadStatus.Font = Enum.Font.Gotham
loadStatus.Parent = loadFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0.08, 0)
progressBar.Position = UDim2.new(0.05, 0, 0.8, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 208, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = loadFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 6)
progressCorner.Parent = progressBar

-- Animate loading
task.spawn(function()
    for i = 0, 1, 0.02 do
        progressBar.Size = UDim2.new(i, 0, 0.08, 0)
        task.wait(0.03)
    end
    task.wait(0.5)
    loadingGui:Destroy()
end)

task.wait(2.2) -- loading selesai

-- === MAIN GUI RAPI (aku bikin sendiri - 2 tab: Fishing & Teleport) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChloeXFishIt"
screenGui.Parent = l_LocalPlayer_0:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 460)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 208, 255)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Chloe X | FishIt"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 45)
tabBar.Position = UDim2.new(0, 0, 0, 50)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBar.Parent = mainFrame

local fishingTab = Instance.new("TextButton")
fishingTab.Size = UDim2.new(0.5, 0, 1, 0)
fishingTab.BackgroundColor3 = Color3.fromRGB(0, 208, 255)
fishingTab.Text = "Fishing"
fishingTab.TextColor3 = Color3.fromRGB(0, 0, 0)
fishingTab.TextScaled = true
fishingTab.Font = Enum.Font.GothamBold
fishingTab.Parent = tabBar

local teleTab = Instance.new("TextButton")
teleTab.Size = UDim2.new(0.5, 0, 1, 0)
teleTab.Position = UDim2.new(0.5, 0, 0, 0)
teleTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleTab.Text = "Teleport"
teleTab.TextColor3 = Color3.fromRGB(255, 255, 255)
teleTab.TextScaled = true
teleTab.Font = Enum.Font.GothamBold
teleTab.Parent = tabBar

-- Content Frames
local fishingContent = Instance.new("Frame")
fishingContent.Size = UDim2.new(1, 0, 1, -95)
fishingContent.Position = UDim2.new(0, 0, 0, 95)
fishingContent.BackgroundTransparency = 1
fishingContent.Visible = true
fishingContent.Parent = mainFrame

local teleContent = Instance.new("Frame")
teleContent.Size = UDim2.new(1, 0, 1, -95)
teleContent.Position = UDim2.new(0, 0, 0, 95)
teleContent.BackgroundTransparency = 1
teleContent.Visible = false
teleContent.Parent = mainFrame

-- === INSTANT FISHING (logic 100% dari document halaman 16-17) ===
local instantBtn = Instance.new("TextButton")
instantBtn.Size = UDim2.new(0.85, 0, 0, 60)
instantBtn.Position = UDim2.new(0.075, 0, 0.15, 0)
instantBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
instantBtn.Text = "INSTANT FISHING : OFF"
instantBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
instantBtn.TextScaled = true
instantBtn.Font = Enum.Font.GothamBold
instantBtn.Parent = fishingContent

local instantLoop = nil
local instantEnabled = false

instantBtn.MouseButton1Click:Connect(function()
    instantEnabled = not instantEnabled
    v8.autoInstant = instantEnabled
    
    if instantEnabled then
        instantBtn.Text = "INSTANT FISHING : ON"
        instantBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        
        _G.Celestial = _G.Celestial or {}
        _G.Celestial.InstantCount = getFishCount()
        
        instantLoop = task.spawn(function()
            while v8.autoInstant do
                if v8.canFish then
                    v8.canFish = false
                    
                    local success, _, castResult = pcall(function()
                        return v6.Functions.ChargeRod:InvokeServer(workspace:GetServerTimeNow())
                    end)
                    
                    if success and typeof(castResult) == "number" then
                        local powerX = -1.233184814453125
                        local powerY = 0.999
                        
                        task.wait(_G.DelayCast)
                        
                        pcall(function()
                            v6.Functions.StartMini:InvokeServer(powerX, powerY, castResult)
                        end)
                        
                        local startTime = tick()
                        repeat task.wait(0.05) until _G.FishMiniData and _G.FishMiniData.LastShift or tick() - startTime > 1
                        
                        task.wait(_G.DelayComplete)
                        
                        pcall(function()
                            v6.Events.REFishDone:FireServer()
                        end)
                        
                        local oldCount = getFishCount()
                        local checkTime = tick()
                        repeat task.wait(0.05) until oldCount < getFishCount() or tick() - checkTime > 1
                    end
                    
                    v8.canFish = true
                end
                task.wait(0.05)
            end
        end)
        
    else
        instantBtn.Text = "INSTANT FISHING : OFF"
        instantBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        v8.autoInstant = false
        if instantLoop then task.cancel(instantLoop) end
    end
end)

-- === TELEPORT (posisi 100% dari document halaman 11) ===
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
scrollFrame.BackgroundTransparency = 0.7
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = teleContent

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

local telePositions = {
    ["Treasure Room"] = Vector3.new(-3602.01, -266.57, -1577.18),
    ["Sisyphus Statue"] = Vector3.new(-3703.69, -135.57, -1017.17),
    ["Crater Island Top"] = Vector3.new(1011.29, 22.68, 5076.27),
    ["Crater Island Ground"] = Vector3.new(1079.57, 3.64, 5080.35),
    ["Coral Reefs SPOT 1"] = Vector3.new(-3031.88, 2.52, 2276.36),
    ["Coral Reefs SPOT 2"] = Vector3.new(-3270.86, 2.5, 2228.1),
    ["Coral Reefs SPOT 3"] = Vector3.new(-3136.1, 2.61, 2126.11),
    ["Lost Shore"] = Vector3.new(-3737.97, 5.43, -854.68),
    ["Weather Machine"] = Vector3.new(-1524.88, 2.87, 1915.56),
    ["Kohana Volcano"] = Vector3.new(-561.81, 21.24, 156.72),
    ["Kohana SPOT 1"] = Vector3.new(-367.77, 6.75, 521.91),
    ["Kohana SPOT 2"] = Vector3.new(-623.96, 19.25, 419.36),
    ["Stingray Shores"] = Vector3.new(44.41, 28.83, 3048.93),
    ["Tropical Grove"] = Vector3.new(-2018.91, 9.04, 3750.59),
    ["Ice Sea"] = Vector3.new(2164, 7, 3269),
    ["Tropical Grove Cave 1"] = Vector3.new(-2151, 3, 3671),
    ["Tropical Grove Cave 2"] = Vector3.new(-2018, 5, 3756),
    ["Tropical Grove Highground"] = Vector3.new(-2139, 53, 3624),
    ["Fisherman Island Underground"] = Vector3.new(-62, 3, 2846),
    ["Fisherman Island Mid"] = Vector3.new(33, 3, 2764),
    ["Fisherman Island Rift Left"] = Vector3.new(-26, 10, 2686),
    ["Fisherman Island Rift Right"] = Vector3.new(95, 10, 2684),
    ["Secred Temple"] = Vector3.new(1475, -22, -632),
    ["Ancient Jungle Outside"] = Vector3.new(1488, 8, -392),
    ["Ancient Jungle"] = Vector3.new(1274, 8, -184),
    ["Underground Cellar"] = Vector3.new(2136, -91, -699),
    ["Mount Hallow"] = Vector3.new(2123, 80, 3265),
    ["Hallow Bay"] = Vector3.new(1730, 8, 3046),
    ["Underground Hallow"] = Vector3.new(2167, 8, 3008),
    ["Crystal Cavern"] = Vector3.new(-1613, -448, 7244),
    ["Admin Spot"] = Vector3.new(-1940, -447, 7422)
}

for name, pos in pairs(telePositions) do
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -10, 0, 45)
    tpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tpBtn.Text = name
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.TextScaled = true
    tpBtn.Font = Enum.Font.GothamSemibold
    tpBtn.Parent = scrollFrame
    
    tpBtn.MouseButton1Click:Connect(function()
        local char = l_LocalPlayer_0.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 6, 0))
            print("✅ Teleported to " .. name)
        end
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)

-- Tab switch
fishingTab.MouseButton1Click:Connect(function()
    fishingContent.Visible = true
    teleContent.Visible = false
    fishingTab.BackgroundColor3 = Color3.fromRGB(0, 208, 255)
    teleTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

teleTab.MouseButton1Click:Connect(function()
    fishingContent.Visible = false
    teleContent.Visible = true
    fishingTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    teleTab.BackgroundColor3 = Color3.fromRGB(0, 208, 255)
end)

-- Drag GUI (bonus biar enak dipake)
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ Chloe X FishIt loaded! (Instant + Teleport siap bro)")
