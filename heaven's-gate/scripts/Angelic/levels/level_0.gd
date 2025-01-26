extends Node

@onready var angel_player = %"Angel Player"

func _ready() -> void:
	angel_player.setCameraLimits(-500,-1500, 2125,600)
