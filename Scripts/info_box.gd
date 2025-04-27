extends Node2D

var hovering = false
var display_info = ""

func get_info(info):
	hovering = true
	display_info = info

func exited():
	hovering = false

func _process(delta):
	if hovering:
		global_position = get_global_mouse_position()
		$Background/Label.text = "\n" + display_info.to_upper()
		visible = true
	else:
		visible = false
