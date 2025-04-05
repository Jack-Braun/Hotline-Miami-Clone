class_name Actor extends CharacterBody2D

const SPEED: int = 90.0
const BLOOD_SPLATTER: PackedScene = preload("res://blood_splatter.tscn")

var hp: int = 1

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _gun: Gun = $Gun
@onready var _blood_particles: GPUParticles2D = $BloodParticles

func take_damage(damage: int) -> void:
	hp += damage
	if hp <= 0:
		set_collision_layer_value(2, false)
		_sprite.hide()
		
		#Blood splatter
		var inst: BloodSplatter = BLOOD_SPLATTER.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.start(global_position)
		
		#Blood particles
		_blood_particles.restart()
		await(_blood_particles.finished)
		#queue_free()
		
