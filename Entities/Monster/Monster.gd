extends CharacterBody3D

@export var speed: float = 2.5 # 2x slower than player (5.0)
@export var detection_range: float = 20.0
var player: Node3D = null
var audio_player: AudioStreamPlayer3D
var nav_agent: NavigationAgent3D

func _ready():
	# Setup Audio
	audio_player = AudioStreamPlayer3D.new()
	audio_player.stream = load("res://assets/audio/monster.wav")
	audio_player.max_distance = detection_range
	add_child(audio_player)
	
	# Setup Navigation
	nav_agent = NavigationAgent3D.new()
	nav_agent.path_desired_distance = 1.0
	nav_agent.target_desired_distance = 2.0
	nav_agent.avoidance_enabled = false
	add_child(nav_agent)
	
	# Give the navmesh some time to bake
	call_deferred("find_player")

func find_player():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		
	# Set collision layer to 2 (Monster) to potentially collide with special blockers
	# But we need to make sure we still collide with world (layer 1)
	collision_layer = 2 
	collision_mask = 1 | 4 # World | DoorBlocker (assuming we will use layer 3 or 4 for blockers)

func _physics_process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		var is_chasing = false
		var close_range = 50.0 # Greatly increased so the monster immediately sees you
		
		# Check lantern status via PlayerController
		var lantern_on = false
		if player.has_node("PlayerController"):
			lantern_on = player.get_node("PlayerController").is_lantern_on()
			
		if distance < close_range:
			is_chasing = true
		elif distance < detection_range and lantern_on:
			is_chasing = true
			
		if is_chasing:
			if not audio_player.playing:
				audio_player.play()
				
			nav_agent.target_position = player.global_position
			
			var dir = Vector3.ZERO
			if not nav_agent.is_navigation_finished():
				var current_agent_position = global_position
				var next_path_position = nav_agent.get_next_path_position()
				dir = (next_path_position - current_agent_position)
				
			# Fallback if navigation fails or path is too short
			if dir.length_squared() < 0.01:
				dir = (player.global_position - global_position)
				
			dir = dir.normalized()
			
			var look_pos = Vector3(global_position.x + dir.x, global_position.y, global_position.z + dir.z)
			if global_position.distance_squared_to(look_pos) > 0.01:
				look_at(look_pos, Vector3.UP)
				
			var new_velocity = dir * speed
			velocity.x = new_velocity.x
			velocity.z = new_velocity.z
		else:
			if audio_player.playing:
				audio_player.stop()
				
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Player"):
			if collider.has_method("lose_life"):
				collider.lose_life()
