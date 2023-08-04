ITEM.name = "Apteczka"
ITEM.model = "models/illusion/eftcontainers/carmedkit.mdl"
ITEM.description = "Uniwersalna apteczka jednorazowego użytku. Pozwala na radzenie sobie z obrażeniami różnego typu i stopnia skomplikowania. Apteczka leczy ~35 procent twojego życia i usuwa część krwawienia i nagromadzonego promieniowania."

ITEM.healthAmount = 20
ITEM.price = 2000
ITEM.useSound = "gmodz/items/medkit.wav"

ITEM.rarity = { weight = 43 }

function ITEM:OnCanUse()
	if (self.player:Health() >= self.player:GetMaxHealth()) then
		return false
	end
end

if (SERVER) then
	function ITEM:OnUse()
		self.player:HealBleeding()
	end
else
	function ITEM:ExtendDesc(text)
		text[#text+1] = "Zatrzymuje krwawienie"
		return text
	end
end