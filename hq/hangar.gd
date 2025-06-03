extends Control

@onready var ship_grid = $HBoxContainer/GridContainer
@onready var buttons_container = $HBoxContainer/VBoxContainer
var selected_ship_module_type: ShipModule.Type
var hovered_cell = null

func _ready():
	ship_grid.columns = max(1, Saver.data.ship.width)
	create_ship_modules_buttons()
	if Saver.data.ship != null:
		draw_plane()


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
	for child in ship_grid.get_children():
		child.queue_free()
	for y in range(Saver.data.ship.height):
		for x in range(Saver.data.ship.width):
			var ship_module_type = Saver.data.ship.get_ship_module(x, y)
			var cell = ColorRect.new()
			if hovered_cell != null and hovered_cell == Vector2i(x, y):
				var base_color = ShipModule.get_color(selected_ship_module_type)
				base_color.a = 0.4
				cell.color = base_color
			else:
				cell.color = ShipModule.get_color(ship_module_type)

			cell.custom_minimum_size = Vector2(16, 16)
			cell.mouse_filter = Control.MOUSE_FILTER_PASS
			cell.connect("gui_input", Callable(self, "_on_cell_input").bind(x, y))
			ship_grid.add_child(cell)


func _on_cell_input(event: InputEvent, x: int, y: int):
	if event is InputEventMouseMotion:
		var new_hover = Vector2i(x, y)
		if new_hover != hovered_cell:
			hovered_cell = new_hover
			draw_plane()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_valid_placement(x, y, selected_ship_module_type):
				Saver.data.ship.set_ship_module(x, y, selected_ship_module_type)
			else:
				invalid_placement_highlight()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if is_valid_placement(x, y, ShipModule.Type.EMPTY):
				Saver.data.ship.set_ship_module(x, y, ShipModule.Type.EMPTY)
			else:
				invalid_placement_highlight()
		draw_plane()


func get_color_from_type(t: ShipModule.Type) -> Color:
	match t:
		"cockpit":
			return Color.DARK_GRAY
		"wing":
			return Color.CYAN
		"engine":
			return Color.ORANGE
		_:
			return Color.TRANSPARENT


func _on_grid_container_mouse_exited() -> void:
	hovered_cell = null
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
		var clicked_ship_module = Saver.data.ship.get_ship_module(x, y)
		if clicked_ship_module == ShipModule.Type.COCKPIT:
			return false
	return true


func check_in_bounds(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= Saver.data.ship.width or y >= Saver.data.ship.height:
		return false
	return true

func check_neighbours(x: int, y: int) -> bool:
	var dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	for d in dirs:
		var neighbor = Vector2i(x, y) + d
		var neighbor_type = Saver.data.ship.get_ship_module(neighbor.x, neighbor.y)
		if neighbor_type != ShipModule.Type.EMPTY:
			return true
	return false

func has_cockpit() -> bool:
	for y in range(Saver.data.ship.height):
		for x in range(Saver.data.ship.width):
			if Saver.data.ship.get_ship_module(x, y) == ShipModule.Type.COCKPIT:
				return true
	return false

func check_preserves_connectivity(x: int, y: int) -> bool:
	var width = Saver.data.ship.width
	var height = Saver.data.ship.height

	# Clone actuel du vaisseau
	var grid = []
	for j in range(height):
		grid.append([])
		for i in range(width):
			grid[j].append(Saver.data.ship.get_ship_module(i, j))

	# Suppression virtuelle
	grid[y][x] = ShipModule.Type.EMPTY

	# Trouver un module de départ
	var visited = {}
	var start: Vector2i = Vector2i(-1, -1)
	for j in range(height):
		for i in range(width):
			if grid[j][i] != ShipModule.Type.EMPTY:
				start = Vector2i(i, j)
				break
		if start.x != -1:
			break

	# Si plus aucun module : ok
	if start.x == -1:
		return true

	# BFS pour vérifier la connectivité
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
	pass
	#var tween = create_tween()
	#tween.tween_property(, "outline_color", Color.DARK_RED, 0.2)
		
