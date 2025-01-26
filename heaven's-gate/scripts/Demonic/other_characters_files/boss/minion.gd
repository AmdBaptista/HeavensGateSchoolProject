extends CharacterBody2D

@export var speed = 60

@onready var demon_player = get_parent().find_child("Demon")
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	set_physics_process(false)
	await animated_sprite.animation_finished
	set_physics_process(true)
	animated_sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	var direction = demon_player.position - position
	velocity = direction.normalized() * speed
	move_and_slide()
	


func _on_hurbox_hurt(damage: int, is_critical: bool) -> void:
	queue_free()
