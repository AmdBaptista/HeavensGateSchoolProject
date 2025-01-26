extends Area2D


signal hurt(damage:int, is_critical:bool)
signal regen(area2d:Area2D)

func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group(("hitboxes")):
		var damage = area.damage
		var is_critical = area.critical_chance > randf()
		if is_critical:
			damage *= 2
		hurt.emit(damage, is_critical)
		if (area.is_in_group("enemy_projectile") and owner.is_in_group("player")) or (area.is_in_group("player_projectile") and owner.is_in_group("enemies")):
			area.get_parent().queue_free()
	if area.is_in_group("utilities"):
		regen.emit(area)
