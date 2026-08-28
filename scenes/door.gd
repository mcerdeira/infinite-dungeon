extends Area2D

@export var bounce_direction := Vector2.LEFT
@export var bounce_force := 700.0
var particles_splash_obj = load("res://scenes/particles_splash.tscn")


func _ready() -> void:
	add_to_group("doors")
	visible = false
	$collider.set_deferred("disabled", true)


func close() -> void:
	visible = true
	$collider.set_deferred("disabled", false)


func open() -> void:
	visible = false
	$collider.set_deferred("disabled", true)
	
func splash(rotation, pos, sca, mini = false):
	var splash = particles_splash_obj.instantiate()
	add_child(splash)

	splash.global_position = pos
	splash.mini = mini
	splash.scale.x = splash.scale.x * sca
	splash.rotation_degrees = rotation
	splash._emit()
	
func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		var direction = bounce_direction.normalized()
		body.bouncer()
		body.velocity = direction * bounce_force
		
		if bounce_direction == Vector2.LEFT:
			splash(0, Vector2(body.global_position.x, body.global_position.y -32), -1)
		elif bounce_direction == Vector2.RIGHT:
			splash(0, Vector2(body.global_position.x, body.global_position.y -32), 1)
		elif bounce_direction == Vector2.DOWN:
			splash(0, body.global_position, 1)
		elif bounce_direction == Vector2.UP:
			splash(180, body.global_position, 1)


func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("arrows"):
		var direction = bounce_direction.normalized()
		area.velocity = direction * bounce_force
		
		if bounce_direction == Vector2.LEFT:
			splash(0, area.global_position, -1, true)
		elif bounce_direction == Vector2.RIGHT:
			splash(0, area.global_position, 1, true)
		elif bounce_direction == Vector2.DOWN:
			splash(0, area.global_position, 1, true)
		elif bounce_direction == Vector2.UP:
			splash(180, area.global_position, 1, true)
