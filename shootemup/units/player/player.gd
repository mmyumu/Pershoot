extends Area2D

@export var speed = 400
@export var hp = 100
@export var max_hp = 100
@export var damage = 10

var money = 0
var invulnerable = false

signal shoot(projectile, direction, location)
signal player_hit(damage)
signal game_over()


func _ready():
	draw_ship(Saver.data.ship)

func _process(delta):
	var velocity: Vector2 = Vector2.ZERO
	var v_x = Input.get_axis("move_left", "move_right")
	var v_y = Input.get_axis("move_up", "move_down")

	velocity.x += v_x
	velocity.y += v_y

	velocity = velocity.limit_length(1.0)

	if velocity.length() > 0:
		velocity *= speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, GlobalVariables.screen_size)

func _on_turret_shoot(projectile, direction, location):
	shoot.emit(projectile, direction, location)

func _on_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if invulnerable:
		return
	if area.is_in_group("Enemies"):
		if "damage" in area:
			hp -= area.damage
			player_hit.emit(area.damage)
		if hp <= 0:
			game_over.emit()

func draw_ship(ship: Ship) -> void:
	# Supprimer les anciens modules affichés (nommés "drawn_x_y")
	for child in get_children():
		if child.name.begins_with("drawn_"):
			child.queue_free()

	# Constante pour la taille d'un "pixel" (module)
	var tile_size := 16
	var offset := Vector2(-ship.width / 2.0 * tile_size, -ship.height / 2.0 * tile_size)

	for y in range(ship.height):
		for x in range(ship.width):
			var module_type = ship.get_ship_module(x, y)
			if module_type == ShipModule.Type.EMPTY:
				continue

			var color := ShipModule.get_color(module_type)

			var rect := ColorRect.new()
			rect.color = color
			rect.size = Vector2(tile_size, tile_size)
			rect.position = Vector2(x, y) * tile_size + offset
			rect.name = "drawn_%d_%d" % [x, y]
			add_child(rect)
