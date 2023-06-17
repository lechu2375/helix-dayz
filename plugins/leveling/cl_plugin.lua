netstream.Hook("levelUp", function(level)
	vgui.Create("ixLevelUp"):open(level)
end)

netstream.Hook("getXP", function(xp, muteSound)
	vgui.Create("ixGetXP"):open(xp, muteSound)
end)


function PLUGIN:CreateCharacterInfoCategory(panel)

	local character = LocalPlayer():GetCharacter()
	local reqXP = ix.leveling.requiredXP(character:GetData("level", 0)+1)
	panel.xp = panel:Add("ixListRow")
	panel.xp:Dock(TOP)

	panel.xp:SetLabelText("Experience")
	panel.xp:SetText(character:GetData("XP", 0).."/"..reqXP)
	panel.xp:SizeToContents()
end

