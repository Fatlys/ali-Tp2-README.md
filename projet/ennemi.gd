extends CharacterBody2D

@export var speed = 100
@export var patrol_delay = 1.0

@onready var sprite = $AnimatedSprite2D

var direction = 1

func _ready():
	_change_direction_loop()

func _change_direction_loop():
	while true:
		await get_tree().create_timer(patrol_delay).timeout
		direction *= -1
		sprite.flip_h = direction < 0

func _physics_process(delta):
	velocity.x = direction * speed
	move_and_slide()
	sprite.play("ennemi-sprint")
