extends CharacterBody2D

@export var speed = 100
@export var patrol_delay = 1.0

@onready var sprite = $AnimatedSprite2D
@onready var death_sound = $DeathS

var direction = 1
var is_dead = false

func _ready():
	add_to_group("ennemi")  # ← Ajoute cette ligne pour être sûr
	_change_direction_loop()

func _change_direction_loop():
	while true:
		await get_tree().create_timer(patrol_delay).timeout
		if not is_dead:
			direction *= -1
			sprite.flip_h = direction < 0

func _physics_process(_delta):
	if is_dead:
		velocity = Vector2.ZERO
		return
	velocity.x = direction * speed
	move_and_slide()
	sprite.play("ennemi-sprint")

func kill():
	if is_dead:
		return
	is_dead = true
	
	# Jouer le son de mort
	if death_sound:
		death_sound.play()
	
	sprite.play("ennemi-death")
	await sprite.animation_finished
	
	# Notifier la scène qu'un ennemi a été tué
	var scene = get_tree().current_scene
	if scene and scene.has_method("on_enemy_killed"):
		scene.on_enemy_killed()
	
	# L'ennemi disparaît
	queue_free() 
