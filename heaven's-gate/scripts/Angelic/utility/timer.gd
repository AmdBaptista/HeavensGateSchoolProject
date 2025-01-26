extends Node2D

@export var time = 120

@onready var timer = $Timer
@onready var label = $CanvasLayer/Label

var lost = false

func _ready() -> void:
	timer.wait_time = time
	timer.start()

func _process(delta: float) -> void:
	label.text = str(int(timer.time_left))  # Display the remaining time

func add_time(time_to_add: float):
	# Add time directly to time_left and restart the timer
	var new_time_left = timer.time_left + time_to_add
	print("Added time. New time_left: ", new_time_left)
	
	if new_time_left > 0:
		timer.stop
		timer.wait_time = new_time_left
		timer.start() 

func _on_timer_timeout() -> void:
	lost = true
	print("Timer expired!")
