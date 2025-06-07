extends Area2D
class_name Tarjeta

var icono : int = 0
@onready var animacion : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var random = randi_range(0, 100)
	if random < 20:
		icono = 0
	elif random < 35:
		icono = 1
	elif random < 50:
		icono = 2
	elif random < 65:
		icono = 3
	elif random < 80:
		icono = 4
	else: 
		icono = 5

	animacion.play(str(icono))
