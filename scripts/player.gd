extends CharacterBody3D


var TURN_SPEED = 180
const SPEED = 2.5

var y_velo = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var move_dir = 0
	var turn_dir = 0
	if Input.is_action_pressed("forward"):
		move_dir -= 1
	if Input.is_action_pressed("backward"):
		move_dir += 1
	if Input.is_action_pressed("right"):
		turn_dir -= 1
	if Input.is_action_pressed("left"):
		turn_dir += 1
	
	rotation_degrees.y += turn_dir * TURN_SPEED * delta
	velocity = global_transform.basis.z * SPEED * move_dir
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		print("swing")
	
	
