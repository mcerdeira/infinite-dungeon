extends Node2D
var map_room_obj = preload("res://scenes/map_room.tscn")
var map_center = Vector2(1152 / 2, 648 / 2)
var last_pos = null
var rooms = []
enum Directions {
	NORTH,
	SOUTH,
	EAST,
	WEST
}
var directions = [Directions.NORTH, Directions.SOUTH, Directions.EAST, Directions.WEST]

func _ready() -> void:
	generate_dungeon()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		$camera.position.x -= 500 * delta
	elif Input.is_action_pressed("right"):
		$camera.position.x += 500 * delta
	elif Input.is_action_pressed("up"):
		$camera.position.y -= 500 * delta
	elif Input.is_action_pressed("down"):
		$camera.position.y += 500 * delta
	
func select_random_dir(banned):
	while(true):
		var dir = directions.pick_random()
		if dir != banned:
			if dir == Directions.SOUTH:
				go_south()
			elif dir == Directions.WEST:
				go_west()
			elif dir == Directions.EAST:
				go_east()
			elif dir == Directions.NORTH:
				go_north()
			return
	
func generate_dungeon():
	var amount_V = 0
	var amount_H = 0
	var final_room_placed = false
	var vertical_dugeon = false
	randomize()
	if randi() % 2 == 0:
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
	create_room(1, map_center)
	
	#Vamos para el norte
	direction = Directions.NORTH
	count = randi() % 2
	reset_pos()
	for i in range(amount_V):
		if last_pos == map_center:
			go_north()
		else:
			if count <= 0:
				count = randi() % 3
				select_random_dir(direction)
			else: 
				count -= 1
				go_north()
		create_room(0, last_pos)
		
	#Vamos para el sur
	direction = Directions.SOUTH
	count = 2
	reset_pos()
	for i in range(amount_V):
		if last_pos == map_center:
			go_south()
		else:
			if count <= 0:
				count = randi() % 3
				select_random_dir(direction)
			else: 
				count -= 1
				go_south()
		create_room(0, last_pos)
		
	#Vamos para el este
	direction = Directions.EAST
	count = 2
	reset_pos()
	for i in range(amount_H):
		if last_pos == map_center:
			go_east()
		else:
			if count <= 0:
				count = randi() % 2
				select_random_dir(direction)
			else: 
				count -= 1
				go_east()
		create_room(0, last_pos)
		
	#Vamos para el oeste
	direction = Directions.WEST
	count = 2
	reset_pos()
	for i in range(amount_H):
		if last_pos == map_center:
			go_west()
		else:
			if count <= 0:
				count = randi() % 2
				select_random_dir(direction)
			else: 
				count -= 1
				go_west()
		create_room(0, last_pos)
		
	var rooms_o = get_tree().get_nodes_in_group("maproom")
	var dist = 0
	var final_room = null
	for r in rooms_o:
		if dist < map_center.distance_to(r.global_position):
			final_room = r
			dist = map_center.distance_to(r.global_position)
			
	final_room.set_room(2)
		
func reset_pos():
	last_pos = map_center

func go_north():
	last_pos += Vector2(0, -32)
	
func go_south():
	last_pos += Vector2(0, 32)
	
func go_west():
	last_pos += Vector2(-32, 0)
	
func go_east():
	last_pos += Vector2(32, 0)
	
func create_room(idx, pos):
	if rooms.find(pos) == -1:
		rooms.append(pos)
		var room = map_room_obj.instantiate()
		room.set_room(idx)
		room.global_position = pos
		add_child(room)
