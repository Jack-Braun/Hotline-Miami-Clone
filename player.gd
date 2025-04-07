class_name Player extends Actor

const HELPERS := preload("res://helpers.gd")

func _ready() -> void:
	Globals.player = self

func _physics_process(_delta: float) -> void:
	if dead:
		#print("Player is dead")
		return

	handle_input()
	handle_movement()
	handle_ammo_pickup()

func handle_input():
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("left_click_pressed") and _gun.shoot_at(get_global_mouse_position()):
		Globals.camera.add_trauma(0.25)

func handle_movement():
	velocity = HELPERS.get_four_direction_vector(true) * SPEED
	if velocity != Vector2.ZERO:
		move_and_slide()

func handle_ammo_pickup():
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is Gun:
			_gun.ammo_count += _gun.data.rounds
			collider.set_collision_layer_value(4, false)
			collider.set_collision_layer_value(1, false)
			collider.hide()
			Events.ammo_updated.emit(_gun.ammo, _gun.ammo_count)
