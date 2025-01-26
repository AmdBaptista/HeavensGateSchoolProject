extends State

var can_transition = false

func enter():
	super.enter()
	animation_player.play("teleport")
	await animation_player.animation_finished
	can_transition = true
	
func teleport():
	var direction = Vector2.LEFT if demon_player.position.x > owner.position.x else Vector2.RIGHT
	owner.position.x = demon_player.position.x + direction.x * 40

func transition():
	if can_transition:
		get_parent().change_state("Attack")
		can_transition = false
