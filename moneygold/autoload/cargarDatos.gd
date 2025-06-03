extends Node

signal dinero_updated
signal banco_updated
signal apuesta_actualizada

var apuestaActual : int = 0 : set = set_apuestaActual
var apuestaBotonSeleccionado : String = ""

# Variables que usaremos en todo el juego y la apuesta del footer
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

func banco_setter(new_value):
	dineroBanco = new_value
	emit_signal("banco_updated")

# Guarda los datos actualizados del jugador en Firestore
func guardar_datos_en_firestore():
	# Aseguramos que tenemos el UID antes de guardar
	if uid == "":
		print("⚠ No hay UID para guardar los datos.")
		return
	
	# Creamos el diccionario con los datos actualizados
	var jugador_data: Dictionary = {
		"DineroFisico": dineroFisico,
		"DineroBanco": dineroBanco,
		"Nombre": nombreJugador,
		"Email": emailJugador
	}

	# Obtenemos la colección de Firestore
	var collection: FirestoreCollection = Firebase.Firestore.collection("Jugadores")
	var task: FirestoreTask = collection.update(uid, jugador_data)

	# Esperamos a que se complete la tarea y damos feedback
	var finished_task: FirestoreTask = await task.task_finished
	if finished_task.error.is_empty():
		print("✅ Datos guardados correctamente en Firestore.")
	else:
		print("❌ Error al guardar datos en Firestore:", finished_task.error)
