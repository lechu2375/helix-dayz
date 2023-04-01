function SpawnNextbot( ply, name, tr )
	if !name then return end
	
	local NextbotList = list.Get( "sean_nextbots" )
	local nextbot = NextbotList[ name ]

	if !nextbot then return end
	
	if !tr then
		--tr = ply:GetEyeTraceNoCursor()
		local vStart = ply:GetShootPos()
		local vForward = ply:GetAimVector()
		local trace = {}
			trace.start = vStart
			trace.endpos = vStart + vForward * 2048
			trace.filter = ply
		tr = util.TraceLine( trace )
	end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	if ( !tr.Hit ) then 
		local SpawnPos = tr.endpos
	end

	--if util.PointContents( tr.HitPos ) == CONTENTS_EMPTY then

		local ent = ents.Create( nextbot.Class )
		
		if !IsValid( ent ) then return end
		
			ent:SetPos( SpawnPos )
			ent:Spawn()

			local angles = Angle( 0, 0, 0 )
			angles = ply:GetAngles()
			angles.pitch = 0
			angles.roll = 0
			angles.yaw = angles.yaw + 180
			
			ent:SetAngles( angles )
			
		local nav = navmesh.GetNearestNavArea( ent:GetPos() )
		if !IsValid(nav) then
			SafeRemoveEntity( ent )
			ply:ChatPrint( nextbot.Name.." is NOT spawned on a nav mesh. Generate a nav mesh or spawn somewhere else.")
			
			local thesound = Sound("common/wpn_denyselect.wav")
			ply:SendLua( "surface.PlaySound( \"" .. thesound .. "\" )" )
		return end	
			
		undo.Create( "NPC" )
		undo.SetPlayer( ply )
		undo.AddEntity( ent )
		undo.SetCustomUndoText( "Undone " .. nextbot.Name )
		undo.Finish( "Nextbot (" .. tostring( nextbot.Name ) .. ")" )

		ply:AddCleanup( "npcs", ent )	
		
	--else
		--ply:ChatPrint( "CANNOT spawn "..nextbot.Name.." outside of the map")
		
		--local thesound = Sound("common/wpn_denyselect.wav")
		--ply:SendLua( "surface.PlaySound( \"" .. thesound .. "\" )" )
	--end

end
concommand.Add( "nb_sean_spawn", function( ply, cmd, args ) SpawnNextbot( ply, args[1] ) end )

function SpawnZombieWeapon( ply, name, tr )
	if !name then return end
	
	local WeaponList = list.Get( "sean_nextbot_weapons" )
	local weapon = WeaponList[ name ]

	if !weapon then return end
	
	if !ply:HasWeapon( weapon.Class ) then
		ply:Give( weapon.Class )
		ply:SelectWeapon( weapon.Class )
	else
		ply:SelectWeapon( weapon.Class )
	end
	
end
concommand.Add( "nb_sean_weapon", function( ply, cmd, args ) SpawnZombieWeapon( ply, args[1] ) end )