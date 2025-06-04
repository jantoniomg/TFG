extends Control

func _ready():
	Firebase.Auth.login_succeeded.connect(on_iniciar_sesion_succeeded)
	Firebase.Auth.login_failed.connect(on_iniciar_sesion_failed)

func _process(delta: float):
	pass

func _on_iniciar_sesion_pressed():
	var email = $VBoxContainer/Usuario.text
	var password = $VBoxContainer/Contraseña.text
	Firebase.Auth.login_with_email_and_password(email, password)
	$VBoxContainer/Estado.text = "Accediendo"

func _on_registrarse_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/registrarse.tscn")

func on_iniciar_sesion_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)

	var uid = auth["localid"]
	var collection: FirestoreCollection = Firebase.Firestore.collection("Jugadores")
	var task: FirestoreTask = collection.get_doc(uid)

	var finished_task: FirestoreTask = await task.task_finished

	var document = finished_task.document

	if document and document.doc_fields:
		var datos_jugador = document.doc_fields
		print("Datos del jugador:", datos_jugador)

		CargarDatos.dineroFisico = datos_jugador.get("DineroFisico", 0)
		CargarDatos.dineroBanco = datos_jugador.get("DineroBanco", 0)
		CargarDatos.nombreJugador = datos_jugador.get("Nombre", "")
		CargarDatos.emailJugador = datos_jugador.get("Email", "")
		CargarDatos.uid = uid

		get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")
	else:
		print("Error al obtener el documento:", finished_task.error)
		$VBoxContainer/Estado.text = "Error al obtener datos del jugador"

func on_iniciar_sesion_failed(error_code, message):
	print(error_code)
	print(message)
	$VBoxContainer/Estado.text = "Acceso fallido"
