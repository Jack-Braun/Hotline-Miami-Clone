class_name Bullet
extends CharacterBody2D

const SPEED: int = 250
const DAMAGE: int = 1
const SHELL_CASING: PackedScene = preload("res://shell_casing.tscn")

func _physics_process(_delta: float) -> void:
	velocity 

	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision: 
		var collider: Object = collision.get_collider()
		if collider is Actor: 
			collider.take_damage(-DAMAGE)
			collider.set_collision_layer_value(1, 0) 
			collider.set_collision_layer_value(2, 0) 
			collider._gun.set_collision_layer_value(1, 1)
		queue_free()

func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	velocity = direction * SPEED

	#Casings
	var inst: Node = SHELL_CASING.instantiate()
	inst.start(start_pos)
	get_tree().current_scene.add_child(inst)
