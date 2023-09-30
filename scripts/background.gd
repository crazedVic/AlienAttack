extends ParallaxBackground

@export var scroll_speed:float = 100

@onready var sprite = $ParallaxLayer/Sprite2D

func _process(delta):
	sprite.region_rect.position += delta * Vector2(scroll_speed, 0)
