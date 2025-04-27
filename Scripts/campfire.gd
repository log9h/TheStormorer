extends Node2D

signal heal(heal)
signal finished()

var ex = false

func init(map=null):
	$HealButton.visible = false
	$HealButton2.visible = false
	var ground = map.get_current_ground()
	ex = ground in [0, 2]
	if ex:
		$Sprite.frame = 1
		$HealButton.text = "CONTINUE"
		$HealButton2.text = "CONTINUE"
	else:
		$Sprite.frame = 0
		$HealButton.text = "HEAL 10 HP"
		$HealButton2.text = "MAX HP + 5"

func start(map=null):
	$HealButton.visible = true
	$HealButton2.visible = true

func _on_heal_button_button_down(d = false):
	$HealButton.visible = false
	$HealButton2.visible = false
	if not ex and not d:
		emit_signal("heal", 10)
	$Sprite.frame = 1
	emit_signal("finished")
