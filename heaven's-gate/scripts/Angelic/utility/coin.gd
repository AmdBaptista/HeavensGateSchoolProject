extends Area2D

# Signal for when the item is picked up
signal picked_up

@onready var audio_player = $AudioStreamPlayer2D
@export var sound : AudioStream = preload("res://assets/sounds/coin_pickup.mp3")

func _ready() -> void:
	audio_player.stream = sound

func _on_body_entered(body: Node2D) -> void:
	emit_signal("picked_up")
	audio_player.play()
	# Get the parent level dynamically
	var parent_level = get_parent().get_parent()
	
	# Ensure the level node is valid
	if parent_level and parent_level.name.begins_with("Level"):
		# Construct the path to the demon node in the second viewport
		var demon_node_path = "/root/Game/VBoxContainer/SubViewportContainer2/SubViewport/%s/Demon" % parent_level.name
		var demon_node = get_node_or_null(demon_node_path)
		
		# Check if the demon node exists and update its stamina
		if demon_node:
			demon_node.current_stamina = demon_node.max_stamina
			print("Demon's stamina restored!")
		else:
			print("Demon node not found at path: ", demon_node_path)
	else:
		print("Parent level not found or invalid!")
