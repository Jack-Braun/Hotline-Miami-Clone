extends Label

func _ready() -> void: 
	Events.gun_changed.connect(_on_events_gun_changed)
	
func _on_events_gun_changed(gun_name) -> void:
	text = gun_name.capitalize()
	
