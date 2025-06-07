extends Node2D
class_name Carta

var rango: String
var palo: String
var valor: int
var boca_abajo = true

func obtener_valor() -> int:
	return valor

func obtener_nombre() -> String:
	return palo + rango

func _ready():
	$ImagenCarta.texture_normal = load("res://assets/images/blackjack/%s%s.png" % [palo, rango])

func _process(_delta):
	if boca_abajo == true:
		$ImagenCarta.disabled = true
	else:
		$ImagenCarta.disabled = false
	
