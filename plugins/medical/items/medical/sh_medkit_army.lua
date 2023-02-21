ITEM.name = "Apteczka wojskowa"
ITEM.model = "models/illusion/eftcontainers/ifak.mdl"
ITEM.description = "Obejmuje leki na szybsze krzepnięcie krwi, a także środki przeciwbólowe, antybiotyki, stymulatory odporności i inne rzeczy tego typu."

ITEM.healthAmount = 50
ITEM.price = 10000
ITEM.useSound = "gmodz/items/medkit.wav"

ITEM.rarity = { weight = 35 }

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