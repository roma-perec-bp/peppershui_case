extends CharacterBody2D
var moveSpeed : int = 75
var direction: Vector2 = Vector2.ZERO
var car_direction: Vector2 = Vector2.DOWN

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var state:String = "Idle"

var canMove:bool = false

@onready var legs = $legs
@onready var body = $body
@onready var cone = $cone
@onready var eye = $eye
@onready var head = $head

func _physics_process(delta):

	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	).normalized()

	velocity = direction * moveSpeed
	
	if canMove:
		if set_state() == true || set_direction() == true:
			update_anim()

	if canMove: move_and_slide()

func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int( round( ( direction ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[direction_id]
	
	if new_dir == car_direction:
		return false
	
	car_direction = new_dir
	
	return true
	
func set_state() -> bool:
	var new_state: String = "default" if direction == Vector2.ZERO else "walk"
	
	if new_state == state:
		return false
	
	state = new_state
	return true
	
func update_anim() -> void:
	$legs.play(state+"-front")
	$body.play(state+"-front")
	$head.play(state+"-front")
	$cone.play(state+"-front")
	$head.play(state+"-front")
	$eye.play(state+"-front")
	
func anim_dir() -> String:
	if car_direction == Vector2.DOWN:
		return "front"
	elif car_direction == Vector2.UP:
		return "back"
	elif car_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"
