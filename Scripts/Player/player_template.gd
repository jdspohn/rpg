extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var nameplate: Label3D = %Nameplate

func _ready() -> void:
	nameplate.text = name

func MovePlayer(new_postition, new_rotation):
	global_position = new_postition
	pivot.global_rotation[1] = new_rotation
