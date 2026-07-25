extends StaticBody2D
var first = true

func _physics_process(delta: float) -> void:
	if first:
		first = false
		var enemies = get_tree().get_nodes_in_group("enemies")
		if enemies.size() <= 0:
			$Timer.start()

func open():
	$collider.set_deferred("disabled", true)
	$AnimationPlayer.play("new_animation")

func _on_timer_timeout() -> void:
	$Timer.stop()
	open()
