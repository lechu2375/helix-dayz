ITEM.name = "Apteczka samochodowa"
ITEM.model = Model("models/illusion/eftcontainers/carmedkit.mdl")
ITEM.description = "Typowa apteczka"

ITEM.price = 12000
ITEM.rarity = { weight = 100-(ITEM.price/1000)} 
ITEM.width = 2
ITEM.height = 1

ITEM.useSound = "gmodz/items/medkit.wav"
ITEM.healthAmount = 30

function ITEM:OnCanUse()
	if (self.player:Health() >= self.player:GetMaxHealth()) then
		return false
	end
end