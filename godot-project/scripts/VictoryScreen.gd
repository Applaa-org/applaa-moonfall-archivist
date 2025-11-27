extends Control

func _ready():
	$VBoxContainer/FinalScoreLabel.text = "Final Score: %d" % Global.score
	$VBoxContainer/TimeBonusLabel.text = "Time Bonus: %d" % int(Global.time_remaining * 2)
	
	var total_score = Global.score + int(Global.time_remaining * 2)
	$VBoxContainer/TotalScoreLabel.text = "Total Score: %d" % total_score
	
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)

func _on_restart_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()