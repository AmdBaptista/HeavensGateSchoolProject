extends State


func enter():
	super.enter()
	animation_player.play("dead")

func boss_slained():
	animation_player.play("boss_slained")
