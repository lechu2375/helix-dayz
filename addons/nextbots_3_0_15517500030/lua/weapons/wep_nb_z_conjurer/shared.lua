if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.VElements = {
	["element_name+"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(22.337, -0.519, -1.558), angle = Angle(-3.507, 94.675, -1.17), size = Vector(1.34, 1.34, 1.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(22.337, -1.558, 0), angle = Angle(0, 94.675, -3.507), size = Vector(1.34, 1.34, 1.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name+"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, -0.519), angle = Angle(0, 78.311, 1.169), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, -0.519), angle = Angle(0, 78.311, 1.169), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

list.Set( "sean_nextbot_weapons", "wep_nb_z_conjurer", 	
{	Name = "Conjurer", 
	Class = "wep_nb_z_conjurer",
	Category = "Zombie SWEPs"	
})

SWEP.PrintName	= "Conjurer"

SWEP.Author		= "Sean"
SWEP.Purpose	= "Kill nextbot humans to turn them into zombies!"
SWEP.Instructions = "Left Click: Attack | Right Click: Summon Type 2s"

SWEP.Spawnable	= true
SWEP.UseHands	= false
SWEP.DrawAmmo	= false

SWEP.ViewModel = "models/weapons/conjurer/stalker/v_captive.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {}

SWEP.ViewModelFOV	= 80
SWEP.Slot			= 0
SWEP.SlotPos		= 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.HitDistance = 55
SWEP.LastPlayerModel = nil
SWEP.SetPlayerModelTo = "models/player/charple.mdl"

hook.Add( "ScalePlayerDamage", "nb_z_conjurer_dmg", function( ply, hitgroup, dmginfo )
	if ply:HasWeapon( "wep_nb_z_conjurer" ) then
		if ply:GetActiveWeapon():GetClass() == "wep_nb_z_conjurer" then
			dmginfo:ScaleDamage( 0.5 )
		end
	end
end)

hook.Add("CalcMainActivity", "animations", function(ply, velocity)
	if ply:Alive() and IsValid(ply) then
		if ply:HasWeapon( "wep_nb_z_conjurer" ) then
			if ply:GetActiveWeapon():GetClass() == "wep_nb_z_conjurer" then
				--velocity:Length2D() > 1
				if ply:OnGround() and !ply:Crouching() then
					return ACT_HL2MP_RUN_FAST, -1
				end
				
				if !ply:OnGround() then
					return ACT_HL2MP_JUMP_KNIFE, -1
				end
				
				if ply:Crouching() then
					return ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, -1
				end
					
			end
		end
	end
end)

function SWEP:Deploy()

	self:SendWeaponAnim(ACT_VM_DEPLOY)
	
	self:UpdateNextIdle()
	
	self.LastPlayerModel = self:GetOwner():GetModel()
	self:GetOwner():SetModel( self.SetPlayerModelTo )

	return true

end

function SWEP:Holster()

	if self.LastPlayerModel != nil then
		self:GetOwner():SetModel( self.LastPlayerModel )
	end

   return true
   
end

function SWEP:OnRemove()

end

function SWEP:Initialize()
	self.ZOMBIENEXTBOTWEP = true --Used in wOs hook to prevent zombies getting downed
	self:SetHoldType( "knife" )
	
	if CLIENT then
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)

		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")                        
				end
			end
		end
	end
end

function SWEP:SetupDataTables()
	
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	
end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:PrimaryAttack( right )

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)

	local anim = "altfire"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.7 )
	
	self:SetNextPrimaryFire( CurTime() + 1.6 )
	self:SetNextSecondaryFire( CurTime() + 1.6 )

end

function SWEP:SecondaryAttack()
	
	local anim = "hitcenter2"
	if math.random(1,2) == 1 then
		anim = "hitcenter1"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	
	self:UpdateNextIdle()
	self:SetNextPrimaryFire( CurTime() + 1.6 )
	self:SetNextSecondaryFire( CurTime() + 3.5 )
	
	timer.Simple( 0.4, function()
	
		if ( self.NextSpawn or 0 ) < CurTime() then
			if self.Weapon and self.Owner and self.Owner:IsValid() and self.Owner:Health() > 0 then
	
				if SERVER then
					local ent = ents.Create( "nb_type2" )
					if ent:IsValid() then
						ent:SetPos( self.Owner:GetPos() + Vector(0,0,15) + self:GetForward() * 33 )
						ent:SetOwner( self.Owner )
						ent.Owner = self.Owner 
						ent.Entrance = true
						ent:Spawn()
						
						if ent.SlumpAnim == 1 then
							ent:ResetSequence( "zombie_slump_idle_01" )
						elseif ent.SlumpAnim == 2 then
							ent:ResetSequence( "zombie_slump_idle_02" )
						end
					
					end
				
				end

				self.NextSpawn = CurTime() + 3
			end
		end
	
	end)
	
end

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP.
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound("physics/metal/metal_barrel_impact_hard"..math.random(1, 3)..".wav")
	end

	local hit = false

	if SERVER && IsValid( tr.Entity ) then
		local dmginfo = DamageInfo()
	
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		
		dmginfo:SetDamageType( DMG_CLUB )
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )

		dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
		dmginfo:SetDamage( 55 )

		tr.Entity:TakeDamageInfo( dmginfo )
		
		if tr.Entity:IsPlayer() or tr.Entity.NEXTBOT or tr.Entity:IsNPC() then
			self:BleedVisual( 0.2, tr.HitPos )
		end
		
		hit = true

	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 360 * phys:GetMass(), tr.HitPos )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:Think()
	
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		self:SendWeaponAnim(ACT_VM_IDLE)
		
		self:UpdateNextIdle()
		
	end	
	
	local meleetime = self:GetNextMeleeAttack()
	
	if ( meleetime > 0 && CurTime() > meleetime ) then
	
		self:DealDamage()
		
		self:SetNextMeleeAttack( 0 )

	elseif ( meleetime > 0 && CurTime() > meleetime - 0.3 ) then
		self:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	end
	
