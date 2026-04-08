# Project Documentation

## Overview
This is a 3D survival horror game built in Godot 4.6. The game features a giant two-story maze-like house with a monster that hunts the player. The player can explore, pick up items (like a lantern, keys, and batteries), and interact with objects (doors, furniture).

## Project Structure
- **`project.godot`**: Engine configuration file.
- **`levels/`**: Contains the main game environments.
  - `main_level.tscn`: The primary level scene containing the giant house, lighting, item placements, player, and monster.
  - `main_level.gd`: Script attached to the main level, responsible for runtime baking of the `NavigationMesh`.
- **`Entities/`**: Contains active characters.
  - **`Monster/`**: Contains `Monster.tscn` and `Monster.gd`. The monster uses `NavigationAgent3D` to pathfind toward the player, featuring a fallback to manual vector movement if pathfinding momentarily fails.
- **`DemoPlayer/`**: Contains the player character.
  - `demo_player.tscn` & `demo_player.gd`: The player entity.
  - `PlayerController.tscn` & `PlayerController.gd`: Handles player input and states, including a togglable lantern.
- **`Interaction/`**: Contains interactable objects.
  - **`Door/`**: Doors that can be locked/unlocked using specific keys.
  - **`Furniture/`**: Environmental objects for the house.
  - **`Items/`**: Collectible items.
    - **`Lantern/`**: The lantern pickup that allows the player to see in dark areas.
    - **`Key/`**: Keys required to open locked doors.
    - **`PowerCell/`**: Batteries used to power devices.
- **`Inventory/`**: Contains the inventory system.
  - `InventorySingleton.gd`: Autoloaded global state manager for the player's inventory and items.
  - `ItemResource.gd`: Data structure for items.
- **`UI/`**: Contains user interface elements.
  - `Jumpscare.tscn` & `Jumpscare.gd`: UI triggered when the monster catches the player.

## Implementation Details
### 1. Level Design (`main_level.tscn`)
- Built using **CSGCombiner3D** and **CSGBox3D** nodes to carve out hollow rooms and hallways in a massive 100x20x100 block.
- A **NavigationRegion3D** wraps the `HouseCSG` to provide a pathfinding surface for the monster. The navmesh is explicitly baked at runtime in `main_level.gd`.
- **Lighting** is achieved using several `OmniLight3D` nodes scattered throughout the level (floodlights and ambient center lights) to increase visibility. The `WorldEnvironment` disables glow and sets a dark ambient background.
- Wall and floor materials are set to have `roughness = 1.0` and no specular highlights to create a matte, non-glossy look.

### 2. Monster AI (`Monster.gd`)
- The monster uses a **NavigationAgent3D** to navigate toward the player.
- **Avoidance** is disabled on the navigation agent to allow direct manipulation of velocity based on the computed path direction.
- The monster's logic uses a `detection_range` and a `close_range` (set to 50.0) to spot the player immediately.
- If `nav_agent.is_navigation_finished()` is true or if `get_next_path_position()` returns a zero-length direction (due to navigation map updates), the logic falls back to moving manually toward the player's direct vector.
- Contact with the player triggers `collider.lose_life()`, leading to a jumpscare.

### 3. Navigation and Physics
- **Collision Layers**: The Monster is on layer 2, Player on layer 1 (typically), and interactables on layer 8.
- The player spawns at `(0, 1.6, 45)`.
- Ground floor Y-level is approximately `0.5`, Upper floor Y-level is `10.5`.

## Future Work
- Fix lingering script compilation errors reported in the debug output (e.g., "Identifier not found: Inventory" in some older scripts, likely due to a missing autoload setup or incorrect capitalization).
- Add more complex rooms and randomized item placement.
- Enhance the monster's patrol logic to wander when the player is out of range.
