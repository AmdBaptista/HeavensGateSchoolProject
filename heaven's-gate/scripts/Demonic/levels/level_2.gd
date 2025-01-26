extends Node


@onready var demon_player = %Demon


func _ready() -> void:
	demon_player.current_stamina = demon_player.max_stamina
	demon_player.setCameraZoom(1.75)
	demon_player.setCameraLimits(-50,-50,1075,550)
