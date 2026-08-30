extends Area2D
var inside = false
var goingint = false

func _physics_process(delta: float) -> void:
	if goingint:
		if $DoorBig.frame > 6:
			Global.shaker_obj.shake(2, 1)
	else:
		if Input.is_action_just_pressed("up"):
			if inside:
				goingint = true
				Global.player_obj.go_inside(self)

func navigate():
	$DoorBig.play("default")

func goto():
	Global.player_obj.global_position = Vector2(562, 353)
	Global.player_obj.reset()
	Global.MainGame.switch_room()

func _on_body_entered(body: Node2D) -> void:
	inside = true

func _on_body_exited(body: Node2D) -> void:
	inside = false

func _on_door_big_animation_finished() -> void:
	goto()
