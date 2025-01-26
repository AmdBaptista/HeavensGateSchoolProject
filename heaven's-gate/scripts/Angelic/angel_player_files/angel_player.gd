extends CharacterBody2D

@export var leaving := false

@export var speed := 130.0
@export var gravity := 1000.0
@export var jump_strength := -350
@export var max_air_jumps := 1
@export var max_wall_jumps := 1
@export var max_air_jumps_wall_recharges := 1
@export var wall_jump_cooldown_duration := 0.1  # Duration of the cooldown in seconds
@export var knockback_force := 150.0  # Force applied to push the player off the wall
var last_jump_direction = 0
var wall_jump_cooldown := 0.0  # Cooldown timer

@export var controls: Resource = null

var numb_air_jumps := 0
var numb_wall_jumps := 0
var numb_air_jumps_wall_resets := 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var carried_item_holder: Node2D = $CarriedItemHolder
@onready var camera : Camera2D = $Camera2D

@export var dead = false
@export var is_actually_dead = false

var carried_item: Node = null  # Reference to the currently carried item

@onready var pickup_area: Area2D = $PickupArea

func get_overlapping_areas() -> Array:
	return pickup_area.get_overlapping_areas()


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		numb_air_jumps = 0
		last_jump_direction = 0
	
	# Get input direction
	var direction = Input.get_axis("p1_move_left", "p1_move_right")
	
	# Wall jump cooldown timer
	if wall_jump_cooldown > 0:
		wall_jump_cooldown -= delta  # Decrease cooldown over time
		# If cooldown ends, allow movement again
		if wall_jump_cooldown <= 0:
			wall_jump_cooldown = 0
	
	# Handle jump
	if Input.is_action_just_pressed("p1_jump"):
		if is_on_floor():
			velocity.y = jump_strength
			numb_air_jumps = 0
		elif is_on_wall_only() && direction != last_jump_direction && wall_jump_cooldown <= 0:
			velocity.y = jump_strength
			numb_air_jumps = 0
			last_jump_direction = direction
			# Apply knockback force to push the character away from the wall
			if direction:
				velocity.x = knockback_force  # Push to the right
			else:
				velocity.x = -knockback_force  # Push to the left

			# Apply movement
			if direction:
				velocity.x += direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
			
			# Start cooldown after a successful wall jump
			wall_jump_cooldown = wall_jump_cooldown_duration
		elif numb_air_jumps < max_air_jumps:
			velocity.y = jump_strength
			numb_air_jumps = numb_air_jumps + 1
	
	# Flip Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	# Apply movement, but block direction toward the wall if on cooldown
	if direction and wall_jump_cooldown == 0:
		velocity.x = direction * speed
	elif not direction and wall_jump_cooldown == 0:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	# Picking up and placing items
	if Input.is_action_just_pressed("p1_pickup"):
		if carried_item:
			place_item()
		else:
			pick_up_item()
			
	# Ensure the carried item follows the player
	if carried_item:
		carried_item.global_position = carried_item_holder.global_position
			
func pick_up_item():
	if not carried_item_holder:
		print("CarriedItemHolder is null. Ensure the node is properly set.")
		return
	
	# Check for items in range
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.has_method("disable_collision") and carried_item == null:
			carried_item = area
			var item_global_position = carried_item.global_position  # Save its global position
			carried_item_holder.add_child(carried_item)  # Attach item to carried_item_holder
			carried_item.global_position = item_global_position  # Restore its global position
			carried_item.disable_collision()  # Disable the item's collision
			return


func place_item():
	# Drop the item at the character's current position
	if carried_item:
		carried_item_holder.remove_child(carried_item)  # Detach the item
		carried_item.enable_collision()  # Re-enable the item's collision
		carried_item.global_position = global_position  # Place it at the character's position
		carried_item = null

func setCameraLimits(left:int,top:int,right:int,bottom:int):
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom
