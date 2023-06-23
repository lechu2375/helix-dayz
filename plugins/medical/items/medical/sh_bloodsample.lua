ITEM.name = "Probówka"
ITEM.model = Model("models/illusion/eftcontainers/bloodsample.mdl")
ITEM.description = "Probówka, posiada w sobie czyjąś krew..."

ITEM.price = 20000
ITEM.rarity = { weight = 100-(ITEM.price/1000)} 
ITEM.width = 1
ITEM.height = 1

ITEM.useSound = "gmodz/items/medkit.wav"
ITEM.healthAmount = 20

function ITEM:OnCanUse()
	if (self.player:Health() >= self.player:GetMaxHealth()) then
		return false
	end
end