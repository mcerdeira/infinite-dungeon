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
	Global.MainGame = self
	generate_dungeon()
	%Map.generate_dungeon()
	%UI.calc_arrows()
	%UI.calc_flask()
	switch_room()
	
func navigate_dugeon(player_postition):
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	
	if player_postition.x > width:
		Global.player_posision.x += 1
		Global.player_obj.global_position.x = 0
	elif player_postition.x < 0:
		Global.player_posision.x -= 1
		Global.player_obj.global_position.x = width
	elif player_postition.y > height:
		Global.player_posision.y += 1
		Global.player_obj.global_position.y = 0
	elif player_postition.y < 16:
		Global.player_posision.y -= 1
		Global.player_obj.global_position.y = height
	
	switch_room()
		
func switch_room():
	reset_player_position()
	var obj = Global.rooms_objs_array[Global.player_posision.x][Global.player_posision.y] 
	Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].visited = true
	gen_room(obj)
	
func reset_player_position():
	var rooms = get_tree().get_nodes_in_group("maproom")
	for r in rooms:
		if Global.player_posision == r.coordinates:
			r.player_here(true)
			r.set_visited()
		else:
			r.player_here(false)
			
	var bloods_o = get_tree().get_nodes_in_group("bloods")
	for b in bloods_o:
		b.kill()
	%Surface.clear_blood()
	
func gen_room(room_obj):
	var items = get_tree().get_nodes_in_group("items")
	for a in items:
		a.deactivate()
		
	for a in items:
		if a.room_bellong != null and a.room_bellong == Global.player_posision:
			a.activate()
	
	var arrows = get_tree().get_nodes_in_group("arrows")
	for a in arrows:
		a.deactivate()
		
	for a in arrows:
		if a.room_bellong != null and a.room_bellong == Global.player_posision:
			a.activate()
	
	#Eliminar Rooms si existieran
	var rooms = get_tree().get_nodes_in_group("rooms")
	for r in rooms:
		r.queue_free()
	
	#Crear y posicionar la room
	var room = room_obj.instantiate()
	
	#Items importantes
	if Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].map:
		room.set_item("map")
	elif Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].radar:
		room.set_item("radar")
	elif Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].double_jump:
		room.set_item("double_jump")
	
	#Items secundarios
	if Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].custom != "":
		var item2 = Global.rooms_metadata_array[Global.player_posision.x][Global.player_posision.y].custom
		room.set_item2(item2)
		
	add_child(room)
	
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
			
			
func get_random_room(radius = 50):
	var center = Global.map_center
	var candidates = []
	for x in range(1000):
		for y in range(1000):
			if Global.rooms_array[x][y] == 0:
				if Vector2(x, y).distance_to(center) < radius:
					candidates.append([x, y])
					
	return candidates
	
func generate_dungeon():
	Global.rooms_array = []
	Global.rooms_array.resize(1000)
	Global.rooms_objs_array = []
	Global.rooms_objs_array.resize(1000)
	Global.rooms_metadata_array = []
	Global.rooms_metadata_array.resize(1000)

	for x in range(1000):
		Global.rooms_array[x] = []
		Global.rooms_array[x].resize(1000)
		Global.rooms_objs_array[x] = []
		Global.rooms_objs_array[x].resize(1000)
		Global.rooms_metadata_array[x] = []
		Global.rooms_metadata_array[x].resize(1000)
		for y in range(1000):
			Global.rooms_array[x][y] = -1
			Global.rooms_objs_array[x][y] = null
			Global.rooms_metadata_array[x][y] = {
				"visited": false,
				"cleared": false,
				"map": false,
				"double_jump": false,
				"radar": false,
				"items": [],
				"custom": "",
			}
	
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
	
	#Definir donde van los items importantes
	var close_rooms = get_random_room(3)
	var important_items = Global.pick_random_rng_cant(3, close_rooms, Global.dungeon_rng)
	var map = close_rooms[important_items[0]]
	var double_jump = close_rooms[important_items[1]]
	var radar = close_rooms[important_items[2]]
	
	Global.rooms_metadata_array[map[0]][map[1]].map = true
	Global.rooms_metadata_array[double_jump[0]][double_jump[1]].double_jump = true
	Global.rooms_metadata_array[radar[0]][radar[1]].radar = true
	
	#Definir donde van los items secundarios
	var items_rooms = get_random_room(50)
	var second_items = Global.pick_random_rng_cant(int(items_rooms.size() / 2), items_rooms, Global.dungeon_rng)
	
	for sec in second_items:
		var pos = items_rooms[sec]
		var items = ["arrows", "bomb", "fly", "homing", "life"]
		Global.rooms_metadata_array[pos[0]][pos[1]].custom = Global.pick_random_rng(items, Global.dungeon_rng)
		
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
