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

    local mikropfone = ents.Create("radio_microphone")
    mikropfone:SetPos(Vector("1568.612061 5181.766113 912.031250"))
    //radiostation:SetAngles(angle_zero)
    mikropfone:Spawn()
    mikropfone:GetPhysicsObject():EnableMotion(false) //freezee!!
    //i huj jazda niech odpierdalają z mikro

    if(!timer.Exists("radioStationsEnabler")) then
        timer.Create("radioStationsEnabler", 120, 0, function() //nie ma kurwy jebane macie sluchac pierdolenia az kurwicy dostaniecie
            for _, v in ipairs(ents.FindByClass("radio_receiver")) do
                if(!v.dt.On) then 
                    v.dt.On = true
                end
            end       
        end)
    end
end

function PLUGIN:LoadData()
    self:LoadRadiostations()
end

function PLUGIN:SaveData()
    self:SaveRadiostations()
end