end

function SWEP:BleedVisual( time, pos, dmginfo )
	local bleed = ents.Create("info_particle_system")
	bleed:SetKeyValue("effect_name", "blood_impact_red_01")
	bleed:SetPos( pos )
	bleed:Spawn()
	bleed:Activate()
	bleed:Fire("Start", "", 0)
	bleed:Fire("Kill", "", time)
end

function SWEP:NextbotType()
	return zombie
end

if CLIENT then

        SWEP.vRenderOrder = nil
        function SWEP:ViewModelDrawn()
                
                local vm = self.Owner:GetViewModel()
                if !IsValid(vm) then return end
                
                if (!self.VElements) then return end
                
                self:UpdateBonePositions(vm)

                if (!self.vRenderOrder) then
                        
                        // we build a render order because sprites need to be drawn after models
                        self.vRenderOrder = {}

                        for k, v in pairs( self.VElements ) do
                                if (v.type == "Model") then
                                        table.insert(self.vRenderOrder, 1, k)
                                elseif (v.type == "Sprite" or v.type == "Quad") then
                                        table.insert(self.vRenderOrder, k)
                                end
                        end
                        
                end

                for k, name in ipairs( self.vRenderOrder ) do
                
                        local v = self.VElements[name]
                        if (!v) then self.vRenderOrder = nil break end
                        if (v.hide) then continue end
                        
                        local model = v.modelEnt
                        local sprite = v.spriteMaterial
                        
                        if (!v.bone) then continue end
                        
                        local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
                        
                        if (!pos) then continue end
                        
                        if (v.type == "Model" and IsValid(model)) then

                                model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
                                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                                ang:RotateAroundAxis(ang:Forward(), v.angle.r)

                                model:SetAngles(ang)
                                //model:SetModelScale(v.size)
                                local matrix = Matrix()
                                matrix:Scale(v.size)
                                model:EnableMatrix( "RenderMultiply", matrix )
                                
                                if (v.material == "") then
                                        model:SetMaterial("")
                                elseif (model:GetMaterial() != v.material) then
                                        model:SetMaterial( v.material )
                                end
                                
                                if (v.skin and v.skin != model:GetSkin()) then
                                        model:SetSkin(v.skin)
                                end
                                
                                if (v.bodygroup) then
                                        for k, v in pairs( v.bodygroup ) do
                                                if (model:GetBodygroup(k) != v) then
                                                        model:SetBodygroup(k, v)
                                                end
                                        end
                                end
                                
                                if (v.surpresslightning) then
                                        render.SuppressEngineLighting(true)
                                end
                                
                                render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
                                render.SetBlend(v.color.a/255)
                                model:DrawModel()
                                render.SetBlend(1)
                                render.SetColorModulation(1, 1, 1)
                                
                                if (v.surpresslightning) then
                                        render.SuppressEngineLighting(false)
                                end
                                
                        elseif (v.type == "Sprite" and sprite) then
                                
                                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                                render.SetMaterial(sprite)
                                render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
                                
                        elseif (v.type == "Quad" and v.draw_func) then
                                
                                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                                
                                cam.Start3D2D(drawpos, ang, v.size)
                                        v.draw_func( self )
                                cam.End3D2D()

                        end
                        
                end
                
        end

        SWEP.wRenderOrder = nil
        function SWEP:DrawWorldModel()
                
                if (self.ShowWorldModel == nil or self.ShowWorldModel) then
                        self:DrawModel()
                end
                
                if (!self.WElements) then return end
                
                if (!self.wRenderOrder) then

                        self.wRenderOrder = {}

                        for k, v in pairs( self.WElements ) do
                                if (v.type == "Model") then
                                        table.insert(self.wRenderOrder, 1, k)
                                elseif (v.type == "Sprite" or v.type == "Quad") then
                                        table.insert(self.wRenderOrder, k)
                                end
                        end

                end
                
                if (IsValid(self.Owner)) then
                        bone_ent = self.Owner
                else
                        // when the weapon is dropped
                        bone_ent = self
                end
                
                for k, name in pairs( self.wRenderOrder ) do
                
                        local v = self.WElements[name]
                        if (!v) then self.wRenderOrder = nil break end
                        if (v.hide) then continue end
                        
                        local pos, ang
                        
                        if (v.bone) then
                                pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
                        else
                                pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
                        end
                        
                        if (!pos) then continue end
                        
                        local model = v.modelEnt
                        local sprite = v.spriteMaterial
                        
                        if (v.type == "Model" and IsValid(model)) then

                                model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
                                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                                ang:RotateAroundAxis(ang:Forward(), v.angle.r)

                                model:SetAngles(ang)
                                //model:SetModelScale(v.size)
                                local matrix = Matrix()
                                matrix:Scale(v.size)
                                model:EnableMatrix( "RenderMultiply", matrix )
                                
                                if (v.material == "") then
                                        model:SetMaterial("")
                                elseif (model:GetMaterial() != v.material) then
                                        model:SetMaterial( v.material )
                                end
                                
                                if (v.skin and v.skin != model:GetSkin()) then
                                        model:SetSkin(v.skin)
                                end
                                
                                if (v.bodygroup) then
                                        for k, v in pairs( v.bodygroup ) do
                                                if (model:GetBodygroup(k) != v) then
                                                        model:SetBodygroup(k, v)
                                                end
                                        end
                                end
                                
                                if (v.surpresslightning) then
                                        render.SuppressEngineLighting(true)
                                end
                                
                                render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
                                render.SetBlend(v.color.a/255)
                                model:DrawModel()
                                render.SetBlend(1)
                                render.SetColorModulation(1, 1, 1)
                                
                                if (v.surpresslightning) then
                                        render.SuppressEngineLighting(false)
                                end
                                
                        elseif (v.type == "Sprite" and sprite) then
                                
                                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                                render.SetMaterial(sprite)
                                render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
                                
                        elseif (v.type == "Quad" and v.draw_func) then
                                
                                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                                
                                cam.Start3D2D(drawpos, ang, v.size)
                                        v.draw_func( self )
                                cam.End3D2D()

                        end
                        
                end
                
        end

        function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
                
                local bone, pos, ang
                if (tab.rel and tab.rel != "") then
                        
                        local v = basetab[tab.rel]
                        
                        if (!v) then return end
                        
                        // Technically, if there exists an element with the same name as a bone
                        // you can get in an infinite loop. Let's just hope nobody's that stupid.
                        pos, ang = self:GetBoneOrientation( basetab, v, ent )
                        
                        if (!pos) then return end
                        
                        pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                        ang:RotateAroundAxis(ang:Up(), v.angle.y)
                        ang:RotateAroundAxis(ang:Right(), v.angle.p)
                        ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                                
                else
                
                        bone = ent:LookupBone(bone_override or tab.bone)

                        if (!bone) then return end
                        
                        pos, ang = Vector(0,0,0), Angle(0,0,0)
                        local m = ent:GetBoneMatrix(bone)
                        if (m) then
                                pos, ang = m:GetTranslation(), m:GetAngles()
                        end
                        
                        if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
                                ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
                                ang.r = -ang.r // Fixes mirrored models
                        end
                
                end
                
                return pos, ang
        end

        function SWEP:CreateModels( tab )

                if (!tab) then return end

                // Create the clientside models here because Garry says we can't do it in the render hook
                for k, v in pairs( tab ) do
                        if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
                                        string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
                                
                                v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
                                if (IsValid(v.modelEnt)) then
                                        v.modelEnt:SetPos(self:GetPos())
                                        v.modelEnt:SetAngles(self:GetAngles())
                                        v.modelEnt:SetParent(self)
                                        v.modelEnt:SetNoDraw(true)
                                        v.createdModel = v.model
                                else
                                        v.modelEnt = nil
                                end
                                
                        elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
                                and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
                                
                                local name = v.sprite.."-"
                                local params = { ["$basetexture"] = v.sprite }
                                // make sure we create a unique name based on the selected options
                                local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
                                for i, j in pairs( tocheck ) do
                                        if (v[j]) then
                                                params["$"..j] = 1
                                                name = name.."1"
                                        else
                                                name = name.."0"
                                        end
                                end

                                v.createdSprite = v.sprite
                                v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
                                
                        end
                end
                
        end
        
        local allbones
        local hasGarryFixedBoneScalingYet = false

        function SWEP:UpdateBonePositions(vm)
                
                if self.ViewModelBoneMods then
                        
                        if (!vm:GetBoneCount()) then return end
                        
                        // !! WORKAROUND !! //
                        // We need to check all model names :/
                        local loopthrough = self.ViewModelBoneMods
                        if (!hasGarryFixedBoneScalingYet) then
                                allbones = {}
                                for i=0, vm:GetBoneCount() do
                                        local bonename = vm:GetBoneName(i)
                                        if (self.ViewModelBoneMods[bonename]) then 
                                                allbones[bonename] = self.ViewModelBoneMods[bonename]
                                        else
                                                allbones[bonename] = { 
                                                        scale = Vector(1,1,1),
                                                        pos = Vector(0,0,0),
                                                        angle = Angle(0,0,0)
                                                }
                                        end
                                end
                                
                                loopthrough = allbones
                        end
                        // !! ----------- !! //
                        
                        for k, v in pairs( loopthrough ) do
                                local bone = vm:LookupBone(k)
                                if (!bone) then continue end
                                
                                // !! WORKAROUND !! //
                                local s = Vector(v.scale.x,v.scale.y,v.scale.z)
                                local p = Vector(v.pos.x,v.pos.y,v.pos.z)
                                local ms = Vector(1,1,1)
                                if (!hasGarryFixedBoneScalingYet) then
                                        local cur = vm:GetBoneParent(bone)
                                        while(cur >= 0) do
                                                local pscale = loopthrough[vm:GetBoneName(cur)].scale
                                                ms = ms * pscale
                                                cur = vm:GetBoneParent(cur)
                                        end
                                end
                                
                                s = s * ms
                                // !! ----------- !! //
                                
                                if vm:GetManipulateBoneScale(bone) != s then
                                        vm:ManipulateBoneScale( bone, s )
                                end
                                if vm:GetManipulateBoneAngles(bone) != v.angle then
                                        vm:ManipulateBoneAngles( bone, v.angle )
                                end
                                if vm:GetManipulateBonePosition(bone) != p then
                                        vm:ManipulateBonePosition( bone, p )
                                end
                        end
                else
                        self:ResetBonePositions(vm)
                end
                   
        end
         
        function SWEP:ResetBonePositions(vm)
                
                if (!vm:GetBoneCount()) then return end
                for i=0, vm:GetBoneCount() do
                        vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
                        vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
                        vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
                end
                
        end

        /**************************
                Global utility code
        **************************/

        // Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
        // Does not copy entities of course, only copies their reference.
        // WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
        function table.FullCopy( tab )

                if (!tab) then return nil end
                
                local res = {}
                for k, v in pairs( tab ) do
                        if (type(v) == "table") then
                                res[k] = table.FullCopy(v) // recursion ho!
                        elseif (type(v) == "Vector") then
                                res[k] = Vector(v.x, v.y, v.z)
                        elseif (type(v) == "Angle") then
                                res[k] = Angle(v.p, v.y, v.r)
                        else
                                res[k] = v
                        end
                end
                
                return res
                
        end
        
end