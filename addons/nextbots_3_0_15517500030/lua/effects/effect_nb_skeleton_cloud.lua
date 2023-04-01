function EFFECT:Init(data)
	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 48)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
		for i=1, 26 do
			 local smoke = emitter:Add("particle/particle_smokegrenade", self:GetPos())
				smoke:SetVelocity( VectorRand() * 100 )
                smoke:SetGravity( Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(10, 15)) )
                smoke:SetDieTime( math.Rand( 2.5, 5 ) )
                smoke:SetStartAlpha( 200 )
                smoke:SetEndAlpha( 0 )
                smoke:SetStartSize( 20 )
                smoke:SetEndSize( 45 )
                smoke:SetRoll( math.Rand(-180, 180) )
                smoke:SetRollDelta( math.Rand(-0.2,0.2) )
                smoke:SetColor( math.Rand( 220, 230 ), math.Rand( 245, 255 ), math.Rand( 220, 235 ) )
                smoke:SetAirResistance( 5 )
                smoke:SetPos( self:GetPos() + (VectorRand() * 64) )
                smoke:SetLighting( false )
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
