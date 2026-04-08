extends Node

class_name Player

@onready var camera = $Head/Camcorder as Camera3D
@onready var ray_cast: RayCast3D = $Head/Camcorder/RayCast3D
@onready var interaction_label: Label = $CenterContainer/Label
@onready var inventory = $Inventory
@onready var head = $Head

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_move_camera = true
@export var mouse_sensibility = 1200
var lantern = null

func equip_lantern():
	if lantern: return
	var lantern_scene = load("res://Interaction/Items/Lantern/Lantern.tscn")
	lantern = lantern_scene.instantiate()
	head.add_child(lantern)
	lantern.position = Vector3(0.5, -0.2, -0.5) # Adjust position relative to camera
	camera.visible = false # Hide camcorder (flashlight)
	print("Lantern Equipped!")

func enable_camera_movement():
	can_move_camera = true
	interaction_label.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Inventory.player = self

func _process(_delta):
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider:
			# print("RayCast colliding with: ", collider.name, " Type: ", collider.get_class())
			
			if not interaction_label.visible and can_move_camera:
				interaction_label.visible = true
				
			# Check if it is InteractionBase
			if collider is InteractionBase:
				# print("It IS InteractionBase")
				pass
			else:
				# print("It is NOT InteractionBase. Script: ", collider.get_script())
				pass
	else:
		if  interaction_label.visible:
			interaction_label.visible = false
			
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		can_move_camera = false
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and not inventory.container.visible:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				can_move_camera = true

	if event.is_action_pressed("Interact") and ray_cast.is_colliding():
		var object = ray_cast.get_collider()
		
		if object is InteractionBase:
			if object is DragInteraction:
				can_move_camera = false
				interaction_label.visible = false
				object.interaction_end.connect(enable_camera_movement,CONNECT_ONE_SHOT)
				object.interact(self)
			else:
				object.interact(self)

	if event.is_action_pressed("ToggleInventory"):
		if not inventory.container.visible:
			enable_camera_movement()
		else:
			can_move_camera = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event.is_action_pressed("ToggleLight"):
		if lantern:
			lantern.toggle()

func is_lantern_on() -> bool:
	if lantern:
		return lantern.is_on()
	return false
				
