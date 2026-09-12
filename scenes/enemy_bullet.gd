extends Area2D
var spark_obj = preload("res://scenes/spark.tscn")
var done = false
var dmg = 1
@export var is_mario_fire = false
var spr : AnimatedSprite2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO
var source_enemy: Node = null
var parried = false
const PARRY_SPEED_MULT = 1.5

func _ready() -> void:
	add_to_group("enemy_bullet")
	spr = $sprite

func setmy_scale(_scale):
	scale.x = _scale

func parry():
	if parried or direction == Vector2.ZERO:
		return
	parried = true
	remove_from_group("enemy_bullet")
	if is_instance_valid(source_enemy):
		direction = (source_enemy.global_position - global_position).normalized()
	else:
		direction = -direction
	speed *= PARRY_SPEED_MULT
	modulate = Color(0.5, 1.4, 0.6)

func explode(die):
	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)
	if die and !is_mario_fire:
		queue_free()

func _physics_process(delta):
	spr.rotation_degrees += 10 * delta
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
		if !done:
			done = true
			explode(false)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		explode(true)

func _on_body_entered(body: Node2D) -> void:
	if body == null:
		return
	if parried:
		if body.is_in_group("enemies") and body.has_method("hit"):
			body.hit()
			explode(true)
	elif body.is_in_group("players"):
		body.hit(dmg)
		explode(true)

func _on_area_entered(area: Area2D) -> void:
	if parried and area and area.is_in_group("enemies") and area.has_method("hit"):
		area.hit(dmg)
		explode(true)
