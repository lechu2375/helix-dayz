if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 
ENT.nosleep = false

function ENT:DeathAnimation( anim, pos, activity, scale, weapon, dropwep, bosstype )
	local human = ents.Create( anim )
	if !self:IsValid() then return end

	if human:IsValid() then
		human:SetPos( pos )
		human:SetModel(self:GetModel())
		human:SetAngles(self:GetAngles())
		human:SetSkin(self:GetSkin())
		human:SetColor(self:GetColor())
		human:SetMaterial(self:GetMaterial())
		human:SetModelScale( scale, 0 )
		
		human:StartActivity( activity )

		human:SetBodygroup( 1, self:GetBodygroup(1) )
		human:SetBodygroup( 2, self:GetBodygroup(2) )
		human:SetBodygroup( 3, self:GetBodygroup(3) )
		human:SetBodygroup( 4, self:GetBodygroup(4) )
		human:SetBodygroup( 5, self:GetBodygroup(5) )
		human:SetBodygroup( 6, self:GetBodygroup(6) )
		human:SetBodygroup( 7, self:GetBodygroup(7) )
		human:SetBodygroup( 8, self:GetBodygroup(8) )
		human:SetBodygroup( 9, self:GetBodygroup(9) )
		
		if self.Weapon and ( weapon != nil ) then
		
			human:EquipWeapon( weapon )
			human.DroppedWeapon = dropwep
		
		end
		
		if bosstype == 1 then --Corpse boss
			human.EquipWeapons = true
		end
		
		human:Spawn()
		
		SafeRemoveEntity( self )
	end
end

function ENT:CheckReanimate( ragdoll )
	
	if !ragdoll:IsValid() then
		return false
	end
	
	return true
	
end

function ENT:RiseAsZombie( ent, base, npc, wep, hp, dropwep )

	if dropwep == true then
		if self.Weapon then
			self:DropWeapon()
		end
	end

	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			ragdoll:SetBodygroup( 1, self:GetBodygroup(1) )
			ragdoll:SetBodygroup( 2, self:GetBodygroup(2) )
			ragdoll:SetBodygroup( 3, self:GetBodygroup(3) )
			ragdoll:SetBodygroup( 4, self:GetBodygroup(4) )
			ragdoll:SetBodygroup( 5, self:GetBodygroup(5) )
			ragdoll:SetBodygroup( 6, self:GetBodygroup(6) )
			ragdoll:SetBodygroup( 7, self:GetBodygroup(7) )
			ragdoll:SetBodygroup( 8, self:GetBodygroup(8) )
			ragdoll:SetBodygroup( 9, self:GetBodygroup(9) )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
			
			self:Reanimate( ragdoll, base, npc, wep, hp, true )
			
		end
	
	SafeRemoveEntity( self )

end

function ENT:Reanimate( ragdoll, ent, npc, wep, hp, zombie )

	if self:CheckReanimate( ragdoll ) then
	
		timer.Simple( math.random(5,6), function()
			
			--if PHASE == "BUILD" then return end 
			
			if hp < 0 then return end 
			
			local zombie = ents.Create( ent )
				if zombie:IsValid() and ragdoll:IsValid() then
	
					--local ents = ents.FindInSphere( ragdoll:GetPos(), 60 )
					--for k,v in pairs( ents ) do
						--if v:IsPlayer() then
						
							--timer.Simple( 3, function()
								--self:Reanimate( ragdoll, "nb_rise_base", "nz_pathtest", self.Weapon )
							--end)
						
						--return end
					--end
				
					zombie:SetPos( ragdoll:GetPos() )
					
					if ragdoll:GetModel() == "models/zombie/poison.mdl" then
						zombie:SetModel( "models/player/poison_player.mdl" )
					else
						zombie:SetModel( ragdoll:GetModel() )
					end
					
					zombie:SetAngles( ragdoll:GetAngles() )
					
					zombie.WeaponClass = wep
					zombie.health = hp
					
					if zombie == true then
						zombie.NEXTBOTZOMBIE = true
					end
					
					zombie:Spawn()
					
					zombie.SpawnNpc = npc
					
					zombie:SetSkin( ragdoll:GetSkin() )
					zombie:SetColor( ragdoll:GetColor() )
					zombie:SetMaterial( ragdoll:GetMaterial() )
					
					zombie:StartActivity( ACT_HL2MP_ZOMBIE_SLUMP_IDLE )
					
					zombie:SetBodygroup( 1, ragdoll:GetBodygroup(1) )
					zombie:SetBodygroup( 2, ragdoll:GetBodygroup(2) )
					zombie:SetBodygroup( 3, ragdoll:GetBodygroup(3) )
					zombie:SetBodygroup( 4, ragdoll:GetBodygroup(4) )
					zombie:SetBodygroup( 5, ragdoll:GetBodygroup(5) )
					zombie:SetBodygroup( 6, ragdoll:GetBodygroup(6) )
					zombie:SetBodygroup( 7, ragdoll:GetBodygroup(7) )
					zombie:SetBodygroup( 8, ragdoll:GetBodygroup(8) )
					zombie:SetBodygroup( 9, ragdoll:GetBodygroup(9) )
					
					SafeRemoveEntity( ragdoll )
					
				end
		
		end)
	
	end

