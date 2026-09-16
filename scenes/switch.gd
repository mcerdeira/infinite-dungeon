extends Area2D

signal activated

var spark_obj = preload("res://scenes/spark.tscn")
var triggered = false


func _ready() -> void:
	add_to_group("switches")


func trigger() -> void:
	if triggered:
		return
	triggered = true
	$collider.set_deferred("disabled", true)

	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)

	activated.emit()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body and (body.is_in_group("players") or body.is_in_group("enemies")):
		trigger()


func _on_area_entered(area: Area2D) -> void:
	if area and (area.is_in_group("enemies") or area.is_in_group("arrows")):
		trigger()
