class_name Player extends Actor

const HELPERS: Script = preload("res://helpers.gd")
@onready var gun = $Gun

@onready var _screen_shake: ScreenShake2D = $ScreenShake2D

func _ready() -> void:
	Globals.player = self

func _physics_process(_delta):
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("left_click_pressed"):
		if _gun.shoot():
			Globals.camera.add_trauma(0.25)
	
	#Movement
	velocity = HELPERS.get_four_direction_vector(true) * SPEED
	if !velocity: 
		return
	move_and_slide()
	
	################
	#Collecting ammo
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision: 
		var collider: Object = collision.get_collider()
		if collider is Gun: 
			gun.ammo_count += 16
			Events.ammo_updated.emit(gun.ammo, gun.ammo_count) 
			collider.set_collision_layer_value(1, 0)
			collider.hide()
	################

