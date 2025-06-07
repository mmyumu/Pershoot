extends Control

@onready var ship_grid = $VBoxContainer/HBoxContainer/GridContainer
@onready var buttons_container = $VBoxContainer/HBoxContainer/VBoxContainer
var selected_ship_module_type: ShipModule.Type
var hovered_cell = null
var focused_ship_module = null
var grid_buttons: Array = []
var ship: Ship = null

func _ready():
	#print("🏁 Hangar ready")
	#print("Script instance:", self)
	#print("Ship instance in Saver:", Saver.data.ship)
	#print("Is save button valid?", $VBoxContainer/HBoxContainer2/SaveButton != null)
	#print("Connecting SaveButton manually")
	#$VBoxContainer/HBoxContainer2/SaveButton.pressed.connect(func(): print("✅ Save button clicked"))
	
	ship = Saver.data.ship.clone()
	
	ship_grid.columns = max(1, ship.width)
	create_grid_buttons()
	create_ship_modules_buttons()
	
	#print("Save button:", $VBoxContainer/HBoxContainer2/SaveButton)
	#print("Cancel button:", $VBoxContainer/HBoxContainer2/CancelButton)
	
	draw_plane()
	buttons_container.get_child(0).grab_focus()

func create_grid_buttons():
	grid_buttons.clear()
	for y in range(ship.height):
		var row: Array = []
		for x in range(ship.width):
			var btn = Button.new()
			btn.focus_mode = Control.FOCUS_ALL
			btn.custom_minimum_size = Vector2(16, 16)
			btn.text = ""
			
			var style = StyleBoxFlat.new()
			style.bg_color = Color(1, 1, 1, 1)

			btn.add_theme_stylebox_override("normal", style)
			btn.add_theme_stylebox_override("pressed", style)

			var style_hover = StyleBoxFlat.new()
			style_hover.bg_color = Color(1, 1, 1, 1)
			style_hover.border_width_bottom = 1
			style_hover.border_width_top = 1
			style_hover.border_width_left = 1
			style_hover.border_width_right = 1
			style_hover.border_color = Color.DARK_ORANGE
			btn.add_theme_stylebox_override("hover", style_hover)
			btn.add_theme_stylebox_override("focus", style_hover)
			
			btn.connect("gui_input", func(event): _on_cell_input(event, x, y))
			btn.connect("focus_exited", func(): hovered_cell = null; draw_plane())
			btn.connect("focus_entered", func(): hovered_cell = Vector2i(x, y); draw_plane())
			btn.connect("mouse_exited", func(): hovered_cell = null; draw_plane())
			btn.connect("mouse_entered", func(): hovered_cell = Vector2i(x, y); draw_plane())
			
			ship_grid.add_child(btn)
			row.append(btn)
		grid_buttons.append(row)


func create_ship_modules_buttons():
	for key in ShipModule.Type.keys():
		var btn = Button.new()
		btn.text = key.capitalize()
		btn.custom_minimum_size = Vector2(80, 24)
		btn.connect("pressed", func(): select_module(ShipModule.Type[key]))
		buttons_container.add_child(btn)


func select_module(ship_module_type: int):
	selected_ship_module_type = ship_module_type


func draw_plane():
	var focused_position = null
	for y in range(ship.height):
		for x in range(ship.width):
			var ship_module_type = ship.get_ship_module(x, y)
			var btn = grid_buttons[y][x]

			if hovered_cell == Vector2i(x, y) and ship_module_type == ShipModule.Type.EMPTY:
				var ghost_color = ShipModule.get_color(selected_ship_module_type)
				ghost_color.a = 0.4
				btn.modulate = ghost_color
			else:
				btn.modulate = ShipModule.get_color(ship_module_type)

