extends CharacterBody2D

@export var speed = 200
@export var jump_force = -450
@export var gravity = 900

@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var music = $MusicS
@onready var jump_sound = $JumpS
@onready var attack_sound = $AttackS
@onready var death_sound = $DeathS
@onready var area = $Area2D

var is_attacking = false
var start_position = Vector2.ZERO

func _ready():
	start_position = global_position
	music.play()
	area.body_entered.connect(_on_area_body_entered)
	area.get_node("CollisionShape2D").disabled = false

func _physics_process(delta):
	if is_attacking:
		move_and_slide()
		return

	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Mouvement horizontal
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
	velocity.x = direction * speed

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		jump_sound.play()

	# Attaque
	if Input.is_action_just_pressed("attack"):
		_attack()

	# Animations
	if is_attacking:
		sprite.play("attack")
	elif not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

	# Orientation et position de la zone d’attaque
	if direction != 0:
		sprite.flip_h = direction < 0
		area.position.x = 20 if direction > 0 else -20

	move_and_slide()

func _attack():
	is_attacking = true
	velocity.x = 0
	attack_sound.play()
	sprite.play("attack")
	await sprite.animation_finished
	is_attacking = false

# Mort avec shake + recul + flash + son + respawn immédiat
func _on_area_body_entered(body):
	if body.is_in_group("ennemi"):
		velocity = Vector2.ZERO
		if death_sound:
			death_sound.play()
		await shake_and_recoil()
		await flash_red()
		global_position = start_position

func shake_and_recoil():
	if camera:
		var original_pos = camera.offset
		for i in range(5):
			camera.offset = Vector2(randf()*20-10, randf()*20-10)
			await get_tree().create_timer(0.05).timeout
		camera.offset = original_pos
		# recul du Player
		global_position += Vector2(-50, 0)

func flash_red():
	var original_modulate = sprite.modulate
	sprite.modulate = Color(1, 0, 0)  # rouge
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = original_modulate
