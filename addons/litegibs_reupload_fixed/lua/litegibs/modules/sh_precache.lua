function LiteGibs.Precache()
	for _, base in pairs(LiteGibs.GibModels) do
		for _, v in pairs(base) do
			for _, model in pairs(v.models) do
				util.PrecacheModel(model)
			end
		end
	end
	for _, v in pairs(LiteGibs.WoundModels) do
		for _, b in pairs(v) do
			if b.model then
				util.PrecacheModel(b.model)
			end
		end
	end
	for _, v in pairs(LiteGibs.GoreModels) do
		for _, model in pairs(v) do
			util.PrecacheModel(model)
		end
	end
	for k,v in pairs(LiteGibs.Sounds) do
		util.PrecacheSound(Sound(v))
	end
end

hook.Add("InitPostEntity","LightGibsPrecache",function()
	LiteGibs.Precache()
end)