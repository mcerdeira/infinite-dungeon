extends Node2D
var my_idx = -1

func _ready() -> void:
	add_to_group("maproom")
	
func player_here(val):
	$player.visible = val

func set_room(idx):
	my_idx = idx
	$sprite.frame = idx
