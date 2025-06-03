extends ParallaxBackground

@export var speed = 800.0
@export var direction = Vector2.DOWN
@export var texture: Texture


func _ready():
	pass

func _process(delta):
	scroll_base_offset += (speed * direction) * delta

func set_texture(texture_to_be_set: Texture):
	$ParallaxLayer/Sprite2D.set_texture(texture_to_be_set)
