extends State
class_name VictimIdle

@export var victim:CharacterBody3D
@export var move_speed: float = 10.0
@export var rotation_speed : float = TAU * 2

var _theta : float
var move_direction : Vector3
var wander_time:float

func randomize_wander():
	move_direction = Vector3(randf_range(-1, 1), 0.0, randf_range(-1, 1)).normalized()
	wander_time = randf_range(1,3)

# Called when the node enters the scene tree for the first time.
func Enter():
	randomize_wander()


func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()


func Physics_update(delta: float):
	if victim:
		victim.velocity = move_direction * move_speed
	
	if move_direction:
		_theta = wrapf(atan2(move_direction.x, move_direction.z) - victim.rotation.y, -PI, PI)
		victim.rotation.y += clamp(rotation_speed * delta, 0, abs(_theta)) * sign(_theta)
	
	victim.move_and_slide()