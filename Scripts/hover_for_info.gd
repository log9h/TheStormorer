extends Area2D

var data: String = ""

func _on_mouse_entered():
	InfoBox.get_info(data) 


func _on_mouse_exited():
	InfoBox.exited() 
