ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PrintName = "Helicoper BWAAF"
ENT.Category = "BWA"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Model = Model("models/blackwatcharmy_nextbots/veh/heli.mdl")
ENT.AutomaticFrameAdvance = true

ENT.SoundTable = {
    {
        t = 0,
        s = "bwa_veh/sas1_veh1_int_quad_front_stat.wav",
        b = "tag_main_rotor_static",
        v = 149
    },
    {
        t = 0,
        s = "bwa_veh/sas1_veh1_ceilingrattles_spot_stat.wav",
        b = "tag_main_rotor_static"
    },
    {
        t = 0,
        s = "bwa_veh/sas1_veh1_int_quad_rear_stat.wav",
        b = "tail_rotor_jnt",
        v = 135
    },
    {
        t = 22 / 30,
        s = "bwa_veh/sas1_veh1_foley_doorman_npc.wav",
        b = "tag_origin"
    },
    {
        t = 22 / 30,
        s = "bwa_veh/sas1_veh1_door_ster_pan.wav",
        b = "tag_origin"
    },
    {
        t = 0,
        s = "bwa_veh/sas1_veh1_foley_seat1_plr.wav",
        b = "tag_origin"
    },
    {
        t = 42 / 30,
        s = "bwa_veh/sas1_veh1_rope_spot_stat.wav",
        b = "tag_origin"
    },
    {
        t = 184 / 30,
        s = "bwa_veh/sas1_veh1_foley_seat1_npc.wav",
        b = "tag_origin"
    },
    {
        t = 190 / 30,
        s = "bwa_veh/sas1_veh1_foley_seat2_npc.wav",
        b = "tag_origin"
    },
    {
        t = 280 / 30,
        s = "bwa_veh/sas1_veh1_foley_seat3_npc.wav",
        b = "tag_origin"
    },
    {
        t = 328 / 30,
        s = "bwa_veh/sas1_veh1_ext_ster_pan.wav",
        b = "tag_origin"
    },
}

function ENT:Initialize()
    self:SetModel(self.Model)

    if SERVER then
        self:SetPos(self:GetPos() + Vector(0, 0, 10))

        local tr = {
            start = self:GetPos(),
            endpos = self:GetPos() + Vector(0, 0, 512)
        }

        if tr.HitSky then
            self:SetAngles(Angle(0, math.Rand(0, 360), 0))
        else
            local testpos = self:GetPos() + Vector(0, 0, 512)

            local amt = 15

            local best = 0
            local best_dist = math.huge

            local offset = math.Rand(0, 360)

            for i = 1, amt do
                local angle = math.Rand(0, 360)

                local str = util.TraceLine({
                    start = testpos,
                    endpos = testpos + Angle(0, angle + offset, 0):Forward() * 10000
                })

                if str.HitSky then
                    best = angle
                    break
                elseif str.Fraction == 1 then
                    best = angle
                    break
                elseif str.Fraction * 10000 > best_dist then
                    best = angle
                    best_dist = str.Fraction * 10000
                end
            end

            self:SetAngles(Angle(0, best + offset + 180 - 10, 0))
            self:SetPos(self:LocalToWorld(-Vector(107.472321, -70.542793, 0)))
        end
    end

    timer.Simple(14, function()
        if !IsValid(self) then return end
        self:Finish()
    end)

    timer.Simple(31.6, function()
        if !IsValid(self) then return end

        self:SetRenderFX(kRenderFxFadeSlow)
    end)

    timer.Simple(36.6, function()
        if !IsValid(self) then return end

        if SERVER then
            self:Remove()
        end
    end)

    if CLIENT then return end
    self:ResetSequence("spawn")

    for _, s in ipairs(self.SoundTable) do
        timer.Simple(s.t, function()
            if !IsValid(self) then return end

            local sproxy = ents.Create("bwa_infil_soundproxy")
            sproxy:SetOwner(self:GetOwner())
            sproxy:SetPos(self:GetPos())
            sproxy:SetAngles(self:GetAngles())
            sproxy:SetParent(self)
            sproxy.Sound = s.s
            sproxy.Bone = s.b
            sproxy.Vol = s.v or 100
            sproxy:Spawn()
        end)
    end

    self.mod1, self.mod1_1 = self:CreateSoldierModel(1)
    self.mod2, self.mod2_1 = self:CreateSoldierModel(2)
    self.mod3, self.mod3_1 = self:CreateSoldierModel(3)
    self.mod4, self.mod4_1 = self:CreateSoldierModel(4)

    timer.Simple(11.5, function()
        if IsValid(self.mod1) then
            self:CreateSoldierNPCFromModel(1)
            self.mod1:Remove()
        end
    end)
    timer.Simple(12.5, function()
        if IsValid(self.mod2) then
            self:CreateSoldierNPCFromModel(2)
            self.mod2:Remove()
        end
    end)
    timer.Simple(14, function()
        if IsValid(self.mod3) then
            self:CreateSoldierNPCFromModel(3)
            self.mod3:Remove()
        end
    end)
