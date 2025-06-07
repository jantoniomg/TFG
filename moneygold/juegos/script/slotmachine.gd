extends Node2D

@onready var animacion_palanca : AnimatedSprite2D = $animacionPalanca
@onready var filas = [$mascara/hilera, $mascara/hilera2, $mascara/hilera3]
var hileras_finalizadas = 0

func _ready() -> void:
	for fila in filas:
		fila.connect("giro_finalizado", Callable(self, "_on_hilera_giro_finalizado"))

func _on_hilera_giro_finalizado():
	hileras_finalizadas += 1
	if hileras_finalizadas == 3:
		await get_tree().process_frame
		detectar_resultado()

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
	$palancaS.play()
	$ganar.stop()
	$perder.stop()
	CargarDatos.dineroFisico -= apuesta
	await CargarDatos.guardar_datos_en_firestore()
	animacion_palanca.play("tirar")

	$mascara/hilera.valores_iniciales()
	$mascara/hilera2.valores_iniciales()
	$mascara/hilera3.valores_iniciales()
	
func detectar_resultado():
	var resultado: Array = []
	
	for fila in filas:
		var centro_y: float = $mascara.global_position.y + $mascara.size.y / 2.0
		fila.centro_visible_y = centro_y
		var tarjeta = fila.obtener_tarjeta_visible()
		resultado.append(tarjeta.icono)

	print("🎰 Resultado (IDs):", resultado)

	if resultado[0] == resultado[1] and resultado[1] == resultado[2]:
		print("🏆 ¡Has ganado con tres iguales!", resultado[0])
		$ganar.play()
	else:
		$perder.play()
		print("😢 No has ganado esta vez")

	var frutas = {
		0: "Sandía",
		1: "Limón",
		2: "Uvas",
		3: "Cerezas",
		4: "Campana",
		5: "Siete"
	}

	print("🎰 Resultado (Nombres):", resultado.map(func(id): return frutas.get(id, "Desconocido")))

	hileras_finalizadas = 0
