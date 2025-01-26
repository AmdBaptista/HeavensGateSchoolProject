extends Node

@onready var demon_player = %Demon


func _ready() -> void:
	demon_player.current_stamina = 0
	demon_player.setCameraLimits(-500,-650,2370,575)