end

function ENT:VehicleHit( ent, base, npc, wep, dmg, dropwep )

	if dropwep == true then
		if self.Weapon then
			self:DropWeapon()
		end
	end

	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			ragdoll:SetBodygroup( 1, self:GetBodygroup(1) )
			ragdoll:SetBodygroup( 2, self:GetBodygroup(2) )
			ragdoll:SetBodygroup( 3, self:GetBodygroup(3) )
			ragdoll:SetBodygroup( 4, self:GetBodygroup(4) )
			ragdoll:SetBodygroup( 5, self:GetBodygroup(5) )
			ragdoll:SetBodygroup( 6, self:GetBodygroup(6) )
			ragdoll:SetBodygroup( 7, self:GetBodygroup(7) )
			ragdoll:SetBodygroup( 8, self:GetBodygroup(8) )
			ragdoll:SetBodygroup( 9, self:GetBodygroup(9) )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
			if ( self:Health() - dmg ) > 0 then
				self:Reanimate( ragdoll, base, npc, wep, dmg )
			end
			
		end
	
	SafeRemoveEntity( self )

end

function ENT:OnContact( ent )

	if ent.NEXTBOT or ent:IsPlayer() then
        self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
       if math.abs(self:GetPos().z - ent:GetPos().z) > 30 then self:SetSolidMask( MASK_NPCSOLID_BRUSHONLY ) end
    end
	
    if ( ent:GetClass() == "prop_physics_multiplayer" or ent:GetClass() == "prop_physics" ) and ent:IsOnGround() then
        self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
        local phys = ent:GetPhysicsObject()
        if !IsValid(phys) then return end
        phys:ApplyForceCenter( self:GetPos() - ent:GetPos() * 1.2 )
    end
	
    if ent:GetClass() == "func_breakable" or ent:GetClass() == "func_breakable_surf" then
        ent:Fire("Shatter")
    end
	
	self:CustomOnContact( ent )
	
end

function ENT:FindSpotFunction( type, radius )

	local spot = self:FindSpot( type, {
		type = "hiding",
		pos = self:GetPos(),
		radius = radius,
		stepup = 100,
		stepdown = 100
		} )

	if !spot then
		return nil
	end
		
	return spot
		
end

function ENT:StartMovementAnim( anim, speed, override )

	if anim != nil then
		
		if isstring( anim ) then
		
			if ( override == 0 or override == nil ) then --Restart Walk animation?
				if self:GetSequence() != anim then
					self:ResetSequence( anim )
				end
			else
				self:ResetSequence( anim )
			end

		else
		
			if ( override == 0 or override == nil ) then
				if self:GetActivity() != anim then
					self:StartActivity( anim )
				end
			else
				self:StartActivity( anim )
			end
		
		end
		
		self.loco:SetDesiredSpeed( speed )

	end

end

function ENT:HandleStuck()

	self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
	
	self.StuckAttempts = self.StuckAttempts + 1
	if self.StuckAttempts == 100 then
		self.loco:ClearStuck()
		self.StuckAttempts = 0
		self.TotalTimesStuck = self.TotalTimesStuck + 1
		if self.TotalTimesStuck >= 10 then
			self:TakeDamage(math.huge, self)
		end
	end

end

function ENT:MoveToPos( pos, options )
	


	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )




	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end

		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		
		coroutine.yield()

	end

	return "ok"

end

function ENT:Alive()
	if self:Health() > 0 then return true
	end
end

function ENT:CheckValid()
	if self:IsValid() then return true
	end
	if self:Alive() then return true
	end
end

