extends Node2D

var total_pieces = 0
var collected_pieces = 0
var total_enemies = 0
var killed_enemies = 0

@onready var coin_sound = $coinS

func _ready():
	# Compter et connecter les pièces
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
	
	# Compter les ennemis
	var enemies = get_tree().get_nodes_in_group("ennemi")
	total_enemies = enemies.size()
	killed_enemies = 0
	print("Total d'ennemis =", total_enemies)

func _on_piece_collected():
	collected_pieces += 1
	print("Pièce ramassée :", collected_pieces, "/", total_pieces)
	
	# Jouer le son de pièce
	if coin_sound:
		coin_sound.play()
	
	_check_level_complete()

func on_enemy_killed():
	killed_enemies += 1
	print("Ennemi tué :", killed_enemies, "/", total_enemies)
	_check_level_complete()

func _check_level_complete():
	if collected_pieces >= total_pieces and killed_enemies >= total_enemies:
		print("🔥 Niveau terminé! Toutes les pièces et ennemis éliminés!")
		get_tree().change_scene_to_file("res://scene_4.tscn")
