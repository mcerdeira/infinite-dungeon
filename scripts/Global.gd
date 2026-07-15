extends Node
var map_center = Vector2(500, 500)
var player_posision = map_center
var rooms_array = []
var rooms_objs_array = []
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

func get_random_room(folder:String) -> PackedScene:
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
