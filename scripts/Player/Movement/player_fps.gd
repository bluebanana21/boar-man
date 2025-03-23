extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var attac_raycast: RayCast3D = $AttackRay
@onready var collision_box: CollisionShape3D = $CollisionShape3D
@onready var y_collision_ray: RayCast3D = $YCollisionRay
@onready var dodge_timer: Timer = $DodgeTimer

@export var fall_acceleration:int = 75
@export var mouse_sens: float = 0.5
@export var speed: float = 5.0
@export var dodge_force: float = 5.0
@export var dodge_dist: float = 0.2

var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO
var is_dodging: bool = false
var check_vert_collison: bool = false

#sets the FPS phantom cam as priority and captures the mouse
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _process(delta: float) -> void:
	pass

#checks any input from player
func _input(event: InputEvent) -> void:
#Camera rotation based on mouse
	if !is_dodging:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			
			var head_pitch = head.rotation_degrees.x
			head_pitch = clamp(head_pitch, -60, 60)  
			head.rotation_degrees.x = head_pitch
			
			camera_3d.rotation.x = head.rotation.x
	
#Attack input
	if event.is_action_pressed("attack"):
		AxeSwing()
	
#	Doedge roll
	if event.is_action_pressed("dodge") and !is_dodging:
		dodge()


func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var facing_direction := -global_transform.basis.z.normalized()

	var camera_basis := global_transform.basis
	var forward_dir := camera_basis.z.normalized()
	var right_dir := camera_basis.x.normalized()
	var camera_direction := forward_dir + right_dir
	camera_direction.y = 0.0
	#camera_direction = camera_direction.normalized()
	
	if !is_dodging:
		direction = lerp(direction, (right_dir * input_dir.x + forward_dir * input_dir.y).normalized(), delta*lerp_speed)
	print("Facing Direction: ", facing_direction)
	print("Facing Direction z: ", facing_direction.z)
	
	if direction.is_equal_approx(Vector3.ZERO):
		direction = Vector3.ZERO
	print(direction)
	
	if direction != Vector3.ZERO:
		if is_dodging:
			velocity.x = direction.x * (speed * dodge_force)
			velocity.z = direction.z * (speed * dodge_force)
		else:
			#print("currently moving")
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else :
		if is_dodging:
			
			position.x += facing_direction.x
			position.z += facing_direction.z
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - (fall_acceleration * delta)
	
	
	if check_vert_collison:
		if !y_collision_ray.is_colliding():
			collision_box.scale.y = lerp(collision_box.scale.y, collision_box.scale.y*2, 1)
			check_vert_collison = false
			is_dodging = false
			
	
	move_and_slide()


#the attack func
func AxeSwing()->void:
	print("attacked")
	if attac_raycast.is_colliding() and attac_raycast.get_collider().has_method("damage"):
		attac_raycast.get_collider().damage()


#func for player damage, make hit instakill
func hit()->void:
	print("player got hit")


func dodge()->void:
	print("player dodged")
	is_dodging = true
	collision_box.scale.y = lerp(collision_box.scale.y, collision_box.scale.y/2, 1)
	dodge_timer.start()


func _on_dodge_timer_timeout() -> void:
	check_vert_collison = true
