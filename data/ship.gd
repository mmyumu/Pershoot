class_name Ship extends Resource

@export var width := 15
@export var height := 15
var ship_modules := {}  # Clé = Vector2i(x, y), valeur = ShipModule.Type (type de module)

@export var cockpit_position := Vector2i(7, 7)

func _init():
	set_ship_module(7, 7, ShipModule.Type.COCKPIT)


func get_ship_module(x: int, y: int) -> ShipModule.Type:
	return ship_modules.get(Vector2i(x, y), ShipModule.Type.EMPTY)


func set_ship_module(x: int, y: int, type: ShipModule.Type) -> void:
	ship_modules[Vector2i(x, y)] = type
