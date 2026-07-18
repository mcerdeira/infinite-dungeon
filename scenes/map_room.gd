extends Node2D
var my_idx = -1

func _ready() -> void:
	add_to_group("maproom")
	
func player_here(val):
	$player.visible = val
	
func set_extra(idx):
	$extra.frame = idx
	$extra.visible = true

func set_room(idx, positional = false):
	my_idx = idx
	$sprite.frame = idx
