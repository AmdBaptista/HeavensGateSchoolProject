extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var angel = get_parent().get_node("Angel Player")
	angel.dead = true
