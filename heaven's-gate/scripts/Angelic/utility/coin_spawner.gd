extends Node2D

# Array to store spawn locations
@export var spawn_locations: Array[NodePath] = []

# Reference to the item
@export var item: NodePath

# Called when the scene starts
func _ready():
	# Ensure there are locations and an item
	if spawn_locations.is_empty():
		push_error("No spawn locations defined!")
		return

	if item == null:
		push_error("Item node is not assigned!")
		return

	# Randomize the spawn initially
	spawn_item_randomly()

# Function to spawn the item at a random location
func spawn_item_randomly():
	var location_paths = spawn_locations.map(get_node)  # Resolve NodePaths to nodes
	if location_paths.is_empty():
		return

	# Choose a random location
	var random_location = location_paths[randi() % location_paths.size()]
	var item_node = get_node(item)

	# Position the item at the random location
	if random_location and item_node:
		item_node.global_position = random_location.global_position

func _on_coin_picked_up() -> void:
	spawn_item_randomly()
