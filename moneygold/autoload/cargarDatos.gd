extends Node

signal cash_updated

var dineroFisico : int = 150 : set =cash_setter

func cash_setter(new_value):
	dineroFisico = new_value
	emit_signal("cash updated")
