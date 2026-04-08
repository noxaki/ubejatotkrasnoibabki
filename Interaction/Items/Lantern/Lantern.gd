extends Node3D

@onready var light: OmniLight3D = $OmniLight3D

func _ready():
	light.visible = false # Off by default
	
func toggle():
	light.visible = not light.visible
	
func is_on() -> bool:
	return light.visible

# Deprecated but kept for compatibility if needed
func add_battery():
	pass
