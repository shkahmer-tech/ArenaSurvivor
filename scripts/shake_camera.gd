extends Camera2D

var strength := 0.0

func shake(amount: float) -> void:
	strength = amount

func _process(delta: float) -> void:
	strength = move_toward(strength, 0.0, 40.0 * delta)
	offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * strength
