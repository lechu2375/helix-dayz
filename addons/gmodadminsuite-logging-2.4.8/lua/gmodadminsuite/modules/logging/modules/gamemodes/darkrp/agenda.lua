local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Agendas"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("agendaUpdated","agendaUpdated",function(ply,agenda,text)
		if (text == "" and ply == nil) then return end
		MODULE:LogPhrase("darkrp_agenda_updated", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(agenda.Title), GAS.Logging:Escape(text))
	end)
	MODULE:Hook("onAgendaRemoved","onAgendaRemoved",function(ply,agenda)
		MODULE:LogPhrase("darkrp_agenda_removed", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(agenda.Title))
	end)
end)

GAS.Logging:AddModule(MODULE)