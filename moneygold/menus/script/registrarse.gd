extends Control

func _ready():
	Firebase.Auth.signup_succeeded.connect(on_registrarse_succeeded)
	Firebase.Auth.signup_failed.connect(on_registrarse_failed)

func _process(delta: float):
	pass

func _on_registrarse_pressed() -> void:
	var email = $VBoxContainer/Usuario.text
	var password = $"VBoxContainer/Contraseña".text
	Firebase.Auth.signup_with_email_and_password(email, password)
	$VBoxContainer/Estado.text = "Registrado"

func on_registrarse_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://menus/inicio_sesion.tscn")
	var uid = auth["localid"]
	var nombre = $VBoxContainer/Nombre.text
	var email = $VBoxContainer/Usuario.text

	var jugador_data: Dictionary = {
		"Nombre": nombre,
		"Email": email,
		"DineroBanco": 100,
		"DineroFisico": 150,
		"ID_Logro_Icono": ["v7vVCoT1QrdGLaY0un5M"]
	}

	var collection: FirestoreCollection = Firebase.Firestore.collection("Jugadores")

	var task: FirestoreTask = collection.update(uid, jugador_data)

	var finished_task: FirestoreTask = await task.task_finished
	if finished_task.error.is_empty():
		print("Jugador creado en Firestore:", uid)
		get_tree().change_scene_to_file("res://menus/inicio_sesion.tscn")
	else:
		print("Error al guardar jugador en Firestore:", finished_task.error)
		$VBoxContainer/Estado.text = "Error al guardar datos"

func on_registrarse_failed(error_code, message):
	print(error_code)
	print(message)
	$VBoxContainer/Estado.text = "Registro fallido"

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/inicio_sesion.tscn")
