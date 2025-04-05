class_name Gun extends CharacterBody2D

const BULLET: PackedScene = preload("res://bullet.tscn")

# gun is manually set here
var data: GunData = Data.guns.glock
var ammo: int = data.rounds
var ammo_count: int = ammo * 3

@onready var _shoot: AudioStreamPlayer2D = $Shoot
@onready var _reload: AudioStreamPlayer2D = $Reload
@onready var _out_of_ammo_click: AudioStreamPlayer2D = $OutOfAmmoClick
@onready var _fire_rate: Timer = $FireRate
@onready var _reload_time: Timer = $ReloadTime

func _ready() -> void:
	await(get_tree().process_frame)
	Events.ammo_updated.emit(ammo, ammo_count) 	

func shoot() -> bool:
	if !_fire_rate.is_stopped() or !_reload_time.is_stopped():
		return false
	
	#Handle out of ammo state
	if ammo <= 0:
		if ammo_count > 0:
			_reload.play()
		else: 
			_out_of_ammo_click.play()
		_reload_time.start(data.reload_time + randf_range(-0.025, 0.025))
		return false
	
	var start_pos: Vector2 = global_position 
	var direction: Vector2 = start_pos.direction_to(get_global_mouse_position())
	
	#Shoot round
	var inst: Bullet = BULLET.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.start(global_position, direction)
	inst.look_at(get_global_mouse_position())
	
	ammo -= 1
	Events.ammo_updated.emit(ammo, ammo_count) 
	_shoot.play()
	_fire_rate.start(data.fire_rate + randf_range(-0.025, 0.025))
	return true

func _on_reload_time_timeout():
	if ammo_count <= 0:
		return
	
	#Reload
	ammo = data.rounds if ammo_count >= data.rounds else ammo_count
	ammo_count -= data.rounds
	Events.ammo_updated.emit(ammo, ammo_count) 
	
