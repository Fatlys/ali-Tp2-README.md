extends Area2D

signal piece_collected

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("piece_collected")
		queue_free()
