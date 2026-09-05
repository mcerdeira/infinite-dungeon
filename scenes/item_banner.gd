extends Control

enum State { ENTERING, PAUSED, EXITING }

var speed = 700.0
var pause_duration = 2.1
var pause_timer = 0.0
var state = State.ENTERING
var center_x = 0.0

func set_title(title: String) -> void:
	$Label.text = title

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	position.y = (viewport_size.y - size.y) / 2.0
	position.x = -size.x
	center_x = (viewport_size.x - size.x) / 2.0

func _process(delta: float) -> void:
	match state:
		State.ENTERING:
			position.x += speed * delta
			if position.x >= center_x:
				position.x = center_x
				state = State.PAUSED
				pause_timer = pause_duration
		State.PAUSED:
			pause_timer -= delta
			if pause_timer <= 0.0:
				state = State.EXITING
		State.EXITING:
			position.x += speed * delta
			if position.x > get_viewport_rect().size.x:
				queue_free()
