extends VictimState
class_name VictimDead

@export var victim:CharacterBody3D

func Enter():
	victim.velocity = Vector3.ZERO
	pass


func Update(delta: float):
	pass


func Physics_update(delta: float):
	pass
