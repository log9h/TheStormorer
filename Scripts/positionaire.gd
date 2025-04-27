extends Node2D

@export var player: Node2D = null
@onready var walkie: AudioStreamPlayer2D = player.get_child(1)

@onready var systems = [get_node("../TBC"), get_node("../Campfire"), get_node("../Stormorer")]
@onready var anim_player: AnimationPlayer = player.get_child(0).get_child(0)

signal reached()

var player_start_pos = Vector2(-42, -37)
var player_end_pos = Vector2(176, 130)
var object_pos_offset = Vector2(-274, -207)

var object_start_pos = Vector2.ZERO
var object
var prev_obj
var object_end_pos = Vector2(-356, -212)

func _ready():
	player.position = player_start_pos
	for s in systems:
		s.position = object_start_pos

func run_to(what: Node2D, prev_activity=null):
	anim_player.play("walk")
	object = what
	prev_obj = prev_activity

func _physics_process(delta):
	if anim_player.current_animation == "walk":
		if not walkie.playing:
			walkie.playing = true
		player.position = player.position.move_toward(player_end_pos, 2)
		object.position = object.position.move_toward(object_end_pos, 2)
		if prev_obj:
			prev_obj.position = prev_obj.position.move_toward(prev_obj.position + \
				Vector2(-354, -212), 2)
		if player.position == player_end_pos and \
			object.position == object_end_pos:
			walkie.playing = false
			player.get_child(1).playing = false
			anim_player.play("idle")
			if prev_obj:
				prev_obj.position = Vector2.ZERO
			emit_signal("reached")

