ITEM.name = "Zestaw rusznikarza"
ITEM.model = "models/gmodz/misc/repair_kit_weapon.mdl"
ITEM.description = "Podstawowe narzędzia pozwalające na konserwację broni"

ITEM.width = 2
ITEM.height = 1

ITEM.raiseDurability = 0.75
ITEM.categoryKit = "weapons"
ITEM.price = 500

ITEM.useSound = "gmodz/items/repair_weapon.wav"

ITEM.rarity = { weight = 7 }

if (CLIENT) then
	function ITEM:ExtendDesc(text)
		text[1] = Format("Odnawia %d%% wytrzymałości.", self.raiseDurability)
		return text
	end
end