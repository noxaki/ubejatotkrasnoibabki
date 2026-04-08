extends SceneTree

func _init():
	var packed_scene = load("res://levels/main_level.tscn")
	var root = packed_scene.instantiate()
	
	var csg = root.get_node("HouseCSG")
	
	# Create a NavigationRegion3D if it doesn't exist
	var nav_region = root.get_node_or_null("NavigationRegion3D")
	if not nav_region:
		nav_region = NavigationRegion3D.new()
		nav_region.name = "NavigationRegion3D"
		root.add_child(nav_region)
		nav_region.owner = root
		
		# Move HouseCSG under NavigationRegion3D
		root.remove_child(csg)
		nav_region.add_child(csg)
		csg.owner = root
		
		# Make sure all children of CSG still have their owner set correctly
		_set_owner_recursive(csg, root)
		
	var nav_mesh = NavigationMesh.new()
	nav_mesh.agent_height = 2.0
	nav_mesh.agent_radius = 0.5
	nav_region.navigation_mesh = nav_mesh
	
	# Bake navmesh
	NavigationServer3D.bake_from_source_geometry_data(nav_mesh, NavigationMeshSourceGeometryData3D.new(), func(): print("done"))
	# Wait, bake_navigation_mesh is easier if we just do it in the editor.
	# Actually, Godot headless baking of CSG might be tricky.
	
	print("Saving scene...")
	var new_packed = PackedScene.new()
	new_packed.pack(root)
	ResourceSaver.save(new_packed, "res://levels/main_level.tscn")
	
	quit()

func _set_owner_recursive(node, root):
	for child in node.get_children():
		child.owner = root
		_set_owner_recursive(child, root)
