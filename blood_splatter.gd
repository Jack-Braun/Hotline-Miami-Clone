class_name BloodSplatter extends Sprite2D

@onready var _sound: AudioStreamPlayer2D = $Sound

func start(start_pos: Vector2) -> void: 
	global_position = start_pos
	rotation_degrees = randf_range(0, 360)
	_sound.play()
