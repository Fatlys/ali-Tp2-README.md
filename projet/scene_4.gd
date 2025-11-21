extends Node2D

@onready var victory_sound = $Victory

func _ready():
	if victory_sound:
		victory_sound.play()
	print("🏆 VICTOIRE!")
