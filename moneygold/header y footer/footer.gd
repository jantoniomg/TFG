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

func update_botones_disponibles() -> void:
	var dinero_disponible = CargarDatos.dineroFisico

	for child in get_children():
		if child is Button:
			var btn_name = child.name.strip_edges()
			if btn_name == "apuesta6":
				child.disabled = dinero_disponible <= 0
			else:
				var valor = valores_apuestas.get(btn_name, 0)
				child.disabled = dinero_disponible < valor

func _on_any_button_pressed(btn_name: String) -> void:
	var boton_presionado = get_node(btn_name) as Button
	if boton_presionado.disabled:
		return

	for child in get_children():
		if child is Button:
			var is_selected = child.name == btn_name
			child.add_theme_color_override("font_color", color_selected if is_selected else color_not_selected)
			child.add_theme_color_override("font_focus_color", color_selected if is_selected else color_not_selected)
			child.add_theme_color_override("font_hover_color", color_selected if is_selected else color_not_selected)

	match btn_name:
		"All in":
			CargarDatos.apuestaActual = CargarDatos.dineroFisico
		_:
			var valor = valores_apuestas.get(btn_name, 0)
			CargarDatos.apuestaActual = valor
	CargarDatos.apuestaBotonSeleccionado = btn_name
