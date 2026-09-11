extends StaticBody2D
var spark_obj = preload("res://scenes/spark.tscn")
var life = 1
var melee_shake_intensity = 4.0
var melee_shake_duration = 0.1

func _ready() -> void:
	add_to_group("destructibles")

func hit():
	if life > 0:
		life -= 1
		if life <= 0:
			die()

func hit_melee():
	Global.shaker_obj.shake(melee_shake_intensity, melee_shake_duration)
	hit()

func die():
	for child in get_children():
		if child.is_in_group("arrows"):
			child.unstuck(get_parent())
	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)
	queue_free()
