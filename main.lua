StartDebug()

local Mod = RegisterMod("Sean Test", 1)
local game = Game()

local ModItems = {
    COLLECTIBLE_SIDEKICK_CAP = Isaac.GetItemIdByName("Sidekick cap")
}

local ItemTracker = {
    SidekickCap = false
}

local ItemBonuses = {
    SIDEKICK_CAP = {
        SPEED = 0.7,
        DAMAGE = 1.3
    }
}

local Costumes = {
    SIDEKICK_CAP = Isaac.GetCostumeIdByPath("gfx/characters/sidekick_cap.anm2"),
    CHAR_LUIGI_HEAD = Isaac.GetCostumeIdByPath("gfx/characters/char_luigi_head.anm2")
}

function Mod:onTear(tear)
    local player = game:GetPlayer(0)
    if player:HasCollectible(ModItems.COLLECTIBLE_SIDEKICK_CAP) and (math.random(3) == 1) then
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_ATTRACTOR
        tear:ChangeVariant(TearVariant.METALLIC)
    end
end

function Mod:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_SPEED then
        if player:HasCollectible(ModItems.COLLECTIBLE_SIDEKICK_CAP) then
            player.MoveSpeed = player.MoveSpeed + ItemBonuses.SIDEKICK_CAP.SPEED
        end
    end
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(ModItems.COLLECTIBLE_SIDEKICK_CAP) then
            player.Damage = player.Damage + ItemBonuses.SIDEKICK_CAP.DAMAGE
        end
    end
end

local function validateItems()
    local player = game:GetPlayer(0)
    ItemTracker.SidekickCap = player:HasCollectible(ModItems.COLLECTIBLE_SIDEKICK_CAP)
end

function Mod:onPlayerInit(player)
    validateItems()
    if player:GetName() == "Luigi" then
        player:AddCollectible(ModItems.COLLECTIBLE_SIDEKICK_CAP, 1, true)
    end
end

function Mod:onUpdate(player)
    if player:HasCollectible(ModItems.COLLECTIBLE_SIDEKICK_CAP) and not ItemTracker.SidekickCap then
        player:AddNullCostume(Costumes.SIDEKICK_CAP)
    end
    validateItems()
end

Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Mod.onTear)
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.onCache)
Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Mod.onUpdate)
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Mod.onPlayerInit)