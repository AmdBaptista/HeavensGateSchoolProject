extends CharacterBody2D

const speed = 100

@export var max_health = 12
@export var health = 10
const min_health = 0
var dead = false

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animatedSprite : AnimatedSprite2D = $AnimatedSprite2D

@export var fireball_speed = 200
@export var fireball_scene = preload("res://scenes/Demonic/other_characters/fire_ball_enemy.tscn")
@onready var attack_timer = $AttackTimer

@onready var demon_player = %Demon
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var randomDirTimer : Timer = $RandomDirTimer
@onready var block_dir_timer : Timer = $BlockDirTimer  # Temporizador para desbloquear direções
@onready var raycasts = {
	"up": $RayCastUp,
	"down": $RayCastDown,
	"left": $RayCastLeft,
	"right": $RayCastRight,
	"up_left": $RayCastLeft_Up,
	"up_right": $RayCastRight_Up,
	"down_left": $RayCastLeft_Down,
	"down_right": $RayCastRight_Down,
}

var is_chasing = false
@onready var chase_timer : Timer = $ChaseTimer

@export var taking_damage = false
const knockBack_force = -100

var dir = Vector2.ZERO
var blocked_directions = []  # Lista de direções bloqueadas temporariamente

func _physics_process(delta: float) -> void:
	var dir_to_player = to_local(nav_agent.get_next_path_position()).normalized()
	var target_dir = Vector2.ZERO
	var distance_to_player = nav_agent.distance_to_target()

	if (distance_to_player >= 250 and distance_to_player <= 450) or chase_timer.time_left > 0:
		is_chasing = true
		target_dir = dir_to_player
	elif distance_to_player < 250:
		is_chasing = true
		target_dir = dir
	else:
		is_chasing = false
		target_dir = dir
		
	if taking_damage:
		target_dir = global_position.direction_to(demon_player.global_position) * knockBack_force
		
	if is_chasing and attack_timer.is_stopped():
		attack_timer.start()

	# Ajustar direção considerando colisões
	target_dir = adjust_direction_with_raycasts(target_dir)
	if !dead:
		velocity = target_dir * speed
		move_and_slide()
		
	if target_dir.x < 0:
		animatedSprite.flip_h = false
	elif target_dir.x > 0:
		animatedSprite.flip_h = true
	
	if animationPlayer.current_animation != "attack" and animationPlayer.current_animation != "hurt" and !dead:
		if target_dir == Vector2.ZERO:
			animationPlayer.play("idle")
		else:
			animationPlayer.play("fly")

func make_path() -> void:
	nav_agent.target_position = demon_player.global_position

func _on_timer_timeout() -> void:
	make_path()

func _on_direction_timer_timeout() -> void:
	randomDirTimer.wait_time = choose([2, 2.5, 3, 3.5])
	dir = choose_random_direction()

func choose_random_direction() -> Vector2:
	var dirx
	var diry
	var random_dir = Vector2.ZERO
	var attempts = 0  # Contador para limitar o número de iterações

	# Tentar gerar uma direção válida que não esteja bloqueada
	while (random_dir == Vector2.ZERO or is_direction_blocked(random_dir)) and attempts < 100:
		dirx = randf_range(-1, 1)
		diry = randf_range(-1, 1)
		random_dir = Vector2(dirx, diry).normalized()
		attempts += 1  # Incrementa o contador

	if attempts >= 100:
		print("Excedeu o número máximo de tentativas.")
		return Vector2.ZERO

	return random_dir

