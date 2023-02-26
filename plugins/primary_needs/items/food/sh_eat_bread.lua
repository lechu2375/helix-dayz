ITEM.name = "Chleb"
ITEM.model = "models/gmodz/food/bread.mdl"
ITEM.description = "Pożywny kawałek chleba uzupełniany trocinami, wyprodukowany w trudnych warunkach stanowi dobre źródło pożywienia."

ITEM.hungerAmount = 0.25
ITEM.thirstAmount = -0.05
ITEM.price = 250
ITEM.useSound = "gmodz/items/food2.wav"

ITEM.rarity = { weight = 48 }

if (SERVER) then
	ITEM.dropUsedItem = nil
end