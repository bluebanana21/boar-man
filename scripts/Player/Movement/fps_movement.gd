extends State
class_name FPSMovement

@onready var head: Node3D = $"../../Head"
@onready var phantom_cam: PhantomCamera3D = $"../../Head/PhantomCamera3D"
@onready var raycast: RayCast3D = $"../../RayCast3D"

@export var player_char: CharacterBody3D
@export var mouse_sens: float = 0.5
@export var speed: float = 5.0

var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

#sets the FPS phantom cam as priority and captures the mouse
func Enter()->void:
	phantom_cam.set_priority(20)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func Update(delta: float):
	pass

#checks any input from player
func _input(event: InputEvent) -> void:
#Camera rotation based on mouse
	if event is InputEventMouseMotion:
		player_char.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		
		var head_pitch = head.rotation_degrees.x
		head_pitch = clamp(head_pitch, -60, 60)  
		head.rotation_degrees.x = head_pitch
		
		phantom_cam.rotation.x = head.rotation.x
	
#Attack input
	if event.is_action_pressed("attack"):
		AxeSwing()

func Physics_update(delta: float):
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	var camera_basis := player_char.global_transform.basis
	var forward_dir = camera_basis.z.normalized()
	var right_dir = camera_basis.x.normalized()
	
	direction = lerp(direction, (right_dir * input_dir.x + forward_dir * input_dir.y).normalized(), delta*lerp_speed)
	
	if direction != Vector3.ZERO:
		player_char.velocity.x = direction.x * speed
		player_char.velocity.z = direction.z * speed
		
	else :
		player_char.velocity.x = move_toward(player_char.velocity.x, 0, speed)
		player_char.velocity.z = move_toward(player_char.velocity.z, 0, speed)
	
	player_char.move_and_slide()


#the attack func
func AxeSwing():
	print("attacked")
	if raycast.is_colliding() and raycast.get_collider().has_method("damage"):
		raycast.get_collider().damage()


#func for player damage, make hit instakill
func hit():
	print("player got hit")
