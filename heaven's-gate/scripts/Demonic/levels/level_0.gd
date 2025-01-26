extends Node

@onready var demon_player = %Demon
@onready var mapa = $Mapa 
@onready var label
@onready var collision = $Area2D/CollisionShape2D

func _ready() -> void:
	demon_player.current_stamina = 0
	label = mapa.find_child("Labels").find_child("Label")
	demon_player.setCameraLimits(-75,75,3550,520)


func _on_area_2d_body_entered(body: Node2D) -> void:
	label.text = "Oh wait, you can't... \nNow you need to wait for the Angel to help you gain Stamina \nand then you can use Shift to Dash\nDon't forget to preserve your Stamina, it's a limited resource!"
