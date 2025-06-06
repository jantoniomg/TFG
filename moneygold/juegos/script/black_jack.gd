extends Node2D
class_name JuegoBlackjack

const EscenaCarta := preload("res://juegos/escenasOanimaciones/carta.tscn")
var palos = ["cardClubs", "cardDiamonds", "cardHearts", "cardSpades"]
var rangos = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "J", "Q", "K"]
var cartas = []
var cartas_crupier = []
var indice_carta : int = 1
var pos_x_jugador : int = 50.0
var pos_x_crupier : int = 50.0
const Y_JUGADOR : int = 100
const Y_CRUPIER : int = -100
var puntos_jugador : int = 0
var puntos_crupier : int = 0
var apuesta_utilizada: int = 0

func _ready():
	apuesta_utilizada = CargarDatos.apuestaActual
	CargarDatos.apuesta_actualizada.connect(_on_apuesta_actualizada)
	CargarDatos.dinero_updated.connect(_on_dinero_actualizado)

	inicializar_baraja()
	ocultar_botones()
	resetear_juego_variables()
	$Jugar.disabled = true

func _on_apuesta_actualizada(valor: int) -> void:
	$Jugar.disabled = valor == 0

func _on_dinero_actualizado(valor: int) -> void:
	if valor <= 0:
		$Jugar.disabled = true


func resetear_juego_variables():
	indice_carta = 1
	pos_x_jugador = 50.0
	pos_x_crupier = 50.0
	puntos_jugador = 0
	puntos_crupier = 0
	cartas_crupier.clear()
	actualizar_puntos()

func inicializar_baraja():
	randomize()
	rangos.shuffle()
	palos.shuffle()

	for palo in palos:
		for rango in rangos:
			var carta = EscenaCarta.instantiate()
			carta.rango = rango
			carta.palo = palo

			if rango in ["2", "3", "4", "5", "6", "7", "8", "9"]:
				carta.valor = int(rango)
			elif rango == "A":
				carta.valor = 1
			elif rango == "Q":
				carta.valor = 10
			elif rango == "J":
				carta.valor = 11
			else:
				carta.valor = 12

			carta.boca_abajo = true
			carta.add_to_group("cartas")
			call_deferred("add_child", carta)

func mostrar_botones_juego():
	$Pedir.visible = true
	$Pasar.visible = true
	$Jugar.visible = false
	$Reiniciar.visible = true

func ocultar_botones():
	$Pedir.visible = false
	$Pasar.visible = false
	$Jugar.visible = true
	$Jugar.disabled = false
	$Reiniciar.visible = false

func agregar_carta_jugador():
	var carta := obtener_siguiente_carta()
	carta.position = Vector2(pos_x_jugador, Y_JUGADOR)
	carta.boca_abajo = false
	pos_x_jugador += 100
	puntos_jugador += carta.valor
	actualizar_puntos()
	if puntos_jugador > 21:
		perder()

func agregar_carta_crupier(boca_arriba := true):
	var carta = obtener_siguiente_carta()
	carta.position = Vector2(pos_x_crupier, Y_CRUPIER)
	carta.boca_abajo = not boca_arriba
	cartas_crupier.append(carta)
	pos_x_crupier += 100

	if boca_arriba:
		puntos_crupier += carta.valor

	actualizar_puntos()

func actualizar_puntos():
	$PuntosJugador.text = CargarDatos.nombreJugador + ": " + str(puntos_jugador)

	if cartas_crupier.size() > 0 and not cartas_crupier[0].boca_abajo:
		$PuntosCrupier.text = "Crupier: %s" % puntos_crupier
	else:
		$PuntosCrupier.text = "Crupier: ¿?"

func obtener_siguiente_carta() -> Node:
	if indice_carta > get_child_count():
		print("No quedan cartas en la baraja")
		return null
	var carta := get_child(get_child_count() - indice_carta)
	indice_carta += 1
	return carta

func ganar():
	CargarDatos.dineroFisico += apuesta_utilizada * 2
	await CargarDatos.guardar_datos_en_firestore()
	ocultar_botones()
	mostrar_boton_reiniciar()

func perder():
	ocultar_botones()
	mostrar_boton_reiniciar()

func empate():
	ocultar_botones()
	mostrar_boton_reiniciar()

func verificar_resultado():
	if puntos_crupier > 21 or puntos_jugador > puntos_crupier:
		ganar()
	elif puntos_jugador == puntos_crupier:
		empate()
	else:
		perder()

func _on_jugar_pressed() -> void:
	if CargarDatos.apuestaActual <= 0:
		print("⚠ No has seleccionado una apuesta.")
		return

	apuesta_utilizada = CargarDatos.apuestaActual
	CargarDatos.dineroFisico -= apuesta_utilizada
	await CargarDatos.guardar_datos_en_firestore()

	CargarDatos.apuestaBotonSeleccionado = ""
	CargarDatos.apuestaActual = 0

	jugar()

func jugar() -> void:
	resetear_juego_variables()  
	agregar_carta_jugador()
	agregar_carta_jugador()
	agregar_carta_crupier(false)
	agregar_carta_crupier(false)
	mostrar_botones_juego()
	$Reiniciar.visible = false

func _on_pedir_pressed() -> void:
	agregar_carta_jugador()

func _on_pasar_pressed() -> void:
	for carta in cartas_crupier:
		if carta.boca_abajo:
			carta.boca_abajo = false
			puntos_crupier += carta.valor

	actualizar_puntos()

	while puntos_crupier < 17:
		await get_tree().create_timer(0.8).timeout
		agregar_carta_crupier(true)
	verificar_resultado()
	while puntos_crupier < 17:
		await get_tree().create_timer(0.8).timeout
		agregar_carta_crupier()

	verificar_resultado()
	
func mostrar_boton_reiniciar():
		$Reiniciar.visible = true
		$Jugar.disabled = true
		$Jugar.visible = false

func _on_reiniciar_pressed() -> void:
	reiniciar_juego()
	$Jugar.disabled = false
	$Reiniciar.visible = false


func reiniciar_juego():
	for carta in get_tree().get_nodes_in_group("cartas"):
		carta.queue_free()

	cartas.clear()
	cartas_crupier.clear()
	indice_carta = 1
	pos_x_jugador = 50.0
	pos_x_crupier = 50.0
	puntos_jugador = 0
	puntos_crupier = 0

	$PuntosJugador.text = CargarDatos.nombreJugador + ": 0" 
	$PuntosCrupier.text = "Crupier: ¿?"
	inicializar_baraja()
	ocultar_botones()
