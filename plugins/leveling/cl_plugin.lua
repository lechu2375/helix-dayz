netstream.Hook("levelUp", function(level)
	vgui.Create("ixLevelUp"):open(level)
end)

netstream.Hook("getXP", function(xp, muteSound)
	vgui.Create("ixGetXP"):open(xp, muteSound)
end)