extends CharacterBody2D

signal interact_requested

const SPEED: float = 150.0
const JUMP_VELOCITY: float = -300.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var glow: PointLight2D = $Glow

var gravity: Vector2 = Vector2(0, 200)
var can_interact: bool = false
var interactable_object: Node = null

func _ready():
	# Set up celestial appearance
	sprite.modulate = Color.LIGHT_CYAN
	glow.color = Color.CYAN
	glow.energy = 1.0
	
	interaction_area.body_entered.connect(_on_interaction_area_entered)
	interaction_area.body_exited.connect(_on_interaction_area_exited)
	
	Global.gravity_changed.connect(_on_gravity_changed)

func _physics_process(delta: float):
	# Apply current gravity
	velocity += gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle interaction
	if Input.is_action_just_pressed("interact") and can_interact:
		interact_requested.emit()
		if interactable_object:
			interactable_object.interact()
	
	move_and_slide()

func _on_interaction_area_entered(body):
	if body.has_method("interact"):
		can_interact = true
		interactable_object = body
		$InteractionPrompt.visible = true

func _on_interaction_area_exited(body):
	if body == interactable_object:
		can_interact = false
		interactable_object = null
		$InteractionPrompt.visible = false

func _on_gravity_changed(direction: String):
	match direction:
		"down":
			gravity = Vector2(0, 200)
			sprite.rotation = 0
		"up":
			gravity = Vector2(0, -200)
			sprite.rotation = PI
		"left":
			gravity = Vector2(-200, 0)
			sprite.rotation = -PI/2
		"right":
			gravity = Vector2(200, 0)
			sprite.rotation = PI/2