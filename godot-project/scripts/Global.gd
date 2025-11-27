extends Node

signal score_changed(new_score: int)
signal archives_restored(count: int)
signal gravity_changed(direction: String)

var score: int = 0
var archives_restored_count: int = 0
var total_archives: int = 3
var current_gravity: Vector2 = Vector2(0, 200)
var time_remaining: float = 300.0  # 5 minutes

func add_score(points: int):
	score += points
	score_changed.emit(score)

func restore_archive():
	archives_restored_count += 1
	archives_restored.emit(archives_restored_count)
	add_score(100)
	
	if archives_restored_count >= total_archives:
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func reset_game():
	score = 0
	archives_restored_count = 0
	time_remaining = 300.0
	current_gravity = Vector2(0, 200)

func set_gravity_direction(direction: String):
	match direction:
		"down":
			current_gravity = Vector2(0, 200)
		"up":
			current_gravity = Vector2(0, -200)
		"left":
			current_gravity = Vector2(-200, 0)
		"right":
			current_gravity = Vector2(200, 0)
	gravity_changed.emit(direction)