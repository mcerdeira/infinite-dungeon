extends SubViewportContainer

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		visible = !visible
