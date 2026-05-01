extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var input_name: LineEdit = %InputName
@onready var label_no_spaces: Label = %LabelNoSpaces

@onready var button_create: Button = %ButtonCreate
@onready var button_back: Button = %ButtonBack

var character_name: String

func _ready() -> void:
	button_create.pressed.connect(_on_create_pressed)
	button_back.pressed.connect(_on_back_pressed)
	input_name.text_changed.connect(_on_text_changed)
	button_create.disabled = true
	label_no_spaces.visible = false


func _physics_process(_delta: float) -> void:
	pass


func _rotate_character() -> void:
	pass


func _on_text_changed(new_text) -> void:
	label_no_spaces.visible = false
	if input_name.text == "" or new_text.contains(" "):
		button_create.disabled = true
		if new_text.contains(" "):
			label_no_spaces.visible = true
	else:
		button_create.disabled = false


func _on_create_pressed() -> void:
	if input_name.text == "" or input_name.text.contains(" "):
		return
	character_name = input_name.text
	print ("user://playersaves/", character_name)
	#generate uuid
	#pass uuid and name to playerdata
	#playerdata.save()



func _on_back_pressed() -> void:
	#FIXME go back to character select
	get_tree().reload_current_scene()
