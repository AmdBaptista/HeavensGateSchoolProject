extends State

var is_attacking = false

func enter():
	super.enter()
	combo()

func attack(move = "1"):
	animation_player.play("attack" + move)
	await animation_player.animation_finished

func combo():
	is_attacking = true
	var move_set = ["1","2","2"]
	for i in move_set:
		await attack(i)
	is_attacking = false
	if owner.direction.length() < 80:
		combo()

func transition():
	if owner.direction.length() > 50 and !is_attacking:
		get_parent().change_state("Follow")
