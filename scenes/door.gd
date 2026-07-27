extends Area2D
var first = true

func _ready() -> void:
	add_to_group("doors")
	visible = false
	$collider.set_deferred("disabled", true)

func close():
	visible = true
	$collider.set_deferred("disabled", false)

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		var player_postition = Global.player_obj.global_position
		
		if player_postition.x > width - 64:
			Global.player_obj.global_position.x = 64
		elif player_postition.x < 64:
			Global.player_obj.global_position.x = width - 64
		elif player_postition.y > height - 64:
			Global.player_obj.global_position.y = 64
		elif player_postition.y < 64:
			Global.player_obj.global_position.y = height - 64
