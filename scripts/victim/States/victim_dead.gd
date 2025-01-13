extends VictimState
class_name VictimDead

signal in_death_state

@export var victim:CharacterBody3D

func Enter():
	in_death_state.emit()
	victim.velocity = Vector3.ZERO
	pass


func Update(delta: float):
	pass


func Physics_update(delta: float):
	pass
