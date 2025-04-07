class_name Bullet extends CharacterBody2D

var speed: int = 225
var damage: int = 1
var player_bullet: bool = true
const SHELL_CASING := preload("res://shell_casing.tscn")

func _ready() -> void:
	if not player_bullet:
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, true)

func _physics_process(_delta: float) -> void:
	move_and_slide()

	var collision := get_last_slide_collision()
	if collision:
		var collider := collision.get_collider()
		if collider is Enemy or collider is Player:
			collider.take_damage(-damage)
			collider.dead = true
		queue_free()

func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	velocity = direction * speed

	#Casings
	var inst: Node = SHELL_CASING.instantiate()
	inst.start(start_pos)
	get_tree().root.get_child(0).add_child(inst)
