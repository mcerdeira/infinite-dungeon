extends Node2D
var ttl = 2.3

func _ready() -> void:
	$particles.emitting = true
	$particles2.emitting = true
	$particles.one_shot = true
	$particles2.one_shot = true

func _physics_process(delta: float) -> void:
	ttl -= 1 * delta
	if ttl <= 0:
		queue_free()
