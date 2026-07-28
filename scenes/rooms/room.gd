extends TileMapLayer
var first = true
var doors = []

func _ready() -> void:
	add_to_group("rooms")
	
func _physics_process(delta: float) -> void:	
	if first:
		doors = get_tree().get_nodes_in_group("doors")
		first = false
		var enemies = get_tree().get_nodes_in_group("enemies")
		if enemies.size() + 1 > 0:
			$Timer.start()

func _on_timer_timeout() -> void:
	for d in doors:
		if d and is_instance_valid(d):
			d.close()
			$Timer.stop()
