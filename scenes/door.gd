extends Area2D
var first = true
var particles_splash_obj = load("res://scenes/particles_splash.tscn")

func _ready() -> void:
	add_to_group("doors")
	visible = false
	$collider.set_deferred("disabled", true)

func close():
	visible = true
	$collider.set_deferred("disabled", false)
	
func splashV(pos1, pos2, rot1, rot2, mini = false):
	var splash = particles_splash_obj.instantiate()
	add_child(splash)
	splash.global_position = pos1
	splash.mini = mini
	splash.rotation_degrees = rot1
	splash._emit()
	#
	splash = particles_splash_obj.instantiate()
	add_child(splash)
	splash.global_position = pos2
	splash.mini = mini
	splash.rotation_degrees = rot2
	splash._emit()
	
	
func splashH(pos1, pos2, sca1, sca2, mini = false):
	var splash = particles_splash_obj.instantiate()
	add_child(splash)
	splash.global_position = pos1
	splash.mini = mini
	splash.scale.x = splash.scale.x * sca1
	splash._emit()
	#
	splash = particles_splash_obj.instantiate()
	add_child(splash)
	splash.global_position = pos2
	splash.mini = mini
	splash.scale.x = splash.scale.x * sca2
	splash._emit()

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		var player_postition = Global.player_obj.global_position
		var pos1 = 0
		var pos2 = 0
		var sca1 = 0
		var sca2 = 0
		var rot1 = 0
		var rot2 = 0
		var h = false
		var v = false
		
		if player_postition.x > width - 32:
			pos1 = Vector2(Global.player_obj.global_position.x, Global.player_obj.global_position.y - 32)
			Global.player_obj.global_position.x = 32
			sca1 = -1
			sca2 = 1
			h = true
			pos2 = Vector2(Global.player_obj.global_position.x, Global.player_obj.global_position.y - 32)
		elif player_postition.x < 32:
			pos1 = Vector2(Global.player_obj.global_position.x, Global.player_obj.global_position.y - 32)
			Global.player_obj.global_position.x = width - 32
			sca1 = 1
			sca2 = -1
			h = true
			pos2 = Vector2(Global.player_obj.global_position.x, Global.player_obj.global_position.y - 32)
		elif player_postition.y > height - 16:
			pos1 = Global.player_obj.global_position
			rot1 = 180.0
			rot2 = 0.0
			v = true
			Global.player_obj.global_position.y = 64
			pos2 = Global.player_obj.global_position
		elif player_postition.y < 64:
			pos1 = Global.player_obj.global_position
			rot1 = 0.0
			rot2 = 180.0
			v = true
			Global.player_obj.global_position.y = height - 32
			pos2 = Global.player_obj.global_position

		if h:
			splashH(pos1, pos2, sca1, sca2)
		elif v:
			splashV(pos1, pos2, rot1, rot2)

func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("arrows"):
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		var player_postition = area.global_position
		var pos1 = 0
		var pos2 = 0
		var sca1 = 0
		var sca2 = 0
		var rot1 = 0
		var rot2 = 0
		var h = false
		var v = false
		
		if player_postition.x > width - 32:
			pos1 = Vector2(area.global_position.x, area.global_position.y - 32)
			area.global_position.x = 32
			sca1 = -1
			sca2 = 1
			h = true
			pos2 = Vector2(area.global_position.x, area.global_position.y - 32)
		elif player_postition.x < 32:
			pos1 = Vector2(area.global_position.x, area.global_position.y - 32)
			area.global_position.x = width - 32
			sca1 = 1
			sca2 = -1
			h = true
			pos2 = Vector2(area.global_position.x, area.global_position.y - 32)
		elif player_postition.y > height - 96:
			pos1 = area.global_position
			rot1 = 180.0
			rot2 = 0.0
			v = true
			area.global_position.y = 32
			pos2 = area.global_position
		elif player_postition.y < 64:
			pos1 = area.global_position
			rot1 = 0.0
			rot2 = 180.0
			v = true
			area.global_position.y = height - 16
			pos2 = area.global_position
		if h:
			splashH(pos1, pos2, sca1, sca2, true)
		elif v:
			splashV(pos1, pos2, rot1, rot2, true)
