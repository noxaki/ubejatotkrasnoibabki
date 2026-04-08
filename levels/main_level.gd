extends Node3D

func _ready():
	var nav_region = $NavigationRegion3D
	if nav_region:
		# Bake the navigation mesh at runtime, blocking to ensure it's ready
		nav_region.bake_navigation_mesh(false)
		print("NavMesh baked at runtime.")
