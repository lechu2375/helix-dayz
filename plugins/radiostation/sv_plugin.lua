local PLUGIN = PLUGIN

function PLUGIN:SaveRadiostations()
	local data = {}

	for _, v in ipairs(ents.FindByClass("radio_receiver")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("radioStations", data)
end

function PLUGIN:LoadRadiostations()
	for _, v in ipairs(ix.data.Get("radioStations") or {}) do
		local radiostation = ents.Create("radio_receiver")
		radiostation:SetPos(v[1])
		radiostation:SetAngles(v[2])
		radiostation:Spawn()
        radiostation:GetPhysicsObject():EnableMotion(false) //freezee!!
	end
end

function PLUGIN:LoadData()
    self:LoadRadiostations()
end

function PLUGIN:SaveData()
    self:SaveRadiostations()
end