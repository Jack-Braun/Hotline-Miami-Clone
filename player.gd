class_name Player extends Actor

#two methods to invoke a different scripts functions
#@onready var helpers := get_tree().root.get_node("helpers")
const HELPERS: Script = preload("res://helpers.gd")
@onready var _screen_shake: ScreenShake2D = $ScreenShake2D

func _physics_process(_delta):
	velocity = HELPERS.get_four_direction_vector(true) * SPEED
	move_and_slide()
	
	if Input.is_action_pressed("left_click_pressed"):
		if _gun.shoot():
			_screen_shake.add_trauma(0.25)
