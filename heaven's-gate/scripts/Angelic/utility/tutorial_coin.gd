extends Area2D

@onready var coin_sound = $AudioStreamPlayer2D
# Signal for when the item is picked up
signal picked_up

func _on_body_entered(body: Node2D) -> void:
	coin_sound.play()
	await coin_sound.finished
	
	# Construct the path to the demon node in the second viewport
	var demon_node_path = "/root/Game/VBoxContainer/SubViewportContainer2/SubViewport/Level/Demon"
	var demon_node = get_node_or_null(demon_node_path)
	
	# Check if the demon node exists and update its stamina
	if demon_node:
		demon_node.current_stamina = demon_node.max_stamina
		print("Demon's stamina restored!")
	else:
		print("Demon node not found at path: ", demon_node_path)
		
	queue_free()