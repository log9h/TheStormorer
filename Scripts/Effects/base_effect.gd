extends Resource
class_name Effect

@export var duration: int = 1

func trigger():
	pass

func _trigger():
	if duration != 0:
		trigger()
		duration -= 1
