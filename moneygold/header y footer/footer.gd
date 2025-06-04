extends Node2D

var color_selected : Color = Color.YELLOW
var color_not_selected : Color = Color.DIM_GRAY

var valores_apuestas = {
	"apuesta1": 50,
	"apuesta2": 100,
	"apuesta3": 150,
	"apuesta4": 200,
	"apuesta5": 250,
	"apuesta6": -1 
}

func _ready() -> void:
	for child in get_children():
		if child is Button:
			child.pressed.connect(_on_any_button_pressed.bind(child.name))
	update_botones_disponibles()
	CargarDatos.dinero_updated.connect(update_botones_disponibles)

func update_botones_disponibles() -> void:
	var dinero_disponible = CargarDatos.dineroFisico
	var seleccionado_aun_valido := false

	for child in get_children():
		if child is Button:
			var btn_name = child.name.strip_edges()
			var valor = valores_apuestas.get(btn_name, 0)

			if btn_name == "apuesta6":
				child.disabled = dinero_disponible <= 0
			else:
				child.disabled = dinero_disponible < valor

			if btn_name == CargarDatos.apuestaBotonSeleccionado and not child.disabled:
				seleccionado_aun_valido = true

	if not seleccionado_aun_valido:
		for child in get_children():
			if child is Button:
				child.add_theme_color_override("font_color", color_not_selected)
				child.add_theme_color_override("font_focus_color", color_not_selected)
				child.add_theme_color_override("font_hover_color", color_not_selected)

		CargarDatos.apuestaBotonSeleccionado = ""
		CargarDatos.apuestaActual = 0


func _on_any_button_pressed(btn_name: String) -> void:
	if CargarDatos.dineroFisico <= 0:
		print("⚠ No puedes apostar con 0 dinero.")
		return

	var boton_presionado = get_node(btn_name) as Button
	if boton_presionado.disabled:
		return

	for child in get_children():
		if child is Button:
			var is_selected = child.name == btn_name
			child.add_theme_color_override("font_color", color_selected if is_selected else color_not_selected)
			child.add_theme_color_override("font_focus_color", color_selected if is_selected else color_not_selected)
			child.add_theme_color_override("font_hover_color", color_selected if is_selected else color_not_selected)

	if btn_name == "apuesta6":
		if CargarDatos.dineroFisico <= 0:
			print("⚠ No puedes hacer All in con 0 dinero.")
			return
		CargarDatos.apuestaActual = CargarDatos.dineroFisico
	else:
		var valor = valores_apuestas.get(btn_name, 0)
		if CargarDatos.dineroFisico < valor:
			print("⚠ No tienes suficiente dinero para esta apuesta.")
			return
		CargarDatos.apuestaActual = valor
	CargarDatos.apuestaBotonSeleccionado = btn_name
