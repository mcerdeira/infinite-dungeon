extends CharacterBody2D
var invulnerable_hit = false
var prefix = ""
var SPEED = 175.0
var JUMP_VELOCITY = -600.0
var shoot_delay = 0.0
var shoot_delay_total = 0.3
var bullet_obj = preload("res://scenes/bullet.tscn")
var jump_ttl_total = 0.5
var jump_ttl = 0.0
var double_jump = false
var jumping = false
var moving = false
var scale_x = 1.0
var scale_y = 1.0
var dont_move = false
var direction = "R"
var direction_shoot = "R"
var bullet_ttl = 0.2
var is_on_stairs = false
var grabbed = false
var canceled = false
var geting_item = 0
var bouncing = 0.0
var call_back = null
var going_inside = false
const blood = preload("res://scenes/blood.tscn")

func _ready() -> void:
	Global.player_obj = self
	add_to_group("players")
	set_init()
	%UI.calc_life()
	
func get_life(amount):
	Global.LIFE += amount
	if Global.LIFE > Global.LIFE_MAX:
		Global.LIFE = Global.LIFE_MAX
	%UI.calc_life()
	
func set_item_anim(anim):
	geting_item = 1.2
	$item.animation = anim
	$pistol.visible = false
	$item.visible = true
	
func reset_item_anim():
	geting_item = 0
	$pistol.visible = true
	$item.visible = false
	
func set_init():
	SPEED = 175.0
	bullet_ttl = 0.2
	shoot_delay_total = 0.3
	
func arrow_catch(amount = 1):
	Global.ARROWS += amount
	%UI.calc_arrows()
	
func got_fly():
	Global.DOUBLEJUMP = false
	Global.FLY = true
	prefix = "fly_"
	$Scarf.visible = true
	$Scarf/Line2D.visible = true
	$Scarf/Line2D.default_color = Color(0.20, 0.16, 0.59, 1)
	$sprite.play(prefix + "_idle")
	
func got_double_jump():
	Global.DOUBLEJUMP = true
	Global.FLY = false
	prefix = "_"
	$Scarf.visible = true
	$Scarf/Line2D.visible = true
	$Scarf/Line2D.default_color = Color(1, 0, 0.23, 1)
	$sprite.play(prefix + "_idle")
	
func got_homing():
	Global.HOMING = true

func recharge_flask():
	if !Global.GAMEOVER:
		Global.FLASK = 2
		rain(5)
		%UI.calc_flask()
	
func use_flask():
	if !Global.GAMEOVER:
		if Global.FLASK > 0:
			Global.FLASK -= 1
			set_item_anim("flask")
			get_life(3)
			rain(5)
			%UI.calc_flask()
			
func bouncer():
	bouncing = 0.15

