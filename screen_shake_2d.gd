class_name ScreenShake2D extends Camera2D

#This class is based off of
#https://gist.github.com/Alkaliii/3d6d920ec3302c0ce26b5ab89b417a4a
#Based of the 3.x KidsCanCode implementation -> https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html


@export var decay := 0.8 #How quickly shaking will stop [0,1].
@export var max_offset := Vector2(100,75) #Maximum displacement in pixels.
@export var max_roll := 0.1 #Maximum rotation in radians (use sparingly).
@export var noise : FastNoiseLite
@onready var death_text: Label = $DeathText

var noise_y = 0 #Value used to move through the noise
var trauma := 0.0 #Current shake strength
var trauma_pwr := 3 #Trauma exponent. Use [2,3]

func _ready():
	Globals.camera = self
	#randomize()
	#noise.seed = randi()

func _process(delta: float) -> void:
	if !Globals.player.dead: 
		global_position = Globals.player.global_position - (Globals.player.global_position - get_global_mouse_position()) * 0.30	
		if trauma:
			trauma = max(trauma - decay * delta, 0)
			_shake()
	  #optional
		elif offset.x != 0 or offset.y != 0 or rotation != 0:
			lerp(offset.x,0.0,1)
			lerp(offset.y,0.0,1)
			lerp(rotation,0.0,1)
	else:
		death_text.show()

func _shake() -> void: 
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(noise.seed,noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(noise.seed*2,noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(noise.seed*3,noise_y)

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)
