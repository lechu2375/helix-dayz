PLUGIN.name = "Player Connected"
PLUGIN.author = "Cyumus"
PLUGIN.desc = "A plugin that shows a message in the chat wether a player has connected to the server or disconnected from it."

function PLUGIN:PlayerConnect(client, ip)
	for _,v in pairs(player.GetAll()) do
		v:ChatPrint(client.." dołączył na serwer.")
	end
end