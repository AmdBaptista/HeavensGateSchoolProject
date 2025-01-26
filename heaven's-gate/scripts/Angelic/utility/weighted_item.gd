extends Area2D

@export var weight := 1.0  # Example property for item weight
@onready var label: Label = $Label

# Add the item to the "items" group so it can be identified by the balance plates
func _ready():
	label.text = str(weight)
	add_to_group("items")

func disable_collision():
	$CollisionShape2D.disabled = true

func enable_collision():
	$CollisionShape2D.disabled = false
