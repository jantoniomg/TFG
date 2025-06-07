extends Control

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menuscene/menuJuegos.tscn")

func _on_banco_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menuscene/sacarDinero.tscn")

func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menuscene/Opciones.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
