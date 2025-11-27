extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var ui: Control = $UI
@onready var score_label: Label = $UI/ScoreLabel
@onready var archives_label: Label = $UI/ArchivesLabel
@onready var time_label: Label = $UI/TimeLabel
@onready var background: ColorRect = $Background

func _ready():
	# Set up celestial background
	background.color = Color(10, 10, 30)  # Dark blue
	
	# Connect signals
	Global.score_changed.connect(_on_score_changed)
	Global.archives_restored.connect(_on_archives_restored)
	
	# Create starfield
	_create_starfield()
	
	# Update UI
	_update_ui()

func _process(delta):
	# Update timer
	Global.time_remaining -= delta
	time_label.text = "Time: %d:%02d" % [floor(Global.time_remaining / 60), int(Global.time_remaining) % 60]
	
	# Check defeat condition
	if Global.time_remaining <= 0:
		get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func _create_starfield():
	for i in range(100):
		var star = Sprite2D.new()
		star.texture = preload("res://assets/star.png") if ResourceLoader.exists("res://assets/star.png") else null
		if not star.texture:
			# Create a simple star texture
			var texture = ImageTexture.new()
			var image = Image.create(4, 4, false, Image.FORMAT_RGBA8)
			image.fill(Color.TRANSPARENT)
			image.set_pixel(1, 1, Color.WHITE)
			image.set_pixel(2, 1, Color.WHITE)
			image.set_pixel(1, 2, Color.WHITE)
			image.set_pixel(2, 2, Color.WHITE)
			texture.set_image(image)
			star.texture = texture
		
		star.position = Vector2(randf() * 1024, randf() * 768)
		star.modulate = Color.WHITE
		star.scale = Vector2(randf() * 0.5 + 0.5, randf() * 0.5 + 0.5)
		add_child(star)

func _on_score_changed(new_score: int):
	score_label.text = "Score: %d" % new_score

func _on_archives_restored(count: int):
	archives_label.text = "Archives: %d/%d" % [count, Global.total_archives]

func _update_ui():
	score_label.text = "Score: %d" % Global.score
	archives_label.text = "Archives: %d/%d" % [Global.archives_restored_count, Global.total_archives]