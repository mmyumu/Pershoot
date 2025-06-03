extends Node

var slots: Array[String] = []
var current_file_name: String = "user://saves/save_debug.res"
var root_folder: String = "user://saves/"

var data: Data

func _init():
	DirAccess.make_dir_absolute(root_folder)
	slots = [
		root_folder + "save0.res",
		root_folder + "save1.res",
		root_folder + "save2.res"
	]
	data = Data.new()

func get_number_of_slots():
	return len(slots)

func set_slot(index):
	if index >= 0 and index < len(slots):
		current_file_name = slots[index]

func save_data():
	if data and current_file_name:
		data.last_saved = Datetime.new()
		save_data_to_filename(data, current_file_name)

func load_data():
	if current_file_name:
		print("load data from %s" % current_file_name)
		data = get_data_from_filename(current_file_name)

func reset_data():
	data = Data.new()

func get_data(index) -> Data:
	if index >= 0 and index < len(slots):
		return get_data_from_filename(slots[index])
	return null

func erase_data(index):
	if index >= 0 and index < len(slots):
		var dir = DirAccess.open(root_folder)
		print("Trying to remove %s" % slots[index])
		if dir and dir.file_exists(slots[index]):
			dir.remove(slots[index])
			print("%s removed" % slots[index])

func save_data_to_filename(data_to_save, filename):
	print("Saving data to %s" % filename)
	var result = ResourceSaver.save(data_to_save, filename)
	assert(result == OK)

func get_data_from_filename(file_name):
	if FileAccess.file_exists(file_name) and ResourceLoader.exists(file_name):
		print("Loading data from %s" % file_name)
		var loaded_data = ResourceLoader.load(file_name)
		if loaded_data is Data:
			return loaded_data
	return null
