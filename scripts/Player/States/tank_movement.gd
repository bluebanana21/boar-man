extends State
class_name TankMovement

@export var player: CharacterBody3D

var turn_speed:int = 180
const speed:float = 2.5

var y_velo:float = 0

func Enter():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func Update(delta:float):
	pass

func Physics_update(delta:float):
	var move_dir = 0
	var turn_dir = 0
	
	if Input.is_action_pressed("forward"):
		move_dir -= 1
	if Input.is_action_pressed("backward"):
		move_dir -= 1
	if Input.is_action_pressed("right"):
		turn_dir -= 1
	if Input.is_action_pressed("left"):
		turn_dir -= 1
	
	var move_str:float = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var turn_str:float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	player.rotation_degrees.y += turn_dir * turn_speed * turn_str * delta
	rotation_degrees.y += turn_dir * turn_speed * turn_str * delta
	player.velocity = global_transform.basis.z * speed * move_str * move_dir
	
	player.move_and_slide()
