# Ubejat Ot Krasnoi Babki - 3D Horror Game

## Overview

"Ubejat Ot Krasnoi Babki" is a 3D survival horror game built in **Godot 4.6**. The player is trapped in a massive two-story maze-like house, hunted by a relentless monster. To survive, you must explore, find keys to unlock doors, and manage your lantern's power while avoiding the monster.

## Features

- **Dynamic Monster AI**: The monster uses `NavigationAgent3D` for pathfinding and features a fallback logic to chase the player even when the navigation map is updating.
- **Inventory & Interaction System**: A robust system for collecting items, managing resources, and interacting with the environment (doors, drawers, etc.).
- **Maze Exploration**: A giant 100x20x100 house built using CSG tools, featuring runtime NavigationMesh baking for seamless AI movement.
- **Atmospheric Lighting**: Dark, ambient environments with interactive lighting (Lantern, Camcorder Night Vision).
- **Survival Mechanics**: Find Power Cells to keep your equipment running and Keys to progress through locked areas.

## Project Structure

- **`levels/`**: Contains `main_level.tscn`, the primary game environment.
- **`Entities/Monster/`**: The monster AI logic and scene.
- **`DemoPlayer/`**: The first-person player controller.
- **`Interaction/`**: Base classes and specific implementations for interactable objects (Doors, Furniture, Items).
- **`Inventory/`**: Global inventory state management and UI.
- **`UI/`**: Game overlays, including health/lives and jumpscare triggers.

## Gameplay Controls

- **WASD**: Movement
- **E**: Interact with objects / Pick up items
- **I**: Toggle Inventory
- **Q**: Toggle Lantern
- **T**: Toggle Camcorder
- **Space**: Jump

## Adding New Items

To extend the game with new collectible items, follow these steps:

#### 1. Create a New Scene
- Create a new scene file (e.g., `MyItem.tscn`) inherited from `res://Interaction/Items/CollectibleItem.tscn`.

#### 2. Configure the Resource
1. Add a mesh to represent the item visually.
2. In the inspector, create a new `ItemResource` for the `item` property.
3. Set the `item_name`, `texture` (for inventory UI), and `description`.

#### 3. Implement Custom Logic (Optional)
Attach a script to your item scene extending `Interaction/Items/CollectibleItem.gd` to handle custom behavior:

```gdscript
extends "res://Interaction/Items/CollectibleItem.gd"

func on_collect():
    # Logic triggered when the player picks up the item
    print("Collected my custom item!")

static func use_item():
    # Logic triggered when the "Use" button is pressed in the inventory
    # Access the player via Inventory.player
    pass
```

## Contributing

Contributions are welcome! If you have improvements for the AI, level design, or systems, feel free to fork the repository and submit a pull request.

## License

This project is released under the MIT License. See the `LICENSE` file for details.
