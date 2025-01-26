extends Area2D

@export var damage := 2
@export var critical_chance := 0.5

var positionx

@onready var colider : CollisionShape2D = $CollisionShape2D

func _ready():
	positionx = colider.position.x

func disable_hitbox():
	colider.call_deferred("set","disabled",true)

func enable_hitbox():
	colider.call_deferred("set","disabled",false)

func flip_hitbox(fliph:bool):
	if fliph:
		if colider.position.x == positionx:
			colider.position.x = -positionx
	else:
		if colider.position.x == -positionx:
			colider.position.x = positionx


func _on_body_entered(body: Node2D) -> void:
	if is_in_group("projectiles") and (body is TileMapLayer or body is TileMap):
		owner.queue_free()
