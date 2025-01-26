extends Node


@onready var angel_player = %"Angel Player"

func _ready() -> void:
	angel_player.setCameraLimits(-100,-200,1900,900)
