local textureInt = 0

--local ringMat = Material("effects/select_ring")
-- local redlaser_mat = Material( "cable/redlaser" )
--local blue_mat = Material( "cable/blue_elec" )
-- local hydr_mat = Material( "cable/hydra" )
-- local beam1_mat = Material( "cable/crystal_beam1" )

local Vector, render = Vector, render

function render.DrawBoundingBox( pos1, pos2, color, mat, thick )
	--mat = mat or blue_mat
	thick = thick or 1
	color = color or color_white

	local a1 = Vector( pos1.x, pos2.y, pos1.z )
	local a2 = Vector(pos2.x, pos1.y, pos1.z)
	local a3 = Vector(pos1.x, pos1.y, pos2.z)

	local b1 = Vector( pos2.x, pos2.y, pos1.z )
	local b2 = Vector( pos2.x, pos1.y, pos2.z )
	local b3 = Vector( pos1.x, pos2.y, pos2.z )

	if (mat) then
		render.SetMaterial( mat )
	else
		render.SetColorMaterial()
	end

	render.DrawBeam( pos1, a1, thick, textureInt, textureInt, color )
	render.DrawBeam( pos1, a2, thick, textureInt, textureInt, color )
	render.DrawBeam( pos1, a3, thick, textureInt, textureInt, color )
	render.DrawBeam( pos2, b1, thick, textureInt, textureInt, color )
	render.DrawBeam( pos2, b2, thick, textureInt, textureInt, color )
	render.DrawBeam( pos2, b3, thick, textureInt, textureInt, color )
	render.DrawBeam( a3, b3, thick, textureInt, textureInt, color )
	render.DrawBeam( a3, b2, thick, textureInt, textureInt, color )
	render.DrawBeam( b2, a2, thick, textureInt, textureInt, color )
	render.DrawBeam( b3, a1, thick, textureInt, textureInt, color )
	render.DrawBeam( b1, a1, thick, textureInt, textureInt, color )
	render.DrawBeam( b1, a2, thick, textureInt, textureInt, color )
end


function Schema:PrePlayerDraw(ply)
	if(LocalPlayer()==ply) then return  end
	if(!LocalPlayer():IsLineOfSightClear(ply)) then return true end
end
-- render.SetMaterial(ringMat)
-- render.DrawQuadEasy(center, vector_up, sizeRing, sizeRing, Color(50, 200, 50))
local ver = "DayZ Rozdział 1 wer. 0.70704a"
local w = draw.GetFontHeight( "DebugFixedSmall")
surface.SetFont("DebugFixedSmall")
local h = surface.GetTextSize(ver)
local wave = Material( "dayzlogo.png", "noclamp smooth" )
function Schema:PostRenderVGUI()
	ix.util.DrawText(ver, ScrW()-h, ScrH()-w, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, "DebugFixedSmall", 255)
	surface.SetMaterial( wave )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, 128, 112   )
end



