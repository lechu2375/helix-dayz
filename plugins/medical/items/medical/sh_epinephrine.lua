ITEM.name = "Epinephrine"
ITEM.model = "models/gmodz/medical/epinephrine.mdl"
ITEM.description = "Strzykawka z organicznym zwiążkiem chemicznym. Pobudza receptory poprzez silne skurczenie naczyń krwionośnych."

ITEM.price = 1500

ITEM.useSound = "gmodz/items/syringe.wav"

if (SERVER) then
	function ITEM:OnUse()
		self.player:AddBuff("morphine")
	end
else
	function ITEM:ExtendDesc(text)
		text[#text+1] = Format("Łagodzi bóle mięśniowe (%d's)", ix.buff.list["morphine"].time)
		return text
	end
end

ITEM.rarity = { weight = 41 }