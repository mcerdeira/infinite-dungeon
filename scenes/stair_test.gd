extends Area2D
@export var parent : CharacterBody2D = null 

func _process(_delta):
	var areas = get_overlapping_areas()
	for a in areas:
		if a.is_in_group("stairs"):
			parent.is_on_stairs = true
			return
			
	parent.is_on_stairs = false
	parent.grabbed = false
