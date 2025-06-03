class_name Enemy extends Node2D

@export var hp = 10
@export var max_hp = 10
@export var damage = 5
@export var money = 1000

var ais
var weapons
var weapon_slot
var shape: Shape

signal shoot(projectile, direction, location)
signal enemy_destroyed(enemy)


func _ready():
	shape = find_children('', 'Shape')[0]
	ais = find_children('', 'AI')
	weapons = find_children('', 'Weapon')
	weapon_slot = find_children('WeaponSlot')[0]
	
	for weapon in weapons:
		weapon.position = weapon_slot.position
	
func _process(delta):
	for ai in ais:
		ai.compute(delta, self)

func _on_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.is_in_group("Player"):
		if "damage" in area:
			hp -= area.damage
		if hp <= 0:
			queue_free()
			enemy_destroyed.emit(self)
		
		if area.is_in_group("Projectile"):
			area.queue_free()

func _on_weapon_shoot(projectile, direction, location):
	shoot.emit(projectile, direction, location)
