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



AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SpawnFunction(ply, tr)
    if not tr.HitWorld then return end
    
    local ent = ents.Create("radio_microphone")
    ent:SetPos(tr.HitPos + Vector(0,0,50))
    ent:Spawn()
    
    return ent
end

function ENT:OnRemove()
    self.Band:Unregister(0, self)
end

function ENT:Initialize()
    self.Band = voicechannel.GetBand("Radio")
    self.Band:Register(0, self, false, true)
    
    self:SetModel("models/mic.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(USE_TOGGLE)
    self:DropToFloor()
    
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
    
    self.Locked = false
    
    self.dt.On = true
    
    if WireAddon then
        self.Inputs = Wire_CreateInputs(self.Entity, {
            "On",
            "Locked",
        })
        
        self.Outputs = Wire_CreateOutputs(self.Entity, {
            "OnAir",
        })
        
        Wire_TriggerOutput(self.Entity, "OnAir", 1)
    end
end

local data = {}
function ENT:InMicrophoneRange(ply)
    if not self.dt.On then return false end
    
    local micPos = self:LocalToWorld(Vector(0, 0, 64))
    
    if ply:GetShootPos():Distance(micPos) >= 200 then return end
    
    data.start = micPos
    data.endpos = ply:GetShootPos()
    data.filter = player.GetAll()
    table.insert(data.filter, self.Entity)
    local tr = util.TraceLine(data)
    return not tr.Hit
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    if self.Locked then return end
    
    self:SetRecordState(not self.dt.On)
end

function ENT:TriggerInput(iname, value)
    if iname == "On" then
        if value > 0 then
            self:SetRecordState(true)
        else
            self:SetRecordState(false)
        end
    elseif iname == "Locked" then
        self.Locked = value > 0
    end
end

function ENT:SetRecordState(on)
    self.dt.On = on
    
    if WireAddon then
        Wire_TriggerOutput(self.Entity, "OnAir", on and 1 or 0)
    end
end

function ENT:Think()
end