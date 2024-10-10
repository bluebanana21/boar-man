extends CharacterBody3D

@onready var raycast = $RayCast3D
@onready var anim_play = $AnimationPlayer
@onready var axe_weapon: Node3D = $"metarig/Skeleton3D/BoneAttachment3D/axe-weapon"

var TURN_SPEED:int = 180
const SPEED:float = 2.5

var axe_damage:int = 100

var y_velo:float = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	axe_weapon.visible = false

#movement code, needs improvement
func _physics_process(delta):
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
	var turn_str = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	rotation_degrees.y += turn_dir * TURN_SPEED * turn_str * delta
	velocity = global_transform.basis.z * SPEED * move_str * move_dir
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		AxeSwing()


func AxeSwing():
	if raycast.is_colliding() and raycast.get_collider().has_method("damage"):
		raycast.get_collider().damage()
