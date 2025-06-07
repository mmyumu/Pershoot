class_name Data extends Resource

# @export var character_name: String = ""
@export var last_saved: Datetime = Datetime.new()
#@export var ship: Ship = Ship.new()
@export var ship_dict := {}

var _cached_ship: Ship = null  # interne

# propriété ship "virtuelle"
var ship:
	get:
		if _cached_ship == null:
			_cached_ship = Ship.new()
			_cached_ship.from_dict(ship_dict)
		return _cached_ship
	set(value):
		_cached_ship = value
		ship_dict = value.to_dict()

func manual_initialize():
	ship = Ship.new()
	ship.manual_initialize()

func get_data_name():
	# Return here the progress of the game which (or anythinog describing the best the game)
	return "New game"
