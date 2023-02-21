ITEM.name = "RAD-X"
ITEM.model = "models/gmodz/medical/antirad.mdl"
ITEM.description = "Chroni przed narażeniem na promieniowanie."

ITEM.radiationAmount = -75
ITEM.price = 2500
ITEM.useSound = "gmodz/items/antirad.wav"

if (SERVER) then
	function ITEM:OnUse()
		self.player:AddBuff("radx")
	end
else
	function ITEM:ExtendDesc(text)
		text[#text+1] = Format("Ochrona przed promieniowaniem: 40%% (%d's)", ix.buff.list["radx"].time)

		return text
	end
end

ITEM.rarity = { weight = 44 }