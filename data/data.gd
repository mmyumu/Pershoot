class_name Data extends Resource

# @export var character_name: String = ""
@export var last_saved: Datetime = Datetime.new()
@export var ship: Ship = Ship.new()

func get_data_name():
	# Return here the progress of the game which (or anythinog describing the best the game)
	return "New game"
