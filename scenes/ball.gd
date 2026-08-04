extends Area2D
var done = false
var detached = false
var life = 0
var velocity: Vector2 = Vector2.ZERO
var item_obj = load("res://scenes/Item.tscn")

func _ready() -> void:
	add_to_group("hanginitem")
	
func hit():
	detached = true
	$"..".detached = true
	
func breakme(wich_item):
	done = true
	$sprite.frame = 1
	var item = item_obj.instantiate()
	item.position.y = -17
	item.wich_item = wich_item
	add_child(item)
	
func _physics_process(delta: float) -> void:
	if !done and detached:
		velocity.y += gravity * delta
		position += velocity * delta
