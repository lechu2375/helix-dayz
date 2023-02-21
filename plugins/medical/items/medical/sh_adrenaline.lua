ITEM.name = "Adrenalina"
ITEM.model = "models/gmodz/medical/adrenaline.mdl"
ITEM.description = "Strzykawka zawierająca adrenaline, wpływa na pracę serca i mięśni."

ITEM.price = 15000

ITEM.useSound = "gmodz/items/syringe.wav"

ITEM.rarity = { weight = 25 }

if (SERVER) then
	function ITEM:OnUse()
		self.player:AddBuff("adrenaline")
	end
else
	function ITEM:ExtendDesc(text)
		local buff = ix.buff.list["adrenaline"]

		if (buff) then
			text[#text+1] = Format("Zwiększa prędkość ruchu (%d's)", buff.time)
			text[#text+1] = Format("Zwiększa regenerację wytrzymałości %.1f", buff.stamina_offset)
		end

		return text
	end
end