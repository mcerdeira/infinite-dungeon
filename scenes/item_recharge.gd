extends Area2D
var taken = false
var room_bellong = null

func _ready() -> void:
	add_to_group("items")
	room_bellong = Global.player_posision

func activate():
	visible = true

func deactivate():
	visible = false

func _on_body_entered(body: Node2D) -> void:
	if visible:
		if !taken:
			if body and body.is_in_group("players"):
				taken = true
				Global.player_obj.recharge_flask()
				Global.player_obj.set_item_anim("flask")
				queue_free()