end

function ENT:Finish()
    if CLIENT then return end
    self:SetBodygroup(3, 1)
    if IsValid(self.mod4) then
        self.mod4:Remove()
    end
end

function ENT:CreateSoldierModel(type)
    local friend = ents.Create("prop_dynamic")
    local friend2 = ents.Create("base_anim")
    if type == 1 then
        friend:SetModel("models/blackwatcharmy_nextbots/veh/guy01.mdl")
    elseif type == 2 then
        friend:SetModel("models/blackwatcharmy_nextbots/veh/guy02.mdl")
    elseif type == 3 then
        friend:SetModel("models/blackwatcharmy_nextbots/veh/guy03.mdl")
    elseif type == 4 then
        friend:SetModel("models/blackwatcharmy_nextbots/veh/chiefl.mdl")
    end
    friend:SetPos(self:GetPos())
    friend:SetAngles(self:GetAngles())
    friend:SetParent(self)
    friend:Spawn()
    friend:ResetSequence('spawn')
    friend2:SetModel("models/blackwatcharmy_nextbots/bwaaf_soldier_ragdoll.mdl")
    friend2:SetPos(self:GetPos())
    friend2:SetAngles(self:GetAngles())
    friend2:SetParent(friend)
    friend2:AddEffects(1)
    friend2:Spawn()
    friend2:SetSkin(math.random(0,12))
    local tab1 = {3, 5, 6, 7, 8, 9, 10, 12, 13, 14}
    local tab2 = {math.random(0,6), math.random(0,6), math.random(0,2), math.random(0,4), math.random(0,5), 1, math.random(0,1), math.random(0,1), math.random(0,1), math.random(0,1)}
    for i, v in ipairs(tab1) do
        friend2:SetBodygroup(v, tab2[i])
    end
    return friend, friend2
end

function ENT:CreateSoldierNPCFromModel(type)
    local pos = self:GetPos()
    local ang = self:GetAngles()
    local bgs = self
    if type == 1 then
        pos = self:LocalToWorld(Vector(112.3, -73.6, -10))
        ang = self.mod1:GetAngles()+Angle(0,180,0)
        bgs = self.mod1_1   
    elseif type == 2 then
        pos = self:LocalToWorld(Vector(66.85, -115.5, -10))
        ang = self.mod2:GetAngles()+Angle(0,180,0)
        bgs = self.mod2_1  
    elseif type == 3 then
        pos = self:LocalToWorld(Vector(73.1, -40.8, -10))
        ang = self.mod3:GetAngles()+Angle(0,180,0)
        bgs = self.mod3_1      
    end
    local friend = ents.Create("bwaaf_soldier")
    friend:SetPos(pos)
    friend:SetAngles(ang)
    friend:Spawn()
    if self.invasion then
        friend.invasion = true
    end
    BWA:CopyBodygroups(bgs, friend)
end

function ENT:Think()
    self:NextThink(CurTime())
    return true
end