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
	const TILE_SIZE := 16

	# Remove existing ship visuals
	if has_node("DrawnShip"):
		get_node("DrawnShip").queue_free()

	# Create container for visuals and hitboxes
	var drawn_root := Node2D.new()
	drawn_root.name = "DrawnShip"
	add_child(drawn_root)

	var offset := Vector2(-ship.width / 2.0 * TILE_SIZE, -ship.height / 2.0 * TILE_SIZE)

	# Create hitbox area and apply global offset
	var hitbox := Area2D.new()
	hitbox.name = "ShipHitbox"
	hitbox.position = offset
	hitbox.add_to_group("Player")
	drawn_root.add_child(hitbox)

	# Connect signal to damage handler
	hitbox.area_shape_entered.connect(_on_area_shape_entered.bind())

	for y in range(ship.height):
		for x in range(ship.width):
			var module_type := ship.get_ship_module(x, y)
			if module_type == ShipModule.Type.EMPTY:
				continue

			# Create visual tile
			var color := ShipModule.get_color(module_type)
			var module_rect := ColorRect.new()
			module_rect.color = color
			module_rect.size = Vector2(TILE_SIZE, TILE_SIZE)
			module_rect.position = Vector2(x, y) * TILE_SIZE + offset
			module_rect.name = "drawn_%d_%d" % [x, y]
			drawn_root.add_child(module_rect)

			# Create collision shape
			var shape := RectangleShape2D.new()
			shape.size = Vector2(TILE_SIZE, TILE_SIZE)

			var shape_node := CollisionShape2D.new()
			shape_node.shape = shape
			# Center the shape properly
			shape_node.position = Vector2(x, y) * TILE_SIZE + Vector2(TILE_SIZE, TILE_SIZE) / 2
			hitbox.add_child(shape_node)
