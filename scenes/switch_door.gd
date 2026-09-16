extends StaticBody2D

## Drag every "switch" node that should unlock this door into this array in
## the inspector. The door opens once all of them have been touched.
@export var switches: Array[NodePath] = []

var spark_obj = preload("res://scenes/spark.tscn")
var remaining = 0


func _ready() -> void:
	add_to_group("switch_doors")
	remaining = switches.size()
	for path in switches:
		var s = get_node_or_null(path)
		if s:
			s.activated.connect(_on_switch_activated)


func _on_switch_activated() -> void:
	remaining -= 1
	if remaining <= 0:
		open()


func open() -> void:
	$collider.set_deferred("disabled", true)
	visible = false

	for offset_y in [-32, 0, 32]:
		var spark = spark_obj.instantiate()
		spark.global_position = global_position + Vector2(0, offset_y)
		get_parent().add_child(spark)

	queue_free()
