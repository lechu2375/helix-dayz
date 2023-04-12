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

module("voicechannel", package.seeall)

local Band = {}

function Band:__construct(id, flags)
    self.Mics = {}
    self.Speakers = {}

    hook.Add("PlayerCanHearPlayersVoice", "MediaChannel" .. id, function(ply1, ply2)
        if self:CanHearFrom(ply2, ply1) then
            return true
        end
    end)
end

function Band:Register(channel, ent, isSpeaker, isMicrophone)
    if not self.Mics[channel] then
        self.Mics[channel] = {}
        self.Speakers[channel] = {}
    end
    
    if isMicrophone then
        self.Mics[channel][ent] = true
    end
    if isSpeaker then
        self.Speakers[channel][ent] = true
    end
end

function Band:Unregister(channel, ent)
    if not self.Mics[channel] then
        return
    end
    
    self.Mics[channel][ent] = nil
    self.Speakers[channel][ent] = nil
    
    if table.Count(self.Mics[channel]) == 0 and table.Count(self.Speakers[channel]) == 0 then
        self.Mics[channel] = nil
        self.Speakers[channel] = nil
    end
end

function Band:CanHearFrom(broadcaster, listener) 
    for chanID, ents in pairs(self.Mics) do
        for ent, _ in pairs(ents) do
            if ent:InMicrophoneRange(broadcaster) then -- removed ValidEntity(ent) and
                -- Now let's see if the listener can listen to this channel
                if self:Hears(chanID, listener) then
                    return true
                end
            end
        end
    end
    
    return false
end

function Band:Hears(channel, listener)
    if not self.Speakers[channel] then
        return false
    end
    
    for ent, _ in pairs(self.Speakers[channel]) do
        if ent:InSpeakerRange(listener) then -- removed ValidEntity(ent) and
            return true
        end
    end
    
    return false
end

local bands = {}

function CreateBand(id, flags)
    if bands[id] then
        return bands[id]
    end
    
    local flags = flags or 0
    local instance = {}
    setmetatable(instance, { __index = Band })
    Band.__construct(instance, id, flags)
    bands[id] = instance
    return instance
end


function GetBand(id)
    if bands[id] then
        return bands[id]
    end
    
    Error("Band " .. id .. " is not defined")
end
