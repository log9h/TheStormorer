extends Node2D

@onready var sprite = $Sprite
@onready var animation_player = $AnimationPlayer
@onready var action_hover_for_info = $Sine/HoverForInfo
@export var stator: Node2D = null

var enemy_data: Enemy

var attacks = []

var current_attack: Attack

var hp
var max_hp

signal completed

func load_enemy_data(_enemy_data: Enemy):
	$EnemyTitle.visible = false
	$HPText.visible = false
	enemy_data = _enemy_data
	
	sprite.texture = enemy_data.texture
	$EnemyTitle.text = enemy_data.name
	max_hp = enemy_data.hp
	hp = enemy_data.hp
	attacks = enemy_data.attacks
	
	update_label()
	animation_player.play("idle")

func update_label():
	$HPText.text = "HP:%s/%s" % [hp, max_hp]

func load_attack():
	$EnemyTitle.visible = true
	$HPText.visible = true
	current_attack = attacks[randi() % len(attacks)]
	action_hover_for_info.get_child(0).frame = current_attack.Icon
	action_hover_for_info.data = current_attack.info
	
	action_hover_for_info.visible = true

func attack():
	stator.change_hp(-current_attack.damage)

func _ready():
	action_hover_for_info.visible = false

func change_hp(delta):
	if stator.is_raining:
		delta = int(delta * stator.storm_mod)
	hp = clamp(hp + delta, 0, 99)
	update_label()
	if delta < 0:
		$GlobalOuchie.playing = true
		$AnimationPlayer.play("hurt")

func play_turn():
	attack()
	await get_tree().create_timer(0.1).timeout
	emit_signal("completed")


func _on_animation_player_animation_finished(anim_name):
	animation_player.play("idle")