func _physics_process(delta: float) -> void:
	if bouncing > 0:
		bouncing -= 1 * delta
	
	if shoot_delay > 0:
		shoot_delay -= 1 * delta
		
	if geting_item > 0:
		geting_item -= 1 * delta
		if geting_item <= 0:
			dont_move = false
			reset_item_anim()
		
	if Input.is_action_just_pressed("use_flask") and !Global.GAMEOVER:
		if geting_item <= 0:
			use_flask()
	
	if not is_on_floor() and !grabbed:
		velocity += get_gravity() * delta
					
	if jumping and is_on_floor():
		double_jump = false
		jumping = false
		scale_x = 3.8
		scale_y = 0.1
		
	moving = false
	
	var hold = false
	var jump = false
	var left = false
	var right = false
	var up = false
	var down = false
	var shoot = false
	var attack = false
	
	jump = Input.is_action_just_pressed("jump")
	left = Input.is_action_pressed("left")
	right = Input.is_action_pressed("right")
	up = Input.is_action_pressed("up")
	down = Input.is_action_pressed("down")
	shoot = Input.is_action_just_released("shoot")
	hold = Input.is_action_pressed("shoot")
	attack = Input.is_action_just_pressed("attack")
	
	if attack:
		hold = false
		shoot = false
	
	if !hold and !shoot and attack:
		$whip/whip_area/collider.set_deferred("disabled", false)
		$whip.visible = true
		$pistol.visible = false
		$whip.play("default")
	
	if geting_item > 0:
		dont_move = true
		shoot = false
		hold = false
	
	if canceled:
		hold = false
	if canceled and shoot:
		hold = false
		shoot = false
		canceled = false
		
	if !dont_move and jump and (is_on_floor() or Global.FLY or Global.DOUBLEJUMP):
		var jump_ok = true
		if Global.DOUBLEJUMP and !is_on_floor():
			if !double_jump:
				double_jump = true
			else:
				jump_ok = false
				
		if jump_ok:
			jump_ttl = jump_ttl_total
			velocity.y = JUMP_VELOCITY
			scale_x = 0.1
			scale_y = 3.1
			jumping = true
		
	$pistol/Bullet.visible = hold
		
	if scale_x > 1.0:
		scale_x = lerp(scale_x, 1.0, 0.3)
		
	if scale_x < 1.0:
		scale_x = lerp(scale_x, 1.0, 0.1)
		
	if scale_y > 1.0:
		scale_y = lerp(scale_y, 1.0, 0.1)
		
	if scale_y < 1.0:
		scale_y = lerp(scale_y, 1.0, 0.1)
		
	$sprite.scale.x = lerp($sprite.scale.x, scale_x, 0.1)
	$sprite.scale.y = lerp($sprite.scale.y, scale_y, 0.1)
		
	if bouncing <= 0 and !going_inside:
		if !dont_move and (!hold or hold and jumping) and !shoot and left:
			direction = "L"
			velocity.x = -1 * SPEED
			moving = true
			$sprite.flip_h = true
			$pistol.scale.x = -1
			$whip.scale.x = -1
		elif !dont_move and (!hold or hold and jumping) and !shoot and right:
			direction = "R"
			velocity.x = 1 * SPEED
			moving = true
			$sprite.flip_h = false
			$pistol.scale.x = 1
			$whip.scale.x = 1
		else:
			velocity.x = 0
		
	if bouncing <= 0 and !going_inside:
		if grabbed and !up and !down:
			velocity.y = 0
		
	if bouncing <= 0 and !going_inside:
		if up:
			if is_on_stairs and !grabbed:
				grabbed = true 
			elif is_on_stairs and grabbed:
				velocity.y = -1 * SPEED / 1.1
				moving = true
				
		if down:
			if is_on_stairs and !grabbed:
				grabbed = true 
			elif is_on_stairs and grabbed:
				velocity.y = 1 * SPEED / 1.1
				moving = true
		
	if !shoot:
		if !dont_move and up and right:
			direction_shoot = "RU"
			$pistol.rotation_degrees = 313
		elif !dont_move and up and left:
			direction_shoot = "LU"
			$pistol.rotation_degrees = 46
		elif !dont_move and down and left:
			direction_shoot = "LD"
			$pistol.rotation_degrees = -46
		elif !dont_move and down and right:
			direction_shoot = "RD"
			$pistol.rotation_degrees = -313
		elif !dont_move and up:
			direction_shoot = "U"
			if $sprite.flip_h:
				$pistol.rotation_degrees = -270
			else:
				$pistol.rotation_degrees = 270
		elif !dont_move and down:
			direction_shoot = "D"
			if $sprite.flip_h:
				$pistol.rotation_degrees = 270
			else:
				$pistol.rotation_degrees = -270
		elif !dont_move and left:
			if direction == "L":
				direction_shoot = "L"
				$pistol.rotation_degrees = 0
			elif direction == "R":
				shoot = false
				hold = false
				canceled = true
		elif !dont_move and right:
			if direction == "R":
				direction_shoot = "R"
				$pistol.rotation_degrees = 0
			elif direction == "L":
				shoot = false
				hold = false
				canceled = true
	
	if!dont_move and !hold and shoot:
		shoot_action()
		
	if !Global.GAMEOVER:
		if !going_inside:
			if moving:
				$sprite.play(prefix + "running")
			else:
				$sprite.play(prefix + "idle")
				
			if geting_item > 0:
				$sprite.play(prefix + "item")

		move_and_slide()
		
		var slide_col = get_slide_collision_count()
		var push_something = false
		for i in slide_col:
			var c = get_slide_collision(i)
			var col = c.get_collider() 
			var normal = c.get_normal()
			if col.is_in_group("interactuable") and normal.y == 0:
				push_something = true
				col.pushed(SPEED, direction)
		
