extends Area2D

signal piece_collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # si le perso touche la pièce
		emit_signal("piece_collected")  # prévenir la scène
		queue_free()  # détruire la pièce
