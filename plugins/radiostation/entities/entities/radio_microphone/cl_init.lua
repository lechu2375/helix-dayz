-- VoiceRadio
-- Copyright (c) 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2010 BoJaN
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- $Id$

include("shared.lua")

local matLight = Material("sprites/light_ignorez")

function ENT:Initialize()
    self.PixVis = util.GetPixelVisibleHandle()
end

function ENT:Draw()    
    local lightPos = self:LocalToWorld(Vector(0, -3, 62.5))
    render.SetMaterial(matLight)
    local visible = util.PixelVisible(lightPos, 1, self.PixVis)
    render.DrawSprite(lightPos, 5, 5, self.dt.On and Color(255, 0, 0, visible * 255) or Color(0, 255, 0, visible * 255))
    
    local tr = LocalPlayer():GetEyeTrace()
    
    if tr.Entity == self then        
        if self.dt.On then
            AddWorldTip(self:EntIndex(), "Radiostacja nadaje!", 0.5, self:LocalToWorld(Vector(0, 0, 64)), self)
        else
            AddWorldTip(self:EntIndex(), "Radiostacja jest wyłączona", 0.5, self:LocalToWorld(Vector(0, 0, 64)), self)
        end
    end
    
    self:DrawModel()
end

local data = {}
function ENT:IsInRange()
    if not self.dt.On then return false end
    
    local micPos = self:LocalToWorld(Vector(0, 0, 64))
    
    if LocalPlayer():GetShootPos():Distance(micPos) >= 200 then return end
    
    data.start = micPos
    data.endpos = LocalPlayer():GetShootPos()
    data.filter = player.GetAll()
    table.insert(data.filter, self.Entity)
    local tr = util.TraceLine(data)
    return not tr.Hit
end