extends Node2D

@onready var object = self

@export var game_stator: Node2D = null

signal shift_grounds(offset)
signal amplify()
signal finished()

var map_loaded = []
var grounds_loaded = []

var current_tile_index

func init(map=null):
	$UI.visible = false

func start(map):
	$UI.visible = true
	map_loaded = map.map
	grounds_loaded = map.grounds
	current_tile_index = map.current_tile_index
	$UI/AmplifyButton/DamageModLabel.text = "STORM DMG MOD: %s" % \
		game_stator.storm_mod
	update_mapview()

func update_mapview():
	for i in 10:
		var map_tile: VBoxContainer = $UI/MapView/HBoxContainer.get_child(i)
		
		var tile: Sprite2D = map_tile.get_child(0).get_child(0)
		tile.frame = map_loaded[i+current_tile_index]
		
		var ground: TextureRect = map_tile.get_child(1)
		if i == 0:
			ground.self_modulate = Color(244/255.0, 180/255.0, 27/255.0)
		elif grounds_loaded[i+current_tile_index] in [0, 2]:
			ground.self_modulate = Color(230/255.0, 72/255.0, 46/255.0)
		elif grounds_loaded[i+current_tile_index] in [1, 3]:
			ground.self_modulate = Color(56/255.0, 217/255.0, 115/255.0)

func end():
	$UI.visible = false
	emit_signal("finished")

func _on_shift_left_button_button_down():
	emit_signal("shift_grounds", -1)
	end()


func _on_shift_right_button_button_down():
	emit_signal("shift_grounds", 1)
	end()


func _on_amplify_button_button_down():
	emit_signal("amplify")
	end()
