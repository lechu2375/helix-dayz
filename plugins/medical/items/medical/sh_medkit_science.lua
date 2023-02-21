ITEM.name = "Scientific medkit"
ITEM.model = "models/gmodz/medical/medkit_science.mdl"
ITEM.description = "Leczy ona znacznie więcej zdrowia niż inne apteczki, a także automatycznie usuwają całkowicie zatrucie promieniowaniem. Jednakże, w przeciwieństwie do zestawów wojskowych, nie są one tak skuteczne w zatrzymywaniu utraty krwi."

ITEM.healthAmount = 80
ITEM.radiationAmount = -250
ITEM.price = 15000
ITEM.useSound = "gmodz/items/medkit.wav"

ITEM.rarity = { weight = 25 }

if (SERVER) then
	function ITEM:OnUse()
		self.player:HealBleeding()
		self.player:HealLeg()
	end
else
	function ITEM:ExtendDesc(text)
		text[#text+1] = "Zatrzymuje krwawienie"
		text[#text+1] = "Leczy złamanie"
		return text
	end
end