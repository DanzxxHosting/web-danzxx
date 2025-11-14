 local FishingService = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fish types and their properties
local FISH_TYPES = {
  {name = "Common Fish", weight = {5, 15}, value = 10, rarity = "common"},
  {name = "Rare Fish", weight = {20, 35}, value = 50, rarity = "rare"},
  {name = "Epic Fish", weight = {40, 60}, value = 100, rarity = "epic"},
  {name = "Legendary Fish", weight = {70, 100}, value = 250, rarity = "legendary"}
}

-- Fishing delay (in seconds)
local FISHING_DELAY = 3

-- Initialize player data
local function initializePlayer(player)
  if not ReplicatedStorage:FindFirstChild("PlayerData") then
    local playerDataFolder = Instance.new("Folder")
    playerDataFolder.Name = "PlayerData"
    playerDataFolder.Parent = ReplicatedStorage
  end
  
  local playerFolder = Instance.new("Folder")
  playerFolder.Name = player.UserId
  playerFolder.Parent = ReplicatedStorage:WaitForChild("PlayerData")
  
  local stats = Instance.new("Folder")
  stats.Name = "Stats"
  stats.Parent = playerFolder
  
  local money = Instance.new("IntValue")
  money.Name = "Money"
  money.Value = 0
  money.Parent = stats
  
  local fishCaught = Instance.new("IntValue")
  fishCaught.Name = "FishCaught"
  fishCaught.Value = 0
  fishCaught.Parent = stats
  
  local totalWeight = Instance.new("IntValue")
  totalWeight.Name = "TotalWeight"
  totalWeight.Value = 0
  totalWeight.Parent = stats
end

-- Get random fish
local function getRandomFish()
  return FISH_TYPES[math.random(1, #FISH_TYPES)]
end

-- Calculate fish weight
local function calculateFishWeight(fishType)
  local min, max = fishType.weight[1], fishType.weight[2]
  return math.random(min, max)
end

-- Handle fishing
local function fish(player)
  local playerFolder = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(tostring(player.UserId))
  local stats = playerFolder:WaitForChild("Stats")
  
  local fish = getRandomFish()
  local weight = calculateFishWeight(fish)
  
  -- Update stats
  stats.Money.Value = stats.Money.Value + fish.value
  stats.FishCaught.Value = stats.FishCaught.Value + 1
  stats.TotalWeight.Value = stats.TotalWeight.Value + weight
  
  return {
    name = fish.name,
    weight = weight,
    value = fish.value,
    rarity = fish.rarity
  }
end

-- Remote function for fishing
local fishingRemote = Instance.new("RemoteFunction")
fishingRemote.Name = "Fish"
fishingRemote.Parent = ReplicatedStorage

function fishingRemote.OnServerInvoke(player)
  if player:FindFirstChild("LastFishTime") then
    local timeSinceLastFish = tick() - player.LastFishTime.Value
    if timeSinceLastFish < FISHING_DELAY then
      return {success = false, message = "Waiting " .. math.ceil(FISHING_DELAY - timeSinceLastFish) .. "s before next fish"}
    end
  end
  
  local lastFishTime = Instance.new("IntValue")
  lastFishTime.Name = "LastFishTime"
  lastFishTime.Value = tick()
  lastFishTime.Parent = player
  
  local fishResult = fish(player)
  return {success = true, fish = fishResult}
end

-- Initialize on player join
Players.PlayerAdded:Connect(function(player)
  initializePlayer(player)
end)

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
  local playerData = ReplicatedStorage:FindFirstChild("PlayerData")
  if playerData then
    local playerFolder = playerData:FindFirstChild(tostring(player.UserId))
    if playerFolder then
      playerFolder:Destroy()
    end
  end
end)

return FishingService
