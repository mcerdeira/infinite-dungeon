extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		# Only lethal when the player falls onto the tips from above;
		# walking in from the side while grounded passes through safely.
		if !body.is_on_floor() and body.velocity.y > 0:
			z_index = -99
			body.hit(9999)
