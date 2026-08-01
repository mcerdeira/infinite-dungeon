extends Area2D
var base_y = 0.0
var time = 0.0
var float_speed = 2.0
var float_amplitude = 6.0

func _ready() -> void:
	add_to_group("items")
	base_y = global_position.y

func _physics_process(delta: float) -> void:
	time += delta
	global_position.y = base_y + sin(time * float_speed) * float_amplitude
