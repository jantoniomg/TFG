extends Node

signal dinero_updated
signal banco_updated
signal apuesta_actualizada

var jugador_logros: Array = []
var logros_disponibles: Dictionary = {}

var apuestaActual : int = 0 : set = set_apuestaActual
var apuestaBotonSeleccionado : String = ""

var dineroFisico : int = 0 : set = dinero_setter
var dineroBanco : int = 0 : set = banco_setter
var nombreJugador : String = ""
var emailJugador : String = ""
var uid : String = ""

func set_apuestaActual(value):
		apuestaActual = value
		emit_signal("apuesta_actualizada", apuestaActual)

func dinero_setter(new_value):
	dineroFisico = new_value
	emit_signal("dinero_updated", dineroFisico)

	if dineroFisico <= 0:
		apuestaActual = 0
		apuestaBotonSeleccionado = ""
		emit_signal("apuesta_actualizada", 0)

func banco_setter(new_value):
	dineroBanco = new_value
	emit_signal("banco_updated")

func cargar_logros():
	var collection = Firebase.Firestore.collection("Logros")
	var task = collection.get_all()
	var resultado = await task.task_finished

	if resultado.error == "":
		for doc in resultado.documents:
			logros_disponibles[doc.id] = doc.fields
		print("✅ Logros cargados:", logros_disponibles.keys())
	else:
		print("❌ Error al cargar logros:", resultado.error)


func guardar_datos_en_firestore():
	if uid == "":
		print("⚠ No hay UID para guardar los datos.")
		return

	var jugador_data: Dictionary = {
		"DineroFisico": dineroFisico,
		"DineroBanco": dineroBanco,
		"Nombre": nombreJugador,
		"Email": emailJugador,
	}

	var collection: FirestoreCollection = Firebase.Firestore.collection("Jugadores")
	var task: FirestoreTask = collection.update(uid, jugador_data)

	var finished_task: FirestoreTask = await task.task_finished
	if finished_task.error.is_empty():
		print("✅ Datos guardados correctamente en Firestore.")
	else:
		print("❌ Error al guardar datos en Firestore:", finished_task.error)
