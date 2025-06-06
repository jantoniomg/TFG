extends Node2D

var resultados_jugador: Array[int] = []
var resultados_casa: Array[int] = []
var total_dados_recibidos := 0
var apuesta_utilizada: int = 0  
@onready var nombre_label: Label = $ColorRect2/jugador   
@onready var dados_jugador = [$ColorRect2/dadoJugador1, $ColorRect2/dadoJugador2]
@onready var dados_casa = [$ColorRect/dadoCasa1, $ColorRect/dadoCasa2]

func _ready():
	nombre_label.text = CargarDatos.nombreJugador
	$jugar.disabled = true
	for dado in dados_jugador + dados_casa:
		dado.resultado_final.connect(_on_dado_resultado)

	CargarDatos.apuesta_actualizada.connect(_on_apuesta_actualizada)
	CargarDatos.dinero_updated.connect(_on_dinero_actualizado)
	
func _on_apuesta_actualizada(valor: int) -> void:
	$jugar.disabled = valor == 0
	
func _on_dinero_actualizado(valor: int) -> void:
	if valor <= 0:
		$jugar.disabled = true

func _on_jugar_pressed() -> void:
	if CargarDatos.apuestaActual <= 0:
		print("⚠ No has seleccionado una apuesta.")
		return

	apuesta_utilizada = CargarDatos.apuestaActual
	CargarDatos.dineroFisico -= apuesta_utilizada
	await CargarDatos.guardar_datos_en_firestore()

	resultados_jugador.clear()
	resultados_casa.clear()
	total_dados_recibidos = 0

	for dado in dados_jugador + dados_casa:
		dado.tirar()

	CargarDatos.apuestaBotonSeleccionado = ""
	CargarDatos.apuestaActual = 0  



func _on_dado_resultado(origen: String, valor: int) -> void:
	total_dados_recibidos += 1

	if origen.begins_with("dadoJugador"):
		resultados_jugador.append(valor)
	elif origen.begins_with("dadoCasa"):
		resultados_casa.append(valor)

	if total_dados_recibidos == 4:
		var total_jugador = resultados_jugador[0] + resultados_jugador[1]
		var total_casa = resultados_casa[0] + resultados_casa[1]

		print("🧍 Jugador sacó:", resultados_jugador, "Total:", total_jugador)
		print("🏠 Casa sacó:", resultados_casa, "Total:", total_casa)

		if total_jugador > total_casa:
			CargarDatos.dineroFisico += apuesta_utilizada * 2 
			await CargarDatos.guardar_datos_en_firestore()
		else:
			print("💀 Perdiste.")
