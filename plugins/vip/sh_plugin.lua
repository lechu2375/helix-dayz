

local PLUGIN = PLUGIN

PLUGIN.name = "Vip Functions"
PLUGIN.author = "Lechu2375"
PLUGIN.description = "Funkcje dla osób wspierających serwer."


local playerMeta = FindMetaTable("Player")
local charMeta = ix.meta.character


function playerMeta:IsVip()
    return (self:IsUserGroup("vip") or self:IsUserGroup("superadmin"))
end


function charMeta:IsVip()
    return self:GetPlayer():IsVip()
end

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")