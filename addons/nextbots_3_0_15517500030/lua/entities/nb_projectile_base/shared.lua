ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() 
end