function ENT:GetDoor(ent)

	local doors = {}
	doors[1] = "models/props_c17/door01_left.mdl"
	doors[2] = "models/props_c17/door02_double.mdl"
	doors[3] = "models/props_c17/door03_left.mdl"
	doors[4] = "models/props_doors/door01_dynamic.mdl"
	doors[5] = "models/props_doors/door03_slotted_left.mdl"
	doors[6] = "models/props_interiors/elevatorshaft_door01a.mdl"
	doors[7] = "models/props_interiors/elevatorshaft_door01b.mdl"
	doors[8] = "models/props_silo/silo_door01_static.mdl"
	doors[9] = "models/props_wasteland/prison_celldoor001b.mdl"
	doors[10] = "models/props_wasteland/prison_celldoor001a.mdl"

	doors[11] = "models/props_radiostation/radio_metaldoor01.mdl"
	doors[12] = "models/props_radiostation/radio_metaldoor01a.mdl"
	doors[13] = "models/props_radiostation/radio_metaldoor01b.mdl"
	doors[14] = "models/props_radiostation/radio_metaldoor01c.mdl"


	for k,v in pairs( doors ) do
		if !IsValid( ent ) then break end
		if ent:GetModel() == v and string.find(ent:GetClass(), "door") then
			return "door"
		end
	end

end

function ENT:CheckDoor()

	if nb_doorinteraction:GetInt() == 1 then

		if ( self.NextCheck or 0 ) < CurTime() then
									
			local offset=Vector(0,0,50)
				local doorTrace={
					start=self:GetPos()+offset,
					endpos=self:GetPos()+(self:EyeAngles():Forward()*70)+offset,
					filter=self,
					mask=MASK_NPCSOLID
					}
					
			local doorTraceRes=util.TraceLine(doorTrace)
			if IsValid(doorTraceRes.Entity) and doorTraceRes.Entity~=NULL then
				
				--Door States:
				--2 = open
				--1 = opening
				--0 = closed
				--3 = closing
				
				if self:GetDoor( doorTraceRes.Entity ) and ( doorTraceRes.Entity:GetSaveTable().m_eDoorState == 0 ) then
				
					return doorTraceRes.Entity
				
				end
				
			end

			self.NextCheck = CurTime() + 1
		end
	
	end
	
	return false

end

function ENT:IsAttackerSameFaction( ent, faction )

	--if faction == 1 then
		--if ent.NEXTBOTZOMBIE then
			--return true
		--end
	--elseif faction == 2 then
		--if !ent.NEXTBOTZOMBIE and !ent.NEXTBOTMERCENARY and !ent.NEXTBOTCOMBINE then
			--return true
		--end
	--elseif faction == 3 then
		--if ent.NEXTBOTMERCENARY then
			--return true
		--end
	--elseif faction == 4 then
		--if ent.NEXTBOTCOMBINE then
			--return true
		--end
	--end
	
	--return false

end

function ENT:CheckFriendlyFire( attacker, faction )
	
	if SERVER then

		if nb_friendlyfire:GetInt() == 0 then

			if attacker and ( IsValid( attacker ) and attacker:Health() > 0 ) then

				if attacker.NEXTBOT then
					if !attacker.BASENEXTBOT and attacker != self then
					
						if self.NEXTBOTFACTION == attacker.NEXTBOTFACTION then
							return true
						end
						
					end
					--if faction == 1 then
						--if self:IsAttackerSameFaction( attacker, faction ) then
							--return true
						--end
					--end
					--if faction == 2 then
						--if self:IsAttackerSameFaction( attacker, faction ) then
							--return true
						--end	
					--end
					--if faction == 3 then
						--if self:IsAttackerSameFaction( attacker, faction ) then
							--return true
						--end
					--end	
					--if faction == 4 then
						--if self:IsAttackerSameFaction( attacker, faction ) then
							--return true
						--end
					--end
				end
				
				
			end	
				
		end
	
		return false
	
	end
	
end

function ENT:BleedVisual( time, pos, dmginfo )
	local bleed = ents.Create("info_particle_system")
	bleed:SetKeyValue("effect_name", "blood_impact_red_01")
	bleed:SetPos( pos )
	bleed:Spawn()
	bleed:Activate()
	bleed:Fire("Start", "", 0)
	bleed:Fire("Kill", "", time)
end

function ENT:CheckEnemyStatus( ent )

	if ent and IsValid( ent ) and ent:Health() > 0 then
		return true
	end
	
	return false

end

