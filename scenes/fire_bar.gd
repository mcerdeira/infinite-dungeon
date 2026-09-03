extends Node2D

@export var rotation_speed: float = 90.0 # degrees per second


func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
