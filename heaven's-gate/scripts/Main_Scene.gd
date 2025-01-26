extends Node

const ANGEL_LEVEL_BEGIN = "res://scenes/Angelic/levels/level"
const DEMON_LEVEL_BEGIN = "res://scenes/Demonic/levels/level"

# Manually assign paths to the nodes
var angel_node_path = "/root/Game/VBoxContainer/SubViewportContainer/SubViewport/Level"
var demon_node_path = "/root/Game/VBoxContainer/SubViewportContainer2/SubViewport/Level"
var level_node_path = "/root/Game/VBoxContainer/SubViewportContainer/SubViewport/Level"
var level_node_path2 = "/root/Game/VBoxContainer/SubViewportContainer2/SubViewport/Level"
var angel_level_before = "/root/Game/VBoxContainer/SubViewportContainer/SubViewport"
var demon_level_before = "/root/Game/VBoxContainer/SubViewportContainer2/SubViewport"

# The actual nodes will be fetched when needed
var node1_instance: Node
var node2_instance: Node
var level_instance: Node
var level_instance2: Node
var angel_level_node: Node
var demon_level_node: Node
var angel_before: Node
var demon_before: Node
@export var next: bool

var boss : Node
var demon : Node
var angel : Node
var timer : Node

var next_level = true

var level_counter = 0


# Called when the scene is ready
func _ready() -> void:
	
	next = false;

# Called every frame
func _process(delta: float) -> void:
	if next_level:
		reload()
	# Ensure the nodes are valid
	if node1_instance and node2_instance:
		if node1_instance.leaving and node2_instance.leaving and is_no_enemies():
			level_counter += 1
			change_scene_to_next_level(level_counter)
			
	if boss != null:
		if boss.boss_dead:
			change_to_menu()
		
	if demon.is_actually_dead or timer.lost or angel.dead:
		change_scene_to_next_level(level_counter)
		
	

func is_no_enemies():
	var enemies = demon_level_node.find_child("enemies")
	if enemies.get_children().is_empty():
		return true
	else:
		return false
		
func reload():
	demon_level_node = get_node(demon_node_path)
	node2_instance = demon_level_node.get_child(0)
	demon = demon_level_node.find_child("Demon")
	boss = demon_level_node.find_child("Boss")
	
	angel_level_node = get_node(angel_node_path)
	node1_instance = angel_level_node.get_child(0)
	angel = angel_level_node.find_child("Angel Player")
	timer = angel_level_node.find_child("Timer")
	
	level_instance = get_node(level_node_path)
	level_instance2 = get_node(level_node_path2)
	angel_before = get_node(angel_level_before)
	demon_before = get_node(demon_level_before)
	
	next_level = false

func change_scene_to_next_level(level:int):
	next = false
	# Get the current scene name of the Level node (which should have a name like "levelX")
	var current_scene_name = level_instance.name.strip_edges()

	# Extract the level number (assuming the format "levelX")
	var current_level_number = current_scene_name.right(1).to_int()

	# Increment the level number
	current_level_number = level

	# Construct the next scene path
	var angel_next_level_scene = ""
	var demon_next_level_scene = ""

	angel_next_level_scene = ANGEL_LEVEL_BEGIN + str(current_level_number) + ".tscn"
	demon_next_level_scene = DEMON_LEVEL_BEGIN + str(current_level_number) + ".tscn"
		
	var next_scene = load(angel_next_level_scene)
	var next_scene_instance = next_scene.instantiate()
	
	angel_before.remove_child(level_instance)
	angel_before.add_child(next_scene_instance)
	
	next_scene = load(demon_next_level_scene)
	next_scene_instance = next_scene.instantiate()
	
	demon_before.remove_child(level_instance2)
	demon_before.add_child(next_scene_instance)
	
	next_level = true
	
func change_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
