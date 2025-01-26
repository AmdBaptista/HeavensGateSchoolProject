extends State


@export var minion_scene = preload("res://scenes/Demonic/other_characters/minion.tscn")
var can_transition = false

func enter():
	super.enter()
	animation_player.play("summon")
	await animation_player.animation_finished
	can_transition = true

func transition():
	if can_transition:
		get_parent().change_state("Follow")
		can_transition = false
		
func spawn():
	var minion = minion_scene.instantiate()
	var direction = 1 if not animated_sprite.flip_h else -1
	minion.position = owner.position + Vector2(40 * direction, -40)
	owner.get_parent().add_child(minion)
