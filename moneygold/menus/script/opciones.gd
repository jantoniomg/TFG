extends Control

func _on_volumen_pressed() -> void:
	pass 

func _on_resolucion_pressed() -> void:
	pass 

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")
