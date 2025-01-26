extends Area2D

var leaving = false


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		leaving = true
		print("Demon is ready to leave")
	else:
		print("Demon node not found at path: ")


func _on_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		leaving = false
		print("Demon is not ready to leave")
	else:
		print("Demon node not found at path: ")
