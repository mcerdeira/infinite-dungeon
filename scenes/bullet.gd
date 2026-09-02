extends Area2D
var spark_obj = preload("res://scenes/spark.tscn")
var done = false
@export var speed: float = 900.0
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var shake_last = 5
var shake_dir = 1
var room_bellong = null
var has_enemy = false
var enemy = null
var nograv_ttl = 0.3
var homing_target = null
var homing_turn_rate = deg_to_rad(240.0)
var homing_search_radius = 500.0

func _ready():
	add_to_group("arrows")
	if Global.HOMING:
		$sprite.animation = "homing"
		
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
	
func unstuck(_new_parent):
	var t = global_transform
	reparent(_new_parent)
	global_transform = t
	enemy = null
	done = false
	has_enemy = false
	velocity = Vector2.ZERO

func explode(die):
	if visible:
		if die:
			$TimerShake.start()
			done = true
			$Timer.stop()
		var spark = spark_obj.instantiate()
		spark.global_position = global_position
		get_parent().add_child(spark)

func find_homing_target():
	var closest = null
	var closest_dist = homing_search_radius
	for e in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(e):
			var dist = global_position.distance_to(e.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest = e
	return closest

func _physics_process(delta):
	if visible:
		if !done:
			nograv_ttl -= 1 * delta
			var homing = false
			if Global.HOMING:
				if homing_target == null or !is_instance_valid(homing_target):
					homing_target = find_homing_target()
				if homing_target != null:
					homing = true
					var desired_angle = (homing_target.global_position - global_position).angle()
					var new_angle = rotate_toward(velocity.angle(), desired_angle, homing_turn_rate * delta)
					velocity = Vector2.from_angle(new_angle) * velocity.length()
			if !homing and nograv_ttl <= 0:
				velocity.y += gravity * delta
			position += velocity * delta
			rotation = velocity.angle()
		else:
			if has_enemy:
				if enemy == null or !is_instance_valid(enemy):
					enemy = null
					done = false
					has_enemy = false
					velocity = Vector2.ZERO

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if visible and !done:
		if body and body.is_in_group("enemies"):
			if !has_enemy:
				var t = global_transform
				enemy = body
				reparent(body)
				global_transform = t
				has_enemy = true
				body.hit()
				explode(true)
				if body.life <= 0:
					unstuck(get_parent())
				
		elif body is TileMapLayer:
			explode(true)

func _on_area_entered(area: Area2D) -> void:
	if visible and !done:
		if area and area.is_in_group("enemies") or area.is_in_group("hanginitem"):
			if !has_enemy:
				var hanginitem = area.is_in_group("hanginitem")
				if hanginitem:
					area.hit()
				else:
					var t = global_transform
					enemy = area
					reparent(area)
					global_transform = t
					has_enemy = true
					area.hit()
					explode(true)
					if area.life <= 0:
						unstuck(get_parent())
				
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
