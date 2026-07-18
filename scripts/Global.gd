extends Node
var MainGame = null
var hardcoded_inicial_room = load("res://scenes/rooms/room_initial.tscn")
var map_center = Vector2(500, 500)
var player_posision = map_center #Posicion segun coordenadas del jugador
var global_player_position = Vector2.ZERO #Posicion real del jugador
var rooms_array = [] #Tipo de habitación según id
var rooms_objs_array = [] #Objeto randomizado de habitacion de la carpeta correspondiente
var player_obj = self
var GAMEOVER = false
var shaker_obj = null
var ARROWS_MAX = 5
var ARROWS = ARROWS_MAX
var dungeon_rng := RandomNumberGenerator.new()
var DUNGEON_SEED = -1

func _ready() -> void:
	randomize()
	DUNGEON_SEED = randi() % 99999999
	dungeon_rng.seed = hash(DUNGEON_SEED)
	
func pick_random_rng(array: Array, rng: RandomNumberGenerator):
	if array.is_empty():
		return null
	return array[rng.randi_range(0, array.size() - 1)]
	
func foldername_by_id(folder_id):
	var name = ""
	if folder_id == 0:
		name = "DOWN"
	elif folder_id == 1:
		name = "FULL"
	elif folder_id == 2:
		name = "LEFT"
	elif folder_id == 3:
		name = "LEFT_DOWN"
	elif folder_id == 4:
		name = "LEFT_DOWN_RIGHT"
	elif folder_id == 5:
		name = "LEFT_RIGHT"
	elif folder_id == 6:
		name = "LEFT_UP"
	elif folder_id == 7:
		name = "LEFT_UP_DOWN"
	elif folder_id == 8:
		name = "LEFT_UP_RIGHT"
	elif folder_id == 9:
		name = "RIGHT"
	elif folder_id == 10:
		name = "RIGHT_DOWN"
	elif folder_id == 11:
		name = "RIGHT_UP"
	elif folder_id == 12:
		name = "RIGHT_UP_DOWN"
	elif folder_id == 13:
		name = "UP"
	elif folder_id == 14:
		name = "UP_DOWN"
		
	#TODO: Quitar
	name = "FULL"
		
	return name

func get_random_room(folder_id) -> PackedScene:
	var folder = foldername_by_id(folder_id)
	var path = "res://scenes/rooms/" + folder
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No existe la carpeta: " + path)
		return null

	var files := []
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break

		if !dir.current_is_dir() and file.ends_with(".tscn"):
			files.append(file)

	dir.list_dir_end()
	if files.is_empty():
		push_error("No hay escenas en " + path)
		return null
		
	return load(path + "/" + files.pick_random())
