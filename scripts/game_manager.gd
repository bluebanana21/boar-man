extends Node

@onready var point_counter: Label = $CanvasLayer/PointCounter

var score:int = 0

func add_point():
	score += 100
	point_counter.text = str(score)