func shoot_action():
	if Global.ARROWS > 0:
		if shoot_delay <= 0:
			Global.ARROWS -= 1
			%UI.calc_arrows()
			shoot_delay = shoot_delay_total
			var buff = 0.0
			var dir = 0.0
			var bullet = bullet_obj.instantiate()
			bullet.global_position = $pistol/point.global_position
			bullet.rotation_degrees = $pistol.rotation_degrees
			if direction_shoot == "R":
				dir = 1.0
				bullet.direction = Vector2.RIGHT
			if direction_shoot == "L":
				dir = -1.0
				bullet.direction = Vector2.LEFT
			if direction_shoot == "U":
				dir = 0.0
				bullet.direction = Vector2.UP
			if direction_shoot == "D":
				dir = 0.0
				bullet.direction = Vector2.DOWN
			if direction_shoot == "RU":
				dir = 1.0
				bullet.direction = Vector2.from_angle(deg_to_rad(bullet.rotation_degrees))
			if direction_shoot == "LU":
				dir = -1.0
				bullet.direction =  Vector2.from_angle(deg_to_rad(bullet.rotation_degrees - 180))
			if direction_shoot == "RD":
				dir = 1.0
				bullet.direction = Vector2.from_angle(deg_to_rad(bullet.rotation_degrees))
			if direction_shoot == "LD":
				dir = -1.0
				bullet.direction =  Vector2.from_angle(deg_to_rad(bullet.rotation_degrees - 180))
			get_tree().current_scene.add_child(bullet)
				
func hit():
	if !invulnerable_hit:
		if Global.LIFE > 0:
			invulnerable_hit = true
			bleed(10)
			Global.LIFE -= 1
			%UI.calc_life()
			if Global.LIFE <= 0:
				Global.LIFE = 0
				die()
			else:
				$TimerHit.start()
				$AnimHit.play("new_animation")
	
func die():
	dont_move = true
	$sprite.play(prefix + "dying")
	Global.GAMEOVER = true
	$pistol.visible = false
	
func rain(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = $item.global_position
		blood_instance.blood_type = "flask_liquid"
		get_parent().call_deferred("add_child", blood_instance)
		
func go_inside(_callback):
	$sprite.play("go_inside")
	$AnimGoInside.play("new_animation")
	$pistol.visible = false
	going_inside = true
	call_back = _callback
	
func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		blood_instance.blood_type = "blood_player"
		get_parent().call_deferred("add_child", blood_instance)

func _on_visibility_notif_screen_exited() -> void:
	Global.MainGame.navigate_dugeon(global_position)

func _on_timer_hit_timeout() -> void:
	invulnerable_hit = false
	$TimerHit.stop()
	$AnimHit.stop()
	
func reset():
	going_inside = false
	$pistol.visible = true
	$sprite.modulate.a = 1.0
	direction_shoot = "R"
	$pistol.rotation_degrees = 0

func _on_sprite_animation_finished() -> void:
	if Global.GAMEOVER:
		$Ghost.visible = true
		$DeadGhost.play("new_animation")

func _on_whip_animation_finished() -> void:
	$whip/whip_area/collider.set_deferred("disabled", true)
	$whip.visible = false
	$pistol.visible = true

func _on_anim_go_inside_animation_finished(anim_name: StringName) -> void:
	call_back.navigate()
