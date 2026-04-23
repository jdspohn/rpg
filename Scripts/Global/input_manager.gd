extends Node

var start_menu = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:

	if Input.is_action_just_pressed("start_menu") and get_tree().current_scene.has_node("StartMenu"):
		start_menu = !start_menu
		get_node("/root/Main/StartMenu").control_menu()
