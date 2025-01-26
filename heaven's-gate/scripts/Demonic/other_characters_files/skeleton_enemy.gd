extends CharacterBody2D

class_name SkeletonEnemy

@export var speed = 6500
var gravity = 1000
var dir : Vector2

@export var jump_strength := -500

var knockBack_force = -100


@export var health = 8
@export var max_health = 8
var min_health = 0

var is_skeleton_chase : bool = false

var dead = false
@export var taking_damage = false

@onready var attack_hitbox : Area2D = $hitbox

var is_roaming = false

@onready var hurtboxCollider : CollisionShape2D = $"hurbox/CollisionShape2D"
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var direction_timer : Timer = $DirectionTimer
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var demon_player = %Demon
@onready var chase_time : Timer = $ChaseTime
@onready var ray_cast_wall : RayCast2D = $RayCast2D

var hurtboxcolliderx
var collisionShapex
var rayCastWallx

func _ready() -> void:
	hurtboxcolliderx = hurtboxCollider.position.x
	collisionShapex = collisionShape.position.x
	rayCastWallx = ray_cast_wall.position.x


func _on_direction_timer_timeout() -> void:
	direction_timer.wait_time = choose([2,2.5,3,3.5])
	if !is_skeleton_chase:
		dir = choose([Vector2.RIGHT,Vector2.LEFT,Vector2.ZERO])
		velocity.x = 0


func choose(choices: Array):
	choices.shuffle()
	return choices.front()


func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	move_and_slide()

	if dir.x > 0:
		animated_sprite.flip_h = false
	elif dir.x < 0:
		animated_sprite.flip_h = true
	attack_hitbox.flip_hitbox(animated_sprite.flip_h)
	collisionShape.position.x = flipx(collisionShapex,collisionShape.position.x,animated_sprite.flip_h)
	hurtboxCollider.position.x = flipx(hurtboxcolliderx,hurtboxCollider.position.x,animated_sprite.flip_h)
	ray_cast_wall.position.x = flipx(rayCastWallx,ray_cast_wall.position.x,animated_sprite.flip_h)
	if(ray_cast_wall.position.x < 0):
		if ray_cast_wall.target_position.x < 0:
			ray_cast_wall.target_position.x *=-1 
	else:
		if ray_cast_wall.target_position.x > 0:
			ray_cast_wall.target_position.x *=-1 
		

	if animation_player.current_animation != "attack" and animation_player.current_animation != "hurt" and !dead :
		if is_on_floor():
			if velocity.x == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")

	var distance_to_player = demon_player.global_position.distance_to(global_position)
	
	
	if distance_to_player < 250 or chase_time.time_left > 0:
		is_skeleton_chase = true
	else:
		is_skeleton_chase = false

func move(delta: float) -> void:
	if !dead:
		if !is_skeleton_chase:
			velocity.x = dir.x * speed * delta
		elif is_skeleton_chase and !taking_damage:
			dir = global_position.direction_to(demon_player.global_position)
			velocity.x = dir.x * speed * delta * 2
		elif taking_damage:
			var knockback_dir = global_position.direction_to(demon_player.global_position) * knockBack_force
			velocity.x = knockback_dir.x
		if !is_on_floor():
			velocity.y += gravity * delta
		if ray_cast_wall.is_colliding() and ray_cast_wall.get_collider() != demon_player and is_on_floor():
			velocity.y = jump_strength
		is_roaming = true
	elif dead:
		velocity.x = 0
	
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox") and !dead:
		if animation_player.current_animation == "hurt":
			animation_player.call_deferred("queue", "attack")
		else:
			animation_player.call_deferred("play", "attack")


func _on_hurbox_hurt(damage: int, is_critical: bool) -> void:
	if !dead:
		if animation_player.current_animation == "attack":
			animation_player.queue("hurt")
		else:
			animation_player.play("hurt")
		take_damage(damage)
	
func take_damage(damage:int):
	if !is_skeleton_chase:
		is_skeleton_chase = true
		chase_time.start()
	health -= damage
	if health <= min_health:
		dead = true
		animation_player.play("death")

func flipx(inicialposx, actualpos, fliph):
	if fliph:
		if actualpos == inicialposx:
			actualpos = -inicialposx
	else:
		if actualpos == -inicialposx:
			actualpos = inicialposx
	return actualpos
	
