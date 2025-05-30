extends Node2D

@onready var dineroF_label :Label =$dineroF


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dineroF_label.text = str(CargarDatos.cash)
	CargarDatos.cash_updated.conect(new_cash)

func new_cash(new_value):
	dineroF_label.text = str(CargarDatos.cash)
