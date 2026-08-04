extends Node2D
var time = 0.0
var float_speed = 2.0
var float_amplitude = 6.0
@export var wich_item = "map"
@onready var ball = $Ball
@onready var line = $Chain
var detached = false
var ball_fake_position = Vector2.ZERO

func _ready() -> void:
	add_to_group("hanginitem")
	
func _process(delta):
	time += delta
	if detached:
		ball_fake_position.x = sin(time * float_speed) * float_amplitude
		line.set_point_position(1, ball_fake_position)
	else:
		ball.position.x = sin(time * float_speed) * float_amplitude
		ball_fake_position = ball.position
		line.set_point_position(1, ball.position)

func _on_ball_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if visible:
		if body is TileMapLayer:
			$Ball.breakme(wich_item)
