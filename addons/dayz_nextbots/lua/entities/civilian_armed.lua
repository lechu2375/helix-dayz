if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot_human" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Armed Civilian"
ENT.Category = "DayZ"
ENT.Models = {
	"models/drem/cch/male_01.mdl",
    "models/drem/cch/male_02.mdl",
    "models/drem/cch/male_03.mdl"
}

-- Relationships --
ENT.Factions = {"FACTION_CIVIL"}

-- Movements --
ENT.UseWalkframes = true

-- Weapons --
ENT.Weapons = {
    "arccw_firearms2_glock20",
    "arccw_firearms2_gsh18",
    "arccw_firearms2_m1911",
    "arccw_firearms2_ots33",
    "arccw_firearms2_deagle",
    "arccw_firearms2_deagle357",
    "arccw_firearms2_sterling_mk7a4"
}
ENT.WeaponAccuracy = 0.20

if SERVER then

	-- Init/Think --

	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
        self:SetFactionRelationship("FACTION_BANDITS", D_NU,2)
		self:SetFactionRelationship("FACTION_CIVIL", D_NU,2)
		self:SetFactionRelationship("FACTION_CDF", D_NU,2)

	end
    function ENT:OnTookDamage(dmg, hitgroup) 
        local inflictor = dmg:GetInflictor()
        self:SetEntityRelationship(inflictor, D_HT,10)
    
    
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
