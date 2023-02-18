
ITEM.name = "Latarka"
ITEM.model = Model("models/raviool/flashlight.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Stara lecz wciąż działająca latarka"
ITEM.category = "Użytkowe"

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)
