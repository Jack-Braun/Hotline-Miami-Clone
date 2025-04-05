class_name Enemy extends Actor

func _ready() -> void: 
	rotation_degrees = randi_range(0, 360)
	
	#gun.hide()