function ENT:DoDamage( dmg, type, ent )

	local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamagePosition( self:GetPos() + Vector(0,0,50) )
		dmginfo:SetDamage( dmg )
		dmginfo:SetDamageType( type )
		dmginfo:SetDamageForce( self.MeleeDamageForce )
		
	if ent:IsPlayer() then
		if self:IsPlayerZombie( ent ) then
			dmginfo:SetDamage( dmg/3 )
		end
	end
		
	ent:TakeDamageInfo(dmginfo)
	
	if ent:IsPlayer() or ( ent.NEXTBOT ) then
		self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )
	end
	
	if ent:Health() > 0 then
		if ent:IsPlayer() or ( ent.NEXTBOT ) then
			if ent:IsPlayer() then
				if string.find(ent:GetActiveWeapon():GetClass(), "wep_nb_k_*") then
					if ent:Alive() and ent:IsValid() then
						ent:GetActiveWeapon():Block()
					end
				end
			
				local viewpunch = ( Angle(math.random(-0.25, 0.25)*dmg, math.random(-0.25, 0.25)*dmg, math.random(-0.25, 0.25)*dmg) )
				ent:ViewPunch( viewpunch )
			end
		end
	end
	
end

function ENT:HaveEnemy()

	local enemy = self:GetEnemy()

	if ( enemy and IsValid( enemy ) ) then
		if ( enemy:Health() < 0 ) then
			return self:FindEnemy()
		end
		
		if enemy:IsPlayer() and ai_ignoreplayers:GetInt() == 1 then 
			return self:FindEnemy()
		elseif enemy:IsPlayer() and self:IsPlayerZombie( enemy ) then
			return self:FindEnemy()
		end
		
		if ( self.NextCheckTimer or 0 ) < CurTime() then --Every 5-8 seconds, find new and best target
			self:FindEnemy()
			if nb_targetmethod:GetInt() == 1 then
				self.LastEnemy = enemy
				timer.Simple(math.random(0.1,1.5),function()
					if IsValid( self ) and self:Health() > 0 then
						if !self.Enemy and self.LastEnemy then
							if IsValid( self.LastEnemy ) and self.LastEnemy:Health() > 0 then
								self:SetEnemy( self.LastEnemy )
							else
								self.LastEnemy = nil
							end
						end
					end
				end)
			end
			self.NextCheckTimer = CurTime() + math.random(5,8)
		end
		
		return true
		
	else
		return self:FindEnemy()
	end
end

function ENT:AlertNearby( ent )

	if nb_targetmethod:GetInt() == 1 then

		if ent and ( IsValid( ent ) and ent:Health() > 0 ) then

			for k,v in pairs( ents.FindByClass("nb_*") ) do

				if !v.BASENEXTBOT and v != self and IsValid(v)then
					
					if self.NEXTBOTFACTION == v.NEXTBOTFACTION then

						if !v:HaveEnemy() then
								
							local disttocheck = ( ( self.ChaseDistance or 3000 ) / 2 )
								
							if self:GetRangeSquaredTo( v ) < disttocheck*disttocheck and self:Visible( v ) then
								
								if ( IsValid( v ) and v:Health() > 0 ) then
									
									v:SetEnemy( ent )
									v:BehaveStart()

								end
									
							end

						end
						
					end
				
				end

			end

		end
	
	end
	
end

function ENT:CustomOnThink()

end

function ENT:Think()

	--while self.TouchedDoor do
		--local back = self:GetPos() + self:GetAngles():Forward() * -628
		--self.loco:Approach(back, 200)
	--end
	
	self:CustomOnThink()
	
	if self.IsAlerted then
	
		if self.AlertedEntity and ( IsValid( self.AlertedEntity ) and self.AlertedEntity:Health() > 0 ) then
			self.loco:FaceTowards( self.AlertedEntity:GetPos() )
		end
	
	end
	
end

function ENT:CheckAlert( ent )

	if ent and ( IsValid( ent ) and ent:Health() > 0 ) then
		
		local orgrate = self.loco:GetMaxYawRate()
		self.loco:SetMaxYawRate( 10 )
		
		self.IsAlerted = true
		self.AlertedEntity = ent
			
		timer.Simple( 1.5, function()
			if IsValid( self ) and self:Health() > 0 then
				
				self.loco:SetMaxYawRate( orgrate )
				self.IsAlerted = false
					
			end
		end)
			
	end

end

function ENT:CustomOnOtherKilled( ent, dmginfo )

end

