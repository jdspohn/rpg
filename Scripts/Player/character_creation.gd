extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var input_name: LineEdit = $Control/InputName
@onready var button_create: Button = %ButtonCreate
@onready var button_back: Button = %ButtonBack

var character_name: String

func _ready() -> void:
	button_create.pressed.connect(_on_create_pressed)
	button_back.pressed.connect(_on_back_pressed)


func _physics_process(_delta: float) -> void:
	pass


func _rotate_character() -> void:
	pass


func _on_create_pressed() -> void:
	if input_name.text == "":
		return
	character_name = input_name.text
	print ("user://playersaves/", character_name)
	#generate uuid
	#pass uuid and name to playerdata
	#playerdata.save()



func _on_back_pressed() -> void:
	#FIXME go back to character select
	get_tree().reload_current_scene()
