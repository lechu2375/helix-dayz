ITEM.name = "Morfina"
ITEM.model = "models/gmodz/medical/morphine.mdl"
ITEM.description = "Jednorazowa strzykawka pełna morfiny - silnego leku, stosowanego przede wszystkim w leczeniu zarówno ostrego, jak i przewlekłego silnego bólu."

ITEM.useSound = "gmodz/items/syringe.wav"

ITEM.price = 4000

function ITEM:OnCanUse()
	return self.player:IsBrokenLeg()
end

if (SERVER) then
	function ITEM:OnUse()
		self.player:HealLeg()
	end
else
	function ITEM:ExtendDesc(text)
		text[#text+1] = "Leczy złamanie"
		return text
	end
end

ITEM.rarity = { weight = 38 }