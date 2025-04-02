class_name ShellCasing extends Sprite2D

func start(start_pos: Vector2) -> void:
	var spread: int = 16
	start_pos.x += randi_range(-spread, spread)
	start_pos.y += randi_range(-spread, spread)
	global_position = start_pos
	rotation_degrees = randf_range(0, 360)
