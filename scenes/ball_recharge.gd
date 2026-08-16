extends Area2D
var done = false
var detached = false
var life = 0
var velocity: Vector2 = Vector2.ZERO
var item_obj = load("res://scenes/ItemRecharge.tscn")
var recharger_obj = load("res://scenes/recharger.tscn")

func _ready() -> void:
	add_to_group("hanginitem")
	
func hit():
	var recharger = recharger_obj.instantiate()
	recharger.global_position = global_position
	get_parent().add_child(recharger)
	detached = true
	$"..".detached = true
	
func breakme():
	var recharger = recharger_obj.instantiate()
	recharger.global_position = global_position
	get_parent().add_child(recharger)
	done = true
	$sprite.frame = 1
		
	var item = item_obj.instantiate()
	item.global_position = global_position
	get_tree().current_scene.add_child(item)
	queue_free()
	
func _physics_process(delta: float) -> void:
	if !done and detached:
		velocity.y += gravity * delta
		position += velocity * delta
