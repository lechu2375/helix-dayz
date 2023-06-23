ITEM.name = "Torba lekarska"
ITEM.model = Model("models/illusion/eftcontainers/docbag.mdl")
ITEM.description = "Zniszczona torba lekarska, może się przydać."

ITEM.price = 30000
ITEM.rarity = { weight = 100-(ITEM.price/1000)} 
ITEM.width = 2
ITEM.height = 2

ITEM.useSound = "gmodz/items/medkit.wav"
ITEM.healthAmount = 40

function ITEM:OnCanUse()
	if (self.player:Health() >= self.player:GetMaxHealth()) then
		return false
	end
end