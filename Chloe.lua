-- ✅ Chloe X | FishIt - RAYFIELD FULL FIX (V2)
-- Sekarang GUI langsung muncul + semua fitur keliatan
-- Rayfield + Instant Fishing + Auto Sell + Teleport (logic 100% dari document lu)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================== SETUP DULU (tapi ga langsung jalan biar ga error) ==================
local v0 = { Players = game:GetService("Players"), RS = game:GetService("ReplicatedStorage") }
local lp = v0.Players.LocalPlayer

local v5 = {
   Net = v0.RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"),
   FishingController = require(v0.RS:WaitForChild("Controllers"):WaitForChild("FishingController"))
}

local v6 = {
   Functions = {
      ChargeRod = v5.Net["RF/ChargeFishingRod"],
      StartMini = v5.Net["RF/RequestFishingMinigameStarted"],
      SellAll = v5.Net["RF/SellAllItems"]
   },
   Events = { REFishDone = v5.Net["RE/FishingCompleted"] }
}

local v8 = { autoInstant = false, canFish = true, player = lp, autoSellEnabled = false }

_G.DelayCast = _G.DelayCast or 0.2
_G.DelayComplete = _G.DelayComplete or 0.5

local function getFishCount()
   pcall(function()
      local bag = lp.PlayerGui:WaitForChild("Inventory", 5):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Options"):WaitForChild("Fish"):WaitForChild("Label"):WaitForChild("BagSize")
      return tonumber((bag.Text or "0/???"):match("(%d+)/")) or 0
   end) or 0
end

-- Hook minigame (delayed biar aman)
task.spawn(function()
   task.wait(3)
   local net = v0.RS:FindFirstChild("Packages", true) and v0.RS.Packages._Index["sleitnick_net@0.2.0"].net
   if net then
      local mini = net:FindFirstChild("RE/FishingMinigameChanged") or net:FindFirstChild("FishingMinigameChanged")
      if mini and not _G.HookedMini then
         _G.HookedMini = true
         mini.OnClientEvent:Connect(function(_, data)
            if data then _G.FishMiniData = data end
         end)
      end
   end
end)

-- ================== GUI RAYFIELD ==================
local Window = Rayfield:CreateWindow({
   Name = "Chloe X | FishIt",
   LoadingTitle = "Chloe X | FishIt",
   LoadingSubtitle = "Beta Release - Fixed",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- TAB FISHING
local FishingTab = Window:CreateTab("🎣 Fishing", 97167558235554)

FishingTab:CreateToggle({
   Name = "🚀 Instant Fishing",
   CurrentValue = false,
   Callback = function(Value)
      v8.autoInstant = Value
      if Value then
         task.spawn(function()
            while v8.autoInstant do
               if v8.canFish then
                  v8.canFish = false
                  local success, _, castResult = pcall(function()
                     return v6.Functions.ChargeRod:InvokeServer(workspace:GetServerTimeNow())
                  end)
                  if success and typeof(castResult) == "number" then
                     task.wait(_G.DelayCast)
                     pcall(function() v6.Functions.StartMini:InvokeServer(-1.233184814453125, 0.999, castResult) end)
                     local st = tick()
                     repeat task.wait(0.05) until ( _G.FishMiniData and _G.FishMiniData.LastShift ) or tick()-st > 1.5
                     task.wait(_G.DelayComplete)
                     pcall(function() v6.Events.REFishDone:FireServer() end)
                  end
                  v8.canFish = true
               end
               task.wait(0.05)
            end
         end)
      end
   end
})

FishingTab:CreateInput({ Name = "Delay Cast (detik)", CurrentValue = "0.2", PlaceholderText = "0.2", Callback = function(v) _G.DelayCast = tonumber(v) or 0.2 end })
FishingTab:CreateInput({ Name = "Delay Complete (detik)", CurrentValue = "0.5", PlaceholderText = "0.5", Callback = function(v) _G.DelayComplete = tonumber(v) or 0.5 end })

FishingTab:CreateToggle({
   Name = "💰 Auto Sell (Delay 60 detik)",
   CurrentValue = false,
   Callback = function(Value)
      v8.autoSellEnabled = Value
      if Value then
         task.spawn(function()
            while v8.autoSellEnabled do
               pcall(function() v6.Functions.SellAll:InvokeServer() end)
               task.wait(60)
            end
         end)
      end
   end
})

-- TAB TELEPORT
local TeleTab = Window:CreateTab("📍 Teleport", 18648122722)

local positions = {
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
   ["Admin Spot"] = Vector3.new(-1940, -447, 7422)
}

for name, pos in pairs(positions) do
   TeleTab:CreateButton({
      Name = "➤ " .. name,
      Callback = function()
         local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(pos + Vector3.new(0, 7, 0))
            Rayfield:Notify({Title = "✅ Teleport", Content = "Berhasil ke " .. name, Duration = 4})
         end
      end
   })
end

Rayfield:Notify({Title = "Chloe X | FishIt", Content = "GUI Fixed! Fitur sudah muncul semua ✅", Duration = 6})
