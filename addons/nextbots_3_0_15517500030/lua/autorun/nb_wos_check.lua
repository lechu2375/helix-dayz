AddCSLuaFile("autorun/nb_wos_check.lua")

if file.Exists( "autorun/wos_laststand_loader.lua", "LUA" ) then
	SetGlobalBool( "nb_revive_players", true )
	print( "NB 3.0: Can Players Revive Nextbots? (TRUE)" )
	
	--Add NEXTBOT Revive Hook
		hook.Add( "KeyPress", "wOS.LastStand.NEXTBOT.ReviveCheck", function( ply, key )
			if wOS.LastStand.JobRestrict:GetBool() and not wOS.LastStand.JobTable[ ply:Team() ] then return end
			if ply.WOS_LastStandKT and ply.WOS_LastStandKT >= CurTime() then return	end
			if ( key == IN_USE ) and ply:KeyDown( IN_DUCK ) then
				local tr = util.TraceLine( util.GetPlayerTrace( ply ) )
				if tr.Entity and tr.Entity:GetPos():DistToSqr( ply:GetPos() ) <= 7000 then

					if tr.Entity:IsPlayer() then
					
						if wOS.LastStand.InLastStand[ tr.Entity ] then
							ply.WOS_LastStandIsReviving = true
							ply:SetCycle( 0 )
							ply.WOS_LastStandHeld = CurTime()
							ply.WOS_LastStandChild = tr.Entity
							if SERVER then
								ply:SetNW2Bool( "wOS.LS.IsReviving", true )
							end
						end
						
					elseif ( tr.Entity.NEXTBOT and !tr.Entity.NEXTBOTMERCENARY and !tr.Entity.NEXTBOTCOMBINE ) then
						
						if wOS.LastStand.InLastStand[ tr.Entity ] then
							ply.WOS_LastStandIsReviving = true
							ply:SetCycle( 0 )
							ply.WOS_LastStandHeld = CurTime()
							ply.WOS_LastStandChild = tr.Entity
							if SERVER then
								ply:SetNW2Bool( "wOS.LS.IsReviving", true )
							end
						end
						
					end	
					
				end
				ply.WOS_LastStandKT = CurTime() + 0.2
			end
		end)
	
		--if SERVER then
			--hook.Add( "EntityTakeDamage", "wOS.LastStand.Incap", function( ply, dmginfo ) --Keep hook same name as wOs hook, otherwise doesn't work..
				--if not ply:IsPlayer() then return end
				--if ply:WOSGetIncapped() then return end
				--if not ply:Alive() then return end
				--if ply:GetActiveWeapon().ZOMBIENEXTBOTWEP then return end
				--local diff =  ply:Health() - dmginfo:GetDamage()
				--if diff <= 0 then return end
				--if diff <= ply:GetMaxHealth()*wOS.LastStand.Percent:GetFloat() then
					--ply.WOS_IncapMe = true
					--if !ply:IsBot() then
						--ply:ConCommand( "wos_ls_force_incap" )
					--else
						--ply:WOSIncap()
					--end
				--end
			--end )
		--end
	
else
	SetGlobalBool( "nb_revive_players", false )
	print( "NB 3.0: Can Players Revive Nextbots? (FALSE)" )
end