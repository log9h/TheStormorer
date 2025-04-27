extends Resource
class_name Weapon

@export var texture: Texture2D = null
@export var name = ""
@export var desc = ""

@export var damage: int = 0
@export var inflict: Effect = null;
@export var receive: Effect = null;

@export var shield: int = 0
