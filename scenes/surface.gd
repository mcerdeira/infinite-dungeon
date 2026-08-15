extends Sprite2D

class_name paint

var bloods = []
var blood_texture =  preload("res://sprites/blood.png")
var blood_texture_player =  preload("res://sprites/blood_player.png")
var flask_liquid_texture = preload("res://sprites/blood_flask.png")
var blood_limit = 100500

func clear_blood():
	bloods = []
	queue_redraw()
		
func draw_blood(draw_pos : Vector2, _blood_type):
	if bloods.size() > blood_limit:
		bloods.pop_back()
		bloods.push_back([draw_pos, _blood_type])
	else:
		bloods.append([draw_pos, _blood_type])
	queue_redraw()
		
func _draw():
	for b in bloods:
		if b[1] == "blood":
			draw_texture(blood_texture, b[0])
		if b[1] == "blood_player":
			draw_texture(blood_texture_player, b[0])
		if b[1] == "flask_liquid":
			draw_texture(flask_liquid_texture, b[0])
			