function ENT:OnOtherKilled( ent, dmginfo )

	if nb_targetmethod:GetInt() == 1 then

		if ( self.NextKilledEnemyTimer or 0 ) < CurTime() then
	
			if ent then
			
				if ( ent.NEXTBOT or ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) ) then
				
					if (self.HaveEnemy and !self:HaveEnemy()) then
				
						local enemy = dmginfo:GetAttacker()
			
						if enemy and ( IsValid( enemy ) and enemy:Health() > 0 ) then
				
							if self:CanTargetThisEnemy( enemy ) then	
				
								if ( ( self:GetRangeSquaredTo( enemy ) < ( self.ChaseDistance*self.ChaseDistance ) or 2000*2000 ) and self:Visible( enemy ) ) then
							
									self:SetEnemy( enemy )
									self:BehaveStart()
							
								else
								
									self:CheckAlert( ent )
								
								end
				
							end
				
						end
				
					end
				
				end
			
			end
	
			self.NextKilledEnemyTimer = CurTime() + 1
		end
	
	end
	
	self:CustomOnOtherKilled( ent, dmginfo )

end

function ENT:CheckEnemyPosition( dmginfo )

	if nb_targetmethod:GetInt() == 1 then

		if ( self.NextEnemyCheckTimer or 0 ) < CurTime() then

			local enemy = dmginfo:GetAttacker()

				if self:CanTargetThisEnemy( enemy ) then

					if !self:HaveEnemy() then
					
						if ( ( self:GetRangeSquaredTo( enemy ) < ( self.ChaseDistance*self.ChaseDistance ) or 3000*3000 ) and self:Visible( enemy ) ) then
							
							self:SetEnemy( enemy )
							self:BehaveStart()
								
							self:AlertNearby( enemy )
								
						else
							
							self:CheckAlert( enemy )
								
						end
					
					end

				end

			self.NextEnemyCheckTimer = CurTime() + 1
		end
	
	end
	
end

function ENT:SearchForEnemy( ents )

	if #ents > 0 then
	
		local bestenemy = self:FirstValueTable( ents )
		if self:CheckTargetMethod( bestenemy ) then
			--print( bestenemy, "nb: ", self )
			self:SetEnemy( bestenemy )
			return true
		else
			self:SetEnemy( nil )
			return false
		end
	else
		self:SetEnemy( nil )
		return false
	end
	
end

function ENT:FirstValueTable( table )
	
	if table and #table > 0 then
	
		if table[0] != nil then
			return table[0]
		else
			return table[1]
		end
		
	end
	
end

function ENT:CanTargetThisEnemy( ent )
	//print(ent)
	if ent then
	
		if ent.BASENEXTBOT then return false end
		//print("p1")
		if IsValid( ent ) and ent:Health() > 0 then
			//print("p2")
			if ent.NEXTBOT then
				if ent.NEXTBOTFACTION != self.NEXTBOTFACTION then
					return true	
				end
			else
				//print("p3")
				if ai_ignoreplayers:GetInt() == 0 then
					if ent:IsPlayer() then
						//print("p4")
						if ent:Alive() then
							//print("p5")


							if self.FriendlyToPlayers then
								//print("p6")
								if self:IsPlayerZombie( ent ) or ent:IsBandit() then
									return true
								end
							elseif(self.NEXTBOTMERCENARY and ent:IsBandit()) then

								return false
							
							else
								
								if self.NEXTBOTFACTION == 'NEXTBOTZOMBIE' then
									if !self:IsPlayerZombie( ent ) then
										return true
									end
								else
									return true
								end
							end
						end
					end
				end
			end
		end
		
	end

	return false
	
end

function ENT:IsPlayerZombie( ent )

	if ent then
		if ent:IsPlayer() and ent:IsValid() then
		
			local entweapon = ent:GetActiveWeapon()
			
			if IsValid(entweapon) then
				--if (type(entweapon.NextbotType) == "function") then
					--if entweapon:NextbotType() == zombie then --Zombie
						--return true
					--else
					--end --Isnt a zombie
				--else
					--Not using zombie swep
				--end
				if string.find(entweapon:GetClass(), "wep_nb_z_*") then
					return true
				end
			end
		end
	end
	
	return false
	
end

function ENT:CheckTargetMethod( ent )

	if nb_targetmethod:GetInt() == 1 then
							
		local dir = ( ent:GetPos() - self:GetPos() ):GetNormal(); 
		local canSee = dir:Dot( self:GetForward() ) > 0.5; -- -1 is directly opposite, 1 is self:GetForward(), 0 is orthogonal		
							
		if self:Visible( ent ) and canSee then 

			return true
				
		else
		
			return false
		
		end
							
	else
							
		return true
							
	end
	
end

