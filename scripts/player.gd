extends CharacterBody2D

@export var laser_cooldown:float = 5
@export var score_boost:float = 0

const BASE_SPEED = 500.0

const MARGIN_X = 50.0;
const MARGIN_Y = 70.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0; # = ProjectSettings.get_setting("physics/2d/default_gravity")
const rocket = preload("res://scenes/rocket.tscn")  #caches scene on load 

# @onready var spawner = get_node("RocketSpawner") #no need to put inside _ready() then
func _ready():
	$LaserCooldown.wait_time = laser_cooldown / 10
	
func _physics_process(delta):	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var vertical_direction = Input.get_axis("ui_up", "ui_down")
	var horizontal_direction = Input.get_axis( "ui_left", "ui_right")
	if vertical_direction:
		velocity.y = vertical_direction * (BASE_SPEED + score_boost)
	else:
		velocity.y = 0 #move_toward(0,velocity.y, SPEED) #momentum
	
	if horizontal_direction:
		velocity.x = horizontal_direction * (BASE_SPEED + score_boost)
	else:
		velocity.x = 0 
	#actually causes player to move
	move_and_slide()
	print(score_boost)
	
	# clamp to screen viewport with margins
	var screen_size = get_viewport_rect().size
	# global_position.x = clampf(global_position.x, MARGIN_X, screen_size.x - MARGIN_X)
	# global_position.y = clampf(global_position.y, MARGIN_Y, screen_size.y - MARGIN_Y)

	# you can also use CLAMPF
	# clampf(100,5, 16) would return 16
	# clampf(3,5,16) would return 5
	# clampf(9,5,16) would return 9
	
	global_position = global_position.clamp(Vector2(MARGIN_X,MARGIN_Y), Vector2(screen_size.x - MARGIN_X, screen_size.y - MARGIN_Y) )
	
func _process(delta):
	# Handle shooting
	if Input.is_action_just_pressed("ui_shoot") and $LaserCooldown.is_stopped():
		shoot()
		$LaserCooldown.start()
		
func shoot():
	var instance = rocket.instantiate()
	instance.rocket_fired.connect(_on_rocket_fired)
	# you can use get_node("RocketSpawner") or $RocketSpawner (Shorthand)
	# all nodes have a .name property
	# second parameter of add child makes the instanced names more readable
	$RocketSpawner.add_child(instance, true) #RocketSpawner is a Node which has no transform
	# instance.z_index = -1
	instance.global_position = global_position

func _on_rocket_fired():
	$LaserFX.play()

func take_damage():
	pass
