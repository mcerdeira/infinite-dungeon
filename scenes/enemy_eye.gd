extends Area2D
var speed: float = 100.0
var bullet_obj = preload("res://scenes/enemy_bullet.tscn")
var life = 2
var shoot_ttl_total_idx = 0
var shoot_ttl_total = [3.0, 0.3, 0.3, 0.3, 0.3]
var shoot_ttl = shoot_ttl_total[shoot_ttl_total_idx]
var no_xp = false
var direction = -1
var arrows = []
var base_y = 0.0
var time = 0.0
var float_speed = 2.0
var float_amplitude = 6.0

@export var imstatic = true
const blood = preload("res://scenes/blood.tscn")

func _ready() -> void:
	add_to_group("enemies")
	base_y = global_position.y
	
func hit():
	if life > 0:
		bleed(5)
		life -= 1
		$sprite.material.set_shader_parameter("on", true)
		$hit_timer.start()
		if life <= 0:
			die()
		
func die(force_noxp = false):
	for child in get_children():
		if child.is_in_group("arrows"):
			child.unstuck(get_parent())
	bleed(35)
	queue_free()

func shoot():
	var bullet = bullet_obj.instantiate()
	bullet.global_position = global_position
	bullet.direction = (Global.player_obj.global_position - global_position).normalized()
	get_parent().add_child(bullet)

func _physics_process(delta: float) -> void:
	time += delta
	global_position.y = base_y + sin(time * float_speed) * float_amplitude
	shoot_ttl -= 1 * delta
	if shoot_ttl <= 0:
		shoot_ttl_total_idx += 1
		if shoot_ttl_total_idx > 4:
			shoot_ttl_total_idx = 0
		shoot_ttl = shoot_ttl_total[shoot_ttl_total_idx]
		shoot()
		
	if !imstatic:
		$sprite.scale.x = direction * -1
		global_position += Vector2(direction, 0) * speed * delta
		
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.hit()

func _on_hit_timer_timeout() -> void:
	$sprite.material.set_shader_parameter("on", false)

func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		get_parent().call_deferred("add_child", blood_instance)
