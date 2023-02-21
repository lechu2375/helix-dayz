ITEM.name = "Antirad"
ITEM.model = "models/gmodz/medical/antirad.mdl"
ITEM.description = "Paczka zawierająca leki anty radiacyjne. Wspomagają organizm w wydaleniu promieniowania."

ITEM.radiationAmount = -300
ITEM.price = 2500

ITEM.useSound = "gmodz/items/antirad.wav"

ITEM.rarity = { weight = 44 }

function ITEM:OnCanUse()
	if (self.player:GetRadiationTotal() <= 0) then
		return false
	end
end