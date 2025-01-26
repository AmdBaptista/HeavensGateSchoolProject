extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")

func _on_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")

func _on_2_pressed() -> void:
	# Change the scene
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")
	

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
