extends Node2D
const blood = preload("res://scenes/blood.tscn")

func _ready() -> void:
	var count = [10, 25, 20, 25]
	rain(count.pick_random())

func rain(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		blood_instance.blood_type = "flask_liquid"
		get_parent().call_deferred("add_child", blood_instance)
