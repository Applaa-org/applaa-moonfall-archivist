extends Node2D

signal puzzle_completed

@onready var orbs: Array[Node] = $Orbs.get_children()
@onready var sequence_display: Label = $SequenceDisplay
@onready var glow: PointLight2D = $Glow

var is_active: bool = false
var target_sequence: Array[int] = [1, 3, 2, 0, 4]  # Target orb sequence
var current_sequence: Array[int] = []
var orb_colors: Array[Color] = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.MAGENTA]

func _ready():
	# Set up orb interactions
	for i in range(orbs.size()):
		orbs[i].input_event.connect(_on_orb_clicked.bind(i))
		orbs[i].modulate = orb_colors[i]
	
	glow.color = Color.MAGENTA
	glow.energy = 0.5

func _on_orb_clicked(viewport: Viewport, event: InputEvent, shape_idx: int, orb_index: int):
	if not is_active or not event is InputEventMouseButton:
		return
	
	if event.pressed:
		_add_to_sequence(orb_index)

func _add_to_sequence(orb_index: int):
	current_sequence.append(orb_index)
	_update_display()
	
	# Visual feedback
	orbs[orb_index].scale = Vector2(1.5, 1.5)
	var tween = create_tween()
	tween.tween_property(orbs[orb_index], "scale", Vector2(1, 1), 0.2)
	
	# Check sequence
	if current_sequence.size() == target_sequence.size():
		_check_sequence()

func _update_display():
	var display_text = ""
	for index in current_sequence:
		display_text += str(index + 1) + " "
	sequence_display.text = display_text

func _check_sequence():
	if current_sequence == target_sequence:
		_puzzle_solved()
	else:
		_reset_sequence()

func _puzzle_solved():
	puzzle_completed.emit()
	Global.add_score(150)
	Global.restore_archive()
	$SuccessLabel.visible = true
	glow.energy = 2.0
	glow.color = Color.GREEN

func _reset_sequence():
	current_sequence.clear()
	sequence_display.text = ""
	
	# Flash red feedback
	for orb in orbs:
		orb.modulate = Color.RED
		var tween = create_tween()
		tween.tween_property(orb, "modulate", orb_colors[orbs.find(orb)], 0.5)

func _on_decoder_area_entered(body):
	if body.name == "Player":
		is_active = true
		$InstructionLabel.visible = true
		$HintLabel.text = "Hint: " + str(target_sequence[0] + 1)

func _on_decoder_area_exited(body):
	if body.name == "Player":
		is_active = false
		$InstructionLabel.visible = false
		$HintLabel.text = ""

func interact():
	if is_active:
		_reset_sequence()