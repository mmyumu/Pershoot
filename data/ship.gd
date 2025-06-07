class_name Ship extends Resource

@export var width := 15
@export var height := 15
var ship_modules := {}  # Clé = Vector2i(x, y), valeur = ShipModule.Type (type de module)

@export var cockpit_position := Vector2i(7, 7)

#func initialize_empty():
	#for y in range(height):
		#for x in range(width):
			#set_ship_module(x, y, ShipModule.Type.EMPTY)
	#set_ship_module(cockpit_position.x, cockpit_position.y, ShipModule.Type.COCKPIT)

func manual_initialize():
	for y in range(height):
		for x in range(width):
			set_ship_module(x, y, ShipModule.Type.EMPTY)
	add_cockpit()

func add_cockpit():
	set_ship_module(cockpit_position.x, cockpit_position.y, ShipModule.Type.COCKPIT)

func get_ship_module(x: int, y: int) -> ShipModule.Type:
	return ship_modules.get(Vector2i(x, y), ShipModule.Type.EMPTY)

func set_ship_module(x: int, y: int, type: ShipModule.Type) -> void:
	ship_modules[Vector2i(x, y)] = type

func clone() -> Ship:
	var cloned_ship = Ship.new()
	cloned_ship.width = width
	cloned_ship.height = height
	for y in range(height):
		for x in range(width):
			cloned_ship.set_ship_module(x, y, get_ship_module(x, y))
	
	return cloned_ship

func to_dict() -> Dictionary:
	var dict := {}
	for pos in ship_modules:
		dict["%s,%s" % [pos.x, pos.y]] = ship_modules[pos]
	return {
		"width": width,
		"height": height,
		"cockpit_position": cockpit_position,
		"ship_modules": dict,
	}

func from_dict(data: Dictionary):
	width = data.get("width", 15)
	height = data.get("height", 15)
	cockpit_position = data.get("cockpit_position", Vector2i(7, 7))
	ship_modules.clear()
	if data.has("ship_modules"):
		for key in data["ship_modules"]:
			var parts = key.split(",")
			var pos = Vector2i(parts[0].to_int(), parts[1].to_int())
			ship_modules[pos] = data["ship_modules"][key]
