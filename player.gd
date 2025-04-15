class_name Player extends Actor

const HELPERS := preload("res://helpers.gd")

var weapon_names := ["glock", "deagle", "uzi"]
var current_weapon_index := 0
var saved_ammo := {}

func _ready() -> void:
	Globals.player = self

func _physics_process(_delta: float) -> void:
	if dead:
		if Input.is_action_just_pressed("restart"):
			restart()
		return
	
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon()
		
	handle_input()
	handle_movement()
	handle_ammo_pickup()

func restart():
	get_tree().change_scene_to_file("res://room.tscn")

func switch_weapon():
	#save current ammo
	var current_gun = weapon_names[current_weapon_index]
	saved_ammo[current_gun] = {
		"ammo": _gun.ammo,
		"ammo_count": _gun.ammo_count
	}

	current_weapon_index = (current_weapon_index + 1) % weapon_names.size()
	var switch_to_gun = weapon_names[current_weapon_index]

	_gun.data = Data.guns[switch_to_gun]

	if saved_ammo.has(switch_to_gun):
		_gun.ammo = saved_ammo[switch_to_gun]["ammo"]
		_gun.ammo_count = saved_ammo[switch_to_gun]["ammo_count"]
	else:
		_gun.ammo = _gun.data.rounds
		_gun.ammo_count = _gun.ammo * 3

	Events.ammo_updated.emit(_gun.ammo, _gun.ammo_count)
	print("Switched to ", switch_to_gun)
	Events.gun_changed.emit(switch_to_gun)

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
