extends Node2D

@onready var hp_bar = $HPBar/Bar
@onready var hp_label = $HPLabel

@onready var shield_bar = $ShieldBar/Bar
@onready var shield_label = $ShieldLabel

func _ready():
	pass

func update(hp, max_hp, shield=0):
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_label.text = "[shifting_text shift=7]HP:%02d/%02d[/shifting_text]" % \
		[hp, max_hp]
	
	shield_bar.max_value = int(max_hp / 2)
	shield_bar.value = shield
	shield_label.text = "[shifting_text shift=7]+%02d[/shifting_text]" % \
		[shield]
	shield_label.visible = shield > 0
	
