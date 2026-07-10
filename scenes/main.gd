extends Node2D
var map_room_obj = preload("res://scenes/map_room.tscn")
var center = null

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		visible = !visible
		if visible:
			generate_dungeon()
			$camera.global_position = center.global_position
		else:
			destroy_dungeon()
	
	if Input.is_action_pressed("left"):
		$camera.position.x -= 500 * delta
	elif Input.is_action_pressed("right"):
		$camera.position.x += 500 * delta
	elif Input.is_action_pressed("up"):
		$camera.position.y -= 500 * delta
	elif Input.is_action_pressed("down"):
		$camera.position.y += 500 * delta
	
func destroy_dungeon():
	var rooms = get_tree().get_nodes_in_group("maproom")
	for r in rooms:
		r.queue_free()
	
func generate_dungeon():
	for x in range(1000):
		for y in range(1000):
			if Global.rooms_array[x][y] != -1:
				var map_room = map_room_obj.instantiate()
				map_room.global_position = Vector2(x * 32, y * 32)
				map_room.set_room(Global.rooms_array[x][y])
				map_room.player_here(false)
				if Global.player_posision == Vector2(x, y):
					center = map_room
					map_room.player_here(true)
					
				add_child(map_room)
