class_name Actor extends CharacterBody2D

const SPEED: int = 90
const BLOOD_SPLATTER: PackedScene = preload("res://blood_splatter.tscn")

var hp: int = 1
var dead: bool = false

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _gun: Gun = $Gun
@onready var _blood_particles: GPUParticles2D = $BloodParticles

func take_damage(amount: int) -> void:
	hp += amount
	if hp <= 0 and not dead:
		die()

func die() -> void:
	dead = true
	set_collision_layer_value(2, false)
	_sprite.hide()
	_gun.set_collision_layer_value(1, true)

	#Blood splatter
	var inst: BloodSplatter = BLOOD_SPLATTER.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.start(global_position)

	#Blood particles
	_blood_particles.restart()
	await(_blood_particles.finished)
