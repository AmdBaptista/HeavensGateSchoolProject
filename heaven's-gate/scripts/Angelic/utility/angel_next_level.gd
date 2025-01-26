extends Area2D

var leaving = false

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		leaving = true
		print("Angel is ready to leave")
	else:
		print("Angel node not found at path: ")


func _on_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		leaving = false
		print("Angel is not ready to leave")
	else:
		print("Angel node not found at path: ")
