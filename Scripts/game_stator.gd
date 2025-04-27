extends Node2D

@onready var hp_shield_bar = $UI_TopRight/Anchor/HpShieldBar
@onready var map = $UI_TopRight/Anchor/Map
@onready var positionaire = $Positionaire

var prev_activity = null
var activity_object

var is_raining = false
var storm_mod = 1.5

var player_hp = 20
var player_maxhp = 20
var player_shield = 0

@onready var systems = [$Campfire, $Stormorer, $TBC]# CAMPFIRE, STORMORER, ENEMY, BOSS

var current_tile
var current_ground

func _ready():
	$Music.playing = true
	hp_shield_bar.update(player_hp, player_maxhp, player_shield)
	map.init()
	
	#for system in systems:
	#	system.finished.connect(update)
	
	update()

func update():
	current_tile = map.get_current_tile()
	current_ground = map.get_current_ground()
	
	is_raining = current_ground in [0, 2]
	$RainParticles.emitting = is_raining
	$StormPlayer.playing = is_raining
	$WetEffect.visible = is_raining
	$WetLabel.visible = is_raining
	$WetLabel.text = "\nWET\nALL SIDES TAKE %sX DAMAGE" % storm_mod
	
	var system
	if current_tile < 3:
		system = systems[current_tile]
		system.init(map)
	else:
		system = systems[2]
		system.init(true)
	
	activity_object = system
	positionaire.run_to(activity_object, prev_activity)
	await positionaire.reached
	
	systems[current_tile].start(map)
	await system.finished
	map.scroll()
	
	prev_activity = activity_object
	update()

func change_hp(delta):
	if is_raining:
		delta = int(delta * storm_mod)
	if delta < 0 and player_shield > 0:
		if (delta + player_shield) < 0:
			delta = delta + player_shield
			player_shield = 0
		else:
			player_shield = player_shield + delta
			delta = 0
	player_hp = clamp(player_hp + delta, 0, player_maxhp)
	hp_shield_bar.update(player_hp, player_maxhp, player_shield)
	if delta < 0:
		$TBC/GlobalOuchie.playing = true
		$Player/Sprite/AnimationPlayer.play("hurt")

func _on_campfire_heal(heal):
	change_hp(heal)


func _on_stormorer_shift_grounds(offset):
	map.shift_grounds(offset)


func _on_stormorer_amplify():
	storm_mod += 0.5
	$RainParticles.amount += 5
	$RainParticles.speed_scale += 0.1


func _on_animation_player_animation_finished(anim_name):
	$Player/Sprite/AnimationPlayer.play("idle")


func _on_weapons_shield_up(sh):
	player_shield = clamp(player_shield + sh, 0, 99)
	hp_shield_bar.update(player_hp, player_maxhp, player_shield)


func _on_heal_button_2_button_down():
	player_maxhp += 5
	$Campfire._on_heal_button_button_down(true)
	hp_shield_bar.update(player_hp, player_maxhp, player_shield)
