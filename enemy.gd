class_name Enemy
extends Actor

func _ready() -> void:
	rotation_degrees = randi_range(0, 360)

func _physics_process(_delta: float) -> void:
	if dead:
		return

	var player = Globals.player
	if player and not player.dead:
		var distance = player.global_position.distance_to(global_position)
		if distance <= 100:
			look_at(player.global_position)
			_gun.shoot_at(player.global_position)
