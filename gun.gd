class_name Gun extends Actor

const BULLET := preload("res://bullet.tscn")

var data: GunData = Data.guns.glock
var ammo: int = data.rounds
var ammo_count: int = ammo * 3

@onready var _shoot: AudioStreamPlayer2D = $Shoot
@onready var _reload: AudioStreamPlayer2D = $Reload
@onready var _out_of_ammo_click: AudioStreamPlayer2D = $OutOfAmmoClick
@onready var _fire_rate: Timer = $FireRate
@onready var _reload_time: Timer = $ReloadTime

func _ready() -> void:
	await get_tree().process_frame
	Events.ammo_updated.emit(ammo, ammo_count)

func shoot_at(target_position: Vector2) -> bool:
	if not _fire_rate.is_stopped() or not _reload_time.is_stopped():
		return false

	if ammo <= 0:
		handle_reload()
		return false

	fire_bullet(target_position)
	return true

func handle_reload():
	if ammo_count > 0:
		_reload.play()
	else:
		#So the enemies dont repeatedly play the clicking noise if out of ammo
		if ammo_count == 0 && ammo == 0 && !Globals.player._gun == self:
			return
		else:
			_out_of_ammo_click.play()
	_reload_time.start(data.reload_time + randf_range(-0.025, 0.025))

func fire_bullet(target_position: Vector2):
	var direction = global_position.direction_to(target_position)
	var bullet = BULLET.instantiate()
	bullet.player_bullet = Globals.player._gun == self
	if !bullet.player_bullet:
		bullet.speed = 75
	get_tree().current_scene.add_child(bullet)  
	bullet.start(global_position, direction)    
	bullet.look_at(target_position)

	ammo -= 1
	if Globals.player._gun == self:
		Events.ammo_updated.emit(ammo, ammo_count)
	_shoot.play()
	
	if bullet.player_bullet:
		_fire_rate.start(data.fire_rate + randf_range(-0.025, 0.025))
	else :
		_fire_rate.start(data.fire_rate + 0.7)
	
func _on_reload_time_timeout():
	if ammo_count <= 0:
		return
	#If gun belongs to player update ammo counter
	if Globals.player._gun == self:
		ammo = data.rounds if ammo_count >= data.rounds else ammo_count
		ammo_count -= data.rounds
		Events.ammo_updated.emit(ammo, ammo_count) 
	else:
		ammo = data.rounds if ammo_count >= data.rounds else ammo_count
		ammo_count -= data.rounds
	
