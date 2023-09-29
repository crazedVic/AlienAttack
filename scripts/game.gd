extends Node2D

# using a manual timer but you can also use a Timer node
var timer:float = 0;
@export var interval_sec:float = 1.7
@export var spawn_gap_px:float = 100;

var random = RandomNumberGenerator.new()
var spawn_points_on_y = []

const enemy = preload("res://scenes/enemy.tscn")  #caches scene on load 

func _ready():
	# spawn at the first one
	spawn_points_on_y = get_spawn_points()
	_spawn_enemy()
	timer = randf_range( 0.0,1.0)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# comment below out to disable the programmatic timer
	# timer += delta
	if timer > interval_sec:
		#spawn enemy
		_spawn_enemy()
		#reset Timer
		timer = randf_range( 0.0,1.1)
		
func _spawn_enemy():
	var instance = enemy.instantiate()
	$EnemySpawner.add_child(instance, true) #RocketSpawner is a Node which has no transform
	instance.enemy_destroyed.connect(_on_enemy_death)
	random.randomize()
	# could use an array of spawn points at specific intervals.
	var rand_y:int = randi() % spawn_points_on_y.size()
	# or use pick_random() on array (see next line of code)
	# could use any point between top and bottom of screen also
	#var n = random.randi_range(60, get_viewport_rect().size.y - 60)
	#instance.global_position = \
	#	Vector2(get_viewport_rect().size.x,spawn_points_on_y.pick_random())
	# challenge - prevent same spawn point back to back
	instance.global_position = \
		Vector2(get_viewport_rect().size.x,spawn_points_on_y[rand_y])
	spawn_points_on_y.remove_at(rand_y)
	if spawn_points_on_y.size() == 0:
		spawn_points_on_y = get_spawn_points()

func _on_timer_timeout():
	# using the Timer Node signal method
	_spawn_enemy()
	$EnemySpawner/Timer.set_wait_time(randf_range( 0.5,2.2))

func get_spawn_points():
	var total_points = (get_viewport_rect().size.y - spawn_gap_px)/spawn_gap_px
	var spawns = []
	for i in range(total_points):
		spawns.append((i+1) * spawn_gap_px)
	return spawns

func _on_enemy_death():
	$SFX/Explosion.play()
