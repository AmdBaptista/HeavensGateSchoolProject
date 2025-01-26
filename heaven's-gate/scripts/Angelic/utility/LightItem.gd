# LightItem.gd
extends Area2D

@export var light_beam_length := 500  # Length of the light beam
@export var light_color := Color(1, 1, 0)  # Light color (yellow for example)

var emitting_light := true  # Whether the item is emitting light
var target_item: Node = null  # The item to hit to stop emitting light

@onready var beam = $Polygon2D  # Assuming you're using a Polygon2D for the beam

# Signal when light completes the process
signal completed()

func _ready():
	# Set up the initial state of the beam
	beam.color = light_color

func _process(delta):
	if emitting_light:
		update_beam()

func update_beam():
	# Calculate the beam direction based on the rotation of the item
	var beam_end = position + Vector2(1, 0).rotated(rotation) * light_beam_length
	
	# Update the beam points (a rectangle or line, depending on your needs)
	beam.points = [position, beam_end]

# In the original item script

func _on_BeamHit(other: Node):
	if other is Area2D:  # Replace LightItem with Area2D
		other.emit_light(beam.rotation)
	elif other == target_item:
		emitting_light = false
		print("Completed")
		emit_signal("completed")


func emit_light(new_rotation):
	# Starts emitting light at the new direction
	rotation = new_rotation
	emitting_light = true
