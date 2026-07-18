extends Area2D
var spark_obj = preload("res://scenes/spark.tscn")
var done = false
@export var speed: float = 900.0
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var shake_last = 5
var shake_dir = 1
var room_bellong = null

func _ready():
	add_to_group("arrows")
	room_bellong = Global.player_posision
	shake_dir = [1, -1].pick_random()
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
		rotation = velocity.angle()

func activate():
	visible = true

func deactivate():
	if done:
		visible = false
	else:
		Global.player_obj.arrow_catch()
		queue_free()

func setmy_scale(_scale):
	scale.x = _scale

func explode(die):
	if visible:
		if die:
			$TimerShake.start()
			done = true
			$Timer.stop()
		var spark = spark_obj.instantiate()
		spark.global_position = global_position
		get_parent().add_child(spark)

func _physics_process(delta):
	if visible:
		if !done:
			velocity.y += gravity * delta
			position += velocity * delta
			rotation = velocity.angle()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if visible:
		if body and body.is_in_group("enemies"):
			body.hit()
			explode(true)
		elif body is TileMapLayer:
			explode(true)

func _on_area_entered(area: Area2D) -> void:
	if visible:
		if area and area.is_in_group("enemies"):
			area.hit()
			explode(true)

func _on_timer_timeout() -> void:
	if visible:
		explode(false)

func _on_arrow_catch_body_entered(body: Node2D) -> void:
	if visible:
		if body and body.is_in_group("players"):
			body.arrow_catch()
			queue_free()

func _on_timer_shake_timeout() -> void:
	if visible:
		$sprite.rotation_degrees += shake_dir * [5, 10, 15].pick_random()
		shake_last -= 1
		shake_dir *= -1
		if shake_last <= 0:
			shake_last = 5
			$TimerShake.stop()