--function ENT:FoundNEXTBOTEnemy( ent, iszombie, ismerc, isrebel, iscombine )

	--if ent.NEXTBOT then
	
		--if ( ent.NEXTBOTZOMBIE and iszombie == false ) 
		--or ( ent.NEXTBOTMERCENARY and ismerc == false ) 
		--or ( ent.NEXTBOTCOMBINE and iscombine == false )
		--or ( !ent.NEXTBOTZOMBIE and !ent.NEXTBOTMERCENARY and !ent.NEXTBOTCOMBINE and isrebel == false ) then
		
		--if self:CanTargetThisEnemy( ent ) then
		
			--if ent:Health() > 0 then
				
				--if nb_targetmethod:GetInt() == 1 then
							
					--local dir = ( ent:GetPos() - self:GetPos() ):GetNormal(); 
					--local canSee = dir:Dot( self:GetForward() ) > 0.5; -- -1 is directly opposite, 1 is self:GetForward(), 0 is orthogonal		
							
					--if self:Visible( ent ) and canSee then 

						--return true
				
					--end
							
				--else
							
					--return true
							
				--end
					
			--end
		

		--end
		
	--end
	
	--return false
	
--end

--function ENT:FoundPLAYEREnemy( ent, iszombie )

	--if ai_ignoreplayers:GetInt() == 0 then

		--if ent:IsPlayer() then
		
			--if ent:Health() > 0 then
			
				--if iszombie == true then
					
					--if self:IsPlayerZombie( ent ) then
					
						--if nb_targetmethod:GetInt() == 1 then
							
							--local dir = ( ent:GetPos() - self:GetPos() ):GetNormal(); 
							--local canSee = dir:Dot( self:GetForward() ) > 0.5; -- -1 is directly opposite, 1 is self:GetForward(), 0 is orthogonal
							
							--if self:Visible( ent ) and canSee then 
								
								--return true
								
							--end
								
						--else
							
							--return true
							
						--end
					
					--end
					
				--else
					
					--if !self:IsPlayerZombie( ent ) then
					
						--if nb_targetmethod:GetInt() == 1 then
								
							--local dir = ( ent:GetPos() - self:GetPos() ):GetNormal(); 
							--local canSee = dir:Dot( self:GetForward() ) > 0.5;
								
							--if self:Visible( ent ) and canSee then 
						
								--return true
						
							--end
								
						--else
							
							--return true
							
						--end
					
					--end	
					
				--end
				
			--end
		
		--end
			
	--end

	--return false	
		
--end

function ENT:PlayGestureSequence( sequence )
	local sequencestring = self:LookupSequence( sequence )
	self:AddGestureSequence( sequencestring, true )
end

--self.CustomWeaponClass = nil
--self.CustomReloadTime1 = 0.2
--self.CustomReloadTime2 = 1
--self.CustomReloadTime3 = 1.4
--self.CustomReloadSound1 = "weapons/m4a1/m4a1_clipout.wav"
--self.CustomReloadSound2 = "weapons/m4a1/m4a1_clipin.wav"
--self.CustomReloadSound3 = "weapons/m4a1/m4a1_boltpull.wav"

function ENT:SetCustomReloadSound()
	if self.CustomWeaponClass != nil then
		if self.WeaponClass == self.CustomWeaponClass then
			self:PlayReloadSound( ( self.CustomReloadTime1 or 0.2 ), ( self.CustomReloadTime2 or 1 ), ( self.CustomReloadTime3 or 1.4 ), self.CustomReloadSound1, self.CustomReloadSound2, self.CustomReloadSound3 )
		end
	end
end

