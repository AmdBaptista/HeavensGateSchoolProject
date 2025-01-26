extends Node2D

@export var left_weight := 0.0
@export var right_weight := 0.0
@export var added_time := 20


@onready var left_plate: Area2D = $LeftPlate
@onready var right_plate: Area2D = $RightPlate
@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_player = $AudioStreamPlayer2D
@onready var timer = get_parent().get_node("Timer")
@export var sound : AudioStream = preload("res://assets/sounds/weight_completed.mp3")

@export var balanced_texture: Texture2D
@export var inclined_texture: Texture2D

var is_balanced := true
var is_left_heavy := true

@export var is_done := false
var has_added_time := false


func update_sprite() -> void:
	if is_balanced:
		sprite.texture = balanced_texture
		sprite.flip_h = false
	else:
		sprite.texture = inclined_texture
		sprite.flip_h = not is_left_heavy

func set_balanced(balanced: bool, left_heavy: bool) -> void:
	is_balanced = balanced
	is_left_heavy = left_heavy
	update_sprite()

# Signal handlers for the plates
func _ready():
	left_plate.connect("body_entered", Callable(self, "_on_body_entered_left"))
	left_plate.connect("body_exited", Callable(self, "_on_body_exited_left"))
	right_plate.connect("body_entered", Callable(self, "_on_body_entered_right"))
	right_plate.connect("body_exited", Callable(self, "_on_body_exited_right"))
	label.text = "balanced"
	audio_player.stream = sound

func _process(delta: float) -> void:
	if is_done and not has_added_time:
		print("Added some time")
		timer.add_time(added_time)
		has_added_time = true
		is_done = false
		audio_player.play()

# Body entered on left plate
func _on_body_entered_left(body):
	if body.is_in_group("items"):
		left_weight += body.weight  # Add item weight to left plate
		update_balance_visual()

# Body exited on left plate
func _on_body_exited_left(body):
	if body.is_in_group("items"):
		left_weight -= body.weight  # Subtract item weight from left plate
		update_balance_visual()

# Body entered on right plate
func _on_body_entered_right(body):
	if body.is_in_group("items"):
		print("joined right")
		right_weight += body.weight  # Add item weight to right plate
		update_balance_visual()

# Body exited on right plate
func _on_body_exited_right(body):
	if body.is_in_group("items"):
		right_weight -= body.weight  # Subtract item weight from right plate
		update_balance_visual()

# Update the balance text based on the weights
func update_balance_visual() -> void:
	if left_weight > right_weight:
		set_balanced(false,true)
		label.text = "Left side heavier"
	elif right_weight > left_weight:
		set_balanced(false, false)
		label.text = "Right side heavier"
	else:
		set_balanced(true, false)
		label.text = "Balanced"
		if left_weight > 0 or right_weight > 0:
			print("Perfect")
			is_done = true
