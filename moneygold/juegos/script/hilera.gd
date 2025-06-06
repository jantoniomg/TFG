extends Node2D

signal giro_finalizado

var numero : int = 150
var size : int = 40
var tarjeta : PackedScene = preload("res://juegos/escenasOanimaciones/tarjeta.tscn")
var twen : Tween
var giro : float
var giro_lento_inicial : float = 0.0005
var giro_lento : float = 0.0005
var giro_fin : float = 0.08
var movimiento : int 
@onready var tamaño :float = size * scale.y
@onready var posicion_inicial : Vector2 = position
@export var tarjetas_extra = 20
@export var parada : float = 0.1
var centro_visible_y: float

func valores_iniciales():
	genera_tarjeta()
	position = posicion_inicial
	giro_lento = giro_lento_inicial
	giro = randf_range(0.01, 0.02)
	movimiento = randi_range(70, 145)
	girar()

func genera_tarjeta():
	for child in get_children():
		if child is Tarjeta:
			child.queue_free()
	for i in range(1, numero):
		var nueva_tarjeta = tarjeta.instantiate()
		nueva_tarjeta.position = Vector2(0, i * size)
		add_child(nueva_tarjeta)

func girar():
	twen = create_tween()
	twen.tween_property(self, "position", Vector2(position.x, (position.y - tamaño)), giro)

	if giro < 0.15 + parada:
		giro += giro_lento
		giro_lento += 0.0003
	elif giro < 0.4:
		giro += giro_fin
	else:
		print("✅ Giro finalizado, emitiendo señal")
		emit_signal("giro_finalizado")
		return


	twen.tween_callback(girar)

func obtener_tarjeta_visible() -> Tarjeta:
	var tarjeta_cercana : Tarjeta = null
	var distancia_min := INF

	for child in get_children():
		if child is Tarjeta:
			var tarjeta_pos_global_y = to_global(child.position).y
			var distancia: float = abs(tarjeta_pos_global_y - centro_visible_y)
			if distancia < distancia_min:
				distancia_min = distancia
				tarjeta_cercana = child

	return tarjeta_cercana
