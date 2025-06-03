extends AnimatedSprite2D

var array_caras : Array[int] = [1,2,3,4,5,6]
var animacion_actual : String  = "1"
var twen :Tween
var tick :float
var caras : int
var cuentaCaras : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	tick = randf_range(0.1, 0.2)
	caras = randi_range(15, 25)
	tirar()

func tirar():
	cuentaCaras = +1
	array_caras.shuffle()
	twen = create_tween()
	twen.tween_property(self, "animacion_actual", str(array_caras[0]), tick)
	if cuentaCaras > caras:
		valorFinal()
	else:
		twen.tween_callback(tirar)

func valorFinal():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass
