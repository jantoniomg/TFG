extends Control


# Funcion llamada al inicio
func _ready():

	#Si haces login llamas a on_iniciar_sesion_succeeded
	Firebase.Auth.login_succeeded.connect(on_iniciar_sesion_succeeded)
	
	#Si falla el login llamas a on_iniciar_sesion_failed
	Firebase.Auth.login_failed.connect(on_iniciar_sesion_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass

# Funcion para hacer login 
func _on_iniciar_sesion_pressed():
	var email = $VBoxContainer/Usuario.text
	var password = $VBoxContainer/Contraseña.text
	Firebase.Auth.login_with_email_and_password(email, password)
	$VBoxContainer/Estado.text = "Accediendo"

# Funcion para registrarse
func _on_registrarse_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/registrarse.tscn")

func on_iniciar_sesion_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)

	var uid = auth["localid"]
	var collection: FirestoreCollection = Firebase.Firestore.collection("Jugadores")
	var task: FirestoreTask = collection.get_doc(uid)

	var finished_task: FirestoreTask = await task.task_finished

	# Accedemos al documento
	var document = finished_task.document

	if document and document.doc_fields:
		var datos_jugador = document.doc_fields
		print("Datos del jugador:", datos_jugador)

		# Guardamos los datos en el autoload "CargarDatos"
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