func _on_cell_input(event: InputEvent, x: int, y: int):
	if event is InputEventMouseMotion:
		var new_hover = Vector2i(x, y)
		if new_hover != hovered_cell:
			hovered_cell = new_hover
			draw_plane()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_valid_placement(x, y, selected_ship_module_type):
				ship.set_ship_module(x, y, selected_ship_module_type)
			else:
				invalid_placement_highlight()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if is_valid_placement(x, y, ShipModule.Type.EMPTY):
				ship.set_ship_module(x, y, ShipModule.Type.EMPTY)
			else:
				invalid_placement_highlight()
	elif event.is_action_pressed("ui_accept"):
		if is_valid_placement(x, y, selected_ship_module_type):
			ship.set_ship_module(x, y, selected_ship_module_type)
		else:
			invalid_placement_highlight()
	elif event.is_action_pressed("ui_cancel"):
		if is_valid_placement(x, y, ShipModule.Type.EMPTY):
			ship.set_ship_module(x, y, ShipModule.Type.EMPTY)
		else:
			invalid_placement_highlight()
		draw_plane()

func is_valid_placement(x: int, y: int, ship_module_type: ShipModule.Type) -> bool:
	if ship_module_type == ShipModule.Type.EMPTY:
		return check_cockpit(x, y, ship_module_type) \
			&& check_in_bounds(x, y) \
			&& check_preserves_connectivity(x, y)
	else:
		return check_cockpit(x, y, ship_module_type) \
			&& check_in_bounds(x, y) \
			&& check_neighbours(x, y)

func check_cockpit(x: int, y: int, ship_module_type: ShipModule.Type) -> bool:
	if ship_module_type == ShipModule.Type.COCKPIT:
		return not has_cockpit()
	elif ship_module_type == ShipModule.Type.EMPTY:
		var clicked_ship_module = ship.get_ship_module(x, y)
		if clicked_ship_module == ShipModule.Type.COCKPIT:
			return false
	return true

func check_in_bounds(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= ship.width or y >= ship.height:
		return false
	return true

func check_neighbours(x: int, y: int) -> bool:
	var dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	for d in dirs:
		var neighbor = Vector2i(x, y) + d
		var neighbor_type = ship.get_ship_module(neighbor.x, neighbor.y)
		if neighbor_type != ShipModule.Type.EMPTY:
			return true
	return false

func has_cockpit() -> bool:
	for y in range(ship.height):
		for x in range(ship.width):
			if ship.get_ship_module(x, y) == ShipModule.Type.COCKPIT:
				return true
	return false

func check_preserves_connectivity(x: int, y: int) -> bool:
	var width = ship.width
	var height = ship.height

	# Clone of actual ship
	var grid = []
	for j in range(height):
		grid.append([])
		for i in range(width):
			grid[j].append(ship.get_ship_module(i, j))

	# Virtual removal
	grid[y][x] = ShipModule.Type.EMPTY

	# Find starting module
	var visited = {}
	var start: Vector2i = Vector2i(-1, -1)
	for j in range(height):
		for i in range(width):
			if grid[j][i] != ShipModule.Type.EMPTY:
				start = Vector2i(i, j)
				break
		if start.x != -1:
			break

	# If no  ship module anymore : ok
	if start.x == -1:
		return true

	# BFS to check connectivity
	var queue = [start]
	visited[start] = true
	var count = 1

	while queue.size() > 0:
		var current = queue.pop_front()
		for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var neighbor = current + dir
			if neighbor.x >= 0 and neighbor.y >= 0 and neighbor.x < width and neighbor.y < height:
				if grid[neighbor.y][neighbor.x] != ShipModule.Type.EMPTY and not visited.has(neighbor):
					visited[neighbor] = true
					queue.append(neighbor)
					count += 1

	# Nombre total de modules non-vides
	var total_modules = 0
	for row in grid:
		for val in row:
			if val != ShipModule.Type.EMPTY:
				total_modules += 1

	return count == total_modules

func invalid_placement_highlight():
	print("invalid")
	pass
	#var tween = create_tween()
	#tween.tween_property(, "outline_color", Color.DARK_RED, 0.2)


func _on_save_button_pressed() -> void:
	Saver.data.ship = ship
	Saver.save_data()
	get_tree().change_scene_to_file("res://hq/main.tscn")



func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://hq/main.tscn")


func _on_test_button_pressed() -> void:
	print("TEST CLIC")
