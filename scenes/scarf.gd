extends Node2D

@export var player: CharacterBody2D

@export var point_count := 8
@export var segment_length := 5.0

@export var stiffness := 14.0
@export var damping := 0.82
@export var gravity := 220.0

@onready var line := $Line2D

var last_direction = "R"

var points := []
var velocities := []

func _ready():

	points.resize(point_count)
	velocities.resize(point_count)

	for i in point_count:
		points[i] = global_position + Vector2.LEFT * i * segment_length
		velocities[i] = Vector2.ZERO

	line.clear_points()


func _physics_process(delta):

	if player == null:
		return
		
	if player.direction != last_direction:

		if player.direction == "R":
			velocities[1].x -= 90
		else:
			velocities[1].x += 90

		last_direction = player.direction

	var neck := Vector2(player.global_position.x, player.global_position.y - 10)

	if player.direction == "R":
		neck += Vector2(-6, -7)
	else:
		neck += Vector2(6, -7)

	points[0] = neck

	var wind = Vector2.ZERO

	# El movimiento del personaje empuja la bufanda
	wind.x = -player.velocity.x * 0.15
	wind.y = -player.velocity.y * 0.05

	# Movimiento cuando está quieto
	if abs(player.velocity.x) < 5 and abs(player.velocity.y) < 5:
		var t = Time.get_ticks_msec() * 0.001
		wind.x += sin(t * 2.5) * 10
		wind.y += cos(t * 3.0) * 4

	# Simulación
	for i in range(1, point_count):

		velocities[i].y += gravity * delta

		var target = points[i - 1]
		var dir = target - points[i]

		var dist = dir.length()

		if dist > 0.001:

			dir /= dist

			var error = dist - segment_length

			velocities[i] += dir * error * stiffness

		velocities[i] += wind * delta

		velocities[i] *= damping

		points[i] += velocities[i] * delta

	# Corrección para mantener la longitud
	for k in range(3):

		points[0] = neck

		for i in range(1, point_count):

			var delta_pos = points[i] - points[i - 1]
			var dist = delta_pos.length()

			if dist == 0:
				continue

			delta_pos /= dist

			points[i] = points[i - 1] + delta_pos * segment_length

	# Dibujar
	line.clear_points()

	for p in points:
		line.add_point(to_local(p))
