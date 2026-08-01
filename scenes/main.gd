extends Node2D
var map_room_obj = preload("res://scenes/map_room.tscn")
var center = null

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if Global.HASMAP:
		if Input.is_action_just_pressed("map"):
			visible = !visible
			if visible:
				$camera.global_position = center.global_position
		
		if Input.is_action_pressed("leftM"):
			$camera.position.x -= 500 * delta
		elif Input.is_action_pressed("rightM"):
			$camera.position.x += 500 * delta
		elif Input.is_action_pressed("upM"):
			$camera.position.y -= 500 * delta
		elif Input.is_action_pressed("downM"):
			$camera.position.y += 500 * delta
	
func destroy_dungeon():
	var rooms = get_tree().get_nodes_in_group("maproom")
	for r in rooms:
		r.queue_free()
		
func something_in_pos(x, y):
	if Global.rooms_array[x][y] == -1:
		return false
	else:
		return true
	
func generate_dungeon():
	for x in range(1000):
		for y in range(1000):
			if Global.rooms_array[x][y] != -1:
				var map_room = map_room_obj.instantiate()
				map_room.coordinates = Vector2(x, y)
				map_room.global_position = Vector2(x * 32, y * 32)
				var extra = 0
				if Global.rooms_array[x][y] != -1:
					if Global.rooms_array[x][y] == 1 or Global.rooms_array[x][y] == 2:
						extra = Global.rooms_array[x][y]
					#Buscar si hay algo abajo
					var down = something_in_pos(x, y + 1)
					#Buscar si hay algo arriba
					var up = something_in_pos(x, y - 1)
					#Buscar si hay algo derecha
					var right = something_in_pos(x + 1, y)
					#Buscar si hay algo a la izquierda
					var left = something_in_pos(x - 1, y)
					var room_n = 0
					
					if right and left and up and down:
						room_n = 1
					elif left and down and right:
						room_n = 4
					elif left and up and down:
						room_n = 7
					elif left and up and right:
						room_n = 8
					elif right and up and down:
						room_n = 12
					elif left and down:
						room_n = 3
					elif left and right:
						room_n = 5
					elif left and up:
						room_n = 6
					elif right and down:
						room_n = 10
					elif right and up:
						room_n = 11
					elif down:
						room_n = 0
					elif left:
						room_n = 2
					elif right:
						room_n = 9
					elif up:
						room_n = 13
					elif up and down:
						room_n = 14
					
					if Global.player_posision == Vector2(x, y):
						Global.rooms_objs_array[x][y] = Global.hardcoded_inicial_room
					else:
						Global.rooms_objs_array[x][y] = Global.get_random_room(room_n)
					
					Global.rooms_array[x][y] = room_n
					map_room.set_room(room_n, true)
					
				if extra != 0:
					map_room.set_extra(extra)
				
				if Global.player_posision == Vector2(x, y):
					center = map_room
					
				add_child(map_room)
