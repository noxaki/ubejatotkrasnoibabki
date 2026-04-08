extends Control

@onready var anim = $AnimationPlayer
@onready var audio = $AudioStreamPlayer

func _ready():
	# Ensure it covers everything
	z_index = 100 
	anim.play("jumpscare_sequence")
	audio.play()

func _on_animation_finished(anim_name):
	if anim_name == "jumpscare_sequence":
		get_tree().reload_current_scene()