func is_direction_blocked(direction: Vector2) -> bool:
	# Verificar se existem mais de 4 direções bloqueadas
	if blocked_directions.size() > 4:
		print("Muitas direções bloqueadas.")
		return false

	# Verificar combinações específicas que fazem o código travar
	if ("up" in blocked_directions and "down_left" in blocked_directions and "down_right" in blocked_directions) or \
	   ("down" in blocked_directions and "up_left" in blocked_directions and "up_right" in blocked_directions):
		print("Combinação problemática detectada.")
		return false

	# Verificar as condições originais
	if ("up" in blocked_directions and "down" in blocked_directions) or \
	   ("left" in blocked_directions and "right" in blocked_directions) or \
	   ("up_left" in blocked_directions and "down_right" in blocked_directions) or \
	   ("up_right" in blocked_directions and "down_left" in blocked_directions):
		return false

	for key in raycasts:
		if key in blocked_directions:
			match key:
				"up":
					if direction.y < 0:
						return true
				"down":
					if direction.y > 0:
						return true
				"left":
					if direction.x < 0:
						return true
				"right":
					if direction.x > 0:
						return true
				"up_left":
					if direction.x < 0 and direction.y < 0:
						return true
				"up_right":
					if direction.x > 0 and direction.y < 0:
						return true
				"down_left":
					if direction.x < 0 and direction.y > 0:
						return true
				"down_right":
					if direction.x > 0 and direction.y > 0:
						return true
	return false


func adjust_direction_with_raycasts(original_dir: Vector2) -> Vector2:
	var adjusted_dir = original_dir

	for key in raycasts:
		var raycast = raycasts[key]
		if raycast.is_colliding() and key not in blocked_directions:
			# Bloquear a direção que causou colisão
			block_direction_temporarily(key)

			match key:
				"up":
					if adjusted_dir.y < 0:
						adjusted_dir.y = max(0, adjusted_dir.y + 1)
				"down":
					if adjusted_dir.y > 0:
						adjusted_dir.y = min(0, adjusted_dir.y - 1)
				"left":
					if adjusted_dir.x < 0:
						adjusted_dir.x = max(0, adjusted_dir.x + 1)
				"right":
					if adjusted_dir.x > 0:
						adjusted_dir.x = min(0, adjusted_dir.x - 1)
				"up_left":
					if adjusted_dir.y < 0 and adjusted_dir.x < 0:
						adjusted_dir += Vector2(1, 1)
				"up_right":
					if adjusted_dir.y < 0 and adjusted_dir.x > 0:
						adjusted_dir += Vector2(-1, 1)
				"down_left":
					if adjusted_dir.y > 0 and adjusted_dir.x < 0:
						adjusted_dir += Vector2(1, -1)
				"down_right":
					if adjusted_dir.y > 0 and adjusted_dir.x > 0:
						adjusted_dir += Vector2(-1, -1)

			# Escolher uma nova direção aleatória ao colidir
			dir = choose_random_direction()

	return adjusted_dir.normalized()

func block_direction_temporarily(direction: String) -> void:
	# Adiciona a direção à lista de bloqueios
	if direction not in blocked_directions:
		blocked_directions.append(direction)
		block_dir_timer.start(0.5)

func _on_BlockDirTimer_timeout() -> void:
	blocked_directions.clear()

func choose(choices: Array) -> float:
	choices.shuffle()
	return choices.front()


func _on_attack_timer_timeout() -> void:
	if !dead:
		if animationPlayer.current_animation != "hurt":
			shoot()
			if is_chasing:
				attack_timer.start()
	
func shoot():
	if !dead:
		var newFireBall = fireball_scene.instantiate()
		get_parent().add_child(newFireBall)
		newFireBall.global_position = global_position
		
		
		var direction = newFireBall.global_position.direction_to(demon_player.global_position)
		newFireBall.set_deferred("rotation", direction.angle() + deg_to_rad((180)))
		newFireBall.apply_central_impulse(direction * fireball_speed)


func _on_hurbox_hurt(damage: int, is_critical: bool) -> void:
	if !dead:
		animationPlayer.play("hurt")
		take_damage(damage)
		
	
func take_damage(damage):
	if !is_chasing:
		is_chasing = true
		chase_timer.start()
	health -= damage
	if health <= min_health:
		dead = true
		animationPlayer.play("death")
	
