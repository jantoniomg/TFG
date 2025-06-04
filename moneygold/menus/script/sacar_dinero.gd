extends Control

@onready var dineroFisico: Label = $DineroF
@onready var dineroBanco: Label = $DineroB
@onready var estado: Label = $Estado
@onready var cantidad: LineEdit = $Cantidad

func _ready() -> void:
	$sacarDinero.pressed.connect(_on_sacar_dinero_pressed)
	$ingresar.pressed.connect(_on_ingresar_pressed)
	$Atras.pressed.connect(_on_atras_pressed)
	actualizar_valores()

func _on_sacar_dinero_pressed() -> void:
	var cantidad = int(cantidad.text)
	if cantidad <= 0:
		estado.text = "Ingresa una cantidad válida"
		return

	if CargarDatos.dineroBanco >= cantidad:
		CargarDatos.dineroBanco -= cantidad
		CargarDatos.dineroFisico += cantidad
		estado.text = "Has sacado %d monedas" % cantidad
		CargarDatos.guardar_datos_en_firestore()
		actualizar_valores()
	else:
		estado.text = "No tienes suficiente dinero en el banco"

func _on_ingresar_pressed() -> void:
	var cantidad = int(cantidad.text)
	if cantidad <= 0:
		estado.text = "Ingresa una cantidad válida"
		return

	if CargarDatos.dineroFisico >= cantidad:
		CargarDatos.dineroFisico -= cantidad
		CargarDatos.dineroBanco += cantidad
		estado.text = "Has ingresado %d monedas al banco" % cantidad
		CargarDatos.guardar_datos_en_firestore()
		actualizar_valores()
	else:
		estado.text = "No tienes suficiente dinero físico"

func actualizar_valores():
	dineroFisico.text = "Físico: $" + str(CargarDatos.dineroFisico)
	dineroBanco.text = "Banco: $" + str(CargarDatos.dineroBanco)

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")
