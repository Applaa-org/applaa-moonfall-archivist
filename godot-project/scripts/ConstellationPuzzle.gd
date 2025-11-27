extends Node2D

signal puzzle_completed

@onready var constellation_area: Area2D = $ConstellationArea
@onready var stars: Array[Node] = $Stars.get_children()
@onready var lines: Array[Node] = $Lines.get_children()
@onready var glow: PointLight2D = $Glow

var is_active: bool = false
var connected_stars: Array[Node] = []
var required_pattern: Array[int] = [0, 2, 4, 1, 3]  # Required star connection order
var current_pattern: Array[int] = []

func _ready():
	constellation_area.body_entered.connect(_on_body_entered)
	constellation_area.body_exited.connect(_on_body_exited)
	
	# Set up star interactions
	for i in range(stars.size()):
		stars[i].input_event.connect(_on_star_clicked.bind(i))
		stars[i].modulate = Color.YELLOW
	
	glow.color = Color.YELLOW
	glow.energy = 0.5

func _on_body_entered(body):
	if body.name == "Player":
		is_active = true
		$InstructionLabel.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		is_active = false
		$InstructionLabel.visible = false

func _on_star_clicked(viewport: Viewport, event: InputEvent, shape_idx: int, star_index: int):
	if not is_active or not event is InputEventMouseButton:
		return
	
	if event.pressed:
		_connect_star(star_index)

func _connect_star(star_index: int):
	var star = stars[star_index]
	
	if star in connected_stars:
		return
	
	connected_stars.append(star)
	current_pattern.append(star_index)
	star.modulate = Color.CYAN
	
	# Draw connection line
	if connected_stars.size() > 1:
		var prev_star = connected_stars[-2]
		var line = Line2D.new()
		line.width = 3
		line.default_color = Color.CYAN
		line.add_point(prev_star.position)
		line.add_point(star.position)
		$Lines.add_child(line)
	
	# Check if pattern is complete
	if current_pattern.size() == required_pattern.size():
		_check_pattern()

func _check_pattern():
	if current_pattern == required_pattern:
		_puzzle_solved()
	else:
		_reset_pattern()

func _puzzle_solved():
	puzzle_completed.emit()
	Global.add_score(100)
	Global.restore_archive()
	$SuccessLabel.visible = true
	glow.energy = 2.0
	glow.color = Color.GREEN

func _reset_pattern():
	connected_stars.clear()
	current_pattern.clear()
	
	for star in stars:
		star.modulate = Color.YELLOW
	
	for line in $Lines.get_children():
		line.queue_free()

func interact():
	if is_active:
		_reset_pattern()