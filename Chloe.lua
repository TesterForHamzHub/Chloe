-- Chloe X | FishIt - Rayfield Edition (Fixed GUI)
-- Instant Fishing + Teleport (logic 100% dari document lu)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Chloe X | FishIt",
   LoadingTitle = "Chloe X | FishIt",
   LoadingSubtitle = "Loading... Beta Release",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = "",
   KeySystem = false
})

-- ================== SETUP (dari document) ==================
local v0 = { Players = game:GetService("Players"), RS = game:GetService("ReplicatedStorage") }
local lp = v0.Players.LocalPlayer

local v5 = {
   Net = v0.RS.Packages._Index["sleitnick_net@0.2.0"].net,
   FishingController = require(v0.RS.Controllers.FishingController)
}

local v6 = {
   Functions = {
      ChargeRod = v5.Net["RF/ChargeFishingRod"],
      StartMini = v5.Net["RF/RequestFishingMinigameStarted"]
   },
   Events = { REFishDone = v5.Net["RE/FishingCompleted"] }
}

local v8 = { autoInstant = false, canFish = true, player = lp }

_G.DelayCast = _G.DelayCast or 0.2
_G.DelayComplete = _G.DelayComplete or 0.5

local function getFishCount()
   local bag = lp.PlayerGui:WaitForChild("Inventory"):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Options"):WaitForChild("Fish"):WaitForChild("Label"):WaitForChild("BagSize")
   return tonumber((bag.Text or "0/???"):match("(%d+)/")) or 0
end

-- Hook minigame
local net = v0.RS.Packages._Index["sleitnick_net@0.2.0"].net
local miniEvent = net:FindFirstChild("RE/FishingMinigameChanged") or net:FindFirstChild("FishingMinigameChanged")
if miniEvent and not _G.HookedMini then
   _G.HookedMini = true
   miniEvent.OnClientEvent:Connect(function(_, data) if data then _G.FishMiniData = data end end)
end

-- ================== FISHING TAB ==================
local FishingTab = Window:CreateTab("Fishing", 97167558235554)

FishingTab:CreateToggle({
   Name = "Instant Fishing",
   CurrentValue = false,
   Flag = "InstantFish",
   Callback = function(Value)
      v8.autoInstant = Value
      if Value then
         _G.Celestial = _G.Celestial or {}
         _G.Celestial.InstantCount = getFishCount()
         
         task.spawn(function()
            while v8.autoInstant do
               if v8.canFish then
                  v8.canFish = false
                  local _, _, castResult = pcall(function()
                     return v6.Functions.ChargeRod:InvokeServer(workspace:GetServerTimeNow())
                  end)
                  
                  if typeof(castResult) == "number" then
                     task.wait(_G.DelayCast)
                     pcall(function()
                        v6.Functions.StartMini:InvokeServer(-1.233184814453125, 0.999, castResult)
                     end)
                     
                     local st = tick()
                     repeat task.wait(0.05) until _G.FishMiniData and _G.FishMiniData.LastShift or tick()-st > 1
                     
                     task.wait(_G.DelayComplete)
                     pcall(function() v6.Events.REFishDone:FireServer() end)
                     
                     local old = getFishCount()
                     local ct = tick()
                     repeat task.wait(0.05) until old < getFishCount() or tick()-ct > 1
                  end
                  v8.canFish = true
               end
               task.wait(0.05)
            end
         end)
      end
   end,
})

FishingTab:CreateInput({
   Name = "Delay Cast",
   PlaceholderText = "0.2",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) _G.DelayCast = tonumber(Text) or 0.2 end
})

FishingTab:CreateInput({
   Name = "Delay Complete",
   PlaceholderText = "0.5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) _G.DelayComplete = tonumber(Text) or 0.5 end
})

-- ================== TELEPORT TAB ==================
local TeleTab = Window:CreateTab("Teleport", 18648122722)

local teleSection = TeleTab:CreateSection("Choose Location")

local telePositions = {
   ["Treasure Room"] = Vector3.new(-3602.01, -266.57, -1577.18),
   ["Sisyphus Statue"] = Vector3.new(-3703.69, -135.57, -1017.17),
   ["Crater Island Top"] = Vector3.new(1011.29, 22.68, 5076.27),
   ["Coral Reefs SPOT 1"] = Vector3.new(-3031.88, 2.52, 2276.36),
   ["Lost Shore"] = Vector3.new(-3737.97, 5.43, -854.68),
   ["Weather Machine"] = Vector3.new(-1524.88, 2.87, 1915.56),
   ["Kohana Volcano"] = Vector3.new(-561.81, 21.24, 156.72),
   ["Stingray Shores"] = Vector3.new(44.41, 28.83, 3048.93),
   ["Tropical Grove"] = Vector3.new(-2018.91, 9.04, 3750.59),
   ["Ice Sea"] = Vector3.new(2164, 7, 3269),
   ["Fisherman Island Mid"] = Vector3.new(33, 3, 2764),
   ["Ancient Jungle"] = Vector3.new(1274, 8, -184),
   ["Mount Hallow"] = Vector3.new(2123, 80, 3265),
   ["Crystal Cavern"] = Vector3.new(-1613, -448, 7244),
   ["Admin Spot"] = Vector3.new(-1940, -447, 7422),
}

for name, pos in pairs(telePositions) do
   TeleTab:CreateButton({
      Name = name,
      Callback = function()
         local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(pos + Vector3.new(0, 6, 0))
            Rayfield:Notify({Title = "Teleported!", Content = "✅ " .. name, Duration = 3})
         end
      end,
   })
end

Rayfield:Notify({Title = "Chloe X | FishIt", Content = "Loaded with Rayfield GUI ✅", Duration = 5})
