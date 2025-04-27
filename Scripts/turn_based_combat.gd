extends Node2D

@export var enemies: Array[Enemy] = []
@export var death_animation: PackedScene = null

@onready var game_stator = get_tree().root.get_child(1)
@onready var player = get_node("../Player")
@onready var enemy = $Enemy

@onready var ui = $Weapons
@onready var lab = $WeaponsLabel

signal finished()
signal turn_played()
var died = false

var turn = 0

var player_actions: int = 3
var enemy_actions: int = 3

func init(boss=false, map=null): # GENERATE AND LOAD ENEMY
	turn = 0
	player.get_child(0).visible = true
	enemy.visible = true
	ui.visible = false
	lab.visible = false
	enemy.load_enemy_data(enemies[randi() % len(enemies)])

func start(map=null): #START THE BATTLE
	ui.visible = true
	lab.visible = true

	while enemy.hp > 0 and game_stator.player_hp > 0:
		play_turn()
		await turn_played
	
	var dies
	if enemy.hp == 0:
		dies = enemy
	else:
		dies = player
	var death_anim: Node2D = death_animation.instantiate()
	death_anim.get_child(0).texture = dies.get_child(0).texture
	self.add_child(death_anim)
	death_anim.global_position = dies.global_position
	enemy.visible = false
	if player == dies:
		get_node("../GameOver").visible = true
		died = true
		player.get_child(0).visible = false
		return
	
	ui.visible = false
	lab.visible = false
	emit_signal("finished")

func _process(delta):
	if died and Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func play_turn():
	enemy.load_attack()
	
	turn += 1
	$WeaponsLabel/TurnsLabel.text = "TURN:%s" % turn
	
	ui.set_active(true, game_stator, enemy)
	await ui.weapon_used
	
	if enemy.hp == 0:
		emit_signal("turn_played")
		return 0
	
	enemy.play_turn()
	await enemy.completed
	emit_signal("turn_played")
