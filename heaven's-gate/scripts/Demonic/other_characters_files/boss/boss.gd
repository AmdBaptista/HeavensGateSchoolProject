extends CharacterBody2D

@export var mov_speed = 100

@onready var demon_player = %Demon
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $CanvasLayer/ProgressBar
@export var boss_dead = false

var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")

@onready var hitboxcollision = $attack/CollisionShape2D
@onready var hurtboxcollision = $hurbox/CollisionShape2D
@onready var collision = $CollisionShape2D
var collisionx
var hitboxcollisionx
var hurtboxcollisionx

var direction : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collisionx = collision.position.x
	hitboxcollisionx = hitboxcollision.position.x
	hurtboxcollisionx = hurtboxcollision.position.x
	set_physics_process(false)
	hitboxcollision.disabled = true
	
func _process(delta: float) -> void:
	direction = demon_player.position - position
	
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false
	collision.position.x = flipx(collisionx,collision.position.x,animated_sprite.flip_h)
	hitboxcollision.position.x = flipx(hitboxcollisionx,hitboxcollision.position.x,animated_sprite.flip_h)
	hurtboxcollision.position.x = flipx(hurtboxcollisionx,hurtboxcollision.position.x,animated_sprite.flip_h)

func _physics_process(delta: float) -> void:
	velocity.x = (direction.normalized() * mov_speed).x
	move_and_collide(velocity * delta)

func flipx(inicialposx, actualpos, fliph):
	if fliph:
		if actualpos == inicialposx:
			actualpos = -inicialposx
	else:
		if actualpos == -inicialposx:
			actualpos = inicialposx
	return actualpos


func _on_hurbox_hurt(damage: int, is_critical: bool) -> void:
	health -= damage
