extends State

func _enter_tree() -> void:
	randomize()

func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	if owner.direction.length() < 50:
		get_parent().change_state("Attack")
	if owner.direction.length() > 300:
		var chance = randi() % 2
		if chance == 0:
			get_parent().change_state("SpawnMinions")
		else:
			get_parent().change_state("Teleport")
		
