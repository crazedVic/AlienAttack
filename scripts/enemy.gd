extends Area2D

@export var speed:float = 3;
@export var variance:float = 1.0;

var calculated_speed:float = 0;
signal enemy_destroyed
signal player_hit

func _ready():
	calculated_speed = speed + randf_range(-1.0 * variance, variance)

func _physics_process(delta):
	# moving to left
	global_position.x += calculated_speed * delta * -100;

func _on_area_entered(area):
	#if area.get_name() == "Rocket": # fails because instances have numbers on the end Rocket03
	if area.is_in_group("Rockets"):
		#need to emit a signal that the game.gd script is listening for
		enemy_destroyed.emit()
		area.queue_free()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_tree_exited():
	print("despawned")
	pass # Replace with function body.


func _on_body_entered(body):
	if body.get_name() == "Player":
		player_hit.emit()
		body.take_damage()
		queue_free()
		enemy_destroyed.emit()
