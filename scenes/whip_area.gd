extends Area2D

func _ready() -> void:
	add_to_group("whip")

func _on_area_entered(area: Area2D) -> void:
		if area and area.is_in_group("enemies") or area.is_in_group("hanginitem"):
			$collider.set_deferred("disabled", true)
			area.hit()
