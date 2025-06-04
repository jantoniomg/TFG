extends Node2D

@onready var animacion_palanca : AnimatedSprite2D = $animacionPalanca

func _ready() -> void:
	pass

func _on_palanca_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not event.is_action_pressed("click"):
		return

	var apuesta = CargarDatos.apuestaActual

	if apuesta <= 0:
		print("⚠ No has seleccionado una apuesta.")
		return

	if CargarDatos.dineroFisico < apuesta:
		print("❌ No tienes suficiente dinero.")
		return

	CargarDatos.dineroFisico -= apuesta
	await CargarDatos.guardar_datos_en_firestore()

	animacion_palanca.play("tirar")
