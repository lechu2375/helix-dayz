ITEM.name = "AI-2 Apteczka"
ITEM.model = Model("models/illusion/eftcontainers/ai2.mdl")
ITEM.description = "Mała apteczka, nic w sobie nie posiada ale można to sprzedać."

ITEM.price = 6600
ITEM.rarity = { weight = 100-(ITEM.price/1000)} 
ITEM.width = 1
ITEM.height = 1

ITEM.useSound = "gmodz/items/medkit.wav"
ITEM.healthAmount = 30

function ITEM:OnCanUse()
	if (self.player:Health() >= self.player:GetMaxHealth()) then
		return false
	end
end