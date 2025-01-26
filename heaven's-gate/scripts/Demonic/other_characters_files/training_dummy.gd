extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_numbers: Node2D = $DamageNumbers

func _on_hurbox_hurt(damage:int, is_critical:bool) -> void:
	if is_critical:
		print("I got hurt for ",damage," damage and it was a critical hit")
	else:
		print("I got hurt for ",damage," damage")
	
	# DamageNumbers.display_numbers(damage, damage_numbers.global_position, is_critical)
	animated_sprite.play("hurt")
