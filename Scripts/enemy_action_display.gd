extends Node2D

func _ready():
	var len = self.get_child_count()
	for i in len:
		var ch: Node2D = get_child(i)
		ch.position
