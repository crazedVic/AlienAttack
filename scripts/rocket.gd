extends Area2D

@export var speed:float = 6.0
@onready var visibleOnScreenNotifier = $VisibleOnScreenNotifier2D

signal rocket_fired

# Called when the node enters the scene tree for the first time.
func _ready():
	#manually connecting signal to function instead of connecting in Node Signals Tab
	visibleOnScreenNotifier.connect("screen_exited", _on_screen_exited)
	rocket_fired.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	global_position.x += speed * delta * 100;

func _on_screen_exited():
	queue_free()
