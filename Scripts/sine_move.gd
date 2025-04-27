extends Node2D

@export_range(1, 1000) var frequency = 1
@export_range(0, 1000) var amplitude = 2
var time = 0

func _physics_process(delta):
	time += delta
	var movement = cos(time * frequency) * amplitude
	position.y += movement * delta
