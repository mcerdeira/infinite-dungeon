extends Area2D
var base_y = 0.0
var time = 0.0
var float_speed = 2.0
var float_amplitude = 6.0
var taken = false
var room_bellong = null
@export var wich_item = "map"

func _ready() -> void:
	add_to_group("items")
	room_bellong = Global.player_posision
	$sprite.animation = wich_item
	base_y = global_position.y
	
func activate():
	visible = true

func deactivate():
	visible = false

func _physics_process(delta: float) -> void:
	if visible:
		if !taken:
			time += delta
			global_position.y = base_y + sin(time * float_speed) * float_amplitude
		else:
			$sprite.material.set_shader_parameter("on", true)
			$AnimationPlayer.play("new_animation")

func _on_body_entered(body: Node2D) -> void:
	if visible:
		if !taken:
			if body and body.is_in_group("players"):
				taken = true
				if wich_item == "map":
					Global.got_map()
				elif wich_item == "double_jump":
					Global.got_double_jump()
				elif wich_item == "fly":
					Global.got_fly()
				elif wich_item == "radar":
					Global.got_radar()
				elif wich_item == "homing":
					Global.got_homing()
				elif wich_item == "bomb":
					Global.got_bomb()
				elif wich_item == "life":
					Global.player_obj.get_life(2)
				elif wich_item == "arrows":
					Global.player_obj.arrow_catch(6)
				elif wich_item == "feather":
					Global.got_feather()
				elif wich_item == "old_coin":
					Global.got_old_coin()
				elif wich_item == "burned_book":
					Global.got_burned_book()
				elif wich_item == "glass_eye":
					Global.got_glass_eye()
				elif wich_item == "amputed_hand":
					Global.got_amputed_hand()
				elif wich_item == "bloody_tongue":
					Global.got_bloody_tongue()
					
				Global.player_obj.set_item_anim(wich_item)
				Global.MainGame.show_item_banner(wich_item)
			
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if visible:
		visible = false
		queue_free()
