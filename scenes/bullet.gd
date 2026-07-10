extends Area2D
var spark_obj = preload("res://scenes/spark.tscn")
var done = false
@export var speed: float = 900.0
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready():
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
		rotation = velocity.angle()

func setmy_scale(_scale):
	scale.x = _scale

func explode(die):
	if die:
		done = true
		$Timer.stop()
	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)

func _physics_process(delta):
	if !done:
		velocity.y += gravity * delta
		position += velocity * delta
		rotation = velocity.angle()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body and body.is_in_group("enemies"):
		body.hit()
		explode(true)
	elif body is TileMapLayer:
		explode(true)

func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("enemies"):
		area.hit()
		explode(true)

func _on_timer_timeout() -> void:
	explode(false)
