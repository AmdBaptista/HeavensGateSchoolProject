extends Node2D
class_name State

@onready var demon_player = owner.get_parent().find_child("Demon")
@onready var animation_player = owner.find_child("AnimationPlayer")
@onready var animated_sprite = owner.find_child("AnimatedSprite2D")

func _ready() -> void:
	set_physics_process(false)
	
func enter():
	set_physics_process(true)
	
func exit():
	set_physics_process(false)

func transition():
	pass
	
func _physics_process(delta: float) -> void:
	transition()
