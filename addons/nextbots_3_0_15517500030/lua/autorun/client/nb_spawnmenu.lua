local tabName  = "Nextbots 3.0"                -- change this to what you want the tab to be named
local tabIcon  = "icon16/nb_icon.png"                -- the icon image of the tab
local hookName = "PopulateSeanNextbots"   -- this is the hook that gets called to populate the tab, you can rename it to whatever

spawnmenu.AddContentType( "sean_nextbots", function( container, obj )
	if !obj.material then return end
	if !obj.nicename then return end
	if !obj.spawnname then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "sean_nextbots" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetColor( Color( 0, 0, 0, 255 ) )
	
	icon.DoClick = function()
		RunConsoleCommand( "nb_sean_spawn", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	
	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "Copy to Clipboard", function() 
				SetClipboardText( obj.spawnname ) 
			end)
			
			menu:AddSpacer()
	
			menu:AddOption( "Spawn Using Toolgun", function() 
				RunConsoleCommand( "gmod_tool", "creator" ) 
				RunConsoleCommand( "creator_type", "0" ) -- only 0 type will allow nextbots to be spawned..
				RunConsoleCommand( "creator_name", obj.spawnname ) 
			end)
			
		menu:Open()

	end
	
	if IsValid( container ) then
		container:Add( icon )
	end

	return icon

end )

spawnmenu.AddContentType( "sean_nextbot_weapons", function( container, obj )
	if !obj.material then return end
	if !obj.nicename then return end
	if !obj.spawnname then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "sean_nextbot_weapons" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetColor( Color( 0, 0, 0, 255 ) )
	
	icon.DoClick = function()
		RunConsoleCommand( "nb_sean_weapon", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	
	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "Copy to Clipboard", function() 
				SetClipboardText( obj.spawnname ) 
			end)

		menu:Open()

	end
	
	if IsValid( container ) then
		container:Add( icon )
	end

	return icon

end )

hook.Add( hookName, "AddEntityContent", function( contentPanel, tree, node )
    
	local Categorised = {}

	--NEXTBOTS
	local nextbots = list.Get( "sean_nextbots" )
	if nextbots then
		for k, v in pairs( nextbots ) do

			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.Class = k
			v.Name = v.Name
			table.insert( Categorised[ v.Category ], v )

		end
	end
	
	for CategoryName, v in SortedPairs( Categorised ) do

		local node = tree:AddNode( CategoryName, "icon16/bricks.png" )

		node.DoPopulate = function( self )

			if self.PropPanel then return end

			self.PropPanel = vgui.Create( "ContentContainer", contentPanel )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
				
				spawnmenu.CreateContentIcon( "sean_nextbots", self.PropPanel, {
					nicename	= ent.Name or ent.Class,
					spawnname	= ent.Class,
					material	= "entities/"..ent.Class..".png",
					admin		= ent.AdminOnly
				} )
				
			end
			
		end

		node.DoClick = function( self )
			
			self:DoPopulate()
			contentPanel:SwitchPanel( self.PropPanel )
			
		end

	end
	
end )

hook.Add( "PopulateGay", "AddWeaponContent", function( contentPanel, tree, node )
    
	-- Loop through the weapons and add them to the menu
	local Weapons = list.Get( "sean_nextbot_weapons" )
	local Categorised = {}

	-- Build into categories
	if Weapons then
		for k, v in pairs( Weapons ) do

			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.Class = k
			v.Name = v.Name
			table.insert( Categorised[ v.Category ], v )

		end
	end

	-- Loop through each category
	for CategoryName, v in SortedPairs( Categorised ) do

		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, "icon16/gun.png" )

		-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )

			-- If we've already populated it - forget it.
			if ( self.PropPanel ) then return end

			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", contentPanel )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )

			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do

				spawnmenu.CreateContentIcon( "sean_nextbot_weapons", self.PropPanel, {
					nicename	= ent.Name or ent.Class,
					spawnname	= ent.Class,
					material	= "entities/" .. ent.Class .. ".png",
					admin		= ent.AdminOnly
				} )

			end

		end

		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )

			self:DoPopulate()
			contentPanel:SwitchPanel( self.PropPanel )

		end

	end
	
end )

spawnmenu.AddCreationTab( tabName, function()

    local ctrl = vgui.Create( "SpawnmenuContentPanel" )
    ctrl:CallPopulateHook( hookName )
	ctrl:CallPopulateHook( "PopulateGay" )
	
    return ctrl

end, tabIcon, 20 )