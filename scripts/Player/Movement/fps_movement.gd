extends State
class_name FPSMovement

@onready var head: Node3D = $"../../Head"
@onready var phantom_cam: PhantomCamera3D = $"../../Head/PhantomCamera3D"
@onready var raycast: RayCast3D = $"../../RayCast3D"

@export var player: CharacterBody3D
@export var mouse_sens: float = 0.5
@export var speed: float = 5.0

var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO


func Enter()->void:
	phantom_cam.set_priority(20)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func Update(delta: float):
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		
		var head_pitch = head.rotation_degrees.x
		head_pitch = clamp(head_pitch, -60, 60)  
		head.rotation_degrees.x = head_pitch
		
		phantom_cam.rotation.x = head.rotation.x
	
	if event.is_action_pressed("attack"):
		AxeSwing()

func Physics_update(delta: float):
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	var camera_basis := player.global_transform.basis
	var forward_dir = camera_basis.z.normalized()
	var right_dir = camera_basis.x.normalized()
	
	direction = lerp(direction, (right_dir * input_dir.x + forward_dir * input_dir.y).normalized(), delta*lerp_speed)
	
	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
		
	else :
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0, speed)
	
	player.move_and_slide()


func AxeSwing():
	print("attacked")
	if raycast.is_colliding() and raycast.get_collider().has_method("damage"):
		raycast.get_collider().damage()
