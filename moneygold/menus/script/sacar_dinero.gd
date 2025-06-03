extends Control

# Referencias a los nodos de la escena
@onready var dineroFisico: Label = $DineroF
@onready var dineroBanco: Label = $DineroB
@onready var estado: Label = $Estado
@onready var cantidad: LineEdit = $Cantidad

# Se conecta todo al iniciar la escena
func _ready() -> void:
	$sacarDinero.pressed.connect(_on_sacar_dinero_pressed)
	$ingresar.pressed.connect(_on_ingresar_pressed)
	$Atras.pressed.connect(_on_atras_pressed)
	actualizar_valores()

# Función cuando el jugador presiona el botón de "Sacar"
func _on_sacar_dinero_pressed() -> void:
	var cantidad = int(cantidad.text)  # Convertimos el texto a número
	if cantidad <= 0:
		estado.text = "Ingresa una cantidad válida"
		return
	
	# Verificamos si el jugador tiene suficiente dinero en el banco
	if CargarDatos.dineroBanco >= cantidad:
		# Se realiza la operación
		CargarDatos.dineroBanco -= cantidad
		CargarDatos.dineroFisico += cantidad
		estado.text = "Has sacado %d monedas" % cantidad
		# Guardamos los nuevos datos en Firestore
		CargarDatos.guardar_datos_en_firestore()
		actualizar_valores()
	else:
		estado.text = "No tienes suficiente dinero en el banco"

# Función cuando el jugador presiona el botón de "Ingresar"
func _on_ingresar_pressed() -> void:
	var cantidad = int(cantidad.text)
	if cantidad <= 0:
		estado.text = "Ingresa una cantidad válida"
		return
	
	# Verificamos si el jugador tiene suficiente dinero físico
	if CargarDatos.dineroFisico >= cantidad:
		# Se realiza la operación
		CargarDatos.dineroFisico -= cantidad
		CargarDatos.dineroBanco += cantidad
		estado.text = "Has ingresado %d monedas al banco" % cantidad
		# Guardamos los nuevos datos en Firestore
		CargarDatos.guardar_datos_en_firestore()
		actualizar_valores()
	else:
		estado.text = "No tienes suficiente dinero físico"

func actualizar_valores():
	dineroFisico.text = "Físico: $" + str(CargarDatos.dineroFisico)
	dineroBanco.text = "Banco: $" + str(CargarDatos.dineroBanco)

# Botón para volver al menú principal
func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")
