BUFF.time = 360
BUFF.time_max = 360

if (CLIENT) then
	function BUFF:HUDExtraPaint(client, perc, hud, margin)
		if (LocalPlayer():HasBuff(self.uniqueID)) then
			local time = math.max(0, LocalPlayer():HasBuff(self.uniqueID).time - CurTime())

			perc.textColor = color_white
			perc.y = perc.y - perc.h - margin
			hud:drawText(perc, "MORFINA: " .. string.ToMinutesSeconds(time))
		end
	end
end