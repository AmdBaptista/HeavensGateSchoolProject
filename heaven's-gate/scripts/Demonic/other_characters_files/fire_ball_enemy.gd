extends RigidBody2D

@onready var timer = $TimerToFree

func _ready() -> void:
	timer.start()


func _on_timer_to_free_timeout() -> void:
	queue_free()
