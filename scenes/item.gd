extends Area2D
var base_y = 0.0
var time = 0.0
var float_speed = 2.0
var float_amplitude = 6.0
var taken = false
@export var wich_item = "map"

func _ready() -> void:
	add_to_group("items")
	$sprite.animation = wich_item
	base_y = global_position.y

func _physics_process(delta: float) -> void:
	if !taken:
		time += delta
		global_position.y = base_y + sin(time * float_speed) * float_amplitude
	else:
		$sprite.material.set_shader_parameter("on", true)
		$AnimationPlayer.play("new_animation")

func _on_body_entered(body: Node2D) -> void:
	if !taken:
		if body and body.is_in_group("players"):
			taken = true
			if wich_item == "map":
				Global.got_map()
			elif wich_item == "double_jump":
				Global.got_double_jump()
			elif wich_item == "radar":
				Global.got_radar()
			
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
	queue_free()
