extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	if Firebase.Auth.check_auth_file():
		get_tree().change_scene_to_file("res://")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _on_iniciar_sesion_pressed():
	var email = %Usuario.text
	var password = %Contraseña.text
	Firebase.Auth.sign_with_email_and_password(email, password)


func _on_registrarse_pressed() -> void:
	var email = %Usuario.text
	var password = %Contraseña.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	
func on_login_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("")
	
func on_signup_succeeded(auth):
	print(auth)
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file(" ")
	
func on_login_failed(error_code, message):
	print(error_code)
	print(message)
	%Estado.text = "Login failed. Error: %s" % message
	
func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	%Estado.text = "Sign up failed. Error: %s" % message
