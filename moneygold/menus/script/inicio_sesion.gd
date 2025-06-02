extends Control


# Funcion llamada al inicio
func _ready():
	#Si haces login llamas a on_iniciar_sesion_succeeded
	Firebase.Auth.login_succeeded.connect(on_iniciar_sesion_succeeded)
	
	#Si te registras llamas a on_registrarse_succeeded
	Firebase.Auth.signup_succeeded.connect(on_registrarse_succeeded)
	
	#Si falla el login llamas a on_iniciar_sesion_failed
	Firebase.Auth.login_failed.connect(on_iniciar_sesion_failed)
	
	#Si haces login llamas a on_registrarse_failed
	Firebase.Auth.signup_failed.connect(on_registrarse_failed)
# En caso de que ya hallas accedido con anterioridad lo detectaremos del sistema
	if Firebase.Auth.check_auth_file():
		$VBoxContainer/Estado.text = "Accedido"
		get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")

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
	var email = $VBoxContainer/Usuario.text
	var password = $VBoxContainer/Contraseña.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	$VBoxContainer/Estado.text = "Registrado"

func on_iniciar_sesion_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")

func on_registrarse_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")

func on_iniciar_sesion_failed(error_code, message):
	print(error_code)
	print(message)
	$VBoxContainer/Estado.text = "Acceso fallido"

func on_registrarse_failed(error_code, message):
	print(error_code)
	print(message)
	$VBoxContainer/Estado.text = "Registro fallido"
