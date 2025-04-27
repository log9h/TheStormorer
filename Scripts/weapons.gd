extends VBoxContainer

@export var weapons_data: Array[Weapon] = []

signal weapon_used(which)
signal shield_up(sh)

var stator
var enemy

func _ready():
	for i in 3:
		var weap = get_child(i)
		weap.connect("weapon_used", use_weapon)
		weap.load_data(weapons_data[i])

func set_active(active, _stator, _enemy):
	stator = _stator
	enemy = _enemy
	for i in 3:
		var weap = get_child(i)
		weap.set_active(active)

func use_weapon(which):
	var weap = weapons_data[which]
	enemy.change_hp(-weap.damage)
	emit_signal("shield_up", weap.shield)
	emit_signal("weapon_used", which)

func add_weapon():
	pass
