extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
	
	# Set up the title with celestial theme
	$TitleLabel.add_theme_font_size_override("font_size", 48)
	$TitleLabel.modulate = Color.CYAN

func _on_start_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()