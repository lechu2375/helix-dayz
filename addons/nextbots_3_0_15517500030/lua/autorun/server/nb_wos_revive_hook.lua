if file.Exists( "autorun/wos_laststand_loader.lua", "LUA" ) then

	hook.Add( "EntityTakeDamage", "wOS.LastStand.Incap", function( ply, dmginfo ) --Keep hook same name as wOs hook, otherwise doesn't work..
		if not ply:IsPlayer() then return end
		if ply:WOSGetIncapped() then return end
		if not ply:Alive() then return end
		if ply:GetActiveWeapon().ZOMBIENEXTBOTWEP then return end
		local diff =  ply:Health() - dmginfo:GetDamage()
		if diff <= 0 then return end
		if diff <= ply:GetMaxHealth()*wOS.LastStand.Percent:GetFloat() then
			ply.WOS_IncapMe = true
			if !ply:IsBot() then
				ply:ConCommand( "wos_ls_force_incap" )
			else
				ply:WOSIncap()
			end
		end
	end )

end