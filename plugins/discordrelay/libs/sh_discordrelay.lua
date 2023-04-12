ix.discordrelay = ix.discordrelay or {}

function ix.discordrelay.RelayChatToDiscord(name, text)
    local name = name or "Unknown"
    local text = text or "Unintelligible"
	local avatar_url = "https://pbs.twimg.com/media/EwxnD5ZXMAMEqxw.jpg"
	HTTP({
		//url = ix.config.Get("webUrl"),
		url = "https://whgoxy.d2a.io/call/json/199943527143178240/faeca938-93b3-4c71-9dd1-ebd5bf2e9111/9_yuzn__DdnUuCDuVrQvh4hMuZaSHd7D7xEu7Vsf7uBAbQ4Hn_VcamPegw-uh8rN",
		method = "POST",
		body = util.TableToJSON({
			content = text,
			username = name,
			avatar_url = avatar_url,
		}),
		headers = {
			['Content-Type'] = 'application/json',
			['accept'] = '*/*'
		},
		type = "application/json; charset=utf-8",
		success = function (code, body, headers) 
		end,
		failed = function( err ) print("RELAY ERROR:",err) end
	})
end


