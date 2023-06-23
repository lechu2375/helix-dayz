local function lgAddOption()

	local function lgOptionEffects(panel)
		--Here are whatever default categories you want.
		local lgOptionFX = {
			Options = {},
			CVars = {},
			MenuButton = "1",
			Folder = "LiteGibs"
		}

		lgOptionFX.Options["#preset.default"] = {
			cl_litegibs_enabled = "1",
			cl_litegibs_fx_blood_stream_enabled = "0",
			cl_litegibs_fx_blood_stream_time = "5",
			cl_litegibs_fx_blood_spray_enabled = "1",
			cl_litegibs_fx_blood_wep_enabled = "1",
			cl_litegibs_fx_blood_pool_enabled = "1",
			cl_litegibs_fx_blood_screen_enabled = "1",
			cl_litegibs_fx_gibs_enabled = "1",
			cl_litegibs_fx_gibs_time = "15",
			cl_litegibs_fx_gibs_blood = "0",
			cl_litegibs_fx_gibs_sound = "0",
			cl_litegibs_fx_limbs_enabled = "1",
			cl_litegibs_fx_wounds_enabled = "1",
			cl_litegibs_fx_wounds_live = "0",
			cl_litegibs_fx_wounds_limit = "16",
			cl_litegibs_footsteps = "0",
			cl_litegibs_damage_multiplier = "1",
			g_ragdoll_maxcount = "8"
		}

		lgOptionFX.Options["Ultra"] = {
			cl_litegibs_enabled = "1",
			cl_litegibs_fx_blood_stream_enabled = "1",
			cl_litegibs_fx_blood_stream_time = "5",
			cl_litegibs_fx_blood_spray_enabled = "1",
			cl_litegibs_fx_blood_wep_enabled = "1",
			cl_litegibs_fx_blood_pool_enabled = "1",
			cl_litegibs_fx_blood_screen_enabled = "1",
			cl_litegibs_fx_gibs_enabled = "1",
			cl_litegibs_fx_gibs_time = "15",
			cl_litegibs_fx_gibs_blood = "1",
			cl_litegibs_fx_gibs_sound = "1",
			cl_litegibs_fx_limbs_enabled = "1",
			cl_litegibs_fx_wounds_enabled = "1",
			cl_litegibs_fx_wounds_live = "1",
			cl_litegibs_fx_wounds_limit = "32",
			cl_litegibs_footsteps = "1",
			cl_litegibs_damage_multiplier = "1",
			g_ragdoll_maxcount = "16"
		}
		lgOptionFX.CVars = table.GetKeys(lgOptionFX.Options["#preset.default"])

		panel:AddControl("ComboBox", lgOptionFX)

		panel:AddControl("Button", {
			Label = "Setup Menu",
			Command = "litegibs_setup"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Mod Clientside",
			Command = "cl_litegibs_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Blood Streams",
			Command = "cl_litegibs_fx_blood_stream_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Blood Sprays",
			Command = "cl_litegibs_fx_blood_spray_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Blood Pools",
			Command = "cl_litegibs_fx_blood_pool_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable HUD Blood Splats",
			Command = "cl_litegibs_fx_blood_screen_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Weapon Blood Stains",
			Command = "cl_litegibs_fx_blood_wep_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Gib Models",
			Command = "cl_litegibs_fx_gibs_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Gib Sounds",
			Command = "cl_litegibs_fx_gibs_sound"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Gib Blood",
			Command = "cl_litegibs_fx_gibs_blood"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Footstep Gib Interaction",
			Command = "cl_litegibs_footsteps"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Limb Ragdolls",
			Command = "cl_litegibs_fx_limbs_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Wounds",
			Command = "cl_litegibs_fx_wounds_enabled"
		})

		panel:AddControl("CheckBox", {
			Label = "Enable Live Wounds",
			Command = "cl_litegibs_fx_wounds_live"
		})

		panel:AddControl("Slider", {
			Label = "Blood Stream Life",
			Command = "cl_litegibs_fx_blood_stream_time",
			Type = "Integer",
			Min = "0",
			Max = "10"
		})

		panel:AddControl("Slider", {
			Label = "Gib Model Life",
			Command = "cl_litegibs_fx_gibs_time",
			Type = "Integer",
			Min = "0",
			Max = "30"
		})

		panel:AddControl("Slider", {
			Label = "Damage Multiplier",
			Command = "cl_litegibs_damage_multiplier",
			Type = "Float",
			Min = "0",
			Max = "5"
		})

		panel:AddControl("Slider", {
			Label = "Ragdoll Limit",
			Command = "g_ragdoll_maxcount",
			Type = "Integer",
			Min = "0",
			Max = "64"
		})

		panel:AddControl("Slider", {
			Label = "Wound Limit",
			Command = "cl_litegibs_fx_wounds_limit",
			Type = "Integer",
			Min = "0",
			Max = "256"
		})
	end
	spawnmenu.AddToolMenuOption("Options", "LiteGibs Options", "liteGibsOptions", "Effects", "", "", lgOptionEffects)
end

hook.Add("PopulateToolMenu", "litegibsAddOptions", lgAddOption)