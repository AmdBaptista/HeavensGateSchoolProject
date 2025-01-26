extends Node


@onready var angel_player = %"Angel Player"

func _ready() -> void:
	angel_player.setCameraLimits(-125,-200,2000,900)
