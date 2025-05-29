extends Control




func _on_ruleta_pressed() -> void:
	get_tree().change_scene_to_file("res://juegos/ruleta.tscn")


func _on_black_jack_pressed() -> void:
	get_tree().change_scene_to_file("res://juegos/BlackJack.tscn")


func _on_tragaperras_pressed() -> void:
	get_tree().change_scene_to_file("res://juegos/tragaperras.tscn")
