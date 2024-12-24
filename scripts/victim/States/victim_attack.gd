extends State
class_name VictimAttack

@onready var model_animation: AnimationPlayer = $"../../Punching-skeleton/ModelAnimation"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"

const attack_range:float = 2.5

func Enter():
	player = get_node(player_path)


func Update(delta: float):
	pass


func Physics_update(delta: float):
	pass
