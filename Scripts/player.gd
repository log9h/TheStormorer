extends Node2D

@onready var anim_player = $Sprite/AnimationPlayer
@onready var attack_button = $AttackButton

signal completed

func _ready():
	attack_button.visible = false

func play_turn():
	print('plr turn!!')
	attack_button.visible = true
	attack_button.disabled = false


func _on_attack_button_pressed():
	print("bum!!!")
	attack_button.disabled = true
	emit_signal("completed")
