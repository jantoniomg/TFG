extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_jugar_pressed() -> void:
	var apuesta = CargarDatos.apuestaActual
	CargarDatos.dineroFisico -= apuesta
	await CargarDatos.guardar_datos_en_firestore()
	roll_dices()

func roll_dices():
	pass
