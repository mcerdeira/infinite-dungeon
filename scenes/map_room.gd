extends Node2D

func _ready() -> void:
	add_to_group("maproom")

func set_room(idx):
	$sprite.frame = idx
