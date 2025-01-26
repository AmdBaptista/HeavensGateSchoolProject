extends State

@onready var collisionShape = $"../../hurbox/CollisionShape2D"
@onready var progressBar = $"../../CanvasLayer/ProgressBar"
@onready var detectPlayerCol = $"../../PlayerDetection/CollisionShape2D"

var player_entered : bool = false:
	set(value):
		player_entered = value
		progressBar.set_deferred("visible",value)
		detectPlayerCol.set_deferred("disabled",value)
		collisionShape.set_deferred("disabled",!value)
		


func _on_player_detection_body_entered(body: Node2D) -> void:
	player_entered = true
	
func transition():
	if player_entered:
		get_parent().change_state("Follow")
