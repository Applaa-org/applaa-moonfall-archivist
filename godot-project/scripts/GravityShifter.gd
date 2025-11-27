extends Node2D

@onready var shifter_area: Area2D = $ShifterArea
@onready var arrow: Sprite2D = $Arrow
@onready var glow: PointLight2D = $Glow

var gravity_directions: Array[String] = ["down", "up", "left", "right"]
var current_direction_index: int = 0

func _ready():
	shifter_area.body_entered.connect(_on_body_entered)
	shifter_area.body_exited.connect(_on_body_exited)
	
	glow.color = Color.PURPLE
	glow.energy = 0.8

func _on_body_entered(body):
	if body.name == "Player":
		$InstructionLabel.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		$InstructionLabel.visible = false

func interact():
	current_direction_index = (current_direction_index + 1) % gravity_directions.size()
	var new_direction = gravity_directions[current_direction_index]
	Global.set_gravity_direction(new_direction)
	
	# Update arrow visual
	match new_direction:
		"down":
			arrow.rotation = 0
		"up":
			arrow.rotation = PI
		"left":
			arrow.rotation = -PI/2
		"right":
			arrow.rotation = PI/2
	
	# Visual feedback
	glow.energy = 2.0
	var tween = create_tween()
	tween.tween_property(glow, "energy", 0.8, 0.5)