extends Node2D
var last_pos = null
enum Directions {
	NORTH,
	SOUTH,
	EAST,
	WEST
}
var directions = [Directions.NORTH, Directions.SOUTH, Directions.EAST, Directions.WEST]

func _ready() -> void:
	var room_obj = Global.get_random_room("FULL")
	var room = room_obj.instantiate()
	
	add_child(room)
	
	generate_dungeon()
	%UI.calc_arrows()
	
func select_random_dir(banned):
	while(true):
		var dir = Global.pick_random_rng(directions, Global.dungeon_rng)
		if dir != banned:
			if dir == Directions.SOUTH:
				last_pos += go_south()
			elif dir == Directions.WEST:
				last_pos += go_west()
			elif dir == Directions.EAST:
				last_pos += go_east()
			elif dir == Directions.NORTH:
				last_pos += go_north()
			return
	
func generate_dungeon():
	Global.rooms_array = []
	Global.rooms_array.resize(1000)
	Global.rooms_objs_array = []
	Global.rooms_objs_array.resize(1000)
	
	for x in range(1000):
		Global.rooms_array[x] = []
		Global.rooms_array[x].resize(1000)
		Global.rooms_objs_array[x] = []
		Global.rooms_objs_array[x].resize(1000)
		for y in range(1000):
			Global.rooms_array[x][y] = -1
			Global.rooms_objs_array[x][y] = -1
	
	var amount_V = 0
	var amount_H = 0
	var vertical_dugeon = false
	if Global.dungeon_rng.randi() % 2 == 0:
		amount_V = 10
		amount_H = 50
		vertical_dugeon = false
	else:
		vertical_dugeon = true
		amount_V = 50
		amount_H = 10
	
	var count = 0
	var direction = null
	#Primera room
	create_room(1, Global.map_center)
	
	#Vamos para el norte
	direction = Directions.NORTH
	count = Global.dungeon_rng.randi() % 2
	last_pos = reset_pos()
	for i in range(amount_V):
		if last_pos == Global.map_center:
			last_pos += go_north()
		else:
			if count <= 0:
				count = Global.dungeon_rng.randi() % 3
				select_random_dir(direction)
			else: 
				count -= 1
				last_pos += go_north()
		create_room(0, last_pos)
		
	#Vamos para el sur
	direction = Directions.SOUTH
	count = 2
	last_pos = reset_pos()
	for i in range(amount_V):
		if last_pos == Global.map_center:
			last_pos += go_south()
		else:
			if count <= 0:
				count = Global.dungeon_rng.randi() % 3
				select_random_dir(direction)
			else: 
				count -= 1
				last_pos += go_south()
		create_room(0, last_pos)
		
	#Vamos para el este
	direction = Directions.EAST
	count = 2
	last_pos = reset_pos()
	for i in range(amount_H):
		if last_pos == Global.map_center:
			last_pos += go_east()
		else:
			if count <= 0:
				count = Global.dungeon_rng.randi() % 2
				select_random_dir(direction)
			else: 
				count -= 1
				last_pos += go_east()
		create_room(0, last_pos)
		
	#Vamos para el oeste
	direction = Directions.WEST
	count = 2
	last_pos = reset_pos()
	for i in range(amount_H):
		if last_pos == Global.map_center:
			last_pos += go_west()
		else:
			if count <= 0:
				count = Global.dungeon_rng.randi() % 2
				select_random_dir(direction)
			else: 
				count -= 1
				last_pos += go_west()
		create_room(0, last_pos)
		
	var final_room = Vector2(0, 0)
	var dist = 0
	for x in range(1000):
		for y in range(1000):
			if Global.rooms_array[x][y] != -1:
				if dist <= Global.map_center.distance_to(Vector2(x, y)):
					dist = Global.map_center.distance_to(Vector2(x, y))
					final_room = Vector2(x, y)
		
	Global.rooms_array[final_room.x][final_room.y] = 2
		
func reset_pos():
	return Global.map_center

func go_north():
	return Vector2(0, -1)
	
func go_south():
	return Vector2(0, 1)
	
func go_west():
	return Vector2(-1, 0)
	
func go_east():
	return Vector2(1, 0)
	
func create_room(idx, pos):
	if Global.rooms_array[pos.x][pos.y] == -1:
		Global.rooms_array[pos.x][pos.y] = idx
