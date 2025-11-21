extends Node2D

var total_pieces = 0
var collected_pieces = 0

@onready var coin_sound = $coinS
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
	
	# Fade in au début
	fade.color.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, 0.5)
	
	var pieces = get_tree().get_nodes_in_group("pieces")
	print("Toutes les pièces trouvées :", pieces)
	total_pieces = pieces.size()
	collected_pieces = 0
	print("Total de pièces =", total_pieces)
	
	for p in pieces:
		if p.has_signal("piece_collected"):
			print("Connexion OK pour :", p)
			p.piece_collected.connect(_on_piece_collected)
		else:
			print("❌ Mauvais node dans le groupe 'pieces' :", p)

func _on_piece_collected():
	collected_pieces += 1
	print("Pièce ramassée :", collected_pieces, "/", total_pieces)
	
	if coin_sound:
		coin_sound.play()
	
	if collected_pieces >= total_pieces:
		print("🔥 Toutes les pièces ramassées → changement de scène !")
		await _fade_to_scene("res://scene_3.tscn")

func _fade_to_scene(scene_path: String):
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(scene_path)
