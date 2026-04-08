extends Control

@onready var lives_label: Label = $Label

func _ready():
	Inventory.update_lives.connect(update_lives)
	update_lives(Inventory.lives)

func update_lives(lives):
	lives_label.text = "Lives: " + str(lives)
