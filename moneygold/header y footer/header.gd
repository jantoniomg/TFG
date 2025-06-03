extends Node2D

@onready var dineroF_label: Label = $dineroF     
@onready var dineroB_label: Label = $dineroB     
@onready var nombre_label: Label = $Nombre         
@onready var foto_perfil: TextureRect = $FotoPerfil 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Mostrar valores actuales
	dineroF_label.text = str(CargarDatos.dineroFisico)
	dineroB_label.text = str(CargarDatos.dineroBanco)
	nombre_label.text = CargarDatos.nombreJugador
	CargarDatos.dinero_updated.connect(nuevo_dinero_fisico)
	CargarDatos.banco_updated.connect(nuevo_dinero_banco)
	
func nuevo_dinero_fisico(new_value):
	dineroF_label.text = str(CargarDatos.dineroFisico)

func nuevo_dinero_banco(new_value):
	dineroB_label.text = str(CargarDatos.dineroBanco)

func _on_sacar_dinero_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menuscene/sacarDinero.tscn")

func _on_salir_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/MenuPrincipal.tscn")
