extends TileMapLayer
var first = true
var doors = []
var open = false

func _ready() -> void:
	add_to_group("rooms")
	
func _physics_process(delta: float) -> void:	
	if first:
		if Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].cleared:
			var enemies = get_tree().get_nodes_in_group("enemies")
			for e in enemies:
				e.queue_free()
		
		doors = get_tree().get_nodes_in_group("doors")
		first = false
		var enemies = get_tree().get_nodes_in_group("enemies")
		if enemies.size() > 0:
			$Timer.start()
	else:
		if !open:
			var enemies = get_tree().get_nodes_in_group("enemies")
			if enemies.size() == 0:
				open = true
				$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.stop()
	for d in doors:
		if d and is_instance_valid(d):
			if open:
				Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].cleared = true
				d.open()
			else:
				d.close()
