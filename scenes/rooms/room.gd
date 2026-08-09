extends TileMapLayer
var first = true
var doors = []
var open = false
var item_obj = load("res://scenes/hanginitem.tscn")

func _ready() -> void:
	add_to_group("rooms")
	
func set_item(id):
	var itm = item_obj.instantiate()
	itm.wich_item = id
	itm.global_position = Vector2($Item1.global_position.x, $Item1.global_position.y + 120)
	add_child(itm)
	
func set_item2(id):
	var itm = item_obj.instantiate()
	itm.wich_item = id
	itm.global_position = Vector2($Item2.global_position.x, $Item2.global_position.y + 120)
	add_child(itm)
	
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