function ENT:ChooseReloadSound()
	if ( self.WeaponClass == "wep_nb_m4a1" or self.WeaponClass == "wep_nb_m4a1s" ) then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/m4a1/m4a1_clipout.wav", "weapons/m4a1/m4a1_clipin.wav", "weapons/m4a1/m4a1_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_galil" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/galil/galil_clipout.wav", "weapons/galil/galil_clipin.wav", "weapons/galil/galil_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_mp5" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/mp5navy/mp5_clipout.wav", "weapons/mp5navy/mp5_clipin.wav", "weapons/mp5navy/mp5_slideback.wav" )
	elseif self.WeaponClass == "wep_nb_famas" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/famas/famas_clipout.wav", "weapons/famas/famas_clipin.wav", "weapons/famas/famas_forearm.wav" )
	elseif ( self.WeaponClass == "wep_nb_usps" or self.WeaponClass == "wep_nb_usp" ) then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/usp/usp_clipout.wav", "weapons/usp/usp_clipin.wav", "weapons/usp/usp_slideback.wav" )
	elseif self.WeaponClass == "wep_nb_pistol" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/usp/usp_clipout.wav", "weapons/usp/usp_clipin.wav", "weapons/usp/usp_slideback.wav" )
	elseif self.WeaponClass == "wep_nb_ump" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/ump45/ump45_clipout.wav", "weapons/ump45/ump45_clipin.wav", "weapons/ump45/ump45_boltslap.wav" )
	elseif self.WeaponClass == "wep_nb_aug" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/aug/aug_clipout.wav", "weapons/aug/aug_clipin.wav", "weapons/aug/aug_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_smg" then
		self:PlayReloadSound( 0.2, false, 1.4, "weapons/smg1/smg1_reload.wav", false, "weapons/mac10/mac10_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_revolver" then
		self:PlayReloadSound( 0.2, 1.7, 2.85, "weapons/357/357_reload1.wav", "weapons/357/357_reload3.wav", "weapons/357/357_spin1.wav" )
	elseif self.WeaponClass == "wep_nb_mac10" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/tmp/tmp_clipout.wav", "weapons/tmp/tmp_clipin.wav", "weapons/mac10/mac10_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_ak47" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/ak47/ak47_clipout.wav", "weapons/ak47/ak47_clipin.wav", "weapons/ak47/ak47_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_awp" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/awp/awp_clipout.wav", "weapons/awp/awp_clipin.wav", "weapons/scout/scout_bolt.wav" )
	elseif self.WeaponClass == "wep_nb_ar2" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/ar2/ar2_reload_rotate.wav", "weapons/ar2/ar2_reload_push.wav", "weapons/mac10/mac10_boltpull.wav" )
	elseif self.WeaponClass == "wep_nb_ar3" then
		self:PlayReloadSound( 0.2, 1, 1.4, "weapons/ar2/ar2_reload_rotate.wav", "weapons/ar2/ar2_reload_push.wav", "weapons/mac10/mac10_boltpull.wav" )
	end
	
	if self.Weapon.TypeClass == "shotgun" then
		self:PlayReloadSound( 0.2, 1, 1.6, "weapons/shotgun/shotgun_reload"..math.random(1,3)..".wav", "weapons/shotgun/shotgun_reload"..math.random(1,3)..".wav", "weapons/shotgun/shotgun_cock.wav" )
	else
		self:SetCustomReloadSound()
	end
end

function ENT:PlayReloadSound( time1, time2, time3, sound1, sound2, sound3 )

	if time1 and sound1 then
		timer.Simple( time1, function()
			if IsValid( self ) and self:Health() > 0 then
				self:EmitSound( sound1 )
			end
		end)
	end
			
	if time2 and sound2 then		
		timer.Simple( time2, function()
			if IsValid( self ) and self:Health() > 0 then
				self:EmitSound( sound2 )
			end
		end)
	end
	
	if time3 and sound3 then
		timer.Simple( time3, function()
			if IsValid( self ) and self:Health() > 0 then
				self:EmitSound( sound3 )
			end
		end)
	end
	
end

function ENT:ResetWeapon()
	self.FoundArea = false
	self.BulletsUsed = 0
	self.Reloading = false
	self.ReloadAnimation = false
	self.LookingForReload = false
	
	self:BehaveStart()
	
	if !self.Downed then
		self:MovementFunction( "standreload" )
	end
end

function ENT:ReloadWeapon( type )

	if !self.Crouching or self.Downed then

		if type == "running" then
			if !self.ReloadAnimation then
		
				if !self.Downed then
					self:MovementFunction( "standreload" )
				end
		
				self.ReloadAnimation = true
		
				local reloadanim = self.RunningReloadAnim
				self:PlayGestureSequence( self.RunningReloadAnim )

				if !self.Downed then
					timer.Simple( ( self:SequenceDuration( reloadanim ) + 1 ), function()
						if IsValid( self ) and self:Health() > 0 then
							self:ResetWeapon()
						end
					end)
				else
					timer.Simple( ( 2.3 ), function()
						if IsValid( self ) and self:Health() > 0 then
							self:ResetWeapon()
						end
					end)
				end
				
				if !( self.RunningReloadAnim == "reload_shotgun" or self.RunningReloadAnim == "reload_revolver" ) then
					self:ChooseReloadSound()
				end
			end
			
		elseif type == "standing" then
			if !self.ReloadAnimation then
			
				self:MovementFunction( "standreload" )
			
				self.ReloadAnimation = true
				
				self:ChooseReloadSound()
				self:PlaySequenceAndWait( self.StandingReloadAnim, 1 )
				self:ResetWeapon()
			end
		end
		
	else
	
		if !self.ReloadAnimation then

			self:MovementFunction( "crouching" )
			
			local reloadanim = self.CrouchingReloadAnim
			self:PlayGestureSequence( reloadanim )
			
			self.ReloadAnimation = true
			
			timer.Simple( ( self:SequenceDuration( reloadanim ) + 1 ), function()
				if IsValid( self ) and self:Health() > 0 then
					self:ResetWeapon()
				end
			end)
			
			if !( self.CrouchingReloadAnim == "reload_shotgun" or self.CrouchingReloadAnim == "reload_revolver" ) then
				self:ChooseReloadSound()
			end
		end
		
	end
	
end

function ENT:ChooseRandomReload( type1, type2 )

	if math.random(1,2) == 1 then
		self:ReloadWeapon( type1 )
	else
		self:ReloadWeapon( type2 )
	end

end

function ENT:EquipWeapon()
	local att = "anim_attachment_rh"
	local shootpos = self:GetAttachment(self:LookupAttachment(att))
		
	local wep = ents.Create( self.WeaponClass )
	wep:SetOwner(self)
	wep:SetPos(shootpos.Pos)
	--wep:SetAngles(ang)
	wep:Spawn()
	wep:SetSolid(SOLID_NONE)
	wep:SetParent(self)
	wep:SetNotSolid(true)
	wep:SetTrigger(false)
	wep:Fire("setparentattachment", "anim_attachment_rh")
	wep:AddEffects(EF_BONEMERGE)
	wep:SetAngles(self:GetForward():Angle())
	wep:SetOwner( self )
		
	self.Weapon = wep
	self.BulletsUsed = 0
	self.ClipAmount = self.ClipAmount

	if wep.MuzzleAnim == nil then --If there's no muzzle anim, then change weptype to 2 and create bulletejection/muzzle flashes
		self.WeaponType = 2
		self.WeaponMuzzleAnim = nil
	else
		self.WeaponType = wep.WeaponType
		self.WeaponMuzzleAnim = wep.MuzzleAnim
	end

	self.Reloading = false
end

function ENT:PoseParameters()
	if SERVER then
		self.loco:FaceTowards( self.Enemy:GetPos() )
	end			
				
	local muzzpos
	muzzpos = self:GetPos()+Vector(0,0,68)
				
	local target = self.Enemy
			
	local targetpos = target:GetPos() + Vector(0,0,60) --or target:GetPos() --  target:HeadTarget(self:GetPos())
	if self.Enemy.NEXTBOT then
		if self.Enemy.Downed then
			targetpos = target:GetPos()
		else
			targetpos = target:GetPos() + Vector(0,0,60)
		end
	end
	
	local TargetOffset = WorldToLocal(targetpos, Angle(), muzzpos, self:GetAngles())
	local Distance = targetpos:Distance(muzzpos)
			
	local newYaw=-math.deg(math.atan(TargetOffset.Y/TargetOffset.X )) --Determine what angle Tangent of X and Y combined will yield, in degrees form.
	local newPitch=math.deg(math.asin(TargetOffset.Z/Distance))	 --Much more simple with a single dimesion.

	--When the target is behind us, aim pos is going to behave as if is has eyes on the back of it's head:
	if TargetOffset.X/Distance < 0 then
		newYaw=newYaw+180
	end
			
	local Pitch=math.NormalizeAngle(newPitch)
	local Yaw=math.NormalizeAngle(newYaw)
			
	if Pitch > 90 then
		Pitch=90
	elseif Pitch < -45 then
		Pitch = -45
	end
			
	if Yaw > 42 then
		Yaw = 41
		self.loco:FaceTowards( targetpos )
	elseif Yaw < -42 then
		Yaw = -41
		self.loco:FaceTowards( targetpos )
	end
			
	self:SetPoseParameter( "aim_pitch", -Pitch )
	self:SetPoseParameter( "aim_yaw", -Yaw )
end

function ENT:AimPos()

	local AngleMod = self:GetAngles() - Angle(-self:GetPoseParameter("aim_pitch"), -self:GetPoseParameter("aim_yaw"), 0)

	local startpoint = (self:GetPos() + Vector(0,0,55)) + (AngleMod:Forward() * 64)
	local endpoint = (self:GetPos() + Vector(0,0,55)) + (AngleMod:Forward() * 1024)

	local trace = util.TraceLine({
		start = startpoint,
		endpos = endpoint
	})
	
	--local tr0vis=constraint.Rope(Entity(0), Entity(0), 0, 0, startpoint, trace.HitPos, 5, 0, 5, 1, "cable/cable", false )
	--timer.Simple(0.1, function() tr0vis:Remove() end)

	--^this^ was used to visualize the trace to our aim pos
	
	return trace.HitPos--trace.Normal

end