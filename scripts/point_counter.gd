extends Label

@onready var point_counter: Label = $"."

var points: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_counter.text = str(points)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func increase_points() -> void:
	point_counter.text = str(points)
