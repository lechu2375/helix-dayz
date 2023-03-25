if SAM_LOADED then return end

local sam, command = sam, sam.command

command.new_argument("dropdown")
    :OnExecute(function(arg, input, ply, _, result)
        if not arg.options or table.Empty(arg.options) then
            ply:sam_send_message("no data", {S = "dropdown", S_2 = input})
            return
        end

        table.insert(result, input)
    end)
    :Menu(function(set_result, body, buttons, arg)
        local default = arg.hint or "select"

        local cbo = buttons:Add("SAM.ComboBox")
        cbo:SetValue(default)
		cbo:SetTall(25)

        function cbo:OnSelect(_, value)
            set_result(value)
            default = value
        end

        function cbo:DoClick()
            if self:IsMenuOpen() then
                return self:CloseMenu()
            end

            self:Clear()
            self:SetValue(default)

            if not arg.options then
                LocalPlayer():sam_send_message("dropdown has no options data")
                return
            end

            for k, v in pairs(arg.options) do
                self:AddChoice(v)
            end

            self:OpenMenu()
        end

        return cbo
    end)
:End()