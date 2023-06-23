LiteGibs = LiteGibs or {}
LiteGibs.CVars = LiteGibs.CVars or {}

local function CreateReplConVar(cvarname, cvarvalue, description)
	return CreateConVar(cvarname, cvarvalue, CLIENT and {FCVAR_REPLICATED} or {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, description)
end -- replicated only on clients, archive/notify on server

if CLIENT then
	if string.lower(engine.ActiveGamemode()) == "nzombies" then
		LiteGibs.CVars.Enabled = CreateClientConVar("nz_litegibs_enabled","1",true,false,"Enable mod globally?")
		LiteGibs.CVars.BloodStreamEnabled = CreateClientConVar("nz_litegibs_fx_blood_stream_enabled","0",true,false,"Enable arterial streams")
		LiteGibs.CVars.BloodStreamTime = CreateClientConVar("nz_litegibs_fx_blood_stream_time","5",true,false,"Blood stream time before stopping")
		LiteGibs.CVars.BloodSprayEnabled = CreateClientConVar("nz_litegibs_fx_blood_spray_enabled","1",true,false,"Enable spray of blood upon gibbing")
		LiteGibs.CVars.BloodPoolEnabled = CreateClientConVar("nz_litegibs_fx_blood_pool_enabled","0",true,false,"Enable pool of blood upon damage")
		LiteGibs.CVars.BloodScreenEnabled = CreateClientConVar("nz_litegibs_fx_blood_screen_enabled","1",true,false,"Enable screen blood upon damage")
		LiteGibs.CVars.BloodFPEnabled = CreateClientConVar("nz_litegibs_fx_blood_wep_enabled","1",true,false,"Enable weapon/hand blood upon damage")
		LiteGibs.CVars.GibsEnabled = CreateClientConVar("nz_litegibs_fx_gibs_enabled","1",true,false,"Enable gib models")
		LiteGibs.CVars.GibsTime = CreateClientConVar("nz_litegibs_fx_gibs_time","5",true,false,"How long gib models appear before fading")
		LiteGibs.CVars.GibsBlood = CreateClientConVar("nz_litegibs_fx_gibs_blood","0",true,false,"Enable decals/blood from gibs at significant velocity")
		LiteGibs.CVars.GibsSound = CreateClientConVar("nz_litegibs_fx_gibs_sound","0",true,false,"Enable sound from gibs at significant velocity")
		LiteGibs.CVars.GibsRate = CreateClientConVar("nz_litegibs_fx_gibs_perframe","10",true,false,"Spawns this many gibs per frame(max)")
		LiteGibs.CVars.GibsQueue = CreateClientConVar("nz_litegibs_fx_gibs_queue","50",true,false,"Queue may contain this many gibs")
		LiteGibs.CVars.LimbsEnabled = CreateClientConVar("nz_litegibs_fx_limbs_enabled","1",true,false,"Enable extra ragdolls to represent sliced parts")
		LiteGibs.CVars.FootstepsEnabled = CreateClientConVar("nz_litegibs_footsteps","0",true,false,"Enable footstep interaction with gibs")
		LiteGibs.CVars.DamageMultiplier = CreateClientConVar("nz_litegibs_damage_multiplier","1.1",true,false,"Multiply damage by this for purpose of calculating gibbing")
		LiteGibs.CVars.WoundsEnabled = CreateClientConVar("nz_litegibs_fx_wounds_enabled","1",true,false,"Enable stencil-based wound system")
		LiteGibs.CVars.WoundsLive = CreateClientConVar("nz_litegibs_fx_wounds_live","0",true,false,"Enable stencil-based wounds on alive characters")
		LiteGibs.CVars.WoundsLimit = CreateClientConVar("nz_litegibs_fx_wounds_limit","8",true,false,"Max number of wounds at once")
		LiteGibs.CVars.LiveDismember = CreateClientConVar("nz_litegibs_fx_dismember_live","1",true,false,"Allow for live dismemberment?")
	else
		LiteGibs.CVars.Enabled = CreateClientConVar("cl_litegibs_enabled","1",true,false,"Enable mod globally?")
		LiteGibs.CVars.BloodStreamEnabled = CreateClientConVar("cl_litegibs_fx_blood_stream_enabled","0",true,false,"Enable arterial streams")
		LiteGibs.CVars.BloodStreamTime = CreateClientConVar("cl_litegibs_fx_blood_stream_time","5",true,false,"Blood stream time before stopping")
		LiteGibs.CVars.BloodSprayEnabled = CreateClientConVar("cl_litegibs_fx_blood_spray_enabled","1",true,false,"Enable spray of blood upon gibbing")
		LiteGibs.CVars.BloodPoolEnabled = CreateClientConVar("cl_litegibs_fx_blood_pool_enabled","1",true,false,"Enable pool of blood upon damage")
		LiteGibs.CVars.BloodScreenEnabled = CreateClientConVar("cl_litegibs_fx_blood_screen_enabled","1",true,false,"Enable screen blood upon damage")
		LiteGibs.CVars.BloodFPEnabled = CreateClientConVar("cl_litegibs_fx_blood_wep_enabled","1",true,false,"Enable weapon/hand blood upon damage")
		LiteGibs.CVars.GibsEnabled = CreateClientConVar("cl_litegibs_fx_gibs_enabled","1",true,false,"Enable gib models")
		LiteGibs.CVars.GibsTime = CreateClientConVar("cl_litegibs_fx_gibs_time","15",true,false,"How long gib models appear before fading")
		LiteGibs.CVars.GibsBlood = CreateClientConVar("cl_litegibs_fx_gibs_blood","0",true,false,"Enable decals/blood from gibs at significant velocity")
		LiteGibs.CVars.GibsSound = CreateClientConVar("cl_litegibs_fx_gibs_sound","0",true,false,"Enable sound from gibs at significant velocity")
		LiteGibs.CVars.GibsRate = CreateClientConVar("cl_litegibs_fx_gibs_perframe","10",true,false,"Spawns this many gibs per frame(max)")
		LiteGibs.CVars.GibsQueue = CreateClientConVar("cl_litegibs_fx_gibs_queue","50",true,false,"Queue may contain this many gibs")
		LiteGibs.CVars.LimbsEnabled = CreateClientConVar("cl_litegibs_fx_limbs_enabled","1",true,false,"Enable extra ragdolls to represent sliced parts")
		LiteGibs.CVars.FootstepsEnabled = CreateClientConVar("cl_litegibs_footsteps","0",true,false,"Enable footstep interaction with gibs")
		LiteGibs.CVars.DamageMultiplier = CreateClientConVar("cl_litegibs_damage_multiplier","1",true,false,"Multiply damage by this for purpose of calculating gibbing")
		LiteGibs.CVars.WoundsEnabled = CreateClientConVar("cl_litegibs_fx_wounds_enabled","1",true,false,"Enable stencil-based wound system")
		LiteGibs.CVars.WoundsLive = CreateClientConVar("cl_litegibs_fx_wounds_live","0",true,false,"Enable stencil-based wounds on alive characters")
		LiteGibs.CVars.WoundsLimit = CreateClientConVar("cl_litegibs_fx_wounds_limit","32",true,false,"Max number of wounds at once")
		LiteGibs.CVars.LiveDismember = CreateClientConVar("cl_litegibs_fx_dismember_live","0",true,false,"Allow for live dismemberment?")
	end
	LiteGibs.CVars.LiveDismemberGameplay = CreateReplConVar("sv_litegibs_dismember_live", "0", "Enable live dismemberment gameplay changes?")
end
if SERVER then
	LiteGibs.CVars.LiveDismemberGameplay = CreateReplConVar("sv_litegibs_dismember_live", "0", "Enable live dismemberment gameplay changes?")
end