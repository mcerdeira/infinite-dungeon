extends CharacterBody2D
var SPEED = 275.0
var JUMP_VELOCITY = -600.0
var shoot_delay = 0.0
var shoot_delay_total = 0.0
var bullet_obj = preload("res://scenes/bullet.tscn")
var jump_ttl_total = 0.5
var jump_ttl = 0.0
var jumping = false
var canjump = true
var moving = false
var scale_x = 1.0
var scale_y = 1.0
var dont_move = false
var direction = "R"
var direction_shoot = "R"
var bullet_ttl = 1.0

func _ready() -> void:
	add_to_group("players")
	set_init()
	
func set_init():
	SPEED = 175.0
	bullet_ttl = 0.2
	shoot_delay_total = 0.3
	
func arrow_catch():
	Global.ARROWS += 1
	if Global.ARROWS > Global.ARROWS_MAX:
		Global.ARROWS = Global.ARROWS_MAX
		
	%UI.calc_arrows()

func _physics_process(delta: float) -> void:
	if shoot_delay > 0:
		shoot_delay -= 1 * delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if jumping and is_on_floor():
		canjump = true
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
	
	jump = Input.is_action_just_pressed("jump")
	left = Input.is_action_pressed("left")
	right = Input.is_action_pressed("right")
	up = Input.is_action_pressed("up")
	down = Input.is_action_pressed("down")
	shoot = Input.is_action_just_released("shoot")
	hold = Input.is_action_pressed("shoot")
		
	if !dont_move and jump and (is_on_floor()):
		if !is_on_floor():
			canjump = false
		
		jump_ttl = jump_ttl_total
		velocity.y = JUMP_VELOCITY
		scale_x = 0.1
		scale_y = 3.1
		jumping = true
		
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
		
	if !dont_move and (!hold or hold and jumping) and !shoot and left:
		direction = "L"
		velocity.x = -1 * SPEED
		moving = true
		$sprite.flip_h = true
		$pistol.scale.x = -1
	elif !dont_move and (!hold or hold and jumping) and !shoot and right:
		direction = "R"
		velocity.x = 1 * SPEED
		moving = true
		$sprite.flip_h = false
		$pistol.scale.x = 1
	else:
		velocity.x = 0
		
	if !shoot:
		if !dont_move and up and right:
			direction_shoot = "RU"
			$pistol.rotation_degrees = 313
		elif !dont_move and up and left:
			direction_shoot = "LU"
			$pistol.rotation_degrees = 46
		elif !dont_move and up:
			direction_shoot = "U"
			if $sprite.flip_h:
				$pistol.rotation_degrees = -270
			else:
				$pistol.rotation_degrees = 270
		elif !dont_move and left:
			direction_shoot = "L"
			$pistol.rotation_degrees = 15
		elif !dont_move and right:
			direction_shoot = "R"
			$pistol.rotation_degrees = -15
	
	if!dont_move and !hold and shoot:
		shoot()
		
	if !Global.GAMEOVER:
		if moving:
			$sprite.play("_running")
		else:
			$sprite.play("_idle")

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
		
func shoot():
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
			
			get_parent().add_child(bullet)
			
			if moving:
				buff = 50 * dir
