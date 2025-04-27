extends Resource
class_name Attack

@export_enum("Attack", "Debuff", "Buff", "Unknown") var Icon = 0

@export var damage: int = 0
@export var inflict: Effect = null
@export var receive: Effect = null
@export var info: String = ""
