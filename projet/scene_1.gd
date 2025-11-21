extends Node2D

@onready var fade = $CanvasLayer/ColorRect

func _ready():
	# Créer le fade s'il n'existe pas
	if not fade:
		var canvas = CanvasLayer.new()
		add_child(canvas)
		fade = ColorRect.new()
		fade.color = Color.BLACK
		fade.set_anchors_preset(Control.PRESET_FULL_RECT)
		canvas.add_child(fade)
	
	# Fade in au début de la scène
	fade.color.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, 0.5)

func fade_to_scene(scene_path: String):
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(scene_path)
