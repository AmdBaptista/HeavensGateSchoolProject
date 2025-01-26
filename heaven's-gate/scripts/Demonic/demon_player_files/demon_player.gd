extends CharacterBody2D

class_name Player

@export var leaving := false

@export var normalspeed := 130.0
@export var gravity := 700.0
@export var jump_strength := -400
@export var max_stamina := 10
@export var min_stamina := 0
@export var current_stamina: int = max_stamina
@export var dash_stamina_cost := 1
@export var attack_stamina_cost := 1

var firaball_scene = preload("res://scenes/Demonic/demon_character_file/abilities/fireball.tscn")
@export var fireball_speed = 500
@onready var fireball_shoot : Node2D = $FireballShoot
var fireball_shootx

@onready var regen_sound = $Sounds/regen
@onready var dash_sound = $Sounds/dash


var hearts_list : Array[TextureRect]
var health = 8

@onready var heart_container = $"HealthBar/HBoxContainer"


const dashspeed = 10000


@export var controls: Resource = null

var numb_jumps := 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : Area2D = $hitbox
@onready var camera : Camera2D = $Camera2D

@export var isAttacking = false

var dead = false
@export var is_actually_dead = false


func _ready():
	hitbox.disable_hitbox()
	fireball_shootx = fireball_shoot.position.x

	for child in heart_container.get_children():
		hearts_list.append(child)

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = jump_strength
	
	# Get input direction
	var direction = Input.get_axis("p2_move_left","p2_move_right")
	
	var speed
	# Apply movement
	if direction:
		if Input.is_action_just_pressed("p2_dash") and current_stamina - dash_stamina_cost >= min_stamina and direction != 0:
			dash_sound.playing = true
			speed = dashspeed
			current_stamina = current_stamina - dash_stamina_cost
		else:
			speed = normalspeed
		velocity.x = direction * speed
	else:
		if Input.is_action_just_pressed("p2_dash") and current_stamina - dash_stamina_cost >= min_stamina and direction != 0:
			dash_sound.playing = true
			speed = dashspeed
			current_stamina = current_stamina - dash_stamina_cost
		else:
			speed = normalspeed
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	# Flip Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	hitbox.flip_hitbox(animated_sprite.flip_h)
	flip_fireball_shoot(animated_sprite.flip_h)

 	# Handle attack	
	if Input.is_action_just_pressed("p2_mele_atk") and !isAttacking and current_stamina - attack_stamina_cost >= min_stamina and !dead:
		animation_player.play("melee")
		current_stamina = current_stamina - attack_stamina_cost
	if Input.is_action_just_pressed("p2_range_atk") and !isAttacking and current_stamina - attack_stamina_cost >= min_stamina and !dead:
		animation_player.play("range")
		current_stamina = current_stamina - attack_stamina_cost
		shoot()		
		
	if !dead:
		if animation_player.current_animation != "melee" and animation_player.current_animation != "range" and animation_player.current_animation != "hurt":
			if is_on_floor():
				if direction == 0:
					animation_player.play("idle")
				if direction != 0:
					animation_player.play("walk")
			else:
				animation_player.play("jump")
	
	
	
func shoot():
	var new_fireball = firaball_scene.instantiate()
	get_parent().add_child(new_fireball)
	new_fireball.global_position = fireball_shoot.global_position

	var fireball_direction = Vector2.LEFT if animated_sprite.flip_h else Vector2.RIGHT
	new_fireball.set_deferred("rotation",fireball_direction.angle() + deg_to_rad((-90)))
	new_fireball.linear_velocity = fireball_direction * fireball_speed

func flip_fireball_shoot(fliph:bool):
	if fliph:
		if fireball_shoot.position.x == fireball_shootx:
			fireball_shoot.position.x = -fireball_shootx
	else:
		if fireball_shoot.position.x == -fireball_shootx:
			fireball_shoot.position.x = fireball_shootx

func _on_coin_picked_up() -> void:
	current_stamina = max_stamina

func take_damage():
	if health == 1:
		animation_player.play("dead")
	if health > 0:
		health -= 1
		update_hearts_list()

func update_hearts_list():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health


func _on_hurbox_hurt(damage: int,is_critical:bool) -> void:
	if health == 1:
		dead = true
	take_damage()
	if !dead:
		if animation_player.current_animation == "melee" or animation_player.current_animation == "range":
			animation_player.queue("hurt")
		else:
			animation_player.play("hurt")


func _on_hurbox_regen(area2d: Area2D) -> void:
	if health < hearts_list.size():
		regen_sound.playing = true
		health += 1
		update_hearts_list()
		area2d.queue_free()

func setCameraLimits(left:int,top:int,right:int,bottom:int):
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom
	
func setCameraZoom(zoom):
	camera.zoom.x = zoom
	camera.zoom.y = zoom
