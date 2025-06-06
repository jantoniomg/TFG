extends AnimatedSprite2D

signal resultado_final(origen: String, valor: int)

var array_caras: Array[int] = [1, 2, 3, 4, 5, 6]
var animacion_actual: String = "1" : set = set_animacion_actual

var twen: Tween
var giro: float
var caras: int
var cuentaCaras: int = 0

func _ready():
	pass

func tirar():
	cuentaCaras = 0
	giro = randf_range(0.1, 0.30)
	caras = randi_range(12, 19)
	_loop_tirada()

func _loop_tirada():
	cuentaCaras += 1
	array_caras.shuffle()
	twen = create_tween()
	twen.tween_property(self, "animacion_actual", str(array_caras[0]), giro)

	if cuentaCaras > caras:
		twen.tween_callback(valorFinal)
	else:
		if cuentaCaras + 3 > caras:
			giro = 0.8
		twen.tween_callback(_loop_tirada)

func valorFinal():
	var resultado = int(animacion_actual)
	emit_signal("resultado_final", name, resultado)

func set_animacion_actual(valor):
	animacion_actual = valor
	play(valor)
