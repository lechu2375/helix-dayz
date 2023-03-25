if SAM_LOADED then return end

local sam = sam
local istable, isstring = sam.istable, sam.isstring

local commands = {}
local arguments = {}

do
	local command = {}

	local current_category = "other"
	function command.set_category(category)
		if isstring(category) then
			current_category = category
		end
	end

	function command.get_commands()
		return commands
	end

	function command.get_command(name)
		for i = 1, #commands do
			local cmd = commands[i]
			if cmd.name == name then
				return cmd, i
			end

			local aliases = cmd.aliases
			for i2 = 1, #aliases do
				local alias = aliases[i2]
				if alias == name then
					return cmd, i
				end
			end
		end
		return false
	end

	function command.remove_command(name)
		local cmd, index = command.get_command(name)
		if index then
			table.remove(commands, index)
			hook.Call("SAM.CommandRemoved", nil, cmd.name, cmd, index)
			return index
		end
		return false
	end

	function command.get_arguments()
		return arguments
	end

	do
		local argument_methods = {
			OnExecute = function(self, func)
				if isfunction(func) and SERVER then
					self.on_execute = func
				end
				return self
			end,
			Menu = function(self, func)
				if isfunction(func) and CLIENT then
					self.menu = func
				end
				return self
			end,
			AutoComplete = function(self, func)
				if isfunction(func) and CLIENT then
					self.auto_complete = func
				end
				return self
			end,
			End = function(self)
				if SERVER then
					arguments[self.name] = self.on_execute
				else
					arguments[self.name] = self
				end
			end
		}

		local argument_meta = {__index = argument_methods}
		function command.new_argument(name)
			if isstring(name) then
				return setmetatable({name = name}, argument_meta)
			end
		end
	end

	if CLIENT then
		function command.run_commands(to_run)
			local time = 0
			for i = 1, #to_run do
				timer.Simple(time, function()
					RunConsoleCommand("sam", unpack(to_run[i]))
				end)
				time = time + 0.76
			end
		end
	end

	--
	-- Methods
	--
	local Command_Methods = {}
	local Command_meta = {__index = Command_Methods}

	function command.new(cmd)
		if not isstring(cmd) then return end

		local new_command = setmetatable({}, Command_meta)
		new_command.can_console_run = true
		new_command.args = {}
		new_command.name = cmd:lower()
		new_command.aliases = {}
		new_command.category = current_category

		return new_command
	end

	local AddMethod = function(name, func)
		Command_Methods[name] = func
	end

	AddMethod("Aliases", function(self, ...)
		for k, v in ipairs({...}) do
			table.insert(self.aliases, v)
		end
		return self
	end)

	AddMethod("AddArg", function(self, name, data)
		if not isstring(name) then return end
		if not istable(data) then
			data = {}
		end
		data.name = name
		table.insert(self.args, data)
		return self
	end)

	AddMethod("DisallowConsole", function(self, disallow)
		self.can_console_run = isbool(disallow) and disallow or false
		return self
	end)

	AddMethod("SetCategory", function(self, category)
		if isstring(category) then
			self.category = category
		end
		return self
	end)

	AddMethod("Help", function(self, help)
		if isstring(help) then
			self.help = sam.language.get(help) or help
		end
		return self
	end)

	AddMethod("OnExecute", function(self, func)
		if isfunction(func) and SERVER then
			self.on_execute = func
		end
		return self
	end)

	AddMethod("SetPermission", function(self, perm, default_rank)
		if isstring(perm) then
			self.permission = perm
			self.default_rank = default_rank
		end
		return self
	end)

	AddMethod("GetRestArgs", function(self, get)
		if not isbool(get) then
			get = true
		end
		self.get_rest_args = get
		return self
	end)

	AddMethod("MenuHide", function(self, should_hide)
		if isbool(should_hide) then
			self.menu_hide = should_hide
		else
			self.menu_hide = true
		end
		return self
	end)

	AddMethod("DisableNotify", function(self, disable)
		if isbool(disable) then
			self.disable_notify = disable
		else
			self.disable_notify = true
		end
		return self
	end)

	AddMethod("End", function(self)
		local name = self.name
		if SERVER and not self.on_execute then
			sam.print("need an OnExecute function for the command!")
			debug.Trace()
			return
		end

		if self.permission then
			sam.permissions.add(self.permission, "Commands - " .. self.category, self.default_rank)
		end

		local _, index = command.get_command(name)
		if index then
			commands[index] = self
			hook.Call("SAM.CommandModified", nil, name, self, index)
		else
			hook.Call("SAM.CommandAdded", nil, name, self, table.insert(commands, self))
		end
	end)

	AddMethod("GetRequiredArgs", function(self)
		local required_args = {}
		local args = self.args
		for i = 1, #args do
			local v = args[i]
			if not v.optional then
				table.insert(required_args, v)
			end
		end
		return required_args
	end)

	AddMethod("GetOptionalArgs", function(self)
		local optional_args = {}
		local args = self.args
		for i = 1, #args do
			local v = args[i]
			if v.optional then
				table.insert(optional_args, v)
			end
		end
		return optional_args
	end)

	AddMethod("ArgsToString", function(self, return_table)
		local str_table = {}
		local args = self.args
		for i = 1, #self.args do
			local v = args[i]
			if not v.optional then
				table.insert(str_table, "<" .. (v.hint or v.name) .. ">")
			else
				table.insert(str_table, "[" .. (v.hint or v.name) .. "]")
			end
		end
		return return_table and str_table or table.concat(str_table, " ")
	end)

	AddMethod("HasArg", function(self, arg)
		local args = self.args
		for i = 1, #self.args do
			if args[i].name == arg then
				return true
			end
		end
		return false
	end)

	command.add_method = AddMethod

	sam.command = command
end

sam.__commands = commands
sam.__arguments = arguments