extends PointLight2D

# Speed not in seconds, higher number = faster animation
@export var color_speed: float = 7.0

var time_passed: float = 0.0
var gradient: Gradient

func _ready():
	var gradient_texture = texture as GradientTexture2D
	if gradient_texture:
		gradient = gradient_texture.gradient
	else:
		print("No light texture found!")

func _process(delta: float):
	if gradient:
		time_passed += delta * color_speed

		var red = sin(time_passed) * 0.5 + 0.5
		var green = sin(time_passed + 2.0) * 0.5 + 0.5
		var blue = sin(time_passed + 4.0) * 0.5 + 0.5

		gradient.set_color(0, Color(red, green, blue))  
		gradient.set_color(1, Color(0, 0, 0, 0))  
