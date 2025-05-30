extends Node2D

var color_selected : Color = Color.YELLOW
var color_not_selected : Color = Color.DIM_GRAY
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Button:
			child.add_theme_color_override("font_color", color_selected)
			child.pressed.connect(_on_any_button_pressed)

func _on_any_button_pressed():
	print ("algun btn apretado")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
