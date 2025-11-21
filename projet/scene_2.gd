extends Node2D

var total_pieces = 0
var collected_pieces = 0

@onready var coin_sound = $coinS  # Ton AudioStreamPlayer dans la scène

func _ready():
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
	
	# Jouer le son de pièce
	if coin_sound:
		coin_sound.play()
	
	if collected_pieces >= total_pieces:
		print("🔥 Toutes les pièces ramassées → changement de scène !")
		get_tree().change_scene_to_file("res://scene_3.tscn")